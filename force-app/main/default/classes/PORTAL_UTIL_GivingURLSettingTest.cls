@isTest
global without sharing class PORTAL_UTIL_GivingURLSettingTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Portal_Giving_URL_Setting__mdt givingURLSetting;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setup() {

            List<Portal_Giving_URL_Setting_Field__mdt> givingURLSettingFields = new List<Portal_Giving_URL_Setting_Field__mdt>();

            givingURLSetting = new Portal_Giving_URL_Setting__mdt(
                Base_URL__c = 'www.ucinnovation.com'
            );

            Portal_Giving_URL_Setting_Field__mdt field1 = new Portal_Giving_URL_Setting_Field__mdt(
                SObject_API_Name__c = 'test'
            );

            Portal_Giving_URL_Setting_Field__mdt field2 = new Portal_Giving_URL_Setting_Field__mdt(
                SObject_API_Name__c = 'test'
            );

            Portal_Giving_URL_Setting_Field__mdt field3 = new Portal_Giving_URL_Setting_Field__mdt(
                SObject_API_Name__c = ''
            );

            Portal_Giving_URL_Setting_Field__mdt field4 = new Portal_Giving_URL_Setting_Field__mdt(
                SObject_API_Name__c = 'test2'
            );


            Map<String, Object> givingURLSettingAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(givingURLSetting));
            givingURLSettingAsMap.put('Portal_Giving_URL_Setting_Fields__r', new Map<String, Object>{'records' => new List<Portal_Giving_URL_Setting_Field__mdt>{field1, field2, field3, field4}});
            givingURLSetting = (Portal_Giving_URL_Setting__mdt) System.JSON.deserialize(System.JSON.serialize(givingURLSettingAsMap), Portal_Giving_URL_Setting__mdt.class);
            System.debug(System.JSON.serialize(givingURLSettingAsMap));
        }


        public virtual void getGivingURLSettingsTest() {

            try {
                PORTAL_UTIL_GivingURLSetting.getGivingURLSettings(null, null);
            }
            catch (PORTAL_UTIL_GivingURLSetting.GivingURLSettingsException e) {

            }

            PORTAL_UTIL_GivingURLSetting.getGivingURLSettings('asdzxcvzxcv', 'asdasd');

            List<Portal_Giving_URL_Setting__mdt> givingURLSettings = [SELECT MasterLabel FROM Portal_Giving_URL_Setting__mdt WHERE MasterLabel != null];

            if (!givingURLSettings.isEmpty()) {
                PORTAL_UTIL_GivingURLSetting.getGivingURLSettings(givingURLSettings[0].MasterLabel, '');
            }
        }


        public virtual void generateGivingURLSettingsMapTest() {
            setup();
            PORTAL_UTIL_GivingURLSetting.generateGivingURLSettingsMap(null);

            PORTAL_UTIL_GivingURLSetting.generateGivingURLSettingsMap(givingURLSetting);
        }


        public virtual void getGivingURLSettingsMapTest() {
            PORTAL_UTIL_GivingURLSetting.getGivingURLSettingsMap('Internal giving page', '');
        }


        public virtual void generateSObjectMapTest() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');

                PORTAL_UTIL_GivingURLSetting.generateSObjectMap(con);
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                PORTAL_UTIL_GivingURLSetting.generateSObjectMap(con);
            }
        }


        public virtual void createGivingURLTest() {
            Map<String, Object> givingURLSettingsMetadata;
            Map<String, Map<String, Object>> sObjectNameToFields;

            PORTAL_UTIL_GivingURLSetting.createGivingURL(null, null);

            givingURLSettingsMetadata = new Map<String, Object>();

            PORTAL_UTIL_GivingURLSetting.createGivingURL(givingURLSettingsMetadata, sObjectNameToFields);

            givingURLSettingsMetadata.put(PORTAL_UTIL_GivingURLSetting.CHILD_FIELD_RECORDS, new Map<String, List<Portal_Giving_URL_Setting_Field__mdt>>());
            givingURLSettingsMetadata.put(PORTAL_UTIL_GivingURLSetting.BASE_URL, 'https://www.ucinnovation.com');

            PORTAL_UTIL_GivingURLSetting.createGivingURL(givingURLSettingsMetadata, sObjectNameToFields);

            sObjectNameToFields = new Map<String, Map<String, Object>>{
                'noFields' => new Map<String, Object>(),
                'sObject1' => new Map<String, Object>{
                    'fieldApiName1' => 'value1',
                    'fieldApiName2' => '',
                    'fieldApiName3__r' => new Contact(
                        FirstName = 'test'
                    )
                }
            };

            Map<String, List<Portal_Giving_URL_Setting_Field__mdt>> sObjectNameToFieldsRecords = new Map<String, List<Portal_Giving_URL_Setting_Field__mdt>>{
                'sObject1' => new List<Portal_Giving_URL_Setting_Field__mdt>{
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = 'blankURLParamName',
                                        URL_parameter_Name__c = ''
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = '',
                                        URL_parameter_Name__c = 'URL_PARAM_NAME',
                                        Static_Field_Value__c = 'staticValue1'
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = '',
                                        URL_parameter_Name__c = 'emptyFieldApiName'
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = 'fieldApiName1',
                                        URL_parameter_Name__c = 'urlParam1'
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = 'fieldApiName1',
                                        URL_parameter_Name__c = ''
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = 'fieldApiName2',
                                        URL_parameter_Name__c = 'urlParam2'
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = 'fieldApiName3__r.FirstName',
                                        URL_parameter_Name__c = 'urlParam3'
                                    ),
                                    new Portal_Giving_URL_Setting_Field__mdt(
                                        Field_API_Name__c = 'fieldApiName3__r.LastName',
                                        URL_parameter_Name__c = 'urlParam3'
                                    )}
            };


            givingURLSettingsMetadata.put(PORTAL_UTIL_GivingURLSetting.CHILD_FIELD_RECORDS, sObjectNameToFieldsRecords);

            PORTAL_UTIL_GivingURLSetting.createGivingURL(givingURLSettingsMetadata, sObjectNameToFields);
        }
    }

    @isTest
    static void getGivingURLSettingsTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_GivingURLSettingTestClass().getGivingURLSettingsTest();
    }

    @isTest
    static void generateGivingURLSettingsMapTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_GivingURLSettingTestClass().generateGivingURLSettingsMapTest();
    }

    @isTest
    static void getGivingURLSettingsMapTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_GivingURLSettingTestClass().getGivingURLSettingsMapTest();
    }

    @isTest
    static void generateSObjectMapTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_GivingURLSettingTestClass().generateSObjectMapTest();
    }

    @isTest
    static void createGivingURLTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_GivingURLSettingTestClass().createGivingURLTest();
    }
}