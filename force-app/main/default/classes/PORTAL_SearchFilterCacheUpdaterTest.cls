@isTest
public without sharing class PORTAL_SearchFilterCacheUpdaterTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            // insert new ucinn_ascendv2__Trigger_Handler__c(Name = 'Directory Search',
            //                                               ucinn_ascendv2__Object__c = 'Contact',
            //                                               ucinn_ascendv2__Load_Order__c = 1,
            //                                               ucinn_ascendv2__Class__c = 'PORTAL_TRIG_DirectorySearchHandler',
            //                                               ucinn_ascendv2__Is_Active__c = true,
            //                                               ucinn_ascendv2__Trigger_Action__c = 'BeforeDelete;AfterInsert;AfterUpdate',
            //                                               ucinn_ascendv2__Is_User_Managed__c = true);

            ucinn_portal_Search_Filter_Cache__c hiringManagerCache = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = 'Hiring_Managers_Cache', Filter_Value__c = 'true', Order_Number__c = 1);

            for (Integer index = 1; index <= 12; index++) {
                String cacheFieldName = 'Contact_Id_Cache_' + index + '__c';

                String cacheField = '';

                Integer fieldMaxSize = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.fields.getMap().get(cacheFieldName).getDescribe().getLength();

                while (cacheField.length() + 19 <= fieldMaxSize) {
                    cacheField = cacheField + 'testertestertester;';
                }

                hiringManagerCache.put(cacheFieldName, cacheField);
            }

            hiringManagerCache.put('Contact_Id_Cache_12__c', hiringManagerCache.Contact_Id_Cache_12__c.substring(19));

            insert hiringManagerCache;
        }

        // public virtual void testUpdateSearchCaches() {
        //     setupData();
        //     System.runAs(thisUser) {
        //         Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
        //         Account acct = new Account(name = 'ACME Co') ;
        //         acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
        //         insert acct;

        //         Contact dummyContact = new Contact();
        //         dummyContact.FirstName = 'Dummy';
        //         dummyContact.LastName = 'Contact';
        //         dummyContact.AccountId = acct.Id;
        //         dummyContact.ucinn_portal_Is_Display_On_Portal__c = true;
        //         dummyContact.ucinn_portal_Is_Hiring_Manager__c = true;
        //         dummyContact.ucinn_portal_Is_Job_Seeker__c = true;
        //         dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});

        //         Contact dummyContact2 = new Contact();
        //         dummyContact2.FirstName = 'Dummy';
        //         dummyContact2.LastName = 'Contact';
        //         dummyContact2.AccountId = acct.Id;
        //         dummyContact2.ucinn_portal_Is_Display_On_Portal__c = true;
        //         dummyContact2.ucinn_portal_Is_Hiring_Manager__c = true;
        //         dummyContact2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact2});

        //         Contact dummyContact3 = new Contact();
        //         dummyContact3.FirstName = 'Dummy';
        //         dummyContact3.LastName = 'Contact';
        //         dummyContact3.AccountId = acct.Id;
        //         dummyContact3.ucinn_portal_Is_Display_On_Portal__c = true;
        //         dummyContact3.ucinn_portal_Is_Hiring_Manager__c = true;
        //         dummyContact3.ucinn_portal_Is_Job_Seeker__c = true;
        //         dummyContact3 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact3});

        //         insert new List<Contact>{dummyContact, dummyContact2};
        //         insert dummyContact3;

        //         dummyContact.ucinn_portal_Is_Hiring_Manager__c = false;
        //         dummyContact2.ucinn_portal_Is_Job_Seeker__c = true;
        //         update new List<Contact>{dummyContact, dummyContact2};

        //         List<ucinn_portal_Search_Filter_Cache__c> cacheList = [SELECT Id, Cache_Api_Name__c FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_Api_Name__c IN ('Job_Seekers_Cache', 'Hiring_Managers_Cache')];
        //         List<Id> idList = new List<Id>();

        //         for (ucinn_portal_Search_Filter_Cache__c eachCache : cacheList) {
        //             idList.add(eachCache.Id);
        //         }

        //         Test.setFixedSearchResults(idList);
        //         delete dummyContact3;

        //         Test.setFixedSearchResults(idList);
        //         delete dummyContact;
        //         Test.setFixedSearchResults(idList);
        //         delete dummyContact2;
        //     }
        // }

        public virtual void testRun() {
            setupData();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact dummyContact = new Contact();
            dummyContact.FirstName = 'Dummy';
            dummyContact.LastName = 'Contact';
            dummyContact.AccountId = acct.Id;
            dummyContact.ucinn_portal_Is_Display_On_Portal__c = true;
            dummyContact.ucinn_portal_Is_Hiring_Manager__c = true;
            dummyContact.ucinn_portal_Is_Job_Seeker__c = true;
            dummyContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact});

            Contact dummyContact2 = new Contact();
            dummyContact2.FirstName = 'Dummy';
            dummyContact2.LastName = 'Contact';
            dummyContact2.AccountId = acct.Id;
            dummyContact2.ucinn_portal_Is_Display_On_Portal__c = true;
            dummyContact2.ucinn_portal_Is_Hiring_Manager__c = true;
            dummyContact2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact2});

            Contact dummyContact3 = new Contact();
            dummyContact3.FirstName = 'Dummy3';
            dummyContact3.LastName = 'Contact';
            dummyContact3.AccountId = acct.Id;
            dummyContact3.ucinn_portal_Is_Display_On_Portal__c = true;
            dummyContact3.ucinn_portal_Is_Hiring_Manager__c = true;
            dummyContact3.ucinn_portal_Is_Job_Seeker__c = true;
            dummyContact3 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dummyContact3});

            insert new List<sObject>{dummyContact, dummyContact2};

            List<sObject> emptyList = null;

            Map<String, Schema.SObjectField> fieldMap = Contact.sObjectType.getDescribe().fields.getMap();
                    
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>(setFieldNames);
                    
            List<sObject> filledList = Database.query('SELECT ' + String.join(lstFieldNames, ',') + ' FROM Contact WHERE FirstName = \'Dummy\'');
            
            new PORTAL_TRIG_DirectorySearchHandler().run(filledList,
                                                        emptyList,
                                                        ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                        Contact.getSObjectType().getDescribe());


            dummyContact.ucinn_portal_Is_Hiring_Manager__c = false;
            dummyContact2.ucinn_portal_Is_Job_Seeker__c = true;
            update new List<Contact>{dummyContact, dummyContact2};

            new PORTAL_TRIG_DirectorySearchHandler().run(filledList,
                                                        filledList,
                                                        ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                        Contact.getSObjectType().getDescribe());

            List<ucinn_portal_Search_Filter_Cache__c> cacheList = [SELECT Id, Cache_Api_Name__c FROM ucinn_portal_Search_Filter_Cache__c WHERE Cache_Api_Name__c IN ('Job_Seekers_Cache', 'Hiring_Managers_Cache')];
            List<Id> idList = new List<Id>();

            for (ucinn_portal_Search_Filter_Cache__c eachCache : cacheList) {
                idList.add(eachCache.Id);
            }

            Test.setFixedSearchResults(idList);
            delete new List<sObject>{dummyContact, dummyContact2};

            new PORTAL_TRIG_DirectorySearchHandler().run(emptyList,
                                                        filledList,
                                                        ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeDelete,
                                                        Contact.getSObjectType().getDescribe());
        }

        public virtual void testInvalidCalls() {
            PORTAL_SearchFilterCacheUpdater.handleDeletingFromCaches(new Map<String, Set<String>>(), new Set<String>());
            PORTAL_SearchFilterCacheUpdater.replaceContactIdsInCache(new Map<String, Map<String, String>>(), new ucinn_portal_Search_Filter_Cache__c());
        }
    }

    // public static testMethod void testUpdateSearchCaches() {
    //     PORTAL_TestClassFactory.getTestClassFactory().getSearchFilterCacheUpdaterTestClass().testUpdateSearchCaches();
    // }

    public static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getSearchFilterCacheUpdaterTestClass().testRun();
    }

    public static testMethod void testInvalidCalls() {
        PORTAL_TestClassFactory.getTestClassFactory().getSearchFilterCacheUpdaterTestClass().testInvalidCalls();
    }
}