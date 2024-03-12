@isTest
public without sharing class PORTAL_TRIG_VolunteerJobHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Volunteer_Job__c volunteerJob;
        public virtual void testRun() {
            List<SObject> newList = new List<SObject>();
            List<SObject> oldList = new List<SObject>();

            ucinn_portal_Volunteer_Job__c volunteerJob = new ucinn_portal_Volunteer_Job__c(Name = 'Test', Street__c = '230 Commerce', City__c = 'Irvine', State__c = 'CA', Country__c = 'USA', Postal_Code__c = '92602');
            newList.add(volunteerJob);
            insert volunteerJob;
            new PORTAL_TRIG_VolunteerJobHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert, ucinn_portal_Volunteer_Job__c.getSObjectType().getDescribe());

            ucinn_portal_Volunteer_Job__c jobClone = volunteerJob.clone(true, true, false, false);
            jobClone.Street__c = '232 Commerce';
            newList = new List<SObject>{jobClone};
            oldList = new List<SObject>{volunteerJob};
            update jobClone;
            new PORTAL_TRIG_VolunteerJobHandler().run(newList, oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate, ucinn_portal_Volunteer_Job__c.getSObjectType().getDescribe());
        }
    }
    
    static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_VolunteerJobHandlerTestClass().testRun();
    }
}