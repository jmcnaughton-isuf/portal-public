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
 * Base class for adding constitutes to a zone membership based on proximity of their active addresses.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
global virtual without sharing class PORTAL_BATCH_AddZoneMembershipsBase implements PORTAL_BatchInterface {
    ucinn_portal_Zone__c currentZoneRecord;
    Portal_Membership_Setting__mdt currentZoneRecordTypeMetadata;
    Set<Id> zoneIdsToSkipSet;

    /**
     * Set zone record to go over and its realted custom metadata record
     *
     * @param   zoneIdsToSkipSet                                 Id's that should be skiped
     * @since
     */
    global virtual void batchConstructor(Set<Id> zoneIdsToSkipSet) {
        this.zoneIdsToSkipSet = zoneIdsToSkipSet;
        List<ucinn_portal_Zone__c> zoneList = queryZones(this.zoneIdsToSkipSet);
        String recordName = '';

        if (!zoneList.isEmpty()) {
            this.currentZoneRecord = zoneList[0];
            recordName = zoneList[0].RecordType.DeveloperName;
        }

        if (String.isNotBlank(recordName)) {
            List<Portal_Membership_Setting__mdt> zoneCustomMetadataRecord = [SELECT id, Constituent_Types_To_Add_To_Zones__c, Constituent_Types_To_Exclude_To_Zones__c, Values_For_Checking_Is_On_Newsletter__c
                                                                             FROM Portal_Membership_Setting__mdt
                                                                             WHERE Record_Type__c = :recordName];

            if (!zoneCustomMetadataRecord.isEmpty()) {
                this.currentZoneRecordTypeMetadata = zoneCustomMetadataRecord[0];
            }
        }

    }

    /**
     * Create query based on portal membership custom metadata to find the constituent that are candidates to be added to the current zone.
     *
     * @param   context                                     Current batch context.
     * @return                                              Query locator for constieutns to potentially add to zone.
     * @since                                               1.0
     */
    global virtual Database.QueryLocator batchStart(Database.BatchableContext bc) {
        if (this.currentZoneRecord == null) {
            System.abortJob(bc.getJobId());
        }

        Id currentZoneId = this.currentZoneRecord.Id;
        Decimal currentZoneSearchRadius = this.currentZoneRecord.Search_Radius__c;
        Decimal currentZoneLatitude = this.currentZoneRecord.Geolocation__latitude__s;
        Decimal currentZoneLongitude = this.currentZoneRecord.Geolocation__longitude__s;
        String constituentTypesToExclude = this.currentZoneRecordTypeMetadata.Constituent_Types_To_Exclude_To_Zones__c;
        String constituentTypesToInclude = this.currentZoneRecordTypeMetadata.Constituent_Types_To_Add_To_Zones__c;

        //zone memberships are based on service indicators that are active and preferred address
        String queryString = 'SELECT Id, ucinn_ascendv2__Contact_Type__c FROM Contact ';
        queryString += ' WHERE Id NOT IN ( SELECT Constituent__c FROM ucinn_portal_Zone_Membership__c WHERE Zone__c = :currentZoneId) '; // check if constituent has an existing zone memebrship
        queryString += ' AND Id IN (SELECT ucinn_ascendv2__Contact__c FROM ucinn_ascendv2__Address_Relation__c WHERE ucinn_ascendv2__Status__c = \'' + PORTAL_CONST_Global.ADDRESS_RELATION_STATUS_CURRENT + '\' AND DISTANCE(ucinn_ascendv2__Address__r.ucinn_ascendv2__Location__c, GEOLOCATION(:currentZoneLatitude, :currentZoneLongitude), \'mi\') < :currentZoneSearchRadius) ';

        if (String.isNotBlank(constituentTypesToExclude)) {
            queryString += ' AND ucinn_ascendv2__Contact_Type__c EXCLUDES (:constituentTypesToExclude) ';
        }

        if (String.isNotBlank(constituentTypesToInclude)) {
            queryString += ' AND ucinn_ascendv2__Contact_Type__c INCLUDES (:constituentTypesToInclude) ';
        }

        return Database.getQueryLocator(queryString);
    }

    /**
     * Add constituents to the zone directly (no case process). If they have a matching service indicator then is on newsletter field
     * Will be false.
     *
     * @param   BC                                          Current batch context.
     * @param   contactList                                 List of contacts to add to zone.
     * @since                                               1.0
     */
    global virtual void batchExecute(Database.BatchableContext BC, List<SObject> contactList) {
        Set<Id> constituentIdsSet = new Set<Id>();
        Map<Id, Set<String>> constituentIdToActiveServiceIndicatorValuesMap = new Map<Id, Set<String>>();
        Set<String> serviceIndicatorsToExcludeFromNewsletterSet = convertStringToSet(this.currentZoneRecordTypeMetadata.Values_For_Checking_Is_On_Newsletter__c);

        for (Contact eachCurrentContact : (List<Contact>)contactList) {
            constituentIdsSet.add(eachCurrentContact.Id);
        }

        List<ucinn_ascendv2__Service_Indicator__c> constituentServiceIndicators = [SELECT Id, ucinn_ascendv2__Service_Indicator_Value__r.ucinn_ascendv2__Code__c, ucinn_ascendv2__Contact__c
                                                                                   FROM ucinn_ascendv2__Service_Indicator__c
                                                                                   WHERE ucinn_ascendv2__Service_Indicator_Value__r.ucinn_ascendv2__Code__c IN :serviceIndicatorsToExcludeFromNewsletterSet
                                                                                     AND ucinn_ascendv2__Is_Active__c = true
                                                                                     AND ucinn_ascendv2__Service_Indicator_Value__c != null
                                                                                     AND ucinn_ascendv2__Contact__c IN :constituentIdsSet];

        // map constituent id to set of active service indicator values
        for (ucinn_ascendv2__Service_Indicator__c eachCurrentServiceIndicator : constituentServiceIndicators) {
            if (constituentIdToActiveServiceIndicatorValuesMap.containsKey(eachCurrentServiceIndicator.ucinn_ascendv2__Contact__c)) {
                Set<String> currentConstituentValues = constituentIdToActiveServiceIndicatorValuesMap.get(eachCurrentServiceIndicator.ucinn_ascendv2__Contact__c);
                currentConstituentValues.add(eachCurrentServiceIndicator.ucinn_ascendv2__Service_Indicator_Value__r.ucinn_ascendv2__Code__c);
            } else {
                constituentIdToActiveServiceIndicatorValuesMap.put(eachCurrentServiceIndicator.ucinn_ascendv2__Contact__c, new Set<String>{eachCurrentServiceIndicator.ucinn_ascendv2__Service_Indicator_Value__r.ucinn_ascendv2__Code__c});
            }
        }

        List<ucinn_portal_Zone_Membership__c> zoneMembershipsToInsertList = getZoneMembershipsToInsert(constituentIdToActiveServiceIndicatorValuesMap, (List<Contact>)contactList);
        insert zoneMembershipsToInsertList;
    }

    /**
     * Add the current zone we went over to the list of zone ids we have gone through. Then check if there are any more zones left.
     * If there are zones left call the batch again.
     *
     * @param   BC                                          Current batch context
     * @since                                               1.0
     */
    global virtual void batchFinish(Database.BatchableContext BC) {
        this.zoneIdsToSkipSet.add(this.currentZoneRecord.Id);

        List<ucinn_portal_Zone__c> zonesLeftList = queryZones(this.zoneIdsToSkipSet);

        if (zonesLeftList != null && !zonesLeftList.isEmpty()) {
            Database.executeBatch(new PORTAL_BATCH_AddZoneMemberships(this.zoneIdsToSkipSet));
        }
    }

    /**
     * Query for zones to add constituents too
     *
     * @param   zoneIdsToSkipSet                            Set of zone ids that have already been checked.
     * @return                                              List of zone records to go through.
     * @since                                               1.0
     */
    global virtual List<ucinn_portal_Zone__c> queryZones(Set<Id> zoneIdsToSkipSet) {
        return [SELECT Id, RecordType.DeveloperName, Geolocation__longitude__s, Geolocation__latitude__s, Search_Radius__c
                    FROM ucinn_portal_Zone__c
                    WHERE Id NOT IN :zoneIdsToSkipSet
                    AND Geolocation__longitude__s != null
                    AND Geolocation__latitude__s != null
                    AND Search_Radius__c != null
                    AND Is_Display_On_Portal__c = true
                    LIMIT 1];
    }

    /**
     * Convert string to set by using ',' as the delimeter.
     *
     * @param valuesForCheckingIsOnNewsletter               String values to check if is on Newsletter
     * @return                                              Set of the string components split on ','
     * @since                                               1.0
     */
    private Set<String> convertStringToSet(String valuesForCheckingIsOnNewsletter) {
        Set<String> returnSet = new Set<String>();

        if (String.isNotEmpty(valuesForCheckingIsOnNewsletter)) {
            List<String> valuesForCheckingIsOnNewsletterList = valuesForCheckingIsOnNewsletter.split(',');
            for (String eachValue : valuesForCheckingIsOnNewsletterList) {
                returnSet.add(eachValue.trim());
            }
        }

        return returnSet;
    }

    /**
     * Get zone memberships to insert
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param constituentIdToActiveServiceIndicatorValuesMap    Mapping of constituent ids to active service indicators
     * @param contactList                                       List of contacts
     *
     * @return                                                  List of zone memberships to insert
     */
    private List<ucinn_portal_Zone_Membership__c> getZoneMembershipsToInsert(Map<Id, Set<String>> constituentIdToActiveServiceIndicatorValuesMap, List<Contact> contactList) {
        List<ucinn_portal_Zone_Membership__c> resultList = new List<ucinn_portal_Zone_Membership__c>();

        if (contactList == null || contactList.isEmpty()) {
            return resultList;
        }

        for (Contact eachContact : contactList) {
            Boolean isOnNewsletter = true;

            if (constituentIdToActiveServiceIndicatorValuesMap?.get(eachContact.Id) != null) {
                isOnNewsletter = false;
            }

            // create zone membership
            resultList.add(new ucinn_portal_Zone_Membership__c(Is_On_Newsletter__c = isOnNewsletter,
                                                               Is_Show_On_Directory__c = true,
                                                               Zone__c = this.currentZoneRecord.Id,
                                                               Status__c = PORTAL_CONST_ClubAndGroups.ZONE_MEMBERSHIP_STATUS_ACTIVE,
                                                               Constituent__c = eachContact.Id)
            );
        }

        return resultList;
    }
}