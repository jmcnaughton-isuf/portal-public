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
 * LWC Controller for portal_EventWaitlistForm
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
public without sharing class PORTAL_LWC_EventWaitlistFormController {
    public static final String ERROR_WAITLISTING = 'There was an error waitlisting for the event. Please contact an administrator.';
    public static final String ERROR_DELETION = 'There was an issue deleting your event registration. Please contact an administrator.';

    /**
     * Waitlist Registrant for the event.
     *
     * @author Aaron Wong
     *
     * @param firstName             The first name of the registrant.
     * @param lastName              The last name of the registrant.
     * @param email                 The email of the registrant.
     * @param ticketTypeId          The ticket type Id to waitlist for.
     * @param numberOfTickets       The number of tickets to waitlist.
     * @param recaptchaToken        The client side recaptcha token to be verified
     * @since                   1.0
     */
     @AuraEnabled
     public static void SERVER_waitlistRegistrant(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventWaitlistControllerBase controller = (PORTAL_EventWaitlistControllerBase)PORTAL_Utils.getControllerFactory().getEventWaitlistController();

            controller.waitlistRegistrant(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventWaitlistFormController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventWaitlistFormController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_WAITLISTING,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
     }

    /**
     * Removes a registrant from the waitlist.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryId       The Id of the waitlist entry to delete.
     * @since                       1.0
     */
     @AuraEnabled
     public static void SERVER_deleteWaitlistEntry(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventWaitlistControllerBase controller = (PORTAL_EventWaitlistControllerBase)PORTAL_Utils.getControllerFactory().getEventWaitlistController();

            controller.deleteWaitlistEntry(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventWaitlistFormController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventWaitlistFormController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DELETION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
     }

     /**
      * Gets waitlist entry by Id.
      */
    @AuraEnabled
    public static ucinn_portal_Event_Waitlist_Entry__c SERVER_getWaitlistEntryById(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventWaitlistControllerBase controller = (PORTAL_EventWaitlistControllerBase)PORTAL_Utils.getControllerFactory().getEventWaitlistController();

            return controller.getWaitlistEntryById(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventWaitlistFormController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventWaitlistFormController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DELETION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }
}