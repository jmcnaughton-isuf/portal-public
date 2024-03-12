@istest
public class PORTAL_PaymentHubControllerBaseORTest {
    
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();      
        @istest
        public  static void testCreateReviewTransaction() {
            Campaign appeal = new Campaign();
            appeal.ucinn_ascendv2__Motivation_Code__c = '123appeal';
            appeal.Name = 'testappeal';
            insert appeal;

            

            Map<String, Object> params = new Map<String, Object>();

            try {
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); //for validating gift type
            } catch(Exception e) {}

            params.put(PORTAL_PaymentHubControllerBaseOR.GIFT_TYPE, PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE);

            try {
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); //for validating payment Id
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'testPaymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '-10.11');

            try {
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); //for validating Amount
            } catch(Exception e) {}


            params.put('tributeInformation', new Map<String, Object>{'ucinn_ascendv2__Tribute_Type_1__c' => 'In Honor Of'});
            params.put('stripeBillingInformation', new Map<String, Object>{'test' => 'test'});
            params.put('pageSectionName', 'nonExistantPage');
            params.put('PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY', '1');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '10.11');
            params.put(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY, new Map<String, Object>{'test' => 'test', 'isGivingAsOrg' => 'false'});
            params.put(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY, new List<Map<Object, Object>>{new Map<Object, Object>{'Name'=> 'test Designation', 'amount'=> 10.11}});
            params.put('appealCode', 'test Appeal');
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_ANNIVERSERY_DATE, String.valueOf(Date.today() + 365));
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_EXPIRATION_DATE, String.valueof(Date.today() + 30));
            params.put('membershipExternalId', 'testMemberId');
            params.put(PORTAL_MembershipControllerBase.APPEAL_CONST, appeal.Id);
            params.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY,PORTAL_CONST_OnlineGiving.MONTHLY_FREQUENCY);
            try {
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); //for subscription flow
            } catch(Exception e) {}


            params.put(PORTAL_PaymentHubControllerBaseOR.GIFT_TYPE, PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE);

            try{
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); //for payment flow
            } catch(Exception e) {}

            params.put(PORTAL_PaymentHubControllerBaseOR.GIFT_TYPE, PORTAL_CONST_PaymentHub.RECURRING_TYPE);
            Date today = Date.today();
            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, String.valueOf(today.addDays(1)));
            params.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, String.valueOf(today));
            try {
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); // for validating recurring gift end date
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, String.valueOf(today.addDays(2)));
            try{
                PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params); // for subscription flow with end date
            } catch(Exception e) {}

        }
    
        public virtual void testPopulateBillingInformation() {
            

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            Map<String, Object> billingInformation = new Map<String, Object>{'records' => new Map<String, Object>{
                                                                                'Personal_Information' => new Map<String, Object>{
                                                                                    'Name' => 'test'
                                                                                }}};
            String pageName = 'Online Giving';

            try {
                PORTAL_PaymentHubControllerBaseOR.populateBillingInformation(reviewTransaction, billingInformation, pageName);
            } catch (Exception e) {}
        }
        @istest
        public static void testPopulateOrganizationalGivingInformation() {
            

            String pageName = 'Online Giving';
            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            Map<String, Object> billingInformation = new Map<String, Object>{'records' => new Map<String, Object>{
                                                                                'Company_Information' => new Map<String, Object>{
                                                                                    'Company' => 'test'
                                                                                }},
                                                                             'isGivingAsOrg' => 'true'};

            try {
                PORTAL_PaymentHubControllerBaseOR.populateOrganizationalGivingInformation(reviewTransaction, billingInformation, pageName);
            } catch (Exception e) {}
        }
        @istest
        public static void testPopulateGiftType() {
             

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            String giftType = PORTAL_CONST_OnlineGiving.GIFT;
            Integer numberOfInstallments = 0;
            String pledgeId = '';
            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.GIFT, Date.today(), numberOfInstallments, pledgeId); //test outright gift

            pledgeId = 'test';
            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.GIFT, Date.today(), numberOfInstallments, pledgeId); //test pledge payment

            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE, Date.today(), numberOfInstallments, pledgeId); //test installment membership

            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE, Date.today(), numberOfInstallments, pledgeId); //test recurring membership

            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.PLEDGE_TYPE, Date.today(), numberOfInstallments, pledgeId); //test pledge payment
            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.PLEDGE_TYPE, Date.today() + 2, numberOfInstallments, pledgeId); //test pledge creation

            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.RECURRING_TYPE, Date.today(), numberOfInstallments, pledgeId); //test recurring payment
            PORTAL_PaymentHubControllerBaseOR.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.RECURRING_TYPE, Date.today() + 2, numberOfInstallments, pledgeId); //test recurring creation
        }
        @istest
        public  static void testPopulateAdditionalDetails() {
            

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

            List<ucinn_portal_Custom_Form_Field__c> formList = new List<ucinn_portal_Custom_Form_Field__c>();
            ucinn_portal_Custom_Form_Field__c customForm = new ucinn_portal_Custom_Form_Field__c();
            customForm.Field_API_Name__c = 'ucinn_ascendv2__Campaign_External_ID__c'; //with real data these would be custom but for testing its just rtv2 fields that are known to exist
            customForm.SObject_API_Name__c = 'Contact';
            customForm.Field_Label__c = 'test';
            customForm.Field_Type__c = 'Text';
            formList.add(customForm);

            //invalid field to test appending the manual review reason
            ucinn_portal_Custom_Form_Field__c invalidForm = new ucinn_portal_Custom_Form_Field__c();
            invalidForm.Field_API_Name__c = 'invalid field';
            invalidForm.SObject_API_Name__c = 'Contact';
            invalidForm.Field_Label__c = 'test';
            invalidForm.Field_Type__c = 'Text';
            formList.add(invalidForm);

            insert formList;

            PORTAL_PaymentHubControllerBaseOR.populateAdditionalDetails(reviewTransaction, formList);
        }
        @istest
        public static void testPopulateMatchingCompany() {
            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

            PORTAL_PaymentHubControllerBaseOR.populateMatchingCompany(reviewTransaction, 'company Name', 'hep Id'); //test HEP matching company
            PORTAL_PaymentHubControllerBaseOR.populateMatchingCompany(reviewTransaction, 'company Name', ''); //test non-HEP matching company
        }
        @istest
        public static void testSendGiftReceipt() {
           

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            reviewTransaction.ucinn_ascendv2__First_Name__c = 'firstName';
            reviewTransaction.ucinn_ascendv2__Last_Name__c = 'lastName';

            Folder[] folders = [SELECT Id FROM Folder
                                WHERE AccessType IN: new list<String>{'Shared','Public'}
                                    AND Type = 'Email'];
            System.assert(!folders.isEmpty(),'test can\'t run without Email Template folders. Folders can\'t be mocked in Apex');


            EmailTemplate template = new EmailTemplate();
            template.Subject = 'test subject';
            template.HtmlValue = 'test html';
            template.body = 'test body';
            template.Name = 'test Template';
            template.DeveloperName = 'test_Template_PaymentHub';
            template.isActive = true;
            template.TemplateType = 'custom';
            template.FolderId = folders[0].Id;
            insert template;

            Decimal totalAmount = 10.11;

            List<Map<String, Object>> designationList = new List<Map<String, Object>>{new Map<String, Object>{'Name'=> 'test Designation', 'amount'=> totalAmount}};

            PORTAL_PaymentHubControllerBaseOR.sendGiftReceipt(template.DeveloperName, designationList, reviewTransaction, null, null, null, totalAmount, new ucinn_ascendv2__Interim__c());
            PORTAL_PaymentHubControllerBaseOR.sendGiftReceipt(template.DeveloperName, designationList, reviewTransaction, null, Date.today().addMonths(24), 'Annual', totalAmount, new ucinn_ascendv2__Interim__c());
        }
     
        
    
        

    

       
}