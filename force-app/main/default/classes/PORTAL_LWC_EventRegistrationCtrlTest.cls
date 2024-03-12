@isTest
public class PORTAL_LWC_EventRegistrationCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testInitEventRegistration() {
            PORTAL_LWC_EventRegistrationController.SERVER_initEventRegistration(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventRegistrationController.SERVER_initEventRegistration(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventRegistrationController.SERVER_initEventRegistration(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testRegisterParticipants() {
            try {
                PORTAL_LWC_EventRegistrationController.SERVER_registerParticipants(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventRegistrationController.SERVER_registerParticipants(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventRegistrationController.SERVER_registerParticipants(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetPromoCodeDiscount() {
            PORTAL_LWC_EventRegistrationController.SERVER_getPromoCodeDiscount(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventRegistrationController.SERVER_getPromoCodeDiscount(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventRegistrationController.SERVER_getPromoCodeDiscount(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testInitEventRegistration() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventRegistrationCtrlTestClass().testInitEventRegistration();
    }

    static testMethod void testRegisterParticipants() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventRegistrationCtrlTestClass().testRegisterParticipants();
    }

    static testMethod void testGetPromoCodeDiscount() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventRegistrationCtrlTestClass().testGetPromoCodeDiscount();
    }
}