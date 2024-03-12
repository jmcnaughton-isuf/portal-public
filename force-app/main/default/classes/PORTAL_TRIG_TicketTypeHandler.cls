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
 * Contains trigger logic for Ticket Types
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
global virtual inherited sharing class PORTAL_TRIG_TicketTypeHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
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
        List<ucinn_portal_Ticket_Type__c> newTicketTypeList = (List<ucinn_portal_Ticket_Type__c>) newList;
        List<ucinn_portal_Ticket_Type__c> oldTicketTypeList = (List<ucinn_portal_Ticket_Type__c>) oldList;

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            handleDatetimeFieldUpdates(newList, null);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            handleDatetimeFieldUpdates(newList, oldList);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            handleWaitlistingForTicketTypes(newTicketTypeList, oldTicketTypeList);
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     * Handles waitlist logic for ticket type trigger.
     *
     * @author Aaron Wong
     *
     * @param newList       Trigger new list.
     * @param oldList       Trigger old List.
     * @since               1.0
     */
    private static void handleWaitlistingForTicketTypes(List<ucinn_portal_Ticket_Type__c> newList, List<ucinn_portal_Ticket_Type__c> oldList) {
        if (newList == null || oldList == null || newList.isEmpty() || oldList.isEmpty()) {
            return;
        }

        Map<String, ucinn_portal_Ticket_Type__c> oldMap = new Map<String, ucinn_portal_Ticket_Type__c>();

        for (ucinn_portal_Ticket_Type__c eachTicketType : oldList) {
            oldMap.put(eachTicketType.Id, eachTicketType);
        }

        Set<Id> listingIdSet = new Set<Id>();

        for (ucinn_portal_Ticket_Type__c eachNewTicketType : newList) {
            ucinn_portal_Ticket_Type__c eachOldTicketType = oldMap.get(eachNewTicketType.Id);

            if (hasAvailableTickets(eachOldTicketType, eachNewTicketType) == true) {
                listingIdSet.add(eachNewTicketType.Listing__c);
            }
        }

        if (listingIdSet.isEmpty()) {
            return;
        }

        PORTAL_EventWaitlistControllerBase controller = (PORTAL_EventWaitlistControllerBase)PORTAL_Utils.getControllerFactory().getEventWaitlistController();
        controller.activateWaitlists(listingIdSet);
    }

    /**
     * See if the updated ticket type has more available tickets than the older version
     *      checks if Total_Tickets_Available__c has increased from the old listing to the new listing 
     *      also checks if Total_Number_of_Tickets__c changed from any number to null (indictes unlimited tickets)
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param oldTicketType     old Ticket Type
     * @param newTicketType     new Ticket Type
     * 
     * @return true if the new/updated ticket type has more available tickets than the old ticket type
     */
    private static Boolean hasAvailableTickets(ucinn_portal_Ticket_Type__c oldTicketType, ucinn_portal_Ticket_Type__c newTicketType) {
        return (oldTicketType.Total_Tickets_Available__c < newTicketType.Total_Tickets_Available__c) || 
               (oldTicketType.Total_Number_of_Tickets__c != null && newTicketType.Total_Number_of_Tickets__c == null);
    }

    private static void handleDatetimeFieldUpdates(List<ucinn_portal_Ticket_Type__c> newList, List<ucinn_portal_Ticket_Type__c> oldList) {
        Map<String, ucinn_portal_Ticket_Type__c> oldMap = new Map<String, ucinn_portal_Ticket_Type__c>();

        if (oldList != null) {
            for (ucinn_portal_Ticket_Type__c eachOldRecord : oldList) {
                oldMap.put(eachOldRecord.Id, eachOldRecord);
            }
        }

        for (ucinn_portal_Ticket_Type__c eachNewRecord : newList) {
            ucinn_portal_Ticket_Type__c oldRecord = oldMap.get(eachNewRecord.Id);
            String oldTimeZone = '';
            if (oldRecord != null) {
                oldTimeZone = oldRecord.Time_Zone__c;
            }

            validateAndUpdateDateTimeFields(eachNewRecord, oldRecord, 'Sales_Start_Date_Time__c', 'Actual_Sales_Start_Date_Time__c', eachNewRecord.Time_Zone__c, oldTimeZone);
            validateAndUpdateDateTimeFields(eachNewRecord, oldRecord, 'Sales_End_Date_Time__c', 'Actual_Sales_End_Date_Time__c', eachNewRecord.Time_Zone__c, oldTimeZone);
        }
    }

    private static void validateAndUpdateDateTimeFields(sObject newRecord, sObject oldRecord, String dateTimeFieldAPIName, String stringFieldAPIName, String newTimeZone, String oldTimeZone) {
        try {
            PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_NEW_RECORD => newRecord,
                                                                                          PORTAL_CommunityUtils.PARAM_OLD_RECORD => oldRecord,
                                                                                          PORTAL_CommunityUtils.PARAM_DATE_TIME_FIELD_API_NAME => dateTimeFieldAPIName,
                                                                                          PORTAL_CommunityUtils.PARAM_STRING_FIELD_API_NAME => stringFieldAPIName,
                                                                                          PORTAL_CommunityUtils.PARAM_NEW_TIME_ZONE => newTimeZone,
                                                                                          PORTAL_CommunityUtils.PARAM_OLD_TIME_ZONE => oldTimeZone});
        } catch (System.TypeException e) {// invalid format for datetimte
            System.debug(e);
        }
    }
}