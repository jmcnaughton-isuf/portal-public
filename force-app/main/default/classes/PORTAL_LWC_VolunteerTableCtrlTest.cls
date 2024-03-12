@isTest
public class PORTAL_LWC_VolunteerTableCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetVolunteerRecords() {
            PORTAL_LWC_VolunteerTableController.SERVER_getVolunteerRecords(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_VolunteerTableController.SERVER_getVolunteerRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_VolunteerTableController.SERVER_getVolunteerRecords(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

    }
    static testMethod void testGetVolunteerRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerTableCtrlTestClass().testGetVolunteerRecords();
    }
}