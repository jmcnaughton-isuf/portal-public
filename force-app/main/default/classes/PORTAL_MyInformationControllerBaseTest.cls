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
public without sharing class PORTAL_MyInformationControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData(){

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

            System.runAs(thisUser) {

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
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
                                        username = 'testCommunityUsermig123@test.com');

                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;
            }

        }


        public virtual void testGetUserInfo() {

            setupData();

            ucinn_portal_Directory_Setting__c directorySetting = new ucinn_portal_Directory_Setting__c();
            directorySetting.Contact__c = con.Id;
            directorySetting.Is_Show_Home_Address__c = false;
            directorySetting.Is_Show_Home_Street__c = false;
            directorySetting.Is_Show_Home_City__c = true;
            directorySetting.Is_Show_Home_State__c = true;
            directorySetting.Is_Show_Home_Country__c = true;
            directorySetting.Is_Show_Home_Postal__c = false;
            directorySetting.Is_Show_Work_Address__c = false;
            directorySetting.Is_Show_Work_Street__c = false;
            directorySetting.Is_Show_Work_City__c = true;
            directorySetting.Is_Show_Work_State__c = true;
            directorySetting.Is_Show_Work_Country__c = true;
            directorySetting.Is_Show_Work_Postal__c = false;
            directorySetting.Is_Show_Home_Phone__c = false;
            directorySetting.Is_Show_Mobile_Phone__c = false;
            directorySetting.Is_Show_Work_Phone__c = false;
            directorySetting.Is_Student_Can_See__c = true;
            directorySetting.Is_Show_Gender__c = false;
            directorySetting.Is_Show_Maiden_Name__c = true;
            directorySetting = (ucinn_portal_Directory_Setting__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => directorySetting});
            insert directorySetting;

            createPhones();
            createAddresses();
            createEmails();
            createNames();
            createInterims();

            System.runAs(communityUser) {
                PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
                controller.getConstituentInformation(new Map<String, Object>{controller.PARAM_CONTACT_ID => con.Id});
            }
        }

        public virtual void createPhones() {

            List<ucinn_ascendv2__Phone__c> phones = new List<ucinn_ascendv2__Phone__c>();

            ucinn_ascendv2__Phone__c homePhone = new ucinn_ascendv2__Phone__c();
            homePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            homePhone.ucinn_ascendv2__Type__c = 'Home';
            homePhone.ucinn_ascendv2__Is_Preferred__c = true;
            homePhone.ucinn_ascendv2__Status__c = 'Current';
            homePhone.ucinn_ascendv2__Contact__c = con.Id;
            homePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            homePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            homePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => homePhone});
            phones.add(homePhone);

            ucinn_ascendv2__Phone__c inactivePhone = new ucinn_ascendv2__Phone__c();
            inactivePhone.ucinn_ascendv2__Phone_Number__c = '5555555555';
            inactivePhone.ucinn_ascendv2__Type__c = 'Home';
            inactivePhone.ucinn_ascendv2__Is_Preferred__c = false;
            inactivePhone.ucinn_ascendv2__Status__c = 'Inactive';
            inactivePhone.ucinn_ascendv2__Contact__c = con.Id;
            inactivePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            inactivePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            inactivePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => inactivePhone});
            phones.add(inactivePhone);

            ucinn_ascendv2__Phone__c mobilePhone = new ucinn_ascendv2__Phone__c();
            mobilePhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            mobilePhone.ucinn_ascendv2__Type__c = 'Mobile';
            mobilePhone.ucinn_ascendv2__Is_Preferred__c = false;
            mobilePhone.ucinn_ascendv2__Status__c = 'Current';
            mobilePhone.ucinn_ascendv2__Contact__c = con.Id;
            mobilePhone.ucinn_portal_Is_Display_On_Portal__c = true;
            mobilePhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            mobilePhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => mobilePhone});
            phones.add(mobilePhone);

            ucinn_ascendv2__Phone__c businessPhone = new ucinn_ascendv2__Phone__c();
            businessPhone.ucinn_ascendv2__Phone_Number__c = '9876543210';
            businessPhone.ucinn_ascendv2__Type__c = 'Business';
            businessPhone.ucinn_ascendv2__Is_Preferred__c = false;
            businessPhone.ucinn_ascendv2__Status__c = 'Current';
            businessPhone.ucinn_portal_Is_Display_On_Portal__c = true;
            businessPhone.ucinn_ascendv2__Contact__c = con.Id;
            businessPhone.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Phone__c.getRecordTypeInfosByDeveloperName().get('Contact_Phone').getRecordTypeId();
            businessPhone = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => businessPhone});
            phones.add(businessPhone);

            insert phones;


        }

        public virtual void createAddresses( ) {

           ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(ucinn_ascendv2__Address_Line_1__c = '230 Commerce',
                                                                        ucinn_ascendv2__City__c = 'Irvine',
                                                                        ucinn_ascendv2__State__c = 'CA',
                                                                        ucinn_ascendv2__Country__c = '');
            address = (ucinn_ascendv2__Address__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => address});
            insert address;

            ucinn_ascendv2__Address_Relation__c relation = new ucinn_ascendv2__Address_Relation__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                    ucinn_ascendv2__Address__c = address.Id,
                                                                                                    ucinn_ascendv2__Is_Preferred__c = false,
                                                                                                    ucinn_ascendv2__Status__c = 'Current',
                                                                                                    ucinn_ascendv2__Start_Date__c = Date.today(),
                                                                                                    ucinn_ascendv2__End_Date__c = Date.today().addDays(10),
                                                                                                    RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get('Contact_Address_Relation').getRecordTypeId(),
                                                                                                    ucinn_ascendv2__Type__c = 'Home',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true);

            relation = (ucinn_ascendv2__Address_Relation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => relation});
            insert relation;


        }

        public virtual void createEmails() {
            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c(ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com',
                                                                          ucinn_ascendv2__Contact__c = con.Id,
                                                                          ucinn_ascendv2__Status__c = 'Current',
                                                                          ucinn_ascendv2__Type__c = 'Business',
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            email = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email});
               insert email;
        }

        public virtual void createInterims() {

            ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
            interim.ucinn_ascendv2__First_Name__c = 'Test';
            interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get('Bio_Information').getRecordTypeId();
            interim.ucinn_ascendv2__Contact__c = con.Id;
            interim.ucinn_ascendv2__Status__c = 'Under Approval';
            interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
            insert interim;

            ucinn_ascendv2__Degree_Information__c degree = new ucinn_ascendv2__Degree_Information__c();
            degree.ucinn_ascendv2__Interim__c = interim.Id;
            Account degreeInstitution = new Account(Name='University');
            degreeInstitution = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => degreeInstitution});
            insert degreeInstitution;

            degree.ucinn_ascendv2__Degree_Institution__c = degreeInstitution.Id;
            degree.ucinn_ascendv2__Non_School_Major__c = 'Test';

            Contact dummyContact = new Contact(LastName = 'dummy', AccountId = degreeInstitution.Id);
            dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});
            insert dummyContact;
            degree.ucinn_ascendv2__Contact__c = dummyContact.Id;
            degree = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => degree});
            insert degree;

            ucinn_ascendv2__Interim__c spousalInterim = new ucinn_ascendv2__Interim__c();
            spousalInterim.ucinn_ascendv2__Status__c = 'Manual Review';
            spousalInterim.ucinn_ascendv2__Manual_Review_Reason__c = 'Spouse information changed';
            spousalInterim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get('Bio_Information').getRecordTypeId();
            spousalInterim.ucinn_ascendv2__Contact__c = con.Id;
            spousalInterim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => spousalInterim});
            insert spousalInterim;
        }

        public virtual void createNames() {

            List<ucinn_ascendv2__Contact_Name__c> names = new List<ucinn_ascendv2__Contact_Name__c>();

            ucinn_ascendv2__Contact_Name__c fullName = new ucinn_ascendv2__Contact_Name__c();
            fullName.ucinn_ascendv2__First_Name__c = 'Full';
            fullName.ucinn_ascendv2__Last_Name__c = 'Name';
            fullName.ucinn_ascendv2__Type__c = 'Full Name';
            fullName.ucinn_ascendv2__Contact__c = con.Id;
            fullName = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => fullName});
            names.add(fullName);

            ucinn_ascendv2__Contact_Name__c maidenName = new ucinn_ascendv2__Contact_Name__c();
            maidenName.ucinn_ascendv2__First_Name__c = 'Maiden';
            maidenName.ucinn_ascendv2__Last_Name__c = 'Name';
            maidenName.ucinn_ascendv2__Type__c = 'Maiden';
            maidenName.ucinn_ascendv2__Contact__c = con.Id;
            maidenName = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => maidenName});
            names.add(maidenName);

            ucinn_ascendv2__Contact_Name__c directoryName = new ucinn_ascendv2__Contact_Name__c();
            directoryName.ucinn_ascendv2__First_Name__c = 'Directory';
            directoryName.ucinn_ascendv2__Last_Name__c = 'Name';
            directoryName.ucinn_ascendv2__Type__c = 'Directory Name';
            directoryName.ucinn_ascendv2__Contact__c = con.Id;
            directoryName = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => directoryName});
            names.add(directoryName);

            ucinn_ascendv2__Contact_Name__c nicnkname = new ucinn_ascendv2__Contact_Name__c();
            nicnkname.ucinn_ascendv2__First_Name__c = 'Nick';
            nicnkname.ucinn_ascendv2__Last_Name__c = 'Name';
            nicnkname.ucinn_ascendv2__Type__c = 'Nickname';
            nicnkname.ucinn_ascendv2__Contact__c = con.Id;
            nicnkname = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => nicnkname});
            names.add(nicnkname);

            insert names;
        }


        public virtual void testProfileUpdate() {
            setupData();
            Test.startTest();
            ucinn_portal_Directory_Setting__c directorySetting = new ucinn_portal_Directory_Setting__c();
            directorySetting.Contact__c = con.Id;
            directorySetting.Is_Show_Home_Address__c = false;
            directorySetting.Is_Show_Home_Street__c = false;
            directorySetting.Is_Show_Home_City__c = true;
            directorySetting.Is_Show_Home_State__c = true;
            directorySetting.Is_Show_Home_Country__c = true;
            directorySetting.Is_Show_Home_Postal__c = false;
            directorySetting.Is_Show_Work_Address__c = false;
            directorySetting.Is_Show_Work_Street__c = false;
            directorySetting.Is_Show_Work_City__c = true;
            directorySetting.Is_Show_Work_State__c = true;
            directorySetting.Is_Show_Work_Country__c = true;
            directorySetting.Is_Show_Work_Postal__c = false;
            directorySetting.Is_Show_Home_Phone__c = false;
            directorySetting.Is_Show_Mobile_Phone__c = false;
            directorySetting.Is_Show_Work_Phone__c = false;
            directorySetting.Is_Student_Can_See__c = true;
            directorySetting.Is_Show_Gender__c = false;
            directorySetting.Is_Show_Maiden_Name__c = true;
            directorySetting = (ucinn_portal_Directory_Setting__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => directorySetting});
            insert directorySetting;

            createPhones();
            createAddresses();
            createEmails();
            createNames();
            createInterims();

            System.runAs(communityUser) {
                PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
                Map<String, Object> informationMap = PORTAL_MyInformationController.SERVER_getConstituentInformation();
                Map<String, Object> recordsMap = (Map<String, Object>) informationMap.get('records');

                Map<String, Object> phoneMap = (Map<String, Object>) recordsMap.get('Phones');
                List<Object> phoneList = (List<Object>) phoneMap.get('records');
                Map<String, Object> phone = (Map<String, Object>) phoneList.get(0);
                phone.put('phoneNumber', '9745323135');
                Map<String, Object> newPhone = new Map<String, Object>();
                newPhone.put('phoneNumber', '5555555555');
                newPhone.put('phoneType', 'Home');
                newPhone.put('status', 'Current');
                phoneList.set(0, phone);
                phoneList.remove(2);
                phoneList.add(newPhone);
                phoneMap.put('records', phoneList);
                recordsMap.put('Phones', phoneMap);

                Map<String, Object> contactMap = (Map<String, Object>) recordsMap.get('Personal_Information');
                List<Object> contactList = (List<Object>) contactMap.get('Additional_Details');
                Map<String, Object> contact = (Map<String, Object>) contactList.get(0);
                contact.put('gender', 'Female');
                contact.put('maritalStatus', 'Married');
                contact.put('spouseFirstName', 'Test');
                contact.put('spouseLastName', 'Spouse');
                contactList.set(0, contact);
                contactMap.put('Additional_Details', contactList);
                recordsMap.put('Personal_Information', contactMap);


                Map<String, Object> addressMap = (Map<String, Object>) recordsMap.get('Addresses');
                List<Object> addressList = (List<Object>) addressMap.get('records');
                Map<String, Object> address = (Map<String, Object>) addressList.get(0);
                address.put('addressLine1', '2855 Michelle Drive');
                address.put('addressCountry', 'United States');
                address.put('addressPostalCode', '92602');
                addressList.set(0, address);
                addressMap.put('records', addressList);
                recordsMap.put('Addresses', addressMap);

                Map<String, Object> degreeMap = (Map<String, Object>) recordsMap.get('Degrees');
                List<Object> degreeList = (List<Object>) degreeMap.get('Non_School_Degree_Information');
                if (degreeList == null) {
                    degreeList = new List<Object>();
                }
                Map<String, Object> degree = new Map<String, Object>();
                degree.put('nonSchoolDegreeInstitution', 'New School');
                degree.put('nonSchoolDegreeMajor', 'Test');
                degree.put('nonSchoolDegreeYear', '2010');
                degree.put('isShowYear', false);
                degree.put('isShowDegree', false);
                degree.put('isShowInstitution', false);
                degree.put('isShowMajor', false);
                degree.put('isShowOnDirectory', false);
                degreeList.add(degree);
                degreeMap.put('Non_School_Degree_Information', degreeList);
                recordsMap.put('Degrees', degreeMap);

                informationMap.put('records', recordsMap);

                Map<String, Object> interimRecordsMap = (Map<String, Object>) informationMap?.get('interimRecords');
                Map<String, Object> interimDegreeMap = (Map<String, Object>) interimRecordsMap?.get('nonSchoolDegrees');
                List<Object> interimDegrees = (List<Object>) interimDegreeMap?.get('nonSchoolDegrees');
                interimDegrees?.clear();
                interimDegreeMap?.put('nonSchoolDegrees', interimDegrees);
                interimRecordsMap?.put('nonSchoolDegrees', interimDegreeMap);

                informationMap?.put('Change_Set', new List<String>{'Phones', 'Addresses', 'Directory_Opt_Out', 'Directory_Setting', 'Non_School_Degree_Information', 'Additional_Details', 'Also_Known_As'});
                try {
                    PORTAL_MyInformationController.SERVER_saveInformation(informationMap);
                } catch(Exception e) {
                    // if this fails, most likely a permission issue
                    System.debug('!!! ' + e);
                }
            }

            Test.stopTest();
        }


        public virtual void testSpouseUpdate() {
            setupData();

            ucinn_portal_Directory_Setting__c directorySetting = new ucinn_portal_Directory_Setting__c();
            directorySetting.Contact__c = con.Id;
            directorySetting.Is_Show_Home_Address__c = false;
            directorySetting.Is_Show_Home_Street__c = false;
            directorySetting.Is_Show_Home_City__c = true;
            directorySetting.Is_Show_Home_State__c = true;
            directorySetting.Is_Show_Home_Country__c = true;
            directorySetting.Is_Show_Home_Postal__c = false;
            directorySetting.Is_Show_Work_Address__c = false;
            directorySetting.Is_Show_Work_Street__c = false;
            directorySetting.Is_Show_Work_City__c = true;
            directorySetting.Is_Show_Work_State__c = true;
            directorySetting.Is_Show_Work_Country__c = true;
            directorySetting.Is_Show_Work_Postal__c = false;
            directorySetting.Is_Show_Home_Phone__c = false;
            directorySetting.Is_Show_Mobile_Phone__c = false;
            directorySetting.Is_Show_Work_Phone__c = false;
            directorySetting.Is_Student_Can_See__c = true;
            directorySetting.Is_Show_Gender__c = false;
            directorySetting.Is_Show_Maiden_Name__c = true;
            directorySetting = (ucinn_portal_Directory_Setting__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => directorySetting});
            insert directorySetting;

            createPhones();
            createAddresses();
            createEmails();
            createNames();
            createInterims();

            Contact spouse = new Contact(FirstName = 'Test', LastName = 'Test', AccountId = con.AccountId);
            spouse = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => spouse});
            insert spouse;
            con.ucinn_ascendv2__Preferred_Spouse__c = spouse.Id;
            update con;

            System.runAs(communityUser) {
                PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
                Map<String, Object> informationMap = controller.getConstituentInformation(new Map<String, Object>{controller.PARAM_CONTACT_ID => con.Id});
                Map<String, Object> recordsMap = (Map<String, Object>) informationMap.get('records');

                Map<String, Object> contactMap = (Map<String, Object>) recordsMap.get('Personal_Information');
                List<Object> contactList = (List<Object>) contactMap.get('Additional_Details');
                Map<String, Object> contact = (Map<String, Object>) contactList.get(0);
                contact.put('gender', 'Female');
                contact.put('maritalStatus', 'Married');
                contact.put('spouseFirstName', 'Married');
                contact.put('spouseLastName', 'Married');
                contactList.set(0, contact);
                contactMap.put('Additional_Details', contactList);
                recordsMap.put('Personal_Information', contactMap);

                informationMap.put('records', recordsMap);

                informationMap.put('Change_Set', new List<String>{'Additional_Details'});
                new PORTAL_MyInformationControllerBase().saveInformation(informationMap);

            }

        }


        public virtual void testReportUpdateWithInterim() {
            setupData();

            ucinn_portal_Directory_Setting__c directorySetting = new ucinn_portal_Directory_Setting__c();
            directorySetting.Contact__c = con.Id;
            directorySetting.Is_Show_Home_Address__c = false;
            directorySetting.Is_Show_Home_Street__c = false;
            directorySetting.Is_Show_Home_City__c = true;
            directorySetting.Is_Show_Home_State__c = true;
            directorySetting.Is_Show_Home_Country__c = true;
            directorySetting.Is_Show_Home_Postal__c = false;
            directorySetting.Is_Show_Work_Address__c = false;
            directorySetting.Is_Show_Work_Street__c = false;
            directorySetting.Is_Show_Work_City__c = true;
            directorySetting.Is_Show_Work_State__c = true;
            directorySetting.Is_Show_Work_Country__c = true;
            directorySetting.Is_Show_Work_Postal__c = false;
            directorySetting.Is_Show_Home_Phone__c = false;
            directorySetting.Is_Show_Mobile_Phone__c = false;
            directorySetting.Is_Show_Work_Phone__c = false;
            directorySetting.Is_Student_Can_See__c = true;
            directorySetting.Is_Show_Gender__c = false;
            directorySetting.Is_Show_Maiden_Name__c = true;
            directorySetting = (ucinn_portal_Directory_Setting__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => directorySetting});
            insert directorySetting;

            createPhones();
            createAddresses();
            createEmails();
            createNames();
            createInterims();

            Account degreeInstitution = new Account(Name='University');
            degreeInstitution = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => degreeInstitution});
            insert degreeInstitution;

            System.runAs(communityUser) {
                PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
                Map<String, Object> record = new Map<String, Object>();
                record.put('gender', 'Female');
                PORTAL_MyInformationController.SERVER_reportUpdate(new Map<String, Object>{'record' => record, 'sObjectName' => 'interims'});
                Map<String, Object> degree = new Map<String, Object>();
                degree.put('schoolDegreeYear', '2015');
                PORTAL_MyInformationController.SERVER_reportUpdate(new Map<String, Object>{'record' => degree, 'sObjectName' => 'schoolDegreesSelfReport', 'recordType' => 'School_Degree_Information', 'masterDegreeId' => (String)degree.get('ucinn_portal_Master_Degree_Information__c'), 'recordToUpdateId' => (String)degree.get('Id')});
            }

        }


        public virtual void testDedupeRecords() {
            PORTAL_MyInformationControllerBase base = new PORTAL_MyInformationControllerBase();
            base.dedupeRecords(new List<String>{'1', '2', '3', '4'}, new Map<String, String>{'1' => 'Name'}, new Contact(), new Contact());
            base.dedupeRecords(new List<String>{'1', 'AND'}, new Map<String, String>{'1' => 'Name'}, new Contact(), new Contact());
            base.dedupeRecords(new List<String>{'AND', 'AND', 'AND', 'AND'}, new Map<String, String>{'1' => 'Name'}, new Contact(), new Contact());
        }


        public virtual void testEvaluateStagingRecordFieldCondition() {
            PORTAL_MyInformationControllerBase base = new PORTAL_MyInformationControllerBase();
            base.evaluateStagingRecordFieldCondition(new Map<String, Object>{base.PARAM_NEW_RECORD => new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Non_School_Major__c = 'Test'),
                                                                            base.PARAM_FIELD_TO_CONDITIONS_MAP => new Map<String, Map<String, String>>{'ucinn_ascendv2__Non_School_Major__c' => new Map<String, String>{'value'=> '', 'operator' => 'ISNOTBLANK'}}});
            base.evaluateStagingRecordFieldCondition(new Map<String, Object>{base.PARAM_NEW_RECORD => new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Non_School_Major__c = 'Test'),
                                                                            base.PARAM_FIELD_TO_CONDITIONS_MAP => new Map<String, Map<String, String>>{'ucinn_ascendv2__Non_School_Major__c' => new Map<String, String>{'value'=> '', 'operator' => 'ISBLANK'}}});
            base.evaluateStagingRecordFieldCondition(new Map<String, Object>{base.PARAM_NEW_RECORD => new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Non_School_Major__c = 'Test'),
                                                                            base.PARAM_FIELD_TO_CONDITIONS_MAP => new Map<String, Map<String, String>>{'ucinn_ascendv2__Degree_Institution__r.' => new Map<String, String>{'value'=> '', 'operator' => 'ISBLANK'}}});
            base.evaluateStagingRecordFieldCondition(new Map<String, Object>{base.PARAM_NEW_RECORD => new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Non_School_Major__c = 'Test'),
                                                                            base.PARAM_FIELD_TO_CONDITIONS_MAP => new Map<String, Map<String, String>>{'ucinn_ascendv2__Degree_Institution__r.Name' => new Map<String, String>{'value'=> '', 'operator' => 'ISBLANK'}}});
        }



        public virtual void testConstructor() {

            setupData();
            System.runAs(communityUser) {
                new PORTAL_MyInformationControllerBase('Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test','Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test' );

            }


        }



        public virtual void testFailures() {
            try {
                new PORTAL_MyInformationControllerBase().getConstituentInformation(new Map<String, Object>());
            } catch (Exception e) {

            }

            try {
                new PORTAL_MyInformationControllerBase().saveInformation(new Map<String, Object>());
            } catch (Exception e) {

            }
        }


        public virtual void testUpdateConstantParameters() {
            List<Portal_Organization_Setting__mdt> orgSettings = new List<Portal_Organization_Setting__mdt>();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.INTERIM_RECORD_TYPE_METADATA_RECORD_NAME,
                                                                    Value__c = controller.INTERIM_RECORD_TYPE_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.INTERIM_DISPLAY_STATUS_METADATA_RECORD_NAME,
                                                                    Value__c = controller.INTERIM_DISPLAY_STATUS));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.SPOUSAL_INTERIM_DESCRIPTION_METADATA_RECORD_NAME,
                                                                    Value__c = controller.SPOUSAL_INTERIM_DESCRIPTION));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.SPOUSAL_INTERIM_STATUS_METADATA_RECORD_NAME,
                                                                    Value__c = controller.SPOUSAL_INTERIM_STATUS));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.DUMMY_CONTACT_FIRST_NAME_METADATA_NAME,
                                                                    Value__c = controller.DUMMY_CONTACT_FIRST_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.DUMMY_CONTACT_LAST_NAME_METADATA_NAME,
                                                                    Value__c = controller.DUMMY_CONTACT_LAST_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.PRIVACY_SETTING_NAME_METADATA_NAME,
                                                                    Value__c = controller.PRIVACY_SETTING_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.DIRECTORY_SETTING_NAME_METADATA_NAME,
                                                                    Value__c = controller.DIRECTORY_SETTING_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.DIRECTORY_OPT_OUT_NAME_METADATA_NAME,
                                                                    Value__c = controller.DIRECTORY_OPT_OUT_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.SPOUSE_SUB_SECTION_NAME_METADATA_NAME,
                                                                    Value__c = controller.SPOUSE_SUB_SECTION_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.SPOUSE_MAIN_SECTION_NAME_METADATA_NAME,
                                                                    Value__c = controller.SPOUSE_MAIN_SECTION_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.CASE_GROUP_NAME_METADATA_NAME,
                                                                    Value__c = controller.CASE_GROUP_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.REPORT_UPDATE_INTERIM_RECORD_TYPE_METADATA_RECORD_NAME,
                                                                    Value__c = controller.REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  controller.REPORT_UPDATE_INTERIM_STATUS_METADATA_RECORD_NAME,
                                                                    Value__c = controller.REPORT_UPDATE_INTERIM_STATUS));
            orgSettings.add(new Portal_Organization_Setting__mdt(Label =  'Test', Value__c = ''));
            new PORTAL_MyInformationControllerBase().updateConstantParameters(orgSettings);

        }


        public virtual void testSetUpOrgSettings() {
            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            new PORTAL_MyInformationControllerBase().setupOrgSettings(new List<ucinn_ascendv2__Org_Wide_Configuration__c>{orgSettings}, new Map<String, Object>());
            new PORTAL_MyInformationControllerBase().setupOrgSettings(new List<ucinn_ascendv2__Org_Wide_Configuration__c>{}, new Map<String, Object>());
        }


        public virtual void testMapInterimRecords() {
            List<ucinn_ascendv2__Interim__c> interimList = new List<ucinn_ascendv2__Interim__c>();
            interimList.add(new ucinn_ascendv2__Interim__c());

            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
            insert orgSettings;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact testCont = new Contact(LastName = 'Test',
                                        AccountId = acct.Id,
                                        ucinn_portal_Is_Display_On_Portal__c = true,
                                        Email = 'testCommunityUsermig123@test.com');
            testCont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testCont});
            insert testCont;


            Map<String, Map<String, Set<String>>> recordToFieldSetMap = new Map<String, Map<String, Set<String>>>();
            recordToFieldSetMap.put('Contact', new Map<String, Set<String>>{'Contact' => new Set<String>{'LastName'}});
            Map<String, Map<String, List<sObject>>> returnMap = new Map<String, Map<String, List<sObject>>>();
            Map<String, Map<String, String>> recordToWhereClause = new Map<String, Map<String, String>>();
            recordToWhereClause.put('Contact', new Map<String, String>{'Contact' => 'WHERE LastName = \'Test\''});
            new PORTAL_MyInformationControllerBase().mapInterimRecords(interimList, returnMap, recordToFieldSetMap, recordToWhereClause);
            new PORTAL_MyInformationControllerBase().mapInterimRecords(interimList, returnMap, recordToFieldSetMap, recordToWhereClause);
            new PORTAL_MyInformationControllerBase().mapInterimRecords(interimList, returnMap, recordToFieldSetMap, recordToWhereClause);
        }


        public virtual void testPerformDMLOperationsDelete() {
            Map<String, List<SObject>> dmlOperationMap = new Map<String, List<sObject>>();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;


            Contact testCont = new Contact(LastName = 'Test',
                                        AccountId = acct.Id,
                                        ucinn_portal_Is_Display_On_Portal__c = true,
                                        Email = 'testCommunityUsermig123@test.com');
            testCont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testCont});
            insert testCont;
            dmlOperationMap.put(controller.DELETE_KEY, new List<sObject>{new Contact(Id = testCont.Id)});
            delete testCont;
            Map<String, String> sobjectNameToLabelMap = new Map<String, String>{'Contact' => 'contacts'};

            controller.performDMLOperations(dmlOperationMap, '',sobjectNameToLabelMap, 'Contact');
        }


        public virtual void testPerformDMLOperationsUpdate() {
            Map<String, List<SObject>> dmlOperationMap = new Map<String, List<sObject>>();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
            dmlOperationMap.put(controller.UPDATE_KEY, new List<sObject>{new Contact()});
            Map<String, String> sobjectNameToLabelMap = new Map<String, String>{'Contact' => 'contacts'};

            controller.performDMLOperations(dmlOperationMap, '',sobjectNameToLabelMap, 'Contact');
        }


        public virtual void testPerformDMLOperationsInsert() {
            Map<String, List<SObject>> dmlOperationMap = new Map<String, List<sObject>>();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
            dmlOperationMap.put(controller.INSERT_KEY, new List<sObject>{new Contact()});
            Map<String, String> sobjectNameToLabelMap = new Map<String, String>{'Contact' => 'contacts'};

            controller.performDMLOperations(dmlOperationMap, '',sobjectNameToLabelMap, 'Contact');
        }


        public virtual void testAddRecordsToDeleteToMap() {
            Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap = new Map<String, Map<String, List<sObject>>> ();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;


            Contact testCont = new Contact(LastName = 'Test',
                                        AccountId = acct.Id,
                                        ucinn_portal_Is_Display_On_Portal__c = true,
                                        Email = 'testCommunityUsermig123@test.com');
            testCont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testCont});
            insert testCont;
            Map<Id, sObject> recordsToDelete = new Map<Id, sObject>{testCont.Id => testCont};
            controller.addRecordsToDeleteToMap(sobjectNameToDmlOperationMap,recordsToDelete, 'Contact');
            controller.addRecordsToDeleteToMap(sobjectNameToDmlOperationMap,recordsToDelete, 'Contact');
            controller.addRecordsToDeleteToMap(sobjectNameToDmlOperationMap,recordsToDelete, 'Contact');
        }


        public virtual void testMapFrontEndFieldRecords() {
            Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap = new Map<String, Map<String, List<sObject>>> ();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;


            Contact testCont = new Contact(LastName = 'Test',
                                        AccountId = acct.Id,
                                        ucinn_portal_Is_Display_On_Portal__c = true,
                                        Email = 'testCommunityUsermig123@test.com');
            testCont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testCont});
            insert testCont;
            Portal_Page_Section_Setting__mdt sectionSetting = new Portal_Page_Section_Setting__mdt();
            sectionSetting.Staging_sObject_API_Name__c = 'Contact';
            sectionSetting.Inactive_Record_Field_Map__c = '{"ucinn_ascendv2__Contact_Type__c":"Friend"}';
            List<Object> objectsWithFrontEndFields = new List<Object>();
            objectsWithFrontEndFields.add((Object) new Map<String, Object>{'Id' => testCont.Id});
            Map<String, List<sObject>> interimRecordMap = new  Map<String, List<sObject>>();
            Map<Id, sObject> allRecordToIdMap = new Map<Id, sObject>{testCont.Id => testCont};
            controller.mapFrontEndFieldRecords(allRecordToIdMap, objectsWithFrontEndFields, sectionSetting, interimRecordMap, sobjectNameToDmlOperationMap);
            controller.mapFrontEndFieldRecords(allRecordToIdMap, objectsWithFrontEndFields, sectionSetting, interimRecordMap, sobjectNameToDmlOperationMap);
            controller.mapFrontEndFieldRecords(allRecordToIdMap, objectsWithFrontEndFields, sectionSetting, interimRecordMap, sobjectNameToDmlOperationMap);
        }


        public virtual void testAddFieldToRecord() {
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
            Portal_Section_Field_Setting__mdt fieldSetting = new Portal_Section_Field_Setting__mdt();
            fieldSetting.Staging_Record_Field_API_Name__c = '';
            Map<String, Object> newRecord = new Map<String, Object>();
            ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
            controller.addFieldToRecord(fieldSetting, newRecord, interim);

            fieldSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Preferred_Address__c';
            fieldSetting.Static_Value_For_Staging_Field__c = 'Address 1';
            fieldSetting.Field_API_Name__c = 'ucinn_ascendv2__Is_Preferred__c';
            newRecord.put('ucinn_ascendv2__Is_Preferred__c', true);
            fieldSetting.Staging_Field_Population_Condition_Value__c = 'true';
            controller.addFieldToRecord(fieldSetting, newRecord, interim);

            fieldSetting.Static_Value_For_Staging_Field__c = '';
            fieldSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Address_1_Line_1__c';
            fieldSetting.Field_API_Name__c = 'ucinn_ascendv2__Address__r.';
            controller.addFieldToRecord(fieldSetting, newRecord, interim);

            fieldSetting.Field_API_Name__c = 'ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c';
            newRecord.put('ucinn_ascendv2__Address__r', new Map<String, Object>{'ucinn_ascendv2__Address_Line_1__c' => 'Test'});
            controller.addFieldToRecord(fieldSetting, newRecord, interim);


            fieldSetting.Field_Type__c = 'checkbox';
            fieldSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Possible_Duplicate_Checked__c';
            fieldSetting.Field_API_Name__c = 'ucinn_ascendv2__Is_Preferred__c';
            newRecord.put('ucinn_ascendv2__Is_Preferred__c', null);
            controller.addFieldToRecord(fieldSetting, newRecord, interim);

            fieldSetting.Field_Type__c = 'date';
            fieldSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Birthdate__c';
            fieldSetting.Field_API_Name__c = 'ucinn_ascendv2__Birthdate__c';
            newRecord.put('ucinn_ascendv2__Birthdate__c', '2020-04-04');
            controller.addFieldToRecord(fieldSetting, newRecord, interim);

            fieldSetting.Field_Type__c = 'checkbox';
            fieldSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Possible_Duplicate_Checked__c';
            fieldSetting.Field_API_Name__c = '';
            fieldSetting.Front_End_Field_Id__c = 'Front_End_Field_Id__c';
            newRecord.put('Front_End_Field_Id__c', null);
            controller.addFieldToRecord(fieldSetting, newRecord, interim);

            fieldSetting.Field_Type__c = '';
            fieldSetting.Staging_Record_Field_API_Name__c = 'ucinn_ascendv2__Manual_Review_Reason__c';
            fieldSetting.Front_End_Field_Id__c = 'Front_End_Field_Id__c';
            newRecord.put('Front_End_Field_Id__c', 'Bad Interim');
            controller.addFieldToRecord(fieldSetting, newRecord, interim);
        }

        public virtual void testIsLinkRecordToInterim() {
            Test.startTest();
            PORTAL_MyInformationControllerBase controller = new PORTAL_MyInformationControllerBase();
            controller.isLinkRecordToInterim(null);
            controller.isLinkRecordToInterim(new Map<String, Object>{controller.PARAM_SECTION_SETTING => null});
            Portal_Page_Section_Setting__mdt sectionSetting = new Portal_Page_Section_Setting__mdt();
            sectionSetting.Is_Create_Staging_Record_Upon_Edit__c = true;
            sectionSetting.Staging_sObject_API_Name__c = 'Contact';
            sectionSetting.Staging_Record_Controlling_Parent_Field__c = 'Contact';
            sectionSetting.Original_Record_Field_API_Name__c = 'Contact';
            controller.isLinkRecordToInterim(new Map<String, Object>{controller.PARAM_SECTION_SETTING => sectionSetting});
            Test.stopTest();
        }

        public virtual void testCheckDuplicateFrontEndInterims() {
            Test.startTest();
            PORTAL_MyInformationControllerBase controller = (PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController();
            Map<String, String> duplicateLogicMap = new Map<String, String>();
            duplicateLogicMap.put('1' , 'ucinn_ascendv2__Phone_Number__c');
            duplicateLogicMap.put('2' , 'ucinn_ascendv2__Type__c');
            List<String> postFixExpressions = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => '1 AND 2'});
            controller.checkDuplicateFrontEndInterims(null, null, null);
            List<sObject> sObjectList = new List<sObject>();
            Map<String, Object> newPhone = new Map<String, Object>();
            newPhone.put('ucinn_ascendv2__Phone_Number__c', '5555555555');
            newPhone.put('ucinn_ascendv2__Type__c', 'Home');
            newPhone.put('ucinn_ascendv2__Status__c', 'Current');

            Map<String, Object> newPhone2 = new Map<String, Object>();
            newPhone2.put('ucinn_ascendv2__Phone_Number__c', '5555555555');
            newPhone2.put('ucinn_ascendv2__Type__c', 'Home');
            newPhone2.put('ucinn_ascendv2__Status__c', 'Current');

            sObjectList.add((sObject) System.JSON.deserialize(System.JSON.serialize(newPhone), System.Type.forName('ucinn_ascendv2__Phone__c')));
            sObjectList.add((sObject) System.JSON.deserialize(System.JSON.serialize(newPhone2), System.Type.forName('ucinn_ascendv2__Phone__c')));
            controller.checkDuplicateFrontEndInterims(null, postFixExpressions, duplicateLogicMap);

            try {
                controller.checkDuplicateFrontEndInterims(sObjectList, postFixExpressions, duplicateLogicMap);
            } catch (Exception e) {
                System.debug(e);
            }
            Test.stopTest();
        }

        public virtual void testGetAcademicOrgName() {
            Test.startTest();
            PORTAL_MyInformationControllerBase controller = (PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController();

            String result = '';

            result = controller.getAcademicOrgName(null);
            System.assertEquals(result, '');

            result = controller.getAcademicOrgName(new Map<String, Object>{controller.OBJECT_NAME => '', controller.ID_CONST => ''});
            System.assertEquals(result, '');

            result = controller.getAcademicOrgName(new Map<String, Object>{controller.OBJECT_NAME => '', controller.ID_CONST => ''});

            ucinn_ascendv2__Academic_Organization__c newAcademicOrg = new ucinn_ascendv2__Academic_Organization__c(Name = 'Test Academic Org');
            newAcademicOrg = (ucinn_ascendv2__Academic_Organization__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newAcademicOrg});
            insert newAcademicOrg;

            ucinn_ascendv2__Post_Code__c newPostCode = new ucinn_ascendv2__Post_Code__c(Name = 'Test Post Code', ucinn_ascendv2__School_1__c = newAcademicOrg.Id);
            newPostCode = (ucinn_ascendv2__Post_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newPostCode});
            insert newPostCode;

            ucinn_ascendv2__Minor_Code__c newMinorCode = new ucinn_ascendv2__Minor_Code__c(Name = 'Test Minor Code', ucinn_ascendv2__Academic_Organization__c = newAcademicOrg.Id);
            newMinorCode = (ucinn_ascendv2__Minor_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newMinorCode});
            insert newMinorCode;

            result = controller.getAcademicOrgName(new Map<String, Object>{controller.OBJECT_NAME => 'postCode', controller.ID_CONST => newPostCode.Id});

            System.assertEquals(result, 'Test Academic Org');

            result = controller.getAcademicOrgName(new Map<String, Object>{controller.OBJECT_NAME => 'minorCode', controller.ID_CONST => newMinorCode.Id});

            System.assertEquals(result, 'Test Academic Org');

            Test.stopTest();
        }

        public virtual void testCreateAddressRecord() {
            setupData();
            Test.startTest();
            PORTAL_MyInformationControllerBase controller = (PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController();

            Map<String, Object> params = new Map<String, Object>();
            params.put(controller.PARAM_CONTACT_ID, con.Id);

            Portal_Page_Section_Setting__mdt sectionSetting = new Portal_Page_Section_Setting__mdt();
            sectionSetting.Is_Create_Staging_Record_Upon_Edit__c = true;
            sectionSetting.Staging_sObject_API_Name__c = 'Contact';
            sectionSetting.Staging_Record_Controlling_Parent_Field__c = 'Contact';
            sectionSetting.Original_Record_Field_API_Name__c = 'Contact';
            params.put(controller.PARAM_SECTION_SETTING, sectionSetting);


            Test.stopTest();
        }
    }

    @isTest
    public static void testGetUserInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testGetUserInfo();
    }

    @isTest
    public static void testProfileUpdate() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testProfileUpdate();
    }

    @isTest
    public static void testSpouseUpdate() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testSpouseUpdate();
    }

    @isTest
    public static void testReportUpdateWithInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testReportUpdateWithInterim();
    }

    @isTest
    public static void testDedupeRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testDedupeRecords();
    }

    @isTest
    public static void testEvaluateStagingRecordFieldCondition() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testEvaluateStagingRecordFieldCondition();
    }

    @isTest
    public static void testConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testConstructor();
    }

    @isTest
    public static void testFailures() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testFailures();
    }

    @isTest
    public static void testUpdateConstantParameters() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testUpdateConstantParameters();
    }

    @isTest
    public static void testSetUpOrgSettings() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testSetUpOrgSettings();
    }

    @isTest
    public static void testMapInterimRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testMapInterimRecords();
    }

    @isTest
    public static void testPerformDMLOperationsDelete() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testPerformDMLOperationsDelete();
    }

    @isTest
    public static void testPerformDMLOperationsUpdate() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testPerformDMLOperationsUpdate();
    }

    @isTest
    public static void testPerformDMLOperationsInsert() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testPerformDMLOperationsInsert();
    }

    @isTest
    public static void testAddRecordsToDeleteToMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testAddRecordsToDeleteToMap();
    }

    @isTest
    public static void testMapFrontEndFieldRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testMapFrontEndFieldRecords();
    }

    @isTest
    public static void testAddFieldToRecord() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testAddFieldToRecord();
    }

    static testMethod void testIsLinkRecordToInterim() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testIsLinkRecordToInterim();
    }

    static testMethod void testCheckDuplicateFrontEndInterims() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testCheckDuplicateFrontEndInterims();
    }

    static testMethod void testGetAcademicOrgName() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerBaseTestClass().testGetAcademicOrgName();
    }
}