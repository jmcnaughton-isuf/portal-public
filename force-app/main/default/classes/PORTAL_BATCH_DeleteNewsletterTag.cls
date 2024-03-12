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
* Batch that frees up tags in a transactional api
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/

public virtual inherited sharing class PORTAL_BATCH_DeleteNewsletterTag implements Database.Batchable<sObject> {

    public static final String NUMBER_OF_DAYS_METADATA_LABEL = 'Number_of_Days_for_Metrics';

    public PORTAL_BATCH_DeleteNewsletterTag() {

    }

     /**
    * Method that determines the cutoff period and queries for newsletters sent outside the cutoff period that needs to be deleted
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual Database.QueryLocator start(Database.BatchableContext context) {
        String queryString;
        Integer cuffoffPeriod = -7;
        List<Portal_Organization_Setting__mdt> organizationSetting = [SELECT Value__c FROM Portal_Organization_Setting__mdt WHERE DeveloperName = :NUMBER_OF_DAYS_METADATA_LABEL];
        if (!organizationSetting.isEmpty()) {
            if (String.isNotBlank(organizationSetting.get(0).Value__c)) {
                cuffoffPeriod = 0 - Math.abs(Integer.valueOf(organizationSetting.get(0).Value__c));
            }
        }

        Datetime cutoff = Datetime.now().addDays(cuffoffPeriod);
        return Database.getQueryLocator('SELECT Id, External_Email_API_Id__c FROM ucinn_portal_Listing__c WHERE RecordType.DeveloperName = \'Newsletter\' AND Newsletter_Metrics__c != null AND Is_Newsletter_Sent__c = true AND Start_Date_Time__c < :cutoff AND Is_Deleted_In_Email_API__c = false');
    }

    /**
    * Method that will delete the newsletter id (tag) from the transactional email api
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual void execute(Database.BatchableContext context, List<ucinn_portal_Listing__c> listingList) {
        PORTAL_API_MailGun controller = new PORTAL_API_MailGun();
        for (ucinn_portal_Listing__c eachListing : listingList) {
            eachListing.Is_Deleted_In_Email_API__c = controller.deleteTag(eachListing.Id);
        }

        update listingList;
    }

    /**
    * finish  method
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual void finish(Database.BatchableContext context) {

    }
}