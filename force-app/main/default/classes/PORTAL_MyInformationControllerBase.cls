/*
* Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
*                     http://www.ucinnovation.com
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
* Handles methods related to the logged in constituent profile information (display and updating)
* Methods can be overwritten for custom functionality, but this is the base
* class that contains the default logic
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/

global virtual inherited sharing class PORTAL_MyInformationControllerBase {

    public String INTERIM_RECORD_TYPE_NAME = 'Bio_Information';
    public String CASE_TYPE_NAME = 'Bio Information';
    public String INTERIM_DISPLAY_STATUS = 'Under Approval';
    public String REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME = 'Bio_Information_Self_Report';
    public String REPORT_UPDATE_INTERIM_STATUS = 'Manual Review';
    public String SPOUSAL_INTERIM_DESCRIPTION = 'Spousal information changed';
    public String SPOUSAL_INTERIM_STATUS = 'Manual Review';
    public String DUMMY_CONTACT_FIRST_NAME = 'My Information Dummy Contact';
    public String DUMMY_CONTACT_LAST_NAME = 'Do Not Delete This Record';
    public String PRIVACY_SETTING_NAME = 'Privacy_Settings';
    public String DIRECTORY_OPT_OUT_NAME = 'Directory_Opt_Out';
    public String DIRECTORY_SETTING_NAME = 'Directory_Setting';
    public String SPOUSE_SUB_SECTION_NAME = 'Additional_Details';
    public String SPOUSE_MAIN_SECTION_NAME = 'Personal_Information';
    public String CASE_GROUP_NAME = 'Bio Information Case Queue';
    public String REQUEST_UPDATE_RICH_TEXT = '';
    public String CREATE_CASE_FOR_BIO_INFO_SELF_REPORT = 'true';

    public String INTERIM_RECORD_TYPE_METADATA_RECORD_NAME = 'My Information Interim Record Type';
    public String INTERIM_DISPLAY_STATUS_METADATA_RECORD_NAME = 'My Information Interim Display Status';
    public String REPORT_UPDATE_INTERIM_RECORD_TYPE_METADATA_RECORD_NAME = 'Interim Self Report Record Type';
    public String REPORT_UPDATE_INTERIM_STATUS_METADATA_RECORD_NAME = 'My Information Report Update Interim Status';
    public String SPOUSAL_INTERIM_DESCRIPTION_METADATA_RECORD_NAME = 'My Information Spousal Interim Description';
    public String SPOUSAL_INTERIM_STATUS_METADATA_RECORD_NAME = 'My Information Spousal Interim Status';
    public String DUMMY_CONTACT_FIRST_NAME_METADATA_NAME = 'My Information Dummy Contact First Name';
    public String DUMMY_CONTACT_LAST_NAME_METADATA_NAME = 'My Information Dummy Contact Last Name';
    public String PRIVACY_SETTING_NAME_METADATA_NAME = 'My Information Privacy Setting Name';
    public String DIRECTORY_SETTING_NAME_METADATA_NAME = 'My Information Directory Setting Name';
    public String DIRECTORY_OPT_OUT_NAME_METADATA_NAME = 'My Information Directory Opt Out Name';
    public String SPOUSE_SUB_SECTION_NAME_METADATA_NAME = 'My Information Spouse Sub Section Name';
    public String SPOUSE_MAIN_SECTION_NAME_METADATA_NAME = 'My Information Spouse Main Section Name';
    public String CASE_GROUP_NAME_METADATA_NAME = 'My Information Case Group Name';
    public String REQUEST_UPDATE_RICH_TEXT_METADATA_NAME = 'My Information Request Update Rich Text';
    public String CREATE_CASE_FOR_BIO_INFO_SELF_REPORT_METADATA_NAME = 'Create Case For Bio Info Self Report';

    public final String INTERIM_RECORDS_KEY = 'interimRecords';
    public final String SPOUSAL_INTERIM_KEY = 'spousalInterim';
    public final String MAIN_STAGING_RECORD_API_NAME = 'ucinn_ascendv2__Interim__c';
    public final String ADDRESS_API_NAME = 'ucinn_ascendv2__Address__c';
    public final String ADDRESS_RELATIONSHIP = 'ucinn_ascendv2__Address__r';
    public final String ADDRESS_RELATION_API_NAME = 'ucinn_ascendv2__Address_Relation__c';
    public final String IS_DISPLAY_ON_PORTAL = 'ucinn_portal_Is_Display_On_Portal__c';
    public final String ORIGINAL_RECORD = 'ucinn_portal_Original_Record__c';
    public final String PREFERRED_SPOUSE = 'ucinn_ascendv2__Preferred_Spouse__r';
    public final String MARITAL_STATUS = 'ucinn_ascendv2__Marital_Status__c';
    public final String SPOUSAL_INTERIM_MARITAL_STATUS = 'ucinn_ascendv2__Marital__c';
    public final String SECTION_SETTING_LIST = 'sectionSettingList';
    public final String STATUS_KEY = 'status';
    public final String FORMER_STATUS = 'Former';
    public final String INACTIVE_STATUS = 'Inactive';
    public final String DELETE_KEY = 'delete';
    public final String INSERT_KEY = 'insert';
    public final String UPDATE_KEY = 'update';

    public final String PARAM_CONTACT_ID = 'contactId';
    public final String PARAM_INTERIM_RECORD_MAP = 'interimRecordMap';
    public final String PARAM_INFORMATION_MAP = 'informationMap';
    public final String PARAM_ALL_RECORDS_MAP = 'allRecordsMap';
    public final String PARAM_ALL_INTERIM_RECORDS_MAP = 'allInterimRecordsMap';
    public final String PARAM_ALL_INTERIM_RECORDS = 'allInterimRecords';
    public final String PARAM_ID_TO_DUPLICATE_OBJECT_MAP = 'idToDuplicateObjectMap';
    public final String PARAM_CURRENT_RECORDS_MAP = 'currentRecords';
    public final String PARAM_RECORD = 'record';
    public final String PARAM_RECORD_TYPE = 'recordType';
    public final String PARAM_SOBJECT_NAME = 'sObjectName';
    public final String PARAM_NEW_RECORD = 'newRecord';
    public final String PARAM_OLD_RECORD = 'oldRecord';
    public final String PARAM_SECTION_SETTING = 'sectionSetting';
    public final String PARAM_FIELD_SET = 'fieldSet';
    public final String PARAM_FIELD = 'field';
    public final String PARAM_RECORDS_TO_INSERT = 'recordsToInsert';
    public final String PARAM_RECORDS_TO_UPDATE = 'recordsToUpdate';
    public final String PARAM_HASH_CODE_TO_ADDRESS_MAP = 'hashCodeToAddressMap';
    public final String PARAM_CONTACT_WITH_SPECIFIED_FIELDS_TO_UPDATE = 'contactWithSpecifiedFieldsToUpdate';
    public final String PARAM_SOBJECT_NAME_TO_DML_OPERATION_MAP = 'sobjectNameToDmlOperationMap';
    public final String PARAM_FIELD_TO_CONDITIONS_MAP = 'fieldToConditionsMap';

    public final String ID_CONST = 'Id';
    public final String MASTER_DEGREE_ID = 'masterDegreeId';
    protected Map<String, String> objectNameToDummyContactFieldMap;
    protected Map<String, String> objectNameToDummyOrganizationFieldMap;
    protected Map<String, String> objectNameToMasterRecordFieldMap;
    protected Map<String, String> interimSubsectionNameToSObjectApiNameMap;
    public final String IS_DELETED = '%isDeleted%';
    public final String FIRST_NAME = 'FirstName';
    public final String LAST_NAME = 'LastName';
    public final String INTERIMS_FRONT_END_NAME = 'interims';
    public final String SCHOOL_DEGREE_INFORMATION = 'School_Degree_Information';
    public final String NON_SCHOOL_DEGREE_INFORMATION = 'Non_School_Degree_Information';
    public final String DEGREE_INFORMATION_API_NAME = 'ucinn_ascendv2__Degree_Information__c';
    public final String SCHOOL_DEGREE_SELF_REPORTS = 'schoolDegreesSelfReport';
    public final String NON_SCHOOL_DEGREE_SELF_REPORTS = 'nonSchoolDegreesSelfReport';
    public final String RECORD_TO_UPDATE_ID = 'recordToUpdateId';
    public final String FORMULA_CONST = 'Formula';
    public final String OBJECT_NAME = 'objectName';
    public final String POST_CODE = 'postCode';
    public final String MINOR_CODE = 'minorCode';
    public final String SELF_REPORTS = 'selfReports';
    public final String REQUEST_UPDATE_RICH_TEXT_KEY = 'requestUpdateRichText';

    public final String ERROR_DUPLICATE_MESSAGE = 'Entering duplicate information. Please enter different information or contact an administrator.';

    public static final String MAIN_QUERY_KEY = 'mainQuery';
    public static final String FRONT_END_INACTIVE_RECORD_FIELD_MAP = 'frontEndInactiveRecordFieldMap';
    public static final String ADDRESSES_CONST = 'Addresses';

    public static final Set<String> V2_SUB_SECTIONS = new Set<String>{'Nickname', 'Maiden Name'};

    public PORTAL_MyInformationControllerBase(String interimRecordTypeMetadataName,
                                              String interimStatusMetadataName,
                                              String reportUpdateInterimRecordTypeMetadataName,
                                              String reportUpdateInterimStatusMetadataName,
                                              String spousalInterimDescriptionMetadataName,
                                              String spousalInterimStatusMetadataName,
                                              String dummyContactFirstNameMetadataName,
                                              String dummyContactLastNameMetadataName,
                                              String directorySettingNameMetadataName,
                                              String directyOptOutNameMetadataName,
                                              String privacySettingsNameMetadataName,
                                              String spouseSubSectionNameMetadataName,
                                              String spouseMainSectionNameMetadataName,
                                              String caseGroupNameMetadataName) {

        if (String.isNotBlank(interimRecordTypeMetadataName)) {
            INTERIM_RECORD_TYPE_METADATA_RECORD_NAME = interimRecordTypeMetadataName;
        }
        if (String.isNotBlank(interimStatusMetadataName)) {
            INTERIM_DISPLAY_STATUS_METADATA_RECORD_NAME = interimStatusMetadataName;
        }

        if (String.isNotBlank(interimRecordTypeMetadataName)) {
            REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME = interimRecordTypeMetadataName;
        }
        if (String.isNotBlank(interimStatusMetadataName)) {
            REPORT_UPDATE_INTERIM_STATUS = interimStatusMetadataName;
        }
        if (String.isNotBlank(spousalInterimDescriptionMetadataName)) {
            SPOUSAL_INTERIM_DESCRIPTION_METADATA_RECORD_NAME = spousalInterimDescriptionMetadataName;
        }
        if (String.isNotBlank(spousalInterimStatusMetadataName)) {
            SPOUSAL_INTERIM_STATUS_METADATA_RECORD_NAME = spousalInterimStatusMetadataName;
        }
        if (String.isNotBlank(dummyContactFirstNameMetadataName)) {
            DUMMY_CONTACT_FIRST_NAME_METADATA_NAME = dummyContactFirstNameMetadataName;
        }
        if (String.isNotBlank(dummyContactLastNameMetadataName)) {
            DUMMY_CONTACT_LAST_NAME_METADATA_NAME = dummyContactLastNameMetadataName;
        }
        if (String.isNotBlank(directorySettingNameMetadataName)) {
            DIRECTORY_SETTING_NAME_METADATA_NAME = directorySettingNameMetadataName;
        }
        if (String.isNotBlank(directyOptOutNameMetadataName)) {
            DIRECTORY_OPT_OUT_NAME_METADATA_NAME = directyOptOutNameMetadataName;
        }
        if (String.isNotBlank(privacySettingsNameMetadataName)) {
            PRIVACY_SETTING_NAME_METADATA_NAME = privacySettingsNameMetadataName;
        }
        if (String.isNotBlank(spouseSubSectionNameMetadataName)) {
            SPOUSE_SUB_SECTION_NAME_METADATA_NAME = spouseSubSectionNameMetadataName;
        }
        if (String.isNotBlank(spouseMainSectionNameMetadataName)) {
            SPOUSE_MAIN_SECTION_NAME_METADATA_NAME = spouseMainSectionNameMetadataName;
        }
        if (String.isNotBlank(caseGroupNameMetadataName)) {
            CASE_GROUP_NAME_METADATA_NAME = caseGroupNameMetadataName;
        }

        Set<String> metadataRecordNames = new Set<String>();
        metadataRecordNames.add(INTERIM_RECORD_TYPE_METADATA_RECORD_NAME);
        metadataRecordNames.add(INTERIM_DISPLAY_STATUS_METADATA_RECORD_NAME);
        metadataRecordNames.add(SPOUSAL_INTERIM_DESCRIPTION_METADATA_RECORD_NAME);
        metadataRecordNames.add(SPOUSAL_INTERIM_STATUS_METADATA_RECORD_NAME);
        metadataRecordNames.add(DUMMY_CONTACT_FIRST_NAME_METADATA_NAME);
        metadataRecordNames.add(DUMMY_CONTACT_LAST_NAME_METADATA_NAME);
        metadataRecordNames.add(PRIVACY_SETTING_NAME_METADATA_NAME);
        metadataRecordNames.add(DIRECTORY_SETTING_NAME_METADATA_NAME);
        metadataRecordNames.add(DIRECTORY_OPT_OUT_NAME_METADATA_NAME);
        metadataRecordNames.add(SPOUSE_SUB_SECTION_NAME_METADATA_NAME);
        metadataRecordNames.add(SPOUSE_MAIN_SECTION_NAME_METADATA_NAME);
        metadataRecordNames.add(CASE_GROUP_NAME_METADATA_NAME);

        // TODO: change label to developer names
        List<Portal_Organization_Setting__mdt> metadataRecords = [SELECT Label, Value__c FROM Portal_Organization_Setting__mdt WHERE Label IN :metadataRecordNames];

        updateConstantParameters(metadataRecords);

    }

    public PORTAL_MyInformationControllerBase() {
        Set<String> metadataRecordNames = new Set<String>();
        metadataRecordNames.add(INTERIM_RECORD_TYPE_METADATA_RECORD_NAME);
        metadataRecordNames.add(INTERIM_DISPLAY_STATUS_METADATA_RECORD_NAME);
        metadataRecordNames.add(SPOUSAL_INTERIM_DESCRIPTION_METADATA_RECORD_NAME);
        metadataRecordNames.add(SPOUSAL_INTERIM_STATUS_METADATA_RECORD_NAME);
        metadataRecordNames.add(DUMMY_CONTACT_FIRST_NAME_METADATA_NAME);
        metadataRecordNames.add(DUMMY_CONTACT_LAST_NAME_METADATA_NAME);
        metadataRecordNames.add(PRIVACY_SETTING_NAME_METADATA_NAME);
        metadataRecordNames.add(DIRECTORY_SETTING_NAME_METADATA_NAME);
        metadataRecordNames.add(DIRECTORY_OPT_OUT_NAME_METADATA_NAME);
        metadataRecordNames.add(SPOUSE_SUB_SECTION_NAME_METADATA_NAME);
        metadataRecordNames.add(SPOUSE_MAIN_SECTION_NAME_METADATA_NAME);
        metadataRecordNames.add(CASE_GROUP_NAME_METADATA_NAME);
        metadataRecordNames.add(REQUEST_UPDATE_RICH_TEXT_METADATA_NAME);
        metadataRecordNames.add(CREATE_CASE_FOR_BIO_INFO_SELF_REPORT_METADATA_NAME);

        List<Portal_Organization_Setting__mdt> metadataRecords = [SELECT Label, Value__c FROM Portal_Organization_Setting__mdt WHERE Label IN :metadataRecordNames];
        updateConstantParameters(metadataRecords);
    }

    @TestVisible
    private void updateConstantParameters(List<Portal_Organization_Setting__mdt> metadataRecords) {
        for (Portal_Organization_Setting__mdt metadataRecord : metadataRecords) {
            if (String.isBlank(metadataRecord.Value__c)) {
                continue;
            }
            if (metadataRecord.Label == INTERIM_RECORD_TYPE_METADATA_RECORD_NAME) {
                INTERIM_RECORD_TYPE_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == INTERIM_DISPLAY_STATUS_METADATA_RECORD_NAME) {
                INTERIM_DISPLAY_STATUS = metadataRecord.Value__c;
            } else if (metadataRecord.Label == SPOUSAL_INTERIM_DESCRIPTION_METADATA_RECORD_NAME) {
                SPOUSAL_INTERIM_DESCRIPTION = metadataRecord.Value__c;
            } else if (metadataRecord.Label == SPOUSAL_INTERIM_STATUS_METADATA_RECORD_NAME) {
                SPOUSAL_INTERIM_STATUS = metadataRecord.Value__c;
            } else if (metadataRecord.Label == DUMMY_CONTACT_FIRST_NAME_METADATA_NAME) {
                DUMMY_CONTACT_FIRST_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == DUMMY_CONTACT_LAST_NAME_METADATA_NAME) {
                DUMMY_CONTACT_LAST_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == PRIVACY_SETTING_NAME_METADATA_NAME) {
                PRIVACY_SETTING_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == DIRECTORY_SETTING_NAME_METADATA_NAME) {
                DIRECTORY_SETTING_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == DIRECTORY_OPT_OUT_NAME_METADATA_NAME) {
                DIRECTORY_OPT_OUT_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == SPOUSE_SUB_SECTION_NAME_METADATA_NAME) {
                SPOUSE_SUB_SECTION_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == SPOUSE_MAIN_SECTION_NAME_METADATA_NAME) {
                SPOUSE_MAIN_SECTION_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == CASE_GROUP_NAME_METADATA_NAME) {
                CASE_GROUP_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == REPORT_UPDATE_INTERIM_RECORD_TYPE_METADATA_RECORD_NAME) {
                REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME = metadataRecord.Value__c;
            } else if (metadataRecord.Label == REPORT_UPDATE_INTERIM_STATUS_METADATA_RECORD_NAME) {
                REPORT_UPDATE_INTERIM_STATUS = metadataRecord.Value__c;
            } else if (metadataRecord.Label == REQUEST_UPDATE_RICH_TEXT_METADATA_NAME) {
                REQUEST_UPDATE_RICH_TEXT = metadataRecord.Value__c;
            } else if (metadataRecord.Label == CREATE_CASE_FOR_BIO_INFO_SELF_REPORT_METADATA_NAME) {
                CREATE_CASE_FOR_BIO_INFO_SELF_REPORT = metadataRecord.Value__c;
            }
        }
    }

    /**
     * method that retrieves the contstituent's bio information records
     * to display on the portal. It is overridable in case more information
     * needs to be added to the returned information; however, the base information
     * that is necessary are the permissions map, records map, picklists map,
     * front end data map, interim records, and the mutliple current records settings.
     * DO NOT REMOVE FIELDS FROM THE RETURN MAP AS IT WILL INTERFERE WITH HOW THE LWC COMPONENTS
     * DISPLAY DATA.
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param params:          Map that contains the parameters for the function. contactId param is required.
     *
     * @return                 Map that contains all the information necessary to display on the front end
     */
    global virtual Map<String, Object> getConstituentInformation(Map<String, Object> params) {
        Id contactId = (Id) params.get(PARAM_CONTACT_ID);
        Map<String, Object> returnMap = new Map<String, Object>();
        if (contactId != null) {
            /* custom metadata that contains the information about the sobject fields and types that
             * are associated with bio information. It also contains information on how it should be
             * displayed on the portal page
             */
            List<Portal_Page_Section_Setting__mdt> sectionSettingList = this.queryPageSectionSettings('My Information');

            Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettingList);

            // make a new page section map. combine all the personal information ones like aka, name, etc etc
            Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> frontEndIdToFrontEndIdToPageSectionSettingMap = createInterimPageSectionSettingMap(pageSectionMap);
            Map<String, Map<String,List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(contactId, pageSectionMap,  new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(),false, true);

            System.debug('Records Map');
            for(String key: recordsMap.keySet()){
                System.debug(recordsMap.get(key));
            }
            returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordsMap);
            //gets the picklist values for the constituent to choose from to update their information
            returnMap.put('picklists', PORTAL_UTIL_PageSectionSetting.getPicklists(sectionSettingList));
            //map that allows for generic getting and setting of lwc fields based on a unique id
            returnMap.put('frontEndData', PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionSettingList));

            List<Portal_Page_Section_Setting__mdt> selfReportSectionSettingList = this.queryPageSectionSettings('My Information Self Report');
            Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMapSelfReport = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(selfReportSectionSettingList);
            Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> frontEndIdToFrontEndIdToPageSectionSettingSelfReportMap = createInterimPageSectionSettingMap(pageSectionMapSelfReport);

            Map<String, Map<String, List<sObject>>> selfReportInterimMap = queryForSelfReportedInterimRecords(contactId, selfReportSectionSettingList);

            returnMap.put(SELF_REPORTS, convertBackEndInterimRecordToFrontEnd(selfReportInterimMap, frontEndIdToFrontEndIdToPageSectionSettingSelfReportMap));

            //interim records that contain the constiuent's previously updated information that still needs to be approved
            Map<String, Map<String, List<sObject>>> interimRecordsMap = queryForInterimRecords(contactId, sectionSettingList);

            returnMap.put(INTERIM_RECORDS_KEY, convertBackEndInterimRecordToFrontEnd(interimRecordsMap, frontEndIdToFrontEndIdToPageSectionSettingMap));
            returnMap.put(SECTION_SETTING_LIST, sectionSettingList);
            returnMap.put(FRONT_END_INACTIVE_RECORD_FIELD_MAP, createFrontEndInactiveRecordFieldMap(sectionSettingList));

            // phones, addresses, and emails are displayed as a table and depending on the org configs, new records can be added
            List<ucinn_ascendv2__Org_Wide_Configuration__c> orgSettings = [SELECT ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c,
                                                                            ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c,
                                                                            ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c
                                                                            FROM ucinn_ascendv2__Org_Wide_Configuration__c LIMIT 1];
            setupOrgSettings(orgSettings, returnMap);
            returnMap.put(REQUEST_UPDATE_RICH_TEXT_KEY, REQUEST_UPDATE_RICH_TEXT);
        }

        return returnMap;
    }

    @TestVisible
    private void setupOrgSettings(List<ucinn_ascendv2__Org_Wide_Configuration__c> orgSettings , Map<String, Object> returnMap) {
        if (orgSettings.isEmpty()) {
            returnMap.put('multipleAddresses', false);
            returnMap.put('multipleEmails', false);
            returnMap.put('multiplePhones', false);

        } else {
            returnMap.put('multipleAddresses', orgSettings.get(0).ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c);
            returnMap.put('multiplePhones', orgSettings.get(0).ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c);
            returnMap.put('multipleEmails', orgSettings.get(0).ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c);
        }
    }

    /**
     * Query all page section setting and related section field setting records for my info v1.
     * Filters out records that are v2-only (using main/sub section names) 
     * 
     * @author Jacob Huang
     * @since 1.18
     * 
     * @param pageName      String: Page Name of page section setting
     * 
     * @return list of page section setting records with related section field settings for v1
     */
    protected virtual List<Portal_Page_Section_Setting__mdt> queryPageSectionSettings(String pageName) {
        List<Portal_Page_Section_Setting__mdt> resultList = new List<Portal_Page_Section_Setting__mdt>();
        for (Portal_Page_Section_Setting__mdt eachSection : PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '')) {
            if (V2_SUB_SECTIONS.contains(eachSection.Page_Sub_Section__c)) {
                continue;
            }

            resultList.add(eachSection);
        }

        return resultList;
    }

    /**
     * method that queries for all the interim records that were generated by this constituent from a previous profile
     * update that has not been approved yet. Required to display data in real time; however, if fields and records need to be
     * added, please update the custom metadata record instead
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param contactId:                    The id of the constituent linked to the interim
     * @param sectionSettingList:            The custom metadata records that contain information on how to query the interim records
     */
    public virtual Map<String, Map<String, List<sObject>>> queryForInterimRecords(Id contactId, List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, Map<String, List<sObject>>> returnMap = new Map<String, Map<String, List<sObject>>>();
        Map<String, Map<String, Set<String>>> recordToFieldSetMap = new Map<String, Map<String, Set<String>>>();
        Map<String, Map<String, String>> recordToWhereClause = new Map<String, Map<String, String>>();
        Set<String> interimFields = new Set<String>{'ucinn_portal_Case__c'};

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            if (String.isBlank(sectionSetting.Staging_sObject_API_Name__c)) {
                continue;
            }
            //gather all of the interim fields into a single set to be queried
            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                //FUTURE TODO: add support for phone, email, and address capturing on staging record
                if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c)) {
                    if (sectionSetting.Staging_sObject_API_Name__c == MAIN_STAGING_RECORD_API_NAME) {
                        interimFields.add(fieldSetting.Staging_Record_Field_API_Name__c);
                    } else {
                        if (recordToFieldSetMap.containsKey(sectionSetting.Front_End_Section_Id__c)) {
                            if (recordToFieldSetMap.get(sectionSetting.Front_End_Section_Id__c).containsKey(sectionSetting.Staging_sObject_API_Name__c)) {
                                recordToFieldSetMap.get(sectionSetting.Front_End_Section_Id__c).get(sectionSetting.Staging_sObject_API_Name__c).add(fieldSetting.Staging_Record_Field_API_Name__c);
                            } else {
                                recordToFieldSetMap.get(sectionSetting.Front_End_Section_Id__c).put(sectionSetting.Staging_sObject_API_Name__c, new Set<String>{fieldSetting.Staging_Record_Field_API_Name__c});
                            }
                        } else {
                            recordToFieldSetMap.put(sectionSetting.Front_End_Section_Id__c, new Map<String, Set<String>>{sectionSetting.Staging_sObject_API_Name__c => new Set<String>{fieldSetting.Staging_Record_Field_API_Name__c}});
                        }

                    }
                }

            }

            if (sectionSetting.Staging_sObject_API_Name__c != MAIN_STAGING_RECORD_API_NAME && String.isNotBlank(sectionSetting.Staging_Record_Controlling_Parent_Field__c)) {
                String whereClause = ' WHERE ' + sectionSetting.Staging_Record_Controlling_Parent_Field__c + ' = :interimId';
                //add the filter cause if there is one
                if (String.isNotBlank(sectionSetting.Staging_Record_Where_Clause__c)) {
                    whereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Staging_Record_Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null}) + ' AND ' + sectionSetting.Staging_Record_Controlling_Parent_Field__c + ' = :interimId';
                }

                if (recordToWhereClause.containsKey(sectionSetting.Front_End_Section_Id__c)) {
                    recordToWhereClause.get(sectionSetting.Front_End_Section_Id__c).put(sectionSetting.Staging_sObject_API_Name__c, whereClause);
                } else {
                    recordToWhereClause.put(sectionSetting.Front_End_Section_Id__c, new Map<String, String>{sectionSetting.Staging_sObject_API_Name__c=> whereClause});
                }

            }


        }

        String interimQueryString = 'SELECT ' + String.join(new List<String>(interimFields), ', ') + ' FROM ' + MAIN_STAGING_RECORD_API_NAME + ' WHERE ucinn_ascendv2__Contact__c = :contactId '
                                    + ' AND ucinn_ascendv2__Status__c = \'' + INTERIM_DISPLAY_STATUS + '\' AND RecordType.DeveloperName = \'' + INTERIM_RECORD_TYPE_NAME +  '\'';

        //FUTURE TODO: should we try catch the database.query or allow the upper level to catch the error?
        List<ucinn_ascendv2__Interim__c> interimList = Database.query(interimQueryString);

        if (!interimList.isEmpty()) {
            returnMap.put(INTERIMS_FRONT_END_NAME, new Map<String, List<sObject>>{MAIN_STAGING_RECORD_API_NAME => interimList});
            Id interimId = interimList.get(0).Id;

            for (String sectionId : recordToFieldSetMap.keySet()) {
                Map<String, Set<String>> sectionMap = recordToFieldSetMap.get(sectionId);
                for (String sobjectName : sectionMap.keyset()) {
                    String queryString = 'SELECT ' + String.join(new List<String>(sectionMap.get(sobjectName)), ', ') +  ' FROM ' + sobjectName + ' '; // Note: Removed Id here and moved to CMT
                    if (recordToWhereClause.containsKey(sectionId) && recordToWhereClause.get(sectionId).containsKey(sobjectName)) {
                        queryString = queryString + recordToWhereClause.get(sectionId).get(sobjectName);
                        List<sObject> interimRecords = Database.query(queryString);
                        if (returnMap.containsKey(sectionId)) {
                            if (returnMap.get(sectionId).containsKey(sobjectName)) {
                                returnMap.get(sectionId).get(sobjectName).addAll(interimRecords);
                            } else {
                                returnMap.get(sectionId).put(sobjectName, interimRecords);
                            }
                        } else {
                            returnMap.put(sectionId, new Map<String, List<sObject>>{sobjectName => interimRecords});
                        }
                    }

                }

            }
        }

        // Move the spousal interim query here, not dependent on the Main interim so it doesnt not create another manual review interim
        //query for the manual review interim that contains the spousal information
        List<ucinn_ascendv2__Interim__c> spousalInterim = [SELECT ucinn_ascendv2__Significant_Other_First_Name__c, ucinn_ascendv2__Significant_Other_Last_Name__c, ucinn_ascendv2__Marital__c
                                                            FROM ucinn_ascendv2__Interim__c
                                                            WHERE ucinn_ascendv2__Contact__c = :contactId
                                                            AND ucinn_ascendv2__Status__c = :SPOUSAL_INTERIM_STATUS
                                                            AND ucinn_ascendv2__Manual_Review_Reason__c = :SPOUSAL_INTERIM_DESCRIPTION
                                                            AND RecordType.DeveloperName = :INTERIM_RECORD_TYPE_NAME];

        if (spousalInterim?.isEmpty() == false) {
            returnMap.put(SPOUSAL_INTERIM_KEY, new Map<String, List<sObject>>{MAIN_STAGING_RECORD_API_NAME => spousalInterim});
        }

        return returnMap;

    }

    /**
     * method that queries for all the interim records that were generated by this constituent from a previous profile
     * update that has not been approved yet. Required to display data in real time; however, if fields and records need to be
     * added, please update the custom metadata record instead
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param contactId:                    The id of the constituent linked to the interim
     * @param sectionSettingList:            The custom metadata records that contain information on how to query the interim records
     */
    private Map<String, Map<String, List<sObject>>> queryForSelfReportedInterimRecords(Id contactId, List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, Map<String, List<sObject>>> returnMap = new Map<String, Map<String, List<sObject>>>();
        Map<String, Map<String, Set<String>>> recordToFieldSetMap = new Map<String, Map<String, Set<String>>>();
        Map<String, Map<String, String>> recordToWhereClause = new Map<String, Map<String, String>>();
        Set<String> interimFields = new Set<String>{'ucinn_portal_Case__c'};
        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            if (String.isBlank(sectionSetting.Staging_sObject_API_Name__c)) {
                continue;
            }
            //gather all of the interim fields into a single set to be queried
            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                //FUTURE TODO: add support for phone, email, and address capturing on staging record
                if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c)) {
                    if (sectionSetting.Staging_sObject_API_Name__c == MAIN_STAGING_RECORD_API_NAME) {
                        interimFields.add(fieldSetting.Staging_Record_Field_API_Name__c);
                    } else {
                        if (recordToFieldSetMap.containsKey(sectionSetting.Front_End_Section_Id__c)) {
                            if (recordToFieldSetMap.get(sectionSetting.Front_End_Section_Id__c).containsKey(sectionSetting.Staging_sObject_API_Name__c)) {
                                recordToFieldSetMap.get(sectionSetting.Front_End_Section_Id__c).get(sectionSetting.Staging_sObject_API_Name__c).add(fieldSetting.Staging_Record_Field_API_Name__c);
                            } else {
                                recordToFieldSetMap.get(sectionSetting.Front_End_Section_Id__c).put(sectionSetting.Staging_sObject_API_Name__c, new Set<String>{fieldSetting.Staging_Record_Field_API_Name__c});
                            }
                        } else {
                            recordToFieldSetMap.put(sectionSetting.Front_End_Section_Id__c, new Map<String, Set<String>>{sectionSetting.Staging_sObject_API_Name__c => new Set<String>{fieldSetting.Staging_Record_Field_API_Name__c}});
                        }

                    }
                }

            }

            if (sectionSetting.Staging_sObject_API_Name__c != MAIN_STAGING_RECORD_API_NAME && String.isNotBlank(sectionSetting.Staging_Record_Controlling_Parent_Field__c)) {
                String whereClause = ' WHERE ' + sectionSetting.Staging_Record_Controlling_Parent_Field__c + ' = :interimId';
                //add the filter cause if there is one
                if (String.isNotBlank(sectionSetting.Staging_Record_Where_Clause__c)) {
                    whereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Staging_Record_Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null}) + ' AND ' + sectionSetting.Staging_Record_Controlling_Parent_Field__c + ' = :interimId';
                }

                if (recordToWhereClause.containsKey(sectionSetting.Front_End_Section_Id__c)) {
                    recordToWhereClause.get(sectionSetting.Front_End_Section_Id__c).put(sectionSetting.Staging_sObject_API_Name__c, whereClause);
                } else {
                    recordToWhereClause.put(sectionSetting.Front_End_Section_Id__c, new Map<String, String>{sectionSetting.Staging_sObject_API_Name__c=> whereClause});
                }

            }


        }

        String interimQueryString = 'SELECT ' + String.join(new List<String>(interimFields), ', ') + ' FROM ' + MAIN_STAGING_RECORD_API_NAME + ' WHERE ucinn_ascendv2__Contact__c = :contactId '
                                    + ' AND ucinn_ascendv2__Status__c = \'' + REPORT_UPDATE_INTERIM_STATUS + '\' AND RecordType.DeveloperName = \'' + REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME +  '\'';

        //FUTURE TODO: should we try catch the database.query or allow the upper level to catch the error?
        List<ucinn_ascendv2__Interim__c> interimList = Database.query(interimQueryString);
        mapInterimRecords(interimList, returnMap, recordToFieldSetMap, recordToWhereClause);

        return returnMap;

    }

    @TestVisible
    private void mapInterimRecords(List<ucinn_ascendv2__Interim__c> interimList, Map<String, Map<String, List<sObject>>> returnMap, Map<String, Map<String, Set<String>>> recordToFieldSetMap, Map<String, Map<String, String>> recordToWhereClause ) {
        if (!interimList.isEmpty()) {
            returnMap.put(INTERIMS_FRONT_END_NAME, new Map<String, List<sObject>>{MAIN_STAGING_RECORD_API_NAME => interimList});
            Id interimId = interimList.get(0).Id;

            for (String sectionId : recordToFieldSetMap.keySet()) {
                Map<String, Set<String>> sectionMap = recordToFieldSetMap.get(sectionId);
                for (String sobjectName : sectionMap.keyset()) {
                    String queryString = 'SELECT ' + String.join(new List<String>(sectionMap.get(sobjectName)), ', ') +  ' FROM ' + sobjectName + ' ';
                    if (recordToWhereClause.containsKey(sectionId) && recordToWhereClause.get(sectionId).containsKey(sobjectName)) {
                        queryString = queryString + recordToWhereClause.get(sectionId).get(sobjectName);
                        List<sObject> interimRecords = Database.query(queryString);
                        if (returnMap.containsKey(sectionId)) {
                            if (returnMap.get(sectionId).containsKey(sobjectName)) {
                                returnMap.get(sectionId).get(sobjectName).addAll(interimRecords);
                            } else {
                                returnMap.get(sectionId).put(sobjectName, interimRecords);
                            }
                        } else {
                            returnMap.put(sectionId, new Map<String, List<sObject>>{sobjectName => interimRecords});
                        }
                    }

                }

            }
        }
    }

    /**
     * method that takes an object from the front end that contains the constituent's edits
     * and saves the information to the backend
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param information:              Object that is a map that contains the updated information (very similar to the information map from the getter)
     */

    global virtual String saveInformation(Map<String, Object> params){
        //TODO: explain in user story that param name is information (include all keys in maps in user story)
        Object information = params.get('information');
        Case newCase = (Case) params.get('newCase');
        Boolean createCase = (Boolean) params.get('createCase');

        String errorMessage = '';
        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        if (cont != null) {

            Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap = new Map<String, Map<String, List<sObject>>>();

            List<Portal_Page_Section_Setting__mdt> sectionSettingList = this.queryPageSectionSettings('My Information');

            Map<String, String> sobjectNameToLabelMap = getLabels(sectionSettingList);

            if (information != null) {

                Map<String, Object> informationMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(information));

                Map<String, Map<String, Object>> mainSectionMap = createMainSectionToFrontEndFieldIdMap(sectionSettingList);
                Map<String, Object> recordMap = convertFrontEndRecordFieldsToBackEnd((Map<String, Object>) informationMap.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY), mainSectionMap);
                informationMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordMap);

                String interimSourceUrl = (String) informationMap.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
                PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);
                Map<String, List<sObject>> interimRecordMap =  new Map<String, List<sObject>>();

                Map<String, Object> convertedInterimRecordsMap = convertFrontEndRecordFieldsToApiNamesForInterim((Map<String, Object>) informationMap.get(INTERIM_RECORDS_KEY));
                if (convertedInterimRecordsMap?.isEmpty() == false) {
                    informationMap.put(INTERIM_RECORDS_KEY, convertedInterimRecordsMap);
                }

                //convert the object from the front end into interim records
                if (informationMap.containsKey(INTERIM_RECORDS_KEY)) {
                    Map<String, Object> interimRecords = (Map<String, Object>) informationMap.get(INTERIM_RECORDS_KEY);
                    for (String sectionId : interimRecords.keySet()) {
                        Map<String, Object> sectionMap = (Map<String, Object>) interimRecords.get(sectionId);
                        for (String sobjectType : sectionMap.keySet()) {
                            List<Object> recordList = (List<Object>) sectionMap.get(sobjectType);
                            if (!recordList.isEmpty()) {
                                if (sectionId == SPOUSAL_INTERIM_KEY) {
                                    interimRecordMap.put(sectionId, convertObjectTosObject(recordList, ucinn_ascendv2__Interim__c.class));
                                } else if (interimRecordMap.containsKey(sobjectType)) {
                                    List<SObject> existingInterimRecords = interimRecordMap.get(sobjectType);
                                    existingInterimRecords.addAll(convertObjectTosObject(recordList,  System.Type.forName(sobjectType)));
                                    interimRecordMap.put(sobjectType, existingInterimRecords);
                                } else {
                                    interimRecordMap.put(sobjectType, convertObjectTosObject(recordList,  System.Type.forName(sobjectType)));
                                }
                            } else {
                                if (!interimRecordMap.containsKey(sobjectType)) {
                                    interimRecordMap.put(sobjectType, new List<sObject>());
                                }
                            }
                        }
                    }

                }

                //used to compare what was originally saved versus new interim data in order to delete records the constituent deleted on the front end
                Map<String, Map<String, List<sObject>>> allInterimRecords = queryForInterimRecords(cont.Id, sectionSettingList);

                Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettingList);

                //contains records of all statuses that, used for finding duplicate records
                Map<String, Map<String, Map<String,List<Map<String, Object>>>>> allRecordsMap = new Map<String, Map<String, Map<String,List<Map<String, Object>>>>>{PORTAL_CONST_PageSectionSetting.RECORD_KEY => PORTAL_UTIL_PageSectionSetting.queryForRecords(cont.Id, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(), true, false)};
                //contains current records, used for "deleting" records the user deleted on the front end
                Map<String, Map<String, Map<String,List<Map<String, Object>>>>> currentRecordsMap = new Map<String, Map<String, Map<String,List<Map<String, Object>>>>>{PORTAL_CONST_PageSectionSetting.RECORD_KEY => PORTAL_UTIL_PageSectionSetting.queryForRecords(cont.Id, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(), false, false)};

                /*map of interim sobject name to the interim lookup id field, used for saving related interim records
                 *that need to look up to the interim during merge process. The interim sobject will have a controlling
                 *parent field to the contact
                 */
                Map<String, String> recordNameToInterimIdField = new Map<String, String>();
                Set<String> changeSet = new Set<String>();

                Map<Id, sObject> idToDuplicateObjectMap = new Map<Id, sObject>();

                if (informationMap.containsKey('Change_Set')) {
                    List<String> changeSetList = (List<String>) System.JSON.deserialize(System.JSON.serialize(informationMap.get('Change_Set')), List<String>.class);
                    changeSet = new Set<String>(changeSetList);
                }

                Contact contactWithSpecifiedFieldsToUpdate = new Contact(Id = cont.Id);
                //for each section see if the section was edited (will be contained in the Change_Set)
                for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {

                    if (String.isNotBlank(sectionSetting.Staging_sObject_API_Name__c) && String.isNotBlank(sectionSetting.Staging_Record_Controlling_Parent_Field__c)) {
                        recordNameToInterimIdField.put(sectionSetting.Staging_sObject_API_Name__c, sectionSetting.Staging_Record_Controlling_Parent_Field__c);
                    }

                    Boolean changed = false;
                    if (String.isNotBlank(sectionSetting.Page_Main_Section__c) && changeSet.contains(sectionSetting.Page_Main_Section__c)) {
                        changed = true;
                    }
                    if (String.isNotBlank(sectionSetting.Page_Sub_Section__c) && changeSet.contains(sectionSetting.Page_Sub_Section__c)) {
                        changed = true;
                    }
                    if (changed) {
                        //directory settings and directory opt out are updated in real time
                        //TODO explain in user story that directory settings, directory opt out, and spousal information are handled differently
                        if (sectionSetting.Page_Sub_Section__c == DIRECTORY_SETTING_NAME) {
                            updateDirectorySetting(new Map<String, Object>{PARAM_INFORMATION_MAP => informationMap, PARAM_CONTACT_ID => cont.Id});

                        } else if (sectionSetting.Page_Sub_Section__c == DIRECTORY_OPT_OUT_NAME) {
                            updateDirectoryOptOut(new Map<String, Object>{PARAM_INFORMATION_MAP => informationMap, PARAM_CONTACT_ID => cont.Id});
                        } else {
                            //start updating the records once we have all of the information
                            if (sectionSetting.SObject_API_Name__c == 'Contact') {
                                if (sectionSetting.Page_Sub_Section__c == SPOUSE_SUB_SECTION_NAME) {
                                    updateSpousalInformationIfNecessary(new Map<String, Object>{PARAM_INFORMATION_MAP => informationMap, PARAM_CONTACT_ID => cont.Id, PARAM_ALL_RECORDS_MAP => allRecordsMap, PARAM_INTERIM_RECORD_MAP => interimRecordMap, PARAM_ALL_INTERIM_RECORDS_MAP => allInterimRecords});
                                }
                                updateContactRecord(new Map<String, Object>{PARAM_CONTACT_ID => cont.Id, PARAM_SECTION_SETTING => sectionSetting, PARAM_INFORMATION_MAP => informationMap, PARAM_ALL_RECORDS_MAP => allRecordsMap, PARAM_CURRENT_RECORDS_MAP => currentRecordsMap, PARAM_INTERIM_RECORD_MAP => interimRecordMap, PARAM_CONTACT_WITH_SPECIFIED_FIELDS_TO_UPDATE => contactWithSpecifiedFieldsToUpdate});
                            } else {
                                updateRelatedRecords(new Map<String, Object>{PARAM_CONTACT_ID => cont.Id, PARAM_SECTION_SETTING => sectionSetting, PARAM_INFORMATION_MAP => informationMap,
                                                                             PARAM_ALL_RECORDS_MAP => allRecordsMap, PARAM_CURRENT_RECORDS_MAP => currentRecordsMap,
                                                                             PARAM_INTERIM_RECORD_MAP => interimRecordMap, PARAM_SOBJECT_NAME_TO_DML_OPERATION_MAP => sobjectNameToDmlOperationMap,
                                                                             PARAM_ALL_INTERIM_RECORDS_MAP => allInterimRecords, PARAM_ID_TO_DUPLICATE_OBJECT_MAP => idToDuplicateObjectMap});
                            }
                            updateFrontEndFieldRecords(sectionSetting, informationMap, allRecordsMap, interimRecordMap, sobjectNameToDmlOperationMap);

                        }

                    }
                }

                update contactWithSpecifiedFieldsToUpdate;

                for (String sObjectName : sobjectNameToDmlOperationMap.keyset()) {
                    Map<String, List<sObject>> dmlOperationMap = sobjectNameToDmlOperationMap.get(sObjectName);
                    errorMessage = performDMLOperations(dmlOperationMap, errorMessage, sobjectNameToLabelMap, sObjectName);
                }


                Map<String, Map<Id, sObject>> existingInterimRecordsToIdMap = new Map<String, Map<Id, sObject>>();
                Set<String> unchangedInterimRecordIdsSet = getUnchangedInterimRecordIdsSet(allInterimRecords, interimRecordMap, sectionSettingList); // needed to be added since previously, we just updated all the enhancement records without checking for changes

                //process the interim records if necsssary
                if (!interimRecordMap.isEmpty()) {
                    Id interimId = null;
                    Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap = new Map<String, ucinn_ascendv2__Address__c>();
                    ucinn_ascendv2__Interim__c interim = new ucinn_ascendv2__Interim__c();
                    if (interimRecordMap.containsKey(MAIN_STAGING_RECORD_API_NAME)) {
                        interim =  (ucinn_ascendv2__Interim__c) interimRecordMap.get(MAIN_STAGING_RECORD_API_NAME).get(0);
                    } else {
                        interim = new ucinn_ascendv2__Interim__c();
                    }

                    List<sObject> allRecordsList = null;
                    sObject constituentNameObjectFullName = null;

                    for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
                        if (sectionSetting.SObject_API_Name__c != 'ucinn_ascendv2__Contact_Name__c') {
                            continue;
                        }

                        allRecordsList = convertObjectTosObject(getRecords(sectionSetting, allRecordsMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c));
                    }

                    for (sObject eachRecord : allRecordsList) {
                        if (eachRecord.get('ucinn_ascendv2__Type__c') == 'Full Name') {
                            constituentNameObjectFullName = eachRecord;
                        }
                    }

                    Set<String> populatedSet = constituentNameObjectFullName.getPopulatedFieldsAsMap().keySet();

                    interim.ucinn_ascendv2__Contact__c = cont.Id;
                    interim.ucinn_ascendv2__Status__c = INTERIM_DISPLAY_STATUS;
                    interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(INTERIM_RECORD_TYPE_NAME).getRecordTypeId();
                    interim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();

                    if (interim.ucinn_portal_Case__c == null && createCase == true) {
                        if (newCase == null) {
                            List<Group> groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :CASE_GROUP_NAME LIMIT 1];

                            newCase = new Case(Origin= 'Portal',
                                                        Subject='A user has submitted changes to their bio information.',
                                                        Status='New',
                                                        Type = CASE_TYPE_NAME,
                                                        ContactId=cont.Id);

                            if (!groupList.isEmpty()) {
                                Id groupId = groupList.get(0).Id;
                                newCase.OwnerId = groupId;
                            }

                        }

                        insert newCase;
                        interim.ucinn_portal_Case__c = newCase.Id;
                    }

                    // Any blank fields should be replaced with IS_DELETED on the interim
                    Map<String, Object> interimAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(interim));
                    for (String eachField : interimAsMap.keySet()) {
                        if (!eachField.contains('__c')) {
                            continue;
                        }

                        if (eachField == 'ucinn_ascendv2__Prefix__c' || eachField == 'ucinn_ascendv2__Suffix__c') {
                            if (String.isBlank((String)interimAsMap.get(eachField)) && !populatedSet.contains(eachField)) {
                                continue;
                            }
                        } else if (eachField == 'ucinn_ascendv2__Business_Title__c') {
                            if (String.isBlank((String)interimAsMap.get(eachField)) && !populatedSet.contains('ucinn_ascendv2__Professional_Designation__c')) {
                                continue;
                            }
                        }

                        if (interimAsMap.get(eachField) != null && String.isBlank((String)interimAsMap.get(eachField))) {
                            interimAsMap.put(eachField, IS_DELETED);
                        }
                    }

                    interim = (ucinn_ascendv2__Interim__c) System.JSON.deserialize(System.JSON.serialize(interimAsMap), System.Type.forName(MAIN_STAGING_RECORD_API_NAME));
                    interimRecordMap.put(MAIN_STAGING_RECORD_API_NAME, new List<sObject>{interim});

                    upsert interim;
                    interimId = interim.Id;

                    for (String sobjectName : interimRecordMap.keySet()) {
                        List<sObject> interimRecordsToInsert = new List<sObject>();
                        List<sObject> interimRecordsToUpdate = new List<sObject>();
                        Map<String, String> objectNameToDummyContactFieldMap = this.getObjectNameToDummyContactFieldMap();
                        Map<String, String> objectNameToDummyOrganizationFieldMap = this.getObjectNameToDummyOrganizationFieldMap();

                        Id dummyContactId = null;
                        Id dummyOrganizationId = null;
                        //these sobjects need a master detail to contact and since they are going on interims, they must go to a dummy contact to be reparented upon approval
                        if (objectNameToDummyContactFieldMap.containsKey(sobjectName)) {
                            List<Contact> dummyContactList = [SELECT Id, AccountId FROM Contact WHERE FirstName = :DUMMY_CONTACT_FIRST_NAME AND LastName = :DUMMY_CONTACT_LAST_NAME];
                            if (dummyContactList.isEmpty()) {
                                // TODO Remove these and add error messages
                                Contact dummyContact = new Contact(FirstName = DUMMY_CONTACT_FIRST_NAME, LastName = DUMMY_CONTACT_LAST_NAME);
                                insert dummyContact;
                                dummyContactId = dummyContact.Id;
                                dummyOrganizationId = dummyContactList.get(0).AccountId;
                            } else {
                                dummyContactId = dummyContactList.get(0).Id;
                                dummyOrganizationId = dummyContactList.get(0).AccountId;
                            }
                        }

                        for (sObject record : interimRecordMap.get(sobjectName)) {
                            if (String.isBlank(record.Id)) {
                                if (sobjectName != SPOUSAL_INTERIM_KEY) {
                                    if (objectNameToDummyContactFieldMap.containsKey(sobjectName)) {
                                        record.put(objectNameToDummyContactFieldMap.get(sobjectName), dummyContactId);
                                    }

                                    if (objectNameToDummyOrganizationFieldMap.containsKey(sobjectName) && String.isBlank((String)record.get(objectNameToDummyOrganizationFieldMap.get(sobjectName)))) {
                                        record.put(objectNameToDummyOrganizationFieldMap.get(sobjectName), dummyOrganizationId);
                                    }
                                    record.put(recordNameToInterimIdField.get(sobjectName), interimId);
                                }
                                interimRecordsToInsert.add(record);
                            } else if (sobjectName == ADDRESS_RELATION_API_NAME) {
                                ucinn_ascendv2__Address__c address = (ucinn_ascendv2__Address__c)record.getSObject(ADDRESS_RELATIONSHIP).clone(false, false, false, false);
                                String hashCode = PORTAL_CommunityUtils.hashObjectFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_SOBJECT_TYPE => ((SObject) Type.forName(ADDRESS_API_NAME).newInstance()).getSObjectType(), PORTAL_CommunityUtils.PARAM_SOBJECT_RECORD => address});

                                address.ucinn_ascendv2__External_System_ID__c = hashCode;
                                hashCodeToAddressMap.put(hashCode, address);

                                Map<String, Object> recordAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(record));
                                recordAsMap.remove(ADDRESS_API_NAME);
                                recordAsMap.put(ADDRESS_RELATIONSHIP, new ucinn_ascendv2__Address__c(ucinn_ascendv2__External_System_Id__c = hashCode));

                                interimRecordsToUpdate.add((sObject) System.JSON.deserialize(System.JSON.serialize(recordAsMap), System.Type.forName(sobjectName)));
                            } else if (idToDuplicateObjectMap.containsKey(record.Id) == false && unchangedInterimRecordIdsSet.contains(record.Id) == false){  // when Has_Duplicate_Logic__c is checked and record has not been modified, we need to make sure we skip over the record in this loop so it doesnt inactivate it again
                                interimRecordsToUpdate.add(record);
                            }
                        }

                        if (!hashCodeToAddressMap.isEmpty()) {
                            upsert hashCodeToAddressMap.values() ucinn_ascendv2__Address__c.Fields.ucinn_ascendv2__External_System_ID__c;
                        }

                        if (!interimRecordsToInsert.isEmpty()) {
                            if (sobjectName != SPOUSAL_INTERIM_KEY) {
                                List<sObject> recordsToInsertWithoutRelationships = new List<sObject>();
                                for (sObject record : interimRecordsToInsert) {
                                    Map<String, Object> recordAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(record));
                                    Set<String> fields = new Set<String> (recordAsMap.keySet());

                                    for (String field : fields) {
                                        if (field.contains('__r') && field != ADDRESS_RELATIONSHIP) {
                                            recordAsMap.remove(field);
                                        }
                                    }
                                    recordsToInsertWithoutRelationships.add((sObject) System.JSON.deserialize(System.JSON.serialize(recordAsMap), System.Type.forName(sobjectName)));
                                }

                                insert recordsToInsertWithoutRelationships;
                            } else {
                                insert interimRecordsToInsert;
                            }
                        }
                        if (!interimRecordsToUpdate.isEmpty()) {
                            update interimRecordsToUpdate;
                            existingInterimRecordsToIdMap.put(sObjectName, new Map<Id, sObject>(interimRecordsToUpdate));
                        }
                    }
                }

                //check to see if interim records were deleted on the front end and delete them if so
                Map<String, List<sObject>> interimRecordsToDelete = new Map<String, List<sObject>>();
                Map<String, List<sObject>> interimRecordsToInactivate = new Map<String, List<sObject>>();
                List<Id> originalRecordIdsToDelete = new List<Id>();

                for (String sectionId : allInterimRecords.keySet()) {
                    Map<String, List<sObject>> sectionMap = allInterimRecords.get(sectionId);

                    for (String sObjectName  : sectionMap.keySet()) {
                        // skip if sObject is the main staging record (interim api name)
                        if (sObjectName == MAIN_STAGING_RECORD_API_NAME) {
                            continue;
                        }

                        Map<Id, sObject> existingInterimRecords = existingInterimRecordsToIdMap.get(sObjectName);

                        for (sObject eachRecord : sectionMap.get(sObjectName)) {
                            // we need to make sure we skip the record if its not been changed on the front end
                            Boolean isNotExistingRecord = (existingInterimRecords == null || !existingInterimRecords.containsKey(eachRecord.Id)) && !unchangedInterimRecordIdsSet.contains(eachRecord.Id);

                            // if the record has an original record field Id populated, inactivate the record or delete
                            // when Has_Duplicate_Logic__c is checked, we need to make sure we skip over the record in this loop so it doesnt delete it
                            if (String.isNotBlank((String)eachRecord.get(ORIGINAL_RECORD)) && isNotExistingRecord && !idToDuplicateObjectMap.containsKey(eachRecord.Id)) {
                                // go through portal page section to check if enhancement is configured
                                // to handle edge case (bad data) if record has original Id but enhancement is not configured
                                for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
                                    Boolean isObjectNameAndEnhancement = (sectionSetting.Staging_sObject_API_Name__c == sObjectName && isLinkRecordToInterim(new Map<String, Object>{PARAM_SECTION_SETTING => sectionSetting}));
                                    // inactivate if enhancement is configured and hard delete is off
                                    if (isObjectNameAndEnhancement && sectionSetting.Is_Hard_Delete_Records__c == false) {
                                        Map<String, Object> inactiveFieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Inactive_Record_Field_Map__c);

                                        for (String eachField : inactiveFieldMap.keySet()) {
                                            if (eachField.contains('End_Date')) {
                                                eachRecord.put(eachField, Date.today());
                                            } else {
                                                eachRecord.put(eachField, inactiveFieldMap.get(eachField));
                                            }

                                        }

                                        if (interimRecordsToInactivate.containsKey(sObjectName)) {
                                            interimRecordsToInactivate.get(sObjectName).add(eachRecord);
                                        } else {
                                            interimRecordsToInactivate.put(sObjectName, new List<sObject>{eachRecord});
                                        }

                                        break;
                                    } else if (isObjectNameAndEnhancement && sectionSetting.Is_Hard_Delete_Records__c == true) {
                                        if (interimRecordsToDelete.containsKey(sObjectName)) {
                                            interimRecordsToDelete.get(sObjectName).add(eachRecord);
                                        } else {
                                            interimRecordsToDelete.put(sObjectName, new List<sObject>{eachRecord});
                                        }

                                        originalRecordIdsToDelete.add((Id) eachRecord.get(ORIGINAL_RECORD));
                                        break;
                                    }
                                }
                            } else if (isNotExistingRecord && !idToDuplicateObjectMap.containsKey(eachRecord.Id)) { // when Has_Duplicate_Logic__c is checked, we need to make sure we skip over the record in this loop so it doesnt delete it
                                if (interimRecordsToDelete.containsKey(sObjectName)) {
                                    interimRecordsToDelete.get(sObjectName).add(eachRecord);
                                } else {
                                    interimRecordsToDelete.put(sObjectName, new List<sObject>{eachRecord});
                                }
                            }
                        }
                    }
                }

                // new delete logic for enhancement, if the record has an original Id lookup and enhancement configured, it should inactivate not delete
                for (String sObjectName : interimRecordsToInactivate.keySet()) {
                    update interimRecordsToInactivate.get(sObjectName);
                }

                for (String sObjectName : interimRecordsToDelete.keySet()) {
                    delete interimRecordsToDelete.get(sObjectName);
                }

                // should only occur when hard delete is checked, enhancement configured, and staging record has Original Record field populated
                if (!originalRecordIdsToDelete.isEmpty()) {
                    Database.delete(originalRecordIdsToDelete);
                }
            }

        }

        return errorMessage;
    }

    @TestVisible
    private String performDMLOperations(Map<String, List<SObject>> dmlOperationMap, String errorMessage, Map<String, String> sobjectNameToLabelMap, String sObjectName) {
        if (dmlOperationMap.containsKey(DELETE_KEY)) {
            Database.DeleteResult[] deleteResultList =  Database.delete(dmlOperationMap.get(DELETE_KEY), false);
            for (Database.DeleteResult result : deleteResultList) {
                if (!result.isSuccess()) {
                    if (String.isNotBlank(sobjectNameToLabelMap.get(sObjectName))) {
                        String error = 'There was a problem updating your ' + sobjectNameToLabelMap.get(sObjectName) + '.';
                        if (!errorMessage.contains(error)) {
                            errorMessage = errorMessage + ' ' + error;
                            break;
                        }
                    }
                }
            }
        }

        if (dmlOperationMap.containsKey(UPDATE_KEY)) {
            Database.SaveResult[] updateResultList = Database.update(dmlOperationMap.get(UPDATE_KEY), false);
            for (Database.SaveResult result : updateResultList) {
                if (!result.isSuccess()) {
                    if (String.isNotBlank(sobjectNameToLabelMap.get(sObjectName))) {
                        String error = 'There was a problem updating your ' + sobjectNameToLabelMap.get(sObjectName) + ' records.';
                        if (!errorMessage.contains(error)) {
                            errorMessage = errorMessage + ' ' + error;
                            break;
                        }
                    }
                }
            }
        }

        if (dmlOperationMap.containsKey(INSERT_KEY)) {
            Database.SaveResult[] insertResultList = Database.insert(dmlOperationMap.get(INSERT_KEY), false);
            for (Database.SaveResult result : insertResultList) {
                if (!result.isSuccess()) {
                    if (String.isNotBlank(sobjectNameToLabelMap.get(sObjectName))) {
                        String error = 'There was a problem updating your ' + sobjectNameToLabelMap.get(sObjectName) + ' records.';
                        if (!errorMessage.contains(error)) {
                            errorMessage = errorMessage + ' ' + error;
                            break;
                        }
                    }
                }
            }
        }
        return errorMessage;
    }

    private virtual Map<String, String> getLabels(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {

        Map<String, String> returnMap = new Map<String, String>();

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            if (String.isNotBlank(sectionSetting.SObject_API_Name__c) && String.isNotBlank(sectionSetting.Front_End_Section_Label__c)) {
                returnMap.put(sectionSetting.SObject_API_Name__c, sectionSetting.Front_End_Section_Label__c.toLowerCase());
            }
        }

        return returnMap;
    }

    /**
     * method that takes updates on the contact record and splits them between the necessary
     * interim fields or contact fields based on the custom metadata
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param params:           Map of params needed in this function
     */
    global virtual void updateContactRecord(Map<String, Object> params) {
        String birthDate = 'ucinn_ascendv2__Birthdate__c';

        Portal_Page_Section_Setting__mdt sectionSetting = (Portal_Page_Section_Setting__mdt) params.get(PARAM_SECTION_SETTING);
        Map<String, Object> informationMap = (Map<String, Object>) params.get(PARAM_INFORMATION_MAP);
        Map<String, Map<String, Map<String,List<Map<String, Object>>>>> allRecordsMap = (Map<String, Map<String, Map<String,List<Map<String, Object>>>>>) params.get(PARAM_ALL_RECORDS_MAP);
        Map<String, Map<String, Map<String,List<Map<String, Object>>>>>  currentRecordsMap = (Map<String, Map<String, Map<String,List<Map<String, Object>>>>>) params.get(PARAM_CURRENT_RECORDS_MAP);
        Map<String, List<sObject>> interimRecordMap = (Map<String, List<sObject>>) params.get(PARAM_INTERIM_RECORD_MAP);
        Contact contactWithSpecifiedFieldsToUpdate = (Contact) params.get(PARAM_CONTACT_WITH_SPECIFIED_FIELDS_TO_UPDATE);

        //get the contact object that was updated
        List<sObject> recordsListAssObject = convertObjectTosObject(getRecords(sectionSetting, informationMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c));
        List<sObject> allRecordsList = convertObjectTosObject(getRecords(sectionSetting, allRecordsMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c));
        Contact newContact = (Contact) recordsListAssObject.get(0);
        Contact oldContact = (Contact) allRecordsList.get(0);

        //create a new contact in order to update specific information
        Boolean isRelatedRecordOnInterim = isLinkRecordToInterim(new Map<String, Object>{PARAM_SECTION_SETTING => sectionSetting});

        for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
            if (String.isBlank(field.Field_API_Name__c) || field.Field_API_Name__c.contains('.') || field.Field_API_Name__c == MARITAL_STATUS
                || (newContact.get(field.Field_API_Name__c) == oldContact.get(field.Field_API_Name__c))
                || (String.isBlank((String) newContact.get(field.Field_API_Name__c)) && String.isBlank((String)oldContact.get(field.Field_API_Name__c)))) { // Need to make sure we do not add marital status
                continue;
            }

            //if we need to create an interim, update the existing interim or create a new one and add it to the interim map
            if (field.Is_Create_Staging_Record_On_Field_Change__c || sectionSetting.Is_Create_Staging_Record_Upon_Edit__c) {
                ucinn_ascendv2__Interim__c interimRecord = new ucinn_ascendv2__Interim__c();
                Boolean isMainInterimRecord = false;

                if (interimRecordMap.containsKey(MAIN_STAGING_RECORD_API_NAME)) {
                    interimRecord = (ucinn_ascendv2__Interim__c) interimRecordMap.get(MAIN_STAGING_RECORD_API_NAME).get(0);
                    isMainInterimRecord = true;
                }

                // TODO: function variables, dont hard code
                // Gender and Pronouns get modified here
                if (String.isNotBlank(field.Staging_Record_Field_API_Name__c)) {
                    if (field.Staging_Record_Field_API_Name__c == birthDate) {
                        if (newContact.get('ucinn_ascendv2__Birth_Day__c') != null && newContact.get('ucinn_ascendv2__Birth_Month__c') != null
                            && newContact.get('ucinn_ascendv2__Birth_Year__c') != null) {
                                Integer day = Integer.valueOf(newContact.get('ucinn_ascendv2__Birth_Day__c'));
                                Integer month = Integer.valueOf(newContact.get('ucinn_ascendv2__Birth_Month__c'));
                                Integer year = Integer.valueOf(newContact.get('ucinn_ascendv2__Birth_Year__c'));
                                interimRecord.put(field.Staging_Record_Field_API_Name__c, Date.newInstance(year, month, day));
                        } else if (newContact.get(birthDate) != null) {
                            interimRecord.put(field.Staging_Record_Field_API_Name__c, newContact.get(birthDate));
                        }
                    } else if (newContact.get(field.Field_API_Name__c) != interimRecord.get(field.Staging_Record_Field_API_Name__c)) {
                        interimRecord.put(field.Staging_Record_Field_API_Name__c, newContact.get(field.Field_API_Name__c));
                    }
                }
                interimRecordMap.put(MAIN_STAGING_RECORD_API_NAME, new List<sObject>{interimRecord});
            } else {
                //add the field to the contact instead
                contactWithSpecifiedFieldsToUpdate.put(field.Field_API_Name__c, newContact.get(field.Field_API_Name__c));
            }
        }
    }

    /**
     * method that updates sobject records that are associated with bio information
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param params:           Map of parameters needed for the function
     *
     */
    global virtual void updateRelatedRecords(Map<String, Object> params) {
        Id contactId = (Id) params.get(PARAM_CONTACT_ID);
        Portal_Page_Section_Setting__mdt sectionSetting = (Portal_Page_Section_Setting__mdt) params.get(PARAM_SECTION_SETTING);
        Map<String, Object> informationMap = (Map<String, Object>) params.get(PARAM_INFORMATION_MAP);
        Map<String, Map<String, Map<String,List<Map<String, Object>>>>> allRecordsMap = (Map<String, Map<String, Map<String,List<Map<String, Object>>>>>) params.get(PARAM_ALL_RECORDS_MAP);
        Map<String, Map<String, Map<String,List<Map<String, Object>>>>>  currentRecordsMap = (Map<String, Map<String, Map<String,List<Map<String, Object>>>>>) params.get(PARAM_CURRENT_RECORDS_MAP);
        Map<String, List<sObject>> interimRecordMap = (Map<String, List<sObject>>) params.get(PARAM_INTERIM_RECORD_MAP);
        Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap = (Map<String, Map<String, List<sObject>>>) params.get(PARAM_SOBJECT_NAME_TO_DML_OPERATION_MAP);

        Map<String, Map<String, List<sObject>>> allInterimRecords = (Map<String, Map<String, List<sObject>>>)params.get(PARAM_ALL_INTERIM_RECORDS_MAP);
        Map<Id, sObject> idToDuplicateObjectMap = (Map<Id, sObject>)params.get(PARAM_ID_TO_DUPLICATE_OBJECT_MAP);
        //convert the objects from the front end into the correlating sobject records
        List<sObject> recordsListAssObject = convertObjectTosObject(getRecords(sectionSetting, informationMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c));
        //convert backend records as well
        List<sObject> allRecordsList = convertObjectTosObject(getRecords(sectionSetting, allRecordsMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c));
        Map<Id, sObject> currentRecordToIdMap = new Map<Id, sObject>(convertObjectTosObject(getRecords(sectionSetting, currentRecordsMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c)));

        List<sObject> allInterimRecordsList = convertAllInterimMapToList(new Map<String, Object>{PARAM_ALL_INTERIM_RECORDS => allInterimRecords});

        List<sObject> interimRecordObjectList = convertFrontEndInterimToObjectList(sectionSetting.Staging_sObject_API_Name__c, interimRecordMap);


        Map<Id, sObject> allRecordToIdMap = new Map<Id, sObject>(allRecordsList);
        Map<Id, sObject> recordsToUpdate = new Map<Id, sObject>();
        Map<Id, sObject> recordsToActivate = new Map<Id, sObject>();
        Map<Id, sObject> recordsToDeactivate = new Map<Id, sObject>();
        List<sObject> recordsToInsert = new List<sObject>();
        Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap = new Map<String, ucinn_ascendv2__Address__c>();

        Map<String, String> duplicateLogicMap = new Map<String, String>();
        List<String> postFixExpressions = new List<String>();
        Set<String> fieldsForInterimLogic = new Set<String>();
        Set<String> fieldsForNewRecordLogic = new Set<String>();
        Map<String, Map<String, String>> fieldToConditionsMap = new Map<String, Map<String, String>>();

        getFieldsForUpdateRecordLogic(sectionSetting, duplicateLogicMap, fieldsForInterimLogic, fieldsForNewRecordLogic, fieldToConditionsMap);
        /*
        * duplicate logic is stored on the field level with the field order and field, we will need to make a map
        * of field order to field in order to quickly evaluate the duplication logic. The logic is held on the custom
        * metadata record and we must convert it into a postifx expression for easy evaluation
        */
        if (sectionSetting.Has_Duplicate_Logic__c && String.isNotBlank(sectionSetting.Duplicate_Field_Logic__c)) {
            postFixExpressions = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => sectionSetting.Duplicate_Field_Logic__c});

            checkDuplicateFrontEndInterims(interimRecordObjectList, postFixExpressions, duplicateLogicMap);
        }

        for (Integer eachRecordIndex = 0; eachRecordIndex < recordsListAsSObject.size(); eachRecordIndex++) {
            sObject record = recordsListAsSObject[eachRecordIndex];
            //if the record data is blank, then we will need to deactivate the record if it was an existing record
            if (checkNullRecord(new Map<String, Object>{PARAM_RECORD => record, PARAM_SECTION_SETTING => sectionSetting})) {
                if (String.isNotBlank(record.Id)) {
                    recordsToDeactivate.put(record.Id, allRecordToIdMap.get(record.Id));
                }
                continue;
            }

            if (String.isNotBlank(record.Id) 
                    && checkIfRecordsMatch(new Map<String, Object>{PARAM_NEW_RECORD => record, PARAM_OLD_RECORD => allRecordToIdMap.get(record.Id), PARAM_SECTION_SETTING => sectionSetting, PARAM_FIELD_SET => fieldsForNewRecordLogic})) {
                
                // need to check for if using interim related list enhancement because if we do, we should skip so the original record (the interim related record parent) does not get directly updated.
                if (isLinkRecordToInterim(new Map<String, Object>{PARAM_SECTION_SETTING => sectionSetting}) == false) {
                    recordsToUpdate.put(record.Id, record);
                }

                continue;
            }

            //if we have duplicate logic, try to find the duplicate record and update that record instead
            //TODO add to user story that if you populate the checkbox, you also need to populate the logic
            if (sectionSetting.Has_Duplicate_Logic__c && String.isNotBlank(sectionSetting.Duplicate_Field_Logic__c)) {
                Boolean foundDuplicate = false;
                for (sObject oldRecord : allRecordsList) {
                    if (oldRecord.Id != record.Id) {  // when editing or inserting records, check for a duplicate
                        if (dedupeRecords(new List<String>(postFixExpressions), duplicateLogicMap, record, oldRecord)) {
                            recordsToActivate.put(oldRecord.Id, oldRecord);
                            if (String.isNotBlank(record.Id)) {
                                recordsToDeactivate.put(record.Id, allRecordToIdMap.get(record.Id));
                            }
                            foundDuplicate = true;
                            break;
                        }
                    }

                }
                if (foundDuplicate) {
                    if (String.isBlank(sectionSetting.Active_Record_Field_Map__c)) {
                        continue;
                    }

                    // we determine the record as active if it meets the values set in the Active Record Field
                    // If the record is active when we try to insert a duplicate, we throw a user friendly, custom error message.
                    Boolean isActiveRecord = true;
                    Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Active_Record_Field_Map__c);

                    for (sObject eachRecord : recordsToActivate.values()) {
                        for (String eachField : fieldMap.keySet()) {
                            if (fieldMap.get(eachField) != eachRecord.get(eachField)) {
                                isActiveRecord = false;
                                break;
                            }
                        }

                        if (isActiveRecord == false) {
                            break;
                        }
                    }

                    if (isActiveRecord) {
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DUPLICATE_MESSAGE});
                    } else {
                        continue;
                    }
                }

                foundDuplicate = false;
                String recordName = record.getSObjectType().getDescribe().getName();

                for (sObject oldRecord : allInterimRecordsList) {
                    String oldRecordName = oldRecord.getSObjectType().getDescribe().getName();

                    if ((oldRecord.Id != record.Id) && (oldRecordName == recordName)) {  // when editing or inserting records, check for a duplicate
                        if (dedupeRecords(new List<String>(postFixExpressions), duplicateLogicMap, record, oldRecord)) {
                            recordsToActivate.put(oldRecord.Id, oldRecord);
                            idToDuplicateObjectMap.put(oldRecord.Id, oldRecord);
                            if (String.isNotBlank(record.Id)) {
                                recordsToDeactivate.put(record.Id, allRecordToIdMap.get(record.Id));
                            }
                            foundDuplicate = true;
                            break;
                        }
                    }

                }

                if (foundDuplicate) {
                    if (String.isBlank(sectionSetting.Active_Record_Field_Map__c)) {
                        continue;
                    }

                    // we determine the record as active if it meets the values set in the Active Record Field
                    // If the record is active when we try to insert a duplicate, we throw a user friendly, custom error message.
                    Boolean isActiveRecord = true;
                    Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Active_Record_Field_Map__c);

                    for (sObject eachRecord : idToDuplicateObjectMap.values()) {
                        for (String eachField : fieldMap.keySet()) {
                            if (fieldMap.get(eachField) != eachRecord.get(eachField)) {
                                isActiveRecord = false;
                                break;
                            }
                        }

                        if (isActiveRecord == false) {
                            break;
                        }
                    }

                    if (isActiveRecord) {
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DUPLICATE_MESSAGE});
                    } else {
                        continue;
                    }
                }

                for (Integer eachIndex = 0; eachIndex < recordsListAsSObject.size(); eachIndex++) {
                    if (eachIndex == eachRecordIndex) {
                        continue;
                    }

                    sObject currentRecord = recordsListAsSObject[eachIndex];
                    String currentRecordName = currentRecord.getSObjectType().getDescribe().getName();

                    if (currentRecordName == recordName) {  // when editing or inserting records, check for a duplicate
                        if (dedupeRecords(new List<String>(postFixExpressions), duplicateLogicMap, record, currentRecord)) {
                            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DUPLICATE_MESSAGE});
                        }
                    }
                }

                //findDuplicatesForInterimRecords(sObject, allInterimObjectList);
            }
            //we create the interim record if it has no id and if the custom metadata has it set up
            if (sectionSetting.Is_Create_Staging_Record_Upon_Creation__c) {
                if (String.isBlank(record.Id)) {
                    createInterimRecord(sectionSetting, interimRecordMap, (Map<String, Object>)System.JSON.deserializeUntyped(System.JSON.serialize(record)));
                    continue;
                }
            }
            //we create the interim record if the new record doesn't match the record we got from the backend
            if (sectionSetting.Is_Create_Staging_Record_Upon_Edit__c || sectionSetting.Is_Create_Staging_Record_Using_Fields__c) {
                Set<String> fieldsToCheck = new Set<String>();
                //if we updated specific fields, then we also need to create the interim if Is_Create_Staging_Record_Using_Fields__c is checked
                if (sectionSetting.Is_Create_Staging_Record_Using_Fields__c) {
                    fieldsToCheck = fieldsForInterimLogic;
                }
                if (String.isNotBlank(record.Id)) {
                    if (allRecordToIdMap.containsKey(record.Id)) {
                        if (((sectionSetting.Is_Create_Staging_Record_Upon_Edit__c  || fieldToConditionsMap.isEmpty()) && !checkIfRecordsMatch(new Map<String, Object> {PARAM_NEW_RECORD => record, PARAM_OLD_RECORD => allRecordToIdMap.get(record.Id), PARAM_SECTION_SETTING => sectionSetting, PARAM_FIELD_SET => fieldsToCheck}))
                            || evaluateStagingRecordFieldCondition(new Map<String, Object> {PARAM_NEW_RECORD => record, PARAM_FIELD_TO_CONDITIONS_MAP => fieldToConditionsMap})) {
                            createInterimRecord(sectionSetting, interimRecordMap, (Map<String, Object>)System.JSON.deserializeUntyped(System.JSON.serialize(record)));

                            if (!isLinkRecordToInterim(new Map<String, Object>{PARAM_SECTION_SETTING => sectionSetting})) {
                                recordsToDeactivate.put(record.Id, allRecordToIdMap.get(record.Id));
                            }
                            continue;
                        }
                    }
                } else {
                    if (evaluateStagingRecordFieldCondition(new Map<String, Object> {PARAM_NEW_RECORD => record, PARAM_FIELD_TO_CONDITIONS_MAP => fieldToConditionsMap})) {
                        createInterimRecord(sectionSetting, interimRecordMap, (Map<String, Object>)System.JSON.deserializeUntyped(System.JSON.serialize(record)));
                        continue;
                    }
                }

            }

            //TODO if field equals specific operators then create staging record


            //TODO delete fields on custom metadata and delete this section of code
            //if there is a specific condition such as Account id being blank, then create the interim record if the evaulation is true
            if (String.isNotBlank(sectionSetting.Create_Staging_Record_Condition_Field__c)) {

                if (PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => String.valueOf(record.get(sectionSetting.Create_Staging_Record_Condition_Field__c)), PORTAL_CommunityUtils.PARAM_SECOND_VALUE => sectionSetting.Create_Staging_Record_Condition_Value__c, PORTAL_CommunityUtils.PARAM_OPERATOR => sectionSetting.Create_Staging_Record_Condition_Operator__c})) {
                    createInterimRecord(sectionSetting, interimRecordMap, (Map<String, Object>)System.JSON.deserializeUntyped(System.JSON.serialize(record)));
                    continue;
                }

            }

            //if it is an address record, then we need to call the special logic or creating an address record
            if (sectionSetting.SObject_API_Name__c == ADDRESS_RELATION_API_NAME) {
                createAddressRecord(new Map<String, Object>{PARAM_CONTACT_ID => contactId, PARAM_NEW_RECORD => record.clone(false, false, false, false), PARAM_RECORDS_TO_INSERT => recordsToInsert, PARAM_RECORDS_TO_UPDATE => recordsToUpdate, PARAM_HASH_CODE_TO_ADDRESS_MAP => hashCodeToAddressMap, PARAM_SECTION_SETTING => sectionSetting});
                if (String.isNotBlank(record.Id)) {
                    recordsToDeactivate.put(record.Id, allRecordToIdMap.get(record.Id));
                }

            } else {
                //insert the record, update the record, or create a new record if necessary
                if (String.isBlank(record.Id)) {
                    if (String.isNotBlank(sectionSetting.Controlling_Parent_Field_API_Name__c)) {
                        record.put(sectionSetting.Controlling_Parent_Field_API_Name__c, contactId);
                        recordsToInsert.add(record);
                    }
                } else {
                    //if this is empty then the custom metadata configuration says that we don't want to capture historial data
                    if (fieldsForNewRecordLogic.isEmpty()) {
                        recordsToUpdate.put(record.Id, record);
                    } else {
                        //we want to capture historical data
                        if (!checkIfRecordsMatch(new Map<String, Object> {PARAM_NEW_RECORD => record, PARAM_OLD_RECORD => allRecordToIdMap.get(record.Id), PARAM_SECTION_SETTING => sectionSetting, PARAM_FIELD_SET => fieldsForNewRecordLogic})) {
                            recordsToDeactivate.put(record.Id, allRecordToIdMap.get(record.Id));
                            recordsToInsert.add(record.clone(false, false, false, false));
                        } else {
                            recordsToUpdate.put(record.Id, record);
                        }
                    }

                }

            }

        }

        //upsert the addresses that are needed for the address relation records
        if (!hashCodeToAddressMap.isEmpty()) {
            upsert hashCodeToAddressMap.values() ucinn_ascendv2__Address__c.Fields.ucinn_ascendv2__External_System_ID__c;
        }

        Map<Id, sObject> recordsToDelete = new Map<Id, sObject>();

        //check to see if the record was deleted on the front end by comparing what was originally retrieved for the front end code and remove it if it was
        for (Id recordId : currentRecordToIdMap.keySet()) {

            Boolean hasRecord = false;
            for (sObject frontEndRecord : recordsListAssObject) {
                if (String.isNotBlank(frontEndRecord.Id) && frontEndRecord.Id == recordId) {
                    hasRecord = true;
                }
            }
            //either hard delete the record if its set up in the custom metadata or update it with deactivated fields
            if (!hasRecord) {
                if (!sectionSetting.Is_Hard_Delete_Records__c) {
                    recordsToDeactivate.put(recordId, currentRecordToIdMap.get(recordId));
                } else {
                    recordsToDelete.put(recordId, currentRecordToIdMap.get(recordId));
                }

            }
        }

        if (!recordsToDelete.isEmpty()) {
            addRecordsToDeleteToMap(sobjectNameToDmlOperationMap, recordsToDelete, sectionSetting.SObject_API_Name__c);
        }

        if (!recordsToDeactivate.isEmpty()) {
            //custom metadata has a json of field to value that need to be set for every record that we don't want to show on the portal
            if (String.isNotBlank(sectionSetting.Inactive_Record_Field_Map__c)) {
                Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Inactive_Record_Field_Map__c);
                for (sObject record : recordsToDeactivate.values()) {
                    for (String field : fieldMap.keySet()) {
                        if (field.contains('End_Date')) {
                            record.put(field, Date.today());
                        } else {
                            record.put(field, fieldMap.get(field));
                        }

                    }
                }
            }
            if (sobjectNameToDmlOperationMap.containsKey(sectionSetting.SObject_API_Name__c)) {
                if (sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).containsKey(UPDATE_KEY)) {
                    sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).get(UPDATE_KEY).addAll(new List<sObject>(recordsToDeactivate.values()));
                } else {
                    sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).put(UPDATE_KEY, new List<sObject>(recordsToDeactivate.values()));
                }
            } else {
                sobjectNameToDmlOperationMap.put(sectionSetting.SObject_API_Name__c, new Map<String, List<sObject>>{UPDATE_KEY => new List<sObject>(recordsToDeactivate.values())});
            }
        }

        if (!recordsToActivate.isEmpty()) {
            //custom metadata has a json of field to value that need to be set for every record that we want to show on the portal
            if (String.isNotBlank(sectionSetting.Active_Record_Field_Map__c)) {
                Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Active_Record_Field_Map__c);
                for (sObject record : recordsToActivate.values()) {
                    for (String field : fieldMap.keySet()) {
                        record.put(field, fieldMap.get(field));
                    }
                }
            }
            if (sobjectNameToDmlOperationMap.containsKey(sectionSetting.SObject_API_Name__c)) {
                if (sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).containsKey(UPDATE_KEY)) {
                    sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).get(UPDATE_KEY).addAll(new List<sObject>(recordsToActivate.values()));
                } else {
                    sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).put(UPDATE_KEY, new List<sObject>(recordsToActivate.values()));
                }
            } else {
                sobjectNameToDmlOperationMap.put(sectionSetting.SObject_API_Name__c, new Map<String, List<sObject>>{UPDATE_KEY => new List<sObject>(recordsToActivate.values())});
            }

        }

        if (!recordsToInsert.isEmpty()) {
            if (String.isNotBlank(sectionSetting.Controlling_Parent_Field_API_Name__c)) {

                //need to remove the relationship fields because you cannot update the object if they are there
                List<sObject> recordsToInsertWithoutRelationships = new List<sObject>();


                Map<String, Object> fieldMap = new Map<String, Object>();
                //custom metadata has a json of field to value that need to be set for every record that we want to show on the portal
                if (String.isNotBlank(sectionSetting.Active_Record_Field_Map__c)) {
                    fieldMap =  (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Active_Record_Field_Map__c);
                }
                for (sObject record : recordsToInsert) {
                    record.put(sectionSetting.Controlling_Parent_Field_API_Name__c, contactId);
                    for (String field : fieldMap.keySet()) {
                        record.put(field, fieldMap.get(field));
                    }

                    Map<String, Object> recordAsMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(record));

                    Set<String> fields = new Set<String> (recordAsMap.keySet());
                    for (String field : fields) {
                        if (field.contains('__r') && field != 'ucinn_ascendv2__Address__r') {
                            recordAsMap.remove(field);
                        }
                    }

                    if (String.isNotBlank(sectionSetting.Record_Type_Developer_Name__c)) {
                        Schema.RecordTypeInfo recordTypeInfo =  Schema.getGlobalDescribe().get(record.getSObjectType().getDescribe().getName()).getDescribe().getRecordTypeInfosByDeveloperName().get(sectionSetting.Record_Type_Developer_Name__c);
                        if (recordTypeInfo == null) {
                            System.debug('PORTAL_MyInformationControllerBase updateRelatedRecords record type name is wrong for section ' + sectionSetting.Label);
                        } else {
                            recordAsMap.put('RecordTypeId', recordTypeInfo.getRecordTypeId());
                        }
                    }
                    recordsToInsertWithoutRelationships.add((sObject) System.JSON.deserialize(System.JSON.serialize(recordAsMap), System.Type.forName(sectionSetting.SObject_API_Name__c)));
                }

                if (sobjectNameToDmlOperationMap.containsKey(sectionSetting.SObject_API_Name__c)) {
                    if (sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).containsKey(INSERT_KEY)) {
                        sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).get(INSERT_KEY).addAll(recordsToInsertWithoutRelationships);
                    } else {
                        sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).put(INSERT_KEY, recordsToInsertWithoutRelationships);
                    }
                } else {
                    sobjectNameToDmlOperationMap.put(sectionSetting.SObject_API_Name__c, new Map<String, List<sObject>>{INSERT_KEY => recordsToInsertWithoutRelationships});
                }
            }

        }

        if (!recordsToUpdate.isEmpty()){
            if (sobjectNameToDmlOperationMap.containsKey(sectionSetting.SObject_API_Name__c)) {
                if (sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).containsKey(UPDATE_KEY)) {
                    sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).get(UPDATE_KEY).addAll(new List<sObject>(recordsToUpdate.values()));
                } else {
                    sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).put(UPDATE_KEY, new List<sObject>(recordsToUpdate.values()));
                }
            } else {
                sobjectNameToDmlOperationMap.put(sectionSetting.SObject_API_Name__c, new Map<String, List<sObject>>{UPDATE_KEY => new List<sObject>(recordsToUpdate.values())});
            }

        }



    }

    @TestVisible
    private void addRecordsToDeleteToMap(Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap, Map<Id, sObject> recordsToDelete, String sObjectName) {
        if (sobjectNameToDmlOperationMap.containsKey(sObjectName)) {
            if (sobjectNameToDmlOperationMap.get(sObjectName).containsKey(DELETE_KEY)) {
                sobjectNameToDmlOperationMap.get(sObjectName).get(DELETE_KEY).addAll(new List<sObject>(recordsToDelete.values()));
            } else {
                sobjectNameToDmlOperationMap.get(sObjectName).put(DELETE_KEY, new List<sObject>(recordsToDelete.values()));
            }
        } else {
            sobjectNameToDmlOperationMap.put(sObjectName, new Map<String, List<sObject>>{DELETE_KEY => new List<sObject>(recordsToDelete.values())});
        }
    }

    /**
     * method that takes the field mapping and gets the corresponding list of records from the map that was passed to the front end
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param sectionSetting:                   The custom metadata record that contains the data needed to pull the information
     * @param informationMap:                   The map that contains the list of records, based on the structure from the getConstituentInformation function
     * @param getFrontEndFieldsRecordsOnly:     Boolean that tells us that we want to pull out records that have lwc wrapper fields that need to be put into an interim
     *
     *
     * @return:                         List of objects that represent bio information records
     */
    private List<Object> getRecords(Portal_Page_Section_Setting__mdt sectionSetting, Map<String, Object> informationMap, Boolean getFrontEndFieldsRecordsOnly) {
        Set<String> frontEndFieldSet = new Set<String>();
        List<Object> returnList = new List<Object>();
        //get the list of front end fields if necessary
        for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
            if (field.Front_End_Field_Only__c && String.isNotBlank(field.Front_End_Field_Id__c)) {
                frontEndFieldSet.add(field.Front_End_Field_Id__c);
            }
        }
        Map<String, Object> recordMap = (Map<String, Object>) informationMap.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
        if (recordMap != null) {
            if (String.isNotBlank(sectionSetting.Page_Main_Section__c)) {
                Map<String, Object> mainSection = (Map<String, Object>) recordMap.get(sectionSetting.Page_Main_Section__c);
                List<Object> recordsList = new List<Object>();
                if (String.isNotBlank(sectionSetting.Page_Sub_Section__c)) {
                    recordsList = (List<Object>) mainSection.get(sectionSetting.Page_Sub_Section__c);
                    //remove the preferred spouse since it cannot be deserialized
                    if (sectionSetting.Page_Sub_Section__c == SPOUSE_SUB_SECTION_NAME) {
                        List<Object> processedRecordsList = new List<Object>();
                        for (Object record : recordsList) {
                            Map<String, Object> recordToProcess = (Map<String, Object>) record;
                            recordToProcess.remove(PREFERRED_SPOUSE);
                            processedRecordsList.add(recordToProcess);
                        }
                        recordsList = processedRecordsList;
                    }
                } else {
                    recordsList = (List<Object>) mainSection.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
                }
                if (!frontEndFieldSet.isEmpty()) {
                    for (Object record : recordsList) {
                        Map<String, Object> recordAsMap = (Map<String, Object>) record;
                        //get the fields that have front end data and pull them out to make the interim, else return it with the list
                        Boolean isFrontEndFieldRecord = false;
                        for (String field : frontEndFieldSet) {
                            if (recordAsMap.containsKey(field) && String.isNotBlank((String)recordAsMap.get(field))) {
                                if (getFrontEndFieldsRecordsOnly) {
                                    returnList.add(record);
                                    isFrontEndFieldRecord = true;
                                    break;
                                }
                            }
                        }
                        if (!isFrontEndFieldRecord && !getFrontEndFieldsRecordsOnly) {
                            for (String fieldToRemove : frontEndFieldSet) {
                                recordAsMap.remove(fieldToRemove);
                            }
                            returnList.add(recordAsMap);
                        }
                    }
                } else {
                    if (getFrontEndFieldsRecordsOnly) {
                        return returnList;
                    } else {
                        return recordsList;
                    }
                }
            }
        }
        return returnList;
    }

    /**
     * method that converts a list of objects into sobjects of the specified type through deserialization
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param records:         List objects that need to be converted
     * @param sObjectType:     The sobject type that the objects need to be converted to
     * @return:                The list of converted sObjects
     */

     //update this to allow other users to handle special cases like address
    global virtual List<sObject> convertObjectTosObject(List<Object> records, System.Type sObjectType) {
        List<sObject> returnedRecords = new List<sObject>();

        if (records != null) {
            for (Object record : records) {
                if (sObjectType.getName() == ADDRESS_RELATION_API_NAME) {
                    Map<String, Object> addressRecord = (Map<String, Object>) record;
                    Map<String, Object> address = (Map<String, Object>) addressRecord.get(ADDRESS_RELATIONSHIP);
                    addressRecord.remove(ADDRESS_RELATIONSHIP);
                    sObject addressAsSObject = (sObject) System.JSON.deserialize(System.JSON.serialize(address), System.Type.forName(ADDRESS_API_NAME));
                    sObject addressRelationAsSObject = (sObject) System.JSON.deserialize(System.JSON.serialize(addressRecord), sObjectType);
                    addressRelationAsSObject.putSObject(ADDRESS_RELATIONSHIP, addressAsSObject);
                    returnedRecords.add(addressRelationAsSObject);
                } else {
                    returnedRecords.add((sObject) System.JSON.deserialize(System.JSON.serialize(record), sObjectType));
                }

            }
        }

        return returnedRecords;
    }


    /**
     * method that takes the duplicate logic and evaluates the newest record against an old record to see if the old
     * record can be considered a duplicate of the newest record
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param postfixExpressions:           The set of strings of the duplicate logic in the postfix version
     * @param duplicateLogicMap:            Field order to field name for evaulating the duplicate logic
     * @param newRecord:                    The record that we got from the front end
     * @param oldRecord:                    The old record that currently exists in the backend
     *
     * @return:                             The boolean of whether or not the records match
     *
     */
    //TODO for all the breaks, add a system debug to tell the developer that the dedupe logic is wrong
    @TestVisible
    private Boolean dedupeRecords(List<String> postfixExpressions,Map<String, String> duplicateLogicMap, sObject newRecord, sObject oldRecord) {

        if (postFixExpressions.size() == 1) {
            if (postFixExpressions.get(0).isNumeric() && duplicateLogicMap.containsKey(postFixExpressions.get(0))) {
                return evaluateFilterCriteria(new Map<String, Object>{PARAM_NEW_RECORD => newRecord, PARAM_OLD_RECORD => oldRecord, PARAM_FIELD => duplicateLogicMap.get(postFixExpressions.get(0))});
            }
        //if there are multiple criteria then evaluate the criteria in the correct order
        } else if (postFixExpressions.size() > 1) {
            List<Boolean> stack = new List<Boolean>();
            while (postFixExpressions.size() > 0) {
                //postfix is evaluated by first finding an operator and then evaluating the two previous criteria using the operator
                for (Integer postFixIndex = 0; postFixIndex < postFixExpressions.size(); postFixIndex++) {
                    if (postFixExpressions.get(postFixIndex) == 'OR' || postFixExpressions.get(postFixIndex) == 'AND') {
                        //if there is no criteria before the operator then clear everything and break
                        //must clear the postFixExpressions to stop the while loop
                        //must clear the stack to indicate a bad result
                        //must stop evaluating because you have bad filter logic

                        if (postFixIndex - 1 < 0) {
                            postFixExpressions.clear();
                            stack.clear();
                            break;
                        //if you have no criteria two indices before the operator then you must use the most recent
                        //evaluation result. if there is no result then this in an error because your logic is bad and
                        //looks something like '1 AND'
                        } else if (postFixIndex - 2 < 0 && stack.size() == 0) {
                            postFixExpressions.clear();
                            stack.clear();
                            break;
                        } else {
                            //you can evaluate your criteria
                            Integer indexOfFirstOperand = postFixIndex - 1;

                            //stops evaluating because your logic looks something like 'AND AND AND'
                            //which cannot be evaulated
                            if (!postFixExpressions.get(indexOfFirstOperand).isNumeric()) {
                                postFixExpressions.clear();
                                stack.clear();
                                break;
                            }

                            Integer indexOfSecondOperand = postFixIndex - 2;

                            //the second operand exists within the expression and should be evaulated
                            if (indexOfSecondOperand >= 0) {

                                //stops evaluating because your logic looks something like 'AND AND AND'
                                //which cannot be evaulated
                                if (!postFixExpressions.get(indexOfSecondOperand).isNumeric()) {
                                    postFixExpressions.clear();
                                    stack.clear();
                                    break;
                                }
                                //evaluates the criteria and adds the result to the stack
                                Boolean evaluationOfFirstOperand = evaluateFilterCriteria(new Map<String, Object>{PARAM_NEW_RECORD => newRecord, PARAM_OLD_RECORD => oldRecord, PARAM_FIELD => duplicateLogicMap.get(postFixExpressions.get(indexOfFirstOperand))});

                                Boolean evaluationOfSecondOperand = evaluateFilterCriteria(new Map<String, Object> {PARAM_NEW_RECORD => newRecord, PARAM_OLD_RECORD => oldRecord, PARAM_FIELD => duplicateLogicMap.get(postFixExpressions.get(indexOfSecondOperand))});
                                if (postFixExpressions.get(postFixIndex) == 'OR') {
                                    stack.add((evaluationOfFirstOperand || evaluationOfSecondOperand));
                                } else if (postFixExpressions.get(postFixIndex) == 'AND') {
                                    stack.add((evaluationOfFirstOperand && evaluationOfSecondOperand));
                                }
                                //removes the criteria that was just evaluated from the list of expressions to evaluate
                                //breaks here to start the evaluation at the beginning after the removal of the old expressions

                                postFixExpressions.remove(postFixIndex);
                                postFixExpressions.remove(indexOfFirstOperand);
                                postFixExpressions.remove(indexOfSecondOperand);
                                break;
                            } else {
                                //evaulates the first criteria against the last result
                                Boolean evaluationOfFirstOperand = evaluateFilterCriteria(new Map<String, Object>{PARAM_NEW_RECORD => newRecord,
                                                                                            PARAM_OLD_RECORD => oldRecord,
                                                                                            PARAM_FIELD => duplicateLogicMap.get(postFixExpressions.get(indexOfFirstOperand))});
                                Boolean evaluationOfSecondOperand = stack.get(0);
                                stack.clear();
                                if (postFixExpressions.get(postFixIndex) == 'OR') {
                                    stack.add((evaluationOfFirstOperand || evaluationOfSecondOperand));
                                } else if (postFixExpressions.get(postFixIndex) == 'AND') {
                                    stack.add((evaluationOfFirstOperand && evaluationOfSecondOperand));
                                }
                                //removes the criteria that was just evaluated from the list of expressions to evaluate
                                //breaks here to start the evaluation at the beginning after the removal of the old expressions
                                postFixExpressions.remove(postFixIndex);
                                postFixExpressions.remove(indexOfFirstOperand);
                                break;
                            }
                        }
                    //if you've reached the end of your expression but there was no operator
                    //stop all evaluations
                    } else if (postFixIndex == postFixExpressions.size() - 1) {
                        postFixExpressions.clear();
                        stack.clear();
                        break;
                    }
                }
            }
            //if the evaluations succeeded and the result was true
            //add the filter id to the set of ids to return
            if (stack.size() == 1 && stack.get(0) == true) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }

    /**
     * method that evaluates if the new record's field matches the old record's field
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param newRecord:               The new record that was updated on the front end
     * @param oldRecord:               The old record we are comparing it to
     * @param field:                   The field name we are evaluating
     *
     *@return:                         Boolean of if the field matches for both records
     *
     */

    global virtual Boolean evaluateFilterCriteria(Map<String, Object> params) {

        sObject newRecord = (sObject) params.get(PARAM_NEW_RECORD);
        sObject oldRecord = (sObject) params.get(PARAM_OLD_RECORD);
        String field = (String) params.get(PARAM_FIELD);

        if (field.contains('.')) {
            List<String> fields = field.split('\\.');
            if (newRecord.getSObject(fields.get(0)) == null && oldRecord.getSObject(fields.get(0)) == null) {
                return true;
            } else if ((newRecord.getSObject(fields.get(0)) == null && oldRecord.getSObject(fields.get(0)) != null)
                       || (newRecord.getSObject(fields.get(0)) != null && oldRecord.getSObject(fields.get(0)) == null) ) {
                return false;
            } else {
                sObject parentRecordOfNewRecord = newRecord;
                sObject parentRecordofOldRecord = oldRecord;
                Object newRecordValue =  null;
                Object oldRecordValue = null;
                for (Integer index = 0; index < fields.size(); index++) {
                    if (index == fields.size()-1) {
                        if (parentRecordOfNewRecord != null) {
                            newRecordValue = parentRecordOfNewRecord.get(fields.get(index));
                        }
                        if (parentRecordofOldRecord != null) {
                            oldRecordValue = parentRecordofOldRecord.get(fields.get(index));
                        }
                    } else {
                        if (parentRecordOfNewRecord != null) {
                            parentRecordOfNewRecord = parentRecordOfNewRecord.getSObject(fields.get(index));
                        }
                        if (parentRecordofOldRecord != null) {
                            parentRecordofOldRecord = parentRecordofOldRecord.getSObject(fields.get(index));
                        }
                    }
                }
                if (newRecordValue == null && oldRecordValue == null) {
                    return true;
                } else if ((newRecordValue != null && String.isNotBlank(String.valueOf(newRecordValue)) && oldRecordValue == null) || newRecordValue == null && oldRecordValue != null && String.isNotBlank(String.valueOf(oldRecordValue))) {
                    return false;
                } else if ((newRecordValue != null && String.isBlank(String.valueOf(newRecordValue)) && oldRecordValue == null) || newRecordValue == null && oldRecordValue != null && String.isBlank(String.valueOf(oldRecordValue))) {
                    return true;
                } else {
                    return String.valueOf(newRecordValue) == String.valueOf(oldRecordValue);
                }
            }
        } else {
            Object newRecordValue =  newRecord?.get(field);
            Object oldRecordValue = oldRecord?.get(field);
            if (newRecordValue == null && oldRecordValue == null) {
                return true;
            } else if ((newRecordValue != null && String.isNotBlank(String.valueOf(newRecordValue)) && oldRecordValue == null) || newRecordValue == null && oldRecordValue != null && String.isNotBlank(String.valueOf(oldRecordValue))) {
                return false;
            } else if ((newRecordValue != null && String.isBlank(String.valueOf(newRecordValue)) && oldRecordValue == null) || newRecordValue == null && oldRecordValue != null && String.isBlank(String.valueOf(oldRecordValue))) {
                return true;
            } else {
                return String.valueOf(newRecordValue) == String.valueOf(oldRecordValue);
            }
        }

    }

    /**
     * method that adds the record fields to the staging records
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param stagingRecord:    The interim record being updated (can be ucinn_ascendv2__Interim__c or the related interim object)
     * @param newRecord:        The updated record being added
     * @param sectionSetting:   The metadata that contains the mapping of object fields to interim fields
     */
    private void addFieldsToStagingRecord (sObject stagingRecord, Map<String, Object> newRecord, Portal_Page_Section_Setting__mdt sectionSetting) {
        //add all the fields to the interim
        for(Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
            if (fieldSetting.Staging_Record_Field_API_Name__c == ORIGINAL_RECORD) {  // this needs to be filtered out so it does not set this value
                continue;
            }
            addFieldToRecord(fieldSetting, newRecord, stagingRecord);
        }

    }

    @TestVisible
    private void addFieldToRecord(Portal_Section_Field_Setting__mdt fieldSetting, Map<String, Object> newRecord, SObject stagingRecord) {
        if (String.isBlank(fieldSetting.Staging_Record_Field_API_Name__c) || fieldSetting.Staging_Record_Field_API_Name__c.contains('.')) {
            return;
        }

        /*make sure the right record is being used to populate the staging record field, used for sections that have the same records that
         * populate different staging record fields*/
        if (String.isBlank(fieldSetting.Filter_Field__c) || PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE =>  newRecord.get(fieldSetting.Filter_Field__c), PORTAL_CommunityUtils.PARAM_SECOND_VALUE => fieldSetting.Filter_Value__c, PORTAL_CommunityUtils.PARAM_OPERATOR => fieldSetting.Filter_Operator__c})) {
             /*the static interim value is used to add values that are specific to the interim
            and does not correlate to the sobject field. For example, the is preferred is a boolean,
            but the is preferred on the interim is a picklist field*/
            if (String.isNotBlank(fieldSetting.Static_Value_For_Staging_Field__c)) {
                //string conversion of booleans since String.valueOf can return the boolean string in a way that we cannot do a comparison
                String fieldValueAsString = '' + newRecord.get(fieldSetting.Field_API_Name__c);

                /*checks to see if the record's boolean value matches the value for the interim field
                must use strings since the boolean values being checked are true, false, and null
                then it checks to see if there is an old record. If there are old records,
                only add the fields to the interim if the old record and new record field values
                are not the same*/
                if(fieldValueAsString.equals(fieldSetting.Staging_Field_Population_Condition_Value__c)) {
                    stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, fieldSetting.Static_Value_For_Staging_Field__c);

                }
            } else {
                //checks for parent relationship fields
                if (String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                    if (fieldSetting.Field_API_Name__c.contains('.')) {
                        List<String> fields = fieldSetting.Field_API_Name__c.split('\\.');
                        if (fields.size() < 2) {
                            System.debug('PORTAL_MyInformationControllerBase addFieldsToStagingRecord field name is wrong for ' + fieldSetting.Label + ' for field ' + fieldSetting.Field_API_Name__c);
                            return;
                        } else {
                            Map<String, Object> parentRecord = newRecord;
                            for (Integer index = 0; index < fields.size(); index++) {
                                if (index == fields.size()-1) {
                                    if (parentRecord != null) {
                                        stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, parentRecord.get(fields.get(index)));
                                    } else {
                                        stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, null);
                                    }
                                } else {
                                    if (parentRecord != null) {
                                        parentRecord = (Map<String, Object>) parentRecord.get(fields.get(index));
                                    } else {
                                        stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, null);
                                        return;
                                    }
                                }
                            }
                        }

                    } else {
                        //must check type because the types will always be the same and wouldn't be added to the interim otherwise
                        if (fieldSetting.Field_Type__c == PORTAL_CONST_PageSectionSetting.CHECKBOX_FIELD_NAME && newRecord.get(fieldSetting.Field_API_Name__c) == null) {
                            stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, false);
                        } else if (fieldSetting.Field_Type__c == PORTAL_CONST_PageSectionSetting.DATE_FIELD_NAME && newRecord.get(fieldSetting.Field_API_Name__c) != null && String.isNotBlank(String.valueOf(newRecord.get(fieldSetting.Field_API_Name__c)))) {
                            stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, Date.valueOf(String.valueOf(newRecord.get(fieldSetting.Field_API_Name__c)) + ' 00:00:00'));
                        } else if (!fieldSetting.Staging_Record_Field_API_Name__c.contains(FORMULA_CONST) && newRecord.containsKey(fieldSetting.Field_API_Name__c)) {  //if staging records contains formula api name, do not put it in staging record or an apex exception will occur
                            stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, newRecord.get(fieldSetting.Field_API_Name__c));
                        }
                    }
                } else if (String.isNotBlank(fieldSetting.Front_End_Field_Id__c)) {
                    if (fieldSetting.Field_Type__c == PORTAL_CONST_PageSectionSetting.CHECKBOX_FIELD_NAME && newRecord.get(fieldSetting.Front_End_Field_Id__c) == null) {
                        stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, false);
                    } else {
                        stagingRecord.put(fieldSetting.Staging_Record_Field_API_Name__c, newRecord.get(fieldSetting.Front_End_Field_Id__c));
                    }

                }

            }
        }
    }

    /**
     * method that maps fields to an interim record
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param sectionSetting:         The custom metadata record taht contains the infomration needed to create/update the interim records
     * @param interimRecordMap:     The map that contains the list of interim records to upsert to the interim sobject name
     * @param originalRecord:            The record that was updated on the front end and must be translated to the sobject
     */

    private void createInterimRecord(Portal_Page_Section_Setting__mdt sectionSetting, Map<String, List<sObject>> interimRecordMap, Map<String, Object> originalRecord) {
        sObject relatedInterimRecord;
        List<sObject> recordsToInsert = new List<sObject>();
        Map<Id, sObject> recordsToUpdate = new Map<Id, sObject>();
        Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap = new Map<String, ucinn_ascendv2__Address__c>();

        if (String.isBlank(sectionSetting.Staging_sObject_API_Name__c)) {
            return;
        }
        //get the correct sobject record
        if (sectionSetting.Staging_sObject_API_Name__c.equals(MAIN_STAGING_RECORD_API_NAME)) {
            if (interimRecordMap.containsKey(MAIN_STAGING_RECORD_API_NAME) && !interimRecordMap.get(MAIN_STAGING_RECORD_API_NAME).isEmpty()) {
                //we will have only one main staging record per constituent for bio information to keep data consistent
                relatedInterimRecord = interimRecordMap.get(MAIN_STAGING_RECORD_API_NAME).get(0);
            } else {
                relatedInterimRecord = (sObject) Type.forName(MAIN_STAGING_RECORD_API_NAME).newInstance();
            }

            // We need to remove the Id from original record since we now query it thru CMT, if we take in the Id, we might override the interim Id field
            // and it will error out since it will be an id mismatch type.
            originalRecord.remove(ID_CONST);

        } else {
            relatedInterimRecord = (sObject) Type.forName(sectionSetting.Staging_sObject_API_Name__c).newInstance();
            if (String.isNotBlank(sectionSetting.Staging_Record_Type_Developer_Name__c)) {
                Schema.RecordTypeInfo recordTypeInfo = Schema.getGlobalDescribe().get(sectionSetting.Staging_sObject_API_Name__c).getDescribe().getRecordTypeInfosByDeveloperName().get(sectionSetting.Staging_Record_Type_Developer_Name__c);
                if (recordTypeInfo == null) {
                    System.debug('PORTAL_MyInformationControllerBase createInterim: record type name is wrong for section ' + sectionSetting.Label);
                } else {
                    relatedInterimRecord.put('RecordTypeId', recordTypeInfo.getRecordTypeId());
                }
            }

            if (String.isNotBlank((String)originalRecord.get(ID_CONST)) && isLinkRecordToInterim(new Map<String, Object>{PARAM_SECTION_SETTING => sectionSetting})) {
                relatedInterimRecord.put(sectionSetting.Original_Record_Field_API_Name__c, (String)originalRecord.get(ID_CONST));
                // We need to remove the Id from original record since we now query it thru CMT, if we take in the Id, 
                // we will be including the Id field on new creation which is an update and not an insertion,
                // and it will error out.
                originalRecord.remove(ID_CONST);
            }
        }

        if (sectionSetting.SObject_API_Name__c == ADDRESS_RELATION_API_NAME) {
            sObject recordAsSObject = (sObject) System.JSON.deserialize(System.JSON.serialize(originalRecord), ucinn_ascendv2__Address_Relation__c.class);
            createAddressRecord(new Map<String, Object>{PARAM_CONTACT_ID => null, PARAM_NEW_RECORD => recordAsSObject, PARAM_RECORDS_TO_INSERT => recordsToInsert, PARAM_RECORDS_TO_UPDATE => recordsToUpdate, PARAM_HASH_CODE_TO_ADDRESS_MAP => hashCodeToAddressMap, PARAM_SECTION_SETTING => sectionSetting});
        }

        //upsert the addresses that are needed for the address relation records
        if (!hashCodeToAddressMap.isEmpty()) {
            upsert hashCodeToAddressMap.values() ucinn_ascendv2__Address__c.Fields.ucinn_ascendv2__External_System_ID__c;
            relatedInterimRecord.put(ADDRESS_API_NAME, hashCodeToAddressMap.values()[0].Id);
        }

        //add the fields from the new record to the interim record
        addFieldsToStagingRecord(relatedInterimRecord, originalRecord, sectionSetting);

        //add the field to the interim record map
        if (interimRecordMap.containsKey(sectionSetting.Staging_sObject_API_Name__c)) {
            if (sectionSetting.Staging_sObject_API_Name__c.equals(MAIN_STAGING_RECORD_API_NAME)) {
                interimRecordMap.get(sectionSetting.Staging_sObject_API_Name__c).set(0, relatedInterimRecord);
            } else {
                interimRecordMap.get(sectionSetting.Staging_sObject_API_Name__c).add(relatedInterimRecord);
            }
        } else {
            interimRecordMap.put(sectionSetting.Staging_sObject_API_Name__c, new List<sObject>{relatedInterimRecord});
        }
    }


    /**
     * method that retrieves the fields that will trigger logic to create an interim
     * if they have been changed,  the fields that will trigger logic to create a new record
     * instead of updating the existing record if they have been changed, and takes the custom metadata
     * records and parses the record into a map of field order and field name if there is duplicate logic
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param sectionSetting:                The custom metadata record that holds the field logic
     *
     *
     * @return                              Set of field api names
     */

    private void getFieldsForUpdateRecordLogic(Portal_Page_Section_Setting__mdt sectionSetting, Map<String, String> duplicateLogicMap, Set<String> interimFieldSet, Set<String> newRecordFieldSet, Map<String, Map<String, String>> fieldToConditionsMap) {
        if (sectionSetting.Portal_Section_Field_Settings__r != null) {
            for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isNotBlank(field.Field_API_Name__c) && field.Is_Create_Staging_Record_On_Field_Change__c) {
                    interimFieldSet.add(field.Field_API_Name__c);
                }
                if (String.isNotBlank(field.Field_API_Name__c) && field.Is_Create_New_Record__c) {
                    newRecordFieldSet.add(field.Field_API_Name__c);
                }
                if (String.isNotBlank(field.Field_Order_For_Duplicate_Logic__c) && String.isNotBlank(field.Field_API_Name__c)) {
                    duplicateLogicMap.put(field.Field_Order_For_Duplicate_Logic__c, field.Field_API_Name__c);
                }
                if (String.isNotBlank(field.Create_Staging_Record_Condition_Value__c)) {
                    fieldToConditionsMap.put(field.Field_API_Name__c, new Map<String, String>{'value' => field.Create_Staging_Record_Condition_Value__c, 'operator' => field.Create_Staging_Record_Condition_Operator__c});
                }
            }
        }

    }

    /**
     * method that checks if one sobject record matches the fields of
     * another sobject record
     *
     * If any field section settings for an object has IS CREATE NEW RECORD checked, the fieldSet will be populated and the code will only compare those fields.
     * I.E if Phones has Phone number field IS CREATE NEW RECORD unchecked and Type field IS CREATE NEW RECORD checked, it will only compare the type field and exclude the phone number field.
     * The scenario above will allow for a direct update to the phone record instead of  following the activating and inactivating logic.
     * 
     * If no field section settings have IS CREATE NEW RECORD checked, then it will compare all fields (fieldSet should be empty).
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param newRecord:                    The record that was updated on the front end
     * @param oldRecord:                    A record that was returned from the front end
     * @param sectionSetting:                The custom metadata record that holds the field logic
     * @param fieldSet:                     Set of field api names if we are checking custom logic instead of the metadata record
     *
     *
     * @return                              Boolean of whether or not the records match
     */

    global virtual Boolean checkIfRecordsMatch(Map<String, Object> params) {
        sObject newRecord = (sObject) params.get(PARAM_NEW_RECORD);
        sObject oldRecord = (sObject) params.get(PARAM_OLD_RECORD);
        Portal_Page_Section_Setting__mdt sectionSetting = (Portal_Page_Section_Setting__mdt) params.get(PARAM_SECTION_SETTING);
        Set<String> fieldSet = (Set<String>) params.get(PARAM_FIELD_SET);

        if (fieldSet == null || fieldSet.isEmpty()) {
            if (sectionSetting?.Portal_Section_Field_Settings__r != null) {
                for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
                    if ((field?.Field_API_Name__c?.contains('__r') == true) && sectionSetting.SObject_API_Name__c != ADDRESS_RELATION_API_NAME) {
                        // skip matching for any field with __r since when we convert front end records, we remove the __r fields to prevent external Id error on update
                        // we do not skip addresses b/c address has special logic that handles relationship fields (__r.Name, __r.Street1, etc)
                        continue;
                    }

                    if (String.isNotBlank(field?.Field_API_Name__c)) {
                        Boolean fieldsMatch = evaluateFilterCriteria(new Map<String, Object>{PARAM_NEW_RECORD => newRecord, PARAM_OLD_RECORD => oldRecord, PARAM_FIELD => field.Field_API_Name__c});
                        if (!fieldsMatch) {
                            return false;
                        }
                    }
                }
            }


        } else {
            for (String field : fieldSet) {
                Boolean fieldsMatch = evaluateFilterCriteria(new Map<String, Object>{PARAM_NEW_RECORD => newRecord, PARAM_OLD_RECORD => oldRecord, PARAM_FIELD => field});
                if (!fieldsMatch) {
                    return false;
                }
            }
        }

        return true;
    }

    /**
     * method that checks if the fields on an sobject record has
     * been deleted
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param record:                       The record that was updated on the front end
     * @param sectionSetting:                The custom metadata record that holds the field logic
     *
     *
     * @return                              Boolean of whether or not the record was deleted
     */
    global virtual Boolean checkNullRecord(Map<String, Object> params) {

        sObject record = (sObject) params.get(PARAM_RECORD);
        Portal_Page_Section_Setting__mdt sectionSetting = (Portal_Page_Section_Setting__mdt) params.get(PARAM_SECTION_SETTING);

        if (sectionSetting.Portal_Section_Field_Settings__r != null) {
            for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isNotBlank(field.Field_API_Name__c)) {
                    if (field.Field_API_Name__c.contains('.')) {
                        List<String> fields = field.Field_API_Name__c.split('\\.');
                        sObject parentRecord = record;
                        Object recordValue = null;
                        for (Integer index = 0; index < fields.size(); index++) {
                            if (index == fields.size()-1) {
                                if (parentRecord != null) {
                                    recordValue = parentRecord.get(fields.get(index));
                                }
                            } else {
                                if (parentRecord != null) {
                                    parentRecord = parentRecord.getSObject(fields.get(index));
                                }
                            }
                        }
                        if (recordValue != null && String.isNotBlank(String.valueOf(recordValue))) {
                            return false;
                        }
                    } else if (record.get(field.Field_API_Name__c) != null && String.isNotBlank(String.valueOf(record.get(field.Field_API_Name__c)))) {  // TODO: Remove hard code, also add comment about checking type
                        return false;
                    }
                }
            }
        }
        return true;
    }

    /**
     * method that creates an address and address relation record if the record has
     * been updated on the front end
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param contactId:                      The id of the contact that this record belongs to
     * @param newRecord:                      The record that was updated on the front end
     * @param recordsToInsert:                The list of records that we want to insert
     * @param recordsToUpdate:                The list of records that we want to update
     * @param hashCodeToAddressMap:           The map of address to their hash code external id to upsert the address records
     *
     *
     *
     */
    global virtual void createAddressRecord(Map<String, Object> params) {
        Id contactId = (Id) params.get(PARAM_CONTACT_ID);
        sObject newRecord = (sObject) params.get(PARAM_NEW_RECORD);
        List<sObject> recordsToInsert =  (List<sObject>) params.get(PARAM_RECORDS_TO_INSERT);
        Map<Id, sObject> recordsToUpdate = (Map<Id, sObject>) params.get(PARAM_RECORDS_TO_UPDATE);
        Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap = (Map<String, ucinn_ascendv2__Address__c>) params.get(PARAM_HASH_CODE_TO_ADDRESS_MAP);
        Portal_Page_Section_Setting__mdt sectionSetting = (Portal_Page_Section_Setting__mdt) params.get(PARAM_SECTION_SETTING);

        ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c();

        ucinn_ascendv2__Address_Relation__c record = new ucinn_ascendv2__Address_Relation__c ();

        if (sectionSetting.Portal_Section_Field_Settings__r != null) {
            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                    if (fieldSetting.Field_API_Name__c.contains('.')) {
                        List<String> fields = fieldSetting.Field_API_Name__c.split('\\.');
                        if (fields.size() < 2) {
                            System.debug('PORTAL_MyInformationControllerBase createAddressRecord field name is wrong for ' + sectionSetting.Label + ' for field ' + fieldSetting.Field_API_Name__c);
                            continue;
                        } else {
                            sObject parentRecord = newRecord;
                            for (Integer index = 0; index < fields.size(); index++) {
                                if (index == fields.size()-1) {
                                    if (parentRecord != null) {
                                        if (fieldSetting.Field_API_Name__c.contains('ucinn_ascendv2__Address__r')) {
                                            address.put(fields.get(index), parentRecord.get(fields.get(index)));
                                        }
                                    }
                                } else {
                                    if (parentRecord != null) {
                                        parentRecord = parentRecord.getSObject(fields.get(index));
                                    } else {
                                        break;
                                    }
                                }
                            }
                        }

                    } else {
                        if (fieldSetting.Field_Type__c == PORTAL_CONST_PageSectionSetting.CHECKBOX_FIELD_NAME && newRecord.get(fieldSetting.Field_API_Name__c) == null) {
                            record.put(fieldSetting.Field_API_Name__c, false);
                        } else {
                            record.put(fieldSetting.Field_API_Name__c, newRecord.get(fieldSetting.Field_API_Name__c));
                        }

                    }

                }
            }
        }

        String hashCode = PORTAL_CommunityUtils.hashObjectFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_SOBJECT_TYPE => ((SObject) Type.forName('ucinn_ascendv2__Address__c').newInstance()).getSObjectType(), PORTAL_CommunityUtils.PARAM_SOBJECT_RECORD => address});

        address.ucinn_ascendv2__External_System_ID__c = hashCode;
        address.Id = null;

        hashCodeToAddressMap.put(hashCode, address);

        if (String.isNotBlank(sectionSetting.Record_Type_Developer_Name__c)) {
            Schema.RecordTypeInfo recordTypeInfo = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get(sectionSetting.Record_Type_Developer_Name__c);
            if (recordTypeInfo == null) {
                System.debug('PORTAL_MyInformationControllerBase createAddress record type is wrong for section ' + sectionSetting.Label);
            } else {
                record.RecordTypeId = recordTypeInfo.getRecordTypeId();
            }
        }

        record.ucinn_ascendv2__Contact__c = contactId;
        record.ucinn_ascendv2__Address__r = new ucinn_ascendv2__Address__c(ucinn_ascendv2__External_System_Id__c = hashCode);
        record.Id = newRecord.Id;

        if (String.isBlank(record.Id)) {
            recordsToInsert.add(record);
        } else {
            recordsToUpdate.put(record.Id, record);
        }
    }

    /**
     * method that takes a record that has new information that has
     * only been captured on the front end and adds it to an
     * interim record
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param sectionSetting:               The custom metadata record that holds the field logic
     * @param informationMap:               The map of records that have been updated on the front end
     * @param allRecordsMap:                The map of records from the backend
     * @param interimRecordMap:             The map of interim records
     *
     *
     * @return                              Boolean of whether or not the record was deleted
     */

    private void updateFrontEndFieldRecords(Portal_Page_Section_Setting__mdt sectionSetting,
                                           Map<String, Object> informationMap,
                                           Map<String, Map<String, Map<String,List<Map<String, Object>>>>> allRecordsMap,
                                           Map<String, List<sObject>> interimRecordMap,
                                           Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap) {

        List<Object> objectsWithFrontEndFields = getRecords(sectionSetting, informationMap,  true);

        if (!objectsWithFrontEndFields.isEmpty()) {
            Map<Id, sObject> allRecordToIdMap = new Map<Id, sObject>(convertObjectTosObject(getRecords(sectionSetting, allRecordsMap, false), System.Type.forName(sectionSetting.SObject_API_Name__c)));
            mapFrontEndFieldRecords(allRecordToIdMap, objectsWithFrontEndFields, sectionSetting, interimRecordMap, sobjectNameToDmlOperationMap);
        }
    }

    @TestVisible
    private void mapFrontEndFieldRecords(Map<Id, sObject> allRecordToIdMap, List<Object> objectsWithFrontEndFields, Portal_Page_Section_Setting__mdt sectionSetting, Map<String, List<sObject>> interimRecordMap, Map<String, Map<String, List<sObject>>> sobjectNameToDmlOperationMap) {
        Map<Id, sObject> recordsToDeactivate = new Map<Id, sObject>();
        for (Object record : objectsWithFrontEndFields) {
            Map<String, Object> recordMap = (Map<String, Object>) record;
            createInterimRecord(sectionSetting, interimRecordMap, recordMap);
            if (String.isNotBlank((String)recordMap.get('Id'))) {
                recordsToDeactivate.put(Id.valueOf((String)recordMap.get('Id')), allRecordToIdMap.get(Id.valueOf((String)recordMap.get('Id'))));
            }
        }

        if (!recordsToDeactivate.isEmpty()) {

            if (String.isNotBlank(sectionSetting.Inactive_Record_Field_Map__c)) {
                Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(sectionSetting.Inactive_Record_Field_Map__c);
                for (sObject record : recordsToDeactivate.values()) {
                    for (String field : fieldMap.keySet()) {
                        record.put(field, fieldMap.get(field));
                    }
                }
                if (sobjectNameToDmlOperationMap.containsKey(sectionSetting.SObject_API_Name__c)) {
                    if (sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).containsKey(UPDATE_KEY)) {
                        sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).get(UPDATE_KEY).addAll(recordsToDeactivate.values());
                    } else {
                        sobjectNameToDmlOperationMap.get(sectionSetting.SObject_API_Name__c).put(UPDATE_KEY, new List<sObject>(recordsToDeactivate.values()));
                    }
                } else {
                    sobjectNameToDmlOperationMap.put(sectionSetting.SObject_API_Name__c, new Map<String, List<sObject>>{UPDATE_KEY => new List<sObject>(recordsToDeactivate.values())});
                }
            }
        }
    }


    /**
     * method that saves the contstituent's bio information updates that were made
     * to a record that isn't updatable. All of this information will be saved onto
     * interim records.
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param record:              A map of the populated fields that represent the sobject record
     * @param sObjectName:         The sobject api name of the record we are trying to update (for deserialization)
     * @param recordType:          The record type of the object if there is one
     * @param masterDegreeId       The id of the master degree to populate lookup
     * @param recordToUpdateId     The id of self report record to update
     *
     * @return                     Object that was updated
     */
    global virtual List<Map<String, Object>> reportUpdate(Map<String, Object> params){
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        List<sObject> listOfObjects = new List<sObject>();

        if (params == null || params.isEmpty()) {
            return returnList;
        }
        
        Map<String, Object> record = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(params.get(PARAM_RECORD)));
        String sObjectName = (String) params.get(PARAM_SOBJECT_NAME);
        String recordType = (String) params.get(PARAM_RECORD_TYPE);
        String masterDegreeId = (String) params.get(MASTER_DEGREE_ID);
        String recordToUpdateId = (String) params.get(RECORD_TO_UPDATE_ID);
        Case newCase = (Case) params.get('newCase');
        Boolean createCase = (Boolean) params.get('createCase');

        String interimSourceUrl = (String) params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);

        Map<String, String> frontEndFieldIdToObjectNames = getInterimSubsectionNamesToSObjectApiNames();
        String sObjectApiName = frontEndFieldIdToObjectNames?.get(sObjectName);

        if (String.isBlank(sObjectApiName)) {
            System.debug('PORTAL_MyInformationControllerBase reportUpdate sObjectApiName is blank');
            return null;
        }

        Schema.RecordTypeInfo interimRecordTypeInfo = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME);
        if (interimRecordTypeInfo == null) {
            System.debug('PORTAL_MyInformationControllerBase reportUpdate interim record type is incorrect');
            return null;
        }

        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        if (cont == null) {
            return null;
        }

        List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id FROM ucinn_ascendv2__Interim__c
                                                        WHERE ucinn_ascendv2__Contact__c = :cont.Id
                                                        AND RecordType.DeveloperName = :REPORT_UPDATE_INTERIM_RECORD_TYPE_NAME
                                                        AND ucinn_ascendv2__Status__c = :REPORT_UPDATE_INTERIM_STATUS];
        ucinn_ascendv2__Interim__c interim;

        if (interimList.isEmpty()) {
            interim = new ucinn_ascendv2__Interim__c();
            interim.ucinn_ascendv2__Contact__c = cont.Id;
            interim.ucinn_ascendv2__Status__c = REPORT_UPDATE_INTERIM_STATUS;
            interim.RecordTypeId = interimRecordTypeInfo.getRecordTypeId();
            interim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();

            if (createCase == true && !CREATE_CASE_FOR_BIO_INFO_SELF_REPORT.equalsIgnoreCase('false')) {
                if (newCase == null) {
                    List<Group> groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :CASE_GROUP_NAME LIMIT 1];

                    newCase = new Case(Origin='Portal',
                                                Subject='A user has submitted changes to their bio information.',
                                                Status='New',
                                                Type = CASE_TYPE_NAME,
                                                ContactId=cont.Id);

                    if (!groupList.isEmpty()) {
                        Id groupId = groupList.get(0).Id;
                        newCase.OwnerId = groupId;
                    }

                }

                insert newCase;
                interim.ucinn_portal_Case__c = newCase.Id;
            }

            insert interim;
        } else {
            interim = interimList.get(0);
        }

        sObject recordAsSObject = null;

        List<Portal_Page_Section_Setting__mdt> selfReportSectionSettingList = this.queryPageSectionSettings('My Information Self Report');
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMapSelfReport = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(selfReportSectionSettingList);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> frontEndIdToFrontEndIdToPageSectionSettingSelfReportMap = createInterimPageSectionSettingMap(pageSectionMapSelfReport);
        Map<String, Object> frontEndFieldIdToStagingRecordApiNameMap = createFieldIdToStagingRecordMap(selfReportSectionSettingList);

        record = convertSelfReportFrontEndRecordToBackEnd(record, frontEndFieldIdToStagingRecordApiNameMap);

        if (sObjectApiName == INTERIMS_FRONT_END_NAME || sObjectApiName == MAIN_STAGING_RECORD_API_NAME) {
            recordAsSObject = (sObject) System.JSON.deserialize(System.JSON.serialize(record), ucinn_ascendv2__Interim__c.class);
            recordAsSObject.Id = interim.Id;
            update recordAsSObject;
        } else {
            recordAsSObject = (sObject) System.JSON.deserialize(System.JSON.serialize(record), System.Type.forName(sObjectApiName));
            Map<String, Schema.SObjectField> fieldMap = (Schema.getGlobalDescribe().get(sObjectApiName)).getDescribe().fields.getMap();
            for (Schema.SObjectField field : fieldMap.values()) {
                List<Schema.SObjectType> references = field.getDescribe().getReferenceTo();
                if (references != null && !references.isEmpty()) {
                    if (references.get(0).getDescribe().getName() == MAIN_STAGING_RECORD_API_NAME) {
                        recordAsSObject.put(field.getDescribe().getName(), interim.Id);
                    } else if (references.get(0).getDescribe().getName() == sObjectApiName) {
                        recordAsSObject.put(field.getDescribe().getName(), record.get('Id'));
                    }
                }
            }

            Map<String, String> objectNameToDummyContactFieldMap = this.getObjectNameToDummyContactFieldMap();
            Map<String, String> objectNameToDummyOrganizationFieldMap = this.getObjectNameToDummyOrganizationFieldMap();
            Map<String, String> objectNameToMasterRecordFieldMap = this.getReportUpdateMasterRecordFieldMap();

            Id dummyContactId = null;
            Id dummyOrganizationId = null;

            //these sobjects need a master detail to contact and since they are going on interims, they must go to a dummy contact to be reparented upon approval
            if (objectNameToDummyContactFieldMap.containsKey(sObjectApiName)) {
                List<Contact> dummyContactList = [SELECT Id, AccountId FROM Contact WHERE FirstName = :DUMMY_CONTACT_FIRST_NAME AND LastName = :DUMMY_CONTACT_LAST_NAME];
                if (dummyContactList.isEmpty()) {
                    Contact dummyContact = new Contact(FirstName = DUMMY_CONTACT_FIRST_NAME, LastName = DUMMY_CONTACT_LAST_NAME);
                    insert dummyContact;
                    dummyContactId = dummyContact.Id;
                } else {
                    dummyContactId = dummyContactList.get(0).Id;
                    dummyOrganizationId = dummyContactList.get(0).AccountId;
                }

                recordAsSObject.put(objectNameToDummyContactFieldMap.get(sObjectApiName), dummyContactId);

                if (objectNameToDummyOrganizationFieldMap.containsKey(sObjectApiName) && String.isBlank((String)recordAsSObject.get(objectNameToDummyOrganizationFieldMap.get(sObjectApiName)))) {
                    recordAsSObject.put(objectNameToDummyOrganizationFieldMap.get(sObjectApiName), dummyOrganizationId);
                }

            }

            if (objectNameToMasterRecordFieldMap.containsKey(sObjectApiName) && String.isNotBlank(masterDegreeId)) {
                recordAsSObject.put(objectNameToMasterRecordFieldMap.get(sObjectApiName), masterDegreeId);
            }

            if (String.isNotBlank(recordType)) {
                Schema.RecordTypeInfo recordTypeInfo = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordType);
                if (recordTypeInfo == null) {
                    System.debug('Portal_MyInformationControllerBase reportUpdate record type is incorrect ' + recordType);
                } else {
                    recordAsSObject.put('RecordTypeId', recordTypeInfo.getRecordTypeId());
                }
            }

            if (String.isNotBlank(recordToUpdateId)) {
                recordAsSObject.put(ID_CONST, recordToUpdateId);
            }

            upsert recordAsSObject;
        }

        if (recordType == SCHOOL_DEGREE_INFORMATION || recordType == NON_SCHOOL_DEGREE_INFORMATION) {
            Map<String, Map<String, List<sObject>>> selfReportList = queryForSelfReportedInterimRecords(cont.Id, selfReportSectionSettingList);

            if (recordType == SCHOOL_DEGREE_INFORMATION) {
                listOfObjects = selfReportList.get(SCHOOL_DEGREE_SELF_REPORTS)?.get(DEGREE_INFORMATION_API_NAME);
            } else {
                listOfObjects = selfReportList.get(NON_SCHOOL_DEGREE_SELF_REPORTS)?.get(DEGREE_INFORMATION_API_NAME);
            }

        } else {
            listOfObjects.add(recordAsSObject);
        }

        returnList = convertRecordsToWrapper(listOfObjects, frontEndIdToFrontEndIdToPageSectionSettingSelfReportMap?.get(sObjectName));
        return returnList;
    }

    /**
     * method that updates the directory setting of a constituent
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param informationMap:              A map of records that have been updated on the front end
     * @param contactId:                   The contact id that this directory setting belongs to
     *
     *
     */

    global virtual void updateDirectorySetting(Map<String, Object> params) {

        Map<String, Object> informationMap = (Map<String, Object>) params.get(PARAM_INFORMATION_MAP);
        Id contactId = (Id) params.get(PARAM_CONTACT_ID);

        Map<String, Object> recordMap = (Map<String, Object>) informationMap.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
        Map<String, Object> privacySettings = (Map<String, Object>) recordMap.get(PRIVACY_SETTING_NAME);
        List<Object> directorySettingList = (List<Object>) privacySettings.get(DIRECTORY_SETTING_NAME);
        if (!directorySettingList.isEmpty()) {
            ucinn_portal_Directory_Setting__c setting = (ucinn_portal_Directory_Setting__c) System.JSON.deserialize(System.JSON.serialize(directorySettingList.get(0)), ucinn_portal_Directory_Setting__c.class);
            if (String.isBlank(setting.Id)) {
                setting.Contact__c = contactId;
            }
            upsert setting;
        }
    }

    /**
     * method that updates the directory opt out field on a constituent
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param informationMap:              A map of records that have been updated on the front end
     * @param contactId                    Id of contact we are updating
     *
     */
    global virtual void updateDirectoryOptOut(Map<String, Object> params) {
        Map<String, Object> informationMap = (Map<String, Object>) params.get(PARAM_INFORMATION_MAP);
        Id contactId = (Id) params.get(PARAM_CONTACT_ID);

        Map<String, Object> recordMap = (Map<String, Object>) informationMap.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
        Map<String, Object> privacySettings = (Map<String, Object>) recordMap.get(PRIVACY_SETTING_NAME);
        List<Object> directoryOptOut = (List<Object>) privacySettings.get(DIRECTORY_OPT_OUT_NAME);

        if (directoryOptOut?.isEmpty() == false) {
            Contact directoryOptOutContact = (Contact) System.JSON.deserialize(System.JSON.serialize(directoryOptOut.get(0)), Contact.class);
            directoryOptOutContact.Id = contactId;
            update directoryOptOutContact;
        }
    }

    /**
     * method that updates the an interim if a constituent's spousal information has been changed
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param informationMap:              A map of records that have been updated on the front end
     * @param contactId:                   The contact id that will be used to link to the interim
     * @param allRecordsMap:               The map of records that have the current backend information
     * @param interimRecordsMap:           The map of interim records
     * @param allInterimRecords            The map of all backend interim records
     *
     *
     */
    global virtual void updateSpousalInformationIfNecessary(Map<String, Object> params) {
        Map<String, Object> informationMap = (Map<String, Object>) params.get(PARAM_INFORMATION_MAP);
        Id contactId = (Id) params.get(PARAM_CONTACT_ID);
        Map<String, Map<String, Map<String,List<Map<String, Object>>>>> allRecordsMap = (Map<String, Map<String, Map<String,List<Map<String, Object>>>>>) params.get(PARAM_ALL_RECORDS_MAP);
        Map<String, Map<String, List<sObject>>> allInterimRecords = (Map<String, Map<String, List<sObject>>>) params.get(PARAM_ALL_INTERIM_RECORDS_MAP);
        Map<String, List<sObject>> interimRecordMap = (Map<String, List<sObject>>) params.get(PARAM_INTERIM_RECORD_MAP);  // this is interim records from front end

        Map<String, Object> recordMap = (Map<String, Object>) informationMap.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
        Map<String, Object> personalInformation = (Map<String, Object>) recordMap.get(SPOUSE_MAIN_SECTION_NAME);
        List<Object> additionalDetails = (List<Object>) personalInformation.get(SPOUSE_SUB_SECTION_NAME);

        Map<String, Object> backendRecordMap = (Map<String, Object>) allRecordsMap.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
        Map<String, Object> backendPersonalInformation = (Map<String, Object>) backendRecordMap.get(SPOUSE_MAIN_SECTION_NAME);
        List<Object> backendAdditionalDetails = (List<Object>) backendPersonalInformation.get(SPOUSE_SUB_SECTION_NAME);

        Map<String, Object> newContact = (Map<String, Object>) additionalDetails.get(0);
        Map<String, Object> oldContact = (Map<String, Object>) backendAdditionalDetails.get(0);

        ucinn_ascendv2__Interim__c spousalInterim = (ucinn_ascendv2__Interim__c) interimRecordMap?.get(SPOUSAL_INTERIM_KEY)?.get(0);
        ucinn_ascendv2__Interim__c backendSpousalInterim = (ucinn_ascendv2__Interim__c) allInterimRecords?.get(SPOUSAL_INTERIM_KEY)?.get(MAIN_STAGING_RECORD_API_NAME)?.get(0);

        if (spousalInterim != null) {
            spousalInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
        }

        if (newContact?.containsKey(PREFERRED_SPOUSE) || (spousalInterim != null && backendSpousalInterim != null)) {

            Boolean changed = false;
            Map<String, Object> spouse = (Map<String, Object>) newContact?.get(PREFERRED_SPOUSE);
            Map<String, Object> oldSpouse = (Map<String, Object>) oldContact?.get(PREFERRED_SPOUSE);
            String firstName = (String) spouse?.get(FIRST_NAME);
            String lastName = (String) spouse?.get(LAST_NAME);
            String oldFirstName = (String) oldSpouse?.get(FIRST_NAME);
            String oldLastName = (String) oldSpouse?.get(LAST_NAME);

            if (!oldContact?.containsKey(PREFERRED_SPOUSE) && spousalInterim == null) {
                //TODO add in front end validation for spouse name
                if (String.isNotBlank(firstName) && String.isNotBlank(lastName)) {
                    changed = true;
                }

            } else if (spousalInterim != null) { // need to check interim (case when first and last name get deleted)
                String spousalInterimFirstName = (String) spousalInterim.get('ucinn_ascendv2__Significant_Other_First_Name__c');
                String spousalInterimLastName = (String) spousalInterim.get('ucinn_ascendv2__Significant_Other_Last_Name__c');
                String backendSpousalInterimFirstName = (String) backendSpousalInterim?.get('ucinn_ascendv2__Significant_Other_First_Name__c');
                String backendSpousalInterimLastName = (String) backendSpousalInterim?.get('ucinn_ascendv2__Significant_Other_Last_Name__c');
                // this is the information from the front end

                if ((String.isBlank(spousalInterimFirstName) && spousalInterimFirstName != oldFirstName)|| (String.isBlank(spousalInterimLastName) && spousalInterimLastName != oldLastName)
                    ||  String.isBlank(spousalInterimFirstName) && spousalInterimFirstName != backendSpousalInterimFirstName
                    ||  String.isBlank(spousalInterimLastName) && spousalInterimLastName != backendSpousalInterimLastName
                    ||  String.isNotBlank(spousalInterimFirstName) && spousalInterimFirstName != backendSpousalInterimFirstName
                    ||  String.isNotBlank(spousalInterimLastName) && spousalInterimLastName != backendSpousalInterimLastName) {
                        firstName = spousalInterimFirstName;
                        lastName = spousalInterimLastName;
                        changed = true;
                }

            } else {
                if (firstName != oldFirstName || lastName != oldLastName) {
                    changed = true;
                }

            }

            if (changed) {
                if (String.isBlank(firstName)) {
                    firstName = IS_DELETED;
                }
                if (String.isBlank(lastName)) {
                    lastName = IS_DELETED;
                }

                if (interimRecordMap.containsKey(SPOUSAL_INTERIM_KEY) && !interimRecordMap.get(SPOUSAL_INTERIM_KEY).isEmpty()) {
                    spousalInterim = (ucinn_ascendv2__Interim__c) interimRecordMap.get(SPOUSAL_INTERIM_KEY).get(0);
                    spousalInterim.ucinn_ascendv2__Significant_Other_First_Name__c = firstName;
                    spousalInterim.ucinn_ascendv2__Significant_Other_Last_Name__c = lastName;
                    spousalInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
                    interimRecordMap.get(SPOUSAL_INTERIM_KEY).set(0, spousalInterim);
                } else {
                    spousalInterim = new ucinn_ascendv2__Interim__c();
                    spousalInterim.ucinn_ascendv2__Significant_Other_First_Name__c = firstName;
                    spousalInterim.ucinn_ascendv2__Significant_Other_Last_Name__c = lastName;
                    spousalInterim.ucinn_ascendv2__Contact__c = contactId;
                    spousalInterim.ucinn_ascendv2__Status__c = SPOUSAL_INTERIM_STATUS;
                    spousalInterim.ucinn_ascendv2__Manual_Review_Reason__c = SPOUSAL_INTERIM_DESCRIPTION;
                    spousalInterim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(INTERIM_RECORD_TYPE_NAME).getRecordTypeId();
                    spousalInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
                    interimRecordMap.put(SPOUSAL_INTERIM_KEY, new List<sObject>{spousalInterim});
                }
            }
        }

        if (newContact.containsKey(MARITAL_STATUS)) {
            Boolean changed = false;
            String newMaritalStatus = (String) newContact.get(MARITAL_STATUS);
            spousalInterim = (ucinn_ascendv2__Interim__c) interimRecordMap?.get(SPOUSAL_INTERIM_KEY)?.get(0);
            String spousalInterimMaritalStatus = (String)spousalInterim?.get(SPOUSAL_INTERIM_MARITAL_STATUS);
            String oldMaritalStatus = (String) oldContact.get(MARITAL_STATUS);

            // when comparing newMaritalStatus to these two other status values. Empty != null, so it might create a spousal interim even though no changes were made
            // set the values to blank strings if they were null to keep consitent

            if (String.isBlank(newMaritalStatus)) {
                newMaritalStatus = '';
            }

            if (String.isBlank(spousalInterimMaritalStatus)) {
                spousalInterimMaritalStatus = '';
            }

            if (String.isBlank(oldMaritalStatus)) {
                oldMaritalStatus = '';
            }

            if (String.isBlank(oldMaritalStatus) && String.isBlank(spousalInterimMaritalStatus) && String.isNotBlank(newMaritalStatus)) {
                changed = true;
            } else if ((String.isBlank(newMaritalStatus) && String.isNotBlank(oldMaritalStatus)) || (String.isBlank(newMaritalStatus) && String.isNotBlank(spousalInterimMaritalStatus))) {
                // if status is deleted from front end when there is only constituent information, or when its deleted from front end and there is a value on the interim
                changed = true;
                newMaritalStatus = IS_DELETED;
            } else if (newMaritalStatus != oldMaritalStatus && String.isBlank(spousalInterimMaritalStatus)){
                changed = true;
            } else if (String.isBlank(oldMaritalStatus) && newMaritalStatus != spousalInterimMaritalStatus) {
                changed = true;
            } else if (String.isNotBlank(spousalInterimMaritalStatus) && newMaritalStatus != spousalInterimMaritalStatus) {
                changed = true;
            }

            if (changed) {
                if (interimRecordMap.containsKey(SPOUSAL_INTERIM_KEY) && !interimRecordMap.get(SPOUSAL_INTERIM_KEY).isEmpty()) {
                    spousalInterim = (ucinn_ascendv2__Interim__c) interimRecordMap.get(SPOUSAL_INTERIM_KEY).get(0);
                    spousalInterim.ucinn_ascendv2__Marital__c = newMaritalStatus;
                    spousalInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
                    interimRecordMap.get(SPOUSAL_INTERIM_KEY).set(0, spousalInterim);
                } else {
                    spousalInterim = new ucinn_ascendv2__Interim__c();
                    spousalInterim.ucinn_ascendv2__Marital__c = newMaritalStatus;
                    spousalInterim.ucinn_ascendv2__Contact__c = contactId;
                    spousalInterim.ucinn_ascendv2__Status__c = SPOUSAL_INTERIM_STATUS;
                    spousalInterim.ucinn_ascendv2__Manual_Review_Reason__c = SPOUSAL_INTERIM_DESCRIPTION;
                    spousalInterim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(INTERIM_RECORD_TYPE_NAME).getRecordTypeId();
                    spousalInterim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
                    interimRecordMap.put(SPOUSAL_INTERIM_KEY, new List<sObject>{spousalInterim});
                }
            }

        }
    }

    /**
     * method that evaluates if the new record's field matches a value that is needed
     * to create a staging record
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param newRecord:                          The new record that was updated on the front end
     * @param fieldToConditionsMap:               The map of field name to conditional value and operators that we are evaluating
     *
     *@return:                                    Boolean of if the record meets the conditional operator conditions
     *
     */
    global virtual Boolean evaluateStagingRecordFieldCondition(Map<String, Object> params) {

        sObject newRecord = (sObject) params.get(PARAM_NEW_RECORD);
        Map<String, Map<String, String>> fieldToConditionsMap = (Map<String, Map<String, String>>) params.get(PARAM_FIELD_TO_CONDITIONS_MAP);

        for (String field : fieldToConditionsMap.keyset()) {
            String fieldValue = '';
            if (field.contains('.')) {
                List<String> fields = field.split('\\.');
                if (fields.size() < 2) {
                    continue;
                } else {
                    sObject parentRecord = newRecord;
                    for (Integer index = 0; index < fields.size(); index++) {
                        if (index == fields.size()-1) {
                            if (parentRecord != null) {
                                if (parentRecord.get(fields.get(index)) != null) {
                                    fieldValue = String.valueOf(parentRecord.get(fields.get(index)));
                                }
                            }
                        } else {
                            if (parentRecord != null) {
                                parentRecord = parentRecord.getSObject(fields.get(index));
                            } else {
                                break;
                            }
                        }
                    }
                }
            } else {
                if (newRecord.get(field) != null) {
                    fieldValue = String.valueOf(newRecord.get(field));
                }
            }
            Boolean evaluation = PORTAL_CommunityUtils.evaluateExpression(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_FIRST_VALUE => fieldValue, PORTAL_CommunityUtils.PARAM_SECOND_VALUE => fieldToConditionsMap.get(field).get('value'), PORTAL_CommunityUtils.PARAM_OPERATOR => fieldToConditionsMap.get(field).get('operator')});
            if (evaluation == true) {
                return true;
            }
        }

        return false;

    }

    /**
     * Determines if we linked related list information to interims
     * Determined by 4 different fields, Is Create Staging Record Upon Edit, Staging sObject API Name not blank,
     * original record field api name, and Staging Record Controlling Parent Field not blank
     *
     * @author      Phillip Nguyen
     * @since       1.0
     *
     * @param sectionSetting    Page Section Setting
     *
     * @return                  Boolean value determining if we are linking related list to interims
     */
    global virtual Boolean isLinkRecordToInterim(Map<String, Object> params) {
        Boolean result = false;
        if (params == null || params.isEmpty()) {
            return result;
        }

        Portal_Page_Section_Setting__mdt sectionSetting = (Portal_Page_Section_Setting__mdt)params.get(PARAM_SECTION_SETTING);

        if (sectionSetting == null) {
            return result;
        }

        result = ((Boolean)sectionSetting.Is_Create_Staging_Record_Upon_Edit__c
                  && String.isNotBlank(sectionSetting.Staging_sObject_API_Name__c)
                  && String.isNotBlank(sectionSetting.Staging_Record_Controlling_Parent_Field__c)
                  && String.isNotBlank(sectionSetting.Original_Record_Field_API_Name__c)
                 );

        return result;
    }

    /**
     * Convert all interim record map to list of sobjects
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param   allInterimRecords
     * @return  allInterimRecords converted to list of sobjects
     */
    global virtual List<sObject> convertAllInterimMapToList(Map<String, Object> params) {
        List<sObject> sObjectList = new List<sObject>();

        if (params == null || params.IsEmpty()) {
            return sObjectList;
        }

        Map<String, Map<String, List<sObject>>> allInterimRecords = (Map<String, Map<String, List<sObject>>>)params.get(PARAM_ALL_INTERIM_RECORDS);

        for (Map<String, List<sObject>> eachObjectNameToObjectList : allInterimRecords.values()) {
            for (String eachObjectName : eachObjectNameToObjectList.keyset()) {
                List<sObject> eachObjectList = eachObjectNameToObjectList.get(eachObjectName);

                if (eachObjectList == null || eachObjectList.isEmpty()) {
                    continue;
                }

                sObjectList.addAll(eachObjectList);
            }
        }

        return sObjectList;
    }

    /**
     * Checks for duplicate inside interimRecordMap, which is the interim records that were added/edited/deleted on the front end
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param interimRecordObjectList   interimRecordMap converted to List of sObjects that does not include the main interim (MAIN_STAGING_RECORD)
     * @param postFixExpressions        List of postfix postfix expressions
     * @param duplicateLogicMap         Map of duplicate logic
     */
    @TestVisible
    private virtual void checkDuplicateFrontEndInterims(List<sObject> interimRecordObjectList, List<String> postFixExpressions, Map<String, String> duplicateLogicMap) {
        if (interimRecordObjectList == null || interimRecordObjectList.isEmpty()
            || postFixExpressions == null || postFixExpressions.isEmpty()
            || duplicateLogicMap == null || duplicateLogicMap.isEmpty()) {
                return;
        }

        for (Integer eachInterimListIndex = 0; eachInterimListIndex < interimRecordObjectList.size(); eachInterimListIndex++) {
            sObject currentOuterRecord = interimRecordObjectList[eachInterimListIndex];
            String currentOuterRecordName = currentOuterRecord.getSObjectType().getDescribe().getName();

            if (currentOuterRecordName == MAIN_STAGING_RECORD_API_NAME) {
                continue;
            }

            for (Integer eachInterimListInnerIndex = 0; eachInterimListInnerIndex < interimRecordObjectList.size(); eachInterimListInnerIndex++) {
                if (eachInterimListIndex == eachInterimListInnerIndex) {
                    continue;
                }

                sObject currentInnerRecord = interimRecordObjectList[eachInterimListInnerIndex];
                String currentInnerRecordName = currentInnerRecord.getSObjectType().getDescribe().getName();

                if (currentInnerRecordName == MAIN_STAGING_RECORD_API_NAME) {
                    continue;
                }

                if (currentOuterRecordName == currentInnerRecordName) {  // when editing or inserting records, check for a duplicate
                    if (dedupeRecords(new List<String>(postFixExpressions), duplicateLogicMap, currentOuterRecord, currentInnerRecord)) {
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DUPLICATE_MESSAGE});
                    }
                }
            }
        }

    }

    /**
     * Converts interimRecordMap into list of sObjects that does NOT include the main interim
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param interimRecordMap  Mapping of front end interim records
     * @return                  Front end interim records converted into list of sObjects
     */
    private virtual List<sObject> convertFrontEndInterimToObjectList(String stagingObjectApiName, Map<String, List<sObject>> interimRecordMap) {
        List<sObject> returnList = new List<sObject>();
        if (interimRecordMap == null || interimRecordMap.isEmpty() || String.isBlank(stagingObjectApiName)) {
            return returnList;
        }

        for (String eachInterimName : interimRecordMap.keySet()) {
            if (String.isBlank(eachInterimName) || eachInterimName == INTERIMS_FRONT_END_NAME || eachInterimName != stagingObjectApiName) {
                continue;
            }

            List<sObject> eachInterimObjectList = interimRecordMap.get(eachInterimName);

            if (eachInterimObjectList == null || eachInterimObjectList.isEmpty()) {
                continue;
            }

            returnList.addAll(eachInterimObjectList);
        }

        return returnList;
    }

    /**
     * Default mapping from object to contact lookup
     * Used to assign dummy contact information to object so insert does not fail
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @return Map of object to contact lookup api name
     */
    global virtual Map<String, String> getObjectNameToDummyContactFieldMap() {
        if (objectNameToDummyContactFieldMap == null || objectNameToDummyContactFieldMap.isEmpty()) {
            objectNameToDummyContactFieldMap = new Map<String, String>{'ucinn_ascendv2__Affiliation__c' => 'ucinn_ascendv2__Contact__c',
                                                                        DEGREE_INFORMATION_API_NAME => 'ucinn_ascendv2__Contact__c',
                                                                       'ucinn_ascendv2__Email__c' => 'ucinn_ascendv2__Contact__c',
                                                                       'ucinn_ascendv2__Phone__c' => 'ucinn_ascendv2__Contact__c',
                                                                        ADDRESS_RELATION_API_NAME => 'ucinn_ascendv2__Contact__c',
                                                                       'ucinn_ascendv2__Social_Media__c' => 'ucinn_ascendv2__Contact__c'};
        }

        return objectNameToDummyContactFieldMap;
    }

    /**
     * Default mapping from object to organization lookup
     * Used to assign dummy contact information to object so insert does not fail
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @return Map of object to orgnanization lookup api name
     */
    global virtual Map<String, String> getObjectNameToDummyOrganizationFieldMap() {
        if (objectNameToDummyOrganizationFieldMap == null || objectNameToDummyOrganizationFieldMap.isEmpty()) {
            objectNameToDummyOrganizationFieldMap = new Map<String, String>{'ucinn_ascendv2__Affiliation__c' => 'ucinn_ascendv2__Account__c',
                                                                            DEGREE_INFORMATION_API_NAME => 'ucinn_ascendv2__Degree_Institution__c'};
        }

        return objectNameToDummyOrganizationFieldMap;
    }

    /**
     * Default mapping from object to master record for report update
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @return Map of object to master record lookup api name
     */
    global virtual Map<String, String> getReportUpdateMasterRecordFieldMap() {
        if (objectNameToMasterRecordFieldMap == null || objectNameToMasterRecordFieldMap.isEmpty()) {
            objectNameToMasterRecordFieldMap = new Map<String, String>{DEGREE_INFORMATION_API_NAME => 'ucinn_portal_Master_Degree_Information__c'};
        }

        return objectNameToMasterRecordFieldMap;
    }

    /**
     * Gets school name for school degree information after clicking on lookup option
     *
     * @author: Phillip Nguyen
     * @since:  1.0
     *
     * @param objectName  name of object we are querying for, which is either Post Code or Minor Code
     * @param Id          Id of Object
     *
     * @return            returns name of school
     */
    public virtual String getAcademicOrgName(Map<String, Object> params) {
        String academicOrgName = '';
        if (params == null || params.isEmpty()) {
            return academicOrgName;
        }

        String objectName = (String)params.get(OBJECT_NAME);
        String objectId = (String)params.get(ID_CONST);

        if (String.isBlank(objectName) || String.isBlank(objectId)) {
            return academicOrgName;
        }

        if (objectName == POST_CODE) {
            List<ucinn_ascendv2__Post_Code__c > postCodeList = [SELECT ucinn_ascendv2__School_1_Name_Formula__c FROM ucinn_ascendv2__Post_Code__c WHERE Id = :objectId];
            academicOrgName = postCodeList?.get(0).ucinn_ascendv2__School_1_Name_Formula__c;
        } else if (objectName == MINOR_CODE) {
            List<ucinn_ascendv2__Minor_Code__c > minorCodeList = [SELECT ucinn_ascendv2__Academic_Organization_Desc_Formula__c FROM ucinn_ascendv2__Minor_Code__c WHERE Id = :objectId];
            academicOrgName = minorCodeList?.get(0).ucinn_ascendv2__Academic_Organization_Desc_Formula__c;
        }

        return academicOrgName;
    }

    /**
     * Convert front end records to back end structure so we can just keep the original my information logic
     * 
     * @author  Phillip Nguyen
     * @since   1.0 
     * 
     * @param   recordMap       Front End records
     * @param   mainSectionMap  Map that is main section -> front end field id -> field api names
     * 
     * @return                  recordMap that has been reformatted
     */
    private Map<String, Object> convertFrontEndRecordFieldsToBackEnd(Map<String, Object> recordMap, Map<String, Map<String, Object>> mainSectionMap) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (recordMap == null || recordMap.isEmpty() || mainSectionMap == null || mainSectionMap.isEmpty()) {
            return returnMap;
        }

        for (String eachRecordSection : recordMap.keySet()) {
            if (String.isBlank(eachRecordSection)) {
                continue;
            }

            Map<String, Object> newMap = new Map<String, Object>();
            Map<String, Object> subSectionMap = (Map<String, Object>)recordMap.get(eachRecordSection);

            if (subSectionMap == null || subSectionMap.isEmpty()) {
                continue;
            }

            for (String eachRecordSubsection : subSectionMap.keySet()) {
                if (String.isBlank(eachRecordSubsection)) {
                    continue;
                }

                Map<String, Object> fieldIdToFieldApiMap = (Map<String, Object>)mainSectionMap.get(eachRecordSection)?.get(eachRecordSubsection);
                List<Object> newList = new List<Object>();
                List<Object> recordList = (List<Object>)subSectionMap.get(eachRecordSubsection);

                if (recordList == null || recordList.isEmpty()) {
                    continue;
                }

                for (Object eachRecord : recordList) {
                    if (eachRecord == null) {
                        continue;
                    }

                    Map<String, Object> newRecordMap = new Map<String, Object>();
                    Map<String, Object> eachRecordMap = (Map<String, Object>)eachRecord;

                    if (eachRecordMap == null || eachRecordMap.isEmpty()) {
                        continue;
                    }

                    for (String eachField : eachRecordMap.keySet()) {
                        String fieldApiName = (String)fieldIdToFieldApiMap?.get(eachField);

                        if (String.isBlank(eachField) || String.isBlank(fieldApiName)) {
                            continue;
                        }

                        populateBackEndRecordWithFrontEndData(newRecordMap, eachRecordMap?.get(eachField), fieldApiName, eachRecordSection);
                    }

                    newList.add(newRecordMap);
                }

                newMap.put(eachRecordSubsection, newList);
            }

            returnMap.put(eachRecordSection, newMap);
        }

        return returnMap;
    }

    /**
     * Create mapping of main section -> front end field -> api name
     * 
     * @author      Phillip Nguyen
     * @since       1.0
     * 
     * @param sectionSettingList    Page section setting list
     * 
     * @return                      Mapping of main section -> front end field -> api name
     */
    private Map<String, Map<String, Object>> createMainSectionToFrontEndFieldIdMap(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();

        if (sectionSettingList == null || sectionSettingList.isEmpty()) {
            return returnMap;
        }

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            if (String.isBlank(sectionSetting.Page_Main_Section__c)) {
                continue;
            }

            Map<String, Object> dataMap = new Map<String, Object>();

            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isBlank(fieldSetting.Front_End_Field_Id__c)) {
                    continue;
                }

                dataMap.put(fieldSetting.Front_End_Field_Id__c, fieldSetting.Field_API_Name__c);
            }

            String subsection = String.isNotBlank(sectionSetting.Page_Sub_Section__c) ? sectionSetting.Page_Sub_Section__c : PORTAL_CONST_PageSectionSetting.RECORD_KEY;

            if (returnMap.get(sectionSetting.Page_Main_Section__c) != null) {
                Map<String, Object> existingSubsectionMap = returnMap.get(sectionSetting.Page_Main_Section__c);
                existingSubsectionMap.put(subsection, dataMap);
                returnMap.put(sectionSetting.Page_Main_Section__c, existingSubsectionMap);
            } else {
                returnMap.put(sectionSetting.Page_Main_Section__c, new Map<String, Object>{subsection => dataMap});
            }
        }

        // mainsection => subsection(if none, then 'records') => front end field id => field api name
        return returnMap;
    }

    /**
     * Create front end page section mapping for interim page section settings
     * 
     * @author  Phillip Nguyen
     * @since   1.0 
     * 
     * @param   pageSectionMap  Back end page section map that contains api names
     * 
     * @return                  Page section map that looks like: front end section id -> MAIN_QUERY_KEY -> Page Section Setting List
     */
    private Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> createInterimPageSectionSettingMap(Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap) {
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> returnMap = new Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>>();

        if (pageSectionMap == null || pageSectionMap.isEmpty()){
            return returnMap;
        }

        for (Map<String, List<Portal_Page_Section_Setting__mdt>> eachObjectToFieldMap : pageSectionMap.values()) {
            if (eachObjectToFieldMap == null || eachObjectToFieldMap.isEmpty()) {
                continue;
            }

            String frontEndSectionId = eachObjectToFieldMap.get(MAIN_QUERY_KEY)?.get(0)?.Front_End_Section_Id__c;
            String mainSectionName = eachObjectToFieldMap.get(MAIN_QUERY_KEY)?.get(0)?.Page_Main_Section__c;

            if (String.isBlank(frontEndSectionId) || String.isBlank(mainSectionName)) {
                continue;
            }

            if (mainSectionName == SPOUSE_MAIN_SECTION_NAME) {
                if (returnMap.containsKey(INTERIMS_FRONT_END_NAME)) {
                    List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = returnMap.get(INTERIMS_FRONT_END_NAME)?.get(MAIN_QUERY_KEY);
                    pageSectionSettingList?.addAll(eachObjectToFieldMap.get(MAIN_QUERY_KEY));

                    returnMap.put(INTERIMS_FRONT_END_NAME, new Map<String, List<Portal_Page_Section_Setting__mdt>>{MAIN_QUERY_KEY => pageSectionSettingList});
                } else {
                    returnMap.put(INTERIMS_FRONT_END_NAME, eachObjectToFieldMap);
                }
            } else if (returnMap.containsKey(frontEndSectionId)) {
                List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = returnMap.get(frontEndSectionId)?.get(MAIN_QUERY_KEY);
                pageSectionSettingList?.addAll(eachObjectToFieldMap.get(MAIN_QUERY_KEY));

                returnMap.put(frontEndSectionId, new Map<String, List<Portal_Page_Section_Setting__mdt>>{MAIN_QUERY_KEY => pageSectionSettingList});
            } else {
                returnMap.put(frontEndSectionId, eachObjectToFieldMap);
            }

        }       

        return returnMap;
    }

    /**
     * Create mapping of front end field id to staging record api names
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   frontEndIdToFrontEndIdToPageSectionSettingMap   Map of front end section id -> subsection -> page section settings
     * 
     * @return  Map: Main section -> front end field id -> staging record api names                                  
     */
    private Map<String, Map<String, Object>> createFrontEndIdToStagingApiNameMap(Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> frontEndIdToFrontEndIdToPageSectionSettingMap) {
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();

        if (frontEndIdToFrontEndIdToPageSectionSettingMap == null || frontEndIdToFrontEndIdToPageSectionSettingMap.isEmpty()) {
            return returnMap;
        }

        for(String eachMainFrontEndId : frontEndIdToFrontEndIdToPageSectionSettingMap.keySet()) {
            if (String.isBlank(eachMainFrontEndId)) {
                continue;
            }

            Map<String, Object> frontEndIdToStagingApiNameMap = new Map<String, Object>();

            for (String eachSubsectionFrontEndId : frontEndIdToFrontEndIdToPageSectionSettingMap.get(eachMainFrontEndId).keySet()) {
                if (String.isBlank(eachSubsectionFrontEndId)) {
                    continue;
                }

                for (Portal_Page_Section_Setting__mdt eachPageSectionSetting : frontEndIdToFrontEndIdToPageSectionSettingMap.get(eachMainFrontEndId).get(eachSubsectionFrontEndId)) {
                    if (eachPageSectionSetting == null || eachPageSectionSetting.Portal_Section_Field_Settings__r == null) {
                        continue;
                    }

                     for (Portal_Section_Field_Setting__mdt eachSectionFieldSetting : eachPageSectionSetting.Portal_Section_Field_Settings__r) {
                        if (eachSectionFieldSetting == null || String.isBlank(eachSectionFieldSetting.Front_End_Field_Id__c)) {
                            continue;
                        }

                        frontEndIdToStagingApiNameMap.put(eachSectionFieldSetting.Front_End_Field_Id__c, eachSectionFieldSetting.Staging_Record_Field_API_Name__c);
                     }
                }
            }

            returnMap.put(eachMainFrontEndId, frontEndIdToStagingApiNameMap);
        }

        return returnMap;
    }

    /**
     * Converts front end fields to back end api fields
     * 
     * @author  Phillip Nguyen
     * @since   1.0 
     * 
     * @param   interimRecordsMap   Interim records from front end (enhancement) (phones -> phones -> [{phoneNumber : 000-000-0000}])
     * 
     * @return  Map of interim records that have been converted (phones -> ucinn_ascendv2__phone__c -> [{ucinn_ascendv2__phone_number__c : 000-000-0000}])
     */
    private Map<String, Object> convertFrontEndRecordFieldsToApiNamesForInterim(Map<String, Object> interimRecordsMap) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (interimRecordsMap == null || interimRecordsMap.isEmpty()) {
            return returnMap;
        }

        List<Portal_Page_Section_Setting__mdt> sectionSettingList = this.queryPageSectionSettings('My Information');

        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettingList);

        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> frontEndIdToFrontEndIdToPageSectionSettingMap = createInterimPageSectionSettingMap(pageSectionMap);  
        Map<String, Map<String, Object>> interimMainSectionToFrontEndIdToApiNameMap = createFrontEndIdToStagingApiNameMap(frontEndIdToFrontEndIdToPageSectionSettingMap); // interims -> interims -> {firstName => ucinn_ascendv2__first_name__c}
        Map<String, String> interimSubsectionIdsToSObjectNames = getInterimSubsectionNamesToSObjectApiNames();

        for (String eachFrontEndSectionId : interimRecordsMap.keySet()) {
            if (String.isBlank(eachFrontEndSectionId)) {
                continue;
            }

            Map<String, Object> subSectionMap = (Map<String, Object>)interimRecordsMap.get(eachFrontEndSectionId);
            Map<String, Object> newMap = new Map<String, Object>();

            if (subSectionMap == null || subSectionMap.isEmpty()) {
                continue;
            }

            for (String eachSubFrontEndSectionId : subSectionMap.keySet()) {
                if (String.isBlank(eachSubFrontEndSectionId)) {
                    continue;
                }

                List<Object> listOfUnconvertedRecords = (List<Object>)subSectionMap.get(eachSubFrontEndSectionId);
                List<Map<String,Object>> convertedRecords = new List<Map<String, Object>>();

                if (listOfUnconvertedRecords == null || listOfUnconvertedRecords.isEmpty()) {
                    continue;
                }

                for (Object eachRecordObject : listOfUnconvertedRecords) {
                    if (eachRecordObject == null) {
                        continue;
                    }

                    Map<String, Object> eachRecordMap = (Map<String, Object>)eachRecordObject;
                    Map<String, Object> newRecordMap = new Map<String, Object>();

                    if (eachRecordMap == null || eachRecordMap.isEmpty()) {
                        continue;
                    }

                    String interimMainSectionValue = (eachFrontEndSectionId == SPOUSAL_INTERIM_KEY) ? INTERIMS_FRONT_END_NAME : eachFrontEndSectionId;

                    for (String eachField : eachRecordMap.keySet()) {
                        String fieldApiName = (String)interimMainSectionToFrontEndIdToApiNameMap?.get(interimMainSectionValue)?.get(eachField);
                        if (String.isBlank(eachField) || String.isBlank(fieldApiName)) {
                            continue;
                        }
                        
                        populateBackEndRecordWithFrontEndData(newRecordMap, eachRecordMap?.get(eachField), fieldApiName, interimSubsectionIdsToSObjectNames?.get(eachSubFrontEndSectionId));
                    }

                    convertedRecords.add(newRecordMap);
                }

                newMap.put(interimSubsectionIdsToSObjectNames?.get(eachSubFrontEndSectionId), convertedRecords);
            }

            returnMap.put(eachFrontEndSectionId, newMap);
        }

        return returnMap;
    }

    /**
     * Converts back end interim records to front end
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   interimRecordsMap       List of interim records
     * @param   interimPageSectionMap   Page section map for records to use for front end field ids
     * 
     * @return  Interim records that have been wrapped
     */
    private Map<String, Map<String, List<Map<String, Object>>>> convertBackEndInterimRecordToFrontEnd(Map<String, Map<String, List<sObject>>> interimRecordsMap, 
                                                                                                      Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> interimPageSectionMap) {
        Map<String, Map<String, List<Map<String, Object>>>> returnMap = new Map<String, Map<String, List<Map<String, Object>>>>();
        
        if (interimRecordsMap == null || interimRecordsMap.isEmpty() || interimPageSectionMap == null || interimPageSectionMap.isEmpty()) {
            return returnMap;
        }

        for (String eachSectionId : interimRecordsMap.keySet()) {
            if (String.isBlank(eachSectionId) || interimRecordsMap.get(eachSectionId) == null || interimRecordsMap.get(eachSectionId).keySet().isEmpty()) {
                continue;
            }

            Map<String, List<Map<String, Object>>> newMap = new Map<String, List<Map<String, Object>>>();
            for (String eachSubSection : interimRecordsMap.get(eachSectionId).keySet()) {
                if (String.isBlank(eachSubSection) || interimRecordsMap.get(eachSectionId)?.get(eachSubSection) == null || interimRecordsMap.get(eachSectionId)?.get(eachSubSection)?.isEmpty()) {
                    continue;
                }

                String convertRecordsToWrapperParam = (eachSectionId == SPOUSAL_INTERIM_KEY) ? INTERIMS_FRONT_END_NAME : eachSectionId;

                newMap.put(eachSectionId, convertRecordsToWrapper(interimRecordsMap.get(eachSectionId)?.get(eachSubSection), interimPageSectionMap?.get(convertRecordsToWrapperParam)));
            }

            returnMap.put(eachSectionId, newMap);
        }

        return returnMap;
    }

    /**
     * Convert self report record from front end to back end, by replacing front end field id with api names
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   frontEndRecord                              Front end record from self report
     * @param   frontEndFieldIdToStagingRecordApiNameMap    Front end field id -> staging record api name map
     * 
     * @return  Record that now has staging record field api names
     */
    private Map<String, Object> convertSelfReportFrontEndRecordToBackEnd(Map<String, Object> frontEndRecord, Map<String, Object> frontEndFieldIdToStagingRecordApiNameMap) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (frontEndRecord == null || frontEndRecord.isEmpty() || frontEndFieldIdToStagingRecordApiNameMap == null || frontEndFieldIdToStagingRecordApiNameMap.isEmpty()) {
            return returnMap;
        }

        for (String eachFrontEndField : frontEndRecord.keySet()) {
            if (String.isBlank(eachFrontEndField) || frontEndFieldIdToStagingRecordApiNameMap.get(eachFrontEndField) == null) {
                continue;
            }

            returnMap.put((String)frontEndFieldIdToStagingRecordApiNameMap.get(eachFrontEndField), frontEndRecord.get(eachFrontEndField));
        }

        return returnMap;
    }

    /**
     * Create mapping of front end field Id to staging record api names
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   pageSectionSettingList  Page section setting list
     * @return  Map of front end field id to staging record api names
     */
    private Map<String, Object> createFieldIdToStagingRecordMap(List<Portal_Page_Section_Setting__mdt> pageSectionSettingList) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (pageSectionSettingList == null || pageSectionSettingList.isEmpty()) {
            return returnMap;
        }

        for (Portal_Page_Section_Setting__mdt eachPageSectionSetting : pageSectionSettingList) {
            if (eachPageSectionSetting == null) {
                continue;
            }

            for (Portal_Section_Field_Setting__mdt eachFieldSetting : eachPageSectionSetting.Portal_Section_Field_Settings__r) {
                if (eachFieldSetting == null || String.isBlank(eachFieldSetting.Front_End_Field_Id__c) 
                    || String.isBlank(eachFieldSetting.Staging_Record_Field_API_Name__c)) {
                        continue;
                }

                returnMap.put((String)eachFieldSetting.Front_End_Field_Id__c, eachFieldSetting.Staging_Record_Field_API_Name__c);
            }
        }
        return returnMap;
    }


    /**
     * Mapping of interim subsection names (usually front end section id) to their corresponding object api name
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @return  Map of front end interim subsection names to corresponding object api name
     */
    global virtual Map<String, String> getInterimSubsectionNamesToSObjectApiNames() {
        if (interimSubsectionNameToSObjectApiNameMap == null || interimSubsectionNameToSObjectApiNameMap.isEmpty()) {
            interimSubsectionNameToSObjectApiNameMap = new Map<String, String>{'employment' => 'ucinn_ascendv2__Affiliation__c',
                                                                            'interims' => 'ucinn_ascendv2__Interim__c',
                                                                            'spousalInterim' => 'ucinn_ascendv2__Interim__c',
                                                                            'schoolDegrees' => DEGREE_INFORMATION_API_NAME,
                                                                            'nonSchoolDegrees' => DEGREE_INFORMATION_API_NAME,
                                                                            'schoolDegreesSelfReport' => DEGREE_INFORMATION_API_NAME, 
                                                                            'nonSchoolDegreesSelfReport' => DEGREE_INFORMATION_API_NAME,
                                                                            'emails' => 'ucinn_ascendv2__Email__c',
                                                                            'phones' => 'ucinn_ascendv2__Phone__c',
                                                                            'addresses' => ADDRESS_RELATION_API_NAME,
                                                                            'socialMedia' => 'ucinn_ascendv2__Social_Media__c'};
        }

        return interimSubsectionNameToSObjectApiNameMap;
    }

    /** 
     * method converts a list of sobject records into a wrapper object 
     * so that the field names will be masked on the front end based on
     * new field names found in custom metadata
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param records:                    The list of records we want to convert
     * @param objectToFieldMap:           Map that contains the custom metadata records needed to convert for the records
     * 
     * 
     * @return:                           The list of wrapped records
     * 
     * 
     */
    private static List<Map<String, Object>> convertRecordsToWrapper(List<sObject> records, Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap) {
        
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        
        if (objectToFieldMap == null || records == null) {
            return returnList;
        }

        for (sObject record : records) {
            Map<String, Object> wrapper = new Map<String, Object>();
            
            for (String objectName : objectToFieldMap.keyset()) {
                //populate the wrapper with the fields on the sobject
                if (objectName == MAIN_QUERY_KEY){
                    populateWrapper(record, wrapper, objectToFieldMap.get(objectName));
                } else {
                    
                    //if it is a relationship, wrap the relationship records before adding it to the wrapper
                    List<Map<String, Object>> relatedRecordAsMapList = new List<Map<String, Object>>();
                    List<sObject> relatedRecordList = record.getSObjects(objectName);
                    List<Portal_Page_Section_Setting__mdt> pageSettingList =  objectToFieldMap.get(objectName);
                    String relationshipId = objectName;
                    for (Portal_Page_Section_Setting__mdt pageSetting : pageSettingList) {
                        if (String.isNotBlank(pageSetting.Relationship_Wrapper_Id__c)) {
                            relationshipId = pageSetting.Relationship_Wrapper_Id__c;
                        }
                    }
                    if (relatedRecordList != null) {
                        for (sObject relatedRecord : relatedRecordList) {
                            Map<String, Object> relatedWrapper = new Map<String, Object>();
                            populateWrapper(relatedRecord, relatedWrapper, objectToFieldMap.get(objectName));
                            if (!relatedWrapper.isEmpty()) {
                                relatedRecordAsMapList.add(relatedWrapper);
                            }
                        }
                    }
                    if (wrapper.containsKey(relationshipId)) {
                        ((List<Map<String, Object>>)wrapper.get(relationshipId)).addAll(relatedRecordAsMapList);
                    } else {
                        //TODO do we want an relationship wrapper field name? Relationship_Front_End_Field_Id__c
                        wrapper.put(relationshipId, relatedRecordAsMapList);
                    }
                    
                }
            }  

            if (!wrapper.isEmpty()) {
                returnList.add(wrapper);   
            }
        }

        return returnList;
    }

    /** 
     * method populates a map of string object from a sobject record based
     * on predefined fields and field names on the custom metadata records
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param record:                                  Record we are trying to convert
     * @param wrapper:                                 The wrapper we are populated
     * @param sectionSettingList:                      List of custom metadata records needed to convert for the records
     * 
     * 
     */
    private static void populateWrapper(SObject record,  Map<String, Object> wrapper, List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            
            if (sectionSetting.Portal_Section_Field_Settings__r != null) {
                
                for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
                    //grabs the data from the field
                    if (String.isNotBlank(field.Staging_Record_Field_API_Name__c) && String.isNotBlank(field.Front_End_Field_Id__c)) {
                        
                        try {
                            //if the field is a relationship, grab the parent sobject before grabbing the field
                            if (field.Staging_Record_Field_API_Name__c.contains('.')) {
                                List<String> fieldSet = field.Staging_Record_Field_API_Name__c.split('\\.');
                                if (fieldSet.size() == 1) {
                                    continue;
                                }
                                sObject parentRecord = record;
                                for (Integer index = 0; index < fieldSet.size(); index++) {
                                    if (index == fieldSet.size()-1) {
                                        if (parentRecord != null) {
                                            wrapper.put(field.Front_End_Field_Id__c, parentRecord.get(fieldSet.get(index)));
                                        } else {
                                            wrapper.put(field.Front_End_Field_Id__c, null);
                                        }
                                    } else {
                                        if (parentRecord != null) {
                                            parentRecord = parentRecord.getSObject(fieldSet.get(index));
                                        } else {
                                            wrapper.put(field.Front_End_Field_Id__c, null);
                                            break;
                                        }
                                    }
                                } 

                            } else {
                                wrapper.put(field.Front_End_Field_Id__c, record.get(field.Staging_Record_Field_API_Name__c));
                            }
                        } catch (Exception e) {
                            System.debug('Could not get field in PORTAL_UTIL_PageSectionSetting.populateWrapper for ' + sectionSetting.Page_Name__c + ' in section ' + sectionSetting.Page_Main_Section__c + ' for field ' + field.Staging_Record_Field_API_Name__c);
                            System.debug(e.getStackTraceString());
                        }
                    }
                }

            }
        }
    }

    /**
     * Create front end inactive record field map. This is so records are hidden properly when using the enhancement for objects.
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   sectionSettingList      Section Setting List for My Information
     * 
     * @return                          Mapping of front end section id to inactive record field map with api names replaced with front end field ids
     */
    private Map<String, Object> createFrontEndInactiveRecordFieldMap(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, Object> returnMap = new Map<String, Object>();
        if (sectionSettingList == null || sectionSettingList.isEmpty()) {
            return returnMap;
        }

        for (Portal_Page_Section_Setting__mdt eachSectionSetting : sectionSettingList) {
            if (eachSectionSetting.Inactive_Record_Field_Map__c == null
                    || eachSectionSetting.Portal_Section_Field_Settings__r == null
                    || eachSectionSetting.Portal_Section_Field_Settings__r.isEmpty()) {
                continue;
            }

            Map<String, String> stagingRecordFieldApiNamesToFrontEndFieldIdMap = createStagingRecordFieldNameToFrontEndFieldIdMap(eachSectionSetting.Portal_Section_Field_Settings__r);

            if (stagingRecordFieldApiNamesToFrontEndFieldIdMap == null || stagingRecordFieldApiNamesToFrontEndFieldIdMap.isEmpty()) {
                continue;
            }

            Map<String, Object> inactiveRecordFieldMap = (Map<String, Object>) JSON.deserializeUntyped(eachSectionSetting.Inactive_Record_Field_Map__c);

            Map<String, Object> inactiveFrontEndFieldToValueMap = new Map<String, Object>();

            // example: 	{"ucinn_ascendv2__Status__c":"Former", "ucinn_ascendv2__Is_Preferred__c":false,
            //               "ucinn_ascendv2__End_Date__c":"", "ucinn_portal_Is_Show_On_Directory__c":false}
            for (String eachField : inactiveRecordFieldMap.keySet()) {
                if (String.isBlank(eachField) || String.isBlank(stagingRecordFieldApiNamesToFrontEndFieldIdMap.get(eachField))) {
                    continue;
                }

                inactiveFrontEndFieldToValueMap.put(stagingRecordFieldApiNamesToFrontEndFieldIdMap.get(eachField), inactiveRecordFieldMap.get(eachField));
            }

            returnMap.put(eachSectionSetting.Front_End_Section_Id__c, inactiveFrontEndFieldToValueMap);
        }

        return returnMap;
    }

    /**
     * Creates Staging Record Field Api Name To Front End Field Id Map to use in the front end to hide records for enhancement
     * 
     * @author      Phillip Nguyen
     * @since       1.0
     * 
     * @param       sectionFieldSettings        Portal Page Section Field Settings for My Information
     * 
     * @return                                  Map of Staging Record Field Api Names To Front End Field Ids
     */
    private Map<String, String> createStagingRecordFieldNameToFrontEndFieldIdMap(List<Portal_Section_Field_Setting__mdt> sectionFieldSettings) {
        Map<String, String> returnMap = new Map<String, String>();

        if (sectionFieldSettings == null || sectionFieldSettings.isEmpty()) {
            return returnMap;
        }

        for (Portal_Section_Field_Setting__mdt eachFieldSetting : sectionFieldSettings) {
            if (eachFieldSetting == null) {
                continue;
            }

            returnMap.put(eachFieldSetting.Staging_Record_Field_API_Name__c, eachFieldSetting.Front_End_Field_Id__c);
        }

        return returnMap;
    }

    /**
     * Find Interim Records that have been unchanged (not modified on front end)
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   allInterimRecords   ALl Interim Records queried in back end
     * @param   interimRecordMap    Interim Records from front end
     * @param   sectionSettingList  Section Setting List for My Information
     * 
     * @return                      Set of Interim Record Ids that have been unchanged (stayed the same)
     */
    private Set<String> getUnchangedInterimRecordIdsSet(Map<String, Map<String, List<SObject>>> allInterimRecords, Map<String, List<SObject>> interimRecordMap, List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Set<String> returnSet = new Set<String>();

        if (allInterimRecords == null || allInterimRecords.isEmpty() || interimRecordMap == null || interimRecordMap.isEmpty() || sectionSettingList == null || sectionSettingList.isEmpty()) {
            return returnSet;
        }

        List<SObject> allInterimRecordsList = convertAllInterimMapToList(new Map<String, Object>{PARAM_ALL_INTERIM_RECORDS => allInterimRecords});

        Map<Id, SObject> allInterimIdToRecordMap = new Map<Id, SObject>(allInterimRecordsList);

        for (Portal_Page_Section_Setting__mdt eachSectionSetting : sectionSettingList) {
            if (eachSectionSetting == null || eachSectionSetting.Staging_sObject_API_Name__c == MAIN_STAGING_RECORD_API_NAME) {
                continue;
            }

            List<SObject> interimRecordObjectList = convertFrontEndInterimToObjectList(eachSectionSetting.Staging_sObject_API_Name__c, interimRecordMap);

            for (SObject eachFrontEndInterimRecord : interimRecordObjectList) {
                String interimRecordApiName = String.valueOf(eachFrontEndInterimRecord.getSObjectType());

                if (eachFrontEndInterimRecord == null || interimRecordApiName == MAIN_STAGING_RECORD_API_NAME || eachSectionSetting.Staging_sObject_API_Name__c != interimRecordApiName) {
                    continue;
                }

                if (checkIfRecordsMatch(new Map<String, Object>{PARAM_NEW_RECORD => eachFrontEndInterimRecord, PARAM_OLD_RECORD => allInterimIdToRecordMap.get(eachFrontEndInterimRecord.Id), PARAM_SECTION_SETTING => eachSectionSetting})) {
                    returnSet.add(eachFrontEndInterimRecord.Id);
                }
            }
        }

        return returnSet;
    }

    /**
     *  Mutates newRecordMap, adds front end data to newRecordMap where it is going to be fieldApiName => data.
     * 
     *  We need to check for relationship here since when we converted code to use a wrapper, address and spousal information and other info
     *  are not structured properly and will cause data issues such as fields not saving and being null but no error appearing.
     *  From the front end the structure looks something like: Addresses -> Records -> {Id: ..., address__r.line1: ..., type:...}
     *  It needs to look like this as an example: Addresses -> records -> {Id: ..., address__r:{line1: ..., state: ...}, type: ...}
     * 
     *  Initial if statement checks for null record & skips the record population if the field is a relationship field and the record we will be populating is NOT an address record and NOT a spousal change.
     *  We skip if it fulfills those conditions since it will fail later on update if the record is modified (due to external Id error).
     *  Address has special logic in this code base that handles the relationship field api names so it will not error.
     *  Spousal changes also have special logic.
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   newRecordMap        Back end record map that is being populated
     * @param   fieldValue          Value of field on record coming from front end
     * @param   fieldApiName        Field Api Name on the newRecordMap that will be populated. 
     * @param   sectionName         Section Name of CMT we are using for conversion. Can be something like Personal_Information or Addresses
     */
    protected virtual void populateBackEndRecordWithFrontEndData(Map<String, Object> newRecordMap, Object fieldValue, String fieldApiName, String sectionName) {
        // There is no subsection on the CMT for just spouse so we need to check against the main section of the page section setting and the field itself if it contains spouse api name
        Boolean isNotAddressField = fieldApiName.contains('__r') && sectionName != ADDRESS_RELATION_API_NAME && sectionName != ADDRESSES_CONST;
        Boolean isNotSpouseField = !fieldApiName.contains(PREFERRED_SPOUSE) && sectionName != SPOUSE_MAIN_SECTION_NAME;

        if (newRecordMap == null || String.isBlank(fieldApiName) || (isNotAddressField && isNotSpouseField)) {
            return;
        }

        if (fieldApiName.contains('__r')) {
            List<String> fields = fieldApiName.split('\\.');

            if (fields == null || fields.isEmpty() || fields.size() < 2) {
                return;
            }

            if (newRecordMap.get(fields.get(0)) != null) {
                Map<String, Object> fieldMap = (Map<String, Object>)newRecordMap.get(fields?.get(0));
                fieldMap?.put((String)fields.get(1), fieldValue);
                newRecordMap.put(fields.get(0), fieldMap);
            } else {
                newRecordMap.put(fields.get(0), new Map<String, Object>{(String)fields.get(1) => fieldValue});
            }
        } else {
            newRecordMap.put(fieldApiName, fieldValue);
        }
    }
}