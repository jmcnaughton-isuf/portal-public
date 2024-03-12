@isTest
global class PORTAL_GoogleGeocodingApiTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_HttpMockCallout mockcallouts;

        public virtual void setup() {
            mockcallouts = new PORTAL_HttpMockCallout();
        }

        public virtual void generateTokenTest() {
            PORTAL_GoogleGeocodingApi googleApi;

            try {
                googleApi = new PORTAL_GoogleGeocodingApi();
            }
            catch (PORTAL_GoogleGeocodingApi.GoogleGeocodingException e) {

            }

            try {
                googleApi.generateToken();
            }
            catch (PORTAL_GoogleGeocodingApi.GoogleGeocodingException e) {

            }
        }

        public virtual  void geolocateSingleLineAddressTest() {
            Test.startTest();
            setup();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
            PORTAL_GoogleGeocodingApi googleApi = new PORTAL_GoogleGeocodingApi();
            String address = '2855 Michelle Dr.';

            googleApi.geolocateSingleLineAddress(null, null);

            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.4224764,"lng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            googleApi.geolocateSingleLineAddress(address);

            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.4224764,"lng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token + '&test=test');
            googleApi.geolocateSingleLineAddress(address, new Map<String, String>{'test' => 'test'});


            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.4224764,"lng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            googleApi.geolocateSingleLineAddress(address);


            mockcallouts.addRequest('{"statuscode":"400","status":"REQUEST_DENIED"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            try {
                googleApi.geolocateSingleLineAddress(address);
            }
            catch (PORTAL_GoogleGeocodingApi.GoogleGeocodingException e) {
            }

            // no lat/long
            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location":{"nolat":37.4224764,"nolng":-122.0842499},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            googleApi.geolocateSingleLineAddress(address);

            // no location
            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry":{"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4238253802915,"lng":-122.0829009197085},"southwest":{"lat":37.4211274197085,"lng":-122.0855988802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            googleApi.geolocateSingleLineAddress(address);

            // no geometry
            mockcallouts.addRequest('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Pkwy","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","plus_code":{"compound_code":"CWC8+W5 Mountain View, California, United States","global_code":"849VCWC8+W5"},"types":["street_address"]}],"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            googleApi.geolocateSingleLineAddress(address);

            // no results
            mockcallouts.addRequest('{"status":"OK"}',
                                    'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + PORTAL_GoogleGeocodingApi.token);
            googleApi.geolocateSingleLineAddress(address);
            Test.stopTest();
        }
    }


    @isTest
    global static void generateTokenTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGoogleGeocodingApiTestClass().generateTokenTest();
    }

    @isTest
    global static void geolocateSingleLineAddressTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGoogleGeocodingApiTestClass().geolocateSingleLineAddressTest();
    }
}