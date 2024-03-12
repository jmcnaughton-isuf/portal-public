/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Base controller and functionality for the zone module.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
global virtual without sharing class PORTAL_ZoneSearchControllerBase {
    // class variables
    protected Id contactId;

    // class key variables
    public final static String FRONT_END_DATA_MAP = 'frontEndDataMap';
    public final static String RECORDS_TO_RETURN_KEY = 'records';
    public final static String OBJECT_TO_FIELD_MAP = 'objectToFieldMap';
    public final static String ZONE_RECORD_TYPES = 'zoneRecordTypes';
    public final static String FORMATTED_RECORDS = 'formattedRecords';
    public final static String FORMATTED_ZONES_LIST = 'formattedZonesList';
    public final static String UNFORMATTED_ZONES_LIST = 'unformattedZonesList';
    public final static String RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED = 'recordTypeDeveloperNamesCommaSeperated';
    public final static String ZONE_MEMBERSHIP_ID = 'zoneMembershipId';
    public final static String COUNTRIES_CONST = 'countries';
    public final static String ZONE_NAME = 'zoneName';
    public final static String SELECTED_COUNTRY = 'selectedCountry';
    public final static String HAS_MORE_RECORDS = 'hasMoreRecords';

    public final static String NAME_SEARCH_INPUT = 'nameSearchInput';
    public final static String LOCATION_KEY = 'location';
    public final static String CITY_CONST = 'city';
    public final static String STATE_CONST = 'state';
    public final static String ZIP_CODE = 'zipCode';
    public final static String RADIUS_CONST = 'radius';
    public final static String COUNTRY_FIELD = 'Country__c';
    public final static String UNITED_STATES = 'United States';
    public final static String LABEL_CONST = 'label';
    public final static String VALUE_CONST = 'value';
    public final static String OFFSET_CONST = 'offset';

    public final static String QUERY_WHERE_CLAUSE = 'queryWhereClause';
    public final static String QUERY_ORDER_BY_CLAUSE = 'queryOrderByClause';

    public final static String LEADERSHIP_URL = 'leadershipURL';
    public final static String HOME_PAGE_URL = 'homePageURL';
    public final static String LATITUDE_CONST = 'latitude';
    public final static String LONGITUDE_CONST = 'longitude';
    public final static String CONTACT = 'contact';
    public final static String CONTACT_TITLE = 'contactTitle';
    public final static String CONTACT_NAME = 'contactName';
    public final static String CONTACT_EMAIL = 'contactEmail';
    public final static String CONTACT_PHONE = 'contactPhone';

    public final static String ID = 'Id';
    public final static String NAME = 'Name';
    public final static String GEOLOCATION_LATITUDE = 'geolocationLatitude';
    public final static String GEOLOCATION_LONGITUDE = 'geolocationLongitude';
    public final static String SOCIAL_MEDIA_ORDER = 'socialMediaOrder';
    public final static String ZONE_MEMBERSHIPS = 'zoneMemberships';

    public final static String LOGO_LINK = 'logoLink';
    public final static String LOGO_DOCUMENT_RECORD = 'logoDocumentRecord';
    public final static String LOGO_URL = 'logoURL';
    public final static String FACEBOOK = 'Facebook';
    public final static String FACEBOOK_LOGO = 'Facebook Logo';
    public final static String FACEBOOK_LINK = 'facebookLink';
    public final static String LINKED_IN = 'LinkedIn';
    public final static String LINKED_IN_LOGO = 'LinkedIn Logo';
    public final static String LINKED_IN_LINK = 'linkedinLink';
    public final static String INSTAGRAM = 'Instagram';
    public final static String INSTAGRAM_LOGO = 'Instagram Logo';
    public final static String INSTAGRAM_LINK = 'instagramLink';
    public final static String TWITTER = 'Twitter';
    public final static String TWITTER_LOGO = 'Twitter Logo';
    public final static String TWITTER_LINK = 'twitterLink';
    public final static String WE_CHAT = 'WeChat';
    public final static String WE_CHAT_LOGO = 'WeChat Logo';
    public final static String WE_CHAT_LINK = 'wechatLink';
    public final static String LINK_CONST = 'link';
    public final static String SOCIAL_MEDIA = 'socialMedia';
    public final static String SOCIAL_MEDIA_LOGOS = 'Portal Social Media Logos';

    public final static String ZONE_SEARCH = 'Zone Search';
    public final static String ZONE_RECORDS = 'zoneRecords';

    // Tabel Media Logo List
    public final static String FACEBOOK_LOGO_STATIC_RESOURCE_NAME = 'Portal_ZoneSearchFacebookLogo';
    public final static String TWITTER_LOGO_STATIC_RESOURCE_NAME = 'Portal_ZoneSearchTwitterLogo';
    public final static String LINKED_IN_LOGO_STATIC_RESOURCE_NAME = 'Portal_ZoneSearchLinkedInLogo';
    public final static String INSTAGRAM_LOGO_STATIC_RESOURCE_NAME = 'Portal_ZoneSearchInstagramLogo';
    public final static String WE_CHAT_LOGO_STATIC_RESOURCE_NAME = 'Portal_ZoneSearchWeChatLogo';
    public final static String RESOURCE_PATH = '/resource/';

    public final static Map<String, String> SOCIAL_MEDIA_FIELD_TO_STATIC_RESOURCE_MAP = new Map<String, String>{
        FACEBOOK_LOGO => FACEBOOK_LOGO_STATIC_RESOURCE_NAME,
        TWITTER_LOGO => TWITTER_LOGO_STATIC_RESOURCE_NAME,
        LINKED_IN_LOGO => LINKED_IN_LOGO_STATIC_RESOURCE_NAME,
        INSTAGRAM_LOGO => INSTAGRAM_LOGO_STATIC_RESOURCE_NAME,
        WE_CHAT_LOGO => WE_CHAT_LOGO_STATIC_RESOURCE_NAME
    };

    // url parameters
    public final static String ERROR_RETRIEVE_ZONES = 'There was an error retrieving your zones. Error Code: 101.';
    public final static String ID_KEY = 'Id';

    // page section settings fields
    global PORTAL_ZoneSearchControllerBase() {
        contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).ContactId;
    }

    /**
    * Init function for the zone search component. Grabs zones and list of searchable countries for zones.
    *
    * @param    nameSearchInput                             User input for 'Name Search' text box.
    * @param    locationObject                              Location Information for geolocation search.
    * @param    recordTypeDeveloperNamesCommaSeperated      Comma seperated string of zone record types to use in the Search.
    *
    * @return                                               Formatted list of zone/zone memberships records.
    * @since                                                1.0
    */
    global virtual Map<String, Object> initZoneSearch(Map<String,Object> params){
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String recordTypeDeveloperNamesCommaSeperated = (String)params.get(RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED);

        if (String.isBlank(recordTypeDeveloperNamesCommaSeperated)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_RETRIEVE_ZONES});
        }

        List<String> recordTypeDeveloperNamesList = recordTypeDeveloperNamesCommaSeperated.split(',');

        Map<String, Object> zoneRecordsMap = getZoneRecords(params);

        if (zoneRecordsMap == null || zoneRecordsMap.isEmpty()) {
            return returnMap;
        }

        returnMap.put(RECORDS_TO_RETURN_KEY, (List<Map<String, Object>>)zoneRecordsMap.get(FORMATTED_ZONES_LIST));
        returnMap.put(HAS_MORE_RECORDS, (Boolean) zoneRecordsMap.get(HAS_MORE_RECORDS));
        returnMap.put(FRONT_END_DATA_MAP, (Map<String, Map<String, Object>>) zoneRecordsMap.get(FRONT_END_DATA_MAP));
        returnMap.put(COUNTRIES_CONST, getCountriesForZones(recordTypeDeveloperNamesList));

        return returnMap;
    }

    /**
    * Query all country values from zone records.
    *
    * @param    recordTypeDeveloperNamesList       List of zone record names to filter on.
    *
    * @return                                      List of formatted country picklist options.
    * @since                                       1.0
    */
    @TestVisible
    protected virtual List<Map<String, String>> getCountriesForZones(List<String> recordTypeDeveloperNamesList){
        List<Map<String, String>> returnList = new List<Map<String, String>>();

        if (recordTypeDeveloperNamesList == null || recordTypeDeveloperNamesList.isEmpty()) {
            return returnList;
        }

        List<String> sortedCountryList = getSortedCountryList(recordTypeDeveloperNamesList);

        for (String eachSortedCountry : sortedCountryList) {
            returnList.add(new Map<String, String>{LABEL_CONST => eachSortedCountry,
                                                   VALUE_CONST => eachSortedCountry});
        }

        return returnList;
    }

    /**
    * Gets a list of available countries for selection. Based on countries existing in zone records.
    *
    * @param    recordTypeDeveloperNamesList       List of zone record names to filter on.
    *
    * @return                                      List of available countries for selection in zone search.
    * @since                                       1.0
    */
    @TestVisible
    protected virtual List<String> getSortedCountryList(List<String> recordTypeDeveloperNamesList) {
        List<String> resultList = new List<String>();

        if (recordTypeDeveloperNamesList == null || recordTypeDeveloperNamesList.isEmpty()) {
            return resultList;
        }

        List<AggregateResult> countriesUsedInZonesList = [SELECT Country__c
                                                          FROM ucinn_portal_Zone__c
                                                          WHERE RecordType.DeveloperName IN :recordTypeDeveloperNamesList
                                                          AND Is_Display_on_Portal__c = true
                                                          GROUP BY Country__c];

        for (AggregateResult eachCountry : countriesUsedInZonesList){
            String countryString = (String)eachCountry.get(COUNTRY_FIELD);
            if (String.isNotBlank(countryString)) {
                resultList.add(countryString);
            }
        }

        if (resultList.isEmpty()) {
            return resultList;
        }

        resultList = sortCountryList(resultList);

        return resultList;
    }

    /**
    * Sorts list of countries and places the United States as the first entry.
    *
    * @param    countryList                        List of countries to be sorted.
    *
    * @return                                      List of sorted country names.
    * @since                                       1.0
    */
    @TestVisible
    protected virtual List<String> sortCountryList(List<String> countryList) {
        List<String> resultList = new List<String>(countryList);

        if (resultList == null || resultList.isEmpty()) {
            return resultList;
        }

        Integer unitedStatesIndex = resultList.indexOf(UNITED_STATES);

        // Remove united states if it exists
        if (unitedStatesIndex > 0) {
            resultList.remove(unitedStatesIndex);
        }

        resultList.sort();

        // Add united states as the first value
        if (unitedStatesIndex > 0) {
            resultList.add(0, UNITED_STATES);
        }

        return resultList;
    }

    /**
     * Query zones by either text or geolocation search.
     *
     * @param    nameSearchInput                             User input for 'Name Search' text box.
     * @param    locationObject                              Location Information for geolocation search.
     * @param    recordTypeDeveloperNamesCommaSeperated      Comma seperated string of zone record types to use in the Search.
     *
     * @return                                               Map<String, Object> with the following key/pair values: 
     *                                                              formattedZoneList => List<Map<String, Object>>: formatted zone/zone membership records
     *                                                              hasMoreRecords    => Boolean: true if the query has more results that can be queried later
     *                                                              frontEndDataMap   => Map<String, Object> front end field map
     * 
     * @since                                                1.0
     */
    @TestVisible
    global virtual Map<String, Object> getZoneRecords(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            System.debug('getZoneRecords params map is null or empty.');
            return new Map<String, Object>();
        }

        String nameSearchInput = (String)params.get(NAME_SEARCH_INPUT);
        Map<Object, Object> locationObject = (Map<Object, Object>)params.get(LOCATION_KEY);
        String recordTypeDeveloperNamesCommaSeperated = (String)params.get(RECORD_TYPE_DEVELOPER_NAMES_COMMA_SEPERATED);

        List<String> recordTypeDeveloperNamesList = null;
        if (String.isNotBlank(recordTypeDeveloperNamesCommaSeperated)) {
            recordTypeDeveloperNamesList = recordTypeDeveloperNamesCommaSeperated.split(',');
        }

        String dynamicWhereClause = getQueryWhereClause(nameSearchInput, locationObject, recordTypeDeveloperNamesList);
        Integer offset = params.get(OFFSET_CONST) != null ? Integer.valueOf(String.valueOf(params.get(OFFSET_CONST))) : 0;

        Map<String, Object> queryResponseMap = queryForZoneRecords(dynamicWhereClause, offset);
        queryResponseMap.put(FORMATTED_ZONES_LIST, getFormattedZoneList((List<Map<String, Object>>) queryResponseMap.remove(UNFORMATTED_ZONES_LIST)));
        return queryResponseMap;
    }

    /**
    * Gets the WHERE query clause for use in a database query.
    *
    * @param    nameSearchInput                     User input for 'Name Search' text box.
    * @param    locationObject                      Location Information for geolocation search.
    * @param    recordTypeDeveloperNamesList        List of zone record types to be used in search.
    *
    * @return                                       Map of the completed WHERE query clause.
    * @since                                        1.0
    */
    @TestVisible
    protected virtual String getQueryWhereClause(String nameSearchInput, Map<Object, Object> locationObject, List<String> recordTypeDeveloperNamesList) {
        String whereClause = '';
        String whereClausePrefix = ' WHERE ';
        if (recordTypeDeveloperNamesList != null && !recordTypeDeveloperNamesList.isEmpty()) {
            whereClause = whereClausePrefix + ' RecordType.DeveloperName IN (\'' + String.join(recordTypeDeveloperNamesList, '\', \'') + '\') ';
            whereClausePrefix = ' AND ';
        }

        if (String.isBlank(nameSearchInput) && (locationObject == null || locationObject.isEmpty())) {
            System.debug('The zone search information provided is null or empty.');
            return whereClause;
        }

        if (String.isNotBlank(nameSearchInput)) {
            whereClause = whereClause + whereClausePrefix + ' Name LIKE \'%' + String.escapeSingleQuotes(nameSearchInput) + '%\' ';
            whereClausePrefix = ' AND ';
        }

        String locationClause = new PORTAL_AddressWrapper(locationObject).toQueryClause(PORTAL_CONST_ClubAndGroups.LOCATION_FIELD_MAPPING);

        if (String.isNotBlank(locationClause)) {
            whereClause = whereClause + whereClausePrefix + locationClause;
        }

        return whereClause;
    }
    
    /**
     * Helper method to use the page section adapter to do the actual query to get zone records for the search
     * and other necessary data that the adapter is needed for
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param dynamicWhereClause    String: where clause to use for dynamic query class
     * @param offset                Integer: offset value to use for dynamic query class
     * 
     * @return Map<String, Object> with the following key/pair values: 
     *      unformattedZoneList => List<Map<String, Object>>: unformatted zone records returned by the query
     *      hasMoreRecords      => Boolean: true if the query has more results that can be queried later
     *      frontEndDataMap     => Map<String, Object> front end field map
     */
    protected virtual Map<String, Object> queryForZoneRecords(String dynamicWhereClause, Integer offset) {
        Map<String, Object> resultMap = new Map<String, Object>();

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.dynamicWhereClause = dynamicWhereClause;
        dynamicQueryObject.offset = offset;

        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(ZONE_SEARCH)
                                                                                              .buildMainSectionName(ZONE_SEARCH)
                                                                                              .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{ZONE_SEARCH => dynamicQueryObject})
                                                                                              .build();

        if (pageSectionAdapter == null) {
            return resultMap;
        }

        Map<String, Object> backendDataMap = pageSectionAdapter.getBackEndDataMap();
        Integer originalLimit = Integer.valueOf(((Map<String, Object>) backendDataMap?.get(ZONE_RECORDS))?.get(PORTAL_UTIL_PageSectionSetting.MAX_NUMBER_OF_QUERY_RECORDS));
        if (originalLimit != null && originalLimit > 0) {
            dynamicQueryObject.maxItems = originalLimit + 1;
        }

        List<Map<String, Object>> zoneList = pageSectionAdapter.getRecords()
                                                               .get(ZONE_SEARCH)
                                                               .get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);

        if (dynamicQueryObject.maxItems != null && zoneList.size() == dynamicQueryObject.maxItems) {
            zoneList.remove(zoneList.size() - 1);
            resultMap.put(HAS_MORE_RECORDS, true);
        }

        resultMap.put(UNFORMATTED_ZONES_LIST, zoneList);
        resultMap.put(FRONT_END_DATA_MAP, pageSectionAdapter.getFrontEndDataMap());
        return resultMap;
    }

    /**
    * Updates available zone record maps with associated zone memberships and available social media platforms.
    *
    * @param    zoneDataList                        List of zone record data.
    *
    * @return                                       List of updated zone records.
    * @since                                        1.0
    */
    @TestVisible
    protected virtual List<Map<String, Object>> getFormattedZoneList(List<Map<String, Object>> zoneDataList) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        if (zoneDataList == null || zoneDataList.isEmpty()) {
            return resultList;
        }

        for (Map<String, Object> eachZoneDataMap : zoneDataList) {
            Map<String, Object> formattedZoneRecordMap = getFormattedZoneRecord(eachZoneDataMap);
            List<Map<String, String>> formattedSocialMediaList = getSocialMediaList(eachZoneDataMap);

            if (formattedSocialMediaList == null || formattedSocialMediaList.isEmpty()) {
                formattedZoneRecordMap.put(SOCIAL_MEDIA, null);
            } else {
                formattedZoneRecordMap.put(SOCIAL_MEDIA, formattedSocialMediaList);
            }

            resultList.add(formattedZoneRecordMap);
        }

        return resultList;
    }

    /**
    * Updates an individual zone record with additional details if they are available.
    *
    * @param    formattedZoneRecord                 List containing map of a formatted zone record.
    * @param    zoneRecord                          Non-formatted zone record containing data to be moved to formattedZoneRecord.
    *
    * @return                                       Formatted zone record possibly containing new fields.
    * @since                                        1.0
    */
    @TestVisible
    protected virtual Map<String, Object> getFormattedZoneRecord(Map<String, Object> zoneDataMap) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (zoneDataMap == null || zoneDataMap.isEmpty()) {
            System.debug('Current Zone record is empty or null.');
            return resultMap;
        }

        resultMap = zoneDataMap;

        List<Map<String, Object>> zoneMembershipsList = (List<Map<String, Object>>)zoneDataMap.get(ZONE_MEMBERSHIPS);

        if (zoneMembershipsList == null || zoneMembershipsList.isEmpty()) {
            return resultMap;
        }

        // Nullcheck for Board_Member_Title__c field of zone membership
        if (String.isNotBlank((String)zoneMembershipsList.get(0).get(CONTACT_TITLE))) {
            resultMap.put(CONTACT_TITLE, zoneMembershipsList.get(0).get(CONTACT_TITLE));
        }

        // Nullcheck for Constituent__r.Name
        if (String.isNotBlank((String)zoneMembershipsList.get(0).get(CONTACT_NAME))) {
            resultMap.put(CONTACT_NAME, zoneMembershipsList.get(0).get(CONTACT_NAME));
        }

        // Nullcheck for Constituent__r.Email
        if (String.isNotBlank((String)zoneMembershipsList.get(0).get(CONTACT_EMAIL))) {
            resultMap.put(CONTACT_EMAIL, zoneMembershipsList.get(0).get(CONTACT_EMAIL));
        }

        // Nullcheck for Constituent__r.Phone
        if (String.isNotBlank((String)zoneMembershipsList.get(0).get(CONTACT_PHONE))) {
            resultMap.put(CONTACT_PHONE, zoneMembershipsList.get(0).get(CONTACT_PHONE));
        }

        return resultMap;
    }

    /**
    * Gets available social media for a given zone record.
    *
    * @param    zoneRecord                          Zone record possibly containing social media.
    *
    * @return                                       List of social media for a given zone record.
    * @since                                        1.0
    */
    @TestVisible
    protected virtual List<Map<String, String>> getSocialMediaList(Map<String, Object> zoneDataMap) {
        List<Map<String, String>> socialMediaList = new List<Map<String, String>>();

        if (zoneDataMap == null || zoneDataMap.isEmpty() || !zoneDataMap.containsKey(SOCIAL_MEDIA_ORDER) ||
            String.isBlank((String)zoneDataMap.get(SOCIAL_MEDIA_ORDER))) {
            return socialMediaList;
        }

        String socialMediaString = (String)zoneDataMap.get(SOCIAL_MEDIA_ORDER);
        List<String> socialMediaNameList = socialMediaString.split(';');

        for (String eachSocialMediaName : socialMediaNameList) {
            Map<String, String> socialMediaMap = getSocialMediaInfoFromLogo(zoneDataMap, eachSocialMediaName);

            if (socialMediaMap == null || socialMediaMap.isEmpty()) {
                continue;
            }

            socialMediaList.add(socialMediaMap);

            if (socialMediaList.size() >= 3) {
                break;
            }
        }

        return socialMediaList;
    }

    /**
    * Determines which social media platform is being used and gets info about that platform.
    *
    * @param    zoneDataMap                        Map with zone data containing fields that link to social media.
    * @param    socialMediaName                    String containing name of a social media platform.
    *
    * @return                                      Map containing info about a social media platform.
    * @since                                       1.0
    */
    @TestVisible
    protected virtual Map<String, String> getSocialMediaInfoFromLogo(Map<String, Object> zoneDataMap,
                                                                     String socialMediaName) {
        Map<String, String> logoInfoMap = new Map<String, String>();

        if (zoneDataMap == null || zoneDataMap.isEmpty()|| String.isBlank(socialMediaName)) {
            return logoInfoMap;
        }


        String logoURL = '';

        if (socialMediaName == FACEBOOK && String.isNotBlank((String)zoneDataMap.get(FACEBOOK_LINK))) {
            logoInfoMap.put(LOGO_LINK, (String)zoneDataMap.get(FACEBOOK_LINK));
            logoURL = getSocialMediaLogoURL(FACEBOOK_LOGO);
        } else if (socialMediaName == LINKED_IN && String.isNotBlank((String)zoneDataMap.get(LINKED_IN_LINK))) {
            logoInfoMap.put(LOGO_LINK, (String)zoneDataMap.get(LINKED_IN_LINK));
            logoURL = getSocialMediaLogoURL(LINKED_IN_LOGO);
        } else if (socialMediaName == INSTAGRAM && String.isNotBlank((String)zoneDataMap.get(INSTAGRAM_LINK))) {
            logoInfoMap.put(LOGO_LINK, (String)zoneDataMap.get(INSTAGRAM_LINK));
            logoURL = getSocialMediaLogoURL(INSTAGRAM_LOGO);
        } else if (socialMediaName == TWITTER && String.isNotBlank((String)zoneDataMap.get(TWITTER_LINK))) {
            logoInfoMap.put(LOGO_LINK, (String)zoneDataMap.get(TWITTER_LINK));
            logoURL = getSocialMediaLogoURL(TWITTER_LOGO);
        } else if (socialMediaName == WE_CHAT && String.isNotBlank((String)zoneDataMap.get(WE_CHAT_LINK))) {
            logoInfoMap.put(LOGO_LINK, (String)zoneDataMap.get(WE_CHAT_LINK));
            logoURL = getSocialMediaLogoURL(WE_CHAT_LOGO);
        }

        logoInfoMap.put(LOGO_URL, logoURL);

        return logoInfoMap;
    }

    /**
     *
     * @author:                 Sean Tang
     * @since:                  1.0
     *
     *
     * @return                      String of the social media logo's url from static resources
     */
    @TestVisible
    protected virtual String getSocialMediaLogoURL(String logoName) {
        return PORTAL_CommunityUtils.getBaseUrl() + RESOURCE_PATH + SOCIAL_MEDIA_FIELD_TO_STATIC_RESOURCE_MAP.get(logoName);
    }
}