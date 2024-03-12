@isTest
public class PORTAL_LWC_PaymentHubControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetOrigin() {
            Map<String,Object> params = new map<String,Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};

            PORTAL_LWC_PaymentHubController.SERVER_getOrigin(params);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getOrigin(params);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getOrigin(params);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetApiKey() {
            Map<String,Object> params = new map<String,Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};
            PORTAL_LWC_PaymentHubController.SERVER_getAPIKey(params);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getAPIKey(params);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getAPIKey(params);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
            
        }

        public virtual void testGetSpreedlyTransactionToken() {
            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'Test Payment Method',
                                                                'giftType' => 'recurring'};

            Test.startTest();

            String result = PORTAL_LWC_PaymentHubController.SERVER_getSpreedlyTransactionToken(params);
            System.debug(result);

            Test.stopTest();
        }

        public virtual void testGetSpreedlyTransactionTokenBlankPaymentMethod() {
            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => ''};

            Test.startTest();

            try {
                PORTAL_LWC_PaymentHubController.SERVER_getSpreedlyTransactionToken(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        

        public virtual void testGetSpreedlyTransactionTokenInvalidInput() {
            Test.startTest();

            try {
                PORTAL_LWC_PaymentHubController.SERVER_getSpreedlyTransactionToken(null);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }


        public virtual void testGetStripeClientSecret() {
            Test.startTest();

            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME};

            try {
                PORTAL_LWC_PaymentHubController.SERVER_getStripeClientSecret(params);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};
            
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getStripeClientSecret(params);
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        
        public virtual void testGetRecaptchaOption() {
            Test.startTest();

            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_METHOD_NAME};

            try {
                PORTAL_LWC_PaymentHubController.SERVER_getRecaptchaOption(params);
                PORTAL_LWC_PaymentHubController.SERVER_getRecaptchaOption(null);

            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getRecaptchaOption(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetTouchNetSettings() {
            Test.startTest();

            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME};

            try {
                PORTAL_LWC_PaymentHubController.SERVER_getTouchNetSettings(params);
                PORTAL_LWC_PaymentHubController.SERVER_getTouchNetSettings(null);

            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getTouchNetSettings(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGenerateSecureLinkTicket() {
            Test.startTest();

            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME};

            try {
                PORTAL_LWC_PaymentHubController.SERVER_generateSecureLinkTicket(params);
                PORTAL_LWC_PaymentHubController.SERVER_generateSecureLinkTicket(null);

            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_generateSecureLinkTicket(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        
        public virtual void testGetCometDSessionId() {
            Test.startTest();

            Map<String, Object> params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME};

            try {
                PORTAL_LWC_PaymentHubController.SERVER_getCometDSessionId(params);
                PORTAL_LWC_PaymentHubController.SERVER_getCometDSessionId(null);

            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            params = new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'test'};

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_PaymentHubController.SERVER_getCometDSessionId(params);
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }
    }

    static testMethod void testGetOrigin() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetOrigin();
    }

    static testMethod void testGetApiKey() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetApiKey();
    }

    static testMethod void testGetSpreedlyTransactionToken() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetSpreedlyTransactionToken();        
    }

    static testMethod void testGetSpreedlyTransactionTokenBlankPaymentMethod() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetSpreedlyTransactionTokenBlankPaymentMethod();        
    }

    static testMethod void testGetSpreedlyTransactionTokenInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetSpreedlyTransactionTokenInvalidInput();        
    }

    static testMethod void testGetStripeClientSecret() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetStripeClientSecret();        
    }
    
    static testMethod void testGetRecaptchaOption() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetRecaptchaOption();        
    }

    static testMethod void testGetTouchNetSettings() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetTouchNetSettings();        
    }

    static testMethod void testGenerateSecureLinkTicket() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGenerateSecureLinkTicket();        
    }

    static testMethod void testGetCometDSessionId() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcPaymentHubControllerTestClass().testGetCometDSessionId();        
    }
}