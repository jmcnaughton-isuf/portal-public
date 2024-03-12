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
 * Base controller that uses an AddressServiceInterface to make API callouts to get information about addresses
 *
 * @author          Jacob Huang
 * @version         1.0
 * @since           1.0
 */
public inherited sharing class PORTAL_AddressServiceHubControllerBase {
    private static PORTAL_AddressServiceInterface autocompleteService;
    private static String autocompleteProvider;

    public static final String SMARTY_STREETS = 'SmartyStreets';
    public static final String ADDRESS_SERVICE_PROVIDER = 'Address Service Provider';
    public static final String ERROR_INVALID_PROVIDER = 'Invalid Address Service Provider. Please contact an administrator.';

    /**
     * Constructor that sets the necessary interface(s) for API calls
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public PORTAL_AddressServiceHubControllerBase() {
        setAutocompleteService();
    }

    /**
     * Set the AddressServiceInterface to be used for autocomplete
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public virtual void setAutocompleteService() {
        if (autocompleteService != null) {
            return;
        }

        PORTAL_AddressServiceHubControllerBase.autocompleteProvider = getAutocompleteProvider();
        if (PORTAL_AddressServiceHubControllerBase.autocompleteProvider == SMARTY_STREETS) {
            autocompleteService = (PORTAL_SmartyStreetsAddressService)PORTAL_Utils.getControllerFactory().getSmartyStreetAddressService();
        }
        else {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INVALID_PROVIDER});
        }
    }

    /**
     * Read Address Service Providers Custom Setting to see which service to use for address autocomplete
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @return string value of Autocomplete Provider field, null if custom setting is missing
     */
    public virtual String getAutocompleteProvider() {
        ucinn_ascendv2__Address_Service_Providers__c provider = ucinn_ascendv2__Address_Service_Providers__c.getInstance(ADDRESS_SERVICE_PROVIDER);
        return provider?.ucinn_ascendv2__Autocomplete_Provider__c;
    }

    /**
     * Read Address Service Providers Custom Setting to see which service to use for address verification
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     * 
     * @return  gets Verification Provider field value
     */
    public virtual String getAddressVerificationProvider() {
        ucinn_ascendv2__Address_Service_Providers__c provider = ucinn_ascendv2__Address_Service_Providers__c.getInstance(ADDRESS_SERVICE_PROVIDER);
        return provider?.ucinn_ascendv2__Verification_Provider__c;
    }

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
    public virtual Map<String, Object> getInternationalAutocompleteConfigurationMap(Map<String, Object> params) {
        Map<String, Object> configurationMap = new Map<String, Object>();
        if (PORTAL_AddressServiceHubControllerBase.autocompleteProvider == SMARTY_STREETS) {
             configurationMap = ((PORTAL_SmartyStreetsAddressService) autocompleteService).getInternationalAutocompleteConfigurationMap(params);
        }
        
        return configurationMap;
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
    public virtual List<PORTAL_AutocompleteAddressWrapper> getAutocompleteSuggestions(Map<String, Object> params) {
        return autocompleteService.getAutocompleteSuggestions(autocompleteService.buildAutocompleteQuery(params));
    }
}