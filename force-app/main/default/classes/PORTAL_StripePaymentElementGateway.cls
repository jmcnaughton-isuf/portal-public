public inherited sharing virtual class PORTAL_StripePaymentElementGateway extends PORTAL_StripePaymentGateway {
    public static final String CLIENT_SECRET_KEY = 'client_secret';
    public static final String STRIPE_PAYMENT_ELEMENT_METADATA_KEY = 'additionalMetadata';
    public static final String IS_SUBSCRIPTION = 'isSubscription';
    public static final String PAYMENT_METHOD_BANK = 'us_bank_account';

    /**
     * This is a method that creates a payment intent and returns the client secret to process payments
     *
     *
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param additionalMetadata:       stringified additional metadata
     * @param amount:                   the amount of the transaction
     * @param stripeBillingInformation: formatted billing information for stripe to create customer
     * @param isGivingAsOrg:            boolean to declare if this gift is given as an org
     * @param isSubscription:           boolean to indicate if this is a one-time payment or subscription
     *
     * @return                          the client secret
     */
    public virtual String getClientSecret(Map<String, Object> params) {
        Decimal amount = (Decimal.valueOf(String.valueOf(params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)))); //make sure to multiply by 100 into an integer before use
        String additionalMetadata = (String)params?.get(STRIPE_PAYMENT_ELEMENT_METADATA_KEY);
        String contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;
        Map<String, Object> billingInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params?.get(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY)));
        Boolean isGivingAsOrg = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.IS_GIVING_AS_ORG);
        Boolean isSubscription = (Boolean)params?.get(IS_SUBSCRIPTION);
        String clientSecret = '';

        Contact currentContact = null;
        if (String.isNotBlank(contactId)) {
            currentContact = PORTAL_CommunityUtils.getContactInfoFromId(contactId);
        }

        String stripeCustomerId = getStripeCustomerId(currentContact, billingInformation, null, isGivingAsOrg);
        String requestBody = '';
        String endpointName = '';
        
        if (isSubscription == true) {
            endpointName = SETUP_INTENT_ENDPOINT;
            requestBody += getSetupIntentRequestBody(stripeCustomerId);
        } else {
            endpointName = PAYMENT_INTENT_ENDPOINT;
            requestBody += getPaymentIntentRequestBody(Integer.valueOf(amount*100), stripeCustomerId);
        }

        requestBody += getMetadataAttributeString(additionalMetadata, contactId);

        Map<String, Object> responseBody = executeAPIRequest(endpointName, requestBody, 'POST');
        clientSecret = (String)responseBody?.get(CLIENT_SECRET_KEY);

        if (isGivingAsOrg != true && currentContact != null && String.isBlank(currentContact.ucinn_portal_Stripe_Customer_ID__c) && String.isNotBlank(stripeCustomerId)) {
            currentContact.ucinn_portal_Stripe_Customer_ID__c = stripeCustomerId;
            update currentContact;
        }

        return clientSecret;
    }

    /**
     * This will return the formatted body of the HTTP request for Payment Intents (Content-Type: application/x-www-form-urlencoded) 
     *
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param amount:                   the amount of the transaction
     * @param stripeCustomerId:         the Stripe customer ID
     *
     * @return                          the body of the HTTP request as a String
     */
    protected virtual String getPaymentIntentRequestBody(Integer amount, String stripeCustomerId) {
        return 'amount=' + amount + '&currency=' + CURRENCY_TYPE_PLACEHOLDER + '&automatic_payment_methods[enabled]=true' + (String.isNotBlank(stripeCustomerId) ? ('&customer=' + stripeCustomerId) : '');
    }

    /**
     * This will return the formatted body of the HTTP request for Setup Intents (Content-Type: application/x-www-form-urlencoded) 
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param stripeCustomerId:         the Stripe customer ID
     *
     * @return                          the body of the HTTP request as a String
     */
    protected virtual String getSetupIntentRequestBody(String stripeCustomerId) {
        if (String.isBlank(stripeCustomerId)) {
            return '';
        }

        return 'customer=' + stripeCustomerId + '&automatic_payment_methods[enabled]=true';
    }

    /**
     * This will split the metadata into 500 character attributes to stay within Stripe limits
     *
     *
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param additionalMetadata:       stringified additional metadata
     * @param contactId:                the contact id of the current logged in user
     *
     * @return                          metadata string to attach to the stripe payment intent creation request
     */
    protected virtual String getMetadataAttributeString(String additionalMetadata, String contactId) {
        String resultString = '';

        if (String.isBlank(additionalMetadata)) {
            return resultString;
        }

        additionalMetadata.replace('\\', '');

        List<String> chunks = additionalMetadata.split('(?<=\\G.{500})');

        for (Integer chunkIndex = 0; chunkIndex < chunks.size(); chunkIndex++) {
            resultString += '&metadata[' + chunkIndex + ']=' + chunks[chunkIndex];
        }

        if (String.isNotBlank(contactId)) {
            resultString += '&metadata[contactId]=' + contactId;
        }

        return resultString;
    }    
    
    /**
     * Return transactionId and customerId
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param paymentId                 String: transaction Id for stripe from the front end
     * @param customerId                String: Stripe customer Id associated with the payment
     *
     * @return                          the PORTAL_PaymentResponseWrapper for stripe one time payment
     */
    public override PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params) {
        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        responseWrapper.transactionId = (String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        responseWrapper.reviewTransactionFieldMap = new Map<String, Object>{STRIPE_CUSTOMER_ID => params?.get(PORTAL_CONST_OnlineGiving.CUSTOMER_ID)};
        return responseWrapper;
    }
            
    /**
     * Returns the payment method tender type used to conduct the transaction
     *
     * @author:                         Todd Shinto
     * @since:                          1.4
     *
     * @param paymentMethod                     The payment method from the additional payment map
     *
     * @return                                  Payment method tender type
     */
    public virtual override String getReviewTransactionTenderType(Map<Object, Object> additionalPaymentDataMap) {
        if (String.isBlank((String)additionalPaymentDataMap?.get((Object)PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY))) {
            return PORTAL_CONST_OnlineGiving.CREDIT_CARD;
        }

        return (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PAYMENT_METHOD_BANK ? PORTAL_CONST_OnlineGiving.ACH_CONST : PORTAL_CONST_OnlineGiving.CREDIT_CARD;
    }
}