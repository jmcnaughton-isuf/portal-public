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
 * batch class that takes an interim employment and creates an account and
 * the contact information records related to that account
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */

public virtual with sharing class PORTAL_BATCH_ProcessPendingEmployment implements Database.Batchable<sObject>{

    List<Portal_Page_Section_Setting__mdt> pageSectionSettingList;

    /**
     * Constructor that retrieves the custom metadata records that will be used
     * for mapping the interim employment fields to account records
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     */
    public PORTAL_BATCH_ProcessPendingEmployment() {
        pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('Hiring Manager', '', '');
    }

    /**
     * batch start method that uses the custom metadata records
     * to get the fields that are needed for the query
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @return                          the query locator for this batch
     */

    public virtual Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> fieldsToQuery = new Set<String>();

        for (Portal_Page_Section_Setting__mdt pageSectionSetting: pageSectionSettingList) {
            if (pageSectionSetting.sObject_API_Name__c == 'Contact') {
                continue;
            }
            if (pageSectionSetting.Portal_Section_Field_Settings__r != null) {
                for (Portal_Section_Field_Setting__mdt fieldSetting : pageSectionSetting.Portal_Section_Field_Settings__r) {
                    if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c)) {
                        fieldsToQuery.add(fieldSetting.Staging_Record_Field_API_Name__c);
                    }
                }
            }
        }

        String queryString = 'SELECT Id, ' + String.join(new List<String>(fieldsToQuery), ',') + ' FROM ucinn_portal_Interim_Employment__c '
                            + ' WHERE Status__c = \'Pending\'';
        return Database.getQueryLocator(queryString);
    }

    /**
     * execution method that will take a list of interim employment records
     * and create sobjects from them
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param interimEmploymentList             list of interim employments to process in this execution
     */

    public virtual void execute(Database.BatchableContext BC, List<ucinn_portal_Interim_Employment__c> interimEmploymentList) {

        Map<Id, ucinn_portal_Interim_Employment__c> interimEmploymentMap = new Map<Id, ucinn_portal_Interim_Employment__c>(interimEmploymentList);
        Map<Id, Account> interimEmploymentIdToAccountMap =  new Map<Id, Account>();
        Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap = new Map<String, ucinn_ascendv2__Address__c>();
        Map<String, List<sObject>> sobjectNameToRecordsToInsertMap = new  Map<String, List<sObject>>();

        for (ucinn_portal_Interim_Employment__c interimEmployment : interimEmploymentList) {
            Account acct = populateAccount(interimEmployment);
            interimEmploymentIdToAccountMap.put(interimEmployment.Id, acct);
        }

        List<Database.SaveResult> saveResultList = Database.insert(interimEmploymentIdToAccountMap.values(), false);
        Map<Id, ucinn_portal_Interim_Employment__c> interimEmploymentsToUpdate = new  Map<Id, ucinn_portal_Interim_Employment__c>();
        Map<Id, Id> accountIdToInterimEmploymentId = new Map<Id, Id>();
        Map<String, String> sObjectNameToControllingField = new Map<String, String> ();

        for (Id interimEmploymentId : interimEmploymentIdToAccountMap.keyset()) {
            ucinn_portal_Interim_Employment__c interimEmployment = new ucinn_portal_Interim_Employment__c();
            interimEmployment.Id = interimEmploymentId;
            if (String.isNotBlank(interimEmploymentIdToAccountMap.get(interimEmploymentId).Id)) {
                Id accountId = interimEmploymentIdToAccountMap.get(interimEmploymentId).Id;
                interimEmployment.Account__c = accountId;
                interimEmployment.Status__c = PORTAL_CONST_CommunityUser.IN_PROGRESS;
                createRelatedRecords(interimEmploymentMap.get(interimEmployment.Id), accountId, hashCodeToAddressMap, sobjectNameToRecordsToInsertMap, sObjectNameToControllingField);
                accountIdToInterimEmploymentId.put(accountId, interimEmploymentId);

            } else {
                interimEmployment.Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                interimEmployment.Manual_Review_Reason__c += 'Could not create account for this interim employment.';
            }
            interimEmploymentsToUpdate.put(interimEmploymentId, interimEmployment);
        }

        if (!hashCodeToAddressMap.isEmpty()) {
            Database.upsert(hashCodeToAddressMap.values(), ucinn_ascendv2__Address__c.ucinn_ascendv2__External_System_ID__c, false);
        }

        for (String sObjectName : sobjectNameToRecordsToInsertMap.keySet()) {
            List<sObject> sobjectsToInsert = new List<sObject>(sobjectNameToRecordsToInsertMap.get(sobjectName));
            List<Database.SaveResult> insertResultList = Database.insert(sobjectsToInsert, false);
            for (Integer index = 0; index < insertResultList.size(); index++) {
                if (!insertResultList.get(index).isSuccess()) {
                    sObject eachFailedRecord = sobjectsToInsert.get(index);
                    if (sObjectNameToControllingField.containsKey(sObjectName)) {
                        //these records are only created if the  account is created, so all we need to do is
                        //get the account id from the account look up field
                        Id accountId = (Id) eachFailedRecord.get(sObjectNameToControllingField.get(sObjectName));
                        if (accountId != null) {
                            //each account id is already linked to the interim employment and each interim employment has already been added
                            //to the update map, but these checks are just to make sure that we do not get an NPE

                            //get the interim employment id from the accountIdToInterimEmploymentId
                            if (accountIdToInterimEmploymentId.containsKey(accountId)) {
                                //get the interim employment from the interimEmploymentsToUpdate using the interim employment id
                                if (interimEmploymentsToUpdate.containsKey(accountIdToInterimEmploymentId.get(accountId))) {
                                    ucinn_portal_Interim_Employment__c employment = interimEmploymentsToUpdate.get(accountIdToInterimEmploymentId.get(accountId));
                                    employment.Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                                    employment.Manual_Review_Reason__c += 'Could not create ' + sObjectName + ' record. ';
                                    interimEmploymentsToUpdate.put(employment.Id, employment);
                                }
                            }
                        }
                    }
                }
            }

        }

        Database.update(interimEmploymentsToUpdate.values(), false);
    }

    /**
     * finish method for batch class that calls the in progress batch after
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     */
    public virtual void finish(Database.BatchableContext BC) {
        if (!Test.isRunningTest()) {
            Database.executeBatch(new PORTAL_BATCH_ProcessInProgressEmployment());
        }
    }

    /**
     * method that takes an interim employment and creates
     * a new account record
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param interimEmployment             the interim employment record we are processing
     *
     * @return                              a new account record with data from the interim employment
     */

    public Account populateAccount(ucinn_portal_Interim_Employment__c interimEmployment) {
        Account acct = new Account();
        for (Portal_Page_Section_Setting__mdt pageSectionSetting: pageSectionSettingList) {
            if (pageSectionSetting.sObject_API_Name__c != 'Account') {
                continue;
            }
            if (pageSectionSetting.Portal_Section_Field_Settings__r != null) {
                for (Portal_Section_Field_Setting__mdt fieldSetting : pageSectionSetting.Portal_Section_Field_Settings__r) {
                    if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c) && String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                        acct.put(fieldSetting.Field_API_Name__c, interimEmployment.get(fieldSetting.Staging_Record_Field_API_Name__c));
                    }
                }

            }

            if (String.isNotBlank(pageSectionSetting.Record_Type_Developer_Name__c)) {
                Schema.RecordTypeInfo recordTypeInfo =  Schema.getGlobalDescribe().get(acct.getSObjectType().getDescribe().getName()).getDescribe().getRecordTypeInfosByDeveloperName().get(pageSectionSetting.Record_Type_Developer_Name__c);
                if (recordTypeInfo == null) {
                    System.debug('PORTAL_BATCH_ProcessPendingEmployment populateAccount record type name is wrong for section ' + pageSectionSetting.Label);
                } else {
                    acct.put('RecordTypeId', recordTypeInfo.getRecordTypeId());
                }
            }

            if (String.isNotBlank(pageSectionSetting.Active_Record_Field_Map__c)) {
                Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(pageSectionSetting.Active_Record_Field_Map__c);
                for (String field : fieldMap.keySet()) {
                    acct.put(field, fieldMap.get(field));
                }
            }
        }

        return acct;
    }

    /**
     * method that takes an interim employment and creates
     * the related records that look up to the account
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param interimEmployment                 the interim employment record we are processing
     * @param accountId                         the account id that we are trying to link to
     * @param hashCodeToAddressMap              the map of hashcode to addresses to upsert later for address relations
     * @param sobjectNameToRecordsToInsertMap   the map of sobject name to records so we can insert them later
     * @param sObjectNameToControllingField     the map of sobject name to the lookup field name for account
     *
     * @return
     */

    public void createRelatedRecords(ucinn_portal_Interim_Employment__c interimEmployment, Id accountId, Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap, Map<String, List<sObject>> sobjectNameToRecordsToInsertMap, Map<String, String> sObjectNameToControllingField) {
        for (Portal_Page_Section_Setting__mdt pageSectionSetting: pageSectionSettingList) {
            if (pageSectionSetting.Portal_Section_Field_Settings__r != null) {
                if (String.isNotBlank(pageSectionSetting.sObject_API_Name__c ) && pageSectionSetting.sObject_API_Name__c != 'Account' && pageSectionSetting.sObject_API_Name__c != 'ucinn_ascendv2__Affiliation__c' && pageSectionSetting.sObject_API_Name__c != 'Contact') {
                    sObject record = null;
                    if (pageSectionSetting.sObject_API_Name__c == 'ucinn_ascendv2__Address_Relation__c') {
                        record = createAddressRelationRecord(interimEmployment, pageSectionSetting, hashCodeToAddressMap);

                    } else {
                        record = (sObject) Type.forName(pageSectionSetting.sObject_API_Name__c).newInstance();
                        for (Portal_Section_Field_Setting__mdt fieldSetting : pageSectionSetting.Portal_Section_Field_Settings__r) {
                            if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c) && String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                                record.put(fieldSetting.Field_API_Name__c, interimEmployment.get(fieldSetting.Staging_Record_Field_API_Name__c));
                            }
                        }
                    }
                    if (String.isNotBlank(pageSectionSetting.Controlling_Parent_Field_API_Name__c)) {
                        sObjectNameToControllingField.put(pageSectionSetting.sObject_API_Name__c, pageSectionSetting.Controlling_Parent_Field_API_Name__c);
                        record.put(pageSectionSetting.Controlling_Parent_Field_API_Name__c, accountId);
                    }

                    if (String.isNotBlank(pageSectionSetting.Record_Type_Developer_Name__c)) {
                        Schema.RecordTypeInfo recordTypeInfo =  Schema.getGlobalDescribe().get(record.getSObjectType().getDescribe().getName()).getDescribe().getRecordTypeInfosByDeveloperName().get(pageSectionSetting.Record_Type_Developer_Name__c);
                        if (recordTypeInfo == null) {
                            System.debug('PORTAL_BATCH_ProcessPendingEmployment createRelatedRecords record type name is wrong for section ' + pageSectionSetting.Label);
                        } else {
                            record.put('RecordTypeId', recordTypeInfo.getRecordTypeId());
                        }
                    }

                    if (String.isNotBlank(pageSectionSetting.Active_Record_Field_Map__c)) {
                        Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(pageSectionSetting.Active_Record_Field_Map__c);
                        for (String field : fieldMap.keySet()) {
                            record.put(field, fieldMap.get(field));
                        }
                    }

                    if (sobjectNameToRecordsToInsertMap.containsKey(pageSectionSetting.sObject_API_Name__c)) {
                        sobjectNameToRecordsToInsertMap.get(pageSectionSetting.sObject_API_Name__c).add(record);
                    } else {
                        sobjectNameToRecordsToInsertMap.put(pageSectionSetting.sObject_API_Name__c, new List<sObject>{record});
                    }

                }
            }
        }
    }

     /**
     * method that takes an interim employment and creates
     * the address relation record for the account
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param interimEmployment             the interim employment record we are processing
     * @param sectionSetting                the custom metadata record that holds the mapping for the fields
     * @param hashCodeToAddressMap          the map of hashcode to addresses that we will be using to upsert address records
     *
     * @return                              a new ucinn_ascendv2__Address_Relation_Record__c record with data from the interim employment
     */

    public ucinn_ascendv2__Address_Relation__c createAddressRelationRecord(ucinn_portal_Interim_Employment__c interimEmployment, Portal_Page_Section_Setting__mdt sectionSetting, Map<String, ucinn_ascendv2__Address__c> hashCodeToAddressMap) {

        ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c();

        ucinn_ascendv2__Address_Relation__c record = new ucinn_ascendv2__Address_Relation__c ();

        if (sectionSetting.Portal_Section_Field_Settings__r != null) {
            for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                if (String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                    if (fieldSetting.Field_API_Name__c.contains('.')) {
                        List<String> fields = fieldSetting.Field_API_Name__c.split('\\.');
                        if (fields.size() < 2) {
                            System.debug('PORTAL_BATCH_ProcessPendingEmployment createAddressRecord field name is wrong for ' + sectionSetting.Label + ' for field ' + fieldSetting.Field_API_Name__c);
                            continue;
                        } else {
                            if (fieldSetting.Field_API_Name__c.contains('ucinn_ascendv2__Address__r')) {
                                address.put(fields.get(fields.size()-1), interimEmployment.get(fieldSetting.Staging_Record_Field_API_Name__c));
                            }
                        }
                    } else {
                        if (fieldSetting.Field_Type__c == PORTAL_CONST_PageSectionSetting.CHECKBOX_FIELD_NAME && interimEmployment.get(fieldSetting.Staging_Record_Field_API_Name__c) == null) {
                            record.put(fieldSetting.Field_API_Name__c, false);
                        } else {
                            record.put(fieldSetting.Field_API_Name__c, interimEmployment.get(fieldSetting.Staging_Record_Field_API_Name__c));
                        }

                    }

                }
            }
        }

        String hashCode = PORTAL_CommunityUtils.hashObjectFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_SOBJECT_TYPE => ((SObject) Type.forName('ucinn_ascendv2__Address__c').newInstance()).getSObjectType(), PORTAL_CommunityUtils.PARAM_SOBJECT_RECORD => address});

        address.ucinn_ascendv2__External_System_ID__c = hashCode;

        hashCodeToAddressMap.put(hashCode, address);

        // if (String.isNotBlank(sectionSetting.Record_Type_Developer_Name__c)) {
        //     Schema.RecordTypeInfo recordTypeInfo = Schema.SObjectType.ucinn_ascendv2__Address_Relation__c.getRecordTypeInfosByDeveloperName().get(sectionSetting.Record_Type_Developer_Name__c);
        //     if (recordTypeInfo == null) {
        //         System.debug('PORTAL_BATCH_ProcessPendingEmployment createAddressRelationRecord record type is wrong for section ' + sectionSetting.Label);
        //     } else {
        //         record.RecordTypeId = recordTypeInfo.getRecordTypeId();
        //     }
        // }
        record.ucinn_ascendv2__Address__r = new ucinn_ascendv2__Address__c(ucinn_ascendv2__External_System_Id__c = hashCode);

        return record;
    }
}