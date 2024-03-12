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
 * Handles trigger logic for the Volunteer object.
 *
 * @author      Aaron Wong
 * @version     1.0
 * @since       1.0
 */

global virtual inherited sharing class PORTAL_TRIG_VolunteerHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        handleContactUpdate((List<ucinn_portal_Volunteer__c>) newList, (List<ucinn_portal_Volunteer__c>) oldList, triggerAction);

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    private static void handleContactUpdate(List<ucinn_portal_Volunteer__c> newList, List<ucinn_portal_Volunteer__c> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        Set<String> contactIdSet = getContactIdSetToUpdate(newList, oldList, triggerAction);

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return;
        }

        List<Contact> contactList = [SELECT id ,ucinn_portal_Total_Volunteer_Hours__c,
                                            (SELECT id, Hours_Reported__c FROM ucinn_portal_Volunteers_Contact__r WHERE Application_Status__c = :PORTAL_CONST_Volunteers.VOLUNTEER_STATUS_COMPLETED)
                                     FROM Contact
                                     WHERE Id IN :contactIdSet];

        if (contactList == null || contactList.isEmpty()) {
            return;
        }

        List<Contact> contactListToUpdate = new List<Contact>();

        // Recalculate total volunteer hours for each constituent
        for (Contact eachContact : contactList) {
            if (eachContact.ucinn_portal_Volunteers_Contact__r == null || eachContact.ucinn_portal_Volunteers_Contact__r.isEmpty() && eachContact.ucinn_portal_Total_Volunteer_Hours__c != 0) {
                eachContact.ucinn_portal_Total_Volunteer_Hours__c = 0;
                contactListToUpdate.add(eachContact);
                continue;
            }

            Decimal totalHoursReported = 0;

            for (ucinn_portal_Volunteer__c eachVolunteer : eachContact.ucinn_portal_Volunteers_Contact__r) {
                if (eachVolunteer.Hours_Reported__c == null) {
                    eachVolunteer.Hours_Reported__c = 0;
                }

                totalHoursReported = totalHoursReported + eachVolunteer.Hours_Reported__c;
            }

            if (eachContact.ucinn_portal_Total_Volunteer_Hours__c != totalHoursReported) {
                eachContact.ucinn_portal_Total_Volunteer_Hours__c = totalHoursReported;
                contactListToUpdate.add(eachContact);
            }
        }

        update contactListToUpdate;
    }

    private static Set<String> getContactIdSetToUpdate(List<ucinn_portal_Volunteer__c> newList, List<ucinn_portal_Volunteer__c> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        Set<String> resultSet = new Set<String>();

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            for (ucinn_portal_Volunteer__c eachVolunteer : newList) {
                if (eachVolunteer.Application_Status__c == PORTAL_CONST_Volunteers.VOLUNTEER_STATUS_COMPLETED) {
                    resultSet.add(eachVolunteer.Contact__c);
                }
            }
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            Map<String, ucinn_portal_Volunteer__c> oldMap = new Map<String, ucinn_portal_Volunteer__c>();

            for (ucinn_portal_Volunteer__c eachOldVolunteer : oldList) {
                oldMap.put(eachOldVolunteer.Id, eachOldVolunteer);
            }

            for (ucinn_portal_Volunteer__c eachNewVolunteer : newList) {
                ucinn_portal_Volunteer__c eachOldVolunteer = oldMap.get(eachNewVolunteer.Id);

                if ((eachNewVolunteer.Application_Status__c == PORTAL_CONST_Volunteers.VOLUNTEER_STATUS_COMPLETED || eachOldVolunteer.Application_Status__c == PORTAL_CONST_Volunteers.VOLUNTEER_STATUS_COMPLETED)
                        && (eachNewVolunteer.Application_Status__c != eachOldVolunteer.Application_Status__c || eachNewVolunteer.Hours_Reported__c != eachOldVolunteer.Hours_Reported__c)) {
                    resultSet.add(eachNewVolunteer.Contact__c);
                }
            }

        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete) {
            for (ucinn_portal_Volunteer__c eachVolunteer : oldList) {
                if (eachVolunteer.Application_Status__c == PORTAL_CONST_Volunteers.VOLUNTEER_STATUS_COMPLETED) {
                    resultSet.add(eachVolunteer.Contact__c);
                }
            }
        }

        return resultSet;
    }
}