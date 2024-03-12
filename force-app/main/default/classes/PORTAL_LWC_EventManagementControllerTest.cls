@isTest
public class PORTAL_LWC_EventManagementControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testIsUserAdmin() {
            PORTAL_LWC_EventManagementController.SERVER_isUserAdministrator();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_isUserAdministrator();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_isUserAdministrator();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testGetRegisteredParticipations() {
            try {
                PORTAL_LWC_EventManagementController.SERVER_getRegisteredParticipations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_getRegisteredParticipations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_getRegisteredParticipations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testMarkParticipationAsAttended() {
            PORTAL_LWC_EventManagementController.SERVER_markParticipationAsAttended(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_markParticipationAsAttended(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_markParticipationAsAttended(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testDeleteParticipationRecord() {
            PORTAL_LWC_EventManagementController.SERVER_deleteParticipationRecord(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_deleteParticipationRecord(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_deleteParticipationRecord(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testGetAttendeeLists() {
            PORTAL_LWC_EventManagementController.getAttendeeLists();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.getAttendeeLists();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.getAttendeeLists();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testGetDegreeAndYearNeeded() {
            PORTAL_LWC_EventManagementController.getDegreeAndYearNeeded();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.getDegreeAndYearNeeded();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.getDegreeAndYearNeeded();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testGetDocumentTitle() {
            PORTAL_LWC_EventManagementController.getDocumentTitle();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.getDocumentTitle();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.getDocumentTitle();
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testEventCheckIn() {
            try {
                PORTAL_LWC_EventManagementController.SERVER_checkInRegistrant(null);
            } catch (Exception e) {
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_checkInRegistrant(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_EventManagementController.SERVER_checkInRegistrant(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

    }

    static testMethod void testIsUserAdmin() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testIsUserAdmin();
    }

    static testMethod void testGetRegisteredParticipations() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testGetRegisteredParticipations();
    }

    static testMethod void testMarkParticipationAsAttended() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testMarkParticipationAsAttended();
    }

    static testMethod void testDeleteParticipationRecord() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testDeleteParticipationRecord();

    }

    static testMethod void testGetAttendeeLists() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testGetAttendeeLists();

    }

    static testMethod void testGetDegreeAndYearNeeded() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testGetDegreeAndYearNeeded();
    }

    static testMethod void testGetDocumentTitle() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testGetDocumentTitle();
    }

    static testMethod void testEventCheckIn() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEventManagementControllerTestClass().testEventCheckIn();
    }
}