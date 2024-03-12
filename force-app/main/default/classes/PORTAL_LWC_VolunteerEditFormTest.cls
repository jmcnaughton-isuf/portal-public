@isTest
public class PORTAL_LWC_VolunteerEditFormTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testInitializeVolunteerEditForm() {
            PORTAL_LWC_VolunteerEditForm.SERVER_initializeVolunteerEditForm(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerEditForm.SERVER_initializeVolunteerEditForm(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerEditForm.SERVER_initializeVolunteerEditForm(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testUpdateVolunteerInformation() {
            PORTAL_LWC_VolunteerEditForm.SERVER_updateVolunteerInformation(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerEditForm.SERVER_updateVolunteerInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerEditForm.SERVER_updateVolunteerInformation(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testInitializeVolunteerEditForm() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerEditFormTestClass().testInitializeVolunteerEditForm();
    }

    static testMethod void testUpdateVolunteerInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerEditFormTestClass().testUpdateVolunteerInformation();
    }
}