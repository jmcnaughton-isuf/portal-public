public virtual without sharing class PORTAL_BATCH_InitializeDirectoryCaches implements Database.Batchable<sObject>{
    String objectApiName = '';

    public PORTAL_BATCH_InitializeDirectoryCaches(String objectApiName) {
        this.objectApiName = objectApiName;
    }

    public virtual Database.QueryLocator start(Database.BatchableContext bc) {
        List<Portal_Directory_Search_Criteria__mdt> cachedCriteriaList = [SELECT Cache_Logic_Field_On_Object__c
                                                                          FROM Portal_Directory_Search_Criteria__mdt
                                                                          WHERE Cache_Api_Name__c != null
                                                                          AND Cache_Logic_Field_On_Object__c != null
                                                                          AND Portal_Directory_Search_Category__r.Object_API_Name__c = :objectApiName
                                                                          ORDER BY MasterLabel];

        Set<String> fieldSet = new Set<String>{'Id'};

        for (Portal_Directory_Search_Criteria__mdt eachCriteria : cachedCriteriaList) {
            fieldSet.add(eachCriteria.Cache_Logic_Field_On_Object__c);
        }

        String queryString = 'SELECT ' + String.join(new List<String>(fieldSet), ', ') + ' FROM ' + objectApiName;

        return Database.getQueryLocator(queryString);
    }

    public virtual void execute(Database.BatchableContext bc, List<SObject> recordList) {
        new PORTAL_SearchFilterCacheUpdater(objectApiName, recordList, new List<SObject>(), ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert).updateSearchCaches();
    }

    public virtual void finish(Database.BatchableContext bc) {
    }
}