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
 * Determines which API to call based on custom metadata settings.
 * Error code range: 800s
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
*/
global without sharing class PORTAL_GeolocationHub {
    private PORTAL_GeolocationApiInterface geolocationApi;
    private String geolocationType = '';

    // class keys
    private static final String ARC_GIS_KEY = 'ArcGIS';
    private static final String GOOGLE_KEY = 'Google';
    global static final String LATITUDE_KEY = 'latitude';
    global static final String LONGITUDE_KEY = 'longitude';

    // variables for test class
    @TestVisible private static String geolocationTypeOverride = '';

    global class GeolocationHubException extends Exception {}

    /**
     * Determines which API to use based on custom metadata settings.
     * Will throw an error if it cannot determine which API you want to use.
     *
     * @version                                             1.0
     * @since                                               1.0
     */
    global PORTAL_GeolocationHub() {
        List<Portal_Organization_Setting__mdt> geolocationTypeList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Geolocation_Type'}
        });

        if (geolocationTypeList.size() == 1) {
            geolocationType = geolocationTypeList[0].Value__c;
        } else {
            throw new GeolocationHubException('Please set the geolocation type. Error Code: 800.');
        }

        if(Test.isRunningTest() && String.isNotBlank(geolocationTypeOverride)) {
            geolocationType = geolocationTypeOverride;
        }

        if (ARC_GIS_KEY.equalsIgnoreCase(geolocationType)) {
            geolocationApi = new PORTAL_ArcGisAPI();
        } else if (GOOGLE_KEY.equalsIgnoreCase(geolocationType)) {
            geolocationApi = new PORTAL_GoogleGeocodingApi();
        } else {
            throw new GeolocationHubException('This type of geolocation is not supported. Error Code: 801.');
        }
    }

    /**
     * geolocate a single address and return the most likly result.
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
        return geolocationApi.geolocateSingleLineAddress(address, additonalUrlParams);
    }

    /**
     * geolocate a single address and return the most likly result.
     *
     *
     * @param       address                                 Address to geolocate
     * @return                                              Map of geolocation for the given address.
     *              PORTAL_GeolocationHub.LONGITUDE_KEY         Longtitude for the provided address
     *              PORTAL_GeolocationHub.LATITUDE_KEY          Latitude for the provided address
     * @version                                             1.0
     * @since                                               1.0
     */
    global Map<String, Object> geolocateSingleLineAddress(String address) {
        return geolocationApi.geolocateSingleLineAddress(address);
    }
}