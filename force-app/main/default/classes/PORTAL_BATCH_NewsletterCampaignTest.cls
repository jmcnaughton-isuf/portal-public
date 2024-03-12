@isTest
public with sharing class PORTAL_BATCH_NewsletterCampaignTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testBatch() {

            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = 'Newsletter Section Listing';
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Newsletter_Listing__c = newsletterTemplate.Id;
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;


            ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
            newsletter.Name = 'Test Newsletter';
            newsletter.Portal_Zone__c = 'All';
            newsletter.Newsletter_Template__c = newsletterTemplate.Id;
            newsletter.Cache_API_Name__c = 'Test Cache';
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Name = 'All';
            zone.Is_Display_on_Portal__c = true;
            zone.Footer_Content__c = '<p>Test</p>';
            zone.Social_Media_Order__c = 'Facebook;Twitter';
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;



            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;



            Contact cont = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              ucinn_portal_Is_Display_On_Portal__c = true,
                              Email = 'testCommunityUsermig123@test.com');
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            ucinn_portal_Search_Filter_Cache__c cache = new ucinn_portal_Search_Filter_Cache__c();
            cache.Cache_API_Name__c = 'Test Cache';
            cache.Order_Number__c = 1;
            cache.Contact_Id_Cache_1__c = String.valueOf(cont.Id);
            cache = (ucinn_portal_Search_Filter_Cache__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cache});
            insert cache;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1));
            Test.stopTest();

            System.assertEquals([SELECT Id FROM Campaign].size(), 1);
            System.assertEquals([SELECT Id FROM CampaignMember].size(), 1);

        }

        public virtual void testInvalidConstructor() {
            try {
                new PORTAL_BATCH_NewsletterCampaign(null, null, null, null);
            } catch (Exception e) {

            }
        }

        public virtual void testInvalidNewsletterConstructor() {
            try {
                ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
                newsletterTemplate.Name = 'Newsletter Section Listing';
                newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
                newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
                newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
                insert newsletterTemplate;

                ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
                section.Name = 'Test Section';
                section.Newsletter_Listing__c = newsletterTemplate.Id;
                section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
                insert section;


                ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
                newsletter.Name = 'Test Newsletter';
                newsletter.Portal_Zone__c = 'All';
                newsletter.Newsletter_Template__c = newsletterTemplate.Id;
                newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
                newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
                insert newsletter;

                new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1);
            } catch (Exception e) {

            }
        }

        public virtual void testInvalidCache() {
            try {
                ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
                newsletterTemplate.Name = 'Newsletter Section Listing';
                newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
                newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
                newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
                insert newsletterTemplate;

                ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
                section.Name = 'Test Section';
                section.Newsletter_Listing__c = newsletterTemplate.Id;
                section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
                insert section;


                ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
                newsletter.Name = 'Test Newsletter';
                newsletter.Portal_Zone__c = 'All';
                newsletter.Cache_API_Name__c = 'Test Cache';
                newsletter.Newsletter_Template__c = newsletterTemplate.Id;
                newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
                newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
                insert newsletter;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1));
                Test.stopTest();
            } catch (Exception e) {

            }
        }

        public virtual void testNoConstituents() {
            try {
                ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
                newsletterTemplate.Name = 'Newsletter Section Listing';
                newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
                newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
                newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
                insert newsletterTemplate;

                ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
                section.Name = 'Test Section';
                section.Newsletter_Listing__c = newsletterTemplate.Id;
                section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
                insert section;


                ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
                newsletter.Name = 'Test Newsletter';
                newsletter.Portal_Zone__c = 'All';
                newsletter.Cache_API_Name__c = 'Test Cache';
                newsletter.Newsletter_Template__c = newsletterTemplate.Id;
                newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
                newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
                insert newsletter;

                ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
                zone.Name = 'All';
                zone.Is_Display_on_Portal__c = true;
                zone.Footer_Content__c = '<p>Test</p>';
                zone.Social_Media_Order__c = 'Facebook;Twitter';
                zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
                insert zone;



                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;



                Contact cont = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_portal_Search_Filter_Cache__c cache = new ucinn_portal_Search_Filter_Cache__c();
                cache.Cache_API_Name__c = 'Test Cache';
                cache.Order_Number__c = 1;
                cache.Contact_Id_Cache_1__c = String.valueOf(cont.Id);
                cache = (ucinn_portal_Search_Filter_Cache__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cache});
                insert cache;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1));
                Test.stopTest();
            } catch (Exception e) {

            }
        }

        public virtual void testEmptyCaches() {
            try {
                ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
                newsletterTemplate.Name = 'Newsletter Section Listing';
                newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
                newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
                newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
                insert newsletterTemplate;

                ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
                section.Name = 'Test Section';
                section.Newsletter_Listing__c = newsletterTemplate.Id;
                section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
                insert section;


                ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
                newsletter.Name = 'Test Newsletter';
                newsletter.Portal_Zone__c = 'All';
                newsletter.Newsletter_Template__c = newsletterTemplate.Id;
                newsletter.Cache_API_Name__c = 'Test Cache';
                newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
                newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
                insert newsletter;

                ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
                zone.Name = 'All';
                zone.Is_Display_on_Portal__c = true;
                zone.Footer_Content__c = '<p>Test</p>';
                zone.Social_Media_Order__c = 'Facebook;Twitter';
                zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
                insert zone;




                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;



                Contact cont = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                ucinn_portal_Is_Display_On_Portal__c = true,
                                Email = 'testCommunityUsermig123@test.com');
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                ucinn_portal_Search_Filter_Cache__c cache = new ucinn_portal_Search_Filter_Cache__c();
                cache.Cache_API_Name__c = 'Test Cache';
                cache.Order_Number__c = 1;
                cache.Contact_Id_Cache_1__c = '';
                cache = (ucinn_portal_Search_Filter_Cache__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cache});
                insert cache;

                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1));
                Test.stopTest();
            } catch (Exception e) {

            }
        }

        public virtual void testExecuteInvalidIdStrings() {
            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = 'Newsletter Section Listing';
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;
    
            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Newsletter_Listing__c = newsletterTemplate.Id;
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;
    
    
            ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
            newsletter.Name = 'Test Newsletter';
            newsletter.Portal_Zone__c = 'All';
            newsletter.Newsletter_Template__c = newsletterTemplate.Id;
            newsletter.Cache_API_Name__c = 'Test Cache';
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            PORTAL_BATCH_NewsletterCampaign controller = new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1);

            Test.startTest();

            controller.execute(null, new List<String>{''});
            controller.execute(null, new List<String>{';'});
            
            Test.stopTest();
        }

        public virtual void testConstructorWithMetrics() {
            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = 'Newsletter Section Listing';
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;
    
            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Newsletter_Listing__c = newsletterTemplate.Id;
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = 'Test';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = PORTAL_BATCH_NewsletterCampaign.COMPLETED_STATUS;
            newsletterCampaign.Type= PORTAL_BATCH_NewsletterCampaign.EMAIL_TYPE;
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_BATCH_NewsletterCampaign.CAMPAIGN_RECORD_TYPE).getRecordTypeId();
            insert newsletterCampaign;
    
            ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
            newsletter.Name = 'Test Newsletter';
            newsletter.Portal_Zone__c = 'All';
            newsletter.Newsletter_Template__c = newsletterTemplate.Id;
            newsletter.Cache_API_Name__c = 'Test Cache';
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter.Newsletter_Metrics__c = newsletterCampaign.Id;
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            Test.startTest();
            PORTAL_BATCH_NewsletterCampaign controller = new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1);
            Test.stopTest();
        }

        public virtual void testFinishEmptyCache() {
            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = 'Newsletter Section Listing';
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;
    
            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Newsletter_Listing__c = newsletterTemplate.Id;
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = 'Test';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = PORTAL_BATCH_NewsletterCampaign.COMPLETED_STATUS;
            newsletterCampaign.Type= PORTAL_BATCH_NewsletterCampaign.EMAIL_TYPE;
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_BATCH_NewsletterCampaign.CAMPAIGN_RECORD_TYPE).getRecordTypeId();
            insert newsletterCampaign;
    
            ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
            newsletter.Name = 'Test Newsletter';
            newsletter.Portal_Zone__c = 'All';
            newsletter.Newsletter_Template__c = newsletterTemplate.Id;
            newsletter.Cache_API_Name__c = 'Test Cache';
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter.Newsletter_Metrics__c = newsletterCampaign.Id;
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            Test.startTest();
            PORTAL_BATCH_NewsletterCampaign controller = new PORTAL_BATCH_NewsletterCampaign(newsletter.Id, Datetime.now(), 1, 1);

            delete [SELECT Order_Number__c FROM ucinn_portal_Search_Filter_Cache__c];

            controller.finish(null);

            Test.stopTest();
        }
    } // class end=========

    @isTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testBatch();
    }

    @isTest
    public static void testInvalidConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testInvalidConstructor();
    }

    @isTest
    public static void testInvalidNewsletterConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testInvalidNewsletterConstructor();
    }

    @isTest
    public static void testInvalidCache() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testInvalidCache();
    }

    @isTest
    public static void testNoConstituents() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testNoConstituents();
    }

    @isTest
    public static void testEmptyCaches() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testEmptyCaches();
    }

    @isTest
    public static void testExecuteInvalidIdStrings() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testExecuteInvalidIdStrings();
    }

    @isTest
    public static void testConstructorWithMetrics() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testConstructorWithMetrics();
    }

    @isTest
    public static void testFinishEmptyCache() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterCampaignTestClass().testFinishEmptyCache();
    }
}