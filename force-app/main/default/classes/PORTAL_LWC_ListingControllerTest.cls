@isTest
public class PORTAL_LWC_ListingControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetListings() {
            PORTAL_LWC_ListingController.SERVER_getListings(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getListings(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getListings(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetListingConfigurations() {
            PORTAL_LWC_ListingController.SERVER_getListingConfigurations(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getListingConfigurations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getListingConfigurations(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetListingButtonText() {
            PORTAL_LWC_ListingController.SERVER_getListingButtonText(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getListingButtonText(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getListingButtonText(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testUpdateRecommmedationEngine() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();

            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                Recommend_Type_2__c = 'Culture',
                                                                                Recommend_Type_3__c = 'Global',
                                                                                Recommend_Type_4__c = 'History',
                                                                                Recommend_Type_5__c = 'Space',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'a');
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;

            PORTAL_LWC_ListingController.SERVER_updateRecommendationEngine(new Map<String, Object>{PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY => testListing.Id, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_updateRecommendationEngine(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_updateRecommendationEngine(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testUpdateActionOnContent() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();

            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                Recommend_Type_2__c = 'Culture',
                                                                                Recommend_Type_3__c = 'Global',
                                                                                Recommend_Type_4__c = 'History',
                                                                                Recommend_Type_5__c = 'Space',
                                                                                RecordTypeId = recordTypeId,
                                                                                Portal_Zone__c = 'All',
                                                                                Name = 'a');
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;

            PORTAL_LWC_ListingController.SERVER_updateActionOnContent(new Map<String, Object>{PORTAL_ListingControllerBase.ACTION_TO_TAKE_KEY => 'bookmark', PORTAL_CONST_ActionOnContent.LISTING_ID_KEY => testListing.Id, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_updateActionOnContent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_updateActionOnContent(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetFrontEndDataMap() {
            PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap(null);
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testGetListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingControllerTestClass().testGetListings();
    }

    static testMethod void testGetListingConfigurations() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingControllerTestClass().testGetListingConfigurations();
    }

    static testMethod void testGetListingButtonText() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingControllerTestClass().testGetListingButtonText();
    }

    static testMethod void testUpdateRecommmedationEngine() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingControllerTestClass().testUpdateRecommmedationEngine();
    }

    static testMethod void testUpdateActionOnContent() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingControllerTestClass().testUpdateActionOnContent();
    }

    static testMethod void testGetFrontEndDataMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcListingControllerTestClass().testGetFrontEndDataMap();
    }
}