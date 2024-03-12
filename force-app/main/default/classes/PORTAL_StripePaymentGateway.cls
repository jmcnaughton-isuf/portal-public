public inherited sharing virtual class PORTAL_StripePaymentGateway extends PORTAL_PaymentGateway {

    public static final String BASE_URL = 'callout:Stripe/';
    public static final String PAYMENT_INTENT_ENDPOINT = BASE_URL + 'v1/payment_intents';
    public static final String PRICE_ID_ENDPOINT = BASE_URL + 'v1/prices';
    public static final String CUSTOMER_ENDPOINT = BASE_URL + 'v1/customers';
    public static final String PAYMENT_METHOD_ENDPOINT = BASE_URL + 'v1/payment_methods';
    public static final String SUBSCRIPTION_ENDPOINT = BASE_URL + 'v1/subscriptions';
    public static final String SETUP_INTENT_ENDPOINT = BASE_URL + 'v1/setup_intents';
    public static final String CHARGE_ENDPOINT = BASE_URL + 'v1/charges';
    private static final String ORG_CURRENCY_METADATA_NAME = 'Org_Currency';
    public static final String CURRENCY_TYPE_PLACEHOLDER = ':currencyType';
    private static final String FIRST_PRICE_ID = 'firstPriceId';
    private static final String SECOND_PRICE_ID = 'secondPriceId';
    private static final String CUSTOMER_ID = 'customerId';
    public static final String ORGANIZATION_METADATA_DEVELOPER_NAME = 'Organization_Name';
    public static final String STRIPE_CUSTOMER_ID = 'ucinn_portal_Stripe_Customer_ID__c';
    public static final String STRIPE_VERSION_CONST = 'Stripe-Version';
    public static final String STRIPE_VERSION_DATE = '2018-02-05';  // Added Date that Trials were added to Stripe, did not want to go further since it was possible more things would stop functioning

    private static final String ONE_TIME_PAYMENT_NAME = 'OneTimePayment';

    public static final String PUBLIC_API_KEY_DEVELOPER_NAME = 'Stripe_Public_Key';

    public static final String GENERIC_ERROR_MESSAGE = 'There was an error processing your gift.';

    private static String cachedPublicApiKey; //cache public key if we query for it multiple times in one transaction

    // Stripe object/map keys
    public static final String STRIPE_RESPONSE_DATA = 'data'; 
    public static final String STRIPE_ID = 'id';
    public static final String STRIPE_SUBSCRIPTION_PAYMENT_METHOD = 'default_payment_method';
    public static final String STRIPE_PAYMENT_METHOD_CARD = 'card';
    public static final String STRIPE_CARD_LAST_4 = 'last4';

    /**
     * method that executes the api request to stripe
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param endpoint:                 the stripe endpoint we are calling
     * @param body:                     the request body
     * @param method:                   the method for the request (POST, GET, PUT)
     *
     * @return                          the subscription id to be used as an external id
     */
    public static Map<String, Object> executeAPIRequest(String endpoint, String body, String method){

        String currencyType = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => ORG_CURRENCY_METADATA_NAME});
        if (String.isBlank(currencyType)) {
            currencyType = PORTAL_CONST_OnlineGiving.USD_CURRENCY_CODE;
        }

        Http con = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        String authorizationHeader = 'Bearer {!$Credential.Password}';
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader(STRIPE_VERSION_CONST, STRIPE_VERSION_DATE);
        body = body.replace(CURRENCY_TYPE_PLACEHOLDER, currencyType);
        if (String.isNotBlank(body)) {
            request.setBody(body);
        }

        HttpResponse response = con.send(request);
        if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
            String responseBody = response.getBody();
            if (String.isNotBlank(responseBody)) {
                return (Map<String, Object>)System.JSON.deserializeUntyped(responseBody);
            } else {
                return new Map<String, Object>();
            }
        } else {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Bad request to external gateway.', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * create and charge a payment intent
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     * @param paymentId                 transaction Id for stripe from the front end
     * @param amount                    decimal amount for the transaction
     * @param contact                   nullable contact record
     * @param stripeBillingInformation  formatted billing information for stripe to create customer
     * @param isGivingAsOrg             Boolean that specifies whether the user is making an organizational gift
     *
     * @return                          the PORTAL_PaymentResponseWrapper for stripe one time payment
     */
    public virtual override PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params) {
        String paymentId = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        Decimal amount = (Decimal.valueOf(String.valueOf(params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)))); //make sure to multiply by 100 into an integer before use
        Contact cont = (Contact)params?.get(PORTAL_CONST_OnlineGiving.CONTACT_KEY);
        Map<String, Object> billingInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params?.get(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY)));
        Boolean isGivingAsOrg = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.IS_GIVING_AS_ORG);

        if (String.isBlank(paymentId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Payment Id is blank', PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }

        String oneTimePriceId = createOneTimePriceItem(amount, ONE_TIME_PAYMENT_NAME);

        String stripeCustomerId = getStripeCustomerId(cont, billingInformation, paymentId, isGivingAsOrg);

        attachPaymentMethodToCustomer(paymentId, stripeCustomerId);

        String transactionId = chargeOneTimePayment(stripeCustomerId, amount, paymentId);

        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        responseWrapper.transactionId = transactionId;
        responseWrapper.reviewTransactionFieldMap = new Map<String, Object>{STRIPE_CUSTOMER_ID => stripeCustomerId};

        return responseWrapper;
    }

    protected virtual String getStripeCustomerId(Contact cont, Map<String, Object> billingInformation, String paymentId, Boolean isGivingAsOrg) {
        //if the constituent doesn't exist or if they do not have a stripe customer id, then create one for them
        String stripeCustomerId = '';
        if (isGivingAsOrg == true || (cont == null || String.isBlank(cont.ucinn_portal_Stripe_Customer_ID__c))) {
            stripeCustomerId = SERVER_createCustomer(billingInformation, paymentId);
        } else {
            stripeCustomerId = cont.ucinn_portal_Stripe_Customer_ID__c;
        }

        return stripeCustomerId;
    }

    protected virtual String chargeOneTimePayment(String stripeCustomerId, Decimal amount, String paymentId) {

        String organizationName = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => ORGANIZATION_METADATA_DEVELOPER_NAME});

        String requestBody = 'amount=' + Integer.valueOf(amount*100) + '&currency=' + CURRENCY_TYPE_PLACEHOLDER + '&customer=' + stripeCustomerId + '&payment_method=' + paymentId + '&description=Payment To ' + organizationName + '&confirm=true';

        Map<String, Object> responseBody = executeAPIRequest(PAYMENT_INTENT_ENDPOINT, requestBody, 'POST');
        return (String)responseBody.get(STRIPE_ID);
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
     * method that creates a customer id for the constituent in stripe
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param billingInformation:       the billing information in stripe format for the constituent
     * @param paymentId:                the stripe payment method id that was generated by the visualforce credit card form
     *
     *
     * @return                          the customer id
     */
    public static String SERVER_createCustomer(Map<String, Object> billingInformation, String paymentId) {
        String requestBody = '';
        String encodingString = '';
        for (String billingField : billingInformation.keySet()) { 
            if (billingField == 'address') {
                Map<String, Object> addressInfo = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(billingInformation.get(billingField)));
                for (String addressKey : addressInfo.keySet()) {
                    requestBody = requestBody + encodingString + 'address[' + addressKey + ']=' + addressInfo.get(addressKey);
                    encodingString = '&';
                }

            } else {
                requestBody = requestBody + encodingString +  billingField + '=' +  billingInformation.get(billingField);
                encodingString = '&';
            }
        }
        Map<String, Object> responseBody = executeAPIRequest(CUSTOMER_ENDPOINT, requestBody, 'POST');
        return (String)responseBody.get(STRIPE_ID);
    }

    /**
     * method that adds the payment method to an existing customer
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param paymentId:                the stripe id tor the payment method
     * @param customerId:               the stripe id for the constituent
     *
     * @return                          the price item id
     */
    public static void attachPaymentMethodToCustomer(String paymentId, String customerId) {
        if (String.isBlank(paymentId) || String.isBlank(customerId) ) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not attach payment method to customer'
            });
        }

        String requestBody = 'customer=' + customerId + '&payment_method=' + paymentId + '&usage=off_session&confirm=true';
        Map<String, Object> responseBody = executeAPIRequest(SETUP_INTENT_ENDPOINT, requestBody, 'POST');
    }

    /**
     * Get the list of a customer's payment methods
     * 
     * @param customerId        Stripe customer ID
     * 
     * @return                  list of payment method objects
     */
    public static List<Object> getStripePaymentMethods(String customerId) {
        if (String.isBlank(customerId)) {
            return new List<Object>();
        }
        String endpoint = CUSTOMER_ENDPOINT + '/' + customerId + '/payment_methods?type=card&limit=100';
        Map<String, Object> responseBody = executeAPIRequest(endpoint, '', 'GET');
        return (List<Object>)responseBody.get(STRIPE_RESPONSE_DATA);
    }

    /**
     * Get a particular customer payment method given the customer and payment method IDs
     * 
     * @param paymentMethodId       Stripe payment method ID String
     * @param customerId            Stripe customer ID String
     * 
     * @return                      single payment method object as a map
     */
    public static Map<String, Object> getStripeSinglePaymentMethod(String paymentMethodId, String customerId) {
        if (String.isBlank(paymentMethodId) || String.isBlank(customerId)) {
            return new Map<String, Object>();
        }

        String endpoint = CUSTOMER_ENDPOINT + '/' + customerId + '/payment_methods/' + paymentMethodId;
        return executeAPIRequest(endpoint, '', 'GET');
    }

    /**
     * Get a payment method given the payment method ID
     * 
     * @author  Todd Shinto
     * @since   1.4
     * 
     * @param   paymentMethodId       Stripe payment method ID String
     * 
     * @return                        Single payment method object as a map
     */
    public static Map<String, Object> getStripePaymentMethod(String paymentMethodId) {
        if (String.isBlank(paymentMethodId)) {
            return new Map<String, Object>();
        }

        String endpoint = PAYMENT_METHOD_ENDPOINT + '/' + paymentMethodId;
        return executeAPIRequest(endpoint, '', 'GET');
    }

     /**
     * method that creates a recurring price item in stripe for subscription billing
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param amount:                   the billing amount for the stripe subscription
     * @param frequency:                the billing frequency for the stripe subscription
     * @param itemName:                 name of the price item
     *
     * @return                          the price item id
     */
    public static String SERVER_createRecurringPriceItem(String frequency, Decimal amount, String itemName) {
        String month = 'month';
        String week = 'week';
        String year = 'year';

        String interval = '';
        Integer intervalCount = 1;
        if (frequency == PORTAL_CONST_OnlineGiving.ANNUAL_FREQUENCY) {
            interval = year;
            intervalCount = 1;
        } else if (frequency == PORTAL_CONST_OnlineGiving.SEMI_ANNUAL_FREQUENCY) {
            interval = month;
            intervalCount = 6;
        } else if (frequency == PORTAL_CONST_OnlineGiving.QUARTERLY_FREQUENCY) {
            interval = month;
            intervalCount = 3;
        } else if (frequency == PORTAL_CONST_OnlineGiving.MONTHLY_FREQUENCY) {
            interval = month;
            intervalCount = 1;
        } else if (frequency == PORTAL_CONST_OnlineGiving.BI_WEEKLY_FREQUENCY) {
            interval = week;
            intervalCount = 2;
        } else if (frequency == PORTAL_CONST_OnlineGiving.WEEKLY_FREQUENCY) {
            interval = week;
            intervalCount = 1;
        }

        String requestBody = 'unit_amount=' + Integer.valueOf(amount*100) + '&currency=' +  CURRENCY_TYPE_PLACEHOLDER + '&product_data[name]=' + itemName + '&recurring[interval]=' + interval + '&recurring[interval_count]=' + intervalCount;

        Map<String, Object> responseBody = executeAPIRequest(PRICE_ID_ENDPOINT, requestBody, 'POST');
        return (String)responseBody.get(STRIPE_ID);

    }

    /**
     * method that creates a one time price item in stripe for subscription billing
     * for charges of extra cents
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     *
     * @param amount:                   the billing amount for the stripe subscription
     * @param itemName:                 name of the price item
     *
     * @return                          the price item id
     */
    public static String createOneTimePriceItem(Decimal amount, String itemName) {
        String requestBody = 'unit_amount=' + integer.valueOf(amount*100) + '&currency=' + CURRENCY_TYPE_PLACEHOLDER + '&product_data[name]=' + itemName;
        Map<String, Object> responseBody = executeAPIRequest(PRICE_ID_ENDPOINT, requestBody, 'POST');
        return (String)responseBody?.get(STRIPE_ID);
    }


    /**
     * method that creates a customer id for the constituent in stripe if they are not currently
     * tracked in stripe. it will also create the subscription price item in order to bill the
     * customer
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param amount:                   the billing amount for the stripe subscription
     * @param firstPaymentAddition:     the remaining amount to charge if the subscription amount is rounded down
     * @param billingInformation:       the billing information in stripe format for the constituent
     * @param frequency:                the billing frequency for the stripe subscription
     * @param paymentId:                the stripe payment method id that was generated by the visualforce credit card form
     * @param cont:                     the logged in constituent (or null if anonymous user)
     * @param isGivingAsOrg:            Boolean that specifies whether the user is making an organizational gift 
     *
     * @return                          map of price items and customer id
     */
    public Map<String, String> createCustomerAndPriceItems(Decimal amount, Decimal firstPaymentAddition, Map<String, Object> billingInformation, String frequency, String paymentId, Contact cont, Boolean isGivingAsOrg) {
        return createCustomerAndPriceItems(amount, firstPaymentAddition, billingInformation, frequency, paymentId, cont, isGivingAsOrg, null);
    }

    /**
     * method that creates a customer id for the constituent in stripe if they are not currently
     * tracked in stripe. it will also create the subscription price item in order to bill the
     * customer
     *
     *
     * @author: Todd Shinto
     * @since: 1.2
     *
     *
     * @param amount:                   the billing amount for the stripe subscription
     * @param firstPaymentAddition:     the remaining amount to charge if the subscription amount is rounded down
     * @param billingInformation:       the billing information in stripe format for the constituent
     * @param frequency:                the billing frequency for the stripe subscription
     * @param paymentId:                the stripe payment method id that was generated by the visualforce credit card form
     * @param cont:                     the logged in constituent (or null if anonymous user)
     * @param isGivingAsOrg:            Boolean that specifies whether the user is making an organizational gift 
     *
     * @return                          map of price items and customer id
     */
    public Map<String, String> createCustomerAndPriceItems(Decimal amount, Decimal firstPaymentAddition, Map<String, Object> billingInformation, String frequency, String paymentId, Contact cont, Boolean isGivingAsOrg, String customerId) {
        Map<String, String> returnMap = new Map<String, String>();

        returnMap.put(FIRST_PRICE_ID, SERVER_createRecurringPriceItem(frequency, amount, 'subscription'));


        if (firstPaymentAddition != null && firstPaymentAddition > 0) {
            returnMap.put(SECOND_PRICE_ID, createOneTimePriceItem(firstPaymentAddition, 'subscriptionFirstPaymentAddition'));
        }

        if (String.isBlank(customerId)) {
            returnMap.put(CUSTOMER_ID, getStripeCustomerId(cont, billingInformation, paymentId, isGivingAsOrg));
        } else {
            returnMap.put(CUSTOMER_ID, customerId);
        }

        return returnMap;

    }

     /**
     * method that creates a subscription in stripe if a user is giving a pledge or recurring
     * gift
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param endDate:                  the date we want the subscription to end, optional for recurring gift, required for pledge
     * @param paymentId:                the payment method id in stripe to connect to the credit card
     * @param customerId:               the id of the constituent in stripe to keep track of the subscription
     * @param priceId:                  the id of the stripe price object that contains the billing amount and frequency
     * @param startDate:                the start date of the subscription
     * @param paymentOrigin             Where the payment originated in the portal
     *
     * @return                          the subscription id to be used as an external id
     */
    public virtual String createStripeSubscription(String customerId, String paymentId, String priceId, String secondPriceId, Date startDate, Date endDate, String paymentOrigin) {

        String requestBody = 'customer=' + customerId + '&items[0][price]=' + priceId;

        if (String.isNotBlank(secondPriceId)) {
            requestBody = requestBody + '&add_invoice_items[0][price]=' + secondPriceId;
        }

        if (String.isNotBlank(paymentId)) {
            if (paymentOrigin != PORTAL_CONST_OnlineGiving.ONLINE_GIVING_PAYMENT_ELEMENT 
                    && paymentOrigin != PORTAL_CONST_OnlineGiving.MEMBERSHIP_PAYMENT_ELEMENT 
                    && paymentOrigin != PORTAL_CONST_OnlineGiving.CONTEXTUAL_GIVING_FORM_PAYMENT_ELEMENT) {
                attachPaymentMethodToCustomer(paymentId, customerId);
            }

            requestBody = requestBody + '&default_payment_method=' + paymentId;
        }

        if (startDate != null && startDate != Date.today()) {
            //tells us when the subscription should start if there is a start date. if there is it will default to date.today()
            Long billingStartDateInMilliseconds = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day()).getTime()/1000;
            requestBody = requestBody + '&trial_end=' + billingStartDateInMilliseconds + '&billing_cycle_anchor=' + billingStartDateInMilliseconds;
        }
        if (endDate != null) {
            //cancels the subscription at the specified date
            requestBody = requestBody + '&cancel_at=' + Datetime.newInstance(endDate.year(), endDate.month(), endDate.day()).getTime()/1000;
        }

        Map<String, Object> responseBody = executeAPIRequest(SUBSCRIPTION_ENDPOINT, requestBody, 'POST');
        return (String)responseBody.get(STRIPE_ID);
    }

    /**
     * Update an existing Stripe subscription with an already created payment method
     * 
     * @author Jacob Huang
     * 
     * @param paymentId         ID for Stripe payment method to associate with subscription
     * @param subscriptionId    ID for Stripe subscription to modify
     */
    public static void updateStripeSubscriptionPaymentMethod(String paymentId, String subscriptionId) {
        if (String.isBlank(paymentId) || String.isBlank(subscriptionId) ) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not update subscription\'s payment method'
            });
        }

        String endpoint = SUBSCRIPTION_ENDPOINT + '/' + subscriptionId;
        String requestBody = 'default_payment_method=' + paymentId;
        Map<String, Object> responseBody = executeAPIRequest(endpoint, requestBody, 'POST');
    }

    /**
     * Get the list of a customer's uncancelled subscription objects
     * 
     * @author Jacob Huang
     * 
     * @param customerId        Stripe customer ID
     * 
     * @return                  list of subscription objects
     */
    public static List<Object> getStripeUncanceledSubscriptions(String customerId) {
        if (String.isBlank(customerId)) {
            return new List<Object>();
        }
        String requestParams = '?customer=' + customerId;
        Map<String, Object> responseBody = executeAPIRequest(SUBSCRIPTION_ENDPOINT + requestParams, '', 'GET');
        return (List<Object>)responseBody.get(STRIPE_RESPONSE_DATA);
    }

    /**
     * Cancel a customer subscription
     * 
     * @author Jacob Huang
     * 
     * @param subscriptionId    Stripe subscription ID
     */
    public static void cancelStripeSubscription(String subscriptionId) {
        if (String.isBlank(subscriptionId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Subscription ID missing.'}); 
        }

        Map<String, Object> responseBody = executeAPIRequest(SUBSCRIPTION_ENDPOINT + '/' + subscriptionId, '', 'DELETE');
    }

    /**
     * method that creates the parameters needed to create a stripe subscription and then
     * calls the function to create the stripe subscription
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param giftType                  the type of gift being created
     * @param frequency:                the frequency of the gift
     * @param paymentId:                the payment method id in stripe to connect to the credit card
     * @param amount:                   the amount to charge
     * @param startDate:                the date the payments should start
     * @param endDate:                  Optional: the last day for a payment if it is a recurring gift
     * @param numberOfInstallments:     The number of installments if the gift is a pledge
     * @param isGivingAsOrg             Boolean that specifies whether the user is making an organizational gift
     * @param customerId                Stripe customer ID string to use
     * @param paymentOrigin             Where the payment originated in the portal
     *
     * @return                          the subscription id to be used as an external id
     */
    public virtual override String createSubscription(Map<String, Object> params) {
        String giftType = (String)params?.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        String frequency = (String)params?.get(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY);
        String paymentId = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);
        Decimal amount = (Decimal)params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY);
        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = (ucinn_ascendv2__Review_Transaction_v2__c)params?.get(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY);
        Contact cont = (Contact)params?.get(PORTAL_CONST_OnlineGiving.CONTACT_KEY);
        Integer numberOfInstallments = (Integer)params?.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY);
        Map<String, Object> billingInformation = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(params?.get(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY)));
        Boolean isGivingAsOrg = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.IS_GIVING_AS_ORG);
        String customerId = (String)params?.get(PORTAL_CONST_OnlineGiving.CUSTOMER_ID);
        String paymentOrigin = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN);

        Date startDate = (Date)params?.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY);
        if (startDate == null || startDate < Date.today()) {
            startDate = Date.today();
        }
        Date endDate = (Date)params?.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY); 
        // Stripe ends subscriptions at midnight on the end date, but other logic in ascend specifies end date as the last day to be charged
        endDate = endDate?.addDays(1);

        validateSubscriptionParams(amount, frequency);

        Decimal paymentAmount = amount;
        Decimal firstPaymentAddition = 0.0;

        //calculate the end date if it is a pledge (meaning numberOfInstallments is populated)
        if (numberOfInstallments != null && numberOfInstallments > 0) {

            // auto renewing memberships should not have the payment amount adjusted
            if (giftType?.equalsIgnoreCase(PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE) == false) {
                paymentAmount = (amount/Decimal.valueOf(numberOfInstallments)).setScale(2, RoundingMode.FLOOR);

                //if the payment amount can't be evenly divided, find the remainder to charge with the first invoice
                if (paymentAmount * numberOfInstallments != amount) {
                    firstPaymentAddition = amount - (paymentAmount * numberOfInstallments);
                }
            }

            endDate = getPledgeEndDate(frequency, startDate, numberOfInstallments);

            reviewTransaction.ucinn_ascendv2__Opportunity_End_Date__c = endDate;

        }
        
        Map<String, String> customerAndPriceItems = createCustomerAndPriceItems(paymentAmount, firstPaymentAddition, billingInformation, frequency, paymentId, cont, isGivingAsOrg, customerId);
        customerId = customerAndPriceItems.get(CUSTOMER_ID);
        String priceId = customerAndPriceItems.get(FIRST_PRICE_ID);
        String secondPriceId = customerAndPriceItems.get(SECOND_PRICE_ID);
        reviewTransaction.ucinn_portal_Stripe_Customer_ID__c = customerId;



        String subscriptionId = createStripeSubscription(customerId, paymentId, priceId, secondPriceId, startDate, endDate, paymentOrigin);

        reviewTransaction.ucinn_ascendv2__Subscription_ID__c = subscriptionId;

        return subscriptionId;
    }

    protected virtual void validateSubscriptionParams(Decimal amount, String frequency) {
        if (amount == null || amount <= 0) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Cannot make a 0 dollar subscription.'
            });
        } else if (String.isBlank(frequency)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Frequency is needed when making a subscription.'
            });
        }
    }

    /**
     * gets the end date of a pledge offsetting by the installments and frequency
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param frequency:                the frequency of the gift
     * @param startDate:                the date the payments should start
     * @param numberOfInstallments:     The number of installments if the gift is a pledge
     *
     *
     * @return                          A Date object with the last payment date
     */
    @testVisible
    protected virtual Date getPledgeEndDate(String frequency, Date startDate, Integer numberOfInstallments) {
        Date endDate = null;

        if (frequency == PORTAL_CONST_OnlineGiving.ANNUAL_FREQUENCY) {
            endDate = startDate.addYears(numberOfInstallments);
        } else if (frequency == PORTAL_CONST_OnlineGiving.SEMI_ANNUAL_FREQUENCY) {
            endDate = startDate.addMonths(numberOfInstallments*6);
        } else if (frequency == PORTAL_CONST_OnlineGiving.QUARTERLY_FREQUENCY) {
            endDate = startDate.addMonths(numberOfInstallments*3);
        } else if (frequency == PORTAL_CONST_OnlineGiving.MONTHLY_FREQUENCY) {
            endDate = startDate.addMonths(numberOfInstallments);
        } else if (frequency == PORTAL_CONST_OnlineGiving.BI_WEEKLY_FREQUENCY) {
            endDate = startDate.addDays(numberOfInstallments*14);
        } else if (frequency == PORTAL_CONST_OnlineGiving.WEEKLY_FREQUENCY) {
            endDate = startDate.addDays(numberOfInstallments*7);
        } else {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'The frequency provided is invalid.'
            });
        }

        return endDate;
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
        if (String.isNotBlank(cachedPublicApiKey)) {
            return cachedPublicApiKey;
        }
        String publicKey = PORTAL_Utils.getSecureMetadata(PUBLIC_API_KEY_DEVELOPER_NAME);

        if (String.isBlank(publicKey)) {
            if (Test.isRunningTest()) {
                return 'testKey';
            }
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error processing your gift.',
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Could not retrieve public key.',
                                                                                            PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
        cachedPublicApiKey = publicKey;
        return publicKey;
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
        Contact cont = (Contact)params?.get(PORTAL_CONST_OnlineGiving.CONTACT_KEY);
        if (cont == null) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Contact not found. User may not be logged in.'
            });
        }

        String customerId = cont.ucinn_portal_Stripe_Customer_ID__c;
        String subscriptionId = (String)params?.get(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY);
        String paymentId = (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);

        attachPaymentMethodToCustomer(paymentId, customerId);
        updateStripeSubscriptionPaymentMethod(paymentId, subscriptionId);
        
        Map<String, Object> paymentMethod = getStripeSinglePaymentMethod(paymentId, customerId);
        Map<String, String> paymentIdToDigitsMap = flattenStripePaymentMethods(new List<Object>{paymentMethod});
        return paymentIdToDigitsMap.get(paymentId);
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
        Map<String, String> resultMap = new Map<String, String>();
        Contact cont = (Contact)params?.get(PORTAL_CONST_OnlineGiving.CONTACT_KEY);
        String customerId = cont?.ucinn_portal_Stripe_Customer_ID__c;
        List<Object> subscriptionIdList = (List<Object>)params?.get(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY);
        if (customerId == null || subscriptionIdList == null || subscriptionIdList.isEmpty()) {
            return resultMap;
        }

        Set<Object> subscriptionIdSet = new Set<Object>(subscriptionIdList);
        List<Object> userSubscriptions = getStripeUncanceledSubscriptions(customerId);
        List<Object> userPaymentMethods = getStripePaymentMethods(customerId);
        Map<String, String> userPaymentIdToCreditCardMap = flattenStripePaymentMethods(userPaymentMethods);

        for (Object eachObject : userSubscriptions) {
            Map<String, Object> eachSubscription = (Map<String, Object>)eachObject;
            String subscriptionId = (String)eachSubscription.get(STRIPE_ID);
            if (subscriptionIdSet.contains(subscriptionId)) {
                String paymentMethod = (String)eachSubscription.get(STRIPE_SUBSCRIPTION_PAYMENT_METHOD);
                resultMap.put(subscriptionId, userPaymentIdToCreditCardMap.get(paymentMethod));
            }
        }

        return resultMap;
    }

    /**
     * Helper method to take a list of Stripe payment method maps and turn it into
     * a map of payment method IDs to last 4 digits of a credit card
     * 
     * @author Jacob Huang
     * 
     * @param paymentMethodList     list of Stripe payment method maps
     * 
     * @return                      map of payment method ID to the last 4 digits of the credit card used
     */
    public static Map<String, String> flattenStripePaymentMethods(List<Object> paymentMethodList) {
        Map<String, String> userPaymentIdToCreditCardMap = new Map<String, String>();
        for (Object eachObject : paymentMethodList) {
            Map<String, Object> eachPaymentMethod = (Map<String, Object>)eachObject;
            Map<String, Object> creditCard = (Map<String, Object>)eachPaymentMethod.get(STRIPE_PAYMENT_METHOD_CARD);
            userPaymentIdToCreditCardMap.put((String)eachPaymentMethod.get(STRIPE_ID), (String)creditCard.get(STRIPE_CARD_LAST_4));
        }

        return userPaymentIdToCreditCardMap;
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
        String subscriptionId = (String)params?.get(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY);

        if (subscriptionId == null) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Subscription not found'});
        }
        
        cancelStripeSubscription(subscriptionId);
    }

    /**
     * Returns the payment method tender type used to conduct the transaction
     *
     * @author:                         Todd Shinto
     * @since:                          1.4
     *
     * @param paymentMethod             The payment method from the additional payment map
     *
     * @return                          Payment method tender type
     */
    public virtual override String getReviewTransactionTenderType(Map<Object, Object> additionalPaymentDataMap) {
        return PORTAL_CONST_OnlineGiving.CREDIT_CARD;
    }
}