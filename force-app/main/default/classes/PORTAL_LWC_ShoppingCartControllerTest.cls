@isTest
public class PORTAL_LWC_ShoppingCartControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetParticipations() {
            PORTAL_LWC_ShoppingCartController.SERVER_getParticipationsMapInSession(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_getParticipationsMapInSession(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_getParticipationsMapInSession(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testCheckForTicketsInShoppingCart() {
            PORTAL_LWC_ShoppingCartController.SERVER_checkForTicketsInShoppingCart(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_checkForTicketsInShoppingCart(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_checkForTicketsInShoppingCart(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testModifyStatusAndExtend() {
            PORTAL_LWC_ShoppingCartController.SERVER_modifyRegistrationStatusAndExtendExpirationDate(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_modifyRegistrationStatusAndExtendExpirationDate(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_modifyRegistrationStatusAndExtendExpirationDate(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testPaymentPageExit() {
            PORTAL_LWC_ShoppingCartController.SERVER_handlePaymentPageExit(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_handlePaymentPageExit(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_handlePaymentPageExit(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testDeleteParticipation() {
            try{
                PORTAL_LWC_ShoppingCartController.SERVER_deleteRegistrationForEvent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_deleteRegistrationForEvent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_deleteRegistrationForEvent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testChargeCreditCard() {
            try{
                PORTAL_LWC_ShoppingCartController.SERVER_isChargeCreditCard(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_isChargeCreditCard(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_isChargeCreditCard(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testEventPaymentCheckout() {
            try{
                PORTAL_LWC_ShoppingCartController.SERVER_eventPaymentCheckout(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_eventPaymentCheckout(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_eventPaymentCheckout(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testhandleUniquePaymentSession() {
            PORTAL_LWC_ShoppingCartController.SERVER_handleUniquePaymentSession(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_handleUniquePaymentSession(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_handleUniquePaymentSession(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testGetEventConfirmationDetails() {
            PORTAL_LWC_ShoppingCartController.SERVER_getEventConfirmationDetails(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_getEventConfirmationDetails(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ShoppingCartController.SERVER_getEventConfirmationDetails(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

    }
    static testMethod void testGetParticipations() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testGetParticipations();

    }

    static testMethod void testCheckForTicketsInShoppingCart() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testCheckForTicketsInShoppingCart();
    }

    static testMethod void testModifyStatusAndExtend() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testModifyStatusAndExtend();
    }

    static testMethod void testPaymentPageExit() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testPaymentPageExit();
    }

    static testMethod void testDeleteParticipation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testDeleteParticipation();
    }

    static testMethod void testChargeCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testChargeCreditCard();

    }

    static testMethod void testEventPaymentCheckout() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testEventPaymentCheckout();

    }

    static testMethod void testhandleUniquePaymentSession() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testhandleUniquePaymentSession();
    }

    static testMethod void testGetEventConfirmationDetails() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcShoppingCartControllerTestClass().testGetEventConfirmationDetails();

    }

}