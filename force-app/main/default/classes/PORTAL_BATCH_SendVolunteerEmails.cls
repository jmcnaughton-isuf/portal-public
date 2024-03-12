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
 * Sends volunteer emails to all volunteers for a given volunteer job or volunteer shift.
 *
 * @author          Aaron Wong
 * @version         1.0
 * @since           1.0
 */
public virtual class PORTAL_BATCH_SendVolunteerEmails implements Database.Batchable<sObject>{
    public String volunteerObjectApiName;
    public String volunteerObjectId;
    public String emailTemplateApiName;
    public String senderDisplayName;

    public static final String COMPLETION_EMAIL_TEMPLATE_DEVELOPER_NAME = 'Volunteer_Batch_Completion_Template';

    /**
     * Constructor for batch.
     *
     * @author Aaron Wong
     *
     * @param volunteerObjectApiName    The objects API Name that the volunteers are related to.
     * @param volunteerObjectId         The objects Id that the volunteers are related to.
     * @param emailTemplateApiName      The email template to use to send the emails.
     * @since                           1.0
     */
    public PORTAL_BATCH_SendVolunteerEmails(String volunteerObjectApiName,
                                            String volunteerObjectId,
                                            String emailTemplateApiName) {
        this.volunteerObjectApiName = volunteerObjectApiName;
        this.volunteerObjectId = volunteerObjectId;
        this.emailTemplateApiName = emailTemplateApiName;
    }

    /**
     * Start method for batch.
     *
     * @author Aaron Wong
     *
     * @since  1.0
     */
    public virtual Database.QueryLocator start(Database.BatchableContext bc) {
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Volunteer_Email_Sender_Display_Name'}
        });

        this.senderDisplayName = PORTAL_CONST_Volunteers.DEFAULT_EMAIL_SENDER_NAME;

        if (orgSettingList != null && !orgSettingList.isEmpty() && String.isNotBlank(orgSettingList.get(0).Value__c)) {
            this.senderDisplayName = orgSettingList.get(0).Value__c;
        }

        Set<String> objectFieldSet = Schema.SObjectType.ucinn_portal_Volunteer__c.fields.getMap().keySet();

        String queryString = 'SELECT ';

        queryString = queryString + String.join(new List<String>(objectFieldSet), ', ') + ' FROM ucinn_portal_Volunteer__c WHERE ';

        if (volunteerObjectApiName == PORTAL_CONST_Volunteers.VOLUNTEER_SHIFT_OBJECT_API_NAME) {
            queryString = queryString + ' Volunteer_Shift__c = \'' + volunteerObjectId + '\' ';
        } else {
            queryString = queryString + ' Volunteer_Shift__r.Volunteer_Job__c = \'' + volunteerObjectId + '\' ';
        }

        return Database.getQueryLocator(queryString);
    }

    /**
     * Execute method for batch.
     *
     * @author Aaron Wong
     *
     * @since  1.0
     */
    public virtual void execute(Database.BatchableContext bc, List<ucinn_portal_Volunteer__c> volunteerList) {
        if (volunteerList == null || volunteerList.isEmpty()) {
            return;
        }

        EmailTemplate emailTemplateRecord = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => emailTemplateApiName});

        if (emailTemplateRecord == null) {
            return;
        }

        List<PORTAL_CommunityUtils.EmailRecipient> recipientList = PORTAL_UTIL_Volunteers.getEmailRecipientList(new Map<String, Object>{
            PORTAL_UTIL_Volunteers.VOLUNTEER_LIST => volunteerList
        });

        if (recipientList == null || recipientList.isEmpty()) {
            return;
        }

        Map<String, User> emailToUserMap = PORTAL_CommunityUtils.getUsersToEmail(new Map<String, Object>{
            PORTAL_CommunityUtils.EMAIL_RECIPIENT_LIST => recipientList
        });

        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();

        for (ucinn_portal_Volunteer__c eachVolunteer : volunteerList) {
            Messaging.SingleEmailMessage eachVolunteerEmail = PORTAL_UTIL_Volunteers.createVolunteerEmail(new Map<String, Object>{
                PORTAL_UTIL_Volunteers.VOLUNTEER_RECORD => eachVolunteer,
                PORTAL_UTIL_Volunteers.EMAIL_TEMPLATE_RECORD => emailTemplateRecord,
                PORTAL_UTIL_Volunteers.USER_RECORD => emailToUserMap.get(eachVolunteer.Email__c),
                PORTAL_UTIL_Volunteers.SENDER_DISPLAY_NAME => this.senderDisplayName
            });

            if (eachVolunteerEmail != null) {
                emailMessageList.add(eachVolunteerEmail);
            }
        }

        PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => emailMessageList});
    }

    /**
     * Finish method for batch.
     *
     * @author Aaron Wong
     *
     * @since                           1.0
     */
    public virtual void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage emailMessage = this.createCompletionNotification();

        if (emailMessage == null) {
            return;
        }

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailMessage});
    }

    /**
     * Creates an email message to send to the user who sent the batch.
     *
     * @author Aaron Wong
     *
     * @return  The email message to send.
     * @since   1.0
     */
    private Messaging.SingleEmailMessage createCompletionNotification() {
        Messaging.SingleEmailMessage resultMessage = null;

        EmailTemplate emailTemplateRecord = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => COMPLETION_EMAIL_TEMPLATE_DEVELOPER_NAME});
        User userRecord = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId());

        if (emailTemplateRecord == null || userRecord == null) {
            return resultMessage;
        }

        Map<String, String> mergeFieldToValueMap = this.getCompletionMergeFieldMap();

        return PORTAL_CommunityUtils.createEmailRecord(new Map<String, Object>{
            PORTAL_CommunityUtils.USER_ID => userRecord.Id,
            PORTAL_CommunityUtils.SENDER_DISPLAY_NAME => this.senderDisplayName,
            PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => emailTemplateRecord,
            PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToValueMap
        });
    }

    /**
     * Template method used to define the merge fields for the completion map.
     *
     * @author  Aaron Wong
     *
     * @return  Merge field map.
     * @since   1.0
     */
    public virtual Map<String, String> getCompletionMergeFieldMap() {
        User userRecord = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId());

        // TODO: add some more default merge fields
        Map<String, String> mergeFieldToValueMap = new Map<String, String>{'Name' => userRecord.Name};

        return mergeFieldToValueMap;
    }
}