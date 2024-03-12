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
 * Controller for Giving History LWCs that need to use payment processors
 * 
 * @author  Jacob Huang
 * @version 1.0
 */
public with sharing class PORTAL_GivingHistoryPaymentController {

    /**
     * For a gift with a subscription (pledge or recurring), update the 
     * credit card information
     *
     * @author Jacob Huang
     * 
     * @param paramMap  List of parameters passed in by the calling function.
     *      String: giftId                      ID of the Opportunity
     *      String: subscriptionId              external ID for the gift's associated subscription
     *      String: paymentId                   ID received from the payment processor representing the credit card
     *      String: paymentMethod               payment processor used (Stripe, Spreedly, Cybersource)
     *      String: externalPaymentGatewayId    Cybersource: merchant reference code of the initial subscription transaction
     * 
     * @return                                  String: last 4 digits of new credit card, null if failure 
     */
    @AuraEnabled
    public static String SERVER_updateSubscriptionCreditCard(Map<String, Object> paramMap) {
        try {
            PORTAL_MyGivingHistoryControllerBase controller = (PORTAL_MyGivingHistoryControllerBase)PORTAL_Utils.getControllerFactory().getGivingHistoryBaseController();
            return controller.updateSubscriptionCreditCard(paramMap);    
        }
        catch (AuraHandledException ahe) {
            throw ahe;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                                                                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Cancel a constituent's existing subscription-based gift (pledge or recurring gift)
     * 
     * @author Jacob Huang
     * 
     * @param params  List of parameters passed in by the calling function.
     *      String: paymentMethod               Payment processor used
     *      String: giftId                      ID of Opportunity
     *      String: subscriptionId              External ID for the gift's associated subscription
     *      String: externalPaymentGatewayId    Merchant reference code of initial subscription transaction
     */
    @AuraEnabled
    public static void SERVER_cancelSubscription(Map<String, Object> params) {
        try {
            PORTAL_MyGivingHistoryControllerBase controller = (PORTAL_MyGivingHistoryControllerBase)PORTAL_Utils.getControllerFactory().getGivingHistoryBaseController();
            controller.cancelSubscription(params);
        }
        catch (AuraHandledException ahe) {
            throw ahe;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                                                            PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}