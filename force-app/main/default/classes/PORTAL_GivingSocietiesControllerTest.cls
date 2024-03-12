// Test methods for controller methods in the giving socities sprint
@isTest
global without sharing class PORTAL_GivingSocietiesControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setup() {
            System.runAs(thisUser) {
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
            }
        }

        public virtual void SERVER_getGivingSocietyDetailPageTest() {
            try {
                PORTAL_GivingSocietiesDetailPage.SERVER_getGivingSocietyDetailPage(new Map<String, Object>());
            }
            catch (Exception e){

            }

            try{
                PORTAL_GivingSocietiesDetailPage.SERVER_getGivingSocietyDetailPage(new Map<String, Object>{PORTAL_GivingSocietiesControllerBase.GIVING_SOCITIES_NAME => 'Test'});
            }
            catch (Exception e) {

            }

            try{
                PORTAL_GivingSocietiesDetailPage.SERVER_getGivingSocietyDetailPage(new Map<String, Object>{PORTAL_GivingSocietiesControllerBase.GIVING_SOCITIES_NAME => true});
            }
            catch (Exception e) {

            }
        }


        public virtual void SERVER_getGivingSocietiesListTest() {
            PORTAL_GivingSocietiesListController.SERVER_getGivingSocietiesList(new Map<String, Object>());

            // invalid string, throws an exception
            try {
                PORTAL_GivingSocietiesListController.SERVER_getGivingSocietiesList(new Map<String, Object>{'nameSearch' => true});
            }
            catch (Exception e) {

            }

            // invalid query, throws GivingSocietiesException
            try {
                PORTAL_GivingSocietiesListController.SERVER_getGivingSocietiesList(new Map<String, Object>{'nameSearch' => 'Test\'=etest'});
            }
            catch (Exception e) {

            }
        }

        public virtual void SERVER_getSocietyMembershipTableDataTest() {
            setup();

            try {
                PORTAL_SocietyMembershipTableController.SERVER_getSocietyMembershipTableData(new Map<String, Object>());
            }
            catch (Exception e) {

            }

            System.runAs(communityUser) {
                PORTAL_SocietyMembershipTableController.SERVER_getSocietyMembershipTableData(new Map<String, Object>{
                    'annualMembershipRenewGivingSettingsName' => 'test',
                    'annualMembershipElevateGivingSettingsName' => 'test',
                    'lifetimeMembershipGivingSettingsName' => 'test',
                    'inactiveMembershipGivingSettingsName' => 'inactiveMembershipGivingSettingsName'
                });
            }
            
        }

        public virtual void testGetSocietyMembershipTableDataInvalidInput() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            Account acct = new Account(name = 'Test_Account') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUserf14@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            User comUser = new User(alias = 'testUser',
                                    email = 'testCommunityUserf14@test.com',
                                    emailencodingkey='UTF-8',
                                    lastname = 'Batman',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = profileId,
                                    contactId = con.Id,
                                    IsActive = true,
                                    timezonesidkey='America/Los_Angeles',
                                    username = System.now().millisecond() + 'testCommunityUserf14@test.com');
            comUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => comUser});
            insert comUser;

            Test.startTest();

            try {
                System.runAs(comUser) {
                    PORTAL_SocietyMembershipTableController.SERVER_getSocietyMembershipTableData(null);
                }
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }


        public virtual void SERVER_getDonorStories() {
            try {
                PORTAL_DonorStoriesController.SERVER_getDonorStories(new Map<String, Object>());
            }
            catch(Exception e) {

            }

            PORTAL_DonorStoriesController.SERVER_getDonorStories(new Map<String, Object>{'numOfItemsToShow' => 3});

            try {
                PORTAL_DonorStoriesController.throwError = true;
                PORTAL_DonorStoriesController.SERVER_getDonorStories(new Map<String, Object>{PORTAL_GivingSocietiesControllerBase.GIVING_SOCITIES_NAME => 'te\'test'});
            }
            catch (Exception e) {

            }

        }

        public virtual void SERVER_getDonorStoryDetailTest() {
            try {
                PORTAL_DonorStoryDetailController.SERVER_getDonorStoryDetail(new Map<String, Object>());
            }
            catch (Exception e) {

            }

            PORTAL_DonorStoryDetailController.SERVER_getDonorStoryDetail(new Map<String, Object>{'donorStoryName' => 'test'});

            try {
                PORTAL_DonorStoryDetailController.throwError = true;
                PORTAL_DonorStoryDetailController.SERVER_getDonorStoryDetail(new Map<String, Object>{'donorStoryName' => 'tes\'t'});
            }
            catch (Exception e) {

            }
        }


        public virtual void SERVER_isConstituentInGivingSocietiesTest() {
            try {
                PORTAL_GivingSocietiesBannerController.SERVER_isConstituentInGivingSocieties(new Map<String, Object>{PORTAL_GivingSocietiesControllerBase.GIVING_SOCITIES_NAME => 'Te\'st'});
            }
            catch (Exception e) {

            }

            PORTAL_GivingSocietiesBannerController.SERVER_isConstituentInGivingSocieties(new Map<String, Object>());

            try {
                PORTAL_GivingSocietiesBannerController.throwError = true;
                PORTAL_GivingSocietiesBannerController.SERVER_isConstituentInGivingSocieties(new Map<String, Object>());
            }
            catch (Exception e) {

            }

        }

    }


    @isTest
    static void SERVER_getGivingSocietyDetailPageTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().SERVER_getGivingSocietyDetailPageTest();
    }

    @isTest
    static void SERVER_getGivingSocietiesListTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().SERVER_getGivingSocietiesListTest();
    }

    @isTest
    static void SERVER_getSocietyMembershipTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().SERVER_getSocietyMembershipTableDataTest();
    }

    @isTest
    static void testGetSocietyMembershipTableDataInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().testGetSocietyMembershipTableDataInvalidInput();
    }

    @isTest
    static void SERVER_getDonorStories() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().SERVER_getDonorStories();
    }

    @isTest
    static void SERVER_getDonorStoryDetailTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().SERVER_getDonorStoryDetailTest();
    }

    @isTest
    static void SERVER_isConstituentInGivingSocietiesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerTestClass().SERVER_isConstituentInGivingSocietiesTest();
    }
}