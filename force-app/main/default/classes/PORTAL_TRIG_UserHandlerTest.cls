@isTest
public class PORTAL_TRIG_UserHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testRun() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            Account acct = new Account(name = 'Test_Account') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUserf14@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            User comUser = new User(alias = 'testUser',
                                    email = 'testCommunityUserf14@test.com',
                                    emailencodingkey='UTF-8',
                                    lastname = 'Batman',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = profileId,
                                    contactId = con.Id,
                                    IsActive = true,
                                    timezonesidkey='America/Los_Angeles',
                                    username = System.now().millisecond() + 'testCommunityUserf14@test.com');
            comUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => comUser});
            comUser.ucinn_portal_Origin_Site__c = 'Alumni Portal';
            insert comUser;

            List<sObject> oldList = new List<sObject>();
            List<sObject> newList = new List<sObject>{comUser};
	
            Test.startTest();

            new PORTAL_TRIG_UserHandler().run(newList,
                                            oldList,
                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                            User.getSObjectType().getDescribe());


            new PORTAL_TRIG_UserHandler().run(newList,
                                            oldList,
                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                            User.getSObjectType().getDescribe());

            Test.stopTest();
        }
    }


    static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTrigUserHandlerTestClass().testRun();
    }
}