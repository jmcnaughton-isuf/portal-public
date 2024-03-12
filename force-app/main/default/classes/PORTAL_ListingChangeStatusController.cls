/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
 *
 * This source code is licensed, not sold, and is subject to a written
 * license agreement.  Among other things, no portion of this source
 * code may be copied, transmitted, disclosed, displayed, distributed,
 * translated, used as the basis for a derivative work, or used, in
 * whole or in part, for any program or purpose other than its intended
 * use in compliance with the license agreement as part of UC Innovation'
 * software.  This source code and certain of the algorithms contained
 * within it are confidential trade secrets of UC Innovation, Inc.f
 * and may not be used as the basis for any other
 * software, hardware, product or service.
 */

/**
 * Provides server side functionality to
 * portal_quickaction_ListingChangeStatus Lightning Web Component.
 *
 * @author      Andrew Leon
 * @version     1.0
 */
public inherited sharing class PORTAL_ListingChangeStatusController {
    static final String PARAMS_RECORD_ID = 'recordId';
    static final String PARAMS_MASTER_RECORD_ID = 'masterRecordId';
    static final String PARAMS_NEW_STATUS = 'newStatus';

    static final String STATUS_FIELD = 'Status__c';
    static final String PICKLIST_VALUES_FIELD = 'picklistOptions';
    static final String CURRENT_STATUS_FIELD = 'currentOption';
    static final String PICKLIST_ENTRIES_FIELD = 'picklistEntries';

    static final String INVALID_RECORD_ID_ERROR         = 'Please provide a valid Record ID.';
    static final String INVALID_STATUS_ERROR            = 'Please provide a valid Status value.';
    static final String CHANGE_STATUS_TO_DRAFT_ERROR    = 'You cannot change a Listing\'s status to \'Draft\' ' +
                                                          'with the \'Change Status\' Quick Action button. Please ' +
                                                          'use the \'Create Draft\' Quick Action button instead.';


    /**
    * Sets the Status field of the provided recordId's associated Listing
    * to the provided Status value. Throws an AuraHandledException if the newStatus
    * is 'Draft'.
    *
    * @author           Andrew Leon
    *
    * @param recordId   The Id of the Listing whose Status field is to be
    *                   set.
    *
    * @param newStatus  The Status to set the Listing to.
    *
    * @return           Contains the recordId and base URL of the Listing.
    *
    * @since            1.0
    * */
    @AuraEnabled
    public static Map<String, Object> SERVER_saveStatus(Map<String,Object> params) {
        if (params == null || params.isEmpty()) {
            return new Map<String, Object>();
        }

        String recordId = (String)params.get(PARAMS_RECORD_ID);
        String newStatus = (String)params.get(PARAMS_NEW_STATUS);

        if (String.isBlank(recordId)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => INVALID_RECORD_ID_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        if (String.isBlank(newStatus)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => INVALID_RECORD_ID_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        if (newStatus == PORTAL_CONST_Listing.STATUS_DRAFT) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => CHANGE_STATUS_TO_DRAFT_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        ucinn_portal_Listing__c listing = null;
        listing = queryListingAllFields(recordId);

        listing.Status__c = newStatus;
        update listing;
        return createRedirectMap(listing.Id);
    }

    /**
    * Merges the Draft listing associated with the given recordId with its
    * master Listing.
    *
    * @author           Andrew Leon
    *
    * @param recordId   The Id of the Draft Listing.
    *
    * @return           Contains the recordId and base URL of the original
    *                   master Listing.
    *
    * @since            1.0
    * */
    @AuraEnabled
    public static Map<String, Object> SERVER_saveDraft(Map<String,Object> params) {
        if (params == null || params.isEmpty()) {
            return new Map<String, Object>();
        }

        String recordId = (String)params.get(PARAMS_RECORD_ID);
        if (String.isBlank(recordId)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => INVALID_RECORD_ID_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        ucinn_portal_Listing__c listing = null;
        listing = queryListingAllFields(recordId);

        ucinn_portal_Listing__c masterListing = null;
        masterListing = queryListingAllFields(listing.Master_Listing__c);

        if (listing.Master_Listing__c != null &&
            listing.Status__c == PORTAL_CONST_Listing.STATUS_DRAFT) {
            listing.Id = listing.Master_Listing__c;
            listing.Status__c = masterListing.Status__c;
            listing.Master_Listing__c = null;
            update listing;
            delete new ucinn_portal_Listing__c (Id = recordId);
        } else {
            update listing;
        }

        return createRedirectMap(listing.Id);
    }

    /**
     * Returns a redirect map for the provided Listing record Id.
     */
    private static Map<String,Object> createRedirectMap(String recordId) {
        Map<String,Object> createRedirectMapParams = new Map<String,Object>();
        createRedirectMapParams.put(PORTAL_UTIL_Listing.PARAMS_RECORD_ID, recordId);
        return PORTAL_UTIL_Listing.createRedirectMap(createRedirectMapParams);
    }

    /**
     * Returns the Listing associated with the provided recordId with all of its field data.
     */
    private static ucinn_portal_Listing__c queryListingAllFields(String recordId) {
        Map<String,Object> queryListingAllFieldsParams = new Map<String,Object>();
        queryListingAllFieldsParams.put(PORTAL_UTIL_Listing.PARAMS_RECORD_ID, recordId);

        return PORTAL_UTIL_Listing.queryListingAllFields(queryListingAllFieldsParams);
    }
}