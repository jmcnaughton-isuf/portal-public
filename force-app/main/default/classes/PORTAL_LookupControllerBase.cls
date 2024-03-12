/**
  * Base class containing logic for the lookup field
  *
  * @author Aaron Wong
  * @version     1.0
  * @since       1.0
  */
  global without sharing virtual class PORTAL_LookupControllerBase {
    public static final String OBJECT_API_NAME_FIELD = 'objectApiNameField';
    public static final String FIELD_API_NAME_FIELD = 'fieldApiNameField';
    public static final String FILTER_CLAUSE_FIELD = 'filterClauseField';
    public static final String STATIC_LIST_FIELD = 'staticListField';
    public static final String STATIC_LIST = 'staticList';
    public static final String LABEL_CONST = 'label';
    public static final String VALUE_CONST = 'value';
    public static final String OBJECT_API_NAME = 'objectApiName';
    public static final String FIELD_API_NAME = 'fieldApiName';
    public static final String FILTER_CLAUSE = 'filterClause';
    public static final String IS_PICKLIST = 'isPicklist';
    public static final String DISPLAY_SETTING_LIST = 'displaySettingList';
    public static final String CUSTOM_METADATA_API_NAME = 'customMetadataApiName';
    public static final String SEARCH_TEXT = 'searchText';
    public static final String MAX_ITEMS = 'maxItems';
    public static final String CUSTOM_METADATA_DEVELOPER_NAME = 'customMetadataDeveloperName';

    private static Map<String, Map<String, String>> metadataNameToFieldMap = new Map<String, Map<String, String>>{
        'Portal_Directory_Search_Display_Setting__mdt' => new Map<String, String>{
            OBJECT_API_NAME_FIELD => 'Object_Api_Name__c',
            FIELD_API_NAME_FIELD => 'Field_Api_Name__c',
            FILTER_CLAUSE_FIELD => 'Filter_Clause__c'
        },
        'Portal_Section_Field_Setting__mdt' => new Map<String, String>{
            OBJECT_API_NAME_FIELD => 'Lookup_SObject_Name__c',
            FIELD_API_NAME_FIELD => 'Lookup_Field_Name__c',
            FILTER_CLAUSE_FIELD => 'Lookup_Filter_Clause__c',
            STATIC_LIST_FIELD => 'Static_Available_Values__c'
        }
    };

    /**
     * Gets the lookup options for all the display settings provided.
     *
     * @author Aaron Wong
     * @param displaySettingList    List of display settings used to get lookup options.
     * @param searchText            Text to filter the lookup options by.
     * @param maxItems              Max number of options to return.
     * @return                      The list of lookup options.
     * @since                       1.0
     */
    global virtual List<Object> getAllLookupOptions(Map<String, Object> params) {
        List<Object> displaySettingList = (List<Object>)params.get(DISPLAY_SETTING_LIST);
        String customMetadataApiName = (String)params.get(CUSTOM_METADATA_API_NAME);
        String searchText = (String)params.get(SEARCH_TEXT);
        Integer maxItems = Integer.valueOf((Decimal)params.get(MAX_ITEMS));

        List<Object> picklistValues = new List<Object>();

        for (Object displaySetting : displaySettingList) {
            Map<Object, Object> displaySettingMap = (Map<Object, Object>)displaySetting;
            Map<String, String> queryInfoMap = getQueryInfoMap((String)displaySettingMap.get(CUSTOM_METADATA_DEVELOPER_NAME), customMetadataApiName);

            if (queryInfoMap.containsKey(STATIC_LIST) && String.isNotBlank(queryInfoMap.get(STATIC_LIST))) {
                if (picklistValues.size() == maxItems) {
                    return picklistValues;
                }

                Integer itemsLeft = maxItems == null ? null : maxItems - picklistValues.size();
                picklistValues.addAll(getPicklistValuesFromQueryInfoMap(queryInfoMap, searchText, itemsLeft));
            
            } else {
                picklistValues.addAll(getLookupOptions(queryInfoMap.get(OBJECT_API_NAME), queryInfoMap.get(FIELD_API_NAME), queryInfoMap.get(FILTER_CLAUSE), searchText, (Boolean)displaySettingMap.get(IS_PICKLIST), maxItems));
            }
        }

        return picklistValues;
    }

    @TestVisible
    private static List<Object> getPicklistValuesFromQueryInfoMap(Map<String, String> queryInfoMap,
                                                            String searchText,
                                                            Integer maxItems) {
        List<Object> picklistValues = new List<Object>();
        String newLineChar = '\n';

        if (queryInfoMap.get(STATIC_LIST).contains('\r\n')) {
            newLineChar = '\r\n';
        } 

        List<String> staticList = queryInfoMap.get(STATIC_LIST).split(newLineChar);
        for (String eachEntry : staticList) {
            //split the entries by label value pairs
            Map<String, String> fieldValuePair = new Map<String, String>();

            List<String> fieldValueList = eachEntry.split(';');

            if (fieldValueList.isEmpty() 
                    || (String.isNotBlank(searchText) && !fieldValueList.get(0).contains(searchText))) {
                continue;
            } else if (fieldValueList.size() == 1) {
                fieldValuePair.put(LABEL_CONST, fieldValueList.get(0));
                fieldValuePair.put(VALUE_CONST, fieldValueList.get(0));
            } else {
                fieldValuePair.put(LABEL_CONST, fieldValueList.get(0));
                fieldValuePair.put(VALUE_CONST, fieldValueList.get(1));
            }

            if (picklistValues.size() == maxItems) {
                return picklistValues;
            }

            picklistValues.add(fieldValuePair);
        }

        return picklistValues;
    }

    /**
     * Gets the lookup options with the information provided.
     *
     * @author Aaron Wong
     * @param objectApiName     API name of the object to get options for.
     * @param fieldApiName      API name of the field on the object to filter on.
     * @param filterClause      Additional SOQL query clause.
     * @param searchText        Text to filter the lookup options by.
     * @param isPicklist        Determines if the options are being pulled from a defined picklist in Salesforce.
     * @param maxItems          Max number of options to return.
     * @return                  The list of lookup options.
     * @since                   1.0uh
     */
    public static List<Object> getLookupOptions(String objectApiName,
                                                String fieldApiName,
                                                String filterClause,
                                                String searchText,
                                                Boolean isPicklist,
                                                Integer maxItems){
        if (isPicklist == true) {
            List<Map<String, String>> picklistValues = new List<Map<String, String>>();
            Schema.SObjectType objectType = PORTAL_SObjectInfoPool.getInstance().getSObjectType(objectApiName);
            List<Schema.PicklistEntry> picklistEntries = objectType.getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPicklistValues();
            for (Schema.PicklistEntry picklistEntry : picklistEntries) {
                if (picklistEntry.getValue().containsIgnoreCase(searchText)) {
                    Map<String, String> newPicklistMap = new Map<String, String>();

                    newPicklistMap.put(LABEL_CONST, picklistEntry.getLabel());
                    newPicklistMap.put(VALUE_CONST, PicklistEntry.getValue());

                    picklistValues.add(newPicklistMap);
                    if (picklistValues.size() == maxItems) {
                        break;
                    }
                }

            }
            return picklistValues;
        }

       Id userId = UserInfo.getUserId();

        User usr = [SELECT Id,
                    ContactId,
                    ucinn_portal_Recommend_Type_1__c, ucinn_portal_Recommend_Type_2__c, ucinn_portal_Recommend_Type_3__c
                    FROM User
                    WHERE Id = :userId];

        String userContactId = usr.ContactId;

        if (userContactId == null) {
            userContactId = '';
        }

        String queryString = 'SELECT id, ' + fieldApiName + ' FROM ' + objectApiName + ' ';
        String whereClausePrefix = ' WHERE ';

        if (String.isNotBlank(searchText)) {
            queryString = queryString + whereClausePrefix + fieldApiName + ' LIKE \'' + searchText + '%\'';
            whereClausePrefix = ' AND ';
        }

        if (!String.isBlank(filterClause)) {
            queryString = queryString + whereClausePrefix + filterClause + ' ';
            whereClausePrefix = ' AND ';
        }

        if (maxItems != null) {
            queryString = queryString + ' LIMIT ' + maxItems;
        }

        System.debug(queryString);

        return Database.query(queryString);
    }

    public static Map<String, String> getQueryInfoMap(String customMetadataDeveloperName,
                                                      String customMetadataApiName) {
        Map<String, String> resultMap = new Map<String, String>();

        if (!metadataNameToFieldMap.containsKey(customMetadataApiName)
                || String.isBlank(customMetadataDeveloperName)) {
            return resultMap;
        }

        Map<String, String> fieldApiNameMap = metadataNameToFieldMap.get(customMetadataApiName);

        String objectApiNameField = fieldApiNameMap.get(OBJECT_API_NAME_FIELD);
        String fieldApiNameField = fieldApiNameMap.get(FIELD_API_NAME_FIELD);
        String filterClauseField = fieldApiNameMap.get(FILTER_CLAUSE_FIELD);
        String staticListField = fieldApiNameMap.get(STATIC_LIST_FIELD);

        String queryString = 'SELECT ';
        String fields = 'id, ' + objectApiNameField + ', ' + fieldApiNameField + ', ' + filterClauseField + ' ';
        String whereClause = ' WHERE DeveloperName = \'' + customMetadataDeveloperName + '\'';

        if (String.isNotBlank(staticListField)) {
            fields = fields + ', ' + staticListField + ' ';
        }

        queryString = queryString + fields + 'FROM ' + customMetadataApiName + whereClause;

        List<SObject> metadataList = Database.query(queryString);

        if (metadataList == null || metadataList.isEmpty()) {
            return resultMap;
        }

        resultMap.put(OBJECT_API_NAME, (String)metadataList.get(0).get(objectApiNameField));
        resultMap.put(FIELD_API_NAME, (String)metadataList.get(0).get(fieldApiNameField));
        resultMap.put(FILTER_CLAUSE, (String)metadataList.get(0).get(filterClauseField));

        if (String.isNotBlank(staticListField)) {
            resultMap.put(STATIC_LIST, (String)metadataList.get(0).get(staticListField));
        }

        System.debug(resultMap);

        return resultMap;
    }
}