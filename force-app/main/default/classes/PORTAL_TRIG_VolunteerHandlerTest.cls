@isTest
public without sharing class PORTAL_TRIG_VolunteerHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public Contact con;
        public ucinn_portal_Volunteer_Job__c volunteerJob;
        public ucinn_portal_Volunteer_Shift__c volunteerShift;

        public virtual void setupData() {
            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                insert con;

                volunteerJob = new ucinn_portal_Volunteer_Job__c(Name = 'Test Job');
                insert volunteerJob;

                volunteerShift = new ucinn_portal_Volunteer_Shift__c(Name = 'Test Shift', Volunteer_Job__c = volunteerJob.Id);
                insert volunteerShift;
            }
        }

        public virtual void testRun() {
            setupData();
            List<SObject> newList = new List<SObject>();
            List<SObject> oldList = new List<SObject>();

            ucinn_portal_Volunteer__c volunteerRecord = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShift.Id, Contact__c = con.Id, Hours_Reported__c = 4, Application_Status__c = 'Completed');
            insert volunteerRecord;

            newList.add(volunteerRecord);
            new PORTAL_TRIG_VolunteerHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert, ucinn_portal_Volunteer__c.getSObjectType().getDescribe());

            ucinn_portal_Volunteer__c volunteerRecordClone = volunteerRecord.clone(true, true, false, false);
            volunteerRecordClone.Hours_Reported__c = 2;
            update volunteerRecordClone;

            newList = new List<SObject>{volunteerRecordClone};
            oldList = new List<SObject>{volunteerRecord};

            new PORTAL_TRIG_VolunteerHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate, ucinn_portal_Volunteer__c.getSObjectType().getDescribe());

            newList = new List<SObject>{};
            oldList = new List<SObject>{volunteerRecordClone};
            delete volunteerRecordClone;
            new PORTAL_TRIG_VolunteerHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete, ucinn_portal_Volunteer__c.getSObjectType().getDescribe());
            new PORTAL_TRIG_VolunteerHandler().run(newList, new List<SObject>(), ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert, ucinn_portal_Volunteer__c.getSObjectType().getDescribe());
        }

    }

    static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_VolunteerHandlerTestClass().testRun();
    }

}