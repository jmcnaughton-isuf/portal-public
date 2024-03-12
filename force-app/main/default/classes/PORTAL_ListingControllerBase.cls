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
 * Base class containing logic for the listing search
 *
 * @author Aaron Wong
 * @version     1.0
 * @since       1.0
 */
global inherited sharing virtual class PORTAL_ListingControllerBase {
    public static final String ADDITIONAL_PARAMS = 'additionalParams';
    public static final String EVENT_DATE = 'eventDate';
    public static final String LISTING_DETAILS = 'listingDetails';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String PAGE_NAME = 'pageName';
    public static final String PROFILE_KEY = 'profile';
    public static final String RECORD_ID = 'recordId';
    public static final String RECORD_NAME = 'recordName';
    public static final String RECORDS_KEY = 'records';
    public static final String SUB_SECTION_NAME = 'subSectionName';
    public static final String KEYWORD_KEY = 'keyword';
    public static final String CATEGORY_KEY = 'category';
    public static final String WHERE_CLAUSE = 'whereClause';
    public static final String ID_LIST = 'idList';
    public static final String RECORD_TYPE = 'recordType';
    public static final String IS_SOLD_OUT = 'isSoldOut';
    public static final String PRIMARY_PARTICIPATION_ID = 'primaryParticipationId';
    public static final String SCOPE_KEY = 'scope';
    public static final String RELEVANCE_KEY = 'relevance';
    public static final String SHARING_KEY = 'sharing';
    public static final String CURRENT_KEY = 'Current';
    public static final String PAST_KEY = 'Past';
    public static final String ME_KEY = 'Me';
    public static final String RECOMMENDED_KEY = 'Recommended';
    public static final String NON_RECOMMENDED = 'Non-Recommended';
    public static final String CURRENT_USER = 'currentUser';
    public static final String LISTING_CONFIGURATIONS = 'listingConfigurations';
    public static final String PORTAL_ZONE = 'portalZone';
    public static final String FIELD_CLAUSE = 'fieldClause';
    public static final String SECTION_TO_APPLY = 'sectionToApply';
    public static final String PAGE_SECTION_LIST = 'pageSectionList';
    public static final String CREATED_BY_USER_ID = 'createdByUserId';
    public static final String TOPIC_KEY = 'topic';
    public static final String FORMAT_KEY = 'format';
    public static final String ARTICLE_LENGTH_KEY = 'articleLength';
    public static final String LOCATION_KEY = 'location';
    public static final String CITY_KEY = 'city';
    public static final String STATE_KEY = 'state';
    public static final String POSTAL_CODE = 'postalCode';
    public static final String COUNTRY_KEY = 'country';
    public static final String RADIUS_KEY = 'radius';
    public static final String ACTION_ON_CONTENT_IN_KEY = 'actionOnContentINWhereClause';
    public static final String ACTION_ON_CONTENT_NOT_IN_KEY = 'actionOnContentNOTINWhereClause';
    public static final String IS_ACTION_ON_CONTENT_FOR_ALL_USERS = 'isActionOnContentForAllUsers';
    public static final String ACTION_TO_TAKE_KEY = 'actionToTake';
    public static final String BOOKMARKED = 'bookmark';
    public static final String NOT_INTERESTED = 'notInterested';
    public static final String FRONT_END_DATA_KEY = 'frontEndData';
    public static final String QUERY_LIMIT = 'totalListings';
    public static final String FEATURED_NEWS_RECORDS_KEY = 'Featured_News';
    public static final string OFFSET_KEY = 'offset';
    public static final String IS_SHOW_ONLINE_EVENTS = 'isShowOnlineEvents';
    public static final String IS_SHOW_ONLINE_EVENTS_ONLY = 'isShowOnlineEventsOnly';
    public static final String IS_SHOW_FEATURED_ONLY = 'isShowFeaturedOnly';
    public static final String ZONE_NAME = 'zoneName';
    public static final String LISTING_DETAIL_PAGE = 'Listing Detail Page';  // page name for Listing detail page
    public static final String LISTING_DETAIL = 'Listing Detail'; // main section name for listing detail page
    public static final String LOOK_WHOS_COMING_PAGE = 'Look Who Is Coming';
    public static final String LOOK_WHOS_COMING_MAIN_SECTION = 'Look Who Is Coming List';
    public static final String ID_CONST = 'Id';
    public static final String IS_NOT_INTERESTED = 'isNotInterested';
    public static final String IS_BOOKMARKED = 'isBookmarked';
    public static final Id FAKE_GUEST_ID = '000000000000000000';

    public static final String ERROR_NO_RECORD_ID_NAME = 'Please provide either a Record ID or Name.';
    public static final String ERROR_NOT_FOUND = 'The server could not find the associated application.';
    public static final String ERROR_INVALID_CONFIGURATION = 'Something went wrong when trying to get the Listings\' configurations. Please contact an administrator.';

    protected virtual PORTAL_PageSectionAdapter.Builder getPageSectionAdapterBuilder() {
        return new PORTAL_PageSectionAdapter.Builder();
    }

     /** Gets listings using the Page Section Custom Metadata.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Custom Metadata.
     * @param mainSectionName       The main section name of the Portal Page Section Custom Metadata.
     * @param subSectionName        The sub section name of the Portal Page Section Custom Metadata.
     * @param additionalParams      Any additional paramaters to filter the Listings by in a Map.
     * @param cookieId              String: session cookie to use for getting pending guest participations 
     * 
     * @return                      List of Maps containing listing information.
     * @since                       1.0
     */
    global virtual List<Map<String, Object>> getListings(Map<String, Object> params) {
        if (params == null) {
            return new List<Map<String, Object>>();
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        Map<Object, Object> additionalParams = (Map<Object, Object>)params.get(ADDITIONAL_PARAMS);
        String cookieId = (String)params.get(PORTAL_ShoppingCartControllerBase.COOKIE_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            return new List<Map<String, Object>>();
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (pageSectionList == null || pageSectionList.isEmpty()) {
            return new List<Map<String, Object>>();
        }

        Map<String, Object> listingConfigurations = getListingConfigurationsFromPageSectionSettings(pageSectionList);

        User currentUser = getUserWithRecommendedTypes();

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = getDynamicQueryForListings(new Map<String, Object>{LISTING_CONFIGURATIONS => listingConfigurations,
                                                                                                                                 CURRENT_USER => currentUser,
                                                                                                                                 ADDITIONAL_PARAMS => additionalParams});
        if (isUsingRecommendationEngine(listingConfigurations) == true) {
            return getRecommendedContent(pageName, mainSectionName, subSectionName, pageSectionList, dynamicQueryObject, listingConfigurations, currentUser);
        }

        String sectionToApply = subSectionName;
        if (String.isBlank(subSectionName)) {
            subSectionName = RECORDS_KEY;
            sectionToApply = mainSectionName;
        }

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(
                                                                                getControllingContactId(),
                                                                                PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList), 
                                                                                new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{sectionToApply => dynamicQueryObject}, 
                                                                                false, 
                                                                                true);

        if (recordsMap == null || recordsMap.get(mainSectionName) == null || recordsMap.get(mainSectionName).get(subSectionName) == null) {
            return new List<Map<String, Object>>();
        }

        return postProcessListings(recordsMap.get(mainSectionName).get(subSectionName), listingConfigurations, cookieId);
    }

    /**
     * Queries custom metadata to get text used for listing buttons.
     *
     * @author Aaron Wong
     *
     * @return      Map of Button Text.
     * @since       1.0
     */
    global virtual Map<String, Object> getListingButtonText(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>{
            PORTAL_CONST_Listing.ORG_SETTING_EVENT_MODIFY_REGISTRATION_TEXT => PORTAL_CONST_Listing.MODIFY_REGISTRATION_TEXT_DEFAULT,
            PORTAL_CONST_Listing.ORG_SETTING_EVENT_REGISTER_TEXT => PORTAL_CONST_Listing.REGISTER_TEXT_DEFAULT,
            PORTAL_CONST_Listing.ORG_SETTING_EVENT_SOLD_OUT_TEXT => PORTAL_CONST_Listing.SOLD_OUT_TEXT_DEFAULT,
            PORTAL_CONST_Listing.ORG_SETTING_EVENT_VIEW_EVENT_TEXT => PORTAL_CONST_Listing.VIEW_EVENT_TEXT_DEFAULT,
            PORTAL_CONST_Listing.ORG_SETTING_EVENT_LOOK_WHOS_COMING_TEXT => PORTAL_CONST_Listing.LOOK_WHOS_COMING_TEXT_DEFAULT
        };

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => PORTAL_CONST_Listing.ORG_SETTING_BUTTON_TEXT_DEVELOPER_NAMES
        });


        if (orgSettingList == null || orgSettingList.isEmpty()) {
            return resultMap;
        }

        for (Portal_Organization_Setting__mdt eachOrgSetting : orgSettingList) {
            if (String.isNotBlank(eachOrgSetting.Value__c)) {
                resultMap.put(eachOrgSetting.DeveloperName, eachOrgSetting.Value__c);
            }
        }

        return resultMap;
    }

    /**
     * Generates the dynamic portion of the Listing query when getting Listings using the Portal Page Section Settings.
     *
     * @author Aaron Wong
     *
     * @param currentUser       The current User.
     * @param additionalParams  Additional parameters to filter the query by.
     * @return                  DynamicQueryClass containing the dynamic query portion.
     * @since                   1.0
     */
    public static PORTAL_UTIL_PageSectionSetting.DynamicQueryClass getDynamicQueryForListings(Map<String, Object> params) {
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass resultQueryClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();

        if (params == null || params.isEmpty()) {
            return resultQueryClass;
        }

        Map<Object, Object> additionalParams = (Map<Object, Object>)params.get(ADDITIONAL_PARAMS);

        resultQueryClass.offset = getDynamicOffsetForListings(additionalParams);

        Map<String, Object> listingConfigurations = (Map<String, Object>)params.get(LISTING_CONFIGURATIONS);

        if (listingConfigurations == null || listingConfigurations.isEmpty()) {
            return resultQueryClass;
        }

        User currentUser = (User)params.get(CURRENT_USER);
        params.put(CURRENT_USER, currentUser);

        resultQueryClass.dynamicWhereClause = getDynamicWhereClauseForListings(listingConfigurations, currentUser, additionalParams);


        return resultQueryClass;
    }

    /**
     * Get listing configurations from the associated Portal Page Section Setting.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Custom Metadata.
     * @param mainSectionName       The main section name of the Portal Page Section Custom Metadata.
     * @param subSectionName        The sub section name of the Portal Page Section Custom Metadata.
     * @return                      The listing configurations.
     * @since                       1.0
     */
    public virtual Map<String, Object> getListingConfigurations(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            return resultMap;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (pageSectionList == null || pageSectionList.isEmpty()) {
            return resultMap;
        }

        resultMap = getListingConfigurationsFromPageSectionSettings(pageSectionList);

        return resultMap;
    }

    /**
     * Gets listing configurations from a list of Page Section Settings.
     *
     * @author Aaron Wong
     *
     * @param pageSectionList   List of Page Section Settings.
     * @return                  Map of Listing configurations.
     * @since                   1.0
     */
    @TestVisible
    private static Map<String, Object> getListingConfigurationsFromPageSectionSettings(List<Portal_Page_Section_Setting__mdt> pageSectionList) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (pageSectionList == null || pageSectionList.isEmpty()) {
            return resultMap;
        }

        for (Portal_Page_Section_Setting__mdt eachPageSection : pageSectionList) {
            if (eachPageSection.Is_Child__c != true && String.isNotBlank(eachPageSection.Listing_Configurations__c)) {
                try {
                    resultMap = (Map<String, Object>)JSON.deserializeUntyped(eachPageSection.Listing_Configurations__c);
                } catch(Exception e) {
                    throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INVALID_CONFIGURATION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
                }
                // There should only be one non-child Page Section Setting when getting listing configurations
                break;
            }
        }

        return resultMap;
    }

    /**
     * Determines whether to use the recommendation engine when getting Listings.
     *
     * @author Aaron Wong
     *
     * @param listingConfigurations     Map of listing configurations.
     * @return                          Whether or not to use the recommendation engine.
     * @since                           1.0
     */
    @TestVisible
    private static Boolean isUsingRecommendationEngine(Map<String, Object> listingConfigurations) {
        if (listingConfigurations == null || listingConfigurations.isEmpty()) {
            return false;
        }

        if ((String)listingConfigurations.get(RELEVANCE_KEY) == RECOMMENDED_KEY) {
            return true;
        }

        return false;
    }

    /**
     * Gets recommended content using the Recommendation Engine.
     *
     * @author Aaron Wong
     *
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param mainSectionName           Main Section Name of the Portal Page Section Setting to use.
     * @param subSectionName            Sub Section Name of the Portal Page Section Setting to use.
     * @param pageSectionList           List of Portal Page Section Settings.
     * @param dynamicQueryObject        Dynamic query clauses to use with the Portal Page Section Settings.
     * @param listingConfigurations     Map of Listing Configurations.
     * @param currentUser               The current user.
     * @return                          List of recommended content to display to the user.
     * @since                           1.0
     */
    private static List<Map<String, Object>> getRecommendedContent(String pageName,
                                                                   String mainSectionName,
                                                                   String subSectionName,
                                                                   List<Portal_Page_Section_Setting__mdt> pageSectionList,
                                                                   PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject,
                                                                   Map<String, Object> listingConfigurations,
                                                                   User currentUser) {

        List<String> recommendationTypeList = getRecommendationTypeList(currentUser);
        String currentUserType = UserInfo.getUserType();
        //Comment this part out if don't want to call recommendation engine
        //Recommendation start
        List<Map<String, Object>> recommendedListingList = PORTAL_ActionOnContentController.getRecommendedContent(new Map<String, Object> {
                                                                                                        PORTAL_CONST_ActionOnContent.USER_ID_KEY => UserInfo.getUserId(),
                                                                                                        PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => currentUserType,
                                                                                                        PORTAL_CONST_ActionOnContent.PAGE_NAME_KEY => pageName,
                                                                                                        PORTAL_CONST_ActionOnContent.MAIN_SECTION_NAME_KEY => mainSectionName,
                                                                                                        PORTAL_CONST_ActionOnContent.SUB_SECTION_NAME_KEY => subSectionName,
                                                                                                        PORTAL_CONST_ActionOnContent.MAX_ITEMS_KEY => (Integer)Integer.valueOf(listingConfigurations.get('maxItems')),
                                                                                                        PORTAL_CONST_ActionOnContent.RECOMMENDATION_TYPE_LIST_KEY => recommendationTypeList,
                                                                                                        PORTAL_CONST_ActionOnContent.PAGE_SECTION_LIST_KEY => pageSectionList,
                                                                                                        PORTAL_CONST_ActionOnContent.DYNAMIC_QUERY_OBJECT_KEY => dynamicQueryObject,
                                                                                                        PORTAL_CONST_ActionOnContent.RECOMMENDATION_TYPE_LIST_KEY => recommendationTypeList});

        return recommendedListingList;
    }

    /**
     * Generates an offset based on the params passed in, or 0 if no param exists.
     *
     * @author Sam Longo
     *
     * @param additionalParams          params passed from frontend
     * @return                          Integer offset
     * @since                           1.0
     */
    private static Integer getDynamicOffsetForListings(Map<Object, Object> additionalParams) {
        if (additionalParams != null && additionalParams.get(OFFSET_KEY) != null) {
            return (Integer) Integer.valueOf((Decimal)additionalParams.get(OFFSET_KEY));
        }
        return null;
    }

    /**
     * Generates a where clause based on the Listing Configurations given.
     *
     * @author Aaron Wong
     *
     * @param listingConfigurations     Map of Listing Configurations.
     * @param currentUser               The current User.
     * @return                          SOQL where clause.
     * @since                           1.0
     */
    private static String getDynamicWhereClauseForListings(Map<String, Object> listingConfigurations,
                                                           User currentUser,
                                                           Map<Object, Object> additionalParams) {
        String resultString = '';

        // To simplify logic in query functions to always start with 'AND '
            resultString = ' WHERE id != null ';


        resultString = resultString + getListingsScopeClause((String)listingConfigurations.get(SCOPE_KEY));
        resultString = resultString + getActionOnContentParamClause((String)listingConfigurations.get(ACTION_ON_CONTENT_IN_KEY),
                                                                    (String)listingConfigurations.get(ACTION_ON_CONTENT_NOT_IN_KEY),
                                                                    (Boolean)listingConfigurations.get(IS_ACTION_ON_CONTENT_FOR_ALL_USERS), 
                                                                    currentUser);
        resultString = resultString + getListingsPortalZoneClause((String)listingConfigurations.get(PORTAL_ZONE));
        resultString = resultString + getListingsSharingClause((String)listingConfigurations.get(SHARING_KEY), currentUser);
        resultString = resultString + getListingsRelevanceClause((String)listingConfigurations.get(RELEVANCE_KEY), currentUser);
        resultString = resultString + getListingsRadiusClause((String)listingConfigurations.get(RADIUS_KEY), currentUser, additionalParams);
        resultString = resultString + getListingsAdditionalParamClause(additionalParams);

        return resultString;
    }

    /**
     * Gets the current user with recommended types.
     *
     * @author Aaron Wong
     *
     * @return  The current user with recommended types.
     * @since   1.0
     */
    private static User getUserWithRecommendedTypes() {
        Id userId = UserInfo.getUserId();

        User usr = [SELECT Id, ContactId, ucinn_portal_Recommend_Type_1__c, ucinn_portal_Recommend_Type_2__c, ucinn_portal_Recommend_Type_3__c
                    FROM User
                    WHERE Id = :userId];

        return usr;
    }

    /**
     * Generates the scope portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param scope     The scope to query Listings for.
     * @return          The scope portion of the where clause.
     * @since           1.0
     */
    @TestVisible
    private static String getListingsScopeClause(String scope) {
        String resultString = '';
        String currentGMTTime = DateTime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        if (String.isBlank(scope) || scope == 'All') {
            return resultString;
        }

        if (scope == CURRENT_KEY) {
            resultString = ' AND Start_Date_Time__c < ' + currentGMTTime + ' AND (End_Date_Time__c > ' + currentGMTTime + ' OR End_Date_Time__c = NULL)';
        }

        if (scope == PAST_KEY) {
            resultString = ' AND End_Date_Time__c < ' + currentGMTTime;
        }

        return resultString;
    }

    /**
     * Generates the Portal Zone portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param portalZoneString      The portal zones (';' seperated) to query the Listings for.
     * @return                      The portal zone portion of the where clause.
     * @since                       1.0
     */
    @TestVisible
    private static String getListingsPortalZoneClause(String portalZoneString) {
        String resultString = '';

        if (String.isBlank(portalZoneString)) {
            return resultString;
        }

        List<String> portalZoneList = portalZoneString.split(';');

        resultString = ' AND Portal_Zone__c INCLUDES (\'All\', \'' + String.join(portalZoneList, '\', \'') + '\') ';
        resultString = resultString + ' AND Portal_Zones_to_Exclude__c EXCLUDES (\'' + String.join(portalZoneList, '\', \'') + '\') ';

        return resultString;
    }

    /**
     * Generates the Sharing portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param sharing       The sharing configuration for the query.
     * @param currentUser   The current user.
     * @return              The Sharing portion of the where clause.
     * @since               1.0
     */
    @TestVisible
    private static String getListingsSharingClause(String sharing, User currentUser) {
        String resultString = '';

        if (String.isBlank(sharing)) {
            return resultString;
        }

        if (sharing == ME_KEY && currentUser != null && String.isNotBlank(currentUser.ContactId)) {
            resultString = ' AND Id IN (SELECT Listing__c FROM ucinn_portal_Participation__c WHERE Purchasing_Constituent__c = \'' + currentUser.ContactId + '\' AND Status__c = \'' + PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED + '\') ';
        }

        return resultString;
    }

    /**
     * Generates the Relevance portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param relevance     The relevance configuration for the query.
     * @param currentUser   The current user.
     * @return              The Relevance portion of the where clause.
     * @since               1.0
     */
    @TestVisible
    private static String getListingsRelevanceClause(String relevance, User currentUser) {
        String resultString = '';

        if (String.isBlank(relevance)) {
            return resultString;
        }

        if (relevance == NON_RECOMMENDED && currentUser != null) {
            List<String> recommendationTypeList = new List<String>(getRecommendationTypeSet(currentUser));

            if (!recommendationTypeList.isEmpty()) {
                String recommendationTypeListString = '(\'' + String.join(recommendationTypeList, '\', \'')+ '\') ';

                resultString = ' AND Recommend_Type_1__c NOT IN ' + recommendationTypeListString +
                    ' AND Recommend_Type_2__c NOT IN ' + recommendationTypeListString +
                    ' AND Recommend_Type_3__c NOT IN ' + recommendationTypeListString +
                    ' AND Recommend_Type_4__c NOT IN ' + recommendationTypeListString +
                    ' AND Recommend_Type_5__c NOT IN ' + recommendationTypeListString;
            }
        }

        return resultString;
    }

    /**
     * Generates the Radius portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param radius        The radius configuration for the query.
     * @param currentUser   The current user.
     * @return              The radius portion of the where clause.
     * @since               1.0
     */
    @TestVisible
    private static String getListingsRadiusClause(String radius, User currentUser, Map<Object, Object> additionalParams) {
        String resultString = '';

        if (String.isBlank(radius) || currentUser == null || String.isBlank(currentUser.ContactId)) {
            return resultString;
        }

        List<Contact> contactList = [SELECT id, ucinn_ascendv2__Preferred_Address_Geolocation__c
                                     FROM Contact
                                     WHERE id = :currentUser.ContactId];

        if (contactList == null || contactList.isEmpty() || contactList.get(0).ucinn_ascendv2__Preferred_Address_Geolocation__c == null) {
            return resultString;
        }

        resultString = ' AND DISTANCE (Geolocation__c , GEOLOCATION(' + contactList.get(0).ucinn_ascendv2__Preferred_Address_Geolocation__c.getLatitude() + ', ' + contactList.get(0).ucinn_ascendv2__Preferred_Address_Geolocation__c.getLongitude() + '), \'mi\') < ' + radius + ' ';

        if (additionalParams != null && additionalParams.get(IS_SHOW_ONLINE_EVENTS) == true) {
            resultString = ' AND (DISTANCE (Geolocation__c , GEOLOCATION(' + contactList.get(0).ucinn_ascendv2__Preferred_Address_Geolocation__c.getLatitude() + ', ' + contactList.get(0).ucinn_ascendv2__Preferred_Address_Geolocation__c.getLongitude() + '), \'mi\') < ' + radius + ' '
                            + ' OR Is_Online_Event__c = true) ';
        }

        return resultString;
    }

    /**
     * Generates the Additional Params portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param additionalParams  The additional params for the query.
     * @param currentUser       The current user.
     * @return                  The Additional Param portion of the where clause.
     * @since                   1.0
     */
    @TestVisible
    private static String getListingsAdditionalParamClause(Map<Object, Object> params) {
        String resultString = '';

        if (params == null || params.isEmpty()) {
            return resultString;
        }

        if (params.containsKey(EVENT_DATE) && String.isNotBlank((String)params.get(EVENT_DATE))) {
            resultString = resultString + getEventDateClause((String)params.get(EVENT_DATE));
        }

        if (params.containsKey(ID_LIST) && params.get(ID_LIST) != null && !((List<String>)params.get(ID_LIST)).isEmpty()) {
            resultString = resultString + ' AND id IN (\'' + String.join((List<String>)params.get(ID_LIST), '\',\'') + '\') ';
        }

        if (params.containsKey(CATEGORY_KEY) && String.isNotBlank((String)params.get(CATEGORY_KEY))) {
            resultString = resultString + ' AND Category__c INCLUDES (\'' + String.escapeSingleQuotes((String)params.get(CATEGORY_KEY)) + '\')';
        }

        if (params.containsKey(LOCATION_KEY) && params.get(LOCATION_KEY) != null) {
            resultString = resultString + getLocationClause((Map<Object, Object>)params.get(LOCATION_KEY));
        }

        if (params.containsKey(CREATED_BY_USER_ID) && String.isNotBlank((String)params.get(CREATED_BY_USER_ID))) {
            resultString = resultString + ' AND CreatedById = \'' + String.escapeSingleQuotes((String)params.get(CREATED_BY_USER_ID)) + '\' ';
        }

        if (params.containsKey(IS_SHOW_ONLINE_EVENTS_ONLY) && (Boolean)params.get(IS_SHOW_ONLINE_EVENTS_ONLY) == true) {
            resultString = resultString + ' AND Is_Online_Event__c = true ';
        }

        if (params.containsKey(IS_SHOW_FEATURED_ONLY) && (Boolean)params.get(IS_SHOW_FEATURED_ONLY) == true) {
            resultString = resultString + ' AND Is_Featured__c = true ';
        }

        if (params.containsKey(TOPIC_KEY) && String.isNotBlank((String)params.get(TOPIC_KEY))) {
            String topic = (String)params.get(TOPIC_KEY);
            resultString = resultString +   ' AND (Recommend_Type_1__c = \'' + topic + '\'' +
                                            ' OR Recommend_Type_2__c = \'' + topic + '\'' +
                                            ' OR Recommend_Type_3__c = \'' + topic + '\'' +
                                            ' OR Recommend_Type_4__c = \'' + topic + '\'' +
                                            ' OR Recommend_Type_5__c = \'' + topic + '\'' + ')';
        }

        if (params.containsKey(FORMAT_KEY) && String.isNotBlank((String)params.get(FORMAT_KEY))) {
            resultString = resultString + ' AND Format__c = \'' + String.escapeSingleQuotes((String)params.get(FORMAT_KEY)) + '\'';
        }

        if (params.containsKey(ARTICLE_LENGTH_KEY) && String.isNotBlank((String)params.get(ARTICLE_LENGTH_KEY))) {
            resultString = resultString + ' AND Article_Length__c = \'' + String.escapeSingleQuotes((String)params.get(ARTICLE_LENGTH_KEY)) + '\'';
        }

        if (params.containsKey(ZONE_NAME) && String.isNotBlank((String)params.get(ZONE_NAME))) {
            resultString = resultString + ' AND Portal_Zone__c INCLUDES (\'' + String.escapeSingleQuotes((String)params.get(ZONE_NAME)) + '\', \'ALL\') ';
            resultString = resultString + ' AND Portal_Zones_To_Exclude__c EXCLUDES (\'' + String.escapeSingleQuotes((String)params.get(ZONE_NAME)) + '\') ';
        }

        return resultString;
    }


    /**
     * Generates the Action On Content portion of the where clause.
     * Split into IN clause and NOT IN clause to help prevent dynamic query too complex issues with large numbers of ids
     *
     * @author Sam Longo
     *
     * @param actionOnContentINWhereClause  the where clause to restrict listings to only action on contents returned by this clause
     * @param actionOnContentNOTINWhereClause the where clause to restrict listings by action on contents not returned by this clause
     * @param isActionOnContentForAllUsers boolean specifying if we should get action on content records for all users or not
     * @param currentUser       The current user.
     * @return                  The Additional Param portion of the where clause.
     * @since                   1.0
     */
    @TestVisible
    private static String getActionOnContentParamClause(String actionOnContentINWhereClause, String actionOnContentNOTINWhereClause, Boolean isActionOnContentForAllUsers, User currentUser) {
        String resultString = '';

        if (currentUser == null || (String.isBlank(actionOnContentINWhereClause) && String.isBlank(actionOnContentNOTINWhereClause))) {
            return resultString;
        }

        String queryStringTemplate = 'SELECT Listing__c FROM ucinn_portal_Action_On_Content__c WHERE ';
        
        if (isActionOnContentForAllUsers != true) {
            queryStringTemplate = queryStringTemplate + ' User__c = \'' + currentUser.Id + '\' AND ';
        }

        if(String.isNotBlank(actionOnContentINWhereClause)) {
            List<ucinn_portal_Action_On_Content__c> actionOnContents = Database.query(queryStringTemplate + actionOnContentINWhereClause);

            if (!actionOnContents.isEmpty()) {
                String idString = createListingIdString(actionOnContents);

                resultString = ' AND Id IN ' + idString;
            } else {
                resultString = ' AND Id = null '; //if there were no action on contents for the IN clause we want no listings to be returned
            }
        }

        if (String.isNotBlank(actionOnContentNOTINWhereClause)) {
            List<ucinn_portal_Action_On_Content__c> actionOnContents = Database.query(queryStringTemplate + actionOnContentNOTINWhereClause);

            if (!actionOnContents.isEmpty()) {
                String idString = createListingIdString(actionOnContents);

                resultString = resultString + ' AND Id NOT IN ' + idString;
            }
        }

        return resultString;
    }

    /**
     * Generates a string representation of a comma separated list from a list of action on contents
     *
     * @author Sam Longo
     *
     * @param actionOnContents      list of action on content records
     * @return                      String of a comma separated list of Ids
     * @since                       1.0
     */
    private static String createListingIdString(List<ucinn_portal_Action_On_Content__c> actionOnContents) {

        Set<String> idStringSet = new Set<String>();
        for (ucinn_portal_Action_On_Content__c eachAction : actionOnContents) {
            idStringSet.add('\'' + eachAction.Listing__c + '\'');
        }
        String idString = '(' + String.Join(New List<String>(idStringSet), ',') + ')';
        return idString;
    }

    /**
     * Generates the Event Date portion of the where clause.
     *
     * @author Aaron Wong
     *
     * @param eventDate         The event date to filter by
     * @return                  The Event Date portion of the where clause.
     * @since                   1.0
     */
    private static String getEventDateClause(String eventDate) {
        String resultString = '';

        if (String.isBlank(eventDate)) {
            return resultString;
        }

        String formattedDate = formatDate(eventDate);

        resultString = resultString + ' AND (DAY_ONLY(convertTimezone(Event_Start_Date_Time__c)) <= ' + formattedDate
                                    + ' AND (DAY_ONLY(convertTimezone(Event_End_Date_Time__c)) >= ' + formattedDate + ' OR Event_End_Date_Time__c = null))';

        return resultString;
    }

    /**
     * Formats the date to be used for SOQL.
     *
     * @author Aaron Wong
     *
     * @param dateToFormat      The date to format.
     * @return                  The formatted date.
     * @since                   1.0
     */
    @TestVisible
    private static String formatDate(String dateToFormat) {
        if (String.isBlank(dateToFormat)) {
            return '';
        }

        List<String> parts = dateToFormat.split('-');

        if (parts == null || parts.size() != 3) {
            return '';
        }

        // Make sure we add a '0' in front of single day/month.
        String part1Str = parts[1].length() == 1 ? '0' + parts[1] : parts[1];
        String part2Str = parts[2].length() == 1 ? '0' + parts[2] : parts[2];

        String dateStr = parts[0] + '-' + part1Str + '-' + part2Str;

        return dateStr;
    }

    /**
     * Generates the location portion of the query clause
     *
     * @author Aaron Wong
     *
     * @param locationObject    The location information to search by.
     * @param currentUser       The current user.
     * @return                  The location portion of the query clause.
     * @since                   1.0
     */
    @TestVisible
    private static String getLocationClause(Map<Object, Object> locationObject) {
        String resultString = '';

        if (locationObject == null || locationObject.isEmpty()) {
            return resultString;
        }

        resultString = new PORTAL_AddressWrapper(locationObject).toQueryClause(PORTAL_CONST_Listing.LOCATION_FIELD_MAPPING);

        if (String.isNotBlank(resultString)) {
            resultString = ' AND ' + resultString;
        }

        return resultString;
    }

    /**
     * Stores the user's Recommended Types into a set.
     *
     * @author Aaron Wong
     *
     * @param userRecord    User to store recommended types for.
     * @return              Set of recommended types.
     * @since               1.0
     */
    @TestVisible
    private static Set<String> getRecommendationTypeSet(User userRecord) {
        Set<String> resultSet = new Set<String>();

        if (userRecord == null) {
            return resultSet;
        }

        if (String.isNotBlank(userRecord.ucinn_portal_Recommend_Type_1__c)) {
            resultSet.add(userRecord.ucinn_portal_Recommend_Type_1__c);
        }

        if (String.isNotBlank(userRecord.ucinn_portal_Recommend_Type_2__c)) {
            resultSet.add(userRecord.ucinn_portal_Recommend_Type_2__c);
        }

        if (String.isNotBlank(userRecord.ucinn_portal_Recommend_Type_3__c)) {
            resultSet.add(userRecord.ucinn_portal_Recommend_Type_3__c);
        }

        return resultSet;
    }

    /** LISTING DETAIL START **/
    /**
     * Get Listing information by its Id or Name. If both are provided, favors the
     * Id over the Name.
     *
     * @author           Andrew Leon
     *
     * @param recordId   The Listing's Id.
     * @param recordName The Listing's Name.
     * @param cookieId   String: session cookie to use for getting pending guest participations
     *
     * @return           Contains the Listing information.
     *
     * @since            1.0
     **/
    global virtual Map<String, Object> getListingDetails(Map<String, Object> params) {
        String recordId = (String)params.get(RECORD_ID);
        String recordName = (String)params.get(RECORD_NAME);
        String cookieId = (String)params.get(PORTAL_ShoppingCartControllerBase.COOKIE_ID);

        if (String.isBlank(recordId) && String.isBlank(recordName)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_NO_RECORD_ID_NAME,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        Map<String, Object> resultMap = new Map<String, Object>();

        List<Map<String, Object>> listingList = getPageSectionAdapterBuilder().buildPageName(LISTING_DETAIL_PAGE)
                                                                              .buildMainSectionName(LISTING_DETAIL)
                                                                              .buildParentFieldId(getControllingContactId())
                                                                              .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{LISTING_DETAIL => getDynamicWhereClause(recordId, recordName)})
                                                                              .build()
                                                                              .getRecords()?.get(LISTING_DETAIL)?.get(RECORDS_KEY);

        resultMap.put(LISTING_DETAILS, listingList);

        if (listingList == null || listingList.isEmpty()) {
            return resultMap;
        }

        String firstListingId = (String)listingList.get(0)?.get(ID_CONST);
        Map<String, Boolean> eventAvailabilityMap = PORTAL_UTIL_Events.getEventAvailability(new Set<String>{firstListingId});
        Map<String, String> listingIdToParticipationIdMap = PORTAL_UTIL_Events.getGuestSessionPrimaryParticipationForListings(new Set<String>{firstListingId}, cookieId);

        resultMap.put(IS_SOLD_OUT, eventAvailabilityMap.get(firstListingId) != true);
        resultMap.put(PRIMARY_PARTICIPATION_ID, listingIdToParticipationIdMap.get(firstListingId));

        // ip address is null bc only guest action on content uses it, and guests don't see bookmark/not interested icons on front end
        ucinn_portal_Action_On_Content__c actionOnContent = getExistingActionOnContent(firstListingId, UserInfo.getUserType(), UserInfo.getUserId(), null);
        resultMap.put(IS_BOOKMARKED, actionOnContent?.Is_Bookmarked__c);
        resultMap.put(IS_NOT_INTERESTED, actionOnContent?.Is_Not_Interested__c);

        return resultMap;
    }

    /**
     * Get listing fields needed for Look Who's Coming List and related participations that are going to be displayed on the list
     * 
     * @author Curtis Ung, Jacob Huang
     * @since 1.1
     * 
     * @param recordId      listing record id
     * @param recordName    listing name
     * 
     * @return listing record represented as a map, including the listing's list of participations
     */
    public virtual Map<String, Object> getLookWhosComingList(Map<String, Object> params) {
        Map<String, Object> emptyMap = new Map<String, Object>();
        String recordId = (String) params?.get(RECORD_ID);
        String recordName = (String) params?.get(RECORD_NAME);

        if (String.isBlank(recordId) && String.isBlank(recordName)) {
            return emptyMap;
        }

        List<Map<String, Object>> listingList = getPageSectionAdapterBuilder().buildPageName(LOOK_WHOS_COMING_PAGE)
                                                                              .buildMainSectionName(LOOK_WHOS_COMING_MAIN_SECTION)
                                                                              .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{LOOK_WHOS_COMING_MAIN_SECTION => getDynamicWhereClause(recordId, recordName)})
                                                                              .build()
                                                                              .getRecords()?.get(LOOK_WHOS_COMING_MAIN_SECTION)?.get(RECORDS_KEY);

        if (listingList == null || listingList.isEmpty()) {
            return emptyMap;
        }

        return listingList[0];
    }

    /**
     * Create a dynamic query class object whose dynamic where clause specifies a particular id and/or name
     * If record id and name are both provided, check against both
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param recordId              String: record id
     * @param recordName            String: record name
     * 
     * @return dynamic query class with dynamic where clause
     */
    protected virtual PORTAL_UTIL_PageSectionSetting.DynamicQueryClass getDynamicWhereClause(String recordId, String recordName) {
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass queryClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        String whereClausePrefix = 'WHERE ';
        queryClass.dynamicWhereClause = '';

        if (String.isNotBlank(recordId)) {
            queryClass.dynamicWhereClause = whereClausePrefix + ' Id = \'' + String.escapeSingleQuotes(recordId) + '\' ';
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(recordName)) {
            queryClass.dynamicWhereClause += whereClausePrefix + ' Name = \'' + String.escapeSingleQuotes(recordName) + '\' ';
        }

        return queryClass;
    }

    /**
     * Helper method to return the authenticated user's contact id
     * If the user is a guest, then a non-blank fake id with proper formatting (18 characters) is returned
     * so that the controlling parent field in page section settings can still filter out records 
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @return contact id of authenticated user or fake id if guest
     */
    private static Id getControllingContactId() {
        Id controllingId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).ContactId;
        return String.isBlank(controllingId) ? FAKE_GUEST_ID : controllingId;
    }

    /**
    * Get the User's Profile name by the User's Id.
    *
    * @author           Andrew Leon
    *
    * @param recordId   The User's Id.
    *
    * @return           Contains the User's Profile name.
    *
    * @since            1.0
    * */
    global virtual Map<String,Object> getUserProfile(Map<String,Object> params) {
        String userId = (String)params.get(RECORD_ID);

        if (String.isBlank(userId)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_CONST_Listing.INVALID_RECORD_ID_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        List<User> userList = [SELECT ProfileId FROM User WHERE Id = :userId];
        if (userList == null || userList.isEmpty()) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_NOT_FOUND,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        Id profileId = userList[0].ProfileId;

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id = :profileId];

        return new Map<String,Object>{PROFILE_KEY => profileList[0]};
    }

    /**
     * method that queries the picklist values for listing fields.
     *
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     * @return                      the map of listing fields to their list of picklist values
     */
    public virtual Map<String, List<Map<String, String>>> getPicklists(Map<String, Object> params){
        Map<String, Map<String, List<Map<String, String>>>> picklistEntryMap = PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object>{
            PORTAL_CommunityUtils.PARAM_PICKLISTS => new Map<String, List<String>>{PORTAL_CONST_Listing.LISTING => new List<String>{PORTAL_CONST_Listing.CATEGORY_API_NAME,
                                                                                                                                    PORTAL_CONST_Listing.COUNTRY_API_NAME,
                                                                                                                                    PORTAL_CONST_Listing.ARTICLE_LENGTH_API_NAME,
                                                                                                                                    PORTAL_CONST_Listing.FORMAT_API_NAME,
                                                                                                                                    PORTAL_CONST_Listing.TOPIC_API_NAME}}
        });

       if (picklistEntryMap == null || picklistEntryMap.get(PORTAL_CONST_Listing.LISTING) == null
               || picklistEntryMap.get(PORTAL_CONST_Listing.LISTING).get(PORTAL_CONST_Listing.CATEGORY_API_NAME) == null) {
           return new Map<String, List<Map<String, String>>>();
       }

       return picklistEntryMap.get(PORTAL_CONST_Listing.LISTING);
    }

    /**
     * Gets front end data map for listing components
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   pageName            Page name of Portal Page Section Setting CMT.
     * @param   mainSectionName     Main Section name of Portal Page Section Setting CMT.
     * @param   subSectionName      Sub Section name of Portal Page Section Setting CMT.
     * 
     * @return  Front End Data Map
     */
    public virtual Map<String, Object> getFrontEndDataMap(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            return new Map<String, Object>();
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);

        return getPageSectionAdapterBuilder().buildPageName(pageName)
                                             .buildMainSectionName(mainSectionName)
                                             .buildSubSectionName(subSectionName)
                                             .build()
                                             ?.getFrontEndDataMap();
    }

    /**
     * Searches for listing records with given parameters.
     *
     * @author Aaron Wong
     *
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param mainSectionName           Main Section Name of the Portal Page Section Setting to use.
     * @param subSectionName            Sub Section Name of the Portal Page Section Setting to use.
     * @param keyword                   Keyword to search for.
     * @param category                  The category to search for.
     * @param isShowOnlineEventsOnly    Boolean: whether to query for online events only 
     * @param location                  The location to search by.
     * @param offset                    The query offset for pagination purposes
     * @param cookieId                  String: session cookie to use for getting pending guest participations
     * 
     * @return                          List of listings.
     * @since                           1.0
     */
    public virtual List<Map<String, Object>> searchListings(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        if (params == null || params.isEmpty()) {
            return resultList;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        String keyword = (String)params.get(KEYWORD_KEY);
        String category = (String)params.get(CATEGORY_KEY);
        Boolean isShowOnlineEventsOnly = (Boolean)params.get(IS_SHOW_ONLINE_EVENTS_ONLY);
        Map<Object, Object> location = (Map<Object, Object>)params.get(LOCATION_KEY);
        Integer offset = Integer.valueOf((Decimal)params.get(OFFSET_KEY));
        String cookieId = (String)params.get(PORTAL_ShoppingCartControllerBase.COOKIE_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            return resultList;
        }

        Map<Object, Object> additionalParams = (Map<Object, Object>)params.get(ADDITIONAL_PARAMS);
        if (additionalParams == null) {
            additionalParams = new Map<Object, Object>();
        }

        if (String.isNotBlank(category)) {
            additionalParams.put(CATEGORY_KEY, category);
        }

        if (location != null && !location.isEmpty()) {
            additionalParams.put(LOCATION_KEY, location);
        }

        if (isShowOnlineEventsOnly != null) {
            additionalParams.put(IS_SHOW_ONLINE_EVENTS_ONLY, isShowOnlineEventsOnly);
        }

        if (offset != null) {
            additionalParams.put(OFFSET_KEY, offset);
        }

        params.put(ADDITIONAL_PARAMS, additionalParams);

        if (String.isNotBlank(keyword)) {
            return getListingsWithKeyword(pageName, mainSectionName, subSectionName, additionalParams, keyword, cookieId);
        }

        return getListings(new Map<String, Object>{PAGE_NAME => pageName,
                                                   MAIN_SECTION_NAME => mainSectionName,
                                                   SUB_SECTION_NAME => subSectionName,
                                                   ADDITIONAL_PARAMS => additionalParams,
                                                   PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId});
    }

    /**
     * Gets a list of Listings that have a specific keyword.
     *
     * @author Aaron Wong
     *
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param mainSectionName           Main Section Name of the Portal Page Section Setting to use.
     * @param subSectionName            Sub Section Name of the Portal Page Section Setting to use.
     * @param keyword                   Keyword to search for.
     * @param cookieId                  String: session cookie to use for getting pending guest participations
     * 
     * @return                          List of listing Ids.
     * @since                           1.0
     */
    @TestVisible
    private static List<Map<String, Object>> getListingsWithKeyword(String pageName,
                                                                    String mainSectionName,
                                                                    String subSectionName,
                                                                    Map<Object, Object> additionalParams,
                                                                    String keyword,
                                                                    String cookieId) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(keyword)) {
            return resultList;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        Map<String, Object> listingConfigurations = getListingConfigurationsFromPageSectionSettings(pageSectionList);

        String sectionToApply = subSectionName;
        if (String.isBlank(subSectionName)) {
            sectionToApply = mainSectionName;
        }

        Map<String, Object> queryClauseMap = getListingQueryClauses(new Map<String, Object>{SECTION_TO_APPLY => sectionToApply,
                                                                                            PAGE_SECTION_LIST => pageSectionList,
                                                                                            LISTING_CONFIGURATIONS => listingConfigurations,
                                                                                            ADDITIONAL_PARAMS => additionalParams});

        if (queryClauseMap == null || queryClauseMap.isEmpty()) {
            return resultList;
        }

        String whereClause = (String)queryClauseMap.get(WHERE_CLAUSE);

        if (String.isBlank(whereClause)) {
            whereClause = '';
        }

        Integer offset = Integer.valueOf(0);

        if (additionalParams != null && additionalParams.get(OFFSET_KEY) != null) {
            offset = (Integer)additionalParams.get(OFFSET_KEY);
        }

        // Only get Ids since SOSL can't query for related lists
        String soslString = 'FIND \'' + String.escapeSingleQuotes(keyword) + '\' IN ALL FIELDS RETURNING ucinn_portal_Listing__c(id ' + whereClause + ' OFFSET ' + offset + ')';

        List<List<SObject>> searchResults = Search.query(soslString);

        if (searchResults == null || searchResults.isEmpty() || searchResults.get(0) == null || searchResults.get(0).isEmpty()) {
            return resultList;
        }

        Set<String> listingIdSet = new Set<String>();

        for (SObject eachObject : searchResults.get(0)) {
            listingIdSet.add(eachObject.Id);
        }

        String fieldClause = (String)queryClauseMap.get(FIELD_CLAUSE);

        if (String.isBlank(fieldClause)) {
            fieldClause = ' id ';
        }

        String queryString = 'SELECT ' + fieldClause
                                + ' FROM ucinn_portal_Listing__c WHERE id IN :listingIdSet ';

        List<ucinn_portal_Listing__c> listingList = Database.query(queryString);

        // sectionToApply is either main section or subsection, since the page section mapping will either be 
        // main section -> page section setting or subsection -> page section setting depending on if subsection is blank or not
        resultList = PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(listingList, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList)?.get(sectionToApply));

        return postProcessListings(resultList, listingConfigurations, cookieId);
    }

    /**
     * Get map of listing query clauses
     *
     * @author Aaron Wong
     *
     * @param sectionToApply            The sub-section or main section to apply dynamic query object to.
     * @param pageSectionList           List of Page Section Settings to use to get query clauses.
     * @param listingConfigurations     Listing Configurations to filter the query.
     * @param additionalParams          Additional parameters to search by.
     * @return                          Map of listing query clauses.
     * @since                           1.0
     */
    public static Map<String, Object> getListingQueryClauses(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String sectionToApply = (String)params.get(SECTION_TO_APPLY);
        List<Portal_Page_Section_Setting__mdt> pageSectionList = (List<Portal_Page_Section_Setting__mdt>)params.get(PAGE_SECTION_LIST);
        Map<String, Object> listingConfigurations = (Map<String, Object>)params.get(LISTING_CONFIGURATIONS);
        Map<Object, Object> additionalParams = (Map<Object, Object>)params.get(ADDITIONAL_PARAMS);

        if (String.isBlank(sectionToApply) || pageSectionList == null || pageSectionList.isEmpty()
                || listingConfigurations == null || listingConfigurations.isEmpty()) {
            return resultMap;
        }

        User currentUser = getUserWithRecommendedTypes();

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = getDynamicQueryForListings(new Map<String, Object>{LISTING_CONFIGURATIONS => listingConfigurations,
                                                                                                                                 CURRENT_USER => currentUser,
                                                                                                                                 ADDITIONAL_PARAMS => additionalParams});

        Map<String, Object> queryClauseMap = PORTAL_UTIL_PageSectionSetting.getQueryClauseMap(getControllingContactId(), sectionToApply, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList), new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{sectionToApply => dynamicQueryObject}, false);

        return queryClauseMap;
    }

    /**
     * Post Processes listing retrieved from getListings
     *
     * @author Aaron Wong
     *
     * @param listingList               List of Listing maps.
     * @param listingConfigurations     Map of Listing Configurations.
     * @param cookieId                  String: session cookie to use for getting pending guest participations
     * 
     * @return                          Parsed list of listings.
     * @since                           1.0
     */
    private static List<Map<String, Object>> postProcessListings(List<Map<String, Object>> listingList, Map<String, Object> listingConfigurations, String cookieId) {
        List<Map<String, Object>> resultList = listingList;

        if (listingList == null || listingList.isEmpty()
                || listingConfigurations == null || listingConfigurations.isEmpty()) {
            return resultList;
        }

        if ((String)listingConfigurations.get(RECORD_TYPE) == PORTAL_CONST_Listing.EVENT) {
            resultList = parseEventListings(listingList, cookieId);
        }

        return resultList;
    }

    /**
     * Parses event listings retrieved from getListings
     *
     * @author Aaron Wong
     *
     * @param listingList               List of Listing maps.
     * @param cookieId                  String: session cookie to use for getting pending guest participations
     * 
     * @return                          Parsed list of listings.
     * @since                           1.0
     */
    private static List<Map<String, Object>> parseEventListings(List<Map<String, Object>> listingList, String cookieId) {
        List<Map<String, Object>> resultList = listingList;

        if (listingList == null || listingList.isEmpty()) {
            return resultList;
        }

        Set<String> listingIdSet = new Set<String>();

        for (Map<String, Object> eachListing : listingList) {
            listingIdSet.add((String)eachListing.get(ID_CONST));
        }

        Map<String, Boolean> eventAvailabilityMap = PORTAL_UTIL_Events.getEventAvailability(listingIdSet);
        Map<String, String> listingIdToParticipationIdMap = PORTAL_UTIL_Events.getGuestSessionPrimaryParticipationForListings(listingIdSet, cookieId);

        for (Map<String, Object> eachListing : resultList) {
            String listingId = (String)eachListing.get(ID_CONST);

            if (eventAvailabilityMap.get(listingId) != true) {
                eachListing.put(IS_SOLD_OUT, true);
            }

            eachListing.put(PRIMARY_PARTICIPATION_ID, listingIdToParticipationIdMap.get(listingId));
        }

        return resultList;
    }

    /**
     * Updates Action on Content for any given listing and constituent
     * @param    actionToTake                    States what needs to be updated on action to content (Ex: bookmark, not interested, etc)
     * @param    listingId                       Id of the listing that will be tied to the action on content
     * @param    ipAddress                       Ip Address of the user
     * @since                                    1.0
     */
    public virtual ucinn_portal_Action_On_Content__c updateActionOnContent(Map<String, Object> params){
        String actionToTake = (String) params.get(ACTION_TO_TAKE_KEY);
        String listingId = (String) params.get(PORTAL_CONST_ActionOnContent.LISTING_ID_KEY);
        String currentUserType = UserInfo.getUserType();
        Id currentUserId = UserInfo.getUserId();
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        if ((currentUserType == PORTAL_CONST_ActionOnContent.GUEST_USER_TYPE && String.isBlank(ipAddress)) || 
            (currentUserType != PORTAL_CONST_ActionOnContent.GUEST_USER_TYPE && currentUserId == null)) {
                return null;
        }

        // grab existing action on content to update or create a new one if none exist
        ucinn_portal_Action_On_Content__c currentContent = getExistingActionOnContent(listingId, currentUserType, currentUserId, ipAddress);

        if (currentContent == null) {
            currentContent = PORTAL_ActionOnContentController.createActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => currentUserId, PORTAL_CONST_ActionOnContent.LISTING_ID_KEY =>  listingId, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            if (currentContent == null) {
                return null;
            }
            currentContent.Is_Bookmarked__c = false;
            currentContent.Is_Not_Interested__c = false;
        }

        // logic for updating different item on action on content
        if (actionToTake == BOOKMARKED) {
            currentContent.Is_Bookmarked__c = !currentContent.Is_Bookmarked__c;
            if (currentContent.Is_Bookmarked__c == true) {
                currentContent.Is_Not_Interested__c = false;
            }
        }
        else if (actionToTake == NOT_INTERESTED) {
            currentContent.Is_Not_Interested__c = !currentContent.Is_Not_Interested__c;
            if (currentContent.Is_Not_Interested__c == true) {
                currentContent.Is_Bookmarked__c = false;
            }
        }

        upsert currentContent;

        return currentContent;
    }

    /**
     * Get an existing action on content record for a listing and user pair
     * 
     * @author Jacob Huang (moved existing code to helper)
     * @since 1.0
     * 
     * @param listingId         String: Id of listing
     * @param currentUserType   String: type of current user (ex: Guest)
     * @param currentUserId     Id: Id of current user
     * @param ipAddress         String: IP address of current user
     * 
     * @return existing ucinn_portal_Action_On_Content__c record, null if record does not exist 
     */
    protected virtual ucinn_portal_Action_On_Content__c getExistingActionOnContent(String listingId, String currentUserType, Id currentUserId, String ipAddress) {
        String identifer = '';

        if (currentUserType == PORTAL_CONST_ActionOnContent.GUEST_USER_TYPE) {
            if (String.isBlank(ipAddress)) {
                return null;
            }
            identifer = listingId + ipAddress;
        } else {
            if (currentUserId == null) {
                return null;
            }
            identifer = listingId + currentUserId;
        }

        List<ucinn_portal_Action_On_Content__c> constituentsContent = [SELECT Id, Is_Bookmarked__c, Is_Not_Interested__c FROM ucinn_portal_Action_On_Content__c WHERE Reference_ID__c = :identifer];
        return constituentsContent.size() > 0 ? constituentsContent[0] : null;
    }

    /**
     * upserts Action on Content for any given listing and constituent
     * @param    listingId                       Id of the listing that will be tied to the action on content
     * @param    ipAddress                       Ip Address of the user
     * @since                                    1.0
     */

    public void updateRecommendationEngine(Map<String, Object> params) {
        Id contentId = (Id) params.get(PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY);
        Id currentUserId = UserInfo.getUserId();
        String currentUserType = UserInfo.getUserType();
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        ucinn_portal_Listing__c thisContent = [SELECT Id, Name, RecordTypeId, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c
                                               FROM ucinn_portal_Listing__c
                                               WHERE Id =: contentId];

        PORTAL_ActionOnContentController.upsertActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => currentUserId, PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => currentUserType,  PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY =>  thisContent, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
    }


    /**
     * gets recommendation types for a user
     * @param    userRecord                      the user record
     * @since                                    1.0
     */

    @TestVisible
    private static List<String> getRecommendationTypeList(User userRecord) {
        List<String> resultList = new List<String>();

        if (userRecord == null) {
            return resultList;
        }

        if (String.isNotBlank(userRecord.ucinn_portal_Recommend_Type_1__c)) {
            resultList.add(userRecord.ucinn_portal_Recommend_Type_1__c);
        }

        if (String.isNotBlank(userRecord.ucinn_portal_Recommend_Type_2__c) && !resultList.contains(userRecord.ucinn_portal_Recommend_Type_2__c)) {
            resultList.add(userRecord.ucinn_portal_Recommend_Type_2__c);
        }

        if (String.isNotBlank(userRecord.ucinn_portal_Recommend_Type_3__c) && !resultList.contains(userRecord.ucinn_portal_Recommend_Type_3__c)) {
            resultList.add(userRecord.ucinn_portal_Recommend_Type_3__c);
        }

        return resultList;
    }
}