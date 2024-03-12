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
 * Base controller that contains functions for different payment methods
 *
 * @author          Phillip Nguyen
 * @version         1.0
 * @since           1.0
 */
public without sharing virtual class PORTAL_PaymentHubControllerBase {
    public static final String CUSTOM_METADATA_NAME = 'customMetadataName';
    public static final String EMPTY_STRING = '';
    public static final String DESIGNATION_CUSTOM_METADATA_NAME = 'Designations';
    public static final String PAGE_NAME = 'pageName';
    public static final String DEFAULT_GIVING_PAGE_SECTION_NAME = 'Online Giving';
    public static final String TOKEN_CONST = 'token';

    public Boolean useExternalId = false;
    public String reviewTransactionPrefix = 'PORT';

    public static final String USER_SPECIFIED_ORGANIZATIONAL_GIFT = ' User specified this is an organizational gift';
    public static final String MATCHING_COMPANY_FOR_GIFT = ' There is a matching company for this gift';
    public static final String MANUAL_REVIEW = 'Manual Review';
    public static final String STATUS_NEW = 'New';
    public static final String IS_EMAIL_EXCEPTION = 'isEmailException';

    public static final String RECORDS = 'records';
    public static final String DOUBLE_THE_DONATION = 'Double The Donation';
    public static final String EMPLOYEE_CONST ='Employee';

    public static final String REVIEW_TRANSACTION_OBJECT_API_NAME = 'ucinn_ascendv2__Review_Transaction_v2__c';
    public static final String ORGANIZATION_INTERFACE = 'Organization_Interface';
    public static final String CONTACT_ID = 'contactId';

    public static final String SALESFORCE_OAUTH_ENDPOINT = 'callout:Salesforce_OAuth';
    public static final String COMETD_CLIENT_ID_API_NAME = 'CometD_Client_Id';
    public static final String COMETD_CLIENT_SECRET_API_NAME = 'CometD_Client_Secret';
    public static final String DUMMY_API_USERNAME = 'Dummy_Api_Username';
    public static final String DUMMY_API_PASSWORD = 'Dummy_Api_Password';
    public static final String ACCESS_TOKEN = 'access_token';
    public static final String ADDRESSES_CONST = 'Addresses';
    public static final String ADDRESS_RELATIONSHIP_API = 'ucinn_ascendv2__Address__r';
    public static final String SMARTY_STREETS = 'SmartyStreets';
    
    public static PORTAL_PaymentGateway paymentInterface = null;

    public class PORTAL_PaymentResponseWrapper {
        public string transactionId; //unique Id that can identify this transaction in external service
        public Map<String, Object> reviewTransactionFieldMap = new Map<String, Object>();
    }

    public PORTAL_PaymentHubControllerBase() {}

    /**
     * Constructor which also initializes the payment interface. required in order to call getPublicApiKey or createReviewTransaction
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentMethod             the name of the payment method we are using
     *
     * @return                          the public key to initialize the credit card form to the correct account
     */
    public PORTAL_PaymentHubControllerBase(String paymentMethod) {
        setPaymentInterface(paymentMethod);
    }

    /**
     * determines which payment interface is being used from the paymentMethod and initializes the class
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentMethod             the name of the payment method we are using
     *
     * @return                          the public key to initialize the credit card form to the correct account
     */
    public virtual void setPaymentInterface(String paymentMethod) {

        if (paymentInterface != null) {
            return; //skip since already invoked this transaction (or assigned from a test)
        }

        if (String.isBlank(paymentMethod)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Missing Payment Method.'
            });
        }

        if (Test.isRunningTest()) {
            paymentInterface = new PORTAL_TestPaymentGateway();
            return;
        }

        //FUTURE TODO: add set payment params functions to all of these in place of the subscription params handled in the createreviewtransactions
        if (paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.SPREEDLY_PAYMENT_METHOD_NAME) || paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.SPREEDLY_ACH_PAYMENT_METHOD_NAME)) {
            paymentInterface = (PORTAL_SpreedlyPaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                    PORTAL_Utils.CLASS_TYPE => PORTAL_SpreedlyPaymentGateway.Class});
        } else if (paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_METHOD_NAME)) {
            paymentInterface = (PORTAL_StripePaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                    PORTAL_Utils.CLASS_TYPE => PORTAL_StripePaymentGateway.Class});
        } else if (paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.CYBERSOURCE_PAYMENT_METHOD_NAME) || paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.CYBERSOURCE_ACH_PAYMENT_METHOD_NAME)) {
            paymentInterface = (PORTAL_CybersourcePaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                PORTAL_Utils.CLASS_TYPE => PORTAL_CybersourcePaymentGateway.Class});
        } else if (paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME)) {
            paymentInterface = (PORTAL_StripePaymentElementGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                PORTAL_Utils.CLASS_TYPE => PORTAL_StripePaymentElementGateway.Class});
        } else if (paymentMethod.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME)) {
            paymentInterface = (PORTAL_TouchNetPaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                PORTAL_Utils.CLASS_TYPE => PORTAL_TouchNetPaymentGateway.Class});
        }

        if (paymentInterface == null) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Failed to initialize a payment interface'
            });
        }
    }

    /**
     * Obtains the community url for communication between the lwc and visualforce page
     *
     *
     * @author:                         Phillip Nguyen
     * @since:                          1.0
     *
     * @return                          Community url
     */
    public static String getOrigin() {
        return PORTAL_CommunityUtils.constructOrigin();
    }

    /**
     * Retrieves the external gateway public api key
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param customMetadataName:       the name of the custom metadata that stores the public key
     *
     * @return                          the public key to initialize the credit card form to the correct account
     */
    public String getAPIKey(Map<String, Object> params) {
        return paymentInterface.getPublicApiKey(params);
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
     * @param isCreatePledgeSubscription        Boolean: create a subscription for a pledge
     *
     * @return                                  Id of ascendv2__Transaction_Data__c object that corresponds with the one time payment transaction, otherwise returns '' if recurring or pledge
     */
    public virtual String getSpreedlyTransactionToken(map<String, Object> params) {
        String giftType = (String) params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        Boolean isCreatePledgeSubscription = (Boolean)params.get(PORTAL_CONST_OnlineGiving.IS_CREATE_PLEDGE_SUBSCRIPTION);

        if (this.isCreateSubscription(giftType, isCreatePledgeSubscription)) {
            return '';
        }

        PORTAL_SpreedlyPaymentGateway spreedlyGateway = (PORTAL_SpreedlyPaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                PORTAL_Utils.CLASS_TYPE => PORTAL_SpreedlyPaymentGateway.Class});

        return spreedlyGateway.getTransactionToken(params);
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
     *
     * @return                                  Stripe client secret returned from creation of Payment Intent
     */
    public virtual String getStripeClientSecret(Map<String, Object> params) {
        PORTAL_StripePaymentElementGateway stripePaymentElementGateway = (PORTAL_StripePaymentElementGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
            PORTAL_Utils.CLASS_TYPE => PORTAL_StripePaymentElementGateway.Class});

        return stripePaymentElementGateway.getClientSecret(params);
    }

    /**
     * Gets the merchant Id for the Cybersource payment gateway.
     * 
     * @author Aaron Wong
     * 
     * @return Cybersource Merchant Id
     * @since  1.0
     */
    public virtual String getCybersourceMerchantId(Map<String, Object> params) {
        PORTAL_CybersourcePaymentGateway cybersourceGateway = (PORTAL_CybersourcePaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                                                            PORTAL_Utils.CLASS_TYPE => PORTAL_CybersourcePaymentGateway.Class});

        return cybersourceGateway.getMerchantId();
    }

    /**
     * Get TouchNet settings from CMT, this includes CMT from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @return  TouchNet settings which includes the uPay site, the uPay Site Id, and the Rest Resource Site (used for webhook)
     */
    public virtual Map<String, Object> getTouchNetSettings() {
        PORTAL_TouchNetPaymentGateway touchNetGateway = (PORTAL_TouchNetPaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                                                            PORTAL_Utils.CLASS_TYPE => PORTAL_TouchNetPaymentGateway.Class});

        return touchNetGateway.getTouchNetSettings();
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
        PORTAL_TouchNetPaymentGateway touchNetGateway = (PORTAL_TouchNetPaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                                                            PORTAL_Utils.CLASS_TYPE => PORTAL_TouchNetPaymentGateway.Class});

        return touchNetGateway.generateSecureLinkTicket(params);
    }

    /**
     * Grabs session Id for CometD
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @return                  Returns user's session Id          
     */
    public virtual String getCometDSessionId() {
        if (String.isNotBlank(UserInfo.getSessionId())) {
            return UserInfo.getSessionId();
        }

        String requestBodyString = getOAuthRequestBodyWithConnectedAppCredentials();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SALESFORCE_OAUTH_ENDPOINT);
        req.setBody(requestBodyString);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('POST');
        HttpResponse response = http.send(req);
        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            System.debug('There was an error with getting guest user session Id');
            return null;
        }

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        return (String)responseMap.get(ACCESS_TOKEN);
    }

    /**
     * Gets request body string in the form of url parameters with connected app keys from secure CMT
     * 
     * @author  Phillip Nguyen
     * @since   1.18
     * 
     * @return  Request Body String
     */
    private String getOAuthRequestBodyWithConnectedAppCredentials() {
        String cometDClientId = PORTAL_Utils.getSecureMetadata(COMETD_CLIENT_ID_API_NAME);
        String cometDClientSecret = PORTAL_Utils.getSecureMetadata(COMETD_CLIENT_SECRET_API_NAME);

        String requestBodyString = 'grant_type=client_credentials&client_id=' + cometDClientId 
                                        + '&client_secret=' + cometDClientSecret;

        return requestBodyString;
    }

    /** Review Transaction Logic Begin **/

    /**
     * method creates the subscription and gets the gateway information then calls createReviewTransactionWithGatewayInfo
     * to create the RTv2
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param endDate:                      Optional: the last day for a payment if it is a recurring gift
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param isGivingAsOrg                 Boolean that specifies whether the user is making an organizational gift
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param dtdBillingInformation:        A flat map of billing values that Double the Donation code can use
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (re-used for Cybersource)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The company id used by a matching company service, ex: HEP or DTD
     * @param matchingCompanyIntegration:   Matching company service being used (e.g. Double the Donation)
     * @param paymentId:                    The external id for the payment taken from the billing external gateway
     * @param pageName:                     The page name for the custom metadata records
     * @param appealCode:                   The external id of the appeal code to default to
     * @param paymentMethod:                The payment method we are using
     * @param emailTemplateName:            Name of the email template used to send the receipt
     * @param externalGatewayName:          Name of external gateway record that stores the gateway token/key
     * @param membershipBenefitRecords      List of membership benefit records
     * @param externalDonationIdentifier    An external identifier string for this gift, e.g. for Double the Donation 
     * @param customerId                    (Stripe) customer ID string to use
     * @param paymentOrigin                 Where the payment originated in the portal
     * @param isCreatePledgeSubscription    Boolean: create a subscription for a pledge
     * 
     * @return Map<String, Object> with receipt data for front end
     */
    public virtual Map<String, Object> createReviewTransaction(Map<String, Object> params) {
        //FUTURE TODO: take this function and move it to its own review transaction builder wrapper
        validateCreateReviewTransaction(params);

        params = getReviewTransactionParams(params);
        String giftType = (String)params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        Boolean isCreatePledgeSubscription = (Boolean)params.get(PORTAL_CONST_OnlineGiving.IS_CREATE_PLEDGE_SUBSCRIPTION);

        PORTAL_PaymentResponseWrapper paymentResponseWrapper = new PORTAL_PaymentResponseWrapper();
        if (this.isCreateSubscription(giftType, isCreatePledgeSubscription)) {
            paymentResponseWrapper = paymentInterface.createSubscriptionWithResponseWrapper(params);
        } else {
            paymentResponseWrapper = processOneTimePayment(params);
        }

        params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_FIELD_MAP, paymentResponseWrapper.reviewTransactionFieldMap);
        params.put(PORTAL_CONST_OnlineGiving.TRANSACTION_ID_KEY, paymentResponseWrapper.transactionId);

        return createReviewTransactionWithGatewayInfo(params);
    }


    /**
     * helper method to modify the review transaction params
     *
     *
     * @author: Todd Shinto
     * @since: 1.12
     *
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param endDate:                      Optional: the last day for a payment if it is a recurring gift
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param isGivingAsOrg                 Boolean that specifies whether the user is making an organizational gift
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param dtdBillingInformation:        A flat map of billing values that Double the Donation code can use
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (re-used for Cybersource)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The company id used by a matching company service, ex: HEP or DTD
     * @param matchingCompanyIntegration:   Matching company service being used (e.g. Double the Donation)
     * @param paymentId:                    The external id for the payment taken from the billing external gateway
     * @param pageName:                     The page name for the custom metadata records
     * @param appealCode:                   The external id of the appeal code to default to
     * @param paymentMethod:                The payment method we are using
     * @param emailTemplateName:            Name of the email template used to send the receipt
     * @param externalGatewayName:          Name of external gateway record that stores the gateway token/key
     * @param membershipBenefitRecords      List of membership benefit records
     * @param externalDonationIdentifier    An external identifier string for this gift, e.g. for Double the Donation 
     * @param customerId                    (Stripe) customer ID string to use
     * @param paymentOrigin                 Where the payment originated in the portal
     * @param isCreatePledgeSubscription    Boolean: create a subscription for a pledge
     * 
     * @return params to use to create the RTv2
     */
    protected virtual Map<String, Object> getReviewTransactionParams(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>(params);
        Decimal giftAmount =  Decimal.valueOf((String)params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY));
        String paymentId = ((String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY)).replaceAll('"', '');
        String contactId = (String)params?.get(CONTACT_ID);

        Integer numberOfInstallments = getNumberOfInstallments(params.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY));
        returnMap.put(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY, numberOfInstallments);
        returnMap.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, giftAmount);
        returnMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, paymentId);

        Date startDate = Date.today();
        if (params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)))) {
            startDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
        }
        returnMap.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, startDate);

        Date endDate = null;
        if (params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)))) {
            endDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)));
        }
        returnMap.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, endDate);

        Contact userContact = null;
        
        if (String.isNotBlank(contactId)) {
            userContact = PORTAL_CommunityUtils.getContactInfoFromId(contactId);
        } else {
            userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        }
        returnMap.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, userContact);

        return returnMap;
    }

    /**
     * method creates the RTv2 using information from the front end and data returned from the payment gateway
     *
     * @author: Todd Shinto
     * @since: 1.12
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param endDate:                      Optional: the last day for a payment if it is a recurring gift
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param isGivingAsOrg                 Boolean that specifies whether the user is making an organizational gift
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param dtdBillingInformation:        A flat map of billing values that Double the Donation code can use
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (re-used for Cybersource)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The company id used by a matching company service, ex: HEP or DTD
     * @param matchingCompanyIntegration:   Matching company service being used (e.g. Double the Donation)
     * @param pageName:                     The page name for the custom metadata records
     * @param appealCode:                   The external id of the appeal code to default to
     * @param paymentMethod:                The payment method we are using
     * @param emailTemplateName:            Name of the email template used to send the receipt
     * @param externalGatewayName:          Name of external gateway record that stores the gateway token/key
     * @param membershipBenefitRecords      List of membership benefit records
     * @param externalDonationIdentifier    An external identifier string for this gift, e.g. for Double the Donation 
     * @param customerId                    (Stripe) customer ID string to use
     * @param paymentOrigin                 Where the payment originated in the portal
     * @param transactionId                 The response wrapper's transaction ID
     * @param reviewTransactionFieldMap     Fields to populate on the RTv2.  Differs depending on the payment gateway
     * @param isCreatePledgeSubscription    Boolean: create a subscription for a pledge
     * @param hasAddressAutocomplete        Boolean: Is Address Autocomplete Enabled
     * 
     * @return  The receipt data for the front end
     */
    public virtual Map<String, Object> createReviewTransactionWithGatewayInfo(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        String giftType = (String)params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        Map<String, Object> tributeInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.TRIBUTE_INFORMATION)));
        Decimal giftAmount =  (Decimal)params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY);
        Boolean isGivingAsOrg = (Boolean)params.get(PORTAL_CONST_OnlineGiving.IS_GIVING_AS_ORG);
        Map<String, Object> billingInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY)));
        Map<Object, Object> additionalPaymentDataMap = (Map<Object, Object>)params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS);
        List<Object> designations = (List<Object>)params.get(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY);
        List<Object> additionalDetails = (List<Object>)params.get(PORTAL_CONST_OnlineGiving.ADDITIONAL_DETAILS);
        String matchingCompanyName = (String)params.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_NAME);
        String matchingCompanyId = (String)params.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID);
        String matchingCompanyIntegration = (String)params.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_INTEGRATION);
        Map<String, Object> dtdBillingInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION)));
        String pageName = (String)params.get(PORTAL_CONST_OnlineGiving.PAGE_SECTION_NAME);
        String pledgeId = (String)params.get(PORTAL_CONST_OnlineGiving.PLEDGE_ID_KEY);
        String emailTemplateName = (String)params.get(PORTAL_CONST_OnlineGiving.EMAIL_TEMPLATE_NAME);
        String appealCode = (String)params.get(PORTAL_CONST_OnlineGiving.APPEAL_CODE);
        String frequency = (String)params.get(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY);
        List<Map<String, Object>> membershipBenefitRecords = (List<Map<String, Object>>)params.get(PORTAL_MembershipControllerBase.MEMBERSHIP_BENEFIT_RECORDS);
        String interimSourceUrl = (String)params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
        String manualReviewReason = (String)params?.get(PORTAL_CONST_OnlineGiving.MANUAL_REVIEW_REASON);
        String contactId = (String)params?.get(CONTACT_ID);
        String externalDonationIdentifier = (String)params?.get(PORTAL_CONST_OnlineGiving.EXTERNAL_DONATION_IDENTIFIER);
        String paymentOrigin = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN);
        Date startDate = (Date)params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY);
        Date endDate = (Date)params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY);
        Integer numberOfInstallments = (Integer)params.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY);
        Contact userContact = (Contact)params.get(PORTAL_CONST_OnlineGiving.CONTACT_KEY);
        String paymentTransactionId = (String)params?.get(PORTAL_CONST_OnlineGiving.TRANSACTION_ID_KEY);
        Map<String, Object> reviewTransactionFieldMap = (Map<String, Object>)params?.get(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_FIELD_MAP);
        Boolean isCreatePledgeSubscription = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.IS_CREATE_PLEDGE_SUBSCRIPTION);
        Boolean hasAddressAutocomplete = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.HAS_ADDRESS_AUTOCOMPLETE);
        
        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);

        if (String.isNotBlank((String)params.get(PORTAL_CONST_OnlineGiving.PREFIX_KEY))) {
            reviewTransactionPrefix = (String)params.get(PORTAL_CONST_OnlineGiving.PREFIX_KEY);
        }

        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
        reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c = giftAmount;
        reviewTransaction.ucinn_ascendv2__Tender_Type_1__c = paymentInterface.getReviewTransactionTenderType(additionalPaymentDataMap);
        reviewTransaction.ucinn_ascendv2__Status__c = STATUS_NEW;

        if (String.isNotBlank(appealCode)) {
            reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c = appealCode;
        }

        if (giftType == PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE
                || giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE
                || giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE) {
            reviewTransaction.ucinn_ascendv2__Membership_Anniversary_Date_1__c = Date.valueOf((String)params.get(PORTAL_MembershipControllerBase.MEMBERSHIP_ANNIVERSERY_DATE));
            reviewTransaction.ucinn_ascendv2__Membership_Expiration_Date_1__c = Date.valueOf((String)params.get(PORTAL_MembershipControllerBase.MEMBERSHIP_EXPIRATION_DATE));
            reviewTransaction.ucinn_ascendv2__Membership_Level_External_ID_1__c = (String)params.get(PORTAL_CONST_OnlineGiving.MEMBERSHIP_EXTERNAL_ID);
            reviewTransaction.ucinn_ascendv2__Campaign__c = (Id)(String.valueOf(params.get(PORTAL_MembershipControllerBase.APPEAL_CONST)));
        }

        returnMap.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY, frequency);
        if (isOneTimePaymentType(giftType)) {
            returnMap.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY, PORTAL_CONST_PaymentHub.ONE_TIME_FREQUENCY);
        }

        returnMap.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, startDate);
        returnMap.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, endDate);

        if (String.isNotBlank(pageName)) {
            setReviewTransactionFieldMap(reviewTransaction, pageName);
        }

        if (userContact != null) {
            reviewTransaction.ucinn_ascendv2__Contact__c = userContact.Id;
        }

        List<Map<String, Object>> designationList = populateDesignationInformation(reviewTransaction, designations, giftType, frequency,numberOfInstallments, startDate);
        
        reviewTransaction.ucinn_ascendv2__External_System_Id__c = reviewTransactionPrefix + '-' + paymentTransactionId;
        reviewTransaction.ucinn_ascendv2__Transaction_ID__c = paymentTransactionId;

        for (String eachField : reviewTransactionFieldMap.keySet()) {
            reviewTransaction.put(eachField, reviewTransactionFieldMap.get(eachField));
        }

        ucinn_ascendv2__Interim__c newInterim = null;
        try {
            reviewTransaction.ucinn_ascendv2__Transaction_Date__c = Date.today();

            populateGiftType(reviewTransaction, giftType, startDate, numberOfInstallments, pledgeId);

            returnMap.put(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY, designationList);

            populateBillingInformation(reviewTransaction, billingInformation, pageName);
            populateTributeInformation(reviewTransaction, tributeInformation);
            populateAdditionalDetails(reviewTransaction, additionalDetails);
            populateMatchingCompany(reviewTransaction, matchingCompanyName, matchingCompanyId);
            populateMembershipBenefits(reviewTransaction, membershipBenefitRecords);

            if (hasAddressAutocomplete == true) {
                this.populateRTv2Geolocation(reviewTransaction, billingInformation);
            }

            String dtdDonationIdentifier = populateDtdDonationInformation(matchingCompanyIntegration, matchingCompanyId, dtdBillingInformation, isGivingAsOrg, reviewTransaction, externalDonationIdentifier);
            returnMap.put(PORTAL_CONST_OnlineGiving.EXTERNAL_DONATION_IDENTIFIER, dtdDonationIdentifier);

            newInterim = populateOrganizationalGivingInformation(reviewTransaction, billingInformation, pageName, isGivingAsOrg);
            
            PORTAL_CommunityUtils.throwTestException(null);

            if (isGivingAsOrg != true && userContact != null && String.isBlank(userContact.ucinn_portal_Stripe_Customer_ID__c) &&
                    String.isNotBlank(reviewTransaction.ucinn_portal_Stripe_Customer_ID__c) && 
                    paymentOrigin != PORTAL_CONST_OnlineGiving.ONLINE_GIVING_PAYMENT_ELEMENT 
                        && paymentOrigin != PORTAL_CONST_OnlineGiving.MEMBERSHIP_PAYMENT_ELEMENT 
                        && paymentOrigin != PORTAL_CONST_OnlineGiving.EVENTS_PAYMENT_ELEMENT
                        && paymentOrigin != PORTAL_CONST_OnlineGiving.CONTEXTUAL_GIVING_FORM_PAYMENT_ELEMENT) {
                userContact.ucinn_portal_Stripe_Customer_ID__c = reviewTransaction.ucinn_portal_Stripe_Customer_ID__c;
                update userContact;
            }

            if (String.isNotBlank(manualReviewReason)) {
                reviewTransaction.ucinn_ascendv2__Status__c = MANUAL_REVIEW;
                appendManualReviewReason(reviewTransaction, ' ' + manualReviewReason + '; ');
            }
            
            sendPlatformEvent(reviewTransaction);
        } catch (Exception e) {
            ucinn_ascendv2__Review_Transaction_v2__c errorReviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            errorReviewTransaction.ucinn_ascendv2__External_System_Id__c = String.isNotBlank(reviewTransaction?.ucinn_ascendv2__External_System_Id__c) ? reviewTransaction.ucinn_ascendv2__External_System_Id__c : reviewTransactionPrefix;
            appendManualReviewReason(errorReviewTransaction, 'Failed to create review transaction for a payment (' + e.getMessage() + ')');
            sendPlatformEvent(errorReviewTransaction);
        }

        try {
            sendGiftReceipt(emailTemplateName, designationList, reviewTransaction, startDate, endDate, frequency, giftAmount, newInterim);
        } catch (System.EmailException emailException) {
            returnMap.put(IS_EMAIL_EXCEPTION, true);
        }

        return returnMap;

    }

    /**
     * Populate Geolocation field on RTv2 by verifying address if Smarty Autocomplete is enabled with Smarty Verification API
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     * 
     * @param   reviewTransaction   The RTv2 to update
     * @param   billingInformation  Billing info map to get the address from
     * 
     */
    protected virtual void populateRTv2Geolocation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> billingInformation) {
        if (reviewTransaction == null || billingInformation == null || billingInformation.isEmpty()) {
            return;
        }

        try {
            PORTAL_AddressServiceHubControllerBase addressServiceController = (PORTAL_AddressServiceHubControllerBase)PORTAL_Utils.getControllerFactory().getAddressServiceHubController();

            if (addressServiceController?.getAddressVerificationProvider() == SMARTY_STREETS) { // Didn't invert this if statement logic just in case we add more verification providers in the future
                Map<String, Object> addressVerificationInfoMap = this.getSmartyVerificationInformation(billingInformation);
                List<PORTAL_SmartyStreetsAddressService.AddressResponse> addressResponseList = (List<PORTAL_SmartyStreetsAddressService.AddressResponse>)addressVerificationInfoMap?.get(PORTAL_SmartyStreetsAddressService.ADDRESS_INFORMATION);

                if (addressResponseList == null || addressResponseList.isEmpty()) {
                    return;
                }

                reviewTransaction.ucinn_portal_Geolocation__latitude__s = (Decimal)addressResponseList.get(0)?.metadata?.get(PORTAL_SmartyStreetsAddressService.LATITUDE_CONST);
                reviewTransaction.ucinn_portal_Geolocation__longitude__s = (Decimal)addressResponseList.get(0)?.metadata?.get(PORTAL_SmartyStreetsAddressService.LONGITUDE_CONST);
            }
        } catch (Exception e) {
            System.debug('Exception: Address Verification. ' + e);
        }
    }

    /**
     * Sends callout to Smarty to verify address and get the information back
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     * 
     * @param   billingInformation  Billing info map to get the address from
     * 
     * @return  Map containing address verification information
     */
    protected virtual Map<String, Object> getSmartyVerificationInformation(Map<String, Object> billingInformation) {
        if (billingInformation == null || billingInformation.isEmpty()) {
            return new Map<String, Object>();
        }

        List<Object> addressObjectList = (List<Object>)((Map<String, Object>)((Map<String, Object>)billingInformation.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY)).get(ADDRESSES_CONST)).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
        Map<String, Object> billingInfoAddressMap = (Map<String, Object>)((Map<String, Object>)addressObjectList.get(0)).get(ADDRESS_RELATIONSHIP_API);

        PORTAL_SmartyStreetsAddressService smartyAddressService = (PORTAL_SmartyStreetsAddressService)PORTAL_Utils.getControllerFactory().getSmartyStreetAddressService();
        return smartyAddressService.getAddressVerificationInformation(billingInfoAddressMap);
    }   

    /**
     * Indicates whether the gift type involves a single payment or multiple 
     * 
     * @since 1.0
     * 
     * @param giftType      String: The type of gift the user is giving
     * 
     * @return true if the gift type involves one-time payment
     */
    public static Boolean isOneTimePaymentType(String giftType) {
        return (giftType != PORTAL_CONST_OnlineGiving.RECURRING_TYPE
                        && giftType != PORTAL_CONST_OnlineGiving.PLEDGE_TYPE
                        && giftType != PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE
                        && giftType != PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE);
    }

    /**
     * Indicates whether to create a subscription in the payment gateway (vs. create a one-time payment).
     * 
     * @author Jacob Huang
     * @since 1.15
     * 
     * @param giftType                      String: The type of gift the user is giving
     * @param isCreatePledgeSubscription    Boolean: create a subscription for a pledge
     * 
     * @return true if there should be a subscription created
     */
    private Boolean isCreateSubscription(String giftType, Boolean isCreatePledgeSubscription) {
        return !PORTAL_PaymentHubControllerBase.isOneTimePaymentType(giftType) && !(giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE && isCreatePledgeSubscription == false);
    }

    /**
     * creates a one time transaction and returns a response wrapper with fields to map on the rtv2 record as well as a transaction id
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentId                         token that identifies the payment, different meaning per integration
     * @param externalGatewayName               if using spreedly, The name of the Spreedly gateway to use. Must match a custom setting record for the object ucinn_ascendv2__Spreedly_Gateway__c
     * @param amount                            The amount to charge the card in USD
     * @param reviewTransaction                 The review transaction record to edit additional fields on
     * @param giftType                          String: The type of gift the user is giving
     * @param isCreatePledgeSubscription        Boolean: create a subscription for a pledge
     * @param designations                      List<Map<String, Object>>: list that contains the designation information such as amount
     * @param numberOfInstallments              Integer: The number of installments if the user is making a pledge
     *
     * @return                                  Unique Transaction Id to for the rtv2 external Id
     */
    public virtual PORTAL_PaymentResponseWrapper processOneTimePayment(Map<String, Object> params) {
        String giftType = (String)params?.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        Boolean isCreatePledgeSubscription = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.IS_CREATE_PLEDGE_SUBSCRIPTION);
        if (giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE && isCreatePledgeSubscription == false) {
            Decimal amount = this.getPledgeFirstPaymentAmount((List<Object>)params.get(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY), (Integer)params.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY));
            if (amount != null) {
                // make a copy so the caller's params map doesn't get mutated
                params = new Map<String, Object>(params);
                params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, amount);
            }
        }

        return paymentInterface.createOneTimePayment(params);
    }

    /**
     * This returns 0 if there are no installments and parses the integer value from the string if there are installments
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     * @param numberOfInstallmentsObject:           Object for number of installments, null or blank if it is 0. can be either a string or a decimal literal
     *
     * @return Integer value for number of installments
     */
    protected virtual Integer getNumberOfInstallments(Object numberOfInstallmentsObject) {

        Integer numberOfInstallments = 0;
        if (numberOfInstallmentsObject != null) {
            numberOfInstallments = Integer.valueOf(numberOfInstallmentsObject);
        }

        return numberOfInstallments;
    }

    /**
     * Get the first payment amount for a pledge. 
     * The ascend logic for installments is to round (half even rounding) the average designation amount, then use whatever remains in the final payment amount.
     * Thus, for the overall pledge payment, take the sum across all designations
     * 
     * @author Jacob Huang
     * @since 1.15
     * 
     * @param designationList       List<Object>: list of designations and the amounts assigned to each (in dollars, mapped to the amount key)
     * @param numberOfInstallments  Integer: number of installments in the pledge
     * 
     * @return pledge first payment amount
     */
    @TestVisible
    private Decimal getPledgeFirstPaymentAmount(List<Object> designationList, Integer numberOfInstallments) {
        if (designationList == null || designationList.isEmpty() || numberOfInstallments == null || numberOfInstallments == 0) {
            return null;
        }

        Decimal firstPaymentAmount = 0;
        for (Object eachDesignationObject : designationList) {
            Map<String, Object> eachDesignation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(eachDesignationObject));
            Decimal designationAmount = Decimal.valueOf(String.valueOf(eachDesignation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)));
            // note: setScale(Integer) uses half even rounding by default
            firstPaymentAmount += (designationAmount / numberOfInstallments).setScale(2, RoundingMode.HALF_EVEN);
        }

        // should not have more than 2 decimal places, but just in case
        return firstPaymentAmount.setScale(2, RoundingMode.HALF_EVEN);
    }

    /**
     * This populates default fields onto the reviewtransaction record based on the associated page section settings
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     * @param reviewTransaction:          The review transaction to assign fields onto
     * @param pageName:                   The custom setting page name to use
     *
     */
    protected virtual void setReviewTransactionFieldMap(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String pageName) {
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Active_Record_Field_Map__c FROM Portal_Page_Section_Setting__mdt WHERE Page_Name__c = :pageName AND Page_Main_Section__c = :DESIGNATION_CUSTOM_METADATA_NAME AND Order_By_Clause__c != null];
        //populates required fields such as default appeals
        if (!sectionSettingList.isEmpty()) {
            Portal_Page_Section_Setting__mdt sectionSetting = sectionSettingList.get(0);
            if (String.isNotBlank(sectionSetting.Active_Record_Field_Map__c)) {
                Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped(sectionSetting.Active_Record_Field_Map__c);
                for (String field : fieldMap.keySet()) {
                    if (field == 'ucinn_ascendv2__Campaign_External_ID__c') {
                        continue;
                    }

                    reviewTransaction.put(field, fieldMap.get(field));
                }

                // Query for default appeal information based on external id
                if (fieldMap.containsKey('ucinn_ascendv2__Campaign_External_ID__c')) {
                    String appeal = (String)fieldMap.get('ucinn_ascendv2__Campaign_External_ID__c');

                    if (String.isNotBlank(reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c)) {
                        appeal = reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c;
                    }

                    reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c = appeal;
                    if (!String.isBlank(appeal)) {
                        List<Campaign> lstCampaign = [SELECT Id, ucinn_ascendv2__Motivation_Code__c FROM Campaign WHERE ucinn_ascendv2__Motivation_Code__c = :appeal];
                        if (!lstCampaign.isEmpty()) {
                            Campaign thisCampaign = lstCampaign[0];
                            reviewTransaction.put('ucinn_ascendv2__Campaign__c', thisCampaign.Id);
                        }
                    }
                }
            }
        }
    }


    /**
     * Performs null checks and other validations at the start of createReviewTransaction, throws an error if invalid.
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     *
     * @param giftType:                     The type of gift the user is giving
     * @param giftAmount:                   The total amount for the gift
     * @param startDate:                    The start of a recurring gift
     * @param endDate:                      Optional: the last day for a payment if it is a recurring gift
     */
    protected virtual void validateCreateReviewTransaction(Map<String, Object> params) {
        if (String.isBlank((String) params?.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY))) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: No gift Type was selected.'});
        }

        if (String.isBlank((String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY))) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: No payment found.'});
        }
        
        if (params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY) == null || Decimal.valueOf((String)params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)) <= 0) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: Payment Amount was negative or unspecified.'});
        }

        Boolean startExists = params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
        Boolean endExists = params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)));
        if (startExists && endExists) {
            Date startDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
            Date endDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY))); 
            if (endDate <= startDate) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: Recurring gift end date must be after the start date.'});
            }
        }
    }

    /**
     * method that populates the designation information for the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param designationList:              List that contains the designation information such as id and amount
     * @param reviewTransaction:            The review transaction record we are populating
     *
     *
     *
     */
    protected virtual List<Map<String, Object>> populateDesignationInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction,
                                                      List<Object> designationList,
                                                      String giftType,
                                                      String frequency,
                                                      Integer numberOfInstallments,
                                                      Date startDate) {

        List<Map<String, Object>> returnList = new  List<Map<String, Object>>();

        if (designationList == null || designationList.isEmpty()) {
            return returnList;
        }
        if (startDate == null || startDate <= Date.today()) {
            startDate = Date.today();
        }
        Set<String> designationIdSet = new Set<String>();

        for (Integer index = 1; index <= designationList.size(); index++) {
            String nameSpace = PORTAL_CONST_OnlineGiving.NAMESPACE;
            if (index > 5) {
                nameSpace = '';
            }

            //Map<Object, Object> designation = (Map<Object, Object>) designationList.get(index-1);
            Map<String, Object> designation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(designationList.get(index-1)));

            //need to populate installments for subscription based billing
            if (!isOneTimePaymentType(giftType)) {
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_DATE_PREFIX + index + '__c', startDate);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_FREQUENCY_PREFIX + index + '__c', frequency);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_AMOUNT_PREFIX + index+ '__c', Decimal.valueOf(String.valueOf(designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY))));
                if (giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE || giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE || giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE) {
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_PREFIX + index + '__c', numberOfInstallments);
                    if (numberOfInstallments < 2) {
                        appendManualReviewReason(reviewTransaction, ' Installment number was less than 2;');
                    }
                }
            }
            //other designations need to go into manual review
            if (designation.get('Id') == null || String.isBlank(String.valueOf(designation.get('Id'))) || String.valueOf(designation.get('Id')) == 'Other') {
                reviewTransaction.ucinn_portal_Other_Designation_Name__c = (String) designation.get('value');
                appendManualReviewReason(reviewTransaction, ' Other designations were specified;');
            } else {
                if (useExternalId == true) {
                    designationIdSet.add((String)designation.get('ucinn_ascendv2__External_System_ID__c'));
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.DESIGNATION_EXTERNAL_PREFIX + index + '__c', designation.get('ucinn_ascendv2__External_System_ID__c'));
                } else {
                    designationIdSet.add((String)designation.get('Id'));
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.DESIGNATION_PREFIX  + index + '__c', designation.get('Id'));
                }

            }

            if (startDate <= Date.today()) {
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_DATE_PREFIX + index + '_1__c', startDate);

                Decimal paymentAmount = Decimal.valueOf(String.valueOf(designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)));
                if ((giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE || giftType == PORTAL_CONST_PaymentHub.PLEDGE) && (numberOfInstallments != null && numberOfInstallments != 0)) {
                    paymentAmount = (paymentAmount / numberOfInstallments).setScale(2, RoundingMode.HALF_EVEN);
                }
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_AMOUNT_PREFIX + index + '_1__c', paymentAmount);
            }
            returnList.add(new Map<String, Object>{'Name' => (String)designation.get('Name'), PORTAL_CONST_OnlineGiving.AMOUNT_KEY => designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)});
        }

        String queryString = 'SELECT Id, ucinn_ascendv2__External_System_ID__c, ucinn_ascendv2__Default_Non_Gift_Amount__c, ucinn_ascendv2__Minimum_Gift_Amount__c FROM ucinn_ascendv2__Designation__c ';
        if (useExternalId == true) {
            queryString += ' WHERE ucinn_ascendv2__External_System_ID__c IN:designationIdSet';
        } else {
            queryString += ' WHERE Id IN:designationIdSet';
        }
        List<ucinn_ascendv2__Designation__c> designationQueryList = Database.query(queryString);

        for (ucinn_ascendv2__Designation__c eachDesignation : designationQueryList) {
            for (Integer index = 1; index <= designationList.size(); index++) {
                String nameSpace = PORTAL_CONST_OnlineGiving.NAMESPACE;
                if (index > 5) {
                    nameSpace = '';
                }
                //Map<Object, Object> eachSelectedDesignation = (Map<Object, Object>) designationList.get(index-1);
                Map<String, Object> eachSelectedDesignation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(designationList.get(index-1)));

                Boolean matchedId = false;
                if (useExternalId == true && eachSelectedDesignation.get('ucinn_ascendv2__External_System_ID__c') == eachDesignation.ucinn_ascendv2__External_System_ID__c) {
                    matchedId = true;
                } else if (eachSelectedDesignation.get('Id') == eachDesignation.Id) {
                    matchedId = true;
                }

                if (matchedId) {
                    if (eachDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c != null && eachDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c > Decimal.valueOf(String.valueOf(eachSelectedDesignation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)))) {
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'amount was less than the minimum for a designation'});
                    }
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_NON_GIFT_AMOUNT_PREFIX + index + '_1__c', eachDesignation.ucinn_ascendv2__Default_Non_Gift_Amount__c);
                }
            }
        }

        return returnList;
    }

    /**
     * method that populates the gift type information for the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param reviewTransaction:            The review transaction record we are populating
     * @param pledgeId:                     If the gift is a pledge payment
     *
     *
     */
    @testVisible
    protected void populateGiftType(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String giftType, Date startDate, Integer numberOfInstallments, String pledgeId) {

        if (giftType == PORTAL_CONST_OnlineGiving.RECURRING_TYPE) {
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_TRANSACTION_TYPE;
            if (startDate != null && startDate <= Date.today()) {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT_PAYMENT;
            } else {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT;
            }
        } else  if (giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE){
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE;
            if ( startDate != null && startDate <= Date.today()) {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_PAYMENT_TRANSACTION_TYPE;
            } else {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_TRANSACTION_TYPE;
            }

        } else if (giftType == PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE
                    || giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE
                    || giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE) {
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = giftType;
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = giftType;
            if (startDate != null && startDate <= Date.today()) {
                if (giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE) {
                    reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TRANSACTION_TYPE;
                } else if (giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE) {
                    reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TRANSACTION_TYPE;
                }
            }
        } else {
            if (String.isNotBlank(pledgeId)) {
                PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
                String pledgeIdFieldApiName = controller.getFieldApiNameForPledgeId(null);
                String queryString = 'SELECT Id, ucinn_ascendv2__External_System_ID__c FROM Opportunity WHERE ' + pledgeIdFieldApiName + ' = :pledgeId ';

                System.debug(queryString);
                List<Opportunity> opportunityList = Database.query(queryString);
                if (opportunityList != null && !opportunityList.isEmpty()) {
                    Opportunity opp = opportunityList.get(0);
                    reviewTransaction.ucinn_ascendv2__Opportunity__c = opp.Id;
                    reviewTransaction.ucinn_ascendv2__Opportunity_External_ID__c = opp.ucinn_ascendv2__External_System_ID__c;
                }

                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_PAYMENT;
                reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE;
                // appendManualReviewReason(reviewTransaction, ' User has specified that this is a pledge payment;');
            } else {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.GIFT;
                reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.OUTRIGHT;
            }

        }
    }

    /**
     * method that populates the billing information for the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param billingInformation:           Map of data that contains the billing information
     * @param reviewTransaction:            The review transaction record we are populating
     *
     *
     *
     */
    @TestVisible
    protected virtual void populateBillingInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> billingInformation, String pageName) {
        if (billingInformation == null || billingInformation.isEmpty() || String.isBlank(pageName)) {
            return;
        }

        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            //designations can be specified on the same page section name as the billing information, so we need to skip it if it is populated
            //skip populating information on the review transaction record if trying to populate fields that go on the interim (Company_Information)
            if (sectionSetting.Page_Main_Section__c == DESIGNATION_CUSTOM_METADATA_NAME
                    || ((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c) == null
                    || sectionSetting.Page_Main_Section__c == PORTAL_OnlineGivingControllerBase.COMPANY_INFORMATION) {
                continue;
            }

            List<Object> recordsList = new List<Object>();
            if (String.isNotBlank(sectionSetting.Page_Sub_Section__c)) {
                recordsList = (List<Object>) ((Map<String, Object>)((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c)).get(sectionSetting.Page_Sub_Section__c);
            } else {
                recordsList = (List<Object>) ((Map<String, Object>)((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c)).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
            }

            //the records are in a list data structure, but there should only be one preferred record per object
            //the record is a map representation of the sobject data
            Map<String, Object> recordMap = new Map<String, Object>();
            if (recordsList != null && !recordsList.isEmpty()) {
                recordMap = (Map<String, Object>) recordsList.get(0);
            } else {
                continue;
            }

            PORTAL_UTIL_PageSectionSetting.populateRecord(reviewTransaction, recordMap, sectionSetting.Portal_Section_Field_Settings__r);
        }
    }

    /**
     * Populates a new interim record with organization information. A review transaction record looks up
     * to the new interim record.
     *
     *
     * @author: Isaiah Rodriguez
     * @since:  1.0
     *
     *
     * @param reviewTransaction:            The review transaction record we are populating
     * @param billingInformation:           Map of data that contains the billing information
     * @param pageName                      The page name for the custom metadata records
     * @param isGivingAsOrg                 Boolean that specifies whether the user is making an organizational gift
     *
     */
    @TestVisible
    protected ucinn_ascendv2__Interim__c populateOrganizationalGivingInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> billingInformation, String pageName, Boolean isGivingAsOrg) {
        if (billingInformation == null || billingInformation.isEmpty() || isGivingAsOrg != true || String.isBlank(pageName)) {
            return null;
        }

        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, PORTAL_OnlineGivingControllerBase.COMPANY_INFORMATION, PORTAL_OnlineGivingControllerBase.COMPANY);

        ucinn_ascendv2__Interim__c newInterim = new ucinn_ascendv2__Interim__c();
        newInterim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(ORGANIZATION_INTERFACE).getRecordTypeId();

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            List<Object> recordsList = (List<Object>) ((Map<String, Object>)((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c)).get(sectionSetting.Page_Sub_Section__c);

            //the records are in a list data structure, but there should only be one preferred record per object
            //the record is a map representation of the sobject data
            Map<String, Object> recordMap = new Map<String, Object>();
            if (recordsList != null && !recordsList.isEmpty()) {
                recordMap = (Map<String, Object>) recordsList.get(0);
            } else {
                continue;
            }

            PORTAL_UTIL_PageSectionSetting.populateRecord(newInterim, recordMap, sectionSetting.Portal_Section_Field_Settings__r);
        }

        newInterim.ucinn_ascendv2__Status__c = MANUAL_REVIEW;

        newInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();

        insert newInterim;
        reviewTransaction.ucinn_ascendv2__Interim__c = newInterim.Id;
        reviewTransaction.ucinn_ascendv2__Status__c = MANUAL_REVIEW;
        appendManualReviewReason(reviewTransaction, USER_SPECIFIED_ORGANIZATIONAL_GIFT);

        return newInterim;
    }

     /**
     * method that populates the tribute information for the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param tributeInformation:           Map of data that contains the tribute information
     * @param reviewTransaction:            The review transaction record we are populating
     */

    protected void populateTributeInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> tributeInformation) {
        Set<String> tributeFieldSet = this.getTributeFieldSet();

        if (tributeInformation != null && !tributeInformation.isEmpty()) {
            for (String field : tributeInformation.keySet()) {
                if (tributeFieldSet.contains(field)) {
                    reviewTransaction.put(field, tributeInformation.get(field));
                }
            }
        }
    }

     /**
     * method that populates the additional custom form field information for the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param additionalDetails:            List of custom form field data formatted as a map of {id => custom form field id, value => the value the user inputted}
     * @param reviewTransaction:            The review transaction record we are populating
     *
     *
     *
     */
    @testVisible
    protected void populateAdditionalDetails(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, List<Object> additionalDetailsList) {
        if (additionalDetailsList != null && !additionalDetailsList.isEmpty()) {
            Map<String, Object> idToValueMap = new Map<String, Object>();
            Set<String> customFormFieldIdSet = new Set<String>();
            for (Object additionalDetail : additionalDetailsList) {
                Map<String, Object> additionalDetailMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(additionalDetail));
                if (String.isNotBlank((String)additionalDetailMap.get('Id'))) {
                    customFormFieldIdSet.add((String)additionalDetailMap.get('Id'));
                    idToValueMap.put((String)additionalDetailMap.get('Id'), additionalDetailMap.get('value'));
                }
            }
            if (!customFormFieldIdSet.isEmpty()) {
                List<ucinn_portal_Custom_Form_Field__c> customFormFields = [SELECT Id, SObject_API_Name__c, Field_API_Name__c FROM ucinn_portal_Custom_Form_Field__c WHERE Id IN :customFormFieldIdSet];
                if (customFormFields != null && !customFormFields.isEmpty()) {
                    for (ucinn_portal_Custom_Form_Field__c field : customFormFields) {
                        if (String.isNotBlank(field.Field_API_Name__c)) {
                            try {
                                reviewTransaction.put(field.Field_API_Name__c, idToValueMap.get(String.valueOf(field.Id)));
                            } catch (Exception e) {
                                appendManualReviewReason(reviewTransaction, ' Could not find field ' + field.Field_API_Name__c + ' and user inputted ' +
                                idToValueMap.get(String.valueOf(field.Id)) + '; ');
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * Method to make Double the Donation callout and add DTD identifier and other DTD info to review transaction
     *
     * @author: Jacob Huang
     * @since: 1.0
     *
     * @param matchingCompanyIntegration:   String: Matching company service being used (e.g. Double the Donation)
     * @param matchingCompanyId:            String: Double the Donation String id for the matching company
     * @param isGivingAsOrg:                Boolean: indicates if user is giving as org
     * @param dtdBillingInformation:        Map<String, Object>: user's billing information details
     * @param reviewTransaction:            ucinn_ascendv2__Review_Transaction_v2__c: review transaction record we are populating
     * @param externalDonationIdentifier    String: possibly previously generated DTD ID, indicates the DTD callout was already made
     * 
     * @return                              Id used in Double the Donation to identify the donation
     */
    @testVisible
    protected String populateDtdDonationInformation(String matchingCompanyIntegration, String matchingCompanyId, Map<String, Object> dtdBillingInformation, Boolean isGivingAsOrg, ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String externalDonationIdentifier) {
        if (matchingCompanyIntegration != DOUBLE_THE_DONATION || dtdBillingInformation?.isEmpty() != false || isGivingAsOrg == true || reviewTransaction == null) {
            return null;
        }

        if (String.isNotBlank(externalDonationIdentifier)) {
            // if the callout was previously done but there's no matching company ID passed from frontend, ignore any potential auto-matching by DTD
            String relatedInterimExternalId = String.isNotBlank(matchingCompanyId) ? this.getRelatedOrgInterimExternalSystemId(externalDonationIdentifier) : null;
            this.setDtdFieldsOnReviewTransaction(externalDonationIdentifier, relatedInterimExternalId, String.isBlank(matchingCompanyId), reviewTransaction);
            return externalDonationIdentifier;
        }

        String campaignName = reviewTransaction.ucinn_ascendv2__Campaign_External_Id__c;
        List<Campaign> campaignList = [SELECT Name FROM Campaign WHERE ucinn_ascendv2__Motivation_Code__c = :campaignName LIMIT 1];
        if (campaignList?.size() > 0 && String.isNotBlank(campaignList.get(0).Name)) {
            campaignName = campaignList.get(0).Name;
        }

        Map<String, Object> dtdParams = new Map<String, Object>{
            PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID => matchingCompanyId,
            PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION => dtdBillingInformation,
            PORTAL_CONST_OnlineGiving.AMOUNT_KEY => reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c,
            PORTAL_CONST_OnlineGiving.TRANSACTION_DATE => reviewTransaction.ucinn_ascendv2__Transaction_Date__c,
            PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME => campaignName
        };

        PORTAL_DoubleTheDonationController controller = (PORTAL_DoubleTheDonationController)PORTAL_Utils.getControllerFactory().getDoubleTheDonationController();
        PORTAL_DoubleTheDonationController.PORTAL_DTDResponseWrapper response = controller.createDonationInDtd(dtdParams);
        processDtdResponseWrapper(response, reviewTransaction);

        return response?.donationIdentifier;
    }

    /**
     * Helper method to handle the response wrapper from the Double the Donation controller and update SObjects as necessary
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param response          PORTAL_DoubleTheDonationController.PORTAL_DTDResponseWrapper: holds the DTD identifier and an organization interim
     * @param reviewTransaction ucinn_ascendv2__Review_Transaction_v2__c: object to update based on the response
     */
    protected void processDtdResponseWrapper(PORTAL_DoubleTheDonationController.PORTAL_DTDResponseWrapper response, ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction) {
        if (String.isBlank(response?.donationIdentifier) || reviewTransaction == null) {
            return;
        }

        if (response?.organizationInterim != null) {
            insert response.organizationInterim;
        }

        this.setDtdFieldsOnReviewTransaction(response.donationIdentifier, response?.organizationInterim?.ucinn_ascendv2__External_System_Id__c, response?.isAutoMatch, reviewTransaction);
    }

    /**
     * Populate the Review Transaction v2 argument with the field values needed for the DTD flow
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @param donationIdentifier        String: identifier used for the DTD callout
     * @param relatedInterimExternalId  String: optional, External System ID of the organization interim created during the DTD callout
     * @param reviewTransaction         ucinn_ascendv2__Review_Transaction_v2__c: rtv2 to add to
     */
    protected void setDtdFieldsOnReviewTransaction(String donationIdentifier, String relatedInterimExternalId, Boolean isAutoMatch, ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction) {
        reviewTransaction.ucinn_ascendv2__External_Matching_Service_ID__c = donationIdentifier;

        if (String.isBlank(relatedInterimExternalId) || isAutoMatch == true) {
            return;
        }

        // removing Contact from rtv2 allows it to create a constituent interim
        reviewTransaction.ucinn_ascendv2__Contact__c = null;
        reviewTransaction.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();

        reviewTransaction.ucinn_portal_Related_Interim_1__c = relatedInterimExternalId;
        reviewTransaction.ucinn_portal_Affiliation_1_Related_Role__c = EMPLOYEE_CONST;

        reviewTransaction.ucinn_ascendv2__Status__c = MANUAL_REVIEW;
        appendManualReviewReason(reviewTransaction, MATCHING_COMPANY_FOR_GIFT + '; ');
    }

    /**
     * Helper method to create an organization interim's external system ID field from the DTD identifier
     * Copies the same creation process as the DTD controller 
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @param donationIdentifier    String: DTD identifier
     * 
     * @return External System ID used by organization interim created during DTD callout
     */
    protected String getRelatedOrgInterimExternalSystemId(String donationIdentifier) {
        return PORTAL_DoubleTheDonationController.ORGANIZATION_INTERIM_EXTERNAL_ID_PREFIX + '-' + donationIdentifier;
    }

    /**
     * method that populates the additional custom form field information for the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param matchingCompanyId:            Hep id of the matching company if the org is HEP enabled
     * @param matchingCompanyName:           The name of the matching company
     * @param reviewTransaction:            The review transaction record we are populating
     *
     *
     *
     */
    @testVisible
    protected void populateMatchingCompany(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String matchingCompanyName, String matchingCompanyId) {

        if (String.isNotBlank(matchingCompanyName)) {
            //if there is a company id, the hep integration was used
            if (String.isNotBlank(matchingCompanyId)) {
                reviewTransaction.ucinn_portal_HEP_Company_Id__c = matchingCompanyId;
                reviewTransaction.ucinn_portal_HEP_Company_Name__c = matchingCompanyName;
            } else {
                reviewTransaction.ucinn_portal_Matching_Company_Name__c = matchingCompanyName;
            }
            appendManualReviewReason(reviewTransaction, MATCHING_COMPANY_FOR_GIFT);
        }
    }

    /**
     * method that creates a subscription in the external payment gateway if a user is giving a pledge or recurring
     * gift
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param emailTemplateName:                    the name of the template being used
     * @param designationList:                         the list of Map<String, Object> that corresponds to the designations
     * @param reviewTransaction:                    the review transaction that was inserted prior to this that corresponds with the gift
     * @param startDate:                            the start date for when payments start
     * @param endDate:                              Optional: the last day for a payment if it is a recurring gift
     * @param frequency:                            The payment frequency
     * @param totalAmount:                          The total amount for the gift
     *
     */
    public virtual void sendGiftReceipt(String emailTemplateName, List<Map<String, Object>> designationList, ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Date startDate, Date endDate, String frequency, Decimal totalAmount, ucinn_ascendv2__Interim__c interimRecord) {
        List<EmailTemplate> templateList = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :emailTemplateName];

        if (!templateList.isEmpty()) {
            EmailTemplate emailTemplate = templateList[0];

            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String subject = emailTemplate.Subject;
            String htmlBody = emailTemplate.HtmlValue;

            String designationDetailHtml = '';

            for (Map<String, Object> eachDesig: designationList) {
                String eachDesigRow = '<tr>'
                + '<td style="padding:20px 10px 20px 0;font-weight:500;letter-spacing:-0.2px;line-height:26px;font-family:&#39;Fira Sans&#39;,Helvetica,Arial,sans-serif;font-size:16px;border-bottom:1px solid #e5e5e5" valign="top">'
                + eachDesig.get('Name') + '</td>'
                + '<td style="padding:20px 10px 20px 0;color:#9b9b9b;letter-spacing:-0.2px;line-height:26px;font-family:&#39;Fira Sans&#39;,Helvetica,Arial,sans-serif;font-size:16px;border-bottom:1px solid #e5e5e5" valign="top" align="right"></td>'
                + '<td style="padding:20px 0;letter-spacing:-0.2px;line-height:26px;font-family:&#39;Fira Sans&#39;,Helvetica,Arial,sans-serif;font-size:16px;border-bottom:1px solid #e5e5e5;color:#151515" valign="top" align="right">'
                + '$' + eachDesig.get('amount') + '</td>'
                + '</tr>';

                designationDetailHtml += eachDesigRow;
            }

            String addressString = '';
            if(String.isNotBlank(reviewTransaction.ucinn_ascendv2__First_Name__c)) {
                addressString += reviewTransaction.ucinn_ascendv2__First_Name__c + ' ';
            }
            if(String.isNotBlank(reviewTransaction.ucinn_ascendv2__Last_Name__c)) {
                addressString += reviewTransaction.ucinn_ascendv2__Last_Name__c;
            }
            if(!String.isEmpty(addressString)) {
                addressString += '<br>';
            }

            htmlBody = htmlBody.replace('{!amountPaidTotal}', '$' + String.valueOf(totalAmount));
            htmlBody = htmlBody.replace('{!designationList}', designationDetailHtml);
            htmlBody = htmlBody.replace('{!address}', addressString);
            if (startDate == null) {
                startDate = Date.today();
            }
            String endDateString = '';
            if (endDate != null) {
                endDateString = ' - ' + endDate.format();
            }
            htmlBody = htmlBody.replace('{!dateOfGift}', startDate.format() + endDateString);

            if (String.isBlank(frequency)) {
                htmlBody = htmlBody.replace('{!frequency}', PORTAL_CONST_PaymentHub.ONE_TIME_FREQUENCY);
            } else {
                htmlBody = htmlBody.replace('{!frequency}', frequency);
            }

            String emailInUse = '';
            if (String.isNotBlank(reviewTransaction.ucinn_ascendv2__Email_1__c)) {
                emailInUse = reviewTransaction.ucinn_ascendv2__Email_1__c;
            } else if (String.isNotBlank(interimRecord?.ucinn_ascendv2__Organization_Email_1__c)) {
                emailInUse = interimRecord?.ucinn_ascendv2__Organization_Email_1__c;
            } else if (String.isNotBlank(interimRecord?.ucinn_ascendv2__Email_1__c)) {
                emailInUse = interimRecord?.ucinn_ascendv2__Email_1__c;
            }

            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mail.setToAddresses(new String[]{emailInUse});
            mail.saveAsActivity = false;
            mailList.add(mail);
            if (!Test.isRunningTest()) {
                Messaging.sendEmail(mailList);
            }

        }
    }

    /**
     * Converts google pay token to a payment method usable for the PSP.
     * 
     * @author Aaron Wong
     * 
     * @param  googlePayToken   Google Pay Token to covert to payment method.
     * @return                  Payment method token/identifier.
     * @since                   1.0
     */
    public virtual String createGooglePayPaymentMethod(Map<String, Object> params) {
        return paymentInterface.createWalletPaymentMethod(PORTAL_PaymentGateway.WalletType.GooglePay, (String)params?.get(TOKEN_CONST));
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
    public virtual String createApplePayPaymentMethod(Map<String, Object> params) {
        return paymentInterface.createWalletPaymentMethod(PORTAL_PaymentGateway.WalletType.ApplePay, (String)params?.get(TOKEN_CONST));
    }

    /**
     * method that appends the manual review reason onto the review transaction
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param reviewTransaction:                The review transaction we are trying to populate
     * @param reason:                           The new manual review reason we are trying to add
     *
     *
     */
    protected void appendManualReviewReason(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String reason) {
        if (String.isNotBlank(reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c)) {
            reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c = reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c + reason;
        } else {
            reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c = reason;
        }
    }

    /**
     * Gets possible fields for tribute information on RTv2.
     *
     * @author Aaron Wong
     *
     * @return Set of field API Names on RTv2.
     * @since  1.0
     */
    protected Set<String> getTributeFieldSet() {
        return new Set<String>{'ucinn_ascendv2__Tribute_Type_1__c',
                               'ucinn_ascendv2__In_Memory_Honor_First_Name_1__c',
                               'ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c',
                               'ucinn_ascendv2__Notify_First_Name_1__c',
                               'ucinn_ascendv2__Notify_Last_Name_1__c',
                               'ucinn_ascendv2__Notify_Address_Line_1_1__c',
                               'ucinn_ascendv2__Notify_Address_Line_2_1__c',
                               'ucinn_ascendv2__Notify_City_1__c',
                               'ucinn_ascendv2__Notify_State_1__c',
                               'ucinn_ascendv2__Notify_Postal_Code_1__c'};
    }

    /**
     * Helper method to create a review transaction to cancel an existing pledge or recurring gift within ascend (no payment processor-related behavior)
     *      uses platform events because cancel adjustment doesn't work with portal user permissions
     * 
     * @author Jacob Huang
     * 
     * @param giftType                  String: 'pledge' or 'recurring'
     * @param giftId                    String: Id of the Opportunity to cancel
     * @param externalSystemId          String: External System Id of the Opportunity to cancel
     */
    public virtual void createCancelReviewTransaction(String giftType, String giftId, String externalSystemId) {
        if (String.isBlank(giftType) || String.isBlank(giftId) || String.isBlank(externalSystemId)) {
            return;
        }

        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c(
            ucinn_ascendv2__Status__c = STATUS_NEW, 
            ucinn_ascendv2__Adjustment_Reason__c = PORTAL_CONST_OnlineGiving.GIFT_CANCELLED,
            ucinn_ascendv2__Adjusted_Opportunity__c = giftId,
            ucinn_ascendv2__External_System_ID__c = externalSystemId
        );

        if (giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE) {
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_TRANSACTION_TYPE;
            reviewTransaction.ucinn_ascendv2__Adjustment_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_ADJUSTMENT;
        }
        else if (giftType == PORTAL_CONST_OnlineGiving.RECURRING_TYPE) {
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT;
            reviewTransaction.ucinn_ascendv2__Adjustment_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT_ADJUSTMENT;
        }

        sendPlatformEvent(reviewTransaction);
    }

    /** Credit Card Logic Begin **/
    
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
     * @param externalPaymentGatewayId  String: for Cybersource: merchant reference code of the initial subscription transaction
     * 
     * @return                          String: last 4 digits of new credit card, null if failure 
     */
    public virtual String updateSubscriptionCreditCard(Map<String, Object> params) {
        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, cont);
        return paymentInterface.updateSubscriptionCreditCard(params);
    }

    /**
     * Return the last 4 digits of the credit card used for all of a user's subscription gifts
     * 
     * @author Jacob Huang
     * 
     * @param creditCardIdList              List<String>: payment or subscription (depends on payment method) IDs to get last 4 credit card digits for
     * @param externalPaymentGatewayIdList  List<String>: list of external payment gateway IDs, length/ordering corresponds to creditCardIdList
     * 
     * @return                              map of string ID to string of last 4 credit card digits 
     */
    public virtual Map<String, String> getCreditCardIdToLastFourDigitsMap(Map<String, Object> params) {
        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, cont);
        return paymentInterface.getCreditCardIdToLastFourDigitsMap(params);
    }

    /**
     * Return the recaptcha display option
     * 
     * @author Sean Tang
     * @since  1.0
     * 
     * @return      recaptcha display option as a string
     */
    public virtual String getRecaptchaOption() {
        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();

        String recaptchaOption = recaptchaController.getRecaptchaOption();
        return recaptchaOption;
    }

    /** Cancellation Logic Begin **/

    /**
     * Cancel a constituent's existing subscription-based gift (pledge or recurring gift)
     * 
     * @author Jacob Huang
     * 
     * @param paymentMethod             String: payment processor used
     * @param giftId                    String: ID of Opportunity
     * @param giftType                  String: 'pledge' or 'recurring'
     * @param subscriptionId            String: external ID for the gift's associated subscription
     * @param externalPaymentGatewayId  String: merchant reference code of initial subscription transaction
     * @param externalSystemId          String: external system ID of Opportunity to cancel
     */
    public virtual void cancelSubscription(Map<String, Object> params) {
        String giftId = (String) params.get(PORTAL_CONST_OnlineGiving.GIFT_ID_KEY);
        String giftType = (String) params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        String externalSystemId = (String) params.get(PORTAL_OnlineGivingControllerBase.EXTERNAL_SYSTEM_ID);

        // the callout succeeding and query/DML failing is bad, so do necessary DML validation before callout
        if ((giftType != PORTAL_CONST_OnlineGiving.PLEDGE_TYPE && giftType != PORTAL_CONST_OnlineGiving.RECURRING_TYPE) || String.isBlank(giftId) || String.isBlank(externalSystemId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error cancelling gift: Invalid gift ID or type.'});
        }

        // Possible callout to cancel subscription in payment processor 
        paymentInterface.cancelSubscription(params);

        // DML: update payment processor-related fields on Opportunity and insert rtv2 adjustment 
        update new Opportunity(Id = giftId, 
                               ucinn_ascendv2__Created_In_External_Payment_Gateway__c = true,
                               ucinn_ascendv2__Updated_In_External_Payment_Gateway__c = true,
                               ucinn_ascendv2__Status_In_External_Payment_Gateway__c = PORTAL_CONST_OnlineGiving.GIFT_CANCELLED);
        
        createCancelReviewTransaction(giftType, giftId, externalSystemId);
    }

    /**
     * Populate non gift amount fields on rtv2
     * 
     * @author  Phillip Nguyen
     * 
     * @param reviewTransaction             RTv2 to populate
     * @param membershipBenefitRecords      List of membership benefit records
     */
    @TestVisible
    protected virtual void populateMembershipBenefits(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, List<Map<String, Object>> membershipBenefitRecords) {
        if (reviewTransaction == null || membershipBenefitRecords == null || membershipBenefitRecords.isEmpty()) {
            System.debug('No membership benefits found.');
            return;
        }

        for (Integer index = 1; index <= membershipBenefitRecords.size(); index++) {
            String nameSpace = PORTAL_CONST_OnlineGiving.NAMESPACE;
            if (index > 5) {
                nameSpace = '';
            }

            Map<String, Object> benefitRecord = membershipBenefitRecords.get(index-1);

            reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_NON_GIFT_AMOUNT_PREFIX + index + '_1__c', benefitRecord.get(PORTAL_MembershipControllerBase.BENEFIT_AMOUNT));
        }
    }

    /**
     * Serializes RTv2 and stores that inside a Platform event which includes the api name, and the dml action to be executed.
     * This functions as a delayed dml action that will be ran as the automated process user by default.
     * This platform event will fire a trigger to perform the dml action on a list of records. 
     * A flow is not used b/c flows do not perform the action as an elevated user.
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     */
    private static void sendPlatformEvent(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction) {
        if (reviewTransaction == null) {
            return;
        }

        Portal_DML_Command_Event__e dmlCommandEvent = new Portal_DML_Command_Event__e(Object_Api_Name__c = REVIEW_TRANSACTION_OBJECT_API_NAME, 
                                                                                      Object_Data__c = System.JSON.serialize(new List<ucinn_ascendv2__Review_Transaction_v2__c>{reviewTransaction}, true),
                                                                                      DML_Action__c = PORTAL_DMLCommandEventBase.INSERT_CONST);
        Database.SaveResult results = EventBus.publish(dmlCommandEvent);

        if (results.isSuccess()) {
            System.debug('Successfully published DML Command event.');
        } else {
            for(Database.Error err : results.getErrors()) {
                System.debug('Error returned: ' +
                            err.getStatusCode() +
                            ' - ' +
                            err.getMessage());
            }
        }
    }
}