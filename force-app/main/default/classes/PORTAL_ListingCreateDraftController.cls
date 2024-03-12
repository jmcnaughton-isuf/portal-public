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
 * Provides server side functionality to
 * portal_quickaction_ListingCreateDraft lightning web component.
 *
 * @author      Andrew Leon
 * @version     1.0
 */
public inherited sharing class PORTAL_ListingCreateDraftController {
    static final String PARAMS_MASTER_RECORD_ID   = 'masterRecordId';

    static final String RECORD_ID_FIELD           = 'newRecordId';
    static final String BASE_URL_FIELD            = 'baseUrl';

    static final String MISSING_MASTER_LISTING    = 'Could not query for the Master Listing with the provided' +
                                                    'Master Listing Id.';

    /**
    * Creates a copy of the current listing with Status='Draft' and no
    * related records.
    *
    * @author                 Andrew Leon
    *
    * @param masterRecordId   The Id of the Listing that's used to create a
    *                         draft.
    *
    * @return                 Contains the recordId ('newRecordId') and base URL ('baseUrl') of the
    *                         newly created Listing.
    *
    * @since                  1.0
    * */
    @AuraEnabled
    public static Map<String, Object> SERVER_createDraft(Map<String,Object> params) {
        if (params == null || params.isEmpty()) {
            return new Map<String, Object>();
        }

        String masterRecordId = (String)params.get(PARAMS_MASTER_RECORD_ID);
        if (String.isBlank(masterRecordId)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => MISSING_MASTER_LISTING,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        ucinn_portal_Listing__c masterListing = null;
        try {
            masterListing = queryListingAllFields(masterRecordId);
        } catch(AuraHandledException e) {
            throw e;
        }

        // Clone the Master Listing with no related records (or an Id).
        ucinn_portal_Listing__c draft = masterListing.clone(false, false, false, false);

        draft.Status__c = PORTAL_CONST_Listing.STATUS_DRAFT;
        draft.Master_Listing__c = masterListing.Id;

        // Ensure the cloned 'Draft' Listing has an Id.
        ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c();
        insert newListing;
        draft.Id = newListing.Id;
        update draft;

        return createRedirectMap(draft.Id);
    }

    /**
     * Returns the Listing associated with the provided recordId with all of its field data.
     */
    private static ucinn_portal_Listing__c queryListingAllFields(String recordId) {
        Map<String,Object> queryListingAllFieldsParams = new Map<String,Object>();
        queryListingAllFieldsParams.put(PORTAL_UTIL_Listing.PARAMS_RECORD_ID, recordId);

        return PORTAL_UTIL_Listing.queryListingAllFields(queryListingAllFieldsParams);
    }

    /**
     * Returns a redirect map for the provided Listing record Id.
     */
    private static Map<String,Object> createRedirectMap(String recordId) {
        Map<String,Object> createRedirectMapParams = new Map<String,Object>();
        createRedirectMapParams.put(PORTAL_UTIL_Listing.PARAMS_RECORD_ID, recordId);
        return PORTAL_UTIL_Listing.createRedirectMap(createRedirectMapParams);
    }
}