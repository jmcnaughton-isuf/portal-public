@isTest
public without sharing class PORTAL_BATCH_EmailApiContactsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testBatch() {
            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact cont = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                Set<Id> contactIds = new Set<Id>();
                contactIds.add(cont.Id);

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_EmailApiContacts(contactIds));
                Test.stopTest();
            }
        }
    }

    @IsTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getEmailApiContactsTestClass().testBatch();
    }
}