@isTest
public class PORTAL_SObjectWrapperTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testSObjectWrapper() {
            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                insert con;

                PORTAL_SObjectWrapper newWrapper = PORTAL_SObjectWrapper.newInstance('Contact');
                newWrapper.getSObjectType();
                new PORTAL_SObjectWrapper(newWrapper.getSObjectRecord());
                newWrapper.put('LastName', 'Wong');
                newWrapper.put(null, 'Wong');
                newWrapper.get('LastName');
                newWrapper.get(null);

                List<Contact> contactList = [SELECT id, Account.Name, (SELECT id FROM ucinn_ascendv2__Degree_Information_Contact__r) FROM Contact];

                newWrapper = new PORTAL_SObjectWrapper(contactList.get(0));
                newWrapper.get('Account.Name');
                newWrapper.getSObjects('ucinn_ascendv2__Degree_Information_Contact__r');
            }
        }
    }
    static testMethod void testSObjectWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getSObjectWrapperTestClass().testSObjectWrapper();
    }
}