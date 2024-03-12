/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
 *
 * This source code is licensed, not sold, and is subject to a written
 * license agreement.  Among other things, no portion of this source
 * code may be copied, transmitted, disclosed, displayed, distributed,
 * translated, used as the basis for a derivative work, or used, in
 * whole or in part, for any program or purpose other than its intended
 * use in compliance with the license agreement as part of UC Innovation's
 * software.  This source code and certain of the algorithms contained
 * within it are confidential trade secrets of UC Innovation, Inc.
 * and may not be used as the basis for any other
 * software, hardware, product or service.
 */
/**
 * Interface for arcGIS API.
 * Error code range: 600s
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
*/
global without sharing class PORTAL_ArcGisApi implements PORTAL_GeolocationApiInterface {

    // Maps OBJECT ID from ArcGIS records to a unique identifer of choice. Used to map each response givin to each request made.
    global Map<Integer, Id> arcGisIdentiferToUniqueIdentifer = new Map<Integer, Id>(); // Maps ArcGis unique Indentifer to a unique identifer of choice
    global Integer currentArcGisdentifer = 1; // unique identifer to map requests made to responses

    public static final String ENDPOINT_PREFIX = 'callout:ArcGis_Geocoding/'; //will become https://geocode.arcgis.com/

    global class ArcGisException extends Exception {}

    /**
     * Wrapper class for batch geocoding response from ArcGis.
     * Top level for response.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    global class PORTAL_ArcGisGeocodingParser {
        global SpatialReference spatialReference;
        global List<Locations> locations;
    }

     /**
     * Wrapper class for batch geocoding response from ArcGis.
     * Holds spatial data.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    global class SpatialReference {
        global Integer wkid;
        global Integer latestWkid;
    }

    /**
     * Wrapper class for batch geocoding response from ArcGis.
     * Holds unique ID of each address.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    global class Attributes {
        global Integer ResultID;
    }

    /**
     * Wrapper class for batch geocoding response from ArcGis.
     * Holds address and geolocation information.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    global class Locations {
        global String address;
        global Location location;
        global Double score;
        global Attributes attributes;
    }

    /**
     * Wrapper class for batch geocoding response from ArcGis.
     * longitude (x) and latitude (y).
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    global class Location {
        global Double x;
        global Double y;
    }

    /**
    * Parses json response into PORTAL_ArcGisGeocodingParser
    *
    * @param        json                                               Raw json response provided by ArcGis Call
    * @since                                                        1.0
    */
    global PORTAL_ArcGisGeocodingParser batchResponseParser(String json) {
        return (PORTAL_ArcGisGeocodingParser) System.JSON.deserialize(json, PORTAL_ArcGisGeocodingParser.class);
    }

    /**
     * Constructor
     * @version                                                     1.0
     * @since                                                       1.0
     */
    global PORTAL_ArcGisApi() {
    }

    /**
     * geolocate a single address and return the most likly result.
     * forStorage (default false). NOTE: YOU ARE CONTRACTUALLY OBLIGATED TO SET THIS FIELD TO TRUE IF YOU ARE STORING THE GEOLOCATION RESULTS IN THE DATABASE
     *
     * API Documentation: https://developers.arcgis.com/rest/geocode/api-reference/geocoding-find-address-candidates.htm
     *
     * @param       address                                         Address to geolocate
     * @param       additonalUrlParams                              Map of URL paramters names to URL paramter values to include.
     * @return                                                      Map of geolocation for the given address.
     *              PORTAL_GeolocationHub.LONGITUDE_KEY                 Longtitude for the provided address
     *              PORTAL_GeolocationHub.LATITUDE_KEY                  Latitude for the provided address
     * @version                                                     1.0
     * @since                                                       1.0
     */
    global Map<String, Object> geolocateSingleLineAddress(String address, Map<String, String> additonalUrlParams) {

        if (String.isBlank(address)) {
            return null;
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String calloutURL = ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/findAddressCandidates?SingleLine=' + EncodingUtil.urlEncode(address, 'UTF-8') +
                        '&outFields=location&f=json';

        if (additonalUrlParams != null) {
            for (String urlParamName : additonalUrlParams.keySet()) {
                String urlParamValue = additonalUrlParams.get(urlParamName);

                if (String.isNotBlank(urlParamName) && String.isNotBlank(urlParamValue)) {
                    calloutURL += '&' + EncodingUtil.urlEncode(urlParamName, 'UTF-8') + '=' + EncodingUtil.urlEncode(urlParamValue, 'UTF-8');
                }
            }
        }

        request.setEndpoint(calloutURL);
        request.setMethod('GET');
        HttpResponse response;

        try {
            response = http.send(request);
        }
        catch (Exception e) {
            throw new ArcGisException('There was an error with API request. Error Code: 607.' + response);
        }

        Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        responseErrorCheck(responseData);

        List<Object> geolocationCandidates = (List<Object>) responseData.get('candidates');

        // no geolocation candidates were found
        if (geolocationCandidates == null || geolocationCandidates.isEmpty()) {
            return null;
        }

        Map<String, Object> bestCandidates = (Map<String, Object>)geolocationCandidates[0];
        Map<String, Object> longtitueLatitute = (Map<String, Object>)bestCandidates.get('location');

        if (longtitueLatitute == null || longtitueLatitute.get('x') == null || longtitueLatitute.get('y') == null){
            return null;
        }

        Double longitude = (Double) longtitueLatitute.get('x');
        Double latitude = (Double) longtitueLatitute.get('y');

        return new Map<String, Double>{PORTAL_GeolocationHub.LATITUDE_KEY => latitude,
                                        PORTAL_GeolocationHub.LONGITUDE_KEY => longitude};
    }

    /**
     * geolocate a single address and return the most likly result.
     * forStorage (default false). NOTE: YOU ARE CONTRACTUALLY OBLIGATED TO SET THIS FIELD TO TRUE IF YOU ARE STORING THE GEOLOCATION RESULTS IN THE DATABASE
     *
     * API Documentation: https://developers.arcgis.com/rest/geocode/api-reference/geocoding-find-address-candidates.htm
     *
     * @param       address                                                     Address to geolocate
     * @return                                                                  Map of geolocation for the given address.
     *              PORTAL_GeolocationHub.LONGITUDE_KEY                             Longtitude for the provided address
     *              PORTAL_GeolocationHub.LATITUDE_KEY                              Latitude for the provided address
     * @version                                                                 1.0
     * @since                                                                   1.0
     */
    global Map<String, Object> geolocateSingleLineAddress(String address) {
        return this.geolocateSingleLineAddress(address, new Map<String, String>());
    }

    /**
     * Batch geocode a list of formatted addresses.
     *
     * API Documentation: https://developers.arcgis.com/rest/geocode/api-reference/geocoding-geocode-addresses.htm.
     *
     * @param       formattedAddresses                                          Map of the an address and its ID.
     *                  PORTAL_AddressGeocodingBatchBase.ADDRESS_UNIQUE_IDENTIFER   Address's Id.
     *                  PORTAL_AddressGeocodingBatchBase.ADDRESS_KEY                Single line address.
     * @return                                                                  Resposne from the API
     * @version                                                                 1.0
     * @since                                                                   1.0
     */
    global HttpResponse batchGeocodeAddresses(List<Map<String, String>> formattedAddresses) {

        if (formattedAddresses == null || formattedAddresses.isEmpty()) {
            return null;
        }

        Boolean addressAdded = false;
        String requestBody = 'addresses={' +
                                '"records": [' ;

        for (Map<String, String> currentAddress : formattedAddresses) {
            String addressId = currentAddress.get(PORTAL_AddressGeocodingBatchBase.ADDRESS_UNIQUE_IDENTIFER);
            String address = currentAddress.get(PORTAL_AddressGeocodingBatchBase.ADDRESS_KEY);

            if (String.isBlank(address) || String.isBlank(addressId)) {
                continue;
            }

            requestBody += '{' +
                                '"attributes": {' +
                                    '"OBJECTID": ' + currentArcGisdentifer + ',' +
                                    '"SingleLine": "' + EncodingUtil.urlEncode(address, 'UTF-8') + '"' +
                                '}' +
                            '},';

            arcGisIdentiferToUniqueIdentifer.put(currentArcGisdentifer, addressId);
            currentArcGisdentifer += 1;
            addressAdded = true;
        }

        if (!addressAdded) {
            return null;
        }

        // remove the last comma in the body
        requestBody = requestBody.substring(0, requestBody.length()-1);

        requestBody += ']' +
                    '}';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_PREFIX + 'arcgis/rest/services/World/GeocodeServer/geocodeAddresses?f=json');
        request.setMethod('POST');
        request.setBody(requestBody);
        HttpResponse response = http.send(request);

        responseErrorCheck((Map<String, Object>) JSON.deserializeUntyped(response.getBody()));

        return response;
    }

    /**
     * Update address records with geolocation from the supplied API response.
     *
     * @param       jsonResponse                                                Response from calling batchGeocodeAddresses.
     * @return                                                                  List of addresses populated with Id and geolocation.
     * @version                                                                 1.0
     * @since                                                                   1.0
     */
    global List<ucinn_ascendv2__Address__c> updateRecords(HttpResponse jsonResponse,String sobjectAPIName, Set<String> geolocationFieldSet) {
        List<sObject> recordsToUpdate = new List<sObject>();

        if (jsonResponse == null) {
            return recordsToUpdate;
        }

        PORTAL_ArcGisGeocodingParser parsedResponse;

        try {
            parsedResponse = batchResponseParser(jsonResponse.getBody());
        }
        catch (Exception e) {
            throw new ArcGisException('The API response was not formatted properly. Erro Code: 609.');
        }

        if (parsedResponse.locations == null) {
            throw new ArcGisException('There was an error with your response from ArcGis Api. Erro Code: 608.');
        }

        for (Integer addressIndex = 0; addressIndex < parsedResponse.locations.size(); addressIndex++) {
            Locations locationData = parsedResponse.locations[addressIndex];
            Integer arcGisIdentifer = (Integer)locationData.attributes.ResultID;

            // If geolocation couldn't be found for the given address or the resulting object Id could not be found
            if (locationData.location == null || arcGisIdentifer == null) {
                continue;
            }

            Id recordId = arcGisIdentiferToUniqueIdentifer.get(arcGisIdentifer);
            Double longitude = locationData.location.x;
            Double latitude = locationData.location.y;

            if (longitude != null && latitude != null && recordId != null) {
                sObject recordToUpdate = (sObject) Type.forName(sobjectAPIName).newInstance();
                recordToUpdate.Id = recordId;
                for (String geolocationField : geolocationFieldSet) {
                    if (geolocationField.containsIgnoreCase('latitude')) {
                        recordToUpdate.put(geolocationField, latitude);
                    } else if (geolocationField.containsIgnoreCase('longitude')) {
                        recordToUpdate.put(geolocationField, longitude);
                    }
                }
                recordsToUpdate.add(recordToUpdate);
            }
        }

        return recordsToUpdate;
    }

    /** Private Methods */

    /**
     * Check the API response to see if there was an error. If an error occured an exception will be thrown.
     *
     * @param       response                                Response from the API call.
     * @version                                             1.0
     * @since                                               1.0
     */
    private static void responseErrorCheck(Map<String, Object> response) {
        // If the response contains an error
        if (response.get('error') != null) {
            String arcGisErrorMessage = '';
            String arcGisErrorCode = '';
            Map<String, Object> error = (Map<String, Object>)response.get('error');

            if (error.get('message') != null) {
                arcGisErrorMessage += ' Error from ArcGis: ' + (String) error.get('message');
            }

            if (error.get('code') != null) {
                arcGisErrorCode += 'ArcGis Error Code: ' + String.valueOf((Integer)error.get('code'));
            }

            throw new ArcGisException('There was an error with your geolocation request.' + arcGisErrorMessage + ' Error Code: 603. ' + arcGisErrorCode);
        }
    }

}