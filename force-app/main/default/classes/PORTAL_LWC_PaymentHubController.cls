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
 * Payment Hub Controller that contains functions for different payment methods
 * Used by portal_EventPayment
 *
 * @author          Phillip Nguyen
 * @version         1.0
 * @since           1.0
 */
public with sharing class PORTAL_LWC_PaymentHubController {
    public static final String ERROR_ORIGIN_SITE= 'There was an error retrieving origin site';
    public static final String ERROR_PAYMENT_INFO = 'There was an error retrieving the payment information.';
    public static final String CUSTOM_ERROR_MESSAGE = 'customErrorMessage';
    public static final String ERROR_MESSAGE_ACQUIRE_INFORMATION = 'Failed to get information. Please contact an administrator.';

    /**
     * Returns community url to communicate between LWC and VF Page for Payment
     *
     * @author      Phillip Nguyen
     *
     * @return      Community Url
     * @since       1.0
     */
    @AuraEnabled
    public static String SERVER_getOrigin(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            return PORTAL_PaymentHubControllerBase.getOrigin();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_ORIGIN_SITE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Retrieves the external gateway public api key
     *
     * @author:                         Phillip Nguyen
     * @since:                          1.0
     *
     * @param paymentMethod             he name of the payment method we are using
     * @param customMetadataName:       the name of the custom metadata that stores the public key
     *
     * @return                          the public key to initialize the credit card form to the correct account
     */
    @AuraEnabled
    public static string SERVER_getAPIKey(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.getAPIKey(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_PAYMENT_INFO,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     *
     * @author:                 Sam Longo
     * @since:                  1.0
     *
     * @param giftType:                         The type of gift the user is giving
     * @param paymentId                         payment token generated by the IFrame on the frontend corresponding to the credit card used
     * @param additionalPaymentDataMap          optional additional params for bank ACH payment data
     * @param externalGatewayName               The name of the Spreedly gateway to use. Must match a custom setting record for the object ucinn_ascendv2__Spreedly_Gateway__c
     * @param amount                            The amount to charge the card in USD
     *
     * @return                                  Id of ascendv2__Transaction_Data__c object that corresponds with the one time payment transaction, otherwise returns '' if recurring or pledge
     */
    @AuraEnabled
    public static String SERVER_getSpreedlyTransactionToken(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.getSpreedlyTransactionToken(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage() + e.getStackTraceString()});
        }
    }

    /**
     *
     * @author:                 Todd Shinto
     * @since:                  1.2
     *
     * @param additionalMetadata:       stringified additional metadata
     * @param amount:                   the amount of the transaction
     * @param stripeBillingInformation: formatted billing information for stripe to create customer
     * @param isGivingAsOrg:            boolean to declare if this gift is given as an org
     * @param isSubscription:           boolean to indicate if this is a one-time payment or subscription
     * @param paymentMethod:            specify which payment processor
     *
     * @return                                  Stripe client secret returned from creation of Payment Intent
     */
    @AuraEnabled
    public static String SERVER_getStripeClientSecret(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.getStripeClientSecret(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage() + e.getStackTraceString()});
        }
    }

    /**
     * Gets the merchant Id for the Cybersource payment gateway.
     * 
     * @author Aaron Wong
     * 
     * @param   paymentMethod       Payment Method to pass to the Payment Hub. 
     * @return                      Cybersource Merchant Id
     * @since                       1.0
     */
    @AuraEnabled
    public static String SERVER_getCybersourceMerchantId(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.getCybersourceMerchantId(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static String SERVER_createGooglePayPaymentMethod(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.createGooglePayPaymentMethod(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage() + e.getStackTraceString()});
        }
    }

    /**
     * Converts apple pay token to a payment method usable for the PSP.
     * 
     * @author Aaron Wong
     * 
     * @param  token            Apple Pay Token to covert to payment method.
     * 
     * @return                  Payment method token/identifier.
     * @since                   1.0
     */
    @AuraEnabled
    public static String SERVER_createApplePayPaymentMethod(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.createApplePayPaymentMethod(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage() + e.getStackTraceString()});
        }
    }

    /**
     * Retrieves recaptcha option from custom metadata record
     *
     * @author:                         Sean Tang
     * @since:                          1.0
     *
     * @param paymentMethod:            the payment method of current module
     * 
     * @return                          the recaptcha display option to show the correct recaptcha component
     */
    @AuraEnabled
    public static string SERVER_getRecaptchaOption(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            controller.setPaymentInterface(paymentMethod);
            return controller.getRecaptchaOption();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_PAYMENT_INFO,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Get TouchNet settings from CMT, this includes CMT from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   paymentMethod   Payment Method getting passed in (would be TouchNet in this case)
     * 
     * @return  TouchNet settings which includes the uPay site, the uPay Site Id, and the Rest Resource Site (used for webhook)
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getTouchNetSettings(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            return controller.getTouchNetSettings();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Function that constructs request with info we want to send and sends request.
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param ticketName        Name of ticket (we generate this value) which TouchNet Requires
     * @param nameValuePairs    String of Information to send to touchnet
     * @param paymentMethod     Payment Method getting passed in (would be TouchNet in this case)
     * 
     * @return                  Returns ticket string that TouchNet gives us             
     */
    @AuraEnabled
    public static String SERVER_generateSecureLinkTicket(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            return controller.generateSecureLinkTicket(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Grabs session Id for CometD
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   paymentMethod   Payment Method getting passed in (would be TouchNet in this case)
     * 
     * @return                  Returns user's session Id          
     */
    @AuraEnabled(cacheable=true)
    public static String SERVER_getCometDSessionId(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            String paymentMethod = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY);
            PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod);
            return controller.getCometDSessionId();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_PaymentHubController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_PaymentHubController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}