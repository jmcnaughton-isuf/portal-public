@isTest
public with sharing class PORTAL_BATCH_AddZoneMembershipsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testBatch() {

            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
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
            addressSetting = (ucinn_ascendv2__Address_Type_Mapping__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => addressSetting});
            addressSetting2 = (ucinn_ascendv2__Address_Type_Mapping__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => addressSetting2});
            insert addressSetting;
            insert addressSetting2;

            ucinn_ascendv2__Reciprocal_Relationships__c relationshipSetting = new ucinn_ascendv2__Reciprocal_Relationships__c(Name = 'Spouse', ucinn_ascendv2__Reciprocal__c = 'Spouse');
            relationshipSetting = (ucinn_ascendv2__Reciprocal_Relationships__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => relationshipSetting});
            insert relationshipSetting;


            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Geolocation__longitude__s = 50;
            zone.Geolocation__latitude__s = 50;
            zone.Is_Display_On_Portal__c = true;
            zone.Search_Radius__c = 200;
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;

            ucinn_portal_Zone__c secondZone = new ucinn_portal_Zone__c();
            secondZone.Geolocation__longitude__s = 80;
            secondZone.Geolocation__latitude__s = 80;
            secondZone.Is_Display_On_Portal__c = true;
            secondZone.Search_Radius__c = 200;
            secondZone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();
            secondZone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => secondZone});
            insert secondZone;

            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.ucinn_ascendv2__Contact_Type__c = 'Alumni';
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c();
            address.ucinn_ascendv2__Address_Line_1__c = '2855 Michelle Drive';
            address.ucinn_ascendv2__City__c = 'Irvine';
            address.ucinn_ascendv2__State__c = 'CA';
            address.ucinn_ascendv2__Country__c = 'United States';
            address.ucinn_ascendv2__Postal_Code__c = '92606';
            address.ucinn_ascendv2__Location__longitude__s = 50;
            address.ucinn_ascendv2__Location__latitude__s = 50;
            address = (ucinn_ascendv2__Address__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => address});
            insert address;

            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c();
            relation.ucinn_ascendv2__Status__c = 'Current';
            relation.ucinn_ascendv2__Address__c =  address.Id;
            relation.ucinn_ascendv2__Contact__c = cont.Id;
            relation = (ucinn_ascendv2__Address_Relation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => relation});
            insert relation;

            ucinn_ascendv2__Service_Indicator_Value__c indicatorValue = new ucinn_ascendv2__Service_Indicator_Value__c();
            indicatorValue.ucinn_ascendv2__Code__c = 'DNC';
            indicatorValue = (ucinn_ascendv2__Service_Indicator_Value__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => indicatorValue});
            insert indicatorValue;

            ucinn_ascendv2__Service_Indicator__c indicator = new ucinn_ascendv2__Service_Indicator__c();
            indicator.ucinn_ascendv2__Contact__c = cont.Id;
            indicator.ucinn_ascendv2__Is_Active__c = true;
            indicator.ucinn_ascendv2__Service_Indicator_Value__c = indicatorValue.Id;
            indicator = (ucinn_ascendv2__Service_Indicator__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => indicator});
            insert indicator;

            ucinn_ascendv2__Service_Indicator_Value__c indicatorValue2 = new ucinn_ascendv2__Service_Indicator_Value__c();
            indicatorValue2.ucinn_ascendv2__Code__c = 'LTC';
            indicatorValue2 = (ucinn_ascendv2__Service_Indicator_Value__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => indicatorValue2});
            insert indicatorValue2;

            ucinn_ascendv2__Service_Indicator__c indicator2 = new ucinn_ascendv2__Service_Indicator__c();
            indicator2.ucinn_ascendv2__Contact__c = cont.Id;
            indicator2.ucinn_ascendv2__Is_Active__c = true;
            indicator2.ucinn_ascendv2__Service_Indicator_Value__c = indicatorValue2.Id;
            indicator2 = (ucinn_ascendv2__Service_Indicator__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => indicator2});
            insert indicator2;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_AddZoneMemberships());
            Test.stopTest();

        }
    }

    @isTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getAddZoneMembershipTestClass().testBatch();
    }
}