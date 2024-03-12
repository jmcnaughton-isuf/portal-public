@isTest
public class PORTAL_LWC_VolunteerControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testInitializeSignUpForm() {
            PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerSignUp(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerSignUp(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerSignUp(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetVolunteerJobList() {

            try {
                PORTAL_LWC_VolunteerController.SERVER_getVolunteerJobList(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_getVolunteerJobList(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_getVolunteerJobList(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testVolunteerShiftSignUp() {
            try {
                PORTAL_LWC_VolunteerController.SERVER_volunteerShiftSignUp(null);
            } catch (Exception ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_volunteerShiftSignUp(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_volunteerShiftSignUp(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testVolunteerModifyApplicationModal() {
            try {
                PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerModifyModal(null);
            } catch (Exception ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerModifyModal(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerModifyModal(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testVolunteerModifyApplicationSave() {
            try {
                PORTAL_LWC_VolunteerController.SERVER_volunteerModifyApplicationSave(null);
            } catch (Exception ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_volunteerModifyApplicationSave(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_volunteerModifyApplicationSave(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetShiftInfo() {
            try {
                PORTAL_LWC_VolunteerController.SERVER_getShiftInfo(null);
            } catch (Exception ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_getShiftInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_getShiftInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void withdrawVolunteerApplication() {
            try {
                PORTAL_LWC_VolunteerController.SERVER_withdrawVolunteerApplication(null);
            } catch (Exception ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_withdrawVolunteerApplication(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerController.SERVER_withdrawVolunteerApplication(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

    }

    static testMethod void testInitializeSignUpForm() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().testInitializeSignUpForm();
    }

    static testMethod void testGetVolunteerJobList() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().testGetVolunteerJobList();
    }

    static testMethod void testVolunteerShiftSignUp() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().testVolunteerShiftSignUp();
    }

    static testMethod void testVolunteerModifyApplicationModal() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().testVolunteerModifyApplicationModal();

    }

    static testMethod void testVolunteerModifyApplicationSave() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().testVolunteerModifyApplicationSave();
    }

    static testMethod void testGetShiftInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().testGetShiftInfo();
    }

    static testMethod void withdrawVolunteerApplication() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerControllerTestClass().withdrawVolunteerApplication();

    }


}