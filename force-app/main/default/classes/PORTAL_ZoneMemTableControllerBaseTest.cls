@isTest
public without sharing class PORTAL_ZoneMemTableControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public User communityUser;
        public Contact constituent;
        public Id clubId;
        public Id groupId;
        PORTAL_ZoneMembershipTableControllerBase baseController;
        PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public void setupData() {
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
                    baseController = new PORTAL_ZoneMembershipTableControllerBase();
                }
            }
        }

        public void testGetZoneMembershipRecords() {
            setupData();

            ucinn_portal_Zone__c groupTest1 = new ucinn_portal_Zone__c(
                Name = 'club1',
                Is_Display_on_Portal__c = true,
                recordTypeId = groupId
            );
            groupTest1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => groupTest1});
            insert groupTest1;

            ucinn_portal_Zone_Membership__c clubMembership = new ucinn_portal_Zone_Membership__c(
                Constituent__c = constituent.Id,
                Zone__c = groupTest1.Id,
                Status__c = 'Active'
            );
            clubMembership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => clubMembership});
            insert clubMembership;

            Map<String, Object> returnMap = baseController.getZoneMembershipRecords(null);
            System.assert(true, returnMap.isEmpty());

            returnMap = baseController.getZoneMembershipRecords(new Map<String, Object>{'testParam' => 'testValue'});
            System.assert(true, returnMap.isEmpty());

            System.runAs(communityUser) {
                returnMap = baseController.getZoneMembershipRecords(new Map<String, Object>{'pageName' => 'Zone Memberships', 'mainSectionName' => 'Zone Memberships', 'subSectionName' => 'Group'});
                //System.assert(false, returnMap.isEmpty());
            }

        }

        public void testGetZoneTableInformation() {
            setupData();
            Map<String, Object> returnMap = baseController.getZoneTableInformation(null);
            System.assert(true, returnMap.isEmpty());

            returnMap = baseController.getZoneTableInformation(new Map<String, Object>{'portalMembershipSettingName' => ''});

            returnMap = baseController.getZoneTableInformation(new Map<String, Object>{'portalMembershipSettingName' => 'Invalid'});

            System.runAs(communityUser){
                returnMap = baseController.getZoneTableInformation(new Map<String, Object>{'portalMembershipSettingName' => 'Clubs'});
            }
        }

        public void testSaveZoneMembershipRecords() {
            setupData();

            Test.startTest();
            // insert club and group zone records
            ucinn_portal_Zone__c club1 = new ucinn_portal_Zone__c(
                Name = 'clubSave',
                Is_Display_on_Portal__c = true,
                recordTypeId = clubId,
                Country__c = 'United States'
            );

            club1 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => club1});
            insert club1;

            baseController.saveZoneMembershipRecords(null);
            baseController.saveZoneMembershipRecords(new Map<String, Object>{'invalid parameter' => 'param'});

            List<Map<Object,Object>> zoneMembershipsToJoin = new List<Map<Object,Object>>{new Map<Object,Object>{'zoneId' => club1.Id,
                                                                                                                'zoneMemName' => club1.Name,
                                                                                                                'zoneMemStatus' => 'Pending',
                                                                                                                'zoneMemIsOnNewsletter' => false,
                                                                                                                'zoneMemIsOnDirectory' => false,
                                                                                                                'zoneRecordType' => 'Club'}};

            System.runAs(communityUser) {
                baseController.saveZoneMembershipRecords(new Map<String, Object>{PORTAL_ZoneMembershipTableControllerBase.ZONE_MEMBERSHIPS_TO_JOIN => zoneMembershipsToJoin,
                                                                                PORTAL_ZoneMembershipTableControllerBase.PAGE_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.MAIN_SECTION_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.SUB_SECTION_NAME => 'Club'});

            }

            List<ucinn_portal_Zone_Membership__c> resultList = [SELECT Id FROM ucinn_portal_Zone_Membership__c WHERE Constituent__c = :constituent.Id AND Name = 'clubSave'];

            System.assert(resultList.size() == 1);

            System.runAs(communityUser) {
                baseController.saveZoneMembershipRecords(new Map<String, Object>{PORTAL_ZoneMembershipTableControllerBase.ZONE_MEMBERSHIPS_TO_LEAVE => new List<Object>{resultList.get(0).Id},
                                                                                PORTAL_ZoneMembershipTableControllerBase.PAGE_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.MAIN_SECTION_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.SUB_SECTION_NAME => 'Club'});

            }

            resultList = [SELECT Id FROM ucinn_portal_Zone_Membership__c WHERE Constituent__c = :constituent.Id AND Name = 'clubSave' AND Status__c = 'Inactive'];

            System.assert(resultList.size() == 1);

            System.runAs(communityUser) {
                baseController.saveZoneMembershipRecords(new Map<String, Object>{PORTAL_ZoneMembershipTableControllerBase.ZONE_MEMBERSHIPS_TO_JOIN => zoneMembershipsToJoin,
                                                                                PORTAL_ZoneMembershipTableControllerBase.PAGE_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.MAIN_SECTION_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.SUB_SECTION_NAME => 'Club'});

            }

            resultList = [SELECT Id FROM ucinn_portal_Zone_Membership__c WHERE Constituent__c = :constituent.Id AND Name = 'clubSave'];

            System.assert(resultList.size() == 1);

            Map<Object,Object> checkboxMap = new Map<Object, Object>{resultList.get(0).Id => new Map<Object, Object>{'zoneMemIsOnNewsletter' => true, 'zoneMemIsOnDirectory' => true}};

            System.runAs(communityUser) {
                baseController.saveZoneMembershipRecords(new Map<String, Object>{PORTAL_ZoneMembershipTableControllerBase.ZONE_MEMBERSHIP_ID_TO_CHECKBOX_VALUES_MAP => checkboxMap,
                                                                                PORTAL_ZoneMembershipTableControllerBase.PAGE_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.MAIN_SECTION_NAME => 'Zone Memberships',
                                                                                PORTAL_ZoneMembershipTableControllerBase.SUB_SECTION_NAME => 'Club'});

            }

            Test.stopTest();
        }

        public void testIsZoneMembershipInsertionCaseOverride() {
            setupData();

            Test.startTest();
            Boolean returnValue = baseController.isZoneMembershipInsertionCaseOverride(null, null);
            System.assert(returnValue == false);

            returnValue = baseController.isZoneMembershipInsertionCaseOverride(new Map<String, Object>{PORTAL_ZoneMembershipTableControllerBase.CONSTITUENT_TYPES => new Set<String>{'Alumni'}}, 'Alumni,Friend,Test');
            System.assert(returnValue == true);

            returnValue = baseController.isZoneMembershipInsertionCaseOverride(new Map<String, Object>{PORTAL_ZoneMembershipTableControllerBase.CONSTITUENT_TYPES => new Set<String>{'In Progress'}}, 'Alumni,Friend,Test');
            System.assert(returnValue == false);

            Test.stopTest();
        }

        public void testGetZoneMembershipStatus() {
            setupData();

            Test.startTest();
            try {
                baseController.getZoneMembershipStatus(null, null);
            } catch (Exception e) {

            }

            Portal_Membership_Setting__mdt zoneMembershipSetting = new Portal_Membership_Setting__mdt();

            String returnValue = baseController.getZoneMembershipStatus(zoneMembershipSetting, new Map<String, Object>{'test' => 'test'});
            System.assert(PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_ACTIVE == returnValue);
            Test.stopTest();
        }

        public void testGetZoneMembershipsForCaseCreation() {
            setupData();

            Test.startTest();
            baseController.getZoneMembershipsForCaseCreation(null, null, null);
            Portal_Membership_Setting__mdt zoneMembershipSetting = new Portal_Membership_Setting__mdt();

            baseController.getZoneMembershipsForCaseCreation(new Map<String, List<ucinn_portal_Zone_Membership__c>>{'testRecordType' => new List<ucinn_portal_Zone_Membership__c>{new ucinn_portal_Zone_Membership__c(Name = 'Test Membership')}},
                                                            new Map<String, Portal_Membership_Setting__mdt>{'invalidRecordType' => zoneMembershipSetting},
                                                            '12345');
            Test.stopTest();
        }

        public void testCaseCreation() {
            setupData();

            Test.startTest();
            String returnValue = baseController.handleCaseCreation(null);
            System.assert(returnValue == '');

            returnValue = baseController.handleCaseCreation(constituent.Id);
            System.assert(returnValue != '');


            Test.stopTest();
        }
    }

    static testMethod void testGetZoneMembershipRecords(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testGetZoneMembershipRecords();
    }

    static testMethod void testGetZoneTableInformation(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testGetZoneTableInformation();
    }

    static testMethod void testSaveZoneMembershipRecords(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testSaveZoneMembershipRecords();
    }

    static testMethod void testIsZoneMembershipInsertionCaseOverride(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testIsZoneMembershipInsertionCaseOverride();
    }

    static testMethod void testGetZoneMembershipStatus(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testGetZoneMembershipStatus();
    }

    static testMethod void testGetZoneMembershipsForCaseCreation(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testGetZoneMembershipsForCaseCreation();
    }

    static testMethod void testCaseCreation(){
        PORTAL_TestClassFactory.getTestClassFactory().getZoneMembershipTableControllerBaseTestClass().testCaseCreation();
    }
}