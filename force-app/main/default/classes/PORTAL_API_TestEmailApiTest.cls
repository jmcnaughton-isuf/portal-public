@isTest
public inherited sharing class PORTAL_API_TestEmailApiTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testFunctions() {

            PORTAL_API_TestEmailApi testApi = new PORTAL_API_TestEmailApi();

            testApi.isTransactionalEmailAPI(null);
            testApi.performDML(null);
            testApi.updateMetrics(null);
            testApi.getUnsubscribeUrl(null);
            testApi.sendTransactionalEmail(null);
            testApi.sendCampaignEmails(null);
            testApi.addOrUpdateContactsToExternalApi(null);
            testApi.removeContactsFromExternalApi(null);
            testApi.createOrUpdateExternalMailingLists(null);
        }
    }

    @isTest
    public static void testFunctions() {
        PORTAL_TestClassFactory.getTestClassFactory().getTestEmailApiTestClass().testFunctions();
    }
}