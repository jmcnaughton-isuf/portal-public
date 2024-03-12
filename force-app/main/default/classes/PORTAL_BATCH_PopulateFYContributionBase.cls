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
 * Base class for populate FY (Fiscal Year) Contributions Batch.
 * Batch populates FY Contributions on society membership based on the yearly giving of a constituent
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global virtual without sharing class PORTAL_BATCH_PopulateFYContributionBase {

    //class variable keys
    global static final String dailyBatch = 'dailyBatch';
    global static final String batchableContext = 'batchableContext';
    global static final String contactRecords = 'contacts';

    /**
     * Generates a query string for the FY batch.
     * NOTE: For the dailymode batch YESTERDAY goes back to midnight of the day before regardless of when the batch is ran.
     *
     * @param               paramMap
     *                          dailyBatch          Boolean that states if the batch should be ran for all constituents or constieunts whose gift data
     *                                              has changed in the last day.
     * @version         1.0
     * @since           1.0
     */
    global virtual String start(Map<String, Object> paramMap) {
        Integer currentFiscalYear = Integer.valueOf([SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name);

        String queryString = 'SELECT Id, (SELECT ucinn_ascendv2__Credit_Amount__c FROM ucinn_ascendv2__Hard_and_Soft_Credits_Contact__r ' +
                                ' WHERE ucinn_ascendv2__Credit_Type__c = \'Hard\' AND ucinn_ascendv2__Gift_Type_Formula__c IN (\'Pledge Payment\', \'Outright Gift\', \'Recurring Gift Payment\') ' +
                                ' AND ucinn_ascendv2__Credit_Amount__c > 0 AND FISCAL_YEAR(ucinn_ascendv2__Credit_Date_Formula__c) = ' + currentFiscalYear + ' ), ' +
                            '(SELECT Id FROM ucinn_ascendv2__Society_Memberships_Contact__r WHERE ucinn_ascendv2__Membership_Status__c = \'Active\' AND ucinn_ascendv2__Giving_Society__r.ucinn_portal_Type__c = \'Annual\') FROM Contact ';
        String whereClause = '';


        Boolean dailyMode = (Boolean)paramMap.get(dailyBatch);

        if (dailyMode) {
            whereClause += ' WHERE ucinn_ascendv2__Giving_Summary_Last_Updated__c >= YESTERDAY ';
        }

        if (String.isNotBlank(whereClause)) {
            queryString += whereClause;
        }

        return queryString;
    }

    /**
     * Sums the constituents credit amounts on their hard and soft credits. Populates all society memberships FY contribution field with that summation.
     *
     * @param               paramMap
     *                          contactRecords      List of contact records and their related society memberships and related hard and soft credits.
     *                          batchableContext    context of the current batch run
     * @version         1.0
     * @since           1.0
     */
    global virtual void execute(Map<String, Object> paramMap) {
        List<Contact> contacts = (List<Contact>)paramMap.get(contactRecords);
        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToUpdate = new List<ucinn_ascendv2__Society_Membership__c>();

        for (Contact currentContact : contacts) {
            Double amountGiven = 0;
            List<ucinn_ascendv2__Society_Membership__c> contactsSocietyMemberships = currentContact.ucinn_ascendv2__Society_Memberships_Contact__r;

            if (contactsSocietyMemberships.isEmpty()) {
                continue;
            }

            for (ucinn_ascendv2__Hard_and_Soft_Credit__c credit : currentContact.ucinn_ascendv2__Hard_and_Soft_Credits_Contact__r) {
                amountGiven += credit.ucinn_ascendv2__Credit_Amount__c;
            }

            // update all society memberships
            if (amountGiven > 0) {
                for (ucinn_ascendv2__Society_Membership__c currentSocietyMemebrship : contactsSocietyMemberships) {
                    currentSocietyMemebrship.ucinn_ascendv2__FY_Contributions__c = amountGiven;
                    societyMembershipsToUpdate.add(currentSocietyMemebrship);
                }
            }
        }

        update societyMembershipsToUpdate;
    }

    /**
     * Place holder for finish method to be overwritten if needed.
     */
    global virtual void finish(Map<String, Object> paramMap) {

    }
}