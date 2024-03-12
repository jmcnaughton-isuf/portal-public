@isTest
global without sharing class PORTAL_GivingSocietiesControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public PORTAL_GivingSocietiesControllerBase baseController;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setup() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                baseController = new PORTAL_GivingSocietiesControllerBase();

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
                                        ucinn_portaL_Recommend_Type_3__c = 'Global');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;
            }

            List<ucinn_ascendv2__Giving_Society__c> givingSocities = new List<ucinn_ascendv2__Giving_Society__c>();
            ucinn_ascendv2__Giving_Society__c givingSociety1 = new ucinn_ascendv2__Giving_Society__c(ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Lifetime',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    ucinn_ascendv2__Society_Website__c = 'www.google.com',
                                                                                                    Name = 'TEST 1'
                                                                                                );

            ucinn_ascendv2__Giving_Society__c givingSociety2 = new ucinn_ascendv2__Giving_Society__c(ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Annual',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    Name = 'TEST 2'
                                                                                                );

            ucinn_ascendv2__Giving_Society__c givingSociety3 = new ucinn_ascendv2__Giving_Society__c(ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Annual',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    Name = 'TEST 3'
                                                                                                );

            givingSociety1 = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety1});
            givingSociety2 = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety2});
            givingSociety3 = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety3});


            givingSocities.add(givingSociety1);

            givingSocities.add(givingSociety2);

            givingSocities.add(givingSociety3);

            insert givingSocities;

            List<ucinn_ascendv2__Society_Membership__c> societyMemberships = new List<ucinn_ascendv2__Society_Membership__c>();

            ucinn_ascendv2__Society_Membership__c societyMembership1 = new ucinn_ascendv2__Society_Membership__c(
                ucinn_ascendv2__Contact__c = con.Id,
                ucinn_ascendv2__Giving_Society__c = givingSocities[0].Id,
                ucinn_ascendv2__Expiration_Date__c =  Date.today().addDays(1),
                ucinn_ascendv2__Member_Since__c = Date.today().addDays(-1)
            );

            ucinn_ascendv2__Society_Membership__c societyMembership2 = new ucinn_ascendv2__Society_Membership__c(
                ucinn_ascendv2__Contact__c = con.Id,
                ucinn_ascendv2__Giving_Society__c = givingSocities[1].Id,
                ucinn_ascendv2__Expiration_Date__c =  Date.today().addDays(1),
                ucinn_ascendv2__Member_Since__c = Date.today().addDays(-1)
            );

            ucinn_ascendv2__Society_Membership__c societyMembership3 = new ucinn_ascendv2__Society_Membership__c(
                ucinn_ascendv2__Contact__c = con.Id,
                ucinn_ascendv2__Giving_Society__c = givingSocities[2].Id,
                ucinn_ascendv2__Expiration_Date__c =  Date.today().addDays(1),
                ucinn_ascendv2__Member_Since__c = Date.today().addDays(-1)
            );

            societyMembership1 = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership1});
            societyMembership2 = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership2});
            societyMembership3 = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership3});

            societyMemberships.add(societyMembership1);
            societyMemberships.add(societyMembership2);
            societyMemberships.add(societyMembership3);

            insert societyMemberships;

            Formula.recalculateFormulas(societyMemberships);

            // donor stories
            Id donorStoryRecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();

            ucinn_portal_Listing__c donorStory1 = new ucinn_portal_Listing__c(
                Status__c = 'Published',
                RecordTypeId = donorStoryRecordTypeId,
                name = 'Daniels donor story'
            );
            donorStory1 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => donorStory1});
            insert donorStory1;
        }


        public virtual void getGivingSocietiesListTest() {
            setup();

            System.runAs(communityUser) {
                baseController.getGivingSocietiesList(new Map<String, Object>{
                    'nameSearch' => null,
                    'givingSocietyType' => null,
                    'givingSocietyDetailURL'  => 'test'
                });

                baseController.getGivingSocietiesList(new Map<String, Object>{
                    'nameSearch' => 'TEST',
                    'givingSocietyType' => 'LIFETIME'
                });
            }

        }

        public virtual void getGivingSocietyDetailPageTest() {
            setup();

            System.runAs(communityUser) {

                // name matches giving society created in setup
                try {
                    baseController.getGivingSocietyDetailPage(new Map<String, Object>{
                        'givingSocietyName' => 'TEST 1'
                    });
                }
                catch (Exception e) {

                }


                // no giving society name provided
                try {
                    baseController.getGivingSocietyDetailPage(new Map<String, Object>{
                        'givingSocietyName' => null
                    });
                }
                catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

                }

                // giving society name that does not exist
                try {
                    baseController.getGivingSocietyDetailPage(new Map<String, Object>{
                        'givingSocietyName' => 'ALKJSHDLKAJNS<MASD'
                    });
                }
                catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

                }
            }
        }

        public virtual void checkIfInGivingSocietyTest() {
            setup();

            System.runAs(communityUser) {
                // search Givign society that doesnt exist
                baseController.checkIfInGivingSociety(
                    new Map<String, Object>{
                        'givingSocietyName' => 'ZXCZXCASDASD!@#ASDBRHYW#'
                    }
                );

                // search all giving socities
                baseController.checkIfInGivingSociety(
                    new Map<String, Object>{
                        'givingSocietyName' => null
                    }
                );
            }

            // no contact
            baseController.checkIfInGivingSociety(
                new Map<String, Object>{
                    'givingSocietyName' => null
                }
            );
        }

        public virtual void getDonorStoriesTest() {
            setup();

            baseController.getDonorStories(new Map<String, Object> {
                'numOfItemsToShow' => 15,
                'givingSocietyDetailPageURL' => 'test'
            });

            // no records found
            baseController.getDonorStories(new Map<String, Object> {
                'numOfItemsToShow' => 15,
                'givingSocietyDetailPageURL' => 'test',
                'givingSocietyName' => 'ASDALKJSDHLAKJSHDLAKJSDASD'
            });

            try {
                // num of items to show is not an integer
                baseController.getDonorStories(new Map<String, Object> {
                    'numOfItemsToShow' => 'asdasdasd',
                    'givingSocietyDetailPageURL' => 'test'
                });
            }
            catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

            }
        }

        public virtual void getDonorStoriesDetailTest() {
            setup();

            baseController.getDonorStoriesDetail(new Map<String, Object>{
                'donorStoryName' => 'Daniels donor story'
            });

            // no donor story name provided.
            try {
                baseController.getDonorStoriesDetail(new Map<String, Object>{
                    'donorStoryName' => null
                });
            }
            catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

            }
        }

        public virtual void getSocityMembersipTableDataTest() {
            setup();

            System.runas(communityUser) {
                baseController.getSocietyMembershipTableData(new Map<String, Object>{
                    'annualMembershipRenewGivingSettingsName' => 'abc123',
                    'annualMembershipElevateGivingSettingsName' => 'abc123',
                    'lifetimeMembershipGivingSettingsName' => 'abc123',
                    'inactiveMembershipGivingSettingsName' => 'abc123'
                });
            }

        }

        public virtual void getGivingSocietyToEarliestMemberSinceDateTest() {
            setup();

            baseController.getGivingSocietyToEarliestMemberSinceDate(new Map<String, Object>{
                'contactId' => con.Id,
                'whereClause' => ' Id != null'
            });
        }

        public virtual void getTableQueryTest() {
            setup();

            try {
                baseController.getTableQuery(new Map<String, Object>());
            }
            catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

            }

            // not valid query string
            try {
                baseController.getTableQuery(new Map<String, Object>{
                    'queryString' => 'SELECT '
                });
            }
            catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

            }
        }

        public virtual void getTableCountQueryTest() {
            setup();

            try {
                baseController.getTableCountQuery(new Map<String, Object>());
            }
            catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

            }

            // not valid query string
            try {
                baseController.getTableCountQuery(new Map<String, Object>{
                    'queryString' => 'SELECT '
                });
            }
            catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {

            }
        }

    }


    @isTest
    static void getGivingSocietiesListTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getGivingSocietiesListTest();
    }

    @isTest
    static void getGivingSocietyDetailPageTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getGivingSocietyDetailPageTest();
    }

    @isTest
    static void checkIfInGivingSocietyTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().checkIfInGivingSocietyTest();
    }

    @isTest
    static void getDonorStoriesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getDonorStoriesTest();
    }

    @isTest
    static void getDonorStoriesDetailTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getDonorStoriesDetailTest();
    }

    @isTest
    static void getSocityMembersipTableDataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getSocityMembersipTableDataTest();
    }

    @isTest
    static void getGivingSocietyToEarliestMemberSinceDateTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getGivingSocietyToEarliestMemberSinceDateTest();
    }

    @isTest
    static void getTableQueryTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getTableQueryTest();
    }

    @isTest
    static void getTableCountQueryTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingSocietiesControllerBaseTestClass().getTableCountQueryTest();
    }

}