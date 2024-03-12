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
 * Contains utility functions for Listing Lightning Web Component
 * controllers.
 *
 * @author      Andrew Leon
 * @version     1.0
 */
public without sharing class PORTAL_UTIL_Listing {
    public static final String PARAMS_RECORD_ID = 'recordId';

    public static final String RECORD_ID_FIELD = 'newRecordId';
    public static final String BASE_URL_FIELD = 'baseUrl';


    /**
    * Returns a mapping that can be used to create a URL to the provided
    * record ID.
    *
    * @author           Andrew Leon
    *
    * @param  recordId  The Id of the Listing.
    *
    * @return           The Listing.
    *
    * @since            1.0
    * */
    public static Map<String, Object> createRedirectMap(Map<String,Object> params) {
        String recordId = (String)params.get(PARAMS_RECORD_ID);

        Map<String, Object> resultMap = new Map<String, Object>();
        resultMap.put(RECORD_ID_FIELD, recordId);
        URL request = URL.getCurrentRequestUrl();
        String urlString = request.toExternalForm();
        String host = request.getHost();
        resultMap.put(BASE_URL_FIELD, urlString.substringBefore(host) + host);

        return resultMap;
    }

    /**
    * Returns the Listing associated with the provided record Id and all its
    * fields.
    *
    * @author           Andrew Leon
    *
    * @param  recordId  The Id of the Listing.
    *
    * @return           The Listing.
    *
    * @since            1.0
    * */
    public static ucinn_portal_Listing__c queryListingAllFields(Map<String,Object> params) {
        String recordId = (String)params.get(PARAMS_RECORD_ID);
        List<DescribeSObjectResult> describeResultList = Schema.describeSObjects(
                                                         new String[]{PORTAL_CONST_Listing.LISTING});

        if (describeResultList == null || describeResultList.isEmpty()) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE =>
                                                        'Could not retrieve metadata information about the Listing ' +
                                                        'Object. Check that the Listing Object exists and the current user ' +
                                                        'has the correct permissions to retrieve its metadata information.',
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        List<String> fieldNames = new List<String>(describeResultList[0].fields.getMap().keySet());

        String queryString = ' SELECT ' + String.join(fieldNames, ',') +
                             ' FROM ' + PORTAL_CONST_Listing.LISTING + ' WHERE Id = \'' + recordId + '\'';
        List<ucinn_portal_Listing__c> listingList = Database.query(queryString);

        if (listingList == null || listingList.isEmpty()) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_CONST_Listing.EMPTY_RECORD_QUERY_RESULT_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        return listingList[0];
    }

}