global virtual without sharing class PORTAL_TRIG_ListingHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{

    public static final String LISTING_API_NAME = 'ucinn_portal_Listing__c';
    public static final String LISTING_AUTO_NUMBER_FIELD = 'Listing_Name_Auto_Number__c';
    public static final Map<String, String>  LISTING_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP = new Map<String, String>{
        'Street__c' => PORTAL_AddressWrapper.STREET_LINE_1,
        'City__c' => PORTAL_AddressWrapper.CITY_CONST,
        'State__c' => PORTAL_AddressWrapper.STATE_CONST, 
        'Country__c' => PORTAL_AddressWrapper.COUNTRY_CONST,
        'Postal_Code__c' => PORTAL_AddressWrapper.POSTAL_CODE
    };

    public class Portal_Trigger_Listing_Exception extends Exception {}

    /**
     * Method occurs on every trigger run.
     *
     * @since                                   1.0
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @param   oldList                         List of the old version of the records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the obect in the trigger
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        List<ucinn_portal_Listing__c> newListings = (List<ucinn_portal_Listing__c>) newList;
        List<ucinn_portal_Listing__c> oldListings = (List<ucinn_portal_Listing__c>) oldList;

        Map<Id, String> userIdToProfileName = new Map<Id, String>();


        if (newListings != null && newListings.size() > 0) {
            userIdToProfileName = getUsersProfiles(newListings);
        }

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Listing__c.getSObjectType());
            String communityUrl = getCommunityUrl();

            for (ucinn_portal_Listing__c listing : newListings) {
                // validateNewsletter(listing, newsletterId);
                setDateTimes(false, true, listing, null, null);
                listing.Alumni_Portal_Base_Url__c = communityUrl;
            }
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            geolocateListings(newListings);
            handleTicketTypeCreation(newListings);
            updateRecordNames(newListings);

        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Listing__c.getSObjectType());
            String communityUrl = getCommunityUrl();

            for (Integer listingIndex = 0; listingIndex < newListings.size(); listingIndex++) {

                ucinn_portal_Listing__c newListing = newListings.get(listingIndex);
                ucinn_portal_Listing__c oldListing = oldListings.get(listingIndex);

                Map<Id, ucinn_portal_Listing__c> updatedListings  = new Map<Id, ucinn_portal_Listing__c>();

                // validateNewsletter(newListing, newsletterId);

                if (String.isBlank(newListing.Alumni_Portal_Base_Url__c) || newListing.Alumni_Portal_Base_Url__c != communityUrl) {
                    newListing.Alumni_Portal_Base_Url__c = communityUrl;
                }

                Map<Id, String> idTimeZoneMap = new Map<Id, String>();

                setDateTimes(true, false, newListing, oldListing, idTimeZoneMap);
            }

        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            handleWaitlistActivation(oldListings, newListings);

            List<ucinn_portal_Listing__c> newListingAddresses = new List<ucinn_portal_Listing__c>();
            
            for (Integer listingIndex = 0; listingIndex < newListings.size(); listingIndex++) {
                ucinn_portal_Listing__c newListing = newListings.get(listingIndex);
                ucinn_portal_Listing__c oldListing = oldListings.get(listingIndex);
                if (getHasAddressChange(oldListing, newListing) == true) {
                    newListingAddresses.add(newListing);
                }
            }

            geolocateListings(newListingAddresses);

        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Listing__c.getSObjectType());
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     * Updates the names of listing records to the auto name number
     * if the name is blank or [Default Name] or the record's Id
     *
     * @author: Todd Shinto
     * @since: 1.18
     *
     * @param newListings    The Listing records from trigger new
     * 
     */
    public void updateRecordNames(List<ucinn_portal_Listing__c> newListings) {
        PORTAL_RecordNameUpdater controller = this.getRecordNameUpdater();
        controller.updateRecordNames(newListings, LISTING_AUTO_NUMBER_FIELD);
    }

    /**
     * Gets a PORTAL_RecordNameUpdater instance. Overridable
     *
     * @author: Todd Shinto
     * @since: 1.18
     *
     * @return An instance of PORTAL_RecordNameUpdater
     * 
     */
    public virtual PORTAL_RecordNameUpdater getRecordNameUpdater() {
        return new PORTAL_RecordNameUpdater();
    }

    /**
     * Method that compares two versions of one listing
     *  
     * @since 1.0
     * 
     * @param oldListing            ucinn_portal_Listing__c: the previous version of the listing
     * @param newListing            ucinn_portal_Listing__c: the updated version of the listing
     * 
     * @return true if the address fields of the 2 listings vary, else false
     */
    private static Boolean getHasAddressChange(ucinn_portal_Listing__c oldListing, ucinn_portal_Listing__c newListing) {
        for (String eachCurrentField : LISTING_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()) {
            if (newListing?.get(eachCurrentField) != oldListing?.get(eachCurrentField)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Use Listing address fields to create an Address Wrapper 
     * 
     * @since 1.0
     * 
     * @param event     ucinn_portal_Listing__c: Any listing object with street, city, state, country, and/or postal code fields
     * 
     * @return PORTAL_AddressWrapper representing the listing address
     */
    private static PORTAL_AddressWrapper getAddressWrapper(ucinn_portal_Listing__c event) {
        Map<Object, Object> paramMap = new Map<Object, Object>();
        for (String eachListingField : LISTING_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()) {
            String fieldValue = (String)event.get(eachListingField);
            if (String.isNotBlank(fieldValue)) {
                paramMap.put(LISTING_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.get(eachListingField), fieldValue);
            }
        }

        return paramMap.isEmpty() ? null : new PORTAL_AddressWrapper(paramMap);
    }

    /**
     * Given a list of Listings, use the address fields do a geolocation callout and populate the latitude and longitude
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param listingList           List<ucinn_portal_Listing__c> listings to geolocate if the address is populated
     */
    private static void geolocateListings(List<ucinn_portal_Listing__c> listingList) {
        if (listingList == null || listingList.isEmpty() || System.isBatch() == true || System.isFuture() == true) {
            return;
        }

        Map<String, String> listingIdToAddressWrapperMap = new Map<String, String>();
        for (ucinn_portal_Listing__c eachListing : listingList) {
            PORTAL_AddressWrapper address = getAddressWrapper(eachListing);
            if (address != null) {
                listingIdToAddressWrapperMap.put(eachListing.Id, JSON.serialize(address, true));
            }
        }

        geolocateAddresses(listingIdToAddressWrapperMap);
    }

    /**
     * Given a map of listing id to listing address, geolocate the address and get the latitude and longitude
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param listingIdToAddressWrapperMap     Map<String, String> listing id mapped to corresponding serialized address wrapper 
     */
    @future(callout = true)
    private static void geolocateAddresses(Map<String, String> listingIdToAddressWrapperMap) {
        if (listingIdToAddressWrapperMap == null || listingIdToAddressWrapperMap.isEmpty() == true) {
            return;
        }

        List<ucinn_portal_Listing__c> listingsToUpdate = new List<ucinn_portal_Listing__c>();

        for (String eachListingId : listingIdToAddressWrapperMap.keySet()) {
            PORTAL_AddressWrapper address = (PORTAL_AddressWrapper) JSON.deserialize(listingIdToAddressWrapperMap.get(eachListingId), PORTAL_AddressWrapper.class);
            Double latitude = address.getLatitude();
            Double longitude = address.getLongitude();
            if (latitude != null && longitude != null) {
                listingsToUpdate.add(new ucinn_portal_Listing__c(Id = eachListingId, Geolocation__latitude__s = latitude, Geolocation__longitude__s = longitude));  
            }
        }

        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(LISTING_API_NAME, false);
        update listingsToUpdate;
        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(LISTING_API_NAME, true);
    }

    /**
     * For listings whose Maximum_Number_of_Enrollment__c increased, activate as many waitlist entries as possible 
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param oldListings       List of the old Lisitngs from the trigger
     * @param newListings       List of the new up to date Listings from the triggers
     */
    private static void handleWaitlistActivation(List<ucinn_portal_Listing__c> oldListings, List<ucinn_portal_Listing__c> newListings) {
        if (newListings == null || oldListings == null || newListings.isEmpty() || oldListings.isEmpty()) {
            return;
        }

        Set<Id> listingIdChangeSet = getListingsWithAvailableTickets(oldListings, newListings);

        if (listingIdChangeSet.isEmpty()) {
            return;
        }

        PORTAL_EventWaitlistControllerBase controller = (PORTAL_EventWaitlistControllerBase)PORTAL_Utils.getControllerFactory().getEventWaitlistController();
        controller.activateWaitlists(listingIdChangeSet);
    }

    /**
     * Get the Listings whose number of available tickets has increased
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param oldListings       List of the old Lisitngs from the trigger
     * @param newListings       List of the new up to date Listings from the triggers
     * 
     * @return set of Listing IDs with more tickets available
     */
    @TestVisible
    private static Set<Id> getListingsWithAvailableTickets(List<ucinn_portal_Listing__c> oldListings, List<ucinn_portal_Listing__c> newListings) {
        Set<Id> listingIdChangeSet = new Set<Id>();
        if (oldListings == null || newListings == null || oldListings.isEmpty() || newListings.isEmpty()) {
            return listingIdChangeSet;
        }

        Map<Id, ucinn_portal_Listing__c> newListingIdMap = new Map<Id, ucinn_portal_Listing__c>(newListings);

        for (ucinn_portal_Listing__c eachOldListing : oldListings) {
            ucinn_portal_Listing__c eachNewListing = newListingIdMap.get(eachOldListing.Id);

            if (hasAvailableTickets(eachOldListing, eachNewListing) == true) {
                listingIdChangeSet.add(eachNewListing.Id);
            }
        }

        return listingIdChangeSet;
    }

    /**
     * See if the updated listing has more available tickets than the older version
     *      checks if Maximum_Number_of_Enrollment__c has increased from the old listing to the new listing (includes if the max was updated from some number to null)
     *      checks if Total_Tickets_Sold__c has decreased from old to new
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param oldListing       old listing
     * @param newListing       new listing
     * 
     * @return true if the new listing has more available tickets than the old listing
     */
    private static Boolean hasAvailableTickets(ucinn_portal_Listing__c oldListing, ucinn_portal_Listing__c newListing) {
        return (oldListing.Maximum_Number_of_Enrollment__c != null && newListing.Maximum_Number_of_Enrollment__c == null) || 
               (oldListing.Maximum_Number_of_Enrollment__c < newListing.Maximum_Number_of_Enrollment__c) ||
               (oldListing.Total_Tickets_Sold__c > newListing.Total_Tickets_Sold__c);
    }

    /**
     * Gets the domain of the public community.
     *
     * @author Aaron Wong
     *
     * @return      Community URL.
     * @since       1.0
     */
    public static String getCommunityUrl() {
        return PORTAL_CommunityUtils.getPortalURL();
    }

    /**
     * method that updates the start date time and end date time fields on a listing
     * with the correct time zone conversions
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param isUpdate:             Boolean that indicates if the trigger was called from an update
     * @param isInsert:             Boolean that indicates if the trigger was called from an insert
     * @param newListing:           The listing to set with the new fields
     * @param oldListing:           The old version of the listing that holds historical data
     * @param idTimeZoneMap:        The map of listing id to time zone that will be used to update the ticket types if the time zones changed
     */

    private static void setDateTimes(Boolean isUpdate, Boolean isInsert, ucinn_portal_Listing__c newListing, ucinn_portal_Listing__c oldListing, Map<Id, String> idTimeZoneMap) {
        if (isUpdate) {
            validateAndUpdateDateTimeFields(newListing, oldListing, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', newListing.Time_Zone__c, oldListing.Time_Zone__c);
            validateAndUpdateDateTimeFields(newListing, oldListing, 'End_Date_Time__c', 'Actual_End_Date_Time__c', newListing.Time_Zone__c, oldListing.Time_Zone__c);

            validateAndUpdateDateTimeFields(newListing, oldListing, 'Event_Start_Date_Time__c', 'Event_Actual_Start_Date_Time__c', newListing.Time_Zone__c, oldListing.Time_Zone__c);
            validateAndUpdateDateTimeFields(newListing, oldListing, 'Event_End_Date_Time__c', 'Event_Actual_End_Date_Time__c', newListing.Time_Zone__c, oldListing.Time_Zone__c);

            //need to keep track of listing id to time zone to update the ticket types for these listings
            if (!String.isBlank(newListing.Time_Zone__c) && newListing.Time_Zone__c != oldListing.Time_Zone__c) {
                idTimeZoneMap.put(newListing.Id, newListing.Time_Zone__c);
            }

        } else if (isInsert) {
            validateAndUpdateDateTimeFields(newListing, null, 'Start_Date_Time__c', 'Actual_Start_Date_Time__c', newListing.Time_Zone__c, null);
            validateAndUpdateDateTimeFields(newListing, null, 'End_Date_Time__c', 'Actual_End_Date_Time__c', newListing.Time_Zone__c, null);

            validateAndUpdateDateTimeFields(newListing, null, 'Event_Start_Date_Time__c', 'Event_Actual_Start_Date_Time__c', newListing.Time_Zone__c, null);
            validateAndUpdateDateTimeFields(newListing, null, 'Event_End_Date_Time__c', 'Event_Actual_End_Date_Time__c', newListing.Time_Zone__c, null);
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

    public static Map<Id, String> getUsersProfiles(List<ucinn_portal_Listing__c> newListings) {
        Map<Id, String> userIdToProfileName = new Map<Id, String>();

        Set<Id> userIds = new Set<Id>();
        for (ucinn_portal_Listing__c currentListing : newListings) {
            userIds.add(currentListing.OwnerId);
        }

        List<User> ownerOfListing = [SELECT Id, Name, profile.name FROM User WHERE Id IN :userIds];

        for (User currentUser: ownerOfListing) {
            if (currentUser.profile != null) {
                userIdToProfileName.put(currentUser.Id, currentUser.profile.name);
            }
        }

        return userIdToProfileName;
    }

    public static void handleTicketTypeCreation(List<ucinn_portal_Listing__c> listingList) {
        if (listingList == null || listingList.isEmpty()) {
            return;
        }

        Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();

        List<ucinn_portal_Ticket_Type__c> ticketTypeListToInsert = new List<ucinn_portal_Ticket_Type__c>();

        for (ucinn_portal_Listing__c eachListing : listingList) {
            if (eachListing.RecordTypeId == recordTypeId) {
                ticketTypeListToInsert.add(new ucinn_portal_Ticket_Type__c(Name = 'General Admission',
                                                                           Listing__c = eachListing.Id,
                                                                           Price__c = 0));
            }
        }

        insert ticketTypeListToInsert;
    }
}