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
public without sharing class PORTAL_MyInformationControllerTest {
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


       public virtual void testGetConstituentInfo() {
           try {
                PORTAL_MyInformationController.SERVER_getConstituentInformation();
           } catch (Exception e) {

           }

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

            System.runAs(communityUser) {
                PORTAL_MyInformationController.SERVER_getConstituentInformation();
            }
       }


       public virtual void testSaveConstituentInfo() {
            PORTAL_MyInformationController.SERVER_saveInformation(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_MyInformationController.SERVER_saveInformation(null);
            } catch (Exception e) {
                System.debug(e);
           }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_MyInformationController.SERVER_saveInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
       }


       public virtual void testReportUpdate() {
            PORTAL_MyInformationController.SERVER_reportUpdate(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_MyInformationController.SERVER_reportUpdate(null);
            } catch (Exception e) {
               System.debug(e);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_MyInformationController.SERVER_reportUpdate(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
       }

        public virtual void testGetAcademicOrgName() {
            PORTAL_MyInformationController.SERVER_getAcademicOrgName(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_MyInformationController.SERVER_getAcademicOrgName(null);
            } catch (Exception e) {
               System.debug(e);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_MyInformationController.SERVER_getAcademicOrgName(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

    }

    @isTest
    public static void testGetConstituentInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerTestClass().testGetConstituentInfo();
    }

   @isTest
   public static void testSaveConstituentInfo() {
    PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerTestClass().testSaveConstituentInfo();
}

   @isTest
   public static void testReportUpdate() {
    PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerTestClass().testReportUpdate();
   }

    static testMethod void testGetAcademicOrgName() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationControllerTestClass().testGetAcademicOrgName();
    }

}