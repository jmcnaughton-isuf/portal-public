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
 * Base controller for the giving societies sprint.
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global inherited sharing class PORTAL_GivingSocietiesControllerBase {
    // Portal Page Section Fields
    private static final String GIVING_SOCIETIES_PAGE_NAME = 'Giving Societies';
    private static final String GIVING_SOCIETIES_DETAIL_PAGE_NAME = 'Giving Societies Detail';
    private static final String GIVING_SOCIETIES_LIST_MAIN_SECTION_NAME = 'Giving Societies List';
    private static final String GIVING_SOCIETIES_BANNER_MAIN_SECTION_NAME = 'Giving Societies Banner';
    private static final String DONOR_STORY_MAIN_SECTION_NAME = 'Donor Story';
    private static final String DONOR_STORY_DETAIL_MAIN_SECTION_NAME = 'Detail Page';
    private static final String SOCIETY_MEMBERSHIP_TABLE_MAIN_SECTION_NAME = 'Society Membership Table';
    private static final String LIFETIME_MEMBERSHIP_SUB_SECTION_NAME = 'Lifetime Society Memberships';
    private static final String ANNUAL_MEMBERSHIP_SUB_SECTION_NAME = 'Annual Society Memberships';
    private static final String INACTIVE_MEMBERSHIP_SUB_SECTION_NAME = 'Inactive Society Memberships';

    // class map keys
    private final static String PERMISSION_MAP_KEY = 'permissionMap';
    private final static String RECORDS_TO_RETURN_KEY = 'records';
    private final static String ERROR_MESSAGE_KEY = 'errorMessage';
    private final static String QUERY_STRING_KEY = 'queryString';
    private final static String SECTION_MAP_KEY = 'sectionMap';
    private final static String UNFORMATTED_RECORDS = 'unformattedRecords';
    private final static String TOTAL_NUMBER_OF_RECORDS_KEY = 'totalNumberOfRecords';
    private final static String PICKLIST_OPTIONS = 'picklistOptions';
    private final static String RETURN_VALUE = 'returnValue';
    private final static String GIVING_SETTINGS_METADATA = 'givingSettingsMetadata';
    private final static String GIVING_SETTINGS_URL_RECORD_NAME = 'givingSettingsURLName';
    private final static String GIVING_SETTINGS_URL_RECORD_FILTER = 'givingSettingsURLFilter';
    private final static String GIVING_URL_FIELD_NAME = 'givingURLFieldName';
    @TestVisible private final static String GIVING_SOCITIES_NAME = 'givingSocietyName';
    private final static String BANNER_TEXT = 'bannerText';
    private final static String SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP = 'ucinn_ascendv2__Giving_Society__c';

    // front end params
    private final static String GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE = 'givingSocietyIdToEarliestDate';
    private final static String ANNUAL_MEMBERSHIP_RENEW_GIVING_SETTINGS_NAME = 'annualMembershipRenewGivingSettingsName';
    private final static String ANNUAL_MEMBERSHIP_RENEW_GIVING_SETTINGS_FILTER = 'annualMembershipRenewGivingSettingsfilter';
    private final static String ANNUAL_MEMBERSHIP_ELEVATE_GIVING_SETTINGS_NAME = 'annualMembershipElevateGivingSettingsName';
    private final static String ANNUAL_MEMBERSHIP_ELEVATE_GIVING_SETTINGS_FILTER = 'annualMembershipElevateGivingSettingsfilter';
    private final static String LIFETIME_MEMBERSHIP_GIVING_SETTINGS_NAME = 'lifetimeMembershipGivingSettingsName';
    private final static String LIFETIME_MEMBERSHIP_GIVING_SETTINGS_FILTER = 'lifetimeMembershipGivingSettingsfilter';
    private final static String INACTIVE_MEMBERSHIP_GIVING_SETTINGS_NAME = 'inactiveMembershipGivingSettingsName';
    private final static String INACTIVE_MEMBERSHIP_GIVING_SETTINGS_FILTER = 'inactiveMembershipGivingSettingsfilter';

    // front end field ids
    private final static String GIVING_SOCIETIES_LIST_EXTERNAL_WEBSITE = 'externalWebsite';
    private final static String GIVING_SOCIETIES_NAME = 'name';

    // query variables
    private Set<Id> socitiesWithActiveMemberships = new Set<Id>();
    private Datetime currentDatetime;

    private final static String ERROR_MESSAGE_WITH_ERROR_CODE = 'Please contact system adminstration. Error Code: ';
    global final static String GENERIC_ERROR_MESSAGE = 'There was an error, please contact system adminstration.';

    global class GivingSocietiesException extends Exception {}

    /**
     * Query information for giving socities list component.
     *
     * @param                   paramMap
     *                              itemsPerPage                    Item per page to display.
     *                              givingSocietyType               The type of giving societies to display.
     *                              givingSocietyDetailURL          The relative URL for the giving societies detail page.
     *                              nameSearch                      Text name search for giving socities to display.
     * @return                  returnMap
     *                              RECORDS_TO_RETURN_KEY           Records returned to display.
     *                              PERMISSION_MAP_KEY              Portal page section permission map.
     *                              TOTAL_NUMBER_OF_RECORDS_KEY     Total number of records in the query.
     *                              PICKLIST_OPTIONS                Picklist options for giving socities type search.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<String, Object> getGivingSocietiesList(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();

        String givingSocietyNameSearch = (String)paramMap.get('nameSearch');
        String typeSearch = (String)paramMap.get('givingSocietyType');

        String additionalWhereClause = '';

        if (String.isNotBlank(givingSocietyNameSearch)) {
            additionalWhereClause = 'Name LIKE \'%' + givingSocietyNameSearch + '%\'';
        }

        if (String.isNotBlank(typeSearch)) {
            if (String.isNotBlank(additionalWhereClause)) {
                additionalWhereClause += ' AND ';
            }

            additionalWhereClause += ' ucinn_portal_Type__c = \'' + typeSearch +'\' ';
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass paginationOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', additionalWhereClause , '', '', null, null, false);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass countQueryOveride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('SELECT Count() ', additionalWhereClause, '', '', null, null, true);
        countQueryOveride.overrideWhereClause = false;

        Map<String, Object> portalPageSectionMetadata = PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata(GIVING_SOCIETIES_PAGE_NAME, GIVING_SOCIETIES_LIST_MAIN_SECTION_NAME,
                                                                                                                    null, GIVING_SOCIETIES_LIST_MAIN_SECTION_NAME,
                                                                                                                    null, false, new List<PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{paginationOverride, countQueryOveride});

        List<Object> queryString = (List<Object>)portalPageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.QUERY_STRING_KEY);

        paramMap.put(QUERY_STRING_KEY, queryString[0]);
        paramMap.put(ERROR_MESSAGE_WITH_ERROR_CODE, ERROR_MESSAGE_WITH_ERROR_CODE + '502.');
        List<sObject> givingSocitiesList = queryGivingSocietiesList(paramMap);

        paramMap.put(SECTION_MAP_KEY, portalPageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.SECTION_MAP_KEY));
        paramMap.put(UNFORMATTED_RECORDS, givingSocitiesList);
        returnMap.put(RECORDS_TO_RETURN_KEY, formatGivingSocietiesList(paramMap));

        returnMap.put(PERMISSION_MAP_KEY, portalPageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.PERMISSION_MAP_KEY));

        paramMap.put(QUERY_STRING_KEY, queryString[1]);
        paramMap.put(ERROR_MESSAGE_WITH_ERROR_CODE, ERROR_MESSAGE_WITH_ERROR_CODE + '503.');
        returnMap.put(TOTAL_NUMBER_OF_RECORDS_KEY, getGivingSocietiesNumberOfRecords(paramMap));

        // get picklist options
        Map<String, List<String>> picklists = new Map<String, List<String>>{SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP => new List<String>{'ucinn_portal_Type__c'}};
        Map<String, List<Map<String, String>>> givingSocietyPicklistOptions = PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object>{
                                                                                                                                PORTAL_CommunityUtils.PARAM_PICKLISTS => picklists}
                                                                                                                             ).get(SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP);

        if (givingSocietyPicklistOptions != null && givingSocietyPicklistOptions.get('ucinn_portal_Type__c') != null) {
            returnMap.put(PICKLIST_OPTIONS, givingSocietyPicklistOptions.get('ucinn_portal_Type__c'));
        }

        return returnMap;
    }

    /**
     * Query giving socities list.
     *
     * @param               paramMap
     * @return                                                      list of giving socities.
     * @version                                                     1.0
     * @since                                                       1.0
     */
    global virtual List<sObject> queryGivingSocietiesList(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Query Giving Societies List number of total records.
     *
     * @param               paramMap
     * @return                                                      Total number of giving socities records.
     * @version                                                     1.0
     * @since                                                       1.0
     */
    global virtual Integer getGivingSocietiesNumberOfRecords(Map<String, Object> paramMap) {
        return getTableCountQuery(paramMap);
    }

    /**
     * Format giving stories list component records.
     *
     * @param                   paramMap
     *                              UNFORMATTED_RECORDS                     Unformatted donor story record.
     *                              SECTION_MAP_KEY                         Portal Page section mapping.
     *                              givingSocietyDetailURL                  URL for the giving socities detail page.
     * @return                  List of Portal Page Section formatted records.
     */
    global virtual List<Map<String, Object>> formatGivingSocietiesList(Map<String, Object> paramMap) {
        String givingSocietyDetailURL = (String)paramMap.get('givingSocietyDetailURL');
        List<Map<String, Object>> formattedRecords =  PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper((List<sObject>)paramMap.get(UNFORMATTED_RECORDS),
                                                                                                            (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(SECTION_MAP_KEY));

        for (Map<String, Object> currentFormattedRecord : formattedRecords) {
            String currentRecordWebsiteURL = '';
            String externalWebsiteURL = (String)currentFormattedRecord.get(GIVING_SOCIETIES_LIST_EXTERNAL_WEBSITE);
            String givingSocietyName = (String)currentFormattedRecord.get(GIVING_SOCIETIES_NAME);

            if (String.isNotBlank(externalWebsiteURL)) {
                currentRecordWebsiteURL = externalWebsiteURL;
            }
            else if (String.isNotBlank(givingSocietyDetailURL) && String.isNotBlank(givingSocietyName)) {
                // 'gsname' stands for  giving society name. Used as a URL paramter to render the information for the giving societies detail page.
                currentRecordWebsiteURL =  givingSocietyDetailURL + '?gsname=' + EncodingUtil.urlEncode(givingSocietyName,'UTF-8');
            }

            if (String.isNotBlank(currentRecordWebsiteURL)) {
                currentFormattedRecord.put('websiteURL', currentRecordWebsiteURL);
            }

        }

        return formattedRecords;
    }

    /**
     * Query information for giving socities list component.
     *
     * @param                   paramMap
     *                              givingSocietyName               Name of the giving society to query for.
     *                              bannerText                      Default banner text.
     * @return                  returnMap
     *                              RECORDS_TO_RETURN_KEY           Records returned to display.
     *                              PERMISSION_MAP_KEY              Portal page section permission map.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<String, Object> getGivingSocietyDetailPage(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        String givingSocietyName = (String)paramMap.get(GIVING_SOCITIES_NAME);

        if (String.isBlank(givingSocietyName)) {
            throw new GivingSocietiesException('Invalid giving society name. Error Code: 507.');
        }

        String additionalWhereClause = ' Name = \'' + String.escapeSingleQuotes(givingSocietyName) + '\' ';

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass urlParamQueryAdditions = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', additionalWhereClause , '', '', null, null, false);

        Map<String, Object> pageSectionMetadata = PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata(GIVING_SOCIETIES_DETAIL_PAGE_NAME, DONOR_STORY_DETAIL_MAIN_SECTION_NAME, null, DONOR_STORY_DETAIL_MAIN_SECTION_NAME,
                                                                                                                      null, false, new List<PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{urlParamQueryAdditions});

        paramMap.put(QUERY_STRING_KEY, ((List<Object>)pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.QUERY_STRING_KEY))[0]);
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '508.');
        List<sObject> unformattedRecords = queryGivingSocietiesDetailPage(paramMap);

        if (unformattedRecords.isEmpty()) {
            throw new GivingSocietiesException('Invalid giving society name. Error Code: 509.');
        }

        paramMap.put(UNFORMATTED_RECORDS, unformattedRecords);
        paramMap.put(SECTION_MAP_KEY, pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.SECTION_MAP_KEY));
        returnMap.put(RECORDS_TO_RETURN_KEY, formatGivingSocietiesDetailPage(paramMap));

        returnMap.put(PERMISSION_MAP_KEY, pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.PERMISSION_MAP_KEY));

        return returnMap;
    }

    /**
     * Query giving societies detail page.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryGivingSocietiesDetailPage(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }


    /**
     * Format giving stories detail page record.
     *
     * @param                   paramMap
     *                              UNFORMATTED_RECORDS                     Unformatted donor story record.
     *                              SECTION_MAP_KEY                         Portal Page section mapping.
     * @return                  List of Portal Page Section formatted records.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<Map<String, Object>> formatGivingSocietiesDetailPage(Map<String, Object> paramMap) {
        List<Map<String, Object>> formattedRecords =  PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper((List<sObject>)paramMap.get(UNFORMATTED_RECORDS), (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(SECTION_MAP_KEY));
        return formattedRecords;
    }

    /**
     * Giving societies thank you banner. Check if user is in given giving society, or in any giving society if giving society name is blank.
     *
     * @param                   paramMap
     *                              givingSocietyName                       Name of the giving society to check if constituent is a part of.
     *                              bannerText                              Default banner text.
     * @return                  returnMap
     *                              RETURN_VALUE                            Boolean stating if user is a part of the provided giving society.
     *                              PERMISSION_MAP_KEY                      Portal Page section permission map.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<String, Object> checkIfInGivingSociety(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        String givingSocietyName = (String)paramMap.get(GIVING_SOCITIES_NAME);
        String bannerText = (String)paramMap.get('bannerText');
        Id contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).contactId;

        if (contactId == null) {
            return null;
        }

        returnMap.put(BANNER_TEXT, bannerText);

        String additionalWhereClause = '';

        if (String.isNotBlank(givingSocietyName)) {
            additionalWhereClause = 'ucinn_ascendv2__Giving_Society__r.Name = \'' + String.escapeSingleQuotes(givingSocietyName) + '\' ';
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass additionalWhereClauseClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', additionalWhereClause , '', '', null, null, false);
        Map<String, Object> pageSectionSettignsMetadata = PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata(GIVING_SOCIETIES_PAGE_NAME, GIVING_SOCIETIES_BANNER_MAIN_SECTION_NAME, null,
                                                                                                                              GIVING_SOCIETIES_BANNER_MAIN_SECTION_NAME, contactId, null, new List<PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{additionalWhereClauseClass});

        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)pageSectionSettignsMetadata.get(PORTAL_UTIL_PageSectionSetting.PERMISSION_MAP_KEY);

        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '519.');
        paramMap.put(QUERY_STRING_KEY, ((List<Object>)pageSectionSettignsMetadata.get(PORTAL_UTIL_PageSectionSetting.QUERY_STRING_KEY))[0]);
        List<sObject> societyMemberships = queryIfInGivingSociety(paramMap);

        if (!societyMemberships.isEmpty()) {
            returnMap.put(RETURN_VALUE, true);
            List<Map<String, Object>> formattedRecords =  PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(societyMemberships, (Map<String, List<Portal_Page_Section_Setting__mdt>>)pageSectionSettignsMetadata.get(PORTAL_UTIL_PageSectionSetting.SECTION_MAP_KEY));

            // only check for detail pages
            if (!formattedRecords.isEmpty() && String.isNotBlank((String)formattedRecords[0].get('bannerText')) && String.isNotBlank(givingSocietyName)) {
                returnMap.put(BANNER_TEXT, formattedRecords[0].get('bannerText'));
            }

        } else {
            returnMap.put(RETURN_VALUE, false);
        }

        if (String.isBlank((String)returnMap.get(BANNER_TEXT))) {
            return null;
        }

        returnMap.put(PERMISSION_MAP_KEY, pageSectionSettignsMetadata.get(PORTAL_UTIL_PageSectionSetting.PERMISSION_MAP_KEY));

        return returnMap;
    }

    /**
     * Query society memberships for the given giving society.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryIfInGivingSociety(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Query information realted to the donor stories component.
     *
     * @param                   paramMap
     *                              numOfItemsToShow                        Number of items to display.
     *                              givingSocietyName                       Name of the giving society to pull donor stories from.
     *                              givingSocietyDetailPageURL              Relative URL for the giving societies detail page.
     * @return                  returnMap
     *                              RECORDS_TO_RETURN_KEY                   giving socitiy record to display.
     *                              PERMISSION_MAP_KEY                      Portal page sectiion setting permisison map.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<String, Object> getDonorStories(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();

        String givingSocietyName = (String)paramMap.get(GIVING_SOCITIES_NAME);
        Integer numberOfItemsToShow = 0;

        try {
            numberOfItemsToShow = Integer.valueOf((Decimal)paramMap.get('numOfItemsToShow'));
        }
        catch (Exception e) {
            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '513.');
        }

        String additionalWhereClause = '';

        if (String.isNotBlank(givingSocietyName)) {
            additionalWhereClause = 'Giving_Societies__c Includes (\'' + String.escapeSingleQuotes(givingSocietyName) + '\')';
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass additionalWhereClauseClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', additionalWhereClause , '', '', null, null, false);
        Map<String, Object> pageSectionMetadata = PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata(GIVING_SOCIETIES_PAGE_NAME, DONOR_STORY_MAIN_SECTION_NAME, null, DONOR_STORY_MAIN_SECTION_NAME,
                                                                                                                      null, false, new List<PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{additionalWhereClauseClass});
        
        // "currentDatetime" can be leveraged within the query defined within the portal page section setting's where clause.
        currentDatetime = Datetime.now();

        paramMap.put(QUERY_STRING_KEY, ((List<Object>)pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.QUERY_STRING_KEY))[0]);
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '504.');
        List<sObject> donorStories = queryDonorStories(paramMap);

        // randomize selected donor stories
        List<sObject> donorStoriesRandomized = new List<sObject>();
        while (numberOfItemsToShow > 0 && donorStories.size() > 0) {
            Integer randomIndex = Integer.valueOf(Math.ceil(Math.random() * donorStories.size()) - 1);

            if (randomIndex < 0) {
                randomIndex = 0;
            }

            sObject donorStoryChosen = donorStories.remove(randomIndex);
            donorStoriesRandomized.add(donorStoryChosen);
            numberOfItemsToShow = numberOfItemsToShow - 1;
        }

        // format records
        paramMap.put(UNFORMATTED_RECORDS, donorStoriesRandomized);
        paramMap.put(SECTION_MAP_KEY, pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.SECTION_MAP_KEY));
        returnMap.put(RECORDS_TO_RETURN_KEY, formatDonorStories(paramMap));

        returnMap.put(PERMISSION_MAP_KEY,  pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.PERMISSION_MAP_KEY));

        return returnMap;
    }

    /**
     * Query donor stories for the given giving society.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryDonorStories(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Format donor stories component
     *
     * @param                   paramMap
     *                              UNFORMATTED_RECORDS                     Unformatted donor story record.
     *                              SECTION_MAP_KEY                         Portal Page section mapping.
     *                              givingSocietyDetailPageURL              URL for the giving socities detail page.
     * @return                  List of Portal Page Section formatted records.
     */
    global virtual List<Map<String, Object>> formatDonorStories(Map<String, Object> paramMap) {
        List<Map<String, Object>> formattedRecords =  PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper((List<sObject>)paramMap.get(UNFORMATTED_RECORDS), (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(SECTION_MAP_KEY));
        String givingSocietyDetailPageURL = (String)paramMap.get('givingSocietyDetailPageURL');

        for (Map<String, Object> currentRecord : formattedRecords) {
            String listingName = (String)currentRecord.get('name');

            if (String.isNotBlank(listingName) && String.isNotBlank(givingSocietyDetailPageURL)) {
                currentRecord.put('detailPageURL', givingSocietyDetailPageURL + '?dsname=' +  EncodingUtil.urlEncode(listingName,'UTF-8'));
            }
        }

        return formattedRecords;
    }

    /**
     * Query information realted to the donor story detail page.
     *
     * @param                   paramMap
     *                              donorStoryName                          name of the donor story to query on.
     * @return                  returnMap
     *                              RECORDS_TO_RETURN_KEY                   giving socitiy record to display.
     *                              PERMISSION_MAP_KEY                      Portal page sectiion setting permisison map.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<String, Object> getDonorStoriesDetail(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        String donorStoryName = (String)paramMap.get('donorStoryName');

        if (String.isBlank(donorStoryName)) {
            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '505.');
        }

        String additionalWhereClause = ' Name = \'' + String.escapeSingleQuotes(donorStoryName) + '\' ';

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass additionalWhereClauseClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', additionalWhereClause , '', '', null, null, false);
        Map<String, Object> pageSectionMetadata = PORTAL_UTIL_PageSectionSetting.getPortalPageSectionDisplayMetadata(GIVING_SOCIETIES_PAGE_NAME, DONOR_STORY_DETAIL_MAIN_SECTION_NAME, null, DONOR_STORY_DETAIL_MAIN_SECTION_NAME,
                                                                                                                      null, false, new List<PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{additionalWhereClauseClass});

        // Query records
        paramMap.put(QUERY_STRING_KEY, ((List<Object>)pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.QUERY_STRING_KEY))[0]);
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '506.');
        paramMap.put(UNFORMATTED_RECORDS, queryDonorStoriesDetail(paramMap));

        // format records
        paramMap.put(SECTION_MAP_KEY, pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.SECTION_MAP_KEY));
        returnMap.put(RECORDS_TO_RETURN_KEY, formatDonorStoryDetail(paramMap));

        returnMap.put(PERMISSION_MAP_KEY, pageSectionMetadata.get(PORTAL_UTIL_PageSectionSetting.PERMISSION_MAP_KEY));

        return returnMap;
    }

    /**
     * Query donor detail information.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryDonorStoriesDetail(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Format donor story detail record
     *
     * @param                   paramMap
     *                              UNFORMATTED_RECORDS                     Unformatted donor story record.
     *                              SECTION_MAP_KEY                         Portal Page section mapping.
     * @return                  List of Portal Page Section formatted records.
     */
    global virtual List<Map<String, Object>> formatDonorStoryDetail(Map<String, Object> paramMap) {
        List<Map<String, Object>> formattedRecords =  PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper((List<sObject>)paramMap.get(UNFORMATTED_RECORDS), (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(SECTION_MAP_KEY));
        return formattedRecords;
    }

    /**
     * Query society membership info for the current constituent.
     *
     * @param                   paramMap
     *                              annualMembershipRenewGivingSettingsName                 Portal_Giving_URL_Setting__mdt record name.
     *                              annualMembershipRenewGivingSettingsfilter               Related Portal_Giving_URL_Setting_Field__mdt fields that contain the query filter keyword.
     *                              annualMembershipElevateGivingSettingsName               Portal_Giving_URL_Setting__mdt record name.
     *                              annualMembershipElevateGivingSettingsfilter             Related Portal_Giving_URL_Setting_Field__mdt fields that contain the query filter keyword.
     *                              lifetimeMembershipGivingSettingsName                    Portal_Giving_URL_Setting__mdt record name.
     *                              lifetimeMembershipGivingSettingsfilter                  Related Portal_Giving_URL_Setting_Field__mdt fields that contain the query filter keyword.
     *                              inactiveMembershipGivingSettingsName                    Portal_Giving_URL_Setting__mdt record name.
     *                              inactiveMembershipGivingSettingsfilter                  Related Portal_Giving_URL_Setting_Field__mdt fields that contain the query filter keyword.
     * @return                  returnMap
     *                              lifetimeMembershipRecords                               Lifetime society membership records.
     *                              annualMembershipRecords                                 Annual society membership records.
     *                              inactiveMembershipRecords                               Inactive society membership records.
     *                              PERMISSION_MAP_KEY                                      Portal page sectiion setting permisison map.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<String, Object> getSocietyMembershipTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        Id contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).contactId;

        if (contactId == null) {
            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '521.');
        }

        List<Portal_Page_Section_Setting__mdt> societyMembershipTablePageSections = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('Giving Societies', 'Society Membership Table', null);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> subPageNameToQuery = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(societyMembershipTablePageSections);

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass additionalFields = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        additionalFields.dynamicSelectClause ='Id, ucinn_ascendv2__Giving_Society__c';

        paramMap.put('contactId', contactId);
        Map<Id, Date> givingSocietyIdToEarliestJoinDate =  getGivingSocietyToEarliestMemberSinceDate(paramMap);

        /* lifetime memberships */

        //query for lifetime memeberships
        String lifetimeMembershipQuery = PORTAL_UTIL_PageSectionSetting.generateQueryString(contactId, subPageNameToQuery.get(LIFETIME_MEMBERSHIP_SUB_SECTION_NAME),
                                                                                                false, additionalFields);
        paramMap.put(QUERY_STRING_KEY, lifetimeMembershipQuery);
        paramMap.put(GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE, givingSocietyIdToEarliestJoinDate);
        paramMap.put(ERROR_MESSAGE_WITH_ERROR_CODE, ERROR_MESSAGE_WITH_ERROR_CODE + '510.');
        List<sObject> unformattedLifetimeMemberships = queryLifetimeSocietyMembershipTableData(paramMap);

        // keep track of all active society memberships
        for (sObject currentSObject : unformattedLifetimeMemberships) {
            socitiesWithActiveMemberships.add((Id)currentSObject.get(SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP));
        }

        // format lifetime memberships
        paramMap.put(UNFORMATTED_RECORDS, unformattedLifetimeMemberships);
        paramMap.put(SECTION_MAP_KEY, subPageNameToQuery.get(LIFETIME_MEMBERSHIP_SUB_SECTION_NAME));

        paramMap.put(GIVING_SETTINGS_METADATA, new List<Map<String, Object>>{new Map<String, Object>{GIVING_SETTINGS_URL_RECORD_NAME => (String)paramMap.get(LIFETIME_MEMBERSHIP_GIVING_SETTINGS_NAME),
                                                GIVING_SETTINGS_URL_RECORD_FILTER => (String)paramMap.get(LIFETIME_MEMBERSHIP_GIVING_SETTINGS_FILTER),
                                                GIVING_URL_FIELD_NAME => 'elevateGivingLink'}});
        List<Map<String, Object>> formattedLiftimeSocietyMemberships = formatLifetimeSocietyMemberships(paramMap);

        /* annual memberships */

        // query annual memberships
        String annualMembershipQuery = PORTAL_UTIL_PageSectionSetting.generateQueryString(contactId, subPageNameToQuery.get(ANNUAL_MEMBERSHIP_SUB_SECTION_NAME),
                                                                                                false, additionalFields);
        paramMap.put(QUERY_STRING_KEY, annualMembershipQuery);
        paramMap.put(ERROR_MESSAGE_WITH_ERROR_CODE, ERROR_MESSAGE_WITH_ERROR_CODE + '511.');
        List<sObject> unformattedAnnualMemberships = queryAnnualSocietyMembershipTableData(paramMap);

        // keep track of all active society memberships
        for (sObject currentSObject : unformattedAnnualMemberships) {
            socitiesWithActiveMemberships.add((Id)currentSObject.get(SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP));
        }

        // format annual memberships
        paramMap.put(UNFORMATTED_RECORDS, unformattedAnnualMemberships);
        paramMap.put(SECTION_MAP_KEY, subPageNameToQuery.get(ANNUAL_MEMBERSHIP_SUB_SECTION_NAME));
        paramMap.put(GIVING_SETTINGS_METADATA, new List<Map<String, Object>>{new Map<String, Object>{GIVING_SETTINGS_URL_RECORD_NAME => (String)paramMap.get(ANNUAL_MEMBERSHIP_RENEW_GIVING_SETTINGS_NAME),
                                                                                    GIVING_SETTINGS_URL_RECORD_FILTER => (String)paramMap.get(ANNUAL_MEMBERSHIP_RENEW_GIVING_SETTINGS_FILTER),
                                                                                    GIVING_URL_FIELD_NAME => 'renewGivingLink'},
                                                                            new Map<String, Object>{ GIVING_SETTINGS_URL_RECORD_NAME => (String)paramMap.get(ANNUAL_MEMBERSHIP_ELEVATE_GIVING_SETTINGS_NAME) ,
                                                                                GIVING_SETTINGS_URL_RECORD_FILTER => (String)paramMap.get(ANNUAL_MEMBERSHIP_ELEVATE_GIVING_SETTINGS_FILTER),
                                                                                GIVING_URL_FIELD_NAME => 'elevateGivingLink'}});
        List<Map<String, Object>> formattedAnnualSocietyMemberships = formatAnnualSocietyMembership(paramMap);

        /* inactive memberships */

        // query for inactive memberships
        paramMap.put(GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE, null);
        // 'socitiesWithActiveMemberships' can be used within the query. This is defined within the portal page section setting where clause.
        String inactiveMembershipQuery = PORTAL_UTIL_PageSectionSetting.generateQueryString(contactId, subPageNameToQuery.get(INACTIVE_MEMBERSHIP_SUB_SECTION_NAME),
                                                                                                false, additionalFields);

        paramMap.put(QUERY_STRING_KEY, inactiveMembershipQuery);
        paramMap.put(ERROR_MESSAGE_WITH_ERROR_CODE, ERROR_MESSAGE_WITH_ERROR_CODE + '512.');
        List<sObject> unformattedInactiveMemberships = queryInactiveSocityMembersipTableData(paramMap);

        // format inactive memberships
        paramMap.put(UNFORMATTED_RECORDS, unformattedInactiveMemberships);
        paramMap.put(SECTION_MAP_KEY, subPageNameToQuery.get(INACTIVE_MEMBERSHIP_SUB_SECTION_NAME));
        paramMap.put(GIVING_SETTINGS_METADATA, new List<Map<String, Object>>{new Map<String, Object>{GIVING_SETTINGS_URL_RECORD_NAME => (String)paramMap.get(INACTIVE_MEMBERSHIP_GIVING_SETTINGS_NAME),
                                                                                                        GIVING_SETTINGS_URL_RECORD_FILTER => (String)paramMap.get(INACTIVE_MEMBERSHIP_GIVING_SETTINGS_FILTER),
                                                                                                        GIVING_URL_FIELD_NAME => 'reenterGivingLink'}});
        List<Map<String, Object>> formattedInactiveSocietyMemberships = formatInactiveSocietyMembership(paramMap);


        returnMap.put('lifetimeMembershipRecords', formattedLiftimeSocietyMemberships);
        returnMap.put('annualMembershipRecords', formattedAnnualSocietyMemberships);
        returnMap.put('inactiveMembershipRecords', formattedInactiveSocietyMemberships);
        returnMap.put(PERMISSION_MAP_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(societyMembershipTablePageSections));

        return returnMap;
    }

    /**
     * Query lifetime society memberships.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryLifetimeSocietyMembershipTableData(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Query annual society memberships.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryAnnualSocietyMembershipTableData(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Query inactive society memberships.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<sObject> queryInactiveSocityMembersipTableData(Map<String, Object> paramMap) {
        return getTableQuery(paramMap);
    }

    /**
     * Format lifetime society membership records.
     *
     * @param   paramMap
     *              UNFORMATTED_RECORDS                         Unformatted society membership records.
     *              SECTION_MAP_KEY                             Portal Page section mapping.
     *              GIVING_SETTINGS_METADATA                    List containing map of     Portal Giving URL Setting name and Portal Giving URL Setting Field query filter.
     *              GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE     Map of giving society Id to earliest join date. Created using getGivingSocietyToEarliestMemberSinceDate function.
     * @return                                                  List of Portal Page Section formatted records.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<Map<String, Object>> formatLifetimeSocietyMemberships(Map<String, Object> paramMap) {
        return formatSocietyMembership(paramMap);
    }

    /**
     * Format annual membership records.
     *
     * @param   paramMap
     *              UNFORMATTED_RECORDS                         Unformatted society membership records.
     *              SECTION_MAP_KEY                             Portal Page section mapping.
     *              GIVING_SETTINGS_METADATA                    List containing map of     Portal Giving URL Setting name and Portal Giving URL Setting Field query filter.
     *              GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE     Map of giving society Id to earliest join date. Created using getGivingSocietyToEarliestMemberSinceDate function.
     * @return                                                  List of Portal Page Section formatted records.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<Map<String, Object>> formatAnnualSocietyMembership(Map<String, Object> paramMap) {
        return formatSocietyMembership(paramMap);
    }

    /**
     * Format inactive membership records.
     *
     * @param   paramMap
     *              UNFORMATTED_RECORDS                         Unformatted society membership records.
     *              SECTION_MAP_KEY                             Portal Page section mapping.
     *              GIVING_SETTINGS_METADATA                    List containing map of     Portal Giving URL Setting name and Portal Giving URL Setting Field query filter.
     *              GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE     Map of giving society Id to earliest join date. Created using getGivingSocietyToEarliestMemberSinceDate function.
     * @return                                                  List of Portal Page Section formatted records.
     * @version         1.0
     * @since           1.0
     */
    global virtual List<Map<String, Object>> formatInactiveSocietyMembership(Map<String, Object> paramMap) {
        List<sObject> unformattedRecords = (List<sObject>)paramMap.get(UNFORMATTED_RECORDS);
        Map<Id, sObject> givingSocietyIdToSocietyMembershipOrder = new Map<Id, sObject>();

        // grab first society inactive society membership by order
        for (sObject currentSObject : unformattedRecords) {
            Id givingSocietyId = (Id)currentSObject.get(SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP);

            if (!givingSocietyIdToSocietyMembershipOrder.containsKey(givingSocietyId)) {
                givingSocietyIdToSocietyMembershipOrder.put(givingSocietyId, currentSObject);
            }
        }

        paramMap.put(UNFORMATTED_RECORDS, givingSocietyIdToSocietyMembershipOrder.values());
        return formatSocietyMembership(paramMap);
    }

    /* HELPER FUNCTIONS */

    /**
     * Create a map of Giving society record Id to the earliest date the constituent has joined.
     *
     * @param           paramMap
     *                      contactId                           Id of the contact to use for society memberships.
     *                      whereClause                         Additonal where clause to include.
     * @return                                                  Map of giving society Id and earliest join date.
     * @version         1.0
     * @since           1.0
     */
    global virtual Map<Id, Date> getGivingSocietyToEarliestMemberSinceDate(Map<String, Object> paramMap) {
        Id contactId = (Id)paramMap.get('contactId');
        String additionalWhereClause = (String)paramMap.get('whereClause');
        Map<Id, Date> givingSocietyNameToJoinDate = new Map<Id, Date>();

        if (contactId == null) {
            return givingSocietyNameToJoinDate;
        }

        String queryString = ' SELECT ucinn_ascendv2__Giving_Society__c, MIN(ucinn_ascendv2__Member_Since__c) joinDate FROM ucinn_ascendv2__Society_Membership__c ' +
                             ' WHERE ucinn_ascendv2__Contact__c =: contactId AND ucinn_ascendv2__Member_Since__c != null AND ucinn_ascendv2__Giving_Society__c != null ';

        if (String.isNotBlank(additionalWhereClause)) {
            additionalWhereClause = additionalWhereClause.removeStartIgnoreCase('where');

            queryString += ' AND ' + additionalWhereClause + ' ';
        }

        queryString += ' GROUP BY ucinn_ascendv2__Giving_Society__c ';

        List<AggregateResult> earliestJoinDateByGivingSociety;

        try {
            earliestJoinDateByGivingSociety = Database.query(queryString);
        }
        catch (Exception e) {
            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '520.');
        }

        for (AggregateResult currentGivingSociety : earliestJoinDateByGivingSociety) {
            givingSocietyNameToJoinDate.put((Id)currentGivingSociety.get(SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP), (Date)currentGivingSociety.get('joinDate'));
        }

        return givingSocietyNameToJoinDate;
    }


    /* PRIVATE CLASS FUNCTIONS */

    /**
     * Query table data from information supplied in paramMap. Throws error if query could not sucessfully be made.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     *                                                      ERROR_MESSAGE_KEY                   Ability to specifiy custom error message.
     *                                                      QUERY_STRING_KEY                    Query string to query for.
     * @return                                          List of sObjects returned from the query.
     * @version         1.0
     * @since           1.0
     */
    @TestVisible
    private List<sObject> getTableQuery(Map<String, Object> paramMap) {
        List<sObject> sObjectList;
        String errorMessage = (String)paramMap.get(ERROR_MESSAGE_KEY);
        String queryString = (String)paramMap.get(QUERY_STRING_KEY);

        if (String.isBlank(queryString)) {
            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '500.');
        }

        try {
            sObjectList = Database.query(queryString);
        } catch(Exception e) {

            if (String.isBlank(errorMessage)) {
                errorMessage = e.getMessage();
            }

            throw new GivingSocietiesException(errorMessage);
        }

        return sObjectList;
    }

    /**
     * Query number of records in the table data from information supplied in paramMap. Throws error if query could not sucessfully be made.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     * @return                                          Number of records in the query.
     * @version         1.0
     * @since           1.0
     */
    @TestVisible
    private Integer getTableCountQuery(Map<String, Object> paramMap) {
        Integer count = 0;
        String errorMessage = (String)paramMap.get(ERROR_MESSAGE_KEY);
        String queryString = (String)paramMap.get(QUERY_STRING_KEY);

        if (String.isBlank(queryString)) {
            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '501.');
        }

        try {
            count = Database.countQuery(queryString);
        } catch(QueryException e) {

            if (String.isBlank(errorMessage)) {
                errorMessage = e.getMessage();
            }

            throw new GivingSocietiesException(ERROR_MESSAGE_WITH_ERROR_CODE + '518.');
        }

        return count;
    }

    /**
     * Format society membership records.
     *
     * @param   paramMap
     *              UNFORMATTED_RECORDS                         Unformatted society membership records.
     *              SECTION_MAP_KEY                             Portal Page section mapping.
     *              GIVING_SETTINGS_METADATA                    List containing map of     Portal Giving URL Setting name and Portal Giving URL Setting Field query filter.
     *              GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE     Map of giving society Id to earliest join date. Created using getGivingSocietyToEarliestMemberSinceDate function.
     * @return                                                  List of Portal Page Section formatted records.
     * @version         1.0
     * @since           1.0
     */
    private List<Map<String, Object>> formatSocietyMembership(Map<String, Object> paramMap) {
        List<sObject> unformattedRecords = (List<sObject>)paramMap.get(UNFORMATTED_RECORDS);
        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(SECTION_MAP_KEY);
        List<Map<String, Object>> formattedRecords = new List<Map<String, Object>>();
        List<Map<String, Object>> givingURLSettingsMetadataList = new List<Map<String, Object>>();

        for (Map<String, Object> givingURLSettingsParams : (List<Map<String, Object>>)paramMap.get(GIVING_SETTINGS_METADATA)) {
            Map<String, Object> currentGivingURLSettingsMetadata = PORTAL_UTIL_GivingURLSetting.getGivingURLSettingsMap((String)givingURLSettingsParams.get(GIVING_SETTINGS_URL_RECORD_NAME),
                                                                                                                        (String)givingURLSettingsParams.get(GIVING_SETTINGS_URL_RECORD_FILTER));
            if (currentGivingURLSettingsMetadata != null) {
                currentGivingURLSettingsMetadata.put(GIVING_URL_FIELD_NAME, (String)givingURLSettingsParams.get(GIVING_URL_FIELD_NAME));
                givingURLSettingsMetadataList.add(currentGivingURLSettingsMetadata);
            }
        }

        Map<Id, Date> givingSocietyIdToEarliestJoinDate = (Map<Id, Date>)paramMap.get(GIVING_SOCIETY_ID_TO_EARLIEST_JOIN_DATE);

        // generate links
        for (sObject currentSocietyMembership : unformattedRecords) {
            Id givingSocietyId = (Id)currentSocietyMembership.get(SOCIETY_MEMBERSHIP_GIVING_SOCIETY_LOOKUP);
            Map<String, Map<String, Object>> sObjectFieldMap = PORTAL_UTIL_GivingURLSetting.generateSObjectMap(currentSocietyMembership);

            List<Map<String, Object>> currentFormattedRecord = PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(new List<sObject>{currentSocietyMembership}, objectToFieldMap);

            if (!currentFormattedRecord.isEmpty()) {
                if (givingSocietyIdToEarliestJoinDate != null && givingSocietyId != null && givingSocietyIdToEarliestJoinDate.get(givingSocietyId) != null) {
                    currentFormattedRecord[0].put('earliestJoinDate', givingSocietyIdToEarliestJoinDate.get(givingSocietyId));
                }

                for (Map<String, Object> givingURLSettingsMetadata: givingURLSettingsMetadataList) {
                    String givingURL = (String)PORTAL_UTIL_GivingURLSetting.createGivingURL(givingURLSettingsMetadata, sObjectFieldMap);
                    String givingURLFieldName = (String)givingURLSettingsMetadata.get(GIVING_URL_FIELD_NAME);

                    if (String.isNotBlank(givingURL) && String.isNotBlank(givingURLFieldName)) {
                        currentFormattedRecord[0].put(givingURLFieldName, givingURL);
                    }
                }

                formattedRecords.add(currentFormattedRecord[0]);
            }

        }

        return formattedRecords;
    }

}