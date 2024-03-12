@isTest
public inherited sharing class PORTAL_AddressWrapperTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public final String STREET_LINE_1 = 'streetLine1';
        public final String STREET_LINE_2 = 'streetLine2';
        public final String STREET_LINE_3 = 'streetLine3';
        public final String CITY_CONST = 'city';
        public final String STATE_CONST = 'state';
        public final String COUNTRY_CONST = 'country';
        public final String POSTAL_CODE = 'postalCode';
        public final String DISTANCE_CONST = 'distance';

        public virtual void testAddressWrapper() {
            PORTAL_AddressWrapper address = new PORTAL_AddressWrapper();

            address = new PORTAL_AddressWrapper(new Map<Object, Object>{PORTAL_AddressWrapper.STREET_LINE_1 => 'test',
                                                                        PORTAL_AddressWrapper.STREET_LINE_2 => 'test2',
                                                                        PORTAL_AddressWrapper.STREET_LINE_3 => 'test3',
                                                                        PORTAL_AddressWrapper.CITY_CONST => 'city',
                                                                        PORTAL_AddressWrapper.STATE_CONST => 'state',
                                                                        PORTAL_AddressWrapper.COUNTRY_CONST => 'country',
                                                                        PORTAL_AddressWrapper.POSTAL_CODE => 'postCode',
                                                                        PORTAL_AddressWrapper.DISTANCE_CONST => '20'});
            String singleLineAddress = address.toString();

            Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String> locationFieldMapping = new Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String>{
                PORTAL_AddressWrapper.ADDRESS_FIELD.STREET1 => 'Street__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.STREET2 => 'Street_2__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.STREET3 => 'Street_3__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.CITY => 'City__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.STATE => 'State__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.COUNTRY => 'Country__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.POSTCODE => 'Postal_Code__c',
                PORTAL_AddressWrapper.ADDRESS_FIELD.GEOLOCATION => 'Geolocation__c'
            };

            String queryClause = address.toQueryClause(locationFieldMapping);

            address = new PORTAL_AddressWrapper(new Map<Object, Object>{PORTAL_AddressWrapper.STREET_LINE_1 => 'test',
                                                                        PORTAL_AddressWrapper.STREET_LINE_2 => 'test2',
                                                                        PORTAL_AddressWrapper.STREET_LINE_3 => 'test3',
                                                                        PORTAL_AddressWrapper.CITY_CONST => 'city',
                                                                        PORTAL_AddressWrapper.STATE_CONST => 'state',
                                                                        PORTAL_AddressWrapper.COUNTRY_CONST => 'country',
                                                                        PORTAL_AddressWrapper.POSTAL_CODE => 'postCode',
                                                                        PORTAL_AddressWrapper.DISTANCE_CONST => ''});

            queryClause = address.toQueryClause(locationFieldMapping);
            Object nullObject = null;
            address = new PORTAL_AddressWrapper(nullObject);
            queryClause = address.toQueryClause(null);
        }

        public virtual void testGeolocationQueryClause() {
            PORTAL_AddressWrapper address = new PORTAL_AddressWrapper(new Map<Object, Object>{PORTAL_AddressWrapper.STREET_LINE_1 => 'test',
                                                                                              PORTAL_AddressWrapper.STREET_LINE_2 => 'test2',
                                                                                              PORTAL_AddressWrapper.STREET_LINE_3 => 'test3',
                                                                                              PORTAL_AddressWrapper.CITY_CONST => 'city',
                                                                                              PORTAL_AddressWrapper.STATE_CONST => 'state',
                                                                                              PORTAL_AddressWrapper.COUNTRY_CONST => 'country',
                                                                                              PORTAL_AddressWrapper.POSTAL_CODE => 'postCode',
                                                                                              PORTAL_AddressWrapper.DISTANCE_CONST => '20'});
            String queryClause = address.getGeolocationQueryClause('Geolocation__c');
            queryClause = address.getGeolocationQueryClause('Geolocation__c');
            
            System.assertEquals(' DISTANCE (Geolocation__c , GEOLOCATION(20.0, 20.0), \'mi\') < 20 ', queryClause);
        }
    }

    @isTest
    public static void testAddressWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getAddressWrapperTestClass().testAddressWrapper();
    }

    @isTest
    public static void testGeolocationQueryClause() {
        PORTAL_TestClassFactory.getTestClassFactory().getAddressWrapperTestClass().testGeolocationQueryClause();
    }
}