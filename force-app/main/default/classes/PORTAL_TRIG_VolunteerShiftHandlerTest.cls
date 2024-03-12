@isTest
public without sharing class PORTAL_TRIG_VolunteerShiftHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Volunteer_Job__c volunteerJob;
        public virtual void setupData() {
            volunteerJob = new ucinn_portal_Volunteer_Job__c(Name = 'Test Job');
            insert volunteerJob;
        }

        public virtual void testRun() {
            setupData();
            List<SObject> newList = new List<SObject>();
            List<SObject> oldList = new List<SObject>();

            ucinn_portal_Volunteer_Shift__c volunteerShift = new ucinn_portal_Volunteer_Shift__c(Name = 'Test Shift', Volunteer_Job__c = volunteerJob.Id, Actual_Start_Date_Time__c = '2022-02-19 12:00:00', Actual_End_Date_Time__c = '2022-02-19 19:00:00');
            newList.add(volunteerShift);
            new PORTAL_TRIG_VolunteerShiftHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert, ucinn_portal_Volunteer_Shift__c.getSObjectType().getDescribe());
            insert volunteerShift;

            ucinn_portal_Volunteer_Shift__c shiftClone = volunteerShift.clone(true, true, false, false);
            shiftClone.Actual_Start_Date_Time__c = null;
            newList = new List<SObject>{shiftClone};
            oldList = new List<SObject>{volunteerShift};

            new PORTAL_TRIG_VolunteerShiftHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate, ucinn_portal_Volunteer_Shift__c.getSObjectType().getDescribe());
            update shiftClone;
        }
    }
    
    static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_VolunteerShiftHandlerTestClass().testRun();

    }
}