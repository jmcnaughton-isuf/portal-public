@isTest
public class PORTAL_ListingControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetListings() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();
            controller.getListings(null);

            controller.getListings(new Map<String, Object> {'test' => 'test'});
            controller.getListings(new Map<String, Object> {PORTAL_ListingControllerBase.PAGE_NAME => 'listingTest',
                                                            PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'listingTest'});
            controller.getListings(new Map<String, Object> {PORTAL_ListingControllerBase.PAGE_NAME => 'Events',
                                                            PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'Events Tabs',
                                                            PORTAL_ListingControllerBase.SUB_SECTION_NAME => 'All Events'});
            controller.getListings(new Map<String, Object> {PORTAL_ListingControllerBase.PAGE_NAME => 'Events',
                                                            PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'Events Tabs'});
        }

        public virtual void testRecommendedContentListings() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                User communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = con.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com',
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

                Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('News').getRecordTypeId();

                ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                    Recommend_Type_2__c = 'Culture',
                                                                                    Recommend_Type_3__c = 'Global',
                                                                                    Recommend_Type_4__c = 'History',
                                                                                    Recommend_Type_5__c = 'Space',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Actual_Start_Date_Time__c = '2020-08-09 00:00:00',
                                                                                    Status__c = 'Published',
                                                                                    Name = 'a');
                testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
                insert testListing;


                System.runAs(communityUser) {

                    PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();
                    controller.getListings(new Map<String, Object> {PORTAL_ListingControllerBase.PAGE_NAME => 'News',
                                                                    PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'Recommended News Show All'});
                }
            }
        }

        public virtual void testGetListingButtonText() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();
            controller.getListingButtonText(null);
        }

        public virtual void testGetDynamicQueryForListings() {
            PORTAL_ListingControllerBase.getDynamicQueryForListings(null);
            PORTAL_ListingControllerBase.getDynamicQueryForListings(new Map<String, Object>{'test' => 'test'});
            PORTAL_ListingControllerBase.getDynamicQueryForListings(new Map<String, Object>{PORTAL_ListingControllerBase.LISTING_CONFIGURATIONS => new Map<String, Object>{'test' => 'test'}});
        }

        public virtual void testGetListingConfigurations() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();
            controller.getListingConfigurations(null);
            controller.getListingConfigurations(new Map<String, Object>{'test' => 'test'});
            controller.getListingConfigurations(new Map<String, Object>{PORTAL_ListingControllerBase.PAGE_NAME => 'listing test',
                                                                        PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'listing test',
                                                                        PORTAL_ListingControllerBase.SUB_SECTION_NAME => 'listing test'});
            controller.getListingConfigurations(new Map<String, Object>{PORTAL_ListingControllerBase.PAGE_NAME => 'Events',
                                                                        PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'Events Tabs',
                                                                        PORTAL_ListingControllerBase.SUB_SECTION_NAME => 'All Events'});
        }

        public virtual void testGetListingConfigurationsFromPageSectionSettings() {
            PORTAL_ListingControllerBase.getListingConfigurationsFromPageSectionSettings(null);
            PORTAL_ListingControllerBase.getListingConfigurationsFromPageSectionSettings(new List<Portal_Page_Section_Setting__mdt>{new Portal_Page_Section_Setting__mdt(Listing_Configurations__c = '{}')});
            try {
                PORTAL_ListingControllerBase.getListingConfigurationsFromPageSectionSettings(new List<Portal_Page_Section_Setting__mdt>{new Portal_Page_Section_Setting__mdt(Listing_Configurations__c = 'test')});
            } catch(Exception e) {
                System.debug(e);
            }
        }

        public virtual void testIsUsingRecommendationEngine() {
            PORTAL_ListingControllerBase.isUsingRecommendationEngine(null);
            PORTAL_ListingControllerBase.isUsingRecommendationEngine(new Map<String, Object>{PORTAL_ListingControllerBase.RELEVANCE_KEY => PORTAL_ListingControllerBase.RECOMMENDED_KEY});
            PORTAL_ListingControllerBase.isUsingRecommendationEngine(new Map<String, Object>{PORTAL_ListingControllerBase.RELEVANCE_KEY => 'No'});
        }

        public virtual void testGetListingsScopeClause() {
            PORTAL_ListingControllerBase.getListingsScopeClause(null);
            PORTAL_ListingControllerBase.getListingsScopeClause('All');
            PORTAL_ListingControllerBase.getListingsScopeClause(PORTAL_ListingControllerBase.CURRENT_KEY);
            PORTAL_ListingControllerBase.getListingsScopeClause(PORTAL_ListingControllerBase.PAST_KEY);
        }

        public virtual void testGetListingsPortalZoneClause() {
            PORTAL_ListingControllerBase.getListingsPortalZoneClause(null);
            PORTAL_ListingControllerBase.getListingsPortalZoneClause('Test');
        }

        public virtual void testGetListingsSharingClause() {
            PORTAL_ListingControllerBase.getListingsSharingClause(null, null);
            Contact con = new Contact(LastName = 'Test');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;
            PORTAL_ListingControllerBase.getListingsSharingClause(PORTAL_ListingControllerBase.ME_KEY, new User(ContactId = con.Id));
        }

        public virtual void testGetListingsRelevanceClause() {
            PORTAL_ListingControllerBase.getListingsRelevanceClause(null, null);
            PORTAL_ListingControllerBase.getListingsRelevanceClause(PORTAL_ListingControllerBase.NON_RECOMMENDED, new User());
            PORTAL_ListingControllerBase.getListingsRelevanceClause(PORTAL_ListingControllerBase.NON_RECOMMENDED, new User(ucinn_portal_Recommend_Type_1__c = 'test',
                                                                                                                           ucinn_portal_Recommend_Type_2__c = 'test',
                                                                                                                           ucinn_portal_Recommend_Type_3__c = 'test'));
        }

        public virtual void testGetListingsRadiusClause() {
            PORTAL_ListingControllerBase.getListingsRadiusClause(null, null, null);
            Contact con = new Contact(LastName = 'Test');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;
            PORTAL_ListingControllerBase.getListingsRadiusClause('3', new User(ContactId = con.Id), new Map<Object, Object>{PORTAL_ListingControllerBase.IS_SHOW_ONLINE_EVENTS => true});
        }

        public virtual void testGetListingsAdditionalParamClause() {
            PORTAL_ListingControllerBase.getListingsAdditionalParamClause(null);
            PORTAL_ListingControllerBase.getListingsAdditionalParamClause(new Map<Object, Object>{'test' => 'test'});
            PORTAL_ListingControllerBase.getListingsAdditionalParamClause(new Map<Object, Object>{PORTAL_ListingControllerBase.EVENT_DATE => '2021-07-23',
                                                                                                  PORTAL_ListingControllerBase.ID_LIST => new List<String>{'test'},
                                                                                                  PORTAL_ListingControllerBase.CATEGORY_KEY => 'category',
                                                                                                  PORTAL_ListingControllerBase.LOCATION_KEY => new Map<Object, Object>(),
                                                                                                  PORTAL_ListingControllerBase.CREATED_BY_USER_ID => 'test',
                                                                                                  PORTAL_ListingControllerBase.IS_SHOW_ONLINE_EVENTS_ONLY => true,
                                                                                                  PORTAL_ListingControllerBase.IS_SHOW_FEATURED_ONLY => true,
                                                                                                  PORTAL_ListingControllerBase.TOPIC_KEY => 'test',
                                                                                                  PORTAL_ListingControllerBase.FORMAT_KEY => 'test',
                                                                                                  PORTAL_ListingControllerBase.ARTICLE_LENGTH_KEY => 'test'});
        }

        public virtual void testGetLocationClause() {
            PORTAL_ListingControllerBase.getLocationClause(null);
            PORTAL_ListingControllerBase.getLocationClause(new Map<Object, Object>{'test' => 'test'});
            PORTAL_ListingControllerBase.getLocationClause(new Map<Object, Object>{PORTAL_ListingControllerBase.CITY_KEY => 'city',
                                                                                   PORTAL_ListingControllerBase.STATE_KEY => 'state',
                                                                                   PORTAL_ListingControllerBase.POSTAL_CODE => 'postalCode',
                                                                                   PORTAL_ListingControllerBase.COUNTRY_KEY => 'country',
                                                                                   PORTAL_ListingControllerBase.RADIUS_KEY => null});
            try {
                PORTAL_ListingControllerBase.getLocationClause(new Map<Object, Object>{PORTAL_ListingControllerBase.CITY_KEY => 'city',
                                                                                       PORTAL_ListingControllerBase.STATE_KEY => 'state',
                                                                                       PORTAL_ListingControllerBase.POSTAL_CODE => 'postalCode',
                                                                                       PORTAL_ListingControllerBase.COUNTRY_KEY => 'country',
                                                                                       PORTAL_ListingControllerBase.RADIUS_KEY => 10});
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetPicklists() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();
            controller.getPicklists(null);
        }

        public virtual void testgetActionOnContentParamClause() {

            User newUser = new User();
            newUser.lastName = 'Test';
            newUser.Email = 'test@test.com';
            newUser.Alias = 'test';
            newUser.Username = 'test@test.test' + PORTAL_CommunityUtils.getEmailProfileId();
            newUser.LocaleSidKey = 'en_US';
            newUser.TimeZoneSidKey = 'GMT';
            newUser.ProfileId = PORTAL_CommunityUtils.getEmailProfileId();
            newUser.LanguageLocaleKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.isActive = false;
            newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
            insert newUser;

            PORTAL_ListingControllerBase.getActionOnContentParamClause(null, null, null, null);
            PORTAL_ListingControllerBase.getActionOnContentParamClause('id != \'\'', null, null, newUser);
            PORTAL_ListingControllerBase.getActionOnContentParamClause(null, 'id != \'\'', null, newUser);
            PORTAL_ListingControllerBase.getActionOnContentParamClause('id != \'\'', 'id != \'\'', null, newUser);

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', Header_Content__c = 'This is a Test.', RecordTypeId = recordTypeId, Status__c = 'Published');

            DateTime currentDateTime = DateTime.now().addDays(-10);
            newListing.Start_Date_Time__c = currentDateTime;
            newListing.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/Indiana/Indianapolis)';
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            ucinn_portal_Action_On_Content__c newAction = new ucinn_portal_Action_On_Content__c(Listing__c = newListing.Id, User__c = newUser.Id);
            newAction = (ucinn_portal_Action_On_Content__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newAction});
            insert newAction;
            Test.setFixedSearchResults(new List<Id>{newAction.Id});
            PORTAL_ListingControllerBase.getActionOnContentParamClause('id != \'\'', 'id != \'\'', null, newUser);

        }

        public virtual void testGetListingDetails() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();
            try {
                controller.getListingDetails(new Map<String, Object>{});
            } catch (Exception e) {
                System.debug(e);
            }

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', Header_Content__c = 'This is a Test.', RecordTypeId = recordTypeId, Status__c = 'Published');

            DateTime currentDateTime = DateTime.now().addDays(-10);
            newListing.Start_Date_Time__c = currentDateTime;
            newListing.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/Indiana/Indianapolis)';
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            controller.getListingDetails(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_NAME => 'test'});
            controller.getListingDetails(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_ID => newListing.Id});
        }

        public virtual void testGetUserProfile() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();

            try {
                controller.getUserProfile(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_ID => ''});
            } catch (Exception e) {
                System.debug(e);
            }

            try {
                controller.getUserProfile(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_ID => 'test'});
            } catch (Exception e) {
                System.debug(e);
            }

            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            User communityUser = new User(alias = 'comUser',
                                     email = 'testCommunityUsermig123@test.com',
                                     emailencodingkey='UTF-8',
                                     lastname = 'Batman',
                                     languagelocalekey='en_US',
                                     localesidkey='en_US',
                                     profileid = profileId,
                                     IsActive = true,
                                     ContactId = con.Id,
                                     timezonesidkey='America/Los_Angeles',
                                     username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
            communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
            insert communityUser;

            try {
                controller.getUserProfile(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_ID => communityUser.Id});
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testSearchListings() {
            PORTAL_ListingControllerBase controller = new PORTAL_ListingControllerBase();

            controller.searchListings(null);
            controller.searchListings(new Map<String, Object>{'test' => 'test'});
            controller.searchListings(new Map<String, Object>{PORTAL_ListingControllerBase.PAGE_NAME => 'Events',
                                                              PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'Events Tabs',
                                                              PORTAL_ListingControllerBase.SUB_SECTION_NAME => 'All Events',
                                                              PORTAL_ListingControllerBase.CATEGORY_KEY => 'Category',
                                                              PORTAL_ListingControllerBase.LOCATION_KEY => new Map<Object, Object>{'city' => 'Los Angeles'}});

            controller.searchListings(new Map<String, Object>{PORTAL_ListingControllerBase.PAGE_NAME => 'Events',
                                                              PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'Events Tabs',
                                                              PORTAL_ListingControllerBase.SUB_SECTION_NAME => 'All Events',
                                                              PORTAL_ListingControllerBase.CATEGORY_KEY => 'Category',
                                                              PORTAL_ListingControllerBase.KEYWORD_KEY => 'test'});
        }

        public virtual void testGetListingsWithKeyword() {
            PORTAL_ListingControllerBase.getListingsWithKeyword('', '', '', null, '', '');
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', Header_Content__c = 'This is a Test.', RecordTypeId = recordTypeId, Status__c = 'Published');

            DateTime currentDateTime = DateTime.now().addDays(-10);
            newListing.Start_Date_Time__c = currentDateTime;
            newListing.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/Indiana/Indianapolis)';
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            Test.setFixedSearchResults(new List<Id>{newListing.Id});
            PORTAL_ListingControllerBase.getListingsWithKeyword('Events', 'Events Tabs', 'All Events', null, 'Test', '');
        }

        public virtual void testFormatDate() {
            PORTAL_ListingControllerBase.formatDate(null);
            PORTAL_ListingControllerBase.formatDate('test');
            PORTAL_ListingControllerBase.formatDate('2021-05-01');
        }

        public virtual void testGetRecommendationTypeSet() {

        }

        public virtual void testGetUserRecommendations() {
            Id profileId = [select id from profile where name=: 'System Administrator'].id;
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

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

            List<String> typeList = PORTAL_ListingControllerBase.getRecommendationTypeList(communityUser);
        }

        public virtual void testUpdateRecommendationEngine() {
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

            new PORTAL_ListingControllerBase().updateRecommendationEngine(new Map<String, Object>{PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY => testListing.Id, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
        }

        public virtual void testUpdateActionOnContent() {
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

            new PORTAL_ListingControllerBase().updateActionOnContent(new Map<String, Object>{PORTAL_ListingControllerBase.ACTION_TO_TAKE_KEY => 'bookmark', PORTAL_CONST_ActionOnContent.LISTING_ID_KEY => testListing.Id, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
            new PORTAL_ListingControllerBase().updateActionOnContent(new Map<String, Object>{PORTAL_ListingControllerBase.ACTION_TO_TAKE_KEY => 'notInterested', PORTAL_CONST_ActionOnContent.LISTING_ID_KEY => testListing.Id, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
        }

        public virtual void testGetFrontendDataMap() {
            System.assertEquals(new Map<String, Object>(), new PORTAL_ListingControllerBase().getFrontEndDataMap(null));
            new PORTAL_ListingControllerBase().getFrontEndDataMap(new Map<String, Object>{PORTAL_ListingControllerBase.PAGE_NAME => 'test', PORTAL_ListingControllerBase.MAIN_SECTION_NAME => 'test'});
        }

        public virtual void testGetLookWhosComingList() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', Header_Content__c = 'This is a Test.', RecordTypeId = recordTypeId, Status__c = 'Published', Is_Display_Look_Who_s_Coming__c = true, Look_Who_s_Coming_Minimum__c = 1);
            insert newListing;

            String testNameTag = 'Test Person';
            insert new List<ucinn_portal_Participation__c>{
                new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                  Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED,
                                                  Name_Tag__c = testNameTag,
                                                  Is_Display_On_Look_Who_s_Coming_List__c = true),

                new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                  Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED,
                                                  Name_Tag__c = testNameTag,
                                                  Is_Display_On_Look_Who_s_Coming_List__c = false)
            };

            PORTAL_ListingControllerBase base = new PORTAL_ListingControllerBase();

            Test.startTest();

            System.assertEquals(0, base.getLookWhosComingList(new Map<String, Object>()).size());
            System.assertEquals(0, base.getLookWhosComingList(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_NAME => 'This Listing Does Not Exist'}).size());

            Map<String, Object> resultMap = base.getLookWhosComingList(new Map<String, Object>{PORTAL_ListingControllerBase.RECORD_NAME => 'Test Event'});
            System.assertEquals(1, resultMap.get('lookWhosComingMinimum'));
            System.assertEquals(1, ((List<Object>) resultMap.get('listingParticipations')).size());
            System.assertEquals(testNameTag, ((Map<String, Object>) ((List<Object>) resultMap.get('listingParticipations'))[0]).get('participationNameTag'));

            Test.stopTest();
        }
    }


    static testMethod void testGetListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListings();
    }

    static testMethod void testRecommendedContentListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testRecommendedContentListings();
    }

    static testMethod void testGetListingButtonText() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingButtonText();
    }

    static testMethod void testGetDynamicQueryForListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetDynamicQueryForListings();
    }

    static testMethod void testGetListingConfigurations() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingConfigurations();
    }

    static testMethod void testGetListingConfigurationsFromPageSectionSettings() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingConfigurationsFromPageSectionSettings();
    }

    static testMethod void testIsUsingRecommendationEngine() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testIsUsingRecommendationEngine();
    }

    static testMethod void testGetListingsScopeClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsScopeClause();
    }

    static testMethod void testGetListingsPortalZoneClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsPortalZoneClause();
    }

    static testMethod void testGetListingsSharingClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsSharingClause();
    }

    static testMethod void testGetListingsRelevanceClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsRelevanceClause();
    }

    static testMethod void testGetListingsRadiusClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsRadiusClause();
    }

    static testMethod void testGetListingsAdditionalParamClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsAdditionalParamClause();
    }

    static testMethod void testGetLocationClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetLocationClause();
    }

    static testMethod void testGetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetPicklists();
    }

    static testMethod void testgetActionOnContentParamClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testgetActionOnContentParamClause();
    }

    static testMethod void testGetListingDetails() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingDetails();
    }

    static testMethod void testGetUserProfile() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetUserProfile();
    }

    static testMethod void testSearchListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testSearchListings();
    }

    static testMethod void testGetListingsWithKeyword() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetListingsWithKeyword();
    }

    static testMethod void testFormatDate() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testFormatDate();
    }

    static testMethod void testGetRecommendationTypeSet() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetRecommendationTypeSet();

    }

    static testMethod void testGetUserRecommendations() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetUserRecommendations();
    }

    static testMethod void testUpdateRecommendationEngine() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testUpdateRecommendationEngine();
    }

    static testMethod void testUpdateActionOnContent() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testUpdateActionOnContent();
    }

    static testMethod void testGetFrontEndDataMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetFrontendDataMap();
    }

    /**
     * test base controller look who's coming
     * @author Jacob Huang
     * @since 1.1
     */
    static testMethod void testGetLookWhosComingList() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingControllerBaseTestClass().testGetLookWhosComingList();
    }
}