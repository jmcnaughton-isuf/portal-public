// test
@isTest
public without sharing class PORTAL_DirectoryControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public Contact dummyContact;
        public Contact dummyContact2;
        public Contact dummyContact3;
        public User communityUser;

        public virtual void setupData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                dummyContact = new Contact();
                dummyContact.FirstName = 'Dummy';
                dummyContact.LastName = 'Contact';
                dummyContact.AccountId = acct.Id;
                dummyContact.ucinn_portal_Is_Display_On_Portal__c = true;
                dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
                insert dummyContact;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = dummyContact.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        CommunityNickname = 'Test',
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;


                dummyContact2 = new Contact();
                dummyContact2.FirstName = 'Dummy';
                dummyContact2.LastName = 'Contact';
                dummyContact2.AccountId = acct.Id;
                dummyContact2.ucinn_portal_Is_Display_On_Portal__c = true;
                dummyContact2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact2});
                insert dummyContact2;

                User communityUser2 = new User(alias = 'comUser1',
                                            email = 'testComUser@test.com',
                                            emailencodingkey='UTF-8',
                                            lastname = 'Bat',
                                            languagelocalekey='en_US',
                                            localesidkey='en_US',
                                            profileid = profileId,
                                            IsActive = true,
                                            ContactId = dummyContact2.Id,
                                            timezonesidkey='America/Los_Angeles',
                                            CommunityNickname = 'Test1',
                                            username = 'testcomUser@test.com');
                communityUser2 = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser2});
                insert communityUser2;

                dummyContact3 = new Contact();
                dummyContact3.FirstName = 'Dummy';
                dummyContact3.LastName = 'Contact';
                dummyContact3.AccountId = acct.Id;
                dummyContact3.ucinn_portal_Is_Display_On_Portal__c = true;
                dummyContact3 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact3});
                insert dummyContact3;

                insert testClassUtil.populateRequiredfieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Contact__c = dummyContact.Id, ucinn_ascendv2__Degree__c = 'AB', ucinn_ascendv2__Conferred_Degree_Year__c = '2017')});
                insert testClassUtil.populateRequiredfieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new ucinn_ascendv2__Affiliation__c(ucinn_ascendv2__Contact__c = dummyContact.Id, ucinn_ascendv2__Job_Title__c = 'Tester', ucinn_ascendv2__Account__c = acct.Id, ucinn_ascendv2__Constituent_Role__c = 'Employee', ucinn_ascendv2__Organization_Role__C = 'Employer')});
            }
        }

        public virtual void testGetContacts() {
            setupData();

            // PORTAL_SearchCategory degreeSearchCategory = new PORTAL_SearchCategory();
            // degreeSearchCategory.objectApiName = 'ucinn_ascendv2__Degree_Information__c';
            // degreeSearchCategory.searchCriteriaList = new List<PORTAL_SearchCriteria>{new PORTAL_SearchCriteria('Degree Year', '2017')};

            Map<Object,Object> degreeSearchCategory = new Map<Object,Object>{'objectApiName' => 'ucinn_ascendv2__Degree_Information__c',
                                                                             'searchCriteriaList' => new List<Object>{
                                                                                 new Map<Object, Object>{
                                                                                     'searchForSelected' => 'Class Year',
                                                                                     'valueList' => new List<Object>{'2017'}
                                                                                    }
                                                                                }
                                                                            };

            PORTAL_DirectoryControllerBase controller = new PORTAL_DirectoryControllerBase();
            controller.getContacts(new Map<String, Object>{PORTAL_DirectoryControllerBase.ZONE_CONST => 'Test'});
            controller.getContacts(new Map<String, Object>{PORTAL_DirectoryControllerBase.ZONE_CONST => 'Main',
                                                           PORTAL_DirectoryControllerBase.SEARCH_CATEGORY_LIST => new List<Object>{
                                                                degreeSearchCategory
                                                           }});
        }

        public virtual void testGetSearchDisplaySettings() {
            PORTAL_DirectoryControllerBase controller = new PORTAL_DirectoryControllerBase();

            controller.getSearchDisplaySettings(new Map<String, Object>{PORTAL_DirectoryControllerBase.ZONE_CONST => 'Main'});
        }

        public virtual void testGetAllDisplayOptions() {
            PORTAL_DirectoryControllerBase controller = new PORTAL_DirectoryControllerBase();

            controller.getAllDisplayOptions(null);
        }

        public virtual void testGetContactInfo() {
            setupData();
            PORTAL_DirectoryControllerBase controller = new PORTAL_DirectoryControllerBase();
    
            System.runAs(communityUser) {
                controller.getContactInfo(null);
                controller.getContactInfo(new Map<String, Object>{PORTAL_DirectoryControllerBase.CONTACT_ID => dummyContact.Id});
            }
        }

        public virtual void testSendMessageToContact() {
            setupData();
            PORTAL_DirectoryControllerBase controller = new PORTAL_DirectoryControllerBase();

            System.runAs(communityUser) {
                controller.sendMessageToContact(null);
                controller.sendMessageToContact(new Map<String, Object>{PORTAL_DirectoryControllerBase.RECEIVER_CONTACT_ID => dummyContact2.Id,
                                                                        PORTAL_DirectoryControllerBase.SUBJECT_CONST => 'Test',
                                                                        PORTAL_DirectoryControllerBase.BODY_CONST => 'Test'});
                controller.sendMessageToContact(new Map<String, Object>{PORTAL_DirectoryControllerBase.RECEIVER_CONTACT_ID => dummyContact3.Id,
                                                                        PORTAL_DirectoryControllerBase.SUBJECT_CONST => 'Test',
                                                                        PORTAL_DirectoryControllerBase.BODY_CONST => 'Test'});
            }
        }

        public virtual void testContactDisplayWrapper() {
            Test.startTest();

            PORTAL_DirectoryControllerBase.ContactDisplayWrapper wrapper = new PORTAL_DirectoryControllerBase.ContactDisplayWrapper(new Map<String, Object>());
            wrapper.contactId = 'Test';
            wrapper.firstName = 'Test';
            wrapper.lastName = 'Test';
            wrapper.degree = 'Test';
            wrapper.degreeYear = 'Test';
            wrapper.jobTitle = 'Test';
            wrapper.companyName = 'Test';

            System.assertEquals('Test', wrapper.contactId);
            System.assertEquals('Test', wrapper.firstName);
            System.assertEquals('Test', wrapper.lastName);
            System.assertEquals('Test', wrapper.degree);
            System.assertEquals('Test', wrapper.degreeYear);
            System.assertEquals('Test', wrapper.jobTitle);
            System.assertEquals('Test', wrapper.companyName);

            Test.stopTest();
        }

        public virtual void testPopulateContactDisplayWrapper() {
            Map<String, Object> degreeInfo = new Map<String, Object>{'degree' => 'Test',
                                                                    'degreeYear' => 'Test'};

            Map<String, Object> employmentInfo = new Map<String, Object>{'employer' => 'Test',
                                                                        'jobTitle' => 'Test'};

            Map<String, Object> contactInfo = new Map<String, Object>{'firstName' => 'Test',
                                                                    'lastName' => 'Test'};

            Map<String, Object> contactMap = new Map<String, Object>{'id' => 'Test',
                                                                    'firstName' => 'Test',
                                                                    'lastName' => 'Test',
                                                                    'degreeInfo' => new List<Map<String,Object>>{degreeInfo},
                                                                    'employments' => new List<Map<String,Object>>{employmentInfo},
                                                                    'contactNames' => new List<Map<String,Object>>{contactInfo}};

            Test.startTest();

            PORTAL_DirectoryControllerBase.ContactDisplayWrapper nullWrapper = new PORTAL_DirectoryControllerBase.ContactDisplayWrapper(null);


            PORTAL_DirectoryControllerBase.ContactDisplayWrapper wrapper = new PORTAL_DirectoryControllerBase.ContactDisplayWrapper(contactMap);

            System.assertEquals('Test', wrapper.contactId);
            System.assertEquals('Test', wrapper.firstName);
            System.assertEquals('Test', wrapper.lastName);
            System.assertEquals('Test', wrapper.degree);
            System.assertEquals('Test', wrapper.degreeYear);
            System.assertEquals('Test', wrapper.jobTitle);
            System.assertEquals('Test', wrapper.companyName);

            Test.stopTest();
        }

        public virtual void testQueryContactListFromIdSet() {
            Set<String> contactIdSet = new Set<String>{'Test'};
            Map<String, Object> params = new Map<String, Object>{'contactIdSet' => contactIdSet};

            Test.startTest();

            PORTAL_DirectoryControllerBase controller = new PORTAL_DirectoryControllerBase();

            try {
                controller.queryContactListFromIdSet(params);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    public static testMethod void testGetContacts() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testGetContacts();
    }

    public static testMethod void testGetSearchDisplaySettings() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testGetSearchDisplaySettings();
    }

    public static testMethod void testGetAllDisplayOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testGetAllDisplayOptions();
    }

    public static testMethod void testGetContactInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testGetContactInfo();
    }

    public static testMethod void testSendMessageToContact() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testSendMessageToContact();
    }

    public static testMethod void testContactDisplayWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testContactDisplayWrapper();
    }

    public static testMethod void testPopulateContactDisplayWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testPopulateContactDisplayWrapper();
    }

    public static testMethod void testQueryContactListFromIdSet() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryControllerBaseTestClass().testQueryContactListFromIdSet();
    }
}