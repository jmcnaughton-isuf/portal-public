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
 * batch class that takes an interim employment and checks to see if
 * it can be processed by the next batches
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */

public with sharing virtual class PORTAL_BATCH_ProcessNewInterimEmployment implements Database.Batchable<sObject>{
    public PORTAL_BATCH_ProcessNewInterimEmployment() {

    }

    /**
     * batch start method that creates the query for the new interim
     * employment records that need to be checked
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @return                          the query locator for this batch
     */

    public virtual Database.QueryLocator start(Database.BatchableContext BC) {
        String queryString = 'SELECT Id FROM ucinn_portal_Interim_Employment__c WHERE Status__c = \'New\' AND '
                             + ' Interim__r.ucinn_ascendv2__Status__c = \'Completed\' AND Is_Possible_Duplicate_Checked__c = true';
        return Database.getQueryLocator(queryString);
    }

    /**
     * execution method that will take a list of interim employment records
     * and checks to see if they can be processed or not
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param interimEmploymentList             list of interim employments to process in this execution
     */

    public virtual void execute(Database.BatchableContext BC, List<ucinn_portal_Interim_Employment__c> interimEmploymentList) {
        Map<Id, ucinn_portal_Interim_Employment__c> interimEmploymentMap = new Map<Id, ucinn_portal_Interim_Employment__c>(interimEmploymentList);

        List<ucinn_ascendv2__Dedupe_Possible_Duplicate__c> duplicatesFound = [SELECT Name FROM ucinn_ascendv2__Dedupe_Possible_Duplicate__c WHERE Name IN :interimEmploymentMap.keyset()];
        Set<String> duplicateIdSet = new Set<String>();
        for (ucinn_ascendv2__Dedupe_Possible_Duplicate__c duplicate : duplicatesFound) {
            duplicateIdSet.add(duplicate.Name);
        }
        for (ucinn_portal_Interim_Employment__c interimEmployment : interimEmploymentList) {
            interimEmployment.Status__c = PORTAL_CONST_CommunityUser.PENDING;
            if (duplicateIdSet.contains(String.valueOf(interimEmployment.Id))) {
                interimEmployment.Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                interimEmployment.Manual_Review_Reason__c = 'Possible duplicates found.';
            }
        }
        Database.update(interimEmploymentList, false);
    }

    /**
     * finish method for batch class that calls the pending batch after
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     */
    public virtual void finish(Database.BatchableContext BC) {
        if (!Test.isRunningTest()) {
            Database.executeBatch(new PORTAL_BATCH_ProcessPendingEmployment());
        }

    }
}