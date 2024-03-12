@isTest
public with sharing class PORTAL_TRIG_ActionOnContentHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testTrigger() {
            System.runAs(thisUser) {
                Id profileId = [SELECT Id FROM Profile WHERE Name=: 'System Administrator'].Id;

                User communityUser = new User(alias = 'comUser',
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


                ucinn_portal_Listing__c testListing8 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                    Recommend_Type_2__c = 'Culture',
                                                                                    Recommend_Type_3__c = 'Global',
                                                                                    Recommend_Type_4__c = 'History',
                                                                                    Recommend_Type_5__c = 'Space',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Name = 'testListing8');
                testListing8 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing8});
                insert testListing8;

                ucinn_portal_Listing__c testListing9 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Medicine',
                                                                                    Recommend_Type_2__c = 'History',
                                                                                    Recommend_Type_3__c = 'Space',
                                                                                    Recommend_Type_4__c = 'Law',
                                                                                    Recommend_Type_5__c = 'Culture',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Name = 'testListing9');
                testListing9 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing9});
                insert testListing9;

                List<ucinn_portal_Listing__c> listingItemList = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c];
                for (Integer index = 0; index < listingItemList.size(); index++) {
                    ucinn_portal_Listing__c eachListing = listingItemList.get(index);
                    PORTAL_ActionOnContentController.upsertActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => communityUser.Id,
                                                                            PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => 'Not Guest',
                                                                            PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY => eachListing,
                                                                            PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
                                                                            PORTAL_ActionOnContentController.SERVER_timeTrack(new Map<String, Object>{PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY => eachListing.Id, PORTAL_ActionOnContentBase.TIME_DIFFERENCE_KEY => 100+(index*100), PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
                }
                List<ucinn_portal_Action_On_Content__c> actionOnContentList = [SELECT Id, User__c FROM ucinn_portal_Action_On_Content__c];
                PORTAL_TRIG_ActionOnContentHandler.updateUserRecommendation(actionOnContentList);
            }
        }
        
        public virtual void testRun() {
            List<sObject> oldList = new List<sObject>();
            List<sObject> newList = new List<sObject>();

            Test.startTest();

            new PORTAL_TRIG_ActionOnContentHandler().run(newList,
                                                        oldList,
                                                        ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                        ucinn_portal_Action_On_Content__c.getSObjectType().getDescribe());

            Test.stopTest();
        }
    }

    @isTest
    public static void testTrigger() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ActionOnContentHandlerTestClass().testTrigger();
    }

    @isTest
    public static void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ActionOnContentHandlerTestClass().testRun();
    }
}