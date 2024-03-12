@isTest
public with sharing class PORTAL_AddressServiceHubCtrlBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetAutocompleteSuggestions() {
            PORTAL_AddressServiceHubControllerBase controller; 
            
            try {
                controller = new PORTAL_AddressServiceHubControllerBase();
                System.assert(false);
            }
            catch (Exception e) { }

            ucinn_ascendv2__Address_Service_Providers__c provider = new ucinn_ascendv2__Address_Service_Providers__c(
                Name = PORTAL_AddressServiceHubControllerBase.ADDRESS_SERVICE_PROVIDER,
                ucinn_ascendv2__Autocomplete_Provider__c = PORTAL_AddressServiceHubControllerBase.SMARTY_STREETS
            );
            insert provider;

            controller = new PORTAL_AddressServiceHubControllerBase();
            controller = new PORTAL_AddressServiceHubControllerBase();

            try {
                controller.getAutocompleteSuggestions(null);
                System.assert(false);
            }
            catch (Exception e) { }
        }
    }

    @isTest
    public static void testGetAutocompleteSuggestions() {
        PORTAL_TestClassFactory.getTestClassFactory().getAddressServiceHubCtrlBaseTestClass().testGetAutocompleteSuggestions();
    }
}