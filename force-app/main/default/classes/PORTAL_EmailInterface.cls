/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
  * This serves as the interface for all email service integrations to extend.
  */
global abstract class PORTAL_EmailInterface {

    /*     SHARED METHODS      */

    /**
     * used to determine if the api is a transactional based API in order to
     * call the PORTAL_BATCH_SendNewsletter class instead of scheduling the
     * email send through the campaign API
     *
     *
     */
    global abstract Boolean isTransactionalEmailAPI(Map<String, Object> params);

    /**
     * called at the end of the transaction regardless if an error occurred in order to do DML updates and inserts.
     *
     */
    global abstract void performDML(Map<String, Object> params);

    /**
     * collects metrics from service and stores them onto a campaign object
     *
     * @param newsletterId          the id for the email stored in salesforce
     * @param externalEmailId       The id for the email stored in the external service where applicable
     */
    global abstract void updateMetrics(Map<String, Object> params);

    /**
     * constructs an unsubscribe URL for this service
     * handled per api since they may have different url params possible with differing merge fields
     *
     * @param newsletterId        the id for the email stored in salesforce
     */
    global abstract String getUnsubscribeUrl(Map<String, Object> params);


    /*     TRANSACTIONAL SERVICE METHODS    */

    /**
     * Sends information with a subset of contacts for transactional email providers. called several times for one email
     * defaults to doing nothing for campaign services
     *
     * @param contactList           list of contacts
     * @param fromEmail             email sender string
     * @param zoneName              String representation of the zone name
     * @param subject               string subject line
     * @param htmlText              body text of the email (merge fields for personalization will come in our standard form and need to be processed for the API consumption)
     * @param plainText             plaintext version of the email for old email clients that can't process html (handle personalization merge fields like the html one)
     * @param deliveryTime          Datetime for when the emails should be sent. Must be a future date. will need to be processed into however the external API handles date times
     */
    global virtual void sendTransactionalEmail(Map<String, Object> params) {}


    /*     CAMPAIGN SERVICE METHODS     */

    /**
     * sends information for a campaign / mailing list provider to create and schedule an email. called only once for one email
     *
     * defaults to doing nothing for transactional email services
     *
     * @param listing               the listing record being sent
     * @param zoneExternalId        the Id for the mailing list that corresponds with the external service
     * @param fromEmail             email sender string
     * @param subject               the string subject line
     * @param htmlText              body text of the email (merge fields for personalization will come in our standard form and need to be processed for the API consumption)
     * @param plainText             plaintext version of the email for old email clients that can't process html (handle personalization merge fields like the html one)
     * @param fromName              name of the sender as a string
     * @param deliveryTime          Datetime for when the emails should be sent. Must be a future date. will need to be processed into however the external API handles date times
     */
    global virtual void sendCampaignEmails(Map<String, Object> params) {

    }

    /**
     * for a campaign service, takes contacts and stores them onto the external service to add them to mailing list
     * note this this requires the mailing lists for the contact to exist on the external service
     *
     * defaults to doing nothing for a transactional service
     *
     * @param contactList          List<contact> records being created and updated
     */
    global virtual void addOrUpdateContactsToExternalApi(Map<String, Object> params) {}

    /**
     * for a campaign service, takes a set of external Ids and deletes the contacts associated with them
     * used in order to reduce contact counts for contacts that are no longer applicable
     *
     * defaults to doing nothing for a transactional service
     *
     * @param externalContactIds          Set<String> external Ids for contacts to delete
     */
    global virtual void removeContactsFromExternalApi(Map<String, Object> params) {}

    /**
     * for a campaign service, takes the zones and creates a mailing lists for it
     *
     * defaults to doing nothing for a transactional service
     *
     * @param zoneList          List<ucinn_portal_Zone__c> record for the zone(s) being created and updated
     */
    global virtual void createOrUpdateExternalMailingLists(Map<String, Object> params) {}
}