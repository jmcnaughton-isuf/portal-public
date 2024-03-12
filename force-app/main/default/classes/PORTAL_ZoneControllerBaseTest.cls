@isTest
public without sharing class PORTAL_ZoneControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public User communityUser;
        public Contact constituent;
        public Id clubId;
        public Id groupId;
        PORTAL_ZoneControllerBase baseController;
        private PORTAL_HttpMockCallout mockcallouts;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public void setupData() {
            mockcallouts = new PORTAL_HttpMockCallout();
            clubId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            groupId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();

            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                constituent = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');

                constituent = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => constituent});
                insert constituent;

                ucinn_ascendv2__Degree_Information__c degreeInfo = new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Contact__c = constituent.Id,
                                                                                                            ucinn_ascendv2__Conferred_Degree_Year__c = '2012',
                                                                                                            ucinn_ascendv2__Degree__c = 'BS',
                                                                                                            ucinn_portal_Status__c = 'Active',
                                                                                                            RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('School_Degree_Information').getRecordTypeId());

                degreeInfo = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => degreeInfo});
                insert degreeInfo;

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
                    Country__c = 'United States'
                );
                club1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club1});
                insert club1;

                ucinn_portal_Zone__c group1 = new ucinn_portal_Zone__c(
                    Name = 'group1',
                    Is_Display_on_Portal__c = true,
                    recordTypeId = groupId,
                    Country__c = 'Armenia'
                );
                group1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => group1});
                insert group1;

                System.runAs(communityUser){
                    baseController = new PORTAL_ZoneControllerBase();
                }
            }
        }

        public void SERVER_getZoneBioDetailInfoTest() {
            setupData();

            ucinn_portal_Zone__c club1 = new ucinn_portal_Zone__c(
                Name = 'club1',
                Is_Display_on_Portal__c = true,
                recordTypeId = clubId
            );
            club1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club1});
            insert club1;

            ucinn_portal_Zone_Membership__c clubMembership = new ucinn_portal_Zone_Membership__c(
                Constituent__c = constituent.Id,
                Zone__c = club1.Id,
                Status__c = 'Active'
            );
            clubMembership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => clubMembership});
            insert clubMembership;

            try {
                baseController.getZoneBioDetailInfo(new Map<String, Object>{
                });
            } catch (Exception e) {

            }

            try {
                baseController.getZoneBioDetailInfo(new Map<String, Object>{
                    'fakeParamName' => clubMembership.Id
                });
            } catch (Exception e) {

            }

            try {
                baseController.getZoneBioDetailInfo(new Map<String, Object>{
                    'zoneMembershipId' => clubMembership.Id
                });
            }
            catch (Exception e) {

            }

        }

        public void testGetZoneRelatedLinks() {
            setupData();
            ucinn_portal_Content_Page__c contentPageRelatedLinks = new ucinn_portal_Content_Page__c(Name = 'TestContentPage');
            contentPageRelatedLinks = (ucinn_portal_Content_Page__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentPageRelatedLinks});
            insert contentPageRelatedLinks;

            ucinn_portal_Content_Module__c contentModuleRelatedLinks = new ucinn_portal_Content_Module__c(Content_Module_Metadata__c = '{"title": "test", "relatedLinks": [{"link": "https://www.test.com", "label": "Test"}]}', Content_Page__c = contentPageRelatedLinks.Id, Name = 'TestContentModule');
            contentModuleRelatedLinks = (ucinn_portal_Content_Module__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentModuleRelatedLinks});
            insert contentModuleRelatedLinks;

            try {
                Map<String, Object> returnMap = baseController.getZoneRelatedLinks(new Map<String, String>{'contentPage' => 'TestContentPage', 'subPageName' => '', 'contentModule' => 'TestContentModule'});
                System.assertEquals(false, returnMap.isEmpty());
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void SERVER_getZoneBoardMembersTest() {
            setupData();
            ucinn_portal_Zone__c club1 = new ucinn_portal_Zone__c(
                Name = 'club1',
                Is_Display_on_Portal__c = true,
                recordTypeId = clubId
            );
            club1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club1});
            insert club1;

            ucinn_portal_Zone_Membership__c zoneMembershipBoardMember = new ucinn_portal_Zone_Membership__c(Name = 'zoneMemBoardMember', Status__c = 'Active', Is_Board_Member__c = true, Constituent__c = constituent.Id, Zone__c = club1.Id);
            zoneMembershipBoardMember = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneMembershipBoardMember});
            insert zoneMembershipBoardMember;

            try {
                baseController.getZoneBoardMembers(new Map<String, Object>{
                    'zoneName' => club1.Name,
                    'orderClause' => 'First Name (A-Z)'
                });
            } catch (Exception e) {
                System.debug(e);
            }

            Map<String, Object> returnMap = baseController.getZoneBoardMembers(new Map<String, Object>());

            System.assertEquals(true, returnMap.isEmpty());

            returnMap = baseController.getZoneBoardMembers(new Map<String, Object>{
                'zoneName' => club1.Name,
                'orderClause' => 'Last Name(Z-A)',
                'pageName' => 'Test Page Name for Zone',
                'mainSectionName' => 'Test Main Section Name for Zone'
            });

            System.assertEquals(new List<Object>(), returnMap.get('records'));

            baseController.getZoneBoardMembers(new Map<String, Object>{
                'zoneName' => club1.Name,
                'orderClause' => 'First Name (Z-A)',
                'pageName' => 'Zone Leadership',
                'mainSectionName' => 'Zone Leadership'
            });
        }

        public void testGetZoneTitleTest() {
            setupData();

            ucinn_portal_Zone__c club1 = new ucinn_portal_Zone__c(
                Name = 'club1',
                Is_Display_on_Portal__c = true,
                recordTypeId = clubId
            );
            club1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club1});
            insert club1;

            ucinn_portal_Zone_Membership__c clubMembership = new ucinn_portal_Zone_Membership__c(
                Constituent__c = constituent.Id,
                Zone__c = club1.Id,
                Status__c = 'Active',
                Is_Featured_Board_Member__c = true
            );
            clubMembership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => clubMembership});
            insert clubMembership;

            String returnString = baseController.getZoneTitle(null);
            System.assertEquals('', returnString);
            baseController.getZoneTitle(new Map<String, String>{'zmid' => clubMembership.Id});
            baseController.getZoneTitle(new Map<String, String>{'zname' => club1.Name});
        }

        public void testGetOrderByForBoardMembers() {
            setupData();
            String returnString = baseController.getOrderByForBoardMembers(null);
            System.assertEquals('', returnString);

            returnString = baseController.getOrderByForBoardMembers('Last Name (Z-A)');
            System.assertEquals(' ORDER BY Constituent__r.LastName DESC ', returnString);

            returnString = baseController.getOrderByForBoardMembers('First Name (A-Z)');
            System.assertEquals(' ORDER BY Constituent__r.FirstName ASC ', returnString);

            returnString = baseController.getOrderByForBoardMembers('First Name (Z-A)');
            System.assertEquals(' ORDER BY Constituent__r.FirstName DESC ', returnString);

            returnString = baseController.getOrderByForBoardMembers('Last Name (A-Z)');
            System.assertEquals(' ORDER BY Constituent__r.LastName ASC ', returnString);
        }

        public void testUnsubscribeFromNewsletter() {
            setupData();

            ucinn_portal_Zone__c testZone = new ucinn_portal_Zone__c (
                name = 'test Zone',
                Geolocation__latitude__s = 37.971077314323544,
                Geolocation__longitude__s = 23.726837563349637,
                Social_Media_Order__c = 'LinkedIn;Instagram;Twitter;WeChat',
                LinkedIn_Link__c = 'test.com',
                Instagram_Link__c = 'test.com',
                Twitter_Link__c = 'test.com',
                WeChat_Link__c = 'test.com'
            );
            testZone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZone});
            insert testZone;

            ucinn_portal_Zone_Membership__c testZoneMembership = new ucinn_portal_Zone_Membership__c(
                Constituent__c = constituent.Id,
                Zone__c = testZone.Id,
                Board_Member_Title__c = 'Important Title',
                Status__c = 'Active'
            );
            testZoneMembership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZoneMembership});
            insert testZoneMembership;

            baseController.unsubscribeFromNewsletter(new Map<String, Object>{PORTAL_ZoneControllerBase.ID_KEY => constituent.Id});

            baseController.unsubscribeFromNewsletter(new Map<String, Object>{PORTAL_ZoneControllerBase.CONTACT_EMAIL => constituent.Email});

            try {
                baseController.unsubscribeFromNewsletter(null);
            } catch (Exception e) {

            }
        }

        public void testGetZoneBanner() {
            setupData();
            String testPageName = 'Zone Banner Test Page';
            String testPageSubPageName = 'Zone Banner Sub Page Name';
            String testModuleName = 'Zone Banner';

            ucinn_portal_Content_Page__c zoneBannerTestPageWithZoneName = new ucinn_portal_Content_Page__c();
            zoneBannerTestPageWithZoneName.Name = testPageName;
            insert zoneBannerTestPageWithZoneName;
            
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = testModuleName;
            module.content_page__c = zoneBannerTestPageWithZoneName.Id;
            module.content_module_metadata__c = '{"htmlText":"Default banner"}';
            module.related_lwc__c = 'portal_HtmlEditor';

            Map<String, Object> params = new Map<String, Object>{PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => testPageName,
                                                                 PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => testModuleName,
                                                                 PORTAL_StaticContentControllerBase.PARAM_SUB_PAGE_NAME => testPageName};

            baseController.getZoneBanner(params);
        }
    }

    static testMethod void testGetZoneBioDetailInfoTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().SERVER_getZoneBioDetailInfoTest();
    }

    static testMethod void testGetZoneRelatedLinks(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().testGetZoneRelatedLinks();
    }

    static testMethod void testGetZoneBoardMembersTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().SERVER_getZoneBoardMembersTest();
    }

    static testMethod void testGetZoneTitleTest(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().testGetZoneTitleTest();
    }

    static testMethod void testGetOrderByForBoardMembers(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().testGetOrderByForBoardMembers();
    }

    static testMethod void testUnsubscribeFromNewsletter(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().testUnsubscribeFromNewsletter();
    }

    static testMethod void testGetZoneBanner(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneControllerBaseTestClass().testGetZoneBanner();
    }
}