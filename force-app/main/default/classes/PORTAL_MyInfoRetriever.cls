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

public inherited sharing virtual class PORTAL_MyInfoRetriever {
    public static final String RECORD_LIST_WITH_STAGED_CHANGES = 'recordListWithStagedChanges';
    public static final String SELF_REPORT_RECORD_LIST = 'selfReportRecordList';
    public static final String CONFIG_STRING = 'configString';
    public static final String IS_DELETED = '%isDeleted%';
    public static final String VALUE_FIELD = 'Value__c';
    public static final String PORTAL_ORGANIZATION_SETTING = 'Portal_Organization_Setting__mdt';
    public static final String MY_INFORMATION_REQUEST_UPDATE_RICH_TEXT = 'My_Information_Request_Update_Rich_Text';
    public static final String MY_INFORMATION_ADDRESS_AUTOCOMPLETE = 'My_Information_Address_Autocomplete';

    private EngineAdapter engine;
    private MyInfoConfiguration backEndConfig;

    public PORTAL_MyInfoRetriever(EngineAdapter engine) {
        this.engine = engine;
    }

    public abstract class EngineAdapter {
        public abstract String getFrontEndConfigurationsString();
        public abstract String getBackEndConfigurationsString();
        public abstract Map<String, Map<String, Object>> retrieveRecordMap(Boolean isGetAllRecords);
        public abstract Map<String, Map<String, Object>> retrieveStagingRecordMap();
        public abstract List<Map<String, Object>> retrieveSelfReportRecordList();
        public abstract List<Map<String, Object>> convertRecordsToWrapper(List<SObject> sObjectList, Boolean isStagingRecords);
    }

    public virtual class MyInfoConfiguration {
        public Boolean isMultipleCurrentAddressesEnabled;
        public Boolean isMultipleCurrentEmailsEnabled;
        public Boolean isMultipleCurrentPhonesEnabled;
        public String requestUpdateRichText;
        public Boolean hasAddressAutocomplete;
        public Map<String, SectionConfiguration> sectionConfigurationMap;
        public Map<String, SectionConfiguration> selfReportSectionConfigurationMap;
    }

    public virtual class SectionConfiguration {
        public String sectionId;
        public String sectionDescription;
        public String sectionName;
        public String mainSectionName;
        public string subSectionName;
        public String sObjectApiName;
        public String controllingParentField;

        public String stagingRecordObjectName;
        public string stagingRecordControllingParentField;
        
        public String recordTypeDeveloperName;
        public String stagingRecordTypeDeveloperName;

        public String originalRecordName;

        public String controllingParentObject;
        public String stagingRecordControllingParentObject; // TODO: keeping this field here for now just in case, but never use it

        public Boolean isHardDeleteRecords = false;

        public String label;
        public Boolean isDisplay = false;
        public Boolean isDisable = false;
        public Boolean isToggleOnSection = false;
        public Boolean isTogglePerRecord = false;
        public Boolean hasReportUpdateLink = false;
        public Boolean isCreateStagingRecordUponCreation = false;
        public Boolean isCreateStagingRecordUponEdit = false;

        public String duplicateFieldLogic;
        public Boolean hasDuplicateLogic = false;

        public Map<String, FieldConfiguration> fieldConfigurationMap;
        public String activeRecordFieldMapString;
        public String inactiveRecordFieldMapString;

        public String whereClause;
        public String orderByClause;
        public String maxNumberOfQueryRecords;
        public virtual override String toString() {
            return null;
        }
    }

    public virtual class FieldConfiguration {
        public String fieldId;
        public String fieldName;
        public String fieldType;
        public String label;
        public String stagingRecordFieldName;
        public Boolean isDisable;
        public Boolean isDisplay;
        public Boolean isLookup;
        public Boolean isPicklist;
        public List<Map<String, String>> picklistValues;
        public Boolean isRichText;
        public Boolean isTextArea;
        public Boolean isRequired;
        public Boolean hasReportUpdateLink;
        public Boolean hasToggle;
        public String customMetadataApiName;
        public String customMetadataDeveloperName;
        public String fieldOrderForDuplicateLogic;
        public Boolean isCreateNewRecord;
        public Boolean isCreateStagingRecordOnFieldChange;
    }
    
    /**
     * Gets the configuration and records for the front end
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @return: A map of the display information: 1) Configurations as a string, 2) Record list with staged changes, 3) Record list with self reported changes (optional)
     */
    public virtual Map<String, Object> getDisplayInfo() {
        Map<String, Object> resultMap = new Map<String, Object>();

        resultMap.put(CONFIG_STRING, this.engine.getFrontEndConfigurationsString());
        resultMap.put(RECORD_LIST_WITH_STAGED_CHANGES, this.getRecordListWithStagedChanges());
        resultMap.put(SELF_REPORT_RECORD_LIST, this.engine.retrieveSelfReportRecordList());
        return resultMap;
    }

    /**
     * Gets the record list with staged changes merged in
     *
     * @author: Todd Shinto, Phillip Nguyen
     * @since:  1.5
     * 
     * @return: Record list with staged changes
     */
    protected virtual List<Map<String, Object>> getRecordListWithStagedChanges() {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        Map<String, Map<String, Object>> recordIdToRecordMap = this.engine.retrieveRecordMap(false);
        Map<String, Map<String, Object>> stagingRecordIdToStagingRecordMap = this.engine.retrieveStagingRecordMap();
        this.backEndConfig = (MyInfoConfiguration)JSON.deserialize(this.engine.getBackEndConfigurationsString(), MyInfoConfiguration.class);

        if (recordIdToRecordMap == null || recordIdToRecordMap.isEmpty()) {
            if (stagingRecordIdToStagingRecordMap != null) {
                resultList.addAll(stagingRecordIdToStagingRecordMap.values());
            }
            return resultList;
        }

        for (String eachRecordId : recordIdToRecordMap.keySet()) {
            Map<String, Object> recordToAdd = this.getRecordWithStagedChanges(recordIdToRecordMap.get(eachRecordId), this.getStagingRecordForOriginalRecord(eachRecordId, stagingRecordIdToStagingRecordMap));

            if (recordToAdd == null || recordToAdd.isEmpty()) {
                continue;
            }

            resultList.add(recordToAdd);
        }

        resultList.addAll(getAllActiveStagingRecordsWithoutOriginalRecord(stagingRecordIdToStagingRecordMap?.values()));
        
        return resultList;
    }

    /**
     * Iterates through the staging record map to find a staging record where the
     * staging record's original record ID matches the record ID we are searching for.
     * When this returns null, getRecordWithStagedChanges will return the original record.
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @param originalRecordId                  The Id of the original record to check against
     * @param stagingRecordIdToStagingRecordMap A map of the staging record Id to the staging record map (using front end field Id's as keys)
     * 
     * @return: Staging record map
     */
    private Map<String, Object> getStagingRecordForOriginalRecord(String recordId, Map<String, Map<String, Object>> stagingRecordIdToStagingRecordMap) {
        if (stagingRecordIdToStagingRecordMap == null || stagingRecordIdToStagingRecordMap.isEmpty()) {
            return null;
        }

        for (String eachStagingRecordId : stagingRecordIdToStagingRecordMap.keySet()) {
            String originalRecordId = (String)stagingRecordIdToStagingRecordMap.get(eachStagingRecordId)?.get(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD);
            if (recordId == originalRecordId || String.isBlank((String)this.backEndConfig.sectionConfigurationMap.values().get(0).originalRecordName)) {
                return stagingRecordIdToStagingRecordMap.get(eachStagingRecordId);
            }
        }

        return null;
    }

    /**
     * Gets record with staging record changes merged with the record
     *
     * @author: Todd Shinto, Phillip Nguyen
     * @since:  1.5
     * 
     * @param recordMap:        Record as a map
     * @param stagingRecordMap: Staging Record as a map
     * 
     * @return:                 Record with possible staged changes merged with the record, or an empty record
     */
    private Map<String, Object> getRecordWithStagedChanges(Map<String, Object> recordMap, Map<String, Object> stagingRecordMap) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (stagingRecordMap == null || stagingRecordMap.isEmpty()) {
            return recordMap;
        }

        if (this.isRecordInactive(stagingRecordMap) == true) {
            return resultMap;
        }
        
        for (String eachFieldId : recordMap.keySet()) {
            if (stagingRecordMap.containsKey(eachFieldId) && stagingRecordMap.get(eachFieldId) != null) {
                Object stagingRecordValue = stagingRecordMap.get(eachFieldId) != IS_DELETED ? stagingRecordMap.get(eachFieldId) : null;
                resultMap.put(eachFieldId, stagingRecordValue);
            } else {
                resultMap.put(eachFieldId, recordMap.get(eachFieldId));
            }
        }

        if (stagingRecordMap.containsKey(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD)) {
            resultMap.put(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD, stagingRecordMap.get(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD));
        }

        return resultMap;
    }

    
    /**
     * Checks if record is inactive by comparing the record to the inactive record field map
     * Since the inactive record field map contains api names and the record has front end field ids,
     * we have to convert each front end field id to an api name so we use the field configuration map from the CMT
     *
     * @author: Phillip Nguyen
     * @since:  1.11
     * 
     * @param   record  The record to check for being inactive
     * @return:         Boolean whether the record is inactive or not. If the records fail a null check, it returns false
     */
    private Boolean isRecordInactive(Map<String, Object> record) {
        if (record == null || record.isEmpty() 
                || String.isBlank((String)this.backEndConfig.sectionConfigurationMap.values().get(0).originalRecordName)
                || String.isBlank(this.backEndConfig.sectionConfigurationMap.values().get(0).inactiveRecordFieldMapString)) {
            return false;
        }

        Map<String, Object> inactiveRecordFieldMap = (Map<String, Object>)JSON.deserializeUntyped(this.backEndConfig.sectionConfigurationMap.values().get(0).inactiveRecordFieldMapString);
        Map<String, FieldConfiguration> fieldConfigurationMap = this.backEndConfig.sectionConfigurationMap.values().get(0).fieldConfigurationMap;

        if (inactiveRecordFieldMap == null || inactiveRecordFieldMap.isEmpty() || fieldConfigurationMap == null || fieldConfigurationMap.isEmpty()) {
            return false;
        }

        for (String eachFieldId : record.keySet()) {
            if (!inactiveRecordFieldMap.containsKey(fieldConfigurationMap.get(eachFieldId).fieldName)) {
                continue;
            }

            if (inactiveRecordFieldMap.get(fieldConfigurationMap.get(eachFieldId).fieldName) != record.get(eachFieldId)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Gets all active staging records that do not have an original record
     * 
     * @author  Phillip Nguyen
     * @since   1.11
     * 
     * @param   listOfStagingRecords    List of staging records as maps
     * 
     * @return                          List of staging records that do not have an original record and are active
     */
    private List<Map<String, Object>> getAllActiveStagingRecordsWithoutOriginalRecord(List<Map<String, Object>> listOfStagingRecords) {
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();

        if (listOfStagingRecords == null || listOfStagingRecords.isEmpty() || String.isBlank((String)this.backEndConfig.sectionConfigurationMap.values().get(0).originalRecordName)) {
            return returnList;
        }

        for (Map<String, Object> eachStagingRecord : listOfStagingRecords) {
            if (String.isNotBlank((String)eachStagingRecord.get(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD)) || this.isRecordInactive(eachStagingRecord) == true) {
                continue;
            }
            
            returnList.add(eachStagingRecord);
        }

        return returnList;
    }
}