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
global without sharing virtual class PORTAL_TRIG_AffiliationHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    public static final String DUMMY_EMPLOYER_NAME = 'Dummy Employer Organization *DO NOT DELETE*';

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
        List<ucinn_ascendv2__Affiliation__c> triggerNew = (List<ucinn_ascendv2__Affiliation__c>) newList;
        List<ucinn_ascendv2__Affiliation__c> triggerOld = (List<ucinn_ascendv2__Affiliation__c>) oldList;
        Map<Id, ucinn_ascendv2__Affiliation__c> triggerOldMap =  new Map<Id, ucinn_ascendv2__Affiliation__c>();

        if (triggerOld != null) {
            triggerOldMap = new Map<Id, ucinn_ascendv2__Affiliation__c>(triggerOld);
        }
        
        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            populateEmployerLookup(triggerNew, triggerOldMap);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            populateEmployerLookup(triggerNew, triggerOldMap);
        }
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     *  Populate Account look up field based on Employer text field. This is primarily used for portal.
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    protected virtual void populateEmployerLookup(List<ucinn_ascendv2__Affiliation__c> newList, Map<Id, ucinn_ascendv2__Affiliation__c> triggerOldMap) {
        Set<String> employersToQuery = getEmployersToQuery(newList, triggerOldMap);

        // If Employer text was not updated on any of the records, skip the rest of the logic.
        if (employersToQuery.isEmpty()) {
            return;
        }

        // Create dummy employer org if it doesn't exist
        Account dummyEmployerOrg = getDummyEmployerOrg();

        List<Account> queriedEmployers = [SELECT ID, Name FROM Account WHERE Name IN: employersToQuery];

        Map<String, List<Id>> employerNameToId = new Map<String, List<Id>>();

        for (Account eachEmployer : queriedEmployers) {
            // If we find multiple accounts with the same name, we need to make sure we point to the dummy org
            if (!employerNameToId.containsKey(eachEmployer.Name.toLowerCase())) {
                employerNameToId.put(eachEmployer.Name.toLowerCase(), new List<Id>());
            }
            employerNameToId.get(eachEmployer.Name.toLowerCase()).add(eachEmployer.Id);
        }

        for (ucinn_ascendv2__Affiliation__c eachAffiliation : newList) {
            if (String.isBlank(eachAffiliation.ucinn_portal_Employer_Text__c)) {
                continue;
            }
            
            List<Id> employerIdList = employerNameToId.get(eachAffiliation.ucinn_portal_Employer_Text__c.toLowerCase());
            if (isEmployerRecordFound(eachAffiliation, employerNameToId, employerIdList)) {
                eachAffiliation.ucinn_ascendv2__Account__c = employerIdList[0];
                continue;
            }

            // If employer text is blank or if there is no exact match found in account list or if there are multiple accounts with the same name, then assign to dummy employer org.
            eachAffiliation.ucinn_ascendv2__Account__c = dummyEmployerOrg.Id;
        }
    }

    /**
     * Gets a set of employer names to query, based off of the employer text field
     * 
     * @param   affiliation         The affiliation record to compare
     * @param   employerNameToId    A map of employer names to a list of Id's.  This maps to a list because there may be duplicate names.
     * @param   employerIdList      The list of Id's corresponding to the employer name found on the affiliation.  This list may be empty.
     * 
     * @return  A boolean indicating whether or not a SINGLE match was found.  If more than one is found, we do not want to return any of the ID's
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    private static Boolean isEmployerRecordFound(ucinn_ascendv2__Affiliation__c affiliation, Map<String, List<Id>> employerNameToId, List<Id> employerIdList) {
        return (affiliation.ucinn_portal_Employer_Text__c != null 
                    && employerNameToId.containsKey(affiliation.ucinn_portal_Employer_Text__c.toLowerCase())
                    && employerIdList.size() == 1);
    }

    /**
     * Gets a set of employer names to query, based off of the employer text field
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    private static Set<String> getEmployersToQuery(List<ucinn_ascendv2__Affiliation__c> newList, Map<Id, ucinn_ascendv2__Affiliation__c> triggerOldMap) {
        Set<String> employersToQuery = new Set<String>();

        for (ucinn_ascendv2__Affiliation__c eachAffiliation : newList) {
            if (String.isBlank(eachAffiliation.ucinn_portal_Employer_Text__c)) {
                continue;
            }

            if (Trigger.isInsert || (Trigger.isUpdate && eachAffiliation.ucinn_portal_Employer_Text__c != triggerOldMap.get(eachAffiliation.Id).ucinn_portal_Employer_Text__c)) {
                employersToQuery.add(eachAffiliation.ucinn_portal_Employer_Text__c);
            }
        }

        return employersToQuery;
    }

    /**
     * Get the Dummy Account, if none are found, make one.
     *                  
     * @author  Todd Shinto
     * @since   1.10
     */
    private static Account getDummyEmployerOrg() {
        List<Account> dummyEmployerOrgList = [SELECT ID FROM Account WHERE Name = :DUMMY_EMPLOYER_NAME];
        if (!dummyEmployerOrgList.isEmpty()) {
            return dummyEmployerOrgList[0];          
        }

        Account newDummyEmployerOrg = new Account(
            Name = DUMMY_EMPLOYER_NAME
        );
        insert newDummyEmployerOrg;
        return newDummyEmployerOrg;
    }
}