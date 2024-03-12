/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Contains utility functions for volunteer functionality.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public without sharing class PORTAL_UTIL_Volunteers {
    public static final String VOLUNTEER_FIRST_NAME = 'volunteerFirstName';
    public static final String VOLUNTEER_LAST_NAME = 'volunteerLastName';
    public static final String VOLUNTEER_EMAIL = 'volunteerEmail';
    public static final String VOLUNTEER_SHIFT_ID = 'volunteerShiftId';
    public static final String VOLUNTEER_BIO_INFO_MAP = 'volunteerBioInfoMap';

    public static final String VOLUNTEER_LIST = 'volunteerList';
    public static final String VOLUNTEER_RECORD = 'volunteerRecord';
    public static final String USER_RECORD = 'userRecord';
    public static final String SENDER_DISPLAY_NAME = 'senderDisplayName';
    public static final String EMAIL_TEMPLATE_RECORD = 'emailTemplateRecord';

    /**
     * Converts volunteer records to email recipient objects.
     *
     * @author Aaron Wong
     *
     * @param volunteerList     List of volunteers to convert.
     * @return                  List of converted email recipients.
     * @since                   1.0
     */
    public static List<PORTAL_CommunityUtils.EmailRecipient> getEmailRecipientList(Map<String, Object> params) {
        List<PORTAL_CommunityUtils.EmailRecipient> resultList = new List<PORTAL_CommunityUtils.EmailRecipient>();

        List<ucinn_portal_Volunteer__c> volunteerList = (List<ucinn_portal_Volunteer__c>)params?.get(VOLUNTEER_LIST);

        if (volunteerList == null || volunteerList.isEmpty()) {
            return resultList;
        }

        for (ucinn_portal_Volunteer__c eachVolunteer : volunteerList) {
            resultList.add(new PORTAL_CommunityUtils.EmailRecipient(eachVolunteer.First_Name__c, eachVolunteer.Last_Name__c, eachVolunteer.Email__c));
        }

        return resultList;
    }

    /**
     * Gets a map for merge fields to their values for a given volunteer record.
     *
     * @author Aaron Wong
     *
     * @param volunteerRecord           Volunteer record to get the map for.
     * @return                          Map of merge fields to their values.
     * @since                           1.0
     */
    public static Map<String, String> getMergeFieldToValueMap(Map<String, Object> params) {
        Map<String, String> resultMap = new Map<String, String>();

        ucinn_portal_Volunteer__c volunteerRecord = (ucinn_portal_Volunteer__c)params?.get(VOLUNTEER_RECORD);

        if (volunteerRecord == null) {
            return resultMap;
        }

        Map<String, Object> populatedFieldMap = volunteerRecord.getPopulatedFieldsAsMap();

        for (String eachFieldName : populatedFieldMap.keySet()) {
            resultMap.put(eachFieldName, String.valueOf(populatedFieldMap.get(eachFieldName)));
        }

        return resultMap;
    }


    /**
     * Creates an email record for the given volunteer record.
     *
     * @author Aaron Wong
     *
     * @param volunteerRecord           Volunteer record to create the email for.
     * @param emailTemplateRecord       Email template record to use to create the email.
     * @param userRecord                The user to send the email to.
     * @param senderDisplayName         The sender's display name.
     * @return                          A SingleEmailMessage record to send.
     * @since                           1.0
     */
    public static Messaging.SingleEmailMessage createVolunteerEmail(Map<String, Object> params) {
        Messaging.SingleEmailMessage resultMessage = null; // difficult to check empty email object

        ucinn_portal_Volunteer__c volunteerRecord = (ucinn_portal_Volunteer__c)params?.get(VOLUNTEER_RECORD);
        EmailTemplate emailTemplateRecord = (EmailTemplate)params?.get(EMAIL_TEMPLATE_RECORD);
        User userRecord = (User)params?.get(USER_RECORD);
        String senderDisplayName = (String)params?.get(SENDER_DISPLAY_NAME);

        if (volunteerRecord == null || emailTemplateRecord == null
                || userRecord == null || String.isBlank(senderDisplayName)) {
            return resultMessage;
        }
        
        Map<String, String> mergeFieldToValueMap = getMergeFieldToValueMap(new Map<String, Object>{VOLUNTEER_RECORD => volunteerRecord});

        resultMessage = PORTAL_CommunityUtils.createEmailRecord(new Map<String, Object>{
            PORTAL_CommunityUtils.USER_ID => userRecord.Id,
            PORTAL_CommunityUtils.SENDER_DISPLAY_NAME => senderDisplayName,
            PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => emailTemplateRecord,
            PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToValueMap
        });

        return resultMessage;
    }

    /**
     * Gets volunteer email templates.
     *
     * @author Aaron Wong
     *
     * @return      List of volunteer email templates.
     * @since       1.0
     */
    public static List<EmailTemplate> getVolunteerEmailTemplateList(Map<String, Object> params) {
        List<EmailTemplate> emailTemplateList = [SELECT Name, DeveloperName, HtmlValue FROM EmailTemplate WHERE FolderId IN (SELECT Id FROM Folder WHERE DeveloperName = 'Portal_Volunteer_Email_Templates')];

        return emailTemplateList;
    }

    /**
     * Gets users to email by volunteer information.
     *
     * @author Phillip Nguyen
     *
     * @param volunteerBioInfoMap   Bioinformation for volunteers.
     * @return                      Map of email to users.
     * @since                       1.0
     */
    public static Map<String, User> getUsersToEmail(Map<String, Object> params) {
        Map<String, User> returnMap = new Map<String, User>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        Map<Object,Object> volunteerBioInfoMap = (Map<Object,Object>)params.get(VOLUNTEER_BIO_INFO_MAP);

        String volunteerFirstName = (String)volunteerBioInfoMap.get(VOLUNTEER_FIRST_NAME);
        String volunteerLastName = (String)volunteerBioInfoMap.get(VOLUNTEER_LAST_NAME);
        String volunteerEmail = (String)volunteerBioInfoMap.get(VOLUNTEER_EMAIL);

        PORTAL_CommunityUtils.EmailRecipient emailRecipient = new PORTAL_CommunityUtils.EmailRecipient(volunteerFirstName, volunteerLastName, volunteerEmail);
        returnMap = PORTAL_CommunityUtils.getUsersToEmail(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_RECIPIENT_LIST =>
                                                                                    new List<PORTAL_CommunityUtils.EmailRecipient>{emailRecipient}
                                                                                  });

        return returnMap;
    }

    /**
     * sendEmails must be run in a without sharing context
     * 
     * @author Jacob Huang
     * 
     * @param emailList             List of emails to send.
     * @return                      Map of email to users.
     */
    public static void sendEmails(Map<String,Object> params) {
        if (!Test.isRunningTest()){
            PORTAL_CommunityUtils.sendEmails(params);
        }
    }

    /**
     * Inserting the volunteer record needs to be ran without sharing
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param   volunteerRecord     Volunteer Record to Insert
     */
    public static void insertVolunteerRecord(ucinn_portal_Volunteer__c volunteerRecord) {
        if (volunteerRecord == null) {
            return;
        }

        insert volunteerRecord;
    }
}