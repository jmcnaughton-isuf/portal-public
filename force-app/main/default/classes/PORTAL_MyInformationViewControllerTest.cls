@isTest
public with sharing class PORTAL_MyInformationViewControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
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
                                    username = 'testCommunityUsermig123@test.com');

            communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
            insert communityUser;

            ucinn_ascendv2__Email__c email = new ucinn_ascendv2__Email__c();
            email.ucinn_ascendv2__Contact__c = con.Id;
            email.ucinn_ascendv2__Email_Address__c = 'blahblah@test.com';
            email.ucinn_ascendv2__Status__c = 'Current';
            email.ucinn_portal_Is_Display_On_Portal__c = true;
            email = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email});
            insert email;
            
            ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
            interim.ucinn_ascendv2__Contact__c = con.Id;
            interim = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interim});
            insert interim;

            ucinn_ascendv2__Email__c changedEmail = new ucinn_ascendv2__Email__c();
            changedEmail.ucinn_ascendv2__Contact__c = con.Id;
            changedEmail.ucinn_ascendv2__Email_Address__c = 'haha@test.com';
            changedEmail.ucinn_ascendv2__Status__c = 'Current';
            changedEmail.ucinn_portal_Is_Display_On_Portal__c = true;
            changedEmail.ucinn_portal_Original_Record__c = email.Id;
            changedEmail.ucinn_portal_Interim__c = interim.Id;
            changedEmail = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => changedEmail});
            insert changedEmail;
        }

        public virtual void testGetViewInfo() {
            setupData();
    
            PORTAL_MyInformationViewControllerBase controller = new PORTAL_MyInformationViewControllerBase();
            Map<String, Object> params = new Map<String, Object>{'pageName' => 'My Information', 'mainSectionName' => 'Emails'};
            System.runAs(communityUser) {
                controller.getViewInfo(params);
            }
        }
    }
    
    @isTest
    public static void testGetViewInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getMyInformationViewControllerTestClass().testGetViewInfo();
    }
}