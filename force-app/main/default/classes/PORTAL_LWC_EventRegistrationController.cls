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
 * LWC Controller for portal_EventRegistrationWrapper
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
public inherited sharing class PORTAL_LWC_EventRegistrationController {
    public static final String ERROR_INITIALIZATION = 'There was an issue with creating this registration page. Please contact an Administrator.';
    public static final String ERROR_REGISTRATION = 'There was an issue with processing your registration. Please contact an Administrator.';
    public static final String ERROR_PROMO_CODE = 'There was an issue applying your promo code. Please contact an Administrator';

    /**
     * Initializes the event registration process.
     *
     * @author Aaron Wong
     *
     * @param listingId                 The listing Id being registered for.
     * @param primaryParticipationId    The primary participation to modify (if any).
     * @return                          Map of information used for event registration.
     * @since                           1.0
     */
    @AuraEnabled(cacheable = true)
    public static Map<String, Object> SERVER_initEventRegistration(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventRegistrationControllerBase controller = (PORTAL_EventRegistrationControllerBase)PORTAL_Utils.getControllerFactory().getEventRegistrationController();

            return controller.initEventRegistration(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventRegistrationController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventRegistrationController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Registers the participants given for the event.
     *
     * @author Aaron Wong
     *
     * @param registrantList        The list of registrants to register.
     * @param listingId             The listing Id of the event.
     * @param sessionId             The session cookie Id to create the registration session for.
     * @param recaptchaToken        The client side recaptcha token to be verified
     * @since                   1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_registerParticipants(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventRegistrationControllerBase controller = (PORTAL_EventRegistrationControllerBase)PORTAL_Utils.getControllerFactory().getEventRegistrationController();

            return controller.registerParticipants(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventRegistrationController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventRegistrationController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_REGISTRATION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets ticket discounts based on the promo code provided.
     *
     * @author Aaron Wong
     *
     * @param listingId     The id of the listing the promo code is being applied to.
     * @param promoCode     The promo code of the discount.
     * @return              A map containing information about the ticket discount.
     * @since               1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getPromoCodeDiscount(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventRegistrationControllerBase controller = (PORTAL_EventRegistrationControllerBase)PORTAL_Utils.getControllerFactory().getEventRegistrationController();

            return controller.getPromoCodeDiscount(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventRegistrationController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventRegistrationController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_PROMO_CODE,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}