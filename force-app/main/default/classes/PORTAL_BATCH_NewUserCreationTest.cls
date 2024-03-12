@isTest
public with sharing class PORTAL_BATCH_NewUserCreationTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testNewUserCreationWithInterim() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreation());
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 1);
            }
        }

        public virtual void testNewUserCreationWithInterimBlankSource() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__Source_File__c = '';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreation());
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 0);

                List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id FROM ucinn_ascendv2__Interim__c WHERE ucinn_ascendv2__Status__c = 'Manual Review'];
            }
        }

        public virtual void testNewUserCreationWithInterimBlankData() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Email_1__c = '';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreation());
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 0);

                List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id FROM ucinn_ascendv2__Interim__c WHERE ucinn_ascendv2__Status__c = 'Manual Review'];

                System.assert(interimList.size() == 1);
            }
        }

        public virtual void testNewUserCreationWithInterimDupUser() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            User dupUser = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = 'portal.demo@ucinnovation.com.portal',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname='bwayne2'
            );
            dupUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dupUser});
            Database.insert(dupUser);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreation());
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 0);

                List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id FROM ucinn_ascendv2__Interim__c WHERE ucinn_ascendv2__Status__c = 'Manual Review'];

                System.assert(interimList.size() == 1);
            }
        }

        public virtual void testNewUserCreationWithContact() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont.Email = 'demo@ucinnovation.com';
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreationFromContact(new List<String>{String.valueOf(cont.Id)}, 'Alumni Portal'));
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 1);
            }
        }

        public virtual void testNewUserCreationWithBadSourceData() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont.Email = 'demo@ucinnovation.com';
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreationFromContact(new List<String>{String.valueOf(cont.Id)}, 'Bad Network Name'));
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 1);
            }
        }

        public virtual void testNewUserCreationWithCompletedHiringManagerInterim() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE).getRecordTypeId();
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                ucinn_portal_Interim_Employment__c employment = new ucinn_portal_Interim_Employment__c();
                employment.Interim__c = interim.Id;
                employment.Status__c = 'Completed';
                employment.Name = 'UC Innovation';
                employment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => employment});
                insert employment;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreation());
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 1);
            }
        }

        public virtual void testNewUserCreationWithIncompletedHiringManagerInterim() {

            UserRole ur = new UserRole(Name = 'Admin');
            insert ur;

            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User portalAccountOwner = new User(
                UserRoleId = ur.Id,
                ProfileId = p.Id,
                Username = System.now().millisecond() + 'testUC1@testUC1.com',
                Alias = 'bwyane',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            portalAccountOwner = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => portalAccountOwner});
            Database.insert(portalAccountOwner);

            System.runAs(portalAccountOwner){
                Account acct = new Account();
                acct.Name = 'Test Account';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact();
                cont.FirstName = 'Test';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE).getRecordTypeId();
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                ucinn_portal_Interim_Employment__c employment = new ucinn_portal_Interim_Employment__c();
                employment.Interim__c = interim.Id;
                employment.Status__c = 'Pending';
                employment.Name = 'UC Innovation';
                employment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => employment});
                insert employment;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewUserCreation());
                Test.stopTest();

                List<User> userList = [SELECT Id FROM User WHERE ContactId = :cont.Id];

                System.assert(userList.size() == 0);
            }
        }
    }

    @isTest
    public static void testNewUserCreationWithInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithInterim();
    }

    @isTest
    public static void testNewUserCreationWithInterimBlankSource() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithInterimBlankSource();
    }

    @isTest
    public static void testNewUserCreationWithInterimBlankData() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithInterimBlankData();
    }

    @isTest
    public static void testNewUserCreationWithInterimDupUser() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithInterimDupUser();
    }

    @isTest
    public static void testNewUserCreationWithContact() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithContact();
    }

    @isTest
    public static void testNewUserCreationWithBadSourceData() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithBadSourceData();
    }

    @isTest
    public static void testNewUserCreationWithCompletedHiringManagerInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithCompletedHiringManagerInterim();
    }

    @isTest
    public static void testNewUserCreationWithIncompletedHiringManagerInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewUserCreationTestClass().testNewUserCreationWithIncompletedHiringManagerInterim();
    }
}