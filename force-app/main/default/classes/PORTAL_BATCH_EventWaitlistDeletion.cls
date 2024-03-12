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

public virtual class PORTAL_BATCH_EventWaitlistDeletion implements Database.Batchable<sObject>, Schedulable {
    public PORTAL_BATCH_EventWaitlistDeletion() {}

    public virtual Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime currentDateTime = Datetime.now();
        return Database.getQueryLocator('SELECT Id, First_Name__c, Last_Name__c, Email__c, Number_of_Tickets_Awaiting__c, Number_of_Tickets_Available__c, Ticket_Type_Name__c, Ticket_Type__c, Listing__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Expiration_Date_Time__c <= :currentDateTime');
    }

    public virtual void execute(Database.BatchableContext context, List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList) {
        notifyWaitlistEntries(waitlistEntryList);
        delete waitlistEntryList;
    }

    public virtual void finish(Database.BatchableContext context) {}

    public virtual void execute(SchedulableContext scon) {
      Database.executeBatch(new PORTAL_BATCH_EventWaitlistDeletion(), 100);
    }

    private void notifyWaitlistEntries(List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList) {
        PORTAL_UTIL_Events.emailWaitlistEntryList(new Map<String, Object>{
            PORTAL_UTIL_Events.WAITLIST_ENTRY_LIST => waitlistEntryList,
            PORTAL_UTIL_Events.EMAIL_TEMPLATE_NAME => PORTAL_CONST_Events.EMAIL_TEMPLATE_EVENT_WAITLIST_EXPIRATION,
            PORTAL_UTIL_Events.MERGE_FIELD_TO_WAITLIST_ENTRY_FIELD_MAP => PORTAL_EventWaitlistControllerBase.mergeFieldToWaitlistEntryFieldMap
        });
    }
}