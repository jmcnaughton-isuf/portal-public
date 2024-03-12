@isTest
public with sharing class PORTAL_LWC_AddressServiceHubCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void setupData() {
            ucinn_ascendv2__Address_Service_Providers__c provider = new ucinn_ascendv2__Address_Service_Providers__c(
                Name = PORTAL_AddressServiceHubControllerBase.ADDRESS_SERVICE_PROVIDER,
                ucinn_ascendv2__Autocomplete_Provider__c = PORTAL_AddressServiceHubControllerBase.SMARTY_STREETS
            );
            insert provider;
        }

        public virtual void testGetInternationalAutocompleteConfigurationMap() {
            setupData();

            PORTAL_LWC_AddressServiceHubController.SERVER_getInternationalAutocompleteConfigurationMap(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_AddressServiceHubController.SERVER_getInternationalAutocompleteConfigurationMap(null);
                System.assert(false);
            }
            catch (Exception e) { }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_AddressServiceHubController.SERVER_getInternationalAutocompleteConfigurationMap(null);
                System.assert(false);
            }
            catch (Exception e) { }
        }

        public virtual void testGetAutocompleteSuggestions() {
            setupData();

            try {
                PORTAL_LWC_AddressServiceHubController.SERVER_getAutocompleteSuggestions(null);
                System.assert(false);
            }
            catch (Exception e) { }
            
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_AddressServiceHubController.SERVER_getAutocompleteSuggestions(null);
                System.assert(false);
            }
            catch (Exception e) { }
        }
    }

    @isTest
    public static void testGetInternationalAutocompleteConfigurationMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcAddressServiceHubCtrlTestClass().testGetInternationalAutocompleteConfigurationMap();
    }

    @isTest
    public static void testGetAutocompleteSuggestions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcAddressServiceHubCtrlTestClass().testGetAutocompleteSuggestions();
    }
}