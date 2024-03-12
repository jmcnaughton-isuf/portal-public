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
 *
 *
 *
 */

 /**
  * class for ConstantContact integration. ConstantContact uses Oauth2.0 for authentication
  * @author                     Sam Longo
  * @since                      1.0
  */
global without sharing virtual class PORTAL_API_ConstantContact extends PORTAL_EmailInterface {

    public static final String ENDPOINT_PREFIX = 'callout:ConstantContact/';
    public static final String CONTACTS_ENDPOINT = ENDPOINT_PREFIX + 'contacts/';
    public static final String CHECK_TOKEN_ENDPOINT = ENDPOINT_PREFIX + 'token_info/';
    public static final String LISTS_ENDPOINT = ENDPOINT_PREFIX + 'contact_lists/';
    public static final String CAMPAIGNS_ENDPOINT = ENDPOINT_PREFIX + 'emails/';

    public static final String LIST_CALLBACK_KEY = 'list_id';

    public static final String CONTACT_CREATE_ERROR_SUBSTRING = 'Validation failed: Email already exists for contact ';

    public static Integer MAX_RECORD_PER_BATCH = 2; //4 callouts per second limit for ConstantContact, and we use 2 callouts per contact.

    //things stored for the transaction for dml inserts at the end of the transaction
    //needed like this because we cannot do a dml and then an api callout
    private Boolean isChangedTokens = false;
    private Map<Id, Contact> changedContactMap = new Map<Id, Contact>();
    private Map<Id, ucinn_portal_Zone__c> changedZoneMap = new Map<Id, ucinn_portal_Zone__c>();
    private Campaign campaignToUpsert = null;
    private ucinn_portal_Listing__c listingToUpdate = null;
    private Set<Id> batchContactIds = new Set<Id>();
    private Set<Id> batchZoneIds = new Set<Id>();

    public static Map<String,String> metricsMap =  new Map<String, String>{'em_clicks'                        => 'ucinn_portal_Number_of_Email_Clicks__c', //count of unique clicks -- at least one link clicked
                                                                            'em_opens.all.mobile'               => '', //count of NON unique opens by a mobile device
                                                                            'em_clicks.all.none'                => '', //count of NON unique opens by a device that was unrecognized or hidden
                                                                            'em_bounces'                        => 'ucinn_portal_Number_Of_Failed_Emails__c', //count of emails that failed to deliver
                                                                            'em_clicks.all'                     => '', //count of NON unique clicks -- counts all links and 1 user clicking the same link multiple times
                                                                            'em_opens.all.computer'             => '', //count of NON unique opens by a desktop computer
                                                                            'em_abuse'                          => 'ucinn_portal_Number_of_Spam_Reports__c', //count of emails reported as spam
                                                                            'em_clicks.all.mobile'              => '', //count of NON unique clicks by a mobile device -- counts all links and 1 user clicking the same link multiple times
                                                                            'em_bounces_blocked'                => '', //count of failed emails with the reason of blocked
                                                                            'em_bounces_other'                  => '', //count of failed emails with a reason that was unknown or hidden
                                                                            'em_opens'                          => 'ucinn_portal_Number_of_Email_Opens__c', //count of UNIQUE opens
                                                                            'em_opens.all'                      => '', //count of NON unique opens
                                                                            'em_clicks.all.computer'            => '', //count of NON unique clicks by a desktop computer
                                                                            'em_opens.all.other'                => '', //count of NON unique opens by an unknown or hidden device
                                                                            'em_not_opened'                     => '', //count of emails successfully set but not yet opened
                                                                            'em_bounces_nonexistent_address'    => '', //count of failed emails with reason of the address being nonexistant
                                                                            'em_bounces_suspended'              => '', //count of failed emails with reason of suspended
                                                                            'em_opens.all.none'                 => '', //count of NON unique opens with an unknown or hidden device
                                                                            'em_sends'                          => 'ucinn_portal_Number_of_Delivered_Emails__c', //count of successfully sent emails
                                                                            'em_optouts'                        => 'ucinn_portal_Number_of_Email_Unsubscribe__c', //count of users unsubscribing through ConstantContact from the email
                                                                            'em_forwards'                       => '', //count of users that forwarded the email with constantContacts provided functionality (this is potentially misleading and inaccurate maybe don't use)
                                                                            'em_bounces_undeliverable'          => '', //count of failed emails with reason of the email being undeliverable -- as in the server itself did not respond, like sending to NAME@gmail.com and the gmail.com server being down
                                                                            'em_opens.all.tablet'               => '', //count of NON unique opens by a tablet device
                                                                            'em_bounces_mailbox_full'           => '', //count of failed emails with reason that the recipient's mailbox was full
                                                                            'em_clicks.all.other'               => '', //count of NON unique clicks by an unknown or hidden device
                                                                            'em_bounces_vacation'               => ''}; //count of failed email with reason that the recipient had a vacation filter


    global class ConstantContactException extends Exception {}

    public PORTAL_API_ConstantContact() {
    }

    /**
     * Lets the emailhub know that this is a campaign service so it can determine what methods to call
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     *
     */
    public override Boolean isTransactionalEmailAPI(Map<String, Object> params) {
        return false;
    }


    /**
     * takes a set of external Ids and deletes the contacts associated with them
     * used in order to reduce contact counts for contacts that are no longer applicable
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     *
     * @param externalContactIds          Set<String> external Ids for contacts to delete
     */
    public override void removeContactsFromExternalApi(Map<String, Object> params) {
        List<String> externalContactIds = new List<String>((Set<String>)params?.get(PORTAL_API_EmailHubBase.EXTERNAL_CONTACT_IDS_KEY));

        if (externalContactIds.isEmpty()) {
            throw new ConstantContactException('There was an error with deleting a batch of contacts. No consituent ids were passed as parameters');
        }

        //once the campaign and email have been created, now we can set the rest of the details
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_PREFIX + 'activities/contact_delete');
        request.setMethod('POST');

        String body = '\'{\'"contact_ids":["{0}"]\'}\'';
        body = String.format(body,new List<Object> {String.join(externalContactIds, '", "')});
        request.setBody(body);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            throw new ConstantContactException('There was an error with deleting a batch of contacts. error code: ' + response.getStatusCode());
        }
    }

    /**
     * takes contacts and stores them onto the external service to add them to mailing list
     * note this this requires the mailing lists for the contact to exist on the external service
     *
     * @author Sam Longo
     *
     * @version                                             1.0
     * @since                                               1.0
     *
     * @param contactList          List<contact> records being created and updated, must include ucinn_portal_External_Email_API_Id__c, Email, FirstName, LastName fields
     */
    public override void addOrUpdateContactsToExternalApi(Map<String, Object> params) {
        List<Contact> contactList = (List<Contact>)params?.get(PORTAL_API_EmailHubBase.CONTACT_LIST_KEY);

        if(contactList.isEmpty()) {
            throw new ConstantContactException('There was an error with updating contacts. No contacts were passed as parameters');
        }

        if (contactList.size() > MAX_RECORD_PER_BATCH) {
            //if we're passed the threshold for a single processing we send everything to be batched in smaller chunks
            List<Contact> firstSlice = new List<Contact>();
            for (Integer eachIndex = 0; eachIndex < contactList.size(); eachIndex++) {
                batchContactIds.add(contactList[eachIndex].Id);
            }
            return;
        }

        for (Contact eachContact : contactList) {
            //first we attempt to create a contact, in the situation where the contact did not have a constantcontact Id
            if (String.isBlank(eachContact.ucinn_portal_External_Email_API_Id__c)) {

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(CONTACTS_ENDPOINT);
                request.setMethod('POST');

                String body = '\'{\'"email_address":\'{\'"address": "{0}"\'}\', "first_name":"{1}", "last_name":"{2}","create_source":"Account"\'}\'';
                body = String.format(body,new List<Object> {eachContact.Email, eachContact.FirstName, eachContact.LastName});
                request.setBody(body);

                HttpResponse response = http.send(request);

                String foundId = '';
                //error strings for this call are actually a list of JSONS for some reason while successes are just a JSON so we need to deserialize differently
                if (response.getStatusCode() == 409) {
                    //error message handling letting us know a duplicate email was found so we extract the Id
                    List<Object> result = (List<Object>) JSON.deserializeUntyped(response.getBody());
                    Map<String, Object> data = (Map<String, Object>) result[0];
                    eachContact.ucinn_portal_External_Email_API_Id__c = ((String)data.get('error_message')).subStringAfter(CONTACT_CREATE_ERROR_SUBSTRING);
                } else if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                    //success message giving us the new id
                    Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    eachContact.ucinn_portal_External_Email_API_Id__c = (String)data.get('contact_id');
                }

                changedContactMap.put(eachContact.Id, eachContact);

                if (String.isBlank(eachContact.ucinn_portal_External_Email_API_Id__c)) {
                    //failed to get an external id so we mark the constituent and skip to the next one
                    eachContact.ucinn_portal_Error_Message__c = 'There was an unexpected error with creating a contact in ConstantContact.';
                    continue; //this is so we don't run the update part for this failed contact
                }
            }

            //update the contact with all the list information
            List<ucinn_portal_Zone_Membership__c> membershipList = eachContact.ucinn_portal_Zone_Memberships__r;
            List<String> externalMembershipIds = new List<String>();
            for (ucinn_portal_Zone_Membership__c eachMembership : membershipList) {
                if (String.isNotBlank(eachMembership.Zone__r.External_Email_API_Id__c)) {
                    externalMembershipIds.add(eachMembership.Zone__r.External_Email_API_Id__c);
                }
            }

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(CONTACTS_ENDPOINT + eachContact.ucinn_portal_External_Email_API_Id__c);
            request.setMethod('PUT');

            String body = '\'{\'"email_address":\'{\'"address": "{0}", "permission_to_send":"implicit"\'}\', "first_name":"{1}", "last_name":"{2}", "update_source":"Account", "list_memberships":["{3}"]\'}\'';
            body = String.format(body,new List<Object> {eachContact.Email, eachContact.FirstName, eachContact.LastName, String.join(externalMembershipIds, '", "')});
            request.setBody(body);

            HttpResponse response = http.send(request);
            if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
                eachContact.ucinn_portal_Error_Message__c = 'There was an error with updating a contact in ConstantContact. error code: ' + response.getStatusCode();
                changedContactMap.put(eachContact.Id, eachContact);
            }
        }
    }

    /**
     * takes a zone without a mailing list and creates a mailing list in ConstantContact and sets the external mail id on the zone
     * for constant contact this is only create since the constituents store lookups to the list
     *
     * @author Sam Longo
     *
     * @version                                             1.0
     * @since                                               1.0
     *
     * @param       zone                                    zone record that will be used to generate a new list, must include External_Email_API_Id__c, Id, Name fields
     */
    public override void createOrUpdateExternalMailingLists(Map<String, Object> params) {
        List<ucinn_portal_Zone__c> zoneList = (List<ucinn_portal_Zone__c>) params?.get(PORTAL_API_EmailHubBase.ZONE_LIST_KEY);

        if(zoneList.isEmpty()) {
            throw new ConstantContactException('There was an error with updating lists. No zones were passed as parameters');
        }

        if (zoneList.size() > MAX_RECORD_PER_BATCH) {
            //if we're passed the threshold for a single processing we will just send to a batch instead to be processed in smaller chunks
            for (Integer eachIndex = 0; eachIndex < zoneList.size(); eachIndex++) {
                batchZoneIds.add(zoneList[eachIndex].Id);
            }

            return;
        }

        for (ucinn_portal_Zone__c eachZone : zoneList) {

            if (String.isNotBlank(eachZone.External_Email_API_Id__c)) {
                //zone already has a list in constantcontact and no updates are neccesary for this service for this zone
                continue;
            }

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(LISTS_ENDPOINT);
            request.setMethod('POST');

            String body = '{"name":"'+ eachZone.Id + ' - ' + eachZone.Name +'"}';
            request.setBody(body);
            HttpResponse response = http.send(request);

            response.getStatusCode();

            if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
                //failure so we add an error message
                eachZone.Error_Message__c = 'Error creating a new ConstantContact list for this zone. Error code: ' + response.getStatusCode();
                continue;
            }

            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            if (data.get(LIST_CALLBACK_KEY) != null) {
                eachZone.External_Email_API_Id__c = (String)data.get(LIST_CALLBACK_KEY);
            }

            changedZoneMap.put(eachZone.Id, eachZone);
        }
    }

    /**
     * Takes a newsletter and creates a campaign and campaign activity in ConstantContact
     * while ConstantContact allows for multiple email activities per email campaign,
     * for simplicity we will be treating it as if 1 listing to 1 email campaign activity,
     * and will only be storing the email Campaign Activity Id
     *
     * @param listing               the listing record being sent
     * @param zoneExternalId        the Id for the mailing list that corresponds with the external service
     * @param fromEmail             email sender string
     * @param subject               the string subject line
     * @param htmlText              body text of the email (merge fields for personalization will come in our standard form and need to be processed for the API consumption)
     * @param plainText             plaintext version of the email for old email clients that can't process html (handle personalization merge fields like the html one)
     * @param fromName              name of the sender as a string
     * @param deliveryTime          Datetime for when the emails should be sent. Must be a future date. will need to be processed into however the external API handles date times
     *
     * @author Sam Longo
     */
    public override void sendCampaignEmails(Map<String, Object> params) {

        if (params == null) {
            throw new ConstantContactException('Error sending email. params were null');
        }

        ucinn_portal_Listing__c listingRecord = (ucinn_portal_Listing__c) params?.get(PORTAL_API_EmailHubBase.LISTING_KEY);
        String htmlText = (String) params?.get(PORTAL_API_EmailHubBase.HTML_KEY);

        if (listingRecord == null) {
            throw new ConstantContactException('Error sending email. listing Record was not defined');
        }

        //add the tracking image to the email
        htmlText = '[[trackingImage]]' + htmlText;
        params?.put(PORTAL_API_EmailHubBase.HTML_KEY, htmlText);

        if (String.isBlank(listingRecord.External_Email_API_Id__c)) {
            //this listing is new so there is no associated campaign yet
            createCampaign(params);
        }

        //once the campaign and email have been created, now we can set the rest of the details
        updateCampaign(params);


        //now that the email is ready, schedule to be sent
        scheduleCampaign(params);
    }

    /**
     * creates an email campaign on constantcontact
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     *
     * @param listing               the listing record being sent, must include Name and Id fields
     * @param fromEmail             email sender string
     * @param subject               the string subject line
     * @param htmlText              body text of the email (merge fields for personalization will come in our standard form and need to be processed for the API consumption)
     * @param plainText             plaintext version of the email for old email clients that can't process html (handle personalization merge fields like the html one)
     * @param fromName              name of the sender as a string
     */
    private void createCampaign(Map<String, Object> params) {

        ucinn_portal_Listing__c listingRecord = (ucinn_portal_Listing__c) params?.get(PORTAL_API_EmailHubBase.LISTING_KEY);
        String fromEmail = (String) params?.get(PORTAL_API_EmailHubBase.FROM_EMAIL_KEY);
        String subject = (String) params?.get(PORTAL_API_EmailHubBase.SUBJECT_KEY);
        String htmlText = (String) params?.get(PORTAL_API_EmailHubBase.HTML_KEY);
        String plainText = (String) params?.get(PORTAL_API_EmailHubBase.PLAIN_TEXT_KEY);
        String fromName = (String) params?.get(PORTAL_API_EmailHubBase.FROM_NAME_KEY);

        if (listingRecord == null) {
            throw new ConstantContactException('Error sending email. listing Record was not defined');
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(CAMPAIGNS_ENDPOINT);
        request.setMethod('POST');

        String creationBody = '\'{\'"name":"{0}", "email_campaign_activities":[\'{\'"format_type":5, "from_name":"{1}", "from_email":"{2}", "reply_to_email":"{2}", "subject":"{3}", "html_content":{4}\'}\']\'}\'';
        creationBody = String.format(creationBody,new List<Object> {listingRecord.Id + ' - ' + listingRecord.Name, fromName, fromEmail, subject, JSON.serialize(htmlText)});
        request.setBody(creationBody);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            listingRecord.Error_Message__c = 'There was an error with creating a campaign in constantContact. error code: ' + response.getStatusCode();
            listingToUpdate = listingRecord;
            throw new ConstantContactException('There was an error with creating a campaign in constantContact. error code: ' + response.getStatusCode());
        }

        Map<String, Object> creationResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> creationData = (List<Object>) creationResult?.get('campaign_activities');
        String externalEmailId = (String)(((Map<String,Object>) creationData[0])?.get('campaign_activity_id'));

        if (String.isBlank(externalEmailId)) {
            listingRecord.Error_Message__c = 'There was an error with creating a campaign in constantContact. error code: ' + response.getStatusCode();
        }

        //set external id here since even if the code fails later in this transaction we still need to stash the external id
        listingRecord.External_Email_API_Id__c = externalEmailId;
        listingToUpdate = listingRecord;
    }

    /**
     * updates an email campaign on constantcontact.
     * in particular this is where the actual data like html content is added to the email
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     *
     * @param listing               the listing record being sent, must include External_Email_API_Id__c and Id fields
     * @param zoneExternalId        the Id for the mailing list that corresponds with the external service
     * @param fromEmail             email sender string
     * @param subject               the string subject line
     * @param htmlText              body text of the email (merge fields for personalization will come in our standard form and need to be processed for the API consumption)
     * @param plainText             plaintext version of the email for old email clients that can't process html (handle personalization merge fields like the html one)
     * @param fromName              name of the sender as a string
     */
    private void updateCampaign(Map<String, Object> params) {

        ucinn_portal_Listing__c listingRecord = (ucinn_portal_Listing__c) params?.get(PORTAL_API_EmailHubBase.LISTING_KEY);
        String zoneExternalId = (String) params?.get(PORTAL_API_EmailHubBase.ZONE_EXTERNAL_ID_KEY);
        String fromEmail = (String) params?.get(PORTAL_API_EmailHubBase.FROM_EMAIL_KEY);
        String subject = (String) params?.get(PORTAL_API_EmailHubBase.SUBJECT_KEY);
        String htmlText = (String) params?.get(PORTAL_API_EmailHubBase.HTML_KEY);
        String plainText = (String) params?.get(PORTAL_API_EmailHubBase.PLAIN_TEXT_KEY);
        String fromName = (String) params?.get(PORTAL_API_EmailHubBase.FROM_NAME_KEY);

        if (listingRecord == null || String.isBlank(listingRecord.External_Email_API_Id__c)) {
            throw new ConstantContactException('Error sending email. listing Record External Id was not defined');
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(CAMPAIGNS_ENDPOINT + 'activities/' + listingRecord.External_Email_API_Id__c);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');

        String updateBody = '\'{\'"campaign_activity_id":"{0}", "contact_list_ids":["{1}"], "from_name":"{2}", "from_email":"{3}", "reply_to_email":"{3}", "subject":"{4}", "html_content":{5}, "document_properties": \'{\'"text_content":{6} \'}}\'';
        updateBody = String.format(updateBody,new List<Object> {listingRecord.External_Email_API_Id__c, zoneExternalId, fromName, fromEmail, subject, JSON.serialize(htmlText), JSON.serialize(plainText)});
        request.setBody(updateBody);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {

            listingRecord.Error_Message__c = 'There was an error with updating a ConstantContact campaign after creation. error code: ' + response.getStatusCode();
            listingToUpdate = listingRecord;
            throw new ConstantContactException('There was an error with updating a ConstantContact campaign after creation. error code: ' + response.getStatusCode());
        }
    }

    /**
     * schedules an email campaign in constantcontact.
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     *
     * @param listing                                       The listing record to be scheduled. expected to include the field External_Email_API_Id__c.
     * @param deliveryTime                                  DateTime for when this email should be scheduled to be sent. Give at least a minute buffer for sending "now"
     */
    private void scheduleCampaign(Map<String, Object> params) {

        ucinn_portal_Listing__c listingRecord = (ucinn_portal_Listing__c) params?.get(PORTAL_API_EmailHubBase.LISTING_KEY);

        if (listingRecord == null || String.isBlank(listingRecord.External_Email_API_Id__c)) {
            throw new ConstantContactException('Error sending email. listing Record was not defined');
        }

        Datetime deliveryTime = (Datetime) params?.get(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_PREFIX + 'emails/activities/' + listingRecord.External_Email_API_Id__c + '/schedules');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        //converts date time to ISO 8601 format
        String scheduleBody = '{"scheduled_date":"'+ deliveryTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'') +'"}';
        request.setBody(scheduleBody);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            listingRecord.Error_Message__c = 'There was an error with scheduling a ConstantContact campaign. error code: ' + response.getStatusCode();
            listingToUpdate = listingRecord;
            throw new ConstantContactException('There was an error with scheduling a ConstantContact campaign. error code: ' + response.getStatusCode());
        }

        //on a successful scheduling we want to set the listingRecord to 'Scheduled' or 'published'
        if (deliveryTime < Datetime.now().addMinutes(30)) {
            listingRecord.Is_Newsletter_Sent__c = true;
            listingRecord.Status__c = 'Published';
        } else {
            listingRecord.Status__c = 'Scheduled';
        }

        // set the time it was scheduled
        if (String.isBlank(listingRecord.Time_Zone__c)) {
            listingRecord.Time_Zone__c = PORTAL_CONST_Global.DEFAULT_TIME_ZONE;
        }
        listingRecord.Start_Date_Time__c = deliveryTime;
        listingToUpdate = listingRecord;
    }

    /**
     * collects metrics from service and stores them onto a campaign object
     *
     * @param newsletterId          the id for the email stored in salesforce
     * @param externalEmailId       The id for the email stored in the constantcontact
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    public override void updateMetrics(Map<String, Object> params) {

        String newsletterId = (String) params?.get(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY);
        String externalEmailActivityId = (String) params?.get(PORTAL_API_EmailHubBase.EXTERNAL_EMAIL_ID_KEY);

        if (String.isBlank(externalEmailActivityId) || String.isBlank(newsletterId)) {
            throw new ConstantContactException('Attempted to collect metrics for a listing with no external email id.');
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_PREFIX + 'reports/stats/email_campaign_activities/' + externalEmailActivityId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            listingToUpdate = new ucinn_portal_Listing__c(Id = newsletterId, Error_Message__c = 'Error collecting metrics.');
            throw new ConstantContactException('There was an error with retrieving metrics. Error code: ' + response.getStatusCode());
        }

        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        List<Object> results = (List<Object>) data.get('results');
        Map<String, Object> result = (Map<String, Object>)results[0];
        Map<String, Object> statsMap = (Map<String, Object>)result.get('stats');

        Campaign newsletterCampaign = new Campaign();
        newsletterCampaign.Name = newsletterId + ' Metrics';

        List<Campaign> matchingCampaignList = [SELECT Id FROM Campaign WHERE Name = :newsletterCampaign.Name];

        if (!matchingCampaignList.isEmpty()) {
            newsletterCampaign = matchingCampaignList.get(0);
        } else {
            //newly created campaign so we want to also include the lookup from the listing to the campaign
            //the lookup id itself will be defined in the dml call since the campaign doesn't have an Id yet
            //we want to include a campaign lookup on the listing, but we cannot do that until the campaign is upserted
            listingToUpdate = new ucinn_portal_Listing__c(Id = newsletterId);
        }


        for (String eachMetric : metricsMap.keySet()) {
            if (statsMap.containsKey(eachMetric) && String.isNotBlank(metricsMap.get(eachMetric))) {
                newsletterCampaign.put(metricsMap.get(eachMetric), Integer.valueOf(statsMap.get(eachMetric)));
            }
        }

        campaignToUpsert = newsletterCampaign;
    }

    /**
     * constructs an unsubscribe URL for this service
     *
     * @param newsletterId        the id for the email stored in salesforce
     */
    public override String getUnsubscribeUrl(Map<String, Object> params) {
        String newsletterId = (String) params?.get(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY);

        return (PORTAL_CommunityUtils.getPortalURL().removeEnd('/') + PORTAL_CONST_CommunityUrls.UNSUBSCRIBE_URL + '?rid=' + newsletterId + '&email=[[EmailAddress]]');
    }

    /**
     * called at the end of the transaction regardless if an error occurred in order to do DML updates and inserts.
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    public override void performDML(Map<String, Object> params) {

        if (!changedContactMap.isEmpty()) {
            update changedContactMap.values();
        }

        if (!changedZoneMap.isEmpty()) {
            update changedZoneMap.values();
        }

        if (campaignToUpsert != null) {
            upsert campaignToUpsert;
            if (listingToUpdate != null) {
                listingToUpdate.Newsletter_Metrics__c = campaignToUpsert.Id;
            }
        }
        if (listingToUpdate != null) {
            update listingToUpdate;
        }

        //the batch callouts need to be at the end instead of when created for same DML issue as the rest
        if (!batchContactIds.isEmpty() && !Test.isRunningTest()) {
            Database.executeBatch(new PORTAL_BATCH_EmailApiContacts(batchContactIds), MAX_RECORD_PER_BATCH);
        }

        if (!batchZoneIds.isEmpty() && !Test.isRunningTest()) {
            Database.executeBatch(new PORTAL_BATCH_EmailApiZones(batchZoneIds), MAX_RECORD_PER_BATCH);
        }
    }
}