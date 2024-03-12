@isTest
public class PORTAL_LWC_EventWaitlistFormCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testWaitlistRegistrant() {
            try {
                PORTAL_LWC_EventWaitlistFormController.SERVER_waitlistRegistrant(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventWaitlistFormController.SERVER_waitlistRegistrant(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testDeleteWaitlistEntry() {
            try{
                PORTAL_LWC_EventWaitlistFormController.SERVER_deleteWaitlistEntry(null);
            } catch (Exception e) {
                System.debug(e);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventWaitlistFormController.SERVER_deleteWaitlistEntry(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventWaitlistFormController.SERVER_deleteWaitlistEntry(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetWaitlistEntryById() {
            PORTAL_LWC_EventWaitlistFormController.SERVER_getWaitlistEntryById(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventWaitlistFormController.SERVER_getWaitlistEntryById(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventWaitlistFormController.SERVER_getWaitlistEntryById(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    static testMethod void testWaitlistRegistrant() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventWaitlistFormCtrlTestClass().testWaitlistRegistrant();
    }

    static testMethod void testDeleteWaitlistEntry() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventWaitlistFormCtrlTestClass().testDeleteWaitlistEntry();
    }

    static testMethod void testGetWaitlistEntryById() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventWaitlistFormCtrlTestClass().testGetWaitlistEntryById();
    }
}