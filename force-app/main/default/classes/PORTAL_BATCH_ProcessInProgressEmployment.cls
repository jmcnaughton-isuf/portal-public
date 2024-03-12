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
 * batch class that takes an interim employment and creates an affiliation
 * that links the interim employment account to the interim's contact
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */
public virtual with sharing class PORTAL_BATCH_ProcessInProgressEmployment implements Database.Batchable<sObject>{

    List<Portal_Page_Section_Setting__mdt> relatedRecordSettingList = new List<Portal_Page_Section_Setting__mdt>();


    /**
     * Constructor that retrieves the custom metadata records that will be used
     * for mapping the interim employment fields to affiliation records
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     */
    public PORTAL_BATCH_ProcessInProgressEmployment() {
        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords('Hiring Manager', '', '');
        for (Portal_Page_Section_Setting__mdt pageSectionSetting : pageSectionSettingList) {
            if (String.isNotBlank(pageSectionSetting.SObject_API_Name__c) && pageSectionSetting.SObject_API_Name__c == 'ucinn_ascendv2__Affiliation__c') {
                relatedRecordSettingList.add(pageSectionSetting);
            }
        }
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
        for (Portal_Page_Section_Setting__mdt relatedRecordSetting: relatedRecordSettingList) {
            if (relatedRecordSetting.Portal_Section_Field_Settings__r != null) {
                for (Portal_Section_Field_Setting__mdt fieldSetting : relatedRecordSetting.Portal_Section_Field_Settings__r) {
                    if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c)) {
                        System.debug(fieldSetting.Staging_Record_Field_API_Name__c);
                        fieldsToQuery.add(fieldSetting.Staging_Record_Field_API_Name__c);
                    }
                }
            }
        }
        fieldsToQuery.add('Account__c');
        fieldsToQuery.add('Interim__r.ucinn_ascendv2__Contact__c');
        fieldsToQuery.add('Id');
        String queryString = 'SELECT ' + String.join(new List<String>(fieldsToQuery), ',')  + ' FROM ucinn_portal_Interim_Employment__c '
                            + ' WHERE Status__c = \'In Progress\' AND Account__c != null AND Interim__r.ucinn_ascendv2__Contact__c != null';
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

        Map<Id, ucinn_ascendv2__Affiliation__c> interimEmploymentIdToAffiliationMap = new Map<Id, ucinn_ascendv2__Affiliation__c>();

        for (ucinn_portal_Interim_Employment__c interimEmployment : interimEmploymentList) {
            ucinn_ascendv2__Affiliation__c eachAffiliationRecord = new ucinn_ascendv2__Affiliation__c();

            for (Portal_Page_Section_Setting__mdt relatedRecordSetting: relatedRecordSettingList) {
                //populate fields
                if (relatedRecordSetting.Portal_Section_Field_Settings__r != null) {
                    for (Portal_Section_Field_Setting__mdt fieldSetting : relatedRecordSetting.Portal_Section_Field_Settings__r) {
                        if (String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c) && String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                            eachAffiliationRecord.put(fieldSetting.Field_API_Name__c, interimEmployment.get(fieldSetting.Staging_Record_Field_API_Name__c));
                        }
                    }
                }

                if (String.isNotBlank(relatedRecordSetting.Record_Type_Developer_Name__c)) {
                    Schema.RecordTypeInfo recordTypeInfo =  Schema.getGlobalDescribe().get(eachAffiliationRecord.getSObjectType().getDescribe().getName()).getDescribe().getRecordTypeInfosByDeveloperName().get(relatedRecordSetting.Record_Type_Developer_Name__c);
                    if (recordTypeInfo == null) {
                        System.debug('PORTAL_BATCH_ProcessInProgressEmployment execute record type name is wrong for section ' + relatedRecordSetting.Label);
                    } else {
                        eachAffiliationRecord.put('RecordTypeId', recordTypeInfo.getRecordTypeId());
                    }
                }

                if (String.isNotBlank(relatedRecordSetting.Active_Record_Field_Map__c)) {
                    Map<String, Object> fieldMap = (Map<String, Object>) System.JSON.deserializeUntyped(relatedRecordSetting.Active_Record_Field_Map__c);
                    for (String field : fieldMap.keySet()) {
                        eachAffiliationRecord.put(field, fieldMap.get(field));
                    }
                }
            }
            eachAffiliationRecord.ucinn_ascendv2__Contact__c = interimEmployment.Interim__r.ucinn_ascendv2__Contact__c;
            eachAffiliationRecord.ucinn_ascendv2__Account__c = interimEmployment.Account__c;

            interimEmploymentIdToAffiliationMap.put(interimEmployment.Id, eachAffiliationRecord);
        }

        List<Database.SaveResult> saveResultList = Database.insert(interimEmploymentIdToAffiliationMap.values(), false);
        List<ucinn_portal_Interim_Employment__c> interimEmploymentsToUpdate = new  List<ucinn_portal_Interim_Employment__c>();
        for (Id interimEmploymentId : interimEmploymentIdToAffiliationMap.keyset()) {
            ucinn_portal_Interim_Employment__c interimEmployment = new ucinn_portal_Interim_Employment__c();
            interimEmployment.Id = interimEmploymentId;
            if (String.isNotBlank(interimEmploymentIdToAffiliationMap.get(interimEmploymentId).Id)) {
                interimEmployment.Status__c = PORTAL_CONST_CommunityUser.COMPLETED;
            } else {
                interimEmployment.Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                interimEmployment.Manual_Review_Reason__c += 'Could not create affiliation for this interim employment. ';
            }
            interimEmploymentsToUpdate.add(interimEmployment);
        }

        Database.update(interimEmploymentsToUpdate, false);
    }

    /**
     * finish method for batch class
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     */
    public virtual void finish(Database.BatchableContext BC) {

    }
}