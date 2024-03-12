/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Class containing logic specific to the directory search.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
public inherited sharing virtual class PORTAL_DirectorySearch {
    private static final String CITY_CONST = 'city';
    private static final String STATE_CONST = 'state';
    private static final String COUNTRY_CONST = 'country';
    private static final String POSTAL_CODE = 'Postal Code';
    private static final String DISTANCE_CONST = 'DISTANCE';
    private static final String TRUE_CONST = 'true';

    private List<PORTAL_SearchCategory> categoryList;
    private List<PORTAL_SearchCriteria> cachedCriteriaList;
    private String zoneName;
    private Integer maxContacts = 150;

    private Map<String, Portal_Directory_Search_Criteria__mdt> nameToSearchCriteriaMetadataMap;
    private PORTAL_GeolocationHub geolocationHub;
    private Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String> addressFieldMapping;

    /**
     * Constructor for the directory seach.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    private PORTAL_DirectorySearch(){}

    /**
     * Builder class for the class.
     *
     * @author  Aaron Wong
     * @version 1.0
     * @since   1.0
     */
    public class Builder {
        private PORTAL_DirectorySearch result;

        /**
         * Constructor for the builder.
         *
         * @author Aaron Wong
         * @since  1.0
         */
        public Builder() {
            this.result = new PORTAL_DirectorySearch();
        }

        /**
         * Sets the category list for the end PORTAL_DirectorySearchClass.
         *
         * @author Aaron Wong
         *
         * @param categoryList      Category List to set.
         * @return                  The same instance of the builder.
         * @since                   1.0
         */
        public Builder buildCategoryList(List<PORTAL_SearchCategory> categoryList) {
            this.result.categoryList = categoryList;
            return this;
        }

        /**
         * Sets the cached criteria list for the end PORTAL_DirectorySearchClass.
         *
         * @author Aaron Wong
         *
         * @param cachedCriteriaList    Cached criteria list to set.
         * @return                      The same instance of the builder.
         * @since                       1.0
         */
        public Builder buildCachedCriteriaList(List<PORTAL_SearchCriteria> cachedCriteriaList) {
            this.result.cachedCriteriaList = cachedCriteriaList;
            return this;
        }

        /**
         * Sets the max contacts for the end PORTAL_DirectorySearchClass.
         *
         * @author Aaron Wong
         *
         * @param maxContacts       Max Contacts to set.
         * @return                  The same instance of the builder.
         * @since                   1.0
         */
        public Builder buildMaxContacts(Integer maxContacts) {
            if (maxContacts != null && maxContacts > 0) {
                this.result.maxContacts = maxContacts;
            }
            return this;
        }

        /**
         * Sets the zone name for the end PORTAL_DirectorySearchClass.
         *
         * @author Aaron Wong
         *
         * @param zoneName          Zone Name to set.
         * @return                  The same instance of the builder.
         * @since                   1.0
         */
        public Builder buildZoneName(String zoneName) {
            this.result.zoneName = zoneName;
            return this;
        }

        /**
         * Builds the PORTAL_DirectorySearch class.
         *
         * @author Aaron Wong
         *
         * @return  The directory search class.
         * @since   1.0
         */
        public PORTAL_DirectorySearch build() {
            this.result.intializeSearch();
            return this.result;
        }
    }

    /**
     * Performs the directory search.
     *
     * @author Aaron Wong
     *
     * @return  Set of constituent Ids.
     * @since   1.0
     */
    public virtual Set<String> performSearch() {
        Set<String> resultSet = new Set<String>();

        if (this.categoryList == null) {
            this.categoryList = new List<PORTAL_SearchCategory>();
        }

        if (this.cachedCriteriaList == null || this.cachedCriteriaList.size() == 0) {
            return this.queryContactIdsFromSearchCategories(null);
        }

        this.sortCachedCriteriaList();

        if (String.isBlank(nameToSearchCriteriaMetadataMap.get(this.cachedCriteriaList.get(0).searchForSelected).Cache_Api_Name__c)) {
            return this.parseContactIdsFromSearch(getNonCachedContactIds(this.cachedCriteriaList.get(0), null));
        }

        // Get first criteria in list and its corresponding search setting
        PORTAL_SearchCriteria firstCriteria = this.cachedCriteriaList.get(0);
        Portal_Directory_Search_Criteria__mdt firstSearchCriteriaMetadata = this.nameToSearchCriteriaMetadataMap.get(firstCriteria.searchForSelected);

        for (ucinn_portal_Search_Filter_Cache__c firstFilterCacheRecord : Database.query(firstCriteria.getFilterCacheQueryString(firstSearchCriteriaMetadata.Cache_API_Name__c))) {
            if (String.isBlank(firstFilterCacheRecord.Contact_Id_Cache_1__c)) {
                continue;
            }

            // Store the contactIds in the iteration
            Set<String> contactIdsInIteration = getContactIdSetFromCache(firstFilterCacheRecord);

            // Free up heap space after storing into a set
            firstFilterCacheRecord = null;

            contactIdsInIteration = filterContactIdsUsingCachedSearchCriteria(contactIdsInIteration);

            if (!this.categoryList.isEmpty() && !contactIdsInIteration.isEmpty()) {
                contactIdsInIteration = this.queryContactIdsFromSearchCategories(contactIdsInIteration);
            }

            resultSet.addAll(contactIdsInIteration);

            if (resultSet.size() >= this.maxContacts) {
                break;
            }
        }

        resultSet = this.parseContactIdsFromSearch(resultSet);

        return resultSet;
    }


    /**
     * Post-processes the contact ids that are returned from the Directory Search.
     *
     * @author Aaron Wong
     * @param contactIdSet  Set of contact Ids from the contacts returned by the Directory Search.
     * @return              Set of parsed contact Ids.
     * @since               1.0
     */
    @TestVisible
    protected virtual Set<String> parseContactIdsFromSearch(Set<String> contactIdSet) {
        Set<String> resultSet = new Set<String>();

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return resultSet;
        }

        if (this.maxContacts == null) {
            return contactIdSet;
        }

        for (String eachContactId : contactIdSet) {
            resultSet.add(eachContactId);
            if (resultSet.size() == this.maxContacts) {
                return resultSet;
            }
        }

        return resultSet;
    }

    /**
     * Factory method for the geolocation hub.
     *
     * @author Aaron Wong
     *
     * @return  The geolocation hub.
     * @since   1.0
     */
    protected virtual PORTAL_GeolocationHub getGeolocationHub() {
        if (this.geolocationHub == null) {
            this.geolocationHub = new PORTAL_GeolocationHub();
        }

        return this.geolocationHub;
    }

    /**
     * Sorts the search criteria list provided to maximize efficiency for the Directory Search algorithm.
     * All cached search criteria with one value will be first, then cached search criteria with multiple values.
     * Non-cached search criteria will be at the end of the list.
     *
     * @author Aaron Wong
     * @return                                  The sorted list of search criteria.
     * @since                                   1.0
     */
    private List<PORTAL_SearchCriteria> sortCachedCriteriaList() {
        if (this.cachedCriteriaList == null || this.cachedCriteriaList.isEmpty() || this.nameToSearchCriteriaMetadataMap.isEmpty()) {
            return this.cachedCriteriaList;
        }

        Set<PORTAL_SearchCriteria> singleValueCriteriaList = new Set<PORTAL_SearchCriteria>();
        Set<PORTAL_SearchCriteria> multipleValueCriteriaList = new Set<PORTAL_SearchCriteria>();
        Set<PORTAL_SearchCriteria> nonCachedCriteriaList = new Set<PORTAL_SearchCriteria>();

        List<PORTAL_SearchCriteria> sortedSearchCriteriaList = new List<PORTAL_SearchCriteria>();

        // Pre-process search criteria list into 3 seperate list
        for (PORTAL_SearchCriteria eachCriteria : this.cachedCriteriaList) {
            if (!nameToSearchCriteriaMetadataMap.containsKey(eachCriteria.searchForSelected)) {
                continue;
            }

            Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata = nameToSearchCriteriaMetadataMap.get(eachCriteria.searchForSelected);

            if ((eachCriteria.valueList == null || eachCriteria.valueList.size() == 0) && (eachCriteria.addressList == null || eachCriteria.addressList.size() == 0)) {
                continue;
            } else if (String.isBlank(searchCriteriaMetadata.Cache_Api_Name__c)) {
                nonCachedCriteriaList.add(eachCriteria);
            } else if (eachCriteria.valueList != null && eachCriteria.valueList.size() > 1) {
                multipleValueCriteriaList.add(eachCriteria);
            } else if (eachCriteria.valueList.size() == 1) {
                singleValueCriteriaList.add(eachCriteria);
            }
        }

        sortedSearchCriteriaList.addAll(singleValueCriteriaList);
        sortedSearchCriteriaList.addAll(multipleValueCriteriaList);
        sortedSearchCriteriaList.addAll(nonCachedCriteriaList);

        this.cachedCriteriaList = sortedSearchCriteriaList;

        return this.cachedCriteriaList;
    }

    /**
     * Initializes the search class.
     *
     * @author Aaron Wong
     * @since                       1.0
     */
    private void intializeSearch() {
        Map<String, Portal_Directory_Search_Criteria__mdt> nameToSearchCriteriaMetadataMap = new Map<String, Portal_Directory_Search_Criteria__mdt>();

        List<Portal_Directory_Search_Criteria__mdt> searchCriteriaList = PORTAL_UTIL_Directory.filterSearchCriteriaByZone(PORTAL_UTIL_Directory.getSearchCriteriaMetadataList(), this.zoneName);

        if (this.cachedCriteriaList == null) {
            this.cachedCriteriaList = new List<PORTAL_SearchCriteria>();
        }

        this.cachedCriteriaList.addAll(getDefaultScopeSearchCriteriaList(searchCriteriaList));

        // Populate map of name to search setting
        for (Portal_Directory_Search_Criteria__mdt eachSearchCriteria : searchCriteriaList) {
            nameToSearchCriteriaMetadataMap.put(eachSearchCriteria.Search_Criteria_Name__c, eachSearchCriteria);
        }

        this.nameToSearchCriteriaMetadataMap = nameToSearchCriteriaMetadataMap;
    }

    /**
     * Filters the contact Ids using the Cached Criteria List.
     *
     * @author Aaron Wong
     *
     * @param contactIdSet      Contact Ids to filter.
     * @return                  Set of filtered contact Ids.
     * @since                   1.0
     */
    private Set<String> filterContactIdsUsingCachedSearchCriteria(Set<String> contactIdSet) {
        Set<String> resultSet = contactIdSet;

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return resultSet;
        }

        // Skip first cached criteria since that's the criteria we are filtering
        for (Integer searchCriteriaIndex = 1; searchCriteriaIndex < this.cachedCriteriaList.size(); searchCriteriaIndex++) {
            PORTAL_SearchCriteria eachCriteria = this.cachedCriteriaList.get(searchCriteriaIndex);
            Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata = nameToSearchCriteriaMetadataMap.get(eachCriteria.searchForSelected);

            if (String.isBlank(searchCriteriaMetadata.Cache_API_Name__c)) {
                resultSet = getNonCachedContactIds(eachCriteria, resultSet);
            } else {
                resultSet = retainAllUsingContactIdCaches(resultSet, searchCriteriaMetadata.Cache_API_Name__c, eachCriteria);
            }

            if (resultSet.size() == 0) {
                break;
            }
        }

        return resultSet;
    }

    /**
     * Performs a retain all on a set of contact Ids with the given search criteria.
     *
     * @author Aaron Wong
     *
     * @param operatorSet               The operator set to perform the retain all on.
     * @param targetCacheApiName        The cache api name to get.
     * @param searchCriteria            The search criteria to use.
     * @return                          Set of contact Ids.
     * @since                           1.0
     */
    private Set<String> retainAllUsingContactIdCaches(Set<String> operatorSet,
                                                      String targetCacheApiName,
                                                      PORTAL_SearchCriteria searchCriteria) {
        Set<String> resultSet = new Set<String>();

        if (operatorSet == null || operatorSet.isEmpty() || String.isBlank(targetCacheApiName) || searchCriteria == null) {
            return resultSet;
        }

        for (ucinn_portal_Search_Filter_Cache__c eachCacheRecord : Database.query(searchCriteria.getFilterCacheQueryString(targetCacheApiName))) {
            if (String.isBlank(eachCacheRecord.Contact_Id_Cache_1__c)) {
                continue;
            }

            // Store the contactIds in the iteration
            Set<String> innerContactIdSet = getContactIdSetFromCache(eachCacheRecord);

            // Deallocate space from the heap
            eachCacheRecord = null;

            // Fun fact: Retain all is slower than a regular for loop and remove
            for (String contactId : innerContactIdSet) {
                if (!operatorSet.contains(contactId)) {
                    innerContactIdSet.remove(contactId);
                }
            }

            resultSet.addAll(innerContactIdSet);
        }

        return resultSet;
    }


    /**
     * Gets all contact Ids stored inside the cache record.
     *
     * @author Aaron Wong
     * @param cacheRecord   Cache record to get the ids from.
     * @return              Set of Ids stored in the cache.
     * @since               1.0
     */
    protected virtual Set<String> getContactIdSetFromCache(ucinn_portal_Search_Filter_Cache__c cacheRecord) {
        Set<String> contactIdSet = new Set<String>();

        // Generate set of first cache
        for (Integer fieldIndex = 1; fieldIndex <= 12; fieldIndex++) {
            String cacheFieldName = 'Contact_Id_Cache_' + fieldIndex + '__c';

            String cacheField = (String)cacheRecord.get(cacheFieldName);
            if (String.isNotBlank(cacheField)) {
                contactIdSet.addAll(cacheField.split(';'));
            }
            cacheRecord.put(cacheFieldName, '');
        }

        if (contactIdSet.contains('')) {
            contactIdSet.remove('');
        }

        return contactIdSet;
    }


    /**
     * Queries for contact Ids given a list of search groups. If contact Ids are present, the results of the query
     * will be limited to those contact Ids.
     *
     * @author Aaron Wong
     * @param searchGroupList                   List of search groups to use for the query.
     * @param contactIds                        Set of possible contact Ids.
     * @param nameToSearchCriteriaMetadataMap   Map of search criteria names to their custom metadata record.
     * @return                                  Set of queried contact IDs.
     * @since                                   1.0
     */
    public Set<String> queryContactIdsFromSearchCategories(Set<String> contactIds) {
        String queryString = '';
        String contactApiName = '';

        if ((this.categoryList == null || this.categoryList.isEmpty()) && contactIds != null) {
            return contactIds;
        }

        if (this.categoryList.size() == 3) {
            this.categoryList = this.swapCategoryListForQuery();

            contactApiName = this.nameToSearchCriteriaMetadataMap.get(this.categoryList.get(0).searchCriteriaList.get(0).searchForSelected).Portal_Directory_Search_Category__r.Contact_Id_Api_Name__c;

            List<String> subQueryStringList = new List<String>();
            subQueryStringList.add(getQueryStringForSearchCategory(this.categoryList.get(1), contactIds));
            subQueryStringList.add(getQueryStringForSearchCategory(this.categoryList.get(2), contactIds));

            queryString = getQueryStringForSearchCategory(this.categoryList.get(0), contactIds);

            queryString = queryString + ' AND ' + contactApiName + ' IN (' + subQueryStringList[0] + ') AND ' + contactApiName + ' IN (' + subQueryStringList[1] + ')';
        } else if (!this.categoryList.isEmpty()){
            contactApiName = 'id';
            queryString = ' SELECT id FROM Contact ';

            String whereClausePrefix = ' WHERE ';

            for (PORTAL_SearchCategory eachSearchCategory : this.categoryList) {
                if (eachSearchCategory.searchCriteriaList == null || eachSearchCategory.searchCriteriaList.isEmpty()) {
                    continue;
                }

                queryString = queryString + whereClausePrefix + ' id IN (' + this.getQueryStringForSearchCategory(eachSearchCategory, contactIds) + ') ';
                whereClausePrefix = ' AND ';
            }
        } else {
            contactApiName = 'Id';
            queryString = ' SELECT Id FROM Contact ';
        }

        List<SObject> objectList = Database.query(queryString + ' LIMIT ' + this.maxContacts);

        Set<String> queriedContactIds = new Set<String>();

        for (SObject objectRecord : objectList) {
            queriedContactIds.add((String)objectRecord.get(contactApiName));
        }

        return queriedContactIds;
    }

    /**
     * Swaps the category list for query string generation to bypass Semi-Join subselect limits.
     *
     * @author Aaron Wong
     *
     * @return  Swapped category list.
     * @since   1.0
     */
    private List<PORTAL_SearchCategory> swapCategoryListForQuery() {
        String firstObjectApiName = this.nameToSearchCriteriaMetadataMap.get(this.categoryList.get(0).searchCriteriaList.get(0).searchForSelected).Portal_Directory_Search_Category__r.Object_Api_Name__c;
        String secondObjectApiName = this.nameToSearchCriteriaMetadataMap.get(this.categoryList.get(1).searchCriteriaList.get(0).searchForSelected).Portal_Directory_Search_Category__r.Object_Api_Name__c;
        String thirdObjectApiName = this.nameToSearchCriteriaMetadataMap.get(this.categoryList.get(2).searchCriteriaList.get(0).searchForSelected).Portal_Directory_Search_Category__r.Object_Api_Name__c;

        // Need to swap categories so due to Semi-Join subselect governer limits (can't have semi-join subselect on the object being queried)
        if (firstObjectApiName == secondObjectApiName) {
            PORTAL_SearchCategory swappedSearchCategory = this.categoryList.get(2);
            this.categoryList.set(2, this.categoryList.get(0));
            this.categoryList.set(0, swappedSearchCategory);
        } else if (firstObjectApiName == thirdObjectApiName) {
            PORTAL_SearchCategory swappedSearchCategory = this.categoryList.get(1);
            this.categoryList.set(1, this.categoryList.get(0));
            this.categoryList.set(0, swappedSearchCategory);
        }

        return this.categoryList;
    }

    /**
     * Generates the query string used to query contacts for a specific Search Group.
     *
     * @author Aaron Wong
     * @param searchGroupRecord         Search Group to generate the query string for.
     * @param contactIds                Set of possible contact ids.
     * @param nameToSearchCriteriaMetadataMap   Map of search criteria names to their custom metadata record.
     * @return                          Generated query string.
     * @since                           1.0
     */
    private String getQueryStringForSearchCategory(PORTAL_SearchCategory searchCategoryRecord,
                                                   Set<String> contactIds) {
        String queryString = 'SELECT ';
        String whereClause = ' ';
        String whereClausePrefix = '';
        String contactApiName = '';

        searchCategoryRecord.searchCriteriaList = this.parseSearchCriteriaForAddresses(searchCategoryRecord.searchCriteriaList);

        for (PORTAL_SearchCriteria eachSearchCriteria : searchCategoryRecord.searchCriteriaList) {
            if (!nameToSearchCriteriaMetadataMap.containsKey(eachSearchCriteria.searchForSelected)) {
                continue;
            }

            Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata = nameToSearchCriteriaMetadataMap.get(eachSearchCriteria.searchForSelected);

            contactApiName = searchCriteriaMetadata.Portal_Directory_Search_Category__r.Contact_Id_Api_Name__c;

            String queryClause = getQueryClauseForSearchCriteria(eachSearchCriteria, searchCriteriaMetadata);

            if (String.isNotBlank(queryClause)) {
                whereClause = whereClause + whereClausePrefix + '(' + queryClause + ')';

                whereClausePrefix = ' AND ';
            }
        }

        queryString = queryString + contactApiName + ' FROM ' + searchCategoryRecord.objectApiName;

        if (contactIds != null && !contactIds.isEmpty()) {
            queryString = queryString + ' WHERE ' + contactApiName + ' IN :contactIds AND ' + whereClause;
        } else {
            queryString = queryString + ' WHERE ' + whereClause;
        }

        return queryString;
    }

    /**
     * Parses the search criteria for addresses, then sets the address list if found.
     *
     * @author Aaron Wong
     *
     * @param criteriaList      List of search criteria to parse.
     * @return                  List of parsed search criteria.
     * @since                   1.0
     */
    @TestVisible
    private List<PORTAL_SearchCriteria> parseSearchCriteriaForAddresses(List<PORTAL_SearchCriteria> criteriaList) {
        if (criteriaList == null || criteriaList.isEmpty()) {
            return criteriaList;
        }

        // Parse for geolocation
        for (PORTAL_SearchCriteria eachSearchCriteria : criteriaList) {
            Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata = nameToSearchCriteriaMetadataMap.get(eachSearchCriteria.searchForSelected);

            if (!isGeolocationSearchCriteria(searchCriteriaMetadata)) {
                continue;
            }

            this.addressFieldMapping = getAddressFieldMapping(criteriaList);
            eachSearchCriteria.addressList = getAddressListFromCriteriaList(eachSearchCriteria, criteriaList);
        }

        return criteriaList;
    }

    /**
     * Gets the address field mapping to be used during the search.
     *
     * @author Aaron wong
     *
     * @param criteriaList  List of search criteria
     * @return              The mapping of the address fields.
     * @since               1.0
     */
    private Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String> getAddressFieldMapping(List<PORTAL_SearchCriteria> criteriaList) {
        Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String> resultMap = new Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String>();

        for (PORTAL_SearchCriteria eachCriteria : criteriaList) {
            Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata = nameToSearchCriteriaMetadataMap.get(eachCriteria.searchForSelected);

            if (String.isBlank(searchCriteriaMetadata.Geolocation_Address_Input__c)) {
                continue;
            }

            String addressFieldApiName = searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r.get(0).Field_Api_Name__c;

            if (searchCriteriaMetadata.Geolocation_Address_Input__c == CITY_CONST) {
                resultMap.put(PORTAL_AddressWrapper.ADDRESS_FIELD.CITY, addressFieldApiName);
            } else if (searchCriteriaMetadata.Geolocation_Address_Input__c == COUNTRY_CONST) {
                resultMap.put(PORTAL_AddressWrapper.ADDRESS_FIELD.COUNTRY, addressFieldApiName);
            } else if (searchCriteriaMetadata.Geolocation_Address_Input__c == STATE_CONST) {
                resultMap.put(PORTAL_AddressWrapper.ADDRESS_FIELD.STATE, addressFieldApiName);
            } else if (searchCriteriaMetadata.Geolocation_Address_Input__c == POSTAL_CODE) {
                resultMap.put(PORTAL_AddressWrapper.ADDRESS_FIELD.POSTCODE, addressFieldApiName);
            } else if (searchCriteriaMetadata.Geolocation_Address_Input__c == DISTANCE_CONST) {
                resultMap.put(PORTAL_AddressWrapper.ADDRESS_FIELD.GEOLOCATION, addressFieldApiName);
            }
        }

        return resultMap;
    }

    /**
     * Gets a list of address wrappers with the given search criteria.
     *
     * @author Aaron Wong
     *
     * @param distanceCriteria      The distance search criteria.
     * @param addressCriteriaList   List of address field search criteria.
     * @return                      List of address wrappers.
     * @since                       1.0
     */
    private List<PORTAL_AddressWrapper> getAddressListFromCriteriaList(PORTAL_SearchCriteria distanceCriteria,
                                                                       List<PORTAL_SearchCriteria> addressCriteriaList) {
        List<PORTAL_AddressWrapper> resultList = new List<PORTAL_AddressWrapper>();

        for (Integer valueIndex = 0; valueIndex < distanceCriteria.valueList.size(); valueIndex++) {
            PORTAL_AddressWrapper newAddress = createAddressWrapperFromCriteriaList(addressCriteriaList, valueIndex);
            resultList.add(newAddress);

            // TODO: move make sure there are no emptu values
            addressCriteriaList = removeStringValuesFromCriteriaList(addressCriteriaList, valueIndex);
        }

        return resultList;
    }

    /**
     * Creates an address wrapper from the given search criteria list.
     *
     * @author Aaron Wong
     *
     * @param addressCriteriaList   List of address search criteria.
     * @param valueIndex            Index of the value list for each criteria to grab.
     * @return                      An address wrapper.
     */
    private PORTAL_AddressWrapper createAddressWrapperFromCriteriaList(List<PORTAL_SearchCriteria> addressCriteriaList,
                                                                       Integer valueIndex) {
        PORTAL_AddressWrapper resultAddress = new PORTAL_AddressWrapper();

        for (PORTAL_SearchCriteria eachAddressCriteria : addressCriteriaList) {
            Portal_Directory_Search_Criteria__mdt addressCriteriaMetadata = this.nameToSearchCriteriaMetadataMap.get(eachAddressCriteria.searchForSelected);
            if (String.isBlank(addressCriteriaMetadata.Geolocation_Address_Input__c)) {
                continue;
            }

            resultAddress = this.populateAddressWrapperField(resultAddress,
                                                             eachAddressCriteria.valueList.get(valueIndex),
                                                             addressCriteriaMetadata.Geolocation_Address_Input__c);
        }

        return resultAddress;
    }

    /**
     * Populates the appropriate field on the address wrapper.
     *
     * @author Aaron Wong
     *
     * @param addressWrapper    Address wrapper to populate.
     * @param value             Value to use.
     * @param fieldType         Field on address wrapper to populate.
     * @return                  The populated address wrapper.
     * @since                   1.0
     */
    protected virtual PORTAL_AddressWrapper populateAddressWrapperField(PORTAL_AddressWrapper addressWrapper,
                                                                        String value,
                                                                        String fieldType) {
        if (addressWrapper == null) {
            return addressWrapper;
        }

        if (fieldType == CITY_CONST) {
            addressWrapper.city = value;
        } else if (fieldType == COUNTRY_CONST) {
            addressWrapper.country = value;
        } else if (fieldType == STATE_CONST) {
            addressWrapper.state = value;
        } else if (fieldType == POSTAL_CODE) {
            addressWrapper.postalCode = value;
        } else if (fieldType == DISTANCE_CONST) {
            addressWrapper.distance = value;
        }

        return addressWrapper;
    }

    // TODO: comment
    private List<PORTAL_SearchCriteria> removeStringValuesFromCriteriaList(List<PORTAL_SearchCriteria> addressCriteriaList,
                                                                           Integer valueIndex) {
        for (PORTAL_SearchCriteria eachCriteria : addressCriteriaList) {
            eachCriteria.valueList.remove(valueIndex);
        }

        return addressCriteriaList;
    }

    /**
     * Generates the query clause for a given search criteria.
     *
     * @author Aaron Wong
     * @param criteria                  The user inputted search criteria.
     * @param searchCriteriaMetadata    The Search Criteria's custom metadata record.
     * @return                          Query clause for the search criteria.
     * @since                           1.0
     */
    public String getQueryClauseForSearchCriteria(PORTAL_SearchCriteria searchCriteria,
                                                  Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata) {
        String queryClause = '';

        if (searchCriteria == null || searchCriteriaMetadata == null) {
            return queryClause;
        }

        Portal_Directory_Search_Category__mdt searchCategoryMetadata = searchCriteriaMetadata.Portal_Directory_Search_Category__r;

        List<String> criteriaValues = searchCriteria.valueList;

        if (searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r == null || searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r.isEmpty()) {
            return queryClause;
        }

        List<Portal_Directory_Search_Query_Field__mdt> queryFieldSettingList = searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r;

        Map<Integer, String> queryClauseMap = new Map<Integer, String>();

        for (Integer fieldIndex = 0; fieldIndex < queryFieldSettingList.size(); fieldIndex++) {
            Portal_Directory_Search_Query_Field__mdt fieldSetting = queryFieldSettingList[fieldIndex];
            queryClauseMap.put(Integer.valueOf(fieldSetting.Order_Number__c), getQueryClauseForFieldSetting(fieldSetting, searchCriteria));
        }

        // Filter Logic Example: 1 AND 2 AND 3
        String filterLogic = searchCriteriaMetadata.Field_Logic__c;

        String fieldSettingClause = findAndReplaceQueryClauses(filterLogic, queryClauseMap);

        return fieldSettingClause;
    }

    /**
     * Checks if the search criteria uses geolocation.
     *
     * @author Aaron Wong
     *
     * @param searchCriteriaMetadata    The metadata to check.
     * @return                          If the search criteria uses geolocation.
     * @since                           1.0
     */
    private static Boolean isGeolocationSearchCriteria(Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata) {
        return searchCriteriaMetadata != null
                    && searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r != null
                    && !searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r.isEmpty()
                    && searchCriteriaMetadata.Portal_Directory_Search_Query_Fields__r.get(0).Operation__c == DISTANCE_CONST;
    }

    /**
     * Generates a query clause for a given field setting.
     *
     * @author Aaron Wong
     * @param fieldSetting      The field setting metadata to generate the query for.
     * @param searchCriteria    The user inputted search criteria.
     * @return                  Generated query clause for the field setting.
     * @since                   1.0
     */
    @TestVisible
    private String getQueryClauseForFieldSetting(Portal_Directory_Search_Query_Field__mdt fieldSetting,
                                                 PORTAL_SearchCriteria searchCriteria) {
        String resultString = '';

        if (fieldSetting.Operation__c == DISTANCE_CONST) {
            if (searchCriteria.addressList == null || searchCriteria.addressList.isEmpty()) {
                return resultString;
            }

            resultString = getGeolocationQueryString(fieldSetting, searchCriteria);
        } else if (isMultiOperationQueryField(fieldSetting) || String.isNotBlank(fieldSetting.Static_Value__c)) {
            resultString = getDirectOperationQueryString(fieldSetting, searchCriteria);
        } else {
            resultString = getSingleOperationQueryString(fieldSetting, searchCriteria);
        }

        if (fieldSetting.Is_Negate_Logic__c == true) {
            resultString = ' (NOT( ' + resultString  + ')) ';
        }

        return resultString;
    }

    /**
     * Gets the geolocation query string for the given field setting and search criteria.
     *
     * @author Aaron Wong
     *
     * @param fieldSetting      The field setting to get the query string for.
     * @param searchCriteria    The search criteria to get the query string for.
     * @return                  A query string.
     * @since                   1.0
     */
    private String getGeolocationQueryString(Portal_Directory_Search_Query_Field__mdt fieldSetting,
                                             PORTAL_SearchCriteria searchCriteria) {
        String resultString = '';
        PORTAL_GeolocationHub geolocationHub = this.getGeolocationHub();
        String queryClausePrefix = '';

        for (PORTAL_AddressWrapper address : searchCriteria.addressList) {
            resultString = resultString + queryClausePrefix + address.toQueryClause(this.addressFieldMapping);
            queryClausePrefix = ' AND ';
        }

        return resultString;
    }

    /**
     * Gets the query string for the given field setting and search criteria.
     *
     * @author Aaron Wong
     *
     * @param fieldSetting      The field setting to get the query string for.
     * @param searchCriteria    The search criteria to get the query string for.
     * @return                  A query string.
     * @since                   1.0
     */
    private String getDirectOperationQueryString(Portal_Directory_Search_Query_Field__mdt fieldSetting,
                                                 PORTAL_SearchCriteria searchCriteria) {
        String resultString = fieldSetting.Field_Api_Name__c + ' ' + fieldSetting.Operation__c + ' ';

        if (String.isNotBlank(fieldSetting.Static_Value__c)) {
            return resultString + ' ' + fieldSetting.Static_Value__c + ' ';
        }

        if (searchCriteria.valueList == null || searchCriteria.valueList.isEmpty()) {
            return '';
        }

        List<String> escapedValues = new List<String>();
        for (String eachValue : searchCriteria.valueList) {
            escapedValues.add(eachValue.replace('\'', '\\\''));
        }
        resultString = resultString + ' (\'' + String.join(escapedValues, '\',\'') + '\') ';

        return resultString;
    }

    /**
     * Determines if the given field setting is using a multi-value operation for the query.
     *
     * @author Aaron Wong
     *
     * @param fieldSetting      The field setting to check.
     * @return                  If the operation is multi-value.
     * @since                   1.0
     */
    private Boolean isMultiOperationQueryField(Portal_Directory_Search_Query_Field__mdt fieldSetting) {
        return fieldSetting.Operation__c == 'IN' || fieldSetting.Operation__c == 'NOT IN'
                        || fieldSetting.Operation__c == 'INCLUDES' || fieldSetting.Operation__c == 'EXCLUDES';
    }

    /**
     * Gets the query string for the given field setting and search criteria.
     *
     * @author Aaron Wong
     *
     * @param fieldSetting      The field setting to get the query string for.
     * @param searchCriteria    The search criteria to get the query string for.
     * @return                  A query string.
     * @since                   1.0
     */
    private String getSingleOperationQueryString(Portal_Directory_Search_Query_Field__mdt fieldsetting,
                                                    PORTAL_SearchCriteria searchCriteria) {
        String resultString = '';

        if (searchCriteria.valueList == null || searchCriteria.valueList.isEmpty()) {
            return resultString;
        }

        String innerPrefix = '';

        // ucinn_ascendv2__Degree__c != 'AB' OR ucinn_ascendv2__Degree__c != 'BS'
        for (String value : searchCriteria.valueList) {
            resultString = resultString + innerPrefix + fieldSetting.Field_Api_Name__c + ' ' + fieldSetting.Operation__c + ' ';

            if (fieldSetting.Operation__c == 'LIKE') {
                resultString = resultString + ' \'%' + value + '%\' ';
            } else {
                resultString = resultString + ' \'' + value + '\' ';
            }

            //FUTURE TODO: refactor name search
            if (searchCriteria.searchForSelected == 'Name Search') {
                innerPrefix = ' AND ';
            } else {
                innerPrefix = ' OR ';
            }
        }

        resultString = ' (' + resultString + ') ';

        return resultString;
    }

    /**
     * Replaces the filter logic with the appropriate filter clause.
     *
     * @author Aaron Wong
     * @param filterLogic                       The filter logic string to replace
     * @param orderNumberToFilterClauseMap      Map of order number to filter clauses.
     * @return                                  Filter logic replaced with the filter clauses.
     * @since                                   1.0
     */
    private static String findAndReplaceQueryClauses(String filterLogic, Map<Integer, String> orderNumberToFilterClauseMap) {
        Integer lastIndex = 0;

        // FUTURE TODO: regex
        for (Integer orderNumber = 1; orderNumber <= orderNumberToFilterClauseMap.keySet().size(); orderNumber++) {
            Integer orderNumberIndex = filterLogic.indexOf(String.valueOf(orderNumber), lastIndex);
            String filterClause = orderNumberToFilterClauseMap.get(orderNumber);

            filterLogic = filterLogic.subString(0, lastIndex) + filterLogic.subString(lastIndex).replace(String.valueOf(orderNumber), filterClause);
            lastIndex = orderNumberIndex + filterClause.length();
        }

        return filterLogic;
    }

    /**
     * Gets the default scope Search Criterion.
     *
     * @author Aaron Wong
     * @param searchCriteriaMetadataList    List of Search Criteria Metadata.
     * @return                              List of Search Criteria records that are for the default scope.
     * @since                               1.0
     */
    private List<PORTAL_SearchCriteria> getDefaultScopeSearchCriteriaList(List<Portal_Directory_Search_Criteria__mdt> searchCriteriaMetadataList) {
        List<PORTAL_SearchCriteria> resultList = new List<PORTAL_SearchCriteria>();

        if (searchCriteriaMetadataList == null || searchCriteriaMetadataList.isEmpty()) {
            return resultList;
        }

        for (Portal_Directory_Search_Criteria__mdt eachCriteriaMetadata : searchCriteriaMetadataList) {
            if (eachCriteriaMetadata.Portal_Directory_Search_Category__r.Type__c == PORTAL_CONST_Directory.SEARCH_CATEGORY_DEFAULT_SCOPE) {
                resultList.add(new PORTAL_SearchCriteria(eachCriteriaMetadata.Search_Criteria_Name__c, TRUE_CONST));
            }
        }

        return resultList;
    }

    /**
     * Gets a set of non-cached contact Ids with the given criteria record.
     *
     * @author Aaron Wong
     *
     * @param criteriaRecord    The search criteria to get contact Ids with.
     * @param contactIdSet      A set of existing contact Ids to restrict the search with.
     * @return                  Set of contact Ids.
     * @since                   1.0
     */
    @TestVisible
    private Set<String> getNonCachedContactIds(PORTAL_SearchCriteria criteriaRecord,
                                               Set<String> contactIdSet) {
        Set<String> resultSet = new Set<String>();
        Portal_Directory_Search_Criteria__mdt searchCriteriaMetadata = nameToSearchCriteriaMetadataMap.get(criteriaRecord.searchForSelected);
        String contactApiName = searchCriteriaMetadata.Portal_Directory_Search_Category__r.Contact_Id_Api_Name__c;

        String queryString = ' SELECT Id, ' + contactApiName + ' FROM ' + searchCriteriaMetadata.Portal_Directory_Search_Category__r.Object_API_Name__c + ' ';
        String whereClause = ' WHERE ';

        if (contactIdSet != null) {
            whereClause = whereClause + contactApiName + ' IN :contactIdSet AND ( ';
        } else {
            whereClause = whereClause + ' ( ';
        }

        whereClause = whereClause + getQueryClauseForSearchCriteria(criteriaRecord, searchCriteriaMetadata) + ') ';

        List<SObject> sobjectList = Database.query(queryString + whereClause);

        for (SObject eachRecord : sobjectList) {
            resultSet.add((String)eachRecord.get(contactApiName));
        }

        return resultSet;
    }
}