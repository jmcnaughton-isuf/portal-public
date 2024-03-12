/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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
 *
 * @author      UC Innovation
 * @version     1.10
 * @since       1.10
 */
global without sharing virtual class PORTAL_TRIG_DegreeInfoHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    public static final String DUMMY_DEGREE_INSTITUTION_NAME = 'Dummy Degree Institution Organization *DO NOT DELETE*';
    /**
     *  Method occurs on every trigger run.
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @param   oldList                         List of the old version of the records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the obect in the trigger
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     * @since                                   1.10
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        List<ucinn_ascendv2__Degree_Information__c> triggerNew = (List<ucinn_ascendv2__Degree_Information__c>)newList;
        List<ucinn_ascendv2__Degree_Information__c> triggerOld = (List<ucinn_ascendv2__Degree_Information__c>)oldList;
        Map<Id, ucinn_ascendv2__Degree_Information__c> triggerOldMap = new Map<Id, ucinn_ascendv2__Degree_Information__c>();

        if (triggerOld != null) {
            triggerOldMap = new Map<Id, ucinn_ascendv2__Degree_Information__c>(triggerOld);
        }

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            populateDegreeInstitutionLookup(triggerNew, triggerOldMap);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            populateDegreeInstitutionLookup(triggerNew, triggerOldMap);
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     *  Populate Degree Institution look up field based on Degree Institution text field. This is primarily used for portal.
     *                  
     * @author  UC Innovation
     * @since   1.10
     */
    protected virtual void populateDegreeInstitutionLookup(List<ucinn_ascendv2__Degree_Information__c> newList, Map<Id, ucinn_ascendv2__Degree_Information__c> triggerOldMap) {
        Set<String> degreeInstitutionsToQuery = getDegreeInstitutionsToQuery(newList, triggerOldMap);

        // If Degree Institution text was not updated on any of the records, skip the rest of the logic.
        if (degreeInstitutionsToQuery.isEmpty()) {
            return;
        }

        // Create dummy institution org if it doesn't exist
        Account dummyInstitution = getDummyInstitutionOrg();

        List<Account> queriedDegreeInstitutions = [SELECT ID, Name FROM Account WHERE Name IN: degreeInstitutionsToQuery];
        Map<String, List<Id>> degreeInstitutionNameToId = new Map<String, List<Id>>();

        for (Account eachInstitution : queriedDegreeInstitutions) {
            // If we find multiple accounts with the same name, we need to make sure we point to the dummy org
            if (!degreeInstitutionNameToId.containsKey(eachInstitution.Name.toLowerCase())) {
                degreeInstitutionNameToId.put(eachInstitution.Name.toLowerCase(), new List<Id>());
            }

            degreeInstitutionNameToId.get(eachInstitution.Name.toLowerCase()).add(eachInstitution.Id);
        }

        for (ucinn_ascendv2__Degree_Information__c eachDegreeInfo : newList) {
            if (String.isBlank(eachDegreeInfo.ucinn_portal_Degree_Institution_Text__c)) {
                continue;
            }
            
            List<Id> degreeInstitutionIdList = degreeInstitutionNameToId.get(eachDegreeInfo.ucinn_portal_Degree_Institution_Text__c.toLowerCase());
            if (isDegreeInstitutionRecordFound(eachDegreeInfo, degreeInstitutionNameToId, degreeInstitutionIdList)) {
                eachDegreeInfo.ucinn_ascendv2__Degree_Institution__c = degreeInstitutionIdList[0];
                continue;
            }

            // If degree institution text is blank or if there is no exact match found in account list, or if there are multiple accounts with the same name, then assign to dummy degree institution org.
            eachDegreeInfo.ucinn_ascendv2__Degree_Institution__c = dummyInstitution.Id;
        }
    }

    /**
     * Gets a set of degree institution names to query, based off of the degree institution text field
     * 
     * @param   affiliation                 The affiliation record to compare
     * @param   degreeInstitutionNameToId   A map of degree institution names to a list of Id's.  This maps to a list because there may be duplicate names.
     * @param   degreeInstitutionIdList     The list of Id's corresponding to the degree institution name found on the degree information record.  This list may be empty.
     * 
     * @return  A boolean indicating whether or not a SINGLE match was found.  If more than one is found, we do not want to return any of the ID's
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    private static Boolean isDegreeInstitutionRecordFound(ucinn_ascendv2__Degree_Information__c degreeInfo, Map<String, List<Id>> degreeInstitutionNameToId, List<Id> degreeInstitutionIdList) {
        return (degreeInfo.ucinn_portal_Degree_Institution_Text__c != null 
                    && degreeInstitutionNameToId.containsKey(degreeInfo.ucinn_portal_Degree_Institution_Text__c.toLowerCase())
                    && degreeInstitutionIdList.size() == 1);
    }

    /**
     * Gets a set of degree institution names to query, based off of the degree institution text field
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    private Set<String> getDegreeInstitutionsToQuery(List<ucinn_ascendv2__Degree_Information__c> newList, Map<Id, ucinn_ascendv2__Degree_Information__c> triggerOldMap) {
        Set<String> degreeInstitutionsToQuery = new Set<String>();

        for (ucinn_ascendv2__Degree_Information__c eachDegreeInfo : newList) {
            if (String.isBlank(eachDegreeInfo.ucinn_portal_Degree_Institution_Text__c)) {
                continue;
            }

            if (Trigger.isInsert || (Trigger.isUpdate && eachDegreeInfo.ucinn_portal_Degree_Institution_Text__c != triggerOldMap.get(eachDegreeInfo.Id).ucinn_portal_Degree_Institution_Text__c)) {
                degreeInstitutionsToQuery.add(eachDegreeInfo.ucinn_portal_Degree_Institution_Text__c);
            }            
        }

        return degreeInstitutionsToQuery;
    }

    /**
     * Get the Dummy Account, if none are found, make one.
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    private Account getDummyInstitutionOrg() {
        List<Account> dummyInstitutionOrgList = [SELECT ID FROM Account WHERE Name = :DUMMY_DEGREE_INSTITUTION_NAME];
        if (!dummyInstitutionOrgList.isEmpty()) {
            return dummyInstitutionOrgList[0];
        }

        Account newDummyInstitutionOrg = new Account(
            Name = DUMMY_DEGREE_INSTITUTION_NAME
        );
        insert newDummyInstitutionOrg;
        return newDummyInstitutionOrg;
    }
}