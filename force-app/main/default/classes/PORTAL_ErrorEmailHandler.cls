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
 * Email Handler to publish a platform event which executes a flow.
 * Flow uses Apex code to send email(s) when an Apex error occurs.
 *
 * @author      Isaiah Rodriguez
 * @version     1.0
 * @since       1.0
 */
public without sharing virtual class PORTAL_ErrorEmailHandler {
    public static final String DEVELOPER_NAME = 'developerName';

    public static final String DEFAULT_FIRST_NAME = 'DefaultFirstName';
    public static final String DEFAULT_LAST_NAME = 'DefaultLastName';

    public static final String PORTAL_APEX_ERROR_EMAIL_LIST = 'Portal_Apex_Error_Email_List';
    public static final String PORTAL_APEX_ERROR_EMAIL_TEMPLATE = 'Portal_Apex_Error_Email_Template';

    public static final String EMAIL_LIST = 'emailList';
    public static final String EMAIL_RECIPIENT_LIST = 'emailRecipientList';

    public static final String USER_ID = 'userId';
    public static final String SENDER_DISPLAY_NAME = 'senderDisplayName';
    public static final String EMAIL_SENDER_NAME = 'PORTAL TEST';
    public static final String SUBJECT_CONST = 'subject';
    public static final String EMAIL_BODY = 'emailBody';
    public static final String EMAIL_TO_SEND_LIST = 'emailList';

    public static final String MERGE_FIELD_REPLACEMENT = 'mergeFieldToReplacementValue';
    public static final String MERGE_FIELD_ORIGINAL_TEXT = 'originalText';
    public static final String MERGE_FIELD_FIRST_NAME = 'FirstName';
    public static final String MERGE_FIELD_LAST_NAME = 'LastName';
    public static final String MERGE_FIELD_ERROR_MESSAGE = 'ErrorMessage';
    public static final String MERGE_FIELD_STACK_TRACE = 'Stacktrace';
    public static final String MERGE_FIELD_CLASS_NAME = 'ClassName';

    public ErrorDetails errorDetailsObject;

     /**
     * Invocable variables detailing the original Apex error.
     *
     * @author      Isaiah Rodriguez
     * @version     1.0
     * @since       1.0
     */
    public class ErrorDetails {
        @InvocableVariable(label='Error Message' description='Error message associated with the original apex error.')
        public String errorMessage;
        @InvocableVariable(label='Stacktrace' description='Stacktrace associated with the original apex error.')
        public String stacktrace;
        @InvocableVariable(label='Class Name' description='Class name where the original apex error occurred.')
        public String className;

        public Boolean isEmpty() {
            return String.isBlank(errorMessage) && String.isBlank(stacktrace) && String.isBlank(className);
        }
    }

    /**
     * Empty constructor.
     *
     * @author:                         Isaiah Rodriguez
     * @since:                          1.0
     */
    public PORTAL_ErrorEmailHandler() {}

    /**
     * Publishes 'Event Error Email' platform event to start the 'Run Apex On Code Error' Salesforce flow.
     *
     * @author                          Isaiah Rodriguez
     * @since                           1.0
     *
     * @param apexException             Exception that causes the publishEmailEvent to be called.
     * @param className                 Name of class where Apex exception occurred.
     *
     * @return                          A boolean that is true only if the email event was successfully published.
     */
    public virtual void publishEmailEvent(Exception apexException, String className) {
        if (!isRunErrorEmailHandler(apexException, className)) {
            return;
        }

        ucinn_portal_Event_Error_Email__e eventError = new ucinn_portal_Event_Error_Email__e();
        eventError.Error_Message__c = apexException.getMessage();
        eventError.Stack_Trace__c = apexException.getStackTraceString();
        eventError.Class_Name__c = className;

        Database.SaveResult publishResult = EventBus.publish(eventError);

        if (!publishResult.isSuccess()) {
            for(Database.Error err : publishResult.getErrors()) {
                System.debug('Error returned: ' +
                            err.getStatusCode() +
                            ' - ' +
                            err.getMessage());
            }

            throw new AuraHandledException('Publishing the email event was unsuccessful.');
        }
    }

    /**
     * Called by a Salesforce flow. Initiates the logic for sending emails.
     *
     * @author                              Isaiah Rodriguez
     * @since                               1.0
     *
     * @param errorDetailList               List of invocable variables detailing the original Apex error.
     */
    @InvocableMethod(label='Send Error Emails' description='Sends emails out after an error has occurred within Apex.')
    public static void sendEmails(List<ErrorDetails> errorDetailList) {
        if (errorDetailList == null || errorDetailList.isEmpty()) {
            System.debug('Error Detail List is null.');
            return;
        }

        // Get error details object. Contains errorMessage, stacktrace, and className.
        ErrorDetails errorDetailsObject = errorDetailList.get(0);

        // Create instance of class to call static methods from in this function
        PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
        errorEmailHandler.errorDetailsObject = errorDetailsObject;
        errorEmailHandler.handleSendingEmails();
    }

    /**
     * Sends emails to users when an Apex error occurs by using an email list and email template
     * retrieved from Portal Organization Settings. Create email records and send them.
     *
     * @author                              Isaiah Rodriguez
     * @since                               1.0
     */
    @TestVisible
    protected virtual void handleSendingEmails() {
        // Get a list of emails to send to
        List<String> emailList = getEmailListFromOrgSetting();

        if (Test.isRunningTest()) {
            emailList.add('test@ucinnovation.com');
        }

        if (emailList == null || emailList.isEmpty()) {
            System.debug('Email list from org setting is null or empty.');
            return;
        }

        // Query for User records associated with the emails from the Error Email Template List Portal Org Setting
        List<User> userList = [SELECT FirstName, LastName, Email FROM USER WHERE Email IN :emailList];

        // Create and populate a list of recipients who will receive emails
        List<PORTAL_CommunityUtils.EmailRecipient> emailRecipientList = getEmailRecipientList(userList, emailList);

        if (emailRecipientList == null || emailRecipientList.isEmpty()) {
            System.debug('Email Recipient List is null or empty.');
            return;
        }

        // Create a list of emails to send
        List<Messaging.SingleEmailMessage> emailMessageList = createEmailRecordList(emailRecipientList);

        PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{EMAIL_TO_SEND_LIST => emailMessageList});
    }

    /**
     * Returns true if the class name and/or exception parameters are within a
     * predetermined (& overridable) container of class names and/or exceptions.
     *
     * @author                                  Isaiah Rodriguez
     * @since                                   1.0
     *
     * @param apexException                     Exception that causes publishEmailEvent to be called.
     * @param className                         Name of class where Apex exception occurred.
     *
     * @return                                  List of email recipients.
     */
    protected virtual Boolean isRunErrorEmailHandler(Exception apexException, String className) {
        return true;
    }

    /**
     * Gets list of emails from portal org setting Portal Apex Error Email List.
     *
     * @author                                  Isaiah Rodriguez
     * @since                                   1.0
     *
     * @return                                  List of email recipients.
     */
    protected virtual List<String> getEmailListFromOrgSetting() {
        List<String> resultList = new List<String>();

        // Query for List of emails to send to
        String errorEmailListString = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object> {
                                                                            PORTAL_Utils.DEVELOPER_NAME => PORTAL_APEX_ERROR_EMAIL_LIST});

        if (String.isBlank(errorEmailListString)) {
            System.debug('List of emails is null or empty');
            return resultList;
        }

        resultList = errorEmailListString.split(',');
        return resultList;
    }

    /**
     * Gets an email template from the portal org setting Portal Apex Error Email Template.
     *
     * @author                                  Isaiah Rodriguez
     * @since                                   1.0
     *
     * @return                                  Email Template to be used in emails.
     */
    protected virtual EmailTemplate getEmailTemplateFromOrgSetting() {
        EmailTemplate resultEmailTemplate = new EmailTemplate();

        // Query for email template name from org settings
        String errorEmailTemplateName = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object> {
        PORTAL_Utils.DEVELOPER_NAME => PORTAL_APEX_ERROR_EMAIL_TEMPLATE});

        if (Test.isRunningTest()) {
            errorEmailTemplateName = 'Test Template';
        }

        if (String.isBlank(errorEmailTemplateName)) {
            System.debug('Email Template name is null or empty');
            return resultEmailTemplate;
        }

        // Get the email template that was queried from the Portal_Apex_Error_Email_Template Org Setting
        EmailTemplate apexErrorEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object> {
                        DEVELOPER_NAME => errorEmailTemplateName});

        if (apexErrorEmailTemplate == null) {
            return resultEmailTemplate;
        }

        resultEmailTemplate = apexErrorEmailTemplate;
        return resultEmailTemplate;
    }

    /**
     * Gets a list of email recipients with named Users and unamed Users.
     *
     * @author                                  Isaiah Rodriguez
     * @since                                   1.0
     *
     * @param userList                          List containing emails associated with User records.
     * @param emailList                         List containing emails that will receive notifications.
     *
     * @return                                  List of all email recipients.
     */
    @TestVisible
    protected virtual List<PORTAL_CommunityUtils.EmailRecipient> getEmailRecipientList(List<User> userList, List<String> emailList) {
        List<PORTAL_CommunityUtils.EmailRecipient> emailRecipientList = new List<PORTAL_CommunityUtils.EmailRecipient>();
        Set<String> emailsAssociatedWithUsersSet = new Set<String>();

        if (userList == null) {
            userList = new List<User>();
        }

        if (emailList == null) {
            emailList = new List<String>();
        }

        // Create an named email recipient with a first & last name retrieved from an associated User record.
        // userList can NOT be null - null check is done from where function is called.
        for (User eachUser : userList) {
            emailRecipientList.add(new PORTAL_CommunityUtils.EmailRecipient(eachUser.FirstName,
                                                                            eachUser.LastName,
                                                                            eachUser.Email));
            emailsAssociatedWithUsersSet.add(eachUser.Email);
        }

        // Create an unnamed email recipient with a default first & last name for any emails that aren't associated with a User record.
        // emailList can NOT be null - null check is done from where function is called.
        for (String eachEmail : emailList) {
            if (emailsAssociatedWithUsersSet.contains(eachEmail)) {
                continue;
            }

            emailRecipientList.add(new PORTAL_CommunityUtils.EmailRecipient(DEFAULT_FIRST_NAME,
                                                                            DEFAULT_LAST_NAME,
                                                                            eachEmail));
        }

        return emailRecipientList;
    }

    /**
     * Gets list of emails from portal org setting Portal Apex Error Email List
     *
     * @author                                      Isaiah Rodriguez
     * @since                                       1.0
     *
     * @param emailRecipientList                    List of Recipients who will receive emails.
     *
     * @return                                      List of emails to send.
     */
    @TestVisible
    protected virtual List<Messaging.SingleEmailMessage> createEmailRecordList(List<PORTAL_CommunityUtils.EmailRecipient> emailRecipientList) {
        List<Messaging.SingleEmailMessage> resultEmailMessageList = new List<Messaging.SingleEmailMessage>();

        // Get users to email from recipient list. Use to get user Id when creating an email record.
        Map<String, User> emailToUserMap = PORTAL_CommunityUtils.getUsersToEmail(new Map<String, Object> {
                                                                                    EMAIL_RECIPIENT_LIST => emailRecipientList});

        EmailTemplate apexErrorEmailTemplate = getEmailTemplateFromOrgSetting();

        if (emailToUserMap == null || emailToUserMap.isEmpty()) {
            return resultEmailMessageList;
        }

        for (PORTAL_CommunityUtils.EmailRecipient eachEmailRecipient : emailRecipientList) {
            if (!emailToUserMap.containsKey(eachEmailRecipient.email)) {
                continue;
            }

            User currentUser = emailToUserMap.get(eachEmailRecipient.email);
            Messaging.SingleEmailMessage emailRecord = createEmailRecord(eachEmailRecipient, apexErrorEmailTemplate, currentUser);

            if (emailRecord == null) {
                continue;
            }

            resultEmailMessageList.add(emailRecord);
        }

        return resultEmailMessageList;
    }

    /**
     * Creates single email message to send to users.
     *
     * @author                                  Isaiah Rodriguez
     * @since                                   1.0
     *
     * @param emailRecipient                    Individual Recipient who will receive an email.
     * @param apexErrorEmailTemplate            The EmailTemplate object being used to format the emails.
     * @param emailToUserMap                    Map of user emails to their respective User record.
     *
     * @return                                  An email record that is ready to be sent.
     */
    @TestVisible
    protected virtual Messaging.SingleEmailMessage createEmailRecord(PORTAL_CommunityUtils.EmailRecipient emailRecipient,
                                                                     EmailTemplate apexErrorEmailTemplate,
                                                                     User currentUser) {
        Messaging.SingleEmailMessage resultEmailRecord = null;

        if (String.isBlank(emailRecipient.email) || String.isBlank(emailRecipient.firstName) || String.isBlank(emailRecipient.lastName)
            || this.errorDetailsObject.isEmpty() || apexErrorEmailTemplate == null) {
            return resultEmailRecord;
        }

        String populatedEmailBody = replaceMergeFields(emailRecipient, apexErrorEmailTemplate);

        resultEmailRecord = PORTAL_CommunityUtils.createEmailRecord(new Map<String,Object>{USER_ID => currentUser.Id,
                                                                                SENDER_DISPLAY_NAME => EMAIL_SENDER_NAME,
                                                                                SUBJECT_CONST => apexErrorEmailTemplate.Subject,
                                                                                EMAIL_BODY => populatedEmailBody
                                                                            });

        return resultEmailRecord;
    }

    /**
     * Replaces merge fields from portal org Portal_Apex_Error_Email_Template with their actual values.
     *
     * @author                                  Isaiah Rodriguez
     * @since                                   1.0
     *
     * @param emailRecipient                    Individual Recipient who will receive an email.
     * @param apexErrorEmailTemplate            The EmailTemplate object being used to format the emails.
     *
     * @return                                  A string of the email body with the merge fields replaced.
     */
    @TestVisible
    protected virtual String replaceMergeFields(PORTAL_CommunityUtils.EmailRecipient emailRecipient,
                                                EmailTemplate apexErrorEmailTemplate) {
        String resultEmailBody = '';

        if (emailRecipient == null || apexErrorEmailTemplate == null) {
            return resultEmailBody;
        }

        Map<String, String> mergeFieldtoReplacementValueMap = new Map<String, String>();
        mergeFieldtoReplacementValueMap.put(MERGE_FIELD_FIRST_NAME, emailRecipient.firstName);
        mergeFieldtoReplacementValueMap.put(MERGE_FIELD_LAST_NAME, emailRecipient.lastName);
        mergeFieldtoReplacementValueMap.put(MERGE_FIELD_ERROR_MESSAGE, this.errorDetailsObject.errorMessage);
        mergeFieldtoReplacementValueMap.put(MERGE_FIELD_STACK_TRACE, this.errorDetailsObject.stacktrace);
        mergeFieldtoReplacementValueMap.put(MERGE_FIELD_CLASS_NAME, this.errorDetailsObject.className);

        // Prioritize HTML Template over Raw Text
        String emailBody = apexErrorEmailTemplate.Body;

        if (String.isNotBlank(apexErrorEmailTemplate.HtmlValue)) {
            emailBody = apexErrorEmailTemplate.HtmlValue;
        }

        resultEmailBody = PORTAL_CommunityUtils.replaceMergeFields(new Map<String,Object>{MERGE_FIELD_REPLACEMENT => mergeFieldtoReplacementValueMap,
                                                                               MERGE_FIELD_ORIGINAL_TEXT => emailBody});

        return resultEmailBody;
    }
}