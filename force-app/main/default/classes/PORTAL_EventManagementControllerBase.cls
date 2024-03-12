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
 * Class containing logic for event management dashboard
 *
 * @author              Phillip Nguyen
 * @version             1.0
 * @since               1.0
 */
global inherited sharing virtual class PORTAL_EventManagementControllerBase {
    public static final String PARTICIPATION_LIST = 'participationList';
    public static final String PARTICIPATION_COUNT_TOTAL = 'participationCountTotal';
    public static final String ATTENDED_PARTICIPATION_COUNT_TOTAL = 'attendedParticipationCountTotal';
    public static final String SEARCH_PARTICIPATION_COUNT_TOTAL = 'searchParticipationCountTotal';

    public static final String FULL_NAME = 'fullName';
    public static final String HAS_ATTENDED = 'hasAttended';
    public static final String STATUS_KEY = 'status';
    public static final String SEARCH_KEY = 'search';
    public static final String PARTICIPATION_ID = 'participationId';
    public static final String EVENT_ID = 'eventId';
    public static final String EVENT_NAME = 'eventName';
    public static final String ATTENDEES_TEXT = 'Attendees';
    public static final String ATTEND_VALUE = 'attendValue';

    public static final String NAME_KEY = 'name';
    public static final String OFFSET_KEY = 'offset';
    public static final Boolean TRUE_KEY = true;
    public static final Integer QUERY_LIMIT = 200;
    public static final Integer OFFSET_LIMIT = 2000;

    public static final String ERROR_NO_ACCESS = 'There was an error accessing this page. Please contact an administrator.';
    public static final String ERROR_GENERAL_MESSAGE = 'There was an error obtaining your records. Please contact an administrator.';
    public static final String ERROR_INSUFFICIENT_ACCESS = 'There was an error accessing this page. Please contact an administrator';
    public static final String ERROR_CHECK_IN = 'There was an error admitting this registrant.';

    /**
     * Attendee class used to store event attendee infomation
     * Used by Name Tag & Download RSVP List VF Pages
     *
     * @author          Phillip Nguyen
     * @since           1.0
     */
    public class Attendee implements Comparable{
        public String firstName {get; set;}
        public string lastName {get; set;}
        public String degreeString {get; set;}
        public String primaryRegistrantName {get; set;}
        public Set<String> ticketTypeNameSet {get; set;}
        public String nameTag {get; set;}

        public Attendee(String firstName, String lastName, String nameTag) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.nameTag = nameTag;
        }

        public Attendee(String firstName, String lastName, String nameTag, String degreeString, String primaryRegistrantName, Set<String> ticketTypeNameSet) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.nameTag = nameTag;
            this.degreeString = degreeString;
            this.primaryRegistrantName = primaryRegistrantName;
            this.ticketTypeNameSet = ticketTypeNameSet;
        }

        public Integer compareTo(Object compareTo) {
            Attendee compareToAttendee = (Attendee)compareTo;
            if (this.lastName > compareToAttendee.lastName) {
                return 1;
            } else if (this.lastName < compareToAttendee.lastName) {
                return -1;
            } else {
                if (this.firstName > compareToAttendee.firstName) {
                    return 1;
                } else if (this.firstName < compareToAttendee.firstName) {
                    return -1;
                } else {
                    return 0;
                }
            }
        }
    }

    /**
     * Checks if current user is system admin or ascend customer community admin
     *
     * @author      Phillip Nguyen
     * @since       1.0
     *
     * @return      true/false if user is admin
     */
    public virtual Boolean isUserAdministrator(){
        try {
            String currentUserProfileName = PORTAL_CommunityUtils.SERVER_getUserProfile();
            return (currentUserProfileName == PORTAL_CONST_Global.SYSTEM_ADMIN_PROFILE ||
                    currentUserProfileName == PORTAL_CONST_Global.COMMUNITY_ADMIN_PROFILE ||
                    FeatureManagement.checkPermission(PORTAL_CONST_Global.PORTAL_ADMIN_ACCESS_PERMISSION) == true);
        } catch (Exception e) {
            throw generateErrorMessage(ERROR_INSUFFICIENT_ACCESS);
        }
    }

    /**
     * Gets registered participants information, and supports offset pagination
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param name              Event Name to query for
     * @param offset            Offset value for query, used for pagination
     * @param searchKey         search string to filter query results
     *
     * @return                  Mapped participation info containing a list of participations, total registered participants,
     *                          total attending participants, and total registered participants filtered by name
     *
     */
    public virtual Map<String,Object> getRegisteredParticipations(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String,Object>();

        if (params == null || params.isEmpty()) {
            throw generateErrorMessage(ERROR_GENERAL_MESSAGE);
        }

        if (isUserAdministrator() != true) {
            throw generateErrorMessage(ERROR_NO_ACCESS);
        }

        String eventName = (String) params.get(NAME_KEY);
        Integer offset = Integer.valueOf(params.get(OFFSET_KEY));
        String searchString = (String) params.get(SEARCH_KEY);

        if (offset == null) {
            offset = 0;
        }

        if (String.isBlank(eventName)) {
            throw generateErrorMessage(ERROR_GENERAL_MESSAGE);
        }

        if (offset >= OFFSET_LIMIT) {
            throw generateErrorMessage(ERROR_GENERAL_MESSAGE);
        }

        ucinn_portal_Listing__c listingRecord = getListingFromName(eventName);
        returnMap.put(EVENT_ID, listingRecord.Id);
        returnMap.put(EVENT_NAME, eventName);

        String whereCountClause = 'WHERE Listing__r.Name = :eventName AND Status__c = \'' + String.escapeSingleQuotes(PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED) + '\' ';
        String whereAttendedClause = 'AND Has_Attended__c = true ';
        String whereSearchClause = 'AND Full_Name__c LIKE :searchString';

        Integer participationCountTotal = Database.countQuery('SELECT COUNT() FROM ucinn_portal_Participation__c ' + whereCountClause);
        Integer attendedParticipationCountTotal = Database.countQuery('SELECT COUNT() FROM ucinn_portal_Participation__c ' + whereCountClause + whereAttendedClause);

        Integer searchParticipationCountTotal = 0;
        if (String.isNotBlank(searchString)) {
            searchString = '%' + searchString + '%';
            searchParticipationCountTotal = Database.countQuery('SELECT COUNT() FROM ucinn_portal_Participation__c ' + whereCountClause + whereSearchClause);
        }

        returnMap.put(PARTICIPATION_COUNT_TOTAL, participationCountTotal);
        returnMap.put(ATTENDED_PARTICIPATION_COUNT_TOTAL, attendedParticipationCountTotal);
        returnMap.put(SEARCH_PARTICIPATION_COUNT_TOTAL, searchParticipationCountTotal);

        // get participations for event and that are registered
        List<ucinn_portal_Participation__c> registeredParticipationsList = getRegisteredParticipations(eventName, searchString, offset);

        if (registeredParticipationsList == null || registeredParticipationsList.isEmpty()) {
            return returnMap;
        }

        returnMap.put(EVENT_ID, registeredParticipationsList.get(0).Listing__r.Id);
        returnMap.put(EVENT_NAME, registeredParticipationsList.get(0).Listing__r.Name);

        List<Map<String, Object>> participationMapList = new List<Map<String, Object>>();

        for (ucinn_portal_Participation__c eachRegisteredParticipation : registeredParticipationsList) {
            Map<String,Object> participationMap = new Map<String,Object>();

            participationMap.put(FULL_NAME, eachRegisteredParticipation.Full_Name__c);
            participationMap.put(HAS_ATTENDED, eachRegisteredParticipation.Has_Attended__c);
            participationMap.put(STATUS_KEY, eachRegisteredParticipation.Status__c);
            participationMap.put(PARTICIPATION_ID, eachRegisteredParticipation.Id);

            participationMapList.add(participationMap);
        }

        returnMap.put(PARTICIPATION_LIST, participationMapList);
        return returnMap;
    }

    /**
     * Mark Single Participation as Has Attended Event and updates participation
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param participationId   Id of participation to mark as 'Has Attended'
     * @param attendValue       Change participation's attended status to this value
     */
    public virtual void markParticipationAsAttended(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return;
        }

        String participationId = (String) params.get(PARTICIPATION_ID);
        Boolean hasAttendedValue = (Boolean) params.get(ATTEND_VALUE);

        if (String.isBlank(participationId) || hasAttendedValue == null) {
            return;
        }

        ucinn_portal_Participation__c participationToModify = new ucinn_portal_Participation__c(Id = participationId, Has_Attended__c = hasAttendedValue);
        update participationToModify;
    }

    /**
     * Check In Registrant, this is usually done when an admin scans qr code
     *
     * @author                  Phillip Nguyen
     * @since                   1.12
     *
     * @param participationId   Id of participation to mark as 'Has Attended'
     * 
     * @return                  Name of Participant
     */
    public virtual String checkInRegistrant(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            throw this.generateErrorMessage(ERROR_CHECK_IN);
        }

        if (this.isUserAdministrator() != true) {
            throw this.generateErrorMessage(ERROR_NO_ACCESS);
        }

        String participationId = (String)params.get(PARTICIPATION_ID);

        if (String.isBlank(participationId)) {
            throw this.generateErrorMessage(ERROR_CHECK_IN);
        }

        this.markParticipationAsAttended(new Map<String, Object>{PARTICIPATION_ID => participationId, ATTEND_VALUE => true});

        // we can assume the SOQL query below does not fail, since the user running this will be an admin, and the participation Id exists
        ucinn_portal_Participation__c participation = [SELECT Id, Full_Name__c FROM ucinn_portal_Participation__c WHERE Id = :participationId];
        return participation.Full_Name__c;
    }

    /**
     * Delete single participation record
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param participationId   Id of participation to delete
     */
    public virtual void deleteParticipationRecord(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return;
        }

        String participationId = (String) params.get(PARTICIPATION_ID);

        if (String.isBlank(participationId)) {
            return;
        }

        update new ucinn_portal_Participation__c(Id = participationId, Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_CANCELLED, Has_Attended__c = false);
    }

    /**
     * Helper function that gets all registered participations in alphabetical order
     * Queries participations that match search string and supports offset pagination
     * Grabs 200 records at a time
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param eventName         Name of event to get registered participations
     * @param searchString      Name of participation we are searching for
     * @param offset            Offset value when querying, used for pagination
     * @return                  List of registered participations that match the parameters in alphabetical order
     */
    private List<ucinn_portal_Participation__c> getRegisteredParticipations(String eventName, String searchString, Integer offset) {

        if (String.isBlank(eventName)) {
            throw generateErrorMessage(ERROR_GENERAL_MESSAGE);
        }

        String queryString = 'SELECT Id, Status__c, Full_Name__c, Has_Attended__c, '
                              + 'Listing__r.Id, Listing__r.Name FROM ucinn_portal_Participation__c ';

        String whereClause = 'WHERE Listing__r.Name = :eventName '
                              + 'AND Status__c = \'' + String.escapeSingleQuotes(PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED) + '\' ';

        if (String.isNotBlank(searchString)) {
            whereClause = whereClause + 'AND Full_Name__c LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\' ';
        }

        whereClause = whereClause + 'ORDER BY Full_Name__c ASC, Id ASC ';

        whereClause = whereClause + 'LIMIT ' + String.valueOf(QUERY_LIMIT) + ' ';

        if (offset != null) {
            whereClause = whereClause + 'OFFSET ' + offset + ' ';
        }

        queryString = queryString + whereClause;

        List<ucinn_portal_Participation__c> participationList = Database.query(queryString);

        return participationList;
    }

    /**
     * Generates user friendly custom error message and a stack trace for developers
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param errorMessage      User friendly error message to display on front end
     * @return                  AuraHandledException containing custom error message and stack trace
     */
    private AuraHandledException generateErrorMessage(String errorMessage) {
        return PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => errorMessage});
    }

    // ---------------- VISUAL FORCE PAGE CONTROLLER FUNCTIONS -----------------------------

    /**
     * Get List of registered attendees for event
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param listingName       Name of event listing to get registered participations
     * @return                  List of List of attendees. Nested list if we split attendee list due to size
     */
    public virtual List<List<Attendee>> getAttendeeLists() {
        String listingName = System.currentPageReference().getParameters().get(NAME_KEY);

        if (isUserAdministrator() != true) {
            throw generateErrorMessage(ERROR_INSUFFICIENT_ACCESS);
        }

        List<List<Attendee>> resultLists = new List<List<Attendee>>();
        List<ucinn_portal_Participation__c> participationList = [SELECT id, Contact__r.FirstName, Contact__r.LastName, Degree_And_Year__c,
                                                                Interim__r.ucinn_ascendv2__First_Name__c, Interim__r.ucinn_ascendv2__Last_Name__c,
                                                                Primary_Participation__r.Full_Name__c, Full_Name__c, Name_Tag__c,
                                                                (SELECT id, Ticket_Type__r.Name, Number_of_Tickets__c FROM ucinn_portal_Tickets_Participation__r WHERE Is_Valid_Ticket__c = true)
                                                                    FROM ucinn_portal_Participation__c
                                                                    WHERE Status__c = :PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED
                                                                    AND Listing__r.Name = :listingName];

        List<Attendee> attendeeList = new List<Attendee>();

        for (ucinn_portal_Participation__c participationRecord : participationList) {
            String firstName = '';
            String lastName = '';
            String primaryRegistrantName = '';
            String degreeString = '';
            String nameTag = '';
            Set<String> ticketTypeNameSet = new Set<String>();

            if (participationRecord.ucinn_portal_Tickets_Participation__r != null && !participationRecord.ucinn_portal_Tickets_Participation__r.isEmpty()) {
                for (ucinn_portal_Ticket__c ticketRecord : participationRecord.ucinn_portal_Tickets_Participation__r) {
                    ticketTypeNameSet.add(ticketRecord.Ticket_Type__r.Name + ' (' + ticketRecord.Number_of_Tickets__c + ')');
                }
            }

            if (participationRecord.Primary_Participation__r != null) {
                primaryRegistrantName = participationRecord.Primary_Participation__r.Full_Name__c;
            }

            if (participationRecord.Interim__c != null) {
                firstName = participationRecord.Interim__r.ucinn_ascendv2__First_Name__c;
                lastName = participationRecord.Interim__r.ucinn_ascendv2__Last_Name__c;
            } else if (participationRecord.Contact__c != null) {
                firstName = participationRecord.Contact__r.FirstName;
                lastName = participationrecord.Contact__r.LastName;
            }

            degreeString = participationRecord.Degree_and_Year__c;

            if (String.isNotBlank(participationRecord.Name_Tag__c)) {
                nameTag = participationRecord.Name_Tag__c;
            } else {
                nameTag = participationRecord.Full_Name__c;
            }

            if (String.isNotBlank(firstName) || String.isNotBlank(lastName)) {
                attendeeList.add(new Attendee(firstName, lastName, nameTag, degreeString, primaryRegistrantName, ticketTypeNameSet));
            }
        }

        // ------------------------------------------------------------------------------------------------------------------------------

        attendeeList.sort();

        List<Attendee> splitAttendeeList = new List<Attendee>();
        for (Attendee attendeeRecord : attendeeList){
            splitAttendeeList.add(attendeeRecord);
            if (splitAttendeeList.size() == 10000) {
                resultLists.add(splitAttendeeList);
                splitAttendeeList = new List<Attendee>();
            }
        }

        if (resultLists.size() == 0) {
            resultLists.add(splitAttendeeList);
        }

        return resultLists;
    }

    /**
     * Get Boolean string if Degree and Year are needed for event RSVP List
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param listingName       Name of event listing to get registered participations
     * @return                  Boolean string
     */
    public virtual String getDegreeAndYearNeeded() {
        String listingName = System.currentPageReference().getParameters().get(NAME_KEY);
        List<ucinn_portal_Listing__c> listingList = [SELECT id, Registration_Template__r.Is_Display_Degree_and_Year_Field__c FROM ucinn_portal_Listing__c WHERE Name = :listingName];

        if (listingList.isEmpty() || listingList.get(0).Registration_Template__c == null || listingList.get(0).Registration_Template__r.Is_Display_Degree_and_Year_Field__c != true) {
            return 'false';
        }

        return 'true';
    }

    /**
     * Creates Title name when downloading rsvp list
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param listingName       Name of event listing to get registered participations
     * @return                  Name of Event Listing plus "Attendees' appended on
     */
    public virtual String getDocumentTitle() {
        String listingName = System.currentPageReference().getParameters().get(NAME_KEY);
        List<ucinn_portal_Listing__c> listingList = [SELECT Name FROM ucinn_portal_Listing__c WHERE Name = :listingName];

        if (listingList.size() == 0) {
            return '';
        }

        return listingList.get(0).Name + ' ' + ATTENDEES_TEXT;
    }

    private ucinn_portal_Listing__c getListingFromName(String listingName) {
        List<ucinn_portal_Listing__c> listingList = [SELECT Id, Name FROM ucinn_portal_Listing__c WHERE Name = :listingName];

        if (!listingList.isEmpty()) {
            return listingList.get(0);
        }

        return new ucinn_portal_Listing__c();
    }
}