@isTest
public without sharing class PORTAL_OnlineGivingControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetPicklists() {
            Map<String, Object> params =  new Map<String, Object>();
            params.put('field', 'ucinn_ascendv2__Frequency__c');
            params.put('sobjectType', 'Opportunity');
            PORTAL_OnlineGivingController.SERVER_getPicklists(params);
        }


        public virtual void testGetPicklistsFailure() {
            Map<String, Object> params =  new Map<String, Object>();
            params.put('field', 'ucinn_ascendv2__Frequency__c');
            params.put('sObjectType', 'Opportunity');
            PORTAL_OnlineGivingController.SERVER_getPicklists(params);
        }


        public virtual void testGetFeaturedDesignations() {
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            designation.ucinn_ascendv2__External_System_Id__c = 'test';
            insert designation;
            ucinn_ascendv2__Designation__c designation2 = new ucinn_ascendv2__Designation__c();
            designation2.Name = 'Test Designation 2';
            designation2.ucinn_portal_Is_Display_On_Portal__c = true;
            designation2.ucinn_portal_Display_Order__c = '2';
            insert designation2;
            Map<String, Object> params =  new Map<String, Object>();
            params.put('designations', String.valueOf(designation.ucinn_ascendv2__External_System_Id__c));
            params.put('pageName', 'Online Giving');
            List<Map<String, Object>> designationList = PORTAL_OnlineGivingController.SERVER_getFeaturedDesignations(params);
            System.assert(designationList.size() == 1);
        }


        public virtual void testGetPledgeData() {
            Contact con = new Contact(
                LastName = 'Test_Contact',
                Email = 'testCommunityUsermig123@test.com');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            RecordType giftOppRecordType = [SELECT Id, Name, Description ,DeveloperName, SobjectType
                                            FROM RecordType
                                            WHERE SobjectType = 'Opportunity'
                                            AND DeveloperName = 'Pledge'];

            Opportunity opp = new Opportunity(
                Name = 'Pledge',
                StageName = 'Active',
                Amount = 1000,
                CloseDate = Date.parse('10/10/2040'),
                AccountId = acct.Id,
                RecordTypeId = giftOppRecordType.Id,
                ucinn_portal_Is_Display_On_Portal__c = true,
                ucinn_ascendv2__Contact__c = con.Id,
                ucinn_ascendv2__External_System_Id__c = 'testExternalSystemId'
            );
            opp = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp});
            insert opp;

            ucinn_ascendv2__Designation_Detail__c desigDetail = new ucinn_ascendv2__Designation_Detail__c(
                ucinn_ascendv2__Opportunity__c = opp.Id,
                ucinn_portal_Is_Display_On_Portal__c = true
            );
            desigDetail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => desigDetail});
            insert desigDetail;

            ucinn_ascendv2__Installment__c installment1 = new ucinn_ascendv2__Installment__c(
                ucinn_ascendv2__Opportunity__c = opp.Id,
                ucinn_ascendv2__Amount__c = 100,
                ucinn_ascendv2__Designation_Detail__c = desigDetail.Id,
                ucinn_ascendv2__Expected_Date__c = Date.parse('1/10/2040')
            );
            installment1 = (ucinn_ascendv2__Installment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => installment1});
            insert installment1;

            ucinn_ascendv2__Installment__c installment2 = new ucinn_ascendv2__Installment__c(
                ucinn_ascendv2__Opportunity__c = opp.Id,
                ucinn_ascendv2__Amount__c = 300,
                ucinn_ascendv2__Designation_Detail__c = desigDetail.Id,
                ucinn_ascendv2__Expected_Date__c = Date.parse('2/10/2040')
            );
            installment2 = (ucinn_ascendv2__Installment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => installment2});
            insert installment2;

            ucinn_ascendv2__Installment__c installment3 = new ucinn_ascendv2__Installment__c(
                ucinn_ascendv2__Opportunity__c = opp.Id,
                ucinn_ascendv2__Amount__c = 100,
                ucinn_ascendv2__Designation_Detail__c = desigDetail.Id,
                ucinn_ascendv2__Expected_Date__c = Date.parse('3/10/2040')
            );
            installment3 = (ucinn_ascendv2__Installment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => installment3});
            insert installment3;

            Test.startTest();
            try {
                PORTAL_OnlineGivingController.SERVER_getPledgeData(new Map<String, Object>());
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_OnlineGivingController.SERVER_getPledgeData(new Map<String, Object>{'pledgeId' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_OnlineGivingController.SERVER_getPledgeData(new Map<String, Object>{'pledgeId' => opp.ucinn_ascendv2__External_System_Id__c});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
            Test.stopTest();
        }


        public virtual void testGetAllDesignations() {
            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;
            Map<String, Object> params =  new Map<String, Object>();
            params.put('pageName', 'Online Giving');
            List<Map<String, Object>> designationList = PORTAL_OnlineGivingController.SERVER_getAllDesignations(params);
            System.assert(designationList.size() == 1);
        }


        public virtual void testGetCategoryDesignations() {
            ucinn_ascendv2__Academic_Organization__c academicOrg = new ucinn_ascendv2__Academic_Organization__c();
            academicOrg.Name = 'Test Academic Org';
            insert academicOrg;

            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            designation.ucinn_ascendv2__X1_Academic_Org__c = academicOrg.Id;
            insert designation;
            Map<String, Object> params =  new Map<String, Object>();
            params.put('pageName', 'Online Giving');
            List<Map<String, Object>> designationList = PORTAL_OnlineGivingController.SERVER_getDesignationsByCategory(params);
        }


        public virtual void testSearchDesignations() {

            Map<String, Object> params = new Map<String, Object>();

            PORTAL_OnlineGivingController.SERVER_searchDesignations(params);

            params.put(PORTAL_OnlineGivingControllerBase.PAGE_NAME, 'Online Giving');
            params.put(PORTAL_OnlineGivingControllerBase.KEYWORD_KEY, 'ascend');
            params.put(PORTAL_OnlineGivingControllerBase.OFFSET_KEY, 0);
            params.put(PORTAL_OnlineGivingControllerBase.FIELD_NAMES_LIST, new List<Object>{'Name','ucinn_ascendv2__Designation_Name__c'});

            PORTAL_OnlineGivingController.SERVER_searchDesignations(params);

            try {
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }


        public virtual void testSearchDesignationsWithNoSearchFields() {

            Map<String, Object> params = new Map<String, Object>();

            PORTAL_OnlineGivingController.SERVER_searchDesignations(params);

            params.put(PORTAL_OnlineGivingControllerBase.PAGE_NAME, 'Online Giving');
            params.put(PORTAL_OnlineGivingControllerBase.KEYWORD_KEY, 'ascend');
            params.put(PORTAL_OnlineGivingControllerBase.OFFSET_KEY, 0);
            params.put(PORTAL_OnlineGivingControllerBase.FIELD_NAMES_LIST, new List<Object>{});

            PORTAL_OnlineGivingController.SERVER_searchDesignations(params);

            try {
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }


        public virtual void testSearchDesignationsWithAllEmptyFields() {
            Map<String, Object> params = new Map<String, Object>();

            params.put(PORTAL_OnlineGivingControllerBase.PAGE_NAME, 'Online Giving');
            params.put(PORTAL_OnlineGivingControllerBase.KEYWORD_KEY, 'ascend');
            params.put(PORTAL_OnlineGivingControllerBase.OFFSET_KEY, 0);
            params.put(PORTAL_OnlineGivingControllerBase.FIELD_NAMES_LIST, new List<Object>{'','',''});

            PORTAL_OnlineGivingController.SERVER_searchDesignations(params);

            try {
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }
 

        public virtual void testSearchDesignationsWithSomeEmptyFields() {
            Map<String, Object> params = new Map<String, Object>();

            params.put(PORTAL_OnlineGivingControllerBase.PAGE_NAME, 'Online Giving');
            params.put(PORTAL_OnlineGivingControllerBase.KEYWORD_KEY, 'ascend');
            params.put(PORTAL_OnlineGivingControllerBase.OFFSET_KEY, 0);
            params.put(PORTAL_OnlineGivingControllerBase.FIELD_NAMES_LIST, new List<Object>{'Name','','ucinn_ascendv2__Designation_Name__c'});

            PORTAL_OnlineGivingController.SERVER_searchDesignations(params);

            try {
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_searchDesignations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }


        public virtual void testGetDesignationsByParentId() {

            Map<String, Object> params = new Map<String, Object>();

            PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId(params);

            params.put(PORTAL_OnlineGivingControllerBase.PAGE_NAME, 'Online Giving');
            params.put(PORTAL_OnlineGivingControllerBase.PARENT_ID_KEY, '');

            PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId(params);

            try {
                PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getDesignationsByParentId(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }


        public virtual void testGetCustomFields() {
            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;

            ucinn_portal_Custom_Form_Field__c checkbox = new ucinn_portal_Custom_Form_Field__c();
            checkbox.Default_Value__c = 'true';
            checkbox.Editable__c = true;
            checkbox.Field_Order__c = 1;
            checkbox.Field_Label__c = 'Checkbox';
            checkbox.ucinn_portal_Content_Module__c = module.Id;
            checkbox.Field_Type__c = 'Checkbox';
            checkbox.Page_Name__c = 'Registrant';
            insert checkbox;

            ucinn_portal_Custom_Form_Field__c checkboxWithNoDefault = new ucinn_portal_Custom_Form_Field__c();
            checkboxWithNoDefault.Default_Value__c = '';
            checkboxWithNoDefault.Editable__c = true;
            checkboxWithNoDefault.Field_Order__c = 1;
            checkboxWithNoDefault.Field_Label__c = 'Checkbox';
            checkboxWithNoDefault.ucinn_portal_Content_Module__c = module.Id;
            checkboxWithNoDefault.Field_Type__c = 'Checkbox';
            checkboxWithNoDefault.Page_Name__c = 'Registrant';
            insert checkboxWithNoDefault;

            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            insert text;

            ucinn_portal_Custom_Form_Field__c picklist = new ucinn_portal_Custom_Form_Field__c();
            picklist.Default_Value__c = 'Hello';
            picklist.Editable__c = true;
            picklist.Field_Order__c = 2;
            picklist.Field_Label__c = 'Picklist';
            picklist.ucinn_portal_Content_Module__c = module.Id;
            picklist.Field_Type__c = 'Picklist';
            picklist.Available_Values__c = 'Hello;Goodbye';
            picklist.Page_Name__c = 'Registrant';
            insert picklist;

            ucinn_portal_Custom_Form_Field__c multipicklist = new ucinn_portal_Custom_Form_Field__c();
            multipicklist.Default_Value__c = 'Hello';
            multipicklist.Editable__c = true;
            multipicklist.Field_Order__c = 2;
            multipicklist.Field_Label__c = 'Multi-Picklist';
            multipicklist.ucinn_portal_Content_Module__c = module.Id;
            multipicklist.Field_Type__c = 'Multi-Picklist';
            multipicklist.Available_Values__c = 'Hello;Goodbye';
            multipicklist.Page_Name__c = 'Registrant';
            insert multipicklist;

            ucinn_portal_Custom_Form_Field__c multipicklistWithNoDefault = new ucinn_portal_Custom_Form_Field__c();
            multipicklistWithNoDefault.Default_Value__c = '';
            multipicklistWithNoDefault.Editable__c = true;
            multipicklistWithNoDefault.Field_Order__c = 2;
            multipicklistWithNoDefault.Field_Label__c = 'Multi-Picklist';
            multipicklistWithNoDefault.ucinn_portal_Content_Module__c = module.Id;
            multipicklistWithNoDefault.Field_Type__c = 'Multi-Picklist';
            multipicklistWithNoDefault.Available_Values__c = 'Hello;Goodbye';
            multipicklistWithNoDefault.Page_Name__c = 'Registrant';
            insert multipicklistWithNoDefault;

            Map<String, Object> params = new Map<String, Object>();
            params.put('contentPageName', 'Test Page');
            params.put('contentModuleName', 'Test Module');

            List<Map<String, Object>> customFormFields =  PORTAL_OnlineGivingController.SERVER_getCustomFields(params);
            System.assert(customFormFields.size() == 6);

        }


        public virtual void testGetConstituentInformation() {

            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Give_Page_Encryption__c = '123',
                                ucinn_ascendv2__Donor_ID__c = '0001');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                Map<String, Object> returnMap = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(new Map<String, Object>{'donorId' => '0001', 'passcode' => '123'});

                System.runAs(communityUser) {
                    returnMap = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(new Map<String, Object>());
                }
            }

        }


        public virtual void testOneTimeGift() {


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'gift');
                params.put('amount', '100');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyId', '34j4tjifg88');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
            }
        }


        public virtual void testPledge() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);



            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Annual');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testPledgeWithPayment() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today());
                params.put('frequency', 'Annual');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testPledgeWithNoInstallments() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Annual');
                params.put('numberOfInstallments', 0);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testRecurringGiftWithPayment() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            Account acct = new Account(name = 'ACME Co') ;
            insert acct;



            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              ucinn_portal_Is_Display_On_Portal__c = true,
                              Email = 'testCommunityUsermig123@test.com');
            insert con;

            ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
            name.ucinn_ascendv2__Type__c = 'Full Name';
            name.ucinn_ascendv2__First_Name__c = 'Test';
            name.ucinn_ascendv2__Last_Name__c = 'Test';
            name.ucinn_ascendv2__Contact__c = con.Id;
            insert name;

            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                     username = 'testCommunityUsermig123@test.com');
            insert communityUser;

            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            insert homePhone;

            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                        ucinn_ascendv2__City__c = 'Irvine',
                                                                        ucinn_ascendv2__State__c = 'CA',
                                                                        ucinn_ascendv2__Country__c = 'US',
                                                                        ucinn_ascendv2__Postal_Code__c = '92602');
            insert address;

            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                    ucinn_ascendv2__Address__c = address.Id,
                                                                                                    ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                    ucinn_ascendv2__Status__c = 'Current',
                                                                                                    ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                    ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                    RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                    ucinn_ascendv2__Type__c = 'Home',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true);
            insert relation;

            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_ascendv2__Is_Preferred__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
               insert email;



            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
            designation.Name = 'Test Designation';
            designation.ucinn_portal_Is_Display_On_Portal__c = true;
            designation.ucinn_portal_Display_Order__c = '1';
            insert designation;

            Map<Object, Object> designationMap = new Map<Object, Object>();
            designationMap.put('Id', designation.Id);
            designationMap.put('amount', 50);
            designationMap.put('Name', 'Test Designation');
            Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
            otherDesignationMap.put('Id', '');
            otherDesignationMap.put('Name', 'Other');
            otherDesignationMap.put('amount', 50);
            List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
            designations.add(designationMap);
            designations.add(otherDesignationMap);

            ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
            page.Name = 'Test Page';
            insert page;
            ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
            module.Name = 'Test Module';
            module.Content_Page__c = page.Id;
            insert module;

            ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
            text.Default_Value__c = 'Hello';
            text.Editable__c = true;
            text.Field_Order__c = 2;
            text.Field_Label__c = 'Text';
            text.ucinn_portal_Content_Module__c = module.Id;
            text.Field_Type__c = 'Text';
            text.Page_Name__c = 'Registrant';
            text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
            insert text;

            Map<String, Object> params = new Map<String, Object>();
            params.put('designations', designations);
            params.put('giftType', 'recurring');
            params.put('amount', '100');
            params.put('startDate', Date.today());
            params.put('frequency', 'Annual');
            params.put('numberOfInstallments', 0);

            Map<String, Object> stripeBillingInformation = new Map<String, Object>();
            stripeBillingInformation.put('name', 'Test Test');
            stripeBillingInformation.put('email', 'test@ucinnovation.com');
            Map<String, Object> addressMap = new Map<String, Object>();
            addressMap.put('city', 'Irvine');
            addressMap.put('state', 'CA');
            addressMap.put('country', 'US');
            addressMap.put('postal_code', '92602');
            addressMap.put('line1', '2855 Michelle Drive');
            stripeBillingInformation.put('address', addressMap);
            params.put('stripeBillingInformation', stripeBillingInformation);
            params.put('apiKeyName', 'Stripe Secret API Key');

            List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
            Map<String, Object> customField = new Map<String, Object>();
            customField.put('Id', text.Id);
            customField.put('value', 'test');
            additionalDetails.add(customField);
            params.put('additionalDetails', additionalDetails);
            params.put('paymentId', '8fgjf7fsdfj3lj34j');
            params.put('matchingCompanyName', 'UC Innovation');

            Map<String, Object> tributeInformation = new Map<String, Object>();
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
            tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
            tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
            tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
            tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
            tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
            params.put('tributeInformation', tributeInformation);
            params.put('paymentMethod', 'Stripe');
            params.put('pageSectionName', 'Online Giving');
            params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

            Test.startTest();
            System.runAs(communityUser) {
                Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                params.put('billingInformation', billingInformation);
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
            }
            Test.stopTest();
        }


        public virtual void testRecurringGiftWithoutPayment() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Stripe_Customer_ID__c = '9843534213');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'recurring');
                params.put('amount', '100');
                params.put('startDate', Date.today());
                params.put('frequency', 'Annual');
                params.put('numberOfInstallments', 0);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testGetOrigin(){
            PORTAL_OnlineGivingController.SERVER_getOrigin(new Map<String, Object>());
        }


        public virtual void testGetApiKey() {
            PORTAL_OnlineGivingController.SERVER_getAPIKey(new Map<String, Object>{'paymentMethod' => 'Stripe', 'customMetadataName' => 'Stripe Public API Key'});
        }


        public virtual void testGetApiKeyNonStripe() {
            PORTAL_OnlineGivingController.SERVER_getAPIKey(new Map<String, Object>{'paymentMethod' => 'CyberSource', 'pageSectionName' => 'Stripe Public API Key'});
        }


        public virtual void testPledgeSemiAnnual() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Semi-Annual');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testPledgeQuarterly() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Quarterly');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testPledgeMonthly() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Monthly');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testPledgeBiWeekly() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Bi-Weekly');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }


        public virtual void testPledgeWeekly() {

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_PaymentHubControllerBase.paymentInterface = new PORTAL_StripePaymentGateway();

            mockcallouts.addRequest(200,'succeeded', '{"id" : "9576304359"}', PORTAL_StripePaymentGateway.PRICE_ID_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "985734396"}', PORTAL_StripePaymentGateway.CUSTOMER_ENDPOINT);
            mockcallouts.addRequest(200, 'succeeded', '{"id":"45345346"}', PORTAL_StripePaymentGateway.SETUP_INTENT_ENDPOINT);
            mockcallouts.addRequest(200,'succeeded', '{"id" : "4983495"}', PORTAL_StripePaymentGateway.SUBSCRIPTION_ENDPOINT);
            mockCallouts.addRequest(200, 'succeeded', '{"id": "1234567"}', PORTAL_StripePaymentGateway.CHARGE_ENDPOINT);


            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;

            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Mailing', ucinn_ascendv2__Address_Relation_Type__c = 'Home',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'home',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Home',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'MailingAddress');
            ucinn_ascendv2__Address_Type_Mapping__c addressSetting2 = new ucinn_ascendv2__Address_Type_Mapping__c(name='Contact_Other', ucinn_ascendv2__Address_Relation_Type__c = 'Business',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'business',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Business',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Contact',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'OtherAddress');
            insert addressSetting;
            insert addressSetting2;

            System.runAs(thisUser) {

                Account acct = new Account(name = 'ACME Co') ;
                insert acct;



                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                insert con;

                ucinn_ascendv2__Contact_Name__c name = new ucinn_ascendv2__Contact_Name__c();
                name.ucinn_ascendv2__Type__c = 'Full Name';
                name.ucinn_ascendv2__First_Name__c = 'Test';
                name.ucinn_ascendv2__Last_Name__c = 'Test';
                name.ucinn_ascendv2__Contact__c = con.Id;
                insert name;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;

                ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
                homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
                homePhone.ucinn_ascendv2__Type__c = 'Home';
                homePhone.ucinn_ascendv2__Is_Preferred__c = true;
                homePhone.ucinn_ascendv2__Status__c = 'Current';
                homePhone.ucinn_ascendv2__Contact__c = con.Id;
                homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
                homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
                insert homePhone;

                ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                            ucinn_ascendv2__City__c = 'Irvine',
                                                                            ucinn_ascendv2__State__c = 'CA',
                                                                            ucinn_ascendv2__Country__c = 'US',
                                                                            ucinn_ascendv2__Postal_Code__c = '92602');
                insert address;

                ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Address__c = address.Id,
                                                                                                        ucinn_ascendv2__Is_Preferred__c = true,
                                                                                                        ucinn_ascendv2__Status__c = 'Current',
                                                                                                        ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                        ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                        RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                        ucinn_ascendv2__Type__c = 'Home',
                                                                                                        ucinn_portal_Is_Display_On_Portal__c = true);
                insert relation;

                ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                            ucinn_ascendv2__Contact__c = con.Id,
                                                                            ucinn_ascendv2__Status__c = 'Current',
                                                                            ucinn_ascendv2__Type__c = 'Business',
                                                                            ucinn_ascendv2__Is_Preferred__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);
                insert email;



                ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c();
                designation.Name = 'Test Designation';
                designation.ucinn_portal_Is_Display_On_Portal__c = true;
                designation.ucinn_portal_Display_Order__c = '1';
                insert designation;

                Map<Object, Object> designationMap = new Map<Object, Object>();
                designationMap.put('Id', designation.Id);
                designationMap.put('amount', 50);
                designationMap.put('Name', 'Test Designation');
                Map<Object, Object> otherDesignationMap = new Map<Object, Object>();
                otherDesignationMap.put('Id', '');
                otherDesignationMap.put('Name', 'Other');
                otherDesignationMap.put('amount', 50);
                List<Map<Object, Object>> designations = new List<Map<Object, Object>>();
                designations.add(designationMap);
                designations.add(otherDesignationMap);

                ucinn_portal_Content_Page__c page = new ucinn_portal_Content_Page__c();
                page.Name = 'Test Page';
                insert page;
                ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
                module.Name = 'Test Module';
                module.Content_Page__c = page.Id;
                insert module;

                ucinn_portal_Custom_Form_Field__c text = new ucinn_portal_Custom_Form_Field__c();
                text.Default_Value__c = 'Hello';
                text.Editable__c = true;
                text.Field_Order__c = 2;
                text.Field_Label__c = 'Text';
                text.ucinn_portal_Content_Module__c = module.Id;
                text.Field_Type__c = 'Text';
                text.Page_Name__c = 'Registrant';
                text.Field_API_Name__c = 'ucinn_ascendv2__Comments_v1__c';
                insert text;

                Map<String, Object> params = new Map<String, Object>();
                params.put('designations', designations);
                params.put('giftType', 'pledge');
                params.put('amount', '100');
                params.put('startDate', Date.today().addMonths(1));
                params.put('frequency', 'Weekly');
                params.put('numberOfInstallments', 10);

                Map<String, Object> stripeBillingInformation = new Map<String, Object>();
                stripeBillingInformation.put('name', 'Test Test');
                stripeBillingInformation.put('email', 'test@ucinnovation.com');
                Map<String, Object> addressMap = new Map<String, Object>();
                addressMap.put('city', 'Irvine');
                addressMap.put('state', 'CA');
                addressMap.put('country', 'US');
                addressMap.put('postal_code', '92602');
                addressMap.put('line1', '2855 Michelle Drive');
                stripeBillingInformation.put('address', addressMap);
                params.put('stripeBillingInformation', stripeBillingInformation);
                params.put('apiKeyName', 'Stripe Secret API Key');

                List<Map<String, Object>> additionalDetails = new List<Map<String, Object>>();
                Map<String, Object> customField = new Map<String, Object>();
                customField.put('Id', text.Id);
                customField.put('value', 'test');
                additionalDetails.add(customField);
                params.put('additionalDetails', additionalDetails);
                params.put('paymentId', '8fgjf7fsdfj3lj34j');
                params.put('matchingCompanyName', 'UC Innovation');

                Map<String, Object> tributeInformation = new Map<String, Object>();
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_First_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Last_Name_1__c', 'Test');
                tributeInformation.put('ucinn_ascendv2__Notify_Address_Line_1_1__c', '2855 Michelle Drive');
                tributeInformation.put('ucinn_ascendv2__Notify_City_1__c', 'Irvine');
                tributeInformation.put('ucinn_ascendv2__Notify_State_1__c', 'CA');
                tributeInformation.put('ucinn_ascendv2__Notify_Postal_Code_1__c', '92602');
                tributeInformation.put('ucinn_ascendv2__Tribute_Type_1__c', 'In Honor Of');
                params.put('tributeInformation', tributeInformation);
                params.put('paymentMethod', 'Stripe');
                params.put('pageSectionName', 'Online Giving');
                params.put('emailTemplateName', 'Online_Giving_Gift_Receipt');

                Test.startTest();
                System.runAs(communityUser) {
                    Map<String, Object> billingInformation = PORTAL_OnlineGivingController.SERVER_getConstituentInformation(params);
                    params.put('billingInformation', billingInformation);
                    PORTAL_OnlineGivingController.SERVER_createReviewTransaction(params);
                }
                Test.stopTest();
            }
        }

        public virtual void testGetPicklistsInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getPicklists(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getPicklists(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetFeaturedDesignationsInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getFeaturedDesignations(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getFeaturedDesignations(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetAllDesignationsInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getAllDesignations(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getAllDesignations(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetDesignationsByCategoryInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getDesignationsByCategory(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getDesignationsByCategory(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetCustomFieldsInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getCustomFields(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getCustomFields(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetConstituentInformationInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getConstituentInformation(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getConstituentInformation(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testCreateReviewTransactionInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_createReviewTransaction(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetOriginInvalidInput() {
            Test.startTest();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getOrigin(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getOrigin(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetAPIKeyInvalidInput() {
            Test.startTest();
            
            try {
                PORTAL_OnlineGivingController.SERVER_getAPIKey(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getAPIKey(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetPledgeDataInvalidInput() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
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
                    PORTAL_OnlineGivingController.SERVER_getPledgeData(null);
                }
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getPledgeData(null);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetOnlineGivingBaseURL() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
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
            Test.startTest();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getOnlineGivingBaseURL(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_getOnlineGivingBaseURL(null);
            } catch (Exception e) {
                System.debug(e);
            }
            
            try {
                System.runAs(portalAccountOwner) {
                    PORTAL_CommunityUtils.testExceptionType = '';
                    PORTAL_OnlineGivingController.SERVER_getOnlineGivingBaseURL(null);
                }
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGenerateOnlineGivingLink() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
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
            Test.startTest();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_generateOnlineGivingLink(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_generateOnlineGivingLink(null);
            } catch (Exception e) {
                System.debug(e);
            }

            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermigrrtTTT123@test.com',
                                ucinn_ascendv2__Donor_ID__c = '0001');
                insert con;

                try {
                    PORTAL_CommunityUtils.testExceptionType = '';
                    PORTAL_OnlineGivingController.SERVER_generateOnlineGivingLink(null);
                } catch (Exception e) {
                    System.assert(String.isNotBlank(e.getMessage()));
                }

                try {
                    PORTAL_OnlineGivingController.SERVER_generateOnlineGivingLink(new Map<String, Object>{'contactId' => new List<Object>{con.Id}});
                } catch (Exception e) {
                    System.assert(String.isNotBlank(e.getMessage()));
                }
                
                try {
                    PORTAL_OnlineGivingController.SERVER_generateOnlineGivingLink(new Map<String, Object>{'contactId' => new List<Object>{con.Id}, 'givingUrl' => 'test.comm/s/give?test=test'});
                } catch (Exception e) {
                    System.assert(String.isNotBlank(e.getMessage()));
                }
            }

            Test.stopTest();
        }

        public virtual void testCreateDTDDonationAndInterim() {
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', '{"matched-company":{"company_name":"Very Good Building Company","ratio":"1:1","id":42},"donation_identifier":"foo"}', PORTAL_DoubleTheDonationController.BASE_URL + PORTAL_DoubleTheDonationController.REGISTER_DONATION_ENDPOINT);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            Test.startTest();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_createDTDDonationAndInterim(null);
                System.assert(false);
            } catch (AuraHandledException ahe) { }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_OnlineGivingController.SERVER_createDTDDonationAndInterim(null);
                System.assert(false);
            } catch (Exception e) { }

            PORTAL_CommunityUtils.testExceptionType = '';
            String result = PORTAL_OnlineGivingController.SERVER_createDTDDonationAndInterim(null);
            System.assertEquals('', result);

            Map<String, Object> params = new Map<String, Object>{
                PORTAL_CONST_OnlineGiving.EXTERNAL_DONATION_IDENTIFIER => 'foo',
                PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_INTEGRATION => PORTAL_PaymentHubControllerBase.DOUBLE_THE_DONATION,
                PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID => '42',
                PORTAL_CONST_OnlineGiving.AMOUNT_KEY => '12.34',
                PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION => new Map<String, Object>{
                    PORTAL_DoubleTheDonationController.FIRST_NAME => 'Test',
                    PORTAL_DoubleTheDonationController.LAST_NAME => 'Test',
                    PORTAL_DoubleTheDonationController.EMAIL_ADDRESS => 'test@test.com'
                },
                PORTAL_CONST_OnlineGiving.PAGE_SECTION_NAME => 'fake page name',
                PORTAL_CONST_OnlineGiving.APPEAL_CODE => 'FOO!!!'
            };

            result = PORTAL_OnlineGivingController.SERVER_createDTDDonationAndInterim(params);
            List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id FROM ucinn_ascendv2__Interim__c];
            System.assertEquals('foo', result);
            System.assertEquals(1, interimList.size());

            (new PORTAL_OnlineGivingControllerBase()).getDefaultAppeal('adsfafdadsf');
            (new PORTAL_OnlineGivingControllerBase()).getDefaultAppeal(PORTAL_OnlineGivingControllerBase.DEFAULT_GIVING_PAGE_SECTION_NAME);

            Test.stopTest();
        }

        public virtual void testGetContextualGivingFormData() {    
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            Id profileId = [SELECT Id FROM Profile WHERE Name=: 'ascend Customer Community User'].Id;
            User communityUser = new User(alias = 'comUser',
                                email = 'testCommunityUsermig123@test.com',
                                emailencodingkey='UTF-8',
                                lastname = 'Batman',
                                languagelocalekey='en_US',
                                localesidkey='en_US',
                                profileid = profileId,
                                contactId = con.Id,
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

            ucinn_portal_Giving_Form__c testGivingForm = new ucinn_portal_Giving_Form__c(Name = 'Test Giving Form',
                                                                                        Page_URL__c = 'test',
                                                                                        Gift_Types__c = 'outright;',
                                                                                        Email_Type_Picklist_Values__c = 'Personal;Business;Other',
                                                                                        Phone_Type_Picklist_Values__c = 'Mobile;Home;Business;Other',
                                                                                        Address_Type_Picklist_Values__c = 'Home;Business;Other',
                                                                                        Gift_Details_Label__c = 'Gift Details',
                                                                                        Billing_Details_Label__c = 'Billing Details',
                                                                                        Confirmation_Label__c = 'Thank You',
                                                                                        Default_Amount__c = 50,
                                                                                        Confirmation_Text__c = 'Thanks man');
            testGivingForm = (ucinn_portal_Giving_Form__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testGivingForm});

            insert testGivingForm;

            
            ucinn_ascendv2__Designation__c designation1 = new ucinn_ascendv2__Designation__c(
                Name = 'Athletics',
                ucinn_ascendv2__Designation_Name__c  = 'Athletics',
                ucinn_portal_Is_Display_On_Portal__c = true
            );
            designation1 = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation1});
            insert designation1;

            Map<String, Object> testParams = new Map<String, Object>{'givingFormName' => 'Test Giving Form', 'pageUrl' => 'test'};
            Test.startTest();
            System.runAs(communityUser) {
                PORTAL_OnlineGivingController.SERVER_getContextualGivingFormData(testParams);
            }
            Test.stopTest();
        }
    }
    @isTest
    public static void testGetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetPicklists();
    }

    @isTest
    public static void testGetPicklistsFailure() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetPicklistsFailure();
    }

    @isTest
    public static void testGetFeaturedDesignations() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetFeaturedDesignations();
    }

    @isTest
    public static void testGetPledgeData() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetPledgeData();
    }

    @isTest
    public static void testGetAllDesignations() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetAllDesignations();
    }

    @isTest
    public static void testGetCategoryDesignations() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetCategoryDesignations();
    }

    @isTest
    public static void testSearchDesignations() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testSearchDesignations();
    }

    @isTest
    public static void testSearchDesignationsWithNoSearchFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testSearchDesignationsWithNoSearchFields();
    }

    @isTest
    public static void testSearchDesignationsWithAllEmptyFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testSearchDesignationsWithAllEmptyFields();
    }

    @isTest
    public static void testSearchDesignationsWithSomeEmptyFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testSearchDesignationsWithSomeEmptyFields();
    }

    @isTest
    public static void testGetDesignationsByParentId() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetDesignationsByParentId();
    }

    @isTest
    public static void testGetCustomFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetCustomFields();

    }

    @isTest
    public static void testGetConstituentInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetConstituentInformation();
    }

    @isTest
    public static void testOneTimeGift() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetConstituentInformation();
    }

    @isTest
    public static void testPledge() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledge();
    }

    @isTest
    public static void testPledgeWithPayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeWithPayment();
    }

    @isTest
    public static void testPledgeWithNoInstallments() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeWithNoInstallments();
    }

    @isTest
    public static void testRecurringGiftWithPayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testRecurringGiftWithPayment();
    }

    @isTest
    public static void testRecurringGiftWithoutPayment() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testRecurringGiftWithoutPayment();
    }

    @isTest
    public static void testGetOrigin(){
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetOrigin();
    }

    @isTest
    public static void testGetApiKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetApiKey();
    }

    @isTest
    public static void testGetApiKeyNonStripe() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetApiKeyNonStripe();
    }

    @isTest
    public static void testPledgeSemiAnnual() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeSemiAnnual();
    }

    @isTest
    public static void testPledgeQuarterly() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeQuarterly();
    }

    @isTest
    public static void testPledgeMonthly() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeMonthly();
    }

    @isTest
    public static void testPledgeBiWeekly() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeBiWeekly();
    }

    @isTest
    public static void testPledgeWeekly() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testPledgeWeekly();
    }

    @isTest
    public static void testGetPicklistsInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetPicklistsInvalidInput();
    }
    
    @isTest
    public static void testGetFeaturedDesignationsInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetFeaturedDesignationsInvalidInput();
    }

    @isTest
    public static void testGetAllDesignationsInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetAllDesignationsInvalidInput();
    }
    
    @isTest
    public static void testGetDesignationsByCategoryInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetDesignationsByCategoryInvalidInput();
    }
    
    @isTest
    public static void testGetCustomFieldsInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetCustomFieldsInvalidInput();
    }

    @isTest
    public static void testGetConstituentInformationInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetConstituentInformationInvalidInput();
    }
    
    @isTest
    public static void testCreateReviewTransactionInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testCreateReviewTransactionInvalidInput();
    }
    
    @isTest
    public static void testGetOriginInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetOriginInvalidInput();
    }

    @isTest
    public static void testGetAPIKeyInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetAPIKeyInvalidInput();
    }

    @isTest
    public static void testGetPledgeDataInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetPledgeDataInvalidInput();
    }

    @isTest
    public static void testGetOnlineGivingBaseURL() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetOnlineGivingBaseURL();
    }

    @isTest
    public static void testGenerateOnlineGivingLink() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGenerateOnlineGivingLink();
    }

    @isTest
    public static void testCreateDTDDonationAndInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testCreateDTDDonationAndInterim();
    }

    @isTest
    public static void testGetContextualGivingFormData() {
        PORTAL_TestClassFactory.getTestClassFactory().getOnlineGivingControllerTestClass().testGetContextualGivingFormData();
    }
}