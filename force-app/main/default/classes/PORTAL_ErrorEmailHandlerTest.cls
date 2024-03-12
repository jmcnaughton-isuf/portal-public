@isTest
public without sharing class PORTAL_ErrorEmailHandlerTest{
    public virtual class TestClass extends PORTAL_TestClassBase{
        public List<User> userList;
        public List<String> emailList;
        public List<PORTAL_CommunityUtils.EmailRecipient> emailRecipientList;
        public PORTAL_ErrorEmailHandler.ErrorDetails errorDetailsObject;


        public virtual void setUpEmailList() {
            emailList = new List<String>();

            String userEmail1 = 'testuser1@test.com';
            String userEmail2 = 'testuser2@test.com';
            String userEmail3 = 'testuser3@test.com';

            String testEmail1 = 'testemail1@test.com';
            String testEmail2 = 'testemail2@test.com';
            String testEmail3 = 'testemail3@test.com';

            emailList.add(userEmail1);
            emailList.add(userEmail2);
            emailList.add(userEmail3);
            emailList.add(testEmail1);
            emailList.add(testEmail2);
            emailList.add(testEmail3);
        }

        public virtual void setUpEmailRecipientList() {
            PORTAL_CommunityUtils.EmailRecipient testRecipient1 = new PORTAL_CommunityUtils.EmailRecipient('Test First Name 1',
                                                                                                           'Test Last Name 1',
                                                                                                           'testuser1@test.com');
            PORTAL_CommunityUtils.EmailRecipient testRecipient2 = new PORTAL_CommunityUtils.EmailRecipient('Test First Name 2',
                                                                                                           'Test Last Name 2',
                                                                                                           'testuser2@test.com');
            PORTAL_CommunityUtils.EmailRecipient testRecipient3 = new PORTAL_CommunityUtils.EmailRecipient('Test First Name 3',
                                                                                                           'Test Last Name 3',
                                                                                                           'testuser3@test.com');

            PORTAL_CommunityUtils.EmailRecipient testRecipient4 = new PORTAL_CommunityUtils.EmailRecipient('DefaultFirstName',
                                                                                                           'DefaultLastName',
                                                                                                           'testemail1@test.com');
            PORTAL_CommunityUtils.EmailRecipient testRecipient5 = new PORTAL_CommunityUtils.EmailRecipient('DefaultFirstName',
                                                                                                           'DefaultLastName',
                                                                                                           'testemail2@test.com');
            PORTAL_CommunityUtils.EmailRecipient testRecipient6 = new PORTAL_CommunityUtils.EmailRecipient('DefaultFirstName',
                                                                                                           'DefaultLastName',
                                                                                                           'testemail3@test.com');

            emailRecipientList.add(testRecipient1);
            emailRecipientList.add(testRecipient2);
            emailRecipientList.add(testRecipient3);
            emailRecipientList.add(testRecipient4);
            emailRecipientList.add(testRecipient5);
            emailRecipientList.add(testRecipient6);
        }

        public virtual void setUpErrorDetailsObject() {
            errorDetailsObject = new PORTAL_ErrorEmailHandler.ErrorDetails();

            errorDetailsObject.errorMessage = 'Test Error Message';
            errorDetailsObject.stacktrace = 'Test Stacktrace';
            errorDetailsObject.className = 'Test Class Name';
        }

        public virtual void testPublishEmailEvent() {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();

            try {
                errorEmailHandler.publishEmailEvent(new AuraHandledException('Test Exception'), 'Test Class Name');
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testSendEmails() {
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
                                    email = 'test@ucinnovation.com',
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

            List<PORTAL_ErrorEmailHandler.ErrorDetails> errorDetailList = new List<PORTAL_ErrorEmailHandler.ErrorDetails>();

            setUpErrorDetailsObject();
            errorDetailList.add(errorDetailsObject);

            try {
                System.runAs(comUser) {
                    PORTAL_ErrorEmailHandler.sendEmails(errorDetailList);
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testNullErrorDetailList() {
            List<PORTAL_ErrorEmailHandler.ErrorDetails> errorDetailList = null;

            try {
                PORTAL_ErrorEmailHandler.sendEmails(errorDetailList);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testNullUserList() {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();

            setUpEmailList();
            userList = null;

            try {
                errorEmailHandler.getEmailRecipientList(userList, emailList);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testNullEmailList() {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();

            emailList = null;

            try {
                errorEmailHandler.getEmailRecipientList(userList, emailList);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testEmptyEmailToUserMap() {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            emailRecipientList = new List<PORTAL_CommunityUtils.EmailRecipient>();

            try {
                errorEmailHandler.createEmailRecordList(emailRecipientList);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testEmailRecipientBlankFirstName() {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();

            PORTAL_CommunityUtils.EmailRecipient testEmailRecipient = new PORTAL_CommunityUtils.EmailRecipient('',
                                                                                                               'Test Last Name',
                                                                                                               'testemail@test.com');

            EmailTemplate testEmailTemplate = new EmailTemplate();
            User testUser = new User();

            try {
                errorEmailHandler.createEmailRecord(testEmailRecipient, testEmailTemplate, testUser);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testNullEmailTemplate() {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();

            EmailTemplate testEmailTemplate = null;
            PORTAL_CommunityUtils.EmailRecipient testEmailRecipient = new PORTAL_CommunityUtils.EmailRecipient('Test First Name',
                                                                                                               'Test Last Name',
                                                                                                               'testemail@test.com');

            try {
                errorEmailHandler.replaceMergeFields(testEmailRecipient, testEmailTemplate);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetEmailRecipientList() {
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
                                    email = 'test@ucinnovation.com',
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
            PORTAL_ErrorEmailHandler controller = new PORTAL_ErrorEmailHandler();

            Test.startTest();

            controller.getEmailRecipientList(new List<User>{comUser}, new List<String>{'test@ucinnovation.com', 'testCommunityUserf14@test.com'});

            Test.stopTest();
        }

        public virtual void testCreateEmailRecord() {
            setUpErrorDetailsObject();
            PORTAL_CommunityUtils.EmailRecipient testRecipient1 = new PORTAL_CommunityUtils.EmailRecipient('Test First Name 1',
                                                                                                           'Test Last Name 1',
                                                                                                           'testuser1@test.com');
            EmailTemplate testEmailTemplate = new EmailTemplate();
            PORTAL_ErrorEmailHandler controller = new PORTAL_ErrorEmailHandler();

            controller.errorDetailsObject = errorDetailsObject;

            Test.startTest();

            controller.createEmailRecord(testRecipient1, testEmailTemplate, thisUser);

            Test.stopTest();
        }

        public virtual void testReplaceMergeFields() {
            setUpErrorDetailsObject();
            PORTAL_CommunityUtils.EmailRecipient testRecipient1 = new PORTAL_CommunityUtils.EmailRecipient('Test First Name 1',
                                                                                                           'Test Last Name 1',
                                                                                                           'testuser1@test.com');
            EmailTemplate testEmailTemplate = new EmailTemplate(HtmlValue = 'Test');
            PORTAL_ErrorEmailHandler controller = new PORTAL_ErrorEmailHandler();

            controller.errorDetailsObject = errorDetailsObject;

            Test.startTest();

            controller.replaceMergeFields(testRecipient1, testEmailTemplate);

            Test.stopTest();
        }
    }

    @isTest
    static void testPublishEmailEvent() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testPublishEmailEvent();
    }

    @isTest
    static void testSendEmails() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testSendEmails();
    }

    @isTest
    static void testNullErrorDetailList() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testNullErrorDetailList();
    }

    @isTest
    static void testNullUserList() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testNullUserList();
    }

    @isTest
    static void testNullEmailList() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testNullEmailList();
    }

    @isTest
    static void testEmptyEmailToUserMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testEmptyEmailToUserMap();
    }

    @isTest
    static void testEmailRecipientBlankFirstName() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testEmailRecipientBlankFirstName();
    }

    @isTest
    static void testNullEmailTemplate() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testNullEmailTemplate();
    }

    @isTest
    static void testGetEmailRecipientList() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testGetEmailRecipientList();
    }

    @isTest
    static void testCreateEmailRecord() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testCreateEmailRecord();
    }

    @isTest
    static void testReplaceMergeFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getErrorEmailHandlerTestClass().testReplaceMergeFields();
    }
}