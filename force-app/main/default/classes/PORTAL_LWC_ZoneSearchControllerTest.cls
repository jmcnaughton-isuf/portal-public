@isTest
public class PORTAL_LWC_ZoneSearchControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public void testInitZoneSearch() {
            PORTAL_LWC_ZoneSearchController.SERVER_initZoneSearch(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneSearchController.SERVER_initZoneSearch(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneSearchController.SERVER_initZoneSearch(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public void testGetZoneRecords() {
            PORTAL_LWC_ZoneSearchController.SERVER_getZoneRecords(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ZoneSearchController.SERVER_getZoneRecords(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ZoneSearchController.SERVER_getZoneRecords(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testInitZoneSearch(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneSearchControllerTestClass().testInitZoneSearch();
    }

    static testMethod void testGetZoneRecords(){
        PORTAL_TestClassFactory.getTestClassFactory().getLwcZoneSearchControllerTestClass().testGetZoneRecords();
    }
}