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

/**
* Base controller that houses newsletter methods
*
* @author:  Ashley Tran and Sam Longo
* @version: 1.0
* @since:   1.0
*/


public virtual inherited sharing class PORTAL_NewsletterControllerBase {

    public class NewsletterControllerException extends Exception {}

    public static final String NEWSLETTER_SUBMISSION_PAGE_NAME = 'Newsletter Submission';
    public static final String SUBMITTED_NEWSLETTER_PAGE_NAME = 'My Newsletters';
    public static final String ZONE_TEMPLATE_PAGE_NAME = 'Zone Template';
    public static final String SUBMITTED_NEWSLETTER_MAIN_SECTION = 'Submitted_Newsletters';
    public static final String LISTING_MERGE_FIELDS_MAIN_SECTION = 'Listing_Merge_Fields';
    public static final String ZONE_MERGE_FIELDS_MAIN_SECTION = 'Zone_Merge_Fields';
    public static final String SECTION_MERGE_FIELDS_MAIN_SECTION = 'Newsletter_Section_Merge_Fields';
    public static final String NEWSLETTER_SECTION_TEMPLATE_RECORD_TYPE = 'Newsletter_Section_Template';
    public static final String NEWSLETTER_TEMPLATE_RECORDTYPE = 'Newsletter_Template';
    public static final String NEWSLETTER_QUEUE_METADATA_LABEL = 'Newsletter_Case_Queue';
    public static final String CREATE_CASE_FOR_NEWSLETTER_METADATA_LABEL = 'Create_Case_For_Newsletter';
    public static final String NEWSLETTER_RECORD_TYPE = 'Newsletter';
    public static final String SOCIAL_MEDIA_LOGO_FOLDER = 'Social Media Logos';
    public static final String LISTING_SOBJECT_NAME = 'ucinn_portal_Listing__c';
    public static final String SUBMIT_NEWSLETTER_PERMISSION = 'Submit Newsletter';
    public static final String NEWSLETTER_PERMISSION_ERROR = 'You do not have the permissions to submit a newsletter to this club or group.';
    public static final String NO_NEWSLETTER_ERROR = 'There was a problem finding the newsletter.';

    public static final String NEWSLETTER_TEMPLATE_NAME = 'Newsletter HTML Template';

    public static final String LISTING_KEY = 'listing';
    public static final String NEWSLETTER_SECTIONS_LIST_KEY = 'newsletterSectionsList';
    public static final String NEWSLETTER_ID_KEY = 'newsletterId';
    public static final String EMAIL_KEY = 'email';
    public static final String DELIVERY_TIME_KEY = 'deliveryTime';
    public static final String FRONT_END_DATA_KEY = 'frontEndDataMap';
    public static final String OFFSET_KEY = 'offset';
    public static final String HAS_MORE_RECORDS = 'hasMoreRecords';
    public static final String RECORDS_MAP_KEY = 'recordsMap';
    public static final String RECORD_TYPE_KEY = 'recordType';
    public static final String SOBJECT_TYPE_KEY = 'sobjectType';
    public static final String ZONES_KEY = 'zones';
    public static final String SUBJECT_KEY = 'subject';
    public static final String IS_FRONT_END_CALL_KEY = 'isFrontEndCall';
    public static final String NEWSLETTER_SECTION_KEY = 'newsletterSection';
    public static final String PORTAL_ZONE_KEY = 'portalZone';
    public static final String CONTACT_ID_KEY = 'id';
    public static final String CLONE_KEY = 'clone';
    public static final String SEARCH_TEXT_KEY = 'searchText';
    public static final String MAX_ITEMS_KEY = 'maxItems';
    public static final String LOWERCASE_FROM = 'from';
    public static final String LOWERCASE_LIMIT = 'limit';
    public static final Integer MINIMUM_SOSL_SEARCH_LENGTH = 2;

    public static final String PENDING_STATUS = 'Pending';
    public static final String SCHEDULED_STATUS = 'Scheduled';
    public static final String TEMPORARY_STATUS = 'Temporary';
    public static final String PUBLISHED_STATUS = 'Published';
    public static final String RESUBMITTED_STATUS = 'Resubmitted';
    public static final String ACTIVE_STATUS = 'Active';
    public static final String INACTIVE_STATUS = 'Inactive';
    public static final String NEWSLETTER_CASE_TYPE = 'Newsletter';
    public static final String CAMPAIGN_ID = 'campaignId';

    public static final String DEFAULT_ZONE_NAME = 'All';
    public static final String ORGANIZATION_METADATA_DEVELOPER_NAME = 'Organization_Name';

    public static final String CONTACT_KEY = 'contact';
    public static final String html_KEY = 'htmlstring';
    public static final String ZONE_NAME_KEY = 'zoneName';
    public static final String DEFAULT_ZONE_KEY = 'defaultZone';
    public static final String SELECTED_ZONE_KEY = 'selectedZone';

    public static final String MERGE_FIELD_API_KEY = 'field';
    public static final String MERGE_FIELD_VALUE_KEY = 'value';
    public static final String MERGE_FIELD_LABEL_KEY = 'label';



    /**
     * Get startup information for NewsletterSubmission component
     *
     * @return                                              Map of return values for front end
     * @since                                               1.0
     */
    public virtual Map<String, Object> getSubmissionSetupInfo(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();
        resultMap.put('mergeFields', getMergeFields(params));
        resultMap.put('filterList', getRecipientFilters(params));
        resultMap.put('portalZones', getAvailableZones(params));
        resultMap.put('templates', getTemplates(new Map<String, Object>{ZONES_KEY => resultMap.get('portalZones')}));
        resultMap.put('timezones', getTimeZones(params));
        resultMap.put('organizationName', getOrganizationName());
        resultMap.put('contact', getContactWithMergeFields((List<Map<String, String>>)resultMap.get('mergeFields')));
        resultMap.put('portalUrl', PORTAL_CommunityUtils.getPortalURL());
        return resultMap;
    }

      /**
     * Get the contact and merge field data needed to personalize the newsletter preview
     *
     *
     * @param mergeFieldList:                              the list of merge fields for the current email api
     *
     *
     * @return                                              contact record for current user
     * @since                                               1.0
     */
    public Contact getContactWithMergeFields(List<Map<String, String>> mergeFieldList) {
        if (mergeFieldList == null || mergeFieldList.isEmpty()) {
            return null;
        }
        
        User usr = [SELECT Id,
                       ContactId
                    FROM User
                    WHERE Id = :UserInfo.getUserId()];

        Id contactId = usr.ContactId;

        if (String.isBlank(contactId)) {
            return null;
        }

        Set<String> contactApiFields = new Set<String>{CONTACT_ID_KEY};
        for (Map<String, String> eachField : mergeFieldList) {
            contactApiFields.add(eachField.get(MERGE_FIELD_API_KEY));
        }

        String queryFields = String.join(new List<String>(contactApiFields), ', ');

        //all merge fields are specific for the contact object
        String soqlQuery = 'SELECT ' + queryFields + ' FROM Contact WHERE Id = \'' + contactId +'\'';

        List<Contact> contactList = Database.query(soqlQuery);
        if (contactList.isEmpty()) {
            return null;
        }
        return contactList.get(0);
    }

    /**
     * Method that returns the list of available newsletter templates
     *
     * @param zones:                            the list of zones that a user can submit newsletters to
     *
     * @return                                  All newsletter templates
     * @since                                   1.0
     */
    public virtual Map<String, Map<String, Object>> getTemplates(Map<String, Object> params){
        String socialMediaHtmlField = 'socialMediaHtmlString';

        Map<String, Map<String, Object>> returnMap = new  Map<String, Map<String, Object>> ();
        List<Map<String, Object>> zoneList = (List<Map<String, Object>>) params.get(ZONES_KEY);

        if (zoneList == null || zoneList.isEmpty()) {
            return returnMap;
        }

        Set<String> zoneNames = new Set<String>{};
        for (Map<String, Object> zone : zoneList) {
            zoneNames.add((String)zone.get('label'));
        }

        List<ucinn_portal_Zone__c> newsletterZones = [SELECT Name, Header_Image_Alt_Text__c, Newsletter_Html_Format__c, Pre_Header__c,
                                                        Footer_Content__c, Social_Media_Order__c, Instagram_Link__c,
                                                        Twitter_Link__c, Facebook_Link__c, LinkedIn_Link__c, WeChat_Link__c,
                                                        Logo_Image_Alt_Text__c, Logo_Image__c, Header_Image__c, Social_Media_Content__c,
                                                        Section_Content_Html__c
                                                        FROM ucinn_portal_Zone__c
                                                        WHERE Name IN :zoneNames AND Is_Display_on_Portal__c = true];
        List<ucinn_portal_Zone__c> defaultZoneList =  [SELECT Name, Header_Image_Alt_Text__c, Newsletter_Html_Format__c, Pre_Header__c,
                                                        Footer_Content__c, Social_Media_Order__c, Instagram_Link__c,
                                                        Twitter_Link__c, Facebook_Link__c, LinkedIn_Link__c, WeChat_Link__c,
                                                        Logo_Image_Alt_Text__c, Logo_Image__c, Header_Image__c, Social_Media_Content__c,
                                                        Section_Content_Html__c
                                                        FROM ucinn_portal_Zone__c
                                                        WHERE Name = :DEFAULT_ZONE_NAME AND Is_Display_on_Portal__c = true];

        if (defaultZoneList.isEmpty()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There needs to be a default club/group.'});
        }

        for (ucinn_portal_Zone__c eachZone : newsletterZones) {
            Map<String, Object> eachZoneMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(eachZone));
            Map<String, Object> zoneParams = new Map<String, Object>();
            zoneParams.put(SELECTED_ZONE_KEY, eachZone);
            zoneParams.put(DEFAULT_ZONE_KEY, defaultZoneList.get(0));
            String socialMediaHtmlString = getSocialMediaHtml(zoneParams);
            eachZoneMap.put(socialMediaHtmlField, socialMediaHtmlString);
            returnMap.put(eachZone.Name, eachZoneMap);
        }

        Map<String, Object> defaultZone = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(defaultZoneList.get(0)));

        Map<String, Object> zoneParams = new Map<String, Object>();
        zoneParams.put(SELECTED_ZONE_KEY, defaultZoneList.get(0));
        zoneParams.put(DEFAULT_ZONE_KEY, defaultZoneList.get(0));
        String socialMediaHtmlString = getSocialMediaHtml(zoneParams);
        defaultZone.put(socialMediaHtmlField, socialMediaHtmlString);
        returnMap.put(defaultZoneList.get(0).Name, defaultZone);

        return returnMap;

    }

    /**
     * Get the list of newsletter filters and sorts them by zone name
     *
     * @return                                              Map of zone name and newsletter recipients associated with it
     * @since                                               1.0
     */
    public virtual Map<String, List<ucinn_portal_Recipient__c>> getRecipientFilters(Map<String, Object> params) {
        Map<String, List<ucinn_portal_Recipient__c>> returnMap = new Map<String, List<ucinn_portal_Recipient__c>>();
        List<ucinn_portal_Recipient__c> newsletterRecipientsList = [SELECT Id, Name, Zone__r.Name FROM ucinn_portal_Recipient__c WHERE RecordType.DeveloperName = :NEWSLETTER_RECORD_TYPE];
        returnMap.put(DEFAULT_ZONE_NAME, newsletterRecipientsList); // all newsletter recipients lists
        List<ucinn_portal_Recipient__c> filtersWithoutSpecificZones = new List<ucinn_portal_Recipient__c>();


        for (ucinn_portal_Recipient__c currentRecipientsList: newsletterRecipientsList) {
            // Gather all newsletter recipients with zone 'ALL' or without a zones
            if (String.isBlank(currentRecipientsList.Zone__c) || currentRecipientsList.Zone__r.Name == DEFAULT_ZONE_NAME) {
                filtersWithoutSpecificZones.add(currentRecipientsList);
                continue;
            }

            if (returnMap.containsKey(currentRecipientsList.Zone__r.Name)) {
                returnMap.get(currentRecipientsList.Zone__r.Name).add(currentRecipientsList); // add content Recipient to the list
            } else {
                returnMap.put(currentRecipientsList.Zone__r.Name, new List<ucinn_portal_Recipient__c>{currentRecipientsList});
            }
        }

        returnMap.put('filtersWithoutSpecificZones', filtersWithoutSpecificZones);

        return returnMap;
    }

    /**
     * personalizes html string for a user
     *
     * @author Sam Longo
     *
     * @param newsletterId      the listing record Id that this newsletter is being generated for
     * @param listing           The listing record that is being parsed (should be only this OR newsletterId but not both)
     * @since                   1.0
     */
    public virtual String getPreviewNewsletterHtml(Map<String, Object> params) {
        String htmlString = parseNewsletterHtml(params);

        List<Map<String, String>> mergeFieldList = getMergeFields(new Map<String, String>{RECORD_TYPE_KEY => NEWSLETTER_RECORD_TYPE, SOBJECT_TYPE_KEY => LISTING_SOBJECT_NAME});
        Contact cont = getContactWithMergeFields(mergeFieldList);

        if (cont != null) {
            for (Map<String, String> eachMergeField : mergeFieldList) {
                String replacementString = (String)cont.get(eachMergeField.get(MERGE_FIELD_API_KEY));
                if (String.isBlank(replacementString)) {
                    replacementString = ''; //need to make sure its a valid string when null since null will throw an error in string.replace
                }
                htmlString = htmlString.replace(eachMergeField.get(MERGE_FIELD_VALUE_KEY), replacementString);
            }
        }

        return htmlString;
    }

     /**
    * method that gets newsletter merge fields from the custom metadata
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual List<Map<String, String>> getMergeFields(Map<String, Object> params) {
        String recordTypeString = (String) params.get(RECORD_TYPE_KEY);
        String sobjectTypeString = (String) params.get(SOBJECT_TYPE_KEY);

        List<Map<String, String>> returnList = new List<Map<String, String>>();

        String mainSection = '';
        String subSection = '';

        if ((String.isBlank(recordTypeString) && String.isBlank(sobjectTypeString)) || (recordTypeString == NEWSLETTER_RECORD_TYPE && sobjectTypeString == LISTING_SOBJECT_NAME)) {
            //get email API so we can determine which collection of mergefields to use for the newsletter contact
            mainSection = LISTING_MERGE_FIELDS_MAIN_SECTION;
            subSection = PORTAL_API_EmailHubBase.getEmailApiService();
            sobjectTypeString = CONTACT_KEY;
        } else if (sobjectTypeString == 'ucinn_portal_Zone__c') {
            mainSection = ZONE_MERGE_FIELDS_MAIN_SECTION;
        } else if (sobjectTypeString == 'ucinn_portal_Newsletter_Section__c') {
            mainSection = SECTION_MERGE_FIELDS_MAIN_SECTION;
        }

        String queryString = 'SELECT Id, DeveloperName, (SELECT Is_Display_On_Portal__c, Front_End_Field_Label__c, Front_End_Field_Value__c, Field_API_Name__c FROM Portal_Section_Field_Settings__r) FROM Portal_Page_Section_Setting__mdt ';
        queryString += ' WHERE Page_Name__c = \'' + NEWSLETTER_SUBMISSION_PAGE_NAME + '\'';
        queryString += ' AND Page_Main_Section__c = \'' + mainSection + '\'';
        queryString += ' AND Page_Sub_Section__c = \'' + subSection + '\'';
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = (List<Portal_Page_Section_Setting__mdt>) PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{PORTAL_Utils.QUERY_STRING => queryString});

        Schema.SObjectType mergeFieldSObjectType = PORTAL_SObjectInfoPool.getInstance().getSObjectType(sobjectTypeString);
        Map<String, Schema.SObjectField> fieldApiNameMap = mergeFieldSObjectType?.getDescribe()?.fields?.getMap();

        if (!sectionSettingList.isEmpty()) {
            List<Portal_Section_Field_Setting__mdt> fieldSettingList = sectionSettingList?.get(0)?.Portal_Section_Field_Settings__r;
            if (fieldSettingList != null) {
                for (Portal_Section_Field_Setting__mdt eachFieldSetting : fieldSettingList) {
                    if (fieldApiNameMap?.containsKey(eachFieldSetting.Field_API_Name__c) == true && String.isNotBlank(eachFieldSetting.Front_End_Field_Label__c) && String.isNotBlank(eachFieldSetting.Front_End_Field_Value__c) && eachFieldSetting.Is_Display_On_Portal__c == true) {
                        Map<String, String> valueMap = new Map<String, String>();
                        valueMap.put(MERGE_FIELD_VALUE_KEY, eachFieldSetting.Front_End_Field_Value__c);
                        valueMap.put(MERGE_FIELD_LABEL_KEY, eachFieldSetting.Front_End_Field_Label__c);
                        valueMap.put(MERGE_FIELD_API_KEY, eachFieldSetting.Field_API_Name__c);
                        returnList.add(valueMap);
                    }
                }
            }
        }
        return returnList;
    }

    /**
    * method that gets the zones that a user can submit newsletters to
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual List<Map<String, String>> getAvailableZones(Map<String, Object> params) {

        List<Map<String,String>> returnList = new List<Map<String,String>>();

        User usr = [SELECT Id, ContactId, Profile.Name
                    FROM User
                    WHERE Id =: UserInfo.getUserId()];



        // if user is not admin, grab the zones they have access too. If the user is an admin, Listing.Portal_Zone__c list is the full list of zones and is already returned.
        if (!PORTAL_CONST_Global.ADMIN_PROFILE_SET.contains(usr.Profile.Name) && FeatureManagement.checkPermission(PORTAL_CONST_Global.PORTAL_ADMIN_ACCESS_PERMISSION) == false) {

            if (usr == null || usr.ContactId == null) {
                return returnList;
            }

            Id contactId = usr.ContactId;

            //TODO: change to add permissions check (may use zone access level instead)
            List<ucinn_portal_Zone_Membership__c> memberships = [SELECT Zone__r.Name FROM ucinn_portal_Zone_Membership__c WHERE Constituent__c = :contactId AND Status__c = :ACTIVE_STATUS AND Zone_Permission_Set__c INCLUDES (:SUBMIT_NEWSLETTER_PERMISSION)];

            for (ucinn_portal_Zone_Membership__c membership : memberships) {
                returnList.add(new Map<String, String>{'value' => membership.Zone__r.Name, 'label' => membership.Zone__r.Name});
            }
            return returnList;
        } else {
            Map<String, Map<String, List<Map<String, String>>>> picklistMap = PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_PICKLISTS => new Map<String, List<String>>{LISTING_SOBJECT_NAME => new List<String>{'Portal_Zone__c'}}});
            return picklistMap.get(LISTING_SOBJECT_NAME)?.get('Portal_Zone__c');
        }
    }

    /**
    * method that gets the available time zones for a listing
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual List<Map<String, String>> getTimeZones(Map<String, Object> params) {
        String timeZoneField = 'Time_Zone__c';
        Map<String, Map<String, List<Map<String, String>>>> picklistMap = PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_PICKLISTS => new Map<String, List<String>>{LISTING_SOBJECT_NAME => new List<String>{timeZoneField}}});
        return picklistMap.get(LISTING_SOBJECT_NAME)?.get(timeZoneField);
    }

    /**
    * method that gets the templates that a user can use as part of their newsletter
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual List<ucinn_portal_Newsletter_Section__c> getNewsletterSectionTemplates(Map<String, Object> params) {
        return formatNewsletterSectionTemplatesForSelectionModal([SELECT Name, Newsletter_Html__c, Image__c FROM ucinn_portal_Newsletter_Section__c WHERE RecordType.DeveloperName = :NEWSLETTER_SECTION_TEMPLATE_RECORD_TYPE ORDER BY Name]);
    }

    protected virtual List<ucinn_portal_Newsletter_Section__c> formatNewsletterSectionTemplatesForSelectionModal(List<ucinn_portal_Newsletter_Section__c> newsletterSectionTemplateList) {
        for (ucinn_portal_Newsletter_Section__c eachSectionTemplate : newsletterSectionTemplateList) {
            if (String.isNotBlank(eachSectionTemplate.Image__c)) {
                eachSectionTemplate.Image__c = PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(eachSectionTemplate.Image__c);
            }
        }

        return newsletterSectionTemplateList;
    }

    /**
     * collects the zone by name passed in along with the default zone
     * and returns them in a map containing the default zone and selected zone
     *
     * @param listing      the listing record to collect the zone for.
     *
     * @return The Map of strings to zones. includes defaultZone and selectedZone.
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     */
    public virtual Map<String, Object> getNewsletterZones(Map<String, Object> params) {

        if (params?.get(LISTING_KEY) == null) {
            throw new NewsletterControllerException('Listing is not defined.');
        }

        ucinn_portal_Listing__c listing = (ucinn_portal_Listing__c) params.get(LISTING_KEY);
        Set<String> zoneNames = new Set<String>();
        zoneNames.add(DEFAULT_ZONE_NAME);

        if (String.isNotBlank(listing.Portal_Zone__c)) {
            zoneNames.add(listing.Portal_Zone__c);
        }

        List<ucinn_portal_Zone__c> newsletterZoneList = [SELECT Name, Header_Image_Alt_Text__c, Newsletter_Html_Format__c, Pre_Header__c,
                                                        Footer_Content__c, Social_Media_Order__c, Instagram_Link__c,
                                                        Twitter_Link__c, Facebook_Link__c, LinkedIn_Link__c, WeChat_Link__c,
                                                        Logo_Image_Alt_Text__c, Logo_Image__c, Header_Image__c, Social_Media_Content__c,
                                                        Section_Content_Html__c
                                                        FROM ucinn_portal_Zone__c
                                                        WHERE Name IN :zoneNames AND Is_Display_on_Portal__c = true];

        ucinn_portal_Zone__c defaultZone = null;
        ucinn_portal_Zone__c selectedZone = null;

        for (ucinn_portal_Zone__c eachZone : newsletterZoneList) {
            if (eachZone.Name == DEFAULT_ZONE_NAME) {
                defaultZone = eachZone;
            }

            if (eachZone.Name == listing.Portal_Zone__c) {
                selectedZone = eachZone;
            }
        }

        if (defaultZone == null) {
            throw new NewsletterControllerException('No default zone was found, ensure that a default zone is configured. Error Code: 314.');
        }
        if (String.isBlank(defaultZone.Newsletter_Html_Format__c)) {
            throw new NewsletterControllerException('Default zone does not have the html format format field filled out. Error Code: 316.');
        }

        if (selectedZone == null) {
            throw new NewsletterControllerException('No selected zone was found for the newsletter. Ensure that a valid zone is selected.');
        }

        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put(DEFAULT_ZONE_KEY , defaultZone);
        returnMap.put(SELECTED_ZONE_KEY, selectedZone);

        return returnMap;
    }

    /**
     * if a string is null, ensures that it is ''
     */
    protected virtual String nullToBlankString(String text) {
        if (String.isBlank(text)) {
            return '';
        }
        return text;
    }

    /**
    * method that searches against published news and events to prepopulate
    * the newsletter
    *
    * @param searchText                        The keyword to search against
    * @param maxItems                          the maximum amount of records we ant to return
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual List<ucinn_portal_Listing__c> searchForListings(Map<String, Object> params) {
        //TODO: make sure the person who is calling this function has the right access

        String searchText = (String) params.get(SEARCH_TEXT_KEY);

        if (String.isBlank(searchText)) {
            return new List<ucinn_portal_Listing__c>();
        }

        Integer maxItems = 10;
        if (String.isNotBlank((String)params.get(MAX_ITEMS_KEY)) && Integer.valueOf(params.get(MAX_ITEMS_KEY)) > 0 && Integer.valueOf(params.get(MAX_ITEMS_KEY)) <= 10) {
            maxItems = Integer.valueOf(params.get(MAX_ITEMS_KEY));
        }

        Id eventId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();
        Id newsId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWS).getRecordTypeId();
        Set<Id> recordTypeIds = new Set<Id>{eventId, newsId};
        searchText = '%' + String.escapeSingleQuotes(searchText) + '%';
        return [SELECT Id, RecordType.DeveloperName, Header_Content__c, Start_Date_Time__c, End_Date_Time__c, Header_Image__c, Name,
                Street__c, City__c, Postal_Code__c, Country__c, State__c, Body_Content__c, Portal_Zone__c, Event_Actual_Start_Date_Time__c, Event_Actual_End_Date_Time__c
                FROM ucinn_portal_Listing__c WHERE Name LIKE :searchText
                AND RecordTypeId IN :recordTypeIds LIMIT :maxItems ];
    }

    /**
     * Parses newsletter listing and sections into an html string
     *
     * @param newsletterId                  the listing record Id that this newsletter is being generated for
     * @param listing                       The listing record that is being parsed (should be only this OR newsletterId but not both)
     * @param newsletterSectionList         The list of newletter sections associated with the newsletter if using listing instead of Id
     * @return                              html string of the newsletter
     * @since                               1.0
     */
    public virtual String parseNewsletterHtml(Map<String, Object> params) {
        ucinn_portal_Listing__c listing;
        List<ucinn_portal_Newsletter_Section__c> listingSections;
        if (params?.get(NEWSLETTER_ID_KEY) != null) {
            listing =  getNewsletter(params);
            listingSections = listing.ucinn_portal_Newsletter_Sections__r;
        } else if (params?.get(LISTING_KEY) != null) {
            listing = (ucinn_portal_Listing__c) System.JSON.deserialize(System.JSON.serialize(params.get(LISTING_KEY)), ucinn_portal_Listing__c.class);
            if (params?.get(NEWSLETTER_SECTIONS_LIST_KEY) != null) {
                listingSections = (List<ucinn_portal_Newsletter_Section__c>) System.JSON.deserialize(System.JSON.serialize(params.get(NEWSLETTER_SECTIONS_LIST_KEY)), List<ucinn_portal_Newsletter_Section__c>.class);
            }
        }

        if (listing == null) {
            throw new NewsletterControllerException('Please select a valid listing. Error Code: 315.');
        }

        params.put(LISTING_KEY, listing);

        String portalUrl = PORTAL_CommunityUtils.getPortalURL();
        String imgURLregex = '<img.*?src="(.*?rtaImage\\?(.*?))"'; // regex to extact rta image data to convert to external, while leaving asset / imageServer links alone

        Map<String, String> moduleMap = getNewsletterModules(new Map<String, Object>());

        Map<String, Object> zoneMap = getNewsletterZones(params);

        ucinn_portal_Zone__c defaultZone = (ucinn_portal_Zone__c) zoneMap.get(DEFAULT_ZONE_KEY);
        params.put(DEFAULT_ZONE_KEY, defaultZone);
        ucinn_portal_Zone__c selectedZone = (ucinn_portal_Zone__c) zoneMap.get(SELECTED_ZONE_KEY);
        params.put(SELECTED_ZONE_KEY, selectedZone);

        String htmlString = parseBodyHtml(params);

        String newsletterSectionContent = '';
        String newsletterSectionsHtml = '';
        String sectionContentHtmlTemplate = (String.isNotBlank(selectedZone.Section_Content_Html__c) ? selectedZone.Section_Content_Html__c : nullToBlankString(defaultZone.Section_Content_Html__c));
        String sectionContentHtml = '';

        Decimal currentSectionNumber = -1;

        if (listingSections != null) {
            for (ucinn_portal_Newsletter_Section__c eachSection : listingSections) {

                if (eachsection.Section_Number__c != currentSectionNumber) {
                    currentSectionNumber = eachSection.Section_Number__c;
                    //add the sections to the previous section or '' if first section
                    sectionContentHtml  = sectionContentHtml.replace('{newsletterSections}', newsletterSectionContent);
                    newsletterSectionsHtml = newsletterSectionsHtml + sectionContentHtml;

                    //set up next section with title and background color from current newsletter section
                    sectionContentHtml = sectionContentHtmlTemplate;
                    sectionContentHtml = sectionContentHtml.replace('{sectionTitle}', nullToBlankString(eachSection.Section_Title__c));
                    sectionContentHtml = sectionContentHtml.replace('{backgroundColor}', nullToBlankString(eachSection.Background_Color__c));

                    newsletterSectionContent = '';
                }

                if (eachSection.Selected_Module__c != null && moduleMap.get(eachSection.Selected_Module__c) != null) {
                    Map<String, Object> sectionParams = new Map<String, Object>();
                    sectionParams.put(NEWSLETTER_SECTION_KEY, eachSection);
                    sectionparams.put(html_KEY, moduleMap.get(eachSection.Selected_Module__c));
                    newsletterSectionContent = newsletterSectionContent + parseSectionHtml(sectionparams);
                } else {
                    throw new NewsletterControllerException('One of the newsletter sections does not have a valid module selected. Error Code: 317.');
                }
            }

            //replace sectioncontent for final section after loop finishes
            sectionContentHtml  = sectionContentHtml.replace('{newsletterSections}', newsletterSectionContent);
            newsletterSectionsHtml = newsletterSectionsHtml + sectionContentHtml;
        }

        htmlString = htmlString.replace('{sectionContent}', newsletterSectionsHtml);

        //replace all the document images with the externally available image
        Pattern imgPattern = Pattern.compile(imgURLregex);
        Matcher imgMatcher = imgPattern.matcher(htmlString);
        portalUrl = portalUrl.removeEnd('/');

        while (imgMatcher.find()) {
            htmlString = htmlString.replace(imgMatcher.group(1), portalUrl + '/servlet/rtaImage?' + imgMatcher.group(2));
        }

        return htmlString;
    }

    /**
     * Takes in the outer html formatting and replaces mergefields based on listing fields
     *
     * @author Sam Longo
     *
     * @param listing                   The listing for this newsletter
     * @param defaultZone               the zone for html to fallback to
     * @param selectedZone              the primary zone to get html fields from
     * @return                          The processed html string for social media
     * @since                           1.0
     */
    public virtual String parseBodyHtml(Map<String, Object> params) {

        ucinn_portal_Listing__c listing = (ucinn_portal_Listing__c) params.get(LISTING_KEY);

        ucinn_portal_Zone__c defaultZone = (ucinn_portal_Zone__c) params.get(DEFAULT_ZONE_KEY);
        ucinn_portal_Zone__c selectedZone = (ucinn_portal_Zone__c) params.get(SELECTED_ZONE_KEY);
        String htmlString = (String.isNotBlank(selectedZone.Newsletter_Html_Format__c) ? selectedZone.Newsletter_Html_Format__c : defaultZone.Newsletter_Html_Format__c);

        String organizationName = getOrganizationName();

        htmlString = htmlString.replace('{footerContent}', (String.isNotBlank(selectedZone.Footer_Content__c) ? selectedZone.Footer_Content__c : nullToBlankString(defaultZone.Footer_Content__c)));
        htmlString = htmlString.replace('{preHeader}', (String.isNotBlank(selectedZone.Pre_Header__c) ? removeMargins(selectedZone.Pre_Header__c) : removeMargins(nullToBlankString(defaultZone.Pre_Header__c))));
        htmlString = htmlString.replace('{bodyContent}', (String.isNotBlank(listing.Body_Content__c) ? removeMargins(listing.Body_Content__c) : ''));
        htmlString = htmlString.replace('{socialMediaContent}', getSocialMediaHtml(params));
        htmlString = htmlString.replace('{organizationName}', organizationName);
        htmlString = htmlString.replace('{unsubscribeURL}', PORTAL_API_EmailHubBase.getUnsubscribeUrl(new Map<String, Object>{PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY => listing.Id}));
        htmlString = htmlString.replace('{changePreferencesURL}', (PORTAL_CommunityUtils.getPortalURL().removeEnd('/') + PORTAL_CONST_CommunityUrls.PREFERENCES_URL));
        htmlString = htmlString.replace('{portalURL}', getSubCommunityPortalUrl(listing.Portal_Subdomain__c));
        htmlString = htmlString.replace('{logoImage}', (String.isNotBlank(selectedZone.Logo_Image__c) ? selectedZone.Logo_Image__c : nullToBlankString(defaultZone.Logo_Image__c)));
        htmlString = htmlString.replace('{headerImage}', (String.isNotBlank(selectedZone.Header_Image__c) ? selectedZone.Header_Image__c : nullToBlankString(defaultZone.Header_Image__c)));
        //url image fields extract from the rich text area.
        //with proper design we suggest using only one or the other between the image or altText + URL.
        //This allows for custom styling on the img tag, that overrides what was in the rich text.
        htmlString = htmlString.replace('{LogoImageAltText}', (String.isNotBlank(selectedZone.Logo_Image_Alt_Text__c) ? selectedZone.Logo_Image_Alt_Text__c : nullToBlankString(defaultZone.Logo_Image_Alt_Text__c)));
        htmlString = htmlString.replace('{logoImageURL}', (String.isNotBlank(selectedZone.Logo_Image__c) ? PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(selectedZone.Logo_Image__c) : PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(defaultZone.Logo_Image__c)));
        htmlString = htmlString.replace('{headerImageAltText}', (String.isNotBlank(selectedZone.Header_Image_Alt_Text__c) ? selectedZone.Header_Image_Alt_Text__c : nullToBlankString(defaultZone.Header_Image_Alt_Text__c)));
        htmlString = htmlString.replace('{headerImageURL}', (String.isNotBlank(selectedZone.Header_Image__c) ? PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(selectedZone.Header_Image__c) : PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(defaultZone.Header_Image__c)));

        return htmlString;
    }

    /**
     * takes in subcommunity name and adds it to after the .com/
     *
     * @author Sam Longo
     * @param portalSubdomain          string with sub community name
     *
     * @return                          portal URL for subcommunity, or default portal URL if no subcommunity name
     * @since                           1.0
     *
     */
    protected virtual String getSubCommunityPortalUrl(String portalSubdomain) {
        if (String.isBlank(portalSubdomain)) {
            return PORTAL_CommunityUtils.getPortalURL();
        } else {
            return PORTAL_CommunityUtils.getPortalURL() + nullToBlankString(portalSubdomain) +'/';
        }
    }

    /**
     * returns a social media string with links based on the listing zone
     *
     * @author Sam Longo
     *
     * @param selectedZone            The zone for this newsletter
     * @param defaultZone               The default zone to use fields from if they do not exist on the selectedZone
     * @return                          The processed html string for social media
     * @since                           1.0
     */
    public virtual String getSocialMediaHtml(map<String, Object> params) {

        ucinn_portal_Zone__c selectedZone = (ucinn_portal_Zone__c) params.get(SELECTED_ZONE_KEY);
        ucinn_portal_Zone__c defaultZone = (ucinn_portal_Zone__c) params.get(DEFAULT_ZONE_KEY);

        String socialMediaHtmlString = (String.isNotBlank(selectedZone.Social_Media_Content__c) ? selectedZone.Social_Media_Content__c : nullToBlankString(defaultZone.Social_Media_Content__c));
        String redirectLinkKey = 'redirectLink';
        String altTextKey = 'altText';
        String imageLinkKey = 'imageLink';

        List<Map<String, String>> orderedSocialMediaInfo = new List<Map<String, String>>(); // a list of information on social media. Contains the redirect url if clicked, as well as url of where the image is located

        List<Document> newsletterDocuments = [SELECT Id, Name, LastModifiedDate FROM Document WHERE Folder.name = :SOCIAL_MEDIA_LOGO_FOLDER]; // where the images for the social media buttons are contained

        Map<String, Document> documentNameToNewsletterDocument = new Map<String, Document>(); // stores document name -> document for documents in newsletter folder
        for (Document currentDocument: newsletterDocuments) {
            documentNameToNewsletterDocument.put(currentDocument.Name, currentDocument);
        }

        List<String> socialMediaOrder = new List<String>();
        // Default social media order if there is none
        if (String.isBlank(selectedZone.Social_Media_Order__c)) {
            if (String.isBlank(defaultZone.Social_Media_Order__c)) {
                return '';
            }
            socialMediaOrder = defaultZone.Social_Media_Order__c.split(';');
        } else {
            socialMediaOrder = selectedZone.Social_Media_Order__c.split(';');
        }

        // populate links and icons with values
        for (String socialMediaName: socialMediaOrder) {
            Map<String, String> socialMediaInfo = new Map<String, String>();
            String altText = ' alt="' + socialMediaName + ' icon" ';
            Document socialMediaDocument = (Document) documentNameToNewsletterDocument.get(socialMediaName + ' Logo');

            String linkField = socialMediaName + '_Link__c';
            String redirectLink = (String)defaultZone.get(linkField);
            if (selectedZone.get(linkField) != null) {
                redirectLink = (String)selectedZone.get(linkField);
            }

            String socialMediaUrl = '';
            if (socialMediaDocument != null) {
                URL request = URL.getCurrentRequestUrl();
                String urlString = request.toExternalForm();
                String host = request.getHost();
                socialMediaUrl = urlString.substringBefore(host) + host +'/servlet/servlet.ImageServer?id='+ socialMediaDocument.Id + '&oid=' + UserInfo.getOrganizationId() + '&lastMod=' + socialMediaDocument.LastModifiedDate.getTime();
            }

            socialMediaInfo.put(redirectLinkKey, redirectLink);
            socialMediaInfo.put(imageLinkKey, socialMediaUrl);
            socialMediaInfo.put(altTextKey, altText);
            orderedSocialMediaInfo.add(socialMediaInfo);
        }

        for (Integer socialMediaIndex = 0; socialMediaIndex < orderedSocialMediaInfo.size(); socialMediaIndex++) {
            //Social_Media_Content__c format starts at 1 so we include an incremented index
            String formatIndex = String.valueOf(socialMediaIndex + 1);
            socialMediaHtmlString = socialMediaHtmlString.replace('{SocialMediaLink_'+ formatIndex +'}', nullToBlankString(orderedSocialMediaInfo[socialMediaIndex].get(redirectLinkKey)));
            socialMediaHtmlString = socialMediaHtmlString.replace('{SocialMediaDefaultAltText_'+ formatIndex +'}', nullToBlankString(orderedSocialMediaInfo[socialMediaIndex].get(altTextKey)));
            socialMediaHtmlString = socialMediaHtmlString.replace('{SocialMediaImageSource_'+ formatIndex +'}', nullToBlankString(orderedSocialMediaInfo[socialMediaIndex].get(imageLinkKey)));
        }
        //any remaining merge fields will be left as is and show broken images / links
        //it is expected that the person(s) setting up the zones will ensure a matched number of social media

        return socialMediaHtmlString;
    }

    /**
     * replaces merge fields on the section html with its text value
     *
     * @author Sam Longo
     *
     * @param section                   The section record
     * @param html                      The html being processed
     * @return                          The processed html string for the section
     * @since                           1.0
     */
    public virtual String parseSectionHtml(Map<String, Object> params) {

        ucinn_portal_Newsletter_Section__c section = (ucinn_portal_Newsletter_Section__c) params.get(NEWSLETTER_SECTION_KEY);
        String html =  (String) params.get(html_KEY);
        Map<String, String> mergeFields = new Map<String, String>();

        mergeFields.put('{bodyContent}',        nullToBlankString(section.Body_Content__c));
        mergeFields.put('{headerContent}',      nullToBlankString(section.Header_Content__c));
        mergeFields.put('{headerURL}',          nullToBlankString(section.Header_URL__c));
        //image field would either have a stylized image using imageURL and imageAltText OR image as directly placing the
        mergeFields.put('{image}',              nullToBlankString(section.Image__c));
        mergeFields.put('{imageURL}',           (String.isNotBlank(section.Image__c)) ? PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(section.Image__c) : '');
        mergeFields.put('{imageAltText}',       nullToBlankString(section.Image_Alt_Text__c));
        mergeFields.put('{backgroundColor}',    nullToBlankString(section.Background_Color__c));
        mergeFields.put('{dateTimeLocation}',   getFormattedDateTimeLocation(section));

        for (String eachKey : mergeFields.keySet()) {
            html = html.replace(eachKey, mergeFields.get(eachKey));
        }

        return html;
    }

    /**
     * @author Sam Longo
     *
     * @param section           The section to parse out the formatted start date time location from
     *
     * @return the processed string for the date time and location
     */
    protected virtual String getFormattedDateTimeLocation(ucinn_portal_Newsletter_Section__c section) {

        if (section == null) {
            return '';
        }

        List<String> startDateTime = formatDate(section.Start_Date_Time__c);
        List<String> endDateTime = formatDate(section.End_Date_Time__c);

        String dateTimeLocation = '';
        String dateString = '';
        String timeString = '';

        if (startDateTime != null && startDateTime.size() >= 2) {

            timeString = startDateTime[1];
            dateString = startDateTime[0];
        }

        if (endDateTime != null && endDateTime.size() >= 2) {

            if (String.isNotBlank(timeString) && String.isNotBlank(endDateTime[1])) {
                timeString += '-';
            }

            timeString += endDateTime[1];

            if (String.isNotBlank(dateString) && String.isNotBlank(endDateTime[0])) {
                dateString += '-';
            }

            dateString += endDateTime[0];
        }

        dateTimeLocation = dateString;

        if (String.isNotBlank(dateTimeLocation)){
            dateTimeLocation += '<br>';
        }

        dateTimeLocation += timeString;

        if (String.isNotBlank(section.Location__c)) {

            if (String.isNotBlank(dateTimeLocation)) {
                dateTimeLocation += '<br>';
            }

            dateTimeLocation += section.Location__c;
        }

           dateTimeLocation = '<div style="font-weight: bold">' + dateTimeLocation + '</div>';
        return dateTimeLocation;
    }



    /**
     * format date and time for newsletter parser
     *
     * @author Sam Longo
     *
     * @param dateTimeStr                                           DateTime in string form
     * @return                                                      list of time and date
     * @since                                                       1.0
     */
    public virtual List<String> formatDate(String dateTimeStr) {
        List<String> response = new List<String>();
        String formattedTime = '';
        String formattedDate = '';

        if (String.isBlank(dateTimeStr)) {
            return response;
        }

        List<String> timeDate = dateTimeStr.split('T');

        if (timeDate.size() < 2) {
            return response;
        }

        String timeStr = timeDate[1];
        String dateStr = timeDate[0];

        //timeStr starts as HH:MM:SS.####z and remove :SS.####z
        timeStr = timeStr.substring(0, 6);

        List<String> timeSplit = timeStr.split(':'); //HH:MM
        List<String> dateSplit = dateStr.split('-');

        if (timeSplit.size() < 2 || dateSplit.size() < 3) {
            return response;
        }

        // format Time
        if (integer.valueOf(timeSplit[0]) > 12 && integer.valueOf(timeSplit[0]) < 24){ // pm
            formattedTime = (integer.valueOf(timeSplit[0])-12) + ':' + timeSplit[1] + ' p.m.';
        } else if (Integer.valueOf(timeSplit[0]) == 0) { // am
            formattedTime = '12' + ':' + timeSplit[1] + ' a.m.';
        } else if (Integer.valueOf(timeSplit[0]) == 12 ) {
            formattedTime = '12' + ':' + timeSplit[1] + ' p.m.';
        }
        else {
            formattedTime = integer.valueOf(timeSplit[0]) + ':' + timeSplit[1] + ' a.m.';
        }

        formattedDate = dateSplit[1] + '/' + dateSplit[2] + '/' + dateSplit[0];

        response.add(formattedDate);
        response.add(formattedTime);

        return response;
    }

    /**
     * collects NewsletterSection modules and outer template maps them by module and template
     *
     * @author Sam Longo
     *
     * @return                          A map of string keys of module names to their corresponding template's html string.
     * @since                           1.0
     */
    public virtual Map<String, String> getNewsletterModules(map<String, Object> params) {
        List<ucinn_portal_Listing__c> newsletterTemplateList = [SELECT (SELECT Newsletter_Html__c, Name FROM ucinn_portal_Newsletter_Sections__r) FROM ucinn_portal_Listing__c WHERE Name = :NEWSLETTER_TEMPLATE_NAME AND RecordType.DeveloperName = :NEWSLETTER_TEMPLATE_RECORDTYPE LIMIT 1];

        if (newsletterTemplateList.isEmpty() || newsletterTemplateList.get(0).ucinn_portal_Newsletter_Sections__r == null) {
            throw new NewsletterControllerException('Newsletter template or modules not found.');
        }

        map<String, String> moduleHtmlMap = new map<String,String>();
        for (ucinn_portal_Newsletter_Section__c eachModule : newsletterTemplateList.get(0).ucinn_portal_Newsletter_Sections__r) {
            moduleHtmlMap.put(eachModule.Name, eachModule.Newsletter_Html__c);
        }

        return moduleHtmlMap;
    }

    /**
     * Remove margins from p and h1-h5 tags.
     *
     * @param text                                                      The html that needs margins removed
     * @return                                                          html with margins removed
     * @since                                                           1.0
     */
    @TestVisible
    protected virtual String removeMargins(String text) {
        text = text.replace('<p>', '<p style="margin-top: 0px; margin-bottom: 0px;">'); // Gmail stop adding margins!
        text = text.replace('<h1>', '<h1 style="margin-top: 0px; margin-bottom: 0px;">'); // Gmail stop adding margins!
        text = text.replace('<h2>', '<h2 style="margin-top: 0px; margin-bottom: 0px;">'); // Gmail stop adding margins!
        text = text.replace('<h3>', '<h3 style="margin-top: 0px; margin-bottom: 0px;">'); // Gmail stop adding margins!
        text = text.replace('<h4>', '<h4 style="margin-top: 0px; margin-bottom: 0px;">'); // Gmail stop adding margins!
        text = text.replace('<h5>', '<h5 style="margin-top: 0px; margin-bottom: 0px;">'); // Gmail stop adding margins!
        return text;
    }

    /**
    * method that submits a newsletter for a user
    *
    * @param listing                           The newsletter we are trying to submit
    * @param newsletterSectionList             The list of newletter sections associated with the newsletter
    * @param recaptchaToken                    The client side recaptcha token to be verified
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual void submitNewsletter(Map<String, Object> params) {
        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_NewsletterControllerBase.submitNewsletter', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        if (params.containsKey(LISTING_KEY) && params.containsKey(NEWSLETTER_SECTIONS_LIST_KEY) && cont != null) {
            ucinn_portal_Listing__c listing = (ucinn_portal_Listing__c) System.JSON.deserialize(System.JSON.serialize(params.get(LISTING_KEY)), ucinn_portal_Listing__c.class);
            List<ucinn_portal_Newsletter_Section__c> newsletterSectionList = (List<ucinn_portal_Newsletter_Section__c>) System.JSON.deserialize(System.JSON.serialize(params.get(NEWSLETTER_SECTIONS_LIST_KEY)), List<ucinn_portal_Newsletter_Section__c>.class);

            if (String.isBlank(listing.Portal_Zone__c)) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Please select a club or group.'});
            } else {
                getUserPermissions(listing.Portal_Zone__c);
            }

            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(NEWSLETTER_RECORD_TYPE).getRecordTypeId();

            //if this is a newsletter edit, check to make sure that the user has permissions to edit this newsletter
            if (String.isNotBlank(listing.Id)) {
                List<ucinn_portal_Listing__c> listingList = [SELECT Id FROM ucinn_portal_Listing__c WHERE Id = :listing.Id AND CreatedById = :UserInfo.getUserId() AND Status__c != :PUBLISHED_STATUS AND Status__c != :SCHEDULED_STATUS];
                if (listingList.isEmpty()) {
                    throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NEWSLETTER_PERMISSION_ERROR});
                }

            }

            //check to see if the case needs to be created
            Boolean createCase = false;
            String queueName = '';
            List<String> metadataLabels = new List<String>{NEWSLETTER_QUEUE_METADATA_LABEL};

            Map<String, Object> queryParams = new Map<String, Object>();
            queryParams.put(PORTAL_Utils.FIELD_SET, new Set<String>{'Boolean_Value__c', 'Value__c'});
            queryParams.put(PORTAL_Utils.SOBJECT_NAME, PORTAL_Utils.ORG_SETTING_MDT);
            queryParams.put(PORTAL_Utils.DEVELOPER_NAME_LIST, metadataLabels);

            List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_utils.getCustomMetadataRecordList(queryParams);
            if (!orgSettingList.isEmpty() && orgSettingList[0]?.Value__c != null) {
                queueName = orgSettingList[0].Value__c;
            }

            metadataLabels = new List<String>{CREATE_CASE_FOR_NEWSLETTER_METADATA_LABEL};
            queryParams.put(PORTAL_Utils.DEVELOPER_NAME_LIST, metadataLabels);

            orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_utils.getCustomMetadataRecordList(queryParams);
            if (!orgSettingList.isEmpty() && String.isNotBlank(orgSettingList[0]?.Value__c)) {
                createCase = Boolean.valueOf(orgSettingList[0].Value__c);
            }

            if (createCase) {

                if (String.isNotBlank(listing.Case__c)) {
                    Case newCase = new Case();
                    newCase.Status = RESUBMITTED_STATUS;
                    newCase.Id = listing.Case__c;
                    update newCase;
                } else {
                    Case newCase = new Case();
                    newCase.Origin='Web';
                    newCase.Subject='A new newsletter has been submitted for approval.';
                    newCase.Status='New';
                    newCase.Type= NEWSLETTER_CASE_TYPE;
                    newCase.ContactId=cont.Id;

                    if (String.isNotBlank(queueName)) {
                        List<Group> groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :queueName Limit 1];
                        if (!groupList.isEmpty()) {
                            newCase.OwnerId = groupList.get(0).Id;
                        }
                    }

                    insert newCase;
                    listing.Case__c = newCase.Id;
                }

            }

            String url = Network.getLoginUrl(Network.getNetworkId());
            if (Test.isRunningTest()) {
                url = 'ucinnovation.com/alumniportal/s';
            }
            Pattern urlMatcher = Pattern.compile('.+(\\.edu|\\.com|\\.org)'); // grabs src="<url>"
            Matcher urlMatches = urlMatcher.matcher(url);

            if (urlMatches.find()) {
                url = url.replace(urlMatches.group(), '');
                url = url.replace('/s/login', '');
                url = url.replace('/', '');
                listing.Portal_Subdomain__c = url;
            }

            listing.Status__c = PENDING_STATUS;
            upsert listing;

            if (newsletterSectionList != null) {
                for (ucinn_portal_Newsletter_Section__c section : newsletterSectionList) {
                    if (String.isBlank(section.Newsletter_Listing__c)) {
                        section.Newsletter_Listing__c = listing.Id;
                    }
                }

                upsert newsletterSectionList;

                Map<Id, sObject> newSectionsMap = new Map<Id, sObject>(newsletterSectionList);
                List<ucinn_portal_NewsLetter_Section__c> sectionsToDelete = [SELECT Id FROM ucinn_portal_NewsLetter_Section__c
                                                                             WHERE NewsLetter_Listing__c = :listing.Id AND Id NOT IN :newSectionsMap.keySet()];
                delete sectionsToDelete;
            } else {
                List<ucinn_portal_NewsLetter_Section__c> sectionsToDelete = [SELECT Id FROM ucinn_portal_NewsLetter_Section__c
                                                                             WHERE NewsLetter_Listing__c = :listing.Id];
                delete sectionsToDelete;
            }

        }
    }

    /**
    * method that checks to see if a front end user has permissions to submit newsletters
    *
    * @param zoneName                          The zone we are checking permissions for
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    @TestVisible
    protected virtual void getUserPermissions(String zoneName) {
        User usr = [SELECT Id, ContactId, Profile.Name
                    FROM User
                    WHERE Id =: UserInfo.getUserId()];
        // if user is not admin, grab the zones they have access too. If the user is an admin, Listing.Portal_Zone__c list is the full list of zones and is already returned.
        if (!PORTAL_CONST_Global.ADMIN_PROFILE_SET.contains(usr.Profile.Name) && FeatureManagement.checkPermission(PORTAL_CONST_Global.PORTAL_ADMIN_ACCESS_PERMISSION) == false) {
            if (usr.ContactId != null) {
                List<ucinn_portal_Zone_Membership__c> zoneMembershipList = [SELECT Id FROM ucinn_portal_Zone_Membership__c
                                                                            WHERE Constituent__c = :usr.ContactId AND Status__c = :ACTIVE_STATUS
                                                                             AND Zone_Permission_Set__c INCLUDES (:SUBMIT_NEWSLETTER_PERMISSION)
                                                                             AND Zone__r.Name = :zoneName];
                if (zoneMembershipList.isEmpty()) {
                    throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NEWSLETTER_PERMISSION_ERROR});
                }
            } else {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NEWSLETTER_PERMISSION_ERROR});
            }
        }
    }

    /**
    * method that gets a newsletter by Id for backend users and processing.
    *
    * @param newsletterId                       The id for the newsletter
    * @return                                   ucinn_portal_Listing__c object with related newsletter sections
    *
    * @author:                                  Ashley Tran
    * @since:                                   1.0
    */
    public virtual ucinn_portal_Listing__c getNewsletter(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        if (String.isNotBlank(newsletterId)) {
            List<ucinn_portal_Listing__c> listingList = [SELECT Id, Case__c, Body_Content__c, Start_Date_Time__c, Portal_Zone__c,
                                                            Time_Zone__c, Name, Header_Image_Alt_Text__c,
                                                            Pre_Header__c, Subject_Line__c, CreatedById, Status__c,
                                                            Portal_Subdomain__c,
                                                            (SELECT Section_Number__c, Order_In_Section__c, Location__c,
                                                            Header_Content__c, Image__c, Body_Content__c, Image_Alt_Text__c,
                                                            Start_Date_Time__c, End_Date_Time__c, Section_Title__c,
                                                            Is_Change_Background_Color__c, Selected_Module__c, Background_Color__c, Newsletter_Listing__c, Header_URL__c
                                                            FROM ucinn_portal_Newsletter_Sections__r ORDER BY Section_Number__c, Order_In_Section__c)
                                                            FROM ucinn_portal_Listing__c
                                                            WHERE Id = :newsletterId AND RecordType.DeveloperName = :NEWSLETTER_RECORD_TYPE
                                                            ];
            if (!listingList.isEmpty()) {
                ucinn_portal_Listing__c returnListing = listingList.get(0);
                return returnListing;
            }

        }
        return null;
    }

    /**
    * method that gets the existing data for a newsletter to allow for a user to edit it on the front end
    *
    * @param newsletterId                       The id for the newsletter
    * @return                                   ucinn_portal_Listing__c object with related newsletter sections
    *
    * @author:                                  Sam Longo
    * @since:                                   1.0
    */
    public virtual ucinn_portal_Listing__c getFrontendNewsletter(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        Boolean isClone = (Boolean) params.get(CLONE_KEY);
        if (String.isNotBlank(newsletterId)) {
            List<ucinn_portal_Listing__c> listingList = [SELECT Id, Case__c, Body_Content__c, Start_Date_Time__c, Portal_Zone__c,
                                                            Time_Zone__c, Name, Header_Image_Alt_Text__c,
                                                            Pre_Header__c, Subject_Line__c, CreatedById, Status__c,
                                                            Portal_Subdomain__c,
                                                            (SELECT Section_Number__c, Order_In_Section__c, Location__c,
                                                            Header_Content__c, Image__c, Body_Content__c, Image_Alt_Text__c,
                                                            Start_Date_Time__c, End_Date_Time__c, Section_Title__c,
                                                            Is_Change_Background_Color__c, Selected_Module__c, Background_Color__c, Newsletter_Listing__c
                                                            FROM ucinn_portal_Newsletter_Sections__r ORDER BY Section_Number__c, Order_In_Section__c)
                                                            FROM ucinn_portal_Listing__c
                                                            WHERE Id = :newsletterId AND RecordType.DeveloperName = :NEWSLETTER_RECORD_TYPE
                                                            ];
            if (!listingList.isEmpty()) {
                ucinn_portal_Listing__c returnListing = listingList.get(0);

                if (returnListing.CreatedById != UserInfo.getUserId()) {
                    return null;
                }

                if (isClone) {
                    returnListing.Id = null;
                    for (ucinn_portal_Newsletter_Section__c eachSection : returnListing.ucinn_portal_Newsletter_Sections__r) {
                        eachSection.Id = null;
                        eachSection.Newsletter_Listing__c = null;
                    }
                    return returnListing;
                }

                if (returnListing.Status__c != PUBLISHED_STATUS && returnListing.Status__c != SCHEDULED_STATUS) {
                    return returnListing;
                }
            }
        }
        return null;
    }

    /**
    * Creates the plain text version of the newsletter
    *
    * @param listing                           The newsletter that contains the data
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual String parseNewsletterPlainText(Map<String, Object> params) {
        ucinn_portal_Listing__c listing = getNewsletter(params);

        if (listing == null) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Please select a valid listing. Error Code: 315.'});
        }

        String plainTextBody = '';
        String stripHtmlTags = '<[^>]+>';

        if (listing.Body_Content__c != null) {
            plainTextBody+= listing.Body_Content__c.replaceAll(stripHtmlTags, '') + '\n\n';
        }

        Decimal currentSectionNumber = 1;

        for (ucinn_portal_Newsletter_Section__c eachSection : listing.ucinn_portal_Newsletter_Sections__r) {
            if (eachsection.Section_Number__c != currentSectionNumber) {
                currentSectionNumber = eachSection.Section_Number__c;
                plainTextBody += eachSection.Section_Title__c.replaceAll(stripHtmlTags, '') + '\n\n';

            }
            List<String> formattedStartDateTime;
            List<String> formattedEndDateTime;

            if (eachSection.Header_Content__c != null) {
                plainTextBody += eachSection.Header_Content__c.replaceALl(stripHtmlTags, '') + '\n';
            }

            String dateTimeLocation = getFormattedDateTimeLocation(eachSection);

            plainTextBody += dateTimeLocation.replaceAll(stripHtmlTags, '') + '\n';

            if (eachSection.Body_Content__c != null) {
                plainTextBody += eachSection.Body_Content__c.replaceAll(stripHtmlTags, '') + '\n';
            }

            plainTextBody += '\n';
        }

        return plainTextBody;

    }

    /**
    * method for the quick action that starts the batch that counts the number of
    * recipients that the newsletter will be sent to
    *
    * @param newsletterId                      The id of he newsletter
    * @param email                             The email of the recipient that will be notified when the batch is done
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual void countRecipients(Map<String, Object> params) {

        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        String email = (String) params.get(EMAIL_KEY);

        if (String.isBlank(email)) {
            email = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()]?.Email;
        }
        if (String.isBlank(newsletterId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }

        List<ucinn_portal_Recipient__c> recipientFilterList = [SELECT Filter_Logic__c, Id FROM ucinn_portal_Recipient__c WHERE Id IN (SELECT Recipient__c FROM ucinn_portal_Listing__c WHERE Id = :newsletterId)];

        if (recipientFilterList.isEmpty()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There is no recipient filter associated with this newsletter.'});
        }

        ucinn_portal_Recipient__c filter = recipientFilterList.get(0);
        List<String> postfixExpressions = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => filter.Filter_Logic__c});
        Database.executeBatch(new PORTAL_BATCH_NewsletterFilter(postfixExpressions, filter.Id, newsletterId, null, null, email, true, false, Datetime.now()));

    }

     /**
    * method that schedules a newsletter to be sent
    *
    * @param newsletterId                      The id of he newsletter
    * @param deliveryTime                      The time we want to deliver the newsletter
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual void scheduleNewsletter(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);

        if (String.isBlank(newsletterId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }

        List<ucinn_portal_Listing__c>  newsletterList = [SELECT Time_Zone__c, Status__c, Scheduled_Job_Id__c, Number_Of_Newsletter_Recipients__c, Recipient__c, Recipient__r.Filter_Logic__c FROM ucinn_portal_Listing__c WHERE Id = :newsletterId];
        if (newsletterList.isEmpty()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }
        ucinn_portal_Listing__c newsletter = newsletterList.get(0);

        if (newsletter.Status__c != PENDING_STATUS) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Can only schedule a newsletter that is in pending status'});
        }

        if (String.isNotBlank(newsletter.Scheduled_Job_Id__c)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'This newsletter already has a scheduled job'});
        }

        //JSON parse datetime because lightning input is in ISO 8601 format, and salesforce requires
        if (params.get(DELIVERY_TIME_KEY) == null || String.isBlank(String.valueOf(params.get(DELIVERY_TIME_KEY)))) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Please select a scheduled time.'});
        }
        Datetime deliveryTime = PORTAL_CommunityUtils.getTimeDifference(newsletter.Time_Zone__c, String.valueOf(params.get(DELIVERY_TIME_KEY)));

        if (newsletter.Number_of_Newsletter_Recipients__c == null || newsletter.Recipient__c == null) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Please use the recipient filter to count your recipients first.'});
        }
        List<String> postFix = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => newsletter.Recipient__r.Filter_Logic__c});
        Integer minutesUntilScheduledTime = (Integer) ((deliveryTime.getTime() - Datetime.now().getTime())/60000);
        String scheduledId = System.scheduleBatch(new PORTAL_BATCH_NewsletterFilter(postfix, newsletter.Recipient__c, newsletterId,null, null, null, false, false, deliveryTime), newsletterId + ' Scheduled Send', minutesUntilScheduledTime, 1000);

        newsletter.Scheduled_Job_Id__c = scheduledId;
        newsletter.Status__c = SCHEDULED_STATUS;
        newsletter.Start_Date_Time__c = deliveryTime;
        newsletter.Actual_Start_Date_Time__c =  String.valueOf(deliveryTime);
        update newsletter;
    }

     /**
    * method for the quick action that clones an existing newsletter and moves
    * over the template and newsletter sections
    *
    * @param newsletterId                      The id of he newsletter
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual Id cloneNewsletter(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        if (String.isNotBlank(newsletterId)) {
            List<ucinn_portal_Listing__c> listingList = [SELECT Id, Body_Content__c, Start_Date_Time__c, Portal_Zone__c,
                                                            Time_Zone__c, Name, Header_Image_Alt_Text__c,
                                                            Pre_Header__c, Subject_Line__c
                                                            FROM ucinn_portal_Listing__c
                                                            WHERE Id = :newsletterId AND RecordType.DeveloperName = :NEWSLETTER_RECORD_TYPE
                                                            ];
            if (!listingList.isEmpty()) {
                ucinn_portal_Listing__c newsletter = listingList.get(0);
                ucinn_portal_Listing__c newNewsletter = newsletter.clone(false, false, false, false);
                newNewsletter.Name = 'Clone of ' + newNewsletter.Name;
                insert newNewsletter;

                List<ucinn_portal_Newsletter_Section__c> newSectionList = new List<ucinn_portal_Newsletter_Section__c>();
                List<ucinn_portal_Newsletter_Section__c> newsletterSectionList = [SELECT Section_Number__c, Order_In_Section__c, Location__c, Header_URL__c,
                                                                                    Header_Content__c, Image__c, Body_Content__c, Image_Alt_Text__c,
                                                                                    Start_Date_Time__c, End_Date_Time__c, Section_Title__c,
                                                                                    Is_Change_Background_Color__c, Selected_Module__c, Background_Color__c
                                                                                    FROM ucinn_portal_Newsletter_Section__c WHERE Newsletter_Listing__c = :newsletterId ORDER BY Section_Number__c, Order_In_Section__c];
                for (ucinn_portal_Newsletter_Section__c eachSection : newsletterSectionList) {
                    ucinn_portal_Newsletter_Section__c newSection = eachSection.clone(false, false, false, false);
                    newSection.Newsletter_Listing__c = newNewsletter.Id;
                    newSectionList.add(newSection);
                }

                insert newSectionList;
                return newNewsletter.Id;
            }

        }
        return null;
    }

    /**
    * method that sends the newsletter right away
    *
    * @param newsletterId                      The id of he newsletter
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */

    public virtual void sendNewsletter(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        if (String.isBlank(newsletterId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }
        List<ucinn_portal_Listing__c>  newsletterList = [SELECT Number_Of_Newsletter_Recipients__c, Recipient__c, Recipient__r.Filter_Logic__c FROM ucinn_portal_Listing__c WHERE Id = :newsletterId];
        if (newsletterList.isEmpty()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }
        ucinn_portal_Listing__c newsletter = newsletterList.get(0);

        if (newsletter.Number_of_Newsletter_Recipients__c == null || newsletter.Recipient__c == null) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Please use the recipient filter to count your recipients first.'});
        }

        List<String> postFix = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => newsletter.Recipient__r.Filter_Logic__c});
        Database.executeBatch(new PORTAL_BATCH_NewsletterFilter(postfix, newsletter.Recipient__c, newsletterId, null, null, null, false, false, Datetime.now().addMinutes(5)), 1000);
    }

    /**
    * method that unschedules the sending of the newsletter in the email api
    *
    * @param newsletterId:                     The id of the newsletter we are trying to cancel
    *
    * @author:                                 Sam Longo
    * @since:                                  1.0
    */

    public virtual void unscheduleNewsletter(Map<String, Object> params) {
        Id newsletterId = (Id) params.get(NEWSLETTER_ID_KEY);
        if (String.isBlank(newsletterId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }

        PORTAL_API_EmailHubBase.unscheduleEmail(params);
    }


    /**
    * method that gets all of a users submitted newsletters so they can view it as
    * a list on the front end
    *
    * @author:                                 Ashley Tran, Jacob Huang
    * @since:                                  1.0
    *
    * @param    offset      Integer: offset number to use in the SOQL/SOSL query
    * @param    searchText  String: user input text to use in a SOSL query FIND clause
    *
    * @return Map<String, Object> with newsletter records, total newsletter count, and front end data map
    */
    public virtual Map<String,Object> getMyNewsletters(Map<String, Object> params) {
        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(SUBMITTED_NEWSLETTER_PAGE_NAME, '', '');

        Integer offset = params?.get(OFFSET_KEY) != null ? Integer.valueOf(String.valueOf(params.get(OFFSET_KEY))) : 0;
        String searchText = (String) params?.get(SEARCH_TEXT_KEY);

        Map<String, Object> returnMap = null;
        if (String.isNotBlank(searchText) == true) {
            returnMap = getMyNewslettersWithSosl(offset, searchText, pageSectionSettingList);
        } else {
            returnMap = getMyNewslettersWithSoql(offset, pageSectionSettingList);
        }

        returnMap.put(FRONT_END_DATA_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList));

        return returnMap;
    }

    /**
     * Execute a SOQL query to search for records 
     * 
     * @author Ashley Tran
     * @since 1.0
     * 
     * @param offset                    Integer: offset number to use in the SOQL query
     * @param pageSectionSettingList    List of page section settings to use for querying
     */
    protected virtual Map<String, Object> getMyNewslettersWithSoql(Integer offset, List<Portal_Page_Section_Setting__mdt> pageSectionSettingList) { 
        Map<String, Object> returnMap = new Map<String, Object>();

        if (pageSectionSettingList == null || pageSectionSettingList.isEmpty() == true) {
            return returnMap;
        }

        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList); 

        // PageSectionSetting.Max_Number_of_Query_Records__c controls the LIMIT clause
        //      if it's 0 or null, then the dynamic query will not have a LIMIT clause
        //      else, pass max+1 to the dynamic query to figure out if there are more available records
        Integer maxNumberOfQueryRecords = (Integer) PORTAL_UTIL_PageSectionSetting.getFieldsForQuery(pageSectionSettingList, new Set<String>())?.get(MAX_ITEMS_KEY);
        if (maxNumberOfQueryRecords != null && maxNumberOfQueryRecords != 0) {
            ++maxNumberOfQueryRecords;
        }

        Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> dynamicQueryMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>();
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass offsetClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass(null, null, null, null, maxNumberOfQueryRecords, offset, false);
        dynamicQueryMap.put(SUBMITTED_NEWSLETTER_MAIN_SECTION, offsetClass);
        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(UserInfo.getUserId(), pageSectionMap, dynamicQueryMap, false, false);
       
        Integer recordListSize = recordsMap?.get(SUBMITTED_NEWSLETTER_MAIN_SECTION)?.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY)?.size();
        Boolean hasMoreRecords = maxNumberOfQueryRecords > 0 && maxNumberOfQueryRecords == recordListSize;
        if (hasMoreRecords) {
            recordsMap.get(SUBMITTED_NEWSLETTER_MAIN_SECTION).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY).remove(recordListSize - 1);
        }

        returnMap.put(RECORDS_MAP_KEY, recordsMap);
        returnMap.put(HAS_MORE_RECORDS, hasMoreRecords);
        return returnMap;
    }

    /**
     * Execute a SOSL query to search for records with the user inputted search text 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param offset                    Integer: offset number to use in the SOSL query
     * @param searchText                String: user input text to use in a SOSL query FIND clause
     * @param pageSectionSettingList    List of page section settings to use for querying
     */
    protected virtual Map<String, Object> getMyNewslettersWithSosl(Integer offset, String searchText, List<Portal_Page_Section_Setting__mdt> pageSectionSettingList) {
        Map<String, Object> returnMap = new Map<String, Object>();
        if (searchText == null || searchText.length() < MINIMUM_SOSL_SEARCH_LENGTH || pageSectionSettingList == null || pageSectionSettingList.isEmpty() == true) {
            return returnMap;
        }

        Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> dynamicQueryMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{
            SUBMITTED_NEWSLETTER_MAIN_SECTION => new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass(null, null, null, null, null, offset, false)
        };

        Map<String, Object> queryClauseMap = PORTAL_UTIL_PageSectionSetting.getQueryClauseMap(UserInfo.getUserId(), SUBMITTED_NEWSLETTER_MAIN_SECTION, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList), dynamicQueryMap, false);

        String limitClause = (String) queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.LIMIT_CLAUSE);
        String limitNumberString = limitClause.toLowerCase().remove(LOWERCASE_LIMIT).trim();
        Integer limitNumber = null;
        if (String.isNotBlank(limitNumberString) == true && Integer.valueOf(limitNumberString) > 0) {
            limitNumber = Integer.valueOf(limitNumberString) + 1;
            limitClause = LOWERCASE_LIMIT + ' ' + limitNumber;
        }

        List<SObject> sObjectList = executeSoslQuery(queryClauseMap, String.escapeSingleQuotes(searchText), limitClause);

        Boolean hasMoreRecords = limitNumber > 0 && limitNumber == sObjectList.size();
        if (hasMoreRecords) {
            sObjectList.remove(sObjectList.size() - 1);
        }

        returnMap.put(RECORDS_MAP_KEY, convertSObjectToMap(sObjectList, SUBMITTED_NEWSLETTER_MAIN_SECTION));
        returnMap.put(HAS_MORE_RECORDS, hasMoreRecords);

        return returnMap;
    }

    /**
     * Given a query clause map (obtained with a helper in PORTAL_UTIL_PageSectionSetting) and search text
     * Execute a SOSL query and return the SObject results
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param queryClauseMap        Map<String, Object> of the various clauses in a query
     * @param escapedSearchText     String to search for, has its single quotes escaped
     * @param limitClauseOverride   String to use for the limit clause, overrides custom metadata and allows identifying if there are more results available
     * 
     * @return List of SObject records returned by the query 
     */
    @TestVisible
    protected virtual List<SObject> executeSoslQuery(Map<String, Object> queryClauseMap, String escapedSearchText, String limitClauseOverride) {
        List<SObject> emptyList = new List<SObject>();

        if (queryClauseMap == null || queryClauseMap.isEmpty() == true || String.isBlank(escapedSearchText) == true || escapedSearchText.length() < MINIMUM_SOSL_SEARCH_LENGTH) {
            return emptyList;
        }

        String sObjectToQuery = ((String) queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.FROM_CLAUSE)).toLowerCase().remove(LOWERCASE_FROM);
        String fieldClause = (String) queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.FIELD_CLAUSE);
        String whereClause = (String) queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.WHERE_CLAUSE);
        String orderByClause = (String) queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.ORDER_BY_CLAUSE);
        String limitClause = limitClauseOverride == null ? '' : limitClauseOverride;
        String offsetClause = (String) queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.OFFSET_CLAUSE);
        List<String> clauseList = new List<String>{fieldClause, whereClause, orderByClause, limitClause, offsetClause}; // order matters

        String soslQuery = 'FIND \'' + escapedSearchText + '*\' IN ALL FIELDS RETURNING ' + sObjectToQuery + '(' + String.join(clauseList, ' ') + ')';
        List<List<SObject>> searchResults = Search.query(soslQuery);

        if (searchResults == null || searchResults.isEmpty() || searchResults.get(0) == null || searchResults.get(0).isEmpty()) {
            return emptyList;
        }

        return searchResults.get(0); 
    }

    /**
     * Convert a list of SObject records into a Map structure emulating what PORTAL_UTIL_PageSectionSetting.queryForRecords() returns
     * This method assumes there's only one main section and no sub sections in the page
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param sObjectList       List of SObject records to convert to a map
     * @param mainSectionName   String name of main section (from page section setting metadata) 
     * 
     * @return Map data structure copying what queryForRecords() creates, containing the sObjects in map form 
     */
    protected virtual Map<String, Map<String, List<Map<String, Object>>>> convertSObjectToMap(List<SObject> sObjectList, String mainSectionName) {
        if (sObjectList == null) {
            return null;
        }

        List<Map<String, Object>> recordsList = new List<Map<String, Object>>();
        for (SObject eachRecord : sObjectList) {
            recordsList.add((Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(eachRecord)));
        }

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = new Map<String, Map<String, List<Map<String, Object>>>>();
        recordsMap.put(mainSectionName, new Map<String, List<Map<String, Object>>>{PORTAL_CONST_PageSectionSetting.RECORD_KEY => recordsList});
        return recordsMap;
    }

    /**
    * method that gets the current organization's name to display in the footer
    *
    * @author:                                 Sam Longo
    * @since:                                  1.0
    */
    public String getOrganizationName() {
        return PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => ORGANIZATION_METADATA_DEVELOPER_NAME});
    }

    /**
    * method that sends a test version of a newsletter
    *
    * @param listing:                          The sample newsletter
    * @param email:                            The string version of a list of emails to send the test newsletter to
    * @param newsletterSectionList:            The optional list of newsletter sections for a particular listing
    *
    * @author:                                 Sam Longo
    * @since:                                  1.0
    */

    public virtual void sendTestNewsletter(Map<String, Object> params) {

        if (params.containsKey(LISTING_KEY) && params.containsKey(EMAIL_KEY)) {
            ucinn_portal_Listing__c listing = (ucinn_portal_Listing__c) System.JSON.deserialize(System.JSON.serialize(params.get(LISTING_KEY)), ucinn_portal_Listing__c.class);
            String emailString = (String) params.get(EMAIL_KEY);
            if (String.isBlank(emailString) || String.isBlank(listing.Subject_Line__c)) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There were invalid parameters.'});
            }

            List<String> emailList = emailString.split(';');
            if (emailList.size() > 10) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There are too many email addresses.'});
            }

            if (String.isBlank(listing.Id)) {
                listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(NEWSLETTER_RECORD_TYPE).getRecordTypeId();
                listing.Status__c = TEMPORARY_STATUS;
                upsert listing;
            }

            if (params.containsKey(NEWSLETTER_SECTIONS_LIST_KEY)) {
                List<ucinn_portal_Newsletter_Section__c> newsletterSectionList = (List<ucinn_portal_Newsletter_Section__c>) System.JSON.deserialize(System.JSON.serialize(params.get(NEWSLETTER_SECTIONS_LIST_KEY)), List<ucinn_portal_Newsletter_Section__c>.class);
                for (ucinn_portal_Newsletter_Section__c section : newsletterSectionList) {
                    if (String.isBlank(section.Newsletter_Listing__c)) {
                        section.Newsletter_Listing__c = listing.Id;
                    }
                }

                upsert newsletterSectionList;
            }


            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setToAddresses(emailList);
            emailMessage.saveAsActivity = false;
            emailMessage.setBccSender(false);
            emailMessage.setUseSignature(false);
            emailMessage.setSubject(listing.Subject_Line__c);

            emailMessage.setHtmlBody(parseNewsletterHtml(new Map<String, Object>{NEWSLETTER_ID_KEY => listing.Id}));

            if (!Test.isRunningTest()) {
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailMessage});
            }
        }
    }


    /**
    * method that gets the portal zone for a listing to show on the front end
    *
    * @param newsletterId:                     The id of the newsletter we are trying get the portal zone for
    *
    * @author:                                 Ashley Tran
    * @since:                                  1.0
    */
    public virtual String getPortalZoneForListing(Map<String, Object> params) {
        String newsletterId = (String) params?.get(NEWSLETTER_ID_KEY);
        if (String.isNotBlank(newsletterId)) {
            return [SELECT Portal_Zone__c FROM ucinn_portal_Listing__c WHERE Id = :newsletterId]?.Portal_Zone__c;
        }
        return '';
    }

    public virtual void updateNewsletterMetrics(Map<String, Object> params) {
        String campaignId = (String)params.get(CAMPAIGN_ID);

        if (String.isBlank(campaignId)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => NO_NEWSLETTER_ERROR});
        }

        Database.executeBatch(new PORTAL_BATCH_UpdateNewsletterMetrics(campaignId), 1);
    }
}