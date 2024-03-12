@isTest
public class PORTAL_LWC_VolunteerInformationTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetVolunteerInformation() {
            PORTAL_LWC_VolunteerInformation.SERVER_getVolunteerInformation(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerInformation.SERVER_getVolunteerInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerInformation.SERVER_getVolunteerInformation(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testGetVolunteerInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerInformationTestClass().testGetVolunteerInformation();
    }
}