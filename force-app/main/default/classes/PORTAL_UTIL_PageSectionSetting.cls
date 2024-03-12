/*
* Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
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
* Handles methods related to the Portal_Page_Section_Setting__mdt that
* allows for dynamic querying of records
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/

global inherited sharing class PORTAL_UTIL_PageSectionSetting {

    //DO NOT CHANGE THESE UNLESS YOU ARE ALSO CHANGING ON THE FRONT END AND IN CODE THAT CALLS THIS UTIL CLASS
    global static final String MAIN_QUERY_KEY = 'mainQuery';
    global static final String FIELD_CLAUSE = 'fieldClause';
    global static final String FROM_CLAUSE = 'fromClause';
    global static final String WHERE_CLAUSE = 'whereClause';
    global static final String GROUP_BY_CLAUSE = 'groupByClause';
    global static final String ORDER_BY_CLAUSE = 'orderByClause';
    global static final String LIMIT_CLAUSE = 'limitClause';
    global static final String OFFSET_CLAUSE = 'offsetClause';
    global static final String FIELD_SET = 'fieldSet';
    global static final String SOBJECT_NAME = 'sobjectName';
    global static final String CONTROLLING_PARENT_FIELD_NAME = 'controllingParentFieldName';
    global static final String FILTER_CLAUSE = 'filterClause';
    global static final String MAX_ITEMS = 'maxItems';

    // class key names for returning
    global static final String QUERY_STRING_KEY = 'query';
    global static final String PERMISSION_MAP_KEY = 'permissionMap';
    global static final String SECTION_MAP_KEY = 'sectionMap';

    global static final String MAX_NUMBER_OF_QUERY_RECORDS = 'maxNumberOfQueryRecords';

    global class PortalPageSectionException extends Exception {}

    /**
     * class that allows developer to create custom queries instead of relying on the 
     * metadata. DEVELOPER MUST BE PREPARED TO TEST ALL CHANGES SINCE IT CAN CREATE
     * A CONFLICT WITH THE CUSTOMER'S METADATA AND CUSTOMER MUST BE AWARE THAT ANY CHANGES
     * TO CUSTOM METADATA THAT HAS THIS CLASS OVERRIDE CAN ALSO CAUSE THE PAGE TO BREAK
     */
    global class DynamicQueryClass {
        global String dynamicSelectClause; // comma seperated list of fields
        global String dynamicWhereClause;
        global String dynamicOrderByClause;
        global String dynamicGroupByClause;
        global Integer maxItems;
        global Integer offset;
        global Boolean overrideMetadata;
        global Boolean overrideWhereClause; // will be the same as overrideMetadata unless explicitly set. Used to have the where clause independantly overwritten
        global Boolean overrideGroupByClause;

        global DynamicQueryClass() {
            this.overrideMetadata = false;
            this.overrideWhereClause = false;
            this.overrideGroupByClause = false;
        }

        global DynamicQueryClass(String dynamicFieldsClause, String whereClause, String orderByClause, String groupByClause, Integer maxItems, Integer offset, Boolean overrideMetadata) {
            this.dynamicSelectClause = dynamicFieldsClause;
            this.dynamicWhereClause = whereClause;
            this.dynamicOrderByClause = orderByClause;
            this.dynamicGroupByClause = groupByClause;
            this.maxItems = maxItems;
            this.offset = offset;
            this.overrideMetadata = overrideMetadata;
            this.overrideWhereClause = overrideMetadata;
        }
    }

     /** 
     * method that retrieves a list of page section setting custom metadata records based
     * on page name
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param pageName:       The page name that we want to filter the custom metadata records by
     * 
     * 
     * @return                List of custom metadata records
     */


    global static List<Portal_Page_Section_Setting__mdt> getPageSectionSettingRecords(String pageName, String mainSection, String subSection) {

        if (String.isBlank(pageName)) {
            return new List<Portal_Page_Section_Setting__mdt>();
        }

        String queryString = 'SELECT Label, DeveloperName, SObject_API_Name__c, Staging_Record_Type_Developer_Name__c, Record_Type_Developer_Name__c, Staging_Record_Controlling_Parent_Field__c, Controlling_Parent_Field_API_Name__c, Page_Main_Section__c, Page_Sub_Section__c, Section_Description__c, Original_Record_Field_API_Name__c, ' + 
                             'Is_Display_Section__c, Is_Disabled__c, Is_Display_Toggle_On_Section__c, Is_Display_Toggle_Per_Record__c,' +
                             'Where_Clause__c, Order_By_Clause__c, Is_Create_Staging_Record_Upon_Edit__c, Is_Create_Staging_Record_Upon_Creation__c,'  +
                             'Is_Create_Staging_Record_Using_Fields__c, Create_Staging_Record_Condition_Field__c, Create_Staging_Record_Condition_Value__c,'  +
                             'Create_Staging_Record_Condition_Operator__c, Staging_sObject_API_Name__c,Has_Duplicate_Logic__c,Has_Report_Update_Link__c,'  +
                             'Duplicate_Field_Logic__c,Inactive_Record_Field_Map__c, Active_Record_Field_Map__c, Is_Hard_Delete_Records__c,'  +
                             'Staging_Record_Where_Clause__c, Page_Name__c,Max_Number_of_Query_Records__c,Front_End_Section_Id__c, SObject_Relationship_API_Name__c,'  +
                             'Controlling_Parent_Object__c, Staging_Record_Controlling_Parent_Object__c, ' + 
                             'Front_End_Section_Label__c, Is_Child__c, Group_By_Clause__c, Relationship_Wrapper_Id__c, Listing_Configurations__c, (SELECT Id, DeveloperName, Field_API_Name__c, Field_Type__c,Is_Display_On_Portal__c,'  +
                             'Is_Disabled__c,Has_Toggle__c,Filter_Value__c,Filter_Field__c,Filter_Operator__c, Front_End_Field_Label__c, Create_Staging_Record_Condition_Value__c, Create_Staging_Record_Condition_Operator__c,'  +
                             'Field_Order_For_Duplicate_Logic__c,Is_Create_New_Record__c,Is_Create_Staging_Record_On_Field_Change__c,'  +
                             'Staging_Record_Field_API_Name__c,Static_Value_For_Staging_Field__c,Staging_Field_Population_Condition_Value__c,'  +
                             'Front_End_Field_Id__c,Front_End_Field_Only__c,Lookup_SObject_Name__c,Lookup_Filter_Clause__c,Lookup_Field_Name__c, Static_Available_Values__c, '  +
                             'Has_Report_Update_Link__c, Tooltip_Text__c, Field_Description__c, Order_Number__c, Is_Required__c FROM Portal_Section_Field_Settings__r) FROM Portal_Page_Section_Setting__mdt'  +
                             ' WHERE Page_Name__c = \'' + pageName + '\' ';
        if (String.isNotBlank(mainSection)) {
            queryString = queryString + ' AND Page_Main_Section__c = \'' + mainSection + '\'';
        }

        if (String.isNotBlank(subSection)) {
            queryString = queryString + ' AND Page_Sub_Section__c = \'' + subSection + '\'';
        }
        
        return (List<Portal_Page_Section_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.QUERY_STRING => queryString
        });
    }


    /** 
     * method that groups a list of custom metadata records based on portal page
     * sections and sobject relcationships
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param sectionSettingList:       The list of custom metadata records that share the page name that we are trying to separate
     * 
     * 
     * @return                          Map of the custom metadata records that are separated into the page's main and sub sections {sectionName => {mainQuery => [records], relationshipName => [records], ....}}
     */
    

    global static Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> generatePageSectionSettingMap(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> returnMap = new Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>>();

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            //if main section is blank, the custom metadata record is considered bad data
            if (String.isNotBlank(sectionSetting.Page_Main_Section__c)) {
                //the first key will be the subsection if it exists, which will separate the records that are grouped by the sub section
                if (String.isNotBlank(sectionSetting.Page_Sub_Section__c)) {
                   
                    addSectionToMap(sectionSetting.Page_Sub_Section__c, sectionSetting, returnMap);

                } else {
                    //the first key will be the main section if it exists, which will separate the records that are grouped by the main section
                    addSectionToMap(sectionSetting.Page_Main_Section__c, sectionSetting, returnMap);
                }
            }
        }

        return returnMap;
    }

     /** 
     * method that checks a custom metadata record to separate it into different lists based
     * on the section it needs to go under in the map it is being added to
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param sectionName:       The name of the section that we are adding this record to (can be the main or sub section name)
     * @param sectionSetting:    The custom metadata record that we are trying to sort
     * @param mapToUpdate:       The data structure that is separating and sorting all of our custom metadata records
     * 
     *
     */

    private static void addSectionToMap(String sectionName, Portal_Page_Section_Setting__mdt sectionSetting, Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> mapToUpdate) {
        if (mapToUpdate.containsKey(sectionName)) {
            //separate by the relationship name if it exists, if it does not then add the section setting to the mainQuery list, which will be the keys of the second map
            if (sectionSetting.Is_Child__c && String.isNotBlank(sectionSetting.SObject_Relationship_API_Name__c)) {
                if(mapToUpdate.get(sectionName).containsKey(sectionSetting.SObject_Relationship_API_Name__c)) {
                    mapToUpdate.get(sectionName).get(sectionSetting.SObject_Relationship_API_Name__c).add(sectionSetting);
                } else {
                    mapToUpdate.get(sectionName).put(sectionSetting.SObject_Relationship_API_Name__c, new List<Portal_Page_Section_Setting__mdt>{sectionSetting});
                }
            } else {
                if (mapToUpdate.get(sectionName).containsKey(MAIN_QUERY_KEY)) {
                    mapToUpdate.get(sectionName).get(MAIN_QUERY_KEY).add(sectionSetting);
                } else {
                    mapToUpdate.get(sectionName).put(MAIN_QUERY_KEY, new List<Portal_Page_Section_Setting__Mdt>{sectionSetting});
                }
                
            }

        } else {
            if (sectionSetting.Is_Child__c && String.isNotBlank(sectionSetting.SObject_Relationship_API_Name__c)) {
                mapToUpdate.put(sectionName, new Map<String, List<Portal_Page_Section_Setting__mdt>>{sectionSetting.SObject_Relationship_API_Name__c => new List<Portal_Page_Section_Setting__mdt>{sectionSetting}});
            } else {
                mapToUpdate.put(sectionName, new Map<String, List<Portal_Page_Section_Setting__mdt>>{MAIN_QUERY_KEY => new List<Portal_Page_Section_Setting__mdt>{sectionSetting}});
            }

        }
    }


    /** 
     * method that queries for records using a query that is dynamically genereated from custom metadata records
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param parentFieldId:                            The id that is used to filter the query through the lookup field to prevent user from querying for more information than they have access to (nullable)
     * @param pageSectionMap:                           Map that contains the custom metadata records needed to query for the records
     * @param sectionNameToDynamicOverrideClassMap:     Map of section name to the a developer defined dynamic query class if the developer wants to override the query
     * @param queryForAllRecords:                       The boolean parameter which tells us if we want to query for all records
     * @param generateWrapper:                          The boolean parameter which tells us that the records need to be wrapped as a map instead of returning it as an sobject
     * 
     * 
     * @return                                          Map of the records that are separated into the page's main and sub sections {mainSectionName => {PORTAL_CONST_PageSectionSetting.RECORD_KEY || subSectionName => [records]}}
     */
    global static Map<String, Map<String, List<Map<String, Object>>>> queryForRecords(Id parentFieldId, 
                                                                                      Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap, 
                                                                                      Map<String, DynamicQueryClass> sectionNameToDynamicOverrideClassMap,
                                                                                      Boolean queryForAllRecords, 
                                                                                      Boolean generateWrapper) {
        Map<String, Map<String, List<Map<String, Object>>>> returnMap = new Map<String, Map<String, List<Map<String, Object>>>>();
        
        if (pageSectionMap == null ) {
            return returnMap;
        }

        for (String sectionName : pageSectionMap.keyset()) {
            Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = pageSectionMap.get(sectionName);

            if (objectToFieldMap.isEmpty()) {
                continue;
            }
            
            DynamicQueryClass dynamicQueryClass = null;
            if (sectionNameToDynamicOverrideClassMap != null) {
                dynamicQueryClass = sectionNameToDynamicOverrideClassMap.get(sectionName);
            }

            String queryString = generateQueryString(parentFieldId, objectToFieldMap, queryForAllRecords, dynamicQueryClass);
            if (String.isBlank(queryString)) {
                continue;
            }

            System.debug(queryString);
            List<sObject> records = Database.query(queryString);

            List<Map<String, Object>> recordList = new List<Map<String, Object>>();
            //if we need to generate the wrapper, then convert the records, if not just convert the records into a map of string object where the keys are the original field api names
            if (generateWrapper) {
                recordList = convertRecordsToWrapper(records, objectToFieldMap);
            } else {
                for (Sobject record : records) {
                    recordList.add((Map<String,Object>)System.JSON.deserializeUntyped(System.JSON.serialize(record)));
                }
            }
            /*
             * add the records to the correct map. if the records belong to a sub section, then add the records to the sub section that
             * is under the main section. if there is no sub section, then add the records using the key 'records' under the main section in
             * order to keep the data structure consistent
             */
            if (objectToFieldMap.containsKey(MAIN_QUERY_KEY) && !objectToFieldMap.get(MAIN_QUERY_KEY).isEmpty()) {
                 
                Portal_Page_Section_Setting__mdt mainSectionSetting = objectToFieldMap.get(MAIN_QUERY_KEY).get(0);
                
                if (String.isNotBlank(mainSectionSetting.Page_Sub_Section__c)) {
                    if (returnMap.containsKey(mainSectionSetting.Page_Main_Section__c)) {
                        if (returnMap.get(mainSectionSetting.Page_Main_Section__c).containsKey(sectionName)) {
                            returnMap.get(mainSectionSetting.Page_Main_Section__c).get(sectionName).addAll(recordList);
                        } else {
                            returnMap.get(mainSectionSetting.Page_Main_Section__c).put(sectionName, recordList);
                        }
                    } else {
                        returnMap.put(mainSectionSetting.Page_Main_Section__c, new Map<String, List<Map<String, Object>>>{sectionName => recordList});
                    }

                } else if (String.isNotBlank(mainSectionSetting.Page_Main_Section__c)) {
                     
                    if (returnMap.containsKey(mainSectionSetting.Page_Main_Section__c)) {
                        if (returnMap.get(mainSectionSetting.Page_Main_Section__c).containsKey(PORTAL_CONST_PageSectionSetting.RECORD_KEY)) {
                            returnMap.get(mainSectionSetting.Page_Main_Section__c).get(sectionName).addAll(recordList);
                        } else {
                            returnMap.get(mainSectionSetting.Page_Main_Section__c).put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordList);
                        }
                    } else {
                        returnMap.put(mainSectionSetting.Page_Main_Section__c, new Map<String, List<Map<String, Object>>>{PORTAL_CONST_PageSectionSetting.RECORD_KEY => recordList});
                    }
                }

            }
        }
        

        return returnMap;
    }

    /** 
     * method generates a query string from custom metadata records
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param parentFieldId:                                 The id that is used to filter the query through the lookup field
     * @param objectToFieldMap:                              Map that contains the custom metadata records needed to query for the records
     * @param queryForAllRecords:                            The boolean parameter which tells us if we want to query for all records
     * @param dynamicQueryClass:
     *
     */

    global static String generateQueryString(Id parentFieldId, Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap, Boolean queryForAllRecords, DynamicQueryClass dynamicQueryClass) {
        //the main query will hold the fields needed to generate the overall query
        Map<String, Object> queryInfoMap = setupQueryGeneration(parentFieldId, objectToFieldMap, queryForAllRecords);

        Set<String> fieldSet = (Set<String>)queryInfoMap.get(FIELD_SET);
        String sobjectName = (String)queryInfoMap.get(SOBJECT_NAME);
        String controllingParentFieldName = (String)queryInfoMap.get(CONTROLLING_PARENT_FIELD_NAME);
        String filterClause = (String)queryInfoMap.get(FILTER_CLAUSE);
        String orderByClause = (String)queryInfoMap.get(ORDER_BY_CLAUSE);
        String groupByClause = (String)queryInfoMap.get(GROUP_BY_CLAUSE);
        Integer maxItems = (Integer)queryInfoMap.get(MAX_ITEMS);

        //generate the main overall query and return it
        return generateQueryForSection(parentFieldId, fieldSet, sobjectName, filterClause, controllingParentFieldName, groupByClause, orderByClause, maxItems, queryForAllRecords, dynamicQueryClass);
    }

    /** 
     * method generates a query string from a list of fields
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param parentFieldId:                            The id that is used to filter the query through the lookup field
     * @param fieldSet:                                 Map that contains the custom metadata records needed to query for the records
     * @param sobjectName:                              The sobject we are querying for or the relationship name for a subquery
     * @param filterClause:                             The where clause for this query
     * @param controllingParentFieldName:               The lookup field that we will add to the where clause to make sure that the user is not querying for all of our records
     * @param groupByClause:                            The group by clause for this query
     * @param orderByClause:                            The order by clause for this query
     * @param queryForAllRecords:                       The boolean parameter which tells us if we want to query for all records
     * @param dynamicQueryClass:                        Class that contains developer defined clauses that will change the query based on developer needs
     * 
     * 
     */
    //TODO check dynamic query for overrides
    global static String generateQueryForSection(String parentFieldId, 
                                                 Set<String> fieldSet, 
                                                 String sobjectName, 
                                                 String filterClause, 
                                                 String controllingParentFieldName, 
                                                 String groupByClause, 
                                                 String orderByClause, 
                                                 Integer maxItems,
                                                 Boolean queryForAllRecords,
                                                 DynamicQueryClass dynamicQueryClass) {       
        Map<String, Object> queryClauseMap = generateQueryMapForSection(parentFieldId, 
                                                                        fieldSet, 
                                                                        sObjectName, 
                                                                        filterClause, 
                                                                        controllingParentFieldName, 
                                                                        groupByClause, 
                                                                        orderByClause, 
                                                                        maxItems, 
                                                                        queryForAllRecords, 
                                                                        dynamicQueryClass);
        String finalSelectClause = 'SELECT ';
        String finalFromClause = '';
        String finalWhereClause = '';
        String finalGroupByClause = '';
        String finalOrderByClause = '';
        String finalLimitClause = '';
        String finalOffsetClause = '';

        if (queryClauseMap.get(FIELD_CLAUSE) != null) {
            if (((String)queryClauseMap.get(FIELD_CLAUSE)).startsWithIgnoreCase('SELECT')) {
                finalSelectClause = (String)queryClauseMap.get(FIELD_CLAUSE);
            } else {
                finalSelectClause = finalSelectClause + (String)queryClauseMap.get(FIELD_CLAUSE);
            }


        }

        if (queryClauseMap.get(FROM_CLAUSE) != null) {
            finalFromClause = (String)queryClauseMap.get(FROM_CLAUSE);
        }

        if (queryClauseMap.get(WHERE_CLAUSE) != null) {
            finalWhereClause = (String)queryClauseMap.get(WHERE_CLAUSE);
        }

        if (queryClauseMap.get(GROUP_BY_CLAUSE) != null) {
            finalGroupByClause = (String)queryClauseMap.get(GROUP_BY_CLAUSE);
        }

        if (queryClauseMap.get(ORDER_BY_CLAUSE) != null) {
            finalOrderByClause = (String)queryClauseMap.get(ORDER_BY_CLAUSE);
        }

        if (queryClauseMap.get(LIMIT_CLAUSE) != null) {
            finalLimitClause = (String)queryClauseMap.get(LIMIT_CLAUSE);
        }

        if (queryClauseMap.get(OFFSET_CLAUSE) != null) {
            finalOffsetClause = (String)queryClauseMap.get(OFFSET_CLAUSE);
        }

        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection finalSelectClause: ' + finalSelectClause);
        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection finalFromClause: ' + finalFromClause);
        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection whereClause: ' + finalWhereClause);
        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection groupByClause: ' + finalGroupByClause);
        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection orderByClause: ' + finalOrderByClause);
        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection limitClause: ' + finalLimitClause);
        System.debug('PORTAL_UTIL_PageSectionSetting.generateQueryForSection offsetClause: ' + finalOffsetClause);

        return finalSelectClause + finalFromClause + ' ' + finalWhereClause + ' ' + finalGroupByClause + ' ' + finalOrderByClause + ' ' + finalLimitClause + ' ' + finalOffsetClause;
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
    global static List<Map<String, Object>> convertRecordsToWrapper(List<sObject> records, Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap) {
        
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        
        if (objectToFieldMap == null || records == null) {
            return returnList;
        }

        for (sObject record : records) {
            Map<String, Object> wrapper = new Map<String, Object>();
            
            for (String objectName : objectToFieldMap.keyset()) {
                //populate the wrapper with the fields on the sobject
                if (objectName == MAIN_QUERY_KEY) {
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
     * method converts a list of sobject records into a wrapper object 
     * so that the field names will be masked on the front end based on
     * new field names found in custom metadata
     * 
     * 
     * @author: Todd Shinto (copied convertRecordsToWrapper)
     * @since: 1.7
     * 
     * @param records:          he list of records we want to convert
     * @param objectToFieldMap: Map that contains the custom metadata records needed to convert for the records
     * 
     * @return:                 The list of wrapped records
     * 
     */
    global static List<Map<String, Object>> convertStagingRecordsToWrapper(List<sObject> records, Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap) {
        
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        
        if (objectToFieldMap == null || records == null) {
            return returnList;
        }

        System.debug(records);
        for (sObject record : records) {
            Map<String, Object> wrapper = new Map<String, Object>();
            for (String objectName : objectToFieldMap.keyset()) {
            	System.debug(objectName);
                //populate the wrapper with the fields on the sobject
                if (objectName == MAIN_QUERY_KEY) {
                    populateStagingRecordWrapper(record, wrapper, objectToFieldMap.get(objectName));
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
                            populateStagingRecordWrapper(relatedRecord, relatedWrapper, objectToFieldMap.get(objectName));
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
            System.debug(sectionSetting);
            if (sectionSetting.Portal_Section_Field_Settings__r != null) {
                
                for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
            		System.debug(field);
                    //grabs the data from the field
                    if (String.isNotBlank(field.Field_API_Name__c) && String.isNotBlank(field.Front_End_Field_Id__c)) {
                        
                        try {
                            //if the field is a relationship, grab the parent sobject before grabbing the field
                            if (field.Field_API_Name__c.contains('.')) {
                                List<String> fieldSet = field.Field_API_Name__c.split('\\.');
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
                                wrapper.put(field.Front_End_Field_Id__c, record.get(field.Field_API_Name__c));
                            }
                        } catch (Exception e) {
                            System.debug('Could not get field in PORTAL_UTIL_PageSectionSetting.populateWrapper for ' + sectionSetting.Page_Name__c + ' in section ' + sectionSetting.Page_Main_Section__c + ' for field ' + field.Field_API_Name__c);
                            System.debug(e.getStackTraceString());
                        }
                    }
                }

            }
        }
    }

    /** 
     * Method that populates a map of string object from a sobject record based
     * on predefined fields and field names on the custom metadata records
     * 
     * 
     * @author: Todd Shinto (copied from populateWrapper)
     * @since: 1.7
     * 
     * @param record:               Record we are trying to convert
     * @param wrapper:              The wrapper we are populated
     * @param sectionSettingList:   List of custom metadata records needed to convert for the records
     * 
     * 
     */
    private static void populateStagingRecordWrapper(SObject record,  Map<String, Object> wrapper, List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        
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
                            System.debug('Could not get field in PORTAL_UTIL_PageSectionSetting.populateStagingRecordWrapper for ' + sectionSetting.Page_Name__c + ' in section ' + sectionSetting.Page_Main_Section__c + ' for field ' + field.Staging_Record_Field_API_Name__c);
                            System.debug(e.getStackTraceString());
                        }
                    }
                }

            }
        }
    }


    global static Map<String, Object> getFieldsForQuery(List<Portal_Page_Section_Setting__mdt> sectionQueryList, Set<String> fieldSet) {
        Boolean valueSet = false;
        String sobjectName = '';
        String controllingParentFieldName = '';
        String filterClause = '';
        String orderByClause = '';
        String groupByClause = '';
        Integer maxItems = 0;

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionQueryList) {

            if (!valueSet) {
                sobjectName = sectionSetting.SObject_API_Name__c;
                controllingParentFieldName = sectionSetting.Controlling_Parent_Field_API_Name__c;
                filterClause = sectionSetting.Where_Clause__c;
                orderByClause = sectionSetting.Order_By_Clause__c;
                groupByClause = sectionSetting.Group_By_Clause__c;
                maxItems = Integer.valueOf(sectionSetting.Max_Number_of_Query_Records__c);
                valueSet = true;
            } else if ((String.isNotBlank(sectionSetting.sObject_API_Name__c) && sObjectName != sectionSetting.sObject_API_Name__c) ||
                        (String.isNotBlank(sectionSetting.Controlling_Parent_Field_API_Name__c) && controllingParentFieldName != sectionSetting.Controlling_Parent_Field_API_Name__c) ||
                        (String.isNotBlank(sectionSetting.Where_Clause__c) && filterClause != sectionSetting.Where_Clause__c) ||
                        (String.isNotBlank(sectionSetting.Order_By_Clause__c) && orderByClause != sectionSetting.Order_By_Clause__c) ||
                        (String.isNotBlank(sectionSetting.Group_By_Clause__c) && groupByClause != sectionSetting.Group_By_Clause__c)) {
                //if there are multiple main query sections (which should not be the case) and the values are different, skip the metadata record
                System.debug('Portal_UTIL_PageSectionSetting.getFieldsForQuery has page section conflict at ' + sectionSetting.Page_Name__c + ' section: ' + sectionSetting.Page_Main_Section__c);
                continue;
            }

            if (sectionSetting.Portal_Section_Field_Settings__r != null) {
                System.debug(sectionSetting);
                for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
                System.debug(field);
                    if (String.isNotBlank(field.Field_API_Name__c)) {
                        fieldSet.add(field.Field_API_Name__c);
                    }
                }
            } 
        }

        Map<String, Object> returnMap = new  Map<String, Object>();
        returnMap.put('sobjectName', sobjectName);
        returnMap.put('controllingParentFieldName', controllingParentFieldName);
        returnMap.put('filterClause', filterClause);
        returnMap.put('orderByClause', orderByClause);
        returnMap.put('groupByClause', groupByClause);
        returnMap.put('maxItems', maxItems);
        return returnMap;

    }

     /**
     * method that takes the unique id of a front end field and generates the data needed for the front end
     * to easily get the record data from the generic getter function
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param sectionSettingList:             List of custom metadata records that contains the front end display details
     * 
     * @return:                             Map of the unique id to the fields necessary for displaying on the front end
     */

    global static Map<String, Map<String, Object>> getFrontEndDataMap(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {

        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();

        if (sectionSettingList == null || sectionSettingList.isEmpty()) {
            return returnMap;
        }

        String reportUpdateLinkKey = 'reportUpdateLink';
        String displaykey = 'display';
        String labelKey = 'label';
        String disableKey = 'disable';
        String isFrontEndFieldOnlyKey = 'isFrontEndFieldOnly';

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            Map<String, Object> sectionSettingMap = new Map<String, Object>();
            sectionSettingMap.put(reportUpdateLinkKey, sectionSetting.Has_Report_Update_Link__c);
            sectionSettingMap.put(displayKey, sectionSetting.Is_Display_Section__c);
            sectionSettingMap.put('toggleOnSection', sectionSetting.Is_Display_Toggle_On_Section__c);
            sectionSettingMap.put('togglePerRecord', sectionSetting.Is_Display_Toggle_Per_Record__c);
            sectionSettingMap.put(labelKey, sectionSetting.Front_End_Section_Label__c);
            sectionSettingMap.put('mainSectionName', sectionSetting.Page_Main_Section__c);
            sectionSettingMap.put('subSectionName', sectionSetting.Page_Sub_Section__c);
            sectionSettingMap.put('sectionId', sectionSetting.Front_End_Section_Id__c);
            sectionSettingMap.put('sectionDescription', sectionSetting.Section_Description__c);
            sectionSettingMap.put('fieldMap', new Map<String, Object>());
            sectionSettingMap.put('isSection', true);
            sectionSettingMap.put(disableKey, sectionSetting.Is_Disabled__c);
            returnMap.put(sectionSetting.Front_End_Section_Id__c, sectionSettingMap);

            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isBlank(fieldSetting.Front_End_Field_Id__c)) {
                    continue;
                }

                Map<String, Object> dataMap = new Map<String, Object>();
                dataMap.put(labelKey, fieldSetting.Front_End_Field_Label__c);
                dataMap.put('mainSection', sectionSetting.Page_Main_Section__c);
                dataMap.put('subSection', sectionSetting.Page_Sub_Section__c);
                dataMap.put('sectionId', sectionSetting.Front_End_Section_Id__c);
                dataMap.put(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_OBJECT_NAME, sectionSetting.Staging_sObject_API_Name__c);
                //put the data necessary for the front end in the data map
                dataMap.put('fieldId', fieldSetting.Front_End_Field_Id__c);
                dataMap.put('fieldName', fieldSetting.Field_API_Name__c);
                dataMap.put('filterValue', fieldSetting.Filter_Value__c);
                dataMap.put('filterField', fieldSetting.Filter_Field__c);
                dataMap.put('isPicklist', fieldSetting.Field_Type__c == PORTAL_CONST_PageSectionSetting.PICKLIST_FIELD_NAME);
                dataMap.put('isRichText', fieldSetting.Field_Type__c == 'richtext');
                dataMap.put('isTextArea', fieldSetting.Field_Type__c == 'textarea');
                dataMap.put('tooltipText', fieldSetting.Tooltip_Text__c);
                dataMap.put('fieldDescription', fieldSetting.Field_Description__c);
                dataMap.put('stagingRecordFieldName', fieldSetting.Staging_Record_Field_API_Name__c);
                dataMap.put('customMetadataApiName', 'Portal_Section_Field_Setting__mdt');
                dataMap.put('customMetadataDeveloperName', fieldSetting.DeveloperName);
                dataMap.put('lookupFilterClauseName', fieldSetting.Lookup_Filter_Clause__c);
                dataMap.put('displayStagingRecordInRealTime', !(fieldSetting.Is_Disabled__c && fieldSetting.Has_Report_Update_Link__c));
                dataMap.put('orderNumber', fieldSetting.Order_Number__c);
                dataMap.put('toggle', fieldSetting.Has_Toggle__c);
                dataMap.put(reportUpdateLinkKey, fieldSetting.Has_Report_Update_Link__c);
                dataMap.put('isLookup', String.isNotBlank(fieldSetting.Lookup_SObject_Name__c));
                dataMap.put('fieldType', fieldSetting.Field_Type__c);
                dataMap.put('isRequired', fieldSetting.Is_Required__c);
                dataMap.put(displayKey, fieldSetting.Is_Display_On_Portal__c);
                dataMap.put(disableKey, fieldSetting.Is_Disabled__c);
                dataMap.put(isFrontEndFieldOnlyKey, fieldSetting.Front_End_Field_Only__c);

                if (sectionSetting.Is_Disabled__c) {
                    dataMap.put(disableKey, true);
                }

                ((Map<String, Object>)sectionSettingMap.get('fieldMap')).put(fieldSetting.Front_End_Field_Id__c, dataMap);
                returnMap.put(fieldSetting.Front_End_Field_Id__c, dataMap);
            }
        }

        return returnMap;
    }


     /**
     * method that takes the unique id of a front end field and generates the data needed for the back end
     * to update the database
     * 
     * 
     * @author: Aaron Wong
     * @since: 1.0
     * 
     * 
     * @param sectionSettingList:             List of custom metadata records that contains the front end display details
     * 
     * @return:                             Map of the unique id to the fields necessary for updating the database
     */

    global static Map<String, Map<String, Object>> getBackEndDataMap(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();

        if (sectionSettingList == null || sectionSettingList.isEmpty()) {
            return returnMap;
        }

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            Map<String, Object> sectionSettingMap = new Map<String, Object>();
            sectionSettingMap.put('sectionId', sectionSetting.Front_End_Section_Id__c);
            sectionSettingMap.put('objectApiName', sectionSetting.sObject_API_Name__c);
            sectionSettingMap.put('mainSectionName', sectionSetting.Page_Main_Section__c);
            sectionSettingMap.put('subSectionName', sectionSetting.Page_Sub_Section__c);

            sectionSettingMap.put(MAX_NUMBER_OF_QUERY_RECORDS, sectionSetting.Max_Number_of_Query_Records__c);
            sectionSettingMap.put('fieldMap', new Map<String, Object>());
            
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.ACTIVE_RECORD_FIELD_MAP, sectionSetting.Active_Record_Field_Map__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.INACTIVE_RECORD_FIELD_MAP, sectionSetting.Inactive_Record_Field_Map__c);

            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.IS_CREATE_STAGING_RECORD_UPON_EDIT, sectionSetting.Is_Create_Staging_Record_Upon_Edit__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.IS_CREATE_STAGING_RECORD_UPON_CREATION, sectionSetting.Is_Create_Staging_Record_Upon_Creation__c);

            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.RECORD_TYPE_DEVELOPER_NAME, sectionSetting.Record_Type_Developer_Name__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_TYPE_DEVELOPER_NAME, sectionSetting.Staging_Record_Type_Developer_Name__c);

            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.CONTROLLING_PARENT_FIELD_NAME, sectionSetting.Controlling_Parent_Field_API_Name__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_OBJECT_NAME, sectionSetting.Staging_sObject_API_Name__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_CONTROLLING_PARENT_FIELD, sectionSetting.Staging_Record_Controlling_Parent_Field__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.ORIGINAL_RECORD_FIELD_API_NAME, sectionSetting.Original_Record_Field_API_Name__c);

            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.CONTROLLING_PARENT_OBJECT, sectionSetting.Controlling_Parent_Object__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_CONTROLLING_PARENT_OBJECT, sectionSetting.Staging_Record_Controlling_Parent_Object__c);
            
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.IS_HARD_DELETE_RECORDS, sectionSetting.Is_Hard_Delete_Records__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.IS_SECTION, true);

            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.HAS_DUPLICATE_LOGIC, sectionSetting.Has_Duplicate_Logic__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.DUPLICATE_FIELD_LOGIC, sectionSetting.Duplicate_Field_Logic__c);

            // clauses
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.WHERE_CLAUSE, sectionSetting.Where_Clause__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.ORDER_BY_CLAUSE, sectionSetting.Order_By_Clause__c);
            sectionSettingMap.put(PORTAL_CONST_PageSectionSetting.MAX_NUMBER_OF_QUERY_RECORDS, sectionSetting.Max_Number_of_Query_Records__c);

            returnMap.put(sectionSetting.Front_End_Section_Id__c, sectionSettingMap);

            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isBlank(fieldSetting.Front_End_Field_Id__c)) {
                    continue;
                }

                Map<String, Object> dataMap = new Map<String, Object>();
                dataMap.put('sectionId', sectionSetting.Front_End_Section_Id__c);
                //put the data necessary for the front end in the data map
                dataMap.put('fieldId', fieldSetting.Front_End_Field_Id__c);
                dataMap.put('fieldApiName', fieldSetting.Field_API_Name__c); // cannot remove this since it is used in many places
                dataMap.put('fieldName', fieldSetting.Field_API_Name__c);  // added b/c this is needed to be consistent with front end data map
                dataMap.put('fieldType', fieldSetting.Field_Type__c);
                dataMap.put('filterValue', fieldSetting.Filter_Value__c);
                dataMap.put('filterField', fieldSetting.Filter_Field__c);
                dataMap.put('stagingRecordFieldName', fieldSetting.Staging_Record_Field_API_Name__c);
                dataMap.put('customMetadataDeveloperName', fieldSetting.DeveloperName);
                dataMap.put('lookupObjectApiName', fieldSetting.Lookup_SObject_Name__c);
                dataMap.put('lookupFieldName', fieldSetting.Lookup_Field_Name__c);
                dataMap.put('staticAvailableValues', fieldSetting.Static_Available_Values__c);
                dataMap.put('lookupFilterClauseName', fieldSetting.Lookup_Filter_Clause__c);
                dataMap.put('displayStagingRecordInRealTime', !(fieldSetting.Is_Disabled__c && fieldSetting.Has_Report_Update_Link__c));
                dataMap.put(PORTAL_CONST_PageSectionSetting.IS_CREATE_NEW_RECORD, fieldSetting.Is_Create_New_Record__c);
                dataMap.put(PORTAL_CONST_PageSectionSetting.IS_CREATE_STAGING_RECORD_ON_FIELD_CHANGE, fieldSetting.Is_Create_Staging_Record_On_Field_Change__c);

                dataMap.put('mainSection', sectionSetting.Page_Main_Section__c);
                dataMap.put('subSection', sectionSetting.Page_Sub_Section__c);
                dataMap.put(PORTAL_CONST_PageSectionSetting.STAGING_RECORD_OBJECT_NAME, sectionSetting.Staging_sObject_API_Name__c);

                dataMap.put(PORTAL_CONST_PageSectionSetting.FIELD_ORDER_FOR_DUPLICATE_LOGIC, fieldSetting.Field_Order_For_Duplicate_Logic__c);

                ((Map<String, Object>)sectionSettingMap.get('fieldMap')).put(fieldSetting.Front_End_Field_Id__c, dataMap);
                returnMap.put(fieldSetting.Front_End_Field_Id__c, dataMap);
            }
        }

        return returnMap;
    }

    /**
     * method that retrieves the picklist values and labels and stores them in the map to display
     * on the front end when a constituent needs to update their information
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param sectionSettingList:         The custom metadata records that contains the field names of the picklists that are needed
     * @return:                           A map of picklist name to list of field labels to field values
     * 
     * 
     */
    global static Map<String, List<Map<String, String>>> getPicklists(List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, List<Map<String, String>>> returnMap = new Map<String, List<Map<String, String>>>();

        //the picklist fields need to be separated by sobject name in order to avoid api name collisions and to query the correcty sobject
        Map<String, List<String>> objectToFieldMap = new Map<String, List<String>>();
        Map<String, Map<String, Set<String>>> frontEndFieldIdMap = new Map<String, Map<String, Set<String>>>();

        if (sectionSettingList == null || sectionSettingList.isEmpty()) {
            return new Map<String, List<Map<String, String>>>();
        }

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            if (String.isNotBlank(sectionSetting.SObject_API_Name__c) && sectionSetting.Portal_Section_Field_Settings__r != null && !sectionSetting.Portal_Section_Field_Settings__r.isEmpty()) {
                List<String> picklistFieldSet = new List<String>();
                String sobjectName = sectionSetting.SObject_API_Name__c;
                if (sectionSetting.Is_Child__c == true && String.isNotBlank(sectionSetting.SObject_Relationship_API_Name__c)) {
                    try {
                        List<Schema.ChildRelationship> childRelationships = ((sObject)Type.forName(sectionSetting.sObject_API_Name__c).newInstance()).getSobjectType().getDescribe().getChildRelationships();
                        for (Schema.ChildRelationship childRelationship : childRelationships) {
                            if (childRelationship.getRelationshipName() == sectionSetting.SObject_Relationship_API_Name__c) {
                                sobjectName = childRelationship.getChildSObject().getDescribe().getName();
                            }
                        }

                    } catch (Exception e) {

                    }
                }
                for (Portal_Section_Field_Setting__mdt field : sectionSetting.Portal_Section_Field_Settings__r) {
                    //TODO create constant class to hold constants for code
                    //only get the picklist if the field type is picklist and add it to the set of picklists that need to be queried
                    if (String.isNotBlank(field.Field_API_Name__c) && String.isNotBlank(field.Field_Type__c) && field.Field_Type__c.equals('picklist')) {
                       if (String.isNotBlank(field.Static_Available_Values__c)) {
                           String newlineChar = '\n';

                           if (field.Static_Available_Values__c.contains('\r\n')) {
                               newlineChar = '\r\n';
                           }

                            List<String> picklistValues = field.Static_Available_Values__c.split(newlineChar);
                            List<Map<String, String>> picklistList = new List<Map<String, String>>();
                            for (String value : picklistValues) {
                                Map<String, String> picklistMap = new Map<String, String>();
                                if (value.contains('~')) {
                                    List<String> labelAndValueList = value.split('~');
                                    picklistMap.put('value', labelAndValueList.get(1));
                                    picklistMap.put('label', labelAndValueList.get(0));
                                } else {
                                     picklistMap.put('value', value);
                                     picklistMap.put('label', value);
                                }
                                picklistList.add(picklistMap);
                            }
                            
                            returnMap.put(field.Front_End_Field_Id__c, picklistList);
                        } else {
                            if (frontEndFieldIdMap.containsKey(sobjectName)) {
                                if (frontEndFieldIdMap.get(sObjectName).containsKey(field.Field_API_Name__c)) {
                                    frontEndFieldIdMap.get(sobjectName).get(field.Field_API_Name__c).add(field.Front_End_Field_Id__c);
                                } else {
                                    frontEndFieldIdMap.get(sobjectName).put(field.Field_API_Name__c, new Set<String>{field.Front_End_Field_Id__c});
                                }
                                
                            } else {
                                frontEndFieldIdMap.put(sobjectName, new Map<String, Set<String>>{field.Field_API_Name__c => new Set<String>{field.Front_End_Field_Id__c}});
                            }

                            
                            
                            picklistFieldSet.add(field.Field_API_Name__c);

                        }
                    }
                }
                if (!picklistFieldSet.isEmpty()) {
                    if (objectToFieldMap.containsKey(sobjectName)) {
                        objectToFieldMap.get(sobjectName).addAll(picklistFieldSet);
                    } else {
                        objectToFieldMap.put(sobjectName, picklistFieldSet);
                    }
                }
            }
        }

        //get the picklist values
        if (objectToFieldMap.isEmpty()) {
            return returnMap;
        } else {
            //TODO convert map to use front end field id
            Map<String, Map<String, List<Map<String, String>>>> picklistMap =  PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object> {PORTAL_CommunityUtils.PARAM_PICKLISTS => objectToFieldMap});
            for (String sobjectAPIName : picklistMap.keyset()) {
                for (String picklistAPIName : picklistMap.get(sObjectAPIName).keyset()) {
                    if (frontEndFieldIdMap.containsKey(sObjectAPIName) && frontEndFieldIdMap.get(sObjectApiName).containsKey(picklistAPIName)) {
                        for (String frontEndFieldId : frontEndFieldIdMap.get(sObjectAPIName).get(picklistAPIName)) {
                            returnMap.put(frontEndFieldId, picklistMap.get(sObjectApiName).get(picklistAPIName));
                        }
                        
                    }
                }
            }
            return returnMap;
        }
        

    }

    /**
     * Gets the staging records for the page section setting
     * 
     * 
     * @author: Todd Shinto
     * @since: 1.5
     * 
     * 
     * @param sectionSetting:               The custom metadata record for the page section setting
     * @param stagingRecordParentFieldId:   The staging record parent field ID
     * 
     * @return:                             A list of staged sObjects
     */
    private static List<Map<String, Object>> getStagingRecordsForSection(String stagingRecordParentFieldId, Portal_Page_Section_Setting__mdt sectionSetting, Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap) {
        if (String.isBlank(sectionSetting.Staging_sObject_API_Name__c) || String.isBlank(stagingRecordParentFieldId)) {
            return new List<Map<String, Object>>();
        }

        Set<String> fieldSet = getStagingFieldSetToQuery(sectionSetting);

        if (fieldSet.isEmpty()) {
            return new List<Map<String, Object>>();
        }

        String whereClause = getStagingRecordsWhereClause(stagingRecordParentFieldId, sectionSetting);
        System.debug(sectionSetting);
        String queryString = getStagingRecordsQueryString(fieldSet, whereClause, sectionSetting.Staging_sObject_API_Name__c);
        List<sObject> recordList = Database.query(queryString);

        //return null;
        return convertStagingRecordsToWrapper(recordList, objectToFieldMap);
    }

    /**
     * Gets the staging record query string
     * 
     * 
     * @author: Todd Shinto
     * @since: 1.5
     * 
     * 
     * @param fieldSet:         The list of fields from the page section setting, to be used in the query
     * @param whereClause:      The page section setting where clause
     * @param sObjectApiName:   The sObject API name that we're querying
     * 
     * @return:                 The staging records query string
     */
    private static String getStagingRecordsQueryString(Set<String> fieldSet, String whereClause, String sObjectApiName) {
        String resultString = 'SELECT ';
        resultString += String.join(new List<String>(fieldSet), ', ');
        resultString += ' FROM ' + sObjectApiName;
        resultString += whereClause;
        
        return resultString;
    }

    /**
     * Gets the staging record where clause
     * 
     * 
     * @author: Todd Shinto
     * @since: 1.5
     * 
     * 
     * @param sectionSetting:               The custom metadata record for the page section setting
     * @param stagingRecordParentFieldId:   The staging record parent field ID
     * 
     * @return:                             The where clause for the query string
     */
    private static String getStagingRecordsWhereClause(String stagingRecordParentFieldId, Portal_Page_Section_Setting__mdt sectionSetting) {
        String resultString = '';
        String whereClausePrefix = ' WHERE ';
        
        if (String.isNotBlank(sectionSetting.Staging_Record_Controlling_Parent_Field__c)) {
            resultString = whereClausePrefix + sectionSetting.Staging_Record_Controlling_Parent_Field__c + ' = \'' + stagingRecordParentFieldId + '\' ';
            whereClausePrefix = ' AND ';
        }

        if (String.isNotBlank(sectionSetting.Staging_Record_Where_Clause__c)) {
            resultString += whereClausePrefix + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Staging_Record_Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
        }

        return resultString;
    }

    /**
     * Gets the fields to query
     * 
     * 
     * @author: Todd Shinto
     * @since: 1.5
     * 
     * 
     * @param sectionSetting:               The custom metadata record for the page section setting
     * 
     * @return:                             A set of fields to query
     */
    private static Set<String> getStagingFieldSetToQuery(Portal_Page_Section_Setting__mdt sectionSetting) {
        Set<String> resultSet = new Set<String>();

        if (sectionSetting == null) {
            return resultSet;
        }

        for (Portal_Section_Field_Setting__mdt eachFieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
            if (eachFieldSetting.Staging_Record_Field_API_Name__c == null) {
                continue;
            }

            resultSet.add(eachFieldSetting.Staging_Record_Field_API_Name__c);
        }

        return resultSet;
    }

    /**
     * method that queries for all the interim records that were generated by this constituent
     *
     *
     * @author: Todd Shinto
     * @since: 1.5
     *
     * @param stagingRecordParentFieldId:   The ID of the parent record on the staging record
     * @param sectionSettingList:           The custom metadata records that contain information on how to query the interim records
     * 
     * @return:                             A map of the section id to queried staged records
     */
    global static Map<String, List<Map<String, Object>>> queryForStagingRecords(String stagingRecordParentFieldId, List<Portal_Page_Section_Setting__mdt> sectionSettingList) {
        Map<String, List<Map<String, Object>>> returnMap = new Map<String, List<Map<String, Object>>>();
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = generatePageSectionSettingMap(sectionSettingList);
        
        
        for (Portal_Page_Section_Setting__mdt eachSectionSetting : sectionSettingList) {
            String sectionName = String.isNotBlank(eachSectionSetting.Page_Sub_Section__c) ? eachSectionSetting.Page_Sub_Section__c : eachSectionSetting.Page_Main_Section__c;

            System.debug(sectionName);
            System.debug(pageSectionMap.get(sectionName));
            returnMap.put(eachSectionSetting.Front_End_Section_Id__c, getStagingRecordsForSection(stagingRecordParentFieldId, eachSectionSetting, pageSectionMap.get(sectionName)));

        }
			return returnMap;
       
    }

    /**
     * Get permission map and section map for portal page section.
     * 
     * @param   pageName                                    Name of the portal page section.
     * @param   mainSectionName                             Name of the main section page name.
     * @param   subSectionName                              Name of the sub section name for the portal page section.
     * @param   sectionToGetName                            Section name to grab query information from.
     * @param   parentFieldId                               The id that is used to filter the query through the lookup field to prevent user from querying for more information than they have access to (nullable) 
     * @param   queryAllRecords                             Query for all recrods.
     * @param   dynamicQueryClass                           List of Class used to overwrite the query. Should always be a list with null as the index value if no class is used.
     * @return                                              Portal page section information related to sectionToGetName.
     */
    global static Map<String, Object> getPortalPageSectionDisplayMetadata(String pageName, String mainSectionName, String subSectionName, String sectionToGetName, 
                                                    Id parentFieldId, Boolean queryAllRecords, List<DynamicQueryClass> dynamicQueryClassList) {
        Map<String, Object> returnMap = new Map<String, Object>(); 

        if (dynamicQueryClassList == null) {
            dynamicQueryClassList = new List<DynamicQueryClass>{null};
        }

        List<Portal_Page_Section_Setting__mdt> sectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, 
                                                                                                                         mainSectionName, 
                                                                                                                         subSectionName);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> sections = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionList);
        Map<String, List<Portal_Page_Section_Setting__mdt>> sectionToReturn = sections.get(sectionToGetName);

        if (sectionToReturn == null ) {
            throw new PortalPageSectionException('Could not find section name. Error Code 400.');
        }

        Map<String, Map<String, Object>> permissionMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionList);

        returnMap.put(SECTION_MAP_KEY, sectionToReturn);
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);
        
        List<Object> queryStrings = new List<Object>();

        for (DynamicQueryClass currentDynamicQueryClass : dynamicQueryClassList) {
            queryStrings.add(PORTAL_UTIL_PageSectionSetting.generateQueryString(parentFieldId, sectionToReturn, queryAllRecords, currentDynamicQueryClass));
        }

        
        returnMap.put(QUERY_STRING_KEY, queryStrings);

        return returnMap;
    }
    /**
     * method that iterates through a list of field settings to populate
     * an sobject record from data that was inputted on the front end 
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param fieldSettingsList:         The custom metadata records that contains the field names and what they should map to
     * @param recordToPopulate:          The sobject record we are trying to populate
     * @param recordWithData:            The record that has the data from the front end
     * 
     * 
     */

    public static void populateRecord(sObject recordToPopulate, Map<String, Object> recordWithData, List<Portal_Section_Field_Setting__mdt> fieldSettingsList) {
        for (Portal_Section_Field_Setting__mdt fieldSetting : fieldSettingsList) {
            if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c)) {
                if (fieldSetting.Field_API_Name__c.contains('.')) {
                    List<String> fields = fieldSetting.Field_API_Name__c.split('\\.');
                        if (fields.size() < 2) {
                            continue;
                        } else {
                            Map<String, Object> parentRecord = new Map<String, Object>(recordWithData);
                            for (Integer index = 0; index < fields.size(); index++) {
                                if (index == fields.size()-1) {
                                    if (parentRecord != null) {
                                        recordToPopulate.put(fieldSetting.Staging_Record_Field_API_Name__c, parentRecord.get(fields.get(index))); 
                                    } else {
                                        recordToPopulate.put(fieldSetting.Staging_Record_Field_API_Name__c, null);
                                    }
                                } else {
                                    if (parentRecord != null) {
                                        parentRecord = (Map<String, Object>) parentRecord.get(fields.get(index));
                                    } else {
                                        recordToPopulate.put(fieldSetting.Staging_Record_Field_API_Name__c, null);
                                        break;
                                    }
                                }
                            }
                        }
                } else {
                    recordToPopulate.put(fieldSetting.Staging_Record_Field_API_Name__c, recordWithData.get(fieldSetting.Field_API_Name__c));
                } 
                
            }
        }
    }

    /** 
     * Gets a map of query clauses using the page sectoin settings provided
     * 
     * 
     * @author: Aaron Wong
     * @since: 1.0
     * 
     * @param parentFieldId:                            The id that is used to filter the query through the lookup field to prevent user from querying for more information than they have access to (nullable)
     * @param sectionName:                              The section name to get the query clauses for. 
     * @param pageSectionMap:                           Map that contains the custom metadata records needed to query for the records
     * @param sectionNameToDynamicOverrideClassMap:     Map of section name to the a developer defined dynamic query class if the developer wants to override the query
     * @return                                          Map of the clauses used to query.
     */
    public static Map<String, Object> getQueryClauseMap(Id parentFieldId, 
                                                        String sectionName,
                                                        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap, 
                                                        Map<String, DynamicQueryClass> sectionNameToDynamicOverrideClassMap,
							                            Boolean queryForAllRecords) {
        Map<String, Object> resultMap = new Map<String, Object>();
        
        if (pageSectionMap == null || String.isBlank(sectionName) 
                || pageSectionMap.get(sectionName) == null || pageSectionMap.get(sectionName).isEmpty()) {
            return resultMap;
        }

        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = pageSectionMap.get(sectionName);
        
        DynamicQueryClass dynamicQueryClass = null;
        if (sectionNameToDynamicOverrideClassMap != null) {
            dynamicQueryClass = sectionNameToDynamicOverrideClassMap.get(sectionName);
        }

        Map<String, Object> queryInfoMap = setupQueryGeneration(parentFieldId, objectToFieldMap, queryForAllRecords);

        Set<String> fieldSet = (Set<String>)queryInfoMap.get(FIELD_SET);
        String sobjectName = (String)queryInfoMap.get(SOBJECT_NAME);
        String controllingParentFieldName = (String)queryInfoMap.get(CONTROLLING_PARENT_FIELD_NAME);
        String filterClause = (String)queryInfoMap.get(FILTER_CLAUSE);
        String orderByClause = (String)queryInfoMap.get(ORDER_BY_CLAUSE);
        String groupByClause = (String)queryInfoMap.get(GROUP_BY_CLAUSE);
        Integer maxItems = (Integer)queryInfoMap.get(MAX_ITEMS);
        
        return generateQueryMapForSection(parentFieldId, fieldSet, sobjectName, filterClause, controllingParentFieldName, groupByClause, orderByClause, maxItems, false, dynamicQueryClass); 
    }

    /**
     * Sets up variables used for generating the final query.
     *
     * @author Ashley Tran
     *
     * @param parentFieldId         The parent field Id.
     * @param objectToFieldMap      Map of object name to page section settings.
     * @return                      Map of variables.
     * @since                       1.0
     */
    private static Map<String, Object> setupQueryGeneration(String parentFieldId,
                                                            Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap,
							    Boolean queryForAllRecords) {
        Map<String, Object> resultMap = new Map<String, Object>();

        Set<String> fieldSet = new Set<String>();

        //the main query will hold the fields needed to generate the overall query
        String sobjectName = '';
        String controllingParentFieldName = '';
        String filterClause = '';
        String orderByClause = '';
        String groupByClause = '';
        Integer maxItems = 0;

        for (String objectName : objectToFieldMap.keyset()) {
            if (objectName == MAIN_QUERY_KEY) {
                List<Portal_Page_Section_Setting__mdt> mainQuerySectionList = objectToFieldMap.get(objectName);
                Map<String, Object> fieldValueToFieldNameMap = getFieldsForQuery(mainQuerySectionList, fieldSet);
                sobjectName = (String) fieldValueToFieldNameMap.get('sobjectName');
                controllingParentFieldName = (String) fieldValueToFieldNameMap.get('controllingParentFieldName');
                filterClause = (String) fieldValueToFieldNameMap.get('filterClause');
                orderByClause = (String) fieldValueToFieldNameMap.get('orderByClause');
                groupByClause = (String) fieldValueToFieldNameMap.get('groupByClause');
                maxItems = (Integer) fieldValueToFieldNameMap.get('maxItems');
            } else {
                //if our fields are on a relationship, then collect all of the relationship fields that we need to generate the subquery
                List<Portal_Page_Section_Setting__mdt> relationshipQueryList = objectToFieldMap.get(objectName);

                Set<String> relationshipFieldSet = new Set<String>();
                String relationshipFilterClause = '';
                String relationshipControllingParentFieldName = '';
                String relationshipGroupByClause = '';
                String relationshipOrderByClause = '';
                Integer relationshipMaxItems = 0;

                Map<String, Object> fieldValueToFieldNameMap =  getFieldsForQuery(relationshipQueryList, relationshipFieldSet);
                relationshipFilterClause = (String) fieldValueToFieldNameMap.get('filterClause');
                relationshipControllingParentFieldName =  (String) fieldValueToFieldNameMap.get('controllingParentFieldName');
                relationshipGroupByClause = (String) fieldValueToFieldNameMap.get('groupByClause');
                relationshipOrderByClause = (String) fieldValueToFieldNameMap.get('orderByClause');
                relationshipMaxItems = (Integer) fieldValueToFieldNameMap.get('maxItems');

                //create the subquery and add it to the field set since it is considered a field on the main query
                String subQuery = generateQueryForSection(parentFieldId, relationshipFieldSet, objectName, relationshipFilterClause, relationshipControllingParentFieldName, relationshipGroupByClause, relationshipOrderByClause, relationshipMaxItems, queryForAllRecords, null);
                if (String.isNotBlank(subQuery)) {
                    subQuery = '(' + subQuery + ')';
                    fieldSet.add(subQuery);  
                } 
            }
        }

        resultMap.put(FIELD_SET, fieldSet);
        resultMap.put(SOBJECT_NAME, sobjectName);
        resultMap.put(CONTROLLING_PARENT_FIELD_NAME, controllingParentFieldName);
        resultMap.put(FILTER_CLAUSE, filterClause);
        resultMap.put(ORDER_BY_CLAUSE, orderByClause);
        resultMap.put(GROUP_BY_CLAUSE, groupByClause);
        resultMap.put(MAX_ITEMS, maxItems);

        return resultMap;
    }

    /** 
     * method generates a query Map from a list of fields
     * 
     * 
     * @author Aaron Wong
     * @since: 1.0
     * 
     * @param parentFieldId:                            The id that is used to filter the query through the lookup field
     * @param fieldSet:                                 Map that contains the custom metadata records needed to query for the records
     * @param sobjectName:                              The sobject we are querying for or the relationship name for a subquery
     * @param filterClause:                             The where clause for this query
     * @param controllingParentFieldName:               The lookup field that we will add to the where clause to make sure that the user is not querying for all of our records
     * @param groupByClause:                            The group by clause for this query
     * @param orderByClause:                            The order by clause for this query
     * @param queryForAllRecords:                       The boolean parameter which tells us if we want to query for all records
     * @param dynamicQueryClass:                        Class that contains developer defined clauses that will change the query based on developer needs
     * 
     * 
     */
    global static Map<String, Object> generateQueryMapForSection(String parentFieldId, 
                                                         Set<String> fieldSet, 
                                                         String sobjectName, 
                                                         String filterClause, 
                                                         String controllingParentFieldName, 
                                                         String groupByClause, 
                                                         String orderByClause, 
                                                         Integer maxItems,
                                                         Boolean queryForAllRecords,
                                                         DynamicQueryClass dynamicQueryClass) {       

        Map<String, Object> resultMap = new Map<String, Object>();

        if (String.isBlank(sobjectName) || fieldSet.isEmpty()) {
            return resultMap;
        }

        if (queryForAllRecords == null) {
            queryForAllRecords = false;
        }

        //generate the base query = 
        String controllingParentFieldNameQueryPrefix = ' WHERE ';
        String finalSelectClause = String.join(new List<String>(fieldSet), ',');
        String finalFromClause = ' FROM ' + sobjectName;
        String finalWhereClause = '';
        String finalGroupByClause = '';
        String finalOrderByClause = '';
        String finalLimitClause = '';
        String finalOffsetClause = '';
        //filter the records based on the filter clause if we are not trying to get all the records with the same lookup id 
        //ALWAYS FILTER BY A LOOKUP TO PREVENT SOMEONE FROM QUERYING FOR ALL OF THE RECORDS IN THE DATABASE UNLESS YOU KNOW EXACTLY WHAT IS RETURNED
        
        if (String.isNotBlank(filterClause) && !queryForAllRecords) {
            finalWhereClause = finalWhereClause + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => filterClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
            controllingParentFieldNameQueryPrefix = ' AND ';
        } 


        //check to see if all of our clauses are prefaced correctly before adding it to the query string
        if (String.isNotBlank(groupByClause)) {
            finalGroupByClause = finalGroupByClause + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => groupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }

        if (String.isNotBlank(orderByClause)) {
           
            finalOrderByClause = finalOrderByClause + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => orderByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'order by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }

        if (maxItems != null && maxItems > 0) {
            finalLimitClause = ' LIMIT ' + String.valueOf(maxItems);
        }

        if (dynamicQueryClass != null) {
            if (dynamicQueryClass.overrideMetadata == true) {
                if (dynamicQueryClass.dynamicSelectClause != null) {
                    finalSelectClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicSelectClause, PORTAL_CommunityUtils.PARAM_PREFIX => '', PORTAL_COmmunityUtils.PARAM_REPLACEMENT => null});
                }
                if (dynamicQueryClass.overrideWhereClause && dynamicQueryClass.dynamicWhereClause != null) {
                    finalWhereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                } else if (String.isNotBlank(dynamicQueryClass.dynamicWhereClause)) {
                    if (String.isBlank(finalWhereClause)) {
                        finalWhereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                    } else {
                        finalWhereClause =  PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => finalWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => 'where ('})  + ') AND ' +  PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''}) + '';
                    }
                }
                if (dynamicQueryClass.overrideGroupByClause == true && dynamicQueryClass.dynamicGroupByClause != null) {
                    finalGroupByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicGroupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                } else if (String.isNotBlank(dynamicQueryClass.dynamicGroupByClause)) {
                    if (String.isBlank(finalGroupByClause)) {
                        finalGroupByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicGroupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                    } else {
                        finalGroupByClause = finalGroupByClause + ', ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicGroupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
                    }
                }
                if (dynamicQueryClass.dynamicOrderByClause != null) {
                    finalOrderByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicOrderByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'order by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                }
                
            } else {
                if (String.isNotBlank(dynamicQueryClass.dynamicSelectClause)) {
                    List<String> dynamicQueryFieldList = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicSelectClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'select', PORTAL_COmmunityUtils.PARAM_REPLACEMENT => ''}).split(',');
                    Set<String> fieldsToQuerySet = new Set<String>(fieldSet);
                    for (String field : dynamicQueryFieldList) {
                        String trimmedField = field.trim();
                        Boolean duplicateField = false;
                        for (String possibleDuplicateField : fieldsToQuerySet) {
                            if (possibleDuplicateField.equalsIgnoreCase(trimmedField)) {
                                duplicateField = true;
                                break;
                            }
                        }
                        if (!duplicateField) {
                            fieldsToQuerySet.add(trimmedField);
                        }
                    }
                    finalSelectClause = String.join(new List<String> (fieldsToQuerySet), ',');
                }

                if (dynamicQueryClass.overrideWhereClause == true && dynamicQueryClass.dynamicWhereClause != null) {
                    finalWhereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                } else if (String.isNotBlank(dynamicQueryClass.dynamicWhereClause)) {
                    if (String.isBlank(finalWhereClause)) {
                        finalWhereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                    } else {
                        finalWhereClause =  PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => finalWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => 'where ('})  + ') AND ' +  PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicWhereClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''}) + '';
                    }
                }

                if (dynamicQueryClass.overrideGroupByClause == true && dynamicQueryClass.dynamicGroupByClause != null) {
                    finalGroupByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicGroupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                } else if (String.isNotBlank(dynamicQueryClass.dynamicGroupByClause)) {
                    if (String.isBlank(finalGroupByClause)) {
                        finalGroupByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicGroupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                    } else {
                        finalGroupByClause = finalGroupByClause + ', ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicGroupByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'group by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
                    }
                }

                if (String.isNotBlank(dynamicQueryClass.dynamicOrderByClause)) {
                    if (String.isBlank(finalOrderByClause)) {
                        finalOrderByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicOrderByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'order by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                    }  else {
                        finalOrderByClause = finalOrderByClause + ', ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => dynamicQueryClass.dynamicOrderByClause, PORTAL_CommunityUtils.PARAM_PREFIX => 'order by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
                    }
                }
            }

            if (dynamicQueryClass.maxItems != null && dynamicQueryClass.maxItems > 0) {
                finalLimitClause = ' LIMIT ' + String.valueOf(dynamicQueryClass.maxItems);
            }

            if (dynamicQueryClass.offset != null && dynamicQueryClass.offset >= 0) {
                finalOffsetClause = ' OFFSET ' + String.valueOf(dynamicQueryClass.offset);
            }
        }

        // parent field id is added here to not alter its case sensitivity. 
        if (String.isNotBlank(controllingParentFieldName) && String.isNotBlank(parentFieldId)) {
            //get all of the sobject records without filters that is related to the lookup
            if (String.isNotBlank(finalWhereClause)) {
                controllingParentFieldNameQueryPrefix = ' AND ';
            }

            finalWhereClause = finalWhereClause + controllingParentFieldNameQueryPrefix +  controllingParentFieldName + ' = \'' + parentFieldId + '\'';
        }

        resultMap.put(FIELD_CLAUSE, finalSelectClause);
        resultMap.put(FROM_CLAUSE, finalFromClause);
        resultMap.put(WHERE_CLAUSE, finalWhereClause);
        resultMap.put(GROUP_BY_CLAUSE, finalGroupByClause);
        resultMap.put(ORDER_BY_CLAUSE, finalOrderByClause);
        resultMap.put(LIMIT_CLAUSE, finalLimitClause);
        resultMap.put(OFFSET_CLAUSE, finalOffsetClause);

        return resultMap;
    }
}