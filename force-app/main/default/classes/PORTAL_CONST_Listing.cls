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
 * Provides constant values for Listing Lightning Web Component controllers.
 *
 * @author      Andrew Leon
 * @version     1.0
 */
global without sharing class PORTAL_CONST_Listing {
    global final static String CATEGORY_API_NAME = 'Category__c';
    global final static String COUNTRY_API_NAME = 'Country__c';
    global final static String TOPIC_API_NAME = 'Recommend_Type_1__c';
    global final static String ARTICLE_LENGTH_API_NAME = 'Article_Length__c';
    global final static String FORMAT_API_NAME = 'Format__c';
    global final static String STATUS_API_NAME = 'Status__c';
    global final static String STATUS_PUBLISHED = 'Published';
    global final static String STATUS_DRAFT = 'Draft';
    global final static String LISTING = 'ucinn_portal_Listing__c';
    global final static String RECORD_TYPE_ID = 'RecordTypeId';
    global final static String EVENT = 'Event';
    global final static String NEWSLETTER = 'Newsletter';
    global final static String NEWS = 'News';

    global static final String LISTING_STATUS_TEMPORARY = 'Temporary';
    global static final String LISTING_STATUS_PENDING = 'Pending';
    global final static String LISTING_STATUS_PUBLISHED = 'Published';

    global final static String AURA_HANDLED_EXCEPTION_MESSAGE  = 'I\'m just here to get the stack trace.';
    global final static String EMPTY_RECORD_QUERY_RESULT_ERROR = 'Could not retrieve the Record ID\'s corresponding ' +
                                                                 'Listing. Make sure the Record ID is valid and the ' +
                                                                 'current user can view the associated Listing.';

    global final static String DEBUG_KEY_NAME = 'Debug_AES_Key'; // switch once it's in COMMUNITY_UTILS
    global final static String INVALID_RECORD_ID_ERROR         = 'Please provide a valid Record ID.';
    global final static String INVALID_RECORD_NAME_ERROR = 'Please provide a valid Record Name.';

    global final static String MODIFY_REGISTRATION_TEXT_DEFAULT = 'Modify Registration';
    global final static String REGISTER_TEXT_DEFAULT = 'Register';
    global final static String SOLD_OUT_TEXT_DEFAULT = 'Sold Out';
    global final static String VIEW_EVENT_TEXT_DEFAULT = 'View Event';
    global final static String LOOK_WHOS_COMING_TEXT_DEFAULT = 'Look Who\'s Coming';

    global final static String ORG_SETTING_EVENT_MODIFY_REGISTRATION_TEXT = 'Event_Modify_Registration_Text';
    global final static String ORG_SETTING_EVENT_REGISTER_TEXT = 'Event_Register_Text';
    global final static String ORG_SETTING_EVENT_SOLD_OUT_TEXT = 'Event_Sold_Out_Text';
    global final static String ORG_SETTING_EVENT_VIEW_EVENT_TEXT = 'Event_View_Event_Text';
    global final static String ORG_SETTING_EVENT_LOOK_WHOS_COMING_TEXT  = 'Event_Look_Whos_Coming_Text';

    global final static List<String> ORG_SETTING_BUTTON_TEXT_DEVELOPER_NAMES = new List<String>{ORG_SETTING_EVENT_REGISTER_TEXT,
                                                                                                ORG_SETTING_EVENT_MODIFY_REGISTRATION_TEXT,
                                                                                                ORG_SETTING_EVENT_SOLD_OUT_TEXT,
                                                                                                ORG_SETTING_EVENT_VIEW_EVENT_TEXT,
                                                                                                ORG_SETTING_EVENT_LOOK_WHOS_COMING_TEXT};

    global final static Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String> LOCATION_FIELD_MAPPING = new Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String>{
        PORTAL_AddressWrapper.ADDRESS_FIELD.STREET1 => 'Street__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.CITY => 'City__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.STATE => 'State__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.COUNTRY => 'Country__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.POSTCODE => 'Postal_Code__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.GEOLOCATION => 'Geolocation__c'
    };
}