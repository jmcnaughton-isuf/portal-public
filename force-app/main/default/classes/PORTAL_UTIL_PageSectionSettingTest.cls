/*
* Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
*                     http://www.ucinnovation.com
*
* This source code is licensed, not sold, and is subject to a written
* license agreement.  Among other things, no portion of this source
* code may be copied, transmitted, disclosed, displayed, distributed,
* translated, used as the basis for a derivative work, or used, in
* whole or in part, for any program or purpose other than its intended
* use in compliance with the license agreement as part of UC Innovation's
* software.  This source code and certain of the algorithms contained
* within it are confidential trade secrets of UC Innovation, Inc.
* and may not be used as the basis for any other
* software, hardware, product or service.
*/

@isTest
global with sharing class PORTAL_UTIL_PageSectionSettingTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Portal_Page_Section_Setting__mdt nameSetting;
        public Portal_Section_Field_Setting__mdt fullNameSetting;
        public Portal_Section_Field_Setting__mdt prefixSetting;

        public Portal_Page_Section_Setting__mdt phoneSetting;
        public Portal_Section_Field_Setting__mdt phoneNumberSetting;

        public Portal_Page_Section_Setting__mdt directorySetting;
        public Portal_Section_Field_Setting__mdt directoryOptOutSetting;

        public Portal_Page_Section_Setting__mdt directoryDegreeSetting;
        public Portal_Section_Field_Setting__mdt degreeSetting;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            fullNameSetting = new Portal_Section_Field_Setting__mdt();
            fullNameSetting.Label = 'Name - Full Name Last Name';
            fullNameSetting.Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c';
            fullNameSetting.Field_Type__c = 'text';
            fullNameSetting.Is_Display_On_Portal__c = true;
            fullNameSetting.Is_Disabled__c = false;
            fullNameSetting.Has_Toggle__c = true;
            fullNameSetting.Filter_Value__c = 'ucinn_ascendv2__Type__c';
            fullNameSetting.Filter_Field__c = 'Full Name';
            fullNameSetting.Front_End_Field_Label__c = 'Last Name';
            fullNameSetting.Field_Order_For_Duplicate_Logic__c = '1';
            fullNameSetting.Is_Create_New_Record__c = true;
            fullNameSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
            fullNameSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c';
            fullNameSetting.Static_Value_For_Staging_Field__c = '';
            fullNameSetting.Staging_Field_Population_Condition_Value__c = '';
            fullNameSetting.Front_End_Field_Id__c = 'lastName';
            fullNameSetting.Front_End_Field_Only__c = false;
            fullNameSetting.Lookup_SObject_Name__c = '';
            fullNameSetting.Lookup_Filter_Clause__c = '';
            fullNameSetting.Lookup_Field_Name__c = '';
            fullNameSetting.Has_Report_Update_Link__c = true;

            prefixSetting = new Portal_Section_Field_Setting__mdt();
            prefixSetting.Label = 'Name - Full Name Prefix';
            prefixSetting.Field_API_Name__c = 'ucinn_ascendv2__Prefix__c';
            prefixSetting.Field_Type__c = 'picklist';
            prefixSetting.Is_Display_On_Portal__c = true;
            prefixSetting.Is_Disabled__c = false;
            prefixSetting.Has_Toggle__c = true;
            prefixSetting.Filter_Value__c = 'ucinn_ascendv2__Type__c';
            prefixSetting.Filter_Field__c = 'Full Name';
            prefixSetting.Front_End_Field_Label__c = 'Prefix';
            prefixSetting.Field_Order_For_Duplicate_Logic__c = '1';
            prefixSetting.Is_Create_New_Record__c = true;
            prefixSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
            prefixSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Prefix__c';
            prefixSetting.Static_Value_For_Staging_Field__c = '';
            prefixSetting.Staging_Field_Population_Condition_Value__c = '';
            prefixSetting.Front_End_Field_Id__c = 'prefix';
            prefixSetting.Front_End_Field_Only__c = false;
            prefixSetting.Lookup_SObject_Name__c = '';
            prefixSetting.Lookup_Filter_Clause__c = '';
            prefixSetting.Lookup_Field_Name__c = '';
            prefixSetting.Has_Report_Update_Link__c = true;

            nameSetting = new Portal_Page_Section_Setting__mdt();
            nameSetting.Label = 'Personal Information - Name';
            nameSetting.SObject_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
            nameSetting.Staging_Record_Controlling_Parent_Field__c = '';
            nameSetting.Controlling_Parent_Field_API_Name__c = 'ucinn_ascendv2__Contact__c';
            nameSetting.Page_Main_Section__c = 'Personal_Information';
            nameSetting.Page_Sub_Section__c = 'Name';
            nameSetting.Is_Display_Section__c = true;
            nameSetting.Is_Disabled__c = true;
            nameSetting.Is_Display_Toggle_On_Section__c = true;
            nameSetting.Is_Display_Toggle_Per_Record__c = true;
            nameSetting.Where_Clause__c = 'WHERE ucinn_ascendv2__Type__c IN (\'Full Name\')';
            nameSetting.Order_By_Clause__c = 'ORDER BY ucinn_ascendv2__Type__c';
            nameSetting.Is_Create_Staging_Record_Upon_Edit__c = true;
            nameSetting.Is_Create_Staging_Record_Upon_Creation__c = true;
            nameSetting.Is_Create_Staging_Record_Using_Fields__c  = true;
            nameSetting.Create_Staging_Record_Condition_Field__c = '';
            nameSetting.Create_Staging_Record_Condition_Value__c = '';
            nameSetting.Create_Staging_Record_Condition_Operator__c = '';
            nameSetting.Staging_sObject_API_Name__c = 'ucinn_ascendv2__Interim__c';
            nameSetting.Has_Duplicate_Logic__c = true;
            nameSetting.Has_Report_Update_Link__c = true;
            nameSetting.Duplicate_Field_Logic__c = '1';
            nameSetting.Inactive_Record_Field_Map__c = '';
            nameSetting.Active_Record_Field_Map__c = '';
            nameSetting.Is_Hard_Delete_Records__c = true;
            nameSetting.Staging_Record_Where_Clause__c = '';
            nameSetting.Page_Name__c = 'My Information';
            nameSetting.Max_Number_of_Query_Records__c = 1;
            nameSetting.Front_End_Section_Id__c = 'name';
            nameSetting.Front_End_Section_Label__c = 'Name';
            nameSetting.Is_Child__c = false;
            nameSetting.Group_By_Clause__c = '';
            nameSetting.SObject_Relationship_API_Name__c = '';
            nameSetting.Relationship_Wrapper_Id__c = '';
            Map<String, Object> nameSettingAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(nameSetting));
            nameSettingAsMap.put('Portal_Section_Field_Settings__r', new Map<String, Object>{'records' => new List<Portal_Section_Field_Setting__mdt>{fullNameSetting, prefixSetting}});
            nameSetting = (Portal_Page_Section_Setting__mdt) System.JSON.deserialize(System.JSON.serialize(nameSettingAsMap), Portal_Page_Section_Setting__mdt.class);

            phoneNumberSetting = new Portal_Section_Field_Setting__mdt();
            phoneNumberSetting.Label = 'Phone - Phone Number';
            phoneNumberSetting.Field_API_Name__c = 'ucinn_ascendv2__Phone_Number__c';
            phoneNumberSetting.Field_Type__c = 'text';
            phoneNumberSetting.Is_Display_On_Portal__c = true;
            phoneNumberSetting.Is_Disabled__c = false;
            phoneNumberSetting.Has_Toggle__c = true;
            phoneNumberSetting.Filter_Value__c = '';
            phoneNumberSetting.Filter_Field__c = '';
            phoneNumberSetting.Front_End_Field_Label__c = '';
            phoneNumberSetting.Field_Order_For_Duplicate_Logic__c = '1';
            phoneNumberSetting.Is_Create_New_Record__c = true;
            phoneNumberSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
            phoneNumberSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Phone_1__c';
            phoneNumberSetting.Static_Value_For_Staging_Field__c = '';
            phoneNumberSetting.Staging_Field_Population_Condition_Value__c = '';
            phoneNumberSetting.Front_End_Field_Id__c = 'phoneNumber';
            phoneNumberSetting.Front_End_Field_Only__c = false;
            phoneNumberSetting.Lookup_SObject_Name__c = '';
            phoneNumberSetting.Lookup_Filter_Clause__c = '';
            phoneNumberSetting.Lookup_Field_Name__c = '';
            phoneNumberSetting.Has_Report_Update_Link__c = true;

            phoneSetting = new Portal_Page_Section_Setting__mdt();
            phoneSetting.Label = 'Phones - Phones';
            phoneSetting.SObject_API_Name__c = 'ucinn_ascendv2__Phone__c';
            phoneSetting.Staging_Record_Controlling_Parent_Field__c = '';
            phoneSetting.Controlling_Parent_Field_API_Name__c = 'ucinn_ascendv2__Contact__c';
            phoneSetting.Page_Main_Section__c = 'Phones';
            phoneSetting.Page_Sub_Section__c = '';
            phoneSetting.Is_Display_Section__c = true;
            phoneSetting.Is_Disabled__c = true;
            phoneSetting.Is_Display_Toggle_On_Section__c = true;
            phoneSetting.Is_Display_Toggle_Per_Record__c = true;
            phoneSetting.Where_Clause__c = 'WHERE ucinn_ascendv2__Type__c IN (\'Home - Cell\')';
            phoneSetting.Order_By_Clause__c = 'ORDER BY ucinn_ascendv2__Type__c';
            phoneSetting.Is_Create_Staging_Record_Upon_Edit__c = true;
            phoneSetting.Is_Create_Staging_Record_Upon_Creation__c = true;
            phoneSetting.Is_Create_Staging_Record_Using_Fields__c  = true;
            phoneSetting.Create_Staging_Record_Condition_Field__c = '';
            phoneSetting.Create_Staging_Record_Condition_Value__c = '';
            phoneSetting.Create_Staging_Record_Condition_Operator__c = '';
            phoneSetting.Staging_sObject_API_Name__c = 'ucinn_ascendv2__Interim__c';
            phoneSetting.Has_Duplicate_Logic__c = true;
            phoneSetting.Has_Report_Update_Link__c = true;
            phoneSetting.Duplicate_Field_Logic__c = '1';
            phoneSetting.Inactive_Record_Field_Map__c = '';
            phoneSetting.Active_Record_Field_Map__c = '';
            phoneSetting.Is_Hard_Delete_Records__c = true;
            phoneSetting.Staging_Record_Where_Clause__c = '';
            phoneSetting.Page_Name__c = 'My Information';
            phoneSetting.Max_Number_of_Query_Records__c = 1;
            phoneSetting.Front_End_Section_Id__c = 'phones';
            phoneSetting.Front_End_Section_Label__c = 'Phones';
            phoneSetting.Is_Child__c = false;
            phoneSetting.Group_By_Clause__c = '';
            phoneSetting.SObject_Relationship_API_Name__c = '';
            phoneSetting.Relationship_Wrapper_Id__c = '';
            Map<String, Object> phoneSettingAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(phoneSetting));
            phoneSettingAsMap.put('Portal_Section_Field_Settings__r', new Map<String, Object>{'records' => new List<Portal_Section_Field_Setting__mdt>{phoneNumberSetting}});
            phoneSetting = (Portal_Page_Section_Setting__mdt) System.JSON.deserialize(System.JSON.serialize(phoneSettingAsMap), Portal_Page_Section_Setting__mdt.class);

            directoryOptOutSetting = new Portal_Section_Field_Setting__mdt();
            directoryOptOutSetting.Label = 'Contact - Directory Opt Out';
            directoryOptOutSetting.Field_API_Name__c = 'Directory_Opt_out__c';
            directoryOptOutSetting.Field_Type__c = 'checkbox';
            directoryOptOutSetting.Is_Display_On_Portal__c = true;
            directoryOptOutSetting.Is_Disabled__c = false;
            directoryOptOutSetting.Has_Toggle__c = true;
            directoryOptOutSetting.Filter_Value__c = '';
            directoryOptOutSetting.Filter_Field__c = '';
            directoryOptOutSetting.Front_End_Field_Label__c = 'Directory Opt Out';
            directoryOptOutSetting.Field_Order_For_Duplicate_Logic__c = '1';
            directoryOptOutSetting.Is_Create_New_Record__c = true;
            directoryOptOutSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
            directoryOptOutSetting.Staging_Record_Field_API_Name__c = '';
            directoryOptOutSetting.Static_Value_For_Staging_Field__c = '';
            directoryOptOutSetting.Staging_Field_Population_Condition_Value__c = '';
            directoryOptOutSetting.Front_End_Field_Id__c = 'directoryOptOut';
            directoryOptOutSetting.Front_End_Field_Only__c = false;
            directoryOptOutSetting.Lookup_SObject_Name__c = '';
            directoryOptOutSetting.Lookup_Filter_Clause__c = '';
            directoryOptOutSetting.Lookup_Field_Name__c = '';
            directoryOptOutSetting.Has_Report_Update_Link__c = true;

            directorySetting = new Portal_Page_Section_Setting__mdt();
            directorySetting.Label = 'Directory - Directory Opt Out';
            directorySetting.SObject_API_Name__c = 'Contact';
            directorySetting.Staging_Record_Controlling_Parent_Field__c = '';
            directorySetting.Controlling_Parent_Field_API_Name__c = 'Id';
            directorySetting.Page_Main_Section__c = 'Directory';
            directorySetting.Page_Sub_Section__c = '';
            directorySetting.Is_Display_Section__c = true;
            directorySetting.Is_Disabled__c = true;
            directorySetting.Is_Display_Toggle_On_Section__c = true;
            directorySetting.Is_Display_Toggle_Per_Record__c = true;
            directorySetting.Where_Clause__c = '';
            directorySetting.Order_By_Clause__c = '';
            directorySetting.Is_Create_Staging_Record_Upon_Edit__c = true;
            directorySetting.Is_Create_Staging_Record_Upon_Creation__c = true;
            directorySetting.Is_Create_Staging_Record_Using_Fields__c  = true;
            directorySetting.Create_Staging_Record_Condition_Field__c = '';
            directorySetting.Create_Staging_Record_Condition_Value__c = '';
            directorySetting.Create_Staging_Record_Condition_Operator__c = '';
            directorySetting.Staging_sObject_API_Name__c = 'ucinn_ascendv2__Interim__c';
            directorySetting.Has_Duplicate_Logic__c = true;
            directorySetting.Has_Report_Update_Link__c = true;
            directorySetting.Duplicate_Field_Logic__c = '1';
            directorySetting.Inactive_Record_Field_Map__c = '';
            directorySetting.Active_Record_Field_Map__c = '';
            directorySetting.Is_Hard_Delete_Records__c = true;
            directorySetting.Staging_Record_Where_Clause__c = '';
            directorySetting.Page_Name__c = 'My Information';
            directorySetting.Max_Number_of_Query_Records__c = 1;
            directorySetting.Front_End_Section_Id__c = 'directory';
            directorySetting.Front_End_Section_Label__c = 'Directory';
            directorySetting.Is_Child__c = false;
            directorySetting.Group_By_Clause__c = '';
            directorySetting.Relationship_Wrapper_Id__c = '';
            directorySetting.SObject_Relationship_API_Name__c = '';
            Map<String, Object> directorySettingAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(directorySetting));
            directorySettingAsMap.put('Portal_Section_Field_Settings__r', new Map<String, Object>{'records' => new List<Portal_Section_Field_Setting__mdt>{directoryOptOutSetting}});
            directorySetting = (Portal_Page_Section_Setting__mdt) System.JSON.deserialize(System.JSON.serialize(directorySettingAsMap), Portal_Page_Section_Setting__mdt.class);


            degreeSetting = new Portal_Section_Field_Setting__mdt();
            degreeSetting.Label = 'Degrees - Degree';
            degreeSetting.Field_API_Name__c = 'ucinn_ascendv2__Degree__c';
            degreeSetting.Field_Type__c = 'picklist';
            degreeSetting.Is_Display_On_Portal__c = true;
            degreeSetting.Is_Disabled__c = false;
            degreeSetting.Has_Toggle__c = true;
            degreeSetting.Filter_Value__c = '';
            degreeSetting.Filter_Field__c = '';
            degreeSetting.Front_End_Field_Label__c = 'Degree';
            degreeSetting.Field_Order_For_Duplicate_Logic__c = '1';
            degreeSetting.Is_Create_New_Record__c = true;
            degreeSetting.Is_Create_Staging_Record_On_Field_Change__c = true;
            degreeSetting.Staging_Record_Field_API_Name__c = '';
            degreeSetting.Static_Value_For_Staging_Field__c = '';
            degreeSetting.Staging_Field_Population_Condition_Value__c = '';
            degreeSetting.Front_End_Field_Id__c = 'degreeDegree';
            degreeSetting.Front_End_Field_Only__c = false;
            degreeSetting.Lookup_SObject_Name__c = '';
            degreeSetting.Lookup_Filter_Clause__c = '';
            degreeSetting.Lookup_Field_Name__c = '';
            degreeSetting.Has_Report_Update_Link__c = true;

            directoryDegreeSetting = new Portal_Page_Section_Setting__mdt();
            directoryDegreeSetting.Label = 'Directory - Directory Opt Out';
            directoryDegreeSetting.SObject_API_Name__c = 'Contact';
            directoryDegreeSetting.Staging_Record_Controlling_Parent_Field__c = '';
            directoryDegreeSetting.Controlling_Parent_Field_API_Name__c = '';
            directoryDegreeSetting.Page_Main_Section__c = 'Directory';
            directoryDegreeSetting.Page_Sub_Section__c = '';
            directoryDegreeSetting.Is_Display_Section__c = true;
            directoryDegreeSetting.Is_Disabled__c = true;
            directoryDegreeSetting.Is_Display_Toggle_On_Section__c = true;
            directoryDegreeSetting.Is_Display_Toggle_Per_Record__c = true;
            directoryDegreeSetting.Where_Clause__c = '';
            directoryDegreeSetting.Order_By_Clause__c = '';
            directoryDegreeSetting.Is_Create_Staging_Record_Upon_Edit__c = true;
            directoryDegreeSetting.Is_Create_Staging_Record_Upon_Creation__c = true;
            directoryDegreeSetting.Is_Create_Staging_Record_Using_Fields__c  = true;
            directoryDegreeSetting.Create_Staging_Record_Condition_Field__c = '';
            directoryDegreeSetting.Create_Staging_Record_Condition_Value__c = '';
            directoryDegreeSetting.Create_Staging_Record_Condition_Operator__c = '';
            directoryDegreeSetting.Staging_sObject_API_Name__c = 'ucinn_ascendv2__Interim__c';
            directoryDegreeSetting.Has_Duplicate_Logic__c = true;
            directoryDegreeSetting.Has_Report_Update_Link__c = true;
            directoryDegreeSetting.Duplicate_Field_Logic__c = '1';
            directoryDegreeSetting.Inactive_Record_Field_Map__c = '';
            directoryDegreeSetting.Active_Record_Field_Map__c = '';
            directoryDegreeSetting.Is_Hard_Delete_Records__c = true;
            directoryDegreeSetting.Staging_Record_Where_Clause__c = '';
            directoryDegreeSetting.Page_Name__c = 'My Information';
            directoryDegreeSetting.Max_Number_of_Query_Records__c = 1;
            directoryDegreeSetting.Front_End_Section_Id__c = 'directory';
            directoryDegreeSetting.Front_End_Section_Label__c = 'Directory';
            directoryDegreeSetting.Is_Child__c = true;
            directoryDegreeSetting.Group_By_Clause__c = '';
            directoryDegreeSetting.Relationship_Wrapper_Id__c = '';
            directoryDegreeSetting.SObject_Relationship_API_Name__c = 'ucinn_ascendv2__Degree_Information_Contact__r';
            Map<String, Object> directoryDegreeSettingAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(directoryDegreeSetting));
            directoryDegreeSettingAsMap.put('Portal_Section_Field_Settings__r', new Map<String, Object>{'records' => new List<Portal_Section_Field_Setting__mdt>{degreeSetting}});
            directoryDegreeSetting = (Portal_Page_Section_Setting__mdt) System.JSON.deserialize(System.JSON.serialize(directoryDegreeSettingAsMap), Portal_Page_Section_Setting__mdt.class);
        }


        public virtual void testGetPageSectionSettingRecords() {
            PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('' , '', '');
            PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('My Information', 'Personal_Information', 'Name');
        }


        public virtual void testGeneratePageSectionSettingMap() {
            setupData();
            PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(new List<Portal_Page_Section_Setting__mdt>{nameSetting, phoneSetting, directorySetting, directoryDegreeSetting});
            PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(new List<Portal_Page_Section_Setting__mdt>{});
            PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(new List<Portal_Page_Section_Setting__mdt>{nameSetting, phoneSetting, directorySetting, directorySetting, directoryDegreeSetting, directoryDegreeSetting});
        }


        public virtual void testGetPicklists() {
            //PORTAL_UTIL_PageSectionSetting.getPicklists(new List<Portal_Page_Section_Setting__mdt>{directoryDegreeSetting});
            PORTAL_UTIL_PageSectionSetting.getPicklists(PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('My Information', '', ''));
            PORTAL_UTIL_PageSectionSetting.getPicklists(new List<Portal_Page_Section_Setting__mdt>{});
        }


        public virtual void testGetFrontEndDataMap() {
            PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('My Information', '', ''));
            PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(new List<Portal_Page_Section_Setting__mdt>{});
        }


        public virtual void testQueryForRecords() {
            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
            insert orgSettings;

            Account acct = new Account(name = 'ACME Co');
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              ucinn_portal_Is_Display_On_Portal__c = true,
                              Email = 'testCommunityUsermig123@test.com');

            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home - Cell';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            homePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => homePhone});
            insert homePhone;

            ucinn_ascendv2__Contact_Name__c fullName = new ucinn_ascendv2__Contact_Name__c();
            fullName.ucinn_ascendv2__First_Name__c = 'Full';
            fullName.ucinn_ascendv2__Last_Name__c = 'Name';
            fullName.ucinn_ascendv2__Type__c = 'Full Name';
            fullName.ucinn_ascendv2__Contact__c = con.Id;
            fullName = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => fullName});
            insert fullName;

            ucinn_ascendv2__Degree_Information__c degree = new ucinn_ascendv2__Degree_Information__c();
            degree.ucinn_ascendv2__Degree_Institution__c = acct.Id;
            degree.ucinn_ascendv2__Contact__c = con.Id;
            degree = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => degree});
            insert degree;

            Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('My Information', '', ''));

            Test.startTest();
            PORTAL_UTIL_PageSectionSetting.queryForRecords(con.Id, pageSectionMap, null, true, true);

            PORTAL_UTIL_PageSectionSetting.queryForRecords(con.Id, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(), true, true);

            PORTAL_UTIL_PageSectionSetting.queryForRecords(con.Id, pageSectionMap, null, false, false);


            PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
            dynamicQueryClass.dynamicWhereClause = ' WHERE Name != null ';
            dynamicQueryClass.dynamicGroupByClause = '';
            dynamicQueryClass.dynamicOrderByClause = '';
            dynamicQueryClass.maxItems = 1;
            dynamicQueryClass.offset = 1;
            dynamicQueryClass.overrideMetadata = false;

            PORTAL_UTIL_PageSectionSetting.queryForRecords(con.Id, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{'Non_School_Degree_Information' => dynamicQueryClass}, true, true);

            PORTAL_UTIL_PageSectionSetting.queryForRecords(null, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{'Non_School_Degree_Information' => dynamicQueryClass}, true, true);
            Test.stopTest();
        }


        public virtual void getPortalPageSectionDisplayMetadataTest() {
            try {
                PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata(null, null, null, null, null, null, null);
            }
            catch(PORTAL_UTIL_PageSectionSetting.PortalPageSectionException e) {

            }

            PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata('My Information', 'Personal_Information', 'Name', 'Name', null, null, new List<PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{
                                                                                                                                                            new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass(),
                                                                                                                                                            new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass()
                                                                                                                                                        });

        }
    }

    @isTest
    global static void testGetPageSectionSettingRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_PageSectionSettingTestClass().testGetPageSectionSettingRecords();
    }

    @isTest
    global static void testGeneratePageSectionSettingMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_PageSectionSettingTestClass().testGeneratePageSectionSettingMap();
    }

    @isTest
    global static void testGetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_PageSectionSettingTestClass().testGetPicklists();
    }

    @isTest
    global static void testGetFrontEndDataMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_PageSectionSettingTestClass().testGetFrontEndDataMap();
    }

    @isTest
    global static void testQueryForRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_PageSectionSettingTestClass().testQueryForRecords();
    }

    @isTest
    global static void getPortalPageSectionDisplayMetadataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_PageSectionSettingTestClass().getPortalPageSectionDisplayMetadataTest();
    }
}