@isTest
public with sharing class PORTAL_LWC_MyInformationV2ControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {        
        public virtual void testGetViewInfo() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetEditInfo() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo(new Map<String, Object>());
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testSaveInformation() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_saveInformation(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_saveInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_saveInformation(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testSelfReportInformation() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_selfReportInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_selfReportInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_selfReportInformation(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testSearchServiceIndicatorValues() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_searchServiceIndicatorValues(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_searchServiceIndicatorValues(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_searchServiceIndicatorValues(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        
        public virtual void testIsDisplaySearchBar() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_isDisplaySearchBar(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_isDisplaySearchBar(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_isDisplaySearchBar(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetCustomMetadataConfiguration() {
            try {
                PORTAL_LWC_MyInformationV2Controller.SERVER_getCustomMetadataConfiguration(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_getCustomMetadataConfiguration(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_MyInformationV2Controller.SERVER_getCustomMetadataConfiguration(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    
    @isTest
    public static void testGetViewInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testGetViewInfo();
    }

    @isTest
    public static void testGetEditInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testGetEditInfo();
    }

    @isTest
    public static void testSaveInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testSaveInformation();
    }

    @isTest
    public static void testSearchServiceIndicatorValues() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testSearchServiceIndicatorValues();
    }

    @isTest
    public static void testIsDisplaySearchBar() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testIsDisplaySearchBar();
    }

    @isTest
    public static void testGetCustomMetadataConfiguration() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testGetCustomMetadataConfiguration();
    }

    /**
     * Code coverage for LWC controller method
     * @author Jacob Huang
     * @since 1.10
     */
    @isTest
    public static void testSelfReportInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMyInfoV2ControllerTestClass().testSelfReportInformation();
    }
}