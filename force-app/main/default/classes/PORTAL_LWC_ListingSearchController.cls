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
 * LWC Controller for portal_LWC_ListingSearch
 *
 * @author Aaron Wong
 * @version     1.0
 * @since       1.0
 */
public inherited sharing virtual class PORTAL_LWC_ListingSearchController {
    public static final String ERROR_CONTACT_ADMIN = 'There was an issue retrieving content. Please contact an administrator.';

    /**
    * method that gets picklist values for listings to display and choose from on the front end
    *
    *
    * @author: Sam Longo
    * @since: 1.0
    *
    *
    * @return                            the map of field APIs to list of picklist value strings
    */
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Map<String, String>>> SERVER_getPicklists(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ListingControllerBase controller = (PORTAL_ListingControllerBase)PORTAL_Utils.getControllerFactory().getListingController();
            return controller.getPicklists(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ListingSearchController.class.getName());
            throw ahe;
        }
         catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ListingSearchController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Gets listing records with a specific key word.
     *
     * @author Aaron Wong
     *
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param mainSectionName           Main Section Name of the Portal Page Section Setting to use.
     * @param subSectionName            Sub Section Name of the Portal Page Section Setting to use.
     * @param keyword                   Keyword to search for.
     * @param category                  The category to search for.
     * @param location                  The location to search for.
     * @param offset                    The query offset for pagination purposes
     * @return                          List of listings.
     * @since                           1.0
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_searchListings(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ListingControllerBase controller = (PORTAL_ListingControllerBase)PORTAL_Utils.getControllerFactory().getListingController();

            return controller.searchListings(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ListingSearchController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ListingSearchController.class.getName());
            System.debug(e);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }
}