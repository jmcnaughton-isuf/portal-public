public without sharing class PORTAL_LookupController {
    @AuraEnabled
    public static List<Object> SERVER_getLookupOptions(List<Map<String, Object>> displaySettingList,
                                                       String searchText,
                                                       Integer maxItems) {
        List<Object> picklistValues = new List<Object>();

        for (Map<String, Object> displaySetting : displaySettingList) {
            picklistValues.addAll(getLookupOptions((String)displaySetting.get('objectApiName'), (String)displaySetting.get('fieldApiName'), (String)displaySetting.get('filterClause'), searchText, (Boolean)displaySetting.get('isPicklist'), maxItems));
        }

        return picklistValues;
    }

    @AuraEnabled
    public static List<sObject> SERVER_getDefaultLookupOptions(String filterClause, String sObjectName, String field, String orderBy, Integer maxItems) {
        if (String.isNotBlank(filterClause) && String.isNotBlank(sObjectName) && String.isNotBlank(field)) {
            String queryString = 'SELECT Id, ' + field + ' FROM ' + sObjectName + ' ' + filterClause ;
            if (String.isNotBlank(orderBy)) {
                queryString = queryString + ' ORDER BY ' + orderBy;
            }
            queryString = queryString + ' LIMIT ' + maxItems;
            return Database.query(queryString);
        } else {
            return new List<sObject>();
        }
    }

    private static List<Object> getLookupOptions(String objectApiName, String fieldApiName, String filterClause, String searchText, Boolean isPicklist, Integer maxItems){
        if (isPicklist == true) {
            List<Map<String, String>> picklistValues = new List<Map<String, String>>();
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
            List<Schema.PicklistEntry> picklistEntries = objectType.getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPicklistValues();
            for (Schema.PicklistEntry picklistEntry : picklistEntries) {
                if (picklistEntry.getValue().containsIgnoreCase(searchText)) {
                    Map<String, String> newPicklistMap = new Map<String, String>();

                    newPicklistMap.put('label', picklistEntry.getLabel());
                    newPicklistMap.put('value', PicklistEntry.getValue());

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

        String queryString = 'SELECT id, ' + fieldApiName + ' FROM ' + objectApiName + ' WHERE ' + fieldApiName + ' LIKE \'' + searchText + '%\'';
        if (!String.isBlank(filterClause)) {
            queryString = queryString + ' AND ' + filterClause + ' ';
        }

        if (maxItems != null) {
            queryString = queryString + ' LIMIT ' + maxItems;
        }

        return Database.query(queryString);
    }
}