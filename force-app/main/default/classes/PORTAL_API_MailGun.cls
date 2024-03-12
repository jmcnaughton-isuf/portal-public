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
* Api implementation for Mailgun, a transactional email api used to send out
* newsletters
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/

public inherited sharing class PORTAL_API_MailGun extends PORTAL_EmailInterface {

    public static final String BASE_DOMAIN = 'callout:Mailgun/';
    //TODO move this hash to an organization setting
    public static final String EMAIL_ENDPOINT =  BASE_DOMAIN + 'messages';
    public static final String TAG_ENDPOINT = BASE_DOMAIN + 'tags';
    public static final String STATS_CONST = 'stats';
    public static final String TOTAL_CONST = 'total';
    public static final String PERMANENT_CONST = 'permanent';
    public static final String TEMPORARY_CONST = 'temporary';

    public Map<String, String> mergeFieldMap = new Map<String, String>();

    Map<String, String> metricsTypeToField = new Map<String, String>{'delivered' => 'ucinn_portal_Number_of_Delivered_Emails__c',
                                                                        'failed' => 'ucinn_portal_Number_Of_Failed_Emails__c',
                                                                        'opened' => 'ucinn_portal_Number_of_Email_Opens__c',
                                                                        'clicked' => 'ucinn_portal_Number_of_Email_Clicks__c',
                                                                        'unsubscribed' => 'ucinn_portal_Number_of_Email_Unsubscribe__c',
                                                                        'complained' =>  'ucinn_portal_Number_of_Spam_Reports__c'};

    private List<Campaign> campaignsToUpsert = new List<Campaign>();

    private final Integer TIMEOUT = 120000;

    public class MailgunException extends Exception{}


    /**
    * constructor that gets the merge fields from the custom metadata
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public PORTAL_API_MailGun() {
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Id, (SELECT Field_API_Name__c, Front_End_Field_Value__c
                                                                    FROM Portal_Section_Field_Settings__r)
                                                                    FROM Portal_Page_Section_Setting__mdt
                                                                    WHERE Page_Name__c = :PORTAL_CONST_Newsletter.NEWSLETTER_SUBMISSION_PAGE_NAME
                                                                    AND Page_Main_Section__c = :PORTAL_CONST_Newsletter.MERGE_FIELDS_MAIN_SECTION
                                                                    AND Page_Sub_Section__c = :PORTAL_CONST_Newsletter.MAILGUN_CONST];
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        if (!sectionSettingList.isEmpty()) {
            List<Portal_Section_Field_Setting__mdt> fieldSettingList = sectionSettingList.get(0).Portal_Section_Field_Settings__r;
            if (fieldSettingList != null) {
                for (Portal_Section_Field_Setting__mdt eachFieldSetting : fieldSettingList) {
                    if (String.isNotBlank(eachFieldSetting.Field_API_Name__c) && String.isNotBlank(eachFieldSetting.Front_End_Field_Value__c)) {
                        mergeFieldMap.put(eachFieldSetting.Field_API_Name__c, eachFieldSetting.Field_API_Name__c);
                    }
                }
            }
        }
    }

    public override String getUnsubscribeUrl(Map<String, Object> params) {
        String newsletterId = (String) params?.get(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY);

        return (PORTAL_CommunityUtils.getPortalURL().removeEnd('/') + PORTAL_CONST_CommunityUrls.UNSUBSCRIBE_URL + '?rid=' + newsletterId + '&cid=%recipient.Id%');
    }

    /**
    * Method that returns the fact that this api is a transactional email api
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    *
    * @return                                  True since this is a transactional api
    */
    public override Boolean isTransactionalEmailAPI(Map<String, Object> params) {
        return true;
    }

    /**
    * Method that will send out emails to a list of constituents through the Mailgun api
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    *
    * @param contactList:                      The list of contacts (queried with their mergefields) to send to
    * @param fromEmail:                        The email we want to use to send from
    * @param newsletterId:                     The newsletter id
    * @param zoneName:                         The zone we are sending from
    * @param subject:                          The subject of the email
    * @param htmlText:                         The html text for the email
    * @param plainText:                        The email as plain text
    * @param deliveryTime:                     The time we want to send out
    */

    public override void sendTransactionalEmail(Map<String, Object> params) {

        List<Contact> contactList = (List<Contact>) params?.get(PORTAL_API_EmailHubBase.CONTACT_LIST_KEY);
        String fromEmail = (String) params?.get(PORTAL_API_EmailHubBase.FROM_EMAIL_KEY);
        String newsletterId =  (String) params?.get(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY);
        String zoneName = (String) params?.get(PORTAL_API_EmailHubBase.ZONE_NAME_KEY);
        String subject = (String) params?.get(PORTAL_API_EmailHubBase.SUBJECT_KEY);
        String htmlText = (String) params?.get(PORTAL_API_EmailHubBase.HTML_KEY);
        String plainText = (String) params?.get(PORTAL_API_EmailHubBase.PLAIN_TEXT_KEY);
        Datetime deliveryTime = (Datetime) params?.get(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY);

        if (contactList == null || contactList.isEmpty() || String.isBlank(fromEmail) || String.isBlank(newsletterId)
            || String.isBlank(zoneName) || String.isBlank(subject) || String.isBlank(htmlText) || String.isBlank(plainText) || deliveryTime == null) {
                throw new MailgunException('The parameters are invalid for sending out a newsletter.');
        }


        //mailgun does merge fields by associating the merge field with the contact's email and then map the merge field label with the value
        Map<String, Map<String, Object>> emailToRecipientVariablesMap = getRecipientVariables(contactList);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(EMAIL_ENDPOINT);
        request.setHeader('Content-Type', PORTAL_MultiFormEncoder.GetContentType());
        request.setTimeout(TIMEOUT);

        String contactEmailListString = String.join(new List<String>(emailToRecipientVariablesMap.keySet()), ',');
        String recipientVariablesString = System.JSON.serialize(emailToRecipientVariablesMap);
        String formattedDeliveryTime = formatDateTime(deliveryTime);

        String body = '';

        Map<String, String> deliveryParameters = new Map<String, String>();
        deliveryParameters.put('from', fromEmail);
        deliveryParameters.put('subject', subject);
        deliveryParameters.put('to', contactEmailListString);
        deliveryParameters.put('text', plainText);
        deliveryParameters.put('html', htmlText);
        deliveryParameters.put('o:tag', newsletterId);
        deliveryParameters.put('recipient-variables', recipientVariablesString);
        deliveryParameters.put('o:deliverytime', formattedDeliveryTime);
        deliveryParameters.put('o:tracking', 'true');
        deliveryParameters.put('o:tracking-clicks', 'true');
        deliveryParameters.put('o:tracking-opens', 'true');

        body = multiFormFormatBody(body, deliveryParameters);

        body += PORTAL_MultiFormEncoder.writeBoundary('');

        Blob bodyAsBlob = Blob.valueof(body);

        //Need to turn into a blob in order to get content-length
        string contentLength = string.valueOf(bodyAsBlob.size());

        request.setBodyAsBlob(bodyAsBlob);
        request.setHeader('Content-Length', contentLength);


        if (!Test.isRunningTest()) {
            HttpResponse response = http.send(request);

            //throw an error for the batch to handle
            if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
                System.debug(response.getStatus());
                System.debug(response.getBody());
                System.debug(response.getStatusCode());
                throw new MailgunException('Could not send the email through the API.');
            }
        }

    }

    /**
    * Method that formats the delivery time as a mailgun parameter
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    *
    * @param deliveryTime:                     the time we want to send the newsletter
    * @return                                  the delivery time formatted as a string for mailgun
    */

    private String formatDateTime(Datetime deliveryTime) {
        //mailgun format is day of the week, day, month, year, and time in gmt (Example: 'Thu, 13 Oct 2011 18:02:00 GMT')
       String formattedDate = '{0}, {1} {2} {3} {4} GMT';
       List<Object> dateFields = new List<Object>{getDayOfWeek(deliveryTime),
                                                  deliveryTime.dayGMT(),
                                                  deliveryTime.format('MMM'),
                                                  deliveryTime.year(),
                                                  formatTime(deliveryTime.hourGmt(), deliveryTime.minuteGmt(), deliveryTime.secondGmt())};
        return String.format(formattedDate, dateFields);
    }

    /**
    * Method that gets the the day of the week for the delivery time
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @param deliveryTime:                     the time we want to send the newsletter
    * @return                                  the shorthand version of the day of the week
    */
    private String getDayOfWeek(DateTime deliveryTime) {
        //must format the date based on gmt (so add or remove days to get the right gmt date);
        if (deliveryTime.day() < deliveryTime.dayGmt()) {
            return deliveryTime.addDays(1).format('E');
        } else if (deliveryTime.day() > deliveryTime.dayGmt()) {
            return deliveryTime.addDays(-1).format('E');
        }
        return deliveryTime.format('E');
    }

    /**
    * Method that gets a time and formats it in a way for mailgun to read
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @param deliveryTime:                     the time we want to send the newsletter
    * @return                                  the time in a mailgun format
    */
    private String formatTime(Integer hour, Integer minute, Integer second) {
        String formattedTime = '{0}:{1}:{2}';
        String hourString = '';
        if (hour < 10) {
            hourString = '0';
        }
        hourString += String.valueOf(hour);
        String minuteString = '';
        if (minute < 10) {
            minuteString = '0';
        }
        minuteString += String.valueOf(minute);
        String secondString = '';
        if (second < 10) {
            secondString = '0';
        }
        secondString += String.valueOf(second);
        return String.format(formattedTime, new List<Object>{hourString, minuteString, secondString});
    }

    /**
    * Method that maps a contact's email to a map of merge fields and the contact's information for those merge fields
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @param contactList:                      the list of contacts to get the data from
    * @return                                  map of email to map of mergefield and value
    */
    private Map<String, Map<String, Object>> getRecipientVariables(List<Contact> contactList) {

        Map<String, Map<String, Object>> returnMap = new  Map<String, Map<String, Object>>();

        for (Contact eachContact : contactList) {
            if (String.isNotBlank(eachContact.Email)) {
                Map<String, Object> contactFieldMap = new Map<String, Object>();
                for (String mergeField : this.mergeFieldMap.keySet()) {
                    if (eachContact.get(mergeFieldMap.get(mergeField)) == null) {
                        contactFieldMap.put(mergeField, '');
                    } else {
                        contactFieldMap.put(mergeField, eachContact.get(mergeFieldMap.get(mergeField)));
                    }
                }
                returnMap.put(eachContact.Email, contactFieldMap);
            }

        }

        return returnMap;
    }

    /**
    * Method that updates the metrics for a specific newsletter (newsletters are tagged by the id in the api)
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @param newsletterId:                     newsletter Id
    */
    public override void updateMetrics(Map<String, Object> params) {

        String newsletterId = (String) params.get(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY);

        Campaign newsletterCampaign = new Campaign();
        newsletterCampaign.Name = newsletterId + ' Metrics';

        List<Campaign> matchingCampaigns = [SELECT Id FROM Campaign WHERE Name = :newsletterCampaign.Name];

        if (!matchingCampaigns.isEmpty()) {
            newsletterCampaign = matchingCampaigns.get(0);
        }

        Http http = new Http();

        for (String eachMetric : metricsTypeToField.keySet()) {
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');

            String endpoint = TAG_ENDPOINT + '/' + newsletterId + '/stats?event=' + eachMetric;

            request.setEndpoint(endpoint);
            // request.setHeader('Content-Type', PORTAL_MultiFormEncoder.GetContentType());
            // request.setTimeout(TIMEOUT);

            // String body = '';
            // body = multiFormFormatBody(body, new Map<String, String>{'event' => eachMetric});
            // body += PORTAL_MultiFormEncoder.writeBoundary('');

            // blob formBlob = Blob.valueOf(body);
            // string contentLength = string.valueOf(formBlob.size());

            // request.setBodyAsBlob(formBlob);
            // request.setHeader('Content-Length', contentLength);

            if (!Test.isRunningTest()) {
                HttpResponse response = http.send(request);

                if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                    Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                    Integer metricStats = getStatsForMetric(data, eachMetric);

                    if (metricStats != null) {
                        newsletterCampaign.put(metricsTypeToField.get(eachMetric), metricStats);
                    }
                }
            }
        }

        campaignsToUpsert.add(newsletterCampaign);
    }

    public static Integer getStatsForMetric(Map<String, Object> dataMap, String metric) {
        if (dataMap == null || dataMap.isEmpty() || String.isBlank(metric) || !dataMap.containsKey(STATS_CONST)) {
            return null;
        }

        Integer resultInteger = 0;

        List<Object> statsList = (List<Object>)dataMap.get(STATS_CONST);

        for (Object eachStat : statsList) {
            Map<String, Object> eachStatMap = (Map<String, Object>)eachStat;

            if (!eachStatMap.containsKey(metric)) {
                continue;
            }

            resultInteger = resultInteger + getTotalFromStatMap((Map<String, Object>)eachStatMap.get(metric));
        }

        return resultInteger;
    }

    private static Integer getTotalFromStatMap(Map<String, Object> statMap) {
        Integer resultInteger = 0;

        if (statMap.containsKey(TOTAL_CONST)) {
            resultInteger = Integer.valueOf(statMap.get(TOTAL_CONST));

            return resultInteger;
        }

        if (statMap.containsKey(PERMANENT_CONST)) {
            resultInteger = resultInteger + Integer.valueOf(((Map<String, Object>)statMap.get(PERMANENT_CONST)).get(TOTAL_CONST));
        }

        if (statMap.containsKey(TEMPORARY_CONST)) {
            resultInteger = resultInteger + Integer.valueOf(((Map<String, Object>)statMap.get(TEMPORARY_CONST)).get(TOTAL_CONST));
        }

        return resultInteger;
    }

    /**
    * Method that deletes a tag for a newsletter once the time for metrics is passed since we
    * the api can only hold a certain amount of tags at a time
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @param newsletterId:                     newsletter Id
    */
    public Boolean deleteTag(String newsletterId) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint(TAG_ENDPOINT + '/' + newsletterId);
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(TIMEOUT);

        if (!Test.isRunningTest()) {

            HttpResponse response = http.send(request);
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                return true;
            }
        } else {
            return true;
        }

        return false;
    }

    /**
    * Method that formats the body for mailgun
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    * @param body:                             the current body for the http request
    * @param deliveryParameters:               Map of the mailgun parameters to the values we want to pass in for those parameters
    * @return                                  multiform/part encoded body string
    */
    private String multiFormFormatBody(String body, Map<String, String> deliveryParameters) {

        for (String param : deliveryParameters.keySet()) {
            body += PORTAL_MultiFormEncoder.writeBoundary(null);
            body += PORTAL_MultiFormEncoder.writeBodyParameter(param, deliveryParameters.get(param));
        }

        return body;
    }


    /**
    * Method that upserts the campaigns (done after we are done with all of our api calls)
    *
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public override void performDML(Map<String, Object> params) {
        if (campaignsToUpsert != null && !campaignsToUpsert.isEmpty()) {
            upsert campaignsToUpsert;
        }
    }
}