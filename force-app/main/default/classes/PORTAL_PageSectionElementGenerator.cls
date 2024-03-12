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
 * Generates front end element information using the Portal Page Section Setting custom metadata structure.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing class PORTAL_PageSectionElementGenerator implements PORTAL_FormGenerator {
    private static String LABEL_CONST = 'label';
    private static String SECTION_ID = 'sectionId';
    private static String DISPLAY_CONST = 'display';
    private static String FIELD_MAP = 'fieldMap';
    private static String FIELD_ID = 'fieldId';
    private static String FIELD_TYPE = 'fieldType';
    private static String IS_LOOKUP = 'isLookup';
    private static String PICKLIST_CONST = 'picklist';
    private static String TEXT_CONST = 'text';
    private static String LOOKUP_CONST = 'lookup';
    private static String TOOLTIP_TEXT = 'tooltipText';
    private static String FIELD_DESCRIPTION = 'fieldDescription';
    private static String IS_REQUIRED = 'isRequired';
    private static String DISABLE_CONST = 'disable';
    private static String IS_PICKLIST = 'isPicklist';
    private static String IS_SECTION = 'isSection';
    private static String SUB_SECTION_NAME = 'subSectionName';
    private static String MAIN_SECTION_NAME = 'mainSectionName';
    private static String RECORDS_CONST = 'records';
    private static String ORDER_NUMBER = 'orderNumber';
    private static String PICKLIST_OBJECT_API_NAME = 'lookupObjectApiName';
    private static String PICKLIST_FIELD_NAME = 'lookupFieldName';
    private static String PICKLIST_FILTER_CLAUSE = 'lookupFilterClauseName';
    private static String STATIC_AVAILABLE_VALUES = 'staticAvailableValues';
    private static String VALUE_CONST = 'value';
    private static String DEFAULT_PICKLIST_LABEL = 'Please select a value';

    private PORTAL_PageSectionAdapter pageSectionAdapter;

    /**
     * Constructor for the class
     *
     * @author Aaron Wong
     *
     * @param pageSectionAdapter    Page section adapter configured to the appropriate custom metadata records.
     * @since                       1.0
     */
    public PORTAL_PageSectionElementGenerator(PORTAL_PageSectionAdapter pageSectionAdapter) {
        this.pageSectionAdapter = pageSectionAdapter;
    }

    // Factory Methods

    /**
     * Factory method for PORTAL_FormWrapper.
     *
     * @author Aaron Wong
     *
     * @return  A new PORTAL_FormWrapper object.
     * @since   1.0
     */
    public virtual PORTAL_FormWrapper createFormWrapper() {
        return new PORTAL_FormWrapper();
    }

    /**
     * Factory method for PORTAL_FormRowWrapper.
     *
     * @author Aaron Wong
     *
     * @param formFieldList         List of form fields to pass into the constructor.
     * @return                      A new PORTAL_FormWrapper object.
     * @since                       1.0
     */
    public virtual PORTAL_FormRowWrapper createFormRowWrapper(List<PORTAL_FormFieldWrapper> formFieldList) {
        return new PORTAL_FormRowWrapper(formFieldList);
    }

    /**
     * Factory method for PORTAL_FormFieldWrapper
     *
     * @author Aaron Wong
     *
     * @return  A new PORTAL_FormFieldWrapper object.
     * @since   1.0
     */
    public virtual PORTAL_FormFieldWrapper createFormFieldWrapper() {
        return new PORTAL_FormFieldWrapper();
    }

    /**
     * Generates form data based on Portal Page Section Settings. Each Portal Page Section Setting record is treated
     * a PORTAL_FormWrapper object, and each Portal Section Field Setting record is treated as a
     * PORTAL_FormFieldWrapper object.
     *
     * @author Aaron Wong
     *
     * @return  Form data to be passed to an LWC.
     * @since   1.0
     */
    public virtual PORTAL_FormWrapper generateForm() {
        PORTAL_FormWrapper formWrapper = this.createFormWrapper();

        if (this.pageSectionAdapter == null) {
            return formWrapper;
        }

        Map<String, Object> frontEndDataMap = this.pageSectionAdapter.getFrontEndDataMap();

        if (frontEndDataMap == null || frontEndDataMap.isEmpty())  {
            return formWrapper;
        }

        Map<String, PORTAL_FormWrapper> mainSectionNameToFormWrapperMap = this.createFormWrapperHierarchies(frontEndDataMap);

        List<PORTAL_FormWrapper> mainSectionFormWrapperList = mainSectionNameToFormWrapperMap.values();

        if (mainSectionFormWrapperList.size() > 1) {
            formWrapper.formId = pageSectionAdapter.getPageName();
            formWrapper.isDisplay = true;
            formWrapper.subSectionList = mainSectionFormWrapperList;
        } else if (mainSectionFormWrapperList.size() == 1) {
            formWrapper = mainSectionFormWrapperList.get(0);
            if (formWrapper.subSectionList != null && !formWrapper.subSectionList.isEmpty()) {
                formWrapper.isDisplay = true;
            }
        } else {
            return formWrapper;
        }

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = this.pageSectionAdapter.getRecords();

        if (recordsMap == null || recordsMap.isEmpty()) {
            return formWrapper;
        }

        // Populate form with input values
        for (String eachMainSectionName : recordsMap.keySet()) {
            PORTAL_FormWrapper mainSectionForm = mainSectionNameToFormWrapperMap.get(eachMainSectionName);
            // Has no sub-sections
            if (recordsMap.get(eachMainSectionName).containsKey(RECORDS_CONST)) {
                this.populateFormValues(mainSectionForm, recordsMap.get(eachMainSectionName).get(RECORDS_CONST));
                continue;
            }

            // Has sub-sections
            Map<String, List<Map<String, Object>>> subSectionNameToRecordsList = recordsMap.get(eachMainSectionName);

            for (PORTAL_FormWrapper eachSubSection : mainSectionForm.subSectionList) {
                Map<String, Object> sectionData = (Map<String, Object>)frontEndDataMap.get(eachSubSection.formId);

                String subSectionName = (String)sectionData.get(SUB_SECTION_NAME);

                if (String.isBlank(subSectionName) || subSectionNameToRecordsList.get(subSectionName) == null
                        || subSectionNameToRecordsList.get(subSectionName).isEmpty()) {
                    continue;
                }

                this.populateFormValues(eachSubSection, subSectionNameToRecordsList.get(subSectionName));
            }
        }

        return formWrapper;
    }

    /**
     * Creates a hierarchy of PORTAL_FormWrappers.
     *
     * @author Aaron Wong
     *
     * @return  A map of main section name to the appropriate form data.
     * @since   1.0
     */
    private Map<String, PORTAL_FormWrapper> createFormWrapperHierarchies(Map<String, Object> frontEndDataMap) {
        Map<String, PORTAL_FormWrapper> resultMap = new Map<String, PORTAL_FormWrapper>();      // main section name to form wrapper

        if (frontEndDataMap == null || frontEndDataMap.isEmpty()) {
            return resultMap;
        }

        for (String eachSectionId : frontEndDataMap.keySet()) {
            Map<String, Object> sectionData = (Map<String, Object>)frontEndDataMap.get(eachSectionId);

            if ((Boolean)sectionData.get(IS_SECTION) != true) {
                continue;
            }

            PORTAL_FormWrapper eachSectionWrapper = createFormWrapperFromSection(sectionData);
            String eachMainSectionName = (String)sectionData.get(MAIN_SECTION_NAME);
            String eachSubSectionName = (String)sectionData.get(SUB_SECTION_NAME);

            if (String.isNotBlank(eachSubSectionName)) {    // Sub section form
                PORTAL_FormWrapper mainSectionWrapper = this.createFormWrapper();
                mainSectionWrapper.formId = eachMainSectionName;

                if (resultMap.containsKey(eachMainSectionName)) {
                    mainSectionWrapper = resultMap.get(eachMainSectionName);
                }

                if (mainSectionWrapper.subSectionList == null) {
                    mainSectionWrapper.subSectionList = new List<PORTAL_FormWrapper>();
                }

                mainSectionWrapper.subSectionList.add(eachSectionWrapper);
                resultMap.put(eachMainSectionName, mainSectionWrapper);
            } else {    // Main section form
                if (resultMap.containsKey(eachMainSectionName)) {
                    eachSectionWrapper.subSectionList = resultMap.get(eachMainSectionName).subSectionList;
                }

                resultMap.put(eachMainSectionName, eachSectionWrapper);
            }
        }

        return resultMap;
    }

    /**
     * Creates an instance of PORTAL_FormWrapper based on the section data provided.
     *
     * @author Aaron Wong
     *
     * @param sectionData   Section data created through PORTAL_UTIL_PageSectionSettings.
     * @return              An instance of PORTAL_FormWrapper.
     * @since               1.0
     */
    private PORTAL_FormWrapper createFormWrapperFromSection(Map<String, Object> sectionData) {
        PORTAL_FormWrapper resultForm = this.createFormWrapper();

        resultForm.heading = (String)sectionData.get(LABEL_CONST);
        resultForm.formId = (String)sectionData.get(SECTION_ID);
        resultForm.isDisplay = (Boolean)sectionData.get(DISPLAY_CONST);

        if (String.isBlank(resultForm.formId)) {
            resultForm.formId = (String)sectionData.get(MAIN_SECTION_NAME);
        }

        Map<String, Object> fieldMap = (Map<String, Object>)sectionData.get(FIELD_MAP);
        resultForm.formRowList = new List<PORTAL_FormRowWrapper>();

        if (fieldMap == null || fieldMap.isEmpty()) {
            return resultForm;
        }

        List<PORTAL_FormFieldWrapper> fieldWrapperList = new List<PORTAL_FormFieldWrapper>();
        for (String eachFieldId : fieldMap.keySet()) {
            PORTAL_FormFieldWrapper eachFieldWrapper = createFormFieldWrapperFromFieldData((Map<String, Object>)fieldMap.get(eachFieldId));

            fieldWrapperList.add(eachFieldWrapper);
        }

        fieldWrapperList.sort();

        PORTAL_FormRowWrapper formRowWrapper = this.createFormRowWrapper(fieldWrapperList);

        resultForm.formRowList.add(formRowWrapper);

        return resultForm;
    }

    /**
     * Creates an instance of PORTAL_FormFieldWrapper using the field data provided.
     *
     * @author Aaron Wong
     *
     * @param fieldData     Field data created through PORTAL_UTIL_PageSectionSettings.
     * @return              An instance of PORTAL_FormFieldWrapper.
     * @since               1.0
     */
    private PORTAL_FormFieldWrapper createFormFieldWrapperFromFieldData(Map<String, Object> fieldData) {
        PORTAL_FormFieldWrapper resultFormField = this.createFormFieldWrapper();

        if (fieldData == null || fieldData.isEmpty()) {
            return resultFormField;
        }

        resultFormField.fieldId = (String)fieldData.get(FIELD_ID);
        String fieldType = (String)fieldData.get(FIELD_TYPE);

        if ((Boolean)fieldData.get(IS_LOOKUP) == true && fieldType == TEXT_CONST) {
            fieldType = LOOKUP_CONST;
        }

        resultFormField.fieldType = fieldType;
        resultFormField.label = (String)fieldData.get(LABEL_CONST);
        resultFormField.tooltipText = (String)fieldData.get(TOOLTIP_TEXT);
        resultFormField.fieldDescription = (String)fieldData.get(FIELD_DESCRIPTION);
        resultFormField.isRequired = (Boolean)fieldData.get(IS_REQUIRED);
        resultFormField.isDisabled = (Boolean)fieldData.get(DISABLE_CONST);
        resultFormField.isDisplay = (Boolean)fieldData.get(DISPLAY_CONST);
        resultFormField.orderNumber = (Decimal)fieldData.get(ORDER_NUMBER);
        resultFormField.lookupSettingList = new List<Map<String, Object>>{new Map<String, Object>{
            PORTAL_LookupControllerBase.CUSTOM_METADATA_DEVELOPER_NAME => fieldData.get(PORTAL_LookupControllerBase.CUSTOM_METADATA_DEVELOPER_NAME)
        }};

        if (resultFormField.fieldType == PICKLIST_CONST || resultFormField.fieldType == LOOKUP_CONST) {
            resultFormField.picklistValues = this.getPicklistValues(resultFormField.fieldId);
        }

        return resultFormField;
    }

    /**
     * Populates the given form wrapper with form values based on the records provided.
     *
     * @author Aaron Wong
     *
     * @param formWrapper           Form data to populate.
     * @param recordWrapperList     List of record wrappers to use for form population.
     * @since                       1.0
     */
    public virtual void populateFormValues(PORTAL_FormWrapper formWrapper, List<Map<String, Object>> recordWrapperList) {
        if (formWrapper == null || formWrapper.formRowList == null
                || formWrapper.formRowList.isEmpty() || formWrapper.formRowList.get(0).formFieldList == null
                || recordWrapperList == null || recordWrapperList.isEmpty()) {
            return;
        }

        List<PORTAL_FormFieldWrapper> formFieldListReference = formWrapper.formRowList.get(0).formFieldList;

        List<PORTAL_FormRowWrapper> formRowWrapperList = new List<PORTAL_FormRowWrapper>();

        for (Map<String, Object> eachRecordWrapper : recordWrapperList) {
            List<PORTAL_FormFieldWrapper> eachFormFieldList = new List<PORTAL_FormFieldWrapper>();

            for (PORTAL_FormFieldWrapper eachFormFieldReference : formFieldListReference) {
                PORTAL_FormFieldWrapper eachNewFormField = this.getPopulatedFormFieldWrapper(eachFormFieldReference, eachRecordWrapper);

                eachFormFieldList.add(eachNewFormField);
            }

            PORTAL_FormRowWrapper eachFormRowWrapper = this.createFormRowWrapper(eachFormFieldList);
            formRowWrapperList.add(eachFormRowWrapper);
        }

        formWrapper.formRowList = formRowWrapperList;
    }

    /**
     * Gets picklist values for the field Id provided.
     *
     * @author Aaron Wong
     *
     * @param fieldId   The Section Field Setting's field Id.
     * @return          List of picklist values.
     * @since           1.0
     */
    private List<Map<String, String>> getPicklistValues(String fieldId) {
        List<Map<String, String>> resultList = new List<Map<String, String>>();

        Map<String, Object> backEndDataMap = this.pageSectionAdapter?.getBackEndDataMap();

        if (String.isBlank(fieldId) || backEndDataMap == null || !backEndDataMap.containsKey(fieldId)) {
            return resultList;
        }

        Map<String, Object> fieldDataMap = (Map<String, Object>)backEndDataMap.get(fieldId);

        String staticAvailableValues = (String)fieldDataMap.get(STATIC_AVAILABLE_VALUES);
        String objectApiName = (String)fieldDataMap.get(PICKLIST_OBJECT_API_NAME);
        String fieldAPIName = (String)fieldDataMap.get(PICKLIST_FIELD_NAME);
        String whereClause = (String)fieldDataMap.get(PICKLIST_FILTER_CLAUSE);

        if (String.isNotBlank(staticAvailableValues)) {
            resultList = convertStringToPicklistValues((String)fieldDataMap.get(STATIC_AVAILABLE_VALUES));
        } else if (String.isNotBlank(objectApiName) && String.isNotBlank(fieldAPIName)) {
            resultList = queryPicklistValues(objectApiName, fieldApiName, whereClause);
        }

        return resultList;
    }

    /**
     * Converts a string of picklist values to a list.
     *
     * @author Aaron Wong
     *
     * @param picklistValueString   String of picklist values.
     * @return                      List of picklist values.
     * @since                       1.0
     */
    @testVisible
    private List<Map<String, String>> convertStringToPicklistValues(String picklistValueString) {
        List<Map<String, String>> resultList = new List<Map<String, String>>();

        if (String.isBlank(picklistValueString)) {
            return resultList;
        }

        String newLineOperator = '\n';

        if (picklistValueString.contains('\r\n')) {
            newLineOperator = '\r\n';
        }

        // picklist pairs look either like value or label;value
        List<String> picklistPairList = picklistValueString.split(newLineOperator);
        for (String eachEntry : picklistPairList) {
            //split the entries by label value pairs
            Map<String, String> fieldValuePair = new Map<String, String>();

            List<String> fieldValueList = eachEntry.split(';');

            if (fieldValueList.isEmpty()) {
                continue;
            } else if (fieldValueList.size() == 1) {
                fieldValuePair.put(LABEL_CONST, fieldValueList.get(0));
                fieldValuePair.put(VALUE_CONST, fieldValueList.get(0));
            } else {
                fieldValuePair.put(LABEL_CONST, fieldValueList.get(0));
                fieldValuePair.put(VALUE_CONST, fieldValueList.get(1));
            }

            resultList.add(fieldValuePair);
        }

        return resultList;
    }

    /**
     * Queries for a list of picklist values with the given parameters.
     * Picklist pairs will be fieldApiName as the label and Id as the value for each record.
     *
     * @author Aaron Wong
     *
     * @param objectApiName     The object api name to query.
     * @param fieldApiName      The field api name to query.
     * @param whereClause       The where cluase to use to query.
     * @return                  List of picklist values.
     * @since                   1.0
     */
    @testVisible
    private List<Map<String, String>> queryPicklistValues(String objectApiName,
                                                          String fieldApiName,
                                                          String whereClause) {
        List<Map<String, String>> resultList = new List<Map<String, String>>{new Map<String, String>{LABEL_CONST => DEFAULT_PICKLIST_LABEL, VALUE_CONST => ''}};

        if (String.isBlank(objectApiName) || String.isBlank(fieldApiName)) {
            return resultList;
        }

        String queryString = 'SELECT Id, ' + fieldApiName + ' FROM ' + objectApiName;

        if (String.isNotBlank(whereClause)) {
            queryString = queryString + ' WHERE ' + whereClause;
        }

        List<SObject> sObjectList = Database.query(queryString);

        for (SObject eachRecord : sObjectList) {
            String eachLabel = String.valueOf(eachRecord.get(fieldApiName));

            if (String.isBlank(eachLabel)) {
                continue;
            }

            Map<String, String> fieldValuePair = new Map<String, String>{
                LABEL_CONST => eachLabel,
                VALUE_CONST => eachRecord.Id
            };

            resultList.add(fieldValuePair);
        }

        return resultList;
    }

    /**
     * Gets a populated form field wrapper.
     *
     * @author Aaron Wong
     *
     * @param referenceWrapper      Reference form field wrapper to populate.
     * @param recordWrapper         Record wrapper that contains the value to populate.
     * @return                      Populated form field wrapper.
     * @since                       1.0
     */
    private PORTAL_FormFieldWrapper getPopulatedFormFieldWrapper(PORTAL_FormFieldWrapper referenceWrapper,
                                                                 Map<String, Object> recordWrapper) {
        PORTAL_FormFieldWrapper resultFormField = referenceWrapper.clone();

        resultFormField.value = recordWrapper.get(referenceWrapper.fieldId);

        if (resultFormField.value == null) {
            resultFormField.value = '';
        }

        if (resultFormField.fieldType == LOOKUP_CONST) {
            resultFormField.value = this.getValueFromPicklist(resultFormField.picklistValues, (String)resultFormField.value);
        }

        return resultFormField;
    }

    /**
     * Gets a value from a list of picklist values
     *
     * @author Aaron Wong
     *
     * @param picklistValueList     List of picklist values.
     * @param value                 Value of the picklist pair to get.
     * @return                      The picklist pair with the value.
     * @since                       1.0
     */
    private Object getValueFromPicklist(List<Map<String, String>> picklistValueList, String value) {
        if (picklistValueList == null || picklistValueList.isEmpty() || String.isBlank(value)) {
            return value;
        }

        for (Map<String, String> picklistValue : picklistValueList) {
            if (picklistValue.get(VALUE_CONST) == value) {
                return picklistValue;
            }
        }

        return value;
    }
}