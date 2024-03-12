@isTest
public with sharing class PORTAL_StripePaymentElementGatewayTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetClientSecret() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359", "client_secret" : "test_client_secret"}', PORTAL_StripePaymentGateway.PAYMENT_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            User newUser;
            Id profileId = [SELECT id FROM profile WHERE name=: 'ascend Customer Community User'].id;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            newUser = new User(alias = 'testUser',
                                email = 'testCommunityUsermig123@test.com',
                                emailencodingkey='UTF-8',
                                lastname = 'Batman',
                                languagelocalekey='en_US',
                                localesidkey='en_US',
                                profileid = profileId,
                                contactId = con.Id,
                                IsActive = true,
                                timezonesidkey='America/Los_Angeles',
                                username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
            newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
            insert newUser;

            PORTAL_StripePaymentElementGateway controller = new PORTAL_StripePaymentElementGateway();

            String metadataString = '{"paymentOrigin":"onlineGivingPaymentElement","params":{"giftType":"gift","numberOfInstallments":0,"startDate":null,"endDate":null,"frequency":"","tributeInformation":{},"amount":"100.00","isGivingAsOrg":false},"stripeBillingInformation":{"address":{"city":"Malibu","line1":"10880 Malibu Point","postal_code":"90265","state":"California","country":"United States"},"email":"anthonystarkironman@gmail.com","name":"Anthony Edward Stark Jr."}}';
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('additionalMetadata', metadataString);            
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, 100);

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
            
            Test.startTest();
            System.runAs(newUser) {
                controller.getClientSecret(params);
            }
            Test.stopTest();
        }

        public virtual void testCreateOneTimePayment() {
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'test');
            PORTAL_StripePaymentElementGateway controller = new PORTAL_StripePaymentElementGateway();

            controller.createOneTimePayment(params);
        }
    }

    
    public static testMethod void testGetClientSecret() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentElementGatewayTestClass().testGetClientSecret();
    }

    public static testMethod void testCreateOneTimePayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getStripePaymentElementGatewayTestClass().testCreateOneTimePayment();
    }
}