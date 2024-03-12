@isTest
public with sharing class PORTAL_DoubleTheDonationControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void testCreateDonationInDtd() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', '{"donation_identifier":"123456789012345678901234"}', PORTAL_DoubleTheDonationController.BASE_URL + PORTAL_DoubleTheDonationController.REGISTER_DONATION_ENDPOINT);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_DoubleTheDonationController controller = new PORTAL_DoubleTheDonationController();
            Map<String, Object> params = new Map<String, Object>{
                PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID => '42',
                PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION => new Map<String, Object>{
                    PORTAL_DoubleTheDonationController.FIRST_NAME => 'Test',
                    PORTAL_DoubleTheDonationController.LAST_NAME => 'Test',
                    PORTAL_DoubleTheDonationController.EMAIL_ADDRESS => 'test@test.com'
                },
                PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 42.42,
                PORTAL_CONST_OnlineGiving.TRANSACTION_DATE => Date.today(),
                PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME => 'Test Appeal'
            };

            Test.startTest();
            PORTAL_DoubleTheDonationController.PORTAL_DTDResponseWrapper wrapper = controller.createDonationInDtd(params);
            System.assertEquals('123456789012345678901234', wrapper.donationIdentifier);
            Test.stopTest();
        }

        public virtual void testInvalidCreateDonationInDtd() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(400, 'error', '', PORTAL_DoubleTheDonationController.BASE_URL + PORTAL_DoubleTheDonationController.REGISTER_DONATION_ENDPOINT);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            Map<String, Object> validParams = new Map<String, Object>{
                PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID => '42',
                PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION => new Map<String, Object>{
                    PORTAL_DoubleTheDonationController.FIRST_NAME => 'Test',
                    PORTAL_DoubleTheDonationController.LAST_NAME => 'Test',
                    PORTAL_DoubleTheDonationController.EMAIL_ADDRESS => 'test@test.com'
                },
                PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 42.42,
                PORTAL_CONST_OnlineGiving.TRANSACTION_DATE => Date.today(),
                PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME => 'Test Appeal'
            };

            Map<String, Object> invalidParams = new Map<String, Object>{PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME => 'Test Appeal', PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID => '42'};

            PORTAL_DoubleTheDonationController controller = new PORTAL_DoubleTheDonationController();
            Test.startTest();
            PORTAL_DoubleTheDonationController.PORTAL_DTDResponseWrapper wrapper = controller.createDonationInDtd(null);
            System.assertEquals(null, wrapper.donationIdentifier);
            wrapper = controller.createDonationInDtd(invalidParams);
            System.assertEquals(null, wrapper.donationIdentifier);
            wrapper = controller.createDonationInDtd(validParams);
            System.assertEquals(null, wrapper.donationIdentifier);
            Test.stopTest();
        }

        public virtual void testCreateOrganizationInterim() {
            PORTAL_DoubleTheDonationController controller = new PORTAL_DoubleTheDonationController();
            String validBody = '{"matched-company":{"corporate_contact_email":"company@company.com","maximum_matched_amount":5,"company_name":"Very Good Building Company","corporate_contact_phone":"(123) 456-7890","minimum_matched_amount":3,"ratio":"0.5:1","id":42},"donation_identifier":"thisisatest1"}';
            Map<String, Object> validResponseMap = (Map<String, Object>) JSON.deserializeUntyped(validBody);
            String invalidRatioBody = '{"matched-company":{"ratio":"invalid:ratio"},"donation_identifier":"thisisatest2"}';
            Map<String, Object> invalidRatioResponseMap = (Map<String, Object>) JSON.deserializeUntyped(invalidRatioBody);

            Test.startTest();
            ucinn_ascendv2__Interim__c interim = controller.createOrganizationInterim(validResponseMap);            
            System.assertEquals(PORTAL_DoubleTheDonationController.ORGANIZATION_INTERIM_EXTERNAL_ID_PREFIX + '-thisisatest1', interim.ucinn_ascendv2__External_System_Id__c);

            interim = controller.createOrganizationInterim(invalidRatioResponseMap);            
            System.assertEquals(PORTAL_DoubleTheDonationController.ORGANIZATION_INTERIM_EXTERNAL_ID_PREFIX + '-thisisatest2', interim.ucinn_ascendv2__External_System_Id__c);
            Test.stopTest();
        }
    }

    @isTest
    public static void testCreateDonationInDtd() {
        PORTAL_TestClassFactory.getTestClassFactory().getDoubleTheDonationControllerTestClass().testCreateDonationInDtd();
    }

    @isTest
    public static void testInvalidCreateDonationInDtd() {
        PORTAL_TestClassFactory.getTestClassFactory().getDoubleTheDonationControllerTestClass().testInvalidCreateDonationInDtd();
    }

    @isTest
    public static void testCreateOrganizationInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getDoubleTheDonationControllerTestClass().testCreateOrganizationInterim();
    }
}