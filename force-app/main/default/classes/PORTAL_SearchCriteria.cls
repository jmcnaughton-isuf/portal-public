/**
 * This class is equivalent to a Search Criteria in the Directory. It is used to capture
 * passed in data from the portal_Directory LWC.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing class PORTAL_SearchCriteria {
    public static final String SEARCH_FOR_SELECTED = 'searchForSelected';
    public static final String ADDRESS_LIST = 'addressList';
    public static final String VALUE_LIST = 'valueList';

    @AuraEnabled
    public String searchForSelected {get; set;}                         // The name of the search criteria
    @AuraEnabled
    public List<PORTAL_AddressWrapper> addressList {get; set;}                  // Any addresses inputted as values by the user
    @AuraEnabled
    public List<String> valueList {get; set;}                               // List of user input values

    public PORTAL_SearchCriteria() {}

    public PORTAL_SearchCriteria(String searchForSelected) {
        this.searchForSelected = searchForSelected;
    }

    public PORTAL_SearchCriteria(String searchForSelected, String value) {
        this.searchForSelected = searchForSelected;
        this.valueList = new List<String>();
        this.valueList.add(value);
    }

    public PORTAL_SearchCriteria(String searchForSelected, List<String> value) {
        this.searchForSelected = searchForSelected;
        this.valueList = value;
    }

    public PORTAL_SearchCriteria(Object objectRecord) {
        if (objectRecord == null) {
            return;
        }

        Map<Object, Object> objectMap = (Map<Object, Object>)objectRecord;

        this.searchForSelected = (String)objectMap.get(SEARCH_FOR_SELECTED);

        if (objectMap.get(ADDRESS_LIST) != null) {
            this.addressList = new List<PORTAL_AddressWrapper>();

            for (Object eachAddressObject : (List<Object>)objectMap.get(ADDRESS_LIST)) {
                this.addressList.add(new PORTAL_AddressWrapper(eachAddressObject));
            }
        }

        if (objectMap.get(VALUE_LIST) != null) {
            this.valueList = new List<String>();

            for (Object eachValueObject : (List<Object>)objectMap.get(VALUE_LIST)) {
                this.valueList.add((String)eachValueObject);
            }
        }
    }

    /**
     * Gets the query string used for filter caches.
     *
     * @author Aaron Wong
     *
     * @param cacheApiName      The cache api name for the caches to query.
     * @return                  The query string.
     * @since                   1.0
     */
    public String getFilterCacheQueryString(String cacheApiName) {
        if (String.isBlank(cacheApiName)) {
            return '';
        }

        String queryString = 'SELECT ';
        String fields = ' Contact_Id_Cache_1__c, Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c, Contact_Id_Cache_6__c, Contact_Id_Cache_7__c, '
                      + ' Contact_Id_Cache_8__c, Contact_Id_Cache_9__c, Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c, Cache_API_Name__c, Filter_Value__c, Order_Number__c ';
        String whereClause = ' WHERE (Cache_API_Name__c = \'' + String.escapeSingleQuotes(cacheApiName) + '\' ';
        String orderClause = ' ORDER By Order_Number__c ASC ';

        if (this.valueList != null && !String.isBlank(this.valueList.get(0))) {
            whereClause = whereClause + ' AND Filter_Value__c = \'' + String.escapeSingleQuotes(this.valueList.get(0)) + '\' ';
        }

        whereClause = whereClause + ') OR Cache_Api_Name__c = \'Dummy_Cache\' ';

        queryString = queryString + fields + ' FROM ucinn_portal_Search_Filter_Cache__c ' + whereClause + orderClause;

        return queryString;

    }
}