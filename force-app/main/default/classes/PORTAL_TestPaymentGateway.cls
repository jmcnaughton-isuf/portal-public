/*
* Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
*                     http://www.ucinnovation.com
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
 * This serves to create a payment gateway that does nothing so that tests that interact with payment gateway aren't required to set the current selected payment gateway and assign callout responses
 */
public with sharing class PORTAL_TestPaymentGateway extends PORTAL_PaymentGateway {

    public PORTAL_TestPaymentGateway() { }

    /**
     * do nothing, return test Id string
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     *
     * @return                          'testId'
     */
    public override PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params) {
        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        responseWrapper.transactionId = 'testId';

        return responseWrapper;
    }

    /**
     * do nothing, return test Id string
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     *
     * @return                          'testId'
     */
    public override String createSubscription(Map<String, Object> params) {
        return 'testId';
    }

    /**
     * do nothing, return test key string
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     *
     * @return                          'testKey'
     */
    public override String getPublicApiKey(Map<String, Object> params) {
        return 'testKey';
    }

    public override String createWalletPaymentMethod(WalletType walletType, String walletToken) {
        return 'testMethod';
    }

    /**
     * do nothing, return 4 test digits
     *
     * @author:                         Jacob Huang
     * 
     * @return                          '1234'
     */
    public override String updateSubscriptionCreditCard(Map<String, Object> params) {
        return '1234';
    }
    
    /**
     * do nothing, return an empty map
     * 
     * @author Jacob Huang
     * 
     * @return                          empty map 
     */
    public override Map<String, String> getCreditCardIdToLastFourDigitsMap(Map<String, Object> params) {
        return new Map<String, String>();
    }

    /**
     * do nothing
     * 
     * @author Jacob Huang
     */
    public override void cancelSubscription(Map<String, Object> params) {
        return;
    }

    /**
     * do nothing
     * 
     * @author Todd Shinto
     */
    public override String getReviewTransactionTenderType(Map<Object, Object> additionalPaymentDataMap) {
        return '';
    }
}