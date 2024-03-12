@isTest
global class PORTAL_BATCH_AddressGeocodingTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_HttpMockCallout mockcallouts;
        public List<ucinn_ascendv2__Address__c> addresses;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            mockcallouts = new PORTAL_HttpMockCallout();
            addresses = new List<ucinn_ascendv2__Address__c>();
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(
                ucinn_ascendv2__Address_Line_1__c = '2855',
                ucinn_ascendv2__Address_Line_2__c = 'Michelle',
                ucinn_ascendv2__Address_Line_3__c = 'Drive',
                ucinn_ascendv2__Address_Line_4__c = '.',
                ucinn_ascendv2__City__c = 'Glendale',
                ucinn_ascendv2__Postal_Code__c = '92618',
                ucinn_ascendv2__State__c = 'California'
            );
            address = (ucinn_ascendv2__Address__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => address});
            addresses.add(address);

            insert addresses;
        }


        public virtual void testArcGisBatch() {
            setupData();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            String testToken = 'sVTestcx123';
            String jsonBody = '{"spatialReference":{"wkid":4326,"latestWkid":4326},"locations":[{"address":"5110 Oak Leaf Ave, Carmichael, California, 95608",'+
            '"location":{"x":-121.34552399999995,"y":38.601135000000056},"score":100,"attributes":{"ResultID":1,"Loc_name":"World","Status":"M","Score":100,"Match_addr":"5110 Oak Leaf Ave, Carmichael, California, 95608",'+
            '"LongLabel":"5110 Oak Leaf Ave, Carmichael, CA, 95608, USA","ShortLabel":"5110 Oak Leaf Ave","Addr_type":"PointAddress","Type":"","PlaceName":"","Place_addr":"5110 Oak Leaf Ave, Carmichael, California, 95608","Phone":"","URL":"","Rank":20,"AddBldg":"",'+
            '"AddNum":"5110","AddNumFrom":"","AddNumTo":"","AddRange":"","Side":"","StPreDir":"","StPreType":"","StName":"Oak Leaf","StType":"Ave","StDir":"","BldgType":"","BldgName":"","LevelType":"","LevelName":"","UnitType":"","UnitName":"","SubAddr":"",'+
            '"StAddr":"5110 Oak Leaf Ave","Block":"","Sector":"","Nbrhd":"","District":"","City":"Carmichael","MetroArea":"","Subregion":"Sacramento County","Region":"California","RegionAbbr":"CA","Territory":"","Zone":"","Postal":"95608","PostalExt":"5415","Country":"USA",'+
            '"LangCode":"ENG","Distance":0,"X":-121.345524,"Y":38.601134999999999,"DisplayX":-121.345524,"DisplayY":38.601134999999999,"Xmin":-121.346524,"Xmax":-121.34452399999999,"Ymin":38.600135000000002,"Ymax":38.602134999999997,"ExInfo":""}}]}';

            mockcallouts.addRequest(jsonBody, PORTAL_ArcGisApi.ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/geocodeAddresses?f=json');

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_ArcGisAddressGeocoding(PORTAL_CONST_GeocodingFields.ADDRESS_API_NAME, PORTAL_CONST_GeocodingFields.ADDRESS_GEOLOCATION_FIELDS, PORTAL_CONST_GeocodingFields.ADDRESS_FIELDS));
            Test.stopTest();
        }

        public virtual void testGoogleBatch() {
            setupData();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            PORTAL_GoogleGeocodingApi googleApi = new PORTAL_GoogleGeocodingApi();
            PORTAL_AddressGeocodingBatchBase geocodingBatchBase = (PORTAL_AddressGeocodingBatchBase)PORTAL_Utils.getControllerFactory().getAddressGeocodingBatchBase();
            geocodingBatchBase.sobjectAPIName = PORTAL_CONST_GeocodingFields.ADDRESS_API_NAME;
            geocodingBatchBase.geolocationFieldSet = PORTAL_CONST_GeocodingFields.ADDRESS_GEOLOCATION_FIELDS;
            geocodingBatchBase.fieldMap = PORTAL_CONST_GeocodingFields.ADDRESS_FIELDS;

            List<Map<String, String>> formattedAddresses = geocodingBatchBase.formatAddresses(addresses);
            String address = formattedAddresses[0].get(PORTAL_AddressGeocodingBatchBase.ADDRESS_KEY);

            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.4224764,"lng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
            'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_GoogleAddressGeocoding(PORTAL_CONST_GeocodingFields.ADDRESS_API_NAME, PORTAL_CONST_GeocodingFields.ADDRESS_GEOLOCATION_FIELDS, PORTAL_CONST_GeocodingFields.ADDRESS_FIELDS));
            Test.stopTest();
        }
    }

    @isTest
    global static void testArcGisBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getAddressGeocodingTestClass().testArcGisBatch();
    }

    @isTest
    global static void testGoogleBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getAddressGeocodingTestClass().testGoogleBatch();
    }
}