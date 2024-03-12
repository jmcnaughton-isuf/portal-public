@isTest
public with sharing class PORTAL_ProcessInterimEmploymentTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();


        public virtual void testNewInterimEmploymentBatch() {

            ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
            interim.ucinn_ascendv2__Status__c = 'Completed';
            interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
            insert interim;

            ucinn_portal_Interim_Employment__c employment = new ucinn_portal_Interim_Employment__c();
            employment.Status__c = 'New';
            employment.Is_Possible_Duplicate_Checked__c = true;
            employment.Interim__c = interim.Id;
            employment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => employment});
            insert employment;

            ucinn_ascendv2__Interim__c failedInterim = new ucinn_ascendv2__Interim__c();
            failedInterim.ucinn_ascendv2__Status__c = 'Completed';
            failedInterim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => failedInterim});
            insert failedInterim;

            ucinn_portal_Interim_Employment__c failedEmployment = new ucinn_portal_Interim_Employment__c();
            failedEmployment.Status__c = 'New';
            failedEmployment.Is_Possible_Duplicate_Checked__c = true;
            failedEmployment.Interim__c = failedInterim.Id;
            failedEmployment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => failedEmployment});
            insert failedEmployment;

            ucinn_ascendv2__Dedupe_Possible_Duplicate__c dup = new ucinn_ascendv2__Dedupe_Possible_Duplicate__c();
            dup.ucinn_ascendv2__Source_Object_Name__c = 'ucinn_portal_Interim_Employment__c';
            dup.ucinn_ascendv2__External_System_ID__c = 'dup test';
            dup.Name = failedEmployment.Id;
            dup = (ucinn_ascendv2__Dedupe_Possible_Duplicate__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dup});
            insert dup;

            ucinn_ascendv2__Dedupe_Possible_Duplicate_Found__c dupFound = new ucinn_ascendv2__Dedupe_Possible_Duplicate_Found__c();
            dupFound.Name = failedEmployment.Id;
            dupFound.ucinn_ascendv2__Dedupe_Possible_Duplicate__c = dup.Id;
            dupFound.ucinn_ascendv2__Matching_Score__c = 70.00;
            dupFound.ucinn_ascendv2__Target_Object_Name__c = 'Account';
            dupFound = (ucinn_ascendv2__Dedupe_Possible_Duplicate_Found__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dupFound});
            insert dupFound;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_ProcessNewInterimEmployment());
            Test.stopTest();

            List<ucinn_portal_Interim_Employment__c> employmentList = [SELECT Id FROM ucinn_portal_Interim_Employment__c WHERE Status__c = 'Pending'];
            System.assert(employmentList.size() == 1);

            List<ucinn_portal_Interim_Employment__c> failedEmploymentList = [SELECT Id FROM ucinn_portal_Interim_Employment__c WHERE Status__c = 'Manual Review'];
            System.assert(failedEmploymentList.size() == 1);
        }


        public virtual void testPendingBatch() {
            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Account_Billing', ucinn_ascendv2__Address_Relation_Type__c = 'Billing',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'billing',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Billing',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Account',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'BillingAddress');
            addressSetting = (ucinn_ascendv2__Address_Type_Mapping__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => addressSetting});
            insert addressSetting;

            ucinn_ascendv2__Interim__C interim = new ucinn_ascendv2__Interim__C();
            interim.put('ucinn_ascendv2__First_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Last_Name__c', 'Test');
            interim.put('ucinn_ascendv2__Email_1__c', 'demo@ucinnovation.com');
            interim.put('ucinn_ascendv2__Email_1_Type__c', 'Personal');
            interim.put('ucinn_ascendv2__Phone_1_Type__c', 'Business');
            interim.put('ucinn_ascendv2__Phone_1__c', '9876543210');
            interim.put('ucinn_ascendv2__Status__c', 'Completed');
            interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
            insert interim;

            ucinn_portal_Interim_Employment__c interimEmployment = new ucinn_portal_Interim_Employment__c();
            interimEmployment.Name =  'UC Innovation';
            interimEmployment.Job_Title__c =  'Hiring Manager';
            interimEmployment.Email__c = 'demo@ucinnovation.com';
            interimEmployment.Phone__c =  '9876543210';
            interimEmployment.Address_Line_1__c = '2855 Michelle Drive';
            interimEmployment.Address_Line_2__c =  '';
            interimEmployment.City__c = 'Irvine';
            interimEmployment.State__c = 'CA';
            interimEmployment.Postal_Code__c = '92607';
            interimEmployment.Country__c = 'United States';
            interimEmployment.Website__c = 'ucinnovation.com';
            interimEmployment.LinkedIn_URL__c = 'linkedin.com';
            interimEmployment.Industry__c = 'Consulting';
            interimEmployment.Description__c = 'We are a CRM company';
            interimEmployment.Interim__c =  interim.Id;
            interimEmployment.Status__c = 'Pending';
            interimEmployment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimEmployment});
            insert interimEmployment;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_ProcessPendingEmployment());
            Test.stopTest();

            List<Account> accountList = [SELECT Name, Website, Industry FROM Account];
            System.assert(accountList.size() == 1);
            Account acct = accountList.get(0);
            System.assert(acct.Name == 'UC Innovation');
            System.assert(acct.Website == 'ucinnovation.com');
            System.assert(acct.Industry == 'Consulting');

            List<ucinn_ascendv2__Address_Relation__c> addressRelationList = [SELECT ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c,
                                                                                ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_2__c, ucinn_ascendv2__Address__r.ucinn_ascendv2__City__c,
                                                                                ucinn_ascendv2__Address__r.ucinn_ascendv2__Country__c, ucinn_ascendv2__Address__r.ucinn_ascendv2__Postal_Code__c,
                                                                                ucinn_ascendv2__Address__r.ucinn_ascendv2__State__c
                                                                                FROM ucinn_ascendv2__Address_Relation__c WHERE ucinn_ascendv2__Account__c = :acct.Id];
            System.assert(addressRelationList.size() == 1);
            ucinn_ascendv2__Address_Relation__c addressRelation = addressRelationList.get(0);
            System.assert(addressRelation.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c == '2855 Michelle Drive');
            System.assert(String.isBlank(addressRelation.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_2__c));
            System.assert(addressRelation.ucinn_ascendv2__Address__r.ucinn_ascendv2__City__c == 'Irvine');
            System.assert(addressRelation.ucinn_ascendv2__Address__r.ucinn_ascendv2__State__c == 'CA');
            System.assert(addressRelation.ucinn_ascendv2__Address__r.ucinn_ascendv2__Postal_Code__c == '92607');
            System.assert(addressRelation.ucinn_ascendv2__Address__r.ucinn_ascendv2__Country__c == 'United States');

            List<ucinn_ascendv2__Phone__c> phoneList = [SELECT ucinn_ascendv2__Phone_Number__c FROM ucinn_ascendv2__Phone__c WHERE ucinn_ascendv2__Account__c = :acct.Id];
            System.assert(phoneList.size() == 1);
            System.assert(phoneList.get(0).ucinn_ascendv2__Phone_Number__c == '9876543210');

            List<ucinn_ascendv2__Email__c> emailList = [SELECT ucinn_ascendv2__Email_Address__c FROM ucinn_ascendv2__Email__c WHERE ucinn_ascendv2__Account__c = :acct.Id];
            System.assert(emailList.size() == 1);
            System.assert(emailList.get(0).ucinn_ascendv2__Email_Address__c == 'demo@ucinnovation.com');
        }


        public virtual void testInProgressBatch() {
            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
            insert orgSettings;

            ucinn_ascendv2__Address_Type_Mapping__c addressSetting = new ucinn_ascendv2__Address_Type_Mapping__c(name='Account_Billing', ucinn_ascendv2__Address_Relation_Type__c = 'Billing',
                                                                                                                    ucinn_ascendv2__Address_Type_Label_Backend_Message__c = 'billing',
                                                                                                                    ucinn_ascendv2__Backend_Address_Type_API_Name__c = 'Billing',
                                                                                                                    ucinn_ascendv2__Object_API_Name__c = 'Account',
                                                                                                                    ucinn_ascendv2__Object_Address_Field_Name__c = 'BillingAddress');
            addressSetting = (ucinn_ascendv2__Address_Type_Mapping__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => addressSetting});
            insert addressSetting;

            ucinn_ascendv2__Reciprocal_Affiliations__c affiliationSetting = new ucinn_ascendv2__Reciprocal_Affiliations__c();
            affiliationSetting.Name = 'Employee';
            affiliationSetting.ucinn_ascendv2__Reciprocal__c = 'Employer';
            affiliationSetting = (ucinn_ascendv2__Reciprocal_Affiliations__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => affiliationSetting});
            insert affiliationSetting;

            ucinn_ascendv2__Reciprocal_Affiliations__c affiliationSetting2 = new ucinn_ascendv2__Reciprocal_Affiliations__c();
            affiliationSetting2.Name = 'Employer';
            affiliationSetting2.ucinn_ascendv2__Reciprocal__c = 'Employee';
            affiliationSetting2 = (ucinn_ascendv2__Reciprocal_Affiliations__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => affiliationSetting2});
            insert affiliationSetting2;

            Contact cont = new Contact();
            cont.FirstName = 'Test';
            cont.LastName = 'Test';
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            ucinn_ascendv2__Interim__C interim = new ucinn_ascendv2__Interim__C();
            interim.ucinn_ascendv2__First_Name__c = 'Test';
            interim.ucinn_ascendv2__Last_Name__c =  'Test';
            interim.ucinn_ascendv2__Email_1__c = 'demo@ucinnovation.com';
            interim.ucinn_ascendv2__Email_1_Type__c = 'Personal';
            interim.ucinn_ascendv2__Phone_1_Type__c = 'Business';
            interim.ucinn_ascendv2__Phone_1__c = '9876543210';
            interim.ucinn_ascendv2__Contact__c = cont.Id;
            interim.ucinn_ascendv2__Status__c = 'Completed';
            interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
            insert interim;

            Account acct = new Account();
            acct.Name = 'UC Innovation';
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            ucinn_portal_Interim_Employment__c interimEmployment = new ucinn_portal_Interim_Employment__c();
            interimEmployment.Name =  'UC Innovation';
            interimEmployment.Account__c = acct.Id;
            interimEmployment.Job_Title__c =  'Hiring Manager';
            interimEmployment.Email__c = 'demo@ucinnovation.com';
            interimEmployment.Phone__c =  '9876543210';
            interimEmployment.Address_Line_1__c = '2855 Michelle Drive';
            interimEmployment.Address_Line_2__c =  '';
            interimEmployment.City__c = 'Irvine';
            interimEmployment.State__c = 'CA';
            interimEmployment.Postal_Code__c = '92607';
            interimEmployment.Country__c = 'United States';
            interimEmployment.Website__c = 'ucinnovation.com';
            interimEmployment.LinkedIn_URL__c = 'linkedin.com';
            interimEmployment.Industry__c = 'Consulting';
            interimEmployment.Description__c = 'We are a CRM company';
            interimEmployment.Interim__c =  interim.Id;
            interimEmployment.Status__c = 'In Progress';
            interimEmployment = (ucinn_portal_Interim_Employment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimEmployment});
            insert interimEmployment;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_ProcessInProgressEmployment());
            Test.stopTest();


            List<ucinn_ascendv2__Affiliation__c> employment = [SELECT Id, ucinn_ascendv2__Job_Title__c FROM ucinn_ascendv2__Affiliation__c WHERE ucinn_ascendv2__Account__c = :acct.Id];
            System.assert(employment.size() == 1);
            System.assert(employment.get(0).ucinn_ascendv2__Job_Title__c == 'Hiring Manager');
        }

    }

    @isTest
    public static void testNewInterimEmploymentBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getProcessInterimEmploymentTestClass().testNewInterimEmploymentBatch();
    }

    @isTest
    public static void testPendingBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getProcessInterimEmploymentTestClass().testPendingBatch();
    }

    @isTest
    public static void testInProgressBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getProcessInterimEmploymentTestClass().testInProgressBatch();
    }
}