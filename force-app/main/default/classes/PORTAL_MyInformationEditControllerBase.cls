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


/**
 * Base controller class for My Information Edit
 * 
 * @author  Phillip Nguyen
 * @since   1.7
 */
public inherited sharing virtual class PORTAL_MyInformationEditControllerBase {
    public static final String PAGE_NAME = 'pageName';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String SUB_SECTION_NAME = 'subSectionName';
    public static final String PARENT_FIELD_ID = 'parentFieldId';
    public static final String STAGING_RECORD_PARENT_FIELD_ID = 'stagingRecordParentFieldId';
    public static final String HAS_PICKLIST_VALUES_IN_CONFIGURATION = 'hasPicklistValuesInConfiguration';
    public static final String SELF_REPORT_PAGE_NAME = 'selfReportPageName';
    public static final String SELF_REPORT_STAGING_RECORD_PARENT_FIELD_ID = 'selfReportStagingRecordParentFieldId';

    public static final String ORIGINAL_RECORD_ID = 'originalRecordId';
    public static final String SECTION_ID = 'sectionId';
    public static final String SECTION_ID_TO_UPDATED_RECORDS_MAP = 'sectionIdToUpdatedRecordsMap';
    public static final String SELF_REPORT_RECORD_MAP = 'selfReportRecordMap';

    public static final String IS_DELETE = 'isDelete';
    public static final String CONTACT_API_NAME = 'Contact';
    public static final String INTERIM_API_NAME = 'ucinn_ascendv2__Interim__c';
    public static final String SIGNIFICANT_OTHER = 'Significant_Other';
    
    public static final String BIO_INFORMATION_SELF_REPORT = 'Bio_Information_Self_Report';
    public static final String CREATE_CASE_FOR_BIO_INFO_SELF_REPORT = 'Create_Case_For_Bio_Info_Self_Report';
    public static final String MANUAL_REVIEW = 'Manual Review';
    public static final String PORTAL_CONST = 'Portal';
    public static final String SELF_REPORT_CASE_SUBJECT = 'A user has submitted changes to their bio information.';
    public static final String NEW_CONST = 'New';
    public static final String BIO_INFORMATION = 'Bio Information';
    public static final String BIO_INFORMATION_CASE_QUEUE = 'Bio Information Case Queue';
    public static final String QUEUE_CONST = 'Queue';
    public static final String SEARCH_TEXT = 'searchText';
    
    public static final String MY_INFORMATION_PAGE_NAME = 'My Information';
    public String DUMMY_CONTACT_FIRST_NAME = 'My Information Dummy Contact';
    public String DUMMY_CONTACT_LAST_NAME = 'Do Not Delete This Record';

    public static final String ERROR_GENERAL_MESSAGE = 'There was an error saving your information. Please contact an administrator to update your information.';

    private String contactId;
    private String dummyContactId;
    private String dummyOrganizationId;
    private String interimId;
    private String selfReportInterimId;

    /**
     * Initialization for edit, includes configuration string with picklist values and records
     * 
     * @author Jacob Huang
     * @since 1.8 (is when the implementation was added)
     * 
     * @param pageName              String: page name
     * @param mainSectionName       String: main section
     * @param subSectionName        String: subsection
     * @param selfReportPageName    String: page name for self reported records, assumes main section and subsection have the same name
     * 
     * @return map with info needed for display (configurations, queried records with staged changes, queried self reported records)
     */
    public virtual Map<String, Object> getEditInfo(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return new Map<String, Object>();
        }

        this.populateIds();
        params.put(PARENT_FIELD_ID, this.contactId);
        params.put(STAGING_RECORD_PARENT_FIELD_ID, this.interimId);
        params.put(SELF_REPORT_STAGING_RECORD_PARENT_FIELD_ID, this.selfReportInterimId);
        params.put(HAS_PICKLIST_VALUES_IN_CONFIGURATION, true);

        PORTAL_MyInfoRetriever displayInfoRetriever = new PORTAL_MyInfoRetriever(this.getEngine(params));
        return displayInfoRetriever.getDisplayInfo();
    }

    /**
     * Saving information with edits portal user has made on my information page
     * sectionIdToUpdatedRecordsMap: {phones => [record1, record2, ...], emails => [record1, record2, ...]}
     * 
     *  TODO PLEASE READ FOR CODE REVIEWERS: FOR DELETE THIS IS THE ASSUMPTION RIGHT NOW:
     *  Deleting record is not stored on a separate list, rather there will be a field set on the front end denoting that the record is being deleted.
     *  right now it is called isDelete/IS_DELETE. Every record should have isDelete populated with true or false (not null)
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   sectionIdToUpdatedRecordsMap    Map of section id to a list of records that have been updated
     * @param   interimSourceUrl              Relative Url that this request was sent from
     * 
     */
    public virtual void saveInformation(Map<String, Object> params) {
        Map<Object, Object> sectionIdToUpdatedRecordsMap = (Map<Object, Object>)params?.get(SECTION_ID_TO_UPDATED_RECORDS_MAP);
        String interimSourceUrl = (String)params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);
        
        if (sectionIdToUpdatedRecordsMap == null || sectionIdToUpdatedRecordsMap.isEmpty()) {
            return;
        }

        this.populateIds();

        System.debug('brandon');
        for(String key: params.keySet()){
            System.debug(params.get(key));
        }

        // Get configurations from backend
        Map<String, PORTAL_MyInfoRetriever.SectionConfiguration> sectionConfigurationMap = this.getSectionConfigurations();
        PORTAL_DMLWrapper dmlWrapper = new PORTAL_DMLWrapper();

        for (Object eachSectionId : sectionIdToUpdatedRecordsMap.keySet()) {
            System.debug('brandon');
            System.debug(eachSectionId);
            List<Object> updatedRecordList = (List<Object>)sectionIdToUpdatedRecordsMap.get(eachSectionId);
            System.debug(updatedRecordList);
            dmlWrapper.addDMLWrapper(this.getDMLOperationsFromSection(updatedRecordList, sectionConfigurationMap?.get((String)eachSectionId)));
        }

        dmlWrapper = getMergedInterimAndContactDMLWrapper(dmlWrapper);

        dmlWrapper.performDmlOperations();

        this.performPostSaveOperations(dmlWrapper);
    }

    /**
     * Save staging records for values that the user requests to update in frontend  
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param selfReportRecordMap   Map<String, Object>: self-reported information as a map
     * @param pageName              String: page name
     * @param mainSectionName       String: main section
     * @param subSectionName        String: subsection
     * @param sectionId             String: front end section id
     * @param originalRecordId      String: id of original record (i.e. pre-existing non-self-reported record)
     * @param interimSourceUrl      String: Relative Url that this request was sent from
     * 
     * @return SObject (as a map) that was just inserted/updated, fields (including lookup and formula) are updated with what was changed
     */
    public virtual Map<String, Object> selfReportInformation(Map<String, Object> params) {
        Map<String, Object> selfReportRecordMap = (Map<String, Object>)System.JSON.deserializeUntyped(System.JSON.serialize(params?.get(SELF_REPORT_RECORD_MAP)));
        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params?.get(SUB_SECTION_NAME);
        String sectionId = (String)params?.get(SECTION_ID);
        String originalRecordId = (String)params?.get(ORIGINAL_RECORD_ID);
        PORTAL_GlobalAttributes.getInstance().setPathUrl((String)params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL));

        if (selfReportRecordMap == null || String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(sectionId)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE}); 
        }

        this.populateIds();
        this.createSelfReportInterimRecord();

        Map<String, Object> engineParams = new Map<String, Object>{
            SELF_REPORT_PAGE_NAME => pageName,
            MAIN_SECTION_NAME => mainSectionName,
            SUB_SECTION_NAME => subSectionName,
            SELF_REPORT_STAGING_RECORD_PARENT_FIELD_ID => this.selfReportInterimId
        };

        PORTAL_MyInfoRetriever.EngineAdapter engine = this.getEngine(engineParams);
        PORTAL_MyInfoRetriever.MyInfoConfiguration backEndConfiguration = (PORTAL_MyInfoRetriever.MyInfoConfiguration)JSON.deserialize(engine.getBackEndConfigurationsString(), PORTAL_MyInfoRetriever.MyInfoConfiguration.class);
        PORTAL_MyInfoRetriever.SectionConfiguration sectionConfig = backEndConfiguration.sectionConfigurationMap.get(sectionId);

        PORTAL_MyInfoSave myInfoSave = new PORTAL_MyInfoSave.Builder().buildRecordDmlWrapper(new PORTAL_DMLWrapper())
                                                                      .buildConfigs(sectionConfig)
                                                                      .buildSelfReportRecordMapToUpdate(selfReportRecordMap)
                                                                      .buildDummyContactId(this.dummyContactId)
                                                                      .buildDummyOrganizationId(this.dummyOrganizationId)
                                                                      .buildInterimRecordId(this.selfReportInterimId)
                                                                      .buildOriginalRecordId(originalRecordId)
                                                                      .build();
  
        SObject savedSObject = myInfoSave.selfReportInformation();
        return this.convertSelfReportRecordToWrapper(savedSObject, sectionConfig, engine);
    }

     /**
     * Checks to see if we are displaying the search bar, we display if there are service indicator values that are not always showing on portal
     *
     * @author Phillip Nguyen
     * 
     * @return                          Boolean if we display search bar
     * @since                           1.12
     */
    public virtual Boolean isDisplaySearchBar(Map<String, Object> params){
        List<ucinn_ascendv2__Service_Indicator_Value__c> serviceIndicatorValueList = [SELECT Id FROM ucinn_ascendv2__Service_Indicator_Value__c 
                                                                                      WHERE ucinn_portal_Is_Always_Display_On_MyInfo__c = false
                                                                                        AND ucinn_portal_Portal_Description__c != null LIMIT 1];

        return !serviceIndicatorValueList.isEmpty();
    }

    /**
     * Get Page Section Setting configs
     *
     * @author Phillip Nguyen
     * 
     * @return                          Map of CMT configurations
     * @since                           1.13
     */
    public virtual Map<String, Object> getCustomMetadataConfiguration(Map<String, Object> params){
        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(MY_INFORMATION_PAGE_NAME, '', '');
        return PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionList);
    }

    /**
     * Gets Service Indicator Values by doing SOSL search
     *
     * @author Phillip Nguyen
     * 
     * @param searchText                String: Text to search for
     * @param pageName                  String: page name
     * @param mainSectionName           String: main section
     * @param subSectionName            String: subsection
     * @param sectionId                 String: front end section id
     * @return                          List of service indicators
     * @since                           1.12
     */
    public virtual List<Map<String, Object>> searchServiceIndicatorValues(Map<String, Object> params){
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        String searchText = (String)params?.get(SEARCH_TEXT);
        String pageName = (String)params?.get(PAGE_NAME);
        String mainSectionName = (String)params?.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params?.get(SUB_SECTION_NAME);
        String sectionId = (String)params?.get(SECTION_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(sectionId) || String.isBlank(searchText) || searchText.length() < 2) {
            return resultList;
        }

        Map<String, Object> engineParams = new Map<String, Object>{
            PAGE_NAME => pageName,
            MAIN_SECTION_NAME => mainSectionName,
            SUB_SECTION_NAME => subSectionName
        };

        PORTAL_MyInfoRetriever.EngineAdapter engine = this.getEngine(engineParams);
        PORTAL_MyInfoRetriever.MyInfoConfiguration backEndConfiguration = (PORTAL_MyInfoRetriever.MyInfoConfiguration)JSON.deserialize(engine.getBackEndConfigurationsString(), PORTAL_MyInfoRetriever.MyInfoConfiguration.class);
        PORTAL_MyInfoRetriever.SectionConfiguration sectionConfig = backEndConfiguration.sectionConfigurationMap.get(sectionId);

        if (sectionConfig == null) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE}); 
        }

        return engine.convertRecordsToWrapper(this.getServiceIndicatorValuesThroughSOSLSearch(sectionConfig, searchText), false);
    }

    /**
     * Gets Service Indicator Values by doing SOSL search
     *
     * @author Phillip Nguyen
     * 
     * @param sectionConfig                     Section Config
     * @param searchText                        Text to search for
     * 
     * @return                                  List of service indicators SObjects
     * @since                                   1.12
     */
    protected virtual List<SObject> getServiceIndicatorValuesThroughSOSLSearch(PORTAL_MyInfoRetriever.SectionConfiguration sectionConfig, String searchText) {
        List<SObject> resultList = new List<SObject>();
        Integer offset = 0;

        if (sectionConfig == null || String.isBlank(searchText)) {
            return resultList;
        }

        Set<String> serviceIndicatorValueFields = this.getFieldApiNames(sectionConfig.fieldConfigurationMap);  

        if (serviceIndicatorValueFields == null || serviceIndicatorValueFields.isEmpty() || searchText.length() < 2) {
            return resultList;
        }

        String whereClause = sectionConfig.whereClause;
        whereClause = String.isBlank(whereClause) ? '' : PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => whereClause, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        
        String orderByClause = sectionConfig.orderByClause;
        orderByClause = String.isBlank(orderByClause) ? '' : PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => orderByClause, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});

        String limitClause = String.isBlank(sectionConfig.maxNumberOfQueryRecords) ? '' : ' LIMIT ' + sectionConfig.maxNumberOfQueryRecords;
        String soslString = 'FIND \'' + String.escapeSingleQuotes(searchText) + '*\' IN ALL FIELDS RETURNING ucinn_ascendv2__Service_Indicator_Value__c(' + String.join(new List<String>(serviceIndicatorValueFields), ',') + ' ' + whereClause + ' ' + orderByClause + limitClause + ' OFFSET ' + offset + ')';
        List<List<SObject>> searchResults = Search.query(soslString);

        if (searchResults.isEmpty() || searchResults.get(0) == null || searchResults.get(0).isEmpty()) {
            return resultList;
        }

        return searchResults.get(0);
    }

    /**
     * Gets Field Api names from Field Config Map
     *
     * @author Phillip Nguyen
     * 
     * @param fieldConfigurationMap             Field Config
     * 
     * @return                                  List of field api names
     * @since                                   1.12
     */
    protected virtual Set<String> getFieldApiNames(Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigurationMap) {
        Set<String> resultList = new Set<String>();

        if (fieldConfigurationMap == null || fieldConfigurationMap.isEmpty()) {
            return resultList;
        }

        for (PORTAL_MyInfoRetriever.FieldConfiguration fieldConfig : fieldConfigurationMap.values()) {
            if (String.isBlank(fieldConfig.fieldName)) {
                continue;
            }

            resultList.add(fieldConfig.fieldName);
        }

        return resultList;
    }

    /**
     * Gets configurations for My Information, currently using the page section setting engine
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @return  Returns section configuration map, which is a map of the front end section ID to SectionConfiguration
     */
    protected virtual Map<String, PORTAL_MyInfoRetriever.SectionConfiguration> getSectionConfigurations() {
        Map<String, Object> engineParamsMap = new Map<String, Object>();
        engineParamsMap.put(PAGE_NAME, MY_INFORMATION_PAGE_NAME);

        PORTAL_MyInfoRetriever.EngineAdapter engine = getEngine(engineParamsMap);
        PORTAL_MyInfoRetriever.MyInfoConfiguration backEndConfiguration = (PORTAL_MyInfoRetriever.MyInfoConfiguration)JSON.deserialize(engine.getBackEndConfigurationsString(), PORTAL_MyInfoRetriever.MyInfoConfiguration.class);
        return backEndConfiguration.sectionConfigurationMap;
    }

   /**
     * Builds standard My Info page section adapter if pageName is populated
     * Builds Self Report My Info page section adapter if selfReportPageName is populated
     * Then builds Engine using the page section adapter(s)
     *
     * @author: Phillip Nguyen
     * @since:  1.7
     *
     * @param pageName                                  String: page name for standard My Info adapter
     * @param selfReportPageName                        String: page name for Self Report My Info adapter
     * @param mainSectionName                           String: main section name, used for both adapters
     * @param subSectionName                            String: sub section name, used for both adapters
     * @param parentFieldId                             String: parent field ID for standard My Info adapter
     * @param stagingRecordParentFieldId                String: staging record parent field ID for standard My Info adapter
     * @param selfReportStagingRecordParentFieldId      String: staging record parent field ID for Self Report My Info adapter
     * @param hasPicklistValuesInConfiguration          Boolean: specify whether to include picklist values in the configuration info
     *  
     * @return: PORTAL_MyInfoRetriever.EngineAdapter
     */
    protected virtual PORTAL_MyInfoRetriever.EngineAdapter getEngine(Map<String, Object> params) {
        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder()
            .buildPageName((String)params?.get(PAGE_NAME))                  // if blank, this adapter will be null
            .buildMainSectionName((String)params?.get(MAIN_SECTION_NAME))
            .buildSubSectionName((String)params?.get(SUB_SECTION_NAME))
            .buildParentFieldId((String)params?.get(PARENT_FIELD_ID))
            .buildStagingRecordParentFieldId((String)params?.get(STAGING_RECORD_PARENT_FIELD_ID))
            .build();

        PORTAL_PageSectionAdapter selfReportPageSectionAdapter = new PORTAL_PageSectionAdapter.Builder()
            .buildPageName((String)params?.get(SELF_REPORT_PAGE_NAME))      // if blank, this adapter will be null
            .buildMainSectionName((String)params?.get(MAIN_SECTION_NAME))
            .buildSubSectionName((String)params?.get(SUB_SECTION_NAME))
            .buildStagingRecordParentFieldId((String)params?.get(SELF_REPORT_STAGING_RECORD_PARENT_FIELD_ID))
            .build();

        PORTAL_MyInfoPageSectionEngine pageSectionEngine = new PORTAL_MyInfoPageSectionEngine.Builder()
            .buildPageSectionAdapter(pageSectionAdapter)
            .buildSelfReportPageSectionAdapter(selfReportPageSectionAdapter)
            .buildHasPicklistValuesInConfiguration((Boolean)params?.get(HAS_PICKLIST_VALUES_IN_CONFIGURATION))
            .build();

        return pageSectionEngine;
    }

    protected virtual void performPostSaveOperations(PORTAL_DMLWrapper dmlWrapper) {
        // Create case
        return;
    }

    /**
     * Gets records to perform dml, will use PORTAL_MyInfoSave to handle logic
     * configs here will already contain portal page section setting => field section settings
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   updatedRecordList   List of records to update(insert/update/delete)
     * @param   sectionConfig       Configuration of specific section
     * 
     * @return  dmlWrapper
     */
    protected virtual PORTAL_DMLWrapper getDMLOperationsFromSection(List<Object> updatedRecordList, 
                                                                    PORTAL_MyInfoRetriever.SectionConfiguration sectionConfig) {

        if (updatedRecordList == null || updatedRecordList.isEmpty() || sectionConfig == null) {
            return null;
        }

        // Perform query for existing staging records/direct records
        PORTAL_MyInfoRetriever.EngineAdapter engine = getSectionEngine(sectionConfig);
        Map<String, Map<String, Object>> currentData = engine?.retrieveRecordMap(true);
        Map<String, Map<String, Object>> currentStagingRecordData = engine?.retrieveStagingRecordMap();

        List<Map<String, Object>> recordsToUpdateList = getRecordsThatMatchFieldValue(updatedRecordList, IS_DELETE, String.valueOf(false));
        List<Map<String, Object>> recordsToDeleteList = getRecordsThatMatchFieldValue(updatedRecordList, IS_DELETE, String.valueOf(true));

        PORTAL_MyInfoSave myInfoSave = new PORTAL_MyInfoSave.Builder().buildRecordDmlWrapper(new PORTAL_DMLWrapper())
                                                                      .buildConfigs(sectionConfig)
                                                                      .buildRecordMapsToUpdate(recordsToUpdateList)
                                                                      .buildRecordMapsToDelete(recordsToDeleteList)
                                                                      .buildCurrentRecords(currentData)
                                                                      .buildCurrentStagingRecords(currentStagingRecordData)
                                                                      .buildContact(this.contactId)
                                                                      .buildDummyContactId(this.dummyContactId)
                                                                      .buildDummyOrganizationId(this.dummyOrganizationId)
                                                                      .buildInterimRecordId(this.interimId)
                                                                      .build();

        this.interimId = myInfoSave.interimRecordId;

        return myInfoSave.getRecordsToPerformDML();
    }

    /**
     * Gets engine for section
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   sectionConfig           Configuration of specific section
     * 
     * @return                          Engine
     */
    protected virtual PORTAL_MyInfoRetriever.EngineAdapter getSectionEngine(PORTAL_MyInfoRetriever.SectionConfiguration sectionConfig){
        if (sectionConfig == null) {
            return null;
        }

        Map<String, Object> engineParamsMap = new Map<String, Object>();
        engineParamsMap.put(PAGE_NAME, MY_INFORMATION_PAGE_NAME);
        engineParamsMap.put(MAIN_SECTION_NAME, sectionConfig.mainSectionName);
        engineParamsMap.put(SUB_SECTION_NAME, sectionConfig.subSectionName);

        engineParamsMap.put(PARENT_FIELD_ID, this.contactId);
        engineParamsMap.put(STAGING_RECORD_PARENT_FIELD_ID, this.interimId);

        return getEngine(engineParamsMap);
    }

    /**
     * Gets information to populate look up fields on records when saving
     * this includes the contact id, dummy contact id, dummy contact org id, and the interim id
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     */
    protected virtual void populateIds() {
        this.contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.ContactId;
        List<Contact> dummyContactList = [SELECT Id, AccountId FROM Contact WHERE FirstName = :DUMMY_CONTACT_FIRST_NAME AND LastName = :DUMMY_CONTACT_LAST_NAME];
        this.dummyContactId = dummyContactList.get(0)?.Id;
        this.dummyOrganizationId = dummyContactList.get(0)?.AccountId;
        this.interimId = getStagingRecordParentFieldId(this.contactId);
        this.selfReportInterimId = getSelfReportStagingRecordParentFieldId(this.contactId);
    }

    /**
     * Merge interim and contact list inside of DML Wrapper
     * The reason is b/c its possible to include multiple interim/contact records with same ID in update list and that will fail
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @param   dmlWrapper  DML Wrapper containing lists to update
     * 
     * @return              DML Wrapper with modified updateMap
     */
    private PORTAL_DMLWrapper getMergedInterimAndContactDMLWrapper(PORTAL_DMLWrapper dmlWrapper) {
        if (dmlWrapper == null) {
            return dmlWrapper;
        }

        Map<String, List<SObject>> dmlWrapperUpdateMap = dmlWrapper.getUpdateMap();
        Map<String, List<SObject>> newUpdateMap = dmlWrapperUpdateMap.clone();

        List<SObject> interimList = dmlWrapperUpdateMap?.get(INTERIM_API_NAME);
        List<SObject> contactList = dmlWrapperUpdateMap?.get(CONTACT_API_NAME);

        newUpdateMap.put(INTERIM_API_NAME, getMergedUpdatedList(interimList, INTERIM_API_NAME));
        newUpdateMap.put(CONTACT_API_NAME, getMergedUpdatedList(contactList, CONTACT_API_NAME));

        dmlWrapper.setUpdateMap(newUpdateMap);

        return dmlWrapper;
    }

    /**
     * Gets the list of records to merge
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @param   sObjectsToMergeList     List of SObjects to merge from updateMap
     * @param   apiName                 API name of SObjects
     * 
     * @return                          List of SObjects that have been merged to contain few records as possible
     */
    private List<SObject> getMergedUpdatedList(List<SObject> sObjectsToMergeList, String apiName) {
        List<SObject> returnList = new List<SObject>();

        if (sObjectsToMergeList == null || sObjectsToMergeList.isEmpty() || String.isBlank(apiName)) {
            return returnList;
        }

        Map<String, Object> idToSObjectAccumulatorMap = new Map<String, Object>();

        for (SObject eachSObject : sObjectsToMergeList) {
            Map<String, Object> eachSObjectAsMap = eachSObject.getPopulatedFieldsAsMap().clone();

            if (!idToSObjectAccumulatorMap.containsKey(eachSObject.Id)) {
                idToSObjectAccumulatorMap.put(eachSObject.Id, eachSObjectAsMap);
                continue;
            }

            Map<String, Object> accumulatedSObjectMap = (Map<String, Object>)idToSObjectAccumulatorMap.get(eachSObject.Id);
            accumulatedSObjectMap.putAll(eachSObjectAsMap);
            idToSObjectAccumulatorMap.put(eachSObject.Id, accumulatedSObjectMap);
        }

        for (Object eachSObject : idToSObjectAccumulatorMap.values()) {
            Map<String, Object> eachSObjectAsMap = (Map<String, Object>)eachSObject;
            SObject newSObject = (SObject)System.Type.forName(apiName).newInstance();
            
            for (String eachSObjectField : eachSObjectAsMap.keySet()) {
                newSObject.put(eachSObjectField, eachSObjectAsMap.get(eachSObjectField));
            }

            returnList.add(newSObject);
        }

        return returnList;
    }

    /**
     * Gets records from a list that match a value given a certain field
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   recordList  List of records as maps
     * @param   field       Field on record to check against provided value
     * @param   value       Value to check 
     * 
     * @return              Returns list of records as maps that match the field & value
     */
    protected virtual List<Map<String, Object>> getRecordsThatMatchFieldValue(List<Object> recordList, String field, String value) {
        if (recordList == null || recordList.isEmpty() || String.isBlank(field)) {
            return new List<Map<String, Object>>();
        }

        List<Map<String, Object>> newRecordList = new List<Map<String, Object>>();

        for (Object eachRecordAsObject : recordList) {
            Map<String, Object> eachRecordAsMap = (Map<String, Object>)System.JSON.deserializeUntyped(System.JSON.serialize(eachRecordAsObject));
            if (String.valueOf(eachRecordAsMap.get(field)) == value) {
                newRecordList.add(eachRecordAsMap);
            }
        }

        return newRecordList;
    }

    /**
     * Gets the interim Id
     *
     * @author: Phillip Nguyen
     * @since:  1.7
     * 
     * @param contactId     String: id of the contact that the interim should look up to
     * 
     * @return: The ID of the constituent's interim that hasn't been processed yet
     */
    protected virtual String getStagingRecordParentFieldId(String contactId) {
        return this.getInterimId(contactId, PORTAL_CONST_PageSectionSetting.INTERIM_DISPLAY_STATUS, PORTAL_CONST_PageSectionSetting.INTERIM_RECORD_TYPE_NAME);
    }

    /**
     * Get the ID for the unprocessed interim containing self-reported info.
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param contactId     String: id of the contact that the interim should look up to
     * 
     * @return The ID of the constituent's interim that hasn't been processed yet containing self-reported info
     */
    protected virtual String getSelfReportStagingRecordParentFieldId(String contactId) {
        return this.getInterimId(contactId, MANUAL_REVIEW, BIO_INFORMATION_SELF_REPORT);
    }

    /**
     * Get the ID of an interim. Expects 0 or 1 results
     * 
     * @author Jacob Huang, basically copied from Phillip Nguyen 
     * @since 1.10
     * 
     * @param contactId                 String: id of the contact that the interim should look up to
     * @param status                    String: expected status of the interim
     * @param recordTypeDeveloperName   String: expected record type developer name of the interim 
     * 
     * @return Id of a queried interim, empty string if not found
     */
    protected virtual String getInterimId(String contactId, String status, String recordTypeDeveloperName) {
        List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id 
                                                        FROM ucinn_ascendv2__Interim__c 
                                                        WHERE ucinn_ascendv2__Contact__c = :contactId 
                                                        AND ucinn_ascendv2__Status__c = :status 
                                                        AND RecordType.DeveloperName = :recordTypeDeveloperName];
        return !interimList.isEmpty() ? (String)(interimList.get(0).Id) : '';
    }

    /**
     * Creates self report interim and associated case if interim does not exist yet
     * Sets self report interim id instance variable.
     * 
     * @author Jacob Huang
     * @since 1.10
     */
    private void createSelfReportInterimRecord() {
        if (String.isNotBlank(this.selfReportInterimId) || String.isBlank(this.contactId)) {
            return;
        }

        Case selfReportCase = this.insertSelfReportCase();
        ucinn_ascendv2__Interim__c newInterim = new ucinn_ascendv2__Interim__c(ucinn_ascendv2__Contact__c = this.contactId, 
                                                                                ucinn_ascendv2__Status__c = MANUAL_REVIEW,
                                                                                recordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(BIO_INFORMATION_SELF_REPORT).getRecordTypeId(),
                                                                                ucinn_portal_Case__c = selfReportCase?.Id,
                                                                                ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl());

        insert newInterim;
        this.selfReportInterimId = newInterim.Id;
    }

    /**
     * Create and insert case for self report interim, unless the portal org setting for creating a self report case is false 
     * 
     * @author Jacob Huang
     * @since 1.15
     * 
     * @return newly inserted Case or null if no Case was inserted
     */
    private Case insertSelfReportCase() {
        String isCreateCaseString = 'true';
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{PORTAL_MyInfoRetriever.VALUE_FIELD},
            PORTAL_Utils.SOBJECT_NAME => PORTAL_MyInfoRetriever.PORTAL_ORGANIZATION_SETTING,
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{CREATE_CASE_FOR_BIO_INFO_SELF_REPORT}
        });

        if (orgSettingList != null && !orgSettingList.isEmpty()) {
            isCreateCaseString = orgSettingList[0].Value__c;
        }

        if (isCreateCaseString.equalsIgnoreCase('false')) {
            return null;
        }

        Case selfReportCase = new Case(Origin = PORTAL_CONST,
                                       Subject = SELF_REPORT_CASE_SUBJECT,
                                       Status = NEW_CONST,
                                       Type = BIO_INFORMATION, 
                                       ContactId = this.contactId);

        List<Group> groupList = [SELECT Id FROM Group WHERE Type = :QUEUE_CONST AND Name = :BIO_INFORMATION_CASE_QUEUE LIMIT 1];
        if (!groupList.isEmpty()) {
            selfReportCase.OwnerId = groupList.get(0).Id;
        }
        
        insert selfReportCase;
        return selfReportCase;
    }

    /**
     * Convert an SObject into a wrapper/record map.
     * Some fields like formula fields or relationship fields may have missing or incorrect values
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param record            SObject: self report staging record to convert to a map, some fields may have missing values
     * @param sectionConfig     PORTAL_MyInfoRetriever.SectionConfiguration: configuration for a self report section
     * @param engine            PORTAL_MyInfoRetriever.EngineAdapter: engine using self report page section settings
     * 
     * @return SObject as a record map with up-to-date field values
     */
    protected virtual Map<String, Object> convertSelfReportRecordToWrapper(SObject record, PORTAL_MyInfoRetriever.SectionConfiguration sectionConfig, PORTAL_MyInfoRetriever.EngineAdapter engine) {
        if (record == null || sectionConfig == null || sectionConfig.fieldConfigurationMap == null || engine == null) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE}); 
        }

        // if there are relationship fields (like SObject__r.Field__c), then the object needs to be re-queried instead of just returned
        for (String eachField : sectionConfig.fieldConfigurationMap.keySet()) {
            if (sectionConfig.fieldConfigurationMap.get(eachField).stagingRecordFieldName.contains(PORTAL_MyInfoSave.CUSTOM_RELATIONSHIP_SUFFIX)) {
                return this.requerySelfReportRecord(record.Id, engine);
            }
        }

        List<SObject> sObjectAsList = new List<SObject>{record};
        Formula.recalculateFormulas(sObjectAsList);
        List<Map<String, Object>> recordWrapperList = engine.convertRecordsToWrapper(sObjectAsList, true);

        if (recordWrapperList == null || recordWrapperList.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE}); 
        }

        return recordWrapperList[0];
    }

    /**
     * Requery a self report record (based on record ID) in order to get updated relationship fields
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param engine        PORTAL_MyInfoRetriever.EngineAdapter: engine using self report page section settings
     * @param recordId      String: specifies the record to requery 
     * 
     * @return record as a map with the specified ID
     */
    protected virtual Map<String, Object> requerySelfReportRecord(String recordId, PORTAL_MyInfoRetriever.EngineAdapter engine) {
        if (engine == null || String.isBlank(recordId)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE}); 
        }

        List<Map<String, Object>> currentStagingRecordData = engine.retrieveSelfReportRecordList();
        for (Map<String, Object> eachSelfReportRecord : currentStagingRecordData) {
            if (recordId == eachSelfReportRecord.get(PORTAL_MyInfoSave.ID_CONST)) {
                return eachSelfReportRecord;
            }
        }

        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE}); 
    }
}