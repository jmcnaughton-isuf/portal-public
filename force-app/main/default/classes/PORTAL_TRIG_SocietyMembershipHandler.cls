/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
 *
 * This source code is licensed, not sold, and is subject to a written
 * license agreement.  Among other things, no portion of this source
 * code may be copied, transmitted, disclosed, displayed, distributed,
 * translated, used as the basis for a derivative work, or used, in
 * whole or in part, for any program or purpose other than its intended
 * use in compliance with the license agreement as part of UC Innovation's
 * software.  This source code and certain of the algorithms contained
 * within it are confidential trade secrets of UC Innovation, Inc.
 * and may not be used as the basis for any other
 * software, hardware, product or service.
 */

/**
 * Society Membership trigger handler, inserts honor roll name if there is none
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */
global virtual without sharing class PORTAL_TRIG_SocietyMembershipHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    private static final String CONTACT_ID_LIST = 'contactIdList';
    private static final String SPOUSE_ID_LIST = 'spouseIdList';

    /**
     *  Method occurs on every trigger run on Society Membership Object
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param   newList                         List of the new up to date version of the Society Membership records from the triggers
     * @param   oldList                         List of the old version of the Society Membership records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the object in the trigger
     *
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            List<ucinn_ascendv2__Society_Membership__c> newSocietyMembershipList = (List<ucinn_ascendv2__Society_Membership__c>) newList;

            handleHonorRollNameInsert(newSocietyMembershipList);
        }

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert){
            List<ucinn_ascendv2__Society_Membership__c> newSocietyMembershipList = (List<ucinn_ascendv2__Society_Membership__c>) newList;

            handleRenewalSolicitOptOut(newSocietyMembershipList);
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }


    /**
     * Sets "Is Renewal Solicit Opt Out" checkbox to match the contact's on the 
     * newly created Society Memberships.
     */
    private static void handleRenewalSolicitOptOut(List<ucinn_ascendv2__Society_Membership__c> newList){
        if (newList == null || newList.isEmpty()) {
            return;
        }
        
        Set<Id> membershipContactIds = getContactIds(newList);
        List<Contact> contactInfo = [SELECT Id, ucinn_portal_Is_Renewal_Solicit_Opt_Out__c
                                     FROM Contact
                                     WHERE Id IN :membershipContactIds];

        Map<Id, Contact> idToContactMap = PORTAL_UTIL_HonorRoll.createContactIdToContactMap(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => contactInfo});
        
        for (ucinn_ascendv2__Society_Membership__c membership : newList){
            if (String.isBlank(membership.ucinn_ascendv2__Contact__c)){
                continue;
            }
            membership.ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = idToContactMap.get(membership.ucinn_ascendv2__Contact__c).ucinn_portal_Is_Renewal_Solicit_Opt_Out__c;
        }
    }
    /**
     * Inserts honor roll if contact connected to society membership does not contain one already
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param newList   List of Society Membership records from trigger
     */
    private static void handleHonorRollNameInsert(List<ucinn_ascendv2__Society_Membership__c> newList) {
        if (newList == null || newList.isEmpty()) {
            return;
        }

        Set<Id> contactIdSet = getContactIds(newList);

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return;
        }

        List<Contact> contactInformationList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => contactIdSet});

        if (contactInformationList == null || contactInformationList.isEmpty()) {
            return;
        }

        Set<Id> spouseIdSet = PORTAL_UTIL_HonorRoll.getSpouseIdSet(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => contactInformationList});

        List<Contact> spouseInformationList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => spouseIdSet});

        Map<Id, Contact> spouseIdToSpouseContactMap = PORTAL_UTIL_HonorRoll.createContactIdToContactMap(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => spouseInformationList});

        List<ucinn_portal_Honor_Roll_Name__c> honorRollNameToInsertList = createHonorRollNamesToInsertList(contactInformationList, spouseIdToSpouseContactMap);

        insert honorRollNameToInsertList;
    }

    /**
     * Get Contact Ids from Society Membership list that are Displaying On Portal
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param newList   List of Society Memberships that have been inserted
     * @return          return set of contact id(s)
     */
    private static Set<Id> getContactIds(List<ucinn_ascendv2__Society_Membership__c> newList) {
        Set<Id> contactIdSet = new Set<Id>();

        if (newList == null || newList.isEmpty()) {
            return contactIdSet;
        }

        for (ucinn_ascendv2__Society_Membership__c eachSocietyMembership : newList) {
            if (String.isBlank(eachSocietyMembership.ucinn_ascendv2__Contact__c) || eachSocietyMembership.ucinn_portal_Is_Display_On_Portal__c != true) {
                continue;
            }

            contactIdSet.add(eachSocietyMembership.ucinn_ascendv2__Contact__c);
        }

        return contactIdSet;
    }

    /**
     * Create Honor Roll Names if Contact does not have one
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param contactList                   List of contacts that had society memberships created
     * @param spouseIdToSpouseContactMap    Spouse Id to Spouse Contact Mapping which is used to create Honor Roll Name
     *
     * @return                              List of Honor Roll Names to insert
     */
    @TestVisible
    private static List<ucinn_portal_Honor_Roll_Name__c> createHonorRollNamesToInsertList(List<Contact> contactList, Map<Id, Contact> spouseIdToSpouseContactMap) {
        List<ucinn_portal_Honor_Roll_Name__c> honorRollNameToInsertList = new List<ucinn_portal_Honor_Roll_Name__c>();

        if (contactList == null || contactList.isEmpty() || spouseIdToSpouseContactMap == null || spouseIdToSpouseContactMap.isEmpty()) {
            return honorRollNameToInsertList;
        }

        String currentFiscalYear = PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.FiscalYearSettings?.Name;

        if (String.isBlank(currentFiscalYear)) {
            return honorRollNameToInsertList;
        }

        for (Contact eachContact : contactList) {
            if (eachContact.ucinn_portal_Honor_Roll_Names_Contact__r != null && !eachContact.ucinn_portal_Honor_Roll_Names_Contact__r.isEmpty()) {
                continue;
            }

            Contact eachSpouseRecord;
            Id jointContactId;

            if (String.isNotBlank(eachContact.ucinn_ascendv2__Preferred_Spouse__c) && spouseIdToSpouseContactMap.containsKey(eachContact.ucinn_ascendv2__Preferred_Spouse__c)) {
                eachSpouseRecord = spouseIdToSpouseContactMap.get(eachContact.ucinn_ascendv2__Preferred_Spouse__c);
            }

            String honorRollNameForContact = PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_RECORD => eachContact});
            String honorRollNameForSpouse = PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_RECORD => eachSpouseRecord});
            String honorRollNameJoint = PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => honorRollNameForContact,
                                                                                                                PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => honorRollNameForSpouse});

            String honorRollNameFieldString = '';

            if (eachContact.ucinn_portal_Honor_Roll_Joint_Preference__c == PORTAL_CONST_HonorRoll.CONTACT_HONOR_ROLL_JOINT_PREFERENCE_JOINT) {
                honorRollNameFieldString = honorRollNameJoint;
                jointContactId = eachContact.ucinn_ascendv2__Preferred_Spouse__c;

            } else if (eachContact.ucinn_portal_Honor_Roll_Joint_Preference__c == PORTAL_CONST_HonorRoll.CONTACT_HONOR_ROLL_JOINT_PREFERENCE_INDIVIDUAL) {
                honorRollNameFieldString = honorRollNameForContact;
            }

            honorRollNameToInsertList.add(new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = honorRollNameFieldString,
                                                                              Contact__c = eachContact.Id,
                                                                              Joint_Contact__c = jointContactId,
                                                                              Starting_Fiscal_Year__c = currentFiscalYear));

        }

        return honorRollNameToInsertList;
    }
}