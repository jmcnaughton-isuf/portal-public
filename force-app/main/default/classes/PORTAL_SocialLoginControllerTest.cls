@isTest
public with sharing class PORTAL_SocialLoginControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Auth.UserData userData;
        public Account acct;
        public Contact con;
        public String portalId;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            System.runAs(thisUser) {
                ucinn_ascendv2__Org_Wide_Configuration__c customSetting = new ucinn_ascendv2__Org_Wide_Configuration__c(name='Default Org Wide Config', ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true,
                                                                                                                        ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true);

                customSetting = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => customSetting});
                insert customSetting;
                Id recordType = [SELECT Id, Name FROM RecordType WHERE Name = 'Household'].Id;

                Account accountPortalAccount = new Account(Name = 'ascend Portal Account');
                accountPortalAccount = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => accountPortalAccount});
                insert accountPortalAccount;

                acct = new Account(Name = 'asad', RecordTypeId = recordType);
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(LastName = 'Test', Email = 'test@ucinnovation.com', AccountId = acct.Id);
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                ucinn_ascendv2__Email__c email1 = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Email_Address__c = 'test@ucinnovation.com',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Status__c = 'Current');

                email1 = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email1});
                insert email1;
                userData = new Auth.UserData('testIdentifier', 'FirstName', 'LastName', 'FirstName LastName', 'test@ucinnovation.com', 'https://www.ucinnovation.com/test', 'test@ucinnovation.com', 'us', 'ucinnovation', null, new Map<String, String>());
            }
        }

        public virtual void runCreateUser() {
            setupData();

            PORTAL_SocialLoginController authHandler = new PORTAL_SocialLoginController();
            authHandler.createUser(null, userData);
            User u = authHandler.createUser(null, userData);
            u = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => u});
            insert u;

            userData.attributeMap = new Map<String, String>{'sfdc_networkid' => 'testId'};
            authHandler.createUser(null, userData);
            delete con;
            try {
                authHandler.createUser(null, userData);
            } catch (Exception e) {}

            authHandler.updateUser(u.Id, null, userData);
        }

        public virtual void testGetNamesCases() {
            setupData();

            PORTAL_SocialLoginController controller = new PORTAL_SocialLoginController();

            List<sObject> networkIds = [SELECT Id FROM network];
            
            Test.startTest();

            if (networkIds.size() > 0) {
                userData.attributeMap = new Map<String, String>{'sfdc_networkid' => networkIds[0].Id};
            }
            else {
                userData.attributeMap = new Map<String, String>{'sfdc_networkid' => 'Unable to reach code'};
            }
            controller.createUser(null, userData);

            userData.firstName = '';
            userData.lastName = '';
            userData.fullName = 'Test';
            
            controller.createUser(null, userData);


            userData.firstName = '';
            userData.lastName = '';
            userData.fullName = 'Test Name';
            
            controller.createUser(null, userData);


            userData.firstName = '';
            userData.lastName = '';
            userData.fullName = 'Test Test Name';
            
            controller.createUser(null, userData);

            Contact con2 = new Contact(LastName = 'Test2', Email = 'test2@ucinnovation.com', AccountId = acct.Id);
            con2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con2});
            insert con2;
            
            ucinn_ascendv2__Email__c email2 = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Contact__c = con2.Id, 
                                                                           ucinn_ascendv2__Email_Address__c = 'test@ucinnovation.com', 
                                                                           ucinn_ascendv2__Type__c = 'Business', 
                                                                           ucinn_ascendv2__Status__c = 'Current');
    
            email2 = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email2});
            insert email2;

            ucinn_ascendv2__Contact_Name__c testRelation = new ucinn_ascendv2__Contact_Name__c();
            testRelation.ucinn_ascendv2__Contact__c = con2.Id;
            testRelation.ucinn_ascendv2__Last_Name__c = 'Test';
            insert testRelation;

            try {
                controller.createUser(null, userData);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testCreateUserContactListCase() {
            setupData();

            PORTAL_SocialLoginController controller = new PORTAL_SocialLoginController();

            List<sObject> networkIds = [SELECT Id FROM network];
            
            Test.startTest();

            if (networkIds.size() > 0) {
                userData.attributeMap = new Map<String, String>{'sfdc_networkid' => networkIds[0].Id};
            }
            else {
                userData.attributeMap = new Map<String, String>{'sfdc_networkid' => 'Unable to reach code'};
            }
            
            controller.createUser(null, userData);

            Contact con2 = new Contact(LastName = 'Test2', Email = 'test2@ucinnovation.com', AccountId = acct.Id);
            con2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con2});
            insert con2;
            
            ucinn_ascendv2__Email__c email2 = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Contact__c = con2.Id, 
                                                                           ucinn_ascendv2__Email_Address__c = 'test@ucinnovation.com', 
                                                                           ucinn_ascendv2__Type__c = 'Business', 
                                                                           ucinn_ascendv2__Status__c = 'Current');
    
            email2 = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email2});
            insert email2;

            ucinn_ascendv2__Contact_Name__c testRelation = new ucinn_ascendv2__Contact_Name__c();
            testRelation.ucinn_ascendv2__Contact__c = con.Id;
            testRelation.ucinn_ascendv2__First_Name__c = 'FirstName';
            testRelation.ucinn_ascendv2__Last_Name__c = 'LastName';
            insert testRelation;

            ucinn_ascendv2__Contact_Name__c testRelation2 = new ucinn_ascendv2__Contact_Name__c();
            testRelation2.ucinn_ascendv2__Contact__c = con2.Id;
            testRelation.ucinn_ascendv2__First_Name__c = 'FirstName';
            testRelation2.ucinn_ascendv2__Last_Name__c = 'LastName';
            insert testRelation2;

            try {
                controller.createUser(null, userData);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    static testMethod void runCreateUser() {
        PORTAL_TestClassFactory.getTestClassFactory().getSocialLoginControllerTestClass().runCreateUser();
    }

    static testMethod void testGetNamesCases() {
        PORTAL_TestClassFactory.getTestClassFactory().getSocialLoginControllerTestClass().testGetNamesCases();
    }

    static testMethod void testCreateUserContactListCase() {
        PORTAL_TestClassFactory.getTestClassFactory().getSocialLoginControllerTestClass().testCreateUserContactListCase();
    }
}