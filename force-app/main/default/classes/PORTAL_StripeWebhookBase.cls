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

global without sharing class PORTAL_StripeWebhookBase {

    public static final String ID_CONST = 'id';
    public static final String INVOICE_ID_CONST = 'invoice_id';
    public static final String AMOUNT_PAID_CONST = 'amount_paid';
    public static final String CHARGE_ID_CONST = 'charge';
    public static final String TIMESTAMP_CONST = 'created';
    public static final String CURRENCY_CONST = 'currency';
    public static final String CUSTOMER_ID_CONST = 'customer';
    public static final String SUBSCRIPTION_ID_CONST = 'subscription';
    public static final String BILLING_REASON_CONST = 'billing_reason';
    public static final String INTERVAL_CONST = 'interval';
    public static final String STATUS_CONST = 'status';
    public static final String DATA_CONST = 'data';
    public static final String OBJECT_CONST = 'object';
    public static final String METADATA_CONST = 'metadata';
    public static final String LAST_PAYMENT_ERROR_CONST = 'last_payment_error';
    public static final String MESSAGE_CONST = 'message';
    public static final String TYPE_CONST = 'type';
    public static final String EVENT_TYPE = 'eventType';
    public static final String LINES_CONST = 'lines';
    public static final String PARAMS_CONST = 'params';
    public static final String PORTAL_RTV2_EXTERNAL_PAYMENT_GATEWAY_STATUS_API_NAME = 'ucinn_portal_Ext_Payment_Gateway_Status__c';
    public static final String OPP_EXTERNAL_PAYMENT_GATEWAY_STATUS_API_NAME = 'ucinn_ascendv2__Status_In_External_Payment_Gateway__c';
    public static final String INVOICE_PAYMENT_SUCCEEDED = 'invoice.payment_succeeded';
    public static final String CUSTOMER_SUBSCRIPTION_UPDATED = 'customer.subscription.updated';
    public static final String INVOICE_UPDATED = 'invoice.updated';
    public static final String CUSTOMER_SUBSCRIPTION_DELETED = 'customer.subscription.deleted';
    public static final String PAYMENT_INTENT_SUCCEEDED = 'payment_intent.succeeded';
    public static final String PAYMENT_INTENT_PAYMENT_FAILED = 'payment_intent.payment_failed';
    public static final String SETUP_INTENT_SUCCEEDED = 'setup_intent.succeeded';
    public static final String SETUP_INTENT_SETUP_FAILED = 'setup_intent.setup_failed';
    public static final String METADATA_PARAMS = 'metadataParamsObj';
    public static final String SUBSCRIPTION_CYCLE = 'subscription_cycle';
    public static final String SUBSCRIPTION_UPDATE = 'subscription_update';
    public static final String CONTACT_ID = 'contactId';
    public static final String PAYMENT_METHOD = 'payment_method';
    public static final String PAYMENT_METHOD_DETAILS = 'payment_method_details';
    public static final String IS_FAILURE = 'isFailure';

    //Stripe gives lowercase versions of statuses so we map them to our picklist values
    public static final Map<String, String> statusMap = new Map<String, String> { 'incomplete' => 'Incomplete',
                                                                                'incomplete_expired' => 'Incomplete-Expired',
                                                                                'past_due' => 'Past Due',
                                                                                'canceled' => 'Cancelled',
                                                                                'unpaid' => 'Unpaid',
                                                                                'active' => 'Active'};

    //FUTURE TODO: move all these statics to a overridable class
    global PORTAL_StripeWebhookBase() {

    }

    /**
     * Uses Stripe webhook's signing secret, a map of the t, v0, and v1 values from the header, and the payload
     * to generate the HMAC SHA256 value which should match v1.
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param secret:                   The webhook secret from Stripe
     * @param keyValues:                map of the t, v0, and v1 values from the header
     * @param payload:                  the request body
     */
    global static String generateHash(String secret, Map<String, String> keyValues, String payload) {
        String signedPayload = keyValues.get('t')+ '.' + payload;
        Blob hmac = Crypto.generateMac('HMACSHA256', Blob.valueOf(signedPayload), Blob.valueOf(secret));
        return EncodingUtil.convertToHex(hmac);
    }

    /**
     * processes incoming events into flattened versions to make it easier to access relevant variables
     *
     * @author Ashley Tran
     * @since 1.0
     *
     * @param body:         Map<String, Object> for body of the callout
     * @return              Map<String, Object> of the flattened response
     *
     */
    global static Map<String, Object> processEventBody(Map<String, Object> body) {
        Map<String, Object> returnMap = new Map<String, Object>();

        //FUTURE TODO: think of a way to unify these
        String eventType = (String)body.get(TYPE_CONST);
        if (eventType == INVOICE_PAYMENT_SUCCEEDED) {
            returnMap = processInvoiceFinalizedBody(body);
        } else if (eventType == CUSTOMER_SUBSCRIPTION_UPDATED || eventType == INVOICE_UPDATED || eventType == CUSTOMER_SUBSCRIPTION_DELETED) {
            returnMap = processEventBody(body, eventType);
        } else if (isStripeIntentEvent(eventType)) {
            returnMap = processStripeElementIntentEventBody(body, eventType);
        } 
        
        returnMap.put(EVENT_TYPE, eventType);

        return returnMap;
    }

    /**
     * Determines whether the webhook event type is one of the Stripe intent events that we listen for
     * 
     * @author Todd Shinto
     * @since 1.2
     * 
     * @param eventType     String: webhook type 
     * 
     * @return              Boolean: whether the webhook event type is one of the Stripe intent events that we listen for
     */
    private static Boolean isStripeIntentEvent(String eventType) {
        return eventType == PAYMENT_INTENT_SUCCEEDED || eventType == PAYMENT_INTENT_PAYMENT_FAILED || eventType == SETUP_INTENT_SUCCEEDED || eventType == SETUP_INTENT_SETUP_FAILED;
    }
    
    /**
     * Processes the incoming metadata from Stripe on payment intent success or fail
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param body:                 The response json as a map
     * @param eventType:            The type of Stripe event
     * @return                      Map<String, Object> of rtv2 params and origin of payment
     */
    private static Map<String, Object> processStripeElementIntentEventBody(Map<String, Object> body, String eventType) {
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, Object> outerData = (Map<String, Object>)body?.get(DATA_CONST);
        Map<String, Object> outerDataObj = (Map<String, Object>)outerData?.get(OBJECT_CONST);
        Map<String, Object> metadataObj = (Map<String, Object>)outerDataObj?.get(METADATA_CONST);
        Map<String, Object> metadataParams = extractMetadataParams(metadataObj);
        
        Map<String, Object> metadataParamsObj = new Map<String, Object>();
        if ((Map<String, Object>)metadataParams?.get(PARAMS_CONST) != null) {
            metadataParamsObj = (Map<String, Object>)metadataParams.get(PARAMS_CONST);
        }

        if (eventType == PAYMENT_INTENT_PAYMENT_FAILED || eventType == SETUP_INTENT_SETUP_FAILED) {
            addPaymentErrorMessage(metadataParamsObj, outerDataObj);
        }

        String paymentIdKey = getPaymentIdKey(eventType);

        metadataParamsObj.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, (String)outerDataObj?.get(paymentIdKey));
        metadataParamsObj.put(PORTAL_CONST_OnlineGiving.CUSTOMER_ID, (String)outerDataObj?.get(CUSTOMER_ID_CONST));
        metadataParamsObj.put(CONTACT_ID, (String)metadataObj?.get(CONTACT_ID));
        metadataParamsObj.put(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN, (String)metadataParams?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN));
        String paymentMethodId = (String)outerDataObj?.get(PAYMENT_METHOD);
        Map<String, Object> paymentMethod = PORTAL_StripePaymentGateway.getStripePaymentMethod(paymentMethodId);
        String tenderType = (String)paymentMethod?.get(TYPE_CONST);

        metadataParamsObj.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, getAdditionalPaymentDataMap((Map<Object, Object>)metadataParamsObj?.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS), tenderType));

        returnMap.put(METADATA_PARAMS, metadataParamsObj);
        returnMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN, metadataParams?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN));

        return returnMap;
    }

    /**
     * This will return the paymentIdKey to be used to get a unique id from Stripe
     * 
     * @author: Todd Shinto
     * @since: 1.5
     *
     * @param eventType:            The type of payment event
     * @return                      String of which paymentIdKey to use
     */
    private static String getPaymentIdKey(String eventType) {
        if (eventType == PAYMENT_INTENT_SUCCEEDED || eventType == PAYMENT_INTENT_PAYMENT_FAILED) {
            return ID_CONST;
        } else if (eventType == SETUP_INTENT_SUCCEEDED || eventType == SETUP_INTENT_SETUP_FAILED) {
            return PAYMENT_METHOD;
        }

        return ID_CONST;
    }

    /**
     * This will add the payment method tender type to the additional payment data map and return the map
     * 
     * @author: Todd Shinto
     * @since: 1.5
     *
     * @param additionalPaymentDataMap: A map of additional payment data
     * @param tenderType:               The payment method tender type
     * @return                          Map<Object, Object> of the additionalPaymentDataMap with the tenderType added
     */
    private static Map<Object, Object> getAdditionalPaymentDataMap(Map<Object, Object> additionalPaymentDataMap, String tenderType) {
        if (additionalPaymentDataMap == null || additionalPaymentDataMap.isEmpty()) {
            return new Map<Object, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY => tenderType};
        }

        additionalPaymentDataMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY, tenderType);

        return additionalPaymentDataMap;
    }

    /**
     * This will extract the metadata stored in the Stripe callout and build it into a map
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param outerDataObj:         The response json
     * @return                      Map<String, Object> of the metadata
     */
    private static Map<String, Object> extractMetadataParams(Map<String, Object> metadataObj) {
        if (metadataObj == null) {
            return new Map<String, Object>();
        }

        String metadataString = '';

        for (Integer metadataIndex = 0; metadataIndex < metadataObj.size(); metadataIndex++) {
            String metadataKeyIndex = String.valueOf(metadataIndex);
            if (metadataObj.containsKey(metadataKeyIndex)) {
                metadataString += (String)metadataObj.get(metadataKeyIndex);
            }
        }

        if (String.isBlank(metadataString)) {
            return new Map<String, Object>();
        }

        return (Map<String, Object>)JSON.deserializeUntyped(metadataString);
    }
    
    /**
     * If the payment failed, add a boolean indcating failure to the metadata
     * and add the fail message as a manual review reason
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param outerDataObj:         The response json
     * @param metadataParamsObj:    The metadata params as a map
     * @return                      
     */
    private static void addPaymentErrorMessage(Map<String, Object> metadataParamsObj, Map<String, Object> outerDataObj) {
        Map<String, Object> paymentError = (Map<String, Object>)outerDataObj?.get(LAST_PAYMENT_ERROR_CONST);
        String paymentErrorMessage = (String)paymentError?.get(MESSAGE_CONST);
        if (metadataParamsObj != null) {
            metadataParamsObj.put(IS_FAILURE, true);
            metadataParamsObj.put(PORTAL_CONST_OnlineGiving.MANUAL_REVIEW_REASON, paymentErrorMessage);
        }
    }
        
    /**
     * This will determine if the payment origin is the Stripe payment element
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param paymentOrigin         String: origin of the webhook
     * 
     * @return                      Boolean: whether the webhook is the result of a Stripe Payment Element form
     */
    private static Boolean isFromStripePaymentElement(String paymentOrigin) {
        return paymentOrigin == PORTAL_CONST_OnlineGiving.ONLINE_GIVING_PAYMENT_ELEMENT ||
               paymentOrigin == PORTAL_CONST_OnlineGiving.EVENTS_PAYMENT_ELEMENT || 
               paymentOrigin == PORTAL_CONST_OnlineGiving.MEMBERSHIP_PAYMENT_ELEMENT ||
               paymentOrigin == PORTAL_CONST_OnlineGiving.CONTEXTUAL_GIVING_FORM_PAYMENT_ELEMENT;
    }
            
    /**
     * This will call the logic to build the review transaction
     * 
     * @author: Todd Shinto
     * @since: 1.2
     *
     * @param metadataParamsObj:    The metadata params as a map
     * @return                      
     */
    private static void processOnlineGivingEvent(Map<String, Object> metadataParamsObj) {
        PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
        controller.SERVER_createReviewTransaction(metadataParamsObj);
    }

    /**
     * This will call the logic to build the review transaction, needs to be a future method because of potential payment processor callouts
     * 
     * @author: Jacob Huang (copied Todd's processOnlineGivingEvent and changed names)
     * @since: 1.3
     *
     * @param metadataParamsObj:    String: The params map, serialized bc future methods can't have map arguments 
     */
    private static void processMembershipEvent(Map<String, Object> metadataParamsObj) {
        PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();
        controller.createReviewTransaction(metadataParamsObj);
    }

    /**
     * Update the status and receipt for the Registration Session that this webhook originated from 
     * 
     * @author Jacob Huang
     * @since 1.3
     * 
     * @param params                Map<String, Object>: params map from the webhook metadata
     */
    private static void processEventsEvent(Map<String, Object> params) {
        PORTAL_ShoppingCartControllerBase controller = (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController();
        controller.completeEventPaymentCheckout(params);
    }

    /**
     * Extracts required fields from JSON body and returns them as part of a flattened map
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param body:                   The response json as a map
     */
    public static Map<String, Object> processInvoiceFinalizedBody(Map<String, Object> body) {
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, Object> outerData = (Map<String, Object>)body.get(DATA_CONST);
        Map<String, Object> outerDataObj = (Map<String, Object>)outerData.get(OBJECT_CONST);
        Map<String, Object> lines = (Map<String, Object>)outerDataObj.get(LINES_CONST);
        List<Object> data = (List<Object>)lines.get(DATA_CONST);
        Map<String, Object> dataItem = (Map<String, Object>)data[0];
        Map<String, Object> plan = new Map<String, Object>();
        Map<String, Object> metadata = new Map<String, Object>();

        if (dataItem.get('plan') != null){
            plan = (Map<String, Object>)dataItem.get('plan');
        }
        String interval = '';
        if (plan.get(INTERVAL_CONST) !=null ){
            interval = (String)plan.get(INTERVAL_CONST);
        }

        returnMap.put(ID_CONST, (String)body.get(ID_CONST));
        returnMap.put(INVOICE_ID_CONST, (String)outerDataObj.get(ID_CONST));
        returnMap.put(AMOUNT_PAID_CONST, (((Decimal)outerDataObj.get(AMOUNT_PAID_CONST))/100));
        returnMap.put(CHARGE_ID_CONST, (String)outerDataObj.get(CHARGE_ID_CONST));
        returnMap.put(TIMESTAMP_CONST, (Long)outerDataObj.get(TIMESTAMP_CONST));
        returnMap.put(CURRENCY_CONST, (String)outerDataObj.get(CURRENCY_CONST));
        returnMap.put(CUSTOMER_ID_CONST, (String)outerDataObj.get(CUSTOMER_ID_CONST));
        returnMap.put(SUBSCRIPTION_ID_CONST, (String)outerDataObj.get(SUBSCRIPTION_ID_CONST));
        returnMap.put(BILLING_REASON_CONST, (String)outerDataObj.get(BILLING_REASON_CONST));
        returnMap.put(INTERVAL_CONST, interval);

        return returnMap;
    }

    /**
     * Extracts required fields from JSON body and returns them as part of a flattened map
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param body:                   The response json as a map
     * @param eventType:              the type of Stripe event
     */
    private static Map<String, Object> processEventBody(Map<String, Object> body, String eventType) {
        Map<String, Object> returnMap = new Map<String, Object>();

        //lines contains info on the payments/plans/subscriptions
        Map<String, Object> outerData = (Map<String, Object>)body.get(DATA_CONST);
        Map<String, Object> outerDataObj = (Map<String, Object>)outerData.get(OBJECT_CONST);

        returnMap.put('request_id', (String)body.get(ID_CONST));
        returnMap.put(SUBSCRIPTION_ID_CONST, (String)outerDataObj.get(ID_CONST));
        if (eventType == CUSTOMER_SUBSCRIPTION_UPDATED) {
            returnMap.put(STATUS_CONST, (String)outerDataObj.get(STATUS_CONST));
        } else if (eventType == CUSTOMER_SUBSCRIPTION_DELETED) {
            returnMap.put(STATUS_CONST, 'canceled');
        }

        return returnMap;
    }

    /**
     * Uses the flattened map of data to update the status of a subscription.
     * Returns true if successful, false otherwise
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param fieldMap:                   The flattened json response
     */
    @TestVisible
    private static Boolean updateSubscriptionStatus(Map<String, Object> fieldMap) {
        String subscriptionId = (String)fieldMap.get(SUBSCRIPTION_ID_CONST);
        String status = (String)fieldMap.get(STATUS_CONST);
        List<Opportunity> opportunityList = [SELECT Id, ucinn_ascendv2__Subscription_ID__c
                                                FROM Opportunity WHERE ucinn_ascendv2__Subscription_ID__c = :subscriptionId];

        if (opportunityList != null && !opportunityList.isEmpty()) {
            for (Opportunity opp : opportunityList) {
                updateStatus(opp, status, OPP_EXTERNAL_PAYMENT_GATEWAY_STATUS_API_NAME);
            }
            update opportunityList;
        } else {
            List<ucinn_ascendv2__Review_Transaction_v2__c> reviewTransactionList = [SELECT Id, ucinn_ascendv2__Subscription_ID__c
                                                                                    FROM ucinn_ascendv2__Review_Transaction_v2__c
                                                                                    WHERE ucinn_ascendv2__Subscription_ID__c = :subscriptionId];
            if (reviewTransactionList == null || reviewTransactionList.isEmpty()) {
                return false;
            }
            for (ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction : reviewTransactionList) {
                updateStatus(reviewTransaction, status, PORTAL_RTV2_EXTERNAL_PAYMENT_GATEWAY_STATUS_API_NAME);
            }
            update reviewTransactionList;
        }

        return true;
    }

    /**
     * Transforms the status from Stripe into an ascend status
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param record:                   the record we need to update
     * @param status:                   the status from Stripe
     * @param field:                    the field we are updating
     */
    private static void updateStatus(sObject record, String status, String field) {
        String mappedStatus = status;
        if (statusMap.containsKey(status)) {
            mappedStatus = statusMap.get(status);
        }
        record.put(field, mappedStatus);
    }

    /**
     * Uses the flattened map of data to create review transactions as needed
     * will first check to see if there is an opportunity associated with the subscription
     * and if there is not, will check to see if there is a review transaction
     * associated with the subscription, for the case of the subscription ending up in manual review
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param fieldMap:                     The flattened json response
     * @param reviewTransactionPrefix:      prefix for rtv2 record
     */
    private static Boolean createSubscriptionPayment(Map<String, Object> fieldMap,  String reviewTransactionPrefix) {
        String subscriptionId = (String)fieldMap.get(SUBSCRIPTION_ID_CONST);
        Boolean foundOpportunity = createPaymentForOpportunities(fieldMap, subscriptionId, reviewTransactionPrefix);

        if (!foundOpportunity) {
            return createPaymentForReviewTransaction(fieldMap, subscriptionId, reviewTransactionPrefix);
        }

        return true;
    }


    /**
     * Creates a payment review transaction based on the data from the
     * Stripe event and the opportunity itself
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param fieldMap:                     The flattened json response
     * @param subscriptionId:               The id of the subscription we are trying to pay
     * @param reviewTransactionPrefix:      prefix for rtv2 record
     */
    @TestVisible
    private static Boolean createPaymentForOpportunities(Map<String, Object> fieldMap, String subscriptionId,  String reviewTransactionPrefix) {
        if (String.isBlank(subscriptionId)) {
            return false;
        }

        List<Opportunity> opportunityList = [SELECT Id, ucinn_ascendv2__Contact__c, RecordType.DeveloperName, AccountId, ucinn_ascendv2__Subscription_ID__c,
                                            Campaign.ucinn_ascendv2__Motivation_Code__c, ucinn_ascendv2__Frequency__c, ucinn_ascendv2__External_System_ID__c, Type,
                                            (SELECT ucinn_ascendv2__Designation_Unit_1_Amount_Formula__c, ucinn_ascendv2__Designation__r.ucinn_ascendv2__Acknowledgement_Description__c,
                                                ucinn_ascendv2__Designation__c, ucinn_ascendv2__Designation__r.ucinn_ascendv2__External_System_ID__c, ucinn_ascendv2__Amount__c
                                                FROM ucinn_ascendv2__Designation_Details_Opportunity__r),
                                            (SELECT ucinn_ascendv2__Expected_Less_Payment_Amount_Formula__c, ucinn_ascendv2__Designation__c, ucinn_ascendv2__Expected_Date__c
                                                FROM ucinn_ascendv2__Installments_Opportunity__r 
                                                WHERE ucinn_ascendv2__Expected_Less_Payment_Amount_Formula__c > 0 
                                                ORDER BY ucinn_ascendv2__Expected_Date__c ASC)
                                            FROM Opportunity WHERE ucinn_ascendv2__Subscription_ID__c = :subscriptionId AND ucinn_ascendv2__External_System_ID__c != null];

        if (opportunityList == null || opportunityList.isEmpty()) {
            return false;
        }

        Opportunity opp = opportunityList.get(0);
        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

        if (String.isNotBlank(opp.ucinn_ascendv2__Contact__c)) {
            reviewTransaction.ucinn_ascendv2__Contact__c = opp.ucinn_ascendv2__Contact__c;
        } else if (String.isNotBlank(opp.AccountId)) {
            reviewTransaction.ucinn_ascendv2__Account__c = opp.AccountId;
        }

        reviewTransaction.ucinn_ascendv2__Opportunity_External_ID__c = opp.ucinn_ascendv2__External_System_ID__c;

        Datetime dt = Datetime.newInstance((Long)fieldMap.get(TIMESTAMP_CONST)*1000);
        Date paymentDate = Date.newInstance(dt.year(), dt.month(), dt.day());
        reviewTransaction.ucinn_ascendv2__Status__c = 'New';
        reviewTransaction.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
        reviewTransaction.ucinn_ascendv2__Transaction_Date__c = paymentDate;
        reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c = (Decimal)fieldMap.get(AMOUNT_PAID_CONST);

        reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c = opp.Campaign.ucinn_ascendv2__Motivation_Code__c;
        reviewTransaction.ucinn_ascendv2__Subscription_ID__c = opp.ucinn_ascendv2__Subscription_ID__c;
        reviewTransaction.ucinn_ascendv2__External_Payment_Gateway_ID__c = (String)fieldMap.get(CHARGE_ID_CONST);

        reviewTransaction.ucinn_ascendv2__Opportunity__c = opp.Id;

        Map<Id, Decimal> designationIdToAmountMap = null;

        if (opp.RecordType.DeveloperName == 'Recurring_Gift'){
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT_PAYMENT_TRANSACTION_TYPE;
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = opp.Type;
            designationIdToAmountMap = createDesignationToAmountMapForRecurringGift(opp.ucinn_ascendv2__Designation_Details_Opportunity__r, reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c);
        } else if (opp.RecordType.DeveloperName == 'Pledge') {
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_PAYMENT;
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = opp.Type;
            designationIdToAmountMap = ucinn_ascendv2.ascend_STRIPE_WebhooksBase.calculateDesignationDetailsToPay(opp, reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c);
        } else if (opp.ucinn_ascendv2__Designation_Details_Opportunity__r?.isEmpty() == false) {
            designationIdToAmountMap = new Map<Id, Decimal>{opp.ucinn_ascendv2__Designation_Details_Opportunity__r[0].ucinn_ascendv2__Designation__c => reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c};
        }

        //Base class will take in a prefix parameter but anyone implementing this class will need to pass in the prefix they want to use
        reviewTransaction.ucinn_ascendv2__External_System_ID__c = reviewTransactionPrefix  + '-' + (String)fieldMap.get(CHARGE_ID_CONST);

        if (opp.ucinn_ascendv2__Designation_Details_Opportunity__r != null){
            for(Integer designationDetailIndex = 1; designationDetailIndex <= opp.ucinn_ascendv2__Designation_Details_Opportunity__r.size(); designationDetailIndex++){
                ucinn_ascendv2__Designation_Detail__c detail = opp.ucinn_ascendv2__Designation_Details_Opportunity__r.get(designationDetailIndex-1);
                String nameSpace = PORTAL_CONST_OnlineGiving.NAMESPACE;
                if (designationDetailIndex > 5) {
                    nameSpace = '';
                }
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_DATE_PREFIX + designationDetailIndex + '_1__c', paymentDate);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_FREQUENCY_PREFIX + designationDetailIndex + '__c', opp.ucinn_ascendv2__Frequency__c);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.DESIGNATION_PREFIX + designationDetailIndex + '__c', detail.ucinn_ascendv2__Designation__c);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_AMOUNT_PREFIX + designationDetailIndex + '_1__c', designationIdToAmountMap.get(detail.ucinn_ascendv2__Designation__c));

            }
        }
        insert reviewTransaction;
        return true;
    }

    /**
     * Uses the same logic from ascend_STRIPE_WebhookBase to determine how some total amount should be distributed 
     * to each of a recurring gift's designation details 
     *  
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param designationDetailList     List<ucinn_ascendv2__Designation_Detail__c>: list of designation details related to the Opportunity in question
     * @param transactionAmount         Decimal: Stripe-reported amount that the user was charged
     * 
     * @return Map<Id, Decimal>: mapping between a Designation Id and the amount to credit to that designation
     */
    @TestVisible
    private static Map<Id, Decimal> createDesignationToAmountMapForRecurringGift(List<ucinn_ascendv2__Designation_Detail__c> designationDetailList, Decimal transactionAmount) {
        Map<Id, Decimal> designationIdToAmountMap = new Map<Id, Decimal>();
        if (designationDetailList == null || designationDetailList.isEmpty()) {
            return designationIdToAmountMap;
        }

        // for each designation detail, try to credit the full amount, otherwise credit what remains
        for (ucinn_ascendv2__Designation_Detail__c eachDesignationDetail : designationDetailList) {
            Decimal amountForDesignation = 0;
            if (transactionAmount != null && eachDesignationDetail.ucinn_ascendv2__Amount__c != null) {
                amountForDesignation = Math.min(transactionAmount, eachDesignationDetail.ucinn_ascendv2__Amount__c);
                transactionAmount -= amountForDesignation;
            }
            designationIdToAmountMap.put(eachDesignationDetail.ucinn_ascendv2__Designation__c, amountForDesignation);
        }

        // if some amount is left, credit it to the first designation detail
        if (transactionAmount > 0) {
            Id firstDesignationId = designationDetailList[0].ucinn_ascendv2__Designation__c;
            designationIdToAmountMap.put(firstDesignationId, designationIdToAmountMap.get(firstDesignationId) + transactionAmount);
        }

        return designationIdToAmountMap;
    }

    /**
     * Creates a payment review transaction based on the data from the
     * Stripe event and the review transaction itself
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param fieldMap:                   The flattened json response
     * @param subscriptionId:             The id of the subscription we are trying to pay
     */
    @TestVisible
    private static Boolean createPaymentForReviewTransaction(Map<String, Object> fieldMap, String subscriptionId,  String reviewTransactionPrefix) {
        if (String.isBlank(subscriptionId)) {
            return false;
        }

        List<ucinn_ascendv2__Review_Transaction_v2__c> reviewTransactionList = [SELECT Id, ucinn_ascendv2__Contact__c, ucinn_ascendv2__Opportunity_External_ID__c,
                                                                                ucinn_ascendv2__Campaign_External_ID__c, ucinn_ascendv2__Designation_1__c,
                                                                                ucinn_ascendv2__Designation_2__c, ucinn_ascendv2__Designation_3__c, ucinn_ascendv2__Designation_4__c,
                                                                                ucinn_ascendv2__Designation_5__c, ucinn_ascendv2__Installment_Frequency_1__c,
                                                                                ucinn_ascendv2__Installment_Frequency_2__c, ucinn_ascendv2__Installment_Frequency_3__c,
                                                                                ucinn_ascendv2__Installment_Frequency_4__c, ucinn_ascendv2__Installment_Frequency_5__c,
                                                                                ucinn_ascendv2__Installment_Amount_1__c,
                                                                                ucinn_ascendv2__Installment_Amount_2__c, ucinn_ascendv2__Installment_Amount_3__c,
                                                                                ucinn_ascendv2__Installment_Amount_4__c, ucinn_ascendv2__Installment_Amount_5__c,
                                                                                ucinn_ascendv2__Payment_Amount_1_1__c, ucinn_ascendv2__Payment_Amount_2_1__c,
                                                                                ucinn_ascendv2__Payment_Amount_3_1__c, ucinn_ascendv2__Payment_Amount_4_1__c,
                                                                                ucinn_ascendv2__Payment_Amount_5_1__c,
                                                                                ucinn_ascendv2__First_Name__c, ucinn_ascendv2__Last_Name__c,
                                                                                ucinn_ascendv2__Middle_Name__c, ucinn_ascendv2__Email_1__c, ucinn_ascendv2__Email_1_Type__c,
                                                                                ucinn_ascendv2__Country_1__c, ucinn_ascendv2__Address_1_Line_1__c,
                                                                                ucinn_ascendv2__City_1__c, ucinn_ascendv2__State_1__c, ucinn_ascendv2__Postal_Code_1__c,
                                                                                ucinn_ascendv2__Address_1_Type__c, ucinn_ascendv2__Transaction_Type__c,
                                                                                ucinn_ascendv2__Opportunity_End_Date__c, ucinn_ascendv2__Account__c,
                                                                                ucinn_ascendv2__Subscription_ID__c
                                                                                FROM ucinn_ascendv2__Review_Transaction_v2__c
                                                                                WHERE ucinn_ascendv2__Subscription_ID__c = :subscriptionId];
        if (reviewTransactionList == null || reviewTransactionList.isEmpty()) {
            return false;
        }

        ucinn_ascendv2__Review_Transaction_v2__c subscriptionReviewTransaction = reviewTransactionList.get(0);
        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

        reviewTransaction.ucinn_ascendv2__Status__c = 'New';

        Datetime dt = Datetime.newInstance((Long)fieldMap.get(TIMESTAMP_CONST)*1000);
        Date paymentDate = Date.newInstance(dt.year(), dt.month(), dt.day());


        Map<String, Object> populatedReviewTransactionFields = subscriptionReviewTransaction.getPopulatedFieldsAsMap();
        for (String field : populatedReviewTransactionFields.keySet()) {
            if (field == ID_CONST) {
                continue;
            }
            if (reviewTransaction.get(field) == null) {
                reviewTransaction.put(field, populatedReviewTransactionFields.get(field));
                if (field.contains('Designation')) {
                    String index = field.replace('ucinn_ascendv2__Designation_', '').replace('__c', ''); //gets the number field is in form of "ucinn_ascendv2__Designation_#__c"
                    String namespace = PORTAL_CONST_OnlineGiving.NAMESPACE;
                    if (Integer.valueOf(index) > 5) {
                        namespace = '';
                    }
                    reviewTransaction.put(namespace + 'Payment_Date_' + index + '_1__c', paymentDate);
                }
            }
        }

        reviewTransaction.ucinn_ascendv2__External_Payment_Gateway_ID__c = (String)fieldMap.get(CHARGE_ID_CONST);
        reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c = (Decimal)fieldMap.get(AMOUNT_PAID_CONST);

        if (subscriptionReviewTransaction.ucinn_ascendv2__Transaction_Type__c == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE || subscriptionReviewTransaction.ucinn_ascendv2__Transaction_Type__c == PORTAL_CONST_OnlineGiving.PLEDGE_PAYMENT_TRANSACTION_TYPE) {
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_TRANSACTION_TYPE;
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE;
            reviewTransaction.ucinn_ascendv2__Opportunity_End_Date__c = subscriptionReviewTransaction.ucinn_ascendv2__Opportunity_End_Date__c;
        } else if (subscriptionReviewTransaction.ucinn_ascendv2__Transaction_Type__c == PORTAL_CONST_OnlineGiving.RECURRING_GIFT || subscriptionReviewTransaction.ucinn_ascendv2__Transaction_Type__c == 'Recurring Gift with Payment') {
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT_PAYMENT_TRANSACTION_TYPE;
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.RECURRING;
        }

        reviewTransaction.ucinn_ascendv2__Subscription_ID__c = subscriptionReviewTransaction.ucinn_ascendv2__Subscription_ID__c;
        reviewTransaction.ucinn_ascendv2__External_System_ID__c = reviewTransactionPrefix + '-' +  (String)fieldMap.get(CHARGE_ID_CONST);

        reviewTransaction.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
        reviewTransaction.ucinn_ascendv2__Transaction_Date__c = paymentDate;
        insert reviewTransaction;
        return true;
    }

    /**
     * Uses the flattened map of data to create review transactions as needed
     * returns false if it fails, true otherwise
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param fieldMap:                     The flattened json response
     * @param reviewTransactionPrefix:      rtv2 prefix
     */
    global static Boolean createOrUpdateRecords(Map<String, Object> fieldMap, String reviewTransactionPrefix) {
        String eventType =  (String)fieldMap?.get(EVENT_TYPE);
        String paymentOrigin = (String)fieldMap?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN);

        if (eventType == INVOICE_PAYMENT_SUCCEEDED) {
            //pledge or recurring gift payment recieved
            if (fieldMap.get(BILLING_REASON_CONST) == SUBSCRIPTION_CYCLE || fieldMap.get(BILLING_REASON_CONST) == SUBSCRIPTION_UPDATE){
                if ((String)fieldMap.get(INVOICE_ID_CONST) != 'in_00000000000000') {
                    return createSubscriptionPayment(fieldMap, reviewTransactionPrefix);
                }
            }

            return false;

        } else if (eventType == CUSTOMER_SUBSCRIPTION_UPDATED || eventType == CUSTOMER_SUBSCRIPTION_DELETED) {
            //subscription was modified in Stripe
            if ((String)fieldMap.get(SUBSCRIPTION_ID_CONST) != 'sub_00000000000000') {
                return updateSubscriptionStatus(fieldMap);
            }
            return false;
        } else if (isStripeIntentEvent(eventType) && isFromStripePaymentElement(paymentOrigin)) {
            Map<String, Object> params = (Map<String, Object>)fieldMap.get(METADATA_PARAMS);
            if (paymentOrigin == PORTAL_CONST_OnlineGiving.ONLINE_GIVING_PAYMENT_ELEMENT || paymentOrigin == PORTAL_CONST_OnlineGiving.CONTEXTUAL_GIVING_FORM_PAYMENT_ELEMENT) {
                processOnlineGivingEvent(params);
            } else if (paymentOrigin == PORTAL_CONST_OnlineGiving.MEMBERSHIP_PAYMENT_ELEMENT) {
                processMembershipEvent(params);
            } else if (paymentOrigin == PORTAL_CONST_OnlineGiving.EVENTS_PAYMENT_ELEMENT) {
                processEventsEvent(params);
            }
        }

        return true; //no need to throw errors for other eventTypes since they don't affect records or not implemented
    }
}