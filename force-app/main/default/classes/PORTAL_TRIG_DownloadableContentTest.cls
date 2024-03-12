@isTest
public with sharing class PORTAL_TRIG_DownloadableContentTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testRun() {
            Test.startTest();
            ucinn_portal_Downloadable_Content__c dlc = new ucinn_portal_Downloadable_Content__c(Component_Name__c = 'Test');
            insert dlc;
            new PORTAL_TRIG_DownloadableContentHandler().run(new List<SObject>{dlc}, new List<SObject>(), ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert, ucinn_portal_Downloadable_Content__c.sObjectType.getDescribe());
            Test.stopTest();
        }
    }

    /**
     * Test run
     * @author Jacob Huang
     * @since 1.19
     */
    @isTest
    public static void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_DownloadableContentTestClass().testRun();
    }
}