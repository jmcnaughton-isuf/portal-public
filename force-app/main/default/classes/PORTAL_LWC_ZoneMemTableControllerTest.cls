@isTest
public class PORTAL_LWC_ZoneMemTableControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public void testGetZoneMembershipRecords() {
            PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneMembershipRecords(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneMembershipRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneMembershipRecords(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testSaveZoneMembershipRecords() {
            PORTAL_LWC_ZoneMembershipTableController.SERVER_saveZoneMembershipRecords(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneMembershipTableController.SERVER_saveZoneMembershipRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneMembershipTableController.SERVER_saveZoneMembershipRecords(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testGetZoneTableInformation() {
            PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneTableInformation(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneTableInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneTableInformation(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testGetZoneMembershipRecords(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneMemTableControllerTestClass().testGetZoneMembershipRecords();
    }

    static testMethod void testSaveZoneMembershipRecords(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneMemTableControllerTestClass().testSaveZoneMembershipRecords();
    }

    static testMethod void testGetZoneTableInformation(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneMemTableControllerTestClass().testGetZoneTableInformation();
    }

}