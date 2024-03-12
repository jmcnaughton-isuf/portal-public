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
 * Case trigger handler, handles Honor Roll Name, Honor Roll Joint Preference, and Global OPT out
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */
global virtual without sharing class PORTAL_TRIG_CaseHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    private static final String APPROVED_STRING = 'Approved';
    private static final String ZONE_MEMBERSHIP_STRING = 'Zone Membership';
    private static final String ACTIVE_STRING = 'Active';
    private static final String DENIED_STRING = 'Denied';
    private static final String PENDING_STATUS = 'PENDING';
    private static final String ID_KEY = 'Id';

    private static final String JOB_POSTING = 'Job Posting';
    private static final String JOB_PENDING_STATUS = 'Pending';
    private static final String JOB_POSTED_STATUS = 'Posted';

    private static final String HONOR_ROLL_NAME = 'Honor Roll Name';
    private static final String HONOR_ROLL_JOINT_PREFERENCE = 'Honor Roll Joint Preference';

    /**
     *  Method occurs on every trigger run on Case Object
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param   newList                         List of the new up to date version of the Case records from the triggers
     * @param   oldList                         List of the old version of the Case records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the object in the trigger
     *
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            List<Case> newCaseList = (List<Case>) newList;
            List<Case> oldCaseList = (List<Case>) oldList;

            List<Case> approvedMembershipCases = new List<Case>();
            List<Case> deniedMembershipCases = new List<Case>();

            List<Case> approvedJobPostingCases = new List<Case>();

            List<Case> casesApprovedList = getCasesWithStatusChangedToApproved(newCaseList, oldCaseList);
            handleHonorRollModifications(casesApprovedList);

            for (Integer index = 0; index < newList.size(); index++) {
                Case oldCase = (Case) oldList.get(index);
                Case newCase = (Case) newList.get(index);

                if (newCase.Type == ZONE_MEMBERSHIP_STRING && newCase.Status == APPROVED_STRING && newCase.Status != oldCase.Status) {
                    approvedMembershipCases.add(newCase);
                }
                else if (newCase.Type == ZONE_MEMBERSHIP_STRING && newCase.Status == DENIED_STRING && newCase.Status != oldCase.Status) {
                    deniedMembershipCases.add(newCase);
                }
                else if (newCase.Type == JOB_POSTING && newCase.Status == APPROVED_STRING && newCase.Status != oldCase.Status) {
                    approvedJobPostingCases.add(newCase);
                }
            }

            updateMembershipCasses(approvedMembershipCases, ACTIVE_STRING);
            updateMembershipCasses(deniedMembershipCases, DENIED_STRING);

            updateJobPostingCases(approvedJobPostingCases);
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     * Gets cases with new status of Approved
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @param newCaseList   Case List with updated fields
     * @param oldCaseList   Case list before updated fields
     */
    private static List<Case> getCasesWithStatusChangedToApproved(List<Case> newCaseList, List<Case> oldCaseList) {
        List<Case> casesApprovedList = new List<Case>();

        if (newCaseList == null || newCaseList.isEmpty() || oldCaseList == null || oldCaseList.isEmpty()) {
            return casesApprovedList;
        }

        Map<Id, Case> oldCaseMap = new Map<Id, Case>();

        for (Case eachOldCase : oldCaseList) {
            oldCaseMap.put(eachOldCase.Id, eachOldCase);
        }

        for (Case eachNewCase : newCaseList) {
            if (String.isBlank(eachNewCase.Description)) {
                continue;
            }

            Case eachOldCase = oldCaseMap.get(eachNewCase.Id);

            if (eachNewCase.Status != eachOldCase.Status && eachNewCase.Status == APPROVED_STRING) {
                casesApprovedList.add(eachNewCase);
            }
        }

        return casesApprovedList;
    }

    /**
     * Handles changes to honor roll joint preference and honor roll name field modifications
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @param casesApprovedList   Case List that have status approved and contains descriptions
     */
    private static void handleHonorRollModifications(List<Case> casesApprovedList) {
        if (casesApprovedList == null || casesApprovedList.isEmpty()) {
            return;
        }

        List<Contact> contactHonorRollJointPreferenceToUpdateList = createContactHonorRollJointPreferenceToUpdateList(casesApprovedList);

        update contactHonorRollJointPreferenceToUpdateList;

        Map<Id, ucinn_portal_Honor_Roll_Name__c> contactIdToHonorRollNameMap = createContactIdToHonorRollNameMap(casesApprovedList);

        List<ucinn_portal_Honor_Roll_Name__c> honorRollNameToUpsertList = createHonorRollNameToUpsertList(casesApprovedList, contactIdToHonorRollNameMap);

        upsert honorRollNameToUpsertList;
    }

    /**
     * Create contact id to honor roll name mapping
     * Link one honor roll name record to Contact Id's (can be multiple Id mapped to 1 honor roll record)
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param casesApprovedList     Case List that have status approved and contains descriptions
     * @return                      Contact Id to Honor Roll name Record Map
     */
    private static Map<Id, ucinn_portal_Honor_Roll_Name__c> createContactIdToHonorRollNameMap(List<Case> casesApprovedList) {
        Map<Id, ucinn_portal_Honor_Roll_Name__c> contactIdToHonorRollNameMap = new Map<Id, ucinn_portal_Honor_Roll_Name__c>();

        if (casesApprovedList == null || casesApprovedList.isEmpty()) {
            return contactIdToHonorRollNameMap;
        }

        List<Id> contactIdList = new List<Id>();

        for (Case eachCase : casesApprovedList) {
            contactIdList.add(eachCase.ContactId);
        }

        if (contactIdList == null || contactIdList.isEmpty()) {
            return contactIdToHonorRollNameMap;
        }

        // this should only return 1 honor roll name record per contact id
        // different id's can share a single honor roll name record (if they are joint)
        List<ucinn_portal_Honor_Roll_Name__c> honorRollNameList = [SELECT Id, Contact__c, Joint_Contact__c, Starting_Fiscal_Year__c, Ending_Fiscal_Year__c
                                                                    FROM ucinn_portal_Honor_Roll_Name__c
                                                                    WHERE (Contact__c IN :contactIdList OR Joint_Contact__c IN :contactIdList)
                                                                    AND Ending_Fiscal_Year__c = null
                                                                    ORDER BY Starting_Fiscal_Year__c DESC NULLS LAST];

        if (honorRollNameList == null || honorRollNameList.isEmpty()) {
            return contactIdToHonorRollNameMap;
        }

        for (ucinn_portal_Honor_Roll_Name__c eachHonorRollNameRecord : honorRollNameList) {
            contactIdToHonorRollNameMap.put(eachHonorRollNameRecord.Contact__c, eachHonorRollNameRecord);

            if (String.isNotBlank(eachHonorRollNameRecord.Joint_Contact__c)) {
                contactIdToHonorRollNameMap.put(eachHonorRollNameRecord.Joint_Contact__c, eachHonorRollNameRecord);
            }
        }

        return contactIdToHonorRollNameMap;
    }

    /**
     * Parses case description to create a list of honor roll name records to update and to add
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param casesApprovedList             Case list that have status approved and contains text in description
     * @param contactIdToHonorRollNameMap   Map of Contact Id -> Honor Roll Name Record
     *
     * @return                              List of Honor Roll Name Records to add and update
     */
    private static List<ucinn_portal_Honor_Roll_Name__c> createHonorRollNameToUpsertList(List<Case> casesApprovedList, Map<Id, ucinn_portal_Honor_Roll_Name__c> contactIdToHonorRollNameMap) {
        List<ucinn_portal_Honor_Roll_Name__c> returnList = new List<ucinn_portal_Honor_Roll_Name__c>();

        if (casesApprovedList == null || casesApprovedList.isEmpty()) {
            return returnList;
        }

        String currentFiscalYear = PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.FiscalYearSettings?.Name;

        if (String.isBlank(currentFiscalYear)) {
            return returnList;
        }

        for (Case eachCase : casesApprovedList) {
            List<String> caseDescription = eachCase.Description.split('\n');

            for (String eachDescriptionLine : caseDescription) {
                if (!eachDescriptionLine.startsWith(HONOR_ROLL_NAME)) {
                    continue;
                }

                // Honor Roll Name: 'New Honor Roll Name'
                // parses for text inside single quotes
                String updatedHonorRollNameFieldString = eachDescriptionLine.substring(eachDescriptionLine.indexOf('\'') + 1, eachDescriptionLine.length() - 1);

                // if there is no honor roll name record for this contact, create a new honor roll name record
                if (contactIdToHonorRollNameMap == null || contactIdToHonorRollNameMap.isEmpty() || !contactIdToHonorRollNameMap.containsKey(eachCase.ContactId)) {
                    returnList.add(new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = updatedHonorRollNameFieldString,
                                                                       Starting_Fiscal_Year__c = currentFiscalYear,
                                                                       Contact__c = eachCase.ContactId
                                                                       ));
                    continue;
                }

                ucinn_portal_Honor_Roll_Name__c honorRollNameRecord = contactIdToHonorRollNameMap.get(eachCase.ContactId);

                // Honor Roll Name Record Fiscal Year Range: (2019) -- [null] =>
                // (2019) -- [current fiscal year - 1] &
                // (current fiscal year) -- [null]
                if (honorRollNameRecord.Starting_Fiscal_Year__c < currentFiscalYear && String.isBlank(honorRollNameRecord.Ending_Fiscal_Year__c)) {
                    // if honor roll name record starting fiscal year is in the past, create a new record and update the ending fiscal year of the current honor roll name record
                    returnList.add(new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = updatedHonorRollNameFieldString,
                                                                       Starting_Fiscal_Year__c = currentFiscalYear,
                                                                       Contact__c = honorRollNameRecord.Contact__c,
                                                                       Joint_Contact__c = honorRollNameRecord.Joint_Contact__c
                                                                       ));

                    honorRollNameRecord.Ending_Fiscal_Year__c = String.valueOf(Integer.valueOf(currentFiscalYear) - 1);
                    returnList.add(honorRollNameRecord);
                } else if (honorRollNameRecord.Starting_Fiscal_Year__c >= currentFiscalYear && String.isBlank(honorRollNameRecord.Ending_Fiscal_Year__c)){
                    // (current fiscal year) -- [null]
                    // update current honor roll name record with new honor roll name
                    returnList.add(new ucinn_portal_Honor_Roll_Name__c(Id = honorRollNameRecord.Id,
                                                                       Honor_Roll_Name__c = updatedHonorRollNameFieldString
                                                                       ));
                }
            }
        }

        return returnList;
    }

    /**
     * Parses case description to create a list of contacts with modified joint preference
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param casesApprovedList             Case list that have status approved and contains text in description
     *
     * @return                              List of Contacts with modified honor roll joint preference to update
     */
    private static List<Contact> createContactHonorRollJointPreferenceToUpdateList(List<Case> casesApprovedList) {
        List<Contact> contactHonorRollJointPreferenceToUpdateList = new List<Contact>();

        if (casesApprovedList == null || casesApprovedList.isEmpty()) {
            return contactHonorRollJointPreferenceToUpdateList;
        }

        for (Case eachCase : casesApprovedList) {
            List<String> caseDescription = eachCase.Description.split('\n');

            for (String eachDescriptionLine : caseDescription) {

                if (eachDescriptionLine.startsWith(HONOR_ROLL_JOINT_PREFERENCE)) {
                    contactHonorRollJointPreferenceToUpdateList.add(new Contact(Id = eachCase.ContactId,
                                                                                ucinn_portal_Honor_Roll_Joint_Preference__c = eachDescriptionLine.substring(eachDescriptionLine.indexOf('\'') + 1, eachDescriptionLine.length() - 1)));
                }
            }
        }

        return contactHonorRollJointPreferenceToUpdateList;
    }

    /**
     * On case update, update the related zone memberships
     *
     * @param   newCases                                list of new cases provided by the trigger
     * @param   newStatus                               The status to give the pending related zone memeberships
     */
    private static void updateMembershipCasses(List<Case> newCases, String newStatus) {
        if (newCases.isEmpty()) {
            return;
        }

        Set<Id> caseIds = new Set<Id>();

        for (Case currentCase : newCases) {
            caseIds.add((Id)currentCase.get(ID_KEY));
        }

        List<ucinn_portal_Zone_Membership__c> membershipsToUpdate = [SELECT Id, Is_On_Newsletter__c, Status__c FROM ucinn_portal_Zone_Membership__c WHERE Case__c IN :caseIds];

        for (ucinn_portal_Zone_Membership__c eachCurrentMembership : membershipsToUpdate) {
            if (eachCurrentMembership.Status__c == PENDING_STATUS) {
                eachCurrentMembership.Status__c = newStatus;
            }
        }

        update membershipsToUpdate;
    }

    /**
     * Updates Pending Jobs to Posted if they've had an associated Case that was set to Approved.
     *
     * @param   newCases                                List of new cases that is used to find Jobs that will be updated.
     */
    private static void updateJobPostingCases(List<Case> newCases) {
        if (newCases.isEmpty()) {
            return;
        }

        Set<Id> caseIds = new Set<Id>();

        for (Case currentCase : newCases) {
            caseIds.add((Id)currentCase.get(ID_KEY));
        }

        List<ucinn_portal_Job__c> jobsToUpdate = [SELECT Status__c FROM ucinn_portal_Job__c WHERE Case__c IN :caseIds];

        for (ucinn_portal_Job__c eachJob : jobsToUpdate) {
            if (eachJob.Status__c == JOB_PENDING_STATUS) {
                eachJob.Status__c = JOB_POSTED_STATUS;
            }
        }

        update jobsToUpdate;
    }
}