@isTest
global class PORTAL_VF_YearEndTaxReceiptTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public Account acct;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            ucinn_ascendv2__Bypass_Settings__c bypassSettings = ucinn_ascendv2__Bypass_Settings__c.getInstance();
            bypassSettings.ucinn_ascendv2__Bypass_Process_Builders__c = true;
            bypassSettings.ucinn_ascendv2__Bypass_Triggers__c = true;
            bypassSettings.ucinn_ascendv2__Bypass_Validation_Rules__c = true;
            bypassSettings.ucinn_ascendv2__Bypass_Workflows__c = true;
            bypassSettings = (ucinn_ascendv2__Bypass_Settings__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => bypassSettings});
            insert bypassSettings;

            System.runAs(thisUser) {

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(
                    FirstName= 'Daniel',
                    LastName = 'Test_Contact',
                    AccountId = acct.Id,
                    Email = 'testCommunityUsermig123@test.com'
                );
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

                // address info
                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(
                    ucinn_ascendv2__Address_Line_1__c = '1',
                    ucinn_ascendv2__Address_Line_2__c = '2',
                    ucinn_ascendv2__Address_Line_3__c = '3',
                    ucinn_ascendv2__Address_Line_4__c = '4',
                    ucinn_ascendv2__City__c = 'Irvine',
                    ucinn_ascendv2__State__c = 'California',
                    ucinn_ascendv2__Postal_Code__c = '92618'
                );
                address = (ucinn_ascendv2__Address__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => address});
                insert address;

                Id consttiuentAddress = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName()
                        .get('Contact_Address_Relation').getRecordTypeId();

                ucinn_ascendv2__Address_Relation__c addressRelation = new ucinn_ascendv2__Address_Relation__c(
                    Name = 'test',
                    ucinn_ascendv2__Address__c = address.Id,
                    ucinn_ascendv2__Contact__c = con.Id,
                    ucinn_ascendv2__Status__c = 'Current',
                    ucinn_ascendv2__Type__c = 'Home',
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Start_Date__c = Date.parse('10/10/10'),
                    ucinn_ascendv2__End_Date__c = Date.parse('11/11/2099'),
                    RecordTypeId = consttiuentAddress
                );
                addressRelation = (ucinn_ascendv2__Address_Relation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => addressRelation});
                insert addressRelation;
            }
        }

        public virtual void yearEndTaxLetterTest() {
            setupData();

            RecordType giftOppRecordType = [SELECT Id, Name, Description ,DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Gift'];

            Opportunity opp = new Opportunity(
                Name = 'Gift',
                StageName = 'Active',
                Amount = 1000,
                CloseDate = Date.parse('10/10/2040'),
                AccountId = acct.Id,
                RecordTypeId = giftOppRecordType.Id,
                ucinn_portal_Is_Display_On_Portal__c = true,
                ucinn_ascendv2__Contact__c = con.Id,
                ucinn_ascendv2__Original_Proposal_ID__c = '12354Test'
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

            ucinn_ascendv2__Designation_Detail__c designDetail = new ucinn_ascendv2__Designation_Detail__c(
                ucinn_ascendv2__Opportunity__c = opp.Id,
                ucinn_portal_Is_Display_On_Portal__c = true
            );
            designDetail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designDetail});
            insert designDetail;

            ucinn_ascendv2__Payment__c  payment1 = new ucinn_ascendv2__Payment__c(
                Name = 'Test',
                ucinn_ascendv2__Tender_Type_for_Gifts__c = 'Stock Gift',
                ucinn_ascendv2__Credit_Date__c = Date.today(),
                ucinn_ascendv2__Contact__c = con.Id,
                ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                ucinn_ascendv2__Opportunity__c = opp.Id,
                ucinn_ascendv2__Payment_Amount__c = 2500,
                ucinn_ascendv2__Status__c = 'Paid'
            );
            payment1 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment1});
            insert payment1;

            ucinn_portal_Content_Page__c contentPage = new ucinn_portal_Content_Page__c(
                Name = 'Year end Receipt Page'
            );
            contentPage = (ucinn_portal_Content_Page__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentPage});
            insert contentPage;

            ucinn_portal_Content_Module__c contentModule = new ucinn_portal_Content_Module__c(
                Name = 'Receipt Info',
                Content_Module_Metadata__c = '{"imageName":"Year_end_receipt_top_logo","imageAltText":"Sample alt text","addressInfo":"<div>UC Innovation</div><div>2855 Michelle Dr Suite 190</div><div>Irvine, CA 92606</div><div>Test</div>","preTableText":"<p>Dear -!salutation- -!lastName-</p><p>Thank you for your support of the UC Innovation\'s Portal Team</p>"}',
                Content_Page__c = contentPage.Id
            );
            contentModule = (ucinn_portal_Content_Module__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentModule});
            insert contentModule;

            PageReference YearEndReceiptPage = Page.PORTAL_YearEndTaxReceipt;
            YearEndReceiptPage.getParameters().put(PORTAL_VF_YearEndTaxReceipt.CONTACT_ID_URL_PARAM, con.Id);
            YearEndReceiptPage.getParameters().put(PORTAL_VF_YearEndTaxReceipt.CONTENT_PAGE_NAME_URL_PARAM, 'Year end Receipt Page');
            YearEndReceiptPage.getParameters().put(PORTAL_VF_YearEndTaxReceipt.CALENDAR_YEAR_URL_PARAM, '2020');

            Test.setCurrentPage(YearEndReceiptPage);

            Test.startTest();

            System.runAs(communityUser) {
                PORTAL_VF_YearEndTaxReceipt yearEndReceiptController = new PORTAL_VF_YearEndTaxReceipt();
            }

            Test.stopTest();
        }
    }

    @isTest
    static void yearEndTaxLetterTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getVF_YearEndTaxReceiptTestClass().yearEndTaxLetterTest();
    }
}