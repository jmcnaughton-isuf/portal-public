@isTest
public class PORTAL_LWC_ListingSearchControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testSearchListings() {
            PORTAL_LWC_ListingSearchController.SERVER_searchListings(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingSearchController.SERVER_searchListings(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingSearchController.SERVER_searchListings(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetPicklists() {
            PORTAL_LWC_ListingSearchController.SERVER_getPicklists(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingSearchController.SERVER_getPicklists(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingSearchController.SERVER_getPicklists(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    static testMethod void testSearchListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingSearchControllerTestClass().testSearchListings();
    }

    static testMethod void testGetPicklists() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingSearchControllerTestClass().testGetPicklists();
    }
}