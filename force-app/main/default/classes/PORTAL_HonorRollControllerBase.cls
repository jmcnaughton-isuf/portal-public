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
 * Base controller for Honor Roll
 *
 * @author      Phillip Nguyen
 * @since       1.0
 */
public inherited sharing virtual class PORTAL_HonorRollControllerBase {
    public static final String CONTACT_FIELD = 'Contact__c';
    public static final String ACTIVE_KEY = 'Active';
    public static final String HONOR_ROLL_NAME = 'Honor Roll Name';
    public static final String HONOR_ROLL_NAME_KEY = 'honorRollName';
    public static final String CONTACT_ID_KEY = 'contactId';
    public static final String JOINT_CONTACT_ID_KEY = 'jointContactId';
    public static final String HAS_PENDING_NAME_CHANGE = 'hasPendingNameChange';
    public static final Boolean TRUE_BOOLEAN = true;

    public static final String PICKLIST_DEFAULT = '- Any -';
    public static final String FISCAL_YEARS = 'fiscalYears';
    public static final String GIVING_SOCIETIES = 'givingSocieties';
    public static final String CLASS_YEARS = 'classYears';
    public static final String OLDEST_CLASS_YEAR = 'oldestClassYear';
    public static final String ACADEMIC_ORGANIZATIONS = 'academicOrganizations';
    public static final String NEW_CONST = 'New';
    public static final String ESCALATED_CONST = 'Escalated';
    public static final String ON_HOLD = 'On Hold';
    public static final String RESUBMITTED_CONST = 'Resubmitted';

    public static final String NAME_SEARCH_STRING = 'nameSearchString';
    public static final String GIVING_SOCIETY = 'givingSociety';
    public static final String CLASS_YEAR = 'classYear';
    public static final String FISCAL_YEAR = 'fiscalYear';
    public static final String FISCAL_YEAR_START_DATE = 'fiscalYearStartDate';
    public static final String FISCAL_YEAR_END_DATE = 'fiscalYearEndDate';
    public static final String ACADEMIC_ORGANIZATION = 'academicOrganization';
    public static final String OFFSET_KEY = 'offset';

    public static final String MEMBERSHIP_LEVEL = 'membershipLevel';

    public static final String SOCIETY_MEMBERSHIP_ID = 'societyMembershipId';
    public static final String DISPLAY_ON_HONOR_ROLL_VALUE = 'displayOnHonorRollValue';
    public static final String HONOR_ROLL_OPT_OUT = 'honorRollOptOut';
    public static final String HONOR_ROLL_JOINT_PREFERENCE = 'honorRollJointPreference';

    public static final String HONOR_ROLL_NAME_UPDATE_TEXT = 'Honor Roll Name:';
    public static final String HONOR_ROLL_JOINT_PREFERENCE_UPDATE_TEXT = 'Honor Roll Joint Preference:';

    public static final String CASE_ORIGIN_WEB = 'Web';
    public static final String CASE_SUBJECT = 'Honor Roll Update';
    public static final String MEMBERSHIPS_TO_UPDATE = 'membershipsToUpdate';
    public static final String QUERY_LIMIT = 'queryLimit';

    public static final Integer NUMBER_OF_PREVIOUS_FISCAL_YEARS = 5;
    public static final Integer DEFAULT_OLDEST_CLASS_YEAR = 1999;
    public static final Integer QUERY_LIMIT_VALUE = 200;

    public static final String DATE_FORMAT = 'yyyy-MM-dd';
    public static final String ANNUAL_STRING = 'Annual';
    public static final String LIFETIME_STRING = 'Lifetime';

    public static final String ERROR_GENERAL_MESSAGE = 'There was an issue getting your information. Please contact an administrator.';

    public static final String IS_JOINT_PREFERENCE_AVAILABLE = 'isJointPreferenceAvailable';

    /**
     * Creates mapping for Honor Roll Name records to pass back to front end
     *
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param fiscalYear                Specific fiscal year selected to query for
     * @param nameSearchString          String of name to search for
     * @param givingSociety             Specific giving society selected to query for
     * @param classYear                 Specific class year selected to query for
     * @param academicOrganization      Specific academic organization to query for
     * @param offset                    Offset value to use for offset pagination
     *
     * @return                          Returns List of Honor Roll Name record mapped information
     */
    public virtual List<Map<String, Object>> getHonorRollNames(Map<String, Object> params) {
        List<Map<String, Object>> honorRollNameRecordInformationList = new List<Map<String, Object>>();

        String honorRollNameQueryString = createHonorRollNameDynamicQueryString(params);
        List<ucinn_portal_Honor_Roll_Name__c> honorRollNameRecords = Database.query(honorRollNameQueryString);

        if (honorRollNameRecords == null || honorRollNameRecords.isEmpty()) {
            return honorRollNameRecordInformationList;
        }

        for (ucinn_portal_Honor_Roll_Name__c eachHonorRollName : honorRollNameRecords) {
            Map<String, Object> honorRollNameRecordInformation = new Map<String, Object>();

            honorRollNameRecordInformation.put(HONOR_ROLL_NAME_KEY, eachHonorRollName.Honor_Roll_Name__c);
            honorRollNameRecordInformation.put(CONTACT_ID_KEY, eachHonorRollName.Contact__c);
            honorRollNameRecordInformation.put(JOINT_CONTACT_ID_KEY, eachHonorRollName.Joint_Contact__c);

            honorRollNameRecordInformationList.add(honorRollNameRecordInformation);
        }

        return honorRollNameRecordInformationList;
    }

    /**
     * Acquires all information to populate picklists in honor roll filter section
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param oldestClassYear           Years to display under Class Year Picklist
     * @return                          A map containing lists for fiscal years, giving societies, class years
     */
    public virtual Map<String, Object> getHonorRollFilterInformation(Map<String, Object> params) {
        Map<String, Object> honorRollInformation = new Map<String, Object>();

        Integer oldestClassYear = DEFAULT_OLDEST_CLASS_YEAR;

        if (params != null && !params.isEmpty() && params.containsKey(OLDEST_CLASS_YEAR)) {
            oldestClassYear = Integer.valueOf(params.get(OLDEST_CLASS_YEAR));
        }

        List<String> previousFiscalYearList = getPreviousFiscalYears();
        List<String> givingSocietyList = getGivingSocieties();
        List<String> classYearList = getClassYearList(oldestClassYear);
        List<String> academicOrgList = getAcademicOrganizations();

        honorRollInformation.put(FISCAL_YEARS, previousFiscalYearList);
        honorRollInformation.put(GIVING_SOCIETIES, givingSocietyList);
        honorRollInformation.put(CLASS_YEARS, classYearList);
        honorRollInformation.put(ACADEMIC_ORGANIZATIONS, academicOrgList);

        return honorRollInformation;
    }

    /**
     * Gets honor roll name details to display when honor roll name is clicked on
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param contactId                 The contact ID linked to honor roll name
     * @param fiscalYear                The contact's honor roll information in this specific year
     *
     * @return                          A list of honor roll detail maps which contains giving society and membership information
     */
    public virtual List<Map<String, Object>> getHonorRollNameDetails(Map<String, Object> params) {
        List<Map<String, Object>> resultMap = new List<Map<String, Object>>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String contactId = (String) params.get(CONTACT_ID_KEY);
        String jointContactId = (String) params.get(JOINT_CONTACT_ID_KEY);
        String honorRollFiscalYear = (String) params.get(FISCAL_YEAR);

        if (String.isBlank(contactId) || String.isBlank(honorRollFiscalYear)) {
            return resultMap;
        }

        List<String> idList = new List<String>();
        idList.add(contactId);

        if (String.isNotBlank(jointContactId)) {
            idList.add(jointContactId);
        }

        Map<String,Object> fiscalYearDateMap = createFiscalYearStartAndEndDateMap(honorRollFiscalYear);

        if (fiscalYearDateMap == null || fiscalYearDateMap.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        Date fiscalYearStartDate = (Date) fiscalYearDateMap.get(FISCAL_YEAR_START_DATE);
        Date fiscalYearEndDate = (Date) fiscalYearDateMap.get(FISCAL_YEAR_END_DATE);

        if (fiscalYearStartDate == null || fiscalYearEndDate == null) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        List<ucinn_ascendv2__Society_Membership__c> contactSocietyMembershipList = [SELECT ucinn_ascendv2__Giving_Society__r.Name,
                                                                                     ucinn_ascendv2__Membership_Level__r.Name
                                                                                    FROM ucinn_ascendv2__Society_Membership__c
                                                                                    WHERE ucinn_ascendv2__Contact__c IN :idList
                                                                                    AND ucinn_portal_Is_Show_on_Honor_Roll__c = true
                                                                                    AND ucinn_ascendv2__Giving_Society__r.ucinn_portal_Is_Display_On_Portal__c = true
                                                                                    AND ucinn_ascendv2__Member_Since__c <= :fiscalYearEndDate
                                                                                    AND (ucinn_ascendv2__Expiration_Date__c = null OR (ucinn_ascendv2__Expiration_Date__c >= :fiscalYearStartDate AND ucinn_ascendv2__Member_Since__c <= :fiscalYearEndDate))
                                                                                    ORDER BY ucinn_ascendv2__Membership_Level__r.ucinn_ascendv2__Order__c DESC NULLS LAST];

        if (contactSocietyMembershipList == null || contactSocietyMembershipList.isEmpty()) {
            return resultMap;
        }

        Set<String> givingSocietySet = new Set<String>();

        for (ucinn_ascendv2__Society_Membership__c eachMembership : contactSocietyMembershipList) {
            if (givingSocietySet.contains(eachMembership.ucinn_ascendv2__Giving_Society__r.Name)) {
                continue;
            }

            givingSocietySet.add(eachMembership.ucinn_ascendv2__Giving_Society__r.Name);

            Map<String, Object> membershipMapping = new Map<String, Object>();
            membershipMapping.put(GIVING_SOCIETY, eachMembership.ucinn_ascendv2__Giving_Society__r.Name);
            membershipMapping.put(MEMBERSHIP_LEVEL, eachMembership.ucinn_ascendv2__Membership_Level__r.Name);

            resultMap.add(membershipMapping);
        }

        return resultMap;
    }

    /**
     * get information that user may modify regarding honor roll
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @return          contact's honor roll opt out value; honor roll joint preference; most recent honor roll;
     *                  has pending honor roll update cases
     * @return          isJointPreferenceAvailable: boolean for whether or not the joint preference
     *                  should be available based on if there is preferred spouse info on contact
     */
    public virtual Map<String,Object> getHonorRollManagementInformation(){
        Map<String, Object> returnMap = new Map<String, Object>();

        Id contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (contactId == null) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        Set<Id> contactIdSet = new Set<Id>{contactId};
        List<Contact> contactList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => contactIdSet});

        if (contactList == null || contactList.isEmpty()) {
            return returnMap;
        }

        Contact loggedInContact = contactList.get(0);

        // grab first honor roll because it is the most recent
        if (loggedInContact.ucinn_portal_Honor_Roll_Names_Contact__r != null && !loggedInContact.ucinn_portal_Honor_Roll_Names_Contact__r.isEmpty()) {
            returnMap.put(HONOR_ROLL_NAME_KEY, loggedInContact.ucinn_portal_Honor_Roll_Names_Contact__r.get(0)?.Honor_Roll_Name__c);
        } else if (loggedInContact.ucinn_portal_Honor_Roll_Names_Joint__r != null && !loggedInContact.ucinn_portal_Honor_Roll_Names_Joint__r.isEmpty()){
            returnMap.put(HONOR_ROLL_NAME_KEY, loggedInContact.ucinn_portal_Honor_Roll_Names_Joint__r.get(0)?.Honor_Roll_Name__c);
        } else {
            returnMap.put(HONOR_ROLL_NAME_KEY, '');
        }

        returnMap.put(HONOR_ROLL_JOINT_PREFERENCE, loggedInContact.ucinn_portal_Honor_Roll_Joint_Preference__c);
        returnMap.put(HONOR_ROLL_OPT_OUT, loggedInContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c);
        returnMap.put(HAS_PENDING_NAME_CHANGE, hasPendingNameChange(contactId));
        returnMap.put(IS_JOINT_PREFERENCE_AVAILABLE, loggedInContact.ucinn_ascendv2__Preferred_Spouse__c != null);

        return returnMap;
    }

    /**
     * Submit changes to honor including global opt out, honor roll name change, and
     * honor roll joint preference change
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param honorRollOptOut                                   New value for global honor roll opt out
     * @param honorRollNameUpdateString                         New honor roll name to display for current honor roll record
     * @param honorRollJointPreferenceUpdateString              New Honor Roll joint preference value
     * @param membershipIdToBooleanMap                          Mapping of society membership Ids to Boolean values
     *
     */
    public virtual void submitHonorRollChanges(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            return;
        }

        Id contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).contactId;

        if (contactId == null) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        Boolean globalHonorRollOptOut = (Boolean) params.get(HONOR_ROLL_OPT_OUT);
        String honorRollNameUpdateString = (String) params.get(HONOR_ROLL_NAME_KEY);
        String honorRollJointPreferenceUpdateString = (String) params.get(HONOR_ROLL_JOINT_PREFERENCE);

        // Id => (Checked Value)
        Map<Object,Object> membershipIdToBooleanMap = (Map<Object,Object>) params.get(MEMBERSHIPS_TO_UPDATE);

        upsertIsDisplayHonorRollOnSocietyMemberships(contactId, membershipIdToBooleanMap);

        createCaseForHonorRollUpdate(contactId, honorRollNameUpdateString, honorRollJointPreferenceUpdateString);

        PORTAL_UTIL_HonorRoll.updateContactGlobalHonorRollOptOut(new Map<String, Object>{PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => globalHonorRollOptOut,
                                                                                         PORTAL_UTIL_HonorRoll.CONTACT_ID => contactId});
    }

    /**
     * Returns whether the given constituent has any pending Honor Roll Update Cases that change their
     * honor roll name. 
     * 
     * @author          Curtis Ung
     * @since           1.0
     * 
     * @param contactId ID of the constituent to query cases for
     * @return          boolean: true if exists an honor roll update case for this contact, else false.
     */
    protected virtual Boolean hasPendingNameChange(Id contactId){
        // Query for honor roll update cases
        List<Case> caseList = [SELECT Id, Status, Contact.Name, Description
                            FROM Case 
                            WHERE Status IN (:NEW_CONST, :ESCALATED_CONST, :ON_HOLD, :RESUBMITTED_CONST)
                                AND Subject = :CASE_SUBJECT 
                                AND Contact.Id = :contactId];
        
        // Check if those cases update the Honor Roll Name itself 
        for (Case eachCase : caseList) {
            List<String> caseDescription = eachCase.Description.split('\n');
            for (String eachDescriptionLine : caseDescription) {
                if (eachDescriptionLine.startsWith(HONOR_ROLL_NAME)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * Queries for honor roll name objects based on parameters below.
     * Also supports offset pagination
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param fiscalYear                Specific fiscal year selected to query for
     * @param nameSearchString          String of name to search for
     * @param givingSociety             Specific giving society selected to query for
     * @param classYear                 Specific class year selected to query for
     * @param academicOrganization      Specific academic organization to query for
     * @param queryLimit                Limit number of records that are queried
     * @param offset                    Offset value to use for offset pagination
     *
     * @return                          Returns query string for honor roll names
     */
    private String createHonorRollNameDynamicQueryString(Map<String, Object> params) {
        Integer offsetValue = 0;
        Integer queryLimit = QUERY_LIMIT_VALUE;

        String queryString = 'SELECT Id, Honor_Roll_Name__c, Contact__c, Joint_Contact__c FROM ucinn_portal_Honor_Roll_Name__c ';
        String whereClause = '';
        String whereClausePrefix = ' WHERE ';

        String societyMembershipQueryString = createSocietyMembershipQueryString(params);

        if (String.isNotBlank(societyMembershipQueryString)) {
            whereClause = whereClause + whereClausePrefix + ' Contact__c IN (' + societyMembershipQueryString + ') ';
            whereClausePrefix = ' AND ';
        }

        String fiscalYearQueryString = createFiscalYearQueryString(params);

        if (String.isNotBlank(fiscalYearQueryString)) {
            whereClause = whereClause + whereClausePrefix + ' ( ' + fiscalYearQueryString + ') ';
        }

        whereClause = whereClause + createDegreeInformationQueryString(params);
        whereClause = whereClause + createNameSearchQueryString(params);

        if (params != null && params.containsKey(OFFSET_KEY)) {
            offsetValue = Integer.valueOf(params.get(OFFSET_KEY));
        }

        if (params != null && params.containsKey(QUERY_LIMIT)) {
            queryLimit = Integer.valueOf(params.get(QUERY_LIMIT));
        }

        String orderByClause = ' ORDER BY Honor_Roll_Name__c ASC ';

        queryString = queryString + whereClause + orderByClause + ' LIMIT ' + queryLimit + ' OFFSET ' + offsetValue;

        return queryString;
    }

    /**
     * Creates query string for society memberships and a specific giving society name
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     * @param givingSociety     Name of giving society to query for
     *
     * @return                  Query string for society membership and optionally, a giving society name
     */
    private String createSocietyMembershipQueryString(Map<String, Object> params) {
        // guaranteed to return something
        String resultString = ' SELECT ucinn_ascendv2__Contact__c FROM ucinn_ascendv2__Society_Membership__c '
                                + 'WHERE ucinn_portal_Is_Show_on_Honor_Roll__c = true '
                                + 'AND ucinn_ascendv2__Giving_Society__r.ucinn_portal_Is_Display_On_Portal__c = true ';

        if (params == null || params.isEmpty() || (String.isBlank((String) params.get(GIVING_SOCIETY)) && String.isBlank((String) params.get(FISCAL_YEAR)))) {
            return resultString;
        }

        String fiscalYearString = (String)params.get(FISCAL_YEAR);

        Map<String,Object> fiscalYearDateMap = createFiscalYearStartAndEndDateMap(fiscalYearString);

        if (String.isNotBlank(fiscalYearString) && fiscalYearDateMap != null && !fiscalYearDateMap.isEmpty()) {
            Date fiscalYearStartDate = (Date) fiscalYearDateMap.get(FISCAL_YEAR_START_DATE);
            Date fiscalYearEndDate = (Date) fiscalYearDateMap.get(FISCAL_YEAR_END_DATE);

            String fiscalYearStartDateString = DateTime.newInstance(fiscalYearStartDate.year(), fiscalYearStartDate.month(), fiscalYearStartDate.day()).format(DATE_FORMAT);
            String fiscalYearEndDateString = DateTime.newInstance(fiscalYearEndDate.year(), fiscalYearEndDate.month(), fiscalYearEndDate.day()).format(DATE_FORMAT);

            if (fiscalYearStartDate != null && fiscalYearEndDate != null) {
                resultString = resultString + ' AND ( '
                                                        + ' (ucinn_ascendv2__Member_Since__c <= ' + fiscalYearEndDateString
                                                        + ' AND (ucinn_ascendv2__Expiration_Date__c = null OR '
                                                            + ' ( '
                                                                + ' ucinn_ascendv2__Expiration_Date__c >= ' + fiscalYearStartDateString + ' AND '
                                                                + ' ucinn_ascendv2__Member_Since__c <= ' + fiscalYearEndDateString
                                                            + ' )) ) '
                                                    + ' ) ';
            }
        }

        String givingSocietyString = (String) params.get(GIVING_SOCIETY);

        if (String.isNotBlank(givingSocietyString)) {
            resultString = resultString + ' AND ucinn_ascendv2__Giving_Society__r.Name = \'' + String.escapeSingleQuotes(givingSocietyString) + '\' ';
        }

        return resultString;
    }

    /**
     * Creates query string for honor rolls in a specific fiscal year
     *
     * @author              Phillip Nguyen
     * @since               1.0
     * @param fiscalYear    Fiscal Year to find Honor Roll Name Records in
     *
     * @return              Query string for honor rolls in a specific fiscal year
     */
    private String createFiscalYearQueryString(Map<String, Object> params) {
        String resultString = '';

        if (params == null || params.isEmpty()) {
            return resultString;
        }

        // query for fiscal year
        String fiscalYearString = (String)params.get(FISCAL_YEAR);

        if (String.isNotBlank(fiscalYearString)) {
            resultString = resultString + ' Starting_Fiscal_Year__c <= \'' + fiscalYearString + '\' '
                                            + ' AND (Ending_Fiscal_Year__c = null OR Ending_Fiscal_Year__c >= \'' + fiscalYearString + '\') ';
        }

        return resultString;
    }

    /**
     * Creates query string for class year and academic orgs
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     * @param classYear             Class year(conferred degree year) to find honor roll name records in
     * @param academicOrganization  Academic Organization to query on
     *
     * @return                      Query string for class year & academic org
     */
    private String createDegreeInformationQueryString(Map<String, Object> params) {
        String resultString = '';
        String classYearStringQuery = '';
        String academicOrganizationStringQuery = '';

        if (params == null || params.isEmpty()) {
            return resultString;
        }

        // query for specific class year
        String classYearString = (String) params.get(CLASS_YEAR);
        String academicOrganizationString = (String) params.get(ACADEMIC_ORGANIZATION);

        if (String.isBlank(classYearString) && String.isBlank(academicOrganizationString)) {
            return resultString;
        }

        if (String.isNotBlank(classYearString)) {
            classYearStringQuery = ' AND ucinn_ascendv2__Conferred_Degree_Year__c = \'' + String.escapeSingleQuotes(classYearString) + '\' ';
        }

        if (String.isNotBlank(academicOrganizationString)) {
            academicOrganizationStringQuery = ' AND ucinn_ascendv2__Post_Code__r.ucinn_ascendv2__School_1__r.Name = \'' + String.escapeSingleQuotes(academicOrganizationString) + '\' ';
        }

        if (String.isNotBlank(classYearString) || String.isNotBlank(academicOrganizationString)) {
            resultString = resultString + ' AND Contact__c IN (SELECT ucinn_ascendv2__Contact__c FROM ucinn_ascendv2__Degree_Information__c '
                                        + ' WHERE ucinn_portal_Is_Display_On_Portal__c = true '
                                        + classYearStringQuery
                                        + academicOrganizationStringQuery + ') ';
        }

        return resultString;
    }

    /**
     * Create query string for when searching for specific honor roll name
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     * @param nameSearchString      Honor roll name we are looking for
     *
     * @return                      Query String for honor roll name search
     */
    private String createNameSearchQueryString(Map<String, Object> params) {
        String resultString = '';

        if (params == null || params.isEmpty()) {
            return resultString;
        }

        // query for name
        String nameSearchString = (String) params.get(NAME_SEARCH_STRING);

        if (String.isNotBlank(nameSearchString)) {
            nameSearchString = '%' + String.escapeSingleQuotes(nameSearchString) + '%';
            resultString = resultString + ' AND Honor_Roll_Name__c LIKE \'' + nameSearchString + '\' ';
        }

        return resultString;
    }

    /**
     * Modify display on honor roll values for society memberships
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param           contactId                   Id of Contact
     * @param           membershipIdToBooleanMap    Society membership to update with new value inside map
     *
     */
    @TestVisible
    private void upsertIsDisplayHonorRollOnSocietyMemberships(Id contactId, Map<Object,Object> membershipIdToBooleanMap){
        if (membershipIdToBooleanMap == null || membershipIdToBooleanMap.isEmpty() || String.isBlank(contactId)) {
            return;
        }

        Set<Id> contactIdSet = new Set<Id>{contactId};
        Set<Id> membershipIdSet = new Set<Id>();

        for (Object eachSocietyMembershipId : membershipIdToBooleanMap.keySet()) {
            if (!(eachSocietyMembershipId instanceOf Id)) {
                continue;
            }

            membershipIdSet.add((Id) eachSocietyMembershipId);
        }

        List<ucinn_ascendv2__Society_Membership__c> societyMembershipList = PORTAL_UTIL_HonorRoll.queryForSocietyMembershipsWithAllFields(new Map<String, Object>{
                                                                                                    PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => contactIdSet,
                                                                                                    PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_ID_SET => membershipIdSet});

        if (societyMembershipList == null || societyMembershipList.isEmpty()) {
            return;
        }

        Date currentFiscalYearStartDate = PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.StartDate;

        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToUpsertList = new List<ucinn_ascendv2__Society_Membership__c>();

        for (ucinn_ascendv2__Society_Membership__c eachSocietyMembership : societyMembershipList) {
            Boolean optOutValue = ((Boolean) membershipIdToBooleanMap.get(eachSocietyMembership.Id) == true);

            List<ucinn_ascendv2__Society_Membership__c> parsedSocietyMembershipsToUpsertList = PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(new Map<String, Object>{
                                                                                                                        PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_RECORD => eachSocietyMembership,
                                                                                                                        PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => optOutValue,
                                                                                                                        PORTAL_UTIL_HonorRoll.CURRENT_FISCAL_YEAR_START_DATE => currentFiscalYearStartDate
                                                                                                                        });

            if (parsedSocietyMembershipsToUpsertList == null || parsedSocietyMembershipsToUpsertList.isEmpty()) {
                continue;
            }

            societyMembershipsToUpsertList.addAll(parsedSocietyMembershipsToUpsertList);
        }

        upsert societyMembershipsToUpsertList;
    }

    /**
     * Create case when user makes modification to their honor roll information
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param contactId                         Contact's Id
     * @param honorRollNameUpdate               New Honor Roll Name Field to display
     * @param honorRollJointPreferenceUpdate    New Honor Roll Joint Preference Value
     */
    @TestVisible
    private void createCaseForHonorRollUpdate(String contactId, String honorRollNameUpdate, String honorRollJointPreferenceUpdate) {
        if (String.isBlank(contactId) || (String.isBlank(honorRollNameUpdate) && String.isBlank(honorRollJointPreferenceUpdate))) {
            return;
        }

        String honorRollModificationCaseDescription = '';

        if (String.isNotBlank(honorRollNameUpdate)) {
            honorRollModificationCaseDescription = honorRollModificationCaseDescription + HONOR_ROLL_NAME_UPDATE_TEXT + '\'' + honorRollNameUpdate + '\'\n';
        }

        if (String.isNotBlank(honorRollJointPreferenceUpdate)) {
            honorRollModificationCaseDescription = honorRollModificationCaseDescription + HONOR_ROLL_JOINT_PREFERENCE_UPDATE_TEXT + '\'' + honorRollJointPreferenceUpdate + '\'';
        }

        if (String.isBlank(honorRollModificationCaseDescription)) {
            return;
        }

        Case honorRollUpdateCase = new Case(ContactId = contactId, Description = honorRollModificationCaseDescription, Origin = CASE_ORIGIN_WEB, Subject = CASE_SUBJECT);
        insert honorRollUpdateCase;
    }

    /**
     * Creates two start and end Date objects for fiscal year passed in
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param fiscalYearString        fiscal year to find start and end dates for
     *
     * @return                  Map containing start date and end date object for fiscal year
     */
    private Map<String,Object> createFiscalYearStartAndEndDateMap(String fiscalYearString) {
        Map<String,Object> fiscalYearDatesMap = new Map<String,Object>();

        if (String.isBlank(fiscalYearString)) {
            return fiscalYearDatesMap;
        }

        Period fiscalYearInformation = PORTAL_CommunityUtils.getCurrentFiscalYear(null);

        Date currentFiscalYearStartDate = fiscalYearInformation?.StartDate;
        Date currentFiscalYearEndDate = fiscalYearInformation?.EndDate;
        Integer fiscalYearOverlap = currentFiscalYearEndDate.year() - currentFiscalYearStartDate.year();

        if (currentFiscalYearStartDate != null && currentFiscalYearEndDate != null) {
            Integer fiscalYearNumber = Integer.valueOf(fiscalYearString);
            Date fiscalYearStartDate = Date.newInstance(fiscalYearNumber, currentFiscalYearStartDate.month(), currentFiscalYearStartDate.day());
            Date fiscalYearEndDate = Date.newInstance(fiscalYearNumber + fiscalYearOverlap, currentFiscalYearEndDate.month(), currentFiscalYearEndDate.day());

            fiscalYearDatesMap.put(FISCAL_YEAR_START_DATE, fiscalYearStartDate);
            fiscalYearDatesMap.put(FISCAL_YEAR_END_DATE, fiscalYearEndDate);
        }

        return fiscalYearDatesMap;
    }

    /**
     * Gets previous fiscal years
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @return          Return list of previous fiscal years
     */
    private List<String> getPreviousFiscalYears() {

        List<String> previousFiscalYears = new List<String>();

        String currentFiscalYear = PORTAL_CommunityUtils.getCurrentFiscalYear(null)?.FiscalYearSettings?.Name;

        if (String.isBlank(currentFiscalYear)) {
            return previousFiscalYears;
        }

        Integer currentFiscalYearNumber = Integer.valueOf(currentFiscalYear);

        for (Integer yearCount = 0; yearCount < NUMBER_OF_PREVIOUS_FISCAL_YEARS; yearCount++) {
            previousFiscalYears.add(String.valueOf(currentFiscalYearNumber));
            currentFiscalYearNumber = currentFiscalYearNumber - 1;
        }

        return previousFiscalYears;
    }

    /**
     * Gets all giving societies to display on honor roll page
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @return          List of giving society names that are can be displayed on honor roll
     */
    private List<String> getGivingSocieties() {
        List<String> givingSocietyNamesList = new List<String>();

        List<ucinn_ascendv2__Giving_Society__c> givingSocietiesList = [SELECT Name FROM ucinn_ascendv2__Giving_Society__c
                                                                    WHERE ucinn_ascendv2__Status__c = :ACTIVE_KEY
                                                                    AND ucinn_portal_Is_Display_On_Portal__c = :TRUE_BOOLEAN
                                                                    ORDER BY Name ASC];

        if (givingSocietiesList.isEmpty()) {
            return givingSocietyNamesList;
        }

        for (ucinn_ascendv2__Giving_Society__c eachGivingSociety : givingSocietiesList) {
            givingSocietyNamesList.add(eachGivingSociety.Name);
        }

        return givingSocietyNamesList;
    }

    /**
     * Gets class year picklist values
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param amountOfYears     amount of years to display on the picklist
     * @return                  List of class years ranges from current year to years before current
     */
    private List<String> getClassYearList(Integer oldestClassYear) {
        List<String> classYearList = new List<String>();

        if (oldestClassYear == null) {
            return classYearList;
        }

        Integer currentYear = System.Today().year();

        for (Integer yearCounter = currentYear; yearCounter >= oldestClassYear; yearCounter--) {
            classYearList.add(String.valueOf(yearCounter));
        }

        return classYearList;
    }

    /**
     * Get academic organizations to be displayed on honor roll academic org picklist
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @return                  List of academic organizations ordered alphabetically
     */
    private List<String> getAcademicOrganizations() {
        List<String> academicOrganizationNameList = new List<String>();

        List<ucinn_ascendv2__Academic_Organization__c> academicOrganizations = [SELECT Name FROM ucinn_ascendv2__Academic_Organization__c WHERE ucinn_portal_Is_Display_On_Portal__c = true
                                                                                AND (ucinn_ascendv2__Effective_Date__c = null OR ucinn_ascendv2__Effective_Date__c <= :System.today())
                                                                                ORDER BY Name ASC];

        if (academicOrganizations == null || academicOrganizations.isEmpty()) {
            return academicOrganizationNameList;
        }

        for (ucinn_ascendv2__Academic_Organization__c eachAcademicOrg : academicOrganizations) {
            academicOrganizationNameList.add(eachAcademicOrg.Name);
        }

        return academicOrganizationNameList;
    }
}