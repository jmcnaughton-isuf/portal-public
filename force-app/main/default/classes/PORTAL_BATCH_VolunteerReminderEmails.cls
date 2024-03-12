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
 * Send reminder emails to volunteers
 *
 * @author          Aaron Wong
 * @version         1.0
 * @since           1.0
 */
public virtual class PORTAL_BATCH_VolunteerReminderEmails implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    public Map<String, EmailTemplate> apiNameToEmailTemplate = new Map<String, EmailTemplate>();    // map of email template api name to email template
    public Set<String> volunteerJobIdSet = new Set<String>();
    public Set<String> volunteerShiftIdSet = new Set<String>();
    public String senderDisplayName = '';

    /**
     * Constructor for batch.
     *
     * @author Aaron Wong
     *
     * @since                           1.0
     */
    public PORTAL_BATCH_VolunteerReminderEmails() {}

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

        queryString = queryString + String.join(new List<String>(objectFieldSet), ', ');

        queryString = queryString + ', Volunteer_Shift__r.Reminder_Email_Date_Time__c, Volunteer_Shift__r.Reminder_Email_Template__c, Volunteer_Shift__r.Is_Reminder_Email_Sent__c, Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Date_Time__c, Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Template__c, Volunteer_Shift__r.Volunteer_Job__r.Is_Reminder_Email_Sent__c FROM ucinn_portal_Volunteer__c ';

        DateTime currentDateTime = DateTime.now();

        queryString = queryString + ' WHERE (Volunteer_Shift__r.Reminder_Email_Date_Time__c < :currentDateTime AND Volunteer_Shift__r.Reminder_Email_Template__c != null AND Volunteer_Shift__r.Is_Reminder_Email_Sent__c = false) OR (Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Date_Time__c < :currentDateTime AND Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Template__c != null AND Volunteer_Shift__r.Volunteer_Job__r.Is_Reminder_Email_Sent__c = false)';

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
        Set<String> thisVolunteerJobIdSet = new Set<String>();
        Set<String> thisVolunteerShiftIdSet = new Set<String>();

        if (volunteerList == null || volunteerList.isEmpty()) {
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
            String emailTemplateApiName = '';

            if (eachVolunteer.Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Date_Time__c != null
                    && eachVolunteer.Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Date_Time__c < DateTime.now()
                    && eachVolunteer.Volunteer_Shift__r.Volunteer_Job__r.Is_Reminder_Email_Sent__c == false) {
                thisVolunteerJobIdSet.add(eachVolunteer.Volunteer_Shift__r.Volunteer_Job__c);
                emailTemplateApiName = eachVolunteer.Volunteer_Shift__r.Volunteer_Job__r.Reminder_Email_Template__c;
            }

            if (eachVolunteer.Volunteer_Shift__r.Reminder_Email_Date_Time__c != null
                    && eachVolunteer.Volunteer_Shift__r.Reminder_Email_Date_Time__c < DateTime.now()
                    && eachVolunteer.Volunteer_Shift__r.Is_Reminder_Email_Sent__c == false) {
                thisVolunteerShiftIdSet.add(eachVolunteer.Volunteer_Shift__c);
                emailTemplateApiName = eachVolunteer.Volunteer_Shift__r.Reminder_Email_Template__c;
            }

            if (String.isBlank(emailTemplateApiName)) {
                continue;
            }

            EmailTemplate emailTemplateRecord = apiNameToEmailTemplate.get(emailTemplateApiName);

            if (emailTemplateRecord == null) {
                emailTemplateRecord = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => emailTemplateApiName});
                apiNameToEmailTemplate.put(emailTemplateApiName, emailTemplateRecord);
            }

            Messaging.SingleEmailMessage volunteerEmail = PORTAL_UTIL_Volunteers.createVolunteerEmail(new Map<String, Object>{
                                                              PORTAL_UTIL_Volunteers.VOLUNTEER_RECORD => eachVolunteer,
                                                              PORTAL_UTIL_Volunteers.EMAIL_TEMPLATE_RECORD => emailTemplateRecord,
                                                              PORTAL_UTIL_Volunteers.USER_RECORD => emailToUserMap.get(eachVolunteer.Email__c),
                                                              PORTAL_UTIL_Volunteers.SENDER_DISPLAY_NAME => this.senderDisplayName
                                                          });

            if (volunteerEmail != null) {
                emailMessageList.add(volunteerEmail);
            }
        }

        PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => emailMessageList});

        volunteerJobIdSet.addAll(thisVolunteerJobIdSet);
        volunteerShiftIdSet.addAll(thisVolunteerShiftIdSet);
    }

    /**
     * Finish method for batch.
     *
     * @author Aaron Wong
     *
     * @since                           1.0
     */
    public virtual void finish(Database.BatchableContext bc) {
        if (!volunteerJobIdSet.isEmpty()) {
            List<ucinn_portal_Volunteer_Job__c> volunteerJobList = new List<ucinn_portal_Volunteer_Job__c>();

            for (String eachJobId : volunteerJobIdSet) {
                volunteerJobList.add(new ucinn_portal_Volunteer_Job__c(Id = eachJobId, Is_Reminder_Email_Sent__c = true));
            }

            update volunteerJobList;
        }

        if (!volunteerShiftIdSet.isEmpty()) {
            List<ucinn_portal_Volunteer_Shift__c> volunteerShiftList = new List<ucinn_portal_Volunteer_Shift__c>();

            for (String eachShiftId : volunteerShiftIdSet) {
                volunteerShiftList.add(new ucinn_portal_Volunteer_Shift__c(Id = eachShiftId, Is_Reminder_Email_Sent__c = true));
            }

            update volunteerShiftList;
        }
    }

    /**
     * Execute method for batch scheduler.
     *
     * @author Aaron Wong
     *
     * @since                           1.0
     */
    public virtual void execute(SchedulableContext scon) {
        Database.executeBatch(new PORTAL_BATCH_VolunteerReminderEmails(), 100);
    }
}