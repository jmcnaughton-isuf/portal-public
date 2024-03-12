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
 * LWC Controller for Mass Email Volunteers quickaction
 *
 * @author              Aaron Wong
 * @version             1.0
 * @since               1.0
 */
public inherited sharing class PORTAL_LWC_VolunteerReminderEmail {
    public static final String RECORD_ID = 'recordId';
    public static final String SCHEDULE_DATE_TIME = 'scheduleDateTime';
    public static final String EMAIL_TEMPLATE_API_NAME = 'emailTemplateApiName';

    /**
     * Gets a list of email templates available to the user.
     *
     * @author Aaron wong
     *
     * @return      A list of email templates.
     * @since       1.0
     */
    @AuraEnabled(cacheable=true)
    public static List<EmailTemplate> SERVER_getEmailTemplateList(Map<String, Object> params){
        return PORTAL_UTIL_Volunteers.getVolunteerEmailTemplateList(new Map<String, Object>());
    }


    /**
     * Schedules Volunteer reminder emails to be sent out.
     *
     * @author Aaron wong
     *
     * @param recordId                  The record Id of the volunteer object to schedule to reminder emails for.
     * @param scheduleDateTime          The date/time to schedule the reminder emails to be sent out.
     * @param emailTemplateApiName      The Email template API name to use for the reminder email.
     * @since       1.0
     */
    @AuraEnabled
    public static void SERVER_scheduleVolunteerReminderEmails(Map<String, Object> params){
        String recordId = (String)params?.get(RECORD_ID);
        Long scheduleDateTime = ((Decimal)params?.get(SCHEDULE_DATE_TIME))?.longValue();
        String emailTemplateApiName = (String)params?.get(EMAIL_TEMPLATE_API_NAME);

        if (String.isBlank(recordId) || scheduleDateTime == null || String.isBlank(emailTemplateApiName)) {
            return;
        }

        SObject volunteeringObject = ((Id)recordId).getSObjectType().newSObject(recordId);

        volunteeringObject.put(PORTAL_CONST_Volunteers.REMINDER_EMAIL_DATE_TIME_API_NAME, Datetime.newInstance(scheduleDateTime));
        volunteeringObject.put(PORTAL_CONST_Volunteers.REMINDER_EMAIL_TEMPLATE_API_NAME, emailTemplateApiName);
        volunteeringObject.put(PORTAL_CONST_Volunteers.IS_REMINDER_EMAIL_SENT_API_NAME, false);

        update volunteeringObject;
    }
}