@isTest
public class PORTAL_BATCH_MLRecommendationCalcTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testBatch() {
            PORTAL_BATCH_MLRecommendationCalculator calculator = new PORTAL_BATCH_MLRecommendationCalculator();
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            List<sObject> params = new List<sObject>();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            User newUser = new User(alias = 'testUser',
                                    email = 'testCommunityUsermig123@test.com',
                                    emailencodingkey='UTF-8',
                                    lastname = 'Batman',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = profileId,
                                    contactId = con.Id,
                                    IsActive = true,
                                    timezonesidkey='America/Los_Angeles',
                                    username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
            newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
            insert newUser;
            params.add(newUser);
            
            Test.startTest();

            try {
                calculator.start(null);
                calculator.execute(null, params);
                calculator.finish(null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    static testMethod void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getBatchMLRecommendationCalcTestClass().testBatch();
    }
}