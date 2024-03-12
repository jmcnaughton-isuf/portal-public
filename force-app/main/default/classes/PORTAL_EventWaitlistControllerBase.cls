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
 * Class containing logic for event waitlisting.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
public inherited sharing virtual class PORTAL_EventWaitlistControllerBase {
    public static final Map<String, String> mergeFieldToWaitlistEntryFieldMap = new Map<String, String> {
        'FirstName' => 'First_Name__c',
        'LastName' => 'Last_Name__c',
        'Email' => 'Email__c',
        'NumberOfTicketsRequested' => 'Number_of_Tickets_Awaiting__c',
        'TicketTypeName' => 'Ticket_Type_Name__c'
    };

    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String EMAIL_KEY = 'email';
    public static final String TICKET_TYPE_ID = 'ticketTypeId';
    public static final String NUMBER_OF_TICKETS = 'numberOfTickets';
    public static final String WAITLIST_ENTRY_ID = 'waitlistEntryId';

    public static final String ERROR_CONTACT_ADMIN = 'There was an issue processing your registration. Please contact an Administrator.';
    public static final String ERROR_TOO_MANY_TICKETS = 'You have waitlisted for too many tickets.';

    /**
     * Waitlist Registrant for the event.
     *
     * @author Aaron Wong
     *
     * @param firstName             The first name of the registrant.
     * @param lastName              The last name of the registrant.
     * @param email                 The email of the registrant.
     * @param ticketTypeId          The ticket type Id to waitlist for.
     * @param numberOfTickets       The number of tickets to waitlist.
     * @param recaptchaToken        The client side recaptcha token to be verified
     * @since                   1.0
     */
    public virtual void waitlistRegistrant(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN
            });
        }

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_EventWaitlistControllerBase.waitlistRegistrant', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        String firstName = (String)params.get(FIRST_NAME);
        String lastName = (String)params.get(LAST_NAME);
        String email = (String)params.get(EMAIL_KEY);
        String ticketTypeId = (String)params.get(TICKET_TYPE_ID);
        Decimal numberOfTickets = (Decimal)params.get(NUMBER_OF_TICKETS);

        if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)
                || String.isBlank(ticketTypeId) || numberOfTickets == null || numberOfTickets < 1) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN
            });
        }

        ucinn_portal_Event_Waitlist_Entry__c waitlistEntryToInsert = new ucinn_portal_Event_Waitlist_Entry__c(First_Name__c = firstName,
                                                                                                              Last_Name__c = lastName,
                                                                                                              Email__c = email,
                                                                                                              Ticket_Type__c = ticketTypeId,
                                                                                                              Number_of_Tickets_Awaiting__c = numberOfTickets);

        // throws error on validations
        validateWaitlistEntry(waitlistEntryToInsert);

        insert waitlistEntryToInsert;

        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList = [SELECT id, First_Name__c, Last_Name__c,
                                                                               Email__c, Number_of_Tickets_Awaiting__c, Number_of_Tickets_Available__c,
                                                                               Ticket_Type_Name__c, Ticket_Type__c, Listing__c
                                                                        FROM ucinn_portal_Event_Waitlist_Entry__c
                                                                        WHERE id = :waitlistEntryToInsert.Id];

        PORTAL_UTIL_Events.emailWaitlistEntryList(new Map<String, Object>{
            PORTAL_UTIL_Events.WAITLIST_ENTRY_LIST => waitlistEntryList,
            PORTAL_UTIL_Events.EMAIL_TEMPLATE_NAME => PORTAL_CONST_Events.EMAIL_TEMPLATE_PORTAL_EVENT_WAITLIST_REGISTRATION,
            PORTAL_UTIL_Events.MERGE_FIELD_TO_WAITLIST_ENTRY_FIELD_MAP => mergeFieldToWaitlistEntryFieldMap
        });
    }

    /**
     * Deletes the waitlist entry given.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryId       The Id of the waitlist entry to delete.
     * @since                       1.0
     */
    public virtual void deleteWaitlistEntry(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN
            });
        }

        String waitlistEntryId = (String)params.get(WAITLIST_ENTRY_ID);

        if (String.isBlank(waitlistEntryId)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN
            });
        }

        delete new ucinn_portal_Event_Waitlist_Entry__c(Id = waitlistEntryId);
    }

    public virtual ucinn_portal_Event_Waitlist_Entry__c getWaitlistEntryById(Map<String, Object> params) {
        String waitlistEntryId = (String)params?.get(WAITLIST_ENTRY_ID);

        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList = [SELECT Id
                                                                        FROM ucinn_portal_Event_Waitlist_Entry__c
                                                                        WHERE Id = :waitlistEntryId
                                                                        AND (Number_of_Tickets_Available__c > 0
                                                                            OR Number_of_Tickets_Awaiting__c > 0)];

        if (waitlistEntryList == null || waitlistEntryList.isEmpty()) {
            return null;
        }

        return waitlistEntryList.get(0);
    }

    /**
     * Gets the waitlisting maximum default.
     *
     * @author Aaron Wong
     *
     * @return The waitlisting maximum default.
     * @since  1.0
     */
    public virtual Decimal getWaitlistingMaxDefault() {
        return 999999999;
    }

    /**
     * Validates the waitlist entry provided
     *
     * @author Aaron Wong
     *
     * @param waitlistEntry     The waitlist entry to validate.
     * @since                   1.0
     */
    private void validateWaitlistEntry(ucinn_portal_Event_Waitlist_Entry__c waitlistEntry) {
        if (waitlistEntry == null) {
            return;
        }

        List<ucinn_portal_Ticket_Type__c> ticketTypeList = [SELECT id, Max_Tickets_Per_Registrant__c, Listing__r.Number_of_Guests__c
                                                            FROM ucinn_portal_Ticket_Type__c
                                                            WHERE Id = :waitlistEntry.Ticket_Type__c];

        if (ticketTypeList == null || ticketTypeList.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN
            });
        }

        ucinn_portal_Ticket_Type__c ticketTypeRecord = ticketTypeList.get(0);

        if (waitlistEntry.Number_of_Tickets_Awaiting__c > getMaximumNumberOfTicketsToWaitlist(ticketTypeRecord)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_TOO_MANY_TICKETS
            });
        }
    }

    /**
     * Gets the maximum number of tickets that can be waitlisted at a time.
     *
     * @author Aaron Wong
     *
     * @param ticketTypeRecord      Ticket type record used for calculation
     * @since                       1.0
     */
    private Decimal getMaximumNumberOfTicketsToWaitlist(ucinn_portal_Ticket_Type__c ticketTypeRecord) {
        if (ticketTypeRecord == null
                || ticketTypeRecord.Max_Tickets_Per_Registrant__c == null
                || ticketTypeRecord.Listing__r.Number_of_Guests__c == null) {
            return getWaitlistingMaxDefault();
        }

        return ticketTypeRecord.Max_Tickets_Per_Registrant__c * (ticketTypeRecord.Listing__r.Number_of_Guests__c + 1);
    }

    /**
     * Allocate tickets for each listing's waitlist based on FIFO ordering and ticket availability 
     * Assumes each listing's waitlist is enabled if it has related waitlist entries 
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param listingIdSet      Set<Id>: set of listing IDs to activate waitlist entries for
     */
    public virtual void activateWaitlists(Set<Id> listingIdSet) {
        Map<String, List<ucinn_portal_Event_Waitlist_Entry__c>> listingIdToWaitlistMap = getListingIdToWaitlistMap(listingIdSet);

        if (listingIdToWaitlistMap.isEmpty()) {
            return;
        }

        Set<String> listingsWithWaitlistSet = listingIdToWaitlistMap.keySet();
        Map<String, Decimal> listingTicketAvailabilityMap = PORTAL_UTIL_Events.getTicketAvailabilityForListings(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID_SET => listingsWithWaitlistSet});
        Map<String, Object> ticketTypeAvailabilityMap = PORTAL_UTIL_Events.getAvailableTicketsForTicketTypes(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID_SET => listingsWithWaitlistSet});

        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryListToUpdate = new List<ucinn_portal_Event_Waitlist_Entry__c>();

        for (String eachListingId : listingsWithWaitlistSet) {
            waitlistEntryListToUpdate.addAll(getWaitlistEntriesToUpdate(listingIdToWaitlistMap.get(eachListingId), listingTicketAvailabilityMap, ticketTypeAvailabilityMap));
        }

        update waitlistEntryListToUpdate;
    }

    /**
     * Helper method that queries for each listing's Waitlist Entries and returns a mapping between listing id and the listing's waitlist
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param listingIdSet      Set<Id>: listings to update the waitlist of
     * 
     * @return map of listing ID to the listing's list of waitlist entries 
     */
    private Map<String, List<ucinn_portal_Event_Waitlist_Entry__c>> getListingIdToWaitlistMap(Set<Id> listingIdSet) {
        Map<String, List<ucinn_portal_Event_Waitlist_Entry__c>> listingIdToWaitlistMap = new Map<String, List<ucinn_portal_Event_Waitlist_Entry__c>>();
        if (listingIdSet == null || listingIdSet.isEmpty()) {
            return listingIdToWaitlistMap;
        }

        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList = [SELECT Id, Number_of_Tickets_Awaiting__c, Number_of_Tickets_Available__c, Ticket_Type__c, Ticket_Type__r.Listing__c
                                                                        FROM ucinn_portal_Event_Waitlist_Entry__c
                                                                        WHERE Ticket_Type__r.Listing__c IN :listingIdSet
                                                                        AND Number_of_Tickets_Awaiting__c > 0
                                                                        ORDER BY CreatedDate ASC];

        for (ucinn_portal_Event_Waitlist_Entry__c eachWaitlistEntry : waitlistEntryList) {
            if (listingIdToWaitlistMap.containsKey(eachWaitlistEntry.Ticket_Type__r.Listing__c) == false) {
                listingIdToWaitlistMap.put(eachWaitlistEntry.Ticket_Type__r.Listing__c, new List<ucinn_portal_Event_Waitlist_Entry__c>());
            }

            listingIdToWaitlistMap.get(eachWaitlistEntry.Ticket_Type__r.Listing__c).add(eachWaitlistEntry);
        }

        return listingIdToWaitlistMap;
    }

    /**
     * Helper method to allocate newly available tickets for a particular listing's waitlist
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param listingWaitlist                   List<ucinn_portal_Event_Waitlist_Entry__c>: complete waitlist for one listing, could have multiple ticket types 
     * @param listingTicketAvailabilityMap      Map<String, Decimal>: listing id to number of tickets available (based on listing's maximum), may be mutated 
     * @param ticketTypeAvailabilityMap         Map<String, Object>: ticket type id to number of tickets available (based on ticket type's maximum), may be mutated
     * 
     * @return List<ucinn_portal_Event_Waitlist_Entry__c> of waitlist entries with changed ticket quantities (no DML update yet)
     */
    @TestVisible
    private List<ucinn_portal_Event_Waitlist_Entry__c> getWaitlistEntriesToUpdate(List<ucinn_portal_Event_Waitlist_Entry__c> listingWaitlist, Map<String, Decimal> listingTicketAvailabilityMap, Map<String, Object> ticketTypeAvailabilityMap) {
        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryListToUpdate = new List<ucinn_portal_Event_Waitlist_Entry__c>();

        if (listingWaitlist == null || listingTicketAvailabilityMap == null || ticketTypeAvailabilityMap == null) {
            return waitlistEntryListToUpdate;
        }

        for (ucinn_portal_Event_Waitlist_Entry__c eachWaitlistEntry : listingWaitlist) {
            String listingId = eachWaitlistEntry?.Ticket_Type__r?.Listing__c;
            Decimal listingAvailability = listingTicketAvailabilityMap.get(listingId);
            if (listingAvailability == null || listingAvailability <= 0) {
                break;
            }

            String ticketTypeId = eachWaitlistEntry.Ticket_Type__c;
            Decimal ticketTypeAvailability = (Decimal) ticketTypeAvailabilityMap.get(ticketTypeId);
            if (ticketTypeAvailability == null || ticketTypeAvailability <= 0) {
                continue;
            }

            Decimal ticketsToAllocate = Math.min(Math.min(listingAvailability, ticketTypeAvailability), eachWaitlistEntry.Number_of_Tickets_Awaiting__c);

            eachWaitlistEntry.Number_of_Tickets_Available__c = ticketsToAllocate + (eachWaitlistEntry.Number_of_Tickets_Available__c != null ? eachWaitlistEntry.Number_of_Tickets_Available__c : 0);
            eachWaitlistEntry.Number_of_Tickets_Awaiting__c -= ticketsToAllocate;

            listingTicketAvailabilityMap.put(listingId, listingAvailability - ticketsToAllocate);
            ticketTypeAvailabilityMap.put(ticketTypeId, ticketTypeAvailability - ticketsToAllocate);

            waitlistEntryListToUpdate.add(eachWaitlistEntry);
        }

        return waitlistEntryListToUpdate;
    }
}