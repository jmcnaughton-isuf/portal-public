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
 * This serves as the abstract class for payment gateways to extend
 */
public abstract class PORTAL_PaymentGateway {
    public enum WalletType {GooglePay, ApplePay}
    //TODO: move response wrappers into here
    //TODO: change recurring to use response wrapper too for consistency


    /**creates a one time transaction and returns a unique external Id to be used by the rtv2 record
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentId                         token that identifies the payment, different meaning per integration
     * @param externalGatewayName               if using spreedly, The name of the Spreedly gateway to use. Must match a custom setting record for the object ucinn_ascendv2__Spreedly_Gateway__c
     * @param amount                            The amount to charge the card in USD
     * @param reviewTransaction                 The review transaction record to edit additional fields on
     *
     * @return Unique Transaction Id to for the rtv2 external Id
     */
    public abstract PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params);

    /**
     * creates a recurring gift or pledge with automated payments, either through adding fields to the rtv2 record,
     * or creating a subscription in the payment gateway depending on integration
     *
     * @author                  Sam Longo
     * @since                   1.0
     *
     * @param paymentId                         payment token generated by the IFrame on the frontend corresponding to the credit card used
     * @param externalGatewayName               The name of the Spreedly gateway to use. Must match a custom setting record for the object ucinn_ascendv2__Spreedly_Gateway__c
     * @param giftType                          The type of gift being created, used to differentiate between handling the payments through installments for a pledge, or from paying off the designation detail like a recurring gift (without distinguishing, pledges would get charged twice)
     * @param reviewTransaction                 The review transaction record to edit additional fields on
     * @param startDate                         The Date for when the payments should begin i.e. recurring payments that begin on the end of the month instead of immediate
     * @param endDate                           Optional: the last day for a payment if it is a recurring gift
     * @param frequency                         String for the frequency of the payments
     * @param amount                            total amount for the gift
     * @param stripeBillingInformation          formatted billing information JSON string
     * @param cont                              contact record that is the payer
     * @param apiKeyName                        api key for the transaction token, used by Stripe
     *
     * @return The unique String for the transaction Id to identify the external Id in the rtv2 record
     */
    public abstract String createSubscription(Map<String, Object> params);

    /**
     * This method assumes that createSubscription() changes the review transaction record. Calls createSubscription()
     *
     * @author                  Todd Shinto
     * @since                   1.12
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
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (only used if using stripe)
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
     * @param cont                              contact record that is the payer
     * @param apiKeyName                        api key for the transaction token, used by Stripe
     *
     * @return PaymentResponseWrapper
     */
    public virtual PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createSubscriptionWithResponseWrapper(Map<String, Object> params) {
        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper paymentResponseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
        if (params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY) != null && (String)params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY) == PORTAL_CONST_OnlineGiving.RECURRING_TYPE) {
            reviewTransaction.ucinn_ascendv2__Opportunity_End_Date__c = (Date)params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY);
        }
        params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY, reviewTransaction);
        
        // createSubscription will populate fields on the RTv2
        paymentResponseWrapper.transactionId = createSubscription(params);

        paymentResponseWrapper.reviewTransactionFieldMap = reviewTransaction.getPopulatedFieldsAsMap();

        return paymentResponseWrapper;
    }

    /**
     * Retrieves the external gateway public api key
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param customMetadataName:       the name of the custom metadata that stores the public key for stripe
     *
     * @return                          the public key to initialize the credit card form to the correct account
     */
    public abstract String getPublicApiKey(Map<String, Object> params); //TODO move these params out too

    /**
     * Creates a payment method for the given wallet type.
     * 
     * @author Aaron Wong
     * 
     * @param walletName    The name of the wallet type.
     * @param walletToken   The tokenized payment method from the wallet.
     * @return              The payment method identifier for the payment service provider.
     * @since               1.0
     */
    public abstract String createWalletPaymentMethod(WalletType walletType, String walletToken);
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
    public abstract String updateSubscriptionCreditCard(Map<String, Object> params);

    /**
     * Return the last 4 digits of the credit card used for all of a user's subscription gifts
     * 
     * @author Jacob Huang
     * 
     * @param cont                          Contact: contact for logged in user
     * @param creditCardIdList              List<String>: payment or subscription (depends on payment method) IDs to get last 4 credit card digits for
     * @param externalPaymentGatewayIdList  List<String>: list of external payment gateway IDs, length/ordering corresponds to creditCardIdList
     * 
     * @return                              map of string ID to string of last 4 credit card digits 
     */
    public abstract Map<String, String> getCreditCardIdToLastFourDigitsMap(Map<String, Object> params);

    /**
     * Cancel a constituent's existing subscription-based gift (pledge or recurring gift) through a payment processor
     * 
     * @author Jacob Huang
     * 
     * @param paymentMethod             String: payment processor used (Stripe, Spreedly, Cybersource)
     * @param giftType                  String: 'pledge' or 'recurring'
     * @param subscriptionId            String: external ID for the gift's associated subscription (Stripe, Cybersource)
     * @param externalPaymentGatewayId  String: merchant reference code of initial subscription transaction (Cybersource)
     */
    public abstract void cancelSubscription(Map<String, Object> params);

            
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
    public abstract String getReviewTransactionTenderType(Map<Object, Object> additionalPaymentDataMap);
}