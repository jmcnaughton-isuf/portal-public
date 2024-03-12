@isTest
public with sharing class PORTAL_CommunityUserControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupUserData() {
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
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                System.debug('communityUser: ' + communityUser.Id);
                System.debug('communityUser.ContactId: ' + communityUser.ContactId);
            }
        }

        public virtual void testGetFrontEndDataMap() {
            Map<String, Object> params = new Map<String, Object>();
            Map<String, Map<String, Object>> returnMap = PORTAL_CommunityUserController.SERVER_getFrontEndDataMap(params);
            System.assert(returnMap.isEmpty());
            params.put('pageName', 'Hiring Manager');
            returnMap = PORTAL_CommunityUserController.SERVER_getFrontEndDataMap(params);
            System.assert(!returnMap.isEmpty());
        }

        public virtual void testGetFrontEndDataMapInvalidInput() {
            Test.startTest();
            try {
                Map<String, Map<String, Object>> returnMap = PORTAL_CommunityUserController.SERVER_getFrontEndDataMap(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
            Test.stopTest();
        }
    
        public virtual void testGetPicklists() {
            Map<String, Object> params = new Map<String, Object>();
            Map<String, List<Map<String, Object>>> picklistMap = PORTAL_CommunityUserController.SERVER_getPicklists(params);
            System.assert(picklistMap.isEmpty());
            params.put('pageName', 'Hiring Manager');
            picklistMap = PORTAL_CommunityUserController.SERVER_getPicklists(params);
            System.assert(!picklistMap.isEmpty());
        }

        public virtual void testGetPicklistsInvalidInput() {
            Test.startTest();

            try {
                PORTAL_CommunityUserController.SERVER_getPicklists(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }
    
        public virtual void testSubmitApplicationWithData() {
            Contact dummyContact = new Contact(FirstName = 'My Information Dummy Contact', LastName = 'Do Not Delete This Record');
            dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
            insert dummyContact;


            Map<String, Object> interim = new Map<String, Object>();
            interim.put('ucinn_ascendv2__Prefix__c', 'Mr.');
            interim.put('ucinn_ascendv2__First_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Middle_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Suffix__c', '');
            interim.put('ucinn_ascendv2__Email_1__c', 'demo@ucinnovation.com');
            interim.put('ucinn_ascendv2__Email_1_Type__c', 'Personal');
            interim.put('ucinn_ascendv2__Phone_1_Type__c', 'Business');
            interim.put('ucinn_ascendv2__Phone_1__c', '9876543210');
            interim.put('ucinn_ascendv2__Address_1_Line_1__c', '2855 Michelle Drive');
            interim.put('ucinn_ascendv2__Address_1_Line_2__c', '');
            interim.put('ucinn_ascendv2__City_1__c', 'Irvine');
            interim.put('ucinn_ascendv2__State_1__c', 'CA');
            interim.put('ucinn_ascendv2__Postal_Code_1__c', '92607');
            interim.put('ucinn_ascendv2__Country_1__c', 'United States');
            interim.put('ucinn_ascendv2__Address_1_Type__c', 'Mailing');
            interim.put('ucinn_portal_Nickname_First_Name__c', 'Test');
            interim.put('ucinn_portal_Nickname_Last_Name__c', 'Test');
            interim.put('ucinn_portal_Maiden_First_Name__c', 'Test');
            interim.put('ucinn_portal_Maiden_Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Birthdate__c', Date.today());
            interim.put('ucinn_ascendv2__Gender__c', 'Male');
            interim.put('ucinn_ascendv2__School_ID__c', 'School Id');

            Map<String, Object> params = new Map<String, Object>();
            params.put('interim', interim);
            params.put('degree', 'BS');
            params.put('degreeYear', '2014');

            PORTAL_CommunityUserController.SERVER_submitNewUserApplication(params);

            List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id, ucinn_ascendv2__First_Name__c, ucinn_ascendv2__Last_Name__c,
                                                            ucinn_ascendv2__Middle_Name__c, ucinn_ascendv2__Prefix__c,
                                                            ucinn_ascendv2__Suffix__c, ucinn_ascendv2__Email_1__c,
                                                            ucinn_ascendv2__Email_1_Type__c, ucinn_ascendv2__Phone_1__c,
                                                            ucinn_ascendv2__Phone_1_Type__c, ucinn_ascendv2__Address_1_Type__c,
                                                            ucinn_ascendv2__Address_1_Line_1__c, ucinn_ascendv2__Address_1_Line_2__c,
                                                            ucinn_ascendv2__City_1__c, ucinn_ascendv2__State_1__c, ucinn_ascendv2__Postal_Code_1__c,
                                                            ucinn_ascendv2__Country_1__c, ucinn_ascendv2__Birthdate__c, ucinn_ascendv2__Gender__c,
                                                            ucinn_ascendv2__School_ID__c, ucinn_portal_Maiden_First_Name__c, ucinn_portal_Maiden_Last_Name__c,
                                                            ucinn_portal_Nickname_First_Name__c, ucinn_portal_Nickname_Last_Name__c
                                                            FROM ucinn_ascendv2__Interim__c];

            System.assert(interimList.size() == 1);

            ucinn_ascendv2__Interim__c insertedInterim = interimList.get(0);

            for (String field : interim.keySet()) {
                if (String.isBlank(String.valueOf(interim.get(field)))) {
                    System.assert(String.isBlank(String.valueOf(insertedInterim.get(field))));
                } else {
                    System.assert(insertedInterim.get(field) == interim.get(field));
                }
            }

            List<ucinn_ascendv2__Degree_Information__c> degreeInfo = [SELECT Id, ucinn_ascendv2__Interim__c, ucinn_ascendv2__Degree__c,
                                                                       ucinn_ascendv2__Conferred_Degree_Year__c, ucinn_ascendv2__Degree_Institution__c,
                                                                       ucinn_ascendv2__Contact__c
                                                                       FROM ucinn_ascendv2__Degree_Information__c];

            System.assert(degreeInfo.size() == 1);

            ucinn_ascendv2__Degree_Information__c degree = degreeInfo.get(0);
            System.assert(degree.ucinn_ascendv2__Conferred_Degree_Year__c == '2014');
            System.assert(degree.ucinn_ascendv2__Degree__c == 'BS');
            System.assert(degree.ucinn_ascendv2__Interim__c == insertedInterim.Id);
            System.assert(degree.ucinn_ascendv2__Contact__c == dummyContact.Id);
        }

        public virtual void testSubmitApplicationWithoutData() {
            Contact dummyContact = new Contact(FirstName = 'My Information Dummy Contact', LastName = 'Do Not Delete This Record');
            dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
            insert dummyContact;

            Map<String, Object> interim = new Map<String, Object>();
            interim.put('ucinn_ascendv2__Prefix__c', 'Mr.');
            interim.put('ucinn_ascendv2__First_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Middle_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Suffix__c', '');
            interim.put('ucinn_ascendv2__Email_1__c', 'demo@ucinnovation.com');
            interim.put('ucinn_ascendv2__Email_1_Type__c', 'Personal');
            interim.put('ucinn_ascendv2__Phone_1_Type__c', 'Business');
            interim.put('ucinn_ascendv2__Phone_1__c', '9876543210');
            interim.put('ucinn_ascendv2__Address_1_Line_1__c', '2855 Michelle Drive');
            interim.put('ucinn_ascendv2__Address_1_Line_2__c', '');
            interim.put('ucinn_ascendv2__City_1__c', 'Irvine');
            interim.put('ucinn_ascendv2__State_1__c', 'CA');
            interim.put('ucinn_ascendv2__Postal_Code_1__c', '92607');
            interim.put('ucinn_ascendv2__Country_1__c', 'United States');
            interim.put('ucinn_ascendv2__Address_1_Type__c', 'Mailing');
            interim.put('ucinn_portal_Nickname_First_Name__c', 'Test');
            interim.put('ucinn_portal_Nickname_Last_Name__c', 'Test');
            interim.put('ucinn_portal_Maiden_First_Name__c', 'Test');
            interim.put('ucinn_portal_Maiden_Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Birthdate__c', Date.today());
            interim.put('ucinn_ascendv2__Gender__c', 'Male');
            interim.put('ucinn_ascendv2__School_ID__c', 'School Id');
    
            Map<String, Object> params = new Map<String, Object>();
            
            try {
                PORTAL_CommunityUserController.SERVER_submitNewUserApplication(params);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }
        
        public virtual void testSubmitApplicationWithFailure() {
            Test.startTest();
            
            try {
                PORTAL_CommunityUserController.SERVER_submitNewUserApplication(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
            
            Test.stopTest();
        }
        
        public virtual void testSubmitNewUserApplicationWithoutAccount() {
            Map<String, Object> interim = new Map<String, Object>();
            interim.put('ucinn_ascendv2__Prefix__c', 'Mr.');
            interim.put('ucinn_ascendv2__First_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Middle_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Suffix__c', '');
            interim.put('ucinn_ascendv2__Email_1__c', 'demo@ucinnovation.com');
            interim.put('ucinn_ascendv2__Email_1_Type__c', 'Personal');
            interim.put('ucinn_ascendv2__Phone_1_Type__c', 'Business');
            interim.put('ucinn_ascendv2__Phone_1__c', '9876543210');
            interim.put('ucinn_ascendv2__Address_1_Line_1__c', '2855 Michelle Drive');
            interim.put('ucinn_ascendv2__Address_1_Line_2__c', '');
            interim.put('ucinn_ascendv2__City_1__c', 'Irvine');
            interim.put('ucinn_ascendv2__State_1__c', 'CA');
            interim.put('ucinn_ascendv2__Postal_Code_1__c', '92607');
            interim.put('ucinn_ascendv2__Country_1__c', 'United States');
            interim.put('ucinn_ascendv2__Address_1_Type__c', 'Mailing');
            interim.put('ucinn_portal_Nickname_First_Name__c', 'Test');
            interim.put('ucinn_portal_Nickname_Last_Name__c', 'Test');
            interim.put('ucinn_portal_Maiden_First_Name__c', 'Test');
            interim.put('ucinn_portal_Maiden_Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Birthdate__c', Date.today());
            interim.put('ucinn_ascendv2__Gender__c', 'Male');
            interim.put('ucinn_ascendv2__School_ID__c', 'School Id');

            Map<String, Object> params = new Map<String, Object>();
            params.put('interim', interim);
            params.put('degree', 'BS');
            params.put('degreeYear', '2014');

            Test.startTest();

            try {
                List<Contact> dummyContactList = [SELECT Id FROM Contact WHERE FirstName = :PORTAL_CONST_Global.DUMMY_CONTACT_FIRST_NAME AND LastName = :PORTAL_CONST_Global.DUMMY_CONTACT_LAST_NAME];

                delete dummyContactList;

                PORTAL_CommunityUserController.SERVER_submitNewUserApplication(params);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testSubmitHiringManagerApplication() {
            Map<String, Object> interim = new Map<String, Object>();
            interim.put('ucinn_ascendv2__First_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Email_1__c', 'demo@ucinnovation.com');
            interim.put('ucinn_ascendv2__Email_1_Type__c', 'Personal');
            interim.put('ucinn_ascendv2__Phone_1_Type__c', 'Business');
            interim.put('ucinn_ascendv2__Phone_1__c', '9876543210');

            Map<String, Object> interimEmployment = new Map<String, Object>();
            interimEmployment.put('Name', 'UC Innovation');
            interimEmployment.put('Job_Title__c', 'Hiring Manager');
            interimEmployment.put('Email__c', 'demo@ucinnovation.com');
            interimEmployment.put('Phone__c', '9876543210');
            interimEmployment.put('Address_Line_1__c', '2855 Michelle Drive');
            interimEmployment.put('Address_Line_2__c', '');
            interimEmployment.put('City__c', 'Irvine');
            interimEmployment.put('State__c', 'CA');
            interimEmployment.put('Postal_Code__c', '92607');
            interimEmployment.put('Country__c', 'United States');
            interimEmployment.put('Website__c', 'ucinnovation.com');
            interimEmployment.put('LinkedIn_URL__c', 'linkedin.com');
            interimEmployment.put('Industry__c', 'Consulting');
            interimEmployment.put('Description__c', 'We are a CRM company');

            Map<String, Object> data = new Map<String, Object>();
            data.put('ucinn_ascendv2__Interim__c', interim);
            data.put('ucinn_portal_Interim_Employment__c', interimEmployment);

            Map<String, Object> params = new Map<String, Object>();
            params.put('data', data);

            PORTAL_CommunityUserController.SERVER_submitHiringManagerApplication(params);

            List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id, ucinn_ascendv2__First_Name__c, ucinn_ascendv2__Last_Name__c,
                                                                ucinn_ascendv2__Middle_Name__c, ucinn_ascendv2__Prefix__c,
                                                                ucinn_ascendv2__Suffix__c, ucinn_ascendv2__Email_1__c,
                                                                ucinn_ascendv2__Email_1_Type__c, ucinn_ascendv2__Phone_1__c,
                                                                ucinn_ascendv2__Phone_1_Type__c, ucinn_ascendv2__Address_1_Type__c,
                                                                ucinn_ascendv2__Address_1_Line_1__c, ucinn_ascendv2__Address_1_Line_2__c,
                                                                ucinn_ascendv2__City_1__c, ucinn_ascendv2__State_1__c, ucinn_ascendv2__Postal_Code_1__c,
                                                                ucinn_ascendv2__Country_1__c, ucinn_ascendv2__Birthdate__c, ucinn_ascendv2__Gender__c,
                                                                ucinn_ascendv2__School_ID__c, ucinn_portal_Maiden_First_Name__c, ucinn_portal_Maiden_Last_Name__c,
                                                                ucinn_portal_Nickname_First_Name__c, ucinn_portal_Nickname_Last_Name__c
                                                                FROM ucinn_ascendv2__Interim__c];

            System.assert(interimList.size() == 1);

            ucinn_ascendv2__Interim__c insertedInterim = interimList.get(0);

            for (String field : interim.keySet()) {
                if (String.isBlank(String.valueOf(interim.get(field)))) {
                    System.assert(String.isBlank(String.valueOf(insertedInterim.get(field))));
                } else {
                    System.assert(insertedInterim.get(field) == interim.get(field));
                }
            }

            List<ucinn_portal_Interim_Employment__c> interimEmployments = [SELECT Id, Name, Email__c, Phone__c, Website__c, Description__c,
                                                                             LinkedIn_URL__c, Industry__c, Job_Title__c, Address_Line_1__c,
                                                                                Address_Line_2__c, City__c, State__c, Postal_Code__c,
                                                                                Country__c
                                                                            FROM ucinn_portal_Interim_Employment__c];

            System.assert(interimEmployments.size() == 1);

            ucinn_portal_Interim_Employment__c employment = interimEmployments.get(0);

            for (String field : interimEmployment.keyset()) {
                if (String.isBlank(String.valueOf(interimEmployment.get(field)))) {
                    System.assert(String.isBlank(String.valueOf(employment.get(field))));
                } else {
                    System.assert(employment.get(field) == interimEmployment.get(field));
                }
            }
        }

        public virtual void testSubmitHiringManagerApplicationInvalidInput() {
            Test.startTest();

            try {
                PORTAL_CommunityUserController.SERVER_submitHiringManagerApplication(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Map<String, Object> data = new Map<String, Object>();
            data.put('ucinn_ascendv2__Interim__c', new Map<String, Object>());
            data.put('ucinn_portal_Interim_Employment__c', new Map<String, Object>{'Postal_Code__c' => '123456789012345678901234567890'}); // max is 20 chars
            Map<String, Object> params = new Map<String, Object>();
            params.put('data', data);

            try {
                PORTAL_CommunityUserController.SERVER_submitHiringManagerApplication(params);
                System.assert(false);
            } catch (AuraHandledException e) { }

            Test.stopTest();
        }
    
        public virtual void testChangePassword() {
            Map<String, Object> params = new Map<String, Object>();

            params.put('oldPassword', 'Test');
            params.put('newPassword', 'Test');
            params.put('passwordConfirmation', 'Test');

            PORTAL_CommunityUserController.SERVER_changePassword(params);
        }

        public virtual void testChangeWithBlankDataPassword() {
            Map<String, Object> params = new Map<String, Object>();

            params.put('oldPassword', '');
            params.put('newPassword', '');
            params.put('passwordConfirmation', '');

            try {
                PORTAL_CommunityUserController.SERVER_changePassword(params);
            } catch (Exception e) {
    
            }
        }

        public virtual void testChangePasswordInvalidInput() {
            Test.startTest();

            try {
                PORTAL_CommunityUserController.SERVER_changePassword(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetUserData() {
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
                                    email = 'testCommunityUserf14@test.com',
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

            Test.startTest();

            System.runAs(comUser) {
                User result = PORTAL_CommunityUserController.SERVER_getUserData(new Map<String, Object>());
                System.assertEquals('testcommunityuserf14@test.com', result.Email);
            }

            Test.stopTest();
        }

        public virtual void testGetUserDataInvalidInput() {
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
                Username = System.now().millisecond() + 'testUC2@testUC2.com',
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
            
            Test.startTest();

            try {
                System.runAs(portalAccountOwner) {
                    PORTAL_CommunityUserController.SERVER_getUserData(null);
                }
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    
        public virtual void testChangeUsername() {
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
                Map<String, Object> params = new Map<String, Object>();
                String newUserName = System.now().millisecond() + 'bruce.banner@test.com';

                params.put('username', newUserName);

                PORTAL_CommunityUserController.SERVER_changeUsername(params);

                List<User> userList = [SELECT Id, Username FROM User WHERE Username = :newUserName];
                System.assert(userList.size() == 1);

            }
        }

        public virtual void testChangeBlankUsername() {
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
                Map<String, Object> params = new Map<String, Object>();

                params.put('username', '');

                try {
                    PORTAL_CommunityUserController.SERVER_changeUsername(params);
                } catch (Exception e) {

                }

                List<User> userList = [SELECT Id, Username FROM User WHERE Username = 'bruce.banner@test.com'];
                System.assert(userList.size() == 0);

            }
        }

        public virtual void testChangeUsernameFailure() {
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
                Username = System.now().millisecond() + 'testUC2@testUC2.com',
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
                Map<String, Object> params = new Map<String, Object>();

                params.put('username', dupUser.Username);

                try {
                    PORTAL_CommunityUserController.SERVER_changeUsername(null);
                } catch (Exception e) {

                }

            }
        }

        public virtual void testChangeEmail() {
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
                Map<String, Object> params = new Map<String, Object>();

                params.put('email', 'bruce.banner@test.com');

                PORTAL_CommunityUserController.SERVER_changeEmail(params);

                List<User> userList = [SELECT Id, Email FROM User WHERE Email = 'bruce.banner@test.com'];
                System.assert(userList.size() == 1);

            }
        }

        public virtual void testChangeBlankEmail() {
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
                Map<String, Object> params = new Map<String, Object>();

                params.put('email', '');

                try {
                    PORTAL_CommunityUserController.SERVER_changeEmail(params);
                } catch (Exception e) {

                }

                List<User> userList = [SELECT Id, Email FROM User WHERE Email = 'bruce.banner@test.com'];
                System.assert(userList.size() == 0);

            }
        }

        public virtual void testChangeEmailFailure() {
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
                Map<String, Object> params = new Map<String, Object>();

                params.put('email', 'bruce.banner@@test.com');

               try {
                    PORTAL_CommunityUserController.SERVER_changeEmail(params);
               } catch (Exception e) {

               }

                List<User> userList = [SELECT Id, Email FROM User WHERE Email = 'bruce.wayne@wayneenterprises.com'];
                System.assert(userList.size() == 1);

            }
        }

        public virtual void testCreateUserWithoutInterim() {
            Map<String, Object> params = new Map<String, Object>();
            PORTAL_CommunityUserController.SERVER_createUserFromInterim(params);
        }

        public virtual void testCreateUserWithInterim() {
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

            System.runAs(portalAccountOwner) {
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

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__First_Name__c = 'Test';
                interim.ucinn_ascendv2__Last_Name__c = 'Test';
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Source_File__c = 'Alumni Portal';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                Map<String, Object> params = new Map<String, Object>();
                params.put('interimId', interim.Id);
                PORTAL_CommunityUserController.SERVER_createUserFromInterim(params);

                List<User> users = [SELECT Id FROM User WHERE Username = 'portal.demo@ucinnovation.com.portal'];
                System.assert(users.size() == 1);

            }
        }

        public virtual void testCreateUserWithEmptySourceFileInterim() {
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

            System.runAs(portalAccountOwner) {
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

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__First_Name__c = 'Test';
                interim.ucinn_ascendv2__Last_Name__c = 'Test';
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

               try {
                    Map<String, Object> params = new Map<String, Object>();
                    params.put('interimId', interim.Id);
                    PORTAL_CommunityUserController.SERVER_createUserFromInterim(params);
               } catch (Exception e) {

               }

            }
        }

        public virtual void testCreateUserWithIncompleteInterim() {
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

            System.runAs(portalAccountOwner) {
                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__First_Name__c = 'Test';
                interim.ucinn_ascendv2__Last_Name__c = 'Test';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                try {
                    Map<String, Object> params = new Map<String, Object>();
                    params.put('interimId', interim.Id);
                    PORTAL_CommunityUserController.SERVER_createUserFromInterim(params);
                } catch (Exception e) {

                }
            }
        }

        public virtual void testCreateUserWithIncompleteInterimEmployment() {
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

            System.runAs(portalAccountOwner) {
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

                ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                interim.ucinn_ascendv2__First_Name__c = 'Test';
                interim.ucinn_ascendv2__Last_Name__c = 'Test';
                interim.ucinn_ascendv2__Contact__c = cont.Id;
                interim.ucinn_ascendv2__Status__c = 'Completed';
                interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE).getRecordTypeId();
                interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
                insert interim;

                ucinn_portal_Interim_Employment__c employment = new ucinn_portal_Interim_Employment__c();
                employment.Name = 'Test';
                employment.Interim__c = interim.Id;
                employment.Status__c = 'Manual Review';
                employment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => employment});
                insert employment;

                try {
                    Map<String, Object> params = new Map<String, Object>();
                    params.put('interimId', interim.Id);
                    PORTAL_CommunityUserController.SERVER_createUserFromInterim(params);
                } catch (Exception e) {
                    System.debug(e.getMessage());
                    System.debug(e.getStackTraceString());
                }
            }
        }

        public virtual void testCreateUserInvalidInput() {
            Test.startTest();

            try {
                PORTAL_CommunityUserController.SERVER_createUserFromInterim(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testSendNewUserRegistrationEmails() {
            Test.startTest();
            PORTAL_CommunityUserControllerBase controller = new PORTAL_CommunityUserControllerBase();
            controller.sendNewUserRegistrationEmails(null, '');
            controller.sendNewUserRegistrationEmails(new ucinn_ascendv2__Interim__c(), 'adsfasfdsaf does not exist');
            controller.sendNewUserRegistrationEmails(new ucinn_ascendv2__Interim__c(ucinn_ascendv2__First_Name__c = 'Test'), 'Portal_New_User_Registration');
            Test.stopTest();
        }

        public virtual void testSendUsernameToEmail() {
            Test.startTest();

            try {
                setupUserData();
                Map<String, Object> params = new Map<String, Object>{
                    'emailTemplateDeveloperName' => 'Portal_Send_Username',
                    'emailAddress' => 'testCommunityUsermig123@test.com'
                };
                PORTAL_CommunityUserController.SERVER_sendUsernameToEmail(params);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }
    }


    @isTest
    public static void testGetFrontEndDataMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testGetFrontEndDataMap();
    }

    @isTest
    public static void testGetFrontEndDataMapInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testGetFrontEndDataMapInvalidInput();
    }
    
    @isTest
    public static void testGetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testGetPicklists();
    }

    @isTest
    public static void testGetPicklistsInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testGetPicklistsInvalidInput();
    }

    @isTest
    public static void testSubmitApplicationWithData() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSubmitApplicationWithData();
    }

    @isTest
    public static void testSubmitApplicationWithoutData() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSubmitApplicationWithoutData();
    }

    @isTest
    public static void testSubmitApplicationWithFailure() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSubmitApplicationWithFailure();
    }

    @isTest
    public static void testSubmitNewUserApplicationWithoutAccount() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSubmitNewUserApplicationWithoutAccount();
    }

    @isTest
    public static void testSubmitHiringManagerApplication() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSubmitHiringManagerApplication();
    }

    @isTest
    public static void testSubmitHiringManagerApplicationInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSubmitHiringManagerApplicationInvalidInput();
    }

    @isTest
    public static void testChangePassword() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangePassword();
    }

    @isTest
    public static void testChangeWithBlankDataPassword() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeWithBlankDataPassword();
    }

    @isTest
    public static void testChangePasswordInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangePasswordInvalidInput();
    }

    @isTest
    public static void testGetUserData() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testGetUserData();
    }

    @isTest
    public static void testGetUserDataInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testGetUserDataInvalidInput();
    }

    @isTest
    public static void testChangeUsername() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeUsername();
    }

    @isTest
    public static void testChangeBlankUsername() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeBlankUsername();
    }

    @isTest
    public static void testChangeUsernameFailure() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeUsernameFailure();
    }

    @isTest
    public static void testChangeEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeEmail();
    }

    @isTest
    public static void testChangeBlankEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeBlankEmail();
    }

    @isTest
    public static void testChangeEmailFailure() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testChangeEmailFailure();
    }


    @isTest
    public static void testCreateUserWithoutInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testCreateUserWithoutInterim();
    }


    @isTest
    public static void testCreateUserWithInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testCreateUserWithInterim();
    }

    @isTest
    public static void testCreateUserWithEmptySourceFileInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testCreateUserWithEmptySourceFileInterim();
    }

    @isTest
    public static void testCreateUserWithIncompleteInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testCreateUserWithIncompleteInterim();
    }

    @isTest
    public static void testCreateUserWithIncompleteInterimEmployment() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testCreateUserWithIncompleteInterimEmployment();
    }

    @isTest
    public static void testCreateUserInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testCreateUserInvalidInput();
    }

    /**
     * code coverage for sendNewUserRegistrationEmails helper
     * 
     * @author Jacob Huang
     * @since 1.9
     */
    @isTest
    public static void testSendNewUserRegistrationEmails() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSendNewUserRegistrationEmails();
    }

    /**
     * code coverage for sendUsernameToEmail
     * 
     * @author Todd Shinto
     * @since 1.11
     */
    @isTest
    public static void testSendUsernameToEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getCommunityUserControllerTestClass().testSendUsernameToEmail();
    }
}