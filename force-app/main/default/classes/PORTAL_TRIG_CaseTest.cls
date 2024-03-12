@isTest
global without sharing class PORTAL_TRIG_CaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact contact;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            System.runAs(thisUser) {
                Account acct = new Account(name = 'test account') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                contact = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');
                contact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contact});
                insert contact;
            }
        }

        public virtual Case createCase(String caseType, String caseStatus) {
            Case case1 = new case(
                Type = caseType,
                ContactId = contact.Id,
                Origin='Web',
                Status = caseStatus,
                Subject = 'This is my subject'
            );

            return case1;
        }


        public virtual void testZoneMembershipCases() {
            setupData();
            List<case> cases = new List<Case>();

            Case case1 = createCase('Zone Membership', 'New');
            Case case2 = createCase('Zone Membership', 'New');
            case1 = (Case)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => case1});
            case2 = (Case)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => case2});

            ucinn_portal_Zone__c testZone = new ucinn_portal_Zone__c (
                Name = 'Alumni Club of Irvine',
                Is_Display_on_Portal__c = true
            );
            testZone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZone});
            insert testZone;

            ucinn_portal_Zone__c testZone2 = new ucinn_portal_Zone__c (
                Name = 'Alumni Club of Irvine2',
                Is_Display_on_Portal__c = true
            );
            testZone2 = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZone2});
            insert testZone2;

            cases.add(case1);
            cases.add(case2);
            insert cases;

            ucinn_portal_Zone_Membership__c testZoneMembership1 = new ucinn_portal_Zone_Membership__c(
                Case__c = case1.Id,
                Status__c = 'Pending',
                Constituent__c = contact.Id,
                Zone__c = testZone.Id
            );
            testZoneMembership1 = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZoneMembership1});
            insert testZoneMembership1;

            ucinn_portal_Zone_Membership__c testZoneMembership2 = new ucinn_portal_Zone_Membership__c(
                Case__c = case2.Id,
                Status__c = 'Pending',
                Constituent__c = contact.Id,
                Zone__c = testZone2.Id
            );
            testZoneMembership2 = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZoneMembership2});
            insert testZoneMembership2;

            List<case> newCases = new List<case>();
            newCases.add(case1.clone(true, false, true, false));
            newCases.add(case2.clone(true, false, true, false));
            newCases[0].Status = 'Approved';
            newCases[1].Status = 'Denied';
            update newCases;

        }
    }


    @isTest
    static void testZoneMembershipCases() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_CaseTestClass().testZoneMembershipCases();
    }
}