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
global virtual inherited sharing class PORTAL_ZoneControllerBase {
    // class variables
    protected Id contactId;

    // class key variables
    public static final String PAGE_NAME = 'pageName';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public final static String PERMISSION_MAP_KEY = 'permissionMap';
    public final static String RECORDS_TO_RETURN_KEY = 'records';
    public final static String PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY = 'objectToFieldMap';
    public final static String ZONE_RECORDS_TYPES = 'zoneRecordTypes';
    public final static String FORMATTED_RECORDS = 'formattedRecords';
    public final static String SECTION_MAP_KEY = 'sectionMap';
    public final static String UNFORMATTED_RECORDS = 'unformattedRecords';
    public final static String RECORD_TYPE_NAMES_COMMA_SEPERATED = 'recordTypeNamesCommaSeperated';
    public final static String ZONE_MEMBERSHIP_ID = 'zoneMembershipId';
    public final static String ZONE_ID = 'zoneId';
    public final static String ZONE_MEM_ID = 'zoneMemId';
    public final static String RECORD_TYPE_FIELD = 'Record_Type__c';
    public final static String ZONE_METADATA = 'zoneMetadata';
    public final static String IS_ON_NEWSLETTER_FIELD = 'zoneMemIsOnNewsletter';
    public final static String IS_SHOW_ON_DIRECTORY_FIELD = 'zoneMemIsOnDirectory';
    public final static String MEMBER_OF = 'memberOf';
    public final static String COUNTRIES_CONST = 'countries';
    public final static String ZONE_BIO_DETAIL_URL = 'zoneBioDetailURL';
    public final static String DEGREE_STRING = 'degreeString';
    public final static String ZONE_NAME = 'zoneName';
    public final static String SELECTED_COUNTRY = 'selectedCountry';
    public final static String ORDER_CLAUSE = 'orderClause';
    public final static String CONTACT_RECORD = 'contactRecord';
    public final static String CITY_CONST = 'city';
    public final static String STATE_CONST = 'state';
    public final static String ZIP_CODE = 'zipCode';
    public final static String RADIUS_CONST = 'radius';
    public final static String COUNTRY_FIELD = 'Country__c';
    public final static String UNITED_STATES = 'United States';
    public final static String LABEL_CONST = 'label';
    public final static String VALUE_CONST = 'value';
    public final static String FIRST_NAME_A_TO_Z = 'First Name (A-Z)';
    public final static String FIRST_NAME_Z_TO_A = 'First Name (Z-A)';
    public final static String LAST_NAME_A_TO_Z = 'Last Name (A-Z)';
    public final static String LAST_NAME_Z_TO_A = 'Last Name (Z-A)';
    public final static String ZONE_LEADERSHIP = 'Zone Leadership';
    public final static String SCHOOL_DEGREE_INFORMATION_DEVELOPER_NAME = 'School_Degree_Information';
    public final static String ACTIVE_CONST = 'Active';
    public final static String PICTURE_URL = 'pictureURL';
    public final static String IS_DISPLAY_SHOW_ON_NEWSLETTER = 'isDisplayShowOnNewsletter';
    public final static String ORDER_BY = 'orderBy';
    public final static String ZONE_MEMBERSHIP_DATA = 'zoneMembershipData';
    public final static String BUTTON_LINK = 'buttonLink';
    public final static String LEADERSHIP_URL = 'leadershipURL';
    public final static String HOME_PAGE_URL = 'homePageURL';
    public final static String CONTACT_TITLE = 'contactTitle';
    public final static String CONTACT_NAME = 'contactName';
    public final static String CONTACT_EMAIL = 'contactEmail';
    public final static String ACTIVE_SERVICE_INDICATOR_VALUES = 'activeServiceIndicatorValues';
    public final static String LOGO_URL = 'logoURL';
    public final static String ZONE_BIO_DETAIL = 'Zone Bio Detail';
    public final static String ZONE_HOME_NAME = 'Zone Home Page';
    public final static String FEATURED_ZONE_MEMBERS = 'Featured Zone Members';
    public final static String ZONE_MEMBERSHIPS = 'Zone Memberships';

    public final static String CONTENT_PAGE = 'contentPage';
    public final static String SUB_PAGE_NAME = 'subPageName';
    public final static String CONTENT_MODULE = 'contentModule';

    // url parameters
    public final static String ZONE_MEMBERSHIP_ID_URL_PARAM = 'zmid';
    public final static String ZONE_NAME_URL_PARAM = 'zname';

    public final static String ERROR_NO_ZONE = 'A zone is required. Error Code: 102.';
    public final static String ERROR_QUERY = 'There was an issue retrieving your data. Please contact the administrator.';
    public final static String ERROR_RETRIEVE_ZONES = 'There was an error retrieving your zones. Error Code: 101.';

    private final static String STATUS_PENDING = 'Pending';
    private final static String STATUS_INACTIVE = 'Inactive';
    private final static String STATUS_ACTIVE = 'Active';

    public final static String ID_KEY = 'id';
    public final static String RECORDS_CONST = 'records';
    public final static String FRONT_END_DATA_MAP = 'frontEndDataMap';

    public final static String ZONE_MEMBERSHIP_CONTACT_ID = 'zoneMembershipContactId';
    public final static String ZONE_MEMBERSHIP_PICTURE_RECORD = 'zoneMembershipPictureRecord';

    global PORTAL_ZoneControllerBase() {
        contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).ContactId;
    }

    /**
    * Get zone records name based on URL paramaters
    *
    * @author   Phillip Nguyen
    * @since    1.0
    *
    * @param zmid    Zone membership Id Url Parameter
    * @param zname   Zone Name URL parameter
    * @return        name of the zone record
    */
    global virtual String getZoneTitle(Map<String, Object> params) {
        String returnString = '';

        if (params == null || params.isEmpty()) {
            return returnString;
        }

        String zoneMembershipIdUrlParam = (String)params.get(ZONE_MEMBERSHIP_ID_URL_PARAM);
        String zoneNameUrlParam = (String)params.get(ZONE_NAME_URL_PARAM);

        if (String.isNotBlank(zoneMembershipIdUrlParam)) {
            // query zone membership and return zone name
            List<ucinn_portal_Zone_Membership__c> zoneMembershipList = [SELECT Zone__r.Name
                                                                        FROM ucinn_portal_Zone_Membership__c
                                                                        WHERE Id = :zoneMembershipIdUrlParam];

            if (zoneMembershipList != null && !zoneMembershipList.isEmpty()) {
                returnString = zoneMembershipList[0].Zone__r.Name;
            }
        } else if (String.isNotBlank(zoneNameUrlParam)) {
            returnString = zoneNameUrlParam;
        }

        return returnString;
    }

    /**
    * Get zone board members & featured zone board members for a given zone
    *
    * @param    pageName                                        page name of the Portal Page Section Setting to use
    * @param    mainSectionName                                 main section name of Portal Page Section Setting to use
    * @param    zoneName                                        Zone Name used to filter zone memberships
    * @param    orderBy                                         Determines the order of featured board memberships returned
    * @return                                                   Map of featured board memebrs and button links
    * @since                                                    1.0
    */
    public virtual Map<String, Object> getZoneBoardMembers(Map<String, object> params){
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String pageName = (String) params.get(PAGE_NAME);
        String mainSectionName = (String) params.get(MAIN_SECTION_NAME);
        String zoneName = (String)params.get(ZONE_NAME);
        String orderBy = (String)params.get(ORDER_BY);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(zoneName)) {
            System.debug('Get zone Board members parameters are blank');
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_QUERY});
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass queryOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        queryOverride.dynamicOrderByClause = getOrderByForBoardMembers(orderBy);
        queryOverride.dynamicWhereClause = ' WHERE Zone__r.Name = \'' + String.escapeSingleQuotes(zoneName) + '\'';

        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                                              .buildMainSectionName(mainSectionName)
                                                                                              .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{mainSectionName => queryOverride})
                                                                                              .build();

        if (pageSectionAdapter == null) {
            return returnMap;
        }

        returnMap.put(PERMISSION_MAP_KEY, pageSectionAdapter.getFrontEndDataMap());
        returnMap.put(RECORDS_TO_RETURN_KEY, addAdditionalInformationToRecords(pageSectionAdapter.getRecords()?.get(mainSectionName)?.get(RECORDS_CONST)));
        returnMap.put(ZONE_NAME, zoneName);

        return returnMap;
    }

    /**
     * Query for the zone related links static information from content page
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param contentPage       Name of the content page to pull data from.
     * @param subPageName       Sub page name of the content page to pull the data from.
     * @param contentModule     Name of the related content module to pull the data from.
     * @return                  Content module metadata for the related record.
     */
    global virtual Map<String, Object> getZoneRelatedLinks(Map<String, Object> params) {
        PORTAL_StaticContentControllerBase staticContentController = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();

        return staticContentController.getContentModuleMetadata(new Map<String, Object>{
            PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => (String)params?.get(CONTENT_PAGE),
            PORTAL_StaticContentControllerBase.PARAM_SUB_PAGE_NAME => (String)params?.get(SUB_PAGE_NAME),
            PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => (String)params?.get(CONTENT_MODULE)
        });
    }

    /**
    * Return a single formatted zone membership bio detail information
    *
    * @param    zoneMembershipId                              Id of zone membership record to query for
    * @return                                                 Map containing bio information related to the zone membership record
    * @since                                                  1.0
    */
    global virtual Map<String, Object> getZoneBioDetailInfo(Map<String, object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String zoneMembershipId = (String)params.get(ZONE_MEMBERSHIP_ID);

        if (String.isBlank(zoneMembershipId)) {
            System.debug('Missing zone membership id');
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_QUERY});
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(ZONE_BIO_DETAIL)
                                                                                              .buildMainSectionName(ZONE_BIO_DETAIL)
                                                                                              .buildParentFieldId(zoneMembershipId)
                                                                                              .build();

        if (pageSectionAdapter == null) {
            return returnMap;
        }

        returnMap.put(PERMISSION_MAP_KEY, pageSectionAdapter.getFrontEndDataMap());
        returnMap.put(RECORDS_TO_RETURN_KEY, addAdditionalInformationToRecords(pageSectionAdapter.getRecords().get(ZONE_BIO_DETAIL).get(RECORDS_CONST))?.get(0));

        return returnMap;
    }

    /**
     * Adds additional information to zone memberships records related to zone leadership.
     * Adds information such as zone bio detail links, degree information, picture url
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param zoneMembershipRecords     List of zone membership records that have been converted to a Map to add additional information too
     *
     * @return                          List of zone membership records that have been updated
     */
    protected virtual List<Map<String, Object>> addAdditionalInformationToRecords(List<Map<String, Object>> zoneMembershipRecords) {
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();

        if (zoneMembershipRecords == null || zoneMembershipRecords.isEmpty()) {
            return returnList;
        }

        Map<Id, Contact> contactIdToContactDegreeInfoMap = getDegreeInformationForContactsMap(zoneMembershipRecords);

        for (Map<String, Object> eachZoneMembershipMap : zoneMembershipRecords) {
            if (eachZoneMembershipMap == null || eachZoneMembershipMap.isEmpty()) {
                continue;
            }

            eachZoneMembershipMap.put(ZONE_MEMBERSHIP_ID, eachZoneMembershipMap.get(ZONE_MEMBERSHIP_ID));

            eachZoneMembershipMap.put(DEGREE_STRING, createDegreeString(contactIdToContactDegreeInfoMap.get((String)eachZoneMembershipMap.get(ZONE_MEMBERSHIP_CONTACT_ID))));

            if (String.isNotBlank((String)eachZoneMembershipMap.get(ZONE_MEMBERSHIP_PICTURE_RECORD))) {
                eachZoneMembershipMap.put(ZONE_MEMBERSHIP_PICTURE_RECORD, eachZoneMembershipMap.get(ZONE_MEMBERSHIP_PICTURE_RECORD));
            }

            returnList.add(eachZoneMembershipMap);
        }

        return returnList;
    }

    /**
     * Gets Contact Id to Contact Record mapping. Contact record contains degree information
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param zoneMembershipList    List of zone membership records that have been converted to a Map
     *
     * @return                      Map of Contact Id to Contact record that contains degree information
     */
    private Map<Id, Contact> getDegreeInformationForContactsMap(List<Map<String, Object>> zoneMembershipList) {
        Map<Id, Contact> returnMap = new Map<Id, Contact>();

        if (zoneMembershipList == null || zoneMembershipList.isEmpty()) {
            return returnMap;
        }

        List<Id> contactIdList = new List<Id>();

        for (Map<String, Object> eachZoneMembershipMap : zoneMembershipList) {
            contactIdList.add((Id)eachZoneMembershipMap.get(ZONE_MEMBERSHIP_CONTACT_ID));
        }

        returnMap = new Map<Id, Contact>([SELECT Id,
                                            (SELECT ucinn_ascendv2__Degree__c, ucinn_ascendv2__Conferred_Degree_Year__c
                                                FROM ucinn_ascendv2__Degree_Information_Contact__r
                                                WHERE RecordType.DeveloperName = :SCHOOL_DEGREE_INFORMATION_DEVELOPER_NAME
                                                AND ucinn_portal_Status__c = :ACTIVE_CONST
                                                ORDER BY ucinn_ascendv2__Conferred_Degree_Year__c ASC)
                                          FROM Contact WHERE Id IN :contactIdList]);  // Aggregate query, so its limited to 2000 records

        return returnMap;
    }

    /**
     * Creates Degree String for zone membership record
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param contactRecord     Contact Record that contains degree information
     *
     * @return                  Formatted degree string
    */
    protected virtual String createDegreeString(Contact contactRecord) {
        String degreeString = '';

        if (contactRecord == null ||
                (contactRecord.ucinn_ascendv2__Degree_Information_Contact__r == null
                || contactRecord.ucinn_ascendv2__Degree_Information_Contact__r.isEmpty())) {
            return degreeString;
        }

        for (ucinn_ascendv2__Degree_Information__c eachDegree : contactRecord.ucinn_ascendv2__Degree_Information_Contact__r) {
            if (String.isBlank(eachDegree.ucinn_ascendv2__Degree__c) || String.isBlank(eachDegree.ucinn_ascendv2__Conferred_Degree_Year__c)) {
                continue;
            }

            degreeString += eachDegree.ucinn_ascendv2__Degree__c + '\'' + eachDegree.ucinn_ascendv2__Conferred_Degree_Year__c + ', ';
        }

        if (String.isNotBlank(degreeString)) {
            degreeString = degreeString.removeEnd(', ');
        }

        return degreeString;
    }

    /**
     * Gets order by clause for board members query
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param orderClause   Order Clause from front end
     *
     * @return              Order by clause for query
     */
    @TestVisible
    private virtual String getOrderByForBoardMembers(String orderClause) {
        String returnString = '';

        if (String.isBlank(orderClause)) {
            return returnString;
        }

        if (orderClause == FIRST_NAME_A_TO_Z) {
            returnString = ' ORDER BY Constituent__r.FirstName ASC ';
        }
        else if (orderClause == FIRST_NAME_Z_TO_A) {
            returnString = ' ORDER BY Constituent__r.FirstName DESC ';
        }
        else if (orderClause == LAST_NAME_A_TO_Z) {
            returnString = ' ORDER BY Constituent__r.LastName ASC ';
        }
        else if (orderClause == LAST_NAME_Z_TO_A) {
            returnString = ' ORDER BY Constituent__r.LastName DESC ';
        }

        return returnString;
    }

    /**
    * method that unsubscribes a contact from all newsletters
    * we unsubcribe from everything instead of per zone to satisfy CAN-SPAM act
    *
    * @param id:                                the contact id for the person unsubscribing, prioritized over email if both available
    * @param contactEmail:                      The email address for the person unsubscribing, used if id is not available
    * @author:                                  Sam Longo
    * @since:                                   1.0
    */
    public virtual void unsubscribeFromNewsletter(Map<String, Object> params) {
        String contactId = (String) params?.get(ID_KEY);
        String email = (String) params?.get(CONTACT_EMAIL);

        if (String.isBlank(contactId) && String.isBlank(email)) {
            throw new AuraHandledException('Error unsubscribing. please log in to preferences or email the site owner.');
        }

        List<ucinn_portal_Zone_Membership__c> zoneMembershipList = new List<ucinn_portal_Zone_Membership__c>();

        if (String.isNotBlank(contactId)) {
            zoneMembershipList = [SELECT Id, Is_On_Newsletter__c, Status__c FROM ucinn_portal_Zone_Membership__c WHERE Constituent__c = :contactId];

        } else if (String.isNotBlank(email)) {
            zoneMembershipList = [SELECT Id, Is_On_Newsletter__c, Status__c FROM ucinn_portal_Zone_Membership__c WHERE Constituent__r.Email = :email];
        }

        for (ucinn_portal_Zone_Membership__c eachMembership : zoneMembershipList) {
            eachMembership.Is_On_Newsletter__c = false;
            eachMembership.Status__c = STATUS_INACTIVE;
        }

        update zoneMembershipList;
    }

    /**
     * Query and return zone banner related to the specific zone from content module record
     * Look for a default one without zoneName if there isn't one
     *
     * @param pageName      Name of the Content Module's Content Page.
     * @param moduleName    Name of the Content Module.
     * @param zoneName      Name of the Zone the Content Module is for (if any).
     * @return              Content Module Metadata in the form of a Map.
     * @since               1.0
     */
    global virtual Map<String, Object> getZoneBanner(Map<String, Object> params) {
        PORTAL_StaticContentControllerBase controller = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();
        Map<String, Object> resultMap = controller.getContentModuleMetadata(params);

        if (resultMap != null && !resultMap.isEmpty()) {
            return resultMap;
        }

        params.put(PORTAL_StaticContentControllerBase.PARAM_SUB_PAGE_NAME, '');
        resultMap = controller.getContentModuleMetadata(params);

        if (resultMap != null && !resultMap.isEmpty()) {
            return resultMap;
        }

        return new Map<String, Object>();
    }
}