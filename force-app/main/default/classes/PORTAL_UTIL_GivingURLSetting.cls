/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
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
 * Utility Functions related to 'Portal Giving URL Setting' and 'Portal Giving URL Setting Field' metadata.
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global inherited sharing class PORTAL_UTIL_GivingURLSetting {


    @TestVisible private static final String BASE_URL = 'baseURL';
    @TestVisible private static final String CHILD_FIELD_RECORDS = 'childFieldRecords';

    global class GivingURLSettingsException extends Exception {}

    /**
     * Query for Portal Giving URL Setting and its related Portal Giving URL Setting Field records.
     *
     * @param               parentName                      Will match against the labels of all Portal Giving URL Setting records.
     * @param               queryFilter                     Narrows down related Portal Giving URL Setting Field by filtering on the query filter field.
     * @return                                              Portal Giving URL Setting record if found, null if not found.
     * @version                                             1.0
     * @since                                               1.0
     */
    global static Portal_Giving_URL_Setting__mdt getGivingURLSettings(String parentName, String queryFilter) {

        if (String.isBlank(parentName)) {
            throw new GivingURLSettingsException('Parent name is missing. Error code 501.');
        }

        String queryString = 'SELECT Base_URL__c, ' +
                                ' (SELECT Field_API_Name__c, SObject_API_Name__c, Static_Field_Value__c, URL_parameter_Name__c FROM Portal_Giving_URL_Setting_Fields__r ';

        if (String.isNotBlank(queryFilter)) {
            queryString += ' WHERE Query_Filter__c LIKE \'%' + queryFilter +'%\' OR Query_Filter__c LIKE \'%All%\' ';
        }

        queryString +=  ' ) FROM Portal_Giving_URL_Setting__mdt WHERE MasterLabel =: parentName ';

        List<Portal_Giving_URL_Setting__mdt> givingUrlSettingsRecords =  Database.query(queryString);

        if (givingUrlSettingsRecords.isEmpty()) {
            return null;
        } else {
            return givingUrlSettingsRecords[0];
        }
    }

    /**
     * Converts a Portal Giving URL Setting record into a formatted map.
     *
     * @param               givingURLMetadataRecord         Portal Giving URL Setting record to convert into a map.
     * @return                                              {BASE_URL => Base URL, CHILD_FIELD_RECORDS => {sObject name => List<Portal Giving URL Setting Field record>}}.
     * @version                                             1.0
     * @since                                               1.0
     */
    global static Map<String, Object> generateGivingURLSettingsMap(Portal_Giving_URL_Setting__mdt givingURLMetadataRecord) {
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String, List<Portal_Giving_URL_Setting_Field__mdt>> sObjectNameToFieldRecords = new Map<String, List<Portal_Giving_URL_Setting_Field__mdt>>();

        if (givingURLMetadataRecord == null) {
            return returnMap;
        }

        if (String.isNotBlank(givingURLMetadataRecord.Base_URL__c)) {
            returnMap.put(BASE_URL, givingURLMetadataRecord.Base_URL__c);
        }

        for (Portal_Giving_URL_Setting_Field__mdt currentGivingUrlSettingField : givingURLMetadataRecord.Portal_Giving_URL_Setting_Fields__r) {
            System.debug(currentGivingUrlSettingField);
            String sObjectApiName = currentGivingUrlSettingField.SObject_API_Name__c;

            if (String.isBlank(sObjectApiName)) {
                continue;
            }

            if (sObjectNameToFieldRecords.containsKey(sObjectApiName)) {
                List<Portal_Giving_URL_Setting_Field__mdt> currentFieldList = sObjectNameToFieldRecords.get(sObjectApiName);
                currentFieldList.add(currentGivingUrlSettingField);
            } else {
                sObjectNameToFieldRecords.put(sObjectApiName, new List<Portal_Giving_URL_Setting_Field__mdt>{currentGivingUrlSettingField});
            }
        }

        returnMap.put(CHILD_FIELD_RECORDS, sObjectNameToFieldRecords);

        return returnMap;
    }

    /**
     * Combines getGivingURLSettings and generateGivingURLSettingsMap functions to allow both to be called from one function.
     *
     * @param               parentName                      Will match against the labels of all Portal Giving URL Setting records.
     * @param               queryFilter                     Narrows down related Portal Giving URL Setting Field by filtering on the query filter field.
     * @return                                              {BASE_URL => Base URL, CHILD_FIELD_RECORDS => {sObject name => List<Portal Giving URL Setting Field record>}}.
     * @version                                             1.0
     * @since                                               1.0
     */
    global static Map<String, Object> getGivingURLSettingsMap(String parentName, String queryFilter) {
        Portal_Giving_URL_Setting__mdt givingURLMetadataRecord = getGivingURLSettings(parentName, queryFilter);
        return generateGivingURLSettingsMap(givingURLMetadataRecord);
    }

    /**
     * Converts a list of sObjects into a map of sObject Name to map of field Api name to field value.
     *
     * @param               sObjects                        List of sObjects to convert.
     * @return                                              {sObject api name => {Field Api Name => Field value}}
     * @version                                             1.0
     * @since                                               1.0
     */
    global static Map<String, Map<String, Object>> generateSObjectMap(List<sObject> sObjects) {
        Map<String, Map<String, Object>> sObjectNameTosObject = new Map<String, Map<String, Object>>();

        for (sObject currentSObject : sObjects) {
            Map<String, Object> fieldMap = currentSObject.getPopulatedFieldsAsMap();

            // id is needed
            if (fieldMap.get('Id') == null) {
                continue;
            }

            Id sobjectFieldId = (Id)fieldMap.get('Id');

            String sObjectApiName = sobjectFieldId.getSObjectType().getDescribe().getName();

            sObjectNameTosObject.put(sObjectApiName, fieldMap);
        }

        return sObjectNameTosObject;
    }

    /**
     * Converts a sObjects into a map of sObject Name to map of field Api name to field value.
     *
     * @param               sObjects                        sObject to convert.
     * @return                                              {sObject api name => {Field Api Name => Field value}}
     * @version                                             1.0
     * @since                                               1.0
     */
    global static Map<String, Map<String, Object>> generateSObjectMap(sObject sObjectRecord) {
        return generateSObjectMap(new List<sObject>{sObjectRecord});
    }

    /**
     * Generate giving URL based on a Portal Giving URL Setting record and formatted sObject records.
     *
     * @param               givingURLSettingsMetadata       Map returned from generateGivingURLSettingsMap function. {BASE_URL => Base URL, CHILD_FIELD_RECORDS => {sObject name => List<Portal Giving URL Setting Field record>}}
     * @param               sObjectNameToFields             Map returned from generateSObjectMap. {sObject api name => {Field Api Name => Field value}}.
     * @return                                              Giving url string.
     * @version                                             1.0
     * @since                                               1.0
     */
    global static String createGivingURL(Map<String, Object> givingURLSettingsMetadata,
                                            Map<String, Map<String, Object>> sObjectNameToFields) {

        if (givingURLSettingsMetadata == null) {
            return '';
        }

        Map<String, List<Portal_Giving_URL_Setting_Field__mdt>> sObjectNameToGivingURLSettingFields = (Map<String, List<Portal_Giving_URL_Setting_Field__mdt>>)givingURLSettingsMetadata.get(CHILD_FIELD_RECORDS);


        String givingURL = (String)givingURLSettingsMetadata.get(BASE_URL);

        if (String.isBlank(givingURL)) {
            return '';
        }

        if (sObjectNameToGivingURLSettingFields == null || sObjectNameToFields == null) {
            return givingURL;
        }

        List<String> urlParams = new List<String>();

        for (String sObjectApiName : sObjectNameToGivingURLSettingFields.keySet()) {
            Map<String, Object> baseSobjectFieldValues = sObjectNameToFields.get(sObjectApiName);
            List<Portal_Giving_URL_Setting_Field__mdt> givingURLSettingFields = sObjectNameToGivingURLSettingFields.get(sObjectApiName);


            if (baseSobjectFieldValues == null || givingURLSettingFields.isEmpty()) {
                continue;
            }

            // loop through giving url fields and get its associated value
            for (Portal_Giving_URL_Setting_Field__mdt currentGivingUrlSettingField : givingURLSettingFields) {
                Map<String, Object> currentSobjectFieldValues = baseSobjectFieldValues.clone();
                String fieldApiName = (String)currentGivingUrlSettingField.Field_API_Name__c;
                String staticValue = (String)currentGivingUrlSettingField.Static_Field_Value__c;
                String urlParamName = (String)currentGivingUrlSettingField.URL_parameter_Name__c;

                if (String.isBlank(urlParamName)) {
                    continue;
                }

                if (String.isNotBlank(staticValue)) {
                    urlParams.add(currentGivingUrlSettingField.URL_parameter_Name__c + '=' + EncodingUtil.urlEncode(staticValue,'UTF-8'));
                    continue;
                }

                if (String.isBlank(fieldApiName)) {
                    continue;
                }

                String fieldValue = '';

                // if field is field on a related object.
                if (fieldApiName.contains('.')) {
                    List<String> fieldApiNamePortions = fieldApiName.split('\\.');
                    String lastFieldApiName = fieldApiNamePortions.remove(fieldApiNamePortions.size() - 1);

                    // last one isn't a map
                    for (String currentFieldApiNamePortion : fieldApiNamePortions) {

                        if (currentSobjectFieldValues.get(currentFieldApiNamePortion) == null) {
                            currentSobjectFieldValues = null;
                            break;
                        }

                        currentSobjectFieldValues = ((sObject)currentSobjectFieldValues.get(currentFieldApiNamePortion)).getPopulatedFieldsAsMap();
                    }

                    if (currentSobjectFieldValues == null) {
                        continue;
                    }

                    fieldValue = (String)currentSobjectFieldValues.get(lastFieldApiName);

                } else {
                    fieldValue = (String)currentSobjectFieldValues.get(fieldApiName);
                }

                if (String.isBlank(fieldValue)) {
                    continue;
                }

                urlParams.add(currentGivingUrlSettingField.URL_parameter_Name__c + '=' + EncodingUtil.urlEncode(fieldValue,'UTF-8'));
            }
        }


        if (!urlParams.isEmpty()) {
            givingURL += '?' + String.join(urlParams, '&');
        }

        return givingURL;
    }
}