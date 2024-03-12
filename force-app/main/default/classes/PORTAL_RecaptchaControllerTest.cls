@isTest
public class PORTAL_RecaptchaControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetSiteKey() {
            PORTAL_RecaptchaController controller = new PORTAL_RecaptchaController();
            Test.startTest();

            controller.siteKey = 'Test';

            String siteKey = controller.siteKey;

            Test.stopTest();
        }

        public virtual void testGetSecretKey() {
            PORTAL_RecaptchaController controller = new PORTAL_RecaptchaController();
            Test.startTest();

            String secretKey = controller.getSecretKey();

            System.assert(String.isNotEmpty(secretKey));

            Test.stopTest();
        }

        public virtual void testGetRecaptchaOption() {
            PORTAL_RecaptchaController controller = new PORTAL_RecaptchaController();
            Test.startTest();

            String recaptchaOption = controller.getRecaptchaOption();

            System.assert(String.isNotEmpty(recaptchaOption));

            Test.stopTest();
        }

        public virtual void testGetLexOrigin() {
            PORTAL_RecaptchaController controller = new PORTAL_RecaptchaController();
            Test.startTest();

            controller.lexOrigin = 'Test';

            String siteKey = controller.lexOrigin;

            Test.stopTest();
        }

        public virtual void isRecaptchaTokenValid() {
            PORTAL_RecaptchaController controller = new PORTAL_RecaptchaController();
            Test.startTest();

            String recaptchaToken = 'Test token';
            String testAction = 'Test action';

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(200, 'succeeded', '{"success": true}', PORTAL_RecaptchaController.GOOGLE_RECAPTCHA_VERIFY_ENDPOINT);

            System.assert(controller.isRecaptchaTokenValid(recaptchaToken, testAction));

            Test.stopTest();
        }

        public virtual void testIsRecaptchaRequestVerified() {
            PORTAL_RecaptchaController controller = new PORTAL_RecaptchaController();
            Test.startTest();
            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            mockcallouts.addRequest(200, 'succeeded', '{"success": true}', PORTAL_RecaptchaController.GOOGLE_RECAPTCHA_VERIFY_ENDPOINT);

            String recaptchaToken = 'Test token';
            String testAction = 'Test action';

            System.assert(controller.isRecaptchaTokenValid(recaptchaToken, testAction));

            mockcallouts.addRequest(404, 'not found', '', PORTAL_RecaptchaController.GOOGLE_RECAPTCHA_VERIFY_ENDPOINT);

            System.assert(!controller.isRecaptchaRequestVerified(recaptchaToken, testAction));

            Decimal acceptScore = controller.getRejectingScore() + 1.0;
            String acceptScoreBody = '{"success": true, "score": ' + String.valueOf(acceptScore) + ', "action": "' + PORTAL_RecaptchaController.FORM_SUBMIT + '"}';
            System.debug(acceptScoreBody);

            Decimal rejectScore = controller.getRejectingScore() - 1.0;
            String rejectScoreBody = '{"success": true, "score": ' + String.valueOf(rejectScore) + ', "action": "' + PORTAL_RecaptchaController.FORM_SUBMIT + '"}';
            System.debug(acceptScoreBody);

            mockcallouts.addRequest(200, 'succeeded', acceptScoreBody, PORTAL_RecaptchaController.GOOGLE_RECAPTCHA_VERIFY_ENDPOINT);
            testAction = PORTAL_RecaptchaController.FORM_SUBMIT;
            System.assert(controller.isRecaptchaRequestVerified(recaptchaToken, testAction));

            mockcallouts.addRequest(200, 'succeeded', rejectScoreBody, PORTAL_RecaptchaController.GOOGLE_RECAPTCHA_VERIFY_ENDPOINT);

            System.assert(!controller.isRecaptchaRequestVerified(recaptchaToken, testAction));

            Test.stopTest();
        }
    }

    static testMethod void testGetSiteKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecaptchaControllerTestClass().testGetSiteKey();
    }

    static testMethod void testGetSecretKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecaptchaControllerTestClass().testGetSecretKey();
    }

    static testMethod void testGetRecaptchaOption() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecaptchaControllerTestClass().testGetRecaptchaOption();
    }
    static testMethod void testGetLexOrigin() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecaptchaControllerTestClass().testGetLexOrigin();
    }

    static testMethod void isRecaptchaTokenValid() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecaptchaControllerTestClass().isRecaptchaTokenValid();
    }
    static testMethod void testIsRecaptchaRequestVerified() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecaptchaControllerTestClass().testIsRecaptchaRequestVerified();
    }
}