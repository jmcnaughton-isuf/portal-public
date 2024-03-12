@isTest
public class PORTAL_LWC_ListingDetailControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetListingDetailsById() {
            Map<String, Object> params = new Map<String, Object>{'recordId' => 'Test Id'};

            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_ListingDetailController.SERVER_getListingDetailsById(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetListingDetailsByIdInvalidId() {
            Map<String, Object> params = new Map<String, Object>{'recordId' => ''};

            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_ListingDetailController.SERVER_getListingDetailsById(params);
            } catch (AuraHandledException ahe) {
                System.assert(!String.isBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetListingDetailsByName() {
            Map<String, Object> params = new Map<String, Object>{'recordName' => 'Test Name'};

            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_ListingDetailController.SERVER_getListingDetailsByName(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetListingDetailsByNameInvalidName() {
            Map<String, Object> params = new Map<String, Object>{'recordName' => ''};

            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_ListingDetailController.SERVER_getListingDetailsByName(params);
            } catch (AuraHandledException ahe) {
                System.assert(!String.isBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetUserProfileName() {
            Map<String, Object> params = new Map<String, Object>{'recordId' => 'Test Id'};

            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_ListingDetailController.SERVER_getUserProfileName(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetUserProfileNameInvalidId() {
            Map<String, Object> params = new Map<String, Object>{'recordId' => ''};

            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_ListingDetailController.SERVER_getUserProfileName(params);
            } catch (AuraHandledException ahe) {
                System.assert(!String.isBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetLookWhosComingList() {
            Test.startTest();

            System.assertEquals(0, PORTAL_LWC_ListingDetailController.SERVER_getLookWhosComingList(null).size());

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingDetailController.SERVER_getLookWhosComingList(null);
                System.assert(false);
            } catch (AuraHandledException ahe) { }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingDetailController.SERVER_getLookWhosComingList(null);
                System.assert(false);
            } catch (Exception e) { }

            Test.stopTest();
        }
    }


    static testMethod void testGetListingDetailsById() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetListingDetailsById();
    }

    static testMethod void testGetListingDetailsByIdInvalidId() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetListingDetailsByIdInvalidId();
    }

    static testMethod void testGetListingDetailsByName() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetListingDetailsByName();
    }

    static testMethod void testGetListingDetailsByIdInvalidName() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetListingDetailsByNameInvalidName();
    }

    static testMethod void testGetUserProfileName() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetUserProfileName();
    }

    static testMethod void testGetUserProfileNameInvalidId() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetUserProfileNameInvalidId();
    }

    /**
     * test LWC controller look who's coming
     * @author Jacob Huang
     * @since 1.1
     */
    static testMethod void testGetLookWhosComingList() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingDetailControllerTestClass().testGetLookWhosComingList();
    }
}