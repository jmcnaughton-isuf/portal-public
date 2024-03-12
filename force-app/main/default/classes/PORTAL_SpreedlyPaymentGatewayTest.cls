@isTest
public with sharing class PORTAL_SpreedlyPaymentGatewayTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void getPublicApiKey() {
            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();

            controller.getPublicApiKey(new Map<String, Object>());
        }

        public virtual void testCreateOneTimePayment() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();

            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');

            ucinn_ascendv2__Transaction_Data__c retVal = new ucinn_ascendv2__Transaction_Data__c();

            retVal.ucinn_ascendv2__External_Payment_Gateway_Type__c = 'Spreedly';
            retVal.ucinn_ascendv2__Reason_Code__c = '100';
            retVal.ucinn_ascendv2__Request__c = '{"transaction": {"retain_on_success": true,"payment_method_token": "paymentToken","order_id": "orderId","currency_code": "USD","amount": 5000}}';
            insert retVal;

            Map<String, Object> params = new Map<String, Object>();

            Test.startTest();
            try {
                controller.createOneTimePayment(params);
            } catch (Exception e) { }

            params.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, retVal.Id);
            params.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, 'testGatewayName');
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'paymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '50');
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY,new ucinn_ascendv2__Review_Transaction_v2__c());

            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, retVal.Id);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);

            controller.getTransactionToken(params);
            controller.createOneTimePayment(params);

            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.FULL_NAME_KEY, 'firstName LastName');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ROUTING_NUMBER_KEY, '1234');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_NUMBER_KEY, '5678');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_TYPE_KEY, 'checking');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_HOLDER_KEY, 'personal');
            additionalPaymentDataMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY, PORTAL_SpreedlyPaymentGateway.PAYMENT_METHOD_BANK);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);

            controller.getTransactionToken(params);
            controller.createOneTimePayment(params);
            Test.stopTest();
        }

        public virtual void testCreateOneTimePaymentInvalidInput() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();
    
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');
    
            ucinn_ascendv2__Transaction_Data__c retVal = new ucinn_ascendv2__Transaction_Data__c();
    
            retVal.ucinn_ascendv2__External_Payment_Gateway_Type__c = 'Spreedly';
            retVal.ucinn_ascendv2__Reason_Code__c = '100';
            retVal.ucinn_ascendv2__Request__c = '{"transaction": {"retain_on_success": true,"payment_method_token": "paymentToken","order_id": "orderId","currency_code": "USD","amount": 5000}}';
            insert retVal;

            Map<String, Object> params = new Map<String, Object>();

            params.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, '');
            params.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, 'testGatewayName');
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'paymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '50');
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY,new ucinn_ascendv2__Review_Transaction_v2__c());
    
            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, '');
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);
    
            try {
                controller.createOneTimePayment(params);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }

        public virtual void testCreateOneTimePaymentInvalidAmount() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();
    
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');
    
            ucinn_ascendv2__Transaction_Data__c retVal = new ucinn_ascendv2__Transaction_Data__c();
    
            retVal.ucinn_ascendv2__External_Payment_Gateway_Type__c = 'Spreedly';
            retVal.ucinn_ascendv2__Reason_Code__c = '100';
            retVal.ucinn_ascendv2__Request__c = '{"transaction": {"retain_on_success": true,"payment_method_token": "paymentToken","order_id": "orderId","currency_code": "USD","amount": 4000}}';
            insert retVal;
    
            Map<String, Object> params = new Map<String, Object>();
    
            Test.startTest();
            
            params.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, retVal.Id);
            params.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, 'testGatewayName');
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'paymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '50');
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY,new ucinn_ascendv2__Review_Transaction_v2__c());
    
            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, retVal.Id);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);
    
            controller.getTransactionToken(params);

            try {
                controller.createOneTimePayment(params);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    
        public virtual void testCreateSubscription() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, 'testGatewayName');
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'testPaymentId');
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY, new ucinn_ascendv2__Review_Transaction_v2__c());
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.RECURRING_GIFT);
            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, Date.today() + 1);

            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods/testPaymentId/retain.json');

            try {
                controller.createSubscription(params);
            } catch(Exception e) {}
    
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods/testPaymentId/retain.json');
    
            string parsedId = controller.createSubscription(params);
    
            System.assert(parsedId.equals('transactionId'), 'failed parsing testId from mock response');
    
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');
    
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.PLEDGE);
            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.FULL_NAME_KEY, 'firstName LastName');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ROUTING_NUMBER_KEY, '1234');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_NUMBER_KEY, '5678');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_TYPE_KEY, 'checking');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_HOLDER_KEY, 'personal');
            additionalPaymentDataMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY, PORTAL_SpreedlyPaymentGateway.PAYMENT_METHOD_BANK);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);
    
            controller.createSubscription(params);
            Test.stopTest();
        }

        public virtual void testCreateSubscriptionRecurringType() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
    
            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();
    
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, 'testGatewayName');
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'testPaymentId');
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY, new ucinn_ascendv2__Review_Transaction_v2__c());
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.RECURRING_TYPE);
            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, Date.today() + 1);
    
    
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods/testPaymentId/retain.json');

            string parsedId = controller.createSubscription(params);

            System.assert(parsedId.equals('transactionId'), 'failed parsing testId from mock response');

            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.PLEDGE);
            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.FULL_NAME_KEY, 'firstName LastName');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ROUTING_NUMBER_KEY, '1234');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_NUMBER_KEY, '5678');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_TYPE_KEY, 'checking');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_HOLDER_KEY, 'personal');
            additionalPaymentDataMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY, PORTAL_SpreedlyPaymentGateway.PAYMENT_METHOD_BANK);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);

            controller.createSubscription(params);
            Test.stopTest();
        }

        public virtual void testRetainBankAccount() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();

            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');

            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();

            try {
                controller.retainBankAccount(additionalPaymentDataMap);
            } catch(Exception e) {}

            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.FULL_NAME_KEY, 'firstName LastName');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ROUTING_NUMBER_KEY, '1234');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_NUMBER_KEY, '5678');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_TYPE_KEY, 'checking');
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.BANK_ACCOUNT_HOLDER_KEY, 'personal');
            additionalPaymentDataMap.put(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY, new Map<Object, Object>{'email' => 'test@test.com'});
            additionalPaymentDataMap.put(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_TYPE_KEY, PORTAL_SpreedlyPaymentGateway.PAYMENT_METHOD_BANK);


            try {
                controller.retainBankAccount(additionalPaymentDataMap);
            } catch(Exception e) {}

            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');

            controller.retainBankAccount(additionalPaymentDataMap);
            Test.stopTest();
        }

        public virtual void testUpdateSubscriptionCreditCard() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"veryencryptedinfo", "last_four_digits": "9999"}, "token":"transactionId"}}', 
                                    PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods/veryencryptedinfo/retain.json');
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"mismatch", "last_four_digits": "doesnt_matter"}, "token":"transactionId"}}', 
                                    PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods/weirddata/retain.json');
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();

            Date futureDate = Date.newInstance(Date.today().year() + 1, 1, 1);
            Opportunity gift = new Opportunity(Name='Test', StageName='Active', CloseDate=futureDate);
            insert gift;
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.GIFT_ID_KEY, gift.Id);

            Test.startTest();
            String nullString = controller.updateSubscriptionCreditCard(null);
            System.assertEquals(null, nullString);

            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'weirddata');
            nullString = controller.updateSubscriptionCreditCard(params);
            System.assertEquals(null, nullString);

            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'veryencryptedinfo');
            String newDigits = controller.updateSubscriptionCreditCard(params);
            System.assertEquals('9999', newDigits);
            Test.stopTest();
        }

        public virtual void testGetCreditCardIdToLastFourDigitsMap() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'Success', '{"payment_method": {"last_four_digits": "1111"}}',
                                    PORTAL_SpreedlyPaymentGateway.BASE_URL + 'v1/payment_methods/AAA111.json');
            mockcallouts.addRequest(200, 'Success', '{"payment_method": {"last_four_digits": "2222"}}',
                                    PORTAL_SpreedlyPaymentGateway.BASE_URL + 'v1/payment_methods/BBB222.json');
            mockcallouts.addRequest(404, 'Error', '{"errors":[{"key":"errors.payment_method_not_found","message":"Unable to find the specified payment method."}]}',
                                    PORTAL_SpreedlyPaymentGateway.BASE_URL + 'v1/payment_methods/CCC333.json');
            mockcallouts.addRequest(404, 'Error', '{"errors":[{"key":"some_other_error","message":"Some unexpected message"}]}',
                                    PORTAL_SpreedlyPaymentGateway.BASE_URL + 'v1/payment_methods/DDD444.json');
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY, new List<String>{'AAA111', 'BBB222', 'CCC333'});

            Test.startTest();
            Map<String, String> empty = controller.getCreditCardIdToLastFourDigitsMap(null);
            System.assertEquals(0, empty.size());

            Map<String, String> digits = controller.getCreditCardIdToLastFourDigitsMap(params);
            System.assertEquals(2, digits.size());
            System.assertEquals('1111', digits.get('AAA111'));
            System.assertEquals('2222', digits.get('BBB222'));

            try {
                params.put(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY, new List<String>{'DDD444'});
                controller.getCreditCardIdToLastFourDigitsMap(params);
                System.assert(false);
            } catch (Exception e) { }

            Test.stopTest();
        }

        public virtual void testInvalidGetSingleCreditCardDigits() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(404, 'Error', '', PORTAL_SpreedlyPaymentGateway.BASE_URL + 'v1/payment_methods/AAA111.json');
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();

            Test.startTest();
            Map<String, Object> emptyMap = controller.getSingleCreditCardDigits(null);
            System.assertEquals(0, emptyMap.size());

            try {
                controller.getSingleCreditCardDigits('AAA111');
                System.assert(false);
            } catch (Exception e) { }

            Test.stopTest();
        }

        public virtual void testCancelSubscription() {
            PORTAL_SpreedlyPaymentGateway controller = new PORTAL_SpreedlyPaymentGateway();
            controller.cancelSubscription(null);
        }
    }

    public static testMethod void getPublicApiKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().getPublicApiKey();
    }

    public static testMethod void testCreateOneTimePayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testCreateOneTimePayment();
    }

    public static testMethod void testCreateSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testCreateSubscription();
    }

    public static testMethod void testRetainBankAccount() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testRetainBankAccount();
    }

    public static testMethod void testCreateOneTimePaymentInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testCreateOneTimePaymentInvalidInput();
    }

    public static testMethod void testCreateOneTimePaymentInvalidAmount() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testCreateOneTimePaymentInvalidAmount();
    }

    public static testMethod void testCreateSubscriptionRecurringType() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testCreateSubscriptionRecurringType();
    }

    public static testMethod void testUpdateSubscriptionCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testUpdateSubscriptionCreditCard();
    }

    public static testMethod void testGetCreditCardIdToLastFourDigitsMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testGetCreditCardIdToLastFourDigitsMap();
    }

    public static testMethod void testInvalidGetSingleCreditCardDigits() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testInvalidGetSingleCreditCardDigits();
    }

    public static testMethod void testCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyPaymentGatewayTestClass().testCancelSubscription();
    }
}