@isTest
public with sharing class PORTAL_BATCH_UpdateNewsletterMetricsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testUpdateNewsletterMetrics() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.Newsletter).getRecordTypeId();
            listing.Is_Newsletter_Sent__c = true;
            listing.Start_Date_Time__c = Datetime.now().addDays(-1);
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = (String)listing.Id + ' Metrics';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = 'Completed';
            newsletterCampaign.Type= 'Email';
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_Campaign).getRecordTypeId();
            newsletterCampaign = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterCampaign});
            insert newsletterCampaign;

            listing.Newsletter_Metrics__c = newsletterCampaign.Id;
            update listing;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_UpdateNewsletterMetrics());
            Test.stopTest();
        }

        public virtual void testConstructor() {
            Test.startTest();

            PORTAL_BATCH_UpdateNewsletterMetrics controller = new PORTAL_BATCH_UpdateNewsletterMetrics('');

            Test.stopTest();
        }

        public virtual void testExecuteAlternative() {
            Test.startTest();

            PORTAL_BATCH_UpdateNewsletterMetrics controller = new PORTAL_BATCH_UpdateNewsletterMetrics('');
            controller.execute(null);

            Test.stopTest();
        }
    }

    @isTest
    public static void testUpdateNewsletterMetrics() {
        PORTAL_TestClassFactory.getTestClassFactory().getUpdateNewsletterMetricsTestClass().testUpdateNewsletterMetrics();
    }

    @isTest
    public static void testConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getUpdateNewsletterMetricsTestClass().testConstructor();
    }

    @isTest
    public static void testExecuteAlternative() {
        PORTAL_TestClassFactory.getTestClassFactory().getUpdateNewsletterMetricsTestClass().testExecuteAlternative();
    }
}