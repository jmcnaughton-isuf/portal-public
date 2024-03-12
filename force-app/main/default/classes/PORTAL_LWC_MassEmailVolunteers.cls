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
public inherited sharing class PORTAL_LWC_MassEmailVolunteers {
    public static final String RECORD_ID = 'recordId';
    public static final String EMAIL_TEMPLATE_API_NAME = 'emailTemplateApiName';

    @AuraEnabled(cacheable=true)
    public static List<EmailTemplate> SERVER_getEmailTemplateList(Map<String, Object> params){
        return PORTAL_UTIL_Volunteers.getVolunteerEmailTemplateList(new Map<String, Object>());
    }

    @AuraEnabled
    public static void SERVER_massEmailVolunteers(Map<String, Object> params){
        String recordId = (String)params?.get(RECORD_ID);
        String emailTemplateApiName = (String)params?.get(EMAIL_TEMPLATE_API_NAME);

        if (String.isBlank(recordId) || String.isBlank(emailTemplateApiName)) {
            return;
        }

        Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails(((Id)recordId).getSObjectType().getDescribe().getName(), recordId, emailTemplateApiName));
    }
}