@isTest
public with sharing class PORTAL_StripePaymentGatewayTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testCreateOneTimePayment() {
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id" : "123456"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PAYMENT_INTENT_ENDPOINT);
            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();
            try {
                controller.createOneTimePayment(new Map<String, Object>());
            } catch (Exception e) {}

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'paymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, 100);
            params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, null);
            params.put(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY, new Map<String, Object>{});

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
            params.put(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY, stripeBillingInformation);

            try {
                controller.createOneTimePayment(null);
            } catch(Exception e) {}

            controller.createOneTimePayment(params);
            Test.stopTest();
        }

        public virtual void testCreateSubscription() {
            Test.startTest();

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'paymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, 100);
            params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, null);
            params.put(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY, new Map<String, Object>{});

            params.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY, PORTAL_CONST_OnlineGiving.ANNUAL_FREQUENCY);
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY, reviewTransaction);
            params.put(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY, 4);
            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, null);

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
            params.put(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY, stripeBillingInformation);


            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();

            try {
                controller.createSubscription(null);
            } catch(Exception e) {}

            controller.createSubscription(params);
            Test.stopTest();
        }

        public virtual void  testGetPledgeEndDate() {

            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();

            controller.getPledgeEndDate(PORTAL_CONST_OnlineGiving.ANNUAL_FREQUENCY, Date.Today(), 1);
            controller.getPledgeEndDate(PORTAL_CONST_OnlineGiving.SEMI_ANNUAL_FREQUENCY, Date.Today(), 1);
            controller.getPledgeEndDate(PORTAL_CONST_OnlineGiving.QUARTERLY_FREQUENCY, Date.Today(), 1);
            controller.getPledgeEndDate(PORTAL_CONST_OnlineGiving.MONTHLY_FREQUENCY, Date.Today(), 1);
            controller.getPledgeEndDate(PORTAL_CONST_OnlineGiving.BI_WEEKLY_FREQUENCY, Date.Today(), 1);
            controller.getPledgeEndDate(PORTAL_CONST_OnlineGiving.WEEKLY_FREQUENCY, Date.Today(), 1);
            try {
                controller.getPledgeEndDate('invalid', Date.Today(), 1);
            } catch(Exception e) {}

        }

        public virtual void testGetPublicAPIKey() {
            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();

            controller.getPublicAPIKey(null);
        }

        public virtual void testUpdateSubscriptionCreditCard() {
            String customerId = '123456789';
            String subscriptionId = 'sub_1111';
            String paymentId = 'pm_9999';

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', '{"id": "9999"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id": "9999"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT + '/' + subscriptionId);
            mockcallouts.addRequest(200, 'succeeded', '{"id": "pm_9999", "card": {"last4": "9999"}}',
                                    PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT + '/' + customerId + '/payment_methods/' + paymentId);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, new Contact(ucinn_portal_Stripe_Customer_ID__c = customerId));
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, paymentId);

            Test.startTest();
            try {
                controller.updateSubscriptionCreditCard(null);
                System.assert(false);
            } catch(Exception e) {}

            try {
                controller.updateSubscriptionCreditCard(params);
                System.assert(false);
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY, subscriptionId);
            String newDigits = controller.updateSubscriptionCreditCard(params);
            System.assertEquals('9999', newDigits);
            Test.stopTest();
        }
        
        public virtual void testGetCreditCardIdToLastFourDigitsMap() {
            String customerId = '123456789';
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', 
                                    '{"data": [' +
                                        '{"id": "sub_1111", "default_payment_method": "pm_1111"},' +
                                        '{"id": "sub_2222", "default_payment_method": "pm_2222"}' +
                                    ']}',
                                    PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT + '?customer=' + customerId);

            mockcallouts.addRequest(200, 'succeeded', 
                                    '{"data": [' +
                                        '{"id": "pm_1111", "card": {"last4": "1111"}}, ' +
                                        '{"id": "pm_2222", "card": {"last4": "2222"}}, ' +
                                        '{"id": "pm_3333", "card": {"last4": "3333"}}' +
                                    ']}', 
                                    PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT + '/' + customerId + '/payment_methods?type=card&limit=100');

            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY, new List<String>{'sub_1111', 'sub_2222'});
            params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, new Contact(ucinn_portal_Stripe_Customer_ID__c = customerId));

            Test.startTest();
            Map<String, String> empty = controller.getCreditCardIdToLastFourDigitsMap(null);
            System.assertEquals(0, empty.size());

            Map<String, String> digits = controller.getCreditCardIdToLastFourDigitsMap(params);
            System.assertEquals(2, digits.size());
            System.assertEquals('1111', digits.get('sub_1111'));
            System.assertEquals('2222', digits.get('sub_2222'));
            Test.stopTest();
        }

        public virtual void testInvalidGetStripeSinglePaymentMethod() {
            Test.startTest();
            Map<String, Object> emptyMap = PORTAL_StripePaymentGateway.getStripeSinglePaymentMethod(null, null);
            System.assertEquals(0, emptyMap.size());
            emptyMap = PORTAL_StripePaymentGateway.getStripeSinglePaymentMethod('id', null);
            System.assertEquals(0, emptyMap.size());
            emptyMap = PORTAL_StripePaymentGateway.getStripeSinglePaymentMethod(null, 'id');
            System.assertEquals(0, emptyMap.size());
            Test.stopTest();
        }

        public virtual void testInvalidGetStripeUncanceledSubscriptions() {
            Test.startTest();
            List<Object> emptyList = PORTAL_StripePaymentGateway.getStripeUncanceledSubscriptions(null);
            System.assertEquals(0, emptyList.size());
            Test.stopTest();
        }

        public virtual void testInvalidGetStripePaymentMethods() {
            Test.startTest();
            List<Object> emptyList = PORTAL_StripePaymentGateway.getStripePaymentMethods(null);
            System.assertEquals(0, emptyList.size());
            Test.stopTest();
        }

        public virtual void testCancelSubscription() {
            String subscriptionId = 'sub_123456789';
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', '', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT + '/' + subscriptionId);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();
            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY => subscriptionId};

            Test.startTest();
            controller.cancelSubscription(params);
            Test.stopTest();
        }

        public virtual void testInvalidCancelSubscription() {
            PORTAL_StripePaymentGateway controller = new PORTAL_StripePaymentGateway();

            Test.startTest();
            try {
                controller.cancelSubscription(null);
                System.assert(false);
            } catch (AuraHandledException e) { }

            try {
                PORTAL_StripePaymentGateway.cancelStripeSubscription(null);
                System.assert(false);
            } catch (AuraHandledException e) { }
            Test.stopTest();
        }
    }

    public static testMethod void testCreateOneTimePayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testCreateOneTimePayment();

    }

    public static testMethod void testCreateSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testCreateSubscription();
    }

    public static testMethod void  testGetPledgeEndDate() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testGetPledgeEndDate();

    }

    public static testMethod void testGetPublicAPIKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testGetPublicAPIKey();
    }

    public static testMethod void testUpdateSubscriptionCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testUpdateSubscriptionCreditCard();
    }

    public static testMethod void testGetCreditCardIdToLastFourDigitsMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testGetCreditCardIdToLastFourDigitsMap();
    }

    public static testMethod void testInvalidGetStripeSinglePaymentMethod() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testInvalidGetStripeSinglePaymentMethod();
    }

    public static testMethod void testInvalidGetStripeUncanceledSubscriptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testInvalidGetStripeUncanceledSubscriptions();
    }

    public static testMethod void testInvalidGetStripePaymentMethods() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testInvalidGetStripePaymentMethods();
    }

    public static testMethod void testCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testCancelSubscription();
    }

    public static testMethod void testInvalidCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentGatewayTestClass().testInvalidCancelSubscription();
    }
}