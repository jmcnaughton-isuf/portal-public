@isTest
global class PORTAL_MyGivingHistoryControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public PORTAL_MyGivingHistoryControllerBase baseController;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            System.runAs(thisUser) {
                // create contact
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'DanielTest',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = con.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = 'testCommunityUsermig123!@test.com',
                                        ucinn_portal_Recommend_Type_1__c = 'Law',
                                        ucinn_portal_Recommend_Type_2__c = 'Culture',
                                        ucinn_portal_Recommend_Type_3__c = 'Global');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                Date today = Date.today();
                RecordType giftOppRecordType = [SELECT Id, Name, Description ,DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Pledge'];

                System.runAs(communityUser) {
                    baseController = new PORTAL_MyGivingHistoryControllerBase();
                }

                Opportunity opp = new Opportunity(
                    Name = 'Pledge',
                    StageName = 'Active',
                    Amount = 1000,
                    CloseDate = Date.parse('10/10/2040'),
                    AccountId = acct.Id,
                    RecordTypeId = giftOppRecordType.Id,
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Contact__c = con.Id
                );
                opp = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp});
                insert opp;

                ucinn_ascendv2__Designation__c designation1 = new ucinn_ascendv2__Designation__c(
                    Name = 'Athletics',
                    ucinn_ascendv2__Designation_Name__c  = 'Athletics',
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                designation1 = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation1});
                insert designation1;

                ucinn_ascendv2__Designation__c designation2 = new ucinn_ascendv2__Designation__c(
                    Name = 'Water polo',
                    ucinn_ascendv2__Designation_Name__c  = 'Water polo',
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                designation2 = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation2});
                insert designation2;

                ucinn_ascendv2__Designation_Detail__c designDetail = new ucinn_ascendv2__Designation_Detail__c(
                    ucinn_ascendv2__Opportunity__c = opp.Id,
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                designDetail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designDetail});
                insert designDetail;


                ucinn_ascendv2__Installment__c installment1 = new ucinn_ascendv2__Installment__c(
                    ucinn_ascendv2__Opportunity__c = opp.Id,
                    ucinn_ascendv2__Amount__c = 500,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id
                );
                installment1 = (ucinn_ascendv2__Installment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => installment1});
                insert installment1;

                ucinn_ascendv2__Payment__c  payment1 = new ucinn_ascendv2__Payment__c(
                    ucinn_ascendv2__Transaction_Type__c = 'Pledge Payment',
                    ucinn_ascendv2__Credit_Date__c = today,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Opportunity__c = opp.Id
                );
                payment1 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment1});
                insert payment1;

                ucinn_ascendv2__Payment__c  payment2 = new ucinn_ascendv2__Payment__c(
                    ucinn_ascendv2__Transaction_Type__c = 'Gift',
                    ucinn_ascendv2__Credit_Date__c = today,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Opportunity__c = opp.Id
                );
                payment2 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment2});
                insert payment2;

                // create data
                ucinn_ascendv2__Hard_and_Soft_Credit__c hnsCredit1 = new ucinn_ascendv2__Hard_and_Soft_Credit__c(
                    ucinn_ascendv2__Credit_Type__c = 'Hard',
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Payment__c = payment1.Id,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Credit_Amount__c = 2500,
                    ucinn_ascendv2__Designation__c  = designation1.Id
                );
                hnsCredit1 = (ucinn_ascendv2__Hard_and_Soft_Credit__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => hnsCredit1});
                insert hnsCredit1;

                ucinn_ascendv2__Hard_and_Soft_Credit__c hnsCredit2 = new ucinn_ascendv2__Hard_and_Soft_Credit__c(
                    ucinn_ascendv2__Credit_Type__c = 'Hard',
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Payment__c = payment2.Id,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Credit_Amount__c = 2500,
                    ucinn_ascendv2__Designation__c  = designation2.Id
                );
                hnsCredit2 = (ucinn_ascendv2__Hard_and_Soft_Credit__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => hnsCredit2});
                insert hnsCredit2;

                ucinn_ascendv2__Hard_and_Soft_Credit__c hnsCredit3 = new ucinn_ascendv2__Hard_and_Soft_Credit__c(
                    ucinn_ascendv2__Credit_Type__c = 'Hard',
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Payment__c = payment1.Id,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Credit_Amount__c = 2500,
                    ucinn_ascendv2__Designation__c  = designation2.Id
                );
                hnsCredit3 = (ucinn_ascendv2__Hard_and_Soft_Credit__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => hnsCredit3});
                insert hnsCredit3;

                RecordType recurringGiftOppRecordType = [SELECT Id, Name, Description ,DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Recurring_Gift'];

                // recurring gift info
                Opportunity opp2 = new Opportunity(
                    Name = 'Recurring Gift',
                    StageName = 'Active',
                    Amount = 1000,
                    CloseDate = Date.parse('10/10/2040'),
                    AccountId = acct.Id,
                    RecordTypeId = recurringGiftOppRecordType.Id,
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Contact__c = con.Id,
                    Type = 'Recurring',
                    ucinn_ascendv2__Frequency__c = 'Weekly',
                    ucinn_ascendv2__Start_Date__c = today,
                    ucinn_ascendv2__End_Date__c = Date.today().addYears(10)
                );
                opp2 = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp2});
                insert opp2;

                ucinn_ascendv2__Designation_Detail__c designDetail2 = new ucinn_ascendv2__Designation_Detail__c(
                    ucinn_ascendv2__Opportunity__c = opp2.Id,
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                designDetail2 = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designDetail2});
                insert designDetail2;

                ucinn_ascendv2__Payment__c  payment4 = new ucinn_ascendv2__Payment__c(
                    ucinn_ascendv2__Transaction_Type__c = 'Gift',
                    ucinn_ascendv2__Credit_Date__c = today,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail2.Id,
                    ucinn_ascendv2__Opportunity__c = opp.Id,
                    ucinn_ascendv2__Amount_Paid_to_Date__c = 250000
                );
                payment4 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment4});
                insert payment4;

                // paid payments
                ucinn_ascendv2__Payment__c  payment5 = new ucinn_ascendv2__Payment__c(
                    ucinn_ascendv2__Transaction_Type__c = 'Pledge Payment',
                    ucinn_ascendv2__Credit_Date__c = today,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Opportunity__c = opp.Id,
                    ucinn_ascendv2__Status__c = 'Paid',
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                payment5 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment5});
                insert payment5;

                ucinn_ascendv2__Payment__c  payment6 = new ucinn_ascendv2__Payment__c(
                    ucinn_ascendv2__Transaction_Type__c = 'Gift',
                    ucinn_ascendv2__Credit_Date__c = today,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Opportunity__c = opp.Id,
                    ucinn_ascendv2__Status__c = 'Paid',
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                payment6 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment6});
                insert payment6;
            }
        }


        public virtual void getFiscalYearTableDataTest() {
            setupData();
            baseController.getFiscalYearTableData(new Map<String, Object>{'hideEmptyRows' => true, 'fiscalYearOrder' => 'Ascending'});
        }


        public virtual void getPieChartDataTest() {
            setupData();
            baseController.getPieChartData(new Map<String, Object>{'maxDesignations' => 1});
        }


        public virtual void getGivingHistoryTableDataTest() {
            setupData();
            baseController.getGivingHistoryTableData(new Map<String, Object>{'itemsPerPage' => 5, 'offset' => 0, 'receiptBaseURL' => 'RECEIPT_URL', 'receiptContentPageName' => 'Page_NAME'});
        }


        public virtual void getPledgeTableDataTest() {
            setupData();
            baseController.getPledgeTableData(new Map<String, Object>{'itemsPerPage' => 5, 'offset' => 0, 'showUpdateCreditCard' => true, 'paymentMethod' => 'Test'});
        }


        public virtual void getRecurringGiftTableDataTest() {
            setupData();
            baseController.getRecurringGiftTableData(new Map<String, Object>{'itemsPerPage' => 5, 'offset' => 0, 'showUpdateCreditCard' => false, 'paymentMethod' => 'Test'});
        }


        public virtual void getMatchingGiftTableDataTest() {
            setupData();
            baseController.getMatchingGiftTableData(new Map<String, Object>{'itemsPerPage' => 5, 'offset' => 0});
        }
        
        public virtual void updateSubscriptionCreditCardTest() {
            setupData();
            System.runAs(communityUser) {
                baseController.updateSubscriptionCreditCard(new Map<String, Object>
                {
                    PORTAL_CONST_OnlineGiving.GIFT_ID_KEY => 'gift id',
                    PORTAL_CONST_OnlineGiving.SUBSCRIPTION_ID_KEY => 'subscription id',
                    PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => 'abcdefg',
                    PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'Test',
                    PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_KEY => 'merchant reference code'
                });
            }
        }


        public virtual void getYearlyGivingTableData() {
            setupData();
            baseController.getYearlyGivingTableData(new Map<String, Object>{'receiptBaseURL' => 'BASE_URL', 'receiptContentPageName' => 'BASE_NAME'});
        }
     
        public virtual void testGiftFrequencyConversion() {
            Test.startTest();

            Map<String, Object> result = PORTAL_MyGivingHistoryControllerBase.giftFrequencyConversion(
                new Map<String, Object>{PORTAL_MyGivingHistoryControllerBase.FREQUENCY_KEY => 'Annual'});
            System.assertEquals(12, result.get(PORTAL_MyGivingHistoryControllerBase.FREQUENCY_CONVERSION_MONTHS_KEY));

            Map<String, Object> result2 = PORTAL_MyGivingHistoryControllerBase.giftFrequencyConversion(
                new Map<String, Object>{PORTAL_MyGivingHistoryControllerBase.FREQUENCY_KEY => 'Semi-Annual'});
            System.assertEquals(6, result2.get(PORTAL_MyGivingHistoryControllerBase.FREQUENCY_CONVERSION_MONTHS_KEY));

            Map<String, Object> result3 = PORTAL_MyGivingHistoryControllerBase.giftFrequencyConversion(
                new Map<String, Object>{PORTAL_MyGivingHistoryControllerBase.FREQUENCY_KEY => 'Quarterly'});
            System.assertEquals(3, result3.get(PORTAL_MyGivingHistoryControllerBase.FREQUENCY_CONVERSION_MONTHS_KEY));

            Map<String, Object> result4 = PORTAL_MyGivingHistoryControllerBase.giftFrequencyConversion(
                new Map<String, Object>{PORTAL_MyGivingHistoryControllerBase.FREQUENCY_KEY => 'Monthly'});
            System.assertEquals(1, result4.get(PORTAL_MyGivingHistoryControllerBase.FREQUENCY_CONVERSION_MONTHS_KEY));

            Map<String, Object> result5 = PORTAL_MyGivingHistoryControllerBase.giftFrequencyConversion(
                new Map<String, Object>{PORTAL_MyGivingHistoryControllerBase.FREQUENCY_KEY => 'Bi-Weekly'});
            System.assertEquals(14, result5.get(PORTAL_MyGivingHistoryControllerBase.FREQUENCY_CONVERSION_DAYS_KEY));

            Test.stopTest();
        }

        public virtual void testFormatYearEndTaxLetterTableDataInvalidInput() {
            PORTAL_MyGivingHistoryControllerBase controller = new PORTAL_MyGivingHistoryControllerBase();

            Test.startTest();

            try {
                controller.formatYearEndTaxLetterTableData(new Map<String, Object>{'yearEndTableData' => null});
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    @isTest
    static void getFiscalYearTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getFiscalYearTableDataTest();
    }

    @isTest
    static void getPieChartDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getPieChartDataTest();
    }

    @isTest
    static void getGivingHistoryTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getGivingHistoryTableDataTest();
    }

    @isTest
    static void getPledgeTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getPledgeTableDataTest();
    }

    @isTest
    static void getRecurringGiftTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getRecurringGiftTableDataTest();
    }

    @isTest
    static void getMatchingGiftTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getMatchingGiftTableDataTest();
    }

    @isTest
    static void updateSubscriptionCreditCardTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().updateSubscriptionCreditCardTest();
    }

    @isTest
    static void getYearlyGivingTableData() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().getYearlyGivingTableData();
    }

    @isTest
    static void testGiftFrequencyConversion() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().testGiftFrequencyConversion();
    }

    @isTest
    static void testFormatYearEndTaxLetterTableDataInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyGivingHistoryControllerBaseTestClass().testFormatYearEndTaxLetterTableDataInvalidInput();
    }
}