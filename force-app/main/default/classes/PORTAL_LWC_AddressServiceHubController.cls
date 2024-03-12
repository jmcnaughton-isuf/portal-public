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
 * Controller that exposes AddressServiceHubControllerBase Apex functions to LWCs 
 * that use address services like autocomplete/typeahead
 *
 * @author          Jacob Huang
 * @version         1.0
 * @since           1.0
 */
public inherited sharing class PORTAL_LWC_AddressServiceHubController {
    
    public static final String ERROR_UNEXPECTED = 'Unexpected Address Service Error. Please contact an administrator.';

    /**
     * Get configuration values for an international address autocomplete service, only needed for Smarty Streets
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param params        Map<String, Object>: no params are used yet
     * 
     * @return Map with configuration values for Smarty Streets international autocomplete, or an empty map if not using Smarty Streets
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getInternationalAutocompleteConfigurationMap(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_AddressServiceHubControllerBase controller = (PORTAL_AddressServiceHubControllerBase)PORTAL_Utils.getControllerFactory().getAddressServiceHubController();
            return controller.getInternationalAutocompleteConfigurationMap(params);
        }
        catch (AuraHandledException ahe) {
            throw ahe;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_UNEXPECTED,
                                                                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Given autocomplete arguments as input, use some address autocomplete service and return a list of suggested addresses
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param searchInput       String: user input string to try to autocomplete
     * @param searchSelection   String: for Smarty Streets: when the user selects a suggestion with multiple address line 2 options, need another callout for resolution
     * @param country           String: specifies which country the autocomplete service should search in
     * @param maxResults        String or Integer: max number of results in response, converted to Integer
     * 
     * @return List of AutocompleteAddressWrappers, each wrapper has various address fields populated with autocomplete suggestions
     */
    @AuraEnabled
    public static List<PORTAL_AutocompleteAddressWrapper> SERVER_getAutocompleteSuggestions(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_AddressServiceHubControllerBase controller = (PORTAL_AddressServiceHubControllerBase)PORTAL_Utils.getControllerFactory().getAddressServiceHubController();
            return controller.getAutocompleteSuggestions(params);
        }
        catch (AuraHandledException ahe) {
            throw ahe;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_UNEXPECTED,
                                                                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}