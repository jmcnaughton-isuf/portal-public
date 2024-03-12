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
 * Class containing logic for event registration.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
public without sharing virtual class PORTAL_EventRegistrationControllerBase {
    public static final String LISTING_ID = 'listingId';
    public static final String TEMPLATE_ID = 'templateId';
    public static final String IS_WALK_IN = 'isWalkIn';
    public static final String REGISTRANT_LIST = 'registrantList';
    public static final String LISTING_RECORD = 'listingRecord';
    public static final String REGISTRATION_TEMPLATE = 'registrationTemplate';
    public static final String TICKET_AVAILABILITY = 'ticketAvailability';
    public static final String TICKET_DISCOUNT_MAP = 'ticketDiscountMap';
    public static final String ORG_SETTINGS = 'orgSettings';
    public static final String SCHOOL_DEGREE_INFORMATION = 'School_Degree_Information';

    public static final String CUSTOM_FORM_FIELDS = 'customFormFields';
    public static final String CONTACT_ID = 'contactId';
    public static final String INTERIM_ID = 'interimId';
    public static final String PARTICIPATION_ID = 'participationId';
    public static final String PARTICIPATION_STATUS = 'participationStatus';
    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String EMAIL_KEY = 'email';
    public static final String DEGREE_AND_YEAR = 'degreeAndYear';
    public static final String EMPLOYER_KEY = 'employer';
    public static final String PHONE_KEY = 'phone';
    public static final String STREET_1_KEY = 'street1';
    public static final String STREET_2_KEY = 'street2';
    public static final String CITY_KEY = 'city';
    public static final String STATE_KEY = 'state';
    public static final String COUNTRY_KEY = 'country';
    public static final String POSTAL_CODE = 'postalCode';
    public static final String ADDITIONAL_INFO_LIST = 'additionalInfoList';
    public static final String TICKET_LIST = 'ticketList';
    public static final String HAS_PROMO_CODES = 'hasPromoCodes';
    public static final String NAME_TAG = 'nameTag';
    public static final String IS_SEND_CONFIRMATION = 'isSendConfirmation';
    public static final String IS_DISPLAY_ON_LOOK_WHOS_COMING_LIST = 'isDisplayOnLookWhosComingList';
    public static final String HAS_INTERIM = 'hasInterim';
    public static final String WAITLIST_ENTRY_ID = 'waitlistEntryId';
    public static final String WAITLIST_ENTRY = 'waitlistEntry';
    public static final String TICKET_TYPE_LIST = 'ticketTypeList';
    public static final String FREE_CONST = 'Free';
    public static final String EVENT_START_DATE_TIME = 'eventStartDateTime';
    public static final String EVENT_END_DATE_TIME = 'eventEndDateTime';
    public static final String FORMATTED_EVENT = 'formattedEvent';
    public static final String TICKET_TYPES_WITH_TICKETS_IN_CART = 'ticketTypesWithTicketsInCart';

    public static final String TICKET_ID = 'ticketId';
    public static final String TICKET_TYPE_ID = 'ticketTypeId';
    public static final String PRICE_KEY = 'price';
    public static final String TICKET_DISCOUNT_ID = 'ticketDiscountId';
    public static final String QUANTITY_KEY = 'quantity';
    public static final String QUANTITY_IN_POSSESSION = 'quantityInPossession';
    public static final String PROMO_CODE = 'promoCode';
    public static final String PURCHASED_QUANTITY = 'purchasedQuantity';

    public static final String ADDITIONAL_INFO_ID = 'additionalInfoId';
    public static final String CUSTOM_FORM_FIELD_ID = 'customFormFieldId';
    public static final String NAME_KEY = 'name';
    public static final String LABEL_KEY = 'label';
    public static final String VALUE_KEY = 'value';
    public static final String EMAIL_TEMPLATE_DEVELOPER_NAME = 'emailTemplateDeveloperName';

    public static final String SESSION_ID = 'sessionId';
    public static final String DISCOUNTED_PRICE = 'discountedPrice';
    public static final String CONTACT_KEY = 'contact';
    public static final String PRIMARY_PARTICIPATION_ID = 'primaryParticipationId';
    public static final String EXISTING_PRIMARY_PARTICIPATION_STATUS = 'existingPrimaryParticipationStatus';
    public static final STring PAYMENT_METHOD = 'paymentMethod';
    public static final STring CREDIT_CARD_ONLINE = 'Credit Card - Online';

    public static final String ERROR_CONTACT_ADMIN = 'There was an issue processing your registration. Please contact an Administrator.';
    public static final String ERROR_REGISTRANT_INFO = 'Please fill out all registration information before proceeding.';
    public static final String ERROR_EVENT_NOT_ENOUGH_TICKETS = 'There are currently not enough tickets available for the event.';
    public static final String ERROR_INVALID_DISCOUNT = 'There was a problem processing your ticket discount. Please contact an Administrator.';

    public static final String EVENT_RECORD_TYPE = 'Event';

    public static String ERROR_TICKET_NOT_ENOUGH_TICKETS(String ticketTypeName) {
        return 'There are currently not enough tickets available for ' + ticketTypeName + '.';
    }

    public static String ERROR_TICKET_EXCEEDED_TICKET_TYPE_LIMIT(String ticketTypeName, Decimal numberOfTickets) {
        return 'You can only purchase ' + String.valueOf(numberOfTickets) + ' ' + ticketTypeName + ' ticket(s).';
    }

    /**
     * Event Registrant class used for capturing information about registration
     *
     * @author  Aaron Wong
     * @version 1.0
     * @since   1.0
     */
    public class EventRegistrant {
        @AuraEnabled
        public String contactId { get; set; }
        @AuraEnabled
        public String interimId { get; set; }
        @AuraEnabled
        public String participationId { get; set; }
        @AuraEnabled
        public String participationStatus { get; set; }
        @AuraEnabled
        public String firstName { get; set; }
        @AuraEnabled
        public String lastName { get; set; }
        @AuraEnabled
        public String email { get; set; }
        @AuraEnabled
        public String nameTag { get; set; }
        @AuraEnabled
        public String degreeAndYear { get; set; }
        @AuraEnabled
        public String employer { get; set; }
        @AuraEnabled
        public String phone { get; set; }
        @AuraEnabled
        public String street1 { get; set; }
        @AuraEnabled
        public String street2 { get; set; }
        @AuraEnabled
        public String city { get; set; }
        @AuraEnabled
        public String state { get; set; }
        @AuraEnabled
        public String country { get; set; }
        @AuraEnabled
        public String postalCode { get; set; }
        @AuraEnabled
        public Boolean isSendConfirmation { get; set; }
        @AuraEnabled
        public Boolean isDisplayOnLookWhosComingList { get; set; }
        @AuraEnabled
        public Boolean hasInterim { get; set;}
        @AuraEnabled
        public List<RegistrationTicket> ticketList { get; set; }
        @AuraEnabled
        public List<RegistrationAdditionalInfo> additionalInfoList { get; set; }

        public ucinn_ascendv2__Interim__c interimRecord = new ucinn_ascendv2__Interim__c();
        public ucinn_portal_Participation__c participationRecord = new ucinn_portal_Participation__c();

        /**
         * Constructs an event registrant from a contact record.
         *
         * @author Aaron Wong
         *
         * @param contactRecord     Contact record used to construct event registrant.
         * @return                  An EventRegistrant
         * @since                   1.0
         */
        public EventRegistrant(Contact contactRecord) {
            this.contactId = contactRecord.Id;
            this.firstName = contactRecord.FirstName;
            this.lastName = contactRecord.LastName;
            this.email = contactRecord.Email;
            this.phone = contactRecord.Phone;
            this.street1 = contactRecord.ucinn_ascendv2__Preferred_Address_Line_1__c;
            this.street2 = contactRecord.ucinn_ascendv2__Preferred_Address_Line_2__c;
            this.city = contactRecord.ucinn_ascendv2__Preferred_Address_City__c;
            this.state = contactRecord.ucinn_ascendv2__Preferred_Address_State__c;
            this.country = contactRecord.ucinn_ascendv2__Preferred_Address_Country__c;
            this.postalCode = contactRecord.ucinn_ascendv2__Preferred_Address_Postal_Code__c;
            this.nameTag = '';
            this.degreeAndYear = '';
            this.employer = '';

            // Should be order by Is Preferred
            if (contactRecord.ucinn_ascendv2__Affiliations_Contact__r != null && !contactRecord.ucinn_ascendv2__Affiliations_Contact__r.isEmpty()) {
                this.employer = contactRecord.ucinn_ascendv2__Affiliations_Contact__r.get(0).ucinn_ascendv2__Account__r.Name;
            }

            if (contactRecord.ucinn_ascendv2__Degree_Information_Contact__r != null && !contactRecord.ucinn_ascendv2__Degree_Information_Contact__r.isEmpty()) {
                this.degreeAndYear = formatDegreeAndYears(contactRecord.ucinn_ascendv2__Degree_Information_Contact__r);
            }

            // First Name can be null
            if (String.isBlank(this.firstName)) {
                this.firstName = '';
            } else {
                this.nameTag = this.firstName + ' ';
            }

            this.nameTag = this.nameTag + this.lastName;

            if (String.isNotBlank(this.degreeAndYear)) {
                this.nameTag = this.nameTag + ' ' + this.degreeAndYear;
            }
        }

        /**
         * Constructs an event registrant from a participation record.
         *
         * @author Aaron Wong
         *
         * @param participationRecord       Participation record used to construct event registrant.
         * @return                          An EventRegistrant
         * @since                           1.0
         */
        public EventRegistrant(ucinn_portal_Participation__c participationRecord) {
            this.participationId = participationRecord.Id;
            this.contactId = participationRecord.Contact__c;

            // Interim is checked first since interim information is information inputted through the registration form
            if (String.isNotBlank(participationRecord.Interim__c)) {
                this.interimId = participationRecord.Interim__c;
                this.firstName = participationRecord.Interim__r.ucinn_ascendv2__First_Name__c;
                this.lastName = participationRecord.Interim__r.ucinn_ascendv2__Last_Name__c;
                this.email = participationRecord.Interim__r.ucinn_ascendv2__Email_1__c;
                this.employer = participationRecord.Interim__r.ucinn_ascendv2__Employer__c;
                this.phone = participationRecord.Interim__r.ucinn_ascendv2__Phone_1__c;
                this.street1 = participationRecord.Interim__r.ucinn_ascendv2__Address_1_Line_1__c;
                this.street2 = participationRecord.Interim__r.ucinn_ascendv2__Address_1_Line_2__c;
                this.city = participationRecord.Interim__r.ucinn_ascendv2__City_1__c;
                this.state = participationRecord.Interim__r.ucinn_ascendv2__State_1__c ;
                this.country = participationRecord.Interim__r.ucinn_ascendv2__Country_1__c;
                this.postalCode = participationRecord.Interim__r.ucinn_ascendv2__Postal_Code_1__c;
                this.hasInterim = true;
            } else if (String.isNotBlank(participationRecord.Contact__c)) {
                this.firstName = participationRecord.Contact__r.FirstName;
                this.lastName = participationRecord.Contact__r.LastName;
                this.email = participationRecord.Contact__r.Email;
                this.phone = participationRecord.Contact__r.Phone;
                this.street1 = participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c;
                this.street2 = participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c;
                this.city = participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_City__c;
                this.state = participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_State__c;
                this.country = participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Country__c;
                this.postalCode = participationRecord.Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c;
            }

            this.nameTag = participationRecord.Name_Tag__c;
            this.isSendConfirmation = participationRecord.Is_Send_Confirmation_Email__c;
            this.isDisplayOnLookWhosComingList = participationRecord.Is_Display_On_Look_Who_s_Coming_List__c;
            this.degreeAndYear = participationRecord.Degree_And_Year__c;
            this.participationStatus = participationRecord.Status__c;

            if (participationRecord.ucinn_portal_Tickets_Participation__r != null && !participationRecord.ucinn_portal_Tickets_Participation__r.isEmpty()) {
                  this.ticketList = getRegistrationTicketsFromTicketRecords(participationRecord.ucinn_portal_Tickets_Participation__r);
            }
            if (participationRecord.ucinn_portal_Registration_Add_Infos__r != null && !participationRecord.ucinn_portal_Registration_Add_Infos__r.isEmpty()) {
                List<RegistrationAdditionalInfo> additionalInfoList = new List<RegistrationAdditionalInfo>();

                for (ucinn_portal_Registration_Add_Info__c eachInfo : participationRecord.ucinn_portal_Registration_Add_Infos__r) {
                    additionalInfoList.add(new RegistrationAdditionalInfo(eachInfo));
                }

                this.additionalInfoList = additionalInfoList;
            }
        }

        /**
         * Constructs an event registrant from an Event Waitlist Entry record.
         *
         * @author Aaron Wong
         *
         * @param waitlistEntryRecord       Event Waitlist Entry record used to construct event registrant.
         * @return                          An EventRegistrant
         * @since                           1.0
         */
        public EventRegistrant(ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord) {
            this.firstName = waitlistEntryRecord.First_Name__c;
            this.lastName = waitlistEntryRecord.Last_Name__c;
            this.email = waitlistEntryRecord.Email__c;
            this.hasInterim = true;
        }

        /**
         * Constructs an event registrant from an object map.
         *
         * @author Aaron Wong
         *
         * @param objectMap     Object map used to construct event registrant.
         * @return              An EventRegistrant
         * @since               1.0
         */
        public EventRegistrant(Map<Object, Object> objectMap) {
            this.contactId = (String)objectMap.get(CONTACT_ID);
            this.interimId = (String)objectMap.get(INTERIM_ID);
            this.participationId = (String)objectMap.get(PARTICIPATION_ID);
            this.firstName = (String)objectMap.get(FIRST_NAME);
            this.lastName = (String)objectMap.get(LAST_NAME);
            this.email = (String)objectMap.get(EMAIL_KEY);
            this.nameTag = (String)objectMap.get(NAME_TAG);
            this.degreeAndYear = (String)objectMap.get(DEGREE_AND_YEAR);
            this.employer = (String)objectMap.get(EMPLOYER_KEY);
            this.phone = (String)objectMap.get(PHONE_KEY);
            this.street1 = (String)objectMap.get(STREET_1_KEY);
            this.street2 = (String)objectMap.get(STREET_2_KEY);
            this.city = (String)objectMap.get(CITY_KEY);
            this.state = (String)objectMap.get(STATE_KEY);
            this.country = (String)objectMap.get(COUNTRY_KEY);
            this.postalCode = (String)objectMap.get(POSTAL_CODE);
            this.isSendConfirmation = (Boolean)objectMap.get(IS_SEND_CONFIRMATION);
            this.isDisplayOnLookWhosComingList = (Boolean)objectMap.get(IS_DISPLAY_ON_LOOK_WHOS_COMING_LIST);
            this.hasInterim = (Boolean)objectMap.get(HAS_INTERIM);

            // check edge case where user loads the page as an authenticated user but submits information as a guest user
            // only an issue where the user is creating a new participation, not an issue when modifying existing participation
            if (String.isBlank(this.participationId) && String.isNotBlank(this.contactId) && String.isBlank(getUserContact()?.Id)) {
                this.contactId = null;
                this.hasInterim = true;
            }

            if (objectMap.containsKey(TICKET_LIST)) {
                List<RegistrationTicket> ticketList = new List<RegistrationTicket>();

                for (Object eachTicketObject : (List<Object>)objectMap.get(TICKET_LIST)) {
                    Map<Object, Object> eachTicketObjectMap = (Map<Object, Object>) eachTicketObject;
                    ticketList.add(new RegistrationTicket(eachTicketObjectMap));
                }

                this.ticketList = ticketList;
            }

            if (objectMap.containsKey(ADDITIONAL_INFO_LIST)) {
                List<RegistrationAdditionalInfo> additionalInfoList = new List<RegistrationAdditionalInfo>();

                for (Object eachInfoObject: (List<Object>)objectMap.get(ADDITIONAL_INFO_LIST)) {
                    additionalInfoList.add(new RegistrationAdditionalInfo(eachInfoObject));
                }

                this.additionalInfoList = additionalInfoList;
            }
        }

        /**
         * Converts the EventRegistrant to an interim.
         *
         * @author Aaron Wong
         *
         * @return      The interim record.
         * @since       1.0
         */
        public ucinn_ascendv2__Interim__c toInterim() {
            ucinn_ascendv2__Interim__c interimRecord = new ucinn_ascendv2__Interim__c();
            interimRecord.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(EVENT_RECORD_TYPE).getRecordTypeId();
            interimRecord.ucinn_ascendv2__First_Name__c = this.firstName;
            interimRecord.ucinn_ascendv2__Last_Name__c = this.lastName;
            interimRecord.ucinn_ascendv2__Email_1__c = this.email;
            interimRecord.ucinn_ascendv2__Phone_1__c = this.phone;
            interimRecord.ucinn_ascendv2__Employer__c = this.employer;
            interimRecord.ucinn_ascendv2__Address_1_Line_1__c = this.street1;
            interimRecord.ucinn_ascendv2__Address_1_Line_2__c = this.street2;
            interimRecord.ucinn_ascendv2__City_1__c = this.city;
            interimRecord.ucinn_ascendv2__State_1__c = this.state;
            interimRecord.ucinn_ascendv2__Country_1__c = this.country;
            interimRecord.ucinn_ascendv2__Postal_Code_1__c = this.postalCode;

            interimRecord.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();

            if (String.isNotBlank(this.interimId)) {
                interimRecord.Id = this.interimId;
            }

            // Interim needs to be stored on the record to set participation record's Interim field
            this.interimRecord = interimRecord;

            return interimRecord;
        }

        /**
         * Converts the EventRegistrant to a participation.
         *
         * @author Aaron Wong
         *
         * @param listingId                     The listing Id the current registration is for.
         * @param participationStatus           The status to set the participation record to if new.
         * @param purchasingConstituentId       The Id of the purchasing constituent.
         * @param isWalkIn                      Whether or not the registrant is a walk in.
         * @return                              The participation record.
         * @since                               1.0
         */
        public ucinn_portal_Participation__c toParticipation(String listingId,
                                                             String primaryParticipationId,
                                                             String participationStatus,
                                                             String purchasingConstituentId,
                                                             Boolean isWalkIn) {
            ucinn_portal_Participation__c participationRecord = new ucinn_portal_Participation__c();

            if (this.interimRecord != null) {
                participationRecord.Interim__c = this.interimRecord.Id;
                participationRecord.Contact__c = null;
            }

            // Empty string causes error when assigning Id
            if (String.isBlank(this.contactId)) {
                participationRecord.Contact__c = null;
            } else {
                participationRecord.Contact__c = this.contactId;
            }

            if (String.isNotBlank(primaryParticipationId) && participationId != primaryParticipationId) {
                participationRecord.Primary_Participation__c = primaryParticipationId;
            }

            // Leave status if the participation already exists
            if (String.isNotBlank(this.participationId)) {
                participationRecord.Id = participationId;
            } else {
                participationRecord.Status__c = participationStatus;
            }

            if (String.isNotBlank(purchasingConstituentId)) {
                participationRecord.Purchasing_Constituent__c = purchasingConstituentId;
            }

            participationRecord.Listing__c = listingId;

            if (String.isNotBlank(this.degreeAndYear)) {
                participationRecord.Degree_And_Year__c = this.degreeAndYear;
            }

            if (String.isNotBlank(this.nameTag)) {
                participationRecord.Name_Tag__c = this.nameTag;
            }

            if (this.isSendConfirmation == true) {
                participationRecord.Is_Send_Confirmation_Email__c = true;
            }

            if (this.isDisplayOnLookWhosComingList != null) {
                participationRecord.Is_Display_On_Look_Who_s_Coming_List__c = this.isDisplayOnLookWhosComingList;
            }

            if (isWalkIn == true) {
                participationRecord.Has_Attended__c = true;
            }

            // Store participation record for ticket and additional info records.
            this.participationRecord = participationRecord;
            return participationRecord;
        }

        /**
         * Gets a list of ticket records from the Event Registrant.
         *
         * @author Aaron Wong
         *
         * @param sessionId     The Registration Session Id to assign the tickets to.
         * @return              A list of ticket records to upsert.
         * @since               1.0
         */
        public List<ucinn_portal_Ticket__c> getTickets(String sessionId) {
            List<ucinn_portal_Ticket__c> resultList = new List<ucinn_portal_Ticket__c>();

            if (this.ticketList == null || this.ticketList.isEmpty()) {
                return resultList;
            }

            // Convert RegistrationTicket records to Ticket records.
            for (RegistrationTicket eachRegistrationTicket : this.ticketList) {
                if (eachRegistrationTicket.quantity > 0) {
                    resultList.add(eachRegistrationTicket.toTicketRecord(participationRecord.Id, sessionId));
                }
            }

            return resultList;
        }

        /**
         * Gets a list of Registration Additional Info records from the Event Registrant.
         *
         * @author Aaron Wong
         *
         * @return  A list of registration additional info records.
         * @since   1.0
         */
        public List<ucinn_portal_Registration_Add_Info__c> getAdditionalInfo() {
            List<ucinn_portal_Registration_Add_Info__c> resultList = new List<ucinn_portal_Registration_Add_Info__c>();

            if (this.additionalInfoList == null || this.additionalInfoList.isEmpty()) {
                return resultList;
            }

            for (RegistrationAdditionalInfo eachAdditionalInfo : this.additionalInfoList) {
                resultList.add(eachAdditionalInfo.toRegistrationAddInfoRecord(participationRecord.Id));
            }

            return resultList;
        }

        /**
         * Gets a list of RegistrationTickets from Ticket records.
         *
         * @author Aaron Wong
         *
         * @param ticketList    List of Ticket records to convert.
         * @return              List of RegistrationTicket records that can be used by LWC.
         * @since               1.0
         */
        private List<RegistrationTicket> getRegistrationTicketsFromTicketRecords(List<ucinn_portal_Ticket__c> ticketList) {
            List<RegistrationTicket> resultList = new List<RegistrationTicket>();

            if (ticketList == null || ticketList.isEmpty()) {
                return resultList;
            }

            Map<String, RegistrationTicket> ticketTypeIdToRegistrationTicketMap = new Map<String, RegistrationTicket>();

            for (ucinn_portal_Ticket__c eachTicket : ticketList) {
                RegistrationTicket eachRegistrationTicket = new RegistrationTicket(eachTicket);

                if (eachTicket.Status__c == PORTAL_CONST_Events.TICKET_STATUS_PAID || eachTicket.Status__c == PORTAL_CONST_Events.TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION) {
                    /* We clear the ticket id because we do not want to modify any paid tickets.
                       By clearing the ticket Id, once the user adds more tickets and registers them,
                       instead of modifying the existing paid ticket it will create a new one. If a ticket
                       exists that isn't paid, then the non-paid ticket will be modified.*/
                    eachRegistrationTicket.ticketId = '';
                }

                if (ticketTypeIdToRegistrationTicketMap.containsKey(eachTicket.Ticket_Type__c)) {
                    RegistrationTicket storedTicket = ticketTypeIdToRegistrationTicketMap.get(eachTicket.Ticket_Type__c);

                    // Add to the quantity and purchased quantity
                    storedTicket.quantity = storedTicket.quantity + eachRegistrationTicket.quantity;
                    storedTicket.purchasedQuantity = storedTicket.purchasedQuantity + eachRegistrationTicket.purchasedQuantity;

                    /* Set the ticket Id if there is one to update this ticket record
                       (There should only be one valid ticket per ticket type that is not paid)*/
                    if (String.isNotBlank(eachRegistrationTicket.ticketId)) {
                        storedTicket.ticketId = eachRegistrationTicket.ticketId;
                    }
                } else {
                    ticketTypeIdToRegistrationTicketMap.put(eachTicket.Ticket_Type__c, eachRegistrationTicket);
                    resultList.add(eachRegistrationTicket);
                }
            }

            return resultList;
        }
    }

    /**
     * Registration Ticket class used for capturing information about tickets for event registration
     *
     * @author  Aaron Wong
     * @version 1.0
     * @since   1.0
     */
    public class RegistrationTicket {
        @AuraEnabled
        public String ticketId { get; set; }
        @AuraEnabled
        public String ticketTypeId { get; set; }
        @AuraEnabled
        public String ticketDiscountId { get; set; }
        @AuraEnabled
        public Decimal price { get; set; }
        @AuraEnabled
        public Decimal quantity { get; set; }                   // Number of tickets being purchased (includes Status In Shopping Cart and Pending Payment)
        @AuraEnabled
        public Decimal purchasedQuantity { get; set; }          // Number of tickets already purchased (Status Paid or Awaiting Gateway Confirmation)
        @AuraEnabled
        public Decimal quantityInPossession { get; set; }       // Number of tickets in the Registrant's posession already. (All Statuses)

        /**
         * Constructs a RegistrationTicket from a Ticket record.
         *
         * @author Aaron Wong
         *
         * @param ticketRecord      Ticket record used to construct the RegistrationTicket.
         * @return                  A RegistrationTicket.
         * @since                   1.0
         */
        public RegistrationTicket(ucinn_portal_Ticket__c ticketRecord) {
            this.ticketId = ticketRecord.Id;
            this.ticketTypeId = ticketRecord.Ticket_Type__c;
            this.ticketDiscountId = ticketRecord.Ticket_Discount__c;
            this.quantity = 0;
            this.purchasedQuantity = 0;
            this.price = ticketRecord.Price_Per_Ticket__c;
            this.quantityInPossession = ticketRecord.Number_of_Tickets__c;

            if (ticketRecord.Status__c == PORTAL_CONST_Events.TICKET_STATUS_PAID || ticketRecord.Status__c == PORTAL_CONST_Events.TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION) {
                this.purchasedQuantity = ticketRecord.Number_of_Tickets__c;
            } else {
                this.quantity = ticketRecord.Number_of_Tickets__c;
            }
        }

        /**
         * Constructs a RegistrationTicket from an object map.
         *
         * @author Aaron Wong
         *
         * @param objectMap     Object map used to construct the RegistrationTicket.
         * @return              A RegistrationTicket.
         * @since               1.0
         */
        public RegistrationTicket(Map<Object, Object> objectMap) {
            this.ticketId = (String)objectMap.get(TICKET_ID);
            this.ticketTypeId = (String)objectMap.get(TICKET_TYPE_ID);
            this.ticketDiscountId = (String)objectMap.get(TICKET_DISCOUNT_ID);
            this.price = (Decimal)objectMap.get(PRICE_KEY);
            this.purchasedQuantity = (objectMap.get(PURCHASED_QUANTITY) != null) ? (Decimal)objectMap.get(PURCHASED_QUANTITY) : 0;
            this.quantityInPossession = (Decimal)objectMap.get(QUANTITY_IN_POSSESSION);
            String quantity = (String)objectMap.get(QUANTITY_KEY);

            if (String.isBlank(quantity)) {
                this.quantity = 0;
            } else if (quantity.isNumeric()) {
                this.quantity = Decimal.valueOf(quantity);
            } else {
                this.quantity = 0;
            }
        }

        /**
         * Converts this Registration Ticket to a Ticket record that can be upserted.
         *
         * @author Aaron Wong
         *
         * @param participationId   Id of the Participation record to assign this ticket to.
         * @param sessionId         Id of the Registration Session record to assign this to.
         * @return                  The ticket record.
         * @since                   1.0
         */
        public ucinn_portal_Ticket__c toTicketRecord(String participationId,
                                                     String sessionId) {
            ucinn_portal_Ticket__c resultTicket = new ucinn_portal_Ticket__c();

            if (String.isNotBlank(this.ticketId)) {
                resultTicket.Id = this.ticketId;
            } else {
                // Field is not writeable if already inserted
                resultTicket.Ticket_Type__c = this.ticketTypeId;
                resultTicket.Participation__c = participationId;
            }

            if (String.isNotBlank(sessionId)) {
                resultTicket.Registration_Session__c = sessionId;
            }

            resultTicket.Number_of_Tickets__c = this.quantity;
            resultTicket.Price_Per_Ticket__c = this.price;
            resultTicket.Ticket_Discount__c = this.ticketDiscountId;

            return resultTicket;
        }
    }

    /**
     * Registration Additional Info class used for capturing information about
     * Custom Form Fields during event registration.
     *
     * @author  Aaron Wong
     * @version 1.0
     * @since   1.0
     */
    public class RegistrationAdditionalInfo {
        @AuraEnabled
        public String additionalInfoId { get; set; }
        @AuraEnabled
        public String customFormFieldId { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public Boolean isRequired { get; set; }

        /**
         * Constructs a RegistrationAdditionalInfo from an Additional Info record
         *
         * @author Aaron Wong
         *
         * @param infoRecord        An Additional Info record.
         * @return                  A RegistrationAdditionalInfo.
         * @since                   1.0
         */
        public RegistrationAdditionalInfo(ucinn_portal_Registration_Add_Info__c infoRecord) {
            this.additionalInfoId = infoRecord.Id;
            this.customFormFieldId = infoRecord.Custom_Form_Field__c;
            this.name = infoRecord.Name;
            this.label = infoRecord.Custom_Form_Field__r.Field_Label__c;
            this.value = infoRecord.Value__c;
            this.isRequired = infoRecord.Custom_Form_Field__r.Is_Required__c;
        }

        /**
         * Constructs a RegistrationAdditionalInfo from an object.
         *
         * @author Aaron Wong
         *
         * @param objectRecord      An object.
         * @return                  A RegistrationAdditionalInfo.
         * @since                   1.0
         */
        public RegistrationAdditionalInfo(Object objectRecord) {
            Map<Object, Object> objectMap = (Map<Object, Object>)objectRecord;

            this.additionalInfoId = (String)objectMap.get(ADDITIONAL_INFO_ID);
            this.customFormFieldId = (String)objectMap.get(CUSTOM_FORM_FIELD_ID);
            this.name = (String)objectMap.get(NAME_KEY);
            this.label = (String)objectMap.get(LABEL_KEY);
            this.value = (String)objectMap.get(VALUE_KEY);
        }

        /**
         * Converts this RegistrationAdditionalInfo to a Registration Add Info record that can be upserted.
         *
         * @author Aaron Wong
         *
         * @param participationId   The participation record to assign the additional info to.
         * @return                  A Registration Add Info record.
         * @since                   1.0
         */
        public ucinn_portal_Registration_Add_Info__c toRegistrationAddInfoRecord(String participationId) {
            ucinn_portal_Registration_Add_Info__c resultRecord =
                                                new ucinn_portal_Registration_Add_Info__c(Name = this.name,
                                                                                          Value__c = this.value,
                                                                                          Custom_Form_Field__c = this.customFormFieldId,
                                                                                          Participation__c = participationId);

            if (String.isNotBlank(additionalInfoId)) {
                resultRecord.Id = additionalInfoId;
            }

            return resultRecord;
        }
    }

    /**
     * Initializes the event registration. Queries for any information needed.
     *
     * @author Aaron Wong
     *
     * @param listingId                 The listing Id being registered for.
     * @param primaryParticipationId    The primary participation to modify (if any).
     * @param isWalkIn                  Whether or not the registration is for walk ins.
     * @return                          Map of information used for event registration.
     * @since                           1.0
     */
    public virtual Map<String, Object> initEventRegistration(Map<String, Object> params){
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty() || String.isBlank((String)params.get(LISTING_ID))) {
            return resultMap;
        }

        String listingId = (String)params.get(LISTING_ID);
        String primaryParticipationId = (String)params.get(PRIMARY_PARTICIPATION_ID);
        String waitlistEntryId = (String)params.get(WAITLIST_ENTRY_ID);
        Boolean isWalkIn = (Boolean)params.get(IS_WALK_IN);

        // Determine if user has permissions to use Walk-In functionality
        PORTAL_EventManagementControllerBase eventManagementController = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();
        isWalkIn = (isWalkIn == true) && eventManagementController.isUserAdministrator();
        resultMap.put(IS_WALK_IN, isWalkIn);
        
        ucinn_portal_Listing__c listingRecord = getListingForEventRegistration(new Map<String, Object>{LISTING_ID => listingId, IS_WALK_IN => isWalkIn});

        if (listingRecord == null) {
            return resultMap;
        }

        Set<String> ticketTypeIdSet = getTicketTypeIdSetFromListing(listingRecord);
        Contact userContact = getUserContact();
        String userContactId = userContact?.Id;

        // Get any constituent attribute ticket discounts, then apply the discount on the front end.
        if (ticketTypeIdSet != null && !ticketTypeIdSet.isEmpty() && userContact != null) {
            resultMap.put(TICKET_DISCOUNT_MAP, PORTAL_UTIL_Events.getTicketTypeDiscountsForConstituent(new Map<String, Object>{
                PORTAL_UTIL_Events.TICKET_TYPE_ID_SET => ticketTypeIdSet,
                PORTAL_UTIL_EVENTS.CONTACT_ID => userContactId
            }));
        }

        resultMap.put(LISTING_RECORD, listingRecord);
        resultMap.put(FORMATTED_EVENT, getFormattedEvent(listingRecord));
        resultMap.put(TICKET_TYPE_LIST, listingRecord.ucinn_portal_Ticket_Types_Listing__r);
        // Check if the listing has any promo codes
        resultMap.put(HAS_PROMO_CODES, PORTAL_UTIL_Events.isListingHasPromoCodes(new Map<String, Object>{LISTING_ID => listingId}));
        // Check if there are tickets available for the listing
        resultMap.put(TICKET_AVAILABILITY, PORTAL_UTIL_Events.getAvailableTicketsForListing(new Map<String, Object>{LISTING_ID => listingId}));
        resultMap.put(TICKET_TYPES_WITH_TICKETS_IN_CART, PORTAL_UTIL_Events.getTicketTypesWithTicketsInCart(new Map<String, Object>{LISTING_ID => listingId,
                                                                                                                                    CONTACT_ID => userContactId,
                                                                                                                                    PRIMARY_PARTICIPATION_ID => primaryParticipationId}));
        // Get any org settings required for event registration. (If Guest Registrations are modifiable)
        resultMap.put(ORG_SETTINGS, getOrganizationSettings());

        // Get the registration template and form custom fields (if any)
        if (listingRecord != null && String.isNotBlank(listingRecord.Registration_Template__c)) {
            ucinn_portal_Registration_Template__c registrationTemplate = getRegistrationTemplate(new Map<String, Object>{TEMPLATE_ID => listingRecord.Registration_Template__c});

            resultMap.put(REGISTRATION_TEMPLATE, registrationTemplate);

            if (registrationTemplate != null) {
                List<ucinn_portal_Custom_Form_Field__c> formFieldList = getCustomFormFields(new Map<String, Object>{TEMPLATE_ID => registrationTemplate.Id});

                if (formFieldList != null && !formFieldList.isEmpty()) {
                    resultMap.put(CUSTOM_FORM_FIELDS, PORTAL_CommunityUtils.parseCustomFormFieldList(formFieldList));
                }
            }
        }

        // Don't prepopulate waitlist information
        if (isWalkIn == true) {
            return resultMap;
        }

        if (userContact != null) {
            resultMap.put(CONTACT_KEY, userContact);
            resultMap.put(REGISTRANT_LIST, new List<EventRegistrant>{new EventRegistrant(userContact)});
        }

        // Query for existing registrants if there is a primary participation Id or if the user is authenticated
        if (String.isNotBlank(primaryParticipationId) || String.isNotBlank(userContactId)) {
            List<EventRegistrant> registrantList = getExistingRegistrantList(primaryParticipationId, userContactId, listingId);

            if (registrantList != null && !registrantList.isEmpty()) {
                resultMap.put(REGISTRANT_LIST, registrantList);
            }
        }

        if (String.isNotBlank(waitlistEntryId)) {
            Map<String, Object> waitlistInformationMap = getWaitlistInformation(waitlistEntryId);

            if (waitlistInformationMap == null || waitlistInformationMap.isEmpty()) {
                return resultMap;
            }

            // New ticket availability map to override since we only allow adding waitlisted tickets
            Map<String, Object> ticketAvailabilityMap = (Map<String, Object>)waitlistInformationMap.get(TICKET_AVAILABILITY);

            if (ticketAvailabilityMap == null || ticketAvailabilityMap.isEmpty()
                    || listingRecord.ucinn_portal_Ticket_Types_Listing__r == null || listingRecord.ucinn_portal_Ticket_Types_Listing__r.isEmpty()) {
                return resultMap;
            }

            String ticketTypeId = new List<String>(ticketAvailabilityMap.keySet()).get(0);

            // Since we are only allowing adding the ticket type waitlisted for, we filter the available ticket types for registration
            List<ucinn_portal_Ticket_Type__c> filteredTicketTypeList = new List<ucinn_portal_Ticket_Type__c>();

            for (ucinn_portal_Ticket_Type__c eachTicketType : listingRecord.ucinn_portal_Ticket_Types_Listing__r) {
                if (eachTicketType.Id == ticketTypeId) {
                    filteredTicketTypeList.add(eachTicketType);
                    break;
                }
            }

            resultMap.put(TICKET_AVAILABILITY, ticketAvailabilityMap);
            resultMap.put(TICKET_TYPE_LIST, filteredTicketTypeList);

            // Don't override registrant list if there is already another registration or the user is authenticated
            if (!resultMap.containsKey(REGISTRANT_LIST)) {
                resultMap.put(REGISTRANT_LIST, waitlistInformationMap.get(REGISTRANT_LIST));
            }
        }

        return resultMap;
    }

    /**
     * Gets ticket discounts based on the promo code provided.
     *
     * @author Aaron Wong
     *
     * @param listingId     The id of the listing the promo code is being applied to.
     * @param promoCode     The promo code of the discount.
     * @return              A map containing information about the ticket discount.
     * @since               1.0
     */
    public virtual Map<String, Object> getPromoCodeDiscount(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String listingId = (String)params.get(LISTING_ID);
        String promoCode = (String)params.get(PROMO_CODE);

        if (String.isBlank(listingId) || String.isBlank(promoCode)) {
            return resultMap;
        }

        //Get ticket discount from promo code.
        Map<String, Map<String, Object>> ticketTypeIdToDiscountedPriceMap = PORTAL_UTIL_Events.getDiscountFromPromoCodes(new Map<String, Object> {
                                                                                                                            PORTAL_UTIL_Events.PROMO_CODE_LIST => new List<String>{promoCode},
                                                                                                                            PORTAL_UTIL_EVENTS.LISTING_ID => listingId});

        if (ticketTypeIdToDiscountedPriceMap == null || ticketTypeIdToDiscountedPriceMap.isEmpty()) {
            return resultMap;
        }

        for (String eachTicketTypeId : ticketTypeIdToDiscountedPriceMap.keySet()) {
            resultMap.put(TICKET_TYPE_ID, eachTicketTypeId);
            resultMap.put(TICKET_DISCOUNT_ID, ticketTypeIdToDiscountedPriceMap.get(eachTicketTypeId).get(PORTAL_UTIL_Events.TICKET_DISCOUNT_ID));
            resultMap.put(DISCOUNTED_PRICE, ticketTypeIdToDiscountedPriceMap.get(eachTicketTypeId).get(PORTAL_UTIL_Events.DISCOUNT_PRICE));
        }

        return resultMap;
    }

    /**
     * Registers the participants given for the event.
     *
     * @author Aaron Wong
     *
     * @param registrantList        The list of registrants to register.
     * @param listingId             The listing Id of the event.
     * @param sessionId             The session cookie Id to create the registration session for.
     * @param isWalkIn              Whether or not the registration is for Walk Ins.
     * @param paymentMethod         The payment method used to process walk ins.
     * @param recaptchaToken        The client side recaptcha token to be verified
     * @since                       1.0
     */
    public virtual Map<String, Object> registerParticipants(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();
        if (params == null || params.isEmpty()) {
            throwException(ERROR_CONTACT_ADMIN);
        }

        // Convert javascript objects to a list of Event Registrants that can be used for Apex actions
        List<EventRegistrant> registrantList = convertObjectsToEventRegistrants((List<Object>)params.get(REGISTRANT_LIST));
        String listingId = (String)params.get(LISTING_ID);
        String sessionId = (String)params.get(SESSION_ID);
        String waitlistEntryId = (String)params.get(WAITLIST_ENTRY_ID);
        Boolean isWalkIn = (Boolean)params.get(IS_WALK_IN);
        String paymentMethod = (String)params.get(PAYMENT_METHOD);
        String emailTemplateDeveloperName = (String)params.get(EMAIL_TEMPLATE_DEVELOPER_NAME);
        String interimSourceUrl = (String) params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);

        PORTAL_EventManagementControllerBase eventManagementController = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();
        if (isWalkIn == true && eventManagementController.isUserAdministrator() == false) {
            throwException(ERROR_CONTACT_ADMIN);
        }

        if (registrantList == null || registrantList.isEmpty()) {
            throwException(ERROR_REGISTRANT_INFO);
        }

        if (String.isBlank(listingId) || String.isBlank(sessionId)) {
            throwException(ERROR_CONTACT_ADMIN);
        }

        ucinn_portal_Listing__c listingRecord = getListingForEventRegistration(new Map<String, Object>{LISTING_ID => listingId});

        if (listingRecord == null) {
            throwException(ERROR_CONTACT_ADMIN);
        }

        if (listingRecord.Is_Non_Ticketed_Event__c == true) {
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            recaptchaController.verifyRecaptcha('PORTAL_EventRegistrationControllerBase.registerParticipants', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));
        }

        String templateId = '';
        if (String.isNotBlank(listingRecord.Registration_Template__c)) {
            templateId = listingRecord.Registration_Template__c;
        }

        ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord;

        if (String.isNotBlank(waitlistEntryId)) {
            waitlistEntryRecord = getWaitlistEntryById(waitlistEntryId);
        }

        User currentUser = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId());

        if (String.isBlank(registrantList[0].participationId)) {
            String guestPrimaryParticipation = PORTAL_UTIL_Events.getGuestSessionPrimaryParticipationForListings(new Set<String>{listingId}, sessionId).get(listingId);
            registrantList = updateStalePrimaryParticipation(registrantList, getExistingRegistrantList(guestPrimaryParticipation, currentUser.ContactId, listingId));
            // this status helps frontend determine where to redirect
            resultMap.put(EXISTING_PRIMARY_PARTICIPATION_STATUS, registrantList[0].participationStatus);
        }

        List<ucinn_portal_Participation__c> participationList = queryParticipationListFromRegistrants(registrantList);
        ucinn_portal_Participation__c primaryParticipation;

        if (participationList != null && !participationList.isEmpty()) {
            primaryParticipation = participationList.get(0);
            // Delete any participations or tickets that were added to the shopping cart, but then removed through modification.
            handleRegistrationRecordDeletion(participationList, registrantList);
        }

        // Validate that the registrants are correct (validateRegistrants throws its own errors)
        if (validateRegistrants(new Map<String, Object>{LISTING_ID => listingId,
                                                        REGISTRANT_LIST => registrantList,
                                                        TEMPLATE_ID => templateId,
                                                        WAITLIST_ENTRY => waitlistEntryRecord}) != true) {
            throwException(ERROR_REGISTRANT_INFO);
        }

        // Handles setting ticket statuses
        ucinn_portal_Registration_Session__c sessionRecord = getRegistrationSession(sessionId,
                                                                                    isWalkIn,
                                                                                    paymentMethod,
                                                                                    primaryParticipation,
                                                                                    waitlistEntryRecord,
                                                                                    listingRecord);

        // If payment is taken onsite, create a receipt record
        if (isWalkIn == true && paymentMethod != CREDIT_CARD_ONLINE && paymentMethod != FREE_CONST) {
            ucinn_portal_Receipt__c receiptRecord = createReceiptRecordForWalkIns(registrantList, paymentMethod);
            if (receiptRecord != null) {
                insert receiptRecord;
                sessionRecord.Receipt__c = receiptRecord.Id;
            }
        }

        upsert sessionRecord;
        resultMap.put(SESSION_ID, sessionRecord.Id);

        String participationStatus = getParticipationStatusToSet(listingRecord, waitlistEntryRecord, isWalkIn, paymentMethod);
        registerParticipants(registrantList, listingId, currentUser.ContactId, sessionRecord.Id, participationStatus, isWalkIn);

        if (waitlistEntryRecord != null) {
            ucinn_portal_Event_Waitlist_Entry__c waitlistEntryToUpdate = getUpdatedWaitlistEntryRecord(waitlistEntryRecord, registrantList);
            update waitlistEntryToUpdate;
        }

        if (listingRecord.Is_Non_Ticketed_Event__c == true && hasAddedRegistrant(registrantList)) {
            List<ucinn_portal_Participation__c> emailParticipationList = getParticipationListForEmail(registrantList.get(0).participationRecord.Id);

            ((PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getControllerFactory().getShoppingCartController())
                                                                                   .sendEmailsToUsers(emailParticipationList,
                                                                                                      emailTemplateDeveloperName,
                                                                                                      registrantList.get(0).firstName,
                                                                                                      registrantList.get(0).lastName,
                                                                                                      registrantList.get(0).email,
                                                                                                      new Map<Object, Object>{EMAIL_KEY => registrantList.get(0).email});
        }

        return resultMap;
    }

    /**
     * Converts a list of javascript objects to a list of EventRegistrant objects
     *
     * @author Aaron Wong
     *
     * @param objectList    List of javascript objects.
     * @return              List of EventRegistrant objects.
     * @since               1.0
     */
    private virtual List<EventRegistrant> convertObjectsToEventRegistrants(List<Object> objectList) {
        List<EventRegistrant> resultList = new List<EventRegistrant>();

        if (objectList == null || objectList.isEmpty()) {
            return resultList;
        }

        for (Object eachObject : objectList) {
            Map<Object, Object> objectMap = (Map<Object, Object>)eachObject;
            resultList.add(new EventRegistrant(objectMap));
        }

        return resultList;
    }

    /**
     * Validates registrants. Throws errors if the registration is invalid.
     *
     * @author Aaron Wong
     *
     * @param registrantList    List of registrants to validate.
     * @param listingId         The Id of the listing for the registration.
     * @param templateId        The Id of the registration template for the registration.
     * @return                  True if the registration is valid.
     * @since                   1.0
     */
    public virtual Boolean validateRegistrants(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return false;
        }

        List<EventRegistrant> registrantList = (List<EventRegistrant>)params.get(REGISTRANT_LIST);
        String listingId = (String)params.get(LISTING_ID);
        String templateId = (String)params.get(TEMPLATE_ID);
        ucinn_portal_Event_Waitlist_Entry__c waitlistEntry = (ucinn_portal_Event_Waitlist_Entry__c)params.get(WAITLIST_ENTRY);

        if (registrantList == null || registrantList.isEmpty() || String.isBlank(listingId)) {
            return false;
        }

        ucinn_portal_Registration_Template__c templateRecord = getRegistrationTemplate(new Map<String, Object>{TEMPLATE_ID => templateId});

        for (Integer registrantIndex = 0; registrantIndex < registrantList.size(); registrantIndex++) {
            EventRegistrant eachRegistrant = registrantList.get(registrantIndex);

            // Check registrant required info is filled out
            if (String.isBlank(eachRegistrant.firstName) || String.isBlank(eachRegistrant.lastName)) {
                return false;
            }

            if ((registrantIndex == 0 || (templateRecord != null && templateRecord.Is_Guest_Email_Required__c == true))
                    && String.isBlank(eachRegistrant.email)) {
                return false;
            }
        }

        return validateRegistrantTickets(registrantList, waitlistEntry, listingId);
    }

    /**
     * Registers the participants.
     *
     * @author Aaron Wong
     *
     * @param registrantList        List of registrants to register.
     * @param listingId             Listing Id of the event being registered for.
     * @param userContactId         Contact id of the current user.
     * @param sessionId             Id of the registration session to assign tickets to.
     * @param participationStatus   The status to set new participation records to.
     * @param isWalkIn              Whether or not the registration is for Walk Ins.
     * @since                       1.0
     */
    private static void registerParticipants(List<EventRegistrant> registrantList,
                                             String listingId,
                                             String userContactId,
                                             String sessionId,
                                             String participationStatus,
                                             Boolean isWalkIn) {
        List<ucinn_ascendv2__Interim__c> interimListToUpsert = new List<ucinn_ascendv2__Interim__c>();
        List<ucinn_portal_Participation__c> participationListToUpsert = new List<ucinn_portal_Participation__c>();
        List<ucinn_portal_Ticket__c> ticketListToUpsert = new List<ucinn_portal_Ticket__c>();
        List<ucinn_portal_Registration_Add_Info__c> additionalInfoListToUpsert = new List<ucinn_portal_Registration_Add_Info__c>();

        for (EventRegistrant eachRegistrant : registrantList) {
            if (eachRegistrant.hasInterim == true) {
                interimListToUpsert.add(eachRegistrant.toInterim());
            }
        }

        upsert interimListToUpsert;

        // First registrant needs to be upserted first to get primary participation Id to set for other constituents
        upsert registrantList[0].toParticipation(listingId, null, participationStatus, userContactId, isWalkIn);

        String primaryParticipationId = registrantList.get(0).participationRecord.Id;

        for (Integer registrantIndex = 1; registrantIndex < registrantList.size(); registrantIndex++) {
            participationListToUpsert.add(registrantList.get(registrantIndex).toParticipation(listingId, primaryParticipationId, participationStatus, userContactId, isWalkIn));
        }

        upsert participationListToUpsert;

        // Need participation Ids before creating tickets or additional infos
        for (EventRegistrant eachRegistrant : registrantList) {
            ticketListToUpsert.addAll(eachRegistrant.getTickets(sessionId));
            additionalInfoListToUpsert.addAll(eachRegistrant.getAdditionalInfo());
        }

        upsert ticketListToUpsert;
        upsert additionalInfoListToUpsert;
    }

    /**
     * Gets the listing used for event registration.
     *
     * @author Aaron Wong
     *
     * @param listingId     The listing id to query for.
     * @return              The listing being queried for.
     * @since               1.0
     */
    public virtual ucinn_portal_Listing__c getListingForEventRegistration(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return new ucinn_portal_Listing__c();
        }

        String listingId = (String)params.get(LISTING_ID);
        Boolean isWalkIn = (Boolean)params.get(IS_WALK_IN);

        if (String.isBlank(listingId)) {
            return new ucinn_portal_Listing__c();
        }

        String queryString = 'SELECT ';
        String fields = ' id, Name, Header_Content__c, Header_Image__c, Registration_Template__c, Number_of_Guests__c, Is_Non_Ticketed_Event__c, Is_Allow_Waitlisting_for_Event__c, Event_Actual_Start_Date_Time__c, Event_Actual_End_Date_Time__c, Time_Zone__c, Is_Guest_Registration_Info_Required__c, Is_Display_Look_Who_s_Coming__c, '
                      + ' (SELECT id, Name, Price__c, Max_Tickets_Per_Registrant__c, Total_Tickets_Available__c, Sales_Start_Date_Time__c, Sales_End_Date_Time__c, Description__c '
                       + ' FROM ucinn_portal_Ticket_Types_Listing__r ORDER BY Order_Number__c ASC) ';

        String whereClause = ' WHERE id = \'' + listingId + '\' AND RecordType.DeveloperName = \'Event\'';

        queryString = queryString + fields + ' FROM ucinn_portal_Listing__c ' + whereClause;

        DateTime currentDateTime = DateTime.now();

        List<ucinn_portal_Listing__c> listingList = Database.query(queryString);

        if (listingList == null || listingList.isEmpty()) {
            return new ucinn_portal_Listing__c();
        }

        return listingList.get(0);
    }

    /**
     * Gets the registration template used for event registration.
     *
     * @author Aaron Wong
     *
     * @param templateId    Id of the registration template to get.
     * @return              The registration template.
     * @since               1.0
     */
    public virtual ucinn_portal_Registration_Template__c getRegistrationTemplate(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return new ucinn_portal_Registration_Template__c();
        }

        String templateId = (String)params.get(TEMPLATE_ID);

        if (String.isBlank(templateId)) {
            return new ucinn_portal_Registration_Template__c();
        }

        String queryString = 'SELECT ';
        String fields = ' id, Name, Is_Display_Address_Fields__c, Is_Display_Degree_and_Year_Field__c, Is_Guest_Email_Required__c, '
                      + ' Is_Display_Employer_Field__c, Is_Display_Phone_Field__c, Is_Display_Registration_Helper_Text__c, '
                      + ' Registration_Helper_Text__c, Has_Terms_And_Conditions__c, Terms_and_Conditions_Text__c, '
                      + ' (SELECT id, Name, Order_Number__c FROM ucinn_portal_Registration_Pages__r ORDER BY Order_Number__c ASC) ';
        String whereClause = ' WHERE id = \'' + templateId + '\'';

        queryString = queryString + fields + ' FROM ucinn_portal_Registration_Template__c ' + whereClause;

        List<ucinn_portal_Registration_Template__c> registrationTemplateList = Database.query(queryString);

        if (registrationTemplateList == null || registrationTemplateList.isEmpty()) {
            return new ucinn_portal_Registration_Template__c();
        }

        return registrationTemplateList.get(0);
    }

    /**
     * Gets the custom form fields for the registration template.
     *
     * @author Aaron Wong
     *
     * @param templateId    Id of the registration template.
     * @return              List of custom form fields.
     * @since               1.0
     */
    public virtual List<ucinn_portal_Custom_Form_Field__c> getCustomFormFields(Map<String, Object> params) {
        List<ucinn_portal_Custom_Form_Field__c> resultList = new List<ucinn_portal_Custom_Form_Field__c>();

        if (params == null || params.isEmpty()) {
            return resultList;
        }

        String templateId = (String)params.get(TEMPLATE_ID);

        if (String.isBlank(templateId)) {
            return resultList;
        }

        /* Custom Form Fields on the main registration page will have Registration Template filled,
           and Custom Form Fields on other registration pages will have the Registration Page filled*/
        String queryString = ' SELECT ';
        String fields = ' id, Name, Field_Type__c, Field_Label__c, Available_Values__c, Default_Value__c, Editable__c, '
                      + ' Registration_Page__c, Field_Order__c, Ticket_Type__c, Is_Display_To_Guests__c, Is_Required__c, '
                      + ' Registration_Page__r.Order_Number__c ';
        String whereClause = ' WHERE Registration_Template__c = \'' + templateId + '\' '
                           + ' OR Registration_Page__r.Registration_Template__c = \'' + templateId + '\'';

        queryString = queryString + fields + ' FROM ucinn_portal_Custom_Form_Field__c ' + whereClause + ' ORDER BY Field_Order__c ';

        resultList = Database.query(queryString);

        return resultList;
    }

    /**
     * Get existing registrant list.
     *
     * @author Aaron Wong
     *
     * @param participationId   The Id of the primary participation.
     * @param contactId         The Id of the authenticated user's contact.
     * @param listingId         The Id of the event to get registrants for.
     * @return                  List of existing event registrants.
     * @since                   1.0
     */
    private static List<EventRegistrant> getExistingRegistrantList(String participationId,
                                                                   String contactId,
                                                                   String listingId) {
        List<EventRegistrant> resultList = new List<EventRegistrant>();

        if ((String.isBlank(participationId) && String.isBlank(contactId))
                || String.isBlank(listingId)) {
            return resultList;
        }

        String queryString = ' SELECT ';
        String fields = ' id, Degree_And_Year__c, Interim__c, Interim__r.ucinn_ascendv2__First_Name__c, Status__c, Is_Send_Confirmation_Email__c, Is_Display_On_Look_Who_s_Coming_List__c, Name_Tag__c,'
                      + ' Interim__r.ucinn_ascendv2__Last_Name__c, Interim__r.ucinn_ascendv2__Email_1__c, '
                      + ' Interim__r.ucinn_ascendv2__Phone_1__c, Interim__r.ucinn_ascendv2__Employer__c, '
                      + ' Interim__r.ucinn_ascendv2__Address_1_Line_1__c, Interim__r.ucinn_ascendv2__Address_1_Line_2__c, Interim__r.ucinn_ascendv2__City_1__c, '
                      + ' Interim__r.ucinn_ascendv2__State_1__c, Interim__r.ucinn_ascendv2__Country_1__c, '
                      + ' Interim__r.ucinn_ascendv2__Postal_Code_1__c, Contact__r.FirstName, Contact__r.LastName, '
                      + ' Contact__r.Email, Contact__r.Phone, Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                      + ' Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                      + ' Contact__r.ucinn_ascendv2__Preferred_Address_State__c, Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                      + ' Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                      + ' (SELECT id, Number_of_Tickets__c, Ticket_Type__c, Ticket_Type__r.Name, Ticket_Type__r.Max_Tickets_Per_Registrant__c, Price_Per_Ticket__c, Ticket_Discount__c, Registration_Session__r.Status__c, Status__c '
                      + '  FROM ucinn_portal_Tickets_Participation__r WHERE Is_Valid_Ticket__c = true), '
                      + ' (SELECT id, Name, Value__c, Custom_Form_Field__c, Custom_Form_Field__r.Name, Custom_Form_Field__r.Field_Label__c, Custom_Form_Field__r.Is_Required__c '
                      + '  FROM ucinn_portal_Registration_Add_Infos__r) ';
        String whereClause = ' WHERE Listing__c = \'' + listingId + '\' ';
        String orderByClause = ' ORDER BY Primary_Participation__c NULLS FIRST';

        if (String.isNotBlank(participationId)) {
            whereClause = whereClause + ' AND (id = \'' + participationId + '\' OR Primary_Participation__c = \'' + participationId + '\') ' ;
        } else if (String.isNotBlank(contactId)) {
            whereClause = whereClause + ' AND Purchasing_Constituent__c = \'' + contactId + '\'';
        } else {
            // Return if no primary participation Id or contact Id given
            return resultList;
        }

        // Only query participation records with valid tickets and with status not cancelled
        whereClause = whereClause + ' AND id IN (SELECT Participation__c FROM ucinn_portal_Ticket__c WHERE Is_Valid_Ticket__c = true)' + ' AND Status__c != \'' + PORTAL_CONST_Events.PARTICIPATION_STATUS_CANCELLED + '\'';

        queryString = queryString + fields + ' FROM ucinn_portal_Participation__c ' + whereClause + orderByClause;

        List<ucinn_portal_Participation__c> participationList = Database.query(queryString);

        // Convert participation records into event registrants
        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            resultList.add(new EventRegistrant(eachParticipation));
        }

        return resultList;
    }

    /**
     * Update a new but potentially stale registrant list with the most recent primary participation record for 
     * the particular authenticated user/listing pair
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param newRegistrantList         list of EventRegistrants that may not contain the most recent primary participation record
     * @param existingRegistrantList    list of EventRegistrants based on existing Participation records
     * 
     * @return list of EventRegistrants with updated primary registrant/primary participation info
     */
    private static List<EventRegistrant> updateStalePrimaryParticipation(List<EventRegistrant> newRegistrantList, List<EventRegistrant> existingRegistrantList) {
        if (newRegistrantList == null || existingRegistrantList == null || newRegistrantList.isEmpty() || existingRegistrantList.isEmpty()) {
            return newRegistrantList;
        }

        if (String.isBlank(newRegistrantList[0].participationId) && String.isNotBlank(existingRegistrantList[0].participationId)) {
            newRegistrantList[0].participationId = existingRegistrantList[0].participationId;
            newRegistrantList[0].participationStatus = existingRegistrantList[0].participationStatus;
        }

        return newRegistrantList;
    }

    /**
     * Get the current user's contact information.
     *
     * @author Aaron Wong
     *
     * @return  The current user's contact information if authenticated.
     * @since   1.0
     */
    private static Contact getUserContact() {
        User currentUser = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId());

        if (currentUser == null || String.isBlank(currentUser.ContactId)) {
            return null;
        }

        List<Contact> contactList = [SELECT id, FirstName, LastName, Email, Phone,
                                            ucinn_ascendv2__Preferred_Address_Line_1__c,
                                            ucinn_ascendv2__Preferred_Address_Line_2__c,
                                            ucinn_ascendv2__Preferred_Address_Line_3__c,
                                            ucinn_ascendv2__Preferred_Address_City__c,
                                            ucinn_ascendv2__Preferred_Address_State__c,
                                            ucinn_ascendv2__Preferred_Address_Country__c,
                                            ucinn_ascendv2__Preferred_Address_Postal_Code__c,
                                            (SELECT id, ucinn_ascendv2__Major_Degree_Short_Formula__c, ucinn_ascendv2__Conferred_Degree_Year__c
                                             FROM ucinn_ascendv2__Degree_Information_Contact__r
                                             WHERE RecordType.DeveloperName = :SCHOOL_DEGREE_INFORMATION
                                             AND ucinn_portal_Is_Display_On_Portal__c = true
                                             ORDER BY ucinn_ascendv2__Conferred_Degree_Year__c ASC),
                                            (SELECT id, ucinn_ascendv2__Account__r.Name
                                             FROM ucinn_ascendv2__Affiliations_Contact__r
                                             WHERE ucinn_ascendv2__Is_Active__c = true
                                             AND ucinn_portal_Is_Display_on_Portal__c = true
                                             ORDER BY ucinn_ascendv2__Start_Date__c DESC)
                                     FROM Contact
                                     WHERE id = :currentUser.ContactId];

        if (contactList == null || contactList.isEmpty()) {
            return null;
        }

        return contactList.get(0);
    }

    /**
     * Formats the degree and year for the given degree list.
     *
     * @author Aaron Wong
     *
     * @param degreeList    List of degrees to format.
     * @return              String of formatted degrees.
     * @since               1.0
     */
    @TestVisible
    private static String formatDegreeAndYears(List<ucinn_ascendv2__Degree_Information__c> degreeList) {
        String resultString = '';

        if (degreeList == null || degreeList.isEmpty()) {
            return resultString;
        }

        for (ucinn_ascendv2__Degree_Information__c eachDegree : degreeList) {
            if (String.isBlank(eachDegree.ucinn_ascendv2__Major_Degree_Short_Formula__c)
                    || String.isBlank(eachDegree.ucinn_ascendv2__Conferred_Degree_Year__c)
                    || eachDegree.ucinn_ascendv2__Conferred_Degree_Year__c.length() != 4) {
                continue;
            }

            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }

            resultString = resultString + eachDegree.ucinn_ascendv2__Major_Degree_Short_Formula__c + '\''
                            + eachDegree.ucinn_ascendv2__Conferred_Degree_Year__c.substring(2);
        }

        return resultString;
    }

    /**
     * Gets the registration session based on the session Id stored on the user's browser. If valid incomplete session
     * is found, a new Registration Session record is created.
     *
     * @author Aaron Wong
     *
     * @param cookieId          The cookie Id stored on the user's browser.
     * @param listingRecord     The listing record if the current event.
     * @return                  The registration session.
     * @since                   1.0
     */
    private static ucinn_portal_Registration_Session__c getRegistrationSession(String cookieId,
                                                                               Boolean isWalkIn,
                                                                               String paymentMethod,
                                                                               ucinn_portal_Participation__c primaryParticipation,
                                                                               ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord,
                                                                               ucinn_portal_Listing__c listingRecord) {
        if (String.isBlank(cookieId)) {
            return null;
        }

        // Should return 0 or 1 Registration Session, but there are edge cases where >1 can exist
        List<ucinn_portal_Registration_Session__c> sessionList = [SELECT id, Expiration_Date_Time__c, Session_Id__c
                                                                  FROM ucinn_portal_Registration_Session__c
                                                                  WHERE Session_Id__c = :cookieId
                                                                    AND Is_Valid_Session__c = true
                                                                    AND Status__c != :PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED
                                                                    AND Status__c != :PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION
                                                                  ORDER BY CreatedDate DESC];

        ucinn_portal_Registration_Session__c resultSession = new ucinn_portal_Registration_Session__c();

        if (sessionList == null || sessionList.isEmpty()) {
            resultSession.Session_Id__c = cookieId;
        } else {
            resultSession = sessionList.get(0);
        }

        String expirationCMTDeveloperName = PORTAL_CONST_Events.ORG_SETTING_SHOPPING_CART_EXPIRATION_TIME_IN_MINUTES;

        /* Non ticketed events and walkIns that don't need payment should be completed after registration and
           don't go to the shopping cart. (Hence status should be completed)*/
        if ((listingRecord != null && listingRecord.Is_Non_Ticketed_Event__c == true)
                || (isWalkIn == true && paymentMethod != CREDIT_CARD_ONLINE)) {
            /* Null out session Id since this is a different session
               (could have tickets in shopping cart that shouldn't be completed).
               Later in the registration process we do an upsert on the registration session, creating a
               new one in this case.*/
            resultSession.Id = null;
            resultSession.Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED;
        } else if ((primaryParticipation != null && primaryParticipation.Status__c == PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED)
                || (isWalkIn == true && paymentMethod == CREDIT_CARD_ONLINE)
                || waitlistEntryRecord != null) {
            /* In the case of modification of an already completed registration, walk ins with payment, or registering waitlisted tickets,
                create a new Registration Session and set the tickets to Pending Payment since they go directly
                to the payment page.*/
            resultSession.Id = null;
            resultSession.Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT;
            expirationCMTDeveloperName = PORTAL_CONST_Events.ORG_SETTING_EVENT_PAYMENT_EXPIRATION_TIME_IN_MINUTES;
        } else {
            resultSession.Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART;
        }

        // Get the expiration time to set
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{expirationCMTDeveloperName}
        });

        // Default expiration time is 15 minutes if no setting is set
        Integer expirationTimeInMinutes = PORTAL_CONST_EVENTS.DEFAULT_SESSION_EXPIRATION_TIME;

        if (orgSettingList != null && !orgSettingList.isEmpty()) {
            try {
                expirationTimeInMinutes = Integer.valueOf(orgSettingList.get(0).Value__c);
            } catch(Exception e) {
                System.debug(e);
            }
        }

        resultSession.Expiration_Date_Time__c = DateTime.now().addMinutes(expirationTimeInMinutes);

        return resultSession;
    }

    /**
     * Gets a map of Ticket Type Id to their record.
     *
     * @author Aaron Wong
     *
     * @param listingId     Id of the listing to get ticket types for.
     * @return              Map of ticket type Id to ticket type.
     * @since               1.0
     */
    @TestVisible
    private static Map<String, ucinn_portal_Ticket_Type__c> getTicketTypeIdToTicketTypeMap(String listingId) {
        Map<String, ucinn_portal_Ticket_Type__c> resultMap = new Map<String, ucinn_portal_Ticket_Type__c>();

        if (String.isBlank(listingId)) {
            return resultMap;
        }

        List<ucinn_portal_Ticket_Type__c> ticketTypeList = [SELECT id, Name, Price__c, Max_Tickets_Per_Registrant__c
                                                            FROM ucinn_portal_Ticket_Type__c
                                                            WHERE Listing__c = :listingId];

        if (ticketTypeList == null || ticketTypeList.isEmpty()) {
            return resultMap;
        }

        for (ucinn_portal_Ticket_Type__c eachTicketType : ticketTypeList) {
            resultMap.put(eachTicketType.Id, eachTicketType);
        }

        return resultMap;
    }

    /**
     * Gets a set of ticket type Ids from the listing record provided.
     *
     * @author Aaron Wong
     *
     * @param listingRecord     The listing record to get ticket type Ids from.
     * @return                  A set of ticket type Ids.
     * @since                   1.0
     */
    private static Set<String> getTicketTypeIdSetFromListing(ucinn_portal_Listing__c listingRecord) {
        Set<String> resultSet = new Set<String>();

        if (listingRecord == null || listingRecord.ucinn_portal_Ticket_Types_Listing__r == null
                || listingRecord.ucinn_portal_Ticket_Types_Listing__r.isEmpty()) {
            return resultSet;
        }

        for (ucinn_portal_Ticket_Type__c eachTicketType : listingRecord.ucinn_portal_Ticket_Types_Listing__r) {
            resultSet.add(eachTicketType.Id);
        }

        return resultSet;
    }

    /**
     * Gets the status to set participation records to.
     *
     * @author Aaron Wong
     *
     * @param listingRecord     The listing record for the registration.
     * @param isWalkIn          Whether or not the registration is for walk ins.
     * @param paymentMethod     The payment method for walkins.
     * @return                  The status to set new participation records to.
     * @since                   1.0
     */
    private static String getParticipationStatusToSet(ucinn_portal_Listing__c listingRecord,
                                                      ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord,
                                                      Boolean isWalkin,
                                                      String paymentMethod) {
        if (listingRecord == null) {
            return '';
        }

        if (listingRecord.Is_Non_Ticketed_Event__c == true || isWalkin == true || waitlistEntryRecord != null) {
            return PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED;
        }

        return PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING;
    }

    /**
     * Get a list of participation records to delete during the registration process.
     * Deletes participation records that are not set to Registered, linked to the primary registrant, and not in
     * the registrant list.
     *
     * @author Aaron Wong
     *
     * @param participationList     List of participation Records for the registration.
     * @param registrantList        List of registrants for the registration.
     * @return                      List of registrants to delete.
     * @since                       1.0
     */
    @TestVisible
    private static void handleRegistrationRecordDeletion(List<ucinn_portal_Participation__c> participationList,
                                                         List<EventRegistrant> registrantList) {
        List<ucinn_portal_Participation__c> participationListToDelete = new List<ucinn_portal_Participation__c>();
        List<ucinn_portal_Ticket__c> ticketListToDelete = new List<ucinn_portal_Ticket__c>();

        /* If the primary registrant (first registrant) doesn't have a participation Id, there are no participation records
          for any of the registrants in the database.*/
        if (registrantList == null || registrantList.isEmpty() || String.isBlank(registrantList.get(0).participationId)
                || participationList == null || participationList.isEmpty()) {
            return;
        }

        Set<String> frontEndParticipationIdSet = new Set<String>();
        Set<String> frontEndTicketIdSet = new Set<String>();
        String primaryParticipationId = registrantList.get(0).participationId;

        // Get all participation and ticket ids that are in the registrantList
        for (EventRegistrant eachRegistrant : registrantList) {
            if (String.isNotBlank(eachRegistrant.participationId)) {
                frontEndParticipationIdSet.add(eachRegistrant.participationId);
            }

            if (eachRegistrant.ticketList == null || eachRegistrant.ticketList.isEmpty()) {
                continue;
            }

            for (RegistrationTicket eachRegistrationTicket : eachRegistrant.ticketList) {
                if (String.isNotBlank(eachRegistrationTicket.ticketId)) {
                    frontEndTicketIdSet.add(eachRegistrationTicket.ticketId);
                }
            }
        }

        /* Delete participation records and ticket records in the database that are not present in the current registration
           where the participation records are not already registered and the ticket records are not paid for yet.*/
        for (ucinn_portal_Participation__c eachParticipation : participationList) {
            if (!frontEndParticipationIdSet.contains(eachParticipation.Id)
                    && eachParticipation.Status__c != PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED) {
                participationListToDelete.add(eachParticipation);
            }

            if (eachParticipation.ucinn_portal_Tickets_Participation__r == null || eachParticipation.ucinn_portal_Tickets_Participation__r.isEmpty()) {
                continue;
            }

            for (ucinn_portal_Ticket__c eachTicket : eachParticipation.ucinn_portal_Tickets_Participation__r) {
                if (!frontEndTicketIdSet.contains(eachTicket.Id)
                        && eachTicket.Status__c != PORTAL_CONST_Events.TICKET_STATUS_PAID && eachTicket.Status__c != PORTAL_CONST_Events.TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION) {
                    ticketListToDelete.add(eachTicket);
                }
            }
        }

        delete ticketListToDelete;
        delete participationListToDelete;
    }

    /**
     * Gets organization settings related to event registration.
     *
     * @author Aaron Wong
     *
     * @return  List of organization settings.
     * @since   1.0
     */
    public static List<Portal_Organization_Setting__mdt> getOrganizationSettings() {
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{PORTAL_CONST_EVENTS.ORG_SETTING_IS_GUEST_REGISTRATION_MODIFIABLE}
        });

        return orgSettingList;
    }

    /**
     * Queries participation records from the list of registrants given.
     *
     * @author Aaron Wong
     *
     * @param registrantList    List of registrants to query participations for.
     * @return                  List of participation records.
     * @since                   1.0
     */
    private static List<ucinn_portal_Participation__c> queryParticipationListFromRegistrants(List<EventRegistrant> registrantList) {
        List<ucinn_portal_Participation__c> resultList = new List<ucinn_portal_Participation__c>();

        if (registrantList == null || registrantList.isEmpty()) {
            return resultList;
        }

        // First registrant is always the primary participation
        String primaryParticipationId = registrantList.get(0).participationId;

        if (String.isBlank(primaryParticipationId)) {
            return resultList;
        }

        resultList = [SELECT id, Status__c,
                             (SELECT id, Status__c FROM ucinn_portal_Tickets_Participation__r WHERE Status__c != :PORTAL_CONST_Events.TICKET_STATUS_PAID AND Status__c != :PORTAL_CONST_Events.TICKET_STATUS_AWAITING_GATEWAY_CONFIRMATION)
                      FROM ucinn_portal_Participation__c
                      WHERE Primary_Participation__c = :primaryParticipationId
                      OR id = :primaryParticipationId
                      ORDER BY Primary_Participation__c NULLS FIRST];

        return resultList;
    }

    /**
     * Validates the registrants tickets. Throws an error if an issue is found.
     *
     * @author Aaron Wong
     *
     * @param registrantlist    The list of registrants.
     * @param listingId         The listing Id.
     * @since                   1.0
     */
    private static Boolean validateRegistrantTickets(List<EventRegistrant> registrantList,
                                                     ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord,
                                                     String listingId) {
        if (registrantList == null || registrantList.isEmpty() || String.isBlank(listingId)) {
            return false;
        }

        Map<String, Object> ticketAvailabilityMap = PORTAL_UTIL_Events.getAvailableTicketsForListing(new Map<String, Object>{LISTING_ID => listingId});

        if (ticketAvailabilityMap == null) {
            return false;
        }

        if (waitlistEntryRecord != null) {
            ticketAvailabilityMap.put(waitlistEntryRecord.Ticket_Type__c, waitlistEntryRecord.Number_of_Tickets_Available__c);
            ticketAvailabilityMap.put(PORTAL_UTIL_Events.TOTAL_TICKETS, waitlistEntryRecord.Number_of_Tickets_Available__c);
        }

        Map<String, ucinn_portal_Ticket_Type__c> idToTicketTypeMap = getTicketTypeIdToTicketTypeMap(listingId);
        Map<String, Map<String, Decimal>> ticketTypeIdToDiscountMap = PORTAL_UTIL_Events.getTicketTypeIdToDiscountMapFromListingId(new Map<String, Object> {LISTING_ID => listingId});

        Decimal totalQuantity = 0;
        Map<String, Decimal> ticketTypeIdToQuantity = new Map<String, Decimal>();

        for (EventRegistrant eachRegistrant : registrantList) {
            // Calculate the total ticket quantity for each type per registrant
            Map<String, Decimal> ticketTypeIdToRegistrantTicketQuantityMap = new Map<String, Decimal>();

            // Calculate total tickets being purchased
            if (eachRegistrant.ticketList != null && !eachRegistrant.ticketList.isEmpty()) {
                for (RegistrationTicket eachTicket : eachRegistrant.ticketList) {
                    // Get the number of unpaid tickets (pending payment and in shopping cart)
                    Decimal quantityUnpaid = eachTicket.quantityInPossession != null ? (eachTicket.quantityInPossession - eachTicket.purchasedQuantity) : 0;

                    if (eachTicket.quantity == null) {
                        eachTicket.quantity = 0;
                    }

                    // Paid and Awaiting Gateway Confirmation tickets are not included in quantity (bc a frontend calc already subtracted them) 
                    // and should not include unpaid tickets (status of in shopping cart and payment pending)
                    Decimal quantityBeingPurchased = eachTicket.quantity - quantityUnpaid;

                    if (ticketTypeIdToQuantity.containsKey(eachTicket.ticketTypeId)) {
                        ticketTypeIdToQuantity.put(eachTicket.ticketTypeId, quantityBeingPurchased + ticketTypeIdToQuantity.get(eachTicket.ticketTypeId));
                    } else {
                        ticketTypeIdToQuantity.put(eachTicket.ticketTypeId, quantityBeingPurchased);
                    }

                    totalQuantity += quantityBeingPurchased;

                    // Add up actual total quantity for ticket type and store in map
                    Decimal totalQuantityForThisTicketType = eachTicket.quantity + eachTicket.purchasedQuantity;

                    if (ticketTypeIdToRegistrantTicketQuantityMap.containsKey(eachTicket.ticketTypeId)) {
                        ticketTypeIdToRegistrantTicketQuantityMap.put(eachTicket.ticketTypeId, totalQuantityForThisTicketType + ticketTypeIdToRegistrantTicketQuantityMap.get(eachTicket.ticketTypeId));
                    } else {
                        ticketTypeIdToRegistrantTicketQuantityMap.put(eachTicket.ticketTypeId, totalQuantityForThisTicketType);
                    }

                    // If price is changed
                    if (!idToTicketTypeMap.containsKey(eachTicket.ticketTypeId)) {
                        return false;
                    }
                    if (eachTicket.price != idToTicketTypeMap.get(eachTicket.ticketTypeId).Price__c) {
                        if (String.isBlank(eachTicket.ticketDiscountId)
                                || !ticketTypeIdToDiscountMap.containsKey(eachTicket.ticketTypeId)
                                || !ticketTypeIdToDiscountMap.get(eachTicket.ticketTypeId).containsKey(eachTicket.ticketDiscountId)
                                || ticketTypeIdToDiscountMap.get(eachTicket.ticketTypeId).get(eachTicket.ticketDiscountId) != eachTicket.price) {
                            throwException(ERROR_INVALID_DISCOUNT);
                        }
                    }
                }
            }

            // For each ticket type, check the accumulated ticket quantity
            // against Max_Tickets_Per_Registrant__c for this registrant
            for (String eachTicketTypeId : ticketTypeIdToRegistrantTicketQuantityMap.keySet()) {
                Decimal totalQuantityForThisTicketTypeForThisRegistrant = ticketTypeIdToRegistrantTicketQuantityMap.get(eachTicketTypeId);

                // Throw error if purchase amount exceeds ticket type's set max
                if (totalQuantityForThisTicketTypeForThisRegistrant > 0 && (Decimal)idToTicketTypeMap.get(eachTicketTypeId)?.Max_Tickets_Per_Registrant__c < totalQuantityForThisTicketTypeForThisRegistrant) {
                    throwException(ERROR_TICKET_EXCEEDED_TICKET_TYPE_LIMIT(idToTicketTypeMap.get(eachTicketTypeId).Name, (Decimal)idToTicketTypeMap.get(eachTicketTypeId)?.Max_Tickets_Per_Registrant__c));
                }
            }
        }

        // Check ticket availability for the event
        if ((Decimal)ticketAvailabilityMap.get(PORTAL_UTIL_Events.TOTAL_TICKETS) < totalQuantity) {
            throwException(ERROR_EVENT_NOT_ENOUGH_TICKETS);
        }

        // Check ticket availability per ticket type
        for (String eachTicketTypeId : ticketTypeIdToQuantity.keySet()) {
            Decimal ticketQuantity = ticketTypeIdToQuantity.get(eachTicketTypeId);

            // Throw error if there's no available tickets for the ticket type
            if ((!ticketAvailabilityMap.containsKey(eachTicketTypeId) && ticketQuantity > 0)
                    || (ticketQuantity > 0 && (Decimal)ticketAvailabilityMap.get(eachTicketTypeId) < ticketQuantity)) {
                throwException(ERROR_TICKET_NOT_ENOUGH_TICKETS(idToTicketTypeMap.get(eachTicketTypeId).Name));
            }
        }

        return true;
    }

    /**
     * Creates a receipt record for walk ins with the given registrants and payment method.
     *
     * @author Aaron Wong
     *
     * @param registrantList        List of registrants to generate receipt with.
     * @param paymentMethod         Payment method to generate receipt with.
     * @return                      A receipt record.
     * @since                       1.0
     */
    @TestVisible
    private static ucinn_portal_Receipt__c createReceiptRecordForWalkIns(List<EventRegistrant> registrantList, String paymentMethod) {
        if (registrantList == null || registrantList.isEmpty() || String.isBlank(paymentMethod)) {
            return null;
        }

        Decimal totalPrice = 0;

        for (EventRegistrant eachRegistrant : registrantList) {
            if (eachRegistrant.ticketList == null || eachRegistrant.ticketList.isEmpty()) {
                continue;
            }

            for (RegistrationTicket eachTicket : eachRegistrant.ticketList) {
                if (eachTicket.price == null || eachTicket.quantity == null) {
                    continue;
                }

                totalPrice = totalPrice + (eachTicket.price * eachTicket.quantity);
            }
        }

        // No receipt needed if no payment is done
        if (totalPrice == 0) {
            return null;
        }

        ucinn_portal_Receipt__c resultReceipt = new ucinn_portal_Receipt__c(First_Name__c = registrantList.get(0).firstName,
                                                                            Last_Name__c = registrantList.get(0).lastName,
                                                                            Email__c = registrantList.get(0).email,
                                                                            Charged_Amount__c = totalPrice,
                                                                            Payment_Method__c = paymentMethod);

        return resultReceipt;
    }

    /**
     * Gets waitlist information for the given wailist entry id.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryId   The Id of the waitlist entry to get info from.
     * @return                  Map containing a prepopulated registrant as well as the ticket availability.
     * @since                   1.0
     */
    private static Map<String, Object> getWaitlistInformation(String waitlistEntryId) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (String.isBlank(waitlistEntryId)) {
            return resultMap;
        }

        ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord = getWaitlistEntryById(waitlistEntryId);

        if (waitlistEntryRecord == null || waitlistEntryRecord.Number_of_Tickets_Available__c <= 0) {
            return resultMap;
        }

        resultMap.put(TICKET_AVAILABILITY, new Map<String, Object>{waitlistEntryRecord.Ticket_Type__c => waitlistEntryRecord.Number_of_Tickets_Available__c});
        resultMap.put(REGISTRANT_LIST, new List<EventRegistrant>{new EventRegistrant(waitlistEntryRecord)});

        return resultMap;
    }

    /**
     * Gets an Event Waitlist Entry by Id.
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryId       The waitlist entry's Id.
     * @return                      The Event Waitlist Entry
     * @since                       1.0
     */
    private static ucinn_portal_Event_Waitlist_Entry__c getWaitlistEntryById(String waitlistEntryId) {
        if (String.isBlank(waitlistEntryId)) {
            return null;
        }

        List<ucinn_portal_Event_Waitlist_Entry__c> waitlistEntryList = [SELECT id, First_Name__c, Last_Name__c, Email__c, Number_of_Tickets_Available__c, Ticket_Type__c
                                                                        FROM ucinn_portal_Event_Waitlist_Entry__c
                                                                        WHERE id = :waitlistEntryId];

        if (waitlistEntryList == null || waitlistEntryList.isEmpty()) {
            return null;
        }

        ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord = waitlistEntryList.get(0);
        return waitlistEntryRecord;
    }

    /**
     * Removes available waitlisted tickets from Event Wailist Entry
     *
     * @author Aaron Wong
     *
     * @param waitlistEntryRecord   Waitlist Entry record to update.
     * @param registrantList        List of registrants.
     * @return                      Updated Event Waitlist Entry record.
     * @since                       1.0
     */
    private static ucinn_portal_Event_Waitlist_Entry__c getUpdatedWaitlistEntryRecord(ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord,
                                                                                      List<EventRegistrant> registrantList) {
        if (waitlistEntryRecord == null || registrantList == null || registrantList.isEmpty()) {
            return null;
        }

        Decimal totalTicketsRegistered = 0;

        for (EventRegistrant eachRegistrant : registrantList) {
            if (eachRegistrant.ticketList == null || eachRegistrant.ticketList.isEmpty()) {
                continue;
            }

            for (RegistrationTicket eachTicket : eachRegistrant.ticketList) {
                if (eachTicket.quantity == null) {
                    continue;
                }

                totalTicketsRegistered = totalTicketsRegistered + eachTicket.quantity;
            }
        }

        return new ucinn_portal_Event_Waitlist_Entry__c(Id = waitlistEntryRecord.Id, Number_of_Tickets_Available__c = waitlistEntryRecord.Number_of_Tickets_Available__c - totalTicketsRegistered);
    }

    private Map<String, Object> getFormattedEvent(ucinn_portal_Listing__c listingRecord) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (listingRecord == null) {
            return resultMap;
        }

        resultMap.put(NAME_KEY, listingRecord.Name);
        resultMap.put(EVENT_START_DATE_TIME, createFormattedDateString(listingRecord.Event_Actual_Start_Date_Time__c, listingRecord.Time_Zone__c));
        resultMap.put(EVENT_END_DATE_TIME, createFormattedDateString(listingRecord.Event_Actual_End_Date_Time__c, listingRecord.Time_Zone__c));

        return resultMap;
    }


    /**
     * Converts Date String into formatted date string for events
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param unformattedDate   Unformatted Date String
     * @param timeZone          Time Zone to parse
     *
     * @return                  Formatted Date String with Time Zone
     */
    @TestVisible
    private String createFormattedDateString(String unformattedDate, String timeZone) {
        String formattedDateString = '';

        if (String.isBlank(unformattedDate)) {
            return formattedDateString;
        }

        formattedDateString = DateTime.valueOfGMT(unformattedDate).format('MMMM dd, yyyy hh:mm aa', 'GMT');

        if (String.isBlank(timeZone)) {
            return formattedDateString;
        }

        List<String> timeZoneParts = timeZone.split(' ');

        for (String eachPart : timeZoneParts) {
            if (!eachPart.startsWith('(')) {
                formattedDateString = formattedDateString + ' ' + eachPart;
                continue;
            }

            if (!eachPart.contains('GMT')) {
                break;
            }
        }

        return formattedDateString;
    }

    /**
     * Gets participation information to send an email. Only used in this class for non-ticketed events
     *
     * @author Aaron Wong
     *
     * @param primaryParticipationId        The primary participation's Id.
     * @return                              List of participations.
     * @since                               1.0
     */
    private static List<ucinn_portal_Participation__c> getParticipationListForEmail(String primaryParticipationId) {
        List<ucinn_portal_Participation__c> resultList = new List<ucinn_portal_Participation__c>();

        List<String> TICKET_STATUS_EXCLUDE_LIST = PORTAL_ShoppingCartControllerBase.TICKET_STATUS_EXCLUDE_LIST;

        String queryString = 'SELECT Id, Name, Is_Send_Confirmation_Email__c, Full_Name__c, Status__c, '
                                 + 'Primary_Participation__c, '
                                 + 'Primary_Participation__r.Status__c, '
                                 + 'Primary_Participation__r.Full_Name__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Email_1__c, '
                                 + 'Primary_Participation__r.Contact__r.Email, '
                                 + 'Contact__r.Email, '
                                 + 'Listing__r.Id, Listing__r.Name, '
                                 + 'Listing__r.Email_Confirmation_Details__c, '
                                 + 'Listing__r.Event_Actual_Start_Date_Time__c, '
                                 + 'Listing__r.Event_Actual_End_Date_Time__c, '
                                 + 'Listing__r.Time_Zone__c, '
                                 + 'Listing__r.Location_Venue__c, '
                                 + 'Interim__r.ucinn_ascendv2__Email_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Address_1_Line_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Address_1_Line_2__c, '
                                 + 'Interim__r.ucinn_ascendv2__City_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__State_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Country_1__c, '
                                 + 'Interim__r.ucinn_ascendv2__Postal_Code_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Address_1_Line_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Address_1_Line_2__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__City_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__State_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Country_1__c, '
                                 + 'Primary_Participation__r.Interim__r.ucinn_ascendv2__Postal_Code_1__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_State__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                                 + 'Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_State__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                                 + 'Primary_Participation__r.Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                                 + '(SELECT Number_of_Tickets__c, Price_Per_Ticket__c, Ticket_Type__r.Name, '
                                 +  'Registration_Session__r.Status__c, Registration_Session__r.Expiration_Date_Time__c FROM ucinn_portal_Tickets_Participation__r '
                                 +  'WHERE Status__c NOT IN :TICKET_STATUS_EXCLUDE_LIST AND Is_Valid_Ticket__c = true) '
                                 + 'FROM ucinn_portal_Participation__c ';

        String whereClause = 'WHERE Id IN (SELECT Participation__c FROM ucinn_portal_Ticket__c WHERE Is_Valid_Ticket__c = true '
                                + ' AND Registration_Session__r.Status__c =  \'' + PORTAL_CONST_EVENTS.REGISTRATION_SESSION_STATUS_COMPLETED + '\') '
                                + ' AND (Id = \'' + primaryParticipationId + '\'  OR Primary_Participation__c = \'' + primaryParticipationId + '\')';


        queryString = queryString + whereClause + ' ORDER BY Primary_Participation__c NULLS FIRST, CreatedDate ASC'; // CHANGED

        resultList = Database.query(queryString);

        return resultList;
    }

    /**
     * Checks if the registrant has added any new registrants.
     *
     * @author Aaron Wong
     *
     * @param registrantList        Registrant list to check.
     * @return                      True if a registrant has been added.
     * @since                       1.0
     */
    private static Boolean hasAddedRegistrant(List<EventRegistrant> registrantList) {
        if (registrantList == null || registrantList.isEmpty()) {
            return false;
        }

        for (EventRegistrant eachRegistrant : registrantList) {
            if (String.isBlank(eachRegistrant.participationId)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Throws an Aurahandled exception with the given message.
     *
     * @author Aaron Wong
     *
     * @param message       Message for the error.
     * @since               1.0
     */
     private static void throwException(String message) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => message,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => new AuraHandledException(message).getStackTraceString()});
     }
}