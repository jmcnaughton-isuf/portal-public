@isTest
public with sharing class PORTAL_SmartyStreetsAddressServiceTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetInternationalAutocompleteConfigurationMap() {
            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();

            Map<String, Object> configurationMap = controller.getInternationalAutocompleteConfigurationMap(null);
            System.assertEquals('', (String) ((Map<String, Object>) configurationMap.get(PORTAL_SmartyStreetsAddressService.COUNTRY_CODE_MAP)).get(PORTAL_SmartyStreetsAddressService.UNITED_STATES));
            System.assertEquals(PORTAL_SmartyStreetsAddressService.UNITED_STATES, (String) configurationMap.get(PORTAL_SmartyStreetsAddressService.DEFAULT_COUNTRY));
            System.assert((Boolean) configurationMap.get(PORTAL_SmartyStreetsAddressService.HAS_INTERNATIONAL_AUTOCOMPLETE));
        }

        public virtual void testInvalidGetCustomMetadataRecordList() {
            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();

            Test.startTest();
            try {
                controller.getCustomMetadataRecordList(null, null, null, '');
                System.assert(false);
            }
            catch (Exception e) { }

            try {
                controller.getCustomMetadataRecordList(
                    PORTAL_SmartyStreetsAddressService.BIO_DEMO_SETTING_MDT,
                    new Set<String>{PORTAL_SmartyStreetsAddressService.ENABLE_INTERNATIONAL_AUTOCOMPLETE_C},
                    new List<String>{PORTAL_SmartyStreetsAddressService.BIO_DEMO_SETTING, PORTAL_SmartyStreetsAddressService.BIO_DEMO_SETTING},
                    'error'
                );
                System.assert(false);
            }
            catch (Exception e) { }
        }

        public virtual void testGetAutocompleteAuthentication() {
            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();

            Test.startTest();
            String authentication = controller.getAutocompleteAuthentication(false);
            Test.stopTest();

            System.assert(authentication == PORTAL_SmartyStreetsAddressService.AUTH_ID + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                                            PORTAL_SmartyStreetsAddressService.AUTH_TOKEN + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST);
        }

        public virtual void testGetAutocompleteSuggestions() {
            // can generate responses for queries with https://www.smarty.com/products/apis/us-autocomplete-pro-api
            String searchResponse = '{"suggestions":[{"street_line":"123 1/2 E Maple Ave","secondary":"","city":"Adrian","state":"MI","zipcode":"49221","entries":0},{"street_line":"123 1/2 E Maple Ave","secondary":"Apt","city":"Adrian","state":"MI","zipcode":"49221","entries":2},{"street_line":"123 1/2 N Maple Ave","secondary":"","city":"Green Bay","state":"WI","zipcode":"54303","entries":0}]}';
            String selectedResponse = '{"suggestions":[{"street_line":"123 1/2 E Maple Ave","secondary":"Apt 1","city":"Adrian","state":"MI","zipcode":"49221","entries":1},{"street_line":"123 1/2 E Maple Ave","secondary":"Apt 2","city":"Adrian","state":"MI","zipcode":"49221","entries":1}]}';

            String searchString = '123 1/2 E Maple Ave';
            String selectedString = '123 1/2 E Maple Ave Apt (2) Adrian MI 49221';

            String searchEndpoint = PORTAL_SmartyStreetsAddressService.AUTH_ID + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                                    PORTAL_SmartyStreetsAddressService.AUTH_TOKEN + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                                    PORTAL_SmartyStreetsAddressService.SEARCH_CONST + '=' + EncodingUtil.urlEncode(searchString, PORTAL_SmartyStreetsAddressService.UTF_8) + '&' +
                                    PORTAL_SmartyStreetsAddressService.MAX_RESULTS + '=' + PORTAL_SmartyStreetsAddressService.DEFAULT_MAX; 
            String selectedEndpoint = searchEndpoint;
            selectedEndpoint += '&' + PORTAL_SmartyStreetsAddressService.SELECTED_CONST + '=' + EncodingUtil.urlEncode(selectedString, PORTAL_SmartyStreetsAddressService.UTF_8);

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', searchResponse, PORTAL_SmartyStreetsAddressService.US_AUTOCOMPLETE_ENDPOINT + '?' + searchEndpoint);
            mockcallouts.addRequest(200, 'succeeded', selectedResponse, PORTAL_SmartyStreetsAddressService.US_AUTOCOMPLETE_ENDPOINT + '?' + selectedEndpoint);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_AddressServiceInterface.SEARCH_INPUT, searchString);
            PORTAL_AddressServiceInterface.AutocompleteQuery searchQuery = controller.buildAutocompleteQuery(params);
            params.put(PORTAL_AddressServiceInterface.SEARCH_SELECTION, selectedString);
            params.put(PORTAL_AddressServiceInterface.COUNTRY_CONST, 'USA');
            PORTAL_AddressServiceInterface.AutocompleteQuery selectedQuery = controller.buildAutocompleteQuery(params);

            Test.startTest();
            List<PORTAL_AddressWrapper> suggestions = controller.getAutocompleteSuggestions(searchQuery);
            System.assertEquals(3, suggestions.size());
            suggestions = controller.getAutocompleteSuggestions(selectedQuery);
            System.assertEquals(2, suggestions.size());
            Test.stopTest();
        }

        public virtual void testInvalidGetAutocompleteSuggestions() {
            String errorResponse = '{"errors":[{"id":1588026162,"message":"Active subscription required (1588026162): The optional license value supplied (if any) was valid and understood, but the account does not have the necessary active subscription to allow this operation to continue."}]}';
            String searchString = '123 1/2 E Maple Ave';
            String searchEndpoint = PORTAL_SmartyStreetsAddressService.AUTH_ID + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                                    PORTAL_SmartyStreetsAddressService.AUTH_TOKEN + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                                    PORTAL_SmartyStreetsAddressService.SEARCH_CONST + '=' + EncodingUtil.urlEncode(searchString, PORTAL_SmartyStreetsAddressService.UTF_8) + '&' +
                                    PORTAL_SmartyStreetsAddressService.MAX_RESULTS + '=' + PORTAL_SmartyStreetsAddressService.DEFAULT_MAX; 

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(402, 'error', errorResponse, PORTAL_SmartyStreetsAddressService.US_AUTOCOMPLETE_ENDPOINT + '?' + searchEndpoint);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();
            Map<String, Object> params = new Map<String, Object>();
            PORTAL_AddressServiceInterface.AutocompleteQuery emptyQuery = controller.buildAutocompleteQuery(params);
            params.put(PORTAL_AddressServiceInterface.SEARCH_INPUT, searchString);
            PORTAL_AddressServiceInterface.AutocompleteQuery searchQuery = controller.buildAutocompleteQuery(params);

            Test.startTest();
            try {
                controller.getAutocompleteSuggestions(emptyQuery);
                System.assert(false);
            }
            catch (Exception e) { }

            try {
                controller.getAutocompleteSuggestions(searchQuery);
                System.assert(false);
            }
            catch (Exception e) { }
            Test.stopTest();
        }

        public virtual void testGetInternationalAutocompleteSuggestions() {
            // can generate responses for queries with https://www.smarty.com/products/apis/international-address-autocomplete-api
            String response = '{"candidates":[{"street":"Downing Street","locality":"Nottingham","postal_code":"NG6 8JU","country_iso3":"GBR"},{"street":"Downing Street","locality":"Sutton-In-Ashfield","postal_code":"NG17 4EF","country_iso3":"GBR"},{"street":"10 Downing Street","locality":"Halesowen","administrative_area":"West Midlands","postal_code":"B63 3TA","country_iso3":"GBR"},{"street":"10 Downing Street","locality":"Cambridge","administrative_area":"Cambridgeshire","postal_code":"CB2 3BJ","country_iso3":"GBR"}]}';
            String input = '10 Downing';
            String country = 'GBR';

            String endpoint = PORTAL_SmartyStreetsAddressService.COUNTRY_CONST_REQUEST + '=' + country + '&' + 
                              PORTAL_SmartyStreetsAddressService.AUTH_ID + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                              PORTAL_SmartyStreetsAddressService.AUTH_TOKEN + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                              PORTAL_SmartyStreetsAddressService.SEARCH_CONST + '=' + EncodingUtil.urlEncode(input, PORTAL_SmartyStreetsAddressService.UTF_8) + '&' +
                              PORTAL_SmartyStreetsAddressService.MAX_RESULTS + '=' + PORTAL_SmartyStreetsAddressService.DEFAULT_MAX; 

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', response, PORTAL_SmartyStreetsAddressService.INTERNATIONAL_AUTOCOMPLETE_ENDPOINT + '?' + endpoint);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();
            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_AddressServiceInterface.SEARCH_INPUT, input);
            params.put(PORTAL_AddressServiceInterface.COUNTRY_CONST, country);
            PORTAL_AddressServiceInterface.AutocompleteQuery query = controller.buildAutocompleteQuery(params);

            Test.startTest();
            List<PORTAL_AddressWrapper> candidates = controller.getAutocompleteSuggestions(query);
            System.assertEquals(4, candidates.size());
            Test.stopTest();
        }

        public virtual void testUSAddressVerification() {
            // can generate responses for queries with https://www.smarty.com/products/apis/us-street-api
            String response = '[{"input_index": 0,"candidate_index": 0,"delivery_line_1": "10880 Malibu Point","last_line": "Malibu CA 90265","delivery_point_barcode": "90265","components": { "primary_number": "10880", "street_name": "Malibu", "street_suffix": "Pt", "city_name": "Malibu", "default_city_name": "Malibu", "state_abbreviation": "CA", "zipcode": "90265" }, "metadata": { "zip_type": "Standard", "county_fips": "06037", "county_name": "Los Angeles", "latitude": 34.0399, "longitude": -118.75883, "precision": "Zip5", "time_zone": "Pacific", "utc_offset": -8, "dst": true }, "analysis": { "dpv_footnotes": "A1", "active": "Y", "footnotes": "F#"}}]';
            String endpoint = PORTAL_SmartyStreetsAddressService.US_VERIFICATION_ENDPOINT + PORTAL_SmartyStreetsAddressService.AUTH_ID + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                              PORTAL_SmartyStreetsAddressService.AUTH_TOKEN + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                              'candidates=10&match=invalid&street=10880+Malibu+Point&city=Malibu&state=California&zipcode=90265';

            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', response, endpoint);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            Map<String, Object> addressAsMap = new Map<String, Object>();
            addressAsMap.put('ucinn_ascendv2__Address_Line_1__c', '10880 Malibu Point');
            addressAsMap.put('ucinn_ascendv2__City__c', 'Malibu');
            addressAsMap.put('ucinn_ascendv2__State__c', 'California');
            addressAsMap.put('ucinn_ascendv2__Postal_Code__c', '90265');

            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();

            Test.startTest();
            Map<String, Object> resultMap = controller.getAddressVerificationInformation(addressAsMap);
            System.assertEquals(1, resultMap.size());
            List<PORTAL_SmartyStreetsAddressService.AddressResponse> addressResponseList = (List<PORTAL_SmartyStreetsAddressService.AddressResponse>)resultMap?.get(PORTAL_SmartyStreetsAddressService.ADDRESS_INFORMATION);
            Decimal latitudeTest = (Decimal)addressResponseList.get(0)?.metadata?.get(PORTAL_SmartyStreetsAddressService.LATITUDE_CONST);
            Test.stopTest();
        }

        public virtual void testInternationalAddressVerification() {
            // can generate responses for queries with https://www.smarty.com/products/apis/international-street-api
            String response = '[{ "address1": "42-43 Kings Road Arches", "address2": "Brighton", "address3": "BN1 2LN", "components": { "administrative_area": "East Sussex", "country_iso_3": "GBR", "locality": "Brighton", "postal_code": "BN1 2LN", "postal_code_short": "BN1 2LN", "premise": "42-43", "premise_number": "42-43", "thoroughfare": "Kings Road Arches" }, "metadata": { "latitude": 50.821722, "longitude": -0.152076, "geocode_precision": "Premise", "max_geocode_precision": "Premise", "address_format": "premise thoroughfare|locality|postal_code" }, "analysis": { "verification_status": "Verified", "address_precision": "DeliveryPoint", "max_address_precision": "DeliveryPoint", "changes": { "components": { "administrative_area": "Added", "country_iso_3": "Added", "locality": "Verified-NoChange", "postal_code": "Verified-NoChange", "postal_code_short": "Verified-NoChange", "premise": "Verified-NoChange", "premise_number": "Verified-NoChange", "thoroughfare": "Verified-NoChange"}}}}]';
            String endpoint = PORTAL_SmartyStreetsAddressService.INTERNATIONAL_VERIFICATION_ENDPOINT + PORTAL_SmartyStreetsAddressService.AUTH_ID + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&' + 
                              PORTAL_SmartyStreetsAddressService.AUTH_TOKEN + '=' + PORTAL_SmartyStreetsAddressService.TEST_CONST + '&geocode=true&' + 
                              'country=United+Kingdom&address1=42-43%2C+Kings+Road+Arches&locality=Brighton&postal_code=BN1+2LN';


            PORTAL_HttpMockCallout mockcallouts = new PORTAL_HttpMockCallout();
            mockcallouts.addRequest(200, 'succeeded', response, endpoint);
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            Map<String, Object> addressAsMap = new Map<String, Object>();
            addressAsMap.put('ucinn_ascendv2__Address_Line_1__c', '42-43, Kings Road Arches');
            addressAsMap.put('ucinn_ascendv2__City__c', 'Brighton');
            addressAsMap.put('ucinn_ascendv2__Country__c', 'United Kingdom');
            addressAsMap.put('ucinn_ascendv2__Postal_Code__c', 'BN1 2LN');

            PORTAL_SmartyStreetsAddressService controller = new PORTAL_SmartyStreetsAddressService();

            Test.startTest();
            Map<String, Object> resultMap = controller.getAddressVerificationInformation(addressAsMap);
            System.assertEquals(1, resultMap.size());
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testGetInternationalAutocompleteConfigurationMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testGetInternationalAutocompleteConfigurationMap();
    }

    @isTest
    public static void testInvalidGetCustomMetadataRecordList() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testInvalidGetCustomMetadataRecordList();
    }

    @isTest
    public static void testGetAutocompleteAuthentication() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testGetAutocompleteAuthentication();
    }

    @isTest
    public static void testGetAutocompleteSuggestions() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testGetAutocompleteSuggestions();
    }

    @isTest
    public static void testInvalidGetAutocompleteSuggestions() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testInvalidGetAutocompleteSuggestions();
    }

    @isTest
    public static void testGetInternationalAutocompleteSuggestions() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testGetInternationalAutocompleteSuggestions();
    }

    @isTest
    public static void testUSAddressVerification() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testUSAddressVerification();
    }

    @isTest
    public static void testInternationalAddressVerification() {
        PORTAL_TestClassFactory.getTestClassFactory().getSmartyStreetsAddressServiceTestClass().testInternationalAddressVerification();
    }
}