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
* Batch that will send a list of contacts and newsletter information to the
* transactional email api
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/
global virtual without sharing class PORTAL_BATCH_SendNewsletter implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    global Id newsletterId;
    global String contactQueryString = '';
    global Datetime deliveryTime;
    global static final String EMAIL_STATUS_FIELD = 'ucinn_portal_Email_Status__c';
    global static final String ERROR_STATUS = 'Error';
    global static final String SENT_STATUS = 'Sent';
    global Integer failures = 0;

    public class SendNewsletterException extends Exception {}

     /**
    * constructor for the newsletter batch
    *
    * @param newsletterId                       The id of the newsletter we are trying to send
    * @param deliveryTime                       The time we want to deliver the newsletter

    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    global PORTAL_BATCH_SendNewsletter (Id newsletterId, Datetime deliveryTime){
        if (newsletterId == null || deliveryTime == null) {
            throw new SendNewsletterException('Invalid paramters recieved. Error code: 201');
        }
        this.deliveryTime = deliveryTime;
        this.newsletterId = newsletterId;
        generateContactQuery();
    }

     /**
    * Creates the query that gahers merge fields from the contact in order to pass the merge fields
    * to the email api
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public void generateContactQuery() {
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Id, (SELECT Field_API_Name__c, Front_End_Field_Id__c
                                                                        FROM Portal_Section_Field_Settings__r)
                                                                        FROM Portal_Page_Section_Setting__mdt
                                                                        WHERE Page_Name__c = :PORTAL_CONST_Newsletter.NEWSLETTER_SUBMISSION_PAGE_NAME
                                                                        AND Page_Main_Section__c = :PORTAL_CONST_Newsletter.MERGE_FIELDS_MAIN_SECTION];

        Set<String> contactFieldSet = new Set<String>();
        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            if (sectionSetting.Portal_Section_Field_Settings__r != null) {
                for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                    if (String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                        contactFieldSet.add(fieldSetting.Field_API_Name__c);
                    }
                }
            }
        }

        contactFieldSet.add('Email');
        contactFieldSet.add('Id');

        this.contactQueryString = 'SELECT ' + String.join(new List<String>(contactFieldSet), ',') + ' FROM Contact WHERE Id IN :contactIdSet and Email != null';
    }


     /**
    * Creates the query locator for the campaign members for the specific newsletter campaign
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    global virtual Database.QueryLocator start(Database.BatchableContext context) {
        Id campaignId = [SELECT Newsletter_Metrics__c FROM ucinn_portal_Listing__c WHERE Id =:this.newsletterId]?.Newsletter_Metrics__c;
        if (campaignId == null) {
            throw new AuraHandledException('There is no newsletter metrics for this newsletter.');
        }
        String queryString = 'SELECT ContactId FROM CampaignMember WHERE CampaignId = :campaignId AND ucinn_portal_Email_Status__c != \'Sent\'';
        return Database.getQueryLocator(queryString);
    }

    /**
    * Gathers the list of campaign members and newsletter parameters to send to the email api
    *
    * @param campaignMemberList                The list of campaign members that need to be sent newsletters
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    global virtual void execute (Database.BatchableContext context, List<sObject> campaignMemberList) {

        Set<Id> contactIdSet = new Set<Id>();

        for (sObject member : campaignMemberList) {
            if (member.get('ContactId') != null) {
                contactIdSet.add((Id) member.get('ContactId'));
            }
        }

        List<Contact> contactList = Database.query(this.contactQueryString);

        List<ucinn_portal_Listing__c> newsletterList = [SELECT Subject_Line__c, Portal_Zone__c FROM ucinn_portal_Listing__c WHERE Id =: this.newsletterId];

        ucinn_portal_Listing__c newsletter = null;
        ucinn_portal_Zone__c zone = null;

        // get club from email, from name, and reply email
        if (!newsletterList.isEmpty()) {
            newsletter = newsletterList.get(0);
            List<ucinn_portal_Zone__c> zones = [SELECT Name, Email__c FROM ucinn_portal_Zone__c WHERE Name =: newsletter.Portal_Zone__c AND Is_Display_on_Portal__c = true];
            if (!zones.isEmpty()) {
                zone = zones[0];
            }
        }

        if (newsletter == null) {
            throw new SendNewsletterException('Could not find newsletter with id: ' + this.newsletterId);
        }

        if (zone == null) {
            throw new SendNewsletterException('There was an issue with your zone, please check your zone. Error Code: 204');
        }

        Map<String, Object> params = new Map<String, Object>();
        params.put(PORTAL_API_EmailHubBase.CONTACT_LIST_KEY, contactList);
        params.put(PORTAL_API_EmailHubBase.FROM_EMAIL_KEY, zone.Email__c);
        params.put(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY, this.newsletterId);
        params.put(PORTAL_API_EmailHubBase.ZONE_NAME_KEY, zone.Name);
        params.put(PORTAL_API_EmailHubBase.SUBJECT_KEY, newsletter.Subject_Line__c);
        PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
        params.put(PORTAL_API_EmailHubBase.HTML_KEY, controller.parseNewsletterHTML(new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => this.newsletterId}));
        params.put(PORTAL_API_EmailHubBase.PLAIN_TEXT_KEY, controller.parseNewsletterPlainText(new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => this.newsletterId}));
        params.put(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY, this.deliveryTime);

        try {
            PORTAL_CommunityUtils.throwTestException(null);

            PORTAL_API_EmailHubBase.scheduleTransactionalEmail(params);
            for (SObject member : campaignMemberList) {
                member.put(EMAIL_STATUS_FIELD, SENT_STATUS);
            }
            update campaignMemberList;

        } catch (Exception e) {
            System.debug('Error: ' + e);
            for (sObject member : campaignMemberList) {
                member.put(EMAIL_STATUS_FIELD, ERROR_STATUS);
            }
            update campaignMemberList;
            this.failures += 1;
        }

    }

    /*
    * Calls the next set of caches to run if there are more caches, if not updates the newsletter to state it has finished.
    * Calls next batch to avoid heap spaces if there are alot of id's in the cache.
    *
    * @param bc                                                 Context of batch provided by salesforce
    */
    global virtual void finish(Database.BatchableContext bc) {

        ucinn_portal_Listing__c newsletter = [SELECT Id, Actual_Start_Date_Time__c, Cache_API_Name__c, Time_Zone__c from ucinn_portal_Listing__c WHERE Id=: this.newsletterId];
        if (failures > 0 || [SELECT NumberOfErrors FROM AsyncApexJob WHERE Id = :bc.getJobId()]?.NumberOfErrors > 0) {
            newsletter.Status__c = 'Incomplete';
        } else if (this.deliveryTime < Datetime.now().addMinutes(30)) {
            newsletter.Is_Newsletter_Sent__c = true;
            newsletter.Status__c = 'Published';
        } else {
            newsletter.Status__c = 'Scheduled';
            newsletter.Start_Date_Time__c = this.deliveryTime;
        }

        // set the time it was sent

        newsletter.Actual_Start_Date_Time__c = String.valueOf(DateTime.now());
        if (String.isBlank(newsletter.Time_Zone__c)) {
            newsletter.Time_Zone__c = PORTAL_CONST_Global.DEFAULT_TIME_ZONE;
        }

        update newsletter;

        if (String.isNotBlank( newsletter.Cache_API_Name__c)) {
            delete [SELECT Id FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c =: newsletter.Cache_API_Name__c];
        }

    }

}