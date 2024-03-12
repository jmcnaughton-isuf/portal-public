/*
* Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
*                     http://www.ucinnovation.com
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
* Base controller that houses newsletter methods
*
* @author:  Sam Longo
* @version: 1.0
* @since:   1.0
*/
global virtual inherited sharing class PORTAL_TRIG_ZoneMembershipHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    private ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper dmlWrapper = new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();

    /**
     * Overridden method that handles the trigger actions and calls the relevant logic
     *
     * @author Sam Longo
     * @version 1.0
     * @since 1.0
     *
     * @param newList           changed records from trigger
     * @param oldList           previous values for records from trigger
     * @param triggerAction     name of the trigger action
     * @param objResult         schema describe for the object type
     *
     * @return                  The dmlWrapper with any sObjects to be inserted/updated/deleted
     *
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        List<ucinn_portal_Zone_Membership__c> triggerNew = (List<ucinn_portal_Zone_Membership__c>) newList;
        List<ucinn_portal_Zone_Membership__c> triggerOld = (List<ucinn_portal_Zone_Membership__c>) oldList;

        Map<Id, ucinn_portal_Zone_Membership__c> triggerOldMap = new Map<Id, ucinn_portal_Zone_Membership__c>();
        if (triggerOld != null) {
            triggerOldMap = new Map<Id, ucinn_portal_Zone_Membership__c>(triggerOld);
        }

        updateContactExternalMembership(triggerNew, triggerOldMap, triggerAction);

        return dmlWrapper;
    }

    /**
     * collects a list of contacts where their zone memberships have changed and sends it to the emailhub to update external campaign services where applicable
     *
     * @param triggerNew            updated or new records null if a delete operation
     * @param triggerOldMap         map of Ids to the old record values. null if an insert operation
     *
     * @author Sam Longo
     */
    global void updateContactExternalMembership (List<ucinn_portal_Zone_Membership__c> triggerNew, Map<Id, ucinn_portal_Zone_Membership__c> triggerOldMap, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        Set<Id> contactIdsToUpdate = new Set<Id>();

        if ((triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert || triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUndelete) && triggerNew != null) {
            //for inserts and undeletes no comparisons needed just add all the new records to the set
            for (ucinn_portal_Zone_Membership__c eachNewMembership : triggerNew) {
                contactIdsToUpdate.add(eachNewMembership.Constituent__c);
            }
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate && triggerNew != null && triggerOldMap != null) {
            //on an update we check against the old values to determine if we should make changes
            for (ucinn_portal_Zone_Membership__c eachNewMembership : triggerNew) {
                if (eachNewMembership.Zone__c != triggerOldMap.get(eachNewMembership.Id).Zone__c
                        || eachNewMembership.Constituent__c != triggerOldMap.get(eachNewMembership.Id).Constituent__c
                        || eachNewMembership.Status__c != triggerOldMap.get(eachNewMembership.Id).Status__c) {
                    contactIdsToUpdate.add(eachNewMembership.Constituent__c);
                    contactIdsToUpdate.add(triggerOldMap.get(eachNewMembership.Id).Constituent__c); //for the occasional situation that the constituent changed
                }
            }
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete && triggerOldMap != null) {
            // on a delete we simply add everything in the old map
            for (ucinn_portal_Zone_Membership__c eachDeletedMembership : triggerOldMap.values()) {
                contactIdsToUpdate.add(eachDeletedMembership.Constituent__c);
            }
        }

        if (System.IsBatch() == false && System.isFuture() == false){
            PORTAL_API_EmailHubBase.addOrUpdateContactsToExternalApi(contactIdsToUpdate);
        }
    }
}