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
 * Handles updating the search filter caches used for the Directory.
 *
 * @author Aaron Wong
 * @version 1.0
 */
public inherited sharing virtual class PORTAL_SearchFilterCacheUpdater {
    protected String objectApiName;
    protected ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction;
    protected List<SObject> triggerNewList;
    protected List<SObject> triggerOldList;

    protected List<Portal_Directory_Search_Criteria__mdt> searchCriteriaList;
    protected String contactIdFieldApiName;

    public PORTAL_SearchFilterCacheUpdater(String objectApiName,
                                           List<SObject> triggerNewList,
                                           List<SObject> triggerOldList,
                                           ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        this.objectApiName = objectApiName;
        this.triggerNewList = triggerNewList;
        this.triggerOldList = triggerOldList;
        this.triggerAction = triggerAction;

        this.searchCriteriaList = getCachedSearchCriteriaMetadataListByObject(objectApiName);

        if (this.searchCriteriaList != null && !this.searchCriteriaList.isEmpty()) {
            this.contactIdFieldApiName= this.searchCriteriaList.get(0).Portal_Directory_Search_Category__r.Contact_Id_Api_Name__c;
        }
    }

    /**
     * Updates the Directory Search Filter Caches on trigger.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    public virtual void updateSearchCaches() {
        if ((!this.isInsert() && !this.isUpdate() && !this.isDelete())
                || this.searchCriteriaList == null || this.searchCriteriaList.isEmpty()) {
            return;
        }

        List<SObject> objectList = new List<SObject>(triggerNewList);

        if (this.isDelete()) {
            objectList = new List<SObject>(triggerOldList);
        }

        Set<String> allContactIds = new Set<String>();
        Set<String> objectIdSet = new Set<String>();

        for (SObject eachObject : objectList) {
            allContactIds.add((String)eachObject.get(this.contactIdFieldApiName));
            objectIdSet.add(eachObject.Id);
        }

        Map<String, List<SObject>> contactIdToRelatedObjectsNotInTriggerMap = getContactIdToListOfSObjectsNotInTriggerMap(allContactIds, objectIdSet);

        Map<String, Set<String>> searchCacheMapToInsert = new Map<String, Set<String>>();       // Used to store info about caches to insert to
        Map<String, Set<String>> searchCacheMapToDelete = new Map<String, Set<String>>();       // Used to store info about caches to delete from

        // Iterate over each search setting and create search caches (Ideally only 3 or 4 times)
        for (Portal_Directory_Search_Criteria__mdt eachSearchCriteria : searchCriteriaList) {
            Map<String, List<SObject>> contactIdToNewObjectInTriggerMap = this.getContactIdToSObjectListMap(this.triggerNewList);
            Map<String, List<SObject>> contactIdToOldObjectInTriggerMap = this.getContactIdToSObjectListMap(this.triggerOldList);

            allContactIds.addAll(contactIdToRelatedObjectsNotInTriggerMap.keySet());
            allContactIds.addAll(contactIdToNewObjectInTriggerMap.keySet());
            allContactIds.addAll(contactIdToOldObjectInTriggerMap.keySet());

            Set<String> contactIdSetToInsertToCache = new Set<String>();
            Set<String> contactIdSetToRemoveFromCache = new Set<String>();

            // Iterate over constituents and check what caches they should go to
            for (String contactId : allContactIds) {
                // Find filter values that are added or deleted when the object is inserted/updated/deleted
                Boolean isBelongInCacheWithoutTriggerObjects = isContactBelongsInCache(contactIdToRelatedObjectsNotInTriggerMap.get(contactId), eachSearchCriteria);
                Boolean isBelongInCacheAfterTrigger = isContactBelongsInCache(contactIdToNewObjectInTriggerMap.get(contactId), eachSearchCriteria);
                Boolean isBelongInCacheBeforeTrigger = isContactBelongsInCache(contactIdToOldObjectInTriggerMap.get(contactId), eachSearchCriteria);

                Set<String> filterValuesToDeleteFrom;
                Set<String> filterValuesToAddTo;

                if (isBelongInCacheWithoutTriggerObjects == true) {
                    continue;
                }

                if (this.isInsert() == true && isBelongInCacheAfterTrigger == true) {
                    contactIdSetToInsertToCache.add(contactId);
                } else if (this.isDelete() == true && isBelongInCacheBeforeTrigger == true) {
                    contactIdSetToRemoveFromCache.add(contactId);
                } else if (this.isUpdate()) {
                    if (isBelongInCacheBeforeTrigger == false && isBelongInCacheAfterTrigger == true) {
                        contactIdSetToInsertToCache.add(contactId);
                    } else if(isBelongInCacheBeforeTrigger == true && isBelongInCacheAfterTrigger == false) {
                        contactIdSetToRemoveFromCache.add(contactId);
                    }
                }
            }

            if (!contactIdSetToInsertToCache.isEmpty()){
                searchCacheMapToInsert.put(eachSearchCriteria.Cache_API_Name__c, contactIdSetToInsertToCache);
            }

            if (!contactIdSetToRemoveFromCache.isEmpty()) {
                searchCacheMapToDelete.put(eachSearchCriteria.Cache_API_Name__c, contactIdSetToRemoveFromCache);
            }
        }

        if (!searchCacheMapToInsert.isEmpty()) {
            handleAddingToCaches(searchCacheMapToInsert);
        }

        if (!searchCacheMapToDelete.isEmpty()) {
            handleDeletingFromCaches(searchCacheMapToDelete, allContactIds);
        }
    }

    /**
     * Determines if the current action is an insert.
     *
     * @author  Aaron Wong
     * @return  Whether the current action is an insert.
     * @since   1.0
     */
    protected virtual Boolean isInsert() {
        return this.triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert;
    }

    /**
     * Determines if the current action is an update.
     *
     * @author  Aaron Wong
     * @return  Whether the current action is an update.
     * @since   1.0
     */
    protected virtual Boolean isUpdate() {
        return this.triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate;
    }

    /**
     * Determines if the current action is an delete.
     *
     * @author  Aaron Wong
     * @return  Whether the current action is an delete.
     * @since   1.0
     */
    protected virtual Boolean isDelete() {
        return this.triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeDelete;
    }

    /**
     * Creates a map of contact Id to a list of the related SObjects.
     *
     * @author Aaron Wong
     *
     * @param objectList        List of objects to map.
     * @return                  Map of contact Ids to the related objects.
     * @since                   1.0
     */
    private Map<String, List<SObject>> getContactIdToSObjectListMap(List<SObject> objectList) {
        Map<String, List<SObject>> resultMap = new Map<String, List<SObject>>();

        if (objectList == null || objectList.isEmpty()) {
            return resultMap;
        }

        for (SObject eachRecord : objectList) {
            if (resultMap.containsKey((String)eachRecord.get(this.contactIdFieldApiName))) {
                resultMap.get((String)eachRecord.get(this.contactIdFieldApiName)).add(eachRecord);
            } else {
                resultMap.put((String)eachRecord.get(this.contactIdFieldApiName), new List<SObject>{eachRecord});
            }
        }

        return resultMap;
    }

    /**
     * Create a map of constituent Ids to the relevane SObject that is currently not in the trigger.
     *
     * @author Aaron Wong
     *
     * @param contactIdSet      Set of constituent ids.
     * @param objectIdSet       Set of object Ids already in the trigger.
     */
    private Map<String, List<SObject>> getContactIdToListOfSObjectsNotInTriggerMap(Set<String> contactIdSet,
                                                                                   Set<String> objectIdSet) {
        List<SObject> allRelatedObjectsList = getAllRelatedObjectsForContactsNotInTrigger(contactIdSet, objectIdSet);

        Map<String, List<SObject>> resultMap = new Map<String, List<SObject>>();

        for (SObject eachObject : allRelatedObjectsList) {
            if (objectIdSet.contains(eachObject.Id)) {
                continue;
            }

            if (resultMap.containsKey((String)eachObject.get(this.contactIdFieldApiName))) {
                resultMap.get((String)eachObject.get(this.contactIdFieldApiName)).add(eachObject);
            } else {
                resultMap.put((String)eachObject.get(this.contactIdFieldApiName), new List<SObject>{eachObject});
            }
        }

        return resultMap;
    }

    /**
     * Gets all cached Search Criteria Custom Metadata that is tied to the given object.
     *
     * @author Aaron Wong
     * @param objectApiName     API name of the object to get cached search criteria for.
     * @return                  List of cached search criteria.
     * @since                   1.0
     */
    public static List<Portal_Directory_Search_Criteria__mdt> getCachedSearchCriteriaMetadataListByObject(String objectApiName) {
        String queryString = ' SELECT ';
        String fields = ' Cache_Api_Name__c, Field_Logic__c, Search_Criteria_Name__c, Portal_Directory_Search_Category__r.Contact_Id_API_Name__c, Cache_Logic_Field_On_Object__c, '
                      + ' Portal_Directory_Search_Category__r.Has_Single_Search_Criteria__c, Portal_Directory_Search_Category__r.Object_Api_Name__c,'
                      + ' (SELECT id, Field_Api_Name__c, Object_Api_Name__c, Filter_Clause__c, Type__c, Static_Values__c FROM Portal_Directory_Search_Display_Settings__r) ';
        String whereClause = ' WHERE Cache_Api_Name__c != null AND Portal_Directory_Search_Category__r.Object_Api_Name__c = \'' + objectApiName + '\'';

        queryString = queryString + fields + ' FROM Portal_Directory_Search_Criteria__mdt ' + whereClause;

        return Database.query(queryString);
    }

    /**
     * Gets all related object for the contacts.
     *
     * @author Aaron Wong
     * @param contactIdSet          Set of contact Ids to get related objects for.
     * @param searchCategoryRecord  The Search Category record for the object to pull.
     * @param searchCriteriaList    The list of search criteria to pull fields for.
     * @return                      List of related objects for the contacts.
     * @since                       1.0
     */
    private List<SObject> getAllRelatedObjectsForContactsNotInTrigger(Set<String> contactIdSet,
                                                                      Set<String> objectIdSet) {
        String queryString = ' SELECT ';
        String fields = ' ' + this.contactIdFieldApiName + ' ';
        String whereClause = ' WHERE ' + this.contactIdFieldApiName + ' IN :contactIdSet AND Id NOT IN :objectIdSet ' ;

        Set<String> fieldSet = new Set<String>();

        for (Portal_Directory_Search_Criteria__mdt eachCriteria : this.searchCriteriaList) {
            fieldSet.add(eachCriteria.Cache_Logic_Field_On_Object__c);
        }

        if (!fieldSet.isEmpty()) {
            fields = fields + ', ' + String.join(new List<String>(fieldSet), ',');
        }

        queryString = queryString + fields + ' FROM ' + this.objectApiName + whereClause;

        List<SObject> queryObjectList = Database.query(queryString);

        return queryObjectList;
    }

    /**
     * Handles adding contact IDs to the search caches.
     *
     * @author Aaron Wong
     * @param searchCacheMapToInsert    Map of Cache API name to Map of Values to set of Contact Ids to insert.
     * @since                           1.0
     */
    public static void handleAddingToCaches(Map<String, Set<String>> searchCacheMapToInsert) {
        String queryString = getCacheQueryString(searchCacheMapToInsert.keySet());
        List<ucinn_portal_Search_Filter_Cache__c> cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();

        // Add ids to caches
        for (ucinn_portal_Search_Filter_Cache__c cacheRecord : Database.query(queryString)) {
            if (!searchCacheMapToInsert.containsKey(cacheRecord.Cache_Api_Name__c)) {
                continue;
            }

            Set<String> contactIdSet = searchCacheMapToInsert.get(cacheRecord.Cache_API_Name__c);

            if (contactIdSet == null || contactIdSet.isEmpty()) {
                continue;
            }

            // Upsert and flush cache if approaching heap size limits
            if (Limits.getLimitHeapSize() - Limits.getHeapSize() < 1000000) {
                // DML
                upsert cacheListToUpsert;
                cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();
            }

            cacheListToUpsert.addAll(addContactIdsToCache(cacheRecord, contactIdSet));
            searchCacheMapToInsert.remove(cacheRecord.Cache_Api_Name__c);
        }

        // Handle adding to any caches that don't currently have a record
        for (String cacheApiName : searchCacheMapToInsert.keySet()) {
            cacheListToUpsert.addAll(addContactIdsToCache(new ucinn_portal_Search_Filter_Cache__c(Cache_Api_Name__c = cacheApiName,
                                                                                                  Filter_Value__c = 'true',
                                                                                                  Order_Number__c = 1),
                                                                                                  searchCacheMapToInsert.get(cacheApiName)));
        }

        System.debug(cacheListToUpsert);
        // DML
        upsert cacheListToUpsert;
    }

    /**
     * Handles deleting contact IDs from the search caches.
     *
     * @author Aaron Wong
     *
     * @param searchCacheMapToDelete    Map of Cache API name to Map of Values to set of Contact Ids to delete.
     * @param contactIdSet              Set of all contact IDs.
     * @since                           1.0
     */
    public static void handleDeletingFromCaches(Map<String, Set<String>> searchCacheMapToDelete,
                                                Set<String> contactIdSet) {
        List<ucinn_portal_Search_Filter_Cache__c> cacheListContainingContactIds = getCacheListContainingContactIds(searchCacheMapToDelete, contactIdSet);

        if (cacheListContainingContactIds == null || cacheListContainingContactIds.isEmpty()) {
            return;
        }

        Set<String> cacheIdSet = new Set<String>();

        for (ucinn_portal_Search_Filter_Cache__c eachCacheRecord : cacheListContainingContactIds) {
            cacheIdSet.add(eachCacheRecord.Id);
        }

        Map<String, Map<String, String>> contactIdsToReplacePerCache = getContactIdsToReplacePerCache(searchCacheMapToDelete);

        String queryString = getCacheQueryStringWithIds(cacheIdSet);

        List<ucinn_portal_Search_Filter_Cache__c> cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();

        for (ucinn_portal_Search_Filter_Cache__c eachCacheRecord : Database.query(queryString)) {
            if (eachCacheRecord.Cache_API_Name__c == PORTAL_CONST_Directory.DUMMY_CACHE_DESC) {
                continue;
            }
            // Upsert and flush cache if approaching heap size limits
            // System.debug('1) HEAP SIZE: ' + Limits.getHeapSize()  + '; MAX HEAP SIZE: ' + Limits.getLimitHeapSize() + '; ' + (Limits.getLimitHeapSize() - Limits.getHeapSize()));
            if (Limits.getLimitHeapSize() - Limits.getHeapSize() < 1000000) {
                // DML
                upsert cacheListToUpsert;
                cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();
            }

            ucinn_portal_Search_Filter_Cache__c newCacheRecord = replaceContactIdsInCache(contactIdsToReplacePerCache, eachCacheRecord);

            if (newCacheRecord != null) {
                cacheListToUpsert.add(newCacheRecord);
            }
        }

        // DML
        upsert cacheListToUpsert;
    }

    /**
     * Replaces the contact IDs in a cache
     *
     * @author Aaron Wong
     * @param contactIdsToReplacePerCache   Map of Cache Api Name to Map of Filter Value to Map of Contact Ids to remove to
     *                                      the contact Id they should be replaced by.
     * @param cacheRecord                   Cache record to replace ids in.
     * @return                              Cache record with replace ids.
     * @since                               1.0
     */
    public static ucinn_portal_Search_Filter_Cache__c replaceContactIdsInCache(Map<String, Map<String, String>> contactIdsToReplacePerCache,
                                                                               ucinn_portal_Search_Filter_Cache__c cacheRecord) {
        ucinn_portal_Search_Filter_Cache__c newCacheRecord = null;

        if (!contactIdsToReplacePerCache.containsKey(cacheRecord.Cache_Api_Name__c)
                || contactIdsToReplacePerCache.get(cacheRecord.Cache_Api_Name__c).isEmpty()) {
            return null;
        }

        Map<String, String> contactIdsToReplaceMap = contactIdsToReplacePerCache.get(cacheRecord.Cache_Api_Name__c);

        for (Integer fieldIndex = 1; fieldIndex <= 12; fieldIndex++) {
            String cacheFieldName = 'Contact_Id_Cache_' + fieldIndex + '__c';

            String cacheField = (String)cacheRecord.get(cacheFieldName);
            if (cacheField == null) {
                cacheField = '';
            }

            for (String eachContactIdToRemove : contactIdsToReplaceMap.keySet()) {
                if (!cacheField.contains(eachContactIdToRemove)) {
                    continue;
                }

                cacheField = cacheField.replace(eachContactIdToRemove, contactIdsToReplaceMap.get(eachContactIdToRemove));
                // Blank values denote that this value should be deleted from the end of the cache
                contactIdsToReplaceMap.put(eachContactIdToRemove, '');
                if (newCacheRecord == null) {
                    newCacheRecord = new ucinn_portal_Search_Filter_Cache__c(Id = cacheRecord.Id,
                                                                            Cache_API_Name__c = cacheRecord.Cache_API_Name__c,
                                                                            Filter_Value__c = cacheRecord.Filter_Value__c,
                                                                            Order_Number__c = cacheRecord.Order_Number__c);
                }
                newCacheRecord.put(cacheFieldName, cacheField);
            }
        }

        return newCacheRecord;
    }

    /**
     * Gets the directory caches with the given contact Ids.
     *
     * @author Aaron Wong
     * @param searchCacheMapToDelete    Map of Cache API Name to Map of Filter value to Set of Contact Ids to delete.
     * @param contactIdSet              Set of contact Ids.
     * @return                          List of Directory Search Filter Caches.
     * @since                           1.0
     */
    private static List<ucinn_portal_Search_Filter_Cache__c> getCacheListContainingContactIds(Map<String, Set<String>> searchCacheMapToDelete,
                                                                                              Set<String> contactIdSet) {
        String searchString = '';

        for (String eachContactId : contactIdSet) {
            if (!String.isBlank(searchString)) {
                searchString = searchString + ' OR ';
            }

            searchString = searchString + '\'%' + eachContactId + '\'% ';
        }

        String whereClause = ' WHERE ';

        whereClause = whereClause + ' Cache_Api_Name__c IN (\'' + String.join(new List<String>(searchCacheMapToDelete.keySet()), '\', \'') + '\') ';
        System.debug(searchString);
        System.debug(whereClause);

        List<List<SObject>> searchResults = Search.query(' FIND :searchString IN ALL FIELDS RETURNING ucinn_portal_Search_Filter_Cache__c(Id ' + whereClause + ')');
        System.debug(searchResults);

        if (searchResults == null || searchResults.size() == 0 || searchResults[0] == null || searchResults.size() == 0) {
            return new List<ucinn_portal_Search_Filter_Cache__c>();
        }

        return (List<ucinn_portal_Search_Filter_Cache__c>)(searchResults.get(0));
    }

    /**
     * Gets the cache query string for search caches.
     *
     * @author Aaron Wong
     * @param searchCache   Map of Cache Api Name to Map of Filter Value to set of contact IDs.
     * @return              Query String for the caches specified in the search cache parameter.
     * @since               1.0
     */
    private static String getCacheQueryString(Set<String> cacheApiNameSet) {
        String queryString = ' SELECT ';
        String fields = ' Contact_Id_Cache_1__c, Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c, Contact_Id_Cache_6__c, Contact_Id_Cache_7__c, ' +
                        ' Contact_Id_Cache_8__c, Contact_Id_Cache_9__c, Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c, Cache_Api_Name__c, Filter_Value__c, Order_Number__c ';
        String whereClause = '';
        String orderClause = ' ORDER BY Order_Number__c DESC';

        // Construct where clause for Directory Search Cache query string
        for (String eachCacheApiName : cacheApiNameSet) {
            String whereClausePrefix = '';
            if (!String.isBlank(whereClause)) {
                whereClausePrefix = ' OR ';
            } else {
                whereClausePrefix = ' WHERE Cache_Api_Name__c = \'Dummy_Cache_DESC\' OR ';
            }

            whereClause = whereClause + whereClausePrefix + ' Cache_Api_Name__c = \'' + eachCacheApiName + '\' ';
        }

        queryString = queryString + fields + ' FROM ucinn_portal_Search_Filter_Cache__c ' + whereClause + orderClause;

        return queryString;
    }

    /**
     * Gets the cache query string for search caches.
     *
     * @author Aaron Wong
     * @param  cacheIdSet   Set of IDs for the caches to get the query string for.
     * @return              Query String for the caches specified.
     * @since               1.0
     */
    private static String getCacheQueryStringWithIds(Set<String> cacheIdSet) {
        String queryString = ' SELECT ';
        String fields = ' Contact_Id_Cache_1__c, Contact_Id_Cache_2__c, Contact_Id_Cache_3__c, Contact_Id_Cache_4__c, Contact_Id_Cache_5__c, Contact_Id_Cache_6__c, Contact_Id_Cache_7__c, ' +
                        ' Contact_Id_Cache_8__c, Contact_Id_Cache_9__c, Contact_Id_Cache_10__c, Contact_Id_Cache_11__c, Contact_Id_Cache_12__c, Cache_Api_Name__c, Filter_Value__c, Order_Number__c ';
        String whereClause = ' WHERE Cache_Api_Name__c = \'Dummy_Cache_DESC\' OR (';
        String orderClause = ' ORDER BY Order_Number__c DESC';

        if (cacheIdSet == null || cacheIdSet.isEmpty()) {
            return '';
        }

        String cacheIdString = String.join(new List<String>(cacheIdSet), '\', \'');
        cacheIdString = '(\'' + cacheIdString + '\')';

        whereClause = whereClause + ' Id IN ' + cacheIdString;

        if (String.isNotBlank(whereClause)) {
            whereClause = whereClause + ')';
        }

        queryString = queryString + fields + ' FROM ucinn_portal_Search_Filter_Cache__c ' + whereClause + orderClause;

        return queryString;
    }

    /**
     * Adds the contact Ids to the given cache.
     *
     * @author Aaron wong
     * @param cacheRecord   Cache record to add contact Ids to.
     * @param contactIdSet  Set of contact Ids to add to the cache.
     * @return              List of cache records with the contact Ids added.
     * @since               1.0
     */
    private static List<ucinn_portal_Search_Filter_Cache__c> addContactIdsToCache(ucinn_portal_Search_Filter_Cache__c cacheRecord,
                                                                                  Set<String> contactIdSet) {
        List<ucinn_portal_Search_Filter_Cache__c> cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();

        Integer lastFieldIndex = 1;
        ucinn_portal_Search_Filter_Cache__c newCacheRecord = null;
        // Loop through each of the id fields on the cache
        for (Integer fieldIndex = 1; fieldIndex <= 12; fieldIndex++) {
            String cacheFieldName = 'Contact_Id_Cache_' + fieldIndex + '__c';

            String cacheField = (String) cacheRecord.get(cacheFieldName);
            if (cacheField == null) {
                cacheField = '';
            }

            Integer fieldMaxSize = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.fields.getMap().get(cacheFieldName).getDescribe().getLength();

            // Store just the last cache field into a new cache object to upsert
            if (cacheField == null || cacheField.length() + PORTAL_CONST_Directory.ID_LENGTH_WITH_SEMICOLON <= fieldMaxSize) {
                newCacheRecord = new ucinn_portal_Search_Filter_Cache__c(Id = cacheRecord.id,
                                                                         Cache_API_Name__c = cacheRecord.Cache_API_Name__c,
                                                                         Filter_Value__c = cacheRecord.Filter_Value__c,
                                                                         Order_Number__c = cacheRecord.Order_Number__c);
                newCacheRecord.put(cacheFieldName, cacheField);
                System.debug(cacheFieldName);
                System.debug(cacheRecord.Cache_API_Name__c);
                lastFieldIndex = fieldIndex;
                break;
            }
        }

        if (newCacheRecord == null) {
            newCacheRecord = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = cacheRecord.Cache_API_Name__c,
                                                                    Filter_Value__c = cacheRecord.Filter_Value__c,
                                                                    Order_Number__c = cacheRecord.Order_Number__c + 1);
        }

        cacheListToUpsert.add(newCacheRecord);

        for (String eachContactId : contactIdSet) {
            String cacheFieldName = 'Contact_Id_Cache_' + lastFieldIndex + '__c';
            String cacheField = (String)newCacheRecord.get(cacheFieldName);

            if (cacheField == null) {
                cacheField = '';
            }

            Integer fieldMaxSize = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.fields.getMap().get(cacheFieldName).getDescribe().getLength();
            System.debug(fieldMaxSize);
            System.debug(cacheField.length());

            if (cacheField.length() + PORTAL_CONST_Directory.ID_LENGTH_WITH_SEMICOLON > fieldMaxSize) {
                // There are no gaps in the constituent ids
                lastFieldIndex = lastFieldIndex + 1;
                if (lastFieldIndex > 12) {
                    lastFieldIndex = 1;
                    newCacheRecord = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = newCacheRecord.Cache_API_Name__c,
                                                                             Filter_Value__c = newCacheRecord.Filter_Value__c,
                                                                             Order_Number__c = newCacheRecord.Order_Number__c + 1);
                    cacheListToUpsert.add(newCacheRecord);
                }

                cacheFieldName = 'Contact_Id_Cache_' + lastFieldIndex + '__c';
                cacheField = (String)newCacheRecord.get(cacheFieldName);

                if (cacheField == null) {
                    cacheField = '';
                }
            }

            cacheField = cacheField + eachContactId + ';';
            newCacheRecord.put(cacheFieldName, cacheField);
        }

        return cacheListToUpsert;
    }

    /**
     * Checks if a contact is in the cache using it's related objects.
     *
     * @param objectList        List of the contact's related objects.
     * @param searchCriteria    The Search Criteria the cache is for.
     * @return                  Whether the contact is in the cache.
     * @since                   1.0
     */
    private static Boolean isContactBelongsInCache(List<SObject> objectList,
                                                  Portal_Directory_Search_Criteria__mdt searchCriteria) {
        if (objectList == null || searchCriteria == null) {
            return false;
        }

        for (SObject eachObject : objectList) {
            if ((Boolean)eachObject.get(searchCriteria.Cache_Logic_Field_On_Object__c)) {
                return true;
            }
        }

        return false;
    }

    /**
      * Populate map of contact ids to replace, where the keys are contact ids that are being deleted from caches, and the values are the contact ids that will replace them
      *
      * @since:  1.0
      */
    public static Map<String, Map<String, String>> getContactIdsToReplacePerCache(Map<String, Set<String>> searchCacheMapToDelete) {
        Map<String, Map<String, String>> contactIdsToReplacePerCache = initializeContactIdsToReplacePerCacheMap(searchCacheMapToDelete);

        List<ucinn_portal_Search_Filter_Cache__c> cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();
        List<ucinn_portal_Search_Filter_Cache__c> cacheListToDelete = new List<ucinn_portal_Search_Filter_Cache__c>();

        String queryString = getCacheQueryString(searchCacheMapToDelete.keySet());

        // Populate ids to replace with
        for (ucinn_portal_Search_Filter_Cache__c eachCacheRecord : Database.query(queryString)) {
            if (eachCacheRecord.Cache_Api_Name__c == 'Dummy_Cache_DESC') {
                continue;
            }

            // System.debug('1) HEAP SIZE: ' + Limits.getHeapSize()  + '; MAX HEAP SIZE: ' + Limits.getLimitHeapSize() + '; ' + (Limits.getLimitHeapSize() - Limits.getHeapSize()));
            if (Limits.getLimitHeapSize() - Limits.getHeapSize() < 1000000) {
                // DML
                upsert cacheListToUpsert;
                cacheListToUpsert = new List<ucinn_portal_Search_Filter_Cache__c>();
            }

            if (!contactIdsToReplacePerCache.containsKey(eachCacheRecord.Cache_Api_Name__c)
                    || contactIdsToReplacePerCache.get(eachCacheRecord.Cache_API_Name__c).isEmpty()) {
                continue;
            }

            Map<String, String> contactIdsToReplaceMap = contactIdsToReplacePerCache.get(eachCacheRecord.Cache_Api_Name__c);

            if (!contactIdsToReplaceMap.values().contains('') && !contactIdsToReplaceMap.values().contains(null)) {
                continue;
            }

            ucinn_portal_Search_Filter_Cache__c newCacheRecord = null;

            // Loop through each of the id fields on the cache
            for (Integer fieldIndex = 12; fieldIndex >= 1; fieldIndex--) {
                String cacheFieldName = 'Contact_Id_Cache_' + fieldIndex + '__c';

                String cacheField = (String)eachCacheRecord.get(cacheFieldName);
                if (cacheField == null) {
                    cacheField = '';
                }

                // Populate map to replace ids keys with id in value
                if (cacheField.length() != 0) {
                    List<String> contactIdList = cacheField.split(';');

                    // Check each value if empty
                    for (String eachContactIdToReplace : contactIdsToReplaceMap.keySet()) {
                        if (String.isNotBlank(contactIdsToReplaceMap.get(eachContactIdToReplace))) {
                            continue;
                        }

                        contactIdsToReplaceMap.put(eachContactIdToReplace, contactIdList.get(0));
                        contactIdList.remove(0);

                        if (contactIdList.isEmpty()) {
                            break;
                        }
                    }

                    cacheField = String.join(contactIdList, ';');
                    if (!String.isBlank(cacheField)) {
                        cacheField = cacheField + ';';
                    }

                    if (newCacheRecord == null) {
                        newCacheRecord = new ucinn_portal_Search_Filter_Cache__c(Id = eachCacheRecord.id,
                                                                                 Cache_API_Name__c = eachCacheRecord.Cache_API_Name__c,
                                                                                 Filter_Value__c = eachCacheRecord.Filter_Value__c,
                                                                                 Order_Number__c = eachCacheRecord.Order_Number__c);
                        cacheListToUpsert.add(newCacheRecord);
                    }

                    newCacheRecord.put(cacheFieldName, cacheField);

                    // We don't store the caches to update so we don't hit heap space limits
                    if (!contactIdList.isEmpty()) {
                        break;
                    }
                }

                if (cacheField.length() == 0 && fieldIndex == 1) {
                    cacheListToDelete.add(newCacheRecord);
                }
            }
        }

        // DML
        upsert cacheListToUpsert;
        delete cacheListToDelete;

        return contactIdsToReplacePerCache;
    }

    /**
     * Initializes the contact Ids to replace per cache map.
     *
     * @author Aaron Wong
     * @param searchCacheMapToDelete    Map of Cache API Name to Map of Filter value to Set of Contact Ids to delete.
     * @return                          Map of Cache API Name to Map of Filter value to Map of Contact Id to replace to Contact Id.
     * @since                           1.0
     */
    private static Map<String, Map<String, String>> initializeContactIdsToReplacePerCacheMap(Map<String, Set<String>> searchCacheMapToDelete) {
        Map<String, Map<String, String>> resultMap = new Map<String, Map<String, String>>();

        for (String eachCacheApiName : searchCacheMapToDelete.keySet()) {
            Map<String, String> contactIdReplacementMap = new Map<String, String>();

            for (String eachContactId : searchCacheMapToDelete.get(eachCacheApiName)) {
                contactIdReplacementMap.put(eachContactId, '');
            }

            resultMap.put(eachCacheApiName, contactIdReplacementMap);
        }

        return resultMap;
    }
}