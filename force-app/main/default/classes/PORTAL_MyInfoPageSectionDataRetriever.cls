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

public inherited sharing virtual class PORTAL_MyInfoPageSectionDataRetriever extends PORTAL_MyInfoDisplayInfoRetriever.DataRetriever {
    private String pageName;
    private String mainSectionName;
    private String subSectionName;
    private String parentFieldId;
    private String stagingRecordParentFieldId;
    private PORTAL_PageSectionAdapter pageSectionAdapter;    
    private Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> sectionNameToDynamicOverrideClassMap;
    private List<Portal_Page_Section_Setting__mdt> pageSectionSettingList;
    
    /**
     * Builder class used to construct PORTAL_MyInfoPageSectionDataRetriever.
     */
    public virtual class Builder {
        PORTAL_MyInfoPageSectionDataRetriever result;
        PORTAL_PageSectionAdapter.Builder adapterBuilder;

        /**
         * Constructor for the builder class.
         *
         * @author  Todd Shinto
         * @since   1.5
         */
        public Builder(){
            adapterBuilder = new PORTAL_PageSectionAdapter.Builder();
            result = new PORTAL_MyInfoPageSectionDataRetriever();
        }

        /**
         * Sets the page name for the PORTAL_MyInfoPageSectionDataRetriever object.
         *
         * @author  Todd Shinto
         * @since   1.5
         *
         * @param pageName  The page name of the Portal Page Section Setting.
         * 
         * @return          This instance of the builder class.
         */
        public Builder buildPageName(String pageName) {
            this.adapterBuilder.buildPageName(pageName);
            this.result.pageName = pageName;

            return this;
        }

        /**
         * Sets the main section name for the PORTAL_MyInfoPageSectionDataRetriever object.
         *
         * @author  Todd Shinto
         * @since   1.5
         *
         * @param mainSectionName   The main section name of the Portal Page Section Setting.
         * 
         * @return                  This instance of the builder class.
         */
        public Builder buildMainSectionName(String mainSectionName) {
            this.adapterBuilder.buildMainSectionName(mainSectionName);
            this.result.mainSectionName = mainSectionName;

            return this;
        }

        /**
         * Sets the sub section name for the PORTAL_MyInfoPageSectionDataRetriever object.
         *
         * @author  Todd Shinto
         * @since   1.5
         *
         * @param subSectionName    The subsection name of the Portal Page Section Setting.
         * 
         * @return                  This instance of the builder class.
         */
        public Builder buildSubSectionName(String subSectionName) {
            this.adapterBuilder.buildSubSectionName(subSectionName);
            this.result.subSectionName = subSectionName;

            return this;
        }

        /**
         * Sets the parent field id for the PORTAL_MyInfoPageSectionDataRetriever object.
         *
         * @author  Todd Shinto
         * @since   1.5
         *
         * @param parentFieldId     The parent field id to use for callouts to PORTAL_UTIL_PageSectionSettings.
         * 
         * @return                  This instance of the builder class.
         */
        public Builder buildParentFieldId(String parentFieldId) {
            this.adapterBuilder.buildParentFieldId(parentFieldId);
            this.result.parentFieldId = parentFieldId;

            return this;
        }

        /**
         * Sets the staging record parent field id for the PORTAL_MyInfoPageSectionDataRetriever object.
         *
         * @author  Todd Shinto
         * @since   1.5
         *
         * @param parentFieldId     The parent field id to use for callouts to PORTAL_UTIL_PageSectionSettings.
         * 
         * @return                  This instance of the builder class.
         */
        public Builder buildStagingRecordParentFieldId(String stagingRecordParentFieldId) {
            this.adapterBuilder.buildStagingRecordParentFieldId(stagingRecordParentFieldId);
            this.result.stagingRecordParentFieldId = stagingRecordParentFieldId;

            return this;
        }

        /**
         * Sets the dynamic query for the PORTAL_MyInfoPageSectionDataRetriever object.
         *
         * @author  Todd Shinto
         * @since   1.5
         *
         * @param sectionNameToDynamicOverrideClassMap  The dynamic query to use for callouts to PORTAL_UTIL_PageSectionSettings.
         * 
         * @return                                      This instance of the builder class.
         */
        public Builder buildDynamicQuery(Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> sectionNameToDynamicOverrideClassMap) {
            this.adapterBuilder.buildDynamicQuery(sectionNameToDynamicOverrideClassMap);
            this.result.sectionNameToDynamicOverrideClassMap = sectionNameToDynamicOverrideClassMap;

            return this;
        }

        /**
         * Returns an instance of PORTAL_MyInfoPageSectionDataRetriever. Page Name is a required field, and a query is done
         * to get the page section setting custom metadata records.
         *
         * @author Todd Shinto
         * @since   1.5
         *
         * @return  Configured instance of PORTAL_PageSectionAdapter.
         */
        public virtual PORTAL_MyInfoPageSectionDataRetriever build() {       
            if (String.isBlank(this.result.pageName)) {
                return null;
            }

            this.result.pageSectionAdapter = this.adapterBuilder.build();

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
    public virtual override String getConfigurationsString() {
        return JSON.serialize(getConfigurations());
    }

    /**
     * Gets the frontEndDataMap from PORTAL_UTIL_PageSectionSetting, as well as org wide settings
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @return  The configurations and org wide settings
     */
    private virtual PORTAL_MyInfoDisplayInfoRetriever.MyInfoConfiguration getConfigurations() {
        Map<String, Object> frontEndDataMap = this.pageSectionAdapter.getFrontEndDataMap();
        
        PORTAL_MyInfoDisplayInfoRetriever.MyInfoConfiguration myInfoConfiguration = getMyInfoConfiguration(frontEndDataMap);

        return myInfoConfiguration;
    }

    /**
     * Extracts the necessary data to build MyInfoConfiguration from the frontEndDataMap and org wide settings
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param frontEndDataMap:      The frontEndDataMap returned from PORTAL_UTIL_PageSectionSetting
     * 
     * @return                      MyInfoConfiguration
     */
    private virtual PORTAL_MyInfoDisplayInfoRetriever.MyInfoConfiguration getMyInfoConfiguration(Map<String, Object> frontEndDataMap) {
        PORTAL_MyInfoDisplayInfoRetriever.MyInfoConfiguration myInfoConfig = new PORTAL_MyInfoDisplayInfoRetriever.MyInfoConfiguration();
        
        if (frontEndDataMap == null || frontEndDataMap.isEmpty()) {
            return myInfoConfig;
        }

        ucinn_ascendv2__Org_Wide_Configuration__c orgWideSetting = getOrgWideSettings();

        myInfoConfig.isMultipleCurrentAddressesEnabled = orgWideSetting?.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c;
        myInfoConfig.isMultipleCurrentEmailsEnabled = orgWideSetting?.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c;
        myInfoConfig.isMultipleCurrentPhonesEnabled = orgWideSetting?.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c;
        myInfoConfig.sectionConfigurationMap = getSectionConfiguration(frontEndDataMap);
        
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
    private virtual Map<String, PORTAL_MyInfoDisplayInfoRetriever.SectionConfiguration> getSectionConfiguration(Map<String, Object> frontEndDataMap) {
        Map<String, PORTAL_MyInfoDisplayInfoRetriever.SectionConfiguration> sectionConfigurationMap = new Map<String, PORTAL_MyInfoDisplayInfoRetriever.SectionConfiguration>();

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
    private virtual PORTAL_MyInfoDisplayInfoRetriever.SectionConfiguration createSectionConfiguration(Map<String, Object> sectionMap) {
        PORTAL_MyInfoDisplayInfoRetriever.SectionConfiguration sectionConfigurationMap = new PORTAL_MyInfoDisplayInfoRetriever.SectionConfiguration();
        sectionConfigurationMap.sectionId = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SECTION_ID);
        sectionConfigurationMap.sectionDescription = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SECTION_DESCRIPTION);
        sectionConfigurationMap.sectionName = (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SUB_SECTION_NAME) == null ? (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.MAIN_SECTION_NAME) : (String)sectionMap?.get(PORTAL_CONST_PageSectionSetting.SUB_SECTION_NAME);
        sectionConfigurationMap.isDisable = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.DISABLE_CONST);
        sectionConfigurationMap.isToggleOnSection = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.TOGGLE_ON_SECTION);
        sectionConfigurationMap.isTogglePerRecord = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.TOGGLE_PER_RECORD);
        sectionConfigurationMap.hasReportUpdateLink = (Boolean)sectionMap?.get(PORTAL_CONST_PageSectionSetting.REPORT_UPDATE_LINK);
        sectionConfigurationMap.fieldConfigurationMap = getFieldConfiguration((Map<String, Object>)sectionMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_MAP));

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
    private virtual Map<String, PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration> getFieldConfiguration(Map<String, Object> fieldMap) {
        if (fieldMap == null || fieldMap.isEmpty()) {
            return new Map<String, PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration>();
        }

        Map<String, PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration> fieldConfigurationMap = new Map<String, PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration>();        
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
    private virtual PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration createFieldConfiguration(Map<String, Object> fieldConfigurationMap) {
        PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration fieldConfiguration = new PORTAL_MyInfoDisplayInfoRetriever.FieldConfiguration();
        fieldConfiguration.fieldId = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_ID);
        fieldConfiguration.fieldName = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_NAME);
        fieldConfiguration.fieldType = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.FIELD_TYPE);
        fieldConfiguration.stagingRecordFieldName = (String)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_FIELD_NAME);
        fieldConfiguration.isDisable = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.DISABLE_CONST);
        fieldConfiguration.isDisplay = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.DISPLAY_CONST);
        fieldConfiguration.isLookup = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_LOOKUP);
        fieldConfiguration.isPicklist = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_PICKLIST);
        fieldConfiguration.isTextArea = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_TEXT_AREA);
        fieldConfiguration.isRichText = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_RICH_TEXT);
        fieldConfiguration.isRequired = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.IS_REQUIRED);
        fieldConfiguration.hasReportUpdateLink = (Boolean)fieldConfigurationMap?.get(PORTAL_CONST_PageSectionSetting.REPORT_UPDATE_LINK);

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
    private virtual ucinn_ascendv2__Org_Wide_Configuration__c getOrgWideSettings() {
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
     * 
     * @return                            A map of the record ID to the record
     */
    public virtual override Map<String, Map<String, Object>> retrieveRecordMap() {
        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = this.pageSectionAdapter.getRecords();
        
        return getRecordIdToRecordMap(recordsMap.get(this.mainSectionName)?.get(this.subSectionName != null ? this.subSectionName : PORTAL_CONST_PageSectionSetting.RECORDS_CONST));
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
    private virtual Map<String, Map<String, Object>> getRecordIdToRecordMap(List<Map<String, Object>> recordsList) {
        Map<String, Map<String, Object>> records = new Map<String, Map<String, Object>>();

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
        return this.retrieveStagingRecordMap(this.pageSectionAdapter.getStagingRecords());
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
    protected Map<String, Map<String, Object>> retrieveStagingRecordMap(Map<String, List<sObject>> stagingRecordsMap) {
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();

        if (stagingRecordsMap == null || stagingRecordsMap.isEmpty()) {
            return returnMap;
        }

        for (String eachSectionKey : stagingRecordsMap.keySet()) {
            if (eachSectionKey == PORTAL_CONST_PageSectionSetting.SPOUSAL_INTERIM_KEY || eachSectionKey == PORTAL_CONST_PageSectionSetting.INTERIMS_FRONT_END_NAME) {
                continue;
            }

            for (sObject eachSobj : stagingRecordsMap.get(eachSectionKey)) {
                returnMap.put((String)eachSobj?.get(PORTAL_CONST_PageSectionSetting.ID_CONST), eachSobj.getPopulatedFieldsAsMap());
            }
        }

        return returnMap;
    }
}