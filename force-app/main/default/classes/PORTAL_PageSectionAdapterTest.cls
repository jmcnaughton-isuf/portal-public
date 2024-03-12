@isTest
public without sharing class PORTAL_PageSectionAdapterTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupUserData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
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
                insert communityUser;
            }
        }

        public virtual void testPageSectionAdapter() {
            setupUserData();

            System.runAs(communityUser) {
                PORTAL_PageSectionAdapter newAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information')
                                                                                              .buildMainSectionName('Volunteer Edit Form')
                                                                                              .buildSubSectionName('Contact Info')
                                                                                              .buildParentFieldId(null)
                                                                                              .buildDynamicQuery(null)
                                                                                              .build();

                new PORTAL_PageSectionAdapter.Builder().build();

                newAdapter.getPageName();
                newAdapter.getMainSectionName();
                newAdapter.getSubSectionName();
                newAdapter.getRecords();
                newAdapter.getFrontEndDataMap();
                newAdapter.getBackEndDataMap();

                newAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information').build();
                newAdapter.getRecords(true, true);
            }
        }
    }

    static testMethod void testPageSectionAdapter() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionAdapterTestClass().testPageSectionAdapter();
    }
}