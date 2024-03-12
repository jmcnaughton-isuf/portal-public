@isTest
public class PORTAL_LWC_HonorRollControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetHonorRollNames() {
            PORTAL_LWC_HonorRollController.SERVER_getHonorRollNames(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollNames(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollNames(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetHonorRollFilterInfo() {
            PORTAL_LWC_HonorRollController.SERVER_getHonorRollFilterInformation(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollFilterInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollFilterInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetHonorRollNameDetails() {
            PORTAL_LWC_HonorRollController.SERVER_getHonorRollNameDetails(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollNameDetails(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollNameDetails(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testHonorRollManageInfo() {
            try {
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollManagementInformation();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollManagementInformation();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_getHonorRollManagementInformation();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testSubmitHonorRollInfor() {
            PORTAL_LWC_HonorRollController.SERVER_submitHonorRollChanges(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_submitHonorRollChanges(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_HonorRollController.SERVER_submitHonorRollChanges(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }
    }
    static testMethod void testGetHonorRollNames() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcHonorRollControllerTestClass().testGetHonorRollNames();
    }

    static testMethod void testGetHonorRollFilterInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcHonorRollControllerTestClass().testGetHonorRollFilterInfo();
    }

    static testMethod void testGetHonorRollNameDetails() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcHonorRollControllerTestClass().testGetHonorRollNameDetails();
    }

    static testMethod void testHonorRollManageInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcHonorRollControllerTestClass().testHonorRollManageInfo();
    }

    static testMethod void testSubmitHonorRollInfor() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcHonorRollControllerTestClass().testSubmitHonorRollInfor();
    }
}