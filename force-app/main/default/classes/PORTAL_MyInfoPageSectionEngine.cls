/*
* Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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

public inherited sharing virtual class PORTAL_MyInfoPageSectionEngine extends PORTAL_MyInfoRetriever.EngineAdapter {
    protected PORTAL_PageSectionAdapter pageSectionAdapter;
    protected PORTAL_PageSectionAdapter selfReportPageSectionAdapter;
    private Boolean hasPicklistValuesInConfiguration;
    
    /**
     * Private constructor, use builder
     * @since 1.10
     */
    private PORTAL_MyInfoPageSectionEngine() { }

    /**
     * Builder class used to construct PORTAL_MyInfoPageSectionEngine.
     */
    public virtual class Builder {
        PORTAL_MyInfoPageSectionEngine result;

        /**
         * Constructor for the builder class.
         *
         * @author  Todd Shinto
         * @since   1.5
         */
        public Builder(){
            result = new PORTAL_MyInfoPageSectionEngine();
        }

        /**
         * Sets whether to include picklist values in the configuration for the PORTAL_MyInfoPageSectionEngine object.
         *
         * @author  Jacob Huang
         * @since   1.8
         *
         * @param hasPicklistValuesInConfiguration     Boolean: add picklist values when getting page section setting configuration info
         * 
         * @return                                     This instance of the builder class.
         */
        public Builder buildHasPicklistValuesInConfiguration(Boolean hasPicklistValuesInConfiguration) {
            this.result.hasPicklistValuesInConfiguration = hasPicklistValuesInConfiguration;
            return this;
        }

        /**
         * Sets the already-built Page Section Adapter for the My Info section
         * 
         * @author Jacob Huang
         * @since 1.10
         * 
         * @param pageSectionAdapter        PORTAL_PageSectionAdapter: page section adapter for the section
         * 
         * @return                          The instance of the builder class
         */
        public Builder buildPageSectionAdapter(PORTAL_PageSectionAdapter pageSectionAdapter) {
            this.result.pageSectionAdapter = pageSectionAdapter;
            return this;
        }

        /**
         * Sets the already-built Page Section Adapter for the My Info Self Report section
         * 
         * @author Jacob Huang
         * @since 1.10
         * 
         * @param selfReportPageSectionAdapter      PORTAL_PageSectionAdapter: page section adapter for the Self Report section
         * 
         * @return                                  The instance of the builder class
         */
        public Builder buildSelfReportPageSectionAdapter(PORTAL_PageSectionAdapter selfReportPageSectionAdapter) {
            this.result.selfReportPageSectionAdapter = selfReportPageSectionAdapter;
            return this;
        }

        /**
         * Returns an instance of PORTAL_MyInfoPageSectionEngine. 
         * Requires at least 1 Page Section Adapter to be non-null
         *
         * @author Todd Shinto
         * @since 1.5
         *
         * @return  Configured instance of PORTAL_MyInfoPageSectionEngine.
         */
        public virtual PORTAL_MyInfoPageSectionEngine build() {       
            if (this.result.pageSectionAdapter == null && this.result.selfReportPageSectionAdapter == null) {
                return null;
            }

            return result;
        }
    }

    /**
     * Gets the configurations as a string
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @return  The configurations as a string
     */
    public virtual override String getFrontEndConfigurationsString() {
        return JSON.serialize(getFrontEndConfigurations());
    }

    /**
     * Gets the back end configurations as a string
     *
     * @author: Phillip
     * @since:  1.7
     *
     * @return  The configurations as a string
     */
    public virtual override String getBackEndConfigurationsString() {
        return JSON.serialize(getBackEndConfigurations());
    }

    /**
     * Gets the frontEndDataMap from PORTAL_UTIL_PageSectionSetting, as well as org wide settings
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @return  The configurations and org wide settings
     */
    protected virtual PORTAL_MyInfoRetriever.MyInfoConfiguration getFrontEndConfigurations() {
        Map<String, Object> frontEndDataMap = this.pageSectionAdapter?.getFrontEndDataMap();
        Map<String, Object> selfReportFrontEndDataMap = this.selfReportPageSectionAdapter?.getFrontEndDataMap();

        PORTAL_MyInfoRetriever.MyInfoConfiguration myInfoConfiguration = getMyInfoConfiguration(frontEndDataMap, selfReportFrontEndDataMap);

        return myInfoConfiguration;
    }

    /**
     * Gets the back end data map from PORTAL_UTIL_PageSectionSetting, as well as org wide settings
     * Prefer using the regular My Info adapter over the Self Report adapter
     *
     * @author: Phillip Nguyen
     * @since:  1.7
     *
     * @return  The configurations and org wide settings
     */
    protected virtual PORTAL_MyInfoRetriever.MyInfoConfiguration getBackEndConfigurations() {
        PORTAL_PageSectionAdapter adapter = (this.pageSectionAdapter != null) ? this.pageSectionAdapter : this.selfReportPageSectionAdapter;
        Map<String, Object> backEndDataMap = adapter?.getBackEndDataMap();
        
        PORTAL_MyInfoRetriever.MyInfoConfiguration myInfoConfiguration = getMyInfoConfiguration(backEndDataMap, null);

        return myInfoConfiguration;
    }

    /**
     * Extracts the necessary data to build MyInfoConfiguration from the dataMap and org wide settings
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param dataMap:              The data map returned from PORTAL_UTIL_PageSectionSetting
     * @param selfReportDataMap:    The data map for self report sections returned from PORTAL_UTIL_PageSectionSetting
     * 
     * @return                      MyInfoConfiguration
     */
    protected virtual PORTAL_MyInfoRetriever.MyInfoConfiguration getMyInfoConfiguration(Map<String, Object> dataMap, Map<String, Object> selfReportDataMap) {
        PORTAL_MyInfoRetriever.MyInfoConfiguration myInfoConfig = new PORTAL_MyInfoRetriever.MyInfoConfiguration();
        
        if (dataMap == null || dataMap.isEmpty()) {
            return myInfoConfig;
        }

        myInfoConfig.sectionConfigurationMap = this.getSectionConfiguration(dataMap);
        myInfoConfig.selfReportSectionConfigurationMap = this.getSectionConfiguration(selfReportDataMap);

        ucinn_ascendv2__Org_Wide_Configuration__c orgWideSetting = this.getOrgWideSettings();
        myInfoConfig.isMultipleCurrentAddressesEnabled = orgWideSetting?.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c;
        myInfoConfig.isMultipleCurrentEmailsEnabled = orgWideSetting?.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c;
        myInfoConfig.isMultipleCurrentPhonesEnabled = orgWideSetting?.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c;
        
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{PORTAL_MyInfoRetriever.VALUE_FIELD},
            PORTAL_Utils.SOBJECT_NAME => PORTAL_MyInfoRetriever.PORTAL_ORGANIZATION_SETTING,
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{PORTAL_MyInfoRetriever.MY_INFORMATION_REQUEST_UPDATE_RICH_TEXT, PORTAL_MyInfoRetriever.MY_INFORMATION_ADDRESS_AUTOCOMPLETE}
        });

        if (orgSettingList == null || orgSettingList.isEmpty()) {
            return myInfoConfig;
        }

        for (Portal_Organization_Setting__mdt eachSetting : orgSettingList) { 
            if (eachSetting.DeveloperName == PORTAL_MyInfoRetriever.MY_INFORMATION_REQUEST_UPDATE_RICH_TEXT) {
                myInfoConfig.requestUpdateRichText = eachSetting.Value__c;
            } else if (eachSetting.DeveloperName == PORTAL_MyInfoRetriever.MY_INFORMATION_ADDRESS_AUTOCOMPLETE) {
                myInfoConfig.hasAddressAutocomplete = 'true'.equalsIgnoreCase(eachSetting.Value__c);
            }
        }

        return myInfoConfig;
    }

    /**
     * Gets the section configurations
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param frontEndDataMap:      The frontEndDataMap returned from PORTAL_UTIL_PageSectionSetting
     * 
     * @return                      A map of the front end section ID to SectionConfiguration
     */
    protected virtual Map<String, PORTAL_MyInfoRetriever.SectionConfiguration> getSectionConfiguration(Map<String, Object> frontEndDataMap) {
        Map<String, PORTAL_MyInfoRetriever.SectionConfiguration> sectionConfigurationMap = new Map<String, PORTAL_MyInfoRetriever.SectionConfiguration>();

        if (frontEndDataMap == null) {
            return sectionConfigurationMap;
        }

        for (String eachFrontEndSectionIdKey : frontEndDataMap.keySet()) {
            Map<String, Object> sectionMap = (Map<String, Object>)frontEndDataMap?.get(eachFrontEndSectionIdKey);
            if ((Boolean)sectionMap.get(PORTAL_CONST_PageSectionSetting.IS_SECTION) == true) {
                sectionConfigurationMap.put(eachFrontEndSectionIdKey, createSectionConfiguration((Map<String, Object>)frontEndDataMap.get(eachFrontEndSectionIdKey)));
            }
        }
        
        return sectionConfigurationMap;
    }

    /**
     * Formats the front end section into SectionConfiguration
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param sectionMap:       The configuration map of a section
     * 
     * @return                  SectionConfiguration
     */
    protected virtual PORTAL_MyInfoRetriever.SectionConfiguration createSectionConfiguration(Map<String, Object> sectionMap) {
        PORTAL_MyInfoRetriever.SectionConfiguration sectionConfigurationMap = new PORTAL_MyInfoRetriever.SectionConfiguration();

        sectionConfigurationMap.sectionId = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SECTION_ID);
        sectionConfigurationMap.sectionDescription = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SECTION_DESCRIPTION);
        sectionConfigurationMap.sectionName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SUB_SECTION_NAME) == null ? (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.MAIN_SECTION_NAME) : (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SUB_SECTION_NAME);
        sectionConfigurationMap.label = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.LABEL_CONST);
        sectionConfigurationMap.isDisplay = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.DISPLAY_CONST);
        sectionConfigurationMap.isDisable = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.DISABLE_CONST);
        sectionConfigurationMap.isToggleOnSection = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.TOGGLE_ON_SECTION);
        sectionConfigurationMap.isTogglePerRecord = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.TOGGLE_PER_RECORD);
        sectionConfigurationMap.hasReportUpdateLink = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.REPORT_UPDATE_LINK);
        sectionConfigurationMap.fieldConfigurationMap = getFieldConfiguration((Map<String, Object>)sectionMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_MAP));
        sectionConfigurationMap.mainSectionName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.MAIN_SECTION_NAME);
        sectionConfigurationMap.subSectionName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SUB_SECTION_NAME);
        sectionConfigurationMap.sObjectApiName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.OBJECT_API_NAME);

        sectionConfigurationMap.recordTypeDeveloperName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.RECORD_TYPE_DEVELOPER_NAME);
        sectionConfigurationMap.stagingRecordTypeDeveloperName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_TYPE_DEVELOPER_NAME);

        sectionConfigurationMap.isCreateStagingRecordUponCreation = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.IS_CREATE_STAGING_RECORD_UPON_CREATION);
        sectionConfigurationMap.isCreateStagingRecordUponEdit = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.IS_CREATE_STAGING_RECORD_UPON_EDIT);

        sectionConfigurationMap.controllingParentField = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.CONTROLLING_PARENT_FIELD_NAME);
        sectionConfigurationMap.stagingRecordObjectName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_OBJECT_NAME);
        sectionConfigurationMap.stagingRecordControllingParentField = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_CONTROLLING_PARENT_FIELD);
        sectionConfigurationMap.originalRecordName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD_FIELD_API_NAME);

        sectionConfigurationMap.controllingParentObject = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.CONTROLLING_PARENT_OBJECT);
        sectionConfigurationMap.stagingRecordControllingParentObject = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_CONTROLLING_PARENT_OBJECT);
        
        sectionConfigurationMap.isHardDeleteRecords = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.IS_HARD_DELETE_RECORDS);
        
        sectionConfigurationMap.activeRecordFieldMapString = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.ACTIVE_RECORD_FIELD_MAP);
        sectionConfigurationMap.inactiveRecordFieldMapString = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.INACTIVE_RECORD_FIELD_MAP);
        
        sectionConfigurationMap.duplicateFieldLogic = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.DUPLICATE_FIELD_LOGIC);
        sectionConfigurationMap.hasDuplicateLogic = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.HAS_DUPLICATE_LOGIC);

        sectionConfigurationMap.whereClause = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.WHERE_CLAUSE);
        sectionConfigurationMap.orderByClause = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.ORDER_BY_CLAUSE);
        sectionConfigurationMap.maxNumberOfQueryRecords = String.valueOf(Integer.valueOf(sectionMap?.get(PORTAL_CONST_PageSectionSetting.MAX_NUMBER_OF_QUERY_RECORDS)));

        return sectionConfigurationMap;
    }

    /**
     * Gets the field configurations
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param fieldMap:      The fieldMap of the section
     * 
     * @return               A map of FieldConfigurations
     */
    protected virtual Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> getFieldConfiguration(Map<String, Object> fieldMap) {
        if (fieldMap == null || fieldMap.isEmpty()) {
            return new Map<String, PORTAL_MyInfoRetriever.FieldConfiguration>();
        }

        Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigurationMap = new Map<String, PORTAL_MyInfoRetriever.FieldConfiguration>();        
        for (String eachFieldId : fieldMap.keySet()) {
            fieldConfigurationMap.put(eachFieldId, createFieldConfiguration((Map<String, Object>)fieldMap.get(eachFieldId)));
        }
        
        return fieldConfigurationMap;
    }

    /**
     * Formats the field configurations
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param fieldConfigurationMap:      The front end field configurations
     * 
     * @return                            FieldConfiguration
     */
    protected virtual PORTAL_MyInfoRetriever.FieldConfiguration createFieldConfiguration(Map<String, Object> fieldConfigurationMap) {
        PORTAL_MyInfoRetriever.FieldConfiguration fieldConfiguration = new PORTAL_MyInfoRetriever.FieldConfiguration();
        fieldConfiguration.fieldId = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_ID);  // front end field id
        fieldConfiguration.fieldName = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_NAME);  // field api name
        fieldConfiguration.fieldType = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_TYPE);
        fieldConfiguration.label = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.LABEL_CONST);
        fieldConfiguration.stagingRecordFieldName = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_FIELD_NAME);
        fieldConfiguration.isDisable = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.DISABLE_CONST);
        fieldConfiguration.isDisplay = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.DISPLAY_CONST);
        fieldConfiguration.isLookup = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_LOOKUP);
        fieldConfiguration.isPicklist = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_PICKLIST);
        fieldConfiguration.isTextArea = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_TEXT_AREA);
        fieldConfiguration.isRichText = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_RICH_TEXT);
        fieldConfiguration.isRequired = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_REQUIRED);
        fieldConfiguration.hasReportUpdateLink = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.REPORT_UPDATE_LINK);
        fieldConfiguration.hasToggle = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.TOGGLE_CONST);
        fieldConfiguration.customMetadataApiName = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.CUSTOM_METADATA_API_NAME);
        fieldConfiguration.customMetadataDeveloperName = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.CUSTOM_METADATA_DEVELOPER_NAME);

        fieldConfiguration.isCreateNewRecord = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_CREATE_NEW_RECORD);
        fieldConfiguration.isCreateStagingRecordOnFieldChange = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_CREATE_STAGING_RECORD_ON_FIELD_CHANGE);

        fieldConfiguration.picklistValues = this.hasPicklistValuesInConfiguration == true ? this.pageSectionAdapter?.getPicklistMap().get(fieldConfiguration.fieldId) : null;

        fieldConfiguration.fieldOrderForDuplicateLogic = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_ORDER_FOR_DUPLICATE_LOGIC);

        return fieldConfiguration;
    }

    /**
     * Queries for the org wide configuration
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @return                  Org wide setting
     */
    protected virtual ucinn_ascendv2__Org_Wide_Configuration__c getOrgWideSettings() {
        List<ucinn_ascendv2__Org_Wide_Configuration__c> orgSettings = [SELECT ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c,
                                                                              ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c,
                                                                              ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c
                                                                         FROM ucinn_ascendv2__Org_Wide_Configuration__c 
                                                                        LIMIT 1];
        if (orgSettings.isEmpty()) {
            return null;
        }

        return orgSettings?.get(0);
    }

    /**
     * Gets the recordMap and formats the records
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param fieldConfigurationMap:      The front end field configurations
     * @param isGetAllRecords             Boolean determining if we query for all the records (includes inactive)
     * 
     * @return                            A map of the record ID to the record
     */
    public virtual override Map<String, Map<String, Object>> retrieveRecordMap(Boolean isGetAllRecords) {
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();
        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = this.pageSectionAdapter?.getRecords(isGetAllRecords, true);
        String mainSectionName = this.pageSectionAdapter?.getMainSectionName();

        if (recordsMap == null || recordsMap.isEmpty()) {
            return returnMap;
        }

        for (String eachSubSectionName : recordsMap.get(mainSectionName).keySet()) {
            List<Map<String, Object>> recordList = (List<Map<String, Object>>)recordsMap.get(mainSectionName).get(eachSubSectionName);
            
            returnMap.putAll(getRecordIdToRecordMap(recordList));
        }

        return returnMap;
    }

    /**
     * Builds a map of the records, using the record ID as a key
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param recordsList:  The list of records queried for
     * 
     * @return              A map of records that uses the ID as a key
     */
    protected virtual Map<String, Map<String, Object>> getRecordIdToRecordMap(List<Map<String, Object>> recordsList) {
        Map<String, Map<String, Object>> records = new Map<String, Map<String, Object>>();
        if (recordsList == null || recordsList.isEmpty()) {
            return records;
        }

        for (Map<String, Object> eachRecord : recordsList) {
            records.put((String)eachRecord.get(PORTAL_CONST_PageSectionSetting.ID_CONST), eachRecord);
        }

        return records;
    }

    /**
     * Gets the staging records map
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @return  The staging record map
     */
    public virtual override Map<String, Map<String, Object>> retrieveStagingRecordMap() {
        return this.retrieveStagingRecordMap(this.pageSectionAdapter?.getStagingRecords());
    }

    /**
     * Builds the staging record map
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param stagingRecordsMap:    The response json as a map
     * 
     * @return                      A map of the related records, using the record Id as a key
     */
    protected virtual Map<String, Map<String, Object>> retrieveStagingRecordMap(Map<String, List<Map<String, Object>>> stagingRecordsMap) {
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();

        for (String eachSectionKey : stagingRecordsMap.keySet()) {
            for (Map<String, Object> eachStagingRecord : stagingRecordsMap.get(eachSectionKey)) {
                returnMap.put((String)eachStagingRecord?.get(PORTAL_CONST_PageSectionSetting.ID_CONST), eachStagingRecord);
            }
        }

        return returnMap;
    }

    /**
     * Get self-reported staging records
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @return list of self-reported staging records
     */
    public virtual override List<Map<String, Object>> retrieveSelfReportRecordList() {
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        Map<String, List<Map<String, Object>>> stagingRecords = this.selfReportPageSectionAdapter?.getStagingRecords();
        
        if (stagingRecords == null || stagingRecords.isEmpty()) {
            return returnList;
        }

        for (List<Map<String, Object>> eachSectionRecordList : stagingRecords.values()) {
            returnList.addAll(eachSectionRecordList);
        }

        return returnList;
    }

    /**
     * Convert SObject records to wrappers using page section settings
     * Prefer using the regular My Info adapter over the Self Report adapter
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param sObjectList       List<SObject>: SObject records to convert to wrappers
     * @param isStagingRecords  Boolean: specifies whether the records are staging records or not
     * 
     * @return list of record maps
     */
    public virtual override List<Map<String, Object>> convertRecordsToWrapper(List<SObject> sObjectList, Boolean isStagingRecords) {
        PORTAL_PageSectionAdapter adapter = (this.pageSectionAdapter != null) ? this.pageSectionAdapter : this.selfReportPageSectionAdapter;
        return adapter?.convertRecordsToWrapper(sObjectList, isStagingRecords);
    }
}