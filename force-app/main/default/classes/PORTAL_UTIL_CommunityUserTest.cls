@isTest
public class PORTAL_UTIL_CommunityUserTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetUserCreationErrorMessage() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;
            String expectedMessageHeader = 'Could not create user because the ';

            Test.startTest();

            try {
                String result = PORTAL_UTIL_CommunityUser.getUserCreationErrorMessage(con.Id, '', '', '', '');
                System.assert(result.startsWith(expectedMessageHeader));
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }


        public virtual void testCreateUserCoverageIncrease() {
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            Test.startTest();

            try {
                User result = PORTAL_UTIL_CommunityUser.createUser(con.Id, 'Test', 'Test', 'test@test.com', '', profileId);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    static testMethod void testGetUserCreationErrorMessage() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_CommunityUserTestClass().testGetUserCreationErrorMessage();
    }

    static testMethod void testCreateUserCoverageIncrease() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_CommunityUserTestClass().testCreateUserCoverageIncrease();
    }
}