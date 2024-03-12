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
 * hub for abstracting the interface between the rest of the code and the email API implementation
 *
 * @author Sam Longo
 * @version     1.0
 * @since       1.0
 */
global virtual class PORTAL_API_EmailHubBase {

    public static PORTAL_EmailInterface emailApi = null; //only public so tests can set it

    global static final String CONSTANTCONTACT_KEY = 'ConstantContact';
    global static final String MAILGUN_KEY = 'Mailgun';

    public static final String CONTACT_LIST_KEY = 'contactList';
    public static final String LISTING_KEY = 'listing';
    public static final String FROM_EMAIL_KEY = 'fromEmail';
    public static final String ZONE_NAME_KEY = 'zoneName';
    public static final String SUBJECT_KEY = 'subject';
    public static final String ZONE_EXTERNAL_ID_KEY = 'zoneExternalId';
    public static final String HTML_KEY = 'htmlText';
    public static final String PLAIN_TEXT_KEY = 'plainText';
    public static final String DELIVERY_TIME_KEY = 'deliveryTime';
    public static final String FROM_NAME_KEY = 'fromName';
    public static final String NEWSLETTER_ID_KEY = 'newsletterId';
    public static final String EXTERNAL_EMAIL_ID_KEY = 'externalEmailId';
    public static final String ZONE_LIST_KEY = 'zoneList';
    public static final String EXTERNAL_CONTACT_IDS_KEY = 'externalContactIds';
    public static final string API_TYPE_DEVELOPER_NAME = 'Email_API_Type';
    public static final String MAILGUN_ID_MERGE_FIELD = '%recipient.contactId%';
    public static final String CONSTANTCONTACT_ID_MERGE_FIELD = '';

    global class EmailApiException extends Exception {}

    /**
     * Determines which API to use based on custom metadata settings.
     * Will throw an error if it cannot determine which API you want to use.
     * override this to use other apis
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    public virtual void getEmailInterface() {
        if (emailApi != null) {
            return; //don't need to query again this transaction because it was already retrieved
        }

        if (Test.isRunningTest()) {
            emailApi = new PORTAL_API_TestEmailApi();
            return;
        }

        String emailServiceType = getEmailApiService();

        if (CONSTANTCONTACT_KEY.equalsIgnoreCase(emailServiceType)) {
            emailApi = new PORTAL_API_ConstantContact();
        } else if (MAILGUN_KEY.equalsIgnoreCase(emailServiceType)) {
            emailApi = new PORTAL_API_MailGun();
        } else {
            throw new EmailApiException('This type of Email API is not supported. Error Code: 801.');
        }
    }

    /**
     * gets an instance of the apihubbase with overrides if defined by custom metadata
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    public static PORTAL_API_EmailHubBase getEmailHub() {
        return (PORTAL_API_EmailHubBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
            PORTAL_Utils.CLASS_TYPE => PORTAL_API_EmailHubBase.Class});
    }

     /**
     * Gets the merge field for the unsubscribe url per api since they may have
     * different ways of defining a path and URL params for the link
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static String getUnsubscribeUrl(map<String, Object> params) {
        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();

        return emailApi.getUnsubscribeUrl(params);
    }

     /**
     * Gets the api we are using from the custom metadata
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static String getEmailApiService() {
        String emailServiceType = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => API_TYPE_DEVELOPER_NAME});

        if (String.isBlank(emailServiceType)) {
            throw new EmailApiException('Please set the Email API type and make sure there is only one value. Error Code: 800.');
        }
        return emailServiceType;
    }

    /**
     * determines whether the service is transactional or campaign and calls or initiates a batch correspondingly
     *
     * @param newsletterId          record Id of the newsletter being scheduled
     * @param deliveryTime          Datatime for when the email should be sent. Usually will be datetime.now() + some buffer
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static void scheduleEmail(Map<String, Object> params) {
        Id newsletterId = (Id) params?.get(NEWSLETTER_ID_KEY);
        Datetime deliveryTime = (Datetime) params?.get(DELIVERY_TIME_KEY);

        if (newsletterId == null) {
            throw new EmailApiException('Error scheduling email. newsletter id was not passed as a param');
        }

        if (deliveryTime == null) {
            throw new EmailApiException('Error scheduling email.  Delivery time was not passed as a param');
        }


        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();

        try {

            if (emailApi.isTransactionalEmailAPI(new Map<String, Object>()) && !Test.isRunningTest()) {
                Database.executeBatch(new PORTAL_BATCH_SendNewsletter(newsletterId, deliveryTime), 900);
                return;
            }

            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            String htmlText = '';
            if (!Test.isRunningTest()) {
                htmlText = controller.parseNewsletterHTML(new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => newsletterId});
            }
            String plainText = '';
            if (!Test.isRunningTest()) {
                plainText = controller.parseNewsletterPlainText(new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => newsletterId});
            }

            List<ucinn_portal_Listing__c> listingList = [SELECT Id, External_Email_API_Id__c, Portal_Zone__c, Name, Actual_Start_Date_Time__c, Time_Zone__c FROM ucinn_portal_Listing__c WHERE Id = :newsletterId];
            if (listingList.isEmpty()) {
                throw new EmailApiException('No listing was found.');
            }
            ucinn_portal_Listing__c listing = listingList[0];

            //there is an assumption that a newsletter is only associated with 1 zone
            List<ucinn_portal_Zone__c> zoneList = [SELECT Id, Name, External_Email_API_Id__c, Email__c FROM ucinn_portal_Zone__c WHERE Name = :listing.Portal_Zone__c];
            if (zoneList.isEmpty()) {
                throw new EmailApiException('No listing was found.');
            }
            ucinn_portal_Zone__c zone = zoneList[0];

            String fromName = zone.Name;
            if (zone.Name == PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME) {
                //since it would look weird to recieve an email from someone named 'All' we replace with org name
                fromName = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => PORTAL_NewsletterControllerBase.ORGANIZATION_METADATA_DEVELOPER_NAME});
            }

            params.put(LISTING_KEY, listing);
            params.put(ZONE_EXTERNAL_ID_KEY, zone.External_Email_API_Id__c);
            params.put(FROM_EMAIL_KEY, zone.Email__c);
            params.put(SUBJECT_KEY, listing.Name);
            params.put(HTML_KEY, htmlText);
            params.put(PLAIN_TEXT_KEY, plainText);
            params.put(FROM_NAME_KEY, fromName);
            params.put(DELIVERY_TIME_KEY, deliveryTime);

            if (!Test.isRunningTest()) {
                emailApi.sendCampaignEmails(params);
                emailApi.performDML(new Map<String, Object>());
            }
        } catch (Exception e) {
            emailApi.performDML(new Map<String, Object>()); //this needs to run even when an error occurs
            System.debug('error caught for schedule email: ' + e);
        }
    }

    /**
     * generally called from a batch only, for a transactional email service, sends segments of the email list
     *
     * @param contactList           list of contacts
     * @param fromEmail             email sender string
     * @param zoneName              String representation of the zone name
     * @param subject               string subject line
     * @param htmlText              body text of the email (merge fields for personalization will come in our standard form and need to be processed for the API consumption)
     * @param plainText             plaintext version of the email for old email clients that can't process html (handle personalization merge fields like the html one)
     * @param deliveryTime          Datetime for when the emails should be sent. Must be a future date. will need to be processed into however the external API handles date times
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static void scheduleTransactionalEmail(Map<String, Object> params) {
        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();
        emailApi.sendTransactionalEmail(params);
    }

    /**
     * aborts the currently running job connected to this newsletter setting it to no longer be sent
     *
     * @param newsletterId           the newsletter being aborted
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static void unscheduleEmail(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        if (String.isBlank(newsletterId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Attempted to unschedule an email without passing newsletter Id'});
        }

        List<ucinn_portal_Listing__c> newsletterList = [SELECT Id, Scheduled_Job_Id__c, Status__c FROM ucinn_portal_Listing__c WHERE Id = :newsletterId];
        if (!newsletterList.isEmpty()) {
            ucinn_portal_Listing__c abortListing = newsletterList.get(0);
            if (abortListing != null && abortListing.Status__c == PORTAL_NewsletterControllerBase.SCHEDULED_STATUS && String.isNotBlank(abortListing.Scheduled_Job_Id__c)) {
                System.abortJob(abortListing.Scheduled_Job_Id__c);
                abortListing.Status__c = 'Unscheduled';
                abortListing.Scheduled_Job_Id__c = '';
                update abortListing;
            } else {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error: attempted to unschedule an email that was not scheduled'});
            }
        }
    }


    /**
     * future method for handling putting lists in external campaign service from zone trigger
     * @param zoneIds           the set of zone Ids being processed
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    @future(callout=true)
    global static void createOrUpdateExternalMailingLists(Set<Id> zoneIds) {
        createOrUpdateExternalMailingListsNonFuture(zoneIds);
    }


    /**
     * non future version which can be called by batch classes
     * handls putting lists in external campaign service
     *
     * @param zoneIds           the set of zone Ids being processed
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static void createOrUpdateExternalMailingListsNonFuture(Set<Id> zoneIds) {
        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();

        try {
            PORTAL_CommunityUtils.throwTestException(null);
            List<ucinn_portal_Zone__c> zoneList = [SELECT Id, External_Email_API_Id__c, Name FROM ucinn_portal_Zone__c WHERE Id IN :zoneIds];

            Map<String, Object> params = new Map<String, Object>();
            params.put(ZONE_LIST_KEY, zoneList);

            emailApi.createOrUpdateExternalMailingLists(params);
        } catch (Exception e) {
            System.debug('error caught for create or update lists: ' + e);
        }

        emailApi.performDML(new Map<String, Object>());
    }

    /**
     * updates a set of contacts on the external email service from trigger
     *
     * @param contactIds           the set of contact Ids being processed
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    @future(callout=true)
    global static void addOrUpdateContactsToExternalApi(Set<Id> contactIds) {
        addOrUpdateContactsToExternalApiNonFuture(contactIds);
    }

    /**
     * non future version which can be called by batch classes
     * updates a set of contacts on the external email service
     *
     * @param contactIds           the set of contact Ids being processed
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static void addOrUpdateContactsToExternalApiNonFuture(Set<Id> contactIds) {
        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();

        try {
            PORTAL_CommunityUtils.throwTestException(null);
            List<Contact> contactList = [SELECT Id, ucinn_portal_External_Email_API_Id__c, Email, FirstName, LastName, (SELECT Zone__r.External_Email_API_Id__c FROM ucinn_portal_Zone_Memberships__r WHERE Status__c = :PORTAL_ZoneControllerBase.ACTIVE_CONST) FROM Contact WHERE Id IN :contactIds];

            Map<String, Object> params = new Map<String, Object>();
            params.put(CONTACT_LIST_KEY, contactList);

            emailApi.addOrUpdateContactsToExternalApi(params);
        } catch (Exception e) {
            System.debug('error caught for create or update contacts: ' + e);
        }

        emailApi.performDML(new Map<String, Object>());
    }

    /**
     * deletes a set of contacts from an external email service.
     * takes external Ids
     *
     * @param externalContactIds           the set of external contact Ids being processed
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    @future(callout=true)
    global static void removeContactsFromExternalApi(Set<String> externalContactIds) {
        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();

        try {
            PORTAL_CommunityUtils.throwTestException(null);
            Map<String, Object> params = new Map<String, Object>();
            params.put(EXTERNAL_CONTACT_IDS_KEY, externalContactIds);

            emailApi.removeContactsFromExternalApi(params);
        } catch (Exception e) {
            System.debug('error caught for delete contacts: ' + e);
        }

        emailApi.performDML(new Map<String, Object>());
    }

    /**
     * updates the metrics for a newsletter
     *
     * @param newsletterId              the newsletter being processed
     * @param externalEmailId           the external Id for the newsletter
     *
     * @author Sam Longo
     * @version                                             1.0
     * @since                                               1.0
     */
    global static void updateMetrics(String newsletterId, String externalEmailId) {

        if (String.isBlank(newsletterId)) {
            throw new EmailApiException('No listing Id provided for update metrics.');
        }

        PORTAL_API_EmailHubBase emailHub = getEmailHub();
        emailHub.getEmailInterface();

        try {
            PORTAL_CommunityUtils.throwTestException(null);
            Map<String, Object> params = new Map<String, Object>();
            params.put(NEWSLETTER_ID_KEY, newsletterId);
            params.put(EXTERNAL_EMAIL_ID_KEY, externalEmailId);


            emailApi.updateMetrics(params);
        } catch (Exception e) {
            System.debug('error caught for update metrics: ' + e);
        }

        emailApi.performDML(new Map<String, Object>()); //this needs to run even when an error occurs

    }
}