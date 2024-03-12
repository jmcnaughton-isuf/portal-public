/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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
 * Controller for TouchNet to handle external callouts and payments
 *
 * @author  Phillip Nguyen
 * @since   1.5
 */
public inherited sharing virtual class PORTAL_TouchNetPaymentGateway extends PORTAL_PaymentGateway {
    public static final String GENERIC_ERROR_MESSAGE = 'There was an error processing your gift. Please contact an administrator.';
    public static final String ENCRYPTED_PAYMENT_INFORMATION = 'ucinn_portal_Encrypted_Payment_Info__c';
    public static final String PORTAL_EXTERNAL_GATEWAY_STATUS = 'ucinn_portal_Ext_Payment_Gateway_Status__c';
    public static final String EXTERNAL_PAYMENT_GATEWAY_ID = 'ucinn_ascendv2__External_Payment_Gateway_ID__c';

    public static final String TICKET_NAME = 'ticketName';
    public static final String NAME_VALUE_PAIRS = 'nameValuePairs';
    public static final String NAME_CONST = 'name';
    public static final String VALUE_CONST = 'value';
    public static final String BODY_CONST = 'Body';
    public static final String TICKET_CONST = 'ticket';
    public static final String GENERATE_SECURE_LINK_TICKET_RESPONSE = 'generateSecureLinkTicketResponse';
    public static final String TOUCHNET_UPAY_SITE = 'touchNetUPaySite';
    public static final String TOUCHNET_UPAY_SITE_ID = 'touchNetUPaySiteId';
    public static final String TOUCHNET_REST_RESOURCE_SITE = 'touchNetRestResourceSite';
    public static final String FAULT_UPPERCASE_CONST = 'Fault';
    public static final String FAULT_LOWERCASE_CONST = 'fault';
    public static final String CODE_CONST = 'code';
    public static final String FAULT_CODE = 'faultcode';
    public static final String DETAIL_CODE = 'detail';
    public static final String ACTIVE_CONST = 'Active';
    public static final String CHARGED_CONST = 'Charged';
    public static final String RECEIPT_NUMBER = 'receiptNumber';
    public static final String AUTHORIZE_ACCOUNT_REQUEST = 'authorizeAccountRequest';
    public static final String AUTHORIZE_ACCOUNT_RESPONSE = 'authorizeAccountResponse';
    public static final String CREDIT_RESPONSE = 'creditResponse';
    public static final String AUTHORIZE_RECURRING_ACCOUNT_REQUEST = 'authorizeRecurringAccountRequest';

    public static final String TOUCHNET_UPAY_SITE_DEVELOPER_NAME = 'TouchNet_Upay_Site';
    public static final String TOUCHNET_UPAY_SITE_ID_DEVELOPER_NAME = 'TouchNet_Upay_Site_Id';
    public static final String TOUCHNET_REST_RESOURCE_SITE_SECURE_DEVELOPER_NAME = 'TouchNet_Rest_Resource_Site';
    public static final String TOUCHNET_API_USERNAME_DEVELOPER_NAME = 'TouchNet_API_Username';
    public static final String TOUCHNET_API_PASSWORD_DEVELOPER_NAME = 'TouchNet_API_Password';
    public static final String TOUCHNET_T_LINK_DEVELOPER_NAME = 'TouchNet_T_Link';

    private static final String TOUCHNET_API_T_LINK_URL = 'https://test.secure.touchnet.net:8703/C30006test_tlink/services/TPGSecureLink';

    /**
     * Get TouchNet settings from CMT, this includes CMT from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @return  TouchNet settings which includes the uPay site, the uPay Site Id, and the Rest Resource Site (used for webhook)
     */
    public virtual Map<String, Object> getTouchNetSettings() {
        Map<String, Object> returnMap = new Map<String, Object>();

        returnMap.put(TOUCHNET_UPAY_SITE, PORTAL_Utils.getSecureMetadata(TOUCHNET_UPAY_SITE_DEVELOPER_NAME));
        returnMap.put(TOUCHNET_UPAY_SITE_ID, PORTAL_Utils.getSecureMetadata(TOUCHNET_UPAY_SITE_ID_DEVELOPER_NAME));
        returnMap.put(TOUCHNET_REST_RESOURCE_SITE, PORTAL_Utils.getSecureMetadata(TOUCHNET_REST_RESOURCE_SITE_SECURE_DEVELOPER_NAME));

        return returnMap;
    }

    /**
     * Function that constructs request with info we want to send and sends request.
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param ticketName        Name of ticket (we generate this value) which TouchNet Requires
     * @param nameValuePairs    String of Information to send to touchnet
     * 
     * @return                  Returns ticket string that TouchNet gives us             
     */
    public virtual String generateSecureLinkTicket(Map<String, Object> params) {
        String returnString = '';

        if (params == null || params.isEmpty()) {
            return returnString;
        }

        String ticketName = (String)params.get(TICKET_NAME);
        List<Object> nameValuePairs = (List<Object>)params.get(NAME_VALUE_PAIRS);

        String touchNetRequestString = constructGenerateSecureLinkTicketRequest(ticketName, constructNameValuePairs(nameValuePairs));

        HttpResponse response = executeSOAPRequest(touchNetRequestString);
        return parseTouchNetResponse(response, new List<String>{GENERATE_SECURE_LINK_TICKET_RESPONSE, TICKET_CONST});
    }

    /**
     * create and charge a payment intent. Pass in the session Id as the payment Id for this.
     * TouchNet sessionId contains all information when making the payment.
     * For one time gift, we do not have to include the amount to charge
     *
     * @author  Phillip Nguyen
     * @since   1.5
     *
     * @param paymentId                 session identifier that touchnet sends us
     *
     * @return                          the PORTAL_PaymentResponseWrapper for touchnet one time payment
     */
    public virtual override PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params) {
        String paymentId = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);

        if (String.isBlank(paymentId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Payment Id is blank', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }

        String receiptNumber = chargeOneTimePayment(paymentId);

        if (String.isBlank(receiptNumber) && !Test.isRunningTest()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Transaction was unsuccessful', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }

        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        responseWrapper.transactionId = paymentId;
        responseWrapper.reviewTransactionFieldMap = new Map<String, Object>{ENCRYPTED_PAYMENT_INFORMATION => paymentId,
                                                                            PORTAL_EXTERNAL_GATEWAY_STATUS => CHARGED_CONST,
                                                                            EXTERNAL_PAYMENT_GATEWAY_ID => receiptNumber
                                                                            };

        return responseWrapper;
    }

    /**
     * Charge one time payment to touchnet
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   paymentId   this will be the session_identifier that touchnet gave us earlier in the flow
     * 
     * @return              Returns the receipt number if the payment was successful
     */
    protected virtual String chargeOneTimePayment(String paymentId) {
        if (String.isBlank(paymentId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Payment Id is blank', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }

        String requestBody = constructPaymentRequestBody(paymentId, '');

        if (String.isBlank(requestBody)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Request Body is blank', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }

        HttpResponse response = executeSOAPRequest(requestBody);
        if (isTouchNetPaymentSuccessful(response) == true) {
            return parseTouchNetResponse(response, new List<String>{AUTHORIZE_ACCOUNT_RESPONSE, CREDIT_RESPONSE, RECEIPT_NUMBER});
        } else {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Payment Callout Failed', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * create subscription for touchnet, we only send payment if the start date is today
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     *
     *
     * @param paymentId:                the session identifier that touchnet sends us
     * @param amount:                   the amount to charge in dollars
     * @param startDate:                the date the payments should start
     * @param reviewTransaction         the reviewTransaction to update
     * @param giftType:                 String: type of gift, only used for determining Membership type
     * @param numberOfInstallments:     Integer: number of installments
     *
     * @return                          the subscription id to be used as an external id
     */
    public virtual override String createSubscription(Map<String, Object> params) {
        String paymentId = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        Decimal amount = (Decimal)params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY);
        Date startDate = (Date)params?.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY);
        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = (ucinn_ascendv2__Review_Transaction_v2__c)params?.get(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY);
        String giftType = (String)params?.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        Integer numberOfInstallments = (Integer)params?.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY);

        if (String.isBlank(paymentId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE
            });
        }

        // according to Cedric, only these fields need to be populated
        reviewTransaction.ucinn_portal_Encrypted_Payment_Info__c = paymentId; 
        reviewTransaction.ucinn_portal_Ext_Payment_Gateway_Status__c = ACTIVE_CONST;
        reviewTransaction.ucinn_portal_Payment_Gateway_Type__c = PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME;

        if (startDate > Date.today()) {  // Don't make payment if the start date is in the future
            return paymentId;
        }

        // same condition and calculation as Payment Hub
        if (giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE && numberOfInstallments != null && numberOfInstallments != 0) {
            amount = (amount / numberOfInstallments).setScale(2);
        }

        validateSubscriptionParams(amount);

        String receiptNumber = createTouchNetSubscriptionPayment(paymentId, String.valueOf(Integer.valueOf(amount * 100)));
        reviewTransaction.ucinn_ascendv2__External_Payment_Gateway_ID__c = receiptNumber;

        return paymentId;
    }

    /**
     * Creates payment to touchnet for automatic payments
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   paymentId       Session Id for TouchNet
     * @param   amount          Amount in cents to pay in the form of a string
     * 
     * @return                  Return receipt number if successful
     */
    protected virtual String createTouchNetSubscriptionPayment(String paymentId, String amount) {
        String returnString = '';

        if (String.isBlank(paymentId) || String.isBlank(amount)) {
            return returnString;
        }

        String requestBody = constructPaymentRequestBody(paymentId, amount);

        HttpResponse response = executeSOAPRequest(requestBody);
        if (isTouchNetPaymentSuccessful(response) == true) {
            return parseTouchNetResponse(response, new List<String>{AUTHORIZE_ACCOUNT_RESPONSE, CREDIT_RESPONSE, RECEIPT_NUMBER});
        } else {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Payment Callout Failed', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * Make the callout to TouchNet
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   requestBody     SOAP envelope body for the HTTP request
     * 
     * @return                  Return response from TouchNet
     */ 
    protected virtual HttpResponse executeSOAPRequest(String requestBody) {
        String apiUsername = PORTAL_Utils.getSecureMetadata(TOUCHNET_API_USERNAME_DEVELOPER_NAME);
        String apiPassword = PORTAL_Utils.getSecureMetadata(TOUCHNET_API_PASSWORD_DEVELOPER_NAME);
        String apiTLink = !Test.isRunningTest() ? PORTAL_Utils.getSecureMetadata(TOUCHNET_T_LINK_DEVELOPER_NAME) : TOUCHNET_API_T_LINK_URL;

        if (String.isBlank(requestBody) || String.isBlank(apiUserName) 
            || String.isBlank(apiPassword) || String.isBlank(apiTLink)) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE});
        }

        String base64AuthString = EncodingUtil.Base64Encode(Blob.valueOf(apiUsername + ':' + apiPassword));
        HttpRequest request = new HttpRequest();

        request.setBody(requestBody);
        request.setEndpoint(apiTLink);
        request.setHeader('Authorization', 'Basic ' + base64AuthString);
        request.setHeader('Content-Type', 'text/xml; charset=utf-8');
        request.setHeader('SOAPAction', '');
        request.setMethod('POST');

        Http http = new Http();
        return http.send(request);
    }

    /**
     * Constructs request body string for http request with proper parameters
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   session     session identifier to send to TouchNet
     * @param   amount      optional amount in cents to send to TouchNet, only for recurring payments
     * 
     * @return              Request Body to send to TouchNet for payment
     */
    protected virtual String constructPaymentRequestBody(String session, String amount) {
        String resultString = '';
        String amountString = '';
        String invoiceNumberXMLElementString = '<invoiceNumber xsi:nil="true" />';
        String authorizationHeaderString = AUTHORIZE_ACCOUNT_REQUEST;

        if (String.isBlank(session)) {
            return resultString;
        }

        // if the amount is not blank, then we are making an automatic payment
        // some of the XML values need to be changed/removed to create a valid request body to send to TouchNet
        if (String.isNotBlank(amount)) {
            amountString = '<amount>' + amount + '</amount>';
            authorizationHeaderString = AUTHORIZE_RECURRING_ACCOUNT_REQUEST;
            invoiceNumberXMLElementString = '';
        }

        resultString = 
            '<?xml version="1.0" encoding="UTF-8"?>' + 
                '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                    '<soapenv:Header/>' +
                    '<soapenv:Body>' +
                        '<' + authorizationHeaderString + ' xmlns="http://types.secureLink.touchnet.com">' + 
                            '<session>' + session + '</session>' + 
                            amountString + 
                            invoiceNumberXMLElementString +
                            '<ancillaryData xsi:nil="true" />' + 
                            '<application xsi:nil="true" />' +
                        '</' + authorizationHeaderString + '>' +
                    '</soapenv:Body>' + 
                '</soapenv:Envelope>';
        
        return resultString;
    }

    /**
     * Parses response from TouchNet when making callout for payment
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param  response     HTTP response from TouchNet
     * @return              Boolean whether response from sending payment callout was successful
     */
    protected virtual Boolean isTouchNetPaymentSuccessful(HttpResponse response) {
        DOM.Document doc = new DOM.Document();
        String responseBody = response?.getBody();

        if (String.isBlank(responseBody) || response?.getStatusCode() < 200 || response?.getStatusCode() >= 300 ) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE});
        }

        doc.load(responseBody);
        DOM.XMLNode root = doc.getRootElement();
        DOM.XMLNode body = root.getChildElement(BODY_CONST, root.getNameSpace());

        String faultCode = PORTAL_XmlParser.getXMLAttribute(new List<String>{FAULT_UPPERCASE_CONST, DETAIL_CODE, FAULT_LOWERCASE_CONST, CODE_CONST}, body);
        String userFaultCode = PORTAL_XmlParser.getXMLAttribute(new List<String>{FAULT_UPPERCASE_CONST, FAULT_CODE}, body);

        return String.isBlank(faultCode) && String.isBlank(userFaultCode);
    }

    /**
     * Returns the payment method tender type used to conduct the transaction
     *
     * @author:                         Phillip Nguyen
     * @since:                          1.5
     *
     * @param paymentMethod             The payment method from the additional payment map
     *
     * @return                          Payment method tender type
     */
    public virtual override String getReviewTransactionTenderType(Map<Object, Object> additionalPaymentDataMap) {
        if ((String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PORTAL_CONST_OnlineGiving.ACH_CONST) {
            return PORTAL_CONST_OnlineGiving.ACH_CONST;
        }

        return PORTAL_CONST_OnlineGiving.CREDIT_CARD;
    }

    /**
     * Construct Name Value pairs to send to TouchNet
     * This includes information like billing info (name, email, address)
     * Also contains info on which site we are using when we close the page, and webhook info
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   nameValuePairsList      List of Objects that contains a name and value
     * 
     * @return                          String of name value pairs to include in request to send to TouchNet
     */
    protected virtual String constructNameValuePairs(List<Object> nameValuePairsList) {
        String resultString = '';

        if (nameValuePairsList == null || nameValuePairsList.isEmpty()) {
            return resultString;
        }

        List<Object> deserializedList = (List<Object>)JSON.deserializeUntyped(JSON.serialize(nameValuePairsList));

        for (Object eachNameValuePair: deserializedList) {
            Map<String, Object> eachNameValuePairMap = (Map<String, Object>)eachNameValuePair;
            if (eachNameValuePairMap == null || eachNameValuePairMap.isEmpty()) {
                continue;
            }

            resultString += '<nameValuePairs><name>' + eachNameValuePairMap.get(NAME_CONST) + '</name><value>' + eachNameValuePairMap.get(VALUE_CONST) + '</value></nameValuePairs>';
        }

        return resultString;
    }

    /**
     * Parses response from TouchNet to retrieve xml path
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   response     HTTP response from TouchNet
     * @param   xmlPath      starting within <soap:Body>, the list of node names to follow to a single node 
     * 
     * @return               value of the node at the end of the xmlPath list
     */
    protected virtual String parseTouchNetResponse(HttpResponse response, List<String> xmlPath) {
        DOM.Document doc = new DOM.Document();

        String responseBody = response?.getBody();

        if (String.isBlank(responseBody) || response?.getStatusCode() < 200 || response?.getStatusCode() >= 300 ) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE});
        }

        doc.load(responseBody);
        DOM.XMLNode root = doc.getRootElement();
        DOM.XMLNode body = root.getChildElement(BODY_CONST, root.getNameSpace());

        return PORTAL_XmlParser.getXMLAttribute(xmlPath, body);
    }

    /**
     * Constructs xml request to send to touchnet to generate ticket
     * 
     * @author  Phillip Nguyen 
     * @since   1.5
     * 
     * @param ticketName        Name of ticket (we generate this value) which TouchNet Requires
     * @param nameValuePairs    String of Information to send to touchnet
     * 
     * @return                  Request we are sending to TouchNet
     */
    private String constructGenerateSecureLinkTicketRequest(String ticketName, String nameValuePairs) {
        String returnString = '';

        if (String.isBlank(ticketName)) {  // only requirement to touchnet is the ticket name according to documentation
            return returnString;
        }

        returnString = 
            '<?xml version="1.0" encoding="UTF-8"?>' + 
                '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                    '<soapenv:Header/>' +
                    '<soapenv:Body>' +
                        '<generateSecureLinkTicketRequest xmlns="http://types.secureLink.touchnet.com">' + 
                            '<ticketName>' + ticketName + '</ticketName>' + 
                            nameValuePairs +
                        '</generateSecureLinkTicketRequest>' +
                    '</soapenv:Body>' + 
                '</soapenv:Envelope>';

        return returnString;
    }

    /**
     * Validates amount for subscription
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   amount      Amount to pay
     */
    protected virtual void validateSubscriptionParams(Decimal amount) {
        if (amount == null || amount <= 0) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Cannot make a 0 dollar subscription.'
            });
        }
    }

    /**
     * Creates a payment method for the given wallet type.
     * 
     * @author Aaron Wong
     * 
     * @param walletName    The name of the wallet type.
     * @param walletToken   The tokenized payment method from the wallet.
     * @return              The payment method identifier for Stripe.
     * @since               1.0
     */
    public override String createWalletPaymentMethod(WalletType walletType, String walletToken) {
        return '';
    }

    /**
     * method that retrieves the stripe public api key
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     *
     * @return                          the public key to initialize the stripe credit card form to the correct account
     */
    public override String getPublicAPIKey(Map<String, Object> params) {
        return '';
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
        return '';
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
        return null;
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
        return;
    }
}