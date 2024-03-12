@isTest
public with sharing class PORTAL_AutocompleteAddressWrapperTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testAutocompleteAddressWrapper() {
            PORTAL_AutocompleteAddressWrapper emptyAddress = new PORTAL_AutocompleteAddressWrapper();
            emptyAddress = new PORTAL_AutocompleteAddressWrapper(null);

            Map<Object, Object> params = new Map<Object, Object>{PORTAL_AddressWrapper.STREET_LINE_1 => '123 Main St',
                                                                PORTAL_AddressWrapper.STREET_LINE_2 => 'Apt 1',
                                                                PORTAL_AddressWrapper.CITY_CONST => 'Irvine',
                                                                PORTAL_AddressWrapper.STATE_CONST => 'CA',
                                                                PORTAL_AddressWrapper.COUNTRY_CONST => 'USA',
                                                                PORTAL_AddressWrapper.POSTAL_CODE => '92617',
                                                                PORTAL_AutocompleteAddressWrapper.ID_CONST => '123 Main St Apt 1',
                                                                PORTAL_AutocompleteAddressWrapper.LABEL_CONST => '123 Main St Apt 1, Irvine, CA 92617',
                                                                PORTAL_AutocompleteAddressWrapper.NUMBER_OF_SIMILAR_ENTRIES => 0};
            PORTAL_AutocompleteAddressWrapper address = new PORTAL_AutocompleteAddressWrapper(params);
        }
    }

    @isTest
    public static void testAutocompleteAddressWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getAutocompleteAddressWrapperTestClass().testAutocompleteAddressWrapper();
    }
}