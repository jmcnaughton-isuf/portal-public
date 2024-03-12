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

public inherited sharing virtual class PORTAL_MyInfoDisplayInfoRetriever {
    private static final String RECORD_LIST_WITH_STAGED_CHANGES = 'recordListWithStagedChanges';
    private static final String CONFIG_STRING = 'configString';

    private DataRetriever dataRetriever;

    public PORTAL_MyInfoDisplayInfoRetriever(DataRetriever dataRetriever) {
        this.dataRetriever = dataRetriever;
    }

    public abstract class DataRetriever {
        public abstract String getConfigurationsString();
        public abstract Map<String, Map<String, Object>> retrieveRecordMap();
        public abstract Map<String, Map<String, Object>> retrieveStagingRecordMap();
    }

    public virtual class MyInfoConfiguration {
        public Boolean isMultipleCurrentAddressesEnabled;
        public Boolean isMultipleCurrentEmailsEnabled;
        public Boolean isMultipleCurrentPhonesEnabled;
        public Map<String, SectionConfiguration> sectionConfigurationMap;
    }

    public virtual class SectionConfiguration {
        public String sectionId;
        public String sectionDescription;
        public String sectionName;
        public Boolean isDisable = false;
        public Boolean isToggleOnSection = false;
        public Boolean isTogglePerRecord = false;
        public Boolean hasReportUpdateLink = false;
        public Map<String, FieldConfiguration> fieldConfigurationMap;

        public virtual override String toString() {
            return null;
        }
    }

    public virtual class FieldConfiguration {
        public String fieldId;
        public String fieldName;
        public String fieldType;
        public String stagingRecordFieldName;
        public Boolean isDisable;
        public Boolean isDisplay;
        public Boolean isLookup;
        public Boolean isPicklist;
        public Boolean isRichText;
        public Boolean isTextArea;
        public Boolean isRequired;
        public Boolean hasReportUpdateLink;
    }
    
    /**
     * Gets the configuration and records for the front end
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @return: A map of the display information: 1) Configurations as a string, 2) Record list with staged changes
     */
    public virtual Map<String, Object> getDisplayInfo() {
        Map<String, Object> resultMap = new Map<String, Object>();

        resultMap.put(CONFIG_STRING, this.dataRetriever.getConfigurationsString());
        resultMap.put(RECORD_LIST_WITH_STAGED_CHANGES, this.getRecordListWithStagedChanges());
        return resultMap;
    }

    /**
     * Gets the record list with staged changes merged in
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @return: Record list with staged changes
     */
    protected virtual List<Map<String, Object>> getRecordListWithStagedChanges() {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        Map<String, Map<String, Object>> recordIdToRecordMap = this.dataRetriever.retrieveRecordMap();
        Map<String, Map<String, Object>> recordIdToStagingRecordMap = this.dataRetriever.retrieveStagingRecordMap();

        if (recordIdToRecordMap == null || recordIdToRecordMap.isEmpty()) {
            return resultList;
        }

        for (String eachRecordId : recordIdToRecordMap.keySet()) {
            resultList.add(this.getRecordWithStagedChanges(recordIdToRecordMap.get(eachRecordId), recordIdToStagingRecordMap?.get(eachRecordId)));
        }
        
        return resultList;
    }

    /**
     * Determines whether to return the original record, or record with staged changes
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @param recordMap:        A map of Id to records
     * @param stagingRecordMap: A map of the staging records
     * 
     * @return:                 A map of the record ID to the staged or original record
     */
    private Map<String, Object> getRecordWithStagedChanges(Map<String, Object> recordMap, Map<String, Object> stagingRecordMap) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (stagingRecordMap == null || stagingRecordMap.isEmpty()) {
            return recordMap;
        }

        for (String eachFieldId : recordMap.keySet()) {
            if (stagingRecordMap.containsKey(eachFieldId) && stagingRecordMap.get(eachFieldId) != null) {
                resultMap.put(eachFieldId, stagingRecordMap.get(eachFieldId));
            } else {
                resultMap.put(eachFieldId, recordMap.get(eachFieldId));
            }
        }

        return resultMap;
    }
}