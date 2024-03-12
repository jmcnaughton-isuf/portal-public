@isTest
public with sharing class PORTAL_TRIG_JobHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void testGeolocateNewJobs() {
            ucinn_portal_Job__c job = new ucinn_portal_Job__c();
            job.Address_Line_1__c = '2855 Michelle Drive';
            job.Address_Line_2__c = '';
            job.Address_Line_3__c = '';
            job.City__c = 'Irvine';
            job.State__c = 'CA';
            job.Country__c = 'United States';
            job.Postal_Code__c = '92606';
            insert job;
            PORTAL_TRIG_JobHandler.geolocateJobs(new List<ucinn_portal_Job__c>{job});
        }

        public virtual void testGeolocateUpdatedJob() {
            ucinn_portal_Job__c job = new ucinn_portal_Job__c();
            job.Address_Line_1__c = '2855 Michelle Drive';
            job.Address_Line_2__c = '';
            job.Address_Line_3__c = '';
            job.City__c = 'Irvine';
            job.State__c = 'CA';
            job.Country__c = 'United States';
            job.Postal_Code__c = '92606';
            insert job;

            ucinn_portal_Job__c updatedJob = new ucinn_portal_Job__c();
            updatedJob.Id = job.Id;
            updatedJob.Address_Line_1__c = '2855 Michelle Drive';
            updatedJob.Address_Line_2__c = '';
            updatedJob.Address_Line_3__c = '';
            updatedJob.City__c = 'Irvine';
            updatedJob.State__c = 'California';
            updatedJob.Country__c = 'United States';
            updatedJob.Postal_Code__c = '92606';

            PORTAL_TRIG_JobHandler.geolocateJobs(new List<ucinn_portal_Job__c>{job}, new List<ucinn_portal_Job__c>{updatedJob});
        }
        
        public virtual void testRun() {
            PORTAL_TRIG_JobHandler handler = new PORTAL_TRIG_JobHandler();
            List<sObject> oldList = new List<sObject>();
            List<sObject> newList = new List<sObject>();

            Test.startTest();

            handler.run(newList,
                        oldList,
                        ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                        ucinn_portal_Job__c.getSObjectType().getDescribe());

            handler.run(newList,
                        oldList,
                        ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                        ucinn_portal_Job__c.getSObjectType().getDescribe());

            Test.stopTest();
        }

        public virtual void testGeolocateNewJobsCoverageIncrease() {
            ucinn_portal_Job__c job = new ucinn_portal_Job__c();
            job.Address_Line_1__c = '2855 Michelle Drive';
            job.Address_Line_2__c = 'Test';
            job.Address_Line_3__c = 'Test';
            job.City__c = 'Irvine';
            job.State__c = 'CA';
            job.Country__c = 'United States';
            job.Postal_Code__c = '92606';
            insert job;
            PORTAL_TRIG_JobHandler.geolocateJobs(new List<ucinn_portal_Job__c>{job});
        }
    }

    @isTest
    public static void testGeolocateNewJobs() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_JobHandlerTestClass().testGeolocateNewJobs();
    }

    @isTest
    public static void testGeolocateUpdatedJob() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_JobHandlerTestClass().testGeolocateUpdatedJob();
    }

    @isTest
    public static void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_JobHandlerTestClass().testRun();
    }

    @isTest
    public static void testGeolocateNewJobsCoverageIncrease() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_JobHandlerTestClass().testGeolocateNewJobsCoverageIncrease();
    }
   
}