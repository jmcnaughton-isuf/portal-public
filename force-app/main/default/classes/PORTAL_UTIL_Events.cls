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
 * Utility Class containing logic for events
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
public without sharing class PORTAL_UTIL_Events {
    public static final String CONTACT_ID = 'contactId';
    public static final String DISCOUNT_RECORD = 'discountRecord';
    public static final String DISCOUNT_PRICE = 'discountPrice';
    public static final String LISTING_C_KEY = 'Listing__c';
    public static final String LISTING_ID = 'listingId';
    public static final String LISTING_ID_SET = 'listingIdSet';
    public static final String PROMO_CODE_LIST = 'promoCodeList';
    public static final String TICKET_TYPE_ID = 'ticketTypeId';
    public static final String TICKET_TYPE_ID_SET = 'ticketTypeIdSet';
    public static final String TICKET_DISCOUNT_ID = 'ticketDiscountId';
    public static final String TOTAL_TICKETS = 'totalTickets';
    public static final String TOTAL_INVALID_TICKETS = 'totalInvalidTickets';
    public static final String WAITLIST_SIZE = 'waitlistSize';
    public static final String WAITLIST_ENTRY_LIST = 'waitlistEntryList';
    public static final String EMAIL_TEMPLATE_NAME = 'emailTemplateName';
    public static final String MERGE_FIELD_TO_WAITLIST_ENTRY_FIELD_MAP = 'mergeFieldToWaitlistEntryFieldMap';
    public static final String REGISTRATION_LINK = 'RegistrationLink';
    public static final String REMOVE_WAITLIST_ENTRY_LINK = 'RemoveWaitlistEntryLink';
    public static final String DEFAULT_EVENT_REGISTRATION_URL = 'event-registration';
    public static final String DEFAULT_SENDER_DISPLAY_NAME = 'Events';
    public static final Decimal DEFAULT_MAX_TICKETS = 9999999;

    /**
     * Gets the discounted price for ticket types with the given promo codes.
     *
     * @author Aaron Wong
     *
     * @param promoCodeList     List of promo codes to get discounts for.
     * @param listingId         The listing to search for ticket discounts for.
     * @return                  Map of ticket type Ids to ticket discount data.
     * @since                   1.0
     */
    public static Map<String, Map<String, Object>> getDiscountFromPromoCodes(Map<String, Object> params) {
        /* Map of ticket Type Id to psuedo ticket discount */
        Map<String, Map<String, Object>> resultMap = new Map<String, Map<String,Object>>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        List<String> promoCodeList = (List<String>)params.get(PROMO_CODE_LIST);
        String listingId = (String)params.get(LISTING_ID);

        if (promoCodeList == null || promoCodeList.isEmpty()) {
            return resultMap;
        }

        DateTime currentDateTime = DateTime.now();

        List<ucinn_portal_Ticket_Discount__c> discountList = getTicketDiscountList(null, null, promoCodeList, listingId);

        if (discountList == null || discountList.isEmpty()) {
            return resultMap;
        }

        resultMap = getTicketTypeIdToDiscountDataMap(discountList);

        return resultMap;
    }

    /**
     * Checks if the given listing has promo codes associated with it.
     *
     * @author Aaron Wong
     *
     * @param listingId     Listing Id to check.
     * @return              True if there is a ticket discount.
     * @since               1.0
     */
    public static Boolean isListingHasPromoCodes(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return false;
        }

        String listingId = (String)params.get(LISTING_ID);

        DateTime currentDateTime = DateTime.now();
        List<ucinn_portal_Ticket_Discount__c> discountList = [SELECT id
                                                              FROM ucinn_portal_Ticket_Discount__c
                                                              WHERE Ticket_Type__r.Listing__c = :listingId
                                                              AND Promo_Code__c != null
                                                              AND (Start_Date_Time__c < :currentDateTime OR Start_Date_Time__c = null)
                                                              AND (End_Date_Time__c > :currentDateTime OR End_Date_Time__c = null)];

        if (discountList == null || discountList.isEmpty()) {
            return false;
        }

        return true;
    }

    /**
     * Gets the discounted price for a ticket.
     *
     * @author Aaron Wong
     *
     * @param discountRecord    The discount record to get the discounted price with.
     * @return                  The discounted price.
     * @since                   1.0
     */
    public static Decimal getDiscountedPrice(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return null;
        }

        ucinn_portal_Ticket_Discount__c discountRecord = (ucinn_portal_Ticket_Discount__c)params.get(DISCOUNT_RECORD);

        if (discountRecord == null) {
            return null;
        }

        if (discountRecord.Discount_Type__c == PORTAL_CONST_Events.TICKET_DISCOUNT_TYPE_FREE) {
            return 0;
        } else if (discountRecord.Discount_Type__c == PORTAL_CONST_Events.TICKET_DISCOUNT_TYPE_PRICE) {
            return discountRecord.Adjusted_Price__c;
        } else if (discountRecord.Discount_Type__c == PORTAL_CONST_Events.TICKET_DISCOUNT_TYPE_PERCENTAGE) {
            Decimal price = discountRecord.Ticket_Type__r.Price__c;

            if (price == null || discountRecord.Discount_Percentage__c == null) {
                return price;
            }

            return price - (price * discountRecord.Discount_Percentage__c * .01);
        }

        return null;
    }

    /**
     * Gets the ticket availability for a listing.
     *
     * @author Aaron Wong
     *
     * @param listingId     The Id of the Listing to get the ticket availability for.
     * @return              Map containing the ticket availability for the Listing.
     * @since               1.0
     */
    public static Map<String, Object> getAvailableTicketsForListing(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || String.isBlank((String)params.get(LISTING_ID))) {
            return resultMap;
        }

        String listingId = (String)params.get(LISTING_ID);

        // Total Tickets Sold for listing and ticket type includes invalid tickets
        List<ucinn_portal_Listing__c> listingList = [SELECT id, Total_Tickets_Sold__c, Maximum_Number_of_Enrollment__c,
                                                            (SELECT id, Total_Tickets_Available__c, Total_Number_of_Tickets__c
                                                             FROM ucinn_portal_Ticket_Types_Listing__r)
                                                     FROM ucinn_portal_Listing__c
                                                     WHERE id = :listingId];

        if (listingList == null || listingList.isEmpty()) {
            return resultMap;
        }

        // Get sum of invalid tickets
        List<AggregateResult> ticketTypeTotals = [SELECT Ticket_Type__c, SUM(Number_of_Tickets__c) totalInvalidTickets
                                                  FROM ucinn_portal_Ticket__c
                                                  WHERE Ticket_Type__r.Listing__c = :listingId
                                                  AND Is_Valid_Ticket__c = false 
                                                  GROUP BY Ticket_Type__c];

        // Get sum of tickets reserved for waitlist entries
        List<AggregateResult> waitlistTotals = [SELECT Listing__c, SUM(Total_Waitlisted_Tickets_Available__c) waitlistSize 
                                                FROM ucinn_portal_Ticket_Type__c
                                                WHERE Listing__c = :listingId
                                                GROUP BY Listing__c];

        Map<String, Decimal> ticketTypeIdToTotalInvalidTickets = new Map<String, Decimal>();
        Decimal totalInvalidTickets = 0;

        for (AggregateResult resultRecord : ticketTypeTotals) {
            totalInvalidTickets = totalInvalidTickets + (Decimal)resultRecord.get(TOTAL_INVALID_TICKETS);
            ticketTypeIdToTotalInvalidTickets.put((String)resultRecord.get(PORTAL_CONST_Events.TICKET_TYPE_API_NAME),
                                                  (Decimal)resultRecord.get(TOTAL_INVALID_TICKETS));
        }

        Decimal waitlistSize = 0;
        for (AggregateResult resultRecord : waitlistTotals) {
            waitlistSize += (Decimal) resultRecord.get(WAITLIST_SIZE);
        }

        if (listingList.get(0).Maximum_Number_of_Enrollment__c == null) {
            resultMap.put(TOTAL_TICKETS, DEFAULT_MAX_TICKETS);
        } else {
            resultMap.put(TOTAL_TICKETS, listingList.get(0).Maximum_Number_of_Enrollment__c - listingList.get(0).Total_Tickets_Sold__c - waitlistSize + totalInvalidTickets);
        }

        if (listingList.get(0).ucinn_portal_Ticket_Types_Listing__r == null || listingList.get(0).ucinn_portal_Ticket_Types_Listing__r.isEmpty()) {
            return resultMap;
        }

        for (ucinn_portal_Ticket_Type__c eachTicketType : listingList.get(0).ucinn_portal_Ticket_Types_Listing__r) {
            if (eachTicketType.Total_Number_of_Tickets__c == null) {
                resultMap.put(eachTicketType.Id, DEFAULT_MAX_TICKETS);
            } else {
                if (!ticketTypeIdToTotalInvalidTickets.containsKey(eachTicketType.Id)) {
                    resultMap.put(eachTicketType.Id, eachTicketType.Total_Tickets_Available__c);
                } else {
                    resultMap.put(eachTicketType.Id, eachTicketType.Total_Tickets_Available__c + ticketTypeIdToTotalInvalidTickets.get(eachTicketType.Id));
                }
            }
        }

        return resultMap;
    }

    /**
     * Gets the ticket availability for ticket types.
     *
     * @author Aaron Wong
     *
     * @param listingId             The Id of the Listing to get the ticket availability for.
     * @param ticketTypeIdSet       The ticket types to get availability for.
     * @return                      Map containing the ticket availability for the Listing.
     * @since                       1.0
     */
    public static Map<String, Object> getAvailableTicketsForTicketTypes(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        Set<String> listingIdSet = (Set<String>)params.get(LISTING_ID_SET);
        Set<String> ticketTypeIdSet = (Set<String>)params.get(TICKET_TYPE_ID_SET);

        String ticketTypeQueryString = 'SELECT id, Total_Tickets_Available__c, Total_Number_of_Tickets__c FROM ucinn_portal_Ticket_Type__c ';
        String ticketTypeWhereClause = '';

        if (listingIdSet != null) {
            ticketTypeWhereClause = ' WHERE Listing__c IN :listingIdSet';
        } else if (ticketTypeIdSet != null) {
            ticketTypeWhereClause = ' WHERE id IN :ticketTypeIdSet';
        } else {
            return resultMap;
        }

        if (ticketTypeIdSet == null) {
            ticketTypeIdSet = new Set<String>();
        }

        List<ucinn_portal_Ticket_Type__c> ticketTypeList = Database.query(ticketTypeQueryString + ticketTypeWhereClause);

        if (ticketTypeList == null || ticketTypeList.isEmpty()) {
            return resultMap;
        }

        // Get sum of invalid tickets
        List<AggregateResult> ticketTypeTotals = [SELECT Ticket_Type__c, SUM(Number_of_Tickets__c) totalInvalidTickets
                                                  FROM ucinn_portal_Ticket__c
                                                  WHERE (Ticket_Type__r.Listing__c IN :listingIdSet
                                                        OR Ticket_Type__c IN :ticketTypeIdSet)
                                                  AND Is_Valid_Ticket__c = false 
                                                  GROUP BY Ticket_Type__c];

        Map<String, Decimal> ticketTypeIdToTotalInvalidTickets = new Map<String, Decimal>();

        for (AggregateResult resultRecord : ticketTypeTotals) {
            ticketTypeIdToTotalInvalidTickets.put((String)resultRecord.get(PORTAL_CONST_Events.TICKET_TYPE_API_NAME), (Decimal)resultRecord.get(TOTAL_INVALID_TICKETS));
        }

        for (ucinn_portal_Ticket_Type__c eachTicketType : ticketTypeList) {
            if (eachTicketType.Total_Number_of_Tickets__c == null) {
                resultMap.put(eachTicketType.Id, DEFAULT_MAX_TICKETS);
            } else {
                if (!ticketTypeIdToTotalInvalidTickets.containsKey(eachTicketType.Id)) {
                    resultMap.put(eachTicketType.Id, eachTicketType.Total_Tickets_Available__c);
                } else {
                    resultMap.put(eachTicketType.Id, eachTicketType.Total_Tickets_Available__c + ticketTypeIdToTotalInvalidTickets.get(eachTicketType.Id));
                }
            }
        }

        return resultMap;
    }

    /**
     * Gets a set of ticket type Ids with tickets in the shopping cart.
     * Can pass params that restrict the check to a single user
     *
     * @author Aaron Wong
     *
     * @param listingId                 The listing Id to get ticket types for.
     * @param primaryParticipationId    Primary participation id 
     * @param contactId                 Contact Id
     * 
     * @return              Set of ticket types with tickets in the shopping cart.
     * @since               1.0
     */
    public static Set<String> getTicketTypesWithTicketsInCart(Map<String, Object> params) {
        String listingId = (String)params?.get(LISTING_ID);
        String primaryParticipationId = (String)params?.get(PORTAL_EventRegistrationControllerBase.PRIMARY_PARTICIPATION_ID);
        String contactId = (String)params?.get(PORTAL_EventRegistrationControllerBase.CONTACT_ID);
        Set<String> resultSet = new Set<String>();

        if (String.isBlank(listingId)) {
            return resultSet;
        }

        String currentUserFilter = '';
        if (String.isNotBlank(primaryParticipationId)) {
            currentUserFilter = ' AND (Participation__r.Id = \'' + primaryParticipationId + '\' OR Participation__r.Primary_Participation__c = \'' + primaryParticipationId + '\') ' ;
        } 
        // different check is needed to account for filtering guest user's tickets, since a guest's contact id is null
        else if (params.containsKey(PORTAL_EventRegistrationControllerBase.CONTACT_ID)) {
            currentUserFilter = ' AND Participation__r.Purchasing_Constituent__c = ' + (String.isBlank(contactId) ? 'null ' : ('\'' + contactId + '\' '));
        }

        String queryString = 'SELECT Id ' +
                             'FROM ucinn_portal_Ticket_Type__c ' + 
                             'WHERE Id IN (SELECT Ticket_Type__c ' +
                                          'FROM ucinn_portal_Ticket__c ' +
                                          'WHERE Is_Valid_Ticket__c = true ' +
                                           currentUserFilter +
                                          'AND Registration_Session__r.Status__c != \'' + PORTAL_CONST_EVENTS.REGISTRATION_SESSION_STATUS_COMPLETED + '\'' +
                                          'AND Registration_Session__r.Status__c != \'' + PORTAL_CONST_EVENTS.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION + '\')';

        List<ucinn_portal_Ticket_Type__c> ticketTypeList = Database.query(queryString);

        if (ticketTypeList == null || ticketTypeList.isEmpty()) {
            return resultSet;
        }

        for (ucinn_portal_Ticket_Type__c eachTicketType : ticketTypeList) {
            resultSet.add(eachTicketType.Id);
        }

        return resultSet;
    }

    /**
     * Gets the total tickets available for the listings.
     *
     * @author Aaron Wong
     *
     * @param listingIdSet      The Ids of the listings to check availability.
     * @return                  Total Tickets available for the listings.
     * @since                   1.0
     */
    public static Map<String, Decimal> getTicketAvailabilityForListings(Map<String, Object> params) {
        Map<String, Decimal> resultMap = new Map<String, Decimal>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        Set<String> listingIdSet = (Set<String>)params.get(LISTING_ID_SET);

        if (listingIdSet == null || listingIdSet.isEmpty()) {
            return resultMap;
        }

        List<ucinn_portal_Listing__c> listingList = [SELECT id, Total_Tickets_Sold__c, Maximum_Number_of_Enrollment__c
                                                     FROM ucinn_portal_Listing__c
                                                     WHERE id IN :listingIdSet];

        if (listingList == null || listingList.isEmpty()) {
            return resultMap;
        }

        // Get sum of invalid tickets
        List<AggregateResult> invalidTicketTotals = [SELECT Ticket_Type__r.Listing__c, SUM(Number_of_Tickets__c) totalInvalidTickets
                                                     FROM ucinn_portal_Ticket__c
                                                     WHERE Ticket_Type__r.Listing__c IN :listingIdSet
                                                     AND Is_Valid_Ticket__c = false 
                                                     GROUP BY Ticket_Type__r.Listing__c];

        // Get sum of tickets reserved for waitlist entries
        List<AggregateResult> waitlistTotals = [SELECT Listing__c, SUM(Total_Waitlisted_Tickets_Available__c) waitlistSize 
                                                FROM ucinn_portal_Ticket_Type__c
                                                WHERE Listing__c IN :listingIdSet
                                                GROUP BY Listing__c];

        Map<String, Double> listingIdToInvalidTickets = new Map<String, Double>();
        Map<String, Double> listingIdToWaitlistSize = new Map<String, Double>();

        for (AggregateResult eachResult : invalidTicketTotals) {
            listingIdToInvalidTickets.put((String) eachResult.get(LISTING_C_KEY), (Double) eachResult.get(TOTAL_INVALID_TICKETS));
        }

        for (AggregateResult eachResult : waitlistTotals) {
            listingIdToWaitlistSize.put((String) eachResult.get(LISTING_C_KEY), (Double) eachResult.get(WAITLIST_SIZE));
        }

        for (ucinn_portal_Listing__c eachListing : listingList) {
            if (eachListing.Maximum_Number_of_Enrollment__c == null) {
                resultMap.put(eachListing.Id, DEFAULT_MAX_TICKETS);
            } else {
                Decimal availableTickets = eachListing.Maximum_Number_of_Enrollment__c - eachListing.Total_Tickets_Sold__c;
                if (listingIdToWaitlistSize.containsKey(eachListing.Id)) {
                    availableTickets -= listingIdToWaitlistSize.get(eachListing.Id);
                }
                if (listingIdToInvalidTickets.containsKey(eachListing.Id)) {
                    availableTickets += listingIdToInvalidTickets.get(eachListing.Id);
                }
                resultMap.put(eachListing.Id, availableTickets);
            }
        }

        return resultMap;
    }

    /**
     * Gets ticket type discounts for constituents based on their constituent attributes.
     *
     * @author Aaron Wong
     *
     * @param ticketTypeIdSet   Set of ticket type ids to check for discounts.
     * @param constituentId     The constituent's Id.
     * @return                  Map of ticket type Id to discount data.
     * @since                   1.0
     */
    public static Map<String, Map<String, Object>> getTicketTypeDiscountsForConstituent(Map<String, Object> params) {
        Map<String, Map<String, Object>> resultMap = new Map<String, Map<String, Object>>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        Set<String> ticketTypeIdset = (Set<String>)params.get(TICKET_TYPE_ID_SET);
        String constituentId = (String)params.get(CONTACT_ID);

        if (ticketTypeIdSet == null || ticketTypeIdSet.isEmpty() || String.isBlank(constituentId)) {
            return resultMap;
        }

        Set<String> recipientIdSet = PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(
                                                                new Map<String, Object>{
                                                                    PORTAL_UTIL_Recipients.CONTACT_ID => constituentId,
                                                                    PORTAL_UTIL_Recipients.TICKET_TYPE_ID_SET => ticketTypeIdSet});

        if (recipientIdSet == null || recipientIdSet.isEmpty()) {
            return resultMap;
        }

        List<ucinn_portal_Ticket_Discount__c> ticketDiscountList = getTicketDiscountList(recipientIdSet, ticketTypeIdSet, null, null);

        if (ticketDiscountList == null || ticketDiscountList.isEmpty()) {
            return resultMap;
        }

        resultMap = getTicketTypeIdToDiscountDataMap(ticketDiscountList);

        return resultMap;
    }

    /**
     * Gets a map of ticket type Ids to possible discounted prices for the ticket type.
     *
     * @author Aaron Wong
     *
     * @param listingId     The listing Id to get ticket discounts for.
     * @return              Map of type Ids to map of ticket discounts to prices.
     * @since               1.0
     */
     public static Map<String, Map<String, Decimal>> getTicketTypeIdToDiscountMapFromListingId(Map<String, Object> params) {
        Map<String, Map<String, Decimal>> resultMap = new Map<String, Map<String, Decimal>>();

        if (params == null || String.isBlank((String)params.get(LISTING_ID))) {
            return resultMap;
        }

        String listingId = (String)params.get(LISTING_ID);

        List<ucinn_portal_Ticket_Discount__c> discountList = getTicketDiscountList(null, null, null, listingId);

        if (discountList == null || discountList.isEmpty()) {
            return resultMap;
        }

        for (ucinn_portal_Ticket_Discount__c eachDiscount : discountList) {
            Decimal discountedPrice = getDiscountedPrice(new Map<String, Object>{DISCOUNT_RECORD => eachDiscount});

            if (!resultMap.containsKey(eachDiscount.Ticket_Type__c)) {
                resultMap.put(eachDiscount.Ticket_Type__c, new Map<String, Decimal>{eachDiscount.Id => discountedPrice});
            } else {
                resultMap.get(eachDiscount.Ticket_Type__c).put(eachDiscount.Id, discountedPrice);
            }
        }

        return resultMap;
     }

    /**
     * Generates a map of ticket type Id to discount data. Generates the lowest price for the ticket types
     * with the given ticket discount records. Also stores the Ticket Discount Id.
     *
     * @author Aaron Wong
     *
     * @param ticketDiscountList    List of ticket discounts used to generate the map.
     * @return                      Map of ticket type Id to discount data.
     * @since                       1.0
     */
    private static Map<String, Map<String, Object>> getTicketTypeIdToDiscountDataMap(List<ucinn_portal_Ticket_Discount__c> ticketDiscountList) {
        Map<String, Map<String, Object>> resultMap = new Map<String, Map<String, Object>>();

        if (ticketDiscountList == null || ticketDiscountList.isEmpty()) {
            return resultMap;
        }

        for (ucinn_portal_Ticket_Discount__c eachDiscount : ticketDiscountList) {
            Decimal discountedPrice = getDiscountedPrice(new Map<String, Object>{DISCOUNT_RECORD => eachDiscount});

            if (discountedPrice == null) {
                discountedPrice = eachDiscount.Ticket_Type__r.Price__c;
            }

            if (!resultMap.containsKey(eachDiscount.Ticket_Type__c)
                    || (Decimal)(resultMap.get(eachDiscount.Ticket_Type__c).get(DISCOUNT_PRICE)) > discountedPrice) {
                Map<String, Object> discountDataMap = new Map<String, Object>{TICKET_DISCOUNT_ID => eachDiscount.Id,
                                                                              DISCOUNT_PRICE => discountedPrice};
                resultMap.put(eachDiscount.Ticket_Type__c, discountDataMap);
            }
        }

        return resultMap;
    }

    /**
     * Generates a ticket discount list based on the parameters provided.
     *
     * @author Aaron Wong
     *
     * @param recipientIdSet        Set of recipient Ids to filter list by.
     * @param ticketTypeIdSet       Set of ticket type Ids to filter list by.
     * @param promoCodeList         List of promo codes to filter list by.
     * @param listingId             Listing id to filter list by.
     * @return                      List of ticket discounts.
     * @since                       1.0
     */
    @TestVisible
    private static List<ucinn_portal_Ticket_Discount__c> getTicketDiscountList(Set<String> recipientIdSet,
                                                                               Set<String> ticketTypeIdSet,
                                                                               List<String> promoCodeList,
                                                                               String listingId) {
        List<ucinn_portal_Ticket_Discount__c> resultList = new List<ucinn_portal_Ticket_Discount__c>();
        DateTime currentDateTime = DateTime.now();
        String queryString = ' SELECT';
        String fields = ' id, Adjusted_Price__c, Discount_Type__c, Discount_Percentage__c, Ticket_Type__c, Ticket_Type__r.Price__c ';
        String whereClause = ' WHERE (Start_Date_Time__c < :currentDateTime OR Start_Date_Time__c = null)'
                           + ' AND (End_Date_Time__c > :currentDateTime OR End_Date_Time__c = null) ';

        if (recipientIdSet != null) {
            whereClause = whereClause + ' AND Recipient__c IN :recipientIdSet ';
        }

        if (ticketTypeIdSet != null) {
            whereClause = whereClause + ' AND Ticket_Type__c IN :ticketTypeIdSet';
        }

        if (promoCodeList != null) {
            whereClause = whereClause + ' AND Promo_Code__c IN :promoCodeList';
        }

        if (String.isNotBlank(listingId)) {
            whereClause = whereClause + ' AND Ticket_Type__r.Listing__c = \'' + listingId + '\' ';
        }

        queryString = queryString + fields + ' FROM ucinn_portal_Ticket_Discount__c ' + whereClause;

        resultList = Database.query(queryString);

        return resultList;
    }

    /**
     * Emails the waitlist entries given.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryList                     List of waitlist entries to send emails to.
     * @param mergeFieldToWaitlistEntryFieldMap     Map of email merge fields to the corresponding field on Event Waitlist Entry.
     * @param emailTemplateName                     Developer Name of the email template to use.
     * @since                                       1.0
     */
    public static void emailWaitlistEntryList(Map<String, Object> params) {
        String debugLog = 'PORTAL_UTIL_Events.emailWaitlistEntryList: ';

        if (params == null || params.isEmpty()) {
            System.debug(debugLog + 'No Params');
            return;
        }

        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList = (List<ucinn_portal_Event_Waitlist_Entry__c>)params.get(WAITLIST_ENTRY_LIST);
        Map<String, String> mergeFieldToWaitlistEntryFieldMap = (Map<String, String>)params.get(MERGE_FIELD_TO_WAITLIST_ENTRY_FIELD_MAP);
        String emailTemplateName = (String)params.get(EMAIL_TEMPLATE_NAME);

        if (waitlistEntryList == null || waitlistEntryList.isEmpty()
                || mergeFieldToWaitlistEntryFieldMap == null || mergeFieldToWaitlistEntryFieldMap.isEmpty()
                || String.isBlank(emailTemplateName)) {
            System.debug(debugLog + 'Missing Params');
            return;
        }

        EmailTemplate emailTemplateToUse = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{
            PORTAL_CommunityUtils.DEVELOPER_NAME => emailTemplateName
        });

        if (emailTemplateToUse == null) {
            System.debug(debugLog + 'No Email Template');
            return;
        }

        Map<String, User> emailToUserMap = PORTAL_CommunityUtils.getUsersToEmail(new Map<String, Object>{
            PORTAL_CommunityUtils.EMAIL_RECIPIENT_LIST => convertWaitlistEntriesToEmailRecipients(waitlistEntryList)
        });

        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        String baseUrl = PORTAL_CommunityUtils.getPortalURL();
        String eventRegistrationPageUrl = getEventRegistrationPageUrl(new Map<String, Object>());

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{PORTAL_CONST_EVENTS.ORG_SETTING_EVENT_SENDER_DISPLAY_NAME}
        });

        String senderDisplayName = DEFAULT_SENDER_DISPLAY_NAME;

        if (orgSettingList != null && !orgSettingList.isEmpty() && String.isNotBlank(orgSettingList.get(0).Value__c)) {
            senderDisplayName = orgSettingList.get(0).Value__c;
        }

        for (ucinn_portal_Event_Waitlist_Entry__c eachWaitlistEntry : waitlistEntryList) {
            emailMessageList.add(createEmailForWaitlistEntry(eachWaitlistEntry,
                                                             emailToUserMap.get(eachWaitlistEntry.Email__c),
                                                             emailTemplateToUse,
                                                             mergeFieldToWaitlistEntryFieldMap,
                                                             baseUrl,
                                                             eventRegistrationPageUrl));
        }

        PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => emailMessageList});
    }

    /**
     * Gets the Event Registration URL stored in custom metadata.
     *
     * @author Aaron Wong
     *
     * @return  The relative path URl of the event registration page (after /s/).
     * @since   1.0
     */
    public static String getEventRegistrationPageUrl(Map<String, Object> params) {
        String resultString = DEFAULT_EVENT_REGISTRATION_URL;

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{PORTAL_CONST_EVENTS.ORG_SETTING_EVENT_REGISTRATION_URL}
        });

        if (orgSettingList != null && !orgSettingList.isEmpty() && String.isNotBlank(orgSettingList.get(0).Value__c)) {
            resultString = orgSettingList.get(0).Value__c;
        }

        return resultString;
    }

    /**
     * Converts a list of waitlist entry records to a list of email recipient objects.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryList     List of Event Waitlist Entry records.
     * @return                      List of Email Recipients.
     * @since                       1.0
     */
    private static List<PORTAL_CommunityUtils.EmailRecipient> convertWaitlistEntriesToEmailRecipients(List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList) {
        List<PORTAL_CommunityUtils.EmailRecipient> resultList = new List<PORTAL_CommunityUtils.EmailRecipient>();

        if (waitlistEntryList == null || waitlistEntryList.isEmpty()) {
            return resultList;
        }

        for (ucinn_portal_Event_Waitlist_Entry__c eachWaitlistEntry : waitlistEntryList) {
            resultList.add(new PORTAL_CommunityUtils.EmailRecipient(eachWaitlistEntry.First_Name__c,
                                                                    eachWaitlistEntry.Last_Name__c,
                                                                    eachWaitlistEntry.Email__c));
        }

        return resultList;
    }

    /**
     * Creates an email record from the waitlist entry and information provided.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryRecord                   The waitlist entry record we are generating the email for.
     * @param userRecord                            The user record to send the email to.
     * @param emailTemplateName                     Developer Name of the email template to use.
     * @param mergeFieldToWaitlistEntryFieldMap     Map of email merge fields to the corresponding field on Event Waitlist Entry.
     * @param baseUrl                               The base URL of the community.
     * @return                                      A generated email record.
     * @since                                       1.0
     */
    private static Messaging.SingleEmailMessage createEmailForWaitlistEntry(ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord,
                                                                            User userRecord,
                                                                            EmailTemplate emailTemplateToUse,
                                                                            Map<String, String> mergeFieldToWaitlistEntryFieldMap,
                                                                            String baseUrl,
                                                                            String eventRegistrationPageUrl) {
        if (waitlistEntryRecord == null || userRecord == null
                || emailTemplateToUse == null || mergeFieldToWaitlistEntryFieldMap == null
                || mergeFieldToWaitlistEntryFieldMap.isEmpty() || String.isBlank(baseUrl)
                || String.isBlank(eventRegistrationPageUrl)) {
            return null;
        }

        // FirstName => Aaron, LastName => Wong
        Map<String, String> mergeFieldToReplacementValue = new Map<String, String>();

        for (String eachMergeField : mergeFieldToWaitlistEntryFieldMap.keySet()) {
            mergeFieldToReplacementValue.put(eachMergeField, String.valueOf(waitlistEntryRecord.get(mergeFieldToWaitlistEntryFieldMap.get(eachMergeField))));
        }

        mergeFieldToReplacementValue.put(REGISTRATION_LINK, baseUrl + 's/' + eventRegistrationPageUrl + '?recordId=' + waitlistEntryRecord.Listing__c + '&waitlistEntryId=' + waitlistEntryRecord.Id);
        mergeFieldToReplacementValue.put(REMOVE_WAITLIST_ENTRY_LINK, baseUrl + 's/' + eventRegistrationPageUrl + '?recordId=' + waitlistEntryRecord.Listing__c + '&waitlistEntryId=' + waitlistEntryRecord.Id + '&removeEntry=true');

        return PORTAL_CommunityUtils.createEmailRecord(new Map<String, Object>{
            PORTAL_CommunityUtils.USER_ID => userRecord.Id,
            PORTAL_CommunityUtils.SENDER_DISPLAY_NAME => PORTAL_CONST_Events.EMAIL_SENDER_DISPLAY_NAME, //TODO: move to custom metadata
            PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => emailTemplateToUse,
            PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToReplacementValue
        });
    }

    /**
     * Gets whether or not the events provided are available for registration.
     *
     * @author Aaron wong
     *
     * @param listingIdSet      Set of listing Ids.
     * @return                  Map of listing Id to if they have tickets available.
     * @since                   1.0
     */
    public static Map<String, Boolean> getEventAvailability(Set<String> listingIdSet) {
        Map<String, Boolean> resultMap = new Map<String, Boolean>();
        DateTime currentDateTime = DateTime.now();

        if (listingIdSet == null || listingIdSet.isEmpty()) {
            return resultMap;
        }

        List<ucinn_portal_Ticket_Type__c> ticketTypeList = [SELECT Id, Listing__c
                                                            FROM ucinn_portal_Ticket_Type__c
                                                            WHERE Listing__c IN :listingIdSet
                                                            AND (Sales_Start_Date_Time__c <= :currentDateTime OR Sales_Start_Date_Time__c = null)
                                                            AND (Sales_End_Date_Time__c >= : currentDateTime OR Sales_End_Date_Time__c = null)];

        if (ticketTypeList == null || ticketTypeList.isEmpty()) {
            return resultMap;
        }

        Map<String, Decimal> listingIdToTicketAvailabilityMap = getTicketAvailabilityForListings(new Map<String, Object>{LISTING_ID_SET => listingIdSet});
        Map<String, Object> ticketTypeAvailabilityMap = getAvailableTicketsForTicketTypes(new Map<String, Object>{LISTING_ID_SET => listingIdSet});

        for (ucinn_portal_Ticket_Type__c eachTicketType : ticketTypeList) {
            if (ticketTypeAvailabilityMap.containsKey(eachTicketType.Id) && (Decimal)ticketTypeAvailabilityMap.get(eachTicketType.Id) > 0) {
                resultMap.put(eachTicketType.Listing__c, true);
            }
        }

        for (String eachListingId : listingIdToTicketAvailabilityMap.keySet()) {
            if (listingIdToTicketAvailabilityMap.get(eachListingId) <= 0) {
                resultMap.put(eachListingId, false);
            }
        }

        return resultMap;
    }

    /**
     * Get the primary participation IDs of tickets 
     * that belong to a particular guest user registration session 
     * for a given set of listings.
     * 
     * The session Status must be Pending Payment or In Shopping Cart.
     * The user executing this method is expected to be a guest.
     *  
     * @author Jacob Huang
     * @since 1.11
     * 
     * @param listingIdSet  Set<String>: set of listings IDs to use
     * @param cookieId      String: registration session cookie (Session_Id__c) used by a guest
     * 
     * @return Map<String, String> map of listing ID to primary participation ID for the registration session
     */
    public static Map<String, String> getGuestSessionPrimaryParticipationForListings(Set<String> listingIdSet, String cookieId) {
        Map<String, String> listingIdToParticipationIdMap = new Map<String, String>();
        if (listingIdSet == null || listingIdSet.isEmpty() || String.isBlank(cookieId) || String.isNotBlank(PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).ContactId)) {
            return listingIdToParticipationIdMap;
        }

        List<ucinn_portal_Participation__c> participationList = [
            SELECT Id, Listing__c
            FROM ucinn_portal_Participation__c
            WHERE Primary_Participation__c = null AND 
                Purchasing_Constituent__c = null AND 
                Listing__c IN :listingIdSet AND
                Id IN (SELECT Participation__c 
                    FROM ucinn_portal_Ticket__c 
                    WHERE Is_Valid_Ticket__c = true
                    AND Registration_Session__r.Session_Id__c = :cookieId
                    AND (Registration_Session__r.Status__c = :PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART 
                        OR Registration_Session__r.Status__c = :PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT))
        ];

        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            listingIdToParticipationIdMap.put(eachParticipation.Listing__c, eachParticipation.Id);
        }

        return listingIdToParticipationIdMap;
    }
}