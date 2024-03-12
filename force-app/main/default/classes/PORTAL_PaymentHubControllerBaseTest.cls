@isTest
public class PORTAL_PaymentHubControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testConstructor() {
            try {
                PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase(''); //test empty string throwing error
            } catch (Exception e) {
            }

            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test'); //test create test gateway

            controller.setPaymentInterface('test'); //test setting payment interface when already set
        }

        public virtual void testGetOrigin() {
            PORTAL_PaymentHubControllerBase.getOrigin();
        }

        public virtual void testGetApiKey() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');
            Map<String, Object> params = new Map<String, Object>();
            controller.getAPIKey(params);
        }

        public virtual void testCreateReviewTransaction() {
            Campaign appeal = new Campaign();
            appeal.ucinn_ascendv2__Motivation_Code__c = '123appeal';
            appeal.Name = 'testappeal';
            insert appeal;

            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            Map<String, Object> params = new Map<String, Object>();

            try {
                controller.createReviewTransaction(params); //for validating gift type
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE);

            try {
                controller.createReviewTransaction(params); //for validating payment Id
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'testPaymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '-10.11');

            try {
                controller.createReviewTransaction(params); //for validating Amount
            } catch(Exception e) {}


            params.put('tributeInformation', new Map<String, Object>{'ucinn_ascendv2__Tribute_Type_1__c' => 'In Honor Of'});
            params.put('stripeBillingInformation', new Map<String, Object>{'test' => 'test'});
            params.put('pageSectionName', 'nonExistantPage');
            params.put('PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY', '1');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '10.11');
            params.put(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY, new Map<String, Object>{'test' => 'test'});
            params.put(PORTAL_CONST_OnlineGiving.IS_GIVING_AS_ORG, false);
            params.put(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY, new List<Map<Object, Object>>{new Map<Object, Object>{'Name'=> 'test Designation', 'amount'=> 10.11}});
            params.put('appealCode', 'test Appeal');
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_ANNIVERSERY_DATE, String.valueOf(Date.today() + 365));
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_EXPIRATION_DATE, String.valueof(Date.today() + 30));
            params.put('membershipExternalId', 'testMemberId');
            params.put(PORTAL_MembershipControllerBase.APPEAL_CONST, appeal.Id);

            controller.createReviewTransaction(params); //for subscription flow

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE);

            controller.createReviewTransaction(params); //for payment flow

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.RECURRING_TYPE);
            Date today = Date.today();
            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, String.valueOf(today.addDays(1)));
            params.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, String.valueOf(today));
            try {
                controller.createReviewTransaction(params); // for validating recurring gift end date
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, String.valueOf(today.addDays(2)));
            controller.createReviewTransaction(params); // for subscription flow with end date

            params.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, String.valueOf(today));
            params.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, null);
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.PLEDGE_TYPE);
            params.put(PORTAL_CONST_OnlineGiving.IS_CREATE_PLEDGE_SUBSCRIPTION, false);
            params.put(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY, 4);
            controller.createReviewTransaction(params); // for pledge without subscription

            PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
            controller.createReviewTransaction(params); // for simulating unexpected portal/ascend exceptions after successful callout
        }
    
        public virtual void testPopulateBillingInformation() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            Map<String, Object> billingInformation = new Map<String, Object>{'records' => new Map<String, Object>{
                                                                                'Personal_Information' => new Map<String, Object>{
                                                                                    'Name' => 'test'
                                                                                }}};
            String pageName = 'Online Giving';

            try {
                controller.populateBillingInformation(reviewTransaction, billingInformation, pageName);
            } catch (Exception e) {}
        }

        public virtual void testPopulateOrganizationalGivingInformation() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            String pageName = 'Online Giving';
            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            Map<String, Object> billingInformation = new Map<String, Object>{'records' => new Map<String, Object>{
                                                                                'Company_Information' => new Map<String, Object>{
                                                                                    'Company' => 'test'
                                                                                }}};
            Boolean isGivingAsOrg = true;

            try {
                controller.populateOrganizationalGivingInformation(reviewTransaction, billingInformation, pageName, isGivingAsOrg);
            } catch (Exception e) {}
        }

        public virtual void testPopulateGiftType() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            String giftType = PORTAL_CONST_OnlineGiving.GIFT;
            Integer numberOfInstallments = 0;
            String pledgeId = '';
            controller.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.GIFT, Date.today(), numberOfInstallments, pledgeId); //test outright gift

            pledgeId = 'test';
            controller.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.GIFT, Date.today(), numberOfInstallments, pledgeId); //test pledge payment

            controller.populateGiftType(reviewTransaction, PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE, Date.today(), numberOfInstallments, pledgeId); //test installment membership

            controller.populateGiftType(reviewTransaction, PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE, Date.today(), numberOfInstallments, pledgeId); //test recurring membership

            controller.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.PLEDGE_TYPE, Date.today(), numberOfInstallments, pledgeId); //test pledge payment
            controller.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.PLEDGE_TYPE, Date.today() + 2, numberOfInstallments, pledgeId); //test pledge creation

            controller.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.RECURRING_TYPE, Date.today(), numberOfInstallments, pledgeId); //test recurring payment
            controller.populateGiftType(reviewTransaction, PORTAL_CONST_OnlineGiving.RECURRING_TYPE, Date.today() + 2, numberOfInstallments, pledgeId); //test recurring creation
        }

        public virtual void testPopulateAdditionalDetails() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

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

            controller.populateAdditionalDetails(reviewTransaction, formList);
        }

        public virtual void testPopulateMatchingCompany() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();

            controller.populateMatchingCompany(reviewTransaction, 'company Name', 'hep Id'); //test HEP matching company
            controller.populateMatchingCompany(reviewTransaction, 'company Name', ''); //test non-HEP matching company
        }

        public virtual void testPopulateDtdDonationInformation() {
            Campaign c = new Campaign(ucinn_ascendv2__Motivation_Code__c = 'Test', Name = 'Test');
            insert c;

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', '{"matched-company":{"id":42},"donation_identifier":"123456789012345678901234"}', PORTAL_DoubleTheDonationController.BASE_URL + PORTAL_DoubleTheDonationController.REGISTER_DONATION_ENDPOINT);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            Test.startTest();
            String dtdId = controller.populateDtdDonationInformation(PORTAL_PaymentHubControllerBase.DOUBLE_THE_DONATION, '42', null, false, null, '');
            System.assertEquals(null, dtdId);
            dtdId = controller.populateDtdDonationInformation(PORTAL_PaymentHubControllerBase.DOUBLE_THE_DONATION, '42', new Map<String, Object>{PORTAL_DoubleTheDonationController.LAST_NAME => 'Test'}, false, new ucinn_ascendv2__Review_Transaction_v2__c(), '');
            System.assertEquals(null, dtdId);
            dtdId = controller.populateDtdDonationInformation(PORTAL_PaymentHubControllerBase.DOUBLE_THE_DONATION, '42', 
                    new Map<String, Object>{
                        PORTAL_DoubleTheDonationController.FIRST_NAME => 'Test',
                        PORTAL_DoubleTheDonationController.LAST_NAME => 'Test',
                        PORTAL_DoubleTheDonationController.EMAIL_ADDRESS => 'test@test.com'
                    }, 
                    false, 
                    new ucinn_ascendv2__Review_Transaction_v2__c(ucinn_ascendv2__Total_Transaction_Amount__c = 42.42, ucinn_ascendv2__Transaction_Date__c = Date.today(), ucinn_ascendv2__Campaign_External_ID__c = 'Test'),
                    '');
            System.assertEquals('123456789012345678901234', dtdId);

            ucinn_ascendv2__Review_Transaction_v2__c rtv2 = new ucinn_ascendv2__Review_Transaction_v2__c();
            dtdId = controller.populateDtdDonationInformation(PORTAL_PaymentHubControllerBase.DOUBLE_THE_DONATION, '42', 
                    new Map<String, Object>{
                        PORTAL_DoubleTheDonationController.FIRST_NAME => 'Test',
                        PORTAL_DoubleTheDonationController.LAST_NAME => 'Test',
                        PORTAL_DoubleTheDonationController.EMAIL_ADDRESS => 'test@test.com'
                    }, 
                    false, 
                    rtv2,
                    'foo');
            System.assertEquals('foo', dtdId);
            System.assertEquals('foo', rtv2.ucinn_ascendv2__External_Matching_Service_ID__c);

            Test.stopTest();
        }

        public virtual void testSendGiftReceipt() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

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

            controller.sendGiftReceipt(template.DeveloperName, designationList, reviewTransaction, null, null, null, totalAmount, new ucinn_ascendv2__Interim__c());
            controller.sendGiftReceipt(template.DeveloperName, designationList, reviewTransaction, null, Date.today().addMonths(24), 'Annual', totalAmount, new ucinn_ascendv2__Interim__c());
        }
     
        public virtual void testGetSpreedlyTransactionTokenOneTimePayment() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('Test');

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
    
            mockcallouts.addRequest(200, 'Success', '{"transaction":{"succeeded": true, "payment_method":{"token":"testId"}, "token":"transactionId"}}', PORTAL_SpreedlyPaymentGateway.BASE_URL + '/v1/payment_methods.json');
    
            ucinn_ascendv2__Transaction_Data__c retVal = new ucinn_ascendv2__Transaction_Data__c();
    
            retVal.ucinn_ascendv2__External_Payment_Gateway_Type__c = 'Spreedly';
            retVal.ucinn_ascendv2__Reason_Code__c = '100';
            retVal.ucinn_ascendv2__Request__c = '{"transaction": {"retain_on_success": true,"payment_method_token": "paymentToken","order_id": "orderId","currency_code": "USD","amount": 5000}}';
            insert retVal;
    
            Map<String, Object> params = new Map<String, Object>();
            
            params.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, retVal.Id);
            params.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, 'testGatewayName');
            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'paymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '50');
            params.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY,new ucinn_ascendv2__Review_Transaction_v2__c());
    
            Map<Object, Object> additionalPaymentDataMap = new Map<Object, Object>();
            additionalPaymentDataMap.put(PORTAL_SpreedlyPaymentGateway.TRANSACTION_TOKEN_KEY, retVal.Id);
            params.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, 'Test Type');

            Test.startTest();

            controller.getSpreedlyTransactionToken(params);

            // subscriptions don't get the token
            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_OnlineGiving.PLEDGE_TYPE);
            controller.getSpreedlyTransactionToken(params);

            Test.stopTest();
        }
    
        public virtual void testPopulateOrganizationalGivingInformationAdditionalInfo() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');
    
            String pageName = 'Online Giving';
            ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            Map<String, Object> billingInformation = new Map<String, Object>{'records' => new Map<String, Object>{
                                                                                'Company_Information' => new Map<String, Object>{
                                                                                    'Company' => new List<Object>{new Map<String, Object>()}
                                                                                }}};
            Boolean isGivingAsOrg = true;
    
            try {
                controller.populateOrganizationalGivingInformation(reviewTransaction, billingInformation, pageName, isGivingAsOrg);
            } catch (Exception e) {}
        }

        public virtual void testGetRecaptchaOption() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            Test.startTest();
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                controller.getRecaptchaOption();
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testCancelSubscription() {
            Id pledgeType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Pledge').getRecordTypeId();
            Id recurringType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Recurring_Gift').getRecordTypeId();
            Opportunity pledge = new Opportunity(Name = 'Test', StageName = 'Active', CloseDate = Date.today(), RecordTypeId = pledgeType, Amount = 50, ucinn_ascendv2__External_System_Id__c = 'PORT-pledge');
            Opportunity recurringGift = new Opportunity(Name = 'Test', StageName = 'Active', CloseDate = Date.today(), RecordTypeId = recurringType, Amount = 50, ucinn_ascendv2__External_System_Id__c = 'PORT-recur');
            insert new List<Opportunity>{pledge, recurringGift};

            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            Test.startTest();
            try {
                controller.cancelSubscription(new Map<String, Object>{
                    PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY => PORTAL_CONST_OnlineGiving.RECURRING_TYPE,
                    PORTAL_CONST_OnlineGiving.GIFT_ID_KEY => 'testing123',
                    PORTAL_OnlineGivingControllerBase.EXTERNAL_SYSTEM_ID => null
                });
                System.assert(false);
            } catch (Exception e) {}

            controller.cancelSubscription(new Map<String, Object>{
                PORTAL_CONST_OnlineGiving.GIFT_ID_KEY => pledge.Id,
                PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY => PORTAL_CONST_OnlineGiving.PLEDGE_TYPE,
                PORTAL_OnlineGivingControllerBase.EXTERNAL_SYSTEM_ID => 'PORT-pledge'
            });

            controller.cancelSubscription(new Map<String, Object>{
                PORTAL_CONST_OnlineGiving.GIFT_ID_KEY => recurringGift.Id,
                PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY => PORTAL_CONST_OnlineGiving.RECURRING_TYPE,
                PORTAL_OnlineGivingControllerBase.EXTERNAL_SYSTEM_ID => 'PORT-recur'
            });
            Test.stopTest();

            // triggers don't work in tests, so the DML Command Event won't even create the rtv2
        }

        public virtual void testCreateReviewTransactionWithBenefits() {
            Campaign appeal = new Campaign();
            appeal.ucinn_ascendv2__Motivation_Code__c = '123appeal';
            appeal.Name = 'testappeal';
            insert appeal;

            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');

            Map<String, Object> params = new Map<String, Object>();

            try {
                controller.createReviewTransaction(params); //for validating gift type
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE);

            try {
                controller.createReviewTransaction(params); //for validating payment Id
            } catch(Exception e) {}

            params.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, 'testPaymentId');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '-10.11');

            try {
                controller.createReviewTransaction(params); //for validating Amount
            } catch(Exception e) {}


            params.put('tributeInformation', new Map<String, Object>{'ucinn_ascendv2__Tribute_Type_1__c' => 'In Honor Of'});
            params.put('stripeBillingInformation', new Map<String, Object>{'test' => 'test'});
            params.put('pageSectionName', 'nonExistantPage');
            params.put('PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY', '1');
            params.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, '10.11');
            params.put(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY, new Map<String, Object>{'test' => 'test', 'isGivingAsOrg' => false});
            params.put(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY, new List<Map<Object, Object>>{new Map<Object, Object>{'Name'=> 'test Designation', 'amount'=> 10.11}});
            params.put('appealCode', 'test Appeal');
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_ANNIVERSERY_DATE, String.valueOf(Date.today() + 365));
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_EXPIRATION_DATE, String.valueof(Date.today() + 30));
            params.put('membershipExternalId', 'testMemberId');
            params.put(PORTAL_MembershipControllerBase.APPEAL_CONST, appeal.Id);

            controller.createReviewTransaction(params); //for subscription flow

            params.put(PORTAL_CONST_OnlineGiving.GIFT_TYPE_KEY, PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE);
            List<Map<String,Object>> membershipBenefitsList = new List<Map<String,Object>>();
            membershipBenefitsList.add(new Map<String,Object>{'benefitDescription' => 'benefit description', 'benefitName' => 'test benefitName', PORTAL_MembershipControllerBase.BENEFIT_AMOUNT => 50});
            params.put(PORTAL_MembershipControllerBase.MEMBERSHIP_BENEFIT_RECORDS, membershipBenefitsList);

            controller.createReviewTransaction(params); //for payment flow
        }

        public virtual void testGetPledgeFirstPaymentAmount() {
            PORTAL_PaymentHubControllerBase controller = new PORTAL_PaymentHubControllerBase('test');
            Assert.areEqual(null, controller.getPledgeFirstPaymentAmount(null, null));
            Assert.areEqual(null, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 30}}, 0));

            Assert.areEqual(16.67, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 200}}, 12));
            Assert.areEqual(1.34, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 5.34}}, 4));
            Assert.areEqual(1.34, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 5.38}}, 4));
            Assert.areEqual(20.02, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 200.20}}, 10));
            Assert.areEqual(20, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 200}}, 10));

            Assert.areEqual(16.67, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 200}}, 12));
            Assert.areEqual(16.68, controller.getPledgeFirstPaymentAmount(new List<Map<String, Object>>{new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 66.68},
                                                                                                        new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 66.66},
                                                                                                        new Map<String, Object>{PORTAL_CONST_OnlineGiving.AMOUNT_KEY => 66.66}
                                                                         }, 12));
        }
    }

    static testMethod void testConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testConstructor();
    }

    static testMethod void testGetOrigin() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testGetOrigin();
    }

    static testMethod void testGetApiKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testGetApiKey();
    }

    static testMethod void testCreateReviewTransaction() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testCreateReviewTransaction();
    }

    static testMethod void testPopulateBillingInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateBillingInformation();
    }

    static testMethod void testPopulateOrganizationalGivingInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateOrganizationalGivingInformation();
    }

    static testMethod void testPopulateGiftType() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateGiftType();
    }

    static testMethod void testPopulateAdditionalDetails() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateAdditionalDetails();
    }

    static testMethod void testPopulateMatchingCompany() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateMatchingCompany();
    }

    static testMethod void testPopulateDtdDonationInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateDtdDonationInformation();
    }

    static testMethod void testSendGiftReceipt() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testSendGiftReceipt();
    }

    static testMethod void testGetSpreedlyTransactionTokenOneTimePayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testGetSpreedlyTransactionTokenOneTimePayment();
    }

    static testMethod void testPopulateOrganizationalGivingInformationAdditionalInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testPopulateOrganizationalGivingInformationAdditionalInfo();
    }

    static testMethod void testGetRecaptchaOption() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testGetRecaptchaOption();
    }

    static testMethod void testCancelSubscription() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testCancelSubscription();
    }

    static testMethod void testPopulateMembershipBenefits() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testCreateReviewTransactionWithBenefits();
    }

    /**
     * @author Jacob Huang
     * @since 1.15
     */
    static testMethod void testGetPledgeFirstPaymentAmount() {
        PORTAL_TestClassFactory.getTestClassFactory().getPaymentHubControllerBaseTestClass().testGetPledgeFirstPaymentAmount();
    }
}