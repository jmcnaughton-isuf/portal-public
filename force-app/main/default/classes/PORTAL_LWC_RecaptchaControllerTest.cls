@isTest
public class PORTAL_LWC_RecaptchaControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetRecaptchaOption() {
            Test.startTest();

            Map<String, Object> params = new Map<String, Object>();

            try {
                PORTAL_LWC_RecaptchaController.SERVER_getRecaptchaOption(params);
                PORTAL_LWC_RecaptchaController.SERVER_getRecaptchaOption(null);

            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_RecaptchaController.SERVER_getRecaptchaOption(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_RecaptchaController.SERVER_getRecaptchaOption(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testVerifyRecaptchaToken() {
            Test.startTest();
    
            PORTAL_LWC_RecaptchaController.SERVER_verifyRecaptchaToken(null);
    
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_RecaptchaController.SERVER_verifyRecaptchaToken(null);
                System.assert(false);
            } catch (AuraHandledException ahe) { }
    
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_RecaptchaController.SERVER_verifyRecaptchaToken(null);
                System.assert(false);
            } catch (Exception e) { }
    
            Test.stopTest();
        }
    }

    static testMethod void testGetRecaptchaOption() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcRecaptchaControllerTestClass().testGetRecaptchaOption();        
    }

    /**
     * test verify recaptcha token in LWC controller
     * @author Jacob Huang
     * @since 1.3
     */
    static testMethod void testVerifyRecaptchaToken() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcRecaptchaControllerTestClass().testVerifyRecaptchaToken();
    }
}