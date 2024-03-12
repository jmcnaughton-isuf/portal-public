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
 * Base class containing logic for the directory search
 *
 * @author Aaron Wong
 * @version     1.0
 * @since       1.0
 */
global without sharing virtual class PORTAL_DirectoryControllerBase {
    global static final Integer DEFAULT_MAX_NUMBER_OF_CONTACTS_TO_DISPLAY = 150;

    global static final String ERROR_TOO_MANY_TEXT_SEARCHES = 'You cannot have more than 2 free text/location searches at the same time';

    global static final String SEARCH_TEXT = 'searchText';
    global static final String CONTACT_IDS = 'contactIds';
    global static final String HIRING_MANAGER = 'hiringManager';
    global static final String JOB_SEEKER = 'jobSeeker';
    global static final String RESULT_IDS = 'resultIds';
    global static final String OBJECT_API_NAME = 'objectApiName';
    global static final String FIELD_API_NAME = 'fieldApiName';
    global static final String FILTER_CLAUSE = 'filterClause';
    global static final String IS_PICKLIST = 'isPicklist';
    global static final String IS_NOT_RECEIVING_MESSAGES = 'isNotReceivingMessages';
    global static final String IS_NOT_SENDING_MESSAGES = 'isNotSendingMessages';
    global static final String IS_SAME_CONTACT = 'isSameContact';

    global static final String SEARCH_CRITERIA_LIST = 'searchCriteriaList';
    global static final String SEARCH_CATEGORY_LIST = 'searchCategoryList';
    global static final String ZONE_CONST = 'zone';

    global static final String CONTACT_ID_SET = 'contactIdSet';

    global static final String DISPLAY_SETTING_LIST = 'displaySettingList';
    global static final String MAX_ITEMS = 'maxItems';

    global static final String CONTACT_ID = 'contactId';

    global static final String RECEIVER_CONTACT_ID = 'receiverContactId';
    global static final String SUBJECT_CONST = 'subject';
    global static final String BODY_CONST = 'body';
    global static final String NAME_SEARCH = 'Name Search';
    global static final String DIRECTORY_CONST = 'Directory';
    global static final String DIRECTORY_TABLE = 'Directory Table';
    global static final String DIRECTORY_PAGE = 'Directory Page';
    global static final String RECORDS_CONST = 'Records';
    global static final String TRUE_CONST = 'true';
    global static final String PICKLISTS_CONST = 'picklists';
    global static final String FRONT_END_DATA = 'frontEndData';
    global static final String DEVELOPER_NAME = 'developerName';
    global static final String MERGE_FIELD_TO_REPLACEMENT_VALUE = 'mergeFieldToReplacementValue';
    global static final String ORIGINAL_TEXT = 'originalText';

    public static final String SEARCH_FOR_SELECTED = 'searchForSelected';
    public static final String ADDRESS_LIST = 'addressList';
    public static final String VALUE_LIST = 'valueList';
    public static final String CITY_CONST = 'city';
    public static final String STATE_CONST = 'state';
    public static final String COUNTRY_CONST = 'country';
    public static final String POSTAL_CODE = 'postalCode';
    public static final String DISTANCE_CONST = 'distance';

    public static final String SEND_MESSAGE_BUTTON_STATE = 'sendMessageButtonState';
    public static final String CURRENT_USER_NOT_RECEIVING = 'currentUserNotReceiving';
    public static final String NOT_RECEIVING = 'notReceiving';
    public static final String NO_SELF_MESSAGING = 'noSelfMessaging';
    public static final String RECEIVING_CONST = 'receiving';

    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String CONTACT_NAMES = 'contactNames';
    public static final String EMPLOYMENTS_CONST = 'employments';
    public static final String EMPLOYER_CONST = 'employer';
    public static final String JOB_TITLE = 'jobTitle';
    public static final String DEGREE_INFO = 'degreeInfo';
    public static final String DEGREE_CONST = 'degree';
    public static final String DEGREE_YEAR = 'degreeYear';

    protected virtual PORTAL_PageSectionAdapter.Builder getPageSectionAdapterBuilder() {
        return new PORTAL_PageSectionAdapter.Builder();
    }

    /**
     * This class represents the formatted contact information that is sent back to the LWC
     * from the apex controller.
     */
    global class ContactDisplayWrapper {
        @AuraEnabled
        public String contactId {get; set;}         // Id of the contact
        @AuraEnabled
        public String firstName {get; set;}         // First name of the contact
        @AuraEnabled
        public String lastName {get; set;}          // Last name of the contact
        @AuraEnabled
        public String degree {get; set;}            // Degree of the contact
        @AuraEnabled
        public String degreeYear {get; set;}        // Degree year of the contact
        @AuraEnabled
        public String jobTitle {get; set;}          // Job title for the contact
        @AuraEnabled
        public String companyName {get; set;}       // Name of the company the contact works at

        /**
         * Constructs a ContactDisplayWrapper from a contact records in Map format
         *
         * @author Aaron Wong
         *
         * @param contactRecord     The contact record in Map format
         * @return                  A ContactDisplayWrapper
         * @since                   1.0
         */
        public ContactDisplayWrapper(Map<String, Object> contactMap) {
            populateContactDisplayWrapper(contactMap);
        }

        /**
         * Overridable function that populates the Contact Display Wrapper.
         *
         * @param  contactRecord    The contact associated with this Contact Display Wrapper.
         * @since                   1.0
         */
        public void populateContactDisplayWrapper(Map<String, Object> contactMap) {
            if (contactMap == null) {
                return;
            }

            this.contactId = (String)contactMap.get('id');
            this.firstName = (String)contactMap.get(FIRST_NAME);
            this.lastName = (String)contactMap.get(LAST_NAME);

            if (contactMap.get(DEGREE_INFO) != null
                    && !((List<Map<String, Object>>)contactMap.get(DEGREE_INFO)).isEmpty()) {
                List<Map<String, Object>> degreeInfoList = (List<Map<String, Object>>)contactMap.get(DEGREE_INFO);

                this.degree = (String)degreeInfoList.get(0).get(DEGREE_CONST);
                this.degreeYear = (String)degreeInfoList.get(0).get(DEGREE_YEAR);
            }

            if (contactMap.get(EMPLOYMENTS_CONST) != null
                    && !((List<Map<String, Object>>)contactMap.get(EMPLOYMENTS_CONST)).isEmpty()) {
                List<Map<String, Object>> employmentList = (List<Map<String, Object>>)contactMap.get(EMPLOYMENTS_CONST);

                this.companyName = (String)employmentList.get(0).get(EMPLOYER_CONST);
                this.jobTitle = (String)employmentList.get(0).get(JOB_TITLE);
            }

            if (contactMap.get(CONTACT_NAMES) != null
                    && !((List<Map<String, Object>>)contactMap.get(CONTACT_NAMES)).isEmpty()) {
                List<Map<String, Object>> contactNameList = (List<Map<String, Object>>)contactMap.get(CONTACT_NAMES);

                this.firstName = (String)contactNameList.get(0).get(FIRST_NAME);
                this.lastName = (String)contactNameList.get(0).get(LAST_NAME);
            }
        }
    }


    /**
     * Formats the contact list provided to a list of ContactDisplayWrappers that can be displayed on
     * the Directory.
     *
     * @author Aaron Wong
     * @param contactList   List of contact records to format.
     * @return              List of formatted ContactDisplayWrappers
     * @since               1.0
     */
    protected virtual List<ContactDisplayWrapper> formatContactListForDisplay(List<Map<String, Object>> contactList) {
        List<ContactDisplayWrapper> resultList = new List<ContactDisplayWrapper>();

        for (Map<String, Object> eachContact : contactList) {
            if (eachContact == null) {
                continue;
            }

            resultList.add(new ContactDisplayWrapper(eachContact));
        }

        return resultList;
    }

    /**
     * Overridable function used for the directory search. Queries for the constituents fitting the given
     * Search Criteria.
     *
     * @author Aaron Wong
     *
     * @param searchText            String used to do a name search on.
     * @param searchCriteriaList    List of search criterion the filter the Directory results by.
     * @param searchGroupList       List of Search Groups used to filter the Directory results.
     * @param zone                  The zone of the Directory, controlling what Search Criteria to use
     * @return                      A list of ContactDisplayWrapper that is used to display results to the Directory.
     * @since                       1.0
     */
    global virtual List<ContactDisplayWrapper> getContacts(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        String searchText = (String)params?.get(SEARCH_TEXT);
        List<PORTAL_SearchCriteria> searchCriteriaList = convertObjectsToSearchCriteria((List<Object>)params?.get(SEARCH_CRITERIA_LIST));
        List<PORTAL_SearchCategory> searchCategoryList = convertObjectsToSearchCategories((List<Object>)params?.get(SEARCH_CATEGORY_LIST));
        String zone = (String)params?.get(ZONE_CONST);
        Integer maxContactsToReturn = getNumberOfContactsFromOrgSetting();

        if (String.isNotBlank(searchText)) {
            searchCriteriaList.add(new PORTAL_SearchCriteria(NAME_SEARCH, String.escapeSingleQuotes(searchText).split(' ')));
        }

        searchCategoryList = parseSearchCategoryList(searchCategoryList);
        PORTAL_DirectorySearch directorySearch = new PORTAL_DirectorySearch.Builder().buildCachedCriteriaList(searchCriteriaList)
                                                                                     .buildCategoryList(searchCategoryList)
                                                                                     .buildMaxContacts(maxContactsToReturn)
                                                                                     .buildZoneName(zone)
                                                                                     .build();

        Set<String> contactIdSet = directorySearch.performSearch();

        resultList = this.queryContactListFromIdSet(new Map<String, Object>{CONTACT_ID_SET => contactIdSet});

        return this.formatContactListForDisplay(resultList);
    }

    /**
     * Queries for contact information using the Ids from the directory search.
     *
     * @author Aaron Wong
     * @param contactIdSet     Set of contact Ids returned from the directory search.
     * @return                  List of contacts with information that can be displayed on
     *                          the directory.
     * @since                   1.0
     */
    global virtual List<Map<String, Object>> queryContactListFromIdSet(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        Set<String> contactIdSet = (Set<String>)params?.get(CONTACT_ID_SET);

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return resultList;
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass queryClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        queryClass.dynamicWhereClause = ' WHERE Id IN (\'' + String.join(new List<String>(contactIdSet), '\', \'')  + '\') ';

        return getPageSectionAdapterBuilder().buildPageName('Directory Search')
                                             .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{
                                                  'Directory Search' => queryClass
                                              })
                                             .build()
                                             .getRecords().get('Directory Search').get('records');
    }

    /**
     * Get the Search Criteria that should be displayed on the Directory
     *
     * @author Aaron Wong
     *
     * @param zone  The zone of the Directory to get Search Criteria for.
     * @return      List of Portal Directory Search Criteria Custom Metadata to display.
     * @since       1.0
     */
    global virtual List<Portal_Directory_Search_Criteria__mdt> getSearchDisplaySettings(Map<String, Object> params){
        String zone = (String)params?.get(ZONE_CONST);

        String querystring = ' SELECT id, MasterLabel, DeveloperName, Default_Value__c, Display_Order__c, Directory_Location__c, Field_Logic__c, Search_Criteria_Name__c, Search_Input_Type__c, Geolocation_Address_Input__c, '
                           + ' Portal_Directory_Search_Category__r.Category_Name__C, Portal_Directory_Search_Category__r.Object_API_Name__c, Portal_Directory_Search_Category__r.Has_Single_Search_Criteria__c, '
                           + ' Portal_Directory_Search_Category__r.Type__c, '
                           + ' (SELECT DeveloperName, Field_Api_Name__c, Filter_Clause__c, Object_Api_Name__c, Type__c, Static_Values__c FROM Portal_Directory_Search_Display_Settings__r) '
                           + ' FROM Portal_Directory_Search_Criteria__mdt '
                           + ' WHERE Is_Display_On_Portal__c = true '
                           + ' AND Portal_Directory_Search_Category__r.Is_Display_On_Portal__c = true '
                           + ' ORDER BY Display_Order__c, MasterLabel ';

        List<Portal_Directory_Search_Criteria__mdt> searchCriteriaList = (List<Portal_Directory_Search_Criteria__mdt>)PORTAL_Utils.getCustomMetadataRecordList(
            new Map<String, Object> {PORTAL_Utils.QUERY_STRING => queryString}
        );

        if (String.isNotBlank(zone)) {
            searchCriteriaList = PORTAL_UTIL_Directory.filterSearchCriteriaByZone(searchCriteriaList, zone);
        }

        List<Portal_Directory_Search_Criteria__mdt> resultList = new List<Portal_Directory_Search_Criteria__mdt>();

        for (Portal_Directory_Search_Criteria__mdt eachCriteria : searchCriteriaList) {
            if (eachCriteria.Portal_Directory_Search_Category__r.Type__c != PORTAL_CONST_Directory.SEARCH_CATEGORY_DEFAULT_SCOPE) {
                resultList.add(eachCriteria);
            }
        }

        return resultList;
    }

    /**
     * Gets all the display options for the given display settings.
     *
     * @author Aaron Wong
     * @param displaySettingList    List of display settings to pull options from.
     * @param searchText            Text used to filter the display options displayed.
     * @param maxItems              Total number of items to pull.
     * @return                      List of display options.
     * @since                       1.0
     */
    global virtual List<Object> getAllDisplayOptions(Map<String, Object> params) {
        List<Object> displaySettingList = (List<Object>)params?.get(DISPLAY_SETTING_LIST);
        String searchText = (String)params?.get(SEARCH_TEXT);
        Integer maxItems = (Integer)params?.get(MAX_ITEMS);

        List<Object> picklistValues = new List<Object>();

        if (displaySettingList == null || displaySettingList.isEmpty()) {
            return picklistValues;
        }

        params.put(PORTAL_LookupControllerBase.CUSTOM_METADATA_API_NAME, PORTAL_CONST_Directory.SEARCH_DISPLAY_SETTING_CUSTOM_METADATA_TYPE);

        return ((PORTAL_LookupControllerBase)PORTAL_Utils.getControllerFactory().getLookupController()).getAllLookupOptions(params);
        
    }

    /**
     * Get constituent data to show in the alumni portal.
     *
     * @author Aaron Wong
     * @param contactId        The constituent data to show.
     * @return                 Constituent data.
     * @since                 1.0
     */
    global virtual Map<String, Object> getContactInfo(Map<String, Object> params) {
        String contactId = (String)params?.get(CONTACT_ID);

        Map<String, Object> resultMap = new Map<String, Object>();

        if (String.isBlank(contactId)) {
            return resultMap;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(DIRECTORY_PAGE)
                                                                                          .buildParentFieldId(contactId)
                                                                                          .build();

        resultMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, pageSectionAdapter.getRecords(false, false));
        resultMap.put(PICKLISTS_CONST, pageSectionAdapter.getPicklistMap());

        //map that allows for generic getting and setting of lwc fields based on a unique id
        resultMap.put(FRONT_END_DATA, pageSectionAdapter.getFrontEndDataMap());
        resultMap.put(SEND_MESSAGE_BUTTON_STATE, this.getSendMessageButtonState(contactId));

        return resultMap;
    }

    /**
     * Send a message to the contact.
     *
     * @author Aaron Wong
     *
     * @param recieverContactId     ID of the contact recieveing the message.
     * @param subject               The subject of the message.
     * @param body                  The body of the message.
     * @since                       1.0
     */
    global virtual void sendMessageToContact(Map<String, Object> params) {
        String receiverContactId = (String)params?.get(RECEIVER_CONTACT_ID);
        String subject = (String)params?.get(SUBJECT_CONST);
        String body = (String)params?.get(BODY_CONST);

        if (String.isBlank(receiverContactId) || String.isBlank(subject) || String.isBlank(body)) {
            return;
        }

        User currentUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];

        if (String.isBlank(currentUser.ContactId)) {
            return;
        }

        List<User> userList = [SELECT id FROM User WHERE ContactId = :receiverContactId];

        if (!userList.isEmpty()) {
            PORTAL_UTIL_Directory.sendDirectMessage(receiverContactId, subject, body);
            return;
        }

        this.sendEmailMessageToConstituent(currentUser, receiverContactId, subject, body);
    }

    protected virtual String getSendMessageButtonState(String receivingContactId) {
        User currentUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];

        if (String.isBlank(currentUser.ContactId)) {
            return CURRENT_USER_NOT_RECEIVING;
        }

        if (currentUser.ContactId == receivingContactId) {
            return NO_SELF_MESSAGING;
        }

        List<ucinn_portal_Directory_Setting__c> directorySettingList = [SELECT Contact__c, Is_Receiving_Messages__c
                                                                        FROM ucinn_portal_Directory_Setting__c
                                                                        WHERE Contact__c IN (:receivingContactId, :currentUser.ContactId)];

        Boolean isCurrentUserReceivingMessages = true;
        Boolean isReceivingUserReceivingMessages = true;

        for (ucinn_portal_Directory_Setting__c eachSetting : directorySettingList) {
            if (eachSetting.Contact__c == receivingContactId) {
                isReceivingUserReceivingMessages = eachSetting.Is_Receiving_Messages__c;
            } else {
                isCurrentUserReceivingMessages = eachSetting.Is_Receiving_Messages__c;
            }
        }

        if (isCurrentUserReceivingMessages != true) {
            return CURRENT_USER_NOT_RECEIVING;
        }

        if (isReceivingUserReceivingMessages != true) {
            return NOT_RECEIVING;
        }

        return RECEIVING_CONST;
    }

    /**
     * Sends an email message to the constituent.
     *
     * @author Aaron Wong
     *
     * @param currentUser           The current user.
     * @param receiverContactId     The receiving contact.
     * @since                       1.0
     */
    protected virtual void sendEmailMessageToConstituent(User currentUser,
                                                         String receiverContactId,
                                                         String subject,
                                                         String body){
        Set<String> contactIdSet = new Set<String>{currentUser.ContactId, receiverContactId};

        List<Contact> contactList = [SELECT id, FirstName, LastName, Email
                                     FROM Contact
                                     WHERE id = :contactIdSet];

        Contact recievingContact;
        Contact sendingContact;

        // Get sending and receiving Constituents' emails
        for (Contact eachContact : contactList) {
            if (eachContact.Id == receiverContactId) {
                recievingContact = eachContact;
            } else {
                sendingContact = eachContact;
            }
        }

        // Get email template to use
        EmailTemplate messagingEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{DEVELOPER_NAME => PORTAL_CONST_Directory.NON_USER_MESSAGE_EMAIL_TEMPLATE});

        Map<String, String> mergeFieldToReplacementValueMap = new Map<String, String>();

        mergeFieldToReplacementValueMap.put(PORTAL_CONST_Directory.RECEIVING_USER_FIRST_NAME, recievingContact.firstName);
        mergeFieldToReplacementValueMap.put(PORTAL_CONST_Directory.RECEIVING_USER_LAST_NAME, recievingContact.lastName);
        mergeFieldToReplacementValueMap.put(PORTAL_CONST_Directory.SENDING_USER_FIRST_NAME, sendingContact.firstName);
        mergeFieldToReplacementValueMap.put(PORTAL_CONST_Directory.SENDING_USER_LAST_NAME, sendingContact.lastName);
        mergeFieldToReplacementValueMap.put(PORTAL_CONST_Directory.MESSAGE_MERGE_FIELD_BODY, body);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        String emailBody = PORTAL_CommunityUtils.replaceMergeFields(new Map<String, Object>{MERGE_FIELD_TO_REPLACEMENT_VALUE => mergeFieldToReplacementValueMap,
                                                                                            ORIGINAL_TEXT => messagingEmailTemplate.HtmlValue});

        email.toaddresses = new List<String>{recievingContact.Email};
        email.saveAsActivity = false;
        email.setBccSender(false);
        email.setUseSignature(false);
        email.setReplyTo(sendingContact.Email);
        email.setSubject(subject);
        email.setHtmlBody(emailBody);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email}, false);
    }

    /**
     * Gets the number of contacts to return for the directory search.
     *
     * @author Aaron Wong
     * @return Number of contacts to pull
     * @since  1.0
     */
    protected virtual Integer getNumberOfContactsFromOrgSetting() {
        String numberOfContactsOrgSettingValue = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => PORTAL_CONST_Directory.NUMBER_OF_CONTACTS_TO_PULL_METADATA_NAME});

        if (String.isBlank(numberOfContactsOrgSettingValue)) {
            return DEFAULT_MAX_NUMBER_OF_CONTACTS_TO_DISPLAY;
        }

        return Integer.valueOf(numberOfContactsOrgSettingValue);
    }

    /**
     * Parses the search category list.
     *
     * @author Aaron Wong
     * @param searchCategoryList    The search group list to parse.
     * @return                      The parsed Search Group List.
     * @since                       1.0
     */
    protected virtual List<PORTAL_SearchCategory> parseSearchCategoryList(List<PORTAL_SearchCategory> searchCategoryList) {
        List<PORTAL_SearchCategory> resultList = new List<PORTAL_SearchCategory>();
        if (searchCategoryList == null || searchCategoryList.isEmpty()) {
            return resultList;
        }

        resultList = this.removeEmptySearchCategories(searchCategoryList);

        return resultList;
    }

    /**
     * Removes empty search categories from the list provided.
     *
     * @author Aaron Wong
     *
     * @param searchCategoryList    List of search categories.
     * @return                      List of search categories with empty ones removed.
     * @since                       1.0
     */
    protected virtual List<PORTAL_SearchCategory> removeEmptySearchCategories(List<PORTAL_SearchCategory> searchCategoryList) {
        List<PORTAL_SearchCategory> resultList = new List<PORTAL_SearchCategory>();

        for (PORTAL_SearchCategory eachSearchCategory : searchCategoryList) {
             if (eachSearchCategory.searchCriteriaList == null || eachSearchCategory.searchCriteriaList.isEmpty()) {
                 continue;
             }

            List<PORTAL_SearchCriteria> searchCriteriaList = new List<PORTAL_SearchCriteria>();

            for (PORTAL_SearchCriteria eachSearchCriteria : eachSearchCategory.searchCriteriaList) {
                 if (eachSearchCriteria.valueList == null || eachSearchCriteria.valueList.isEmpty() || String.isBlank(eachSearchCriteria.searchForSelected)) {
                     continue;
                 }

                 searchCriteriaList.add(eachSearchCriteria);
             }

            if (searchCriteriaList.isEmpty()) {
                continue;
            }

            eachSearchCategory.searchCriteriaList = searchCriteriaList;
            resultList.add(eachSearchCategory);
         }

         return resultList;
     }

    /**
     * Converts a list of objects to a list of SearchCriteria.
     *
     * @author Aaron Wong
     *
     * @param objectList       A list of objects to convert
     * @return                 A list of SearchCriteria.
     * @since                  1.0
     */
    private static List<PORTAL_SearchCriteria> convertObjectsToSearchCriteria(List<Object> objectList) {
        List<PORTAL_SearchCriteria> resultList = new List<PORTAL_SearchCriteria>();

        if (objectList == null || objectList.isEmpty()) {
            return resultList;
        }

        for (Object eachObject : objectList) {
            resultList.add(new PORTAL_SearchCriteria(eachObject));
        }

        return resultList;
    }

    /**
     * Converts a list of objects to a list of SearchCategory.
     *
     * @author Aaron Wong
     *
     * @param objectList       A list of objects to convert
     * @return                 A list of SearchCategory.
     * @since                  1.0
     */
    private static List<PORTAL_SearchCategory> convertObjectsToSearchCategories(List<Object> objectList) {
        List<PORTAL_SearchCategory> resultList = new List<PORTAL_SearchCategory>();

        if (objectList == null || objectList.isEmpty()) {
            return resultList;
        }

        for (Object eachObject : objectList) {
            resultList.add(new PORTAL_SearchCategory(eachObject));
        }

        return resultList;
    }
}