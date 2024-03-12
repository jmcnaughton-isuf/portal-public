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
 * Class for My Information Edit Saving
 * 
 * @author  Phillip Nguyen
 * @since   1.7
 */
public inherited sharing virtual class PORTAL_MyInfoSave {
    protected PORTAL_DMLWrapper recordDmlWrapper;
    protected PORTAL_MyInfoRetriever.SectionConfiguration configs;
    protected FieldUpdateConfigs fieldUpdateConfigs;
    protected List<Map<String, Object>> recordMapsToUpdate;
    protected List<Map<String, Object>> recordMapsToDelete;
    protected List<String> postFixExpressions;

    protected Map<String, Map<String, Object>> currentRecordsMap;
    protected Map<String, Map<String, Object>> currentStagingRecordsMap;
    Map<String, Object> selfReportRecordMap;

    protected String recordTypeId;
    protected String stagingRecordTypeId;

    protected String contactId;
    protected String dummyContactId;
    protected String dummyOrganizationId;
    protected String originalRecordId;

    protected Map<String, SObject> hashCodeToParentSObjectMap;  // upsert this after populating dml wrappers 

    public static final String ID_CONST = 'Id';
    public static final String EXTERNAL_SYSTEM_ID_API_NAME = 'ucinn_ascendv2__External_System_ID__c';
    public static final String END_DATE = 'End_Date';
    public static final String FORMULA_CONST = 'Formula';
    public static final String RECORD_TYPE_ID = 'RecordTypeId';
    public static final String BIO_INFORMATION = 'Bio_Information';
    public static final String PERSONAL_INFORMATION = 'Personal_Information';
    public static final String CONTACT_API_NAME = 'Contact';
    public static final String INTERIM_API_NAME = 'ucinn_ascendv2__Interim__c';
    public static final String AFFILIATION_API_NAME = 'ucinn_ascendv2__Affiliation__c'; 
    public static final String DEGREE_INFORMATION_API_NAME = 'ucinn_ascendv2__Degree_Information__c';
    public static final String ACCOUNT_FIELD_API_NAME = 'ucinn_ascendv2__Account__c';
    public static final String DEGREE_INSTITUTION_FIELD_API_NAME = 'ucinn_ascendv2__Degree_Institution__c';

    public static final String CONTACT_BIRTHDATE_API_NAME = 'Birthdate';
    public static final String CONTACT_BIRTH_DAY_API_NAME = 'ucinn_ascendv2__Birth_Day__c';
    public static final String CONTACT_BIRTH_MONTH_API_NAME = 'ucinn_ascendv2__Birth_Month__c';
    public static final String CONTACT_BIRTH_YEAR_API_NAME = 'ucinn_ascendv2__Birth_Year__c';
    public static final String STAGING_BIRTHDATE_API_NAME = 'ucinn_ascendv2__Birthdate__c';
    public static final String BIRTH_DATE = 'birthdate';
    public static final String BIRTH_MONTH = 'birthMonth';
    public static final String BIRTH_YEAR = 'birthYear';
    public static final String IS_DELETED = '%isDeleted%';
    public static final String OR_CONST = 'OR';
    public static final String AND_COST = 'AND';

    public static final String CUSTOM_FIELD_SUFFIX = '__c';
    public static final String CUSTOM_RELATIONSHIP_SUFFIX = '__r';

    public final String ERROR_DUPLICATE_MESSAGE = 'Entering duplicate information. Please enter different information or contact an administrator.';

    public String interimRecordId { get; protected set; }
 
    /**
     * Class that contains sets of fields for how to create/delete records
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     */
    private class FieldUpdateConfigs {
        Set<String> fieldsForNewRecord = new Set<String>();
        Set<String> fieldsForDirectUpdate = new Set<String>();
        Set<String> fieldsForStagingRecord = new Set<String>();
        Map<String, String> fieldsForDuplicateLogicMap = new Map<String, String>();
    }

    /**
     * Builder class used to construct PORTAL_MyInfoSave.
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     */
    public virtual class Builder {
        private PORTAL_MyInfoSave result;

        public Builder() {
            this.result = new PORTAL_MyInfoSave();
        }

        public virtual Builder buildRecordDmlWrapper(PORTAL_DMLWrapper recordDmlWrapper) {
            this.result.recordDmlWrapper = new PORTAL_DMLWrapper(recordDmlWrapper);

            return this;
        }            

        /**
         * Sets configs, which right now is page section configs and the fieldupdate configs
         * 
         * @author  Phillip Nguyen
         * @since   1.7
         * 
         * @param   configs     Configs which right now is page section setting
         */
        public virtual Builder buildConfigs(PORTAL_MyInfoRetriever.SectionConfiguration configs) {
            this.result.configs = configs;

            this.result.recordTypeId = this.result.getRecordTypeId();
            this.result.stagingRecordTypeId = this.result.getStagingRecordTypeId();
            this.result.fieldUpdateConfigs = this.result.getFieldUpdateConfigs();
            return this;
        }

        public virtual Builder buildRecordMapsToUpdate(List<Map<String, Object>> recordMapsToUpdate) {
            this.result.recordMapsToUpdate = recordMapsToUpdate;

            return this;
        }

        public virtual Builder buildRecordMapsToDelete(List<Map<String, Object>> recordMapsToDelete) {
            this.result.recordMapsToDelete = recordMapsToDelete;

            return this;
        }

        public virtual Builder buildSelfReportRecordMapToUpdate(Map<String, Object> selfReportRecordMap) {
            this.result.selfReportRecordMap = selfReportRecordMap;

            return this;
        }

        public virtual Builder buildCurrentRecords(Map<String, Map<String, Object>> currentRecordsMap) {
            this.result.currentRecordsMap = currentRecordsMap;

            return this;
        }

        public virtual Builder buildCurrentStagingRecords(Map<String, Map<String, Object>> currentStagingRecordsMap) {
            this.result.currentStagingRecordsMap = currentStagingRecordsMap;

            return this;
        }

        public virtual Builder buildContact(String contactId) {
            this.result.contactId = contactId;

            return this;
        }

        public virtual Builder buildDummyContactId(String dummyContactId) {
            this.result.dummyContactId = dummyContactId;
            return this;
        }

        public virtual Builder buildDummyOrganizationId(String dummyOrganizationId) {
            this.result.dummyOrganizationId = dummyOrganizationId;
            return this;
        }

        public virtual Builder buildOriginalRecordId(String originalRecordId) {
            this.result.originalRecordId = originalRecordId;

            return this;
        }

        /**
         * Build interim record ID, sets a flag to create the interim if it doesn't exist yet
         * 
         * @author Phillip Nguyen
         * @since 1.7
         */
        public virtual Builder buildInterimRecordId(String interimRecordId) {
            this.result.interimRecordId = interimRecordId;
            return this;
        }

        /**
         * Builds hashCodeToParentSObjectMap map
         * Creates interim record and sets the id, if record already exists, then just set the id
         * 
         * @author  Phillip Nguyen
         * @since   1.7
         * 
         */
        public virtual PORTAL_MyInfoSave build() {
            this.result.hashCodeToParentSObjectMap = new Map<String, SObject>();

            this.createInterimRecord();
            this.result.postFixExpressions = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => this.result.configs.duplicateFieldLogic});

            return this.result;
        }

        /**
         * Creates interim
         * TODO: move in the future?
         * @author  Phillip Nguyen
         * @since   1.8
         */
        private void createInterimRecord() {

            if (String.isNotBlank(this.result.interimRecordId) || String.isBlank(this.result.contactId)) {
                return;
            }

            String interimRecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(BIO_INFORMATION).getRecordTypeId();
            ucinn_ascendv2__Interim__c newInterim = new ucinn_ascendv2__Interim__c(ucinn_ascendv2__Contact__c = this.result.contactId, 
                                                                                    ucinn_ascendv2__Status__c = PORTAL_CONST_PageSectionSetting.INTERIM_DISPLAY_STATUS, 
                                                                                    recordTypeId = interimRecordTypeId,
                                                                                    ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl());
            insert newInterim;
            this.result.interimRecordId = newInterim.Id;
        }
    }

    /**
     * Gets records to perform DML
     * Includes creating/updating/deleting records
     * 
     * Right now it supports standard OOB configuration for portal page section settings
     * It also supports the related list enhancement
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @return  DML Wrapper
     */
    public virtual PORTAL_DMLWrapper getRecordsToPerformDML() {
        this.populateDMLWrapperWithUpdatedRecords();
        this.populateDMLWrapperWithDeletedRecords();
        return this.recordDmlWrapper;
    }

    /**
     * Save staging records for values that the user requests to update in frontend
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @return return the SObject that was updated/inserted
     */
    public virtual SObject selfReportInformation() {
        SObject stagingSObject = this.convertRecordMapToStagingSObject(this.selfReportRecordMap);

        if (this.configs.stagingRecordObjectName == INTERIM_API_NAME) {
            // this is always an update, but Id may not be populated if builder inserted the self report interim
            stagingSObject.put(ID_CONST, this.interimRecordId);
            update stagingSObject;
            return stagingSObject;
        } 

        if (String.isNotBlank(this.configs.originalRecordName)) {
            stagingSObject.put(this.configs.originalRecordName, this.originalRecordId);
        }

        this.populateControllingParentFieldsForStagingRecord(stagingSObject);
        this.populateDummyOrganizationId(stagingSObject);
  
        this.setParentForRecord(stagingSObject, this.selfReportRecordMap);
        if (!this.hashCodeToParentSObjectMap.isEmpty()) {
            SObject parentObject = (SObject)System.Type.forName(this.configs.controllingParentObject).newInstance();
            Database.upsert(this.hashCodeToParentSObjectMap.values(), parentObject.getSObjectType().getDescribe().fields.getMap().get(EXTERNAL_SYSTEM_ID_API_NAME));
        }

        upsert stagingSObject;
        return stagingSObject;
    }

    /**
     * Populates DML Wrapper with records that have been updated. 
     * This includes insert/update
     * 
     * Right now it supports standard OOB configuration for portal page section settings
     * It also supports the related list enhancement
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     */
    protected virtual void populateDMLWrapperWithUpdatedRecords() {
        if (this.fieldUpdateConfigs == null || this.recordMapsToUpdate == null || this.recordMapsToUpdate.isEmpty()) {
            return;
        }

        this.dedupeRecordsToUpdate();

        // order should be check for staging record, then for new record, then lastly for direct update
        for (Map<String, Object> eachRecordToUpdateAsMap : this.recordMapsToUpdate) {
            System.debug('eachRecordToUpdateAsMap');
            System.debug(eachRecordToUpdateAsMap);
            if (this.isUpdatingContactInformation() == true) {
                this.populateDMLWrapperWithUpdatedContactInformation(eachRecordToUpdateAsMap);
            } else if (this.isUpdatingPersonalInfoMappedToInterim() == true) {  // personal info related records but needs to map to interim
                SObject stagingObjectToUpdate = this.getStagingRecordWithPersonalInfoRelatedRecordsMappedToInterim(eachRecordToUpdateAsMap);
                this.recordDmlWrapper.addRecordForDML(this.configs.stagingRecordObjectName, stagingObjectToUpdate, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);

            } else if (this.isRelatedListEnhancementConfigured()) {
                this.createOrUpdateStagingRelatedRecords(eachRecordToUpdateAsMap);
            } else {
                this.createOrUpdateRelatedRecords(eachRecordToUpdateAsMap);
            }
        }

        if (!this.hashCodeToParentSObjectMap.isEmpty()) {
            SObject parentObject = (SObject)System.Type.forName(this.configs.controllingParentObject).newInstance();
            Database.upsert(this.hashCodeToParentSObjectMap.values(), parentObject.getSObjectType().getDescribe().fields.getMap().get(EXTERNAL_SYSTEM_ID_API_NAME));
        }
    }

    /**
     * Dedupes records that were updated on front end. 
     * This ensures that the user does not save two of the same record on the front end
     * 
     * @author  Phillip Nguyen
     * @since   1.10
     * 
     */
    private void dedupeRecordsToUpdate() {
        if (this.configs.hasDuplicateLogic != true || String.isBlank(this.configs.duplicateFieldLogic)) {
            return;
        }

        for (Integer index = 0; index < this.recordMapsToUpdate.size(); index++) {
            for (Integer innerIndex = index + 1; innerIndex < this.recordMapsToUpdate.size(); innerIndex++) {
                Map<String, Object> eachRecordToUpdateOuterRecord = this.recordMapsToUpdate.get(index);
                Map<String, Object> eachRecordToUpdateInnerRecord = this.recordMapsToUpdate.get(innerIndex);

                Boolean isRecordsMatch = this.isRecordsMatchUsingDuplicateLogic(eachRecordToUpdateOuterRecord, eachRecordToUpdateInnerRecord);

                if (isRecordsMatch == true) {
                    throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_DUPLICATE_MESSAGE});
                }
            }
        }
    }

    /**
     * Check if config/page section setting right now is using contact for sobject name
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @return      Boolean is SObjectApiName is Contact
     */
    protected virtual Boolean isUpdatingContactInformation() {
        return this.configs.sObjectApiName == CONTACT_API_NAME;
    }

    /**
     * Check if config/page section setting right now is personal information and going to staging record
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @return      Boolean that determines if current config main section is Personal Information & add new info to staging record
     */
    protected virtual Boolean isUpdatingPersonalInfoMappedToInterim() {
        return this.configs.mainSectionName == PERSONAL_INFORMATION 
                && (this.configs.isCreateStagingRecordUponCreation || this.configs.isCreateStagingRecordUponEdit);
    }

    /**
     * Populates DML Wrapper with Contact and Interim updates if applicable. This only applies for CMT that has Contact as SObject API Name.
     * Contains birthdate logic for contact and interim update
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @param   newRecordToUpdate   Record modified on front end (this would be containing contact info)
     */
    protected virtual void populateDMLWrapperWithUpdatedContactInformation(Map<String, Object> newRecordToUpdate) {
        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty()) {
            return;
        }

        Map<String, Object> currentContactMap = this.currentRecordsMap.values().get(0);

        SObject contactToUpdate = (SObject)System.Type.forName(this.configs.sObjectApiName).newInstance();
        contactToUpdate.put(ID_CONST, this.contactId);

        SObject interimToUpdate = null;
        if (String.isNotBlank((String)this.configs?.stagingRecordObjectName)) {
            interimToUpdate = (SObject)System.Type.forName(this.configs?.stagingRecordObjectName).newInstance();
            interimToUpdate.put(ID_CONST, this.interimRecordId);
        }
        
        for (String eachFieldId : newRecordToUpdate.keySet()) {
            if (!this.configs.fieldConfigurationMap.containsKey(eachFieldId)) {
                continue;
            }

            if (this.configs.isCreateStagingRecordUponEdit == true 
                    || this.configs.isCreateStagingRecordUponCreation == true
                    || this.fieldUpdateConfigs.fieldsForStagingRecord.contains(eachFieldId)) {
                interimToUpdate = this.getContactStagingRecordWithFieldUpdated(interimToUpdate, eachFieldId, newRecordToUpdate);
            } else {
                contactToUpdate = this.getContactRecordWithFieldUpdated(contactToUpdate, eachFieldId, newRecordToUpdate, currentContactMap);
            }
        }

        this.recordDmlWrapper.addRecordForDML(this.configs.sObjectApiName, contactToUpdate, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
        if (interimToUpdate != null) {
            this.recordDmlWrapper.addRecordForDML(this.configs.stagingRecordObjectName, interimToUpdate, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
        }
    }

    /**
     * Gets staging record/interim with personal info populated. The info are related records like directory name, former name, etc
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @param newRecordToUpdate     Map containing information to map to staging record
     * 
     * @return                      Populated Staging Record/Interim
     */
    protected virtual SObject getStagingRecordWithPersonalInfoRelatedRecordsMappedToInterim(Map<String, Object> newRecordToUpdate) {
        SObject interimToUpdate = (SObject)System.Type.forName(this.configs.stagingRecordObjectName).newInstance();

        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty()) {
            return interimToUpdate;
        }

        Map<String, Object> currentStagingRecordDataMap = new Map<String, Object>();
        
        List<Map<String, Object>> currentStagingRecordsValuesList = this.currentStagingRecordsMap?.values();

        if (currentStagingRecordsValuesList != null && !currentStagingRecordsValuesList.isEmpty()) {
            currentStagingRecordDataMap = currentStagingRecordsValuesList.get(0);
        }

        interimToUpdate.put(ID_CONST, this.interimRecordId);

        for (String eachFieldId : newRecordToUpdate.keySet()) {
            if (!this.fieldUpdateConfigs.fieldsForNewRecord.contains(eachFieldId)) {
                continue;
            }

            String fieldValue = String.isBlank((String)newRecordToUpdate.get(eachFieldId)) ? IS_DELETED : (String)newRecordToUpdate.get(eachFieldId);

            if (fieldValue == currentStagingRecordDataMap?.get(eachFieldId)) {
                continue;
            }

            interimToUpdate.put(this.configs.fieldConfigurationMap.get(eachFieldId).stagingRecordFieldName, fieldValue);
        }

        return interimToUpdate;
    }

    /**
     * Gets contact record with a field populated (if the field value changed and it's not a relationship field).
     * Possible that the field has special logic, like birthdate
     * 
     * @author Jacob Huang
     * @since 1.14
     * 
     * @param contactRecordToUpdate     Contact record for update 
     * @param fieldToUpdate             Front end field ID to set value for
     * @param newRecordToUpdate         Map of front end field ID to user-inputted values for update
     * @param currentContactMap         Map of front end field ID to existing contact values
     * 
     * @return                          contactRecordToUpdate argument, possibly with a new field populated
     */
    private SObject getContactRecordWithFieldUpdated(SObject contactRecordToUpdate, String fieldToUpdate, Map<String, Object> newRecordToUpdate, Map<String, Object> currentContactMap) {
        String fieldApiName = this.configs?.fieldConfigurationMap?.get(fieldToUpdate)?.fieldName;
        if (contactRecordToUpdate == null || String.isBlank(fieldToUpdate) || String.isBlank(fieldApiName) || newRecordToUpdate == null || currentContactMap == null ||
            newRecordToUpdate.get(fieldToUpdate) == currentContactMap.get(fieldToUpdate) || fieldApiName.contains(CUSTOM_RELATIONSHIP_SUFFIX)) {

            return contactRecordToUpdate;
        }

        if (fieldApiName == CONTACT_BIRTH_DAY_API_NAME || fieldApiName == CONTACT_BIRTH_MONTH_API_NAME || fieldApiName == CONTACT_BIRTH_YEAR_API_NAME) {
            return this.getRecordWithUpdatedBirthdate(contactRecordToUpdate, newRecordToUpdate, CONTACT_BIRTHDATE_API_NAME);
        }

        contactRecordToUpdate.put(fieldApiName, newRecordToUpdate.get(fieldToUpdate));
        return contactRecordToUpdate;
    }

    /**
     * Gets interim record with a field populated. Possible each field has special logic such as birthdate
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @param   stagingRecordToUpdate   Interim Record to Update
     * @param   fieldToUpdate           Field To Populate on Interim
     * @param   newRecordToUpdate       Map containing information to map to staging record
     * 
     * @return                          Interim record with field populated
     */
    private SObject getContactStagingRecordWithFieldUpdated(SObject stagingRecordToUpdate, String fieldToUpdate, Map<String, Object> newRecordToUpdate) {
        String stagingRecordFieldApiName = this.configs.fieldConfigurationMap.get(fieldToUpdate).stagingRecordFieldName;

        if (stagingRecordToUpdate == null || String.isBlank(fieldToUpdate) 
                || newRecordToUpdate == null || newRecordToUpdate.isEmpty()
                || String.isBlank(stagingRecordFieldApiName)) {
            return stagingRecordToUpdate;
        }

        Map<String, Object> currentStagingRecordDataMap = new Map<String, Object>();
        
        List<Map<String, Object>> currentStagingRecordsValuesList = this.currentStagingRecordsMap?.values();

        if (currentStagingRecordsValuesList != null && !currentStagingRecordsValuesList.isEmpty()) {
            currentStagingRecordDataMap = currentStagingRecordsValuesList.get(0);
        }

        String fieldValue = String.isBlank((String)newRecordToUpdate.get(fieldToUpdate)) ? IS_DELETED : (String)newRecordToUpdate.get(fieldToUpdate);

        if (stagingRecordFieldApiName == STAGING_BIRTHDATE_API_NAME) {
            // TODO: might need to add new conditional branch for birthdate but need extensive testing once front end is done
            return this.getRecordWithUpdatedBirthdate(stagingRecordToUpdate, newRecordToUpdate, STAGING_BIRTHDATE_API_NAME);
        } else if (fieldValue != currentStagingRecordDataMap?.get(fieldToUpdate)) {
            stagingRecordToUpdate.put(stagingRecordFieldApiName, fieldValue);
        }

        return stagingRecordToUpdate;
    }

    /**
     * Get record with birthdate populated
     * 
     * @author  Phillip Nguyen, Jacob Huang
     * @since   1.8
     * 
     * @param   recordToUpdate          Record (contact or interim) to Update
     * @param   newRecordToUpdate       Map containing information to map to staging record
     * @param   birthdateFieldApiName   String: birthdate field API name on the record to update
     * 
     * @return                          Record with birthdate populated
     */
    private SObject getRecordWithUpdatedBirthdate(SObject recordToUpdate, Map<String, Object> newRecordToUpdate, String birthdateFieldApiName) {
        if (recordToUpdate == null || newRecordToUpdate == null || newRecordToUpdate.isEmpty() || String.isBlank(birthdateFieldApiName)) {
            return recordToUpdate;
        }

        if (newRecordToUpdate.get(BIRTH_DATE) == null 
                || newRecordToUpdate.get(BIRTH_MONTH) == null
                || newRecordToUpdate.get(BIRTH_YEAR) == null) {
            return recordToUpdate;
        }

        Integer day = Integer.valueOf(newRecordToUpdate.get(BIRTH_DATE));
        Integer month = Integer.valueOf(newRecordToUpdate.get(BIRTH_MONTH));
        Integer year = Integer.valueOf(newRecordToUpdate.get(BIRTH_YEAR));
        recordToUpdate.put(birthdateFieldApiName, Date.newInstance(year, month, day));

        return recordToUpdate;
    }

    /**
     * Populates DML Wrapper with records that have been deleted
     * 
     * Supports hard delete and inactivation of records
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     */
    protected virtual void populateDMLWrapperWithDeletedRecords() {
        if (this.recordMapsToDelete == null || this.recordMapsToDelete.isEmpty()) {
            return;
        }

        for (Map<String, Object> eachRecordToDelete : this.recordMapsToDelete) {
            SObject recordToDelete = null;
            String sObjectApiName = '';

            if (this.isRelatedListEnhancementConfigured()) {
                recordToDelete = this.convertRecordMapToStagingSObject(eachRecordToDelete);
                sObjectApiName = this.configs.stagingRecordObjectName;
            } else {
                recordToDelete = this.convertRecordMapToSObject(eachRecordToDelete);
                sObjectApiName = this.configs.sObjectApiName;
            }

            if (this.configs.isHardDeleteRecords == true) {
                this.recordDmlWrapper.addRecordForDML(sObjectApiName, recordToDelete, PORTAL_DMLWrapper.DmlOperation.DELETE_OP);
            } else {
                recordToDelete = this.getInactiveRecord(recordToDelete);
                this.recordDmlWrapper.addRecordForDML(sObjectApiName, recordToDelete, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
            }
        }
    }

    /**
     * Populates DML Wrapper with staging records to insert/update. Contains logic for related list enhancement
     * This also includes logic for assigning original record field 
     * and assigning lookups to look at interim and dummy contact
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param newRecordToUpdate     Record that was modified in front end
     */
    @TestVisible
    protected virtual void createOrUpdateStagingRelatedRecords(Map<String, Object> newRecordToUpdate) {
        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty()) {
            return;
        }

        String recordId = (String)newRecordToUpdate.get(ID_CONST);
        String stagingRecordId = this.getMatchingRecordId(newRecordToUpdate, this.currentStagingRecordsMap);

        Boolean isNewRecord = String.isBlank(recordId);

        // the following two should be mutually exclusive in practice
        Boolean hasCurrentExistingRecordBeenModified = this.currentRecordsMap.containsKey(recordId)
                                                        && this.hasRecordFieldsBeenChanged(newRecordToUpdate, this.currentRecordsMap.get(recordId), this.fieldUpdateConfigs.fieldsForNewRecord);

        Boolean hasCurrentExistingStagingRecordBeenModified = this.currentStagingRecordsMap.containsKey(recordId)
                                                                && this.hasRecordFieldsBeenChanged(newRecordToUpdate, this.currentStagingRecordsMap.get(recordId), this.fieldUpdateConfigs.fieldsForNewRecord);

        if (isNewRecord == true) {
            this.addNewStagingRecordsToDmlWrapper(stagingRecordId, newRecordToUpdate);
            return;
        }

        if (hasCurrentExistingRecordBeenModified == true) {
            SObject newRecord = this.getNewStagingRecord(newRecordToUpdate);
            newRecord = this.getStagingRecordWithOriginalRecordIdPopulated(newRecord, (String)newRecordToUpdate.get(ID_CONST));

            this.recordDmlWrapper.addRecordForDML(this.configs.stagingRecordObjectName, newRecord, PORTAL_DMLWrapper.DmlOperation.INSERT_OP);
        } else if (hasCurrentExistingStagingRecordBeenModified == true) {
            SObject stagingRecordToUpdate = this.convertRecordMapToStagingSObject(newRecordToUpdate);
            stagingRecordToUpdate = this.setParentForRecord(stagingRecordToUpdate, newRecordToUpdate);

            this.recordDmlWrapper.addRecordForDML(this.configs.stagingRecordObjectName, stagingRecordToUpdate, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
        }
    }

    /**
     * Contains logic for standard OOB config for related records
     * This includes logic using the active and inactive record field map
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param newRecordToUpdate     Record that was modified in front end
     */
    protected virtual void createOrUpdateRelatedRecords(Map<String, Object> newRecordToUpdate) {
        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty()) {
            return;
        }

        String recordId = (String)newRecordToUpdate.get(ID_CONST);
        String matchingRecordId = this.getMatchingRecordId(newRecordToUpdate, this.currentRecordsMap);

        Boolean isNewRecord = String.isBlank(recordId);

        // for a record to be directly updated, the record has to exist, the fields that were changed were not ones that require to make a new record, 
        // and the fields that have been changed has to be ones that are able to be directly updated
        Boolean isRecordForDirectUpdate = this.currentRecordsMap.containsKey(recordId)
                                            && !this.hasRecordFieldsBeenChanged(newRecordToUpdate, this.currentRecordsMap.get(recordId), this.fieldUpdateConfigs.fieldsForNewRecord)
                                            && this.hasRecordFieldsBeenChanged(newRecordToUpdate, this.currentRecordsMap.get(recordId), this.fieldUpdateConfigs.fieldsForDirectUpdate);

        Boolean hasCurrentExistingRecordBeenModified = this.currentRecordsMap.containsKey(recordId)
                                                        && this.hasRecordFieldsBeenChanged(newRecordToUpdate, this.currentRecordsMap.get(recordId), this.fieldUpdateConfigs.fieldsForNewRecord);

        if (isNewRecord == true) {
            this.addNewRelatedRecordsToDMLWrapper(matchingRecordId, newRecordToUpdate);
            return;
        }

        if (isRecordForDirectUpdate == true) {
            this.recordDmlWrapper.addRecordForDML(this.configs.sObjectApiName, this.convertRecordMapToSObject(newRecordToUpdate), PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
        } else if (hasCurrentExistingRecordBeenModified == true) {
            this.addNewRecordAndInactiveCurrentRecordToDmlWrapper(newRecordToUpdate, recordId);
        }
    }

    /**
     * Gets the matching record for a new record (record has no Id)
     * This is for the case when a user adds a new record but it actually matches an inactive record in the database
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param newRecordAsMap        Record that was modified in front end
     * @param currentRecordsMap     Current map of record ids to record in the database
     * 
     * @return                      Id of Record that is found in database
     */
    private String getMatchingRecordId(Map<String, Object> newRecordAsMap, Map<String, Map<String, Object>> currentRecordsMap) {
        String returnString = '';
        if (newRecordAsMap == null || newRecordAsMap.isEmpty() 
                || currentRecordsMap == null || currentRecordsMap.isEmpty() 
                || this.configs.hasDuplicateLogic != true 
                || String.isBlank(this.configs.duplicateFieldLogic)) {
            return returnString;
        }

        for (String eachRecordId : currentRecordsMap.keySet()) {
            Map<String, Object> eachCurrentRecordAsMap = currentRecordsMap.get(eachRecordId);
            Boolean isRecordsMatch = this.isRecordsMatchUsingDuplicateLogic(newRecordAsMap, eachCurrentRecordAsMap);

            if (isRecordsMatch == true) {
                return eachRecordId;
            }
        } 

        return returnString;
    }

    /**
     * Checks to see if record has been changed by comparing specific fields
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param newRecordToUpdate     Record that was modified in front end
     * @param currentRecordsMap     Current map of record ids to record in the database
     * @param fieldSet              Fields to compare 
     * 
     * @return                      Boolean to see if record has been modified
     */
    private Boolean hasRecordFieldsBeenChanged(Map<String, Object> newRecordAsMap, Map<String, Object> currentRecordAsMap, Set<String> fieldSet) {
        if (newRecordAsMap == null || newRecordAsMap.isEmpty() 
                || currentRecordAsMap == null || currentRecordAsMap.isEmpty() 
                || fieldSet == null || fieldSet.isEmpty()) {
            return false;
        }

        for (String eachField : fieldSet) {
            if (newRecordAsMap.get(eachField) != currentRecordAsMap.get(eachField)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Gets fields that will be checked to determine if we perform a direct update, or create a new record, etc..
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @return                          FieldUpdateConfigs class that contains list of fields to determine if we perform a direct update, or create a new record, etc..
     */
    private FieldUpdateConfigs getFieldUpdateConfigs() {
        List<PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigurationList = this.configs?.fieldConfigurationMap?.values();
        if (fieldConfigurationList == null || fieldConfigurationList.isEmpty()) {
            return null;
        }

        FieldUpdateConfigs fieldSets = new FieldUpdateConfigs();

        for (PORTAL_MyInfoRetriever.FieldConfiguration eachFieldConfig : fieldConfigurationList) {
            if (String.isBlank(eachFieldConfig?.fieldId)) {
                continue;
            }

            if (String.isNotBlank(eachFieldConfig.fieldOrderForDuplicateLogic) && String.isNotBlank(eachFieldConfig.fieldId)) {
                fieldSets.fieldsForDuplicateLogicMap.put(eachFieldConfig.fieldOrderForDuplicateLogic, eachFieldConfig.fieldId);
            }

            if (eachFieldConfig.isCreateNewRecord == false && eachFieldConfig.isCreateStagingRecordOnFieldChange == false) {
                fieldSets.fieldsForDirectUpdate.add(eachFieldConfig.fieldId);
            } else if (eachFieldConfig.isCreateNewRecord == true) {
                fieldSets.fieldsForNewRecord.add(eachFieldConfig.fieldId);
            } else if (eachFieldConfig.isCreateStagingRecordOnFieldChange == true) {
                fieldSets.fieldsForStagingRecord.add(eachFieldConfig.fieldId);
            }
        }

        return fieldSets;
    }

    /**
     * Get the record type ID for the section records based on the configuration
     * 
     * @author Jacob Huang
     * @since 1.8
     * 
     * @return Record Type ID
     */
    private String getRecordTypeId() {
        if (String.isBlank(this.configs?.sObjectApiName) || String.isBlank(this.configs?.recordTypeDeveloperName)) {
            return null;
        }

        SObject record = (SObject)System.Type.forName(this.configs.sObjectApiName).newInstance();
        return record.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName().get(this.configs.recordTypeDeveloperName).getRecordTypeId();

    }

    /**
     * Get the record type ID for the section staging records based on the configuration
     * 
     * @author Jacob Huang
     * @since 1.8
     * 
     * @return Record Type ID for staging records
     */
    private String getStagingRecordTypeId() {
        if (String.isBlank(this.configs?.stagingRecordObjectName) || String.isBlank(this.configs?.stagingRecordTypeDeveloperName)) {
            return null;
        }

        SObject record = (SObject)System.Type.forName(this.configs.stagingRecordObjectName).newInstance();
        return record.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName().get(this.configs.stagingRecordTypeDeveloperName).getRecordTypeId();
    }

    /**
     * Creates new sobject and sets the sobject's id to current record id. Then inactivate the record.
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   currentRecordsMap       Current map of record ids to record in the database
     * 
     * @return                          Current SObject that is inactive (according to inactive record field map)
     */
    private SObject getInactivatedCurrentRecord(Map<String, Object> currentRecordAsMap) {
        if (currentRecordAsMap == null || currentRecordAsMap.isEmpty()) {
            return null;
        }
        SObject currentRecord = (SObject)System.Type.forName(this.configs.sObjectApiName).newInstance();
        currentRecord.put(ID_CONST, currentRecordAsMap.get(ID_CONST));
        currentRecord = this.getInactiveRecord(currentRecord);
        return currentRecord;
    }

    /**
     * Converts new record as map to SObject, activate the record and then sets the new record's id field
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   newRecordAsMap          Record that was modified in front end
     * @param   recordId                Id of record
     * 
     * @return                          New SObject that is active (according to active record field map)
     */
    private SObject getActivatedSObjectFromRecordMapAndId(Map<String, Object> newRecordAsMap, String recordId) {
        if (newRecordAsMap == null || newRecordAsMap.isEmpty()) {
            return null;
        }

        SObject newRecord = this.convertRecordMapToSObject(newRecordAsMap);
        newRecord = this.getActivatedRecord(newRecord);
        newRecord.put(ID_CONST, recordId);
        return newRecord;
    }

    /**
     * Activate record using active record field map
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   record                  Record to be activated
     * 
     * @return                          Return record with fields activated
     */
    private SObject getActivatedRecord(SObject record) {
        if (record == null || String.isBlank(this.configs.activeRecordFieldMapString)) {
            return record;
        }

        SObject recordToActivate = record;

        Map<String, Object> activeRecordFieldMap = (Map<String, Object>)JSON.deserializeUntyped(this.configs.activeRecordFieldMapString);

        if (activeRecordFieldMap == null || activeRecordFieldMap.isEmpty()) {
            return recordToActivate;
        }

        for (String eachField : activeRecordFieldMap.keySet()) {
            recordToActivate.put(eachField, activeRecordFieldMap.get(eachField));
        }

        return recordToActivate;
    }

    /**
     * Inactivate record using inactive record field map
     * If end date is included in this mapping, set records end date to today
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   record                  Record to be inactivated
     */
    private SObject getInactiveRecord(SObject record) {
        if (record == null || String.isBlank(this.configs.inactiveRecordFieldMapString)) {
            return record;
        }

        SObject recordToInactivate = record;

        Map<String, Object> inactiveRecordFieldMap = (Map<String, Object>)JSON.deserializeUntyped(this.configs.inactiveRecordFieldMapString);

        if (inactiveRecordFieldMap == null || inactiveRecordFieldMap.isEmpty()) {
            return recordToInactivate;
        }

        for (String eachField : inactiveRecordFieldMap.keySet()) {
            if (eachField.contains(END_DATE)) {
                recordToInactivate.put(eachField, Date.today());
            } else {
                recordToInactivate.put(eachField, inactiveRecordFieldMap.get(eachField));
            }
        }

        return recordToInactivate;
    }

    /**
     * Populates the controlling parent field with the constituent's id
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   newRecord   Record to populate
     */
    private void populateControllingParentFieldsForNewRecord(SObject newRecord) {
        if (newRecord == null) {
            return;
        }
        
        newRecord.put(this.configs.controllingParentField, this.contactId);
    }

    /**
     * Populates the controlling parent field 
     * and the staging record controlling parent field
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   newRecord   Record to populate
     */
    private void populateControllingParentFieldsForStagingRecord(SObject newRecord) {
        if (newRecord == null || String.isBlank(this.configs.controllingParentField) || String.isBlank(this.configs.stagingRecordControllingParentField)) {
            return;
        }
        
        newRecord.put(this.configs.controllingParentField, this.dummyContactId);
        newRecord.put(this.configs.stagingRecordControllingParentField, this.interimRecordId);
    }

    /**
     * If controlling parent object is populated, depending on the SObject type,
     * populate an empty Account lookup field with the dummy organization ID
     * 
     * future TODO: this method and/or the logic within may or may not be required or changed
     * depending on the case to convert these Account lookup fields to text fields in frontend 
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param newRecord    SObject: record to populate
     */
    private void populateDummyOrganizationId(SObject newRecord) {
        if (newRecord == null || (this.configs.stagingRecordObjectName != AFFILIATION_API_NAME && this.configs.stagingRecordObjectName != DEGREE_INFORMATION_API_NAME)) {
            return; 
        }
    
        String accountField = this.configs.stagingRecordObjectName == AFFILIATION_API_NAME ? ACCOUNT_FIELD_API_NAME : DEGREE_INSTITUTION_FIELD_API_NAME;
        if (String.isBlank((String)newRecord.get(accountField))) {
            newRecord.put(accountField, this.dummyOrganizationId);
        }
    }

    /**
     * Populates original record field on record and then deletes id on record since we should not be updating
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   stagingRecord      Staging record to populate
     * @param   originalRecordId   Original Record Id
     * 
     * @return                     Staging record with original record Id populated and its own Id deleted
     * 
     */
    private SObject getStagingRecordWithOriginalRecordIdPopulated(SObject stagingRecord, String originalRecordId) {
        if (stagingRecord == null) {
            return stagingRecord;
        }

        stagingRecord.put(this.configs.originalRecordName, originalRecordId);
        stagingRecord.put(ID_CONST, null);

        return stagingRecord;
    }

    /**
     * Create new staging record for related list enhancement
     * Populates controlling parent fields on record
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   newRecordMap      Record to create
     * 
     * @return                    New Staging SObject
     */
    private SObject getNewStagingRecord(Map<String, Object> newRecordMap) {
        if (newRecordMap == null || newRecordMap.isEmpty()) {
            return null;
        }

        SObject newRecord = this.convertRecordMapToStagingSObject(newRecordMap);
        newRecord = this.getActivatedRecord(newRecord);
        this.populateControllingParentFieldsForStagingRecord(newRecord);
        newRecord = this.setParentForRecord(newRecord, newRecordMap);

        return newRecord;
    }

    /**
     * Sets parent of staging record we are updating if config populates controlling parent object field on CMT. 
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   recordToUpdate             Record to update
     * @param   recordAsMap                Record to update as a map (before conversion to sobject)
     * 
     * @return                             Return record that we are updating (possibly with the parent populated)
     */
    private SObject setParentForRecord(SObject recordToUpdate, Map<String, Object> recordAsMap) {
        if (recordToUpdate == null || String.isBlank(this.configs.controllingParentObject)) {
            return recordToUpdate;
        }

        SObject parentRecord = this.getPopulatedParentSObject(recordAsMap);

        String hashCode = PORTAL_CommunityUtils.hashObjectFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_SOBJECT_TYPE => 
                                                                                ((SObject)Type.forName(this.configs.controllingParentObject).newInstance()).getSObjectType(), 
                                                                                PORTAL_CommunityUtils.PARAM_SOBJECT_RECORD => parentRecord});

        SObject parentReference = this.getParentSObjectReference(hashCode);
        if (parentReference != null) {
            recordToUpdate.putSObject(this.configs.controllingParentObject.replace(CUSTOM_FIELD_SUFFIX, CUSTOM_RELATIONSHIP_SUFFIX), parentReference);
        }

        parentRecord.put(EXTERNAL_SYSTEM_ID_API_NAME, hashCode);
        parentRecord.put(ID_CONST, null);
        this.hashCodeToParentSObjectMap.put(hashCode, parentRecord);

        return recordToUpdate;
    }

    /**
     * Creates parent reference which is used to set the parent foreign key reference on the child sobject
     * This object should only have the EXTERNAL ID FIELD SET
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   hashCode                                External System Id (Foreign Key)
     * @return                                          Returns Parent Reference
     */
    private SObject getParentSObjectReference(String hashCode) {
        if (String.isBlank(this.configs.controllingParentObject)) {
            return null;
        }

        SObject newParentReference = (SObject)System.Type.forName(this.configs.controllingParentObject).newInstance();
                
        newParentReference.put(EXTERNAL_SYSTEM_ID_API_NAME, hashCode);
        return newParentReference;
    }

    /**
     * Populate fields on parent object
     * Loop through the record that was modified, and check for fields with '__r'
     * These fields should be populated on the parent object, has logic to either use the staging record field or normal fields
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   childRecordAsMap                        Record that was updated as a map
     * 
     * @return                                          Returns Parent SObject that is populate
     * 
     */
    private SObject getPopulatedParentSObject(Map<String, Object> childRecordAsMap) {
        Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigurationMap = this.configs.fieldConfigurationMap;

        if (childRecordAsMap == null || childRecordAsMap.isEmpty() || fieldConfigurationMap == null || fieldConfigurationMap.isEmpty() || String.isBlank(this.configs.controllingParentObject)) {
            return null;
        }

        SObject newParentObject = (SObject)System.Type.forName(this.configs.controllingParentObject).newInstance();

        for (String eachField : childRecordAsMap.keySet()) {
            if (fieldConfigurationMap.containsKey(eachField) == false) {
                continue;
            }

            String fieldNameToUse = this.isRelatedListEnhancementConfigured() ? fieldConfigurationMap.get(eachField).stagingRecordFieldName : fieldConfigurationMap.get(eachField).fieldName;

            if (!fieldNameToUse.contains(CUSTOM_RELATIONSHIP_SUFFIX)) {
                continue;
            }

            List<String> fieldList = fieldNameToUse.split('\\.');
            String fieldApiName = fieldList.get(fieldList.size() - 1);

            newParentObject.put(fieldApiName, childRecordAsMap.get(eachField));
        }

        return newParentObject;
    }

    /**
     * Determines if we linked related list information to interims
     * Determined by 4 different fields, Is Create Staging Record Upon Edit, Staging sObject API Name not blank,
     * original record field api name, and Staging Record Controlling Parent Field not blank
     *
     * @author      Phillip Nguyen
     * @since       1.7
     *
     * @return                  Boolean value determining if we are linking related list to interims
     */
    protected virtual Boolean isRelatedListEnhancementConfigured() {
        if (this.configs == null) {
            return false;
        }

        return (this.configs.isCreateStagingRecordUponEdit
                  && String.isNotBlank(this.configs.stagingRecordObjectName)
                  && String.isNotBlank(this.configs.stagingRecordControllingParentField)
                  && String.isNotBlank(this.configs.originalRecordName)
                 );
    }

    /**
     * Converts the record as a map to an SObject using standard fields (field api name on CMT)
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   eachRecordToUpdateAsMap                 Record that was updated as a map
     * 
     * @return                                          SObject of that record
     * 
     */
    private SObject convertRecordMapToSObject(Map<String, Object> eachRecordToUpdateAsMap) {
        SObject convertedRecord = null;
        Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigurationMap = this.configs.fieldConfigurationMap;

        if (eachRecordToUpdateAsMap == null || eachRecordToUpdateAsMap.isEmpty() || fieldConfigurationMap == null || fieldConfigurationMap.isEmpty()) {
            return convertedRecord;
        }

        convertedRecord = (SObject)System.Type.forName(this.configs.sObjectApiName).newInstance();

        for (String eachField : eachRecordToUpdateAsMap.keySet()) {
            if (fieldConfigurationMap.containsKey(eachField) == false || fieldConfigurationMap.get(eachField).fieldName.contains(CUSTOM_RELATIONSHIP_SUFFIX) || fieldConfigurationMap.get(eachField).fieldName.contains(FORMULA_CONST)) {
                continue;
            }

            Object fieldValue = eachRecordToUpdateAsMap.get(eachField);
            if (fieldConfigurationMap.get(eachField).fieldType == PORTAL_CONST_PageSectionSetting.DATE_FIELD_NAME) {
                fieldValue = String.isNotBlank((String)fieldValue) ? Date.valueOf((String)fieldValue) : null;
            }

            convertedRecord.put(fieldConfigurationMap.get(eachField).fieldName, fieldValue);
        }

        if (String.isNotBlank(this.recordTypeId)) {
            convertedRecord.put(RECORD_TYPE_ID, this.recordTypeId);
        }

        return convertedRecord;
    }

    /**
     * Adds new staging record to DML wrapper. Handles logic for if it is a brand new record, and the case if the new record exists in the database already
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   stagingRecordId                             Possible Id of staging record that exists in database
     * @param   newRecordToUpdate                           New Record to add to DML wrapper in the form of a map
     */
    private void addNewStagingRecordsToDmlWrapper(String stagingRecordId, Map<String, Object> newRecordToUpdate) {
        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty()) {
            return;
        }

        if (String.isBlank(stagingRecordId)) {
            SObject newRecord = this.getNewStagingRecord(newRecordToUpdate);

            this.recordDmlWrapper.addRecordForDML(this.configs.stagingRecordObjectName, newRecord, PORTAL_DMLWrapper.DmlOperation.INSERT_OP);
            return;
        }

        SObject stagingRecordToUpdate = this.convertRecordMapToStagingSObject(newRecordToUpdate);
        stagingRecordToUpdate = this.getActivatedRecord(stagingRecordToUpdate);
        stagingRecordToUpdate.put(ID_CONST, stagingRecordId);
        stagingRecordToUpdate = this.setParentForRecord(stagingRecordToUpdate, newRecordToUpdate);

        this.recordDmlWrapper.addRecordForDML(this.configs.stagingRecordObjectName, stagingRecordToUpdate, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
    }

    /**
     * Adds new related record to DML wrapper. Handles logic for if it is a brand new record, and the case if the new record exists in the database already
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   matchingRecordId                     Possible Id of record that exists in database
     * @param   newRecordToUpdate                    New Record to add to DML wrapper in the form of a map
     */
    private void addNewRelatedRecordsToDMLWrapper(String matchingRecordId, Map<String, Object> newRecordToUpdate) {
        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty()) {
            return;
        }

        if (String.isNotBlank(matchingRecordId)) {
            SObject activeNewRecord = this.getActivatedSObjectFromRecordMapAndId(newRecordToUpdate, matchingRecordId);
            this.recordDmlWrapper.addRecordForDML(this.configs.sObjectApiName, activeNewRecord, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
            return;
        } 

        SObject newRecord = this.convertRecordMapToSObject(newRecordToUpdate);
        newRecord = this.getActivatedRecord(newRecord);
        this.populateControllingParentFieldsForNewRecord(newRecord);
        newRecord = this.setParentForRecord(newRecord, newRecordToUpdate);
            
        this.recordDmlWrapper.addRecordForDML(this.configs.sObjectApiName, newRecord, PORTAL_DMLWrapper.DmlOperation.INSERT_OP);
    }

    
    /**
     * Adds new related record to DML wrapper to insert. Inactivates current record and adds it to DML wrapper to update
     * 
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   newRecordToUpdate                   New Record to add to DML wrapper in the form of a map
     * @param   currentRecordId                     Id of current record to inactivate
     * 
     */
    private void addNewRecordAndInactiveCurrentRecordToDmlWrapper(Map<String, Object> newRecordToUpdate, String currentRecordId) {
        if (newRecordToUpdate == null || newRecordToUpdate.isEmpty() || String.isBlank(currentRecordId)) {
            return;
        }

        SObject activeNewRecord = this.getActivatedSObjectFromRecordMapAndId(newRecordToUpdate, null);
        this.populateControllingParentFieldsForNewRecord(activeNewRecord);
        activeNewRecord = this.setParentForRecord(activeNewRecord, newRecordToUpdate);
        this.recordDmlWrapper.addRecordForDML(this.configs.sObjectApiName, activeNewRecord, PORTAL_DMLWrapper.DmlOperation.INSERT_OP);
        
        SObject inactiveCurrentRecord = this.getInactivatedCurrentRecord(this.currentRecordsMap.get(currentRecordId));
        this.recordDmlWrapper.addRecordForDML(this.configs.sObjectApiName, inactiveCurrentRecord, PORTAL_DMLWrapper.DmlOperation.UPDATE_OP);
    }

    /**
     * Converts the record as a map to an SObject  using staging record fields (staging record field api name on CMT)
     * @author  Phillip Nguyen
     * @since   1.7
     * 
     * @param   eachRecordToUpdateAsMap                 Record that was updated as a map
     * 
     * @return                                          SObject of that record
     * 
     */
    private SObject convertRecordMapToStagingSObject(Map<String, Object> eachRecordToUpdateAsMap) {
        SObject convertedRecord = null;
        Map<String, PORTAL_MyInfoRetriever.FieldConfiguration> fieldConfigurationMap = this.configs.fieldConfigurationMap;

        if (eachRecordToUpdateAsMap == null || eachRecordToUpdateAsMap.isEmpty() || fieldConfigurationMap == null || fieldConfigurationMap.isEmpty()) {
            return convertedRecord;
        }

        convertedRecord = (SObject)System.Type.forName(this.configs.stagingRecordObjectName).newInstance();

        for (String eachField : eachRecordToUpdateAsMap.keySet()) {
            if (fieldConfigurationMap.containsKey(eachField) == false || fieldConfigurationMap.get(eachField).stagingRecordFieldName.contains(CUSTOM_RELATIONSHIP_SUFFIX) || fieldConfigurationMap.get(eachField).stagingRecordFieldName.contains(FORMULA_CONST)) {
                continue;
            }

            Object fieldValue = eachRecordToUpdateAsMap.get(eachField);
            if (fieldConfigurationMap.get(eachField).fieldType == PORTAL_CONST_PageSectionSetting.DATE_FIELD_NAME) {
                fieldValue = String.isNotBlank((String)fieldValue) ? Date.valueOf((String)fieldValue) : null;
            }

            convertedRecord.put(fieldConfigurationMap.get(eachField).stagingRecordFieldName, fieldValue);
        }

        if (String.isNotBlank(this.stagingRecordTypeId)) {
            convertedRecord.put(RECORD_TYPE_ID, this.stagingRecordTypeId);
        }

        return convertedRecord;
    }

    /**
     * method that takes the duplicate logic and evaluates the newest record against an old record to see if the old
     * record can be considered a duplicate of the newest record
     *
     *
     * @author: Ashley Tran (Phillip Nguyen copied and pasted)
     * @since: 1.10
     *
     *
     * @param newRecord:                    The record that we got from the front end
     * @param oldRecord:                    The old record that currently exists in the backend
     *
     * @return:                             The boolean of whether or not the records match
     *
     */
    private Boolean isRecordsMatchUsingDuplicateLogic(Map<String, Object> newRecord, Map<String, Object> oldRecord) {
        List<String> postfixExpressions = new List<String>(this.postFixExpressions);
        if (postfixExpressions.size() <= 1) {
            return isSinglePostfixExpressionMatch(newRecord, oldRecord, postfixExpressions);
        }
        return isRecordsMatchUsingPostfixExpressions(newRecord, oldRecord, postfixExpressions);
    }

    /**
     * If the CMT only wants to compare a single field, then we check if it is a numbered field, and if the field exists
     * It automatically returns false if the single field inside the duplicate field logic is not valid.
     *
     *
     * @author: Phillip Nguyen
     * @since: 1.10
     *
     *
     * @param newRecord:                    The record that we got from the front end
     * @param oldRecord:                    The old record that currently exists in the backend
     * @param postfixExpressions:           Duplicate Logic converted to Postfix
     * @return:                             The boolean of whether or not the records match
     *
     */
    private Boolean isSinglePostfixExpressionMatch(Map<String, Object> newRecord, Map<String, Object> oldRecord, List<String> postfixExpressions) {
        Map<String, String> duplicateLogicMap = this.fieldUpdateConfigs.fieldsForDuplicateLogicMap;

        if (postfixExpressions.size() == 1) {
            if (postfixExpressions.get(0).isNumeric() && duplicateLogicMap.containsKey(postFixExpressions.get(0))) {
                return isFieldOnRecordsMatch(newRecord, oldRecord, duplicateLogicMap.get(postFixExpressions.get(0)));
            }
            return false;
        }
        return false;
    }

    /**
     * If the CMT is configured to compare multiple fields i.e 1 AND 2
     * then we loop through the postfix expressions and begin comparing the fields to determine if the records are matching
     * The stack needs to only contain a single boolean value at the end for the records to match
     *
     * @author: Phillip Nguyen
     * @since: 1.10
     *
     *
     * @param newRecord:                    The record that we got from the front end
     * @param oldRecord:                    The old record that currently exists in the backend
     * @param postfixExpressions:           Duplicate Logic converted to Postfix
     * @return:                             The boolean of whether or not the records match
     *
     */
    private Boolean isRecordsMatchUsingPostfixExpressions(Map<String, Object> newRecord, Map<String, Object> oldRecord, List<String> postfixExpressions) {
        List<Boolean> stack = new List<Boolean>();

        while (postfixExpressions.size() > 0) {
            evaluatePostfixExpressions(newRecord, oldRecord, postfixExpressions, stack);
        }

        return stack.size() == 1 && stack.get(0);
    }

    /**
     * Loop through the postfix expressions and determine if the fields on the records match.
     * This function will mutate postfixExpressions & the stack
     *
     *
     * @author: Phillip Nguyen
     * @since: 1.10
     *
     *
     * @param newRecord:                    The record that we got from the front end
     * @param oldRecord:                    The old record that currently exists in the backend
     * @param postfixExpressions:           Duplicate Logic converted to Postfix
     * @param stack:                        Stack containing values from evaluating the postfix expression
     *
     */
    private void evaluatePostfixExpressions(Map<String, Object> newRecord, Map<String, Object> oldRecord, List<String> postfixExpressions, List<Boolean> stack) {
        Map<String, String> duplicateLogicMap = this.fieldUpdateConfigs.fieldsForDuplicateLogicMap;

        for (Integer postFixIndex = 0; postFixIndex < postfixExpressions.size(); postFixIndex++) {
            String currExpression = postfixExpressions.get(postFixIndex);

            if (currExpression == OR_CONST || currExpression == AND_COST) {
                Integer indexOfFirstOperand = postFixIndex - 1;
                Integer indexOfSecondOperand = postFixIndex - 2;
                Boolean eval1 = false;
                Boolean eval2 = false;

                if (postFixExpressions.get(indexOfFirstOperand).isNumeric()) {
                    eval1 = isFieldOnRecordsMatch(newRecord, oldRecord, duplicateLogicMap.get(postFixExpressions.get(indexOfFirstOperand)));
                }

                if (indexOfSecondOperand >= 0 && postFixExpressions.get(indexOfSecondOperand).isNumeric()) {
                    eval2 = isFieldOnRecordsMatch(newRecord, oldRecord, duplicateLogicMap.get(postFixExpressions.get(indexOfSecondOperand)));
                } else if (!stack.isEmpty()) {
                    eval2 = stack.get(0);
                }

                stack.clear();

                if (currExpression == OR_CONST) {
                    stack.add(eval1 || eval2);
                } else {
                    stack.add(eval1 && eval2);
                }

                postfixExpressions.remove(postFixIndex);
                postfixExpressions.remove(indexOfFirstOperand);

                if (indexOfSecondOperand >= 0) {
                    postfixExpressions.remove(indexOfSecondOperand);
                }
                break;
            }
        }
    }

    /**
     * method that evaluates if the new record's field matches the old record's field
     *
     *
     * @author: Ashley Tran (Phillip copied and pasted)
     * @since: 1.10
     *
     *
     * @param newRecord:               The new record that was updated on the front end
     * @param oldRecord:               The old record we are comparing it to
     * @param field:                   The field name we are evaluating
     *
     * @return:                        Boolean of if the field matches for both records
     *
     */
    public virtual Boolean isFieldOnRecordsMatch(Map<String, Object> newRecord, Map<String, Object> oldRecord, String field) {
        Object newRecordValue =  newRecord?.get(field);
        Object oldRecordValue = oldRecord?.get(field);

        if (newRecordValue == null && oldRecordValue == null) {
            return true;
        }

        if ((newRecordValue != null && String.isNotBlank(String.valueOf(newRecordValue)) && oldRecordValue == null) 
                || newRecordValue == null && oldRecordValue != null && String.isNotBlank(String.valueOf(oldRecordValue))) {
            return false;
        } 
        
        if ((newRecordValue != null && String.isBlank(String.valueOf(newRecordValue)) && oldRecordValue == null) 
                || newRecordValue == null && oldRecordValue != null && String.isBlank(String.valueOf(oldRecordValue))) {
            return true;
        }

        return String.valueOf(newRecordValue) == String.valueOf(oldRecordValue);
    }
}