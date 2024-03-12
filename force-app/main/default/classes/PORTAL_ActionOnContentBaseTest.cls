@isTest
public with sharing class PORTAL_ActionOnContentBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public String ipAddress = '287.854.13.33';
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'System Administrator'].id;
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
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testPortalUsermig123@test.com',
                                        ucinn_portal_Recommend_Type_1__c = 'Law',
                                        ucinn_portal_Recommend_Type_2__c = 'Culture',
                                        ucinn_portal_Recommend_Type_3__c = 'Global',
                                        ucinn_portal_Open_Possibility_For_Type_1__c = .5,
                                        ucinn_portal_Open_Possibility_For_Type_2__c = .24,
                                        ucinn_portal_Open_Possibility_For_Type_3__c = .33,
                                        ucinn_Weight_For_Number_Of_Content__c = .67,
                                        ucinn_portal_Weight_For_Times_Commented__c = .45,
                                        ucinn_portal_Weight_For_Time_Spent__c = .8,
                                        ucinn_portal_Weight_For_Times_Viewed__c = .5);
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;
            }

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();

            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                Recommend_Type_2__c = 'Culture',
                                                                                Recommend_Type_3__c = 'Global',
                                                                                Recommend_Type_4__c = 'History',
                                                                                Recommend_Type_5__c = 'Space',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'a');
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;

            ucinn_portal_Listing__c testListing1 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                    Recommend_Type_2__c = 'Culture',
                                                                                    Recommend_Type_3__c = 'Global',
                                                                                    Recommend_Type_4__c = 'History',
                                                                                    Recommend_Type_5__c = 'Space',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Name = 'b');
            testListing1 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing1});
            insert testListing1;

            ucinn_portal_Listing__c testListing2 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                Recommend_Type_2__c = 'Culture',
                                                                                Recommend_Type_3__c = 'Global',
                                                                                Recommend_Type_4__c = 'History',
                                                                                Recommend_Type_5__c = 'Space',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'c');
            testListing2 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing2});
            insert testListing2;

            ucinn_portal_Listing__c testListing3 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Medicine',
                                                                                Recommend_Type_2__c = 'History',
                                                                                Recommend_Type_3__c = 'Space',
                                                                                Recommend_Type_4__c = 'Law',
                                                                                Recommend_Type_5__c = 'Culture',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'ab');
            testListing3 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing3});
            insert testListing3;

            ucinn_portal_Listing__c testListing4 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                    Recommend_Type_2__c = 'Culture',
                                                                    Recommend_Type_3__c = 'Global',
                                                                    Recommend_Type_4__c = 'History',
                                                                    Recommend_Type_5__c = 'Space',
                                                                    RecordTypeId = recordTypeId,
                                                                    Portal_Zone__c = 'All',
                                                                    Name = 'testListing4');
            testListing4 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing4});
            insert testListing4;

            ucinn_portal_Listing__c testListing5 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                    Recommend_Type_2__c = 'Culture',
                                                                                    Recommend_Type_3__c = 'Global',
                                                                                    Recommend_Type_4__c = 'History',
                                                                                    Recommend_Type_5__c = 'Space',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Name = 'testListing5');
            testListing5 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing5});
            insert testListing5;

            ucinn_portal_Listing__c testListing6 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                Recommend_Type_2__c = 'Culture',
                                                                                Recommend_Type_3__c = 'Global',
                                                                                Recommend_Type_4__c = 'History',
                                                                                Recommend_Type_5__c = 'Space',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'testListing6');
            testListing6 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing6});
            insert testListing6;

            ucinn_portal_Listing__c testListing7 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Medicine',
                                                                                Recommend_Type_2__c = 'History',
                                                                                Recommend_Type_3__c = 'Space',
                                                                                Recommend_Type_4__c = 'Law',
                                                                                Recommend_Type_5__c = 'Culture',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'testListing7');
            testListing7 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing7});
            insert testListing7;


        }

        public virtual void upsertRecommendedContent() {

            setupData();

            List<ucinn_portal_Listing__c> listingItemList = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c];
            List<String> listingIdList = new List<String>();
            for (ucinn_portal_Listing__c listing : listingItemList) {
                listingIdList.add(String.valueOf(listing.Id));
            }
            new PORTAL_ActionOnContentBase().upsertRecommendedContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id,
                                                                                        PORTAL_ActionOnContentBase.LISTING_ID_LIST_KEY => listingIdList,
                                                                                        PORTAL_ActionOnContentBase.RECOMMENDED_TYPE_KEY => 'Law',
                                                                                        PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            new PORTAL_ActionOnContentBase().upsertRecommendedContent(new Map<String, Object>());
        }

        public virtual void getNumOfReccomendationTest() {
            setupData();
            new PORTAL_ActionOnContentBase().getNumOfRecommendation(new Map<String, Object>());
            new PORTAL_ActionOnContentBase().getNumOfRecommendation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => PORTAL_CONST_ActionOnContent.GUEST_USER_TYPE});
            new PORTAL_ActionOnContentBase().getNumOfRecommendation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => 'Authenticated'});
        }

        public virtual void recommendationEnabledTest() {
            setupData();
            new PORTAL_ActionOnContentBase().recommendationEnabled(PORTAL_CONST_ActionOnContent.GUEST_USER_TYPE);
            new PORTAL_ActionOnContentBase().recommendationEnabled('Authenticated');
        }

        public virtual void timeTrackTest() {
            setupData();
            List<ucinn_portal_Listing__c> listingItemList = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c];

            String listingId = listingItemList[0].Id;
            String listingName = listingItemList[0].Name;
            String identifier =  listingId + communityUser.Id;

            ucinn_portal_Action_On_Content__c action1 = new ucinn_portal_Action_On_Content__c(
                Listing__c = listingId,
                User__c = communityUser.Id,
                Time_Spent__c = 23,
                Reference_ID__c = identifier
            );
            action1 = (ucinn_portal_Action_On_Content__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => action1});
            insert action1;

            System.runAs(communityUser){
                new PORTAL_ActionOnContentBase().timeTrack(new Map<String, Object>{PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY => listingId, PORTAL_ActionOnContentBase.TIME_DIFFERENCE_KEY => 52300000, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
                new PORTAL_ActionOnContentBase().timeTrackByName(new Map<String, Object>{PORTAL_ActionOnContentBase.CONTENT_NAME_KEY => listingName, PORTAL_ActionOnContentBase.TIME_DIFFERENCE_KEY => 52300000, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            }
        }

        public virtual void createActionOnContentTest() {

            setupData();

            List<ucinn_portal_Listing__c> listingItemList = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c];
            new PORTAL_ActionOnContentBase().createActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id, PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY => listingItemList[0], PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});

        }

        public virtual void upsertActionOnContentTest() {
            setupData();

            List<ucinn_portal_Listing__c> listingItemList = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c];

            ucinn_portal_Listing__c listing = listingItemList[0];
            String listingId = listing.Id;
            String identifier = listingId  + communityUser.Id;

            new PORTAL_ActionOnContentBase().upsertActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id,
                                                                                            PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => 'Not Guest',
                                                                                            PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY => listing,
                                                                                            PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            new PORTAL_ActionOnContentBase().upsertActionOnContent(new Map<String, Object>());

        }

        public virtual void ranRecommendationCalculationTest() {
            setupData();
            PORTAL_ActionOnContentController.SERVER_runRecommendationCalculation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => 'a23123'});
            PORTAL_ActionOnContentController.SERVER_runRecommendationCalculation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id});
            List<ucinn_portal_Listing__c> listingItemList = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c];
            for (Integer index = 0; index < listingItemList.size(); index++) {
                ucinn_portal_Listing__c eachListing = listingItemList.get(index);
                PORTAL_ActionOnContentController.upsertActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id,
                    PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => 'Not Guest',
                    PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY => eachListing,
                    PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
                    new PORTAL_ActionOnContentBase().timeTrack(new Map<String, Object>{PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY => eachListing.Id, PORTAL_ActionOnContentBase.TIME_DIFFERENCE_KEY => 100+(index*100), PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            }
            List<ucinn_portal_Action_On_Content__c> actionOnContentList = [SELECT Id, Listing__c FROM ucinn_portal_Action_On_Content__c WHERE User__c = :communityUser.Id];
            Map<Id, ucinn_portal_Listing__c> listingIdMap = new Map<Id, ucinn_portal_Listing__c>(listingItemList);
            for (Integer index = 0; index < actionOnContentList.size(); index++) {
                if (index <= 3) {
                    actionOnContentList.get(index).Is_Possibility_Processed__c = true;
                    actionOnContentList.get(index).Is_Adjustment_Processed__c = false;
                } else if (index > 3) {
                    actionOnContentList.get(index).Is_Possibility_Processed__c = false;
                    if (index > 5) {
                        actionOnContentList.get(index).Is_Recommended_To__c = true;
                        actionOnContentList.get(index).Recommendation_Type__c = listingIdMap.get(actionOnContentList.get(index).Listing__c).Recommend_Type_1__c;
                    }
                }
            }
            update actionOnContentList;
            new PORTAL_ActionOnContentBase().runRecommendationCalculation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id});
            new PORTAL_ActionOnContentBase().runRecommendationCalculation(new Map<String, Object>());
        }

        public virtual void testGetReferenceId() {
            try {
                new PORTAL_ActionOnContentBase().getReferenceId(null, null, null, null);
            } catch (Exception e) {

            }
            try {
                new PORTAL_ActionOnContentBase().getReferenceId('id', 'Guest', null, null);
            } catch (Exception e) {

            }
            try {
                new PORTAL_ActionOnContentBase().getReferenceId('id', 'Guest', null, '234.535.3423');
            } catch (Exception e) {

            }
            try {
                new PORTAL_ActionOnContentBase().getReferenceId('id', 'Not Guest', null, '234.535.3423');
            } catch (Exception e) {

            }
            try {
                new PORTAL_ActionOnContentBase().getReferenceId('id', 'Not Guest', 'id', '234.535.3423');
            } catch (Exception e) {

            }
        }
    }

    @isTest
    public static void upsertRecommendedContent() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().upsertRecommendedContent();
    }

    @isTest
    public static void getNumOfReccomendationTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().getNumOfReccomendationTest();
    }

    @isTest
    public static void recommendationEnabledTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().recommendationEnabledTest();
    }

    @isTest
    public static void timeTrackTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().timeTrackTest();
    }

    @isTest
    public static void createActionOnContentTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().createActionOnContentTest();
    }

    @isTest
    public static void upsertActionOnContentTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().upsertActionOnContentTest();
    }

    @isTest
    public static void ranRecommendationCalculationTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().ranRecommendationCalculationTest();
    }

    @isTest
    public static void testGetReferenceId() {
        PORTAL_TestClassFactory.getTestClassFactory().getActionOnContentBaseTestClass().testGetReferenceId();
    }
}