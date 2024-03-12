@isTest
public with sharing class PORTAL_API_MailGunTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testSendTransactionalEmail() {
            Map<String, Object> params =  new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.CONTACT_LIST_KEY, new List<Contact>{new Contact(FirstName = 'Test', LastName='Test', Email='demo@ucinnovation.com')});
            params.put(PORTAL_API_EmailHubBase.FROM_EMAIL_KEY, 'demo@ucinnovation.com');
            params.put(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY, 'testId');
            params.put(PORTAL_API_EmailHubBase.ZONE_NAME_KEY, 'All');
            params.put(PORTAL_API_EmailHubBase.SUBJECT_KEY, 'Test Newsletter');
            params.put(PORTAL_API_EmailHubBase.HTML_KEY, 'Test');
            params.put(PORTAL_API_EmailHubBase.PLAIN_TEXT_KEY, 'Test');
            params.put(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY, Datetime.newInstance(2021, 10, 31, 9, 9, 9));
            PORTAL_API_MailGun apiController = new PORTAL_API_MailGun();
            apiController.sendTransactionalEmail(params);
        }

        public virtual void testDeleteTag() {
            PORTAL_API_MailGun apiController = new PORTAL_API_MailGun();
            apiController.deleteTag('testId');
        }

        public virtual void testIsTransactionalEmail() {
            PORTAL_API_MailGun apiController = new PORTAL_API_MailGun();
            apiController.isTransactionalEmailAPI(new Map<String, Object>());
        }

        public virtual void testUpdateMetrics() {
            Map<String, Object> params =  new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY, 'testId');
            Campaign newsletterCampaign = new Campaign();
            newsletterCampaign.Name = 'testId Metrics';
            newsletterCampaign.IsActive = true;
            newsletterCampaign.Status = 'Completed';
            newsletterCampaign.Type= 'Email';
            newsletterCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_Campaign).getRecordTypeId();
            newsletterCampaign = (Campaign)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterCampaign});
            insert newsletterCampaign;
            PORTAL_API_MailGun apiController = new PORTAL_API_MailGun();
            apiController.updateMetrics(params);
            apiController.performDML(new Map<String, Object>());
        }

        public virtual void testGetStatsForMetric() {
            Map<String, Object> statMap = new Map<String, Object>{'total' => 1};
            Map<String, Object> statMapAlternativeSubMap = new Map<String, Object>{'total' => 1};
            Map<String, Object> statMapAlternative = new Map<String, Object>{'permanent' => statMapAlternativeSubMap, 'temporary' => statMapAlternativeSubMap};

            String metric = 'Test';

            Map<String, Object> statMapContainer = new Map<String, Object>{metric => statMap};
            Map<String, Object> statMapAlternativeContainer = new Map<String, Object>{metric => statMapAlternative};
            Map<String, Object> emptyStatMap = new Map<String, Object>{'Test' => new Map<String, Object>()};

            List<Object> listContainer = new List<Object>{emptyStatMap, statMapContainer, statMapAlternativeContainer};

            Map<String, Object> finalMap = new Map<String, Object>{'stats' => listContainer};

            Test.startTest();

            Integer result = PORTAL_API_MailGun.getStatsForMetric(finalMap, metric);
            System.assertEquals(3, result);

            Test.stopTest();
        }

        public virtual void testGetStatsForMetricEmptyInput() {
            Test.startTest();

            Integer result = PORTAL_API_MailGun.getStatsForMetric(null, '');
            System.assertEquals(null, result);

            Test.stopTest();
        }

        public virtual void testGetUnsubscribeUrl() {
            PORTAL_API_MailGun controller = new PORTAL_API_MailGun();
            String input = 'Test';
            String expected = PORTAL_CommunityUtils.getPortalURL().removeEnd('/') + PORTAL_CONST_CommunityUrls.UNSUBSCRIBE_URL + '?rid=' + input + '&cid=%recipient.Id%';

            Test.startTest();

            String result = controller.getUnsubscribeUrl(new Map<String, Object>{'newsletterId' => input});
            System.assertEquals(expected, result);

            Test.stopTest();
        }

        public virtual void testSendTransactionalEmailEmptyInput() {
            PORTAL_API_MailGun controller = new PORTAL_API_MailGun();

            Test.startTest();

            try {
                controller.sendTransactionalEmail(new Map<String, Object>());
            } catch (Exception e) {
                System.assertEquals('The parameters are invalid for sending out a newsletter.', e.getMessage());
            }
            
            Test.stopTest();
        }
    }

    @isTest
    public static void testSendTransactionalEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testSendTransactionalEmail();
    }

    @isTest
    public static void testDeleteTag() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testDeleteTag();
    }

    @isTest
    public static void testIsTransactionalEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testIsTransactionalEmail();
    }

    @isTest
    public static void testUpdateMetrics() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testUpdateMetrics();
    }

    @isTest
    public static void testGetStatsForMetric() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testGetStatsForMetric();
    }

    @isTest
    public static void testGetStatsForMetricEmptyInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testGetStatsForMetricEmptyInput();
    }

    @isTest
    public static void testGetUnsubscribeUrl() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testGetUnsubscribeUrl();
    }

    @isTest
    public static void testSendTransactionalEmailEmptyInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getMailGunTestClass().testSendTransactionalEmailEmptyInput();
    }
}