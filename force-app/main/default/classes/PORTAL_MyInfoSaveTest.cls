@isTest
public with sharing class PORTAL_MyInfoSaveTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public Contact con;
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public PORTAL_MyInfoRetriever.SectionConfiguration sectionConfigurationMap;

        public virtual void setupData(){
            System.runAs(thisUser) {
                ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
                orgSettings.Name = 'Default Org Wide Config';
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
                orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
                insert orgSettings;

                Id profileId = [SELECT Id FROM Profile WHERE Name = :'ascend Customer Community User'].Id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact dummyContact = new Contact();
                dummyContact.FirstName = 'My Information Dummy Contact';
                dummyContact.LastName = 'Do Not Delete This Record';
                dummyContact.AccountId = acct.Id;
                dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
                insert dummyContact;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');

                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                communityUser = new User(alias = 'comUser',
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
            }
        }

        public virtual void setupConfigs() {
            this.sectionConfigurationMap = new PORTAL_MyInfoRetriever.SectionConfiguration();

            this.sectionConfigurationMap.sectionId = 'emails';
            this.sectionConfigurationMap.sectionName = 'Emails';
            this.sectionConfigurationMap.mainSectionName = 'Emails';
            this.sectionConfigurationMap.sObjectApiName = 'ucinn_ascendv2__Email__c';

            this.sectionConfigurationMap.isCreateStagingRecordUponCreation = true;
            this.sectionConfigurationMap.isCreateStagingRecordUponEdit = true;

            this.sectionConfigurationMap.controllingParentField = 'ucinn_ascendv2__Contact__c';
            this.sectionConfigurationMap.stagingRecordObjectName = 'ucinn_ascendv2__Email__c';
            this.sectionConfigurationMap.stagingRecordControllingParentField = 'ucinn_portal_Interim__c';
            this.sectionConfigurationMap.originalRecordName = 'ucinn_portal_Original_Record__c';

            this.sectionConfigurationMap.activeRecordFieldMapString = '{\"ucinn_ascendv2__Status__c\":\"Current\",\"ucinn_portal_Is_Display_On_Portal__c\":true,\"ucinn_ascendv2__End_Date__c\":null}';
            this.sectionConfigurationMap.inactiveRecordFieldMapString = '{\"ucinn_ascendv2__Status__c\":\"Former\",\"ucinn_portal_Is_Display_On_Portal__c\":false,\"ucinn_ascendv2__Is_Preferred__c\":false}';
            
            this.sectionConfigurationMap.fieldConfigurationMap = getFieldConfiguration();
        }

        public virtual Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> getFieldConfiguration() {
            Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigs = new Map<String, PORTAL_MyInfoRetriever.FieldConfiguration>();
            
            PORTAL_MyInfoRetriever.FieldConfiguration idConfig = new PORTAL_MyInfoRetriever.FieldConfiguration();
            idConfig.fieldId = 'Id';  // front end field id
            idConfig.fieldName = 'Id';  // field api name
            idConfig.stagingRecordFieldName = 'Id';  // staging record field api name
            idConfig.isCreateNewRecord = false;
            idConfig.isCreateStagingRecordOnFieldChange = false;
            fieldConfigs.put('Id', idConfig);

            PORTAL_MyInfoRetriever.FieldConfiguration emailAddressConfig = new PORTAL_MyInfoRetriever.FieldConfiguration();
            emailAddressConfig.fieldId = 'emailAddress';  // front end field id
            emailAddressConfig.fieldName = 'ucinn_ascendv2__Email_Address__c';  // field api name
            emailAddressConfig.stagingRecordFieldName = 'ucinn_ascendv2__Email_Address__c';  // staging record field api name
            emailAddressConfig.isCreateNewRecord = true;
            emailAddressConfig.isCreateStagingRecordOnFieldChange = false;
            fieldConfigs.put('emailAddress', emailAddressConfig);

            PORTAL_MyInfoRetriever.FieldConfiguration emailPreferredConfig = new PORTAL_MyInfoRetriever.FieldConfiguration();
            emailPreferredConfig.fieldId = 'emailIsPreferred';  // front end field id
            emailPreferredConfig.fieldName = 'ucinn_ascendv2__Is_Preferred__c';  // field api name
            emailPreferredConfig.stagingRecordFieldName = 'ucinn_ascendv2__Is_Preferred__c';  // staging record field api name
            emailPreferredConfig.isCreateNewRecord = true;
            emailPreferredConfig.isCreateStagingRecordOnFieldChange = false;
            fieldConfigs.put('emailIsPreferred', emailPreferredConfig);

            PORTAL_MyInfoRetriever.FieldConfiguration emailTypeConfig = new PORTAL_MyInfoRetriever.FieldConfiguration();
            emailTypeConfig.fieldId = 'emailType';  // front end field id
            emailTypeConfig.fieldName = 'ucinn_ascendv2__Type__c';  // field api name
            emailTypeConfig.stagingRecordFieldName = 'ucinn_ascendv2__Type__c';  // staging record field api name
            emailTypeConfig.isCreateNewRecord = true;
            emailTypeConfig.isCreateStagingRecordOnFieldChange = false;
            fieldConfigs.put('emailType', emailTypeConfig);

            return fieldConfigs;
        }


        public virtual void testCreateOrUpdateStagingRelatedRecords() {
            Test.startTest();
            setupData();
            setupConfigs();

            Map<String,Object> record = new Map<String, Object>{'emailAddress' => 'testmyinfomail@test.com', 'emailType' => 'Other', 'isDelete' => false};
            Map<String,Object> existRecord = new Map<String, Object>{'emailAddress' => 'test2@test.com', 'emailType' => 'Other', 'isDelete' => false, 'Id' => '1234'};

            PORTAL_MyInfoSave controller = new PORTAL_MyInfoSave.Builder().buildRecordDmlWrapper(new PORTAL_DMLWrapper())
                                                                        .buildConfigs(this.sectionConfigurationMap)
                                                                        .buildCurrentRecords(new Map<String, Map<String, Object>>())
                                                                        .buildCurrentStagingRecords(new Map<String, Map<String, Object>>{'1234' => existRecord})
                                                                        .buildContact(con.Id)
                                                                        .buildDummyContactId('')
                                                                        .buildInterimRecordId('')
                                                                        .build();

            System.runAs(communityUser) {
                controller.createOrUpdateStagingRelatedRecords(null);
                controller.createOrUpdateStagingRelatedRecords(record);

                record = new Map<String, Object>{'emailAddress' => 'testmail3@test.com', 'emailType' => 'Other', 'isDelete' => false, 'Id' => '1234'};

                controller.createOrUpdateStagingRelatedRecords(record);
            }

            Test.stopTest();
        }
    }
    
    @isTest
    public static void testCreateOrUpdateStagingRelatedRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInfoSaveTestClass().testCreateOrUpdateStagingRelatedRecords();
    }
}