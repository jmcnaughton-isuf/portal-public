@isTest
public  class PORTAL_TRIG_CaseHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact contactRecord;
        public Case caseHonorRoll;
        public string caseDescription = 'Honor Roll Name: \'Test New Name\' \n' +
                                        'Honor Roll Joint Preference: \'Joint\'';
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts() {
            System.runAs(thisUser) {
                Account acct = new Account(name = 'Test Account');
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                contactRecord = new Contact(LastName = 'Test Contact',
                                    AccountId = acct.Id,
                                    ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual',
                                    ucinn_portal_Is_Honor_Roll_Opt_Out__c = false);

                contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
                insert contactRecord;

                Contact jointRecord = new Contact(LastName = 'Test Joint Contact',
                                                AccountId = acct.Id,
                                                ucinn_ascendv2__Preferred_Spouse__c = contactRecord.Id,
                                                ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual',
                                                ucinn_portal_Is_Honor_Roll_Opt_Out__c = false);

                jointRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jointRecord});
                insert jointRecord;

                contactRecord.ucinn_ascendv2__Preferred_Spouse__c = jointRecord.Id;
                update contactRecord;
            }
        }

        public virtual void setUpCase() {
            if (contactRecord == null) {
                setUpContacts();
            }

            caseHonorRoll = new Case(ContactId = contactRecord.Id, Status = 'New', Origin = 'Web',
                                     Description = caseDescription);
            caseHonorRoll = (Case)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => caseHonorRoll});
            insert caseHonorRoll;
        }

        public virtual Case createCaseZone(String caseType, String caseStatus) {
            Case case1 = new case(
                Type = caseType,
                ContactId = contactRecord.Id,
                Origin='Web',
                Status = caseStatus,
                Subject = 'This is my subject'
            );

            return case1;
        }

        public virtual void setUpHonorRollNameRecord(String fiscalYear) {
            if (contactRecord == null) {
                setUpContacts();
            }

            String startingFiscalYear = '2010';

            if (String.isNotBlank(fiscalYear)) {
                startingFiscalYear = fiscalYear;
            }

            ucinn_portal_Honor_Roll_Name__c newHonorRollName = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                                                    Joint_Contact__c = contactRecord.ucinn_ascendv2__Preferred_Spouse__c,
                                                                                                    Starting_Fiscal_Year__c = startingFiscalYear,
                                                                                                    Honor_Roll_Name__c = 'Test Honor Roll Name');

            newHonorRollName = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newHonorRollName});
            insert newHonorRollName;
        }

        public virtual void testWithNoHonorRollNameRecordRun() {
            setUpContacts();
            setUpCase();

            List<SObject> oldList = new List<SObject>{caseHonorRoll};

            Case newCase = caseHonorRoll.clone(true, true, false, false);
            newCase.Status = 'Approved';

            List<SObject> newList = new List<SObject>{newCase};

            new PORTAL_TRIG_CaseHandler().run(newList,
                                                oldList,
                                                ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                Case.getSObjectType().getDescribe());
        }

        public virtual void testWithHonorRollNameRecordInThePastRun() {
            setUpContacts();
            setUpCase();
            setUpHonorRollNameRecord(null);

            List<SObject> oldList = new List<SObject>{caseHonorRoll};

            Case newCase = caseHonorRoll.clone(true, true, false, false);
            newCase.Status = 'Approved';

            List<SObject> newList = new List<SObject>{newCase};

            new PORTAL_TRIG_CaseHandler().run(newList,
                                                oldList,
                                                ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                Case.getSObjectType().getDescribe());
        }

          public virtual void testWithHonorRollNameRecordInCurrentFiscalYearRun() {
            setUpContacts();
            setUpCase();
            setUpHonorRollNameRecord(PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.FiscalYearSettings?.Name);

            List<SObject> oldList = new List<SObject>{caseHonorRoll};

            Case newCase = caseHonorRoll.clone(true, true, false, false);
            newCase.Status = 'Approved';

            List<SObject> newList = new List<SObject>{newCase};

            new PORTAL_TRIG_CaseHandler().run(newList,
                                                oldList,
                                                ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                Case.getSObjectType().getDescribe());
        }

        public virtual void testZoneMembershipCases() {
            setUpContacts();
            List<case> cases = new List<Case>();

            Case case1 = createCaseZone('Zone Membership', 'New');
            Case case2 = createCaseZone('Zone Membership', 'New');
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
                Constituent__c = contactRecord.Id,
                Zone__c = testZone.Id
            );
            testZoneMembership1 = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZoneMembership1});
            insert testZoneMembership1;

            ucinn_portal_Zone_Membership__c testZoneMembership2 = new ucinn_portal_Zone_Membership__c(
                Case__c = case2.Id,
                Status__c = 'Pending',
                Constituent__c = contactRecord.Id,
                Zone__c = testZone2.Id
            );
            testZoneMembership2 = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testZoneMembership2});
            insert testZoneMembership2;

            Case newCase1 = case1.clone(true, false, true, false);
            newCase1.Status = 'Approved';

            Case newCase2 = case2.clone(true, false, true, false);
            newCase2.Status = 'Denied';

            List<Case> oldList = new List<Case>{case1, case2};
            List<Case> newList = new List<Case>{newCase1, newCase2};

            new PORTAL_TRIG_CaseHandler().run(newList,
                                                oldList,
                                                ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                Case.getSObjectType().getDescribe());
        }

        public virtual void testJobPostingCases() {
            setUpContacts();
            List<case> cases = new List<Case>();

            Case case1 = createCaseZone('Job Posting', 'New');
            Case case2 = createCaseZone('Job Posting', 'New');
            case1 = (Case)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => case1});
            case2 = (Case)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => case2});

            cases.add(case1);
            cases.add(case2);
            insert cases;

            ucinn_portal_Job__c testJob1 = new ucinn_portal_Job__c(
                Name = 'Project Manager',
                Case__c = case1.Id,
                Status__c = 'Pending'
            );
            testJob1 = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testJob1});
            insert testJob1;

            ucinn_portal_Job__c testJob2 = new ucinn_portal_Job__c(
                Name = 'Software Developer',
                Status__c = 'Pending Edit'
            );
            testJob2 = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testJob2});
            insert testJob2;

            ucinn_portal_Job__c testJob2Draft = new ucinn_portal_Job__c(
                Name = 'Salesforce Developer',
                Case__c = case2.Id,
                Status__c = 'Draft',
                Master_Job__c = testJob2.Id
            );
            testJob2Draft = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testJob2Draft});
            insert testJob2Draft;

            Case newCase1 = case1.clone(true, false, true, false);
            newCase1.Status = 'Approved';

            Case newCase2 = case2.clone(true, false, true, false);
            newCase2.Status = 'Approved';

            List<Case> oldList = new List<Case>{case1, case2};
            List<Case> newList = new List<Case>{newCase1, newCase2};

            new PORTAL_TRIG_CaseHandler().run(newList,
                                              oldList,
                                              ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                              Case.getSObjectType().getDescribe());
        }

    }

    static testMethod void testWithNoHonorRollNameRecordRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_CaseHandlerTestClass().testWithNoHonorRollNameRecordRun();
    }

    static testMethod void testWithHonorRollNameRecordInThePastRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_CaseHandlerTestClass().testWithHonorRollNameRecordInThePastRun();
    }

    static testMethod void testWithHonorRollNameRecordInCurrentFiscalYearRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_CaseHandlerTestClass().testWithHonorRollNameRecordInCurrentFiscalYearRun();
    }

    static testMethod void testZoneMembershipCases() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_CaseHandlerTestClass().testZoneMembershipCases();
    }

    static testMethod void testJobPostingCases() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_CaseHandlerTestClass().testJobPostingCases();
    }

}