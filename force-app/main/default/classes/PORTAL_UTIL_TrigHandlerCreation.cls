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
 * Portal Trigger Handler Creation
 *
 * @author  Phillip Nguyen
 * @since   1.0
 */
public virtual without sharing class PORTAL_UTIL_TrigHandlerCreation {

    public class PortalTriggerHandlerClass {
        public String name;
        public String className;
        public String objectName;
        public String triggerAction;
        public Boolean isActive;
        public Boolean isAsync;
        public Boolean isUserManaged;
        public Integer loadOrder;

        public PortalTriggerHandlerClass(String name, String className, String objectName, String triggerAction) {
            this.name = name;
            this.className = className;
            this.objectName = objectName;
            this.triggerAction = triggerAction;
            this.isActive = true;
            this.isAsync = false;
            this.isUserManaged = false;
            this.loadOrder = 1;
        }
    }

    /**
     * Creates trigger handler classes from a set of mappings
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @return  A list of trigger handler classes
     */
    public static List<PortalTriggerHandlerClass> createTriggerHandlerObjects() {
        List<PortalTriggerHandlerClass> portalTrigHandlerList = new List<PortalTriggerHandlerClass>();
        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Event Waitlist Entry Handler', 
                                                                'PORTAL_TRIG_EventWaitlistEntryHandler',
                                                                'ucinn_portal_Event_Waitlist_Entry__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Ticket Type Handler', 
                                                                'PORTAL_TRIG_TicketTypeHandler',
                                                                'ucinn_portal_Ticket_Type__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Zone Handler', 
                                                                'PORTAL_TRIG_ZoneHandler',
                                                                'ucinn_portal_Zone__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal TRIG Newsletter Section Handler', 
                                                                'PORTAL_TRIG_NewsletterSectionHandler',
                                                                'ucinn_portal_Newsletter_Section__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Zone Membership Handler', 
                                                                'PORTAL_TRIG_ZoneMembershipHandler',
                                                                'ucinn_portal_Zone_Membership__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Job Trigger Handler', 
                                                                'PORTAL_TRIG_JobHandler',
                                                                'ucinn_portal_Job__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Listing Trigger Handler', 
                                                                'PORTAL_TRIG_ListingHandler',
                                                                'ucinn_portal_Listing__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Case Handler', 
                                                                'PORTAL_TRIG_CaseHandler',
                                                                'Case',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Contact Handler', 
                                                                'PORTAL_TRIG_ContactHandler',
                                                                'Contact',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Society Membership Handler', 
                                                                'PORTAL_TRIG_SocietyMembershipHandler',
                                                                'ucinn_ascendv2__Society_Membership__c',
                                                                'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete'));

        portalTrigHandlerList.add(new PortalTriggerHandlerClass('Portal Contact Search Handler', 
                                                                'PORTAL_TRIG_DirectorySearchHandler',
                                                                'Contact',
                                                                'BeforeDelete;AfterInsert;AfterUpdate'));


        return portalTrigHandlerList;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    }

    /**
     * Creates Portal ascend Trigger Handlers and inserts them
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     */
    public static void createPortalTriggerHandlers() {
        List<PortalTriggerHandlerClass> portalTrigHandlerList = createTriggerHandlerObjects();

        if (portalTrigHandlerList == null || portalTrigHandlerList.isEmpty()) {
            return;
        }

        List<ucinn_ascendv2__Trigger_Handler__c> ascendTriggerHandlerListToInsert = new List<ucinn_ascendv2__Trigger_Handler__c>();

        for (PortalTriggerHandlerClass eachPortalTriggerHandler : portalTrigHandlerList) {
            ucinn_ascendv2__Trigger_Handler__c newAscendTriggerHandler = new ucinn_ascendv2__Trigger_Handler__c();
            newAscendTriggerHandler.Name = eachPortalTriggerHandler.name;
            newAscendTriggerHandler.ucinn_ascendv2__Class__c = eachPortalTriggerHandler.className;
            newAscendTriggerHandler.ucinn_ascendv2__Object__c = eachPortalTriggerHandler.objectName;
            newAscendTriggerHandler.ucinn_ascendv2__Trigger_Action__c = eachPortalTriggerHandler.triggerAction;
            newAscendTriggerHandler.ucinn_ascendv2__Is_Active__c = eachPortalTriggerHandler.isActive;
            newAscendTriggerHandler.ucinn_ascendv2__Is_Asynchronous__c = eachPortalTriggerHandler.isAsync;
            newAscendTriggerHandler.ucinn_ascendv2__Is_User_Managed__c = eachPortalTriggerHandler.isUserManaged;
            newAscendTriggerHandler.ucinn_ascendv2__Load_Order__c = eachPortalTriggerHandler.loadOrder;
            
            ascendTriggerHandlerListToInsert.add(newAscendTriggerHandler);
        }

        insert ascendTriggerHandlerListToInsert;
    }
}