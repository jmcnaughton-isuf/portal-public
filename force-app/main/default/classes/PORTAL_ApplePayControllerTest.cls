@isTest
public inherited sharing class PORTAL_ApplePayControllerTest {
    public static final String TEST_CONST = 'Test';

    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_HttpMockCallout mockcallouts;

        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetLexOrigin() {
            PORTAL_ApplePayController controller = new PORTAL_ApplePayController();
            controller.lexOrigin = TEST_CONST;
            System.debug(controller.lexOrigin);
        }

        public virtual void testGetMerchantName() {
            PORTAL_ApplePayController controller = new PORTAL_ApplePayController();
            controller.merchantName = TEST_CONST;

            System.debug(controller.merchantName);
        }

        public virtual void testGetMerchantSession() {
            Test.startTest();
            PORTAL_ApplePayController controller = new PORTAL_ApplePayController();
            mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'Request Successful', '{}', PORTAL_ApplePayController.PAYMENT_SESSION_ENDPOINT);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            controller.merchantSession = TEST_CONST;

            System.debug(controller.merchantSession);
            Test.stopTest();
        }

        public virtual void testIsApplePayConfigured() {
            PORTAL_ApplePayController controller = new PORTAL_ApplePayController();
            controller.isApplePayConfigured = true;

            System.debug(controller.isApplePayConfigured);
        }
    }

    @isTest
    public static void testGetLexOrigin() {
        PORTAL_TestClassFactory.getTestClassFactory().getApplePayControllerTestClass().testGetLexOrigin();
    }

    @isTest
    public static void testGetMerchantName() {
        PORTAL_TestClassFactory.getTestClassFactory().getApplePayControllerTestClass().testGetMerchantName();
    }

    @isTest
    public static void testGetMerchantSession() {
        PORTAL_TestClassFactory.getTestClassFactory().getApplePayControllerTestClass().testGetMerchantSession();
    }

    @isTest
    public static void testIsApplePayConfigured() {
        PORTAL_TestClassFactory.getTestClassFactory().getApplePayControllerTestClass().testIsApplePayConfigured();
    }
}