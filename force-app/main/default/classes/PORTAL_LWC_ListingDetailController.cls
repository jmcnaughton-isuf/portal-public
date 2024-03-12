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
 * portal_ListingDetails_Data Lightning Web Component.
 *
 * @author      Andrew Leon
 * @version     1.0
 */
public inherited sharing virtual class PORTAL_LWC_ListingDetailController {
    public static String PARAMS_RECORD_ID = 'recordId';
    public static String PARAMS_RECORD_NAME = 'recordName';
    public static final String ERROR_PARTICIPATION = 'There was an error retrieving the list of participants.';

    /**
    * Get the Listing information by its Id.
    *
    * @author           Andrew Leon
    *
    * @param recordId   The Listing's Id.
    *
    * @return           Contains the Listing information.
    *
    * @since            1.0
    * */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getListingDetailsById(Map<String,Object> params) {
        String recordId = (String)params.get(PARAMS_RECORD_ID);

        if (String.isBlank(recordId)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_CONST_LISTING.INVALID_RECORD_ID_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        PORTAL_ListingControllerBase baseController = (PORTAL_ListingControllerBase)PORTAL_Utils.getControllerFactory().getListingController();
        return baseController.getListingDetails(params);
    }

    /**
    * Get the Listing detail information by its Name.
    *
    * @author           Andrew Leon
    *
    * @param recordName The Listing's Name.
    *
    * @return           Contains the Listing information.
    *
    * @since            1.0
    * */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getListingDetailsByName(Map<String,Object> params) {
        String recordName = (String)params.get(PARAMS_RECORD_NAME);

        if (String.isBlank(recordName)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_CONST_LISTING.INVALID_RECORD_NAME_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        PORTAL_ListingControllerBase baseController = (PORTAL_ListingControllerBase)PORTAL_Utils.getControllerFactory().getListingController();
        return baseController.getListingDetails(params);
    }


    /**
    * Get the Profile Name of the User associated with the provided User Id.
    *
    * @author           Andrew Leon
    *
    * @param recordId  The User's Id.
    *
    * @return           Contains the Listing information.
    *
    * @since            1.0
    * */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getUserProfileName(Map<String,Object> params) {
        String userId = (String)params.get(PARAMS_RECORD_ID);

        if (String.isBlank(userId)) {
            AuraHandledException e = new AuraHandledException(PORTAL_CONST_Listing.AURA_HANDLED_EXCEPTION_MESSAGE);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_CONST_LISTING.INVALID_RECORD_ID_ERROR,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

        PORTAL_ListingControllerBase baseController = (PORTAL_ListingControllerBase)PORTAL_Utils.getControllerFactory().getListingController();
        return baseController.getUserProfile(params);
    }

    /**
     * Get listing fields needed for Look Who's Coming List and related participations that are going to be displayed on the list
     * 
     * @author Curtis Ung, Jacob Huang
     * @since 1.1
     * 
     * @param recordId      listing record id
     * @param recordName    listing name
     * 
     * @return listing record represented as a map, including the listing's list of participations
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getLookWhosComingList(Map<String,Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ListingControllerBase baseController = (PORTAL_ListingControllerBase) PORTAL_Utils.getControllerFactory().getListingController();
            return baseController.getLookWhosComingList(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler) PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ListingSearchController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler) PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ListingSearchController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                                                           PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_PARTICIPATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}