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

public virtual with sharing class PORTAL_BATCH_NewsletterCampaign implements Database.Batchable<String>, Database.AllowsCallouts{

    public static final String CAMPAIGN_RECORD_TYPE = 'Newsletter_Campaign';
    public static final String COMPLETED_STATUS = 'Completed';
    public static final String EMAIL_TYPE = 'Email';
    public static final String PENDING_STATUS = 'Pending';

    public String cacheApiName; // cache API Name of cache NOT ID
    public Id newsletterId;
    public Integer startingFieldOrder;
    public Integer numberOfCaches;
    public Id campaignId;
    public Datetime deliveryTime;

    public class NewsletterCampaignException extends Exception {}

    /**
    * Constructor which assigns class variables. If the newsletter doesn't have a campaign associated with it, one is created and newsletter is updated.
    * Run batch at size of 1.
    *
    * @param deliveryTime                         The time we want to send the newsletter
    * @param newsletterId                         Id of the newsletter being sent
    * @param startingFieldOrder                   Which field of the cache we are starting the current run on. (Initial run should be 1)
    * @param numberOfCaches                       The number of caches to handle in a given batch. Setting this to high can cause heap limits exceptions.
    */
    public PORTAL_BATCH_NewsletterCampaign(Id newsletterId, Datetime deliveryTime, Integer startingFieldOrder, Integer numberOfCaches) {
        if (String.isBlank(newsletterId) || numberOfCaches == null || numberOfCaches <= 0 || startingFieldOrder == null || startingFieldOrder <= 0 || deliveryTime == null) {
            throw new NewsletterCampaignException('Invalid parameters recieved. Error code: 701');
        }
        this.newsletterId = newsletterId;
        this.startingFieldOrder = startingFieldOrder; // 1 to start!
        this.numberOfCaches = numberOfCaches; // recommended 1
        this.deliveryTime = deliveryTime;

        List<ucinn_portal_Listing__c> newsletters = [SELECT Id, Newsletter_Template__c, Newsletter_Metrics__c, Cache_API_Name__c From ucinn_portal_Listing__c WHERE Id =:this.newsletterId AND Cache_API_Name__c != null];


        if (newsletters.isEmpty()) {
            throw new NewsletterCampaignException('Invalid newsletter Id. Error code: 702');
        }

        ucinn_portal_Listing__c newsletter = newsletters[0];
        this.cacheApiName = newsletter.Cache_API_Name__c;

        // if there is no campaign, set one up
        if (newsletter.Newsletter_Metrics__c == null) {
            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = (String)newsletterId + ' Metrics';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = COMPLETED_STATUS;
            newsletterCampaign.Type= EMAIL_TYPE;
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(CAMPAIGN_RECORD_TYPE).getRecordTypeId();
            insert newsletterCampaign;
            this.campaignId = newsletterCampaign.Id;

            // Update newsletter. get plaintext body for newsletter and link newsletter with header and footer.
            newsletter.Newsletter_Metrics__c = newsletterCampaign.Id;
            update newsletter;
        } else {
            this.campaignId = newsletter.Newsletter_Metrics__c;
        }
    }

    /**
    * Gets the caches that hold the contact ids of constituents who should be sent the newsletter
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual Iterable<String> start(Database.BatchableContext context) {
        String queryString = 'SELECT Contact_Id_Cache_1__c, Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c, Contact_Id_Cache_6__c,'
                            + 'Contact_Id_Cache_7__c, Contact_Id_Cache_8__c, Contact_Id_Cache_9__c, Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c, Order_Number__c '
                            + 'FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c=\'' + this.cacheApiName + '\' AND Order_Number__c >= ' + this.startingFieldOrder + ' ORDER BY Order_Number__c ASC LIMIT '
                            + this.numberOfCaches;

        List<ucinn_portal_Search_Filter_Cache__c> constituentIdCacheList = Database.query(queryString);

        if (constituentIdCacheList.isEmpty()) {
            throw new NewsletterCampaignException('There was no constituents to send the newsletter to. Error Code: 705');
        }

        List<String> constituentIdSegment = segmentContactCache(constituentIdCacheList);

        if (constituentIdSegment == null) {
            throw new NewsletterCampaignException('There was no constituents to send the newsletter to. Error Code: 706');
        }

        return constituentIdSegment;
    }

    /**
    * method that gets all of the cache strings
    *
    * @param constituentIdCacheList            List of caches taht need to be parsed
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @return                                  list of strings that represent the contact ids
    */

    private List<String> segmentContactCache(List<ucinn_portal_Search_Filter_Cache__c> constituentIdCacheList) {
        List<String> segmentedIdList = new List<String>();
        String cacheFieldTemplate = 'Contact_Id_Cache_{0}__c';
        for (ucinn_portal_Search_Filter_Cache__c eachCache: constituentIdCacheList) {
            for (Integer currentCacheField = 1; currentCacheField <= 12; currentCacheField++) {
                String cacheIds = (String)eachCache.get(String.format(cacheFieldTemplate, new List<Object>{currentCacheField}));
                if (String.isBlank(cacheIds)) {
                    continue;
                }
                segmentedIdList.add(cacheIds);
            }
        }

        return segmentedIdList;
    }

    /**
    * method that takes the list of contact strings and converts them into campaign members
    *
    * @param idStringList                      List of strings that each represent a list of constituent ids
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual void execute(Database.BatchableContext content, List<String> idStringList) {
        //executed with batch size 1
        String currentIdString = idStringList.get(0);

        if (String.isBlank(currentIdString)) {
            return;
        }

        List<String> constituentIdList = currentIdString.split(';');

        // Should never be greater than size 10,000. Prevents DML exception
        if (constituentIdList.size() > 10000 || constituentIdList.isEmpty()) {
            System.debug('constituentIdList was over 10,000 Ids or was empty, so it was skipped on this chunk.');
            return;
        }

        List<CampaignMember> campaignMembersToInsert = new List<CampaignMember>();

        for (String eachContactId : constituentIdList) {
            CampaignMember eachCampaignMember = new CampaignMember();
            eachCampaignMember.CampaignId = this.campaignId;
            eachCampaignMember.ContactId = eachContactId;
            eachCampaignMember.ucinn_portal_Email_Status__c = PENDING_STATUS;
            campaignMembersToInsert.add(eachCampaignMember);
        }

        insert campaignMembersToInsert;
    }

    /**
    * continues to add campaign members if there are more caches to go through else
    * will schedule the email
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual void finish(Database.BatchableContext content) {
        List<ucinn_portal_Search_Filter_Cache__c> cacheList = [SELECT Order_Number__c FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_API_Name__c =:this.cacheApiName ORDER BY Order_Number__c DESC LIMIT 1];

        if (cacheList.isEmpty()) {
            return;
        }

        ucinn_portal_Search_Filter_Cache__c cache = cacheList.get(0);
        Integer maxOrderCache = (Integer)cache.Order_Number__c;
        Integer currentOrder = this.startingFieldOrder + this.numberOfCaches;

        // more caches to go through
        if (!Test.isRunningTest()) {
            if (currentOrder <= maxOrderCache) {
                Database.executeBatch(new PORTAL_BATCH_NewsletterCampaign(this.newsletterId, this.deliveryTime, currentOrder, this.numberOfCaches), 1);
            }
            else {
                Map<String,Object> params = new Map<String, Object>();
                params.put(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY, this.newsletterId);
                params.put(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY, this.deliveryTime);
                PORTAL_API_EmailHubBase.scheduleEmail(params);
            }
        }
    }
}