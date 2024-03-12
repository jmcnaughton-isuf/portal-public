/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
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
 public with sharing class PORTAL_JobBoardControllerBaseTest {
     public virtual class TestClass extends PORTAL_TestClassBase{
         public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
         public Contact contactRecord;
 
         public virtual void setUpContact() {
             contactRecord = new Contact(FirstName = 'Anthony',
                                         MiddleName='Edward',
                                         LastName='Stark',
                                         ucinn_ascendv2__Gender__c='Male',
                                         ucinn_ascendv2__Preferred_Pronouns__c='He/Him/His',
                                         ucinn_ascendv2__Marital_Status__c='Single',
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         ucinn_portal_Is_Directory_Opt_Out__c = false);
 
             contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
             insert contactRecord;
         }
 
         public virtual void testGetFrontEndDataMap() {
             Map<String, Object> params = new Map<String, Object>();
             new PORTAL_JobBoardControllerBase().getCreateJobPostingFrontEndData(params);
         }
 
         public virtual void testGetContactInfo() {
 
             ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
             orgSettings.Name = 'Default Org Wide Config';
             orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
             orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
             orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
             orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
             insert orgSettings;
 
             System.runAs(thisUser) {
 
                 Account acct = new Account(name = 'ACME Co') ;
                 acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                 insert acct;
 
 
 
                 Contact con = new Contact(LastName = 'Test_Contact',
                                             AccountId = acct.Id,
                                             ucinn_portal_Is_Display_On_Portal__c = true,
                                             Email = 'testCommunityUsermig123@test.com');
                 con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                 insert con;
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
                                         username = System.now().millisecond()+'testCommunityUsermig123@test.com');
                 communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                 insert communityUser;
 
 
                 System.runAs(communityUser) {
                     Map<String, Object> returnedContact = new PORTAL_JobBoardControllerBase().getContactInfo(new Map<String, Object>());
                     System.assert(returnedContact != null);
                 }
             }
 
         }
 
         public virtual void testGetPicklists() {
             Map<String, Object> params = new Map<String, Object>();
             new PORTAL_JobBoardControllerBase().getPicklists(params);
         }
 
         public virtual void testArchiveJob() {
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Pending';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
             Map<String, Object> params = new Map<String, Object>{'recordId' => job.Id};
             new PORTAL_JobBoardControllerBase().archiveJob(params);
             List<ucinn_portal_Job__c> jobList = [SELECT Id FROM ucinn_portal_Job__c WHERE Id = :job.Id AND Status__c = 'Archived'];
             System.assert(!jobList.isEmpty());
         }
 
         public virtual void testGetMyPostedJobs() {
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
             Map<String, Object> params = new Map<String, Object>{'closedOffset' => 0, 'openOffset' => 0};
             Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().getMyPostedJobs(params);
             System.assert(!returnMap.isEmpty());
             System.assert(returnMap.get('records') != null);
             Map<String, Map<String, List<Map<String, Object>>>> recordsMap = (Map<String, Map<String, List<Map<String, Object>>>>)  returnMap.get('records');
             System.assert(recordsMap.containsKey('Open_Jobs'));
             System.assert(recordsMap.get('Open_Jobs').containsKey('records'));
             System.assert(!recordsMap.get('Open_Jobs').get('records').isEmpty());
             System.assert(recordsMap.containsKey('Closed_Jobs'));
             System.assert(recordsMap.get('Closed_Jobs').containsKey('records'));
             System.assert(recordsMap.get('Closed_Jobs').get('records').isEmpty());
         }
 
         public virtual void testGetJobListing() {
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
             Map<String, Object> params = new Map<String, Object>{'recordId' => job.Id};
             Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().getJobListing(params);
             System.assert(!returnMap.isEmpty());
             System.assert(returnMap.get('records') != null);
             Map<String, Map<String, List<Map<String, Object>>>> recordsMap = (Map<String, Map<String, List<Map<String, Object>>>>)  returnMap.get('records');
             System.assert(recordsMap.containsKey('Job'));
             System.assert(recordsMap.get('Job').containsKey('records'));
             System.assert(!recordsMap.get('Job').get('records').isEmpty());
         }
 
         public virtual void testGetJobListingWithBlankId() {
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
             Map<String, Object> params = new Map<String, Object>{'recordId' => null};
             Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().getJobListing(params);
             System.assert(returnMap.isEmpty());
         }
 
         public virtual void testCreateJobApplication() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
 
                 Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().createJobApplication(new Map<String, Object>{'recordId' => job.Id});
                 System.assert(returnMap.get('jobApplication') != null);
             }
 
         }
 
         public virtual void testSubmitJobApplication() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
 
             System.runAs(communityUser) {
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
 
                 Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().createJobApplication(new Map<String, Object>{'recordId' => job.Id});
                 ucinn_portal_Job_Application__c jobApplication = (ucinn_portal_Job_Application__c) returnMap.get('jobApplication');
                 Map<String, Object> params = new Map<String, Object>{'jobApplication' => jobApplication};
                 new PORTAL_JobBoardControllerBase().submitJobApplication(params);
                 List<ucinn_portal_Job_Application__c> jobApplicationList = [SELECT Id FROM ucinn_portal_Job_Application__c WHERE Status__c  = 'Submitted'];
                 System.assert(!jobApplicationList.isEmpty());
             }
 
         }
 
         public virtual void testGetJobApplicationFileUploads() {
 
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
 
             ucinn_portal_Job_Application__c jobApplication = new ucinn_portal_Job_Application__c();
             jobApplication.Name = 'Test';
             jobApplication.Job__c = job.Id;
             jobApplication.Status__c = 'Submitted';
             jobApplication = (ucinn_portal_Job_Application__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jobApplication});
             insert jobApplication;
 
             ContentVersion cv = new ContentVersion(Title = 'Test',
                                             PathOnClient = 'Test.pdf',
                                             VersionData = blob.valueOf('Test CV data'),
                                             IsMajorVersion = true);
             cv = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv});
             insert cv;
 
             ContentDocumentLink contentLink = new ContentDocumentLink();
             contentLink.LinkedEntityId = jobApplication.Id;
             contentLink.ShareType = 'V';
             contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv.Id].ContentDocumentId;
             contentLink = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink});
             insert contentLink;
 
             List<String> fileUploadList = new PORTAL_JobBoardControllerBase().getJobApplicationFileUploads(new Map<String, Object> {'jobApplicationId' => jobApplication.Id});
             Boolean result = fileUploadList.contains(String.valueOf(contentLink.ContentDocumentId));
             System.assertEquals(true, result);
 
         }
 
         public virtual void testGetMyApplications() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
 
                 Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().createJobApplication(new Map<String, Object>{'recordId' => job.Id});
                 ucinn_portal_Job_Application__c jobApplication = (ucinn_portal_Job_Application__c) returnMap.get('jobApplication');
                 Map<String, Object> params = new Map<String, Object>{'jobApplication' => jobApplication};
                 new PORTAL_JobBoardControllerBase().submitJobApplication(params);
                 Map<String, Object> applicationsMap = new PORTAL_JobBoardControllerBase().getMyApplications(new Map<String, Object>{'openOffset' => 0, 'closedOffset' => 0});
                 System.assert(applicationsMap.containsKey('records'));
                 Map<String, Map<String, Map<String, Map<String, Object>>>> recordsMap = (Map<String, Map<String, Map<String, Map<String, Object>>>>)  applicationsMap.get('records');
                 System.assert(recordsMap.containsKey('Open_Applications'));
                 System.assert(recordsMap.get('Open_Applications').containsKey('records'));
                 System.assert(!recordsMap.get('Open_Applications').get('records').isEmpty());
             }
 
         }
 
         public virtual void testGetApplicants() {
 
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
                 ucinn_portal_Job_Application__c jobApplication = new ucinn_portal_Job_Application__c();
                 jobApplication.Name = 'Test';
                 jobApplication.Job__c = job.Id;
                 jobApplication.Status__c = 'Submitted';
                 jobApplication = (ucinn_portal_Job_Application__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jobApplication});
                 insert jobApplication;
 
                 ContentVersion cv = new ContentVersion(Title = 'Test',
                                                 PathOnClient = 'Test.jpg',
                                                 VersionData = blob.valueOf('Test CV data'),
                                                 IsMajorVersion = true);
                 cv = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv});
                 insert cv;
 
                 ContentDocumentLink contentLink = new ContentDocumentLink();
                 contentLink.LinkedEntityId = jobApplication.Id;
                 contentLink.ShareType = 'V';
                 contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv.Id].ContentDocumentId;
                 contentLink = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink});
                 insert contentLink;
 
                 Map<String, Object> applicationsMap = new PORTAL_JobBoardControllerBase().getJobApplicants(new Map<String, Object>{'offset' => 0, 'recordId' => job.Id});
                 System.assert(applicationsMap.containsKey('records'));
                 Map<String, Map<String, Map<String, Map<String, Object>>>> recordsMap = (Map<String, Map<String, Map<String, Map<String, Object>>>>)  applicationsMap.get('records');
                 System.assert(recordsMap.containsKey('Open_Applications'));
                 System.assert(recordsMap.get('Open_Applications').containsKey('records'));
                 System.assert(!recordsMap.get('Open_Applications').get('records').isEmpty());
 
         }
 
         public virtual void testWithdrawApplication() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
 
                 Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().createJobApplication(new Map<String, Object>{'recordId' => job.Id});
                 ucinn_portal_Job_Application__c jobApplication = (ucinn_portal_Job_Application__c) returnMap.get('jobApplication');
                 Map<String, Object> params = new Map<String, Object>{'jobApplication' => jobApplication};
                 new PORTAL_JobBoardControllerBase().submitJobApplication(params);
                 new PORTAL_JobBoardControllerBase().withdrawApplication(new Map<String, Object>{ 'recordId' => jobApplication.Id});
                 List<ucinn_portal_Job_Application__c> jobApplicationList = [SELECT Id FROM ucinn_portal_Job_Application__c WHERE Id = :jobApplication.Id AND Status__c = 'Withdrawn'];
                 System.assert(!jobApplicationList.isEmpty());
             }
 
         }
 
         public virtual void testWithdrawApplicationWithWrongOwner() {
 
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
 
             ucinn_portal_Job_Application__c application = new ucinn_portal_Job_Application__c();
             application.Job__c = job.Id;
             application.Status__c = 'Submitted';
             application = (ucinn_portal_Job_Application__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => application});
             insert application;
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
 
                 List<ucinn_portal_Job_Application__c> applicationList = [SELECT Id FROM ucinn_portal_Job_Application__c];
                 try {
                     new PORTAL_JobBoardControllerBase().withdrawApplication(new Map<String, Object>{ 'recordId' => applicationList.get(0).Id});
                 } catch (Exception e) {
 
                 }
             }
 
         }
 
         public virtual void testChangeApplicationStatus() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
 
                 Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().createJobApplication(new Map<String, Object>{'recordId' => job.Id});
                 ucinn_portal_Job_Application__c jobApplication = (ucinn_portal_Job_Application__c) returnMap.get('jobApplication');
                 Map<String, Object> params = new Map<String, Object>{'jobApplication' => jobApplication};
                 new PORTAL_JobBoardControllerBase().submitJobApplication(params);
                 new PORTAL_JobBoardControllerBase().changeApplicationStatus(new Map<String, Object>{ 'recordId' => jobApplication.Id, 'status' => 'Not Selected'});
                 List<ucinn_portal_Job_Application__c> jobApplicationList = [SELECT Id FROM ucinn_portal_Job_Application__c WHERE Id = :jobApplication.Id AND Status__c = 'Not Selected'];
                 System.assert(!jobApplicationList.isEmpty());
             }
 
         }
 
         public virtual void testGetSearchFilterPicklists() {
             new PORTAL_JobBoardControllerBase().getSearchFilterPicklists(new Map<String, Object>());
         }
 
         public virtual void testSearchForJobWithFilters() {
             Map<String, Object> filterMap = new Map<String, Object>();
             filterMap.put('city', 'Irvine');
             filterMap.put('state', 'CA');
             filterMap.put('postalCode', '92606');
             filterMap.put('radius', 0);
             filterMap.put('lowerBoundSalary', '65000');
             filterMap.put('upperBoundSalary', '75000');
             filterMap.put('includeNulls', true);
             filterMap.put('isRemote', false);
             filterMap.put('multipleLocations', false);
             filterMap.put('classDegreeLevel', '');
             filterMap.put('posititonType', '');
 
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job.City__c = 'Irvine';
             job.Postal_Code__c = '92606';
             job.State__c = 'CA';
             job.Approximate_Salary__c = 70000;
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
 
             new PORTAL_JobBoardControllerBase().searchForJobWithFilters(new Map<String, Object>{'filterMap' => filterMap});
 
         }
 
         public virtual void testSearchForJobWithFilterWithKeyword() {
             Map<String, Object> filterMap = new Map<String, Object>();
             filterMap.put('city', 'Irvine');
             filterMap.put('state', 'CA');
             filterMap.put('postalCode', '92606');
             filterMap.put('radius', 0);
             filterMap.put('lowerBoundSalary', '65000');
             filterMap.put('upperBoundSalary', '75000');
             filterMap.put('includeNulls', true);
             filterMap.put('isRemote', false);
             filterMap.put('multipleLocations', false);
             filterMap.put('classDegreeLevel', '');
             filterMap.put('posititonType', '');
             filterMap.put('keyword', 'Test');
 
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job.City__c = 'Irvine';
             job.Postal_Code__c = '92606';
             job.State__c = 'CA';
             job.Approximate_Salary__c = 70000;
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
 
             new PORTAL_JobBoardControllerBase().searchForJobWithFilters(new Map<String, Object>{'filterMap' => filterMap});
 
         }
 
         public virtual void testSearchForJobFailed() {
 
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job.Approximate_Salary__c = 70000;
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
 
             new PORTAL_JobBoardControllerBase().searchForJobWithFilters(new Map<String, Object>());
 
         }
 
         public virtual void testSubmitJobPosting() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com',
                                         ucinn_ascendv2__Contact_Type__c = 'Alumni');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                Map<Object, Object> jobPosting = new Map<Object, Object>();
                jobPosting.put('Name', 'Software Developer');
                jobPosting.put('Recruiting_Company__c', 'UC Innovation');
                jobPosting.put('Can_Work_Remote__c', true);
                jobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
                jobPosting.put('Address_Line_2__c', '');
                jobPosting.put('Address_Line_3__c', '');
                jobPosting.put('Approximate_Salary__c', 70000);
                jobPosting.put('City__c', 'Irvine');
                jobPosting.put('Class_Or_Degree_Level__c', 'Masters');
                jobPosting.put('Country__c', 'US');
                jobPosting.put('Description__c', 'Test');
                jobPosting.put('Desired_Majors__c', 'Test');
                jobPosting.put('Desired_Skills__c', 'Test');
                jobPosting.put('Expiration_Date__c', Date.today());
                jobPosting.put('External_Job_Application_Link__c', '');
                jobPosting.put('Has_Contact_Information__c', false);
                jobPosting.put('Has_Multiple_Locations__c', true);
                jobPosting.put('Is_Cover_Letter_Required__c', true);
                jobPosting.put('Is_External_Site__c', false);
                jobPosting.put('Is_Unofficial_Transcript_Required__c', true);
                jobPosting.put('Is_Work_Authorization_Required__c', true);
                jobPosting.put('Job_Poster_Company__c', '');
                jobPosting.put('Job_Poster_Email__c', '');
                jobPosting.put('Job_Poster_Job_Title__c', '');
                jobPosting.put('Job_Poster_Name__c', '');
                jobPosting.put('Job_Poster_Phone__c', '');
                jobPosting.put('Job_Poster_School_Degree__c', '');
                jobPosting.put('Postal_Code__c', '92606');
                jobPosting.put('Position_Type__c', 'Full Time Entry Level');
                jobPosting.put('Qualifications__c', 'Test');
                jobPosting.put('State__c', 'CA');
                jobPosting.put('Work_Hours_Per_Week__c', 40);
 
                Set<String> fields = new Set<String>();
                for (Object field : jobPosting.keySet()) {
                    fields.add(String.valueOf(field));
                }
 
                new PORTAL_JobBoardControllerBase().submitJobPosting(new Map<String, Object>{'jobRecord' => jobPosting});
 
                String queryString = 'SELECT Id,' + String.join(new List<String>(fields), ',') + ' FROM ucinn_portal_Job__c';
                List<ucinn_portal_Job__c> jobList = Database.query(queryString);
                System.assert(!jobList.isEmpty());
                ucinn_portal_Job__c job = jobList.get(0);
                for (String field : fields) {
                    if (job.get(field) == null) {
                        System.assert(String.isBlank(String.valueOf(jobPosting.get(field))));
                    } else {
                        System.assert(jobPosting.get(field) == job.get(field));
                    }
                }
 
             }
 
         }
 
         public virtual void testSubmitJobPostingAsHiringManager() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         ucinn_ascendv2__Contact_Type__c = 'Alumni;Friend',
                                         Email = 'testCommunityUsermig123@test.com',
                                         ucinn_portal_Is_Hiring_Manager__c = true);
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
                                      username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                Map<Object, Object> jobPosting = new Map<Object, Object>();
                jobPosting.put('Name', 'Software Developer');
                jobPosting.put('Recruiting_Company__c', 'UC Innovation');
                jobPosting.put('Can_Work_Remote__c', true);
                jobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
                jobPosting.put('Address_Line_2__c', '');
                jobPosting.put('Address_Line_3__c', '');
                jobPosting.put('Approximate_Salary__c', 70000);
                jobPosting.put('City__c', 'Irvine');
                jobPosting.put('Class_Or_Degree_Level__c', 'Masters');
                jobPosting.put('Country__c', 'US');
                jobPosting.put('Description__c', 'Test');
                jobPosting.put('Desired_Majors__c', 'Test');
                jobPosting.put('Desired_Skills__c', 'Test');
                jobPosting.put('Expiration_Date__c', Date.today());
                jobPosting.put('External_Job_Application_Link__c', '');
                jobPosting.put('Has_Contact_Information__c', false);
                jobPosting.put('Has_Multiple_Locations__c', true);
                jobPosting.put('Is_Cover_Letter_Required__c', true);
                jobPosting.put('Is_External_Site__c', false);
                jobPosting.put('Is_Unofficial_Transcript_Required__c', true);
                jobPosting.put('Is_Work_Authorization_Required__c', true);
                jobPosting.put('Job_Poster_Company__c', '');
                jobPosting.put('Job_Poster_Email__c', '');
                jobPosting.put('Job_Poster_Job_Title__c', '');
                jobPosting.put('Job_Poster_Name__c', '');
                jobPosting.put('Job_Poster_Phone__c', '');
                jobPosting.put('Job_Poster_School_Degree__c', '');
                jobPosting.put('Postal_Code__c', '92606');
                jobPosting.put('Position_Type__c', 'Full Time Entry Level');
                jobPosting.put('Qualifications__c', 'Test');
                jobPosting.put('State__c', 'CA');
                jobPosting.put('Work_Hours_Per_Week__c', 40);
 
                Set<String> fields = new Set<String>();
                for (Object field : jobPosting.keySet()) {
                    fields.add(String.valueOf(field));
                }
 
                new PORTAL_JobBoardControllerBase().submitJobPosting(new Map<String, Object>{'jobRecord' => jobPosting});
 
                String queryString = 'SELECT Id,' + String.join(new List<String>(fields), ',') + ' FROM ucinn_portal_Job__c';
                List<ucinn_portal_Job__c> jobList = Database.query(queryString);
                System.assert(!jobList.isEmpty());
                ucinn_portal_Job__c job = jobList.get(0);
                for (String field : fields) {
                    if (job.get(field) == null) {
                        System.assert(String.isBlank(String.valueOf(jobPosting.get(field))));
                    } else {
                        System.assert(jobPosting.get(field) == job.get(field));
                    }
                }
 
             }
 
         }
 
         public virtual void testSubmitJobPostingResubmit() {
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com',
                                         ucinn_ascendv2__Contact_Type__c = 'Alumni');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                Map<Object, Object> jobPosting = new Map<Object, Object>();
                jobPosting.put('Name', 'Software Developer');
                jobPosting.put('Recruiting_Company__c', 'UC Innovation');
                jobPosting.put('Can_Work_Remote__c', true);
                jobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
                jobPosting.put('Address_Line_2__c', '');
                jobPosting.put('Address_Line_3__c', '');
                jobPosting.put('Approximate_Salary__c', 70000);
                jobPosting.put('City__c', 'Irvine');
                jobPosting.put('Class_Or_Degree_Level__c', 'Masters');
                jobPosting.put('Country__c', 'US');
                jobPosting.put('Description__c', 'Test');
                jobPosting.put('Desired_Majors__c', 'Test');
                jobPosting.put('Desired_Skills__c', 'Test');
                jobPosting.put('Expiration_Date__c', Date.today());
                jobPosting.put('External_Job_Application_Link__c', '');
                jobPosting.put('Has_Contact_Information__c', false);
                jobPosting.put('Has_Multiple_Locations__c', true);
                jobPosting.put('Is_Cover_Letter_Required__c', true);
                jobPosting.put('Is_External_Site__c', false);
                jobPosting.put('Is_Unofficial_Transcript_Required__c', true);
                jobPosting.put('Is_Work_Authorization_Required__c', true);
                jobPosting.put('Job_Poster_Company__c', '');
                jobPosting.put('Job_Poster_Email__c', '');
                jobPosting.put('Job_Poster_Job_Title__c', '');
                jobPosting.put('Job_Poster_Name__c', '');
                jobPosting.put('Job_Poster_Phone__c', '');
                jobPosting.put('Job_Poster_School_Degree__c', '');
                jobPosting.put('Postal_Code__c', '92606');
                jobPosting.put('Position_Type__c', 'Full Time Entry Level');
                jobPosting.put('Qualifications__c', 'Test');
                jobPosting.put('State__c', 'CA');
                jobPosting.put('Work_Hours_Per_Week__c', 40);
 
                Set<String> fields = new Set<String>();
                for (Object field : jobPosting.keySet()) {
                    fields.add(String.valueOf(field));
                }
 
                new PORTAL_JobBoardControllerBase().submitJobPosting(new Map<String, Object>{'jobRecord' => jobPosting});
 
                String queryString = 'SELECT Id,' + String.join(new List<String>(fields), ',') + ' FROM ucinn_portal_Job__c';
                List<ucinn_portal_Job__c> jobList = Database.query(queryString);
                System.assert(!jobList.isEmpty());
 
                Map<Object, Object> updatedJobPosting = new Map<Object, Object>();
                ucinn_portal_Job__c job = jobList.get(0);
 
                for (String field : fields) {
                    updatedJobPosting.put(field, job.get(field));
                }
 
                job.Status__c = 'Pending';
                update job;
 
                updatedJobPosting.put('Id', job.Id);
                updatedJobPosting.put('Desired_Majors__c', 'New Test');
                new PORTAL_JobBoardControllerBase().submitJobPosting(new Map<String, Object>{'jobRecord' => updatedJobPosting});
 
                List<ucinn_portal_Job__c> updatedJobList = Database.query(queryString);
 
                ucinn_portal_Job__c updatedJob = updatedJobList.get(0);
                System.assert(updatedJob.Desired_Majors__c == 'New Test');
 
             }
 
         }
 
         public virtual void testSubmitJobPostingWithDraft() {
             List<Portal_Organization_Setting__mdt> orgSettingsList = [SELECT Id, Value__c, DeveloperName FROM Portal_Organization_Setting__mdt WHERE DeveloperName = 'Create_Draft_For_Alumni_Job_Posting'];
             if (orgSettingsList.get(0).Value__c.toLowerCase() != 'true') {
                 return;
             }
 
 
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
 
 
 
             Contact con = new Contact(LastName = 'Test_Contact',
                                         AccountId = acct.Id,
                                         ucinn_portal_Is_Display_On_Portal__c = true,
                                         Email = 'testCommunityUsermig123@test.com',
                                         ucinn_ascendv2__Contact_Type__c = 'Alumni');
             con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
             insert con;
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
             communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
             insert communityUser;
 
             System.runAs(communityUser) {
                Map<Object, Object> jobPosting = new Map<Object, Object>();
                jobPosting.put('Name', 'Software Developer');
                jobPosting.put('Recruiting_Company__c', 'UC Innovation');
                jobPosting.put('Can_Work_Remote__c', true);
                jobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
                jobPosting.put('Address_Line_2__c', '');
                jobPosting.put('Address_Line_3__c', '');
                jobPosting.put('Approximate_Salary__c', 70000);
                jobPosting.put('City__c', 'Irvine');
                jobPosting.put('Class_Or_Degree_Level__c', 'Masters');
                jobPosting.put('Country__c', 'US');
                jobPosting.put('Description__c', 'Test');
                jobPosting.put('Desired_Majors__c', 'Test');
                jobPosting.put('Desired_Skills__c', 'Test');
                jobPosting.put('Expiration_Date__c', Date.today());
                jobPosting.put('External_Job_Application_Link__c', '');
                jobPosting.put('Has_Contact_Information__c', false);
                jobPosting.put('Has_Multiple_Locations__c', true);
                jobPosting.put('Is_Cover_Letter_Required__c', true);
                jobPosting.put('Is_External_Site__c', false);
                jobPosting.put('Is_Unofficial_Transcript_Required__c', true);
                jobPosting.put('Is_Work_Authorization_Required__c', true);
                jobPosting.put('Job_Poster_Company__c', '');
                jobPosting.put('Job_Poster_Email__c', '');
                jobPosting.put('Job_Poster_Job_Title__c', '');
                jobPosting.put('Job_Poster_Name__c', '');
                jobPosting.put('Job_Poster_Phone__c', '');
                jobPosting.put('Job_Poster_School_Degree__c', '');
                jobPosting.put('Postal_Code__c', '92606');
                jobPosting.put('Position_Type__c', 'Full Time Entry Level');
                jobPosting.put('Qualifications__c', 'Test');
                jobPosting.put('State__c', 'CA');
                jobPosting.put('Work_Hours_Per_Week__c', 40);
 
                Set<String> fields = new Set<String>();
                for (Object field : jobPosting.keySet()) {
                    fields.add(String.valueOf(field));
                }
 
                new PORTAL_JobBoardControllerBase().submitJobPosting(new Map<String, Object>{'jobRecord' => jobPosting});
 
                String queryString = 'SELECT Id,' + String.join(new List<String>(fields), ',') + ' FROM ucinn_portal_Job__c';
                List<ucinn_portal_Job__c> jobList = Database.query(queryString);
                System.assert(!jobList.isEmpty());
                Map<Object, Object> updatedJobPosting = new Map<Object, Object>();
                ucinn_portal_Job__c job = jobList.get(0);
                for (String field : fields) {
                    updatedJobPosting.put(field, job.get(field));
                }
                job.Status__c = 'Posted';
                update job;
 
                updatedJobPosting.put('Id', job.Id);
                updatedJobPosting.put('Desired_Majors__c', 'New Test');
 
                new PORTAL_JobBoardControllerBase().submitJobPosting(new Map<String, Object>{'jobRecord' => updatedJobPosting});
                List<ucinn_portal_Job__c> updatedJobList = [SELECT Desired_Majors__c
                                                            FROM ucinn_portal_Job__c
                                                            WHERE Status__c = 'Draft'
                                                            AND Master_Job__c = :job.Id];
                System.assert(!updatedJobList.isEmpty());
                System.assert(updatedJobList.get(0).Desired_Majors__c == 'New Test');
 
             }
 
         }
 
         public virtual void testPublishDraft() {
             // Test publishing a 'Draft' job
             ucinn_portal_Job__c jobPosting = new ucinn_portal_Job__c();
             jobPosting.put('Name', 'Software Developer');
             jobPosting.put('Recruiting_Company__c', 'UC Innovation');
             jobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
             jobPosting.put('City__c', 'Irvine');
             jobPosting.put('State__c', 'CA');
             jobPosting.put('Postal_Code__c', '92606');
             jobPosting.put('Country__c', 'US');
             jobPosting.put('Can_Work_Remote__c', true);
             jobPosting.put('Is_Cover_Letter_Required__c', true);
             jobPosting.put('Is_Unofficial_Transcript_Required__c', true);
             jobPosting.put('Is_Work_Authorization_Required__c', true);
             jobPosting.put('Position_Type__c', 'Full Time Entry Level');
             jobPosting.put('Class_Or_Degree_Level__c', 'Masters');
             jobPosting.put('Approximate_Salary__c', 70000);
             jobPosting.put('Work_Hours_Per_Week__c', 40);
             jobPosting.put('Status__c', 'Pending Edit');
             jobPosting = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jobPosting});
 
             insert jobPosting;
 
             ucinn_portal_Job__c draftJobPosting = new ucinn_portal_Job__c();
             draftJobPosting.put('Name', 'Salesforce Developer');
             draftJobPosting.put('Recruiting_Company__c', 'UC Innovation');
             draftJobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
             draftJobPosting.put('City__c', 'Irvine');
             draftJobPosting.put('State__c', 'CA');
             draftJobPosting.put('Postal_Code__c', '92606');
             draftJobPosting.put('Country__c', 'US');
             draftJobPosting.put('Can_Work_Remote__c', true);
             draftJobPosting.put('Is_Cover_Letter_Required__c', true);
             draftJobPosting.put('Is_Unofficial_Transcript_Required__c', true);
             draftJobPosting.put('Is_Work_Authorization_Required__c', true);
             draftJobPosting.put('Position_Type__c', 'Full Time Entry Level');
             draftJobPosting.put('Class_Or_Degree_Level__c', 'Masters');
             draftJobPosting.put('Approximate_Salary__c', 70000);
             draftJobPosting.put('Work_Hours_Per_Week__c', 40);
             draftJobPosting.put('Status__c', 'Draft');
             draftJobPosting.put('Master_Job__c', jobPosting.Id);
             draftJobPosting = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => draftJobPosting});
 
             insert draftJobPosting;
 
             new PORTAL_JobBoardControllerBase().publishDraft(new Map<String, Object>{'recordId' => draftJobPosting.Id});
 
             List<ucinn_portal_Job__c> jobList = [SELECT Name, Status__c
                                                  FROM ucinn_portal_Job__c
                                                  WHERE Id = :jobPosting.Id];
             System.assert(jobList.isEmpty() == false);
 
             ucinn_portal_Job__c job = jobList.get(0);
             System.assert(job.Name == 'Salesforce Developer');
             System.assert(job.Status__c == 'Posted');
 
             List<ucinn_portal_Job__c> draftJobList = [SELECT Status__c
                                                       FROM ucinn_portal_Job__c
                                                       WHERE Id = :draftJobPosting.Id];
             System.assert(draftJobList.isEmpty() == true);
 
             // Test publishing a 'Pending' job
             setUpContact();
             Case case1 = new Case(
                 Type = 'Job Posting',
                 ContactId = contactRecord.Id,
                 Origin='Web',
                 Status = 'New',
                 Subject = 'A new job posting has been submitted for approval.'
             );
 
             insert case1;
 
             ucinn_portal_Job__c newJobPosting = new ucinn_portal_Job__c();
             newJobPosting.put('Name', 'Software Engineer in Test');
             newJobPosting.put('Recruiting_Company__c', 'UC Innovation');
             newJobPosting.put('Address_Line_1__c', '2855 Michelle Drive');
             newJobPosting.put('City__c', 'Irvine');
             newJobPosting.put('State__c', 'CA');
             newJobPosting.put('Postal_Code__c', '92606');
             newJobPosting.put('Country__c', 'US');
             newJobPosting.put('Can_Work_Remote__c', true);
             newJobPosting.put('Is_Cover_Letter_Required__c', true);
             newJobPosting.put('Is_Unofficial_Transcript_Required__c', true);
             newJobPosting.put('Is_Work_Authorization_Required__c', true);
             newJobPosting.put('Position_Type__c', 'Full Time Entry Level');
             newJobPosting.put('Class_Or_Degree_Level__c', 'Masters');
             newJobPosting.put('Approximate_Salary__c', 70000);
             newJobPosting.put('Work_Hours_Per_Week__c', 40);
             newJobPosting.put('Status__c', 'Pending');
             newJobPosting.put('Case__c', case1.Id);
             newJobPosting = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newJobPosting});
 
             insert newJobPosting;
 
             new PORTAL_JobBoardControllerBase().publishDraft(new Map<String, Object>{'recordId' => newJobPosting.Id});
 
             List<ucinn_portal_Job__c> newJobList = [SELECT Status__c, Case__r.Status
                                                     FROM ucinn_portal_Job__c
                                                     WHERE Id = :newJobPosting.Id];
             System.assert(newJobList.isEmpty() == false);
 
             ucinn_portal_Job__c newJob = newJobList.get(0);
             System.assert(newJob.Status__c == 'Posted');
             System.assert(newJob.Case__r.Status == 'Approved');
         }
 
         public virtual void testGetCreateJobPostingFrontEndData() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
 
             ucinn_portal_Content_Page__c testPage = new ucinn_portal_Content_Page__c(Name = 'Test Page');
             insert testPage;
 
             ucinn_portal_Content_Module__c testModule = new ucinn_portal_Content_Module__c(Name = 'Test Module',
                                                                                         content_module_metadata__c = '{"htmlText":""}',
                                                                                         content_page__c = testPage.Id);
             insert testModule;
 
             Test.startTest();
 
             controller.getCreateJobPostingFrontEndData(new Map<String, Object>{'contentModuleName' => 'Test Module',
                                                                             'contentPageName' => 'Test Page'});
 
             Test.stopTest();
         }
 
         public virtual void testGetJobListingDifferentUser() {
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
                 Username = 'demo@ucinnovation.com.portal',
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
 
             System.runAs(portalAccountOwner) {
                 ucinn_portal_Job__c job = new ucinn_portal_Job__c();
                 job.Status__c = 'Posted';
                 job.Name = 'Test Job';
                 job.View_Count__c = 1;
                 job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
                 insert job;
 
                 System.runAs(dupUser) {
                     Map<String, Object> params = new Map<String, Object>{'recordId' => job.Id};
                     Map<String, Object> returnMap = new PORTAL_JobBoardControllerBase().getJobListing(params);
                     System.assert(!returnMap.isEmpty());
                     System.assert(returnMap.get('records') != null);
                     Map<String, Map<String, List<Map<String, Object>>>> recordsMap = (Map<String, Map<String, List<Map<String, Object>>>>)  returnMap.get('records');
                     System.assert(recordsMap.containsKey('Job'));
                     System.assert(recordsMap.get('Job').containsKey('records'));
                     System.assert(!recordsMap.get('Job').get('records').isEmpty());
                 }
             }            
 
             Test.stopTest();
         }
 
         public virtual void testArchiveJobMissMatchId() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
             Id missMatchId = UserInfo.getUserId();
 
             Test.startTest();
 
             controller.archiveJob(new Map<String, Object>{PORTAL_JobBoardControllerBase.RECORD_ID_KEY => missMatchId});
 
             Test.stopTest();
         }
 
         public virtual void testGetJobListingMissMatchId() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
             Id missMatchId = UserInfo.getUserId();
 
             Test.startTest();
             try {
                 controller.getJobListing(new Map<String, Object>{PORTAL_JobBoardControllerBase.RECORD_ID_KEY => missMatchId});
             } catch (Exception e) {
                 System.assert(String.isNotBlank(e.getMessage()));
             }
 
             Test.stopTest();
         }
 
         public virtual void testCreateJobApplicationBlankId() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
 
             Test.startTest();
 
             controller.createJobApplication(new Map<String, Object>{PORTAL_JobBoardControllerBase.RECORD_ID_KEY => null});
 
             Test.stopTest();
         }
 
         public virtual void testSubmitDuplicateJobApplication() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
 
             ucinn_portal_Job__c job = new ucinn_portal_Job__c();
             job.Status__c = 'Posted';
             job.Name = 'Test Job';
             job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
             insert job;
 
             ucinn_portal_Job_Application__c  existingApplication = new ucinn_portal_Job_Application__c();
             existingApplication.Status__c = PORTAL_JobBoardControllerBase.SUBMITTED_STATUS;
             existingApplication.Job__c = job.Id;
             insert existingApplication;
 
             Test.startTest();
             try {
                 controller.submitJobApplication(new Map<String, Object>{PORTAL_JobBoardControllerBase.JOB_APPLICATION_KEY => existingApplication});
             } catch (Exception e) {
                 System.assert(String.isNotBlank(e.getMessage()));
             }
 
             Test.stopTest();
         }
 
         public virtual void testGetJobApplicantsMissMatchId() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
             Id missMatchId = UserInfo.getUserId();
 
             Test.startTest();
 
             Map<String, Object> result = controller.getJobApplicants(new Map<String, Object>{PORTAL_JobBoardControllerBase.RECORD_ID_KEY => missMatchId});
             System.assert(result.isEmpty());
 
             Test.stopTest();
         }
 
         public virtual void testChangeApplicationStatusMissMatchId() {
             PORTAL_JobBoardControllerBase controller = new PORTAL_JobBoardControllerBase();
             Id missMatchId = UserInfo.getUserId();
 
             Test.startTest();
 
             controller.changeApplicationStatus(new Map<String, Object>{PORTAL_JobBoardControllerBase.RECORD_ID_KEY => missMatchId,
                                                                     'status' => 'Test status'});
 
             Test.stopTest();
         }
     } 
 
     @isTest
     public static void testGetFrontEndDataMap() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetFrontEndDataMap();
     }
 
     @isTest
     public static void testGetContactInfo() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetContactInfo();
     }
 
     @isTest
     public static void testGetPicklists() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetPicklists();
     }
 
     @isTest
     public static void testArchiveJob() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testArchiveJob();
     }
 
     @isTest
     public static void testGetMyPostedJobs() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetMyPostedJobs();
     }
 
     @isTest
     public static void testGetJobListing() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetJobListing();
     }
 
     @isTest
     public static void testGetJobListingWithBlankId() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetJobListingWithBlankId();
     }
 
     @isTest
     public static void testCreateJobApplication() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testCreateJobApplication();
     }
 
     @isTest
     public static void testSubmitJobApplication() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSubmitJobApplication();
     }
 
     @isTest
     public static void testGetJobApplicationFileUploads() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetJobApplicationFileUploads();
     }
 
     @isTest
     public static void testGetMyApplications() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetMyApplications();
     }
 
     @isTest
     public static void testGetApplicants() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetApplicants();
     }
 
     @isTest
     public static void testWithdrawApplication() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testWithdrawApplication();
     }
 
     @isTest
     public static void testWithdrawApplicationWithWrongOwner() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testWithdrawApplicationWithWrongOwner();
     }
 
     @isTest
     public static void testChangeApplicationStatus() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testChangeApplicationStatus();
     }
 
     @isTest
     public static void testGetSearchFilterPicklists() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetSearchFilterPicklists();
     }
 
     @isTest
     public static void testSearchForJobWithFilters() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSearchForJobWithFilters();
     }
 
     @isTest
     public static void testSearchForJobWithFilterWithKeyword() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSearchForJobWithFilterWithKeyword();
     }
 
     @isTest
     public static void testSearchForJobFailed() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSearchForJobFailed();
     }
 
     @isTest
     public static void testSubmitJobPosting() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSubmitJobPosting();
     }
 
     @isTest
     public static void testSubmitJobPostingAsHiringManager() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSubmitJobPostingAsHiringManager();
     }
 
     @isTest
     public static void testSubmitJobPostingResubmit() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSubmitJobPostingResubmit();
     }
 
     @isTest
     public static void testSubmitJobPostingWithDraft() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSubmitJobPostingWithDraft();
         }
 
     @isTest
     public static void testPublishDraft() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testPublishDraft();
     }
 
     @isTest
     public static void testGetCreateJobPostingFrontEndData() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetCreateJobPostingFrontEndData();
     }
 
     @isTest
     public static void testGetJobListingDifferentUser() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetJobListingDifferentUser();
     }
 
     @isTest
     public static void testArchiveJobMissMatchId() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testArchiveJobMissMatchId();
     }
 
     @isTest
     public static void testGetJobListingMissMatchId() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetJobListingMissMatchId();
     }
 
     @isTest
     public static void testCreateJobApplicationBlankId() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testCreateJobApplicationBlankId();
     }
 
     @isTest
     public static void testSubmitDuplicateJobApplication() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testSubmitDuplicateJobApplication();
     }
 
     @isTest
     public static void testGetJobApplicantsMissMatchId() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testGetJobApplicantsMissMatchId();
     }
 
     @isTest
     public static void testChangeApplicationStatusMissMatchId() {
         PORTAL_TestClassFactory.getTestClassFactory().getJobBoardControllerBaseTestClass().testChangeApplicationStatusMissMatchId();
     }
 }