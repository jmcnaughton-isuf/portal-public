@isTest
global class PORTAL_ArcGisApiTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_HttpMockCallout mockcallouts;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setup() {
            mockcallouts = new PORTAL_HttpMockCallout();
        }

        public virtual void geolocateSingleLineAddressTest() {
            Test.startTest();
            setup();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_ArcGisAPI arcGis = new PORTAL_ArcGisAPI();

            arcGis.geolocateSingleLineAddress(null, null);
            String address = '2855 Michelle Dr.';

            mockcallouts.addRequest('{"spatialReference":{"wkid":4326,"latestWkid":4326},"candidates":[{"address":"380 New York St, Redlands, California, 92373","location":{"x":-117.19487199429184,"y":34.05723700023128},"score":100,"attributes":{"Loc_name":"World","Status":"M","Score":100,"Match_addr":"380 New York St, Redlands, California, 92373","LongLabel":"380 New York St, Redlands, CA, 92373, USA","ShortLabel":"380 New York St","Addr_type":"PointAddress","Type":"","PlaceName":"","Place_addr":"380 New York St, Redlands, California, 92373","Phone":"","URL":"","Rank":20,"AddBldg":"","AddNum":"380","AddNumFrom":"","AddNumTo":"","AddRange":"","Side":"","StPreDir":"","StPreType":"","StName":"New York","StType":"St","StDir":"","BldgType":"","BldgName":"","LevelType":"","LevelName":"","UnitType":"","UnitName":"","SubAddr":"","StAddr":"380 New York St","Block":"","Sector":"","Nbrhd":"","District":"","City":"Redlands","MetroArea":"","Subregion":"San Bernardino County","Region":"California","RegionAbbr":"CA","Territory":"","Zone":"","Postal":"92373","PostalExt":"8118","Country":"USA","LangCode":"ENG","Distance":0,"X":-117.19568252432872,"Y":34.05723700023128,"DisplayX":-117.19487199429184,"DisplayY":34.05723700023128,"Xmin":-117.19587199429185,"Xmax":-117.19387199429184,"Ymin":34.056237000231285,"Ymax":34.05823700023128,"ExInfo":""},"extent":{"xmin":-117.19587199429185,"ymin":34.056237000231285,"xmax":-117.19387199429184,"ymax":34.05823700023128}}]}',
                                    PORTAL_ArcGisApi.ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/findAddressCandidates?SingleLine=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&outFields=location&f=json');
            arcGis.geolocateSingleLineAddress(address);

            mockcallouts.addRequest('{"spatialReference":{"wkid":4326,"latestWkid":4326},"candidates":[{"address":"380 New York St, Redlands, California, 92373","location":{"x":-117.19487199429184,"y":34.05723700023128},"score":100,"attributes":{"Loc_name":"World","Status":"M","Score":100,"Match_addr":"380 New York St, Redlands, California, 92373","LongLabel":"380 New York St, Redlands, CA, 92373, USA","ShortLabel":"380 New York St","Addr_type":"PointAddress","Type":"","PlaceName":"","Place_addr":"380 New York St, Redlands, California, 92373","Phone":"","URL":"","Rank":20,"AddBldg":"","AddNum":"380","AddNumFrom":"","AddNumTo":"","AddRange":"","Side":"","StPreDir":"","StPreType":"","StName":"New York","StType":"St","StDir":"","BldgType":"","BldgName":"","LevelType":"","LevelName":"","UnitType":"","UnitName":"","SubAddr":"","StAddr":"380 New York St","Block":"","Sector":"","Nbrhd":"","District":"","City":"Redlands","MetroArea":"","Subregion":"San Bernardino County","Region":"California","RegionAbbr":"CA","Territory":"","Zone":"","Postal":"92373","PostalExt":"8118","Country":"USA","LangCode":"ENG","Distance":0,"X":-117.19568252432872,"Y":34.05723700023128,"DisplayX":-117.19487199429184,"DisplayY":34.05723700023128,"Xmin":-117.19587199429185,"Xmax":-117.19387199429184,"Ymin":34.056237000231285,"Ymax":34.05823700023128,"ExInfo":""},"extent":{"xmin":-117.19587199429185,"ymin":34.056237000231285,"xmax":-117.19387199429184,"ymax":34.05823700023128}}]}',
                                    PORTAL_ArcGisApi.ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/findAddressCandidates?SingleLine=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&outFields=location&f=json' + '&' + EncodingUtil.urlEncode('test', 'UTF-8') + '=' + EncodingUtil.urlEncode('test', 'UTF-8'));
            arcGis.geolocateSingleLineAddress(address, new Map<String, String>{'test' => 'test'});
            Test.stopTest();
        }

        public virtual void batchGeocodeAddressesTest() {
            setup();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_ArcGisAPI arcGis = new PORTAL_ArcGisAPI();

            ucinn_ascendv2__Address__c address1 = new ucinn_ascendv2__Address__c(
                ucinn_ascendv2__Address_Line_1__c = 'test',
                ucinn_ascendv2__City__c = 'Irvine',
                ucinn_ascendv2__State__c = 'California'
            );
            address1 = (ucinn_ascendv2__Address__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => address1});
            insert address1;

            List<Map<String, String>> formattedAddresses = new List<Map<String, String>>();
            formattedAddresses.add(new Map<String, String>{
                PORTAL_AddressGeocodingBatchBase.ADDRESS_KEY => '2855 Michelle Dr, Irvine, CA',
                PORTAL_AddressGeocodingBatchBase.ADDRESS_UNIQUE_IDENTIFER => address1.Id
            });

            formattedAddresses.add(new Map<String, String>{
                PORTAL_AddressGeocodingBatchBase.ADDRESS_KEY => '2855 Michelle Dr, Irvine, CA'
            });

            mockcallouts.addRequest('{}', PORTAL_ArcGisApi.ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/geocodeAddresses?f=json');
            Test.startTest();
            arcGis.batchGeocodeAddresses(formattedAddresses);
            arcGis.batchGeocodeAddresses(null);

            //test thrown error
            mockcallouts.addRequest('{"error":{"message":"test Error", "code":123}}', PORTAL_ArcGisApi.ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/geocodeAddresses?f=json');
            try {
                arcGis.batchGeocodeAddresses(formattedAddresses);
            } catch (Exception e) {

            }
            Test.stopTest();
        }

        public virtual void updateAddressesTest() {
            setup();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            PORTAL_ArcGisAPI arcGis = new PORTAL_ArcGisAPI();

            ucinn_ascendv2__Address__c address1 = new ucinn_ascendv2__Address__c(
                ucinn_ascendv2__Address_Line_1__c = 'test',
                ucinn_ascendv2__City__c = 'Irvine',
                ucinn_ascendv2__State__c = 'California'
            );
            address1 = (ucinn_ascendv2__Address__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => address1});
            insert address1;

            String jsonBody = '{"spatialReference":{"wkid":4326,"latestWkid":4326},"locations":[{"address":"5110 Oak Leaf Ave, Carmichael, California, 95608",'+
            '"location":{"x":-121.34552399999995,"y":38.601135000000056},"score":100,"attributes":{"ResultID":1,"Loc_name":"World","Status":"M","Score":100,"Match_addr":"5110 Oak Leaf Ave, Carmichael, California, 95608",'+
            '"LongLabel":"5110 Oak Leaf Ave, Carmichael, CA, 95608, USA","ShortLabel":"5110 Oak Leaf Ave","Addr_type":"PointAddress","Type":"","PlaceName":"","Place_addr":"5110 Oak Leaf Ave, Carmichael, California, 95608","Phone":"","URL":"","Rank":20,"AddBldg":"",'+
            '"AddNum":"5110","AddNumFrom":"","AddNumTo":"","AddRange":"","Side":"","StPreDir":"","StPreType":"","StName":"Oak Leaf","StType":"Ave","StDir":"","BldgType":"","BldgName":"","LevelType":"","LevelName":"","UnitType":"","UnitName":"","SubAddr":"",'+
            '"StAddr":"5110 Oak Leaf Ave","Block":"","Sector":"","Nbrhd":"","District":"","City":"Carmichael","MetroArea":"","Subregion":"Sacramento County","Region":"California","RegionAbbr":"CA","Territory":"","Zone":"","Postal":"95608","PostalExt":"5415","Country":"USA",'+
            '"LangCode":"ENG","Distance":0,"X":-121.345524,"Y":38.601134999999999,"DisplayX":-121.345524,"DisplayY":38.601134999999999,"Xmin":-121.346524,"Xmax":-121.34452399999999,"Ymin":38.600135000000002,"Ymax":38.602134999999997,"ExInfo":""}}]}';

            HttpResponse response = new HttpResponse();
            response.setBody(jsonBody);
            arcGis.arcGisIdentiferToUniqueIdentifer = new Map<Integer, Id>{1 => address1.Id};

            arcGis.updateRecords(response, 'ucinn_ascendv2__Address__c', new Set<String>{'ucinn_ascendv2__Location__longitude__s', 'ucinn_ascendv2__Location__latitude__s'});

            arcGis.updateRecords(null, 'ucinn_ascendv2__Address__c', new Set<String>{'ucinn_ascendv2__Location__longitude__s', 'ucinn_ascendv2__Location__latitude__s'});

            try {
                response.setBody('test');
                arcGis.updateRecords(response, 'ucinn_ascendv2__Address__c', new Set<String>{'ucinn_ascendv2__Location__longitude__s', 'ucinn_ascendv2__Location__latitude__s'});
            }
            catch (Exception e) {

            }
        }
    }

    @isTest
    global static void geolocateSingleLineAddressTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getArcGisApiTestClass().geolocateSingleLineAddressTest();
    }

    @isTest
    global static void batchGeocodeAddressesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getArcGisApiTestClass().batchGeocodeAddressesTest();
    }

    @isTest
    global static void updateAddressesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getArcGisApiTestClass().updateAddressesTest();
    }
}