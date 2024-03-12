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
 * controller class for recaptcha LWC
 *
 * @author      Sean Tang
 * @version 1.0
 * @since   1.0
 */

public with sharing class PORTAL_LWC_RecaptchaController {
    public static final String ERROR_RECAPTCHA_OPTION = 'There was an error retrieving the reCAPTCHA Option.';    
    public static final String ERROR_RECAPTCHA_VERIFICATION = 'There was an unexpected error during reCAPTCHA verification.';

    /**
     * Retrieves recaptcha option from custom metadata record
     *
     * @author:                         Sean Tang
     * @since:                          1.0
     *
     * @return                          the recaptcha display option to show the correct recaptcha component
     */
    @AuraEnabled
    public static string SERVER_getRecaptchaOption(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            return recaptchaController.getRecaptchaOption();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_RecaptchaController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_RecaptchaController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_RECAPTCHA_OPTION,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Check if recaptcha is enabled for specific LWC by checking if the base apex class/function exists in the list
     * Example string: PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction
     * 
     * @author  Phillip Nguyen
     * @since   1.2
     * 
     * @param classFunctionName     String of the base class function name
     * 
     * @return                      Boolean, whether recaptcha is enabled
     */
    @AuraEnabled(cacheable=true)
    public static Boolean SERVER_getIsRecaptchaEnabled(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            return recaptchaController.getIsRecaptchaEnabled(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_RecaptchaController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_RecaptchaController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_RECAPTCHA_OPTION,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Verifies if recaptcha token is valid
     * If not valid, throws AuraHandledException
     * 
     * @author  Jacob Huang
     * @since   1.3
     * 
     * @param recaptchaToken        String: The client side recaptcha token to be verified
     */
    @AuraEnabled
    public static void SERVER_verifyRecaptchaToken(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            recaptchaController.verifyRecaptchaToken(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_RecaptchaController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_RECAPTCHA_VERIFICATION,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}