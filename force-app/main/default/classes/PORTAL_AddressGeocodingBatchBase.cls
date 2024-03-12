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
 * Address geolocation base class.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
*/
global virtual inherited sharing class PORTAL_AddressGeocodingBatchBase {

    global static final String ADDRESS_UNIQUE_IDENTIFER = 'addressUniqueIdentifer';
    global static final String ADDRESS_KEY = 'address';

    private PORTAL_ArcGisApi arcGisAPI;
    private PORTAL_GoogleGeocodingApi googleAPI;
    public Map<String, List<String>> fieldMap;
    public String sobjectAPIName;
    public Set<String> geolocationFieldSet;


    public PORTAL_AddressGeocodingBatchBase() {
    }

    /**
     * Base batch query for address records.
     *
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual String getQuery() {
        Set<String> fieldSet = new Set<String>();
        for (List<String> fields : fieldMap.values()) {
            fieldSet.addAll(fields);
        }
        Set<String> geolocationClauseSet = new Set<String>();
        //the set contains the longitutde and latitude fields and we add the null check for the where clause in order to get records that do not have a geolocation already
        for (String geolocationField : geolocationFieldSet) {
            geolocationClauseSet.add(geolocationField + ' = null ');
        }
        String queryString = 'SELECT Id, ' + String.join(new List<String>(fieldSet), ', ') + ' FROM ' + this.sobjectAPIName + ' WHERE ' + String.join(new List<String>(geolocationClauseSet), ' OR ');

        return queryString;
    }

    /**
     * Convert address records into maps of single line addresses and their associated id.
     *
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual List<Map<String, String>> formatAddresses(List<sObject> recordsList) {
        List<Map<String, String>> formattedAddressesInfo = new List<Map<String, String>>();

        for (sObject eachRecord : recordsList) {
            String uniqueIdentifer = (String)eachRecord.Id;
            String formattedAddress = '';

            if (String.isBlank(uniqueIdentifer)) {
                continue;
            }

            for (String streetField : this.fieldMap.get(PORTAL_CONST_GeocodingFields.STREET_FIELDS_KEY)) {
                if (String.isNotBlank((String)eachRecord.get(streetField))) {
                    if (String.isNotBlank(formattedAddress)) {
                        formattedAddress += ' ';
                    }
                    formattedAddress += (String) eachRecord.get(streetField);
                }
            }

            for (String addressAttribute : this.fieldMap.get(PORTAL_CONST_GeocodingFields.OTHER_FIELDS_KEY)) {
                if (String.isNotBlank(addressAttribute)) {
                    if (String.isNotBlank(formattedAddress)) {
                        formattedAddress += ', ';
                    }
                    formattedAddress += eachRecord.get(addressAttribute);
                }
            }

            if (String.isNotBlank(formattedAddress)) {
                formattedAddressesInfo.add(new Map<String, String>{
                    ADDRESS_UNIQUE_IDENTIFER => uniqueIdentifer,
                    ADDRESS_KEY => formattedAddress
                });
            }

        }

        return formattedAddressesInfo;
    }

    /*** ArcGis geolocation batch functions ***/

    /**
     * Constructor for the ArcGis address geolocation batch class.
     *
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual void arcGisGeolocationBatchConstructor() {
        arcGisAPI = new PORTAL_ArcGisAPI();
    }

    /**
     * Start method for the ArcGis address geolocation batch class.
     *
     * @param           bc                                      Context of the current batch.
     * @return                                                  Database query locator for the provided address query.
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual Database.QueryLocator arcGisGeolocationBatchStart(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.getQuery());
    }

    /**
     * Execute method for the ArcGis address geolocation batch class. Geolocate the addressess and update those records.
     *
     * @param           bc                                      Context of the current batch.
     * @param           addressRecords                          Addresses to geolocate.
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual void arcGisGeolocationBatchExecute(Database.BatchableContext bc, List<SObject> recordList) {
        List<Map<String, String>> formattedAddresses = this.formatAddresses(recordList);
        HttpResponse geocodingResponse = arcGisAPI.batchGeocodeAddresses(formattedAddresses);
        List<sobject> geolocatedRecords = arcGisAPI.updateRecords(geocodingResponse, this.sobjectAPIName, this.geolocationFieldSet);

        if (geolocatedRecords != null) {
            update geolocatedRecords;
        }
    }

    /**
     * Finish method for the ArcGis Geolocation batch.
     *
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual void arcGisGeolocationBatchFinish(Database.BatchableContext bc) {
    }

    /*** Google geolocation batch functions ***/

    /**
     * Constructor for the Google address geolocation batch class.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    global virtual void googleGeolocationBatchConstructor() {
        googleAPI = new PORTAL_GoogleGeocodingApi();
    }

    /**
     * Start method for the Google address geolocation batch class.
     *
     * @param           bc                                      Context of the current batch.
     * @return                                                  Database query locator for the provided address query.
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global virtual Database.QueryLocator googleGeolocationBatchStart(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.getQuery());
    }

    /**
     * Execute method for the Google address geolocation batch class. Geolocate the addressess and update those records.
     *
     * @param           bc                                      Context of the current batch.
     * @param           addressRecords                          Addresses to geolocate.
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global void googleGeolocationBatchExecute(Database.BatchableContext bc, List<sObject> recordList) {
        List<Map<String, String>> formattedAddresses = this.formatAddresses(recordList);
        List<sObject> recordsToUpdate = new List<sObject>();

        for (Map<String, String> currentFormattedAddress : formattedAddresses) {
            Id recordId = (Id)currentFormattedAddress.get(ADDRESS_UNIQUE_IDENTIFER);
            String address = currentFormattedAddress.get(ADDRESS_KEY);

            if (recordId == null || String.isBlank(address)) {
                continue;
            }

            Map<String, Object> geolocation;

            try {
                geolocation = googleAPI.geolocateSingleLineAddress(address); // NOTE: we make a callout per address record.
            }
            catch (PORTAL_GoogleGeocodingApi.GoogleGeocodingException e) {
                continue;
            }

            if (geolocation == null) {
                continue;
            }

            Double latitude = (Double)geolocation.get(PORTAL_GeolocationHub.LATITUDE_KEY);
            Double longitude = (Double)geolocation.get(PORTAL_GeolocationHub.LONGITUDE_KEY);

            if (latitude != null && longitude != null) {
                sObject recordToUpdate = (sObject) Type.forName(this.sobjectAPIName).newInstance();
                recordToUpdate.Id = recordId;
                for (String geolocationField : this.geolocationFieldSet) {
                    if (geolocationField.containsIgnoreCase('latitude')) {
                        recordToUpdate.put(geolocationField, latitude);
                    } else if (geolocationField.containsIgnoreCase('longitude')) {
                        recordToUpdate.put(geolocationField, longitude);
                    }
                }
                recordsToUpdate.add(recordToUpdate);
            }

        }

        update recordsToUpdate;
    }

    /**
     * Finish method for the Google Geolocation batch.
     *
     * @version                                                 1.0
     * @since                                                   1.0
     */
    global void googleGeolocationBatchFinish(Database.BatchableContext bc) {
    }

}