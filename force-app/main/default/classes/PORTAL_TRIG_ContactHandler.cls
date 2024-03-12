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
 * Contact trigger handler, handles Honor Roll Joint Preference Changes
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */

global virtual without sharing class PORTAL_TRIG_ContactHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    private static final String ID_KEY = 'Id';
    private static final String HONOR_ROLL_JOINT_PREFERENCE = 'honorRollJointPreference';
    private static final String DEGREE_INFORMATION = 'degreeInformation';
    private static final String HONOR_ROLL_NAME_LIST = 'honorRollNameList';
    private static final String ACTIVE_KEY = 'Active';
    private static final String LIFETIME_KEY = 'Lifetime';

    private static final String UNSYNCED_CONTACT_LIST = 'unsyncedContactList';
    private static final String SYNCED_CONTACT_LIST = 'syncedContactList';
    private static final String HONOR_ROLL_NAMES_TO_UPSERT_LIST = 'honorRollsToUpsertList';
    private static final String HONOR_ROLL_NAMES_TO_DELETE_LIST = 'honorRollsToDeleteList';

    /**
     *  Method occurs on every trigger run on Contact Object
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param   newList                         List of the new up to date version of the Contact records from the triggers
     * @param   oldList                         List of the old version of the Contact records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the object in the trigger
     *
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        List<Contact> newContactList = (List<Contact>) newList;
        List<Contact> oldContactList = (List<Contact>) oldList;

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            handleHonorRollJointPreferenceChange(newContactList, oldContactList);
            handleGlobalOptOutHonorRoll(newContactList, oldContactList);
            handleGlobalOptOutMembershipRenewalSolicitaion(newContactList, oldContactList);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete) {
            deleteExternalEmailApiContact(oldContactList);
        }



        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     * Deletes contacts in external email api for a campaign service
     *
     * @param triggerOld            the list of records to delete
     *
     * @author Sam Longo
     */
    global void deleteExternalEmailApiContact(List<Contact> triggerOld) {
        if (triggerOld == null || triggerOld.isEmpty()) {
            return;
        }

        Set<String> externalContactIdsToDelete = new Set<String>();
        for (Contact eachContact : triggerOld) {
            if (String.isNotBlank(eachContact.ucinn_portal_External_Email_API_Id__c)) {
                externalContactIdsToDelete.add(eachContact.ucinn_portal_External_Email_API_Id__c);
            }
        }
        if (!externalContactIdsToDelete.isEmpty()) {
            PORTAL_API_EmailHubBase.removeContactsFromExternalApi(externalContactIdsToDelete);
        }
    }

    /**
     * Finds which contacts had joint preference changed and sync that information with their spouse
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param newContactList    Contact List after update
     * @param oldContactList    Contact List before update
     */
    private static void handleHonorRollJointPreferenceChange(List<Contact> newContactList, List<Contact> oldContactList) {
        if (newContactList == null || newContactList.isEmpty() || oldContactList == null || oldContactList.isEmpty()) {
            return;
        }

        List<Contact> contactsWithJointPreferenceChangedList = getContactswithJointPreferenceChanged(newContactList, oldContactList);

        if (contactsWithJointPreferenceChangedList == null || contactsWithJointPreferenceChangedList.isEmpty()) {
            return;
        }

        Set<Id> spouseIdSet = PORTAL_UTIL_HonorRoll.getSpouseIdSet(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => contactsWithJointPreferenceChangedList});

        if (spouseIdSet == null || spouseIdSet.isEmpty()) {
            return;
        }

        List<Contact> spouseInfoList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => spouseIdSet});

        if (spouseInfoList == null || spouseInfoList.isEmpty()) {
            return;
        }

        Map<Id,Contact> spouseIdToSpouseContactInfoMap = PORTAL_UTIL_HonorRoll.createContactIdToContactMap(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => spouseInfoList});

        Map<String, Object> contactListMap = getUnsyncedAndSyncedContactRecordMap(contactsWithJointPreferenceChangedList, spouseIdToSpouseContactInfoMap);

        List<Contact> syncedContactList = (List<Contact>) contactListMap?.get(SYNCED_CONTACT_LIST);
        List<Contact> spouseContactsToSync = (List<Contact>) contactListMap?.get(UNSYNCED_CONTACT_LIST);

        // when it is not null or empty, we want to update the spouse joint preference, and recursively fire this trigger to handle the rest of joint preference logic
        if (spouseContactsToSync != null && !spouseContactsToSync.isEmpty()) {
            update spouseContactsToSync;
            //return;
        }

        if (syncedContactList == null || syncedContactList.isEmpty()) {
            return;
        }

        handleHonorRollNameRecordChanges(syncedContactList, spouseIdToSpouseContactInfoMap);
    }

    /**
     * Find which contacts had their joint preference modified
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param newContactList    Contact list after update
     * @param oldContactList    Contact list before update
     *
     * @return                  list of contacts where joint preference was modified
     */
    @TestVisible
    private static List<Contact> getContactswithJointPreferenceChanged(List<Contact> newContactList, List<Contact> oldContactList) {
        List<Contact> contactsWithJointPreferenceChanged = new List<Contact>();

        if (newContactList == null || newContactList.isEmpty() || oldContactList == null || oldContactList.isEmpty()) {
            return contactsWithJointPreferenceChanged;
        }

        Map<Id, Contact> oldContactMap = new Map<Id, Contact>();

        for (Contact eachOldContact : oldContactList) {
            oldContactMap.put(eachOldContact.Id, eachOldContact);
        }

        for (Contact eachNewContact : newContactList) {
            if (String.isBlank(eachNewContact.ucinn_ascendv2__Preferred_Spouse__c)) {
                continue;
            }

            Contact eachOldContact = oldContactMap.get(eachNewContact.Id);

            if (eachNewContact.ucinn_portal_Honor_Roll_Joint_Preference__c != eachOldContact.ucinn_portal_Honor_Roll_Joint_Preference__c) {
                contactsWithJointPreferenceChanged.add(eachNewContact);
            }
        }

        return contactsWithJointPreferenceChanged;
    }

    /**
     * Sync spouse's honor roll joint preference if out of sync
     *
     * @author                              Phillip Nguyen
     * @since                                   1.0
     *
     * @param contactList                     Contact list that has modified honor roll joint preference
     * @param spouseIdToSpouseInfoMap         Spouse Id to Spouse Info Map
     *
    * @return                                 ContactListToUpdate Object containing a list of contacts with unsynced joint preferences, and a list of contacts with synced joint preferences
     */
    @TestVisible
    private static Map<String, Object> getUnsyncedAndSyncedContactRecordMap(List<Contact> contactList, Map<Id,Contact> spouseIdToSpouseInfoMap) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (contactList == null || contactList.isEmpty() || spouseIdToSpouseInfoMap == null || spouseIdToSpouseInfoMap.isEmpty()) {
            return returnMap;
        }

        List<Contact> unsyncedSpouseList = new List<Contact>();
        List<Contact> syncedContactList = new List<Contact>();

        for (Contact eachContact : contactList) {
            if (!spouseIdToSpouseInfoMap.containsKey(eachContact.ucinn_ascendv2__Preferred_Spouse__c)) {
                continue;
            }

            if (eachContact.ucinn_portal_Honor_Roll_Joint_Preference__c != spouseIdToSpouseInfoMap.get(eachContact.ucinn_ascendv2__Preferred_Spouse__c).ucinn_portal_Honor_Roll_Joint_Preference__c) {
                Contact syncedSpouseRecord = new Contact(Id = eachContact.ucinn_ascendv2__Preferred_Spouse__c, ucinn_portal_Honor_Roll_Joint_Preference__c = eachContact.ucinn_portal_Honor_Roll_Joint_Preference__c);
                unsyncedSpouseList.add(syncedSpouseRecord);
            } else {
                syncedContactList.add(eachContact);
            }
        }

        returnMap.put(UNSYNCED_CONTACT_LIST, unsyncedSpouseList);
        returnMap.put(SYNCED_CONTACT_LIST, syncedContactList);

        return returnMap;
    }

    /**
     * Gets information for contact that had their joint preference changed, and obtains those contacts' spouse information as well,
     * so we can update their appropriate honor roll name records
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param contactList                           List of contacts with honor roll joint preference changed
     * @param spouseIdToSpouseInformationMap        Map of Spouse Id to Spouse Information
     */
    @TestVisible
    private static void handleHonorRollNameRecordChanges(List<Contact> contactList, Map<Id,Contact> spouseIdToSpouseInformationMap) {

        if (contactList == null || contactList.isEmpty() || spouseIdToSpouseInformationMap == null || spouseIdToSpouseInformationMap.isEmpty()) {
            return;
        }

        Set<Id> contactIdSet = new Set<Id>();

        for (Contact eachContact : contactList) {
            contactIdSet.add(eachContact.Id);
        }

        List<Contact> contactInformationList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => contactIdSet});

        if (contactInformationList == null || contactInformationList.isEmpty()) {
            return;
        }

        updateHonorRollNameRecords(contactInformationList, spouseIdToSpouseInformationMap);
    }

    /**
     * Update/Generate/Delete Honor Roll Name Records depending on Joint Preference Change
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @param contactInformationList            List of contact information that where Honor Roll Joint Preference was changed
     * @param spouseIdToSpouseInformationMap    Map of Spouse Id to Spouse Information
     *
     */
    @TestVisible
    private static void updateHonorRollNameRecords(List<Contact> contactInformationList, Map<Id,Contact> spouseIdToSpouseInformationMap) {
        if (contactInformationList == null || contactInformationList.isEmpty()
            || spouseIdToSpouseInformationMap == null || spouseIdToSpouseInformationMap.isEmpty()) {
                return;
        }

        String currentFiscalYear = PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.FiscalYearSettings?.Name;

        if (String.isBlank(currentFiscalYear)) {
            return;
        }

        List<ucinn_portal_Honor_Roll_Name__c> honorRollsToUpsertList = new List<ucinn_portal_Honor_Roll_Name__c>();
        List<ucinn_portal_Honor_Roll_Name__c> honorRollsToDeleteList = new List<ucinn_portal_Honor_Roll_Name__c>();

        for (Contact eachContact : contactInformationList) {
            ucinn_portal_Honor_Roll_Name__c mostRecentHonorRollNameRecord;
            ucinn_portal_Honor_Roll_Name__c spouseMostRecentHonorRollNameRecord;

            if (!spouseIdToSpouseInformationMap.containsKey(eachContact.ucinn_ascendv2__Preferred_Spouse__c)) {
                continue;
            }

            Contact spouseInformationForContact = (Contact)spouseIdToSpouseInformationMap.get(eachContact.ucinn_ascendv2__Preferred_Spouse__c);

            // this is guaranteed to be the most recent honor roll name record from the query
            if (eachContact.ucinn_portal_Honor_Roll_Names_Contact__r != null && !eachContact.ucinn_portal_Honor_Roll_Names_Contact__r.isEmpty()) {
                mostRecentHonorRollNameRecord = eachContact.ucinn_portal_Honor_Roll_Names_Contact__r.get(0);
            }

            // this is guaranteed to be the most recent honor roll name record from the query
            if (spouseInformationForContact.ucinn_portal_Honor_Roll_Names_Contact__r != null && !spouseInformationForContact.ucinn_portal_Honor_Roll_Names_Contact__r.isEmpty()) {
                spouseMostRecentHonorRollNameRecord = spouseInformationForContact.ucinn_portal_Honor_Roll_Names_Contact__r.get(0);
            }

            if (mostRecentHonorRollNameRecord == null && spouseMostRecentHonorRollNameRecord == null) {
                continue;
            }

            Map<String,Object> honorRollNamesToUpsertAndDeleteMap = getHonorRollNamesToUpsertAndDelete(eachContact, spouseInformationForContact, currentFiscalYear, mostRecentHonorRollNameRecord, spouseMostRecentHonorRollNameRecord);

            if (honorRollNamesToUpsertAndDeleteMap == null || honorRollNamesToUpsertAndDeleteMap.isEmpty()) {
                continue;
            }

            honorRollsToUpsertList.addAll((List<ucinn_portal_Honor_Roll_Name__c>) honorRollNamesToUpsertAndDeleteMap.get(HONOR_ROLL_NAMES_TO_UPSERT_LIST));
            honorRollsToDeleteList.addAll((List<ucinn_portal_Honor_Roll_Name__c>) honorRollNamesToUpsertAndDeleteMap.get(HONOR_ROLL_NAMES_TO_DELETE_LIST));
        }

        upsert honorRollsToUpsertList;
        delete honorRollsToDeleteList;
    }

    /**
     * Gets list of honor roll name records to upsert and delete
     * Handles logic with creating default honor roll names when switching to joint/individual preference
     *
     * @author                                      Phillip Nguyen
     * @since                                       1.0
     *
     * @param contactRecord                         Contact record in which honor roll joint preference has been updated
     * @param spouseContactRecord                   Prefered spouse contact record connected to Contact Record
     * @param currentFiscalYear                     Current Fiscal Year determined by org setup
     * @param mostRecentHonorRollNameRecord         Most recent honor roll name record connected to Contact Record
     * @param spouseMostRecentHonorRollNameRecord   Most recent honor roll name record connected to Spouse Contact Record
     */
    private static Map<String,Object> getHonorRollNamesToUpsertAndDelete(Contact contactRecord, Contact spouseContactRecord, String currentFiscalYear,
                                                                         ucinn_portal_Honor_Roll_Name__c mostRecentHonorRollNameRecord, ucinn_portal_Honor_Roll_Name__c spouseMostRecentHonorRollNameRecord) {
        Map<String,Object> returnMap = new Map<String, Object>();

        // both honor roll name records cannot be null, only one of them can be null
        if (contactRecord == null || spouseContactRecord == null || String.isBlank(currentFiscalYear)
                || (mostRecentHonorRollNameRecord == null && spouseMostRecentHonorRollNameRecord == null)) {
            return returnMap;
        }

        String honorRollNameForContact = PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_RECORD => contactRecord});
        String honorRollNameForSpouse = PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_RECORD => spouseContactRecord});
        String honorRollNameJoint = PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => honorRollNameForContact,
                                                                                                           PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => honorRollNameForSpouse});

        List<ucinn_portal_Honor_Roll_Name__c> honorRollsToUpsertList = new List<ucinn_portal_Honor_Roll_Name__c>();
        List<ucinn_portal_Honor_Roll_Name__c> honorRollsToDeleteList = new List<ucinn_portal_Honor_Roll_Name__c>();

        if (contactRecord.ucinn_portal_Honor_Roll_Joint_Preference__c == PORTAL_CONST_HonorRoll.CONTACT_HONOR_ROLL_JOINT_PREFERENCE_JOINT) {
            // take contact's honor roll name record and update it with joint information (will create new record if record being updated is not in current fiscal year)
            // delete spouse's honor roll name record if it exists, so contact & spouse only have one honor roll name record if they are joint

            if (mostRecentHonorRollNameRecord != null) {
                addHonorRollNameToDmlList(mostRecentHonorRollNameRecord, currentFiscalYear, honorRollsToUpsertList, honorRollsToDeleteList);
            }

            if (spouseMostRecentHonorRollNameRecord != null) {
                addHonorRollNameToDmlList(spouseMostRecentHonorRollNameRecord, currentFiscalYear, honorRollsToUpsertList, honorRollsToDeleteList);
            }

            honorRollsToUpsertList.add(new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = honorRollNameJoint, Contact__c = contactRecord.Id, Joint_Contact__c = spouseContactRecord.Id, Starting_Fiscal_Year__c = currentFiscalYear));

        } else if (contactRecord.ucinn_portal_Honor_Roll_Joint_Preference__c == PORTAL_CONST_HonorRoll.CONTACT_HONOR_ROLL_JOINT_PREFERENCE_INDIVIDUAL) {
            // Delete joint honor roll name record and create two new honor roll name records for contact & spouse

            if (mostRecentHonorRollNameRecord != null && String.isNotBlank(mostRecentHonorRollNameRecord.Contact__c) && String.isNotBlank(mostRecentHonorRollNameRecord.Joint_Contact__c)) {
                addHonorRollNameToDmlList(mostRecentHonorRollNameRecord, currentFiscalYear, honorRollsToUpsertList, honorRollsToDeleteList);

            } else if (spouseMostRecentHonorRollNameRecord != null && String.isNotBlank(spouseMostRecentHonorRollNameRecord.Contact__c) && String.isNotBlank(spouseMostRecentHonorRollNameRecord.Joint_Contact__c)) {
                addHonorRollNameToDmlList(spouseMostRecentHonorRollNameRecord, currentFiscalYear, honorRollsToUpsertList, honorRollsToDeleteList);
            }

            // create two default honor roll names
            honorRollsToUpsertList.add(new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = honorRollNameForContact, Contact__c = contactRecord.Id, Starting_Fiscal_Year__c = currentFiscalYear));
            honorRollsToUpsertList.add(new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = honorRollNameForSpouse, Contact__c = spouseContactRecord.Id, Starting_Fiscal_Year__c = currentFiscalYear));
        }

        returnMap.put(HONOR_ROLL_NAMES_TO_UPSERT_LIST, honorRollsToUpsertList);
        returnMap.put(HONOR_ROLL_NAMES_TO_DELETE_LIST, honorRollsToDeleteList);

        return returnMap;
    }

    /**
     * Adds honor roll name record to upsert list if it's starting fiscal year is in the past, otherwise, add record to deletion list
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param honorRollNameRecord       Honor roll name record to either update or delete
     * @param currentFiscalYear         Current Fiscal Year determined by the Org
     * @param honorRollsToUpsertList    Honor rolls to upsert (will be modified and changes reflected in parent)
     * @param honorRollsToDeleteList    Honor Rolls to delete (will be modified and changes reflected in parent)
     */
    private static void addHonorRollNameToDmlList(ucinn_portal_Honor_Roll_Name__c honorRollNameRecord, String currentFiscalYear, List<ucinn_portal_Honor_Roll_Name__c> honorRollsToUpsertList, List<ucinn_portal_Honor_Roll_Name__c> honorRollsToDeleteList) {
        if (honorRollNameRecord == null || String.isBlank(currentFiscalYear) || honorRollsToUpsertList == null || honorRollsToDeleteList == null) {
            return;
        }

        // if record's fiscal year is less than current fiscal year, update ending fiscal year on this record
        if (honorRollNameRecord.Starting_Fiscal_Year__c < currentFiscalYear) {
            honorRollsToUpsertList.add(new ucinn_portal_Honor_Roll_Name__c(Id = honorRollNameRecord.Id, Ending_Fiscal_Year__c = String.valueOf(Integer.valueOf(currentFiscalYear) - 1)));
        } else {
            // if record is current fiscal year, then delete
            honorRollsToDeleteList.add(honorRollNameRecord);
        }
    }

    /**
     * Handle global opt out of honor roll, also updates spouse's opt out if joint
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @param newContactList        Contact list containing updated fields
     * @param oldContactList        Contact list before updated fields
     */
    private static void handleGlobalOptOutHonorRoll(List<Contact> newContactList, List<Contact> oldContactList) {
        if (newContactList == null || newContactList.isEmpty() || oldContactList == null || oldContactList.isEmpty()) {
            return;
        }

        Map<Id, Boolean> contactIdToHonorRollOptOutPreferenceMap = new Map<Id, Boolean>();
        Map<Id, Contact> oldContactMap = new Map<Id, Contact>();

        for (Contact eachOldContact : oldContactList) {
            oldContactMap.put(eachOldContact.Id, eachOldContact);
        }

        // Find which contacts have had their Honor Roll Opt Out Changed
        for (Contact eachNewContact : newContactList) {
            Contact eachOldContact = oldContactMap.get(eachNewContact.Id);

            if (eachNewContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c != eachOldContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c) {
                contactIdToHonorRollOptOutPreferenceMap.put(eachNewContact.Id, eachNewContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c);
            }
        }

        if (contactIdToHonorRollOptOutPreferenceMap == null || contactIdToHonorRollOptOutPreferenceMap.isEmpty()) {
            return;
        }

        List<Contact> newContactInformationList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET =>
                                                                                                                        contactIdToHonorRollOptOutPreferenceMap.keySet()});

        List<Contact> spouseToUpdateList = new List<Contact>();

        for (Contact eachContact : newContactInformationList) {
            if (eachContact.ucinn_portal_Honor_Roll_Joint_Preference__c == PORTAL_CONST_HonorRoll.CONTACT_HONOR_ROLL_JOINT_PREFERENCE_JOINT
                && String.isNotBlank(eachContact.ucinn_ascendv2__Preferred_Spouse__c)
                && eachContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c != eachContact.ucinn_ascendv2__Preferred_Spouse__r.ucinn_portal_Is_Honor_Roll_Opt_Out__c) {

                spouseToUpdateList.add(new Contact(Id = eachContact.ucinn_ascendv2__Preferred_Spouse__c, ucinn_portal_Is_Honor_Roll_Opt_Out__c = eachContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c));
            }
        }

        //keySet will return a set of Ids
        List<ucinn_ascendv2__Society_Membership__c> societyMembershipList = PORTAL_UTIL_HonorRoll.queryForSocietyMembershipsWithAllFields(new Map<String, Object>{
                                                                                                    PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => contactIdToHonorRollOptOutPreferenceMap.keySet()});

        if (societyMembershipList == null || societyMembershipList.isEmpty()) {
            return;
        }

        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToUpsertList = getSocietyMembershipsToUpsert(societyMembershipList, contactIdToHonorRollOptOutPreferenceMap);

        upsert societyMembershipsToUpsertList;
        update spouseToUpdateList;
    }

    /**
     * Gets society memberships to upsert
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param societyMembershipList                     List of society memeberships
     * @param contactIdToHonorRollOptOutPreferenceMap   Mapping of contact id to joint preference (boolean value)
     *
     * @return                                          List of society memberships to upsert
     */
    @TestVisible
    private static List<ucinn_ascendv2__Society_Membership__c> getSocietyMembershipsToUpsert(List<ucinn_ascendv2__Society_Membership__c> societyMembershipList, Map<Id, Boolean> contactIdToHonorRollOptOutPreferenceMap) {
        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToUpsertList = new List<ucinn_ascendv2__Society_Membership__c>();

        if (societyMembershipList == null || societyMembershipList.isEmpty() || contactIdToHonorRollOptOutPreferenceMap == null || contactIdToHonorRollOptOutPreferenceMap.isEmpty()) {
            return societyMembershipsToUpsertList;
        }

        Date currentFiscalYearStartDate = PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.StartDate;

        // Set expiration date of society membership and create new record (Similar to Honor Roll Name Logic with the starting fiscal year)
        // LifeTime -> 2017 - [] =>
        // LifeTime -> 2017 - Previous Fiscal Year, => LifeTime2 -> 2021 - []
        for (ucinn_ascendv2__Society_Membership__c eachSocietyMembershipRecord : societyMembershipList) {

            if (!contactIdToHonorRollOptOutPreferenceMap.containsKey(eachSocietyMembershipRecord.ucinn_ascendv2__Contact__c)) {
                continue;
            }

            Boolean honorRollOptOutValue = (contactIdToHonorRollOptOutPreferenceMap.get(eachSocietyMembershipRecord.ucinn_ascendv2__Contact__c) != true);

            // this means this society membership does not need to be updated
            if (eachSocietyMembershipRecord.ucinn_portal_Is_Show_on_Honor_Roll__c == honorRollOptOutValue) {
                continue;
            }

            List<ucinn_ascendv2__Society_Membership__c> parsedSocietyMembershipsToUpsertList = PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(new Map<String, Object>{
                                                                                                                        PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_RECORD => eachSocietyMembershipRecord,
                                                                                                                        PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => honorRollOptOutValue,
                                                                                                                        PORTAL_UTIL_HonorRoll.CURRENT_FISCAL_YEAR_START_DATE => currentFiscalYearStartDate
                                                                                                                        });

            if (parsedSocietyMembershipsToUpsertList == null || parsedSocietyMembershipsToUpsertList.isEmpty()) {
                continue;
            }

            societyMembershipsToUpsertList.addAll(parsedSocietyMembershipsToUpsertList);
        }

        return societyMembershipsToUpsertList;
    }

    /**
     * Handle global opt out of membership renewal solicitaions
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param newContactList        Contact list containing updated fields
     * @param oldContactList        Contact list before updated fields
     */
    private static void handleGlobalOptOutMembershipRenewalSolicitaion(List<Contact> newContactList, List<Contact> oldContactList) {
        if (newContactList == null || newContactList.isEmpty() || oldContactList == null || oldContactList.isEmpty()) {
            return;
        }

        Map<Id, Boolean> contactIdToRenewalSolicitOptOutMap = new Map<Id, Boolean>();
        Map<Id, Contact> oldContactMap = new Map<Id, Contact>();

        for (Contact eachOldContact : oldContactList) {
            oldContactMap.put(eachOldContact.Id, eachOldContact);
        }

        // Find which contacts have had their Membership Renewal Solicitation Opt Out Changed
        for (Contact eachNewContact : newContactList) {
            Contact eachOldContact = oldContactMap.get(eachNewContact.Id);

            if (eachNewContact.ucinn_portal_Is_Renewal_Solicit_Opt_Out__c != eachOldContact.ucinn_portal_Is_Renewal_Solicit_Opt_Out__c) {
                contactIdToRenewalSolicitOptOutMap.put(eachNewContact.Id, eachNewContact.ucinn_portal_Is_Renewal_Solicit_Opt_Out__c);
            }
        }

        if (contactIdToRenewalSolicitOptOutMap == null || contactIdToRenewalSolicitOptOutMap.isEmpty()) {
            return;
        }

        // get all non-lifetime society memberships for each contact (can be inactive too)
        List<ucinn_ascendv2__Society_Membership__c> nonLifetimeSocietyMembershipList = [SELECT Id, ucinn_ascendv2__Contact__c, ucinn_portal_Is_Renewal_Solicit_Opt_Out__c
                                                                                        FROM ucinn_ascendv2__Society_Membership__c
                                                                                        WHERE ucinn_ascendv2__Contact__c IN :contactIdToRenewalSolicitOptOutMap.keySet()
                                                                                        AND ucinn_ascendv2__Giving_Society__r.ucinn_portal_Type__c != :LIFETIME_KEY];

        if (nonLifetimeSocietyMembershipList == null || nonLifetimeSocietyMembershipList.isEmpty()) {
            return;
        }

        // go through memberships and update them to new value
        List<ucinn_ascendv2__Society_Membership__c> membershipsToUpdateList = new List<ucinn_ascendv2__Society_Membership__c>();

        for (ucinn_ascendv2__Society_Membership__c eachMembership : nonLifetimeSocietyMembershipList) {
            if (!contactIdToRenewalSolicitOptOutMap.containsKey(eachMembership.ucinn_ascendv2__Contact__c)) {
                continue;
            }

            membershipsToUpdateList.add(new ucinn_ascendv2__Society_Membership__c(Id = eachMembership.Id,
                                                                                  ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = contactIdToRenewalSolicitOptOutMap.get(eachMembership.ucinn_ascendv2__Contact__c)));
        }

        update membershipsToUpdateList;
    }
}