@isTest
public class PORTAL_CyberSourceFormControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testController() {
            Test.startTest();
            try {
                PORTAL_CyberSourceFormController controller = new PORTAL_CyberSourceFormController();
                controller.captureContext = 'Test Context';
                controller.lexOrigin = 'Test lexOrigin';
                controller.termsAndConditionsUrl = '/s/testurl';

                PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
                Test.setMock(HttpCalloutMock.class, mockcallouts);
                mockcallouts.addRequest(200, 'succeeded', '{"keyId" : "Test Context"}', 'https://apitest.cybersource.com' + PORTAL_CybersourcePaymentGateway.CAPTURE_CONTEXT_REQUEST_TARGET);
                    
                String ctx = controller.captureContext;
                String lOrigin = controller.lexOrigin;
                String termsUrl = controller.termsAndConditionsUrl;

                System.assertEquals('Test Context', ctx);
                System.assertNotEquals(null, lOrigin);
                System.assertEquals('/s/testurl', termsUrl);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testController() {
        PORTAL_TestClassFactory.getTestClassFactory().getCyberSourceFormControllerTestClass().testController();
    }
}