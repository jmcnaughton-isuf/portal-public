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
 * Interface for Google geocoding API.
 * Error code range: 700s
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
*/
global without sharing class PORTAL_GoogleGeocodingApi implements PORTAL_GeolocationApiInterface{
    @TestVisible private static String token = '';
    public final static String RESULTS_CONST = 'results';

    global class GoogleGeocodingException extends Exception {}

    /**
     * Constructor that grabs token for the class.
     * @version                                             1.0
     * @since                                               1.0
     */
    global PORTAL_GoogleGeocodingApi() {
        this.generateToken();
    }

    /**
     * Grabs the key from custom metadata.
     *
     * @version                                             1.0
     * @since                                               1.0
     */
    global void generateToken() {
        if (String.isNotBlank(PORTAL_GoogleGeocodingApi.token)) {
            return;
        }

        List<Portal_Organization_Setting__mdt> googleToken = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Google_Geolocation_API_Key'}
        });

        if (googleToken.size() == 1) {
            PORTAL_GoogleGeocodingApi.token = googleToken[0].Value__c;
        } else{
            throw new GoogleGeocodingException('Your google API Key could not be found. Error Code: 700.');
        }
    }

    /**
     * geolocate a single address and return the most likly result.
     *
     * API Documentation: https://developers.google.com/maps/documentation/geocoding/overview#geocoding
     *
     * @param       address                                 Address to geolocate
     * @param       additonalUrlParams                      Map of URL paramters names to URL paramter values to include.
     * @return                                              Map of geolocation for the given address.
     *              PORTAL_GeolocationHub.LONGITUDE_KEY         Longtitude for the provided address
     *              PORTAL_GeolocationHub.LATITUDE_KEY          Latitude for the provided address
     * @version                                             1.0
     * @since                                               1.0
     */
    global Map<String, Object> geolocateSingleLineAddress(String address, Map<String, String> additonalUrlParams) {
        if (String.isBlank(address)) {
            return null;
        }

        if (String.isBlank(PORTAL_GoogleGeocodingApi.token)) {
            this.generateToken();
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String calloutURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') +
                            '&key=' + PORTAL_GoogleGeocodingApi.token;

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
            throw new GoogleGeocodingException('There was an error with your API Request. Error Code 702.');
        }

        // check for error
        responseErrorCheck(response);

        Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        List<Object> results = (List<Object>)responseBody?.get(RESULTS_CONST);

        if (results == null || results.isEmpty()) {
            return null;
        }

        Map<String, Object> firstResult = (Map<String, Object>)results[0];

        Map<String, Object> geometryData = (Map<String, Object>) firstResult.get('geometry');

        if (geometryData == null) {
            return null;
        }

        Map<String, Object> locationData = (Map<String, Object>) geometryData.get('location');

        if (locationData == null || locationData.get('lng') == null || locationData.get('lat') == null) {
            return null;
        }

        Double longitude = (Double) locationData.get('lng');
        Double latitude = (Double) locationData.get('lat');

        return new Map<String, Double>{PORTAL_GeolocationHub.LATITUDE_KEY => latitude,
                                        PORTAL_GeolocationHub.LONGITUDE_KEY => longitude};
    }

    /**
     * geolocate a single address and return the most likly result.
     *
     * API Documentation: https://developers.google.com/maps/documentation/geocoding/overview#geocoding
     *
     * @param       address                                 Address to geolocate
     * @return                                              Map of geolocation for the given address.
     *              PORTAL_GeolocationHub.LONGITUDE_KEY         Longtitude for the provided address
     *              PORTAL_GeolocationHub.LATITUDE_KEY          Latitude for the provided address
     * @version                                             1.0
     * @since                                               1.0
     */
    global Map<String, Object> geolocateSingleLineAddress(String address) {
        return this.geolocateSingleLineAddress(address, new Map<String, String>());
    }

    /** Private methods */

    /**
     * Check the API response to see if there was an error. If an error occured an exception will be thrown.
     *
     * @param       response                                Response from the API call.
     * @version                                             1.0
     * @since                                               1.0
     */
    private void responseErrorCheck(HttpResponse response){
        if (response == null || response.getStatusCode() == null) {
            return;
        }

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            String errorString = 'There was an error with geolocation request. Error Code 701. ' + response.getStatusCode() + '. ';
            throw new GoogleGeocodingException(errorString);
        }
    }
}