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
 * Contains trigger logic for Event Waitlist Entry.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
global virtual inherited sharing class PORTAL_TRIG_EventWaitlistEntryHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    public static Map<String, String> mergeFieldToWaitlistEntryFieldMap = new Map<String, String> {
        'FirstName' => 'First_Name__c',
        'LastName' => 'Last_Name__c',
        'Email' => 'Email__c',
        'NumberOfTicketsAvailable' => 'Number_of_Tickets_Available__c',
        'TicketTypeName' => 'Ticket_Type_Name__c'
    };
    public static final String WAITLIST_EXPIRATION_TIME_IN_HOURS = 'Waitlist_Expiration_Time_in_Hours';

    /**
     * Runs trigger logic.
     *
     * @author Aaron Wong
     *
     * @param newList           Trigger new list.
     * @param oldList           Trigger old list.
     * @param triggerAction     Trigger action being taken.
     * @param objResult         Schema of the trigger object.
     * @since                   1.0
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        List<ucinn_portal_Event_Waitlist_Entry__c> newWaitlistEntryList = (List<ucinn_portal_Event_Waitlist_Entry__c>) newList;
        List<ucinn_portal_Event_Waitlist_Entry__c> oldWaitlistEntryList = (List<ucinn_portal_Event_Waitlist_Entry__c>) oldList;

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            handleNotifyWaitlistedRegistrants(newWaitlistEntryList, oldWaitlistEntryList);
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     * Handles notifying the waitlisted registrants.
     *
     * @author Aaron wong
     *
     * @param newList       Trigger new list.
     * @param oldList       Trigger old List.
     * @since               1.0
     */
    private static void handleNotifyWaitlistedRegistrants(List<ucinn_portal_Event_Waitlist_Entry__c> newList, List<ucinn_portal_Event_Waitlist_Entry__c> oldList) {
        List<ucinn_portal_Event_Waitlist_Entry__c> entryToNotifyList = new List<ucinn_portal_Event_Waitlist_Entry__c>();

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{WAITLIST_EXPIRATION_TIME_IN_HOURS}
        });

        Integer waitlistExpirationTimeInHours = PORTAL_CONST_Events.DEFAULT_WATILIST_EXPIRATION_TIME_IN_HOURS;

        if (orgSettingList != null && !orgSettingList.isEmpty() && String.isNotBlank(orgSettingList.get(0).Value__c)) {
            try {
                waitlistExpirationTimeInHours = Integer.valueOf(orgSettingList.get(0).Value__c);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        Map<String, ucinn_portal_Event_Waitlist_Entry__c> oldMap = new Map<String, ucinn_portal_Event_Waitlist_Entry__c>();

        for (ucinn_portal_Event_Waitlist_Entry__c oldEntry : oldList) {
            oldMap.put(oldEntry.Id, oldEntry);
        }

        for (ucinn_portal_Event_Waitlist_Entry__c eachNewEntry : newList) {
            ucinn_portal_Event_Waitlist_Entry__c eachOldEntry = oldMap.get(eachNewEntry.Id);
            Decimal oldNumberOfTickets = 0;
            Decimal newNumberOfTickets = 0;

            if (eachOldEntry.Number_of_Tickets_Available__c != null) {
                oldNumberOfTickets = eachOldEntry.Number_of_Tickets_Available__c;
            }

            if (eachNewEntry.Number_of_Tickets_Available__c != null) {
                newNumberOfTickets = eachNewEntry.Number_of_Tickets_Available__c;
            }

            if (newNumberOfTickets > oldNumberOfTickets) {
                eachNewEntry.Expiration_Date_Time__c = DateTime.now().addHours(waitlistExpirationTimeInHours);

                entryToNotifyList.add(eachNewEntry);
            }
        }


        emailWaitlistEntries(entryToNotifyList);
    }

    /**
     * Emails the waitlist entries given.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryList     List of waitlist entries to email.
     * @since                       1.0
     */
    private static void emailWaitlistEntries(List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList) {
        PORTAL_UTIL_Events.emailWaitlistEntryList(new Map<String, Object>{
            PORTAL_UTIL_Events.WAITLIST_ENTRY_LIST => waitlistEntryList,
            PORTAL_UTIL_Events.EMAIL_TEMPLATE_NAME => PORTAL_CONST_Events.EMAIL_TEMPLATE_PORTAL_EVENT_WAITLIST_AVAILABLE,
            PORTAL_UTIL_Events.MERGE_FIELD_TO_WAITLIST_ENTRY_FIELD_MAP => mergeFieldToWaitlistEntryFieldMap
        });
    }
}