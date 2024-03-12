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
 * LWC Controller for portal_ShoppingCart and portal_EventPayment
 *
 * @author              Phillip Nguyen
 * @version             1.0
 * @since               1.0
 */

public without sharing class PORTAL_LWC_ShoppingCartController {
    public static final String ERROR_CONTACT_ADMIN = 'There was an issue retrieving content. Please contact an administrator.';

    /**
     * Get all participation's information in registration session that have tickets that are not paid
     *
     * @author                              Phillip Nguyen
     *
     * @param cookieId                      The registration session cookie Id
     * @param currentStatus                 The status of registration session (i.e 'In Shopping Cart', 'Pending Payment')
     * @return                              List of Mapped Participation Information used by Shopping Cart & Payment
     *
     * @since                               1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getParticipationsMapInSession(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            return controller.getParticipationsMapInSession(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Checks if there are valid tickets in shopping cart
     * Used for portal_ShoppingCartBanner
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param cookieId                      Registration Session cookie Id
     * @return                              Map that contains if tickets are valid and expiration date/time of tickets
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_checkForTicketsInShoppingCart(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            return controller.checkForTicketsInShoppingCart(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * When exiting payment page, if primary participant is registered: delete tickets, registration, participations
     * if primary participant is not registered: extend session by 15 min and set status to 'In Shopping Cart'
     *
     * @author                              Phillip Nguyen
     * @since                               1.0
     *
     * @param cookieId                      Registration Session cookie Id
     */
    @AuraEnabled
    public static void SERVER_handlePaymentPageExit(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            controller.handlePaymentPageExit(params);

        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Changes registration status and extends timer in shopping cart and payment page
     *
     * @author                              Phillip Nguyen
     *
     * @param cookieId                      The registration session cookie Id
     * @param currentStatus                 The current registration status for querying current registration
     * @param nextStatus                    The status that current registration will be set to
     *
     * @since                               1.0
     */
    @AuraEnabled
    public static void SERVER_modifyRegistrationStatusAndExtendExpirationDate(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            controller.modifyRegistrationStatusAndExtendExpirationDate(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ShoppingCartController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ShoppingCartController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Delete all participations in an Event Listing
     *
     * @author                          Phillip Nguyen
     * @param cookieId                  Registration Session cookie Id
     * @param eventId                   Event Listing Id
     *
     * @since                           1.0
     */
    @AuraEnabled
    public static void SERVER_deleteRegistrationForEvent(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            controller.deleteRegistrationForEvent(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ShoppingCartController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ShoppingCartController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Determines if we need to charge user's credit card
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param   cookieId        Registration session cookie Id
     * @param   sessionStatus   Registration session status
     * @param   paymentAmount   Amount registrant is paying is displayed correctly
     *
     * @return                  Boolean value, true means we charge credit card, false means we do not charge credit card
     */
    @AuraEnabled
    public static Boolean SERVER_isChargeCreditCard(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            return controller.isChargeCreditCard(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ShoppingCartController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ShoppingCartController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * After successfully charging credit card
     * Create receipt object for session, set tickets to paid, registration status to completed, update primary participation mapping
     * And send out emails to registrants and guests
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     * 
     * @param cookieId                          Registration Session cookie Id
     * @param developerName                     Developer Name for email template used for primary registrant
     * @param paymentId                         Optional string: The external id or payment token for the payment taken from the billing external gateway
     * @param amount                            Amount paid in dollars
     * @param paymentMethod                     Payment vendor that was used
     * @param registrantInformation             Primary Registrants information
     * @param recaptchaToken:                   The recaptcha client side token for this transaction submission
     * @param externalGatewayName               Optional string: Spreedly gateway name
     * @param additionalPaymentDataMap          Optional map: contains other info used by various payment processors
     * @param pageName                          Optional string: page section setting page name to use for populating rtv2 billing info fields and static/default fields 
     */
    @AuraEnabled
    public static void SERVER_eventPaymentCheckout(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            controller.eventPaymentCheckout(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ShoppingCartController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ShoppingCartController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Checks if the registration session is already on the payment page. If not, sets the registration
     * session to be on the payment page.
     *
     * @author Aaron Wong
     *
     * @param cookieId      The cookie Id of the registration session.
     * @return              Whether or not the registration session is already on the payment page.
     * @since               1.0
     */
    @AuraEnabled
    public static Boolean SERVER_handleUniquePaymentSession(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            return controller.handleUniquePaymentSession(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets event confirmation details for the given session.
     *
     * @author Aaron Wong
     *
     * @param sessionId     The Id of the registration session.
     * @return              The event confirmation details.
     * @since               1.0
     */
    @AuraEnabled
    public static List<ucinn_portal_Listing__c> SERVER_getEventConfirmationDetails(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();

            return controller.getEventConfirmationDetails(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}