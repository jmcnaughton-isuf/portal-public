/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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

public inherited sharing virtual class PORTAL_AddressWrapper {
    public enum ADDRESS_FIELD {STREET1, STREET2, STREET3, CITY, STATE, COUNTRY, POSTCODE, GEOLOCATION}

    public static final String STREET_LINE_1 = 'streetLine1';
    public static final String STREET_LINE_2 = 'streetLine2';
    public static final String STREET_LINE_3 = 'streetLine3';
    public static final String CITY_CONST = 'city';
    public static final String STATE_CONST = 'state';
    public static final String COUNTRY_CONST = 'country';
    public static final String POSTAL_CODE = 'postalCode';
    public static final String DISTANCE_CONST = 'distance';

    @AuraEnabled
    public String streetLine1 {get; set;}              // Street of the address
    @AuraEnabled
    public String streetLine2 {get; set;}              // Street of the address
    @AuraEnabled
    public String streetLine3 {get; set;}              // Street of the address
    @AuraEnabled
    public String city {get; set;}                      // City of the address
    @AuraEnabled
    public String state {get; set;}                     // State of the address
    @AuraEnabled
    public String country {get; set;}                   // Country of the address
    @AuraEnabled
    public String postalCode {get; set;}                // Postal Code of the address
    @AuraEnabled
    public String distance {get; set;}                  // Distance the user inputted
    
    private Double latitude;                            // Latitude of address
    private Double longitude;                           // Longitude of address

    public PORTAL_AddressWrapper() {}

    public PORTAL_AddressWrapper(Object objectRecord) {
        if (objectRecord == null) {
            return;
        }

        Map<Object, Object> objectMap = (Map<Object, Object>)objectRecord;

        this.streetLine1 = (String)objectMap.get(STREET_LINE_1);
        this.streetLine2 = (String)objectMap.get(STREET_LINE_2);
        this.streetLine3 = (String)objectMap.get(STREET_LINE_3);
        this.city = (String)objectMap.get(CITY_CONST);
        this.state = (String)objectMap.get(STATE_CONST);
        this.country = (String)objectMap.get(COUNTRY_CONST);
        this.postalCode = (String)objectMap.get(POSTAL_CODE);
        this.distance = (String)objectMap.get(DISTANCE_CONST);
        this.latitude = (Double)objectMap.get(PORTAL_GeolocationHub.LATITUDE_KEY);
        this.longitude = (Double)objectMap.get(PORTAL_GeolocationHub.LONGITUDE_KEY);
    }

    /**
     * Return string representation of this address wrapper, used in geolocation hub
     * 
     * @since 1.0
     * 
     * @return address formatted for use in geolocation hub
     */
    public override String toString(){
        String resultString = '';

        if (String.isNotBlank(this.streetLine1)) {
            resultString = resultString + this.streetLine1;
        }

        if (String.isNotBlank(this.streetLine2)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }
            resultString = resultString + this.streetLine2;
        }

        if (String.isNotBlank(this.streetLine3)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }
            resultString = resultString + this.streetLine3;
        }

        // Irvine
        if (String.isNotBlank(this.city)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }
            resultString = resultString + this.city;
        }

        // CA || Irvine, CA
        if (String.isNotBlank(this.state)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }

            resultString = resultString + this.state;
        }

        // 92602 || Irvine, 92602 || CA 92602 || Irvine, CA 92602
        if (String.isNotBlank(this.postalCode)) {
            if (String.isNotBlank(resultString) && String.isBlank(this.state)) {
                resultString = resultString + ', ';
            } else if (String.isNotBlank(this.state)) {
                resultString = resultString + ' ';
            }

            resultString = resultString + this.postalCode;
        }

        // USA || 92602, USA || Irvine, 92602, USA || CA 92602, USA || Irvine, CA 92602, USA
        if (String.isNotBlank(this.country)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }

            resultString = resultString + this.country;
        }

        return resultString;
    }

    /**
     * Make a callout to a geolocation API to populate this address wrapper's latitude and longitude if currently blank 
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    protected virtual void geolocateAddress() {
        String singleLineAddress = this.toString();
        if ((this.latitude != null && this.longitude != null) || String.isBlank(singleLineAddress)) {
            return;   
        }

        PORTAL_GeolocationHub geolocationHub = new PORTAL_GeolocationHub();
        Map<String, Object> locationMap = null;
        if (Test.isRunningTest()) {
            locationMap = new Map<String, Object>{PORTAL_GeolocationHub.LATITUDE_KEY => 20, PORTAL_GeolocationHub.LONGITUDE_KEY => 20};
        } else {
            try {
                locationMap = geolocationHub.geolocateSingleLineAddress(singleLineAddress);
            }
            catch (Exception e) {
                System.debug('There was a geolocation error. ' + e.getMessage());
            }
        }

        this.latitude = (Double) locationMap?.get(PORTAL_GeolocationHub.LATITUDE_KEY);
        this.longitude = (Double) locationMap?.get(PORTAL_GeolocationHub.LONGITUDE_KEY);
    }

    /**
     * Getter method for latitude, will do geolocation callout for latitude and longitude if latitude is null
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @return latitude of address
     */
    public virtual Double getLatitude() {
        if (this.latitude == null) {
            geolocateAddress();
        }

        return this.latitude;
    }

    /**
     * Getter method for latitude, will do geolocation callout for latitude and longitude if longitude is null
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @return latitude of address
     */
    public virtual Double getLongitude() {
        if (this.longitude == null) {
            geolocateAddress();
        }

        return this.longitude;
    }

    public virtual String toQueryClause(Map<ADDRESS_FIELD, String> addressFieldMapping) {
        String resultString = '';

        if (addressFieldMapping == null || addressFieldMapping.isEmpty()) {
            return resultString;
        }

        if (String.isNotBlank(distance) && addressFieldMapping.containsKey(ADDRESS_FIELD.GEOLOCATION)) {
            return getGeolocationQueryClause(addressFieldMapping.get(ADDRESS_FIELD.GEOLOCATION));
        }

        return getLocationTextSearchQueryClause(addressFieldMapping);
    }

    @TestVisible
    protected virtual String getGeolocationQueryClause(String geolocationFieldApiName) {
        geolocateAddress();
        if (this.latitude == null || this.longitude == null) {
            return '';
        }

        return ' DISTANCE (' + geolocationFieldApiName + ' , GEOLOCATION(' + this.latitude + ', ' + this.longitude + '), \'mi\') < ' + this.distance + ' ';
    }

    protected virtual String getLocationTextSearchQueryClause(Map<ADDRESS_FIELD, String> addressFieldMapping) {
        String resultString = '';
        String whereClausePrefix = '';

        if (String.isNotBlank(this.streetLine1) && addressFieldMapping.containsKey(ADDRESS_FIELD.STREET1)) {
            resultString = resultString + addressFieldMapping.get(ADDRESS_FIELD.STREET1) + ' = \'' + String.escapeSingleQuotes(this.streetLine1) + '\' ' ;
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(this.streetLine2) && addressFieldMapping.containsKey(ADDRESS_FIELD.STREET2)) {
            resultString = resultString + whereClausePrefix + addressFieldMapping.get(ADDRESS_FIELD.STREET2) + ' = \'' + String.escapeSingleQuotes(this.streetLine2) + '\' ' ;
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(this.streetLine3) && addressFieldMapping.containsKey(ADDRESS_FIELD.STREET3)) {
            resultString = resultString + whereClausePrefix + addressFieldMapping.get(ADDRESS_FIELD.STREET3) + ' = \'' + String.escapeSingleQuotes(this.streetLine2) + '\' ' ;
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(this.city) && addressFieldMapping.containsKey(ADDRESS_FIELD.CITY)) {
            resultString = resultString + whereClausePrefix + addressFieldMapping.get(ADDRESS_FIELD.CITY) + ' = \'' + String.escapeSingleQuotes(this.city) + '\' ' ;
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(this.state) && addressFieldMapping.containsKey(ADDRESS_FIELD.STATE)) {
            resultString = resultString + whereClausePrefix + addressFieldMapping.get(ADDRESS_FIELD.STATE) + ' = \'' + String.escapeSingleQuotes(this.state) + '\' ' ;
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(this.country) && addressFieldMapping.containsKey(ADDRESS_FIELD.COUNTRY)) {
            resultString = resultString + whereClausePrefix + addressFieldMapping.get(ADDRESS_FIELD.COUNTRY) + ' = \'' + String.escapeSingleQuotes(this.country) + '\' ' ;
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(this.postalCode) && addressFieldMapping.containsKey(ADDRESS_FIELD.POSTCODE)) {
            resultString = resultString + whereClausePrefix + addressFieldMapping.get(ADDRESS_FIELD.POSTCODE) + ' LIKE \'%' + String.escapeSingleQuotes(this.postalCode) + '%\' ' ;
        }

        return resultString;
    }
}