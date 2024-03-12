@isTest
public class PORTAL_LWC_ZoneControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public void testGetZoneBioDetailInfo() {
            PORTAL_LWC_ZoneController.SERVER_getZoneBioDetailInfo(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneBioDetailInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneBioDetailInfo(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testGetZoneBoardMembers() {
            PORTAL_LWC_ZoneController.SERVER_getZoneBoardMembers(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneBoardMembers(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneBoardMembers(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testGetZoneTitle() {
            PORTAL_LWC_ZoneController.SERVER_getZoneTitle(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneTitle(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneTitle(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testGetContentToDisplay() {
            PORTAL_LWC_ZoneController.SERVER_getContentToDisplay(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getContentToDisplay(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getContentToDisplay(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testUnsubscribeFromNewsletter() {
            try {
                PORTAL_LWC_ZoneController.SERVER_unsubscribeFromNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_unsubscribeFromNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_unsubscribeFromNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testGetZoneBanner() {
            try {
                PORTAL_LWC_ZoneController.SERVER_getZoneBanner(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneBanner(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneController.SERVER_getZoneBanner(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testGetZoneBioDetailInfo(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneControllerTestClass().testGetZoneBioDetailInfo();
    }

    static testMethod void testGetZoneBoardMembers(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneControllerTestClass().testGetZoneBoardMembers();
    }

    static testMethod void testGetZoneTitle(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneControllerTestClass().testGetZoneTitle();
    }

    static testMethod void testUnsubscribeFromNewsletter(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneControllerTestClass().testUnsubscribeFromNewsletter();
    }

    static testMethod void testGetZoneBanner(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneControllerTestClass().testGetZoneBanner();
    }
}