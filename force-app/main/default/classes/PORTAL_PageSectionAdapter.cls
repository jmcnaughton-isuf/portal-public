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
 * Adapter class for PORTAL_UTIL_PageSectionSettings. Allows for simpler use of utility code.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing virtual class PORTAL_PageSectionAdapter {
    private String pageName;
    private String mainSectionName;
    private String subSectionName;
    private String parentFieldId;
    private String stagingRecordParentFieldId;
    private Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> sectionNameToDynamicOverrideClassMap;

    private List<Portal_Page_Section_Setting__mdt> pageSectionSettingList;
    private Map<String, Object> frontEndDataMap;
    private Map<String, Object> backEndDataMap;
    private Map<String, Map<String, List<Map<String, Object>>>> recordsMap;
    private Map<String, List<Map<String,Object>>> stagingRecordsMap;
    private Map<String, List<Map<String, String>>> picklistMap;

    /**
     * Private constructor.
     *
     * @author  Aaron Wong
     * @since   1.0
     */
    private PORTAL_PageSectionAdapter(){}

    /**
     * Builder class used to construct PORTAL_PageSectionAdapter.
     */
    public virtual class Builder {
        PORTAL_PageSectionAdapter result;

        /**
         * Constructor for the builder class.
         *
         * @author  Aaron Wong
         * @since   1.0
         */
        public Builder(){
            result = new PORTAL_PageSectionAdapter();
        }

        /**
         * Sets the page name for the PORTAL_PageSectionAdapter object.
         *
         * @author  Aaron Wong
         *
         * @param pageName  The page name of the Portal Page Section Setting.
         * @return          This instance of the builder class.
         * @since           1.0
         */
        public Builder buildPageName(String pageName) {
            this.result.pageName = pageName;
            return this;
        }

        /**
         * Sets the main section name for the PORTAL_PageSectionAdapter object.
         *
         * @author  Aaron Wong
         *
         * @param mainSectionName   The main section name of the Portal Page Section Setting.
         * @return                  This instance of the builder class.
         * @since                   1.0
         */
        public Builder buildMainSectionName(String mainSectionName) {
            this.result.mainSectionName = mainSectionName;
            return this;
        }

        /**
         * Sets the sub section name for the PORTAL_PageSectionAdapter object.
         *
         * @author  Aaron Wong
         *
         * @param subSectionName    The subsection name of the Portal Page Section Setting.
         * @return                  This instance of the builder class.
         * @since                   1.0
         */
        public Builder buildSubSectionName(String subSectionName) {
            this.result.subSectionName = subSectionName;
            return this;
        }

        /**
         * Sets the parent field id for the PORTAL_PageSectionAdapter object.
         *
         * @author  Aaron Wong
         *
         * @param parentFieldId     The parent field id to use for callouts to PORTAL_UTIL_PageSectionSettings.
         * @return                  This instance of the builder class.
         * @since                   1.0
         */
        public Builder buildParentFieldId(String parentFieldId) {
            this.result.parentFieldId = parentFieldId;
            return this;
        }

        /**
         * Sets the dynamic query for the PORTAL_PageSectionAdapter object.
         *
         * @author  Aaron Wong
         *
         * @param sectionNameToDynamicOverrideClassMap  The dynamic query to use for callouts to PORTAL_UTIL_PageSectionSettings.
         * @return                                      This instance of the builder class.
         * @since                                       1.0
         */
        public Builder buildDynamicQuery(Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> sectionNameToDynamicOverrideClassMap) {
            this.result.sectionNameToDynamicOverrideClassMap = sectionNameToDynamicOverrideClassMap;
            return this;
        }

        /**
         * Sets the staging record parent field id for the PORTAL_PageSectionAdapter object.
         *
         * @author  Todd Shinto
         *
         * @param sectionNameToDynamicOverrideClassMap  The dynamic query to use for callouts to PORTAL_UTIL_PageSectionSettings.
         * @return                                      This instance of the builder class.
         * @since                                       1.5
         */
        public Builder buildStagingRecordParentFieldId(String stagingRecordParentFieldId) {
            this.result.stagingRecordParentFieldId = stagingRecordParentFieldId;
            return this;
        }

        /**
         * Returns an instance of PORTAL_PageSectionAdapter. Page Name is a required field, and a query is done
         * to get the page section setting custom metadata records.
         *
         * @author Aaron Wong
         *
         * @return  Configured instance of PORTAL_PageSectionAdapter.
         * @since   1.0
         */
        public virtual PORTAL_PageSectionAdapter build() {
            if (String.isBlank(this.result.pageName)) {
                return null;
            }

            this.result.pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(this.result.pageName, this.result.mainSectionName, this.result.subSectionName);

            return result;
        }
    }

    /**
     * Getter for the page name field.
     *
     * @author Aaron Wong
     *
     * @return  The page name.
     * @since   1.0
     */
    public String getPageName() {
        return this.pageName;
    }

    /**
     * Getter for the main section name
     *
     * @author Aaron Wong
     *
     * @return  The main section name.
     * @since   1.0
     */
    public String getMainSectionName() {
        return this.mainSectionName;
    }

    /**
     * Getter for the subsection name field.
     *
     * @author Aaron Wong
     *
     * @return  The sub section name.
     * @since   1.0
     */
    public String getSubSectionName() {
        return this.subSectionName;
    }

    /**
     * Queries the records map if there is none. Then returns the records map.
     *
     * @author Aaron Wong
     *
     * @return The records map.
     * @since  1.0
     */
    public Map<String, Map<String, List<Map<String, Object>>>> getRecords() {
        if (recordsMap == null) {
            this.recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(parentFieldId,
                                                                             PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList),
                                                                             sectionNameToDynamicOverrideClassMap,
                                                                             false,
                                                                             true);
        }

        return this.recordsMap;
    }

    /**
     * Queries the records map if there is none. Then returns the records map.
     *
     * @author Aaron Wong
     *
     * @param isGetAllRecords       The boolean parameter which tells us if we want to query for all records.
     * @param isGenerateWrapper     The boolean parameter which tells us that the records need to be wrapped as a map instead of returning it as an sobject.
     * @return                      The records map.
     * @since                       1.0
     */
    public Map<String, Map<String, List<Map<String, Object>>>> getRecords(Boolean isGetAllRecords, Boolean isGenerateWrapper) {
        if (recordsMap == null) {
            this.recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(parentFieldId,
                                                                             PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList),
                                                                             sectionNameToDynamicOverrideClassMap,
                                                                             isGetAllRecords,
                                                                             isGenerateWrapper);
        }

        return this.recordsMap;
    }

    /**
     * Queries for staging records
     *
     * @author Todd Shinto
     *
     * @return The list of staging records, wrapped.
     * @since  1.6
     */
    public virtual Map<String, List<Map<String, Object>>> getStagingRecords() {
        if (stagingRecordsMap == null) {
            this.stagingRecordsMap = PORTAL_UTIL_PageSectionSetting.queryForStagingRecords(this.stagingRecordParentFieldId, this.pageSectionSettingList);
        }

        return this.stagingRecordsMap;
    }

    /**
     * Creates a front end data map if there is none, then returns it.
     *
     * @author Aaron Wong
     *
     * @return The front end data map.
     * @since  1.0
     */
    public Map<String, Object> getFrontEndDataMap() {
        if (this.frontEndDataMap == null) {
            this.frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(this.pageSectionSettingList);
        }

        return this.frontEndDataMap;
    }

    /**
     * Creates a back end data map if there is none, then returns it.
     *
     * @author Aaron Wong
     *
     * @return The back end data map
     * @since  1.0
     */
    public Map<String, Object> getBackEndDataMap() {
        if (this.backEndDataMap == null) {
            this.backEndDataMap = PORTAL_UTIL_PageSectionSetting.getBackEndDataMap(this.pageSectionSettingList);
        }

        return this.backEndDataMap;
    }

    /**
     * Gets picklist values.
     *
     * @author Aaron Wong
     *
     * @return  Map of picklists.
     * @since   1.0
     */
    public Map<String, List<Map<String, String>>> getPicklistMap() {
        if (this.picklistMap == null) {
            this.picklistMap = PORTAL_UTIL_PageSectionSetting.getPicklists(this.pageSectionSettingList);
        }

        return this.picklistMap;
    }

    /**
     * Convert SObject records to wrappers using page section settings
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param sObjectList       List<SObject>: SObject records to convert to wrappers
     * @param isStagingRecords  Boolean: specifies whether the records are staging records or not
     * 
     * @return list of record maps
     */
    public List<Map<String, Object>> convertRecordsToWrapper(List<SObject> sObjectList, Boolean isStagingRecords) {
        if (this.pageSectionSettingList == null || this.pageSectionSettingList.isEmpty() || (String.isBlank(this.mainSectionName) && String.isBlank(this.subSectionName))) {
            return null;   
        }

        String sectionName = String.isNotBlank(this.subSectionName) ? this.subSectionName : this.mainSectionName;

        if (isStagingRecords) {
            return PORTAL_UTIL_PageSectionSetting.convertStagingRecordsToWrapper(sObjectList, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(this.pageSectionSettingList).get(sectionName));
        }

        return PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(sObjectList, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(this.pageSectionSettingList).get(sectionName));
    }
}