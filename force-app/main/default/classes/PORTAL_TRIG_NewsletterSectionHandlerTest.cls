@isTest
public class PORTAL_TRIG_NewsletterSectionHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testRun() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            insert listing;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c(Newsletter_Listing__c = listing.Id);
            insert section;

            List<sObject> oldList = new List<sObject>();
            List<sObject> newList = new List<sObject>{section};
	
            Test.startTest();

            new PORTAL_TRIG_NewsletterSectionHandler().run(newList,
                                                            oldList,
                                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert,
                                                            ucinn_portal_Newsletter_Section__c.getSObjectType().getDescribe());

            new PORTAL_TRIG_NewsletterSectionHandler().run(newList,
                                                            oldList,
                                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                            ucinn_portal_Newsletter_Section__c.getSObjectType().getDescribe());

            new PORTAL_TRIG_NewsletterSectionHandler().run(newList,
                                                            oldList,
                                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete,
                                                            ucinn_portal_Newsletter_Section__c.getSObjectType().getDescribe());

            Test.stopTest();
        }
    }


    static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTrigNewsletterSectionHandlerTestClass().testRun();
    }
}