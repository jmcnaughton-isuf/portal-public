@isTest
public without sharing class PORTAL_ZoneSearchControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public User communityUser;
        public Contact constituent;
        public Id clubId;
        public Id groupId;
        PORTAL_ZoneSearchControllerBase baseController;
        private  PORTAL_HttpMockCallout mockcallouts;
        PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public void setupData() {
            mockcallouts = new PORTAL_HttpMockCallout();
            clubId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            groupId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();

            System.runAs(thisUser) {

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                constituent = new Contact(FirstName = 'testFirstName',
                                        LastName = 'testLastName',
                                        AccountId = acct.Id,
                                        Email = 'testCommunityUsermig123@test.com',
                                        Phone = '1234567890');

                constituent = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => constituent});
                insert constituent;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = constituent.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com',
                                        ucinn_portal_Recommend_Type_1__c = 'Law',
                                        ucinn_portal_Recommend_Type_2__c = 'Culture',
                                        ucinn_portal_Recommend_Type_3__c = 'Global');

                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                // insert club and group zone records
                ucinn_portal_Zone__c club1 = new ucinn_portal_Zone__c(
                    Name = 'club1',
                    Is_Display_on_Portal__c = true,
                    recordTypeId = clubId,
                    City__c = 'Irvine',
                    State__c = 'California',
                    Country__c = 'United States',
                    Geolocation__latitude__s = 33.645615,
                    Geolocation__longitude__s = -117.842856,
                    Social_Media_Order__c = 'Twitter;Facebook;Instagram;LinkedIn;WeChat',
                    Twitter_Link__c = 'twitter.com/test',
                    Facebook_Link__c = 'facebook.com/test',
                    Instagram_Link__c = 'instagram.com/test',
                    LinkedIn_Link__c = 'linkedin.com/test',
                    WeChat_Link__c = 'wechat.com/test'
                );
                club1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club1});
                insert club1;

                ucinn_portal_Zone__c club2 = new ucinn_portal_Zone__c(
                    Name = 'club2',
                    Is_Display_on_Portal__c = true,
                    recordTypeId = clubId,
                    City__c = 'Irvine',
                    State__c = 'California',
                    Country__c = 'United States',
                    Geolocation__latitude__s = 33.645615,
                    Geolocation__longitude__s = -117.842856,
                    Social_Media_Order__c = 'Facebook;Instagram;Twitter',
                    Facebook_Link__c = 'facebook.com/test',
                    Instagram_Link__c = 'instagram.com/test',
                    Twitter_Link__c = 'twitter.com/test'
                );
                club2 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club2});
                insert club2;

                ucinn_portal_Zone__c club3 = new ucinn_portal_Zone__c(
                    Name = 'club3',
                    Is_Display_on_Portal__c = true,
                    recordTypeId = clubId,
                    City__c = 'Irvine',
                    State__c = 'California',
                    Country__c = 'United States',
                    Geolocation__latitude__s = 33.645615,
                    Geolocation__longitude__s = -117.842856,
                    Social_Media_Order__c = 'LinkedIn;WeChat',
                    LinkedIn_Link__c = 'linkedin.com/test',
                    WeChat_Link__c = 'wechat.com/test'
                );
                club3 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club3});
                insert club3;

                ucinn_portal_Zone__c group1 = new ucinn_portal_Zone__c(
                    Name = 'group1',
                    Is_Display_on_Portal__c = true,
                    recordTypeId = groupId,
                    Country__c = 'Armenia',
                    Geolocation__latitude__s = 40.0691,
                    Geolocation__longitude__s = 45.0382,
                    Social_Media_Order__c = 'WeChat',
                    WeChat_Link__c = 'wechat.com/test'
                );
                group1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => group1});
                insert group1;

                ucinn_portal_Zone__c group2 = new ucinn_portal_Zone__c(
                    Name = 'group2',
                    Is_Display_on_Portal__c = true,
                    recordTypeId = groupId,
                    City__c = 'Irvine',
                    State__c = 'California',
                    Country__c = 'United States',
                    Geolocation__latitude__s = 33.645615,
                    Geolocation__longitude__s = -117.842856,
                    Social_Media_Order__c = ''
                );
                group2 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => group2});
                insert group2;

                ucinn_portal_Zone_Membership__c zoneMembership1 = new ucinn_portal_Zone_Membership__c(
                    Board_Member_Title__c = 'Funk Master',
                    Constituent__c = constituent.Id,
                    Zone__c = club2.Id,
                    Status__c = 'Active',
                    Is_Primary_Contact__c = true
                );
                zoneMembership1 = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneMembership1});
                insert zoneMembership1;

                ucinn_portal_Zone_Membership__c zoneMembership2 = new ucinn_portal_Zone_Membership__c(
                    Board_Member_Title__c = 'Techno King',
                    Constituent__c = constituent.Id,
                    Zone__c = club3.Id,
                    Status__c = 'Active',
                    Is_Primary_Contact__c = true
                );
                zoneMembership2 = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneMembership2});
                insert zoneMembership2;

                System.runAs(communityUser){
                    baseController = new PORTAL_ZoneSearchControllerBase();
                }
            }
        }

        public void initZoneSearchTest() {
            setupData();

            try {
                baseController.initZoneSearch(null);
            } catch (AuraHandledException e) {

            }

            try {
                baseController.initZoneSearch(new Map<String, Object>{
                    PORTAL_ZoneSearchControllerBase.NAME_SEARCH_INPUT => null,
                    PORTAL_ZoneSearchControllerBase.LOCATION_KEY => null,
                    PORTAL_ZoneSearchControllerBase.RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED => null
                });
            } catch (AuraHandledException e) {

            }

            try {
                baseController.initZoneSearch(new Map<String, Object>{
                    PORTAL_ZoneSearchControllerBase.NAME_SEARCH_INPUT => 'group',
                    PORTAL_ZoneSearchControllerBase.LOCATION_KEY => new Map<Object, Object>{'city' => 'Irvine',
                                                                                            'state'=> 'California',
                                                                                            'postalCode'=> null,
                                                                                            'country'=> 'United States',
                                                                                            'distance'=> 100},
                    PORTAL_ZoneSearchControllerBase.RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED => 'Club,Group'
                });
            } catch (Exception e) {

            }
        }

        public void getZoneRecordsTest() {
            setupData();

            try {
                baseController.getZoneRecords(new Map<String, Object>{
                    PORTAL_ZoneSearchControllerBase.NAME_SEARCH_INPUT => null,
                    PORTAL_ZoneSearchControllerBase.LOCATION_KEY => null,
                    PORTAL_ZoneSearchControllerBase.RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED => null
                }); //null, null, null
            } catch (AuraHandledException e) {

            }

            // geolocation search
            try {
                baseController.getZoneRecords(new Map<String, Object>{
                    PORTAL_ZoneSearchControllerBase.NAME_SEARCH_INPUT => '',
                    PORTAL_ZoneSearchControllerBase.LOCATION_KEY => new Map<Object, Object>{'city' => 'Irvine',
                                                                                            'state'=> 'California',
                                                                                            'postalCode'=> null,
                                                                                            'country'=> 'United States',
                                                                                            'distance'=> 100},
                    PORTAL_ZoneSearchControllerBase.RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED => 'Club'
                });
            } catch (Exception e) {

            }

            // text search
            try {
                baseController.getZoneRecords(new Map<String, Object>{
                    PORTAL_ZoneSearchControllerBase.NAME_SEARCH_INPUT => null,
                    PORTAL_ZoneSearchControllerBase.LOCATION_KEY => new Map<Object, Object>{'city' => 'Irvine',
                                                                                            'state'=> 'California',
                                                                                            'postalCode'=> null,
                                                                                            'country'=> 'United States',
                                                                                            'distance'=> null},
                    PORTAL_ZoneSearchControllerBase.RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED => 'Club'
                });
            } catch (Exception e) {

            }
        }

        public void getCountriesForZonesTest() {
            setupData();

            try {
                baseController.getCountriesForZones(null);
            } catch (Exception E) {

            }

            List<String> testRecordTypeNames = new List<String>();
            testRecordTypeNames.add('Club');
            testRecordTypeNames.add('Group');

            try {
                baseController.getCountriesForZones(testRecordTypeNames);
            } catch (Exception e) {

            }
        }


        public void getSortedCountryListTest() {
            setupData();

            try {
                baseController.getSortedCountryList(null);
            } catch (Exception e) {

            }
        }


        public void sortCountryListTest() {
            setupData();

            try {
                baseController.sortCountryList(null);
            } catch (Exception e) {

            }
        }


        public void getFormattedZoneListTest() {
            setupData();

            try {
                baseController.getFormattedZoneList(null);
            } catch (AuraHandledException e) {

            }
        }


        public void getFormattedZoneRecordTest() {
            setupData();

            try {
                baseController.getFormattedZoneRecord(null);
            } catch (Exception e) {

            }
        }


        public void getQueryWhereClauseTest() {
            setupData();

            try {
                baseController.getQueryWhereClause(null, null, null);
            } catch (Exception e) {

            }
        }


        public void getSocialMediaListTest() {
            setupData();

            try {
                baseController.getSocialMediaList(null);
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaList(new Map<String,Object> {'socialMediaOrder' => 'Facebook;LinkedIn;Instagram;Twitter;WeChat'});
            } catch (Exception e) {

            }
        }


        public void getSocialMediaInfoFromLogoTest() {
            setupData();

            try {
                baseController.getSocialMediaInfoFromLogo(null, 'testSocialMediaName');
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaInfoFromLogo(new Map<String,Object> {'testFormattedZone' => new ucinn_portal_Zone__c()}, 'testSocialMediaName');
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaInfoFromLogo(new Map<String,Object> {'facebookLink' => 'facebook.com'}, 'Facebook');
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaInfoFromLogo(new Map<String,Object> {'linkedinLink' => 'linkedin.com'}, 'LinkedIn');
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaInfoFromLogo(new Map<String,Object> {'instagramLink' => 'instagram.com'}, 'Instagram');
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaInfoFromLogo(new Map<String,Object> {'twitterLink' => 'twitter.com'}, 'Twitter');
            } catch (Exception e) {

            }

            try {
                baseController.getSocialMediaInfoFromLogo(new Map<String,Object> {'wechatLink' => 'wechat.com'}, 'WeChat');
            } catch (Exception e) {

            }
        }
    }

    static testMethod void testInitZoneSearchTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().initZoneSearchTest();
    }

    static testMethod void getZoneRecordsTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getZoneRecordsTest();
    }

    static testMethod void getCountriesForZonesTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getCountriesForZonesTest();
    }

    static testMethod void getSortedCountryListTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getSortedCountryListTest();
    }

    static testMethod void getFormattedZoneListTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getFormattedZoneListTest();
    }

    static testMethod void getFormattedZoneRecordTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getFormattedZoneRecordTest();
    }

    static testMethod void getQueryWhereClauseTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getQueryWhereClauseTest();
    }

    static testMethod void getSocialMediaListTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getSocialMediaListTest();
    }

    static testMethod void getSocialMediaInfoFromLogoTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneSearchControllerBaseTestClass().getSocialMediaInfoFromLogoTest();
    }
}