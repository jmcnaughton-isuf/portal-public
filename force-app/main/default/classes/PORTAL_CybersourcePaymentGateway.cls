public without sharing virtual class PORTAL_CybersourcePaymentGateway extends PORTAL_PaymentGateway {
    public static final String DEVELOPER_NAME_KEY = 'DeveloperName';
    public static final String PUBLIC_API_KEY_DEVELOPER_NAME = 'Cybersource_Public_Key';
    public static final String SECRET_API_KEY_DEVELOPER_NAME = 'Cybersource_Secret_Key';
    public static final String HOST_DEVELOPER_NAME = 'Cybersource_Host_URL';
    public static final String MERCHANT_ID_DEVELOPER_NAME = 'Cybersource_Merchant_Id';
    public static final String AUTHORIZATION_AMOUNT_DEVELOPER_NAME = 'Cybersource_Authorization_Amount';
    public static final String WALLET_TYPE = 'walletType';

    public static final String GENERIC_CYBERSOURCE_METADATA_ERROR = 'Error with Cybersource custom metadata.';
    public static final String GENERIC_CALLOUT_ERROR = 'Please recheck your payment information.';
    public static final String UPDATE_SUBSCRIPTION_ERROR = 'Update subscription error: merchant reference code, subscription ID, or JWT not found';
    public static final String RETRIEVE_SUBSCRIPTION_ERROR = 'Retrieve subscription error: merchant reference code or subscription ID not found';

    public static final String CAPTURE_CONTEXT_REQUEST_TARGET = '/flex/v1/keys?format=JWT';
    public static final String PAYMENT_TARGET = '/pts/v2/payments';

    public static final String AUTHORIZED_STATUS = 'AUTHORIZED';
    public static final String PENDING_STATUS = 'PENDING';
    public static final String APPLE_PAY_DESCRIPTOR = 'RklEPUNPTU1PTi5BUFBMRS5JTkFQUC5QQVlNRU5U';

    // JWT payload keys
    public static final String JWT_DATA_KEY = 'data';
    public static final String JWT_CREDIT_CARD_NUMBER_KEY = 'number';
    public static final String JWT_JTI_KEY = 'jti';

    // ascend param map keys
    public static final String ASCEND_PAYMENT_GATEWAY_SETTING_KEY = 'paymentGatewaySetting';
    public static final String ASCEND_PLEDGE_RECORD_KEY = 'pledgeRec';
    public static final String ASCEND_GIFT_RECORD_KEY = 'giftRec';

    //Named Credential shared with base ascend for the SOAP password, username and URL
    public static final String SOAP_CREDENTIAL = 'callout:CyberSource';
    public static final String WSDL_VERSION = '1.191'; 
    public static final String XML_VERSION = '<?xml version="1.0" encoding="UTF-8"?>';
    public static final String SOAP_ENVELOPE_OPEN = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">';
    public static final String SOAP_ENVELOPE_CLOSE = '</soapenv:Envelope>';
    public static final String SOAP_ENVELOPE_HEADER =         
        '<soapenv:Header>' +
        '<wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' +
            '<wsse:UsernameToken>' +
                '<wsse:Username>' + '{!$Credential.UserName}' + '</wsse:Username>' +
                '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + '{!$Credential.Password}' + '</wsse:Password>' +
            '</wsse:UsernameToken>' +
        '</wsse:Security>' +
        '</soapenv:Header>';

    public static final String FIRST_NAME_KEY = 'firstName';
    public static final String LAST_NAME_KEY = 'lastName';
    public static final String EMAIL_KEY = 'email';
    public static final String ADDRESS_KEY = 'address';
    public static final String ADDRESS_LINE1_KEY = 'line1';
    public static final String ADDRESS_LINE2_KEY = 'line2';
    public static final String CITY_KEY = 'city';
    public static final String STATE_KEY = 'state';
    public static final String POSTAL_CODE_KEY = 'postal_code';
    public static final String COUNTRY_KEY = 'country';

    // node names in XML responses
    public static final String REPLY_MESSAGE_NODE = 'replyMessage';
    public static final String BODY_NODE = 'Body';
    public static final String SUBSCRIPTION_CREATE_NODE = 'paySubscriptionCreateReply';
    public static final String SUBSCRIPTION_RETRIEVE_NODE = 'paySubscriptionRetrieveReply';
    public static final String SUBSCRIPTION_ID_NODE = 'subscriptionID';
    public static final String CARD_NUMBER_NODE = 'cardAccountNumber';
    public static final String REASON_CODE_NODE = 'reasonCode';
    public static final String REASON_CODE_SUCCESS = '100';
    public static final String REASON_CODE_INVALID_FIELD = '102';
    public static final String DECISION_NODE = 'decision';
    public static final String DECISION_ACCEPT = 'ACCEPT';

    //cybersource has specific lowercase versions of frequencies, so we map our versions to those
    public static final Map<String, String> frequencyMap = new Map<String, String> { 'Weekly' => 'weekly',
                                                                                    'Bi-Weekly' => 'bi-weekly',
                                                                                    'Quad-Weekly' => 'quad-weekly',
                                                                                    'Monthly' => 'monthly',
                                                                                    'Semi-Monthly' => 'semi-monthly',
                                                                                    'Quarterly' => 'quarterly',
                                                                                    'Semi-Annual' => 'semi-annually',
                                                                                    'Annual' => 'annually' };

    private static final Map<String, WalletType> WALLET_NAME_TO_TYPE_MAP = new Map<String, WalletType>{'googlePay' => WalletType.GooglePay,
                                                                                                       'applePay' => WalletType.ApplePay};
    private static final Map<WalletType, String> WALLET_TYPE_TO_PAYMENT_SOLUTION = new Map<WalletType, String>{WalletType.GooglePay => '012',
                                                                                                               WalletType.ApplePay => '001'};
    private WalletType walletType;
    private Boolean isAchPayment = false;

    public PORTAL_CybersourcePaymentGateway() { }

    public enum contentType {
        XML,
        JSON
    }

    /**
     * gets REST public api key from cybersource
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     *
     * @return cybersource REST public api key
     */
    public override String getPublicApiKey(Map<String, Object> params) {

        String publicKey = PORTAL_Utils.getSecureMetadata(PUBLIC_API_KEY_DEVELOPER_NAME);

        if (String.isBlank(publicKey)) {
            if(Test.isRunningTest()) {
                return 'publicKey';
            }
            throw new AuraHandledException(GENERIC_CYBERSOURCE_METADATA_ERROR);
        }

        return publicKey;
    }

    /**
     * collects and returns the host domain currently in use from the custom metadata
     * This will determine whether it is a test transaction or a live transaction
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     *
     * @return                          The host domain. will be either apitest.cybersource.com or api.cybersource.com
     *
     */
    protected virtual String getHost() {
        String host = PORTAL_Utils.getSecureMetadata(HOST_DEVELOPER_NAME);

        if (host != 'apitest.cybersource.com' && host != 'api.cybersource.com') {
            if(Test.isRunningTest()) {
                return 'apitest.cybersource.com';
            }
            throw new AuraHandledException(GENERIC_CYBERSOURCE_METADATA_ERROR);
        }

        return host;
    }

    /**
     * private function, collects cybersource REST secret api key
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     *
     * @return Cybersource REST secret api key
     */
    protected virtual String getSecretApiKey() {
        String secretKey = PORTAL_Utils.getSecureMetadata(SECRET_API_KEY_DEVELOPER_NAME);

        if (String.isBlank(secretKey)) {
            if(Test.isRunningTest()) {
                return 'testKey';
            }
            throw new AuraHandledException(GENERIC_CYBERSOURCE_METADATA_ERROR);
        }

        return secretKey;
    }

    /**
     * collects CyberSource merchant Id from custom metadata
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     *
     * @return Cybersource merchant Id
     */
    public virtual String getMerchantId() {
        String merchantId = PORTAL_Utils.getSecureMetadata(MERCHANT_ID_DEVELOPER_NAME);

        if (String.isBlank(merchantId)) {
            if(Test.isRunningTest()) {
                return 'merchantId';
            }
            throw new AuraHandledException(GENERIC_CYBERSOURCE_METADATA_ERROR);
        }

        return merchantId;
    }

    /**
     * collects authorization amount from organization custom metadata
     * This value is the amount that constituent is charged for creating a plege / recurring gift
     *
     * @author:                     Sam Longo
     * @since                       1.0
     *
     * @return Authorization amount
     */
    public virtual Decimal getAuthorizationAmount() {
        String authAmount = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => AUTHORIZATION_AMOUNT_DEVELOPER_NAME});

        if (String.isBlank(authAmount)) {
            if(Test.isRunningTest()) {
                return 1.00;
            }
            throw new AuraHandledException(GENERIC_CYBERSOURCE_METADATA_ERROR);
        }

        return Decimal.valueOf(authAmount).setScale(2);
    }

    /**
     * Creates an automatic subscription in cybersource, and fills out the relevant rtv2 fields
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentId                         The payment token to charge against.
     * @param amount                            The amount to charge the card in USD
     * @param reviewTransaction                 The review transaction record to edit additional fields on
     * @param numberOfInstallments              number of installments for a pledge
     * @param giftType                          Type of gift being created, used for differentiating logic between installment based pledges and recurring gifts
     * @param frequency                         frequency of payments string
     * @param startDate                         Date object for when the first payment should occur, if blank, will default to today
     * @param endDate                           Optional: the last day for a payment if it is a recurring gift
     * @param stripeBillingInformation          Formatted billing information JSON
     *
     *
     * @return unique Transaction Id
     */
    public override String createSubscription(Map<String, Object> params) {
        //TODO: add a one time charge for a pledge with remainder
        String paymentAmount = String.valueOf(params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY));
        String tokenizedCard = (String) params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY); //FUTURE TODO verify JWT token signature w/public and private key
        String installmentsString = String.valueOf(params.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY));
        Map<Object, Object> additionalPaymentDataMap = (Map<Object, Object>) params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS);
        this.setWalletType((String)additionalPaymentDataMap?.get(WALLET_TYPE));
        this.isAchPayment = additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PORTAL_CONST_OnlineGiving.ACH_CONST;

        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = (ucinn_ascendv2__Review_Transaction_v2__c) params.get(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY);

        String paymentToken = (this.walletType == null && this.isAchPayment == false) ? getJtiToken(tokenizedCard) : tokenizedCard;

        String giftType = (String) params.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);

        String frequency = (String) params.get(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY);
        String correctedFrequency = frequencyMap.get(frequency);

        Map<String, Object> formattedBillingInformation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY)));

        Date startDate = Date.today();
        if (params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)))) {
            startDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
        }

        Date endDate = (Date) params?.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY);
        
        //convert date format to yyyyMMdd
        String month = String.valueOf(startDate.month()).leftPad(2,'0');
        String day = String.valueOf(startDate.day()).leftPad(2,'0');
        String correctedStartDate = startDate.year() + month + day;

        String billTo = createBillingString(formattedBillingInformation, contentType.XML);

        String merchantReferenceCode = String.valueOf(DateTime.now().getTime()) + Crypto.getRandomInteger();

        String body = '';

        if (giftType.equalsIgnoreCase(PORTAL_CONST_OnlineGiving.RECURRING_TYPE) || giftType.equalsIgnoreCase(PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE)) {
            String recurringPaymentsString = String.valueOf(PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));
            body = createRecurringBody(billTo, paymentAmount, correctedFrequency, recurringPaymentsString, correctedStartDate, paymentToken, merchantReferenceCode, additionalPaymentDataMap);
        } else {
            body = createPledgeBody(billTo, paymentAmount, correctedFrequency, installmentsString, correctedStartDate, paymentToken, merchantReferenceCode, additionalPaymentDataMap);
        }

        HttpResponse response = executeSOAPRequest(PAYMENT_TARGET, body);
        if (isSOAPSuccess(response) != true) {
            String reasonCode = parseSOAPResponse(response, new List<String>{REPLY_MESSAGE_NODE, REASON_CODE_NODE});
            String additionalReason = (reasonCode == REASON_CODE_INVALID_FIELD && endDate != null) ? '. Make sure the end date is not more than 5 years in the future.' : '';
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Failed to make gift. Error code ' + reasonCode + additionalReason});
        }
        String subscriptionId = parseSOAPResponse(response, new List<String>{REPLY_MESSAGE_NODE, SUBSCRIPTION_CREATE_NODE, SUBSCRIPTION_ID_NODE});

        reviewTransaction.ucinn_ascendv2__External_Payment_Gateway_ID__c = merchantReferenceCode;
        reviewTransaction.ucinn_portal_Payment_Gateway_Type__c = PORTAL_CONST_OnlineGiving.CYBERSOURCE_PAYMENT_METHOD_NAME;
        reviewTransaction.ucinn_ascendv2__Subscription_ID__c = subscriptionId;

        return subscriptionId;
    }

    /**
     * Decode a JWT and return its JTI identifier
     * 
     * @author Sam Longo, turned into helper method by Jacob Huang
     * 
     * @param JWT       JSON web token from frontend aka tokenized credit card info
     * 
     * @return          jti (token ID) obtained from the payload section of the JWT
     */ 
    public virtual String getJtiToken(String jwt) {
        // FUTURE TODO verify JWT token signature w/public and private key
        String payload = jwt.substring(jwt.indexOf('.') + 1, jwt.lastIndexOf('.'));
        String jsonPayload = EncodingUtil.base64Decode(payload).toString();
        String jtiToken = (String)((Map<String, Object>)JSON.deserializeUntyped(jsonPayload)).get(JWT_JTI_KEY);
        return jtiToken;
    }

    /**
     * Decode a JWT and return the last 4 digits of the credit card
     * 
     * @author Jacob Huang
     * 
     * @param JWT       JSON web token from frontend aka tokenized credit card info
     * 
     * @return          last 4 credit card digits
     */ 
    public virtual String getLastFourDigitsFromJWT(String jwt) {
        String payload = jwt.substring(jwt.indexOf('.') + 1, jwt.lastIndexOf('.'));
        String jsonPayload = EncodingUtil.base64Decode(payload).toString();
        Map<String, Object> creditCardMap = (Map<String, Object>)((Map<String, Object>)JSON.deserializeUntyped(jsonPayload)).get(JWT_DATA_KEY);
        String creditCardNumber = (String) creditCardMap.get(JWT_CREDIT_CARD_NUMBER_KEY);
        return creditCardNumber.right(4);
    }

    /**
     * creates and adds header fields to Cybersource callout as well as encrypting a signature for the header
     * prerequsite that the body string for the request is finalized
     */
    protected virtual void setHeaderAndSignature(HttpRequest request, String requestTarget) {
        String host = getHost();
        String merchantId = getMerchantId();
        String secretKey = getSecretApiKey();
        String publicKey = getPublicApiKey(new Map<String, Object>());

        //RFC1123 format for date
        String rfcDate = String.valueOf(Datetime.now().format('EEE, dd MMM yyyy HH:mm:ss z'));

        request.setHeader('host', host);
        request.setHeader('v-c-date', rfcDate);
        String digest = EncodingUtil.base64Encode(Crypto.generateDigest('SHA-256', Blob.valueOf(request.getBody())));
        String digestString = 'SHA-256=' + digest;
        request.setHeader('digest', digestString);
        request.setHeader('v-c-merchant-id', merchantId);

        String signatureString =  'host: '+ host +'\n' +
            '(request-target): post ' + requestTarget +'\n' +
            'digest: ' + digestString + '\n' +
            'v-c-merchant-id: ' + merchantId;

        Blob signatureStringBlob = Blob.valueOf(signatureString);
        Blob decodedBase64Secret = EncodingUtil.base64Decode(secretKey);
        Blob hmacData = Crypto.generateMac('HmacSHA256', signatureStringBlob, decodedBase64Secret);
        String base64SignatureString = EncodingUtil.base64Encode(hmacData);


        String outerSignatureString =   'keyid="' + publicKey + '",' +
            'algorithm="HmacSHA256",' +
            'headers="host (request-target) digest v-c-merchant-id",' +
            'signature="' + base64SignatureString + '"';
        request.setHeader('signature', outerSignatureString);
    }

    /**
     * Complete the SOAP XML body string by wrapping the SOAP Envelope header and body in the envelope and attaching the XML version string
     * 
     * @author Jacob Huang
     * 
     * @param envelopeBody      SOAP envelope body
     * 
     * @return full XML body/SOAP envelope string for SOAP API
     */
    public virtual String createSOAPBody(String envelopeBody) {
        return  XML_VERSION + 
                SOAP_ENVELOPE_OPEN + 
                    SOAP_ENVELOPE_HEADER + 
                    envelopeBody + 
                SOAP_ENVELOPE_CLOSE;
    }

    /**
     * Create a installment based pledge creation body. 
     * 
     * Note from Jacob for future devs working on this: a very very useful resource is 
     * https://ics2ws.ic3.com/commerce/1.x/transactionProcessor/ and specifically something like 
     * https://ics2ws.ic3.com/commerce/1.x/transactionProcessor/CyberSourceTransaction_1.191.xsd
     * which will specify the correct order for child elements of <RequestMessage> and available children/arguments
     * for elements in general
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param billTo                            String: billing information XML string with name, address, email
     * @param paymentAmount                     Stringified Decimal for payment amount
     * @param frequency                         frequency of payments precondition that it is formatted to Cybersource's lowercase frequency strings
     * @param numOfInstallments                 Number of installments for the pledge
     * @param startDate                         start date for first installment. must be formatted into yyyyMMdd
     * @param paymentToken                      Payment Token to use for the recurring payment
     * @param merchantReferenceCode             maximum 50 character unique string to allow for base Ascend to identify which payments correspond to which pledge/recurring gifts
     * @param additionalPaymentDataMap          Map<Object, Object>: map with data for ACH
     * 
     * @return XML string for pledge creation request body
     */
    protected virtual string createPledgeBody(String billTo, 
                                              String paymentAmount, 
                                              String frequency, 
                                              String numOfInstallments, 
                                              String startDate, 
                                              String paymentToken, 
                                              String merchantReferenceCode,
                                              Map<Object, Object> additionalPaymentDataMap) {
        String merchantId = getMerchantId();

        Decimal amount = Decimal.valueOf(paymentAmount);
        Decimal installments = Decimal.valueOf(numOfInstallments);
        Decimal pledgeAmountDecimal = (amount / installments).setScale(2, RoundingMode.DOWN);
        String pledgeAmount = String.valueOf(pledgeAmountDecimal);
        
        Decimal firstPaymentAddition = 0;
        if (pledgeAmountDecimal * installments != amount) {
            firstPaymentAddition = Math.abs(amount - (pledgeAmountDecimal * installments));
        }

        Decimal authAmountDecimal = firstPaymentAddition > 0 ? firstPaymentAddition : getAuthorizationAmount();
        String authAmount = String.valueOf(authAmountDecimal);
        String paymentMethodXML = this.createPaymentMethodXML(paymentToken, additionalPaymentDataMap);

        Boolean hasCcAuthService = this.isAchPayment != true;
        Boolean hasEcDebitService = this.isAchPayment == true && authAmountDecimal != 0;
        Boolean hasCcCaptureService = this.isAchPayment != true && firstPaymentAddition > 0;

        String envelopeBody = 
                    '<soapenv:Body>' +
                        '<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-' + WSDL_VERSION + '">' +
                            '<merchantID>' + merchantId + '</merchantID>' +
                            '<merchantReferenceCode>' + merchantReferenceCode + '</merchantReferenceCode>' +
                            billTo +
                            '<purchaseTotals>' +
                                '<currency>' + 'USD' + '</currency>' +
                                '<grandTotalAmount>' + authAmount + '</grandTotalAmount>' + // credit card amount authorized on subscription creation, sometimes captured (if pledge has remainder, the remainder will be captured); or ACH setup fee
                            '</purchaseTotals>' +
                            ((this.walletType != null || this.isAchPayment == true) ? paymentMethodXML : '') + // <encryptedPayment> if walletType, <check> and <subscription> if ACH
                            '<recurringSubscriptionInfo>' +
                                '<amount>' + pledgeAmount + '</amount>' +
                                '<numberOfPayments>' + numOfInstallments + '</numberOfPayments>' +
                                '<automaticRenew>' + 'false' + '</automaticRenew>' +
                                '<frequency>' + frequency + '</frequency>' +
                                '<startDate>' + startDate + '</startDate>' +
                            '</recurringSubscriptionInfo>' +
                            ((this.walletType == null && this.isAchPayment != true) ? paymentMethodXML : '') + // <tokenSource>

                            '<ccAuthService run="' + hasCcAuthService + '">' +
                                '<commerceIndicator>' + 'recurring' + '</commerceIndicator>' +
                            '</ccAuthService>' +

                            '<ccCaptureService run="' + hasCcCaptureService + '" />' +

                            '<ecDebitService run="' + hasEcDebitService + '">' +
                                '<verificationLevel>' + getVerificationLevel() + '</verificationLevel>' +
                                '<commerceIndicator>' + 'recurring' + '</commerceIndicator>' +
                            '</ecDebitService>' +

                            '<paySubscriptionCreateService run=' + '"true"' + '>' +
                                '<disableAutoAuth>' + 'false' + '</disableAutoAuth>' +
                            '</paySubscriptionCreateService>' +
                            (this.walletType != null ? '<paymentSolution>' + WALLET_TYPE_TO_PAYMENT_SOLUTION.get(this.walletType) + '</paymentSolution>' : '') +
                        '</requestMessage>' +
                    '</soapenv:Body>';

        return createSOAPBody(envelopeBody);
    }

    /**
     * Create a installment based pledge creation body
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param billTo                            String: billing information XML string with name, address, email
     * @param paymentAmount                     Stringified Decimal for payment amount
     * @param frequency                         frequency of payments precondition that it is formatted to Cybersource's lowercase frequency strings
     * @param numberOfPayments                  Optional: string of an integer for recurring gifts with an end date, otherwise null
     * @param startDate                         start date for first installment. must be formatted into yyyyMMdd
     * @param paymentToken                      Payment Token to use for the recurring payment
     * @param merchantReferenceCode             maximum 50 character unique string to allow for base Ascend to identify which payments correspond to which pledge/recurring gifts
     * @param additionalPaymentDataMap          Map<Object, Object>: map with data for ACH
     *
     * @return XML string for pledge creation request body
     */
    protected virtual string createRecurringBody(String billTo, 
                                                 String paymentAmount, 
                                                 String frequency, 
                                                 String numberOfPayments, 
                                                 String startDate, 
                                                 String paymentToken, 
                                                 String merchantReferenceCode,
                                                 Map<Object, Object> additionalPaymentDataMap) {
        String merchantId = getMerchantId();

        Decimal authAmountDecimal = getAuthorizationAmount();
        String authAmount = String.valueOf(authAmountDecimal);
        String paymentMethodXML = this.createPaymentMethodXML(paymentToken, additionalPaymentDataMap);

        Boolean hasCcAuthService = this.isAchPayment != true;
        Boolean hasEcDebitService = this.isAchPayment == true && authAmountDecimal != 0;

        string envelopeBody = 
                    '<soapenv:Body>' +
                        '<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-' + WSDL_VERSION + '">' +
                            '<merchantID>' + merchantId + '</merchantID>' +
                            '<merchantReferenceCode>' + merchantReferenceCode + '</merchantReferenceCode>' +
                            billTo +
                            '<purchaseTotals>' +
                                '<currency>' + 'USD' + '</currency>' +
                                '<grandTotalAmount>' + authAmount + '</grandTotalAmount>' + // credit card authorization amount or ACH setup fee
                            '</purchaseTotals>' +
                            ((this.walletType != null || this.isAchPayment == true) ? paymentMethodXML : '') + // <encryptedPayment> if walletType, <check> and <subscription> if ACH
                            '<recurringSubscriptionInfo>' +
                                '<amount>' + paymentAmount + '</amount>' +
                                (numberOfPayments != null ? '<numberOfPayments>' + numberOfPayments + '</numberOfPayments>' : '') +
                                '<automaticRenew>' + 'false' + '</automaticRenew>' +
                                '<frequency>' + frequency + '</frequency>' +
                                '<startDate>' + startDate + '</startDate>' +
                            '</recurringSubscriptionInfo>' +
                            ((this.walletType == null && this.isAchPayment != true) ? paymentMethodXML : '') + // <tokenSource>

                            '<ccAuthService run="' + hasCcAuthService + '">' +
                                '<commerceIndicator>' + 'recurring' + '</commerceIndicator>' +
                            '</ccAuthService>' +

                            '<ecDebitService run="' + hasEcDebitService + '">' +
                                '<verificationLevel>' + getVerificationLevel() + '</verificationLevel>' +
                                '<commerceIndicator>' + 'recurring' + '</commerceIndicator>' +
                            '</ecDebitService>' +

                            '<paySubscriptionCreateService run=' + '"true"' + '>' +
                                '<disableAutoAuth>' + 'false' + '</disableAutoAuth>' +
                            '</paySubscriptionCreateService>' +
                            (this.walletType != null ? '<paymentSolution>' + WALLET_TYPE_TO_PAYMENT_SOLUTION.get(this.walletType) + '</paymentSolution>' : '') +
                        '</requestMessage>' +
                    '</soapenv:Body>';

        return createSOAPBody(envelopeBody);
    }

    /**
     * Creates the subscription payment method XML of the SOAP callout for cybersource.
     * 
     * @author Aaron Wong
     * 
     * @param paymentToken              String: Payment Token to use for the payment
     * @param additionalPaymentDataMap  Map<Object, Object>: map with data for ACH
     * 
     * @return                  Payment Method XML.
     * @since                   1.0
     */
    protected virtual String createPaymentMethodXML(String paymentToken, Map<Object, Object> additionalPaymentDataMap) {
        if (String.isBlank(paymentToken)) {
            return '';
        }

        if (this.isAchPayment == true) {
            String fullName = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.FULL_NAME);
            String bankAccountNumber = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_NUMBER);
            String bankAccountType = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_TYPE);
            String bankRoutingNumber = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BANK_ROUTING_NUMBER);

            return '<check>' +
                        '<fullName>' + fullName + '</fullName>' +
                        '<accountNumber>' + bankAccountNumber + '</accountNumber>' + 
                        '<accountType>' + bankAccountType + '</accountType>' +
                        '<bankTransitNumber>' + bankRoutingNumber + '</bankTransitNumber>' +
                    '</check>' +
                    '<subscription>' +
                        '<paymentMethod>check</paymentMethod>' +
                    '</subscription>';

        } else if (this.walletType == null) {
            return '<tokenSource>' +
                       '<transientToken>' + paymentToken + '</transientToken>' +
                   '</tokenSource>';
        } 

        return '<encryptedPayment>' + 
                   (this.walletType == PORTAL_PaymentGateway.WalletType.ApplePay ? '<descriptor>' + APPLE_PAY_DESCRIPTOR + '</descriptor>' : '') +
                   '<data>' + paymentToken + '</data>' +
               '</encryptedPayment>'; 

    }

    /**
     * takes in the formattedBillingInformation provided from the frontend and converts it into a callout compatible format
     * either in JSON or XML, returns a blank string if formatted billing information is not provided under the assumption that AVS is turned off
     * note ACH payments require address line 1, city, country, email, and last name independent of AVS
     *
     * @param formattedBillingInformation           map<Object, Object> for the billing information if not null must have firstName, lastName, email, and a sub map address that contains line1, city, state, postal_code, country; line2 is optional
     * @param chosenFormat                          contentType enum that determines to format into JSON or XML
     *
     * @return billTo string for api callout
     */
    public virtual String createBillingString(Map<String, Object> formattedBillingInformation, contentType chosenFormat) {

        String billTo = '';

        if (formattedBillingInformation != null) {
            String firstName = String.valueOf(formattedBillingInformation.get(FIRST_NAME_KEY));
            String lastName = String.valueOf(formattedBillingInformation.get(LAST_NAME_KEY));
            String email = String.valueOf(formattedBillingInformation.get(EMAIL_KEY));

            Map<String, Object> addressInfo = (Map<String, Object>) (formattedBillingInformation.get(ADDRESS_KEY));
            if (addressInfo != null) {
                String addressLine1 = String.valueOf(addressInfo.get(ADDRESS_LINE1_KEY));
                String addressLine2 = addressInfo.get(ADDRESS_LINE2_KEY) != null ? String.valueOf(addressInfo.get(ADDRESS_LINE2_KEY)) : '';
                String city = String.valueOf(addressInfo.get(CITY_KEY));
                String state = String.valueOf(addressInfo.get(STATE_KEY));
                String postalCode = String.valueOf(addressInfo.get(POSTAL_CODE_KEY));
                // Cybersource documentation says this must be a 2 letter country code, but that's not the whole truth. Fully spelled out country names can work too.
                String countryCode = String.valueOf(addressInfo.get(COUNTRY_KEY));

                if(chosenFormat.equals(contentType.XML)) {
                    billTo = '<billTo>' +
                                    '<firstName>{0}</firstName>' +
                                    '<lastName>{1}</lastName>' +
                                    '<street1>{2}</street1>' +
                                    '<street2>{3}</street2>' +
                                    '<city>{4}</city>' +
                                    '<state>{5}</state>' +
                                    '<postalCode>{6}</postalCode>' +
                                    '<country>{7}</country>' +
                                    '<email>{8}</email>' +
                            '</billTo>';
                    billTo = String.format(billTo,new List<Object> {firstName, lastName, addressLine1, addressLine2, city, state, postalCode, countryCode, email});
                } else if (chosenFormat.equals(contentType.JSON)) {
                    billTo = '"billTo": \'{\'"firstName": "{0}", "lastName": "{1}", "address1": "{2}", "address2": "{3}", "locality": "{4}", "administrativeArea": "{5}", "postalCode": "{6}", "country": "{7}", "email": "{8}"\'}\',';
                    billTo = String.format(billTo,new List<Object> {firstName, lastName, addressLine1, addressLine2, city, state, postalCode, countryCode, email});
                }

            }
        }

        return billTo;
    }

    /**
     * Create the XML body for a callout to retrieve the specified subscription object
     * 
     * @author Jacob Huang
     * 
     * @param subscriptionId            String subscription ID to query Cybersouce for
     * @param merchantReferenceCode     String merchant reference code for the subscription, stored in Opportunity External Payment Gateway ID
     * 
     * @return          XML body string
     */
    public virtual String createRetrieveSubscriptionBody(String subscriptionId, String merchantReferenceCode) {
        if (String.isBlank(subscriptionId) || String.isBlank(merchantReferenceCode)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => RETRIEVE_SUBSCRIPTION_ERROR
            });
        }

        String merchantId = getMerchantId();

        String envelopeBody = 
            '<soapenv:Body>' +
                '<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-' + WSDL_VERSION + '">' +
                    '<merchantID>' + merchantId + '</merchantID>' +
                    '<merchantReferenceCode>' + merchantReferenceCode + '</merchantReferenceCode>' +
                    '<recurringSubscriptionInfo>' +
                        '<subscriptionID>' + subscriptionId + '</subscriptionID>' +
                    '</recurringSubscriptionInfo>' +
                    '<paySubscriptionRetrieveService run="true"/>' +
                '</requestMessage>' +
            '</soapenv:Body>';

        return createSOAPBody(envelopeBody);
    }

    /** 
     * Create the XML body for a callout to update a subscription's payment method
     * 
     * @author Jacob Huang
     * 
     * @param subscriptionId            String subscription ID for the Cybersource subscription to update
     * @param merchantReferenceCode     String merchant reference code for the subscription, stored in Opportunity External Payment Gateway ID
     * @param jtiToken                  String new jti token passed from the frontend representing the new payment method
     * 
     * @return      XML body string
     */
    public virtual String createUpdateSubscriptionPaymentBody(String subscriptionId, String merchantReferenceCode, String jtiToken) {
        String merchantId = getMerchantId();
        String authAmount = String.valueOf(getAuthorizationAmount());

        String envelopeBody = 
            '<soapenv:Body>' +
                '<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-' + WSDL_VERSION + '">' +
                    '<merchantID>' + merchantId + '</merchantID>' +
                    '<merchantReferenceCode>' + merchantReferenceCode + '</merchantReferenceCode>' +
                    '<purchaseTotals>' +
                        '<currency>' + 'USD' + '</currency>' +
                        '<grandTotalAmount>' + authAmount + '</grandTotalAmount>' +
                    '</purchaseTotals>' +
                    '<recurringSubscriptionInfo>' +
                        '<subscriptionID>' + subscriptionId + '</subscriptionID>' + 
                    '</recurringSubscriptionInfo>' +
                    '<tokenSource>' +
                        '<transientToken>' + jtiToken + '</transientToken>' +
                    '</tokenSource>' +
                    '<ccAuthService run="true">' +
                        '<commerceIndicator>' + 'recurring' + '</commerceIndicator>' +
                    '</ccAuthService>' +
                    '<paySubscriptionUpdateService run="true"/>' +
                '</requestMessage>' +
            '</soapenv:Body>';

        return createSOAPBody(envelopeBody);
    }

    /**
     * Create the XML body for a callout to cancel a subscription
     * Leverage existing ascend code to build the String
     * 
     * @author Jacob Huang
     * 
     * @param giftType                  String: 'pledge' or 'recurring'
     * @param subscriptionId            String: external ID for the gift's associated subscription
     * @param externalPaymentGatewayId  String: merchant reference code of initial subscription transaction 
     * 
     * @return          XML body String
     */
    public virtual String createCancelSubscriptionBody(String giftType, String subscriptionId, String externalPaymentGatewayId) {
        Map<String, Object> cyberSourceParams = new Map<String, Object>();
        // Portal either hard codes these values or gets them from Portal Secure Organization Settings
        ucinn_ascendv2__Gift_Processing_External_Pymnt_Gateways__mdt paymentGatewaySetting = new ucinn_ascendv2__Gift_Processing_External_Pymnt_Gateways__mdt(
            ucinn_ascendv2__Merchant_ID__c = getMerchantId(),
            ucinn_ascendv2__WSDL_Version__c = WSDL_VERSION,
            ucinn_ascendv2__Gateway_Named_Credential_Name__c = SOAP_CREDENTIAL.split(':')[1]
        );
        Opportunity gift = new Opportunity(ucinn_ascendv2__External_Payment_Gateway_ID__c = externalPaymentGatewayId, ucinn_ascendv2__Subscription_ID__c = subscriptionId);
        cyberSourceParams.put(ASCEND_PAYMENT_GATEWAY_SETTING_KEY, paymentGatewaySetting);
        cyberSourceParams.put(giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE ? ASCEND_PLEDGE_RECORD_KEY : ASCEND_GIFT_RECORD_KEY, gift);
        ucinn_ascendv2.ascend_GIFT_ExternalPaymentCyberSource.params = cyberSourceParams;

        ucinn_ascendv2.ascend_GIFT_ExternalPaymentRecurCancel xmlBodyConstructor = new ucinn_ascendv2.ascend_GIFT_ExternalPaymentRecurCancel();
        // xmlBodyConstructor.prepForCallout() would build the XML body but it's not global 
        // however, it's only 3 lines and its 4 constituent parts are global so it's not a big deal 
        xmlBodyConstructor.constructVarMap();
        ucinn_ascendv2.ascend_GIFT_ExternalPaymentCyberSource.processMissingOrNullFields(xmlBodyConstructor.requiredFieldMap);
        xmlBodyConstructor.constructRequestToPaymentGateway();

        return ucinn_ascendv2.ascend_GIFT_ExternalPaymentCyberSource.requestBody;
    }

    /**
     * Make the callout to Cybersource SOAP API
     * 
     * @author Sam Longo, turned into helper method by Jacob Huang
     * 
     * @param requestTarget     API endpoint
     * @param body              SOAP envelope body for the HTTP request
     * 
     * @return          HTTP response sent by Cybersource
     */ 
    public virtual HttpResponse executeSOAPRequest(String requestTarget, String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(SOAP_CREDENTIAL);
        request.setMethod('POST');
        request.setBody(body);
        setHeaderAndSignature(request, requestTarget);
        request.setHeader('Content-Type', 'text/xml; charset=utf-8');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_CALLOUT_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ' Request body: ' + body + ' Response status: ' + response.getStatusCode() + ' Response Body: ' + response.getBody()
            });
        }

        return response;
    }

    /**
     * Helper method to parse HTTP XML response body
     * 
     * @author Jacob Huang
     * 
     * @param response      HttpResponse sent by Cybersource SOAP Toolkit API
     * @param xmlPath       starting within <soap:Body>, the list of node names to follow to a single node 
     * 
     * @return              value of the node at the end of the xmlPath list
     */
    public String parseSOAPResponse(HttpResponse response, List<String> xmlPath) {
        DOM.Document doc = new DOM.Document();
        doc.load(response.getBody());
        DOM.XMLNode root = doc.getRootElement();
        DOM.XMLNode bodyNode = root.getChildElement(BODY_NODE, root.getNameSpace());
        return PORTAL_XmlParser.getXMLAttribute(xmlPath, bodyNode);
    }

    /**
     * Helper method to check success status of Cybersource XML response body
     * 
     * @author Jacob Huang
     * 
     * @param response      HttpResponse sent by Cybersource SOAP Toolkit API
     * 
     * @return              true if request was successful, else false
     */
    public Boolean isSOAPSuccess(HttpResponse response) {
        String reasonCode = parseSOAPResponse(response, new List<String>{REPLY_MESSAGE_NODE, REASON_CODE_NODE});
        String decision = parseSOAPResponse(response, new List<String>{REPLY_MESSAGE_NODE, DECISION_NODE});

        // reason code alone should be sufficient, but decision is extra insurance in case Cybersource ever changes their API
        return reasonCode.equals(REASON_CODE_SUCCESS) || decision.equals(DECISION_ACCEPT);
    }

    /**
     * This is used to take in the transaction params, and process a payment with cybersource and then return the transaction id
     *
     * @author:                         Sam Longo
     * @since:                          1.0
     *
     * @param paymentId                         JWT generated by the IFrame on the frontend corresponding to the credit card used
     * @param amount                            The amount to charge the card in USD
     * @param stripeBillingInformation          formatted map for billing information
     * @param additionalPaymentDataMap          Map<Object, Object>: may contain info about wallet type or bank account info for ACH
     *
     * @return unique Transaction Id
     */
    public override PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper createOneTimePayment(Map<String, Object> params) {
        String paymentAmount = String.valueOf(params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY));
        String tokenizedCard = (String) params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY); //FUTURE TODO verify JWT token signature w/public and private key
        Map<String, Object> formattedBillingInformation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY)));
        Map<Object, Object> additionalPaymentDataMap = (Map<Object, Object>) params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS);
        this.setWalletType((String)additionalPaymentDataMap?.get(WALLET_TYPE));
        this.isAchPayment = additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PORTAL_CONST_OnlineGiving.ACH_CONST;

        String requestTarget = PAYMENT_TARGET;
        String host = getHost();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://' + host + requestTarget);
        request.setMethod('POST');

        //FUTURE TODO: look into using clientReferenceInformation as part of this transaction so the transaction can be merchant defined and found later

        string billTo = createBillingString(formattedBillingInformation, contentType.JSON);

        String paymentMethodString = '"tokenInformation": {"transientTokenJwt": "'+ tokenizedCard +'"}';

        if (this.walletType != null) {
            paymentMethodString = '"paymentInformation": {"fluidData": {"value": "' + tokenizedCard + '"}}, "processingInformation": {"paymentSolution": "' + WALLET_TYPE_TO_PAYMENT_SOLUTION.get(this.walletType) + '"}';
        } else if (this.isAchPayment == true) {
            String bankAccountNumber = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_NUMBER);
            String bankRoutingNumber = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BANK_ROUTING_NUMBER);
            String bankAccountType = (String)additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_TYPE);
            paymentMethodString = '"paymentInformation": {"bank": {"account": {"type": "' + bankAccountType + '", "number": "' + bankAccountNumber + '"},"routingNumber": "' + bankRoutingNumber + '"}}';
            paymentMethodString += ', "processingInformation": {"bankTransferOptions": {"fraudScreeningLevel": "' + getVerificationLevel() + '"}}';
        }

        String body = '{' + paymentMethodString + ' ,"orderInformation" : { ' + billTo + '  "amountDetails" : {"totalAmount" : "' + paymentAmount + '", "currency" : "USD"}}}';
        request.setBody(body);

        setHeaderAndSignature(request, requestTarget);

        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);



        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_CALLOUT_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'responseJson: ' + response.getBody()
            });
        }

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

        String transactionId = (String)responseMap.get('id');
        String status = (String) responseMap.get('status');

        // Cybersource provides 0 documentation about what a successful ACH payment response looks like using their JSON REST API
        // from what I've seen, the status for success cases is PENDING, but I cannot say for certain that AUTHORIZED never appears
        if (String.isBlank(transactionId) == true || 
           (status.equalsIgnoreCase(AUTHORIZED_STATUS) || (this.isAchPayment == true && status.equalsIgnoreCase(PENDING_STATUS))) == false) {
            
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GENERIC_CALLOUT_ERROR,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'responseJson: ' + response.getBody()
            });
        }

        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        responseWrapper.transactionId = transactionId;

        return responseWrapper;
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
     * This is used to generate the JWT token for use by the microform on the frontend
     * allowing for the secure payment fields to be hosted by Cybersource for PCI compliance
     *
     * @author Sam Longo
     * @since: 1.0
     *
     * @return                          JWT token to pass to Cybersource's microform javascript component
     *
     */
    public virtual String getCaptureContext() {

        String host = getHost();
        String requestTarget = CAPTURE_CONTEXT_REQUEST_TARGET;
        String targetOrigin = PORTAL_CommunityUtils.getPortalURL().removeEnd('/'); //cybersource requires the target origin be http://domain.com without the / or any sub domains

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://' + host + requestTarget);
        request.setMethod('POST');

        String body = '{ "targetOrigin": "' + targetOrigin + '", "encryptionType": "RsaOaep"}';
        request.setBody(body);

        setHeaderAndSignature(request, requestTarget);

        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            System.debug('error code: ' + response.getStatusCode());
            System.debug('error: ' + response.getBody());
            throw new AuraHandledException('Error with Cybersource capture context. Error code: ' + response.getStatusCode());
        }

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return (String)result.get('keyId');
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
        String merchantReferenceCode = (String) params?.get(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY);
        String subscriptionId = (String) params?.get(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY);
        String jwt = (String) params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY);

        if (String.isBlank(merchantReferenceCode) || String.isBlank(subscriptionId) || String.isBlank(jwt)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => UPDATE_SUBSCRIPTION_ERROR
            });
        }

        String jtiToken = getJtiToken(jwt);
        String body = createUpdateSubscriptionPaymentBody(subscriptionId, merchantReferenceCode, jtiToken);

        HttpResponse response = executeSOAPRequest(PAYMENT_TARGET, body);

        if (isSOAPSuccess(response)) {
            return getLastFourDigitsFromJWT(jwt);
        }
        else {
            return null;
        }
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
        List<Object> subscriptionIdList = (List<Object>) params?.get(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY);
        List<Object> merchantReferenceCodeList = (List<Object>) params?.get(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_LIST_KEY);
        if (subscriptionIdList == null || subscriptionIdList.isEmpty()) {
            return returnMap;
        }

        for (Integer giftIndex = 0; giftIndex < subscriptionIdList.size(); ++giftIndex) {
            String subscriptionId = (String) subscriptionIdList[giftIndex];
            String merchantReferenceCode = (String) merchantReferenceCodeList[giftIndex];

            String creditCardDigits = getSingleCreditCardDigits(subscriptionId, merchantReferenceCode);
            if (String.isNotBlank(creditCardDigits)) {
                returnMap.put(subscriptionId, creditCardDigits);
            }
        }

        return returnMap;
    }
    
    /**
     * Helper method that makes the callout to get a single credit card's information
     * 
     * @author Jacob Huang
     * 
     * @param subscriptionId            String subscription ID to query Cybersouce for
     * @param merchantReferenceCode     String merchant reference code for the subscription, stored in Opportunity External Payment Gateway ID
     * 
     * @return      last 4 digits of the card credit used for the subscription, null if subscription not found 
     */
    public String getSingleCreditCardDigits(String subscriptionId, String merchantReferenceCode) { 
        String body;       
        try {
            body = createRetrieveSubscriptionBody(subscriptionId, merchantReferenceCode);
        }
        catch (AuraHandledException ahe) {
            return null;
        }

        HttpResponse response = executeSOAPRequest(PAYMENT_TARGET, body);
        String cardNumber = parseSOAPResponse(response, new List<String>{REPLY_MESSAGE_NODE, SUBSCRIPTION_RETRIEVE_NODE, CARD_NUMBER_NODE});
        return cardNumber?.right(4);
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
        String giftType = (String) params?.get(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY);
        String subscriptionId = (String) params?.get(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY);
        String externalPaymentGatewayId = (String) params?.get(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY);

        if (subscriptionId == null || externalPaymentGatewayId == null || (giftType != PORTAL_CONST_OnlineGiving.RECURRING_TYPE && giftType != PORTAL_CONST_OnlineGiving.PLEDGE_TYPE)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Insufficient information to cancel subscription'});
        }

        String body = createCancelSubscriptionBody(giftType, subscriptionId, externalPaymentGatewayId);
        HttpResponse response = executeSOAPRequest(PAYMENT_TARGET, body);

        if (!isSOAPSuccess(response)) {
            String reasonCode = parseSOAPResponse(response, new List<String>{REPLY_MESSAGE_NODE, REASON_CODE_NODE});
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Failed to cancel subscription. ' + ucinn_ascendv2.ascend_GIFT_ExternalPaymentCyberSource.failureReasonCodes.get(reasonCode)});
        }
    }

    /**
     * Sets the wallet type being used for this payment.
     * 
     * @author Aaron Wong
     * 
     * @param walletName    Name of the wallet.
     * @since               1.0
     */
    private void setWalletType(String walletName) {
        this.walletType = WALLET_NAME_TO_TYPE_MAP.get(walletName);
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
        this.isAchPayment = additionalPaymentDataMap?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY) == PORTAL_CONST_OnlineGiving.ACH_CONST;
        return this.isAchPayment == true ? PORTAL_CONST_OnlineGiving.ACH_CONST : PORTAL_CONST_OnlineGiving.CREDIT_CARD;
    }

    /**
     * Select the validation/verification option for transactions using ACH (technically, electronic check is Cybersource's more general term that includes ACH)
     * This method exists so the value be changed in just a single place and also so the information below isn't in a giant comment block above a static constant 
     * 
     * if this value is not used in the HttpRequest body, then Cybersource will select 1 by default
     * 1 is used by Paymentech and Telecheck payment processors
     * 2 is only for Paymentech payment processor
     * 3 and 4 are also documented options but from a copyright 2010 guide, so they're likely obsolete
     * 
     * In the REST/JSON request, this value is for processingInformation.bankTransferOptions.fraudScreeningLevel
     * In the SOAP/XML request, this value is for ecDebitService_verificationLevel 
     * 
     * @author Jacob Huang
     * @since 1.5
     * 
     * @return '1'
     */
    protected virtual String getVerificationLevel() {
        return '1';
    }
}