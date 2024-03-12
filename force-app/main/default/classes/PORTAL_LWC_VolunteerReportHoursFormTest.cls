@isTest
public class PORTAL_LWC_VolunteerReportHoursFormTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testInitializeReportHoursForm() {
            PORTAL_LWC_VolunteerReportHoursForm.SERVER_initializeReportHoursForm(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerReportHoursForm.SERVER_initializeReportHoursForm(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerReportHoursForm.SERVER_initializeReportHoursForm(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testReportVolunteerHours() {
            PORTAL_LWC_VolunteerReportHoursForm.SERVER_reportVolunteerHours(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerReportHoursForm.SERVER_reportVolunteerHours(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerReportHoursForm.SERVER_reportVolunteerHours(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    static testMethod void testInitializeReportHoursForm() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerReportHoursFormTestClass().testInitializeReportHoursForm();
    }

    static testMethod void testReportVolunteerHours() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerReportHoursFormTestClass().testReportVolunteerHours();

    }
}