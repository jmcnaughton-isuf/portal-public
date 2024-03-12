@isTest
public class PORTAL_LWC_MembershipPurchaseCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testInitializeMembershipPurchase() {
            PORTAL_LWC_MembershipPurchaseController.SERVER_initializeMembershipPurchase(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_initializeMembershipPurchase(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_initializeMembershipPurchase(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetMembershipFieldsToPrepopulate() {
            PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipFieldsToPrepopulate(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipFieldsToPrepopulate(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipFieldsToPrepopulate(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testCreateReviewTransaction() {
            PORTAL_LWC_MembershipPurchaseController.SERVER_createReviewTransaction(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_createReviewTransaction(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_createReviewTransaction(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetMembershipBenefitInformation() {
            PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipBenefitInformation(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipBenefitInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipBenefitInformation(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    static testMethod void testInitializeMembershipPurchase() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipPurchaseCtrlTestClass().testInitializeMembershipPurchase();
    }

    static testMethod void testGetMembershipFieldsToPrepopulate() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipPurchaseCtrlTestClass().testGetMembershipFieldsToPrepopulate();
    }

    static testMethod void testCreateReviewTransaction() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipPurchaseCtrlTestClass().testCreateReviewTransaction();
    }

    static testMethod void testGetBenefitInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMembershipPurchaseCtrlTestClass().testGetMembershipBenefitInformation();
    }
}