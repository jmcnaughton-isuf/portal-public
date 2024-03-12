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
 * Controller for Spreedly to handle external callouts and payments
 *
 * @author          Sam Longo
 * @version         1.0
 * @since           1.0
 */
public inherited sharing virtual class PORTAL_SpreedlyPaymentGateway extends PORTAL_PaymentGateway {
    public static final String GATEWAY_TOKEN_KEY = 'gatewayToken';
    public static final String PAYMENT_METHOD_TOKEN_KEY = 'paymentMethodToken';
    public static final String TRANSACTION_TOKEN_KEY = 'transactionToken';
    public static final String BASE_URL = 'callout:Spreedly/';
    public static final String PAYMENT_METHOD_SHOW_INVALID_TOKEN = 'errors.payment_method_not_found';
    public static final String SPREEDLY_ERROR_ERRORS_KEY = 'errors';
    public static final String SPREEDLY_ERROR_KEY_KEY = 'key';
    public static final String GENERIC_SPREEDLY_ERROR = 'There was an error processing the transaction with Spreedly.';
    public static final String SPREEDLY_TEST_CARD = 'Spreedly_Test_Card';
    public static final String ORG_CURRENCY = 'Org_Currency';

    public static final String TOKEN_KEY = 'token';
    public static final String TRANSACTION_KEY = 'transaction';
    public static final String PAYMENT_METHOD_API_ATTRIBUTE = 'payment_method';

    public static final String PAYMENT_METHOD_KEY = 'payment_method';
    public static final String PAYMENT_METHOD_LAST_FOUR_DIGITS_KEY = 'last_four_digits';
    public static final String PAYMENT_METHOD_BANK = 'bank_account';

    public static final String FULL_NAME_KEY = 'fullName';
    public static final String BANK_ROUTING_NUMBER_KEY = 'bankRoutingNumber';
    public static final String BANK_ACCOUNT_NUMBER_KEY = 'bankAccountNumber';
    public static final String BANK_ACCOUNT_TYPE_KEY = 'bankAccountType';
    public static final String BANK_ACCOUNT_HOLDER_KEY = 'bankAccountHolderType';

    public static final List<WalletType> SUPPORTED_WALLET_TYPE_LIST = new List<WalletType>{WalletType.GooglePay, WalletType.ApplePay};

    public PORTAL_SpreedlyPaymentGateway() {
    }

    public class RetainResponseWrapper {
        public String transactionId;
        public String paymentToken;
        public String lastFourCreditCardDigits;

        public RetainResponseWrapper(String responseString) {
            Map<String, Object> responseJson = (Map<String, Object>)JSON.deserializeUntyped(responseString);
            Map<String, Object> transactionResponseJson = (Map<String, Object>)responseJson.get(TRANSACTION_KEY);

            transactionId = (String)transactionResponseJson.get(TOKEN_KEY); //for the external rtv2 Id since this identifies the retain callout for future use

            Map<String, Object> paymentMethodResponseJson = (Map<String, Object>)transactionResponseJson.get(PAYMENT_METHOD_KEY);
            paymentToken = (String) paymentMethodResponseJson.get(TOKEN_KEY); //this has the token which can be used at any point in the future
            lastFourCreditCardDigits = (String) paymentMethodResponseJson.get(PAYMENT_METHOD_LAST_FOUR_DIGITS_KEY); // value is passed to front end after updating credit card 
        }
    }

    /**
     * Retrieves the external gateway public api key
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @return                          the Spreedly environment public key
     */
    public override String getPublicApiKey(Map<String, Object> params) {
        return ucinn_ascendv2.ascend_SPREEDLY_CheckoutController.SERVER_getEnvironmentKey();
    }

    /**
     * Creates a one time payment in Spreedly and returns the unique transaction id
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param additionalPaymentDataMap                         map<String, Object> which contains key transactionToken which corresponds to a ucinn_ascendv2__Transaction_Data__c Id, which can just be executed on
     *
     * @return Spreedly transaction Id which can be used to search for the specific transaction in Spreedly dashboard
     */
    public override PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params) {
        Map<String, Object> additionalPaymentDataMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS)));
        String transactionToken = (String) additionalPaymentDataMap?.get(TRANSACTION_TOKEN_KEY);
        Decimal amount = (Decimal.valueOf(String.valueOf(params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY))));

        if(String.isBlank(transactionToken)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'No transaction Token passed to createOneTimePayment'
            });
        }

        ucinn_ascendv2__Transaction_Data__c transactionToCheck = [
            SELECT
                ucinn_ascendv2__Request__c,
                ucinn_ascendv2__Response__c,
                ucinn_ascendv2__Reason_Code__c
            FROM
                ucinn_ascendv2__Transaction_Data__c
            WHERE
                Id = :transactionToken
        ];


        Map<String, Object> requestJson =  (Map<String, Object>)JSON.deserializeUntyped(transactionToCheck.ucinn_ascendv2__Request__c);
        Decimal requestAmount = Decimal.valueOf(String.valueOf(((Map<String, Object>)requestJson.get('transaction')).get('amount')));

        //multiply by 100 since Spreedly works in cents as integers
        if (amount * 100 != requestAmount || transactionToCheck.ucinn_ascendv2__Reason_Code__c != '100' || !String.isEmpty(transactionToCheck.ucinn_ascendv2__Response__c)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Idempotent token was invalid. ' + amount + ' vs ' + requestAmount + ' reason: ' + transactionToCheck.ucinn_ascendv2__Reason_Code__c + ' response: ' + transactionToCheck.ucinn_ascendv2__Response__c});
        }

        Map<String, Object> paymentParams = new Map<String, Object>();
        paymentParams.put(TRANSACTION_TOKEN_KEY, transactionToken);

        ucinn_ascendv2__Transaction_Data__c transactionData = new ucinn_ascendv2__Transaction_Data__c();
        if (!test.isRunningTest()) { //since we don't always know exactly what base ascend will do, we can't simply mock callout and instead just skip over it
            transactionData = ucinn_ascendv2.ascend_SPREEDLY_CheckoutController.SERVER_executeTransaction(paymentParams);

            if (!transactionData.ucinn_ascendv2__Is_Success__c) {
                throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Payment was unsuccessful Please check your credit card details and retry.'});
            }
        }

        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        responseWrapper.transactionId = transactionData.ucinn_ascendv2__Request_ID__c;
        responseWrapper.reviewTransactionFieldMap.put('ucinn_portal_Payment_Gateway_Type__c', PORTAL_CONST_OnlineGiving.SPREEDLY_PAYMENT_METHOD_NAME);

        return responseWrapper;
    }

    /**
     * for one time payments, base ascend requires using idempotent tokens to process, so before the main execute we need to create the token
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentId                         payment token generated by the IFrame on the frontend corresponding to the credit card used
     * @param additionalPaymentDataMap          optional additional params for bank ACH payment data
     * @param externalGatewayName               The name of the Spreedly gateway to use. Must match a custom setting record for the object ucinn_ascendv2__Spreedly_Gateway__c
     * @param amount                            The amount to charge the card in USD
     *
     * @return Spreedly transaction Id which can be used to search for the specific transaction in Spreedly dashboard
     */
    public virtual String getTransactionToken(Map<String, Object> params) {
        String gatewayRecordName = (String) params.get(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY);
        String gatewayToken = getGatewayToken(gatewayRecordName);
        Map<Object, Object> additionalPaymentDataMap = (Map<Object, Object>) params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS);
        String paymentMethodToken = (String) params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        Integer amount = Integer.valueOf(100*(Decimal.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)))));

        if (additionalPaymentDataMap != null && (String)additionalPaymentDataMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PAYMENT_METHOD_BANK) {
            RetainResponseWrapper retainWrapper = retainBankAccount(additionalPaymentDataMap);
            paymentMethodToken = retainWrapper.paymentToken;
        }

        Map<String, Object> paymentParams = new Map<String, Object>();
        paymentParams.put(GATEWAY_TOKEN_KEY, gatewayToken);
        paymentParams.put(PAYMENT_METHOD_TOKEN_KEY, paymentMethodToken);
        paymentParams.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, amount);

        String currencyCode = PORTAL_CONST_OnlineGiving.USD_CURRENCY_CODE;

        List<Portal_Organization_Setting__mdt> settings = [SELECT DeveloperName, Value__c FROM Portal_Organization_Setting__mdt
                                                            WHERE DeveloperName = :ORG_CURRENCY AND Value__c != null];
        if (settings != null && !settings.isEmpty()) {
            currencyCode = settings.get(0).Value__c;
        }
        paymentParams.put(PORTAL_CONST_OnlineGiving.CURRENCY_CODE_KEY, currencyCode);

        String transactionToken = '';
        if (!test.isRunningTest()) { //since we don't always know exactly what base ascend will do, we can't simply mock callout and instead just skip over it
            transactionToken = (String) ucinn_ascendv2.ascend_SPREEDLY_CheckoutController.SERVER_getTransactionToken(paymentParams);
        }

        return transactionToken;
    }

    /**
     * helper function to request and validate the environment token from base ascend's getter
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param gatewayRecordName         String for the name of the gateway custom setting record
     *
     * @return                          environment token
     */
    protected virtual String getGatewayToken(String gatewayRecordName) {
        if (Test.isRunningTest()) {
            return gatewayRecordName;
        }
        System.debug(gatewayRecordName);

        ucinn_ascendv2__Spreedly_Gateway__c gatewayTokenRecord = ucinn_ascendv2__Spreedly_Gateway__c.getValues(gatewayRecordName);

        if (gatewayTokenRecord == null || String.isBlank(gatewayTokenRecord.ucinn_ascendv2__Token__c)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'gateway record name: ' + gatewayRecordName + ', gateway record received: ' + gatewayTokenRecord
            });
        }

        return gatewayTokenRecord.ucinn_ascendv2__Token__c;
    }


    /**
     * retains the supplied card by token and puts Spreedly recurring/pledge gift specific fields onto the RTv2 record
     *
     * @author                  Sam Longo
     * @since                   1.0
     *
     * @param paymentId                         payment token generated by the IFrame on the frontend corresponding to the credit card used
     * @param externalGatewayName               The name of the Spreedly gateway to use. Must match a custom setting record for the object ucinn_ascendv2__Spreedly_Gateway__c
     * @param giftType                          The type of gift being created, used to differentiate between handling the payments through installments for a pledge, or from paying off the designation detail like a recurring gift (without distinguishing, pledges would get charged twice)
     * @param reviewTransaction                 The review transaction record to edit additional fields on
     * @param startDate                         The Date for when the payments should begin i.e. recurring payments that begin on the end of the month instead of immediate
     *
     * @return Spreedly transaction Id which can be used to search for the specific transaction in Spreedly dashboard
     */
    public override String createSubscription(Map<String, Object> params) {
        //TODO: add a one time charge for the remainder of a pledge payment
        //FUTURE TODO: base ascend will add the retain end point at some point in the future so we can do away with needing our own named credential, and simplify this code once that happens
        String gatewayRecordName = (String)params.get(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY);
        String giftType = (String)params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = (ucinn_ascendv2__Review_Transaction_v2__c)params.get(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY);
        Map<Object, Object> additionalPaymentDataMap = (Map<Object, Object>)params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS);
        String transientPaymentId = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);

        Date startDate = Date.today();
        if (params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)))) {
            startDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
        }

        //retain the card/bank account
        RetainResponseWrapper retainWrapper;
        if (additionalPaymentDataMap != null && (String)additionalPaymentDataMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PAYMENT_METHOD_BANK) {
            retainWrapper = retainBankAccount(additionalPaymentDataMap);
        } else {
            retainWrapper = retainCreditCard(transientPaymentId);
        }
        String transactionId = retainWrapper.transactionId;
        String retainedPaymentToken = retainWrapper.paymentToken;

        //add fields to the rtv2 record
        reviewTransaction.ucinn_portal_Encrypted_Payment_Info__c = retainedPaymentToken;
        reviewTransaction.ucinn_portal_Payment_Gateway_Type__c = PORTAL_CONST_OnlineGiving.SPREEDLY_PAYMENT_METHOD_NAME;
        reviewTransaction.ucinn_portal_Payment_Gateway_Settings__c = gatewayRecordName;

        if (giftType.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.RECURRING_TYPE) || giftType.equalsIgnoreCase(PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE)) {
            reviewTransaction.ucinn_portal_Detail_Auto_Payments__c = true; // for recurring gifts
        } else {
            reviewTransaction.ucinn_portal_Installment_Auto_Payments__c = true; //for pledges
        }

        reviewTransaction.ucinn_portal_Recurring_Payment_Date__c = startDate;

        return transactionId;
    }

    /**
     * Creates a payment method for the given wallet type.
     * 
     * @author Aaron Wong
     * 
     * @param walletName    The name of the wallet type.
     * @param walletToken   The tokenized payment method from the wallet.
     * @return              The payment method identifier for Spreedly.
     * @since               1.0
     */
    public override String createWalletPaymentMethod(WalletType walletName, String walletToken) {
        if (!SUPPORTED_WALLET_TYPE_LIST.contains(walletName)) {
            return '';
        }

        if (walletName == WalletType.GooglePay) {
            return createGooglePayPaymentMethod(walletToken);
        }

        if (walletName == WalletType.ApplePay) {
            return createApplePayPaymentMethod(walletToken);
        }

        return '';
    }

    /**
     * Creates a Spreedly payment method with the given tokenized google pay payment method.
     * 
     * @author Aaron Wong
     * 
     * @param googlePayToken    The tokenized google pay payment method.
     * @return                  The spreedly payment method identifier.
     * @since                   1.0
     */
    protected virtual String createGooglePayPaymentMethod(String googlePayToken) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + '/v1/payment_methods.json');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/JSON');

        String spreedlyTestCard = getSpreedlyWalletTestCard();

        String body = '{"payment_method": {"google_pay": {"payment_data": ' + googlePayToken + '';

        if (String.isNotBlank(spreedlyTestCard)) {
            body = body + ', "test_card_number": "' + spreedlyTestCard + '"}}}';
        } else {
            body = body + '}}}';
        }

        request.setBody(body);

        Map<String, Object> bodyJSON = (Map<String, Object>)JSON.deserializeUntyped(body);

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        if (String.isBlank(responseBody) || response.getStatusCode() < 200 || response.getStatusCode() >= 300 ) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Failed to create payment method using Google Pay, request excluded from this stacktrace. response string: ' + responseBody
            });
        }

        Map<String, Object> responseJson = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        return (String)((Map<String, Object>)((Map<String, Object>)responseJson.get(TRANSACTION_KEY)).get(PAYMENT_METHOD_API_ATTRIBUTE)).get(TOKEN_KEY);
    }

    /**
     * Creates a Spreedly payment method with the given tokenized apple pay payment method.
     * 
     * @author Aaron Wong
     * 
     * @param applePayToken     The tokenized apple pay payment method.
     * @return                  The spreedly payment method identifier.
     * @since                   1.0
     */
    protected virtual String createApplePayPaymentMethod(String applePayToken) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + '/v1/payment_methods.json');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/JSON');

        String spreedlyTestCard = getSpreedlyWalletTestCard();

        String body = '{"payment_method": {"apple_pay": {"payment_data": ' + applePayToken + '';

        if (String.isNotBlank(spreedlyTestCard)) {
            body = body + ', "test_card_number": "' + spreedlyTestCard + '"}}}';
        } else {
            body = body + '}}}';
        }

        request.setBody(body);

        Map<String, Object> bodyJSON = (Map<String, Object>)JSON.deserializeUntyped(body);

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        if (String.isBlank(responseBody) || response.getStatusCode() < 200 || response.getStatusCode() >= 300 ) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Failed to create payment method using Apple Pay, request excluded from this stacktrace. response string: ' + responseBody
            });
        }

        Map<String, Object> responseJson = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        return (String)((Map<String, Object>)((Map<String, Object>)responseJson?.get(TRANSACTION_KEY))?.get(PAYMENT_METHOD_API_ATTRIBUTE))?.get(TOKEN_KEY);
    }

    /**
     * Gets a test card for spreedly wallet stored in Portal Organization Settings.
     * 
     * @author Aaron Wong
     * 
     * @return Test card number, if any.
     */
    private static String getSpreedlyWalletTestCard() {
        return PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => SPREEDLY_TEST_CARD});
    }

    /**
     * 
     * puts the bank account into Spreedly's secure vault and returns the payment token
     *
     * @author                  Sam Longo
     * @since                   1.0
     *
     * @param fullName                  first and last name of bank account owner
     * @param bankRoutingNumber         bank routing number
     * @param bankAccountNumber         bank accout number
     * @param bankAccountType           bank account type (valid values: "checking" or "savings")
     * @param bankAccountHolderType     bank account holder type (valid values: "personal" or "business")
     * @param billingInformation        map with address info, email
     *
     * @return unique token for using the payment method with spreedly
     */
    @TestVisible
    protected virtual RetainResponseWrapper retainBankAccount(Map<Object, Object> additionalPaymentDataMap) {
        String body = getRetainBankAccountBody(additionalPaymentDataMap);
        if (String.isBlank(body)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Missing required bank account fields'
            });
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + '/v1/payment_methods.json');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/JSON');
        request.setBody(body);

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        if (String.isBlank(responseBody) || response.getStatusCode() < 200 || response.getStatusCode() >= 300 ) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Failed to retain bank account, request excluded from this stacktrace. response string: ' + responseBody
            });
        }

        return new RetainResponseWrapper(responseBody);
    }

    /**
     * Build the JSON body string for the retain bank account callout 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param fullName                  first and last name of bank account owner
     * @param bankRoutingNumber         bank routing number
     * @param bankAccountNumber         bank accout number
     * @param bankAccountType           bank account type (valid values: "checking" or "savings")
     * @param bankAccountHolderType     bank account holder type (valid values: "personal" or "business")
     * @param billingInformation        map with address info, email
     * 
     * @return JSON string for the http request body
     */
    protected virtual String getRetainBankAccountBody(Map<Object, Object> additionalPaymentDataMap) {
        String fullName = (String)additionalPaymentDataMap?.get(FULL_NAME_KEY);
        String bankRoutingNumber = (String)additionalPaymentDataMap?.get(BANK_ROUTING_NUMBER_KEY);
        String bankAccountNumber = (String)additionalPaymentDataMap?.get(BANK_ACCOUNT_NUMBER_KEY);
        String bankAccountType = (String)additionalPaymentDataMap?.get(BANK_ACCOUNT_TYPE_KEY);
        String bankAccountHolderType = (String)additionalPaymentDataMap?.get(BANK_ACCOUNT_HOLDER_KEY);
        Map<Object, Object> billingInformation = (Map<Object, Object>)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY);

        if (String.isBlank(fullName) || String.isBlank(bankRoutingNumber) || String.isBlank(bankAccountNumber)) {
            return '';
        }

        String billingInformationString = '';
        if (billingInformation != null) {
            for (Object eachKey : billingInformation.keySet()) {
                if (String.isNotBlank((String) billingInformation.get(eachKey))) {
                    billingInformationString += '"' + eachKey + '": "' + billingInformation.get(eachKey) + '", ';
                }
            }
        }

        return  '{"payment_method": {' + 
                    '"retained": true, ' + 
                    '"bank_account": {' + 
                        billingInformationString + 
                        '"full_name": "' + fullName + '", ' + 
                        '"bank_routing_number": "' + bankRoutingNumber + '", ' + 
                        '"bank_account_number": "' + bankAccountNumber + '", ' + 
                        '"bank_account_type": "' + bankAccountType + '", ' + 
                        '"bank_account_holder_type": "' + bankAccountHolderType + '"' + 
                    '}' + 
                '}}';
    }


    /**retains a given transient payment If from the IFrame and vaults it in spreedly so it can be used for later payments
     *
     * @author                  Sam Longo
     * @since                   1.0
     *
     * @param String transientPaymentId             payment Id from Iframe
     *
     * @return RetainResposneWrapper with id fields filled
     */
    protected virtual RetainResponseWrapper retainCreditCard(String transientPaymentId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + '/v1/payment_methods/'+ transientPaymentId +'/retain.json');
        request.setMethod('PUT');

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        if (String.isBlank(responseBody) || response.getStatusCode() < 200 || response.getStatusCode() >= 300 ) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR});
        }

        return new RetainResponseWrapper(responseBody);
    }

    /**
     * callout to Spreedly's Payment Method Show endpoint to get credit card information for the given payment ID
     * 
     * @author Jacob Huang
     * 
     * @param String paymentMethodToken       payment method token representing a credit card 
     * 
     * @return      Map of 
     * 
     */
    @TestVisible
    protected virtual Map<String, Object> getSingleCreditCardDigits(String paymentMethodToken) {
        if (String.isBlank(paymentMethodToken)) {
            return new Map<String, Object>();
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + 'v1/payment_methods/' + paymentMethodToken + '.json');
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        if (String.isBlank(responseBody)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR});
        }

        Map<String, Object> responseMap = (Map<String, Object>) System.JSON.deserializeUntyped(responseBody);
        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300 ) {
            List<Object> errorList = (List<Object>) responseMap.get(SPREEDLY_ERROR_ERRORS_KEY);
            Map<String, Object> errorMap = (Map<String, Object>) (errorList?.get(0));
            throw new CalloutException((String) errorMap?.get(SPREEDLY_ERROR_KEY_KEY));
        }
        
        return (Map<String, Object>) responseMap.get(PAYMENT_METHOD_KEY);
    }

    /**
     * For a gift with a subscription (pledge or recurring), update the 
     * credit card information
     *
     * @author Jacob Huang
     * 
     * @param giftId                    String: ID of the Opportunity
     * @param subscriptionId            String: external ID for the gift's associated subscription
     * @param paymentId                 String: new ID received from the payment processor representing the credit card
     * @param paymentMethod             String: payment processor used (Stripe, Spreedly, Cybersource)
     * @param cont                      Contact: contact for logged in user
     * @param externalPaymentGatewayId  String: for Cybersource: merchant reference code of the initial subscription transaction
     * 
     * @return                          String: last 4 digits of new credit card, null if failure
     */
    public override String updateSubscriptionCreditCard(Map<String, Object> params) {
        String giftId = (String) params?.get(PORTAL_CONST_OnlineGiving.GIFT_ID_KEY);
        String paymentId = (String) params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        if (String.isBlank(giftId) || String.isBlank(paymentId)) {
            return null;
        }
        
        RetainResponseWrapper retainWrapper = retainCreditCard(paymentId);
        if (paymentId != retainWrapper.paymentToken) {
            return null;
        }

        Opportunity gift = new Opportunity(Id = giftId, ucinn_ascendv2__Encrypted_Payment_Information__c = paymentId, ucinn_ascendv2__Card_Expiration_Date__c = null); 
        update gift;
        return retainWrapper.lastFourCreditCardDigits;
    }

    /**
     * Return the last 4 digits of the credit card used for all of a user's subscription gifts
     * 
     * @author Jacob Huang
     * 
     * @param cont                          Contact: contact for logged in user
     * @param creditCardIdList              List<String>: payment or subscription (depends on payment method) IDs to get last 4 credit card digits for
     * @param externalPaymentGatewayIdList  List<String>: list of external payment gateway IDs, length/ordering corresponds to creditCardIdList
     * 
     * @return      map of string ID to string of last 4 credit card digits 
     */
    public override Map<String, String> getCreditCardIdToLastFourDigitsMap(Map<String, Object> params) {
        Map<String, String> returnMap = new Map<String, String>();
        List<Object> paymentTokenList = (List<Object>) params?.get(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY);
        if (paymentTokenList == null || paymentTokenList.isEmpty()) {
            return returnMap;
        }

        for (Object eachPaymentToken : paymentTokenList) {
            try {
                Map<String, Object> paymentMethod = getSingleCreditCardDigits((String) eachPaymentToken);
                String lastFourDigits = (String) paymentMethod.get(PAYMENT_METHOD_LAST_FOUR_DIGITS_KEY);
                // for bank account, last 4 digits is null
                if (String.isNotBlank(lastFourDigits)) {
                    returnMap.put((String) eachPaymentToken, lastFourDigits);
                }
            }
            catch (CalloutException e) {
                // if the payment token doesn't exist, just skip over it and return what does exist; other exceptions are errors
                if (e.getMessage() != PAYMENT_METHOD_SHOW_INVALID_TOKEN) {
                    throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_SPREEDLY_ERROR});
                }
            }
        }

        return returnMap;
    }

    /**     
     * Cancel a constituent's existing subscription-based gift (pledge or recurring gift)
     * 
     * @author Jacob Huang
     * 
     * @param paymentMethod             String: payment processor used (Stripe, Spreedly, Cybersource)
     * @param giftType                  String: 'pledge' or 'recurring'
     * @param subscriptionId            String: external ID for the gift's associated subscription
     * @param externalPaymentGatewayId  String: merchant reference code of initial subscription transaction
     */
    public override void cancelSubscription(Map<String, Object> params) {
        // no API callouts are necessary, and the caller will end up updating the Opportunity so the ascend batch no longer autopays it
        //      specifically, when Opportunity StageName is not Active, the batch will not query for it
        return;
    }

        
    /**
     * Returns the payment method tender type used to conduct the transaction
     *
     * @author:             Todd Shinto
     * @since:              1.4
     *
     * @param paymentMethod The payment method from the additional payment map
     *
     * @return              Payment method tender type
     */
    public virtual override String getReviewTransactionTenderType(Map<Object, Object> additionalPaymentDataMap) {
        if (String.isBlank((String)additionalPaymentDataMap?.get((Object)PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY))) {
            return PORTAL_CONST_OnlineGiving.CREDIT_CARD;
        }

        return (String)additionalPaymentDataMap?.get((Object)PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PAYMENT_METHOD_BANK ? PORTAL_CONST_OnlineGiving.ACH_CONST : PORTAL_CONST_OnlineGiving.CREDIT_CARD;
    }
}