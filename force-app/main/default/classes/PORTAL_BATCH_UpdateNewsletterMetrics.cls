/*
* Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
*                     http://www.ucinnovation.com
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
* Batch that will update the metrics for newsletters that have been sent
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/

global virtual without sharing class PORTAL_BATCH_UpdateNewsletterMetrics implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts{
    public static final String NUMBER_OF_DAYS_METADATA_LABEL = 'Number_of_Days_for_Metrics';
    public String campaignId;

    global PORTAL_BATCH_UpdateNewsletterMetrics() {}

    global PORTAL_BATCH_UpdateNewsletterMetrics(String campaignId) {
        this.campaignId = campaignId;
    }

    /**
    * Method that determines the cutoff period and queries for newsletters sent within that cutoff period
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    global virtual Database.QueryLocator start(Database.BatchableContext context) {
        Integer cuffoffPeriod = -7;
        List<Portal_Organization_Setting__mdt> organizationSetting = [SELECT Value__c FROM Portal_Organization_Setting__mdt WHERE DeveloperName = :NUMBER_OF_DAYS_METADATA_LABEL];
        if (!organizationSetting.isEmpty()) {
            if (String.isNotBlank(organizationSetting.get(0).Value__c)) {
                //cutoff period should be negative
                cuffoffPeriod = 0 - Math.abs(Integer.valueOf(organizationSetting.get(0).Value__c));
            }
        }

        Datetime cutoff = Datetime.now().addDays(cuffoffPeriod);
        Datetime currentDateTime = Datetime.now();

        String queryString = 'SELECT Id, External_Email_API_Id__c FROM ucinn_portal_Listing__c WHERE  RecordType.DeveloperName = \'Newsletter\' AND Newsletter_Metrics__c != null AND Is_Newsletter_Sent__c = true AND Start_Date_Time__c >= :cutoff AND Start_Date_Time__c < :currentDateTime';
        if (String.isNotBlank(this.campaignId)) {
            queryString = queryString + ' AND Newsletter_Metrics__c = \'' + this.campaignId + '\' ';
        }

        //find newsletters that are sent between the cutoff time and now
        return Database.getQueryLocator(queryString);
    }

    /**
    * Method that will update the metric for each newsletter
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    global virtual void execute(Database.BatchableContext context, List<ucinn_portal_Listing__c> listingList) {

        for (ucinn_portal_Listing__c eachListing : listingList) {
            if (!Test.isRunningTest()) {
                //update the metrics
                PORTAL_API_EmailHubBase.updateMetrics(eachListing.Id, eachListing.External_Email_API_Id__c);
            }
        }
    }

    /**
    *finish method
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    global virtual void finish(Database.BatchableContext context) {

    }

    public virtual void execute(SchedulableContext scon) {
        Database.executeBatch(new PORTAL_BATCH_UpdateNewsletterMetrics(), 1);
    }
}