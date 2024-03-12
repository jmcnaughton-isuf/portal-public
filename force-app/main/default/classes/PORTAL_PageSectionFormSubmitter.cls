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
  * Form Submitter implementation using Portal Page Section Settings.
  *
  * @author     Aaron Wong
  * @version    1.0
  */
public inherited sharing virtual class PORTAL_PageSectionFormSubmitter extends PORTAL_FormSubmitter {
    private static final String OBJECT_API_NAME = 'objectApiName';
    private static final String FIELD_API_NAME = 'fieldApiName';
    private static final String FIELD_MAP = 'fieldMap';
    private static final String VALUE_CONST = 'value';

    private PORTAL_PageSectionAdapter pageSectionAdapter;

    /**
     * Constructor for PORTAL_PageSectionFormSubmitter
     *
     * @author Aaron Wong
     *
     * @param formDataMap           Map of form data.
     * @param pageSectionAdapter    Page Section adapter to use.
     * @since                       1.0
     */
    public PORTAL_PageSectionFormSubmitter(PORTAL_PageSectionAdapter pageSectionAdapter) {
        this.pageSectionAdapter = pageSectionAdapter;
    }

    /**
     * Factory method for PORTAL_DMLWrapper
     *
     * @author Aaron Wong
     *
     * @return  An instance of PORTAL_DMLWrapper;
     * @since   1.0
     */
    public virtual PORTAL_DmlWrapper createDmlWrapper() {
        return new PORTAL_DMLWrapper();
    }

    /**
     * Submits the form data.
     *
     * @author  Aaron Wong
     *
     * @param formDataMap       Form data to submit.
     * @return                  True if submitted appropriately.
     * @since                   1.0
     */
    public virtual override Boolean submit(Map<String, List<PORTAL_FormRecordWrapper>> formDataMap) {
        if (formDataMap == null || formDataMap.isEmpty() || pageSectionAdapter == null) {
            return false;
        }

        Map<String, Object> backEndDataMap = pageSectionAdapter.getBackEndDataMap();

        PORTAL_DmlWrapper dmlWrapper = this.getPopulatedDmlWrapper(formDataMap, backEndDataMap);

        dmlWrapper.performDmlOperations();

        return true;
    }

    /**
     * Gets a populated DML wrapper saying what DML operations to perform.
     *
     * @author Aaron Wong
     *
     * @param formDataMap       Form data to submit.
     * @param backEndDataMap    Backend data map from PORTAL_PageSectionAdapter.
     * @return                  A populated instance of PORTAL_DMLWrapper.
     * @since                   1.0
     */
    private PORTAL_DMLWrapper getPopulatedDmlWrapper(Map<String, List<PORTAL_FormRecordWrapper>> formDataMap, Map<String, Object> backEndDataMap) {
        PORTAL_DmlWrapper resultWrapper = this.createDmlWrapper();

        for (String eachSectionId : formDataMap.keySet()) {
            if (!backEndDataMap.containsKey(eachSectionId) || formDataMap.get(eachSectionId).isEmpty()) {
                continue;
            }

            Map<String, Object> sectionData = (Map<String, Object>)backEndDataMap.get(eachSectionId);

            List<SObject> upsertList = getSObjectListToUpsertFromRecordList(sectionData, formDataMap.get(eachSectionId));
            List<SObject> deleteList = getSObjectListToDeleteFromRecordList(sectionData, formDataMap.get(eachSectionId));

            String objectApiName = (String)sectionData?.get(OBJECT_API_NAME);

            resultWrapper.addRecordListForDML(objectApiName, upsertList, PORTAL_DMLWrapper.DmlOperation.UPSERT_OP);
            resultWrapper.addRecordListForDML(objectApiName, deleteList, PORTAL_DMLWrapper.DmlOperation.DELETE_OP);
        }

        return resultWrapper;
    }

    /**
     * Gets a list of SObjects to upsert.
     *
     * @author Aaron Wong
     *
     * @param sectionData       Section data from PORTAL_UTIL_PageSectionSettings.
     * @param recordList        List of PORTAL_FormRecordWrapper that each correspond to a record.
     * @return                  List of SObjects to upsert.
     * @since                   1.0
     */
    private List<SObject> getSObjectListToUpsertFromRecordList(Map<String, Object> sectionData,
                                                               List<PORTAL_FormRecordWrapper> recordList) {
        List<SObject> resultList = new List<SObject>();
        String objectApiName = (String)sectionData?.get(OBJECT_API_NAME);
        Map<String, Object> fieldIdToDataMap = (Map<String, Object>)sectionData?.get(FIELD_MAP);

        if (sectionData == null || String.isBlank(objectApiName)
                || fieldIdToDataMap == null || fieldIdToDataMap.isEmpty()) {
            return resultList;
        }

        for (PORTAL_FormRecordWrapper eachRecord : recordList) {
            if (eachRecord.isDeleted == true) {
                continue;
            }

            SObject eachSObjectRecord = convertFormRecordWrapperToSObject(eachRecord, fieldIdToDataMap, objectApiName);

            resultList.add(eachSObjectRecord);
        }

        return resultList;
    }

    /**
     * Gets a list of SObjects to delete.
     *
     * @author Aaron Wong
     *
     * @param sectionData       Section data from PORTAL_UTIL_PageSectionSettings.
     * @param recordList        List of PORTAL_FormRecordWrapper that each correspond to a record.
     * @return                  List of SObjects to delete.
     * @since                   1.0
     */
    private List<SObject> getSObjectListToDeleteFromRecordList(Map<String, Object> sectionData,
                                                               List<PORTAL_FormRecordWrapper> recordList) {
        List<SObject> resultList = new List<SObject>();
        String objectApiName = (String)sectionData?.get(OBJECT_API_NAME);
        Map<String, Object> fieldIdToData = (Map<String, Object>)sectionData?.get(FIELD_MAP);

        if (sectionData == null || String.isBlank(objectApiName)
                || fieldIdToData == null || fieldIdToData.isEmpty()) {
            return resultList;
        }

        for (PORTAL_FormRecordWrapper eachRecord : recordList) {
            if (eachRecord.isDeleted != true) {
                continue;
            }

            SObject eachSObjectRecord = convertFormRecordWrapperToSObject(eachRecord, fieldIdToData, objectApiName);

            if (eachSObjectRecord == null || String.isBlank(eachSObjectRecord.Id)) {
                continue;
            }

            resultList.add(eachSObjectRecord);
        }

        return resultList;
    }

    /**
     * Converts a PORTAL_FormRecordWrapper to an SObject.
     *
     * @author Aaron Wong
     *
     * @param formDataWrapper       Form Data wrapper to convert.
     * @param fieldIdToDataMap      Map of field Id to field data.
     * @param objectApiName         API Name of the object to convert the PORTAL_FormRecordWrapper to.
     * @return                      Converted SObject.
     * @since                       1.0
     */
    private static SObject convertFormRecordWrapperToSObject(PORTAL_FormRecordWrapper formDataWrapper,
                                                             Map<String, Object> fieldIdToDataMap,
                                                             String objectApiName) {
        if (formDataWrapper == null || fieldIdToDataMap == null || fieldIdToDataMap.isEmpty() || String.isBlank(objectApiName)) {
            return null;
        }

        PORTAL_SObjectWrapper sObjectWrapper = PORTAL_SObjectWrapper.newInstance(objectApiName);

        for (String eachFieldId : formDataWrapper.formData.keySet()) {
            Map<String, Object> eachFieldMetadata = (Map<String, Object>)fieldIdToDataMap.get(eachFieldId);

            if (eachFieldMetadata == null || String.isBlank((String)eachFieldMetadata.get(FIELD_API_NAME))) {
                continue;
            }

            String fieldApiName = (String)eachFieldMetadata.get(FIELD_API_NAME);
            Object fieldValue = formDataWrapper.formData.get(eachFieldId);

            sObjectWrapper.put(fieldApiName, fieldValue);
        }

        return sObjectWrapper.getSObjectRecord();
    }
}