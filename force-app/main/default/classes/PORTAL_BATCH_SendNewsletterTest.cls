@isTest
public with sharing class PORTAL_BATCH_SendNewsletterTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testConstructor() {
            try {
                new PORTAL_BATCH_SendNewsletter(null, null);
            } catch (Exception e) {

            }
        }

        public virtual void testBatch() {

            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = PORTAL_NewsletterControllerBase.NEWSLETTER_TEMPLATE_NAME;
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
            newsletter.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            newsletter.Newsletter_Template__c = newsletterTemplate.Id;
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            zone.Is_Display_on_Portal__c = true;
            zone.Footer_Content__c = '<p>Test</p>';
            zone.Social_Media_Order__c = 'Facebook;Twitter';
            zone.Newsletter_Html_Format__c = '<p>{footerContent}<p>';
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;

            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = (String)newsletter.Id + ' Metrics';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = 'Completed';
            newsletterCampaign.Type= 'Email';
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_Campaign).getRecordTypeId();
            newsletterCampaign = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterCampaign});
            insert newsletterCampaign;

            newsletter.Newsletter_Metrics__c = newsletterCampaign.Id;
            update newsletter;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;



            Contact cont = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              ucinn_portal_Is_Display_On_Portal__c = true,
                              Email = 'testCommunityUsermig123@test.com');
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            CampaignMember eachCampaignMember = new CampaignMember();
            eachCampaignMember.CampaignId = newsletterCampaign.Id;
            eachCampaignMember.ContactId = cont.Id;
            eachCampaignMember.ucinn_portal_Email_Status__c = 'Pending';
            eachCampaignMember = (CampaignMember)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => eachCampaignMember});
            insert eachCampaignMember;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_SendNewsletter(newsletter.Id, Datetime.now()));
            Test.stopTest();

        }

        public virtual void testBatchWithError() {
            PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
            testBatch();
        }

        public virtual void testBatchWithNoZone() {
            ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
            newsletter.Name = 'Test Newsletter';
            newsletter.Portal_Zone__c = 'Alumni Club of Irvine';
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = (String)newsletter.Id + ' Metrics';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = 'Completed';
            newsletterCampaign.Type= 'Email';
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_Campaign).getRecordTypeId();
            newsletterCampaign = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterCampaign});
            insert newsletterCampaign;

            newsletter.Newsletter_Metrics__c = newsletterCampaign.Id;
            update newsletter;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;



            Contact cont = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              ucinn_portal_Is_Display_On_Portal__c = true,
                              Email = 'testCommunityUsermig123@test.com');
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            CampaignMember eachCampaignMember = new CampaignMember();
            eachCampaignMember.CampaignId = newsletterCampaign.Id;
            eachCampaignMember.ContactId = cont.Id;
            eachCampaignMember.ucinn_portal_Email_Status__c = 'Pending';
            eachCampaignMember = (CampaignMember)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => eachCampaignMember});
            insert eachCampaignMember;


            try {
                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_SendNewsletter(newsletter.Id, Datetime.now()));
                Test.stopTest();
            } catch (Exception e) {

            }


        }

        public virtual void testBatchWithNoNewsletter() {
            ucinn_portal_Listing__c newsletter = new ucinn_portal_Listing__c();
            newsletter.Name = 'Test Newsletter';
            newsletter.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            newsletter.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            newsletter = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletter});
            insert newsletter;

            Id newsletterId = newsletter.Id;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            zone.Is_Display_on_Portal__c = true;
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;

            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = (String)newsletter.Id + ' Metrics';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = 'Completed';
            newsletterCampaign.Type= 'Email';
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_Campaign).getRecordTypeId();
            newsletterCampaign = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterCampaign});
            insert newsletterCampaign;

            newsletter.Newsletter_Metrics__c = newsletterCampaign.Id;
            update newsletter;

            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;



            Contact cont = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              ucinn_portal_Is_Display_On_Portal__c = true,
                              Email = 'testCommunityUsermig123@test.com');
            cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
            insert cont;

            CampaignMember eachCampaignMember = new CampaignMember();
            eachCampaignMember.CampaignId = newsletterCampaign.Id;
            eachCampaignMember.ContactId = cont.Id;
            eachCampaignMember.ucinn_portal_Email_Status__c = 'Pending';
            eachCampaignMember = (CampaignMember)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => eachCampaignMember});
            insert eachCampaignMember;

            delete newsletter;


            try {
                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_SendNewsletter(newsletterId, Datetime.now()));
                Test.stopTest();
            } catch (Exception e) {

            }
        }

        public virtual void testBatchWithNothing() {

            try {
                Test.startTest();
                Database.executeBatch(new PORTAL_BATCH_SendNewsletter('', Datetime.now()));
                Test.stopTest();
            } catch (Exception e) {

            }
        }
    }

    @isTest
    public static void testConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendNewsletterTestClass().testConstructor();
    }

    @isTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendNewsletterTestClass().testBatch();
    }

    @isTest
    public static void testBatchWithError() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendNewsletterTestClass().testBatchWithError();
    }

    @isTest
    public static void testBatchWithNoZone() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendNewsletterTestClass().testBatchWithNoZone();
    }

    @isTest
    public static void testBatchWithNoNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendNewsletterTestClass().testBatchWithNoNewsletter();
    }

    @isTest
    public static void testBatchWithNothing() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendNewsletterTestClass().testBatchWithNothing();
    }
}