/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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
 * @author UC Innovation
 * @date 9/16/2021
 * @group Trigger Handlers
 * @description Handler class for Zone Trigger
 */
global virtual inherited sharing class PORTAL_TRIG_ZoneHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    private ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper dmlWrapper = new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    public static final String ZONE_API_NAME = 'ucinn_portal_Zone__c';

    /*******************************************************************************************************
     * @description Overridden method that handles the trigger actions and calls the relevant logic
     * @return The dmlWrapper with any sObjects to be inserted/updated/deleted
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        List<ucinn_portal_Zone__c> triggerNew = (List<ucinn_portal_Zone__c>) newList;
        List<ucinn_portal_Zone__c> triggerOld = (List<ucinn_portal_Zone__c>) oldList;
        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Zone__c.getSObjectType());
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            updateMailingList(triggerNew, triggerOld, triggerAction);
            geolocateZones(triggerNew);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Zone__c.getSObjectType());
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            updateMailingList(triggerNew, triggerOld, triggerAction);
            geolocateZones(triggerNew);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeDelete) {
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete) {
            updateMailingList(triggerNew, triggerOld, triggerAction);
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Zone__c.getSObjectType());
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUndelete) {
            updateMailingList(triggerNew, triggerOld, triggerAction);
        }
        return dmlWrapper;
    }

    /**
     * sends zone Ids to emailhub to process changes for the mailing lists in external service
     *
     * @author Sam Longo
     */
    global void updateMailingList (List<ucinn_portal_Zone__c> triggerNew, List<ucinn_portal_Zone__c> triggerOld, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        Set<Id> zoneIdsToUpdate = new Set<Id>();
        Set<Id> zoneIdsToDelete = new Set<Id>();

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert ||
                triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate ||
                triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUndelete) {
            //for inserts, updates and undeletes we add trigger new
            for (ucinn_portal_Zone__c eachNewZone : triggerNew) {
                zoneIdsToUpdate.add(eachNewZone.Id);
            }
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete) {
            // on a delete we simply add everything in trigger old
            for (ucinn_portal_Zone__c eachDeletedZone : triggerOld) {
                zoneIdsToDelete.add(eachDeletedZone.Id);
            }
        }

        if (System.isBatch() == false && System.isFuture() == false){
            PORTAL_API_EmailHubBase.createOrUpdateExternalMailingLists(zoneIdsToUpdate);
        }
    }

    /**
     * Geolocate zones by passing list of zones and converting the address fields to a single string to geolocate
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   zoneList     List of zones that have been inserted or updated
     * 
     */
    private void geolocateZones(List<ucinn_portal_Zone__c> zoneList) {
        if (zoneList == null || zoneList.isEmpty() || System.isBatch() || System.isFuture()) {
            return;
        }

        Map<String, String> zoneIdToZoneAddressWrapper = new Map<String, String>();

        for (ucinn_portal_Zone__c eachZone : zoneList) {
            if (eachZone == null) {
                continue;
            }

            PORTAL_AddressWrapper addressWrapper = new PORTAL_AddressWrapper();
            addressWrapper.city = eachZone.City__c;
            addressWrapper.state = eachZone.State__c;
            addressWrapper.country = eachZone.Country__c;
            addressWrapper.postalCode = eachZone.Postal_Code__c;

            zoneIdToZoneAddressWrapper.put(eachZone.Id, JSON.serialize(addressWrapper, true));
        }

        if (zoneIdToZoneAddressWrapper?.isEmpty() == false) {
            geolocateAddresses(zoneIdToZoneAddressWrapper);
        }
    }

    /**
     * Use address wrapper to do geolocation callout(s)
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   zoneIdToZoneAddressWrapper     Map of Zone Ids to Addresses Wrapper (serialized as a string so it can be used in a future method)
     * 
     */
    @future(callout = true)
    private static void geolocateAddresses(Map<String, String> zoneIdToZoneAddressWrapper) {
        if (zoneIdToZoneAddressWrapper == null || zoneIdToZoneAddressWrapper.isEmpty()) {
            return;
        }

        List<ucinn_portal_Zone__c> zonesToUpdateList = new List<ucinn_portal_Zone__c>();

        for (String eachZoneId : zoneIdToZoneAddressWrapper.keySet()) {
            PORTAL_AddressWrapper address = (PORTAL_AddressWrapper) JSON.deserialize(zoneIdToZoneAddressWrapper.get(eachZoneId), PORTAL_AddressWrapper.class);
            Double latitude = address.getLatitude();
            Double longitude = address.getLongitude();
            if (latitude != null && longitude != null) {
                zonesToUpdateList.add(new ucinn_portal_Zone__c(Id = (Id)eachZoneId, Geolocation__latitude__s = latitude, Geolocation__longitude__s = longitude));
            }
        }

        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(ZONE_API_NAME, false);
        update zonesToUpdateList;
        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(ZONE_API_NAME, true);
    }
}