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
 * Base Controller for Zone Membership Table Controller
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */
public inherited sharing virtual class PORTAL_ZoneMembershipTableControllerBase {
    public static final String PAGE_NAME = 'pageName';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String SUB_SECTION_NAME = 'subSectionName';
    public static final String FRONT_END_DATA_MAP = 'frontEndDataMap';
    public static final String RECORDS_CONST = 'records';
    public static final String ZONE_MEMBERSHIPS_TO_LEAVE = 'zoneMembershipsToLeave';
    public static final String ZONE_MEMBERSHIPS_TO_JOIN = 'zoneMembershipsToJoin';
    public static final String ZONE_MEMBERSHIP_ID_TO_CHECKBOX_VALUES_MAP = 'zoneMembershipIdsToCheckboxValuesMap';
    public static final String ZONE_RECORD_TYPE = 'zoneRecordType';
    public final static String ACTIVE_SERVICE_INDICATOR_VALUES = 'activeServiceIndicatorValues';
    public final static String CONSTITUENT_TYPES = 'constituentTypes';
    public final static String CREATE_CASE = 'Create Case';
    public final static String FIELD_API_NAME = 'fieldApiName';
    public final static String PORTAL_MEMBERSHIP_SETTING_NAME = 'portalMembershipSettingName';
    public final static String ZONE_DISPLAY_TYPE = 'zoneDisplayType';
    public final static String AVAILABLE_ZONES_TO_JOIN_MAP = 'availableZonesToJoinMap';
    public final static String ZONE_ID = 'zoneId';
    public final static String ID_CONST = 'Id';
    public final static String ZONE_LOOKUP_API_NAME = 'Zone__c';
    public final static String NEWSLETTER_VALUES = 'newsletterValues';

    public final static String ERROR_MESSAGE_SAVE_GENERIC = 'There was an error saving your information. Please contact an administrator.';

    /**
     * Gets zone membership records based on the portal page section settings.
     *
     * @author Phillip Nguyen
     * @since  1.0
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @param subSectionName        The sub section name of the Portal Page Section Setting to use.
     * @return                      Map containing the front end layout and zone membership records.
     */
    public virtual Map<String, Object> getZoneMembershipRecords(Map<String, Object> params){
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String pageName = (String) params.get(PAGE_NAME);
        String mainSectionName = (String) params.get(MAIN_SECTION_NAME);
        String subSectionName = (String) params.get(SUB_SECTION_NAME);

        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString) || String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(subSectionName)) {
            return resultMap;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .buildSubSectionName(subSectionName)
                                                                    .buildParentFieldId(contactIdString)
                                                                    .build();

        if (pageSectionAdapter == null) {
            return resultMap;
        }

        resultMap.put(FRONT_END_DATA_MAP, pageSectionAdapter.getFrontEndDataMap());
        resultMap.put(RECORDS_CONST, pageSectionAdapter.getRecords().get(mainSectionName).get(subSectionName));

        return resultMap;
    }

    /**
     * Save zone membership records that have been updated on the front end
     * Also process zone memberships that we want to join and handle creating cases for certain record types
     *
     * @author Phillip Nguyen
     * @since 1.0
     *
     * @param pageName                              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName                       The main section name of the Portal Page Section Setting to use.
     * @param zoneMembershipIdsToLeave              List of zone membership ids that we want to set to inactive (leave)
     * @param zoneMembershipIdsToCheckboxValues     Map of zone membership ids to their new checbox values (is show on director/newsletter)
     * @param zoneMembershipsToJoin                 List of zone membership ids that we want to join
     */
    public virtual void saveZoneMembershipRecords(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            return;
        }

        String pageName = (String) params.get(PAGE_NAME);
        String mainSectionName = (String) params.get(MAIN_SECTION_NAME);
        List<Object> zoneMembershipIdsToLeaveList = (List<Object>)params.get(ZONE_MEMBERSHIPS_TO_LEAVE);
        Map<Object, Object> zoneMembershipIdsToCheckboxValuesMap = (Map<Object, Object>)params.get(ZONE_MEMBERSHIP_ID_TO_CHECKBOX_VALUES_MAP);
        List<Object> zoneMembershipsToJoinList = (List<Object>)params.get(ZONE_MEMBERSHIPS_TO_JOIN);

        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(contactIdString)) {
            return;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .build();

        addZoneMemberships(zoneMembershipsToJoinList, contactIdString, pageSectionAdapter);

        Map<String, ucinn_portal_Zone_Membership__c> zoneMemIdToZoneMemUpdateMap = processZoneMembershipCheckboxUpdates(zoneMembershipIdsToCheckboxValuesMap, pageSectionAdapter);
        zoneMemIdToZoneMemUpdateMap = processLeavingZoneMemberships(zoneMembershipIdsToLeaveList, zoneMemIdToZoneMemUpdateMap);

        update zoneMemIdToZoneMemUpdateMap.values();
    }

    /**
     * Grabs information for zone membership table such as the zone display type, the zone record type, and the available zones to join
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param  portalMembershipSettingName  Name of the portal membership setting name to query
     * @return                              Map that contains zone display type and zone record type,
     *                                      available zones to join, contact info and values for checking is on newsletter
     */
    public virtual Map<String, Object> getZoneTableInformation(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String portalMembershipSettingName = (String)params.get(PORTAL_MEMBERSHIP_SETTING_NAME);
        Portal_Membership_Setting__mdt zoneMembershipSetting = getZoneMembershipSetting(portalMembershipSettingName);
        Map<String, List<ucinn_portal_Zone__c>> availableZonesToJoinMap = getAvailableZonesToJoin();
        List<String> valuesForCheckingIsOnNewsletterList = getListOfValuesForCheckingIsOnNewsletter(zoneMembershipSetting?.Values_For_Checking_Is_On_Newsletter__c);

        resultMap.put(ZONE_DISPLAY_TYPE, zoneMembershipSetting?.Zone_Display_Types__c);
        resultMap.put(ZONE_RECORD_TYPE, zoneMembershipSetting?.Record_Type__c);
        resultMap.put(AVAILABLE_ZONES_TO_JOIN_MAP, availableZonesToJoinMap);
        resultMap.put(NEWSLETTER_VALUES, valuesForCheckingIsOnNewsletterList);
        resultMap.put(ACTIVE_SERVICE_INDICATOR_VALUES, getContactInfo(PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId)?.get(ACTIVE_SERVICE_INDICATOR_VALUES));

        return resultMap;
    }

    /**
     * Get portal membership setting custom metadata
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param portalMembershipSettingName  Name of portal membership setting
     * @return                             Portal Membership Setting
     */
    private virtual Portal_Membership_Setting__mdt getZoneMembershipSetting(String portalMembershipSettingName) {
        if (String.isBlank(portalMembershipSettingName)) {
            return null;
        }

        List<Portal_Membership_Setting__mdt> portalMembershipSettingList = (List<Portal_Membership_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Zone_display_types__c', 'Record_Type__c', 'Values_For_Checking_Is_On_Newsletter__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Membership_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{String.escapeSingleQuotes(portalMembershipSettingName)}
        });

        if (portalMembershipSettingList == null || portalMembershipSettingList.isEmpty()) {
            return null;
        }

        return portalMembershipSettingList.get(0);
    }

    /**
     * Get available zones to join which is any zone they do NOT have an active/pending zone membership for.
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @return Map of zone record types to zone records
     */
    protected virtual Map<String, List<ucinn_portal_Zone__c>> getAvailableZonesToJoin() {
        Map<String, List<ucinn_portal_Zone__c>> resultMap = new Map<String, List<ucinn_portal_Zone__c>>();

        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString)) {
            return resultMap;
        }

        List<ucinn_portal_Zone__c> availableZonesToJoinList = [SELECT Id, Name, RecordType.DeveloperName
                                                                FROM ucinn_portal_Zone__c
                                                                WHERE Id NOT IN
                                                                    (SELECT Zone__c
                                                                     FROM ucinn_portal_Zone_Membership__c
                                                                     WHERE Status__c IN (:PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_ACTIVE,
                                                                                         :PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_PENDING)
                                                                     AND Constituent__c = :contactIdString)
                                                                AND Is_Display_on_Portal__c = true];

        if (availableZonesToJoinList == null || availableZonesToJoinList.isEmpty()) {
            return resultMap;
        }

        resultMap = createRecordTypeToZoneMap(availableZonesToJoinList);

        return resultMap;
    }

    /**
     * Gets a list of strings representing all of the service indicator codes in the "Values for checking is on newsletter"
     * field on Portal Zone Membership Settings.
     *
     * @author  Isaiah Rodriguez
     * @since   1.0
     *
     * @param valuesForCheckingIsOnNewsletter       String values to check if is on Newsletter
     *
     * @return                                      List of Strings that do not have leading or trailing whitespace characters
     */
    protected virtual List<String> getListOfValuesForCheckingIsOnNewsletter(String valuesForCheckingIsOnNewsletter) {
        List<String> resultList = new List<String>();

        if (String.isBlank(valuesForCheckingIsOnNewsletter)) {
            return resultList;
        }

        for (String eachValue : valuesForCheckingIsOnNewsletter.split(',')) {
            resultList.add(eachValue.trim());
        }

        return resultList;
    }

    /**
     * Creates mapping of zone record type developer name to zone record
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param availableZonesToJoinList      List of zones that portal user can join.
     *                                      Includes zones that constituent does not have a membership for, or has an inactive zone membership
     *
     * @return                              Map of zone record type developer name to zone record
     */
    private Map<String, List<ucinn_portal_Zone__c>> createRecordTypeToZoneMap(List<ucinn_portal_Zone__c> availableZonesToJoinList) {
        Map<String, List<ucinn_portal_Zone__c>> returnMap = new Map<String, List<ucinn_portal_Zone__c>>();
        if (availableZonesToJoinList == null || availableZonesToJoinList.isEmpty()) {
            return returnMap;
        }

        for (ucinn_portal_Zone__c eachZone : availableZonesToJoinList) {
            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();

            if (returnMap.containsKey(eachZone.RecordType.DeveloperName)) {
                zoneList = (List<ucinn_portal_Zone__c>)returnMap.get(eachZone.RecordType.DeveloperName);
                zoneList.add(eachZone);
            } else {
                zoneList = new List<ucinn_portal_Zone__c>();
                zoneList.add(eachZone);
            }

            returnMap.put(eachZone.RecordType.DeveloperName, zoneList);
        }

        return returnMap;
    }

    /**
     * Process leaving zone memberships which is setting the statis to inactive.
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param zoneMembershipIdsToLeaveList  List of zone memberships ids to set to inactive (leave)
     * @param zoneMemIdToZoneMemUpdateMap   Map of zone membership Ids to zone memberships
     *
     * @return                              Map of zone membership Id to zone membership to update
     */
    protected virtual Map<String, ucinn_portal_Zone_Membership__c> processLeavingZoneMemberships(List<Object> zoneMembershipIdsToLeaveList, Map<String, ucinn_portal_Zone_Membership__c> zoneMemIdToZoneMemUpdateMap) {
        Map<String, ucinn_portal_Zone_Membership__c> returnMap = new Map<String, ucinn_portal_Zone_Membership__c>(zoneMemIdToZoneMemUpdateMap);

        if (zoneMembershipIdsToLeaveList == null || zoneMembershipIdsToLeaveList.isEmpty() || zoneMemIdToZoneMemUpdateMap == null) {
            return returnMap;
        }

        for (Object eachZoneMembershipId : zoneMembershipIdsToLeaveList) {
            if (String.isBlank((String)eachZoneMembershipId)) {
                continue;
            }

            ucinn_portal_Zone_Membership__c modifiedZoneMembership = new ucinn_portal_Zone_Membership__c(Id = (String)eachZoneMembershipId);
            if (zoneMemIdToZoneMemUpdateMap.containsKey((String)eachZoneMembershipId)) {
                modifiedZoneMembership = zoneMemIdToZoneMemUpdateMap.get((String)eachZoneMembershipId);
            }

            modifiedZoneMembership.Status__c = PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_INACTIVE;

            returnMap.put((String)eachZoneMembershipId, modifiedZoneMembership);
        }

        return returnMap;
    }

    /**
     * Process checkbox updates on zone memberships i.e. show on newsletter and directory
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param zoneMembershipIdsToCheckboxValuesMap  Zone memberships Id to updated values from front end
     *
     * @return                                      Map of zone membership Id to zone membership to update
     */
    protected virtual Map<String, ucinn_portal_Zone_Membership__c> processZoneMembershipCheckboxUpdates(Map<Object, Object> zoneMembershipIdsToCheckboxValuesMap, PORTAL_PageSectionAdapter pageSectionAdapter) {
        Map<String, ucinn_portal_Zone_Membership__c> returnMap = new Map<String, ucinn_portal_Zone_Membership__c>();

        if (zoneMembershipIdsToCheckboxValuesMap == null || zoneMembershipIdsToCheckboxValuesMap.isEmpty() || returnMap == null) {
            return returnMap;
        }

        Map<String, Object> backEndDataMap = pageSectionAdapter.getBackEndDataMap();

        if (backEndDataMap == null || backEndDataMap.isEmpty()) {
            return returnMap;
        }

        for (Object eachZoneMembershipId : zoneMembershipIdsToCheckboxValuesMap.keySet()) {
            Map<Object,Object> eachZoneMemFieldIdToValueMap = (Map<Object,Object>)zoneMembershipIdsToCheckboxValuesMap.get(eachZoneMembershipId);
            ucinn_portal_Zone_Membership__c newZoneMembership = new ucinn_portal_Zone_Membership__c(Id=(String)eachZoneMembershipId);

            for (Object eachZoneMemFieldId : eachZoneMemFieldIdToValueMap.keySet()) {
                if (eachZoneMemFieldId == null) {
                    continue;
                }

                Map<String, Object> fieldIdToDataMap = (Map<String, Object>)backEndDataMap.get((String)eachZoneMemFieldId);

                newZoneMembership.put((String)fieldIdToDataMap.get(FIELD_API_NAME), Boolean.valueOf(eachZoneMemFieldIdToValueMap.get(eachZoneMemFieldId)));
            }

            returnMap.put((String)eachZoneMembershipId, newZoneMembership);
        }

        return returnMap;
    }

    /**
     * Add zone membership for constituent from front end. Checks for relevant zone membership metadata for different insertion methods.
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param zoneMembershipsToJoin      List of zone memberships to Add from front end
     * @param contactIdString           Current user's contact Id String
     */
    private virtual void addZoneMemberships(List<Object> zoneMembershipsToJoin, String contactIdString, PORTAL_PageSectionAdapter pageSectionAdapter) {
        if (zoneMembershipsToJoin == null || zoneMembershipsToJoin.isEmpty() || String.isBlank(contactIdString) || pageSectionAdapter == null) {
            return;
        }

        Map<String, Object> backEndDataMap = pageSectionAdapter.getBackEndDataMap();

        if (backEndDataMap == null || backEndDataMap.isEmpty()) {
            return;
        }

        Map<String, Portal_Membership_Setting__mdt> zoneRecordTypeNameToMetadataMap = getZoneRecordTypeNameToCMTMap();
        Map<String, List<ucinn_portal_Zone_Membership__c>> recordTypeToZoneMembershipsToUpsertMap = getZoneMembershipsToUpsertByRecordType(zoneMembershipsToJoin, contactIdString, backEndDataMap, zoneRecordTypeNameToMetadataMap);
        List<ucinn_portal_Zone_Membership__c> zoneMembershipListForCaseCreation = getZoneMembershipsForCaseCreation(recordTypeToZoneMembershipsToUpsertMap, zoneRecordTypeNameToMetadataMap, contactIdString);

        List<ucinn_portal_Zone_Membership__c> zoneMembershipsToUpsertList = populateCaseForZoneMemberships(recordTypeToZoneMembershipsToUpsertMap, zoneMembershipListForCaseCreation, contactIdString);

        upsert zoneMembershipsToUpsertList;
    }

    /**
     * Populate case for zone memberships if the zone membership is linked to a case.
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param recordTypeToZoneMembershipsToUpsertMap    Map of zone record types to zone memberships to upsert
     * @param zoneMembershipListForCaseCreation         List of zone memberships that will be linked to a case
     * @param contactIdString                           Id of contact that will be used for potential case
     *
     * @return                                          List of zone memberships to upsert
     */
    private List<ucinn_portal_Zone_Membership__c> populateCaseForZoneMemberships(Map<String, List<ucinn_portal_Zone_Membership__c>> recordTypeToZoneMembershipsToUpsertMap,
                                                                                 List<ucinn_portal_Zone_Membership__c> zoneMembershipListForCaseCreation,
                                                                                 String contactIdString) {

        List<ucinn_portal_Zone_Membership__c> returnList = new List<ucinn_portal_Zone_Membership__c>();
        if (recordTypeToZoneMembershipsToUpsertMap == null || recordTypeToZoneMembershipsToUpsertMap.isEmpty() || String.isBlank(contactIdString)) {
                return returnList;
        }

        for (List<ucinn_portal_Zone_Membership__c> eachZoneMembershipList : recordTypeToZoneMembershipsToUpsertMap.values()) {
            returnList.addAll(eachZoneMembershipList);
        }

        if (zoneMembershipListForCaseCreation == null || zoneMembershipListForCaseCreation.isEmpty()) {
            return returnList;
        }

        String caseId = handleCaseCreation(contactIdString);
        for (ucinn_portal_Zone_Membership__c eachZoneMembership : zoneMembershipListForCaseCreation) {
            eachZoneMembership.Case__c = caseId;
        }

        return returnList;
    }

    /**
     * If the new zone membership matches an existing zone membership (by comparing zone Ids), that equals Inactive or Denied, then we will set the new zone membership Id to the existing
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param zoneMembershipsToJoinList             List of front end zone memberships to join
     * @param contactIdString                       Current user's constituent Id
     *
     * @return                                      List of front end zone memberships with populated Id field and converted to Map<Object, Object>
     */
    private List<Map<Object, Object>> getMembershipDataMapsWithExistingIds(List<Object> zoneMembershipsToJoinList, String contactIdString) {
        List<Map<Object, Object>> returnList = new List<Map<Object, Object>>();

        if (zoneMembershipsToJoinList == null || zoneMembershipsToJoinList.isEmpty() || String.isBlank(contactIdString)) {
            return returnList;
        }

        Map<String, ucinn_portal_Zone_Membership__c> existingZoneIdToZoneMembershipMap = getExistingZoneIdToZoneMembershipMap(contactIdString);

        for (Object eachZoneMembership : zoneMembershipsToJoinList) {
            Map<Object, Object> eachZoneMembershipMap = (Map<Object, Object>)eachZoneMembership;
            String zoneRecordType = (String)eachZoneMembershipMap.get(ZONE_RECORD_TYPE);

            if (String.isBlank(zoneRecordType)) {
                continue;
            }

            ucinn_portal_Zone_Membership__c existingZoneMembership = existingZoneIdToZoneMembershipMap.get((String)eachZoneMembershipMap.get(ZONE_ID));

            if (existingZoneMembership != null && (existingZoneMembership.Status__c == PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_INACTIVE || existingZoneMembership.Status__c == PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_DENIED)) {
                eachZoneMembershipMap.put(ID_CONST, existingZoneMembership.Id);
            }

            returnList.add(eachZoneMembershipMap);
        }

        return returnList;
    }

    /**
     * Gets zone memberships to upsert. Creates mapping of record type to zone membership to upsert.
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param zoneMembershipsToJoinList          List of zone memberships to join from the front end with the Id prepopulated
     * @param contactIdString                   Current user's constituent Id
     * @param backEndDataMap                    Back end data map, contains mapping of front end Id to Portal Page Section Setting / Section Field Setting CMD Data
     * @param zoneRecordTypeNameToMetadataMap   Map of Zone Record Type to Portal Membership Setting CMD Map
     *
     * @return                                  Map of Zone Record Type to Zone Membership Records To Upsert
     */
    private Map<String, List<ucinn_portal_Zone_Membership__c>> getZoneMembershipsToUpsertByRecordType(List<Object> zoneMembershipsToJoinList,
                                                                                                      String contactIdString,
                                                                                                      Map<String, Object> backEndDataMap,
                                                                                                      Map<String, Portal_Membership_Setting__mdt> zoneRecordTypeNameToMetadataMap) {
        Map<String, List<ucinn_portal_Zone_Membership__c>> returnMap = new Map<String, List<ucinn_portal_Zone_Membership__c>>();

        if (zoneMembershipsToJoinList == null || zoneMembershipsToJoinList.isEmpty() || String.isBlank(contactIdString)
            || backEndDataMap == null || backEndDataMap.isEmpty()
            || zoneRecordTypeNameToMetadataMap == null || zoneRecordTypeNameToMetadataMap.isEmpty()) {
                return returnMap;
        }

        List<Map<Object, Object>> zoneMembershipsToJoinWithIdsList = getMembershipDataMapsWithExistingIds(zoneMembershipsToJoinList, contactIdString);

        for (Map<Object, Object> eachZoneMembershipMap : zoneMembershipsToJoinWithIdsList) {
            String zoneRecordType = (String)eachZoneMembershipMap?.get(ZONE_RECORD_TYPE);
            Portal_Membership_Setting__mdt zoneMembershipSetting = zoneRecordTypeNameToMetadataMap.get(zoneRecordType);

            if (zoneMembershipSetting == null) {
                continue;
            }

            ucinn_portal_Zone_Membership__c newZoneMembership = createZoneMembershipRecord(eachZoneMembershipMap, backEndDataMap, contactIdString, zoneMembershipSetting);

            if (returnMap.get(zoneRecordType) == null) {
                returnMap.put(zoneRecordType, new List<ucinn_portal_Zone_Membership__c>{newZoneMembership});
            } else {
                List<ucinn_portal_Zone_Membership__c> zoneMembershipList = returnMap.get(zoneRecordType);
                zoneMembershipList.add(newZoneMembership);
            }
        }

        return returnMap;
    }

    /**
     * Get zone memberships that will need to be linked to a case.
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param zoneRecordTypeToZoneMembershipsToUpsertMap        Map of Zone Record Type to Zone Membership Records To Upsert
     * @param zoneRecordTypeNameToMetadataMap                   Map of Zone Record Type to Portal Membership Setting CMD
     *
     * @return                                                  List of zone memberships that will need to be linked to a case
     */
    @TestVisible
    private List<ucinn_portal_Zone_Membership__c> getZoneMembershipsForCaseCreation(Map<String, List<ucinn_portal_Zone_Membership__c>> zoneRecordTypeToZoneMembershipsToUpsertMap,
                                                                                    Map<String, Portal_Membership_Setting__mdt> zoneRecordTypeNameToMetadataMap,
                                                                                    String contactIdString) {
        List<ucinn_portal_Zone_Membership__c> returnList = new List<ucinn_portal_Zone_Membership__c>();

        if (zoneRecordTypeToZoneMembershipsToUpsertMap == null || zoneRecordTypeToZoneMembershipsToUpsertMap.isEmpty()
                || zoneRecordTypeNameToMetadataMap == null || zoneRecordTypeNameToMetadataMap.isEmpty() || String.isBlank(contactIdString)) {
            return returnList;
        }

        for (String eachRecordType : zoneRecordTypeToZoneMembershipsToUpsertMap.keySet()) {
            Portal_Membership_Setting__mdt zoneMembershipSetting = zoneRecordTypeNameToMetadataMap.get(eachRecordType);

            if (zoneMembershipSetting == null) {
                continue;
            }

            if (zoneMembershipSetting.Membership_Record_Insertion__c != CREATE_CASE
                    && isZoneMembershipInsertionCaseOverride(getContactInfo(contactIdString), zoneMembershipSetting.Constituent_Types_For_Case_Approval__c) != true) {
                continue;
            }

            returnList.addAll(zoneRecordTypeToZoneMembershipsToUpsertMap.get(eachRecordType));
        }

        return returnList;
    }

    /**
     * Gets all existing zone memberships on the constituent and creates a mapping from zone membership id to zone membership.
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param contactIdString   Current user's contact Id String
     * @return                  Map of zone membership id to zone membership
     */
    private virtual Map<String, ucinn_portal_Zone_Membership__c> getExistingZoneIdToZoneMembershipMap(String contactIdString) {
        Map<String, ucinn_portal_Zone_Membership__c> returnMap = new Map<String, ucinn_portal_Zone_Membership__c>();

        if (String.isBlank(contactIdString)) {
            return returnMap;
        }

        List<ucinn_portal_Zone_Membership__c> zoneMembershipList = [SELECT Id, Status__c, Zone__c FROM ucinn_portal_Zone_Membership__c
                                                                    WHERE Constituent__c =: contactIdString];

        if (zoneMembershipList == null || zoneMembershipList.isEmpty()) {
            return returnMap;
        }

        for (ucinn_portal_Zone_Membership__c eachZoneMembership : zoneMembershipList) {
            returnMap.put(eachZoneMembership.Zone__c, eachZoneMembership);
        }

        return returnMap;
    }

    /**
     * Determines if newsletter field is editable according to constituents service indicators
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param zoneMembershipSetting             Current zone membership setting for zone membership's record type
     * @param contactInfoMap                    Contact info map containing service indicator information
     * @param doNotContactValuesForRecordType   String of values to check if newsletter field should be changed.
     *
     * @return                                  Boolean value determining if the newsletter field is editable according to custom metadata
     */
    private virtual Boolean isNewsletterFieldEditible(Portal_Membership_Setting__mdt zoneMembershipSetting,
                                                      Map<String, Object> contactInfoMap,
                                                      String doNotContactValuesForRecordType) {
        if (zoneMembershipSetting == null || contactInfoMap == null || contactInfoMap.isEmpty()) {
            return false;
        }

        List<String> doNotContactValuesList = new List<String>();

        // check if constituent matches one of the prevent newsletter service indicator values
        if (String.isNotBlank(doNotContactValuesForRecordType)) {
            doNotContactValuesList = getListOfValuesForCheckingIsOnNewsletter(doNotContactValuesForRecordType);
        }

        Set<String> constituentsActiveServiceIndiatorValues = (Set<String>)contactInfoMap.get(ACTIVE_SERVICE_INDICATOR_VALUES);
        constituentsActiveServiceIndiatorValues.retainAll(doNotContactValuesList);

        return constituentsActiveServiceIndiatorValues.isEmpty();
    }

   /**
    * Determines if the zone memberships should go to case regardless of what settings is in the custom metadata
    *
    * @author   Phillip Nguyen
    * @since    1.0
    *
    * @param    contactInfoMap                                  Map of contact info containing service indicator values and contact type
    * @param    caseInsertionConstituentTypesForRecordType      list of constituent types to check for case insertion
    * @return                                                   Boolean value determining if zone memberships should be sent though the case process.
    *
    */
    @TestVisible
    private virtual Boolean isZoneMembershipInsertionCaseOverride(Map<String, Object> contactInfoMap, String caseInsertionConstituentTypesForRecordType) {
        if (String.isBlank(caseInsertionConstituentTypesForRecordType) || contactInfoMap == null || contactInfoMap.isEmpty()) {
            return false;
        }

        List<String> caseInsertionConstituentValues = caseInsertionConstituentTypesForRecordType.split(',');
        Set<String> constituentTypes = (Set<String>)contactInfoMap.get(CONSTITUENT_TYPES);
        constituentTypes.retainAll(caseInsertionConstituentValues);

        return !constituentTypes.isEmpty();
    }

    /**
     * Converts front end zone membership record information to zone membership
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param zoneMembershipMap zone membership record front end converted into a Map
     * @param backEndDataMap    back end data map for portal page section setting to convert get correct field api names for front end field Ids
     *
     * @return                  Zone membership record
     */
    private virtual ucinn_portal_Zone_Membership__c createZoneMembershipRecord(Map<Object, Object> zoneMembershipMap, Map<String, Object> backEndDataMap,
                                                                               String contactIdString, Portal_Membership_Setting__mdt zoneMembershipSetting) {
        ucinn_portal_Zone_Membership__c newZoneMembership = new ucinn_portal_Zone_Membership__c();

        if (zoneMembershipMap == null || zoneMembershipMap.isEmpty() || backEndDataMap == null || backEndDataMap.isEmpty()
                || zoneMembershipSetting == null || String.isBlank(contactIdString)) {
            return null;
        }

        Map<String, Object> contactInfoMap = getContactInfo(contactIdString);

        for (Object eachZoneMembershipFieldId : zoneMembershipMap.keySet()) {
            String eachZoneMemFieldId = (String)eachZoneMembershipFieldId;

            if (String.isBlank(eachZoneMemFieldId)) {
                continue;
            }

            Map<String, Object> fieldIdToDataMap = (Map<String, Object>)backEndDataMap.get(eachZoneMemFieldId);

            if (fieldIdToDataMap == null || fieldIdToDataMap.isEmpty()) {
                continue;
            }

            String fieldApiName = (String)fieldIdToDataMap.get(FIELD_API_NAME);

            if (fieldApiName.contains('.')) {
                List<String> fields = fieldApiName.split('\\.');
                fieldApiName = fields[1];
            }

            if (String.isBlank(fieldApiName) || fieldApiName.contains('.') || (fieldApiName == ZONE_LOOKUP_API_NAME && zoneMembershipMap.get(ID_CONST) != null)) {
                continue;
            }

            newZoneMembership.put(fieldApiName, zoneMembershipMap.get(eachZoneMemFieldId));
        }

        newZoneMembership.Constituent__c = contactIdString;
        newZoneMembership.Status__c = getZoneMembershipStatus(zoneMembershipSetting, contactInfoMap);

        if (isNewsletterFieldEditible(zoneMembershipSetting, contactInfoMap, zoneMembershipSetting.Values_For_Checking_Is_On_Newsletter__c) != true) {
            newZoneMembership.Is_On_Newsletter__c = false;  // Default value is true
        }

        return newZoneMembership;
    }

    /**
     * Get Zone Membership Status, which can be either Active or Pending
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param zoneMembershipSetting     Portal Membership setting for zone membership's record type
     * @param contactInfoMap            Map of contact information, containing contact types and active service indicators
     *
     * @return                          Return status of zone membership
     */
    @TestVisible
    protected virtual String getZoneMembershipStatus(Portal_Membership_Setting__mdt zoneMembershipSetting, Map<String, Object> contactInfoMap) {
        if (zoneMembershipSetting == null || contactInfoMap == null || contactInfoMap.isEmpty()) {
            System.debug('getZoneMembershipStatus params are null');
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_SAVE_GENERIC});
        }

        if (zoneMembershipSetting.Membership_Record_Insertion__c == CREATE_CASE
                || isZoneMembershipInsertionCaseOverride(contactInfoMap, zoneMembershipSetting.Constituent_Types_For_Case_Approval__c) == true) {
            return PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_PENDING;
        } else {
            return PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_ACTIVE;
        }
    }

    /**
     * Logic to create case for zone membership insert
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param contactIdString                   Current user contact id string
     * @return                                  Case Id
     */
    @TestVisible
    private virtual String handleCaseCreation(String contactIdString) {
        if (String.isBlank(contactIdString)) {
            return '';
        }

        // create case and link to all zone memberships in that list
        List<Group> zoneMembershipCaseQueueList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name='Zone Membership Case Queue' LIMIT 1];

        // TODO: remove hardcoded strings
        Case newCase = new Case (Subject ='Zone memberships awaiting approval to join',
                                 Status ='New',
                                 Origin = 'Web',
                                 Type ='Zone Membership',
                                 Description = 'All related zone memberships are waiting approval.',
                                 ContactId = contactIdString);

        if (zoneMembershipCaseQueueList != null && !zoneMembershipCaseQueueList.isEmpty()) {
            newCase.OwnerId = zoneMembershipCaseQueueList.get(0).Id;
        }

        insert newCase;
        return newCase.Id;
    }

    /**
     * Get zone record type to portal membership setting CMT map
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @return  Map of zone record type to portal membership setting CMT
     */
    private Map<String, Portal_Membership_Setting__mdt> getZoneRecordTypeNameToCMTMap() {
        Map<String, Portal_Membership_Setting__mdt> zoneRecordTypeNameToMetadataMap = new Map<String, Portal_Membership_Setting__mdt>();

        List<Portal_Membership_Setting__mdt> portalMembershipSettingCMTList = getPortalMembershipSetting();

        if (portalMembershipSettingCMTList == null || portalMembershipSettingCMTList.isEmpty()) {
            return zoneRecordTypeNameToMetadataMap;
        }

        for (Portal_Membership_Setting__mdt eachZoneMembershipSetting : portalMembershipSettingCMTList) {
            zoneRecordTypeNameToMetadataMap.put(eachZoneMembershipSetting.Record_Type__c, eachZoneMembershipSetting);
        }

        return zoneRecordTypeNameToMetadataMap;
    }


    /**
     * Query for portal membership custom setting information
     *
     * @author  Phillip Nguyen
     * @since   1.0
     * @return  List of portal membership settings custom metadata records.
     */
    protected virtual List<Portal_Membership_Setting__mdt> getPortalMembershipSetting() {
        List<Portal_Membership_Setting__mdt> returnList = (List<Portal_Membership_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Constituent_types_to_add_to_zones__c', 'Constituent_types_to_exclude_to_zones__c',
                                                      'Membership_record_insertion__c', 'Record_Type__c', 'Constituent_types_for_case_approval__c',
                                                      'Values_for_checking_is_on_newsletter__c', 'Zone_display_types__c', 'Prevent_is_on_newsletter_helper_text__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Membership_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Clubs', 'Groups'}
        });

        return returnList;
    }

    /**
     * Get contact and service indicator information on a given constituent
     *
     * @author  Phillip Nguyen
     * @since   1.0
     * @param   contactId                                       Id of contact to search
     * @return                                                  Returned constituent information and active service indicators
     */
    protected virtual Map<String, Object> getContactInfo(String contactId) {
        Map<String, Object> contactInfoMap = new Map<String, Object>();

        List<Contact> contactInfoList = [SELECT Id,    ucinn_ascendv2__Contact_Type__c,
                                            (SELECT Id, ucinn_ascendv2__Code_Formula__c
                                            FROM ucinn_ascendv2__Service_Indicators_Contact__r
                                            WHERE ucinn_ascendv2__Is_Active__c = true AND ucinn_ascendv2__Code_Formula__c != null)
                                        FROM Contact WHERE Id = :contactId];

        if (contactInfoList == null || contactInfoList.isEmpty()) {
            return contactInfoMap;
        }

        Set<String> activeServiceIndicatorValues = new Set<String>();

        for (ucinn_ascendv2__Service_Indicator__c currentServiceIndicator : contactInfoList[0].ucinn_ascendv2__Service_Indicators_Contact__r) {
            activeServiceIndicatorValues.add(currentServiceIndicator.ucinn_ascendv2__Code_Formula__c);
        }

        contactInfoMap.put(ACTIVE_SERVICE_INDICATOR_VALUES, activeServiceIndicatorValues);

        if (String.isNotBlank(contactInfoList[0].ucinn_ascendv2__Contact_Type__c)) {
            Set<String> activeConstituentTypes = new Set<String>();
            activeConstituentTypes.addAll(contactInfoList[0].ucinn_ascendv2__Contact_Type__c.split(';'));
            contactInfoMap.put(CONSTITUENT_TYPES, activeConstituentTypes);
        }

        return contactInfoMap;
    }
}