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
 * Base Controller for Volunteers
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */
public inherited sharing class PORTAL_VolunteerControllerBase {
    public static final String PAGE_NAME = 'pageName';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String SUB_SECTION_NAME = 'subSectionName';
    public static final String FRONT_END_DATA_MAP = 'frontEndDataMap';
    public static final String VOLUNTEER_SHIFT_ID = 'volunteerShiftId';
    public static final String VOLUNTEER_ID = 'volunteerId';
    public static final String INTERIM_ID = 'interimId';
    public static final String VOLUNTEER_BIO_INFO_MAP = 'volunteerBioInfoMap';
    public static final String VOLUNTEER_JOB_LIST = 'volunteerJobList';
    public static final String STAGING_RECORD_FIELD_NAME = 'stagingRecordFieldName';
    public static final String SEARCH_STRING = 'searchString';
    public static final String PENDING_STATUS = 'Pending';
    public static final String CANCELLED_STATUS = 'Cancelled';
    public static final String IS_VOLUNTEER_CREATE_CASE_DEVELOPER_NAME = 'Is_Volunteer_Create_Case';
    public static final String IS_ALREADY_REGISTERED = 'isAlreadyRegistered';
    public static final String VOLUNTEER_REGISTERED_MESSAGE = 'Volunteer_Registered_Message';
    public static final String REGISTERED_MESSAGE = 'registeredMessage';
    public static final String FORM_DATA = 'formData';
    public static final String RECORD_ID = 'recordId';
    public static final String REGISTERED_SHIFTS = 'registeredShifts';
    public static final string HEADING_CONST = 'heading';
    public static final string HEADING_INFO = 'headingInfo';
    public static final String START_DATE_TIME = 'startDateTime';
    public static final String END_DATE_TIME = 'endDateTime';

    public static final String CASE_ORIGIN = 'Portal Volunteers';
    public static final String CASE_SUBJECT = 'A volunteer has signed up for a shift.';
    public static final String CASE_DESCRIPTION = 'A user has signed up for a volunter shift and needs review.';
    public static final String CASE_MODIFY_SUBJECT = 'A volunteer has modified their volunteer application.';
    public static final String CASE_MODIFY_DESCRIPTION = 'A user has modified their volunteer application and needs review.';
    public static final String CASE_NEW_STATUS = 'New';
    public static final String CASE_RESUBMITTED_STATUS = 'Resubmitted';

    public static final String CONTACT_CONST = 'contact';
    public static final String LABEL_CONST = 'label';
    public static final String VALUE_CONST = 'value';
    public static final String RECORDS_CONST = 'records';
    public static final String ID_CONST = 'id';

    public static final String LOCATION_KEY = 'location';
    public static final String CITY_KEY = 'city';
    public static final String STATE_KEY = 'state';
    public static final String POSTAL_CODE = 'postalCode';
    public static final String COUNTRY_KEY = 'country';
    public static final String RADIUS_KEY = 'radius';
    public static final String OFFSET_KEY = 'offset';
    public static final String SIGN_UP_TYPE = 'signUpType';
    public static final String GUEST_KEY = 'guest';
    public static final String MODIFY_KEY = 'modify';
    private static final String VOLUNTEER_SHIFTS = 'volunteerShifts';
    private static final String VOLUNTEER_SHIFT = 'volunteerShift';

    private static final String ERROR_MESSAGE_RETRIEVAL = 'There was an issue retrieving your information. Please contact an administrator';
    private static final String ERROR_MESSAGE_SUBMIT = 'There was an issue submitting your information. Please contact an administrator';
    private static final String ERROR_MESSAGE_EMPTY_PARAMS = 'Parameters are empty or null.';

    private static final String MERGE_FIELD_FIRST_NAME = 'FirstName';
    private static final String MERGE_FIELD_LAST_NAME = 'LastName';
    private static final String MERGE_FIELD_VOLUNTEER_JOB_NAME = 'VolunteerJobName';
    private static final String MERGE_FIELD_VOLUNTEER_SHIFT_NAME = 'VolunteerShiftName';
    private static final String MERGE_FIELD_VOLUNTEER_SHIFT_TIME = 'VolunteerShiftTime';
    private static final String MERGE_FIELD_REPORT_LINK = 'ReportLink';
    private static final String MERGE_FIELD_REPLACEMENT = 'mergeFieldToReplacementValue';
    private static final String MERGE_FIELD_ORIGINAL_TEXT = 'originalText';
    private static final String MERGE_FIELD_MODIFY_LINK = 'modifyLink';

    private static final String USER_ID = 'userId';
    private static final String SENDER_DISPLAY_NAME = 'senderDisplayName';
    private static final String EMAIL_SENDER_NAME = 'Portal Volunteer';
    private static final String SUPPORT_EMAIL = 'portalsendsupport@help.com';
    private static final String SUBJECT_KEY = 'subject';
    private static final String EMAIL_BODY = 'emailBody';

    private static final String EMAIL_TEMPLATE_DEVELOPER_NAME = 'developerName';
    private static final String VOLUNTEER_SHIFT_SIGN_UP_EMAIL_TEMPLATE = 'Portal_Volunteer_Shift_Sign_Up_Email';

    protected PORTAL_PageSectionAdapter pageSectionAdapter;

    /**
     * Factory method for PORTAL_FormGenerator
     *
     * @author Aaron Wong
     *
     * @return  An instance of PORTAL_FormGenerator.
     * @since   1.0
     */
    public virtual PORTAL_FormGenerator getFormGenerator() {
        return new PORTAL_PageSectionElementGenerator(this.pageSectionAdapter);
    }

    /**
     * Factory method for PORTAL_FormSubmitter
     *
     * @author Aaron Wong
     *
     * @return  An instance of PORTAL_FormSubmitter.
     * @since   1.0
     */
    public virtual PORTAL_FormSubmitter getFormSubmitter() {
        return new PORTAL_PageSectionFormSubmitter(this.pageSectionAdapter);
    }


    /**
     * Initializes the Volunteer Edit Form.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @return                      Map containing the front end data and information to prepopulate wiht.
     * @since                       1.0
     */
    public virtual PORTAL_FormWrapper initializeVolunteerEditForm(Map<String, Object> params){
        PORTAL_FormWrapper resultWrapper = new PORTAL_FormWrapper();

        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);
        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString) || String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            return resultWrapper;
        }

        pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .buildParentFieldId(contactIdString)
                                                                    .build();

        if (pageSectionAdapter == null) {
            return resultWrapper;
        }

        PORTAL_FormGenerator formGenerator = getFormGenerator();

        resultWrapper = formGenerator?.generateForm();

        return resultWrapper;
    }

    /**
     * Updates the volunteer information with the info provided.
     *
     * @author Aaron Wong
     *
     * @param formData              Map of formId to List of PORTAL_FormRecordWrappers (Map<String, List<PORTAL_FormRecordWrapper>>)
     * @since                       1.0
     */
    public virtual void updateVolunteerInformation(Map<String, Object> params) {
        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);

        pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .build();

        if (pageSectionAdapter == null) {
            return;
        }

        PORTAL_FormSubmitter formSubmitter = this.getFormSubmitter();

        Map<String, List<PORTAL_FormRecordWrapper>> formData = formSubmitter?.convertObjectToFormDataMap((Object)params?.get(FORM_DATA));

        formSubmitter?.submit(formData);
    }

    /**
     * Gets volunteer information for the logged in Constituent.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @return                      Map containing the front end layout and volunteer information.
     * @since                       1.0
     */
    public virtual Map<String, Object> getVolunteerInformation(Map<String, Object> params){
        Map<String, Object> resultMap = new Map<String, Object>();

        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);
        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString) || String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            return resultMap;
        }

        pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .buildParentFieldId(contactIdString)
                                                                    .build();

        if (pageSectionAdapter == null) {
            return resultMap;
        }

        resultMap.put(FRONT_END_DATA_MAP, pageSectionAdapter.getFrontEndDataMap());
        resultMap.put(RECORDS_CONST, pageSectionAdapter.getRecords().get(mainSectionName));

        return resultMap;
    }

    /**
     * Initializes the report hours form for a Volunteer record.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @param recordId              The record Id of the Volunteer Record.
     * @return                      Map containing the front end layout and volunteer information.
     * @since                       1.0
     */
    public virtual Map<String, Object> initializeReportHoursForm(Map<String, Object> params){
        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);
        String recordId = (String)params?.get(RECORD_ID);

        Map<String, Object> resultMap = new Map<String, Object>();

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(recordId)) {
            return resultMap;
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.dynamicWhereClause = ' WHERE Id = \'' + recordId + '\' ';

        pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{mainSectionName => dynamicQueryObject})
                                                                    .build();

        PORTAL_FormGenerator formGenerator = getFormGenerator();

        resultMap.put(FORM_DATA, formGenerator?.generateForm());
        resultMap.put(HEADING_INFO, this.getReportHoursHeadingInfo(recordId));

        return resultMap;
    }

    /**
     * Gets heading information for the report hours form.
     *
     * @author Aaron Wong
     *
     * @param recordId  The record id for the record to report.
     * @return          Map containing heading info.
     * @since           1.0
     */
    private Map<String, Object> getReportHoursHeadingInfo(String recordId) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (String.isBlank(recordId)) {
            return resultMap;
        }

        List<ucinn_portal_Volunteer__c> volunteerList = [SELECT Volunteer_Shift__r.Volunteer_Job__r.Name,
                                                                Volunteer_Shift__r.Actual_Start_Date_Time__c,
                                                                Volunteer_Shift__r.Actual_End_Date_Time__c
                                                         FROM ucinn_portal_Volunteer__c
                                                         WHERE Id = :recordId];

        if (volunteerList == null || volunteerList.isEmpty()) {
            return resultMap;
        }

        resultMap.put(HEADING_CONST, volunteerList.get(0).Volunteer_Shift__r.Volunteer_Job__r.Name);
        resultMap.put(START_DATE_TIME, volunteerList.get(0).Volunteer_Shift__r.Actual_Start_Date_Time__c);
        resultMap.put(END_DATE_TIME, volunteerList.get(0).Volunteer_Shift__r.Actual_End_Date_Time__c);
        return resultMap;
    }

    /**
     * Reports the volunteer hours for a given volunteer record.
     *
     * @author Aaron Wong
     *
     * @param volunteerMap      Map of field api name on volunteer to field value.
     * @param recordId          Record Id of the volunteer record to update.
     * @since                   1.0
     */
    public virtual void reportVolunteerHours(Map<String, Object> params) {
        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);

        pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
                                                                    .buildMainSectionName(mainSectionName)
                                                                    .build();

        if (pageSectionAdapter == null) {
            return;
        }

        PORTAL_FormSubmitter formSubmitter = this.getFormSubmitter();

        Map<String, List<PORTAL_FormRecordWrapper>> formData = formSubmitter?.convertObjectToFormDataMap((Object)params?.get(FORM_DATA));

        formSubmitter?.submit(formData);
    }

    /**
     * Gets volunteer records based on the portal page section settings.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @param mainSectionName       The sub section name of the Portal Page Section Setting to use.
     * @return                      Map containing the front end layout and volunteer records.
     * @since                       1.0
     */
    public Map<String, Object> getVolunteerRecords(Map<String, Object> params){
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

        pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName(pageName)
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
     * Gets shift information when user clicks on modify link in email
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param pageName              Page Name of Portal Page Section Setting
     * @param mainSectionName       Main Section Name of Portal Page Section Setting
     * @param volunteerShiftId      Id of Volunteer Shift
     *
     * @return                      Returns volunteer shift as map
     */
    public virtual Map<String, Object> getShiftInfo(Map<String, Object> params) {
        // the shift is in the form of a map
        Map<String,Object> volunteerShiftMap = null;

        if (params == null || params.isEmpty()) {
            return volunteerShiftMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String volunteerShiftId = (String)params.get(VOLUNTEER_SHIFT_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(volunteerShiftId)) {
            return volunteerShiftMap;
        }

        Map<String, Object> jobListParamMap = params;

        // uses job list to preserve the front end field ids
        Map<String, Object> volunteerJobListMap = getVolunteerJobList(jobListParamMap);

        List<Map<String,Object>> volunteerJobList = (List<Map<String,Object>>)volunteerJobListMap.get(VOLUNTEER_JOB_LIST);

        if (volunteerJobList == null || volunteerJobList.isEmpty()) {
            return volunteerShiftMap;
        }

        for (Map<String,Object> eachVolunteerMap : volunteerJobList) {
            List<Map<String,Object>> eachShiftList = (List<Map<String,Object>>)eachVolunteerMap.get(VOLUNTEER_SHIFTS);

            if (eachShiftList == null || eachShiftList.isEmpty()) {
                continue;
            }

            for (Map<String,Object> eachShiftMap : eachShiftList) {
                if (eachShiftMap == null || eachShiftMap.isEmpty()) {
                    continue;
                }

                String eachShiftId = (String)eachShiftMap.get(VOLUNTEER_SHIFT_ID);

                if (volunteerShiftId == eachShiftId) {
                    volunteerShiftMap = eachShiftMap;
                    break;
                }

            }

            if (volunteerShiftMap != null && !volunteerShiftMap.isEmpty()) {
                break;
            }
        }

        return volunteerShiftMap;
    }

    /**
     * Gets list of Volunteer Jobs to display on the front end
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param pageName          Page Name of Page Section Setting
     * @param mainSectionName   Main Section Name of Page Section Setting
     * @param searchString      Name of Job to Search For
     * @param locationObject    Location Information for geolocation search
     * @param offset            Offset for query search
     *
     * @return                  Returns front end data map & volunteer job list
     */
    public virtual Map<String, Object> getVolunteerJobList(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        String searchString = (String)params.get(SEARCH_STRING);
        Integer offset = Integer.valueOf(params.get(OFFSET_KEY));
        Map<Object, Object> locationObject = (Map<Object, Object>)params.get(LOCATION_KEY);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            System.debug('Get Volunteer Job List ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        List<Portal_Page_Section_Setting__mdt> volunteerPageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (volunteerPageSectionList == null || volunteerPageSectionList.isEmpty()) {
            return returnMap;
        }

        returnMap.put(FRONT_END_DATA_MAP, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(volunteerPageSectionList));

        Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> dynamicOverrideMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>();
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();

        dynamicQueryClass.dynamicWhereClause = generateVolunteerJobListWhereClause(searchString, locationObject);
        dynamicQueryClass.offset = offset;
        dynamicOverrideMap.put(mainSectionName, dynamicQueryClass);

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(null,
                                                                                                                        PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(volunteerPageSectionList),
                                                                                                                        dynamicOverrideMap,
                                                                                                                        false,
                                                                                                                        true);

        returnMap.put(VOLUNTEER_JOB_LIST, recordsMap?.get(mainSectionName)?.get(RECORDS_CONST));

        // find shifts that user are already registered for
        Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        List<ucinn_portal_Volunteer__c> registeredShifts = getRegisteredShifts(userContact);
        List<String> registeredShiftsIdList = new List<String>();

        if (registeredShifts != null && !registeredShifts.isEmpty()) {
            for (Integer index = 0; index < registeredShifts.size(); index++) {
                registeredShiftsIdList.add(registeredShifts[index].Volunteer_Shift__c);
            }
        }

        returnMap.put(REGISTERED_SHIFTS, registeredShiftsIdList);

        return returnMap;
    }

    /**
     * Initializes Volunteer Sign Up Modal
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param pageName              Page Name of Portal Page Section Setting
     * @param mainSectionName       Main Section Name of Portal Page Section Setting
     * @param volunteerShiftId      Id of Volunteer Shift
     *
     * @return                      Return map that contains contact information for current logged in user, and front end data map
     */
    public virtual Map<String, Object> initializeVolunteerSignUp(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String volunteerShiftId = (String)params.get(VOLUNTEER_SHIFT_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(volunteerShiftId)) {
            return resultMap;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, '');

        if (pageSectionSettingList == null || pageSectionSettingList.isEmpty()) {
            return resultMap;
        }

        Map<String, Map<String, Object>> frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList);

        resultMap.put(FRONT_END_DATA_MAP, frontEndDataMap);

        Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        if (userContact == null) {
            return resultMap;
        }

        if (userContact == null) {  // so unaunthenticated user does not get prepopulated
            return resultMap;
        }

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(userContact?.Id,
                                                                                                                        PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList),
                                                                                                                        new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(),
                                                                                                                        false,
                                                                                                                        true);


        resultMap.put(CONTACT_CONST, recordsMap?.get(mainSectionName)?.get(RECORDS_CONST)[0]);
        return resultMap;
    }

    /**
     * Initializes Volunteer Modify Application Modal
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param pageName              Page Name of Portal Page Section Setting
     * @param mainSectionName       Main Section Name of Portal Page Section Setting
     * @param volunteerShiftId      Id of Volunteer Shift
     * @param volunteerId           Id of volunteer object that user is modifying
     *
     * @return                      Return map that contains list of volunteer applications, and front end data map
     */
    public virtual Map<String, Object> initializeVolunteerModifyModal(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String volunteerShiftId = (String)params.get(VOLUNTEER_SHIFT_ID);
        String volunteerId = (String)params.get(VOLUNTEER_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(volunteerShiftId)) {
            return resultMap;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, '');

        if (pageSectionSettingList == null || pageSectionSettingList.isEmpty()) {
            return resultMap;
        }

        Map<String, Map<String, Object>> frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList);

        resultMap.put(FRONT_END_DATA_MAP, frontEndDataMap);

        Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});

        Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> dynamicOverrideMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>();
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();

        String whereClausePrefix = ' WHERE ';
        String whereClause = '';
        String registeringConstituentWhereClause = ' ';

        if (String.isNotBlank(volunteerId)) {
            whereClause = whereClausePrefix + ' Id =\'' + String.escapeSingleQuotes(volunteerId) + '\' ';
            whereClausePrefix = ' AND ';
        }

        if (userContact != null) {
            whereClause = whereClause + whereClausePrefix + ' Registering_Constituent__c = \'' + userContact.Id + '\' ';
            whereClausePrefix = 'AND ';
        } 

        dynamicQueryClass.dynamicWhereClause =  whereClause + whereClausePrefix
                                                + ' Volunteer_Shift__c = \'' + String.escapeSingleQuotes(volunteerShiftId) + '\''
                                                + ' AND Application_Status__c != \'' + CANCELLED_STATUS + '\'';
        dynamicOverrideMap.put(mainSectionName, dynamicQueryClass);

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(userContact?.Id,
                                                                                                                        PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList),
                                                                                                                        dynamicOverrideMap,
                                                                                                                        false,
                                                                                                                        true);
        resultMap.put(RECORDS_CONST, recordsMap?.get(mainSectionName)?.get(RECORDS_CONST));
        return resultMap;
    }

    /**
     * Signs user up for shift by creating volunteer object linked to either
     * the contact record (no changes made on front end and user has contact)
     * or an interim (if user does not have contact record or changes were made on front end)
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param volunteerShiftId      Id of shift that user is signing up for
     * @param volunteerBioInfoMap   Bio information of volunteer that was inputted on front end
     * @param pageName              Page Name of page section setting
     * @param mainSectionName       Main Section Name of page section setting
     * @param recaptchaToken             The client side recaptcha token to be verified
     */
    public virtual void volunteerShiftSignUp(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            System.debug('Shift sign up ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_VolunteerControllerBase.volunteerShiftSignUp', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        String volunteerShiftIdString = (String)params.get(VOLUNTEER_SHIFT_ID);
        Map<Object, Object> volunteerBioInfoMap = (Map<Object, Object>)params.get(VOLUNTEER_BIO_INFO_MAP);
        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String signUpType = (String)params.get(SIGN_UP_TYPE);
        String interimSourceUrl = (String) params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);

        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);

        if (String.isBlank(volunteerShiftIdString) || volunteerBioInfoMap == null || volunteerBioInfoMap.isEmpty()
                || String.isBlank(pageName) || String.isBlank(mainSectionName) || isShiftFull(volunteerShiftIdString)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, null);

        Map<String, Map<String, Object>> frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList);

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(userContact?.Id,
                                                                                                                        PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList),
                                                                                                                        new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(),
                                                                                                                        false,
                                                                                                                        true);

        Map<String, Object> contactInfoMap = recordsMap?.get(mainSectionName)?.get(RECORDS_CONST)[0];

        ucinn_portal_Volunteer__c newVolunteerObject = null;
        String volunteerId = '';

        Boolean isCreateCase = isCreateCaseForVolunteer();

        if (userContact == null || signUpType == GUEST_KEY || isAlreadyRegisteredForShift(userContact, volunteerShiftIdString) || isEditOnFrontEnd(contactInfoMap, volunteerBioInfoMap)) {
            newVolunteerObject = createVolunteerWithInterim(frontEndDataMap, volunteerBioInfoMap, volunteerShiftIdString, userContact, isCreateCase);
        } else {
            newVolunteerObject = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShiftIdString, Contact__c = userContact.Id, Registering_Constituent__c = userContact.Id);
        }

        if (isCreateCase == true) {
            Case newCase = createCase(null, null);
            newVolunteerObject.Case__c = newCase.Id;
            newVolunteerObject.Application_Status__c = PENDING_STATUS;
        }

        PORTAL_UTIL_Volunteers.insertVolunteerRecord(newVolunteerObject);
        sendEmailsToVolunteers(volunteerShiftIdString, volunteerBioInfoMap, newVolunteerObject?.Id);
    }

    /**
     * Modifies user's application by editing their interim if one exists or creates a new one of none exists
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param volunteerId           Id of volunteer object that user is modifying
     * @param interimId             Id of interim linked to volunteer object
     * @param volunteerBioInfoMap   Bio information of volunteer that was inputted on front end
     * @param pageName              Page Name of page section setting
     * @param mainSectionName       Main Section Name of page section setting
     * @param recaptchaToken             The client side recaptcha token to be verified
     */
    public virtual void volunteerModifyApplicationSave(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            System.debug('Volunteer modification ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_VolunteerControllerBase.volunteerModifyApplicationSave', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        String volunteerId = (String)params.get(VOLUNTEER_ID);
        String interimId = (String)params.get(INTERIM_ID);
        Map<Object, Object> volunteerBioInfoMap = (Map<Object, Object>)params.get(VOLUNTEER_BIO_INFO_MAP);
        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);


        if (String.isBlank(volunteerId) || volunteerBioInfoMap == null || volunteerBioInfoMap.isEmpty()
                || String.isBlank(pageName) || String.isBlank(mainSectionName) ) {
            System.debug('Volunteer modification ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        String registeringConstituentId = '';

        if (userContact != null) {
            registeringConstituentId = userContact.Id;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, null);

        Map<String, Map<String, Object>> frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList);

        List<ucinn_portal_Volunteer__c> volunteerObjectList = [SELECT Id, Interim__c, Case__c FROM ucinn_portal_Volunteer__c
                                                                WHERE Id = :volunteerId
                                                                AND Registering_Constituent__c = :registeringConstituentId
                                                                AND Application_Status__c != :CANCELLED_STATUS];

        if (volunteerObjectList == null || volunteerObjectList.isEmpty()) {
            System.debug('Volunteer modification ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        ucinn_portal_Volunteer__c volunteerApplication = volunteerObjectList.get(0);

        ucinn_ascendv2__Interim__c newInterim = new ucinn_ascendv2__Interim__c(Id = volunteerApplication.Interim__c);

        for (Object eachFieldId : volunteerBioInfoMap.keySet()) {
            String stagingRecordField = (String)frontEndDataMap.get((String)eachFieldId).get(STAGING_RECORD_FIELD_NAME);

            if (String.isBlank(stagingRecordField)) {
                continue;
            }

            // populates interim fields with staging record fields from portal field section settings
            newInterim.put(stagingRecordField, volunteerBioInfoMap.get(eachFieldId));
        }

        upsert newInterim;
        volunteerApplication.Interim__c = newInterim.Id;

        if (isCreateCaseForVolunteer()) {
            volunteerApplication.Application_Status__c = PENDING_STATUS;
            if (String.isBlank(volunteerApplication.Case__c)) {
                Case newCase = createCase(CASE_MODIFY_SUBJECT, CASE_MODIFY_DESCRIPTION);
                volunteerApplication.Case__c = newCase.Id;
            } else {  // if they already have a case, set it to resubmitted
                Case newCase = new Case(Id = volunteerApplication.Case__c, Status = CASE_RESUBMITTED_STATUS, Description = CASE_MODIFY_DESCRIPTION, Subject = CASE_MODIFY_SUBJECT);
                update newCase;
            }
        }

        update volunteerApplication;
    }

    /**
     * Withdraws volunteer application by setting status to cancelled
     *
     * @author                 Phillip Nguyen
     * @since                  1.0
     *
     * @param volunteerId      Id of Volunteer
     */
    public virtual void withdrawVolunteerApplication(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            System.debug('Volunteer withdraw ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        String volunteerId = (String)params.get(VOLUNTEER_ID);

        if (String.isBlank(volunteerId)) {
            System.debug('Volunteer withdraw ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        ucinn_portal_Volunteer__c newVolunteer = new ucinn_portal_Volunteer__c(Id = volunteerId, Application_Status__c = CANCELLED_STATUS);
        update newVolunteer;
    }

    /**
     * Checks to see if contact has already registered for shift
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param userContact       Contact of authenticated user
     * @param volunteerShiftId  Id of Volunteer Shift
     *
     * @return                  Boolean value determining if user is already registered for volunteer shift
     */
    private static Boolean isAlreadyRegisteredForShift(Contact userContact, String volunteerShiftId) {
        if (userContact == null || String.isBlank(volunteerShiftId)) {
            return false;
        }

        List<ucinn_portal_Volunteer__c> volunteerList = [SELECT Id FROM ucinn_portal_Volunteer__c
                                                         WHERE Volunteer_Shift__c = :volunteerShiftId
                                                         AND Application_Status__c != :CANCELLED_STATUS
                                                         AND Registering_Constituent__c = :userContact.Id];

        if (volunteerList == null || volunteerList.isEmpty()) {
            return false;
        }

        return true;
    }

    
    /**
     * Checks to see if the volunteer shift is full.
     *
     * @author  Todd Shinto
     * @since   1.3
     *
     * @param volunteerShiftId  Id of Volunteer Shift
     *
     * @return                  Boolean value determining if the volunteer shift is full.
     */
    private static Boolean isShiftFull(String volunteerShiftId) {
        if (String.isBlank(volunteerShiftId)) {
            return true;
        }

        List<ucinn_portal_Volunteer_Shift__c> volunteerShiftList = [SELECT Id, Available_Number_of_Volunteers__c 
                                                                    FROM ucinn_portal_Volunteer_Shift__c
                                                                    WHERE Id = :volunteerShiftId];

        if (volunteerShiftList.isEmpty()) {
            return true;
        }

        return volunteerShiftList.get(0)?.Available_Number_of_Volunteers__c <= 0;
    }

    /**
     * Checks portal org setting to see if a case is create when signing up for shift or modifying application
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param userContact       Contact of authenticated user
     *
     * @return                  Boolean value determining if a case is created
     */
    private static Boolean isCreateCaseForVolunteer() {
        Boolean isCreateCase = false;
        List<SObject> volunteerOrgSetting = PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object> {PORTAL_Utils.QUERY_STRING =>
                                                                                                'SELECT id, DeveloperName, Value__c FROM Portal_Organization_Setting__mdt WHERE DeveloperName =\'' + IS_VOLUNTEER_CREATE_CASE_DEVELOPER_NAME + '\''
                                                                                                });

        if (volunteerOrgSetting == null || volunteerOrgSetting.isEmpty()) {
            return isCreateCase;
        }

        Portal_Organization_Setting__mdt isCreateCaseForVolunteerOrgSetting = (Portal_Organization_Setting__mdt)volunteerOrgSetting[0];
        isCreateCase = Boolean.valueOf(isCreateCaseForVolunteerOrgSetting?.Value__c);

        return isCreateCase;
    }

    /**
     * Gets shifts that users have applied for
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param userContact       Contact of authenticated user
     *
     * @return                  Volunteer shifts that user applied for
     */
    private static List<ucinn_portal_Volunteer__c> getRegisteredShifts(Contact userContact) {
        List<ucinn_portal_Volunteer__c> volunteerList = new List<ucinn_portal_Volunteer__c>();

        if (userContact == null) {
            return volunteerList;
        }

        volunteerList = [SELECT Volunteer_Shift__c FROM ucinn_portal_Volunteer__c
                         WHERE Registering_Constituent__c = :userContact.Id
                         AND Application_Status__c != :CANCELLED_STATUS];

        return volunteerList;
    }

    /**
     * Check to see if contact info on sign up form was edited
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param userContact           Authenticated user's contact information
     * @param volunteerBioInfoMap   Bio information of volunteer that was inputted on front end
     *
     * @return  Returns boolean value determining if front end contact information was edited
     */
    private static Boolean isEditOnFrontEnd(Map<String, Object> contactInfoMap, Map<Object, Object> volunteerBioInfoMap){
        if (contactInfoMap == null || contactInfoMap.isEmpty() || volunteerBioInfoMap == null || volunteerBioInfoMap.isEmpty()) {
            System.debug('Is Edit on Front End ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        // compare front end information to user's queried contact information
        for (Object eachVolunteerBioInfoKey : volunteerBioInfoMap.keySet()) {
            String frontEndValue = (String)volunteerBioInfoMap.get(eachVolunteerBioInfoKey);
            String queriedValue = (String)contactInfoMap.get((String)eachVolunteerBioInfoKey);

            if (frontEndValue != queriedValue) {
                return true;
            }
        }

        return false;
    }

    /**
     * Creates volunteer object with interim when user is guest (no contact record) or
     * if they edit their prepopulated information when they are an authenticated user
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param frontEndDataMap           Data map to access staging record field name for interim
     * @param volunteerBioInfoMap       Bio information from the sign up form modal
     * @param volunteerShiftIdString    Id of volunteer shift
     * @param userContact               User's contact record (used to populate the registering contact field)
     * @param isCreateCase              Boolean determing whether to create a case during registration
     *
     * @return                          Return Volunteer Object
     */
    private static ucinn_portal_Volunteer__c createVolunteerWithInterim(Map<String, Map<String, Object>> frontEndDataMap, Map<Object, Object> volunteerBioInfoMap, String volunteerShiftIdString, Contact userContact, Boolean isCreateCase) {
        if (volunteerBioInfoMap == null || volunteerBioInfoMap.isEmpty() || String.isBlank(volunteerShiftIdString)) {
            System.debug('Sign up with interim creation ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        ucinn_ascendv2__Interim__c newInterim = new ucinn_ascendv2__Interim__c();

        newInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();

        for (Object eachFieldId : volunteerBioInfoMap.keySet()) {
            String stagingRecordField = (String)frontEndDataMap.get((String)eachFieldId).get(STAGING_RECORD_FIELD_NAME);

            if (String.isBlank(stagingRecordField)) {
                continue;
            }

            // populates interim fields with staging record fields from portal field section settings
            newInterim.put(stagingRecordField, volunteerBioInfoMap.get(eachFieldId));
        }

        insert newInterim;

        ucinn_portal_Volunteer__c newVolunteerObject = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShiftIdString, Interim__c = newInterim.Id);

        if (userContact != null) {
            newVolunteerObject.Registering_Constituent__c = userContact.Id;
        }

        return newVolunteerObject;
    }

    /**
     * Creates case with overridable subject and description
     * @author                  Phillip Nguyen
     * @since                   1.0
     * @param caseSubject       The case subject
     * @param caseDescription   The case description
     */
    @TestVisible
    private static Case createCase(String caseSubject, String caseDescription) {
        String defaultCaseSubject = CASE_SUBJECT;
        String defaultCaseDescription = CASE_DESCRIPTION;

        if (String.isNotBlank(caseSubject)) {
            defaultCaseSubject = caseSubject;
        }

        if (String.isNotBlank(caseDescription)) {
            defaultCaseDescription = caseDescription;
        }

        Case newCase = new Case(Origin = CASE_ORIGIN,
                                Subject = defaultCaseSubject,
                                Description = defaultCaseDescription,
                                Status = CASE_NEW_STATUS);

        insert newCase;
        return newCase;
    }

    /**
     * Gets dynamic where clause if the job list search is filtered by job name and location
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param   searchString    Volunteer Job name search string to filter by
     * @param   locationObject  Front end Map that contains information about the geolocation search
     *
     * @return                  Where Clause that includes searching by volunteer job name and location
     */
    private static String generateVolunteerJobListWhereClause(String searchString, Map<Object, Object> locationObject) {
        String resultString = '';
        String whereClausePrefix = ' WHERE ';

        if (String.isNotBlank(searchString)) {
            resultString = resultString + whereClausePrefix + ' (Name LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\' OR Listing__r.Name LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\') ';
            whereClausePrefix = ' AND ';
        }

        if (locationObject != null && !locationObject.isEmpty()) {
            String locationClause = getLocationClause(locationObject);

            if (String.isNotBlank(locationClause)) {
                resultString = resultString + whereClausePrefix + locationClause;
            }
        }

        return resultString;
    }

    /**
     * Gets the location portion for the volunteer jobs list
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param city          The city to query by.
     * @param state         The state to query by.
     * @param postalCode    The postal code to query by.
     * @param country       The country to query by.
     * @param radius        The radius to query by.
     *
     * @return              The location clause.
     */
    private static String getLocationClause(Map<Object, Object> locationObject) {
        if (locationObject == null || locationObject.isEmpty()) {
            return '';
        }

        String city = (String)locationObject.get(CITY_KEY);
        String state = (String)locationObject.get(STATE_KEY);
        String postalCode = (String)locationObject.get(POSTAL_CODE);
        String country = (String)locationObject.get(COUNTRY_KEY);
        Decimal radius = (Decimal)locationObject.get(RADIUS_KEY);

        if (String.isBlank(city) && String.isBlank(state) && String.isBlank(postalCode) && String.isBlank(country)) {
            return '';
        }

        if (radius == null || radius <= 0) {
            return getLocationClauseWithNoRadius(city, state, postalCode, country);
        }

        return getLocationClauseWithRadius(city, state, postalCode, country, radius);
    }

    /**
     * Gets the location portion of the query where clause when no radius is present.
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param city          The city to query by.
     * @param state         The state to query by.
     * @param postalCode    The postal code to query by.
     * @param country       The country to query by.
     *
     * @return              The location clause.
     */
    private static String getLocationClauseWithNoRadius(String city,
                                                        String state,
                                                        String postalCode,
                                                        String country) {
        String resultString = '';
        String whereClausePrefix = '';

        if (String.isNotBlank(city)) {
            resultString = resultString + whereClausePrefix + ' City__c = \'' + String.escapeSingleQuotes(city) + '\' ';
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(state)) {
            resultString = resultString + whereClausePrefix + ' State__c = \'' + String.escapeSingleQuotes(state) + '\' ';
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(postalCode)) {
            resultString = resultString + whereClausePrefix + ' Postal_Code__c = \'' + String.escapeSingleQuotes(postalCode) + '\' ';
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(country)) {
            resultString = resultString + whereClausePrefix + ' Country__c = \'' + String.escapeSingleQuotes(country) + '\' ';
        }

        return resultString;
    }

    /**
     * Gets the location portion of the query where clause when no radius is present.
     *
     * @author Phillip Nguyen
     * @since               1.0
     *
     * @param city          The city to query by.
     * @param state         The state to query by.
     * @param postalCode    The postal code to query by.
     * @param country       The country to query by.
     * @param radius        The radius to query by.
     *
     * @return              The location clause.
     */
    private static String getLocationClauseWithRadius(String city,
                                                      String state,
                                                      String postalCode,
                                                      String country,
                                                      Decimal radius) {
        if ((String.isBlank(city) && String.isBlank(state) && String.isBlank(postalCode) && String.isBlank(country))
                || radius == null || radius <= 0) {
            return '';
        }

        String singleLineAddress = PORTAL_CommunityUtils.generateSingleLineAddress(new Map<String, Object>{PORTAL_CommunityUtils.CITY_KEY => city,
                                                                                                           PORTAL_CommunityUtils.STATE_KEY => state,
                                                                                                           PORTAL_CommunityUtils.POSTAL_CODE => postalCode,
                                                                                                           PORTAL_CommunityUtils.COUNTRY_KEY => country});

        if (String.isBlank(singleLineAddress)) {
            return '';
        }

        Map<String, Object> locationMap = null;
        try {
            PORTAL_GeolocationHub geolocationHub = new PORTAL_GeolocationHub();
            locationMap = geolocationHub.geolocateSingleLineAddress(singleLineAddress);
        } catch (Exception e) {
            System.debug('FATAL: ' + e);
        }

        if (locationMap == null || locationMap.isEmpty()) {
            return '';
        }

        Double lattitude = (Double)locationMap.get(PORTAL_GeolocationHub.LATITUDE_KEY);
        Double longitude = (Double)locationMap.get(PORTAL_GeolocationHub.LONGITUDE_KEY);

        if (lattitude == null || longitude == null) {
            return '';
        }

        return ' DISTANCE (Geolocation__c , GEOLOCATION(' + lattitude + ', ' + longitude + '), \'mi\') < ' + radius + ' ';
    }

    /**
     * Send email to volunteer after sign up
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param volunteerShiftId          Id of Volunteer Shift that user signed up for
     * @param volunteerBioInfoMap       Bio information of volunteer that was inputted on front end
     * @param volunteerId               Id of volunteer object created during sign up
     */
    public static void sendEmailsToVolunteers(String volunteerShiftId, Map<Object,Object> volunteerBioInfoMap, String volunteerId) {
        if (String.isBlank(volunteerShiftId) || volunteerBioInfoMap == null || volunteerBioInfoMap.isEmpty() || String.isBlank(volunteerId)) {
            return;
        }

        EmailTemplate volunteerShiftSignUpEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => VOLUNTEER_SHIFT_SIGN_UP_EMAIL_TEMPLATE});

        if (volunteerShiftSignUpEmailTemplate == null) {
            System.debug('Volunteer shift sign up email template ' + ERROR_MESSAGE_EMPTY_PARAMS);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_SUBMIT});
        }


        Map<String, User> usersToEmailMap = PORTAL_UTIL_Volunteers.getUsersToEmail(new Map<String, Object>{PORTAL_UTIL_Volunteers.VOLUNTEER_BIO_INFO_MAP => volunteerBioInfoMap});
        if (usersToEmailMap == null || usersToEmailMap.isEmpty()) {
            System.debug('Could not get users to email');
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_SUBMIT});
        }

        List<ucinn_portal_Volunteer_Shift__c> volunteerShiftList = [SELECT Id, Name, Actual_Start_Date_Time__c, Time_Zone__c, Volunteer_Job__r.Name FROM ucinn_portal_Volunteer_Shift__c WHERE Id = :volunteerShiftId];
        if (volunteerShiftList == null || volunteerShiftList.isEmpty()) {
            System.debug('No volunteer shift found for email');
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_RETRIEVAL});
        }

        String communityName = PORTAL_CommunityUtils.getBaseUrl();
        String volunteerEmail = (String)volunteerBioInfoMap.get(PORTAL_UTIL_Volunteers.VOLUNTEER_EMAIL);

        //create email record with the usersToEmailMap, email template, generated email body
        Map<String, String> mergeFieldtoReplacementValue = createMergeFieldToReplacementMap(volunteerShiftList.get(0), volunteerBioInfoMap, communityName, volunteerId);
        Messaging.SingleEmailMessage emailRecord = createEmailRecord(mergeFieldtoReplacementValue, usersToEmailMap, volunteerEmail, volunteerShiftSignUpEmailTemplate);

        if (emailRecord == null) {
            return;
        }

        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        emailMessageList.add(emailRecord);

        PORTAL_UTIL_Volunteers.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => emailMessageList});
    }

    /**
     * Creates mapping of merge fields to their respective replacement values
     *
     * @param volunteerShift        Volunteer Shift Object to put volunteer shift information inside email
     * @param volunteerBioInfoMap   Volunteer Bio Info Map that contains Volunteer's Bio Information
     * @param communityName         Community Name of Portal
     * @param volunteerId           Volunteer Object Id to add to report hours link inside the email
     *
     * @return                      Map of merge fields to replacement values
     */
    private static Map<String, String> createMergeFieldToReplacementMap(ucinn_portal_Volunteer_Shift__c volunteerShift, Map<Object, Object> volunteerBioInfoMap, String communityName, String volunteerId) {
        Map<String, String> mergeFieldtoReplacementValue = new Map<String, String>();

        if (volunteerShift == null || volunteerBioInfoMap == null || volunteerBioInfoMap.isEmpty() || String.isBlank(communityName) || String.isBlank(volunteerId)) {
            return mergeFieldtoReplacementValue;
        }

        mergeFieldtoReplacementValue.put(MERGE_FIELD_FIRST_NAME, (String)volunteerBioInfoMap.get((Object)PORTAL_UTIL_Volunteers.VOLUNTEER_FIRST_NAME));
        mergeFieldtoReplacementValue.put(MERGE_FIELD_LAST_NAME, (String)volunteerBioInfoMap.get((Object)PORTAL_UTIL_Volunteers.VOLUNTEER_LAST_NAME));
        mergeFieldtoReplacementValue.put(MERGE_FIELD_VOLUNTEER_JOB_NAME, volunteerShift.Volunteer_Job__r?.Name);
        mergeFieldtoReplacementValue.put(MERGE_FIELD_VOLUNTEER_SHIFT_NAME, volunteerShift.Name);
        mergeFieldtoReplacementValue.put(MERGE_FIELD_VOLUNTEER_SHIFT_TIME, PORTAL_CommunityUtils.createFormattedDateString(new Map<String, Object>{PORTAL_CommunityUtils.UNFORMATTED_DATE => volunteerShift.Actual_Start_Date_Time__c,
                                                                                                                                                   PORTAL_CommunityUtils.TIME_ZONE => volunteerShift.Time_Zone__c}));
        mergeFieldtoReplacementValue.put(MERGE_FIELD_REPORT_LINK, createReportLink(communityName, volunteerId));
        mergeFieldtoReplacementValue.put(MERGE_FIELD_MODIFY_LINK, createModifyLink(communityName, (String)volunteerShift.Id, volunteerId));

        return mergeFieldToReplacementValue;
    }

    /**
     * Creates single email message to send to users
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param mergeFieldtoReplacementValue      Mapping of merge fields to their replacements
     * @param usersToEmailMap                   Mapping to find user corresponding to their email
     * @param userEmail                         User's email we are sending email to
     * @param emailTemplateBody                 Email template body to use
     * @param subject                           Subject of email
     *
     * @return                                  Single email message
     */
    private static Messaging.SingleEmailMessage createEmailRecord(Map<String, String> mergeFieldtoReplacementValue, Map<String, User> usersToEmailMap, String userEmail, EmailTemplate emailTemplateRecord) {

        if (usersToEmailMap == null || usersToEmailMap.isEmpty() || mergeFieldtoReplacementValue == null
                || mergeFieldtoReplacementValue.isEmpty() || !usersToEmailMap.containsKey(userEmail) || String.isBlank(userEmail)) {
            return null;
        }

        return PORTAL_CommunityUtils.createEmailRecord(new Map<String,Object>{USER_ID => usersToEmailMap.get(userEmail).Id,
                                                                              SENDER_DISPLAY_NAME => EMAIL_SENDER_NAME,
                                                                              PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => emailTemplateRecord,
                                                                              PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToReplacementValue
                                                                              });
    }

    /**
     * Create report link for email
     *
     * @author      Phillip Nguyen
     * @since       1.0
     *
     * @param communityName     Name of community
     * @param volunteerId       Volunteer Object Id
     *
     * @return                  Returns report volunteer hour link
     */
    private static String createReportLink(String communityName, String volunteerId) {
        String returnString = '';

        if (String.isBlank(volunteerId)) {
            return returnString;
        }

        if (communityName.endsWith('/')) {
            communityName = communityName.removeEnd('/');
        }

        returnString = returnString + 'Report your volunteer hours here: ' + communityName
                                        + '/s/volunteer-information?recordId=' + volunteerId;

        return returnString;
    }

    /**
     * Create modify link for email
     *
     * @author      Phillip Nguyen
     * @since       1.0
     *
     * @param communityName         Name of community
     * @param volunteerShiftId      Volunteer Shift Id
     * @param volunteerId           Volunteer Object Id
     *
     * @return  Returns modify volunteer application link
     */
    private static String createModifyLink(String communityName, String volunteerShiftId, String volunteerId) {
        String returnString = '';

        if (String.isBlank(volunteerId) || String.isBlank(volunteerShiftId)) {
            return returnString;
        }

        if (communityName.endsWith('/')) {
            communityName = communityName.removeEnd('/');
        }

        returnString = returnString + 'Modify your volunteer application here: ' + communityName
                                        + '/s/volunteers?recordId=' + volunteerId
                                        + '&shiftId=' + volunteerShiftId;

        return returnString;
    }
}