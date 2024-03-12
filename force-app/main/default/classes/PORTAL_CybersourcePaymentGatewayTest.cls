// test
@isTest
public with sharing class PORTAL_CybersourcePaymentGatewayTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void testGetPublicAPIKey() {
            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();

            controller.getPublicApiKey(new Map<String, Object>());
        }

        public virtual void testGetCaptureContext() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(200,'succeeded', '{"keyId" : "JWT token"}', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.CAPTURE_CONTEXT_REQUEST_TARGET);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            controller.getCaptureContext();
            Test.stopTest();
        }

        public virtual void testCreateOneTimePayment() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(201,'succeeded', '{"id":"testId", "status":"AUTHORIZED"}', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.PAYMENT_TARGET);

            Map<String, Object> params = new Map<String, Object>();

            params.put('paymentId', 'JWT token');
            params.put('amount', '25');

            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();

            mockcallouts.addRequest(201,'succeeded', '{"id":"testId", "status":"AUTHORIZED"}', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.PAYMENT_TARGET);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, new Map<Object, Object>{'walletType' => 'googlePay'});
            controller.createOneTimePayment(params);

            mockcallouts.addRequest(201,'succeeded', '{"id":"testId", "status":"AUTHORIZED"}', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.PAYMENT_TARGET);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, new Map<Object, Object>{'walletType' => 'applePay'});
            controller.createOneTimePayment(params);

            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, new Map<Object, Object>{
                PORTAL_CONST_OnlineGiving.FULL_NAME => 'Testy McTestFace',
                PORTAL_CONST_OnlineGiving.BANK_ROUTING_NUMBER => '121042882',   // test routing and account numbers
                PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_NUMBER => '4100',        
                PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_TYPE => 'C',
                PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY => PORTAL_CONST_OnlineGiving.ACH_CONST
            });
            controller.createOneTimePayment(params);
            
            mockcallouts.addRequest(201,'succeeded', '{"id":"testId", "status":"ERROR"}', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.PAYMENT_TARGET);

            try {
                controller.createOneTimePayment(params);
            } catch(Exception e) {

            }

            mockcallouts.addRequest(404,'not found', '', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.PAYMENT_TARGET);

            try {
                controller.createOneTimePayment(params);
            } catch (Exception e) {

            }
            Test.stopTest();
        }

        public virtual void testCreateSubscription() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            String testId = 'testId';
            mockcallouts.addRequest(201,'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:decision>ACCEPT</c:decision>' +
                                                '<c:reasonCode>100</c:reasonCode>' +
                                                '<c:paySubscriptionCreateReply>' +
                                                    '<c:subscriptionID>' + testId + '</c:subscriptionID>' +
                                                '</c:paySubscriptionCreateReply>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();


            Map<String, Object> params = new Map<String, Object>();

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY, reviewTransaction);

            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, Datetime.now().addDays(1));

            String JWTPayload = EncodingUtil.base64Encode(Blob.valueOf('{"jti":"testId"}'));
            params.put('paymentId', 'JWTHeader.' + JWTPayload + '.JWTSignature');
            params.put('amount', '25');
            params.put(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY, 5);
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.PLEDGE);

            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);

            String subscriptionId = controller.createSubscription(params);
            System.assertEquals(testId, subscriptionId);

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.RECURRING_TYPE);

            subscriptionId = controller.createSubscription(params);
            System.assertEquals(testId, subscriptionId);

            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, new Map<Object, Object>{'walletType' => 'googlePay'});
            subscriptionId = controller.createSubscription(params);
            System.assertEquals(testId, subscriptionId);

            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, new Map<Object, Object>{'walletType' => 'applePay'});
            subscriptionId = controller.createSubscription(params);
            System.assertEquals(testId, subscriptionId);

            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, new Map<Object, Object>{
                PORTAL_CONST_OnlineGiving.FULL_NAME => 'Testy McTestFace',
                PORTAL_CONST_OnlineGiving.BANK_ROUTING_NUMBER => '121042882',   // test routing and account numbers
                PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_NUMBER => '4100',        
                PORTAL_CONST_OnlineGiving.BANK_ACCOUNT_TYPE => 'C',
                PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY => PORTAL_CONST_OnlineGiving.ACH_CONST
            });
            subscriptionId = controller.createSubscription(params);
            System.assertEquals(testId, subscriptionId);

            mockcallouts.addRequest(200,'success', 
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:decision>REJECT</c:decision>' +
                                                '<c:reasonCode>102</c:reasonCode>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            try {
                controller.createSubscription(params);
            } catch (Exception e) { }

            mockcallouts.addRequest(404,'not found', '', PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            try {
                controller.createSubscription(params);
            } catch (Exception e) { }

            Test.stopTest();
        }

        public virtual void testUpdateSubscriptionCreditCard() {
            // example JWT with expiration date in the past for test credit card 3782 8224 6310 005, can decode with https://jwt.io/
            // note: it's not super easy to generate a valid JWT at runtime so this is sufficient for now
            String jwt = 'eyJraWQiOiIwOGxmQ2VzYVFDa1MyZ0hCMHVEMFVBQ0ZSYmIyMGZiYiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjp7ImV4cGlyYXRpb25ZZWFyIjoiMjAyMyIsIm51bWJlciI6IjM3ODI4MlhYWFhYMDAwNSIsImV4cGlyYXRpb25Nb250aCI6IjA3IiwidHlwZSI6IjAwMyJ9LCJpc3MiOiJGbGV4LzA3IiwiZXhwIjoxNjYzMjY5NjQyLCJ0eXBlIjoibWYtMC4xMS4wIiwiaWF0IjoxNjYzMjY4NzQyLCJqdGkiOiIxRTYxUUJaMlEyRllERlZRUzg2WEY0QVdMVUhKNkRVSExKQTA1RUNWTTdPWjRJQ1RFOFNMNjMyMzdCMEFGRTMyIiwiY29udGVudCI6eyJwYXltZW50SW5mb3JtYXRpb24iOnsiY2FyZCI6eyJleHBpcmF0aW9uWWVhciI6eyJ2YWx1ZSI6IjIwMjMifSwibnVtYmVyIjp7Im1hc2tlZFZhbHVlIjoiWFhYWFhYWFhYWFgwMDA1IiwiYmluIjoiMzc4MjgyIn0sInNlY3VyaXR5Q29kZSI6e30sImV4cGlyYXRpb25Nb250aCI6eyJ2YWx1ZSI6IjA3In0sInR5cGUiOnsidmFsdWUiOiIwMDMifX19fX0.EZVARWDb_ZmCowZr14dzGkS_-1mymlWhsG1mApC1Pk89z5GovXW18oiTYNEbX4CW3mTcpmsWYTk4l_-tde6pvLFBkKpfGMacKpu1zOoUN1QHhMNNucyDlps5vKGCjJyiVysLpVpQfkOVmaInGbD3gtXhe35OOEJV-c3iMGbIWtNtvBYLeTUdhsy38wtIwqxZkFaHenalrVkuvbN8timcBH4b9OMamNrp3uzfIV0duyTvzRZhQjp5DTTQaQuwNi4TPnHAdC0UctvdYASchELNyUyN_cO-aqGdFwul4FyICSdmsBInOwRQ58KwpfrY_B4ru-XV5tmCobcb3Ggx8w_1SQ';
            String gatewayId = 'merchantreferencecode';
            String subscriptionId = 'subscriptionid';

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:decision>ACCEPT</c:decision>' +
                                                '<c:reasonCode>100</c:reasonCode>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, jwt);
            params.put(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY, gatewayId);
            params.put(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY, subscriptionId);
            
            Test.startTest();
            String newDigits = controller.updateSubscriptionCreditCard(params);
            System.assertEquals('0005', newDigits);
            Test.stopTest();
        }

        public virtual void testInvalidUpdateSubscriptionCreditCard() {
            String jwt = 'eyJraWQiOiIwOGxmQ2VzYVFDa1MyZ0hCMHVEMFVBQ0ZSYmIyMGZiYiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjp7ImV4cGlyYXRpb25ZZWFyIjoiMjAyMyIsIm51bWJlciI6IjM3ODI4MlhYWFhYMDAwNSIsImV4cGlyYXRpb25Nb250aCI6IjA3IiwidHlwZSI6IjAwMyJ9LCJpc3MiOiJGbGV4LzA3IiwiZXhwIjoxNjYzMjY5NjQyLCJ0eXBlIjoibWYtMC4xMS4wIiwiaWF0IjoxNjYzMjY4NzQyLCJqdGkiOiIxRTYxUUJaMlEyRllERlZRUzg2WEY0QVdMVUhKNkRVSExKQTA1RUNWTTdPWjRJQ1RFOFNMNjMyMzdCMEFGRTMyIiwiY29udGVudCI6eyJwYXltZW50SW5mb3JtYXRpb24iOnsiY2FyZCI6eyJleHBpcmF0aW9uWWVhciI6eyJ2YWx1ZSI6IjIwMjMifSwibnVtYmVyIjp7Im1hc2tlZFZhbHVlIjoiWFhYWFhYWFhYWFgwMDA1IiwiYmluIjoiMzc4MjgyIn0sInNlY3VyaXR5Q29kZSI6e30sImV4cGlyYXRpb25Nb250aCI6eyJ2YWx1ZSI6IjA3In0sInR5cGUiOnsidmFsdWUiOiIwMDMifX19fX0.EZVARWDb_ZmCowZr14dzGkS_-1mymlWhsG1mApC1Pk89z5GovXW18oiTYNEbX4CW3mTcpmsWYTk4l_-tde6pvLFBkKpfGMacKpu1zOoUN1QHhMNNucyDlps5vKGCjJyiVysLpVpQfkOVmaInGbD3gtXhe35OOEJV-c3iMGbIWtNtvBYLeTUdhsy38wtIwqxZkFaHenalrVkuvbN8timcBH4b9OMamNrp3uzfIV0duyTvzRZhQjp5DTTQaQuwNi4TPnHAdC0UctvdYASchELNyUyN_cO-aqGdFwul4FyICSdmsBInOwRQ58KwpfrY_B4ru-XV5tmCobcb3Ggx8w_1SQ';
            String gatewayId = 'merchantreferencecode';
            String subscriptionId = 'subscriptionid';

            // Cybersource returns status code 200 even when the query fails, look for decision REJECT and/or non-100 reasonCode
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:decision>REJECT</c:decision>' +
                                                '<c:reasonCode>102</c:reasonCode>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, jwt);
            params.put(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY, gatewayId);
            params.put(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY, subscriptionId);
            
            Test.startTest();
            try {
                controller.updateSubscriptionCreditCard(null);
                System.assert(false);
            } catch (Exception e) { }
            
            String nullString = controller.updateSubscriptionCreditCard(params);
            System.assertEquals(null, nullString);
            Test.stopTest();
        }

        public virtual void testGetCreditCardIdToLastFourDigitsMap() {
            String subscriptionId = '123456';
            String merchantReferenceCode = 'abcdef';

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:paySubscriptionRetrieveReply>' +
                                                    '<c:cardAccountNumber>411111XXXXXX1111</c:cardAccountNumber>' +
                                                '</c:paySubscriptionRetrieveReply>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            
            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY, new List<String>{subscriptionId});
            params.put(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_LIST_KEY, new List<String>{merchantReferenceCode});

            Test.startTest();
            Map<String, String> emptyMap = controller.getCreditCardIdToLastFourDigitsMap(null);
            System.assertEquals(0, emptyMap.size());

            Map<String, String> digits = controller.getCreditCardIdToLastFourDigitsMap(params);
            System.assertEquals(1, digits.size());
            System.assertEquals('1111', digits.get(subscriptionId));
            Test.stopTest();
        }

        public virtual void testInvalidGetCreditCardIdToLastFourDigitsMap() {
            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();

            Test.startTest();
            String nullString = controller.getSingleCreditCardDigits(null, null);
            System.assertEquals(null, nullString);
            nullString = controller.getSingleCreditCardDigits(null, 'code');
            System.assertEquals(null, nullString);
            nullString = controller.getSingleCreditCardDigits('id', null);
            System.assertEquals(null, nullString);
            Test.stopTest();
        }

        public virtual void testCancelSubscription() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:decision>ACCEPT</c:decision>' +
                                                '<c:reasonCode>100</c:reasonCode>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.RECURRING_TYPE);
            params.put(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY, '123456');
            params.put(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY, 'abcdef');

            Test.startTest();
            controller.cancelSubscription(params);
            Test.stopTest();
        }

        public virtual void testInvalidCancelSubscription() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            // Cybersource returns status code 200 even when the query fails, look for decision REJECT and/or non-100 reasonCode
            mockcallouts.addRequest(200, 'succeeded',
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                                        '<soap:Body>' + 
                                            '<c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.191">' +
                                                '<c:decision>REJECT</c:decision>' +
                                                '<c:reasonCode>102</c:reasonCode>' +
                                            '</c:replyMessage>' +
                                        '</soap:Body>' +
                                    '</soap:Envelope>',
                                    PORTAL_CybersourcePaymentGateway.SOAP_CREDENTIAL);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.RECURRING_TYPE);
            params.put(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY, '123456');
            params.put(PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY, 'abcdef');

            Test.startTest();
            try {
                controller.cancelSubscription(null);
                System.assert(false);
            } catch (AuraHandledException e) { }

            try {
                controller.cancelSubscription(params);
                System.assert(false);
            }
            catch (AuraHandledException e) { }
            Test.stopTest();
        }

        public virtual void testGetReviewTransactionTenderType() {
            Test.startTest();
            PORTAL_CybersourcePaymentGateway controller = new PORTAL_CybersourcePaymentGateway();
            String tenderType = controller.getReviewTransactionTenderType(null);
            System.assertEquals(PORTAL_CONST_OnlineGiving.CREDIT_CARD, tenderType);

            tenderType = controller.getReviewTransactionTenderType(new Map<Object, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY => PORTAL_CONST_OnlineGiving.ACH_CONST});
            System.assertEquals(PORTAL_CONST_OnlineGiving.ACH_CONST, tenderType);
            Test.stopTest();
        }
    }

    public static testMethod void testGetPublicAPIKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testGetPublicAPIKey();
    }

    public static testMethod void testGetCaptureContext() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testGetCaptureContext();
    }

    public static testMethod void testCreateOneTimePayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testCreateOneTimePayment();
    }

    public static testMethod void testCreateSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testCreateSubscription();
    }

    public static testMethod void testUpdateSubscriptionCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testUpdateSubscriptionCreditCard();
    }

    public static testMethod void testInvalidUpdateSubscriptionCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testInvalidUpdateSubscriptionCreditCard();
    }

    public static testMethod void testGetCreditCardIdToLastFourDigitsMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testGetCreditCardIdToLastFourDigitsMap();
    }

    public static testMethod void testInvalidGetCreditCardIdToLastFourDigitsMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testInvalidGetCreditCardIdToLastFourDigitsMap();
    }

    public static testMethod void testCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testCancelSubscription();
    }

    public static testMethod void testInvalidCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testInvalidCancelSubscription();
    }

    /**
     * Test get tender type
     * @author Jacob Huang
     * @since 1.5
     */
    public static testMethod void testGetReviewTransactionTenderType() {
        PORTAL_TestClassFactory.getTestClassFactory().getCybersourcePaymentGatewayTestClass().testGetReviewTransactionTenderType();

    }
}