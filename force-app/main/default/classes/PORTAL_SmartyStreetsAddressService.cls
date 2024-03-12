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
 * Address Service implementation for Smarty Streets (aka Smarty)
 * some logic based on ascend_ADDR_SmartyStreets
 * 
 * @author          Jacob Huang
 * @version         1.0
 * @since           1.0
 */
public inherited sharing virtual class PORTAL_SmartyStreetsAddressService extends PORTAL_AddressServiceInterface {

    private static Boolean hasInternationalAutocomplete;

    // constants for authentication
    public static final String EXTERNAL_API_CREDENTIAL = 'ucinn_ascendv2__External_API_Credential__mdt';
    public static final String US_AUTOCOMPLETE_AUTH_ID = 'SmartyStreet_Autocomplete_Auth_Id';
    public static final String US_AUTOCOMPLETE_AUTH_TOKEN = 'SmartyStreet_Autocomplete_Auth_Token';
    public static final String INTERNATIONAL_AUTOCOMPLETE_AUTH_ID = 'SmartyStreet_Int_Autocomp_Auth_Id';
    public static final String INTERNATIONAL_AUTOCOMPLETE_AUTH_TOKEN = 'SmartyStreet_Int_Autocomp_Auth_Token';
    public static final String VALUE_C = 'ucinn_ascendv2__Value__c';
    public static final String DEVELOPER_NAME = 'DeveloperName';

    // constants for international configuration
    public static final String BIO_DEMO_SETTING_MDT = 'ucinn_ascendv2__Bio_Demo_Setting__mdt';
    public static final String BIO_DEMO_SETTING = 'Bio_Demo_Setting';
    public static final String COUNTRY_CODE_MAP_C = 'ucinn_ascendv2__SmartyStreets_Country_Code_Map__c';
    public static final String DEFAULT_COUNTRY_C = 'ucinn_ascendv2__SmartyStreets_Default_Country_v1__c';
    public static final String ENABLE_INTERNATIONAL_AUTOCOMPLETE_C = 'ucinn_ascendv2__Enable_International_Autocomplete__c';
    public static final String COUNTRY_CODE_MAP = 'countryCodeMap';
    public static final String DEFAULT_COUNTRY = 'defaultCountry';
    public static final String HAS_INTERNATIONAL_AUTOCOMPLETE = 'hasInternationalAutocomplete';
    public static final String TEST_COUNTRY_CODE_MAP = '{"Albania": "ALB", "United States":""}';
    // values taken from ascend code
    public static final Set<String> US_NAMES_SET = new Set<String>{'us', 'u.s.', 'u.s', 'usa', 'u.s.a.', 'u.s.a', 'united states', 'united states of america'};

    // constants for callout query/response
    public static final String AUTH_ID = 'auth-id';
    public static final String AUTH_TOKEN = 'auth-token';
    public static final String SEARCH_CONST = 'search';
    public static final String SELECTED_CONST = 'selected';
    public static final String COUNTRY_CONST_REQUEST = 'country';
    public static final String MAX_RESULTS = 'max_results';
    // per ascend: 5 is consistent with Google, which doesn't have a variable value for this
    public static final Integer DEFAULT_MAX = 5;
    public static final String UTF_8 = 'UTF-8';
    public static final String US_AUTOCOMPLETE_ENDPOINT = 'https://us-autocomplete-pro.api.smartystreets.com/lookup';
    public static final String INTERNATIONAL_AUTOCOMPLETE_ENDPOINT = 'https://international-autocomplete.api.smartystreets.com/lookup';
    public static final String HTTP_GET = 'GET';
    public static final String UNITED_STATES = 'United States';
    public static final String ERRORS_CONST = 'errors';
    public static final String MESSAGE_CONST = 'message';
    public static final String TEST_CONST = 'testing123';
    public static final String ERROR_AUTHENTICATION = 'SmartyStreets Authentication Error. Please contact an administrator.';
    public static final String ERROR_BIO_DEMO = 'Unable to access bio/demo settings. Please contact an administrator.';
    public static final String ERROR_NO_SEARCH_INPUT = 'No search input'; 
    public static final String ERROR_UNEXPECTED = 'Unexpected SmartyStreets Error. Please contact an administrator.';

    // Constants for Verification
    public static final String US_VERIFICATION_ENDPOINT = 'https://us-street.api.smartystreets.com/street-address?';
    public static final String INTERNATIONAL_VERIFICATION_ENDPOINT = 'https://international-street.api.smartystreets.com/verify?';
    public static final String SMARTYSTREETS_LICENSE_TYPE_C = 'ucinn_ascendv2__SmartyStreets_License_Type__c';
    public static final String SMARTYSTREETS_MATCH_METHOD_C = 'ucinn_ascendv2__SmartyStreets_Match_Method__c';
    public static final String SMARTYSTREETS_US_ADDRESS_SEARCH_MAP_C = 'ucinn_ascendv2__SmartyStreets_US_Address_Search_Map__c';
    public static final String SMARTYSTREETS_INT_ADDRESS_SEARCH_MAP_C = 'ucinn_ascendv2__SmartyStreets_Int_Address_Search_Map__c';
    public static final String ADDRESS_SOBJECT_API_NAME = 'ucinn_ascendv2__Address__c';
    public static final String ADDRESS_COUNTRY_FIELD_API_NAME = 'ucinn_ascendv2__Country__c';
    public static final String LICENSE_TYPE = 'licenseType';
    public static final String MATCH_METHOD = 'matchMethod';
    public static final String US_ADDRESS_SEARCH_MAP = 'usAddressSearchMap';
    public static final String INT_ADDRESS_SEARCH_MAP = 'intAddressSearchMap';
    public static final String ADDRESS_INFORMATION = 'addressInformation';
    public static final String LATITUDE_CONST = 'latitude';
    public static final String LONGITUDE_CONST = 'longitude';
    public static final String COMPONENTS_CONST = 'components';
    public static final String METADATA_CONST = 'metadata';
    public static final String ANALYSIS_CONST = 'analysis';

    /**
     * Helper class for converting Smarty Streets Autocomplete HTTP response string to an object
     * Suggestion is the US API response, Candidate is the international API response
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public class AutocompleteResponse {
        public List<Suggestion> suggestions;
        public List<Candidate> candidates;
    }

    /**
     * Helper class for converting Smarty Streets US Autocomplete HTTP response string to an object
     * The actual address suggestion fields/values live here
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public class Suggestion {
        // fields directly mapped to Smarty Streets HTTP response JSON
        public String street_line;
        public String secondary;
        public String city;
        public String state;
        public String zipcode;
        public Integer entries;
        // fields with values derived from others
        public String id;
        public String label;

        /**
         * Convert the Suggestion object/fields to PORTAL_AutocompleteAddressWrapper
         * Note: Smarty Streets US will return an empty string for fields like secondary if the field value doesn't exist
         * 
         * @author Jacob Huang
         * @since 1.0
         * 
         * @return Autocomplete Address Wrapper populated with the same values as this Suggestion 
         */
        public PORTAL_AutocompleteAddressWrapper getAddressWrapper() {
            Map<Object, Object> addressMap = new Map<Object, Object>{
                PORTAL_AddressWrapper.STREET_LINE_1 => street_line,
                PORTAL_AddressWrapper.STREET_LINE_2 => secondary,
                PORTAL_AddressWrapper.CITY_CONST => city,
                PORTAL_AddressWrapper.STATE_CONST => state,
                PORTAL_AddressWrapper.COUNTRY_CONST => UNITED_STATES,
                PORTAL_AddressWrapper.POSTAL_CODE => zipcode,
                PORTAL_AutocompleteAddressWrapper.ID_CONST => id,
                PORTAL_AutocompleteAddressWrapper.LABEL_CONST => label,
                PORTAL_AutocompleteAddressWrapper.NUMBER_OF_SIMILAR_ENTRIES => entries
            };

            return new PORTAL_AutocompleteAddressWrapper(addressMap);
        }
    }

    /**
     * Helper class for converting Smarty Streets International Autocomplete HTTP response string to an object
     * The actual address suggestion fields/values live here
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public class Candidate {
        // fields directly mapped to Smarty Streets HTTP response JSON
        public String street;
        public String locality;
        public String administrative_area;
        // possible future TODO: some countries use sub_administrative_area (China, etc.) or super_administrative_area (France, etc.) to supplement administrative_area
        //                       these fields are not in Smarty Streets documentation so they are considered "experimental" fields 
        public String postal_code;
        public String country_iso3;
        // fields with values derived from others
        public String id;
        public String label;

        /**
         * Convert the Candidate object/fields to PORTAL_AutocompleteAddressWrapper
         * Note: Smarty Streets International will omit fields from the response if the field value doesn't exist
         * 
         * @author Jacob Huang
         * @since 1.0
         * 
         * @return Autocomplete Address Wrapper populated with the same values as this Candidate 
         */
        public PORTAL_AutocompleteAddressWrapper getAddressWrapper() {
            Map<Object, Object> addressMap = new Map<Object, Object>{
                PORTAL_AddressWrapper.STREET_LINE_1 => street,
                PORTAL_AddressWrapper.STREET_LINE_2 => '',
                PORTAL_AddressWrapper.CITY_CONST => String.isNotBlank(locality) ? locality : '',
                PORTAL_AddressWrapper.STATE_CONST => String.isNotBlank(administrative_area) ? administrative_area : '',
                PORTAL_AddressWrapper.POSTAL_CODE => String.isNotBlank(postal_code) ? postal_code : '',
                PORTAL_AutocompleteAddressWrapper.ID_CONST => id,
                PORTAL_AutocompleteAddressWrapper.LABEL_CONST => label,
                PORTAL_AutocompleteAddressWrapper.NUMBER_OF_SIMILAR_ENTRIES => 0
            };

            return new PORTAL_AutocompleteAddressWrapper(addressMap);
        }
    }

    /**
     * Apex representation of the address returned from verification. Copied from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     */
    public class AddressResponse {
        public String input_id;
        public Integer input_index;              // The order in which this address was submitted
        public Integer candidate_index;          // Index when there are multiple addresses returned
        public String addressee;                 // Company name or intended recipient
        public String delivery_line_1;           // Verified street address
        public String delivery_line_2;
        public String last_line;                // City, state, and ZIP code combined
        public String delivery_point_barcode;

        // International specific address response.
        public String organization;
        public String address1;
        public String address2;
        public String address3;
        public String address4;

        // Not part of SmartyStreets spec.  Added to track any errors.
        public String error;

        public Components components;
        public Metadata metadata;
        public Analysis analysis;

       /**
        * Returns the address in a string format.
        *
        * @return: The address in a string format.
        */
        public String getFullAddress() {
            return (((addressee != null) ? (addressee + '\n') : '') + ((delivery_line_1 != null) ? (delivery_line_1 + '\n') : '') +
                    ((delivery_line_2 != null) ? (delivery_line_2 + '\n') : '') + ((last_line != null) ? (last_line) : '')).trim();
        }

       /**
        * Get the value of a parameter in the class.
        *
        * @param parameterName    The parameter to get a value from.
        *
        * @return                The value of the parameter.
        */
        public Object get(String parameterName) {
            String jsonInstance = JSON.serialize(this);
            Map<String, Object> untypedInstance = (Map<String, Object>)JSON.deserializeUntyped(jsonInstance);
            return untypedInstance.get(parameterName);
        }

       /**
        * Get the value of a parameter from another class referenced in in the class.
        *
        * @param subClass        The sub class that the parameter name belongs to.
        * @param parameterName    The parameter to get a value from.
        *
        * @return                The value of the parameter.
        */
        public Object get(String subClass, String parameterName) {
            if (subClass.toLowerCase() == COMPONENTS_CONST) {
                return components?.get(parameterName);
            }
            else if (subClass.toLowerCase() == METADATA_CONST) {
                return metadata?.get(parametername);
            }
            else if (subClass.toLowerCase() == ANALYSIS_CONST) {
                return analysis?.get(parametername);
            }

            return null;
        }
    }

    /**
     * Apex representation of the address returned from verification. Copied from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     */
    public class Components {
        public String urbanization;
        public String primary_number;
        public String street_name;
        public String street_predirection;
        public String street_postdirection;
        public String street_suffix;
        public String secondary_number;
        public String secondary_designator;
        public String extra_secondary_number;
        public String extra_secondary_designator;
        public String pmb_designator;
        public String pmb_number;
        public String city_name;
        public String default_city_name;
        public String state_abbreviation;
        public String zipcode;
        public String plus4_code;
        public String delivery_point;
        public String delivery_point_check_digit;

        // International specific address response.
        public String country_iso_3;
        public String administrative_area;
        public String super_administrative_area;
        public String sub_administrative_area;
        public String locality;
        public String dependent_locality;
        public String dependent_locality_name;
        public String double_dependent_locality;
        public String postal_code;
        public String postal_code_short;
        public String postal_code_extra;
        public String premise;
        public String premise_extra;
        public String premise_number;
        public String premise_type;
        public String thoroughfare;
        public String thoroughfare_predirection;
        public String thoroughfare_postdirection;
        public String thoroughfare_name;
        public String thoroughfare_trailing_type;
        public String thoroughfare_type;
        public String dependent_thoroughfare;
        public String dependent_thoroughfare_predirection;
        public String dependent_thoroughfare_postdirection;
        public String dependent_thoroughfare_name;
        public String dependent_thoroughfare_trailing_type;
        public String dependent_thoroughfare_type;
        public String building;
        public String building_leading_type;
        public String building_name;
        public String building_trailing_type;
        public String sub_building;
        public String sub_building_type;
        public String sub_building_number;
        public String sub_building_name;
        public String post_box;
        public String post_box_type;
        public String post_box_number;

       /**
        * Get the value of a parameter in the class.
        *
        * @param parameterName    The parameter to get a value from.
        *
        * @return                The value of the parameter.
        */
        public Object get(String parameterName) {
            String jsonInstance = JSON.serialize(this);
            Map<String, Object> untypedInstance = (Map<String, Object>)JSON.deserializeUntyped(jsonInstance);
            return untypedInstance.get(parameterName);
        }
    }

    /**
     * Apex representation of the address returned from verification. Copied from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     */
    public class Metadata {
        public String record_type;
        public String zip_type;
        public String county_fips;
        public String county_name;
        public String ews_match;
        public String carrier_route;
        public String congressional_district;
        public String building_default_indicator;
        public String rdi;
        public String elot_sequence;
        public String elot_sort;
        public Double latitude;
        public Double longitude;
        public Integer coordinate_license;
        public String precision;
        public String time_zone;
        public Integer utc_offset;
        public String dst;

        // International specific address response.
        public String geocode_precision;
        public String max_geocode_precision;
        public String address_format;

       /**
        * Get the value of a parameter in the class.
        *
        * @param parameterName    The parameter to get a value from.
        *
        * @return                The value of the parameter.
        */
        public Object get(String parameterName) {
            String jsonInstance = JSON.serialize(this);
            Map<String, Object> untypedInstance = (Map<String, Object>)JSON.deserializeUntyped(jsonInstance);
            return untypedInstance.get(parameterName);
        }
    }

    /**
     * Apex representation of the address returned from verification. Copied from ascend
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     */
    public class Analysis {
        public String dpv_match_code;
        public String dpv_footnotes;
        public String dpv_cmra;
        public String dpv_vacant;
        public String active;
        public String footnotes;
        public String lacslink_code;
        public String lacslink_indicator;
        public String suitelink_match;

        // International specific address response.
        public String verification_status;
        public String address_precision;
        public String max_address_precision;
        public AddressResponse changes;

       /**
        * Get the value of a parameter in the class.
        *
        * @param parameterName    The parameter to get a value from.
        *
        * @return                The value of the parameter.
        */
        public Object get(String parameterName) {
            String jsonInstance = JSON.serialize(this);
            Map<String, Object> untypedInstance;
            untypedInstance= (Map<String, Object>)JSON.deserializeUntyped(jsonInstance);
            return untypedInstance.get(parameterName);
        }
    }

    /**
     * Get the Smarty Street international autocomplete configurations/settings from the Bio/Demo Setting custom metadata
     * Includes whether international is enabled or not, a default country, and a map of country labels to ISO 3166-1 alpha-3 country codes 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param params    Map<String, Object>: Map<String, Object>: no params are used yet
     * 
     * @return Map with Smarty Street international autocomplete configurations as values
     */
    public virtual Map<String, Object> getInternationalAutocompleteConfigurationMap(Map<String, Object> params) {
        List<ucinn_ascendv2__Bio_Demo_Setting__mdt> bioDemoSettings = (List<ucinn_ascendv2__Bio_Demo_Setting__mdt>) getCustomMetadataRecordList(
            BIO_DEMO_SETTING_MDT, 
            new Set<String>{COUNTRY_CODE_MAP_C, DEFAULT_COUNTRY_C, ENABLE_INTERNATIONAL_AUTOCOMPLETE_C}, 
            new List<String>{BIO_DEMO_SETTING}, 
            ERROR_BIO_DEMO
        );

        Map<String, Object> returnMap = new Map<String, Object>();
        hasInternationalAutocomplete = Test.isRunningTest() ? true : (Boolean) bioDemoSettings[0].get(ENABLE_INTERNATIONAL_AUTOCOMPLETE_C);
        String countryCodeJson = Test.isRunningTest() ? TEST_COUNTRY_CODE_MAP : (String) bioDemoSettings[0].get(COUNTRY_CODE_MAP_C);
        returnMap.put(COUNTRY_CODE_MAP, JSON.deserializeUntyped(countryCodeJson));
        returnMap.put(DEFAULT_COUNTRY, Test.isRunningTest() ? UNITED_STATES : bioDemoSettings[0].get(DEFAULT_COUNTRY_C));
        returnMap.put(HAS_INTERNATIONAL_AUTOCOMPLETE, hasInternationalAutocomplete);
        return returnMap;
    }

    /**
     * Factory method to convert a params map into an AutocompleteQuery object 
     * @param searchInput       String: user input string to try to autocomplete
     * @param searchSelection   String: user selection in case where a suggestion has multiple address line 2 options
     * @param maxResults        String or Integer: max number of results in response, converted to Integer
     * 
     * @return AutocompleteQuery instance with popuplated fields
     */
    public override AutocompleteQuery buildAutocompleteQuery(Map<String, Object> params) {
        return new PORTAL_AddressServiceInterface.QueryBuilder()
                    .buildSearchInput((String) params?.get(SEARCH_INPUT))
                    .buildSearchSelection((String) params?.get(SEARCH_SELECTION))
                    .buildCountry((String) params?.get(COUNTRY_CONST))
                    .buildMaxResults(Integer.valueOf(params?.get(MAX_RESULTS)))
                    .build();
    }
    
    /**
     * Given autocomplete arguments as input, return a list of Smarty Streets suggested addresses
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param query     AutocompleteQuery: object with the following fields as parameters: 
     *                      searchInput: String, user input string to try to autocomplete
     *                      searchSelection: String, when the user selects a suggestion with multiple address line 2 options, need another callout for resolution
     *                      maxResults: Integer, max number of results in response
     * 
     * @return List of AutocompleteAddressWrappers, each address wrapper has its fields populated by Suggestion.getAddressWrapper()
     */
    public override List<PORTAL_AutocompleteAddressWrapper> getAutocompleteSuggestions(AutocompleteQuery query) {
        String endpoint = buildAutocompleteEndpoint(query);
        HttpResponse response = executeAPIRequest(endpoint);
        AutocompleteResponse responseObject = (AutocompleteResponse) System.JSON.deserialize(response.getBody(), AutocompleteResponse.class);
        return parseAutocompleteResponse(responseObject);
    }

   /**
    * Send verification request to SmartStreets to get more detailed address information.
    * Supports US/INT verification
    *
    * @author  Phillip Nguyen
    * @since   1.16
    * 
      @param   addressAsMap                Address object as a map, field api names -> values
    *
    * @return   Map containing address verification information
    */
    public virtual Map<String, Object> getAddressVerificationInformation(Map<String, Object> addressAsMap) {
        if (addressAsMap == null || addressAsMap.isEmpty()) {
            return new Map<String, Object>();
        }

        Boolean isInternationalAddress = this.isUSAddress((String)addressAsMap.get(ADDRESS_COUNTRY_FIELD_API_NAME)) == false;
        String authIdName = isInternationalAddress ? INTERNATIONAL_AUTOCOMPLETE_AUTH_ID : US_AUTOCOMPLETE_AUTH_ID;
        String authTokenName = isInternationalAddress ? INTERNATIONAL_AUTOCOMPLETE_AUTH_TOKEN : US_AUTOCOMPLETE_AUTH_TOKEN;
        Map<String, String> developerNameToAuthValueMap = this.getExternalAPICredentialDeveloperNameToValueMap(new List<String>{authIdName, authTokenName});

        String authId = developerNameToAuthValueMap.get(authIdName);
        String authToken = developerNameToAuthValueMap.get(authTokenName);

        if (String.isBlank(authId) || String.isBlank(authToken)) {
            System.debug('Error: Blank Smarty AuthId and/or AuthToken');
            return new Map<String, Object>();
        }

        return this.getAddressVerificationResponse(addressAsMap, authId, authToken, isInternationalAddress);
    }

   /**
    * Send verification request to SmartStreets to get more detailed address information.
    *
    * @author  Phillip Nguyen
    * @since   1.16
    * 
      @param   addressAsMap                Address object as a map, field api names -> values
    * 
    * @return   Map containing address verification information
    */
    protected virtual Map<String, Object> getAddressVerificationResponse(Map<String, Object> addressAsMap, String authId, String authToken, Boolean isInternationalAddress) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (addressAsMap == null || addressAsMap.isEmpty() || String.isBlank(authId) || String.isBlank(authToken)) {
            return resultMap;
        }

        Map<String, Object> verificationConfigMap = this.getVerificationConfigurationMap(new Map<String, Object>());

        String endpoint = this.generateInitialVerificationEndpoint(isInternationalAddress, authId, authToken, verificationConfigMap);
        Map<String, String> smartyFieldToAddressFieldValuesMap = this.getSmartyFieldToAddressFieldValuesMap(isInternationalAddress, addressAsMap, verificationConfigMap);

        for (String eachField : smartyFieldToAddressFieldValuesMap.keySet()) {
            if (String.isBlank(smartyFieldToAddressFieldValuesMap.get(eachField))) {
                continue;
            }

            endpoint += eachField + '=' + EncodingUtil.urlEncode(smartyFieldToAddressFieldValuesMap.get(eachField), 'UTF-8') + '&';
        }

        endpoint = endpoint.removeEnd('&');

        HttpResponse response = this.executeAPIRequest(endpoint);
        List<AddressResponse> responseObjectList = (List<AddressResponse>) System.JSON.deserialize(response.getBody(), List<AddressResponse>.class);
        resultMap.put(ADDRESS_INFORMATION, responseObjectList);

        return resultMap;
    }

    /**
     * Get the Smarty Street verification configurations/settings from the Bio/Demo Setting custom metadata
     * Includes US/INT field mapping, match method, and license type
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     * 
     * @param   params      Map<String, Object>: Map<String, Object>: no params are used yet
     * 
     * @return              Map with Smarty Street verification configurations as values
     */
    protected virtual Map<String, Object> getVerificationConfigurationMap(Map<String, Object> params) {
        List<ucinn_ascendv2__Bio_Demo_Setting__mdt> bioDemoSettings = (List<ucinn_ascendv2__Bio_Demo_Setting__mdt>) getCustomMetadataRecordList(
            BIO_DEMO_SETTING_MDT, 
            new Set<String>{SMARTYSTREETS_LICENSE_TYPE_C, SMARTYSTREETS_MATCH_METHOD_C, SMARTYSTREETS_INT_ADDRESS_SEARCH_MAP_C, SMARTYSTREETS_US_ADDRESS_SEARCH_MAP_C}, 
            new List<String>{BIO_DEMO_SETTING}, 
            ERROR_BIO_DEMO
        );

        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put(LICENSE_TYPE, bioDemoSettings[0].get(SMARTYSTREETS_LICENSE_TYPE_C));
        returnMap.put(MATCH_METHOD, bioDemoSettings[0].get(SMARTYSTREETS_MATCH_METHOD_C));
        returnMap.put(US_ADDRESS_SEARCH_MAP, JSON.deserializeUntyped((String)bioDemoSettings[0].get(SMARTYSTREETS_US_ADDRESS_SEARCH_MAP_C)));
        returnMap.put(INT_ADDRESS_SEARCH_MAP, JSON.deserializeUntyped((String)bioDemoSettings[0].get(SMARTYSTREETS_INT_ADDRESS_SEARCH_MAP_C)));

        return returnMap;
    }

    /**
     * Generates initial endpoint for SmartyStreets verification
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     * 
     * @param   isInternational             If address is international address
     * @param   authId                      AuthId key
     * @param   authToken                   AuthToken key
     * @param   bioDemoConfigurationMap     Bio Demo fields for config
     * 
     * @return  Endpoint with params
     */
    protected virtual String generateInitialVerificationEndpoint(Boolean isInternational, String authId, String authToken, Map<String, Object> bioDemoConfigurationMap) {
        String endpoint = '';

        if (String.isBlank(authId) || String.isBlank(authToken)) {
            return endpoint;
        }
        
        if (isInternational == true) {
            endpoint = INTERNATIONAL_VERIFICATION_ENDPOINT +
                        'auth-id=' + authId + '&' +
                        'auth-token=' + authToken + '&' +
                        'geocode=true&';
            return endpoint;
        }

        String license = '';
        if (String.isNotBlank((String)bioDemoConfigurationMap?.get(LICENSE_TYPE))) {
            license = '&license=' + bioDemoConfigurationMap.get(LICENSE_TYPE);
        }

        String matchMethod = '&match=invalid';
        if (String.isNotBlank((String)bioDemoConfigurationMap?.get(MATCH_METHOD))) {
            matchMethod = '&match=' + bioDemoConfigurationMap.get(MATCH_METHOD);
        }

        endpoint = US_VERIFICATION_ENDPOINT +
                    'auth-id=' + authId + '&' +
                    'auth-token=' + authToken + '&' +
                    'candidates=10' + 
                    license + matchMethod + '&';

        return endpoint;
    }

    /**
     * Get smarty address field to address field value map to use later to create end point with address data.
     * Uses mapping from ascend's Bio Demo US/IT Smarty Search Fields
     * 
     * @author  Phillip Nguyen
     * @since   1.16
     * 
     * @param   isInternationalAddress      If address is international address
     * @param   addressAsMap                Address object as a map, field api names -> values
     * @param   bioDemoConfigurationMap     Bio Demo fields for config
     * 
     * @return                              Map of Smarty Field to Address Field value i.e {country => U.S}
     */
    private Map<String, String> getSmartyFieldToAddressFieldValuesMap(Boolean isInternationalAddress, Map<String, Object> addressAsMap, Map<String, Object> bioDemoConfigurationMap) {
        Map<String, String> addressFieldToValueMap = new Map<String, String>();

        if (bioDemoConfigurationMap == null || bioDemoConfigurationMap.isEmpty() || addressAsMap == null || addressAsMap.isEmpty()) {
            return addressFieldToValueMap;
        }

        Map<String, Object> smartyFieldMapping = isInternationalAddress == true ? (Map<String, Object>)bioDemoConfigurationMap.get(INT_ADDRESS_SEARCH_MAP) : (Map<String, Object>)bioDemoConfigurationMap.get(US_ADDRESS_SEARCH_MAP);
        smartyFieldMapping = (Map<String, Object>)smartyFieldMapping.get(ADDRESS_SOBJECT_API_NAME);

        //Allow multiple fields to map to the same API field. Concatenate the field values when this occurs
        for (String eachField : smartyFieldMapping.keySet()) {
            String apiField = (String)smartyFieldMapping.get(eachField);
            String fieldValue = (String)addressAsMap.get(eachField);

            if (String.isBlank(fieldValue)) {
                continue;
            }

            if (addressFieldToValueMap.containsKey(apiField)) {
                addressFieldToValueMap.put(apiField, addressFieldToValueMap.get(apiField) + ' ' + fieldValue);
            } else {
                addressFieldToValueMap.put(apiField, fieldValue);
            }
        }

        return addressFieldToValueMap;
    }

    /**
     * Validate the autocomplete parameters, throwing errors if required fields are missing or assigning default values
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param query     AutocompleteQuery: object with parameters needed for autocomplete callout
     */
    protected virtual void validateAutocompleteQuery(AutocompleteQuery query) {
        if (String.isBlank(query?.searchInput)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_NO_SEARCH_INPUT});
        }
        // [1, 10] is the allowable range, so use default if outside range
        if (query.maxResults == null || query.maxResults < 1 || query.maxResults > 10) {
            query.maxResults = DEFAULT_MAX;
        }
        // with default custom metadata values, query.country is already blank for US addresses 
        if (String.isNotBlank(query.country) && isUSAddress(query.country)) {
            query.country = '';
        }
    }

    /**
     * Determine whether a country string represents the United States or not
     * 
     * @author Jacob Huang, logic borrowed from ascend code
     * @since 1.0
     * 
     * @param country   String: some country
     * 
     * @return true if the country is one of several possibilities that represents the United States 
     */
    protected virtual Boolean isUSAddress(String country) {
        country = country?.toLowerCase();
        return String.isBlank(country) || US_NAMES_SET.contains(country);
    }

    /**
     * Convert the autocomplete parameters into a properly formatted URL/endpoint
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param query     AutocompleteQuery: object with parameters needed for autocomplete callout
     * 
     * @return String: Smarty Streets endpoint with appropriately formatted URL arguments from the AutocompleteQuery 
     */
    protected virtual String buildAutocompleteEndpoint(AutocompleteQuery query) {
        validateAutocompleteQuery(query);
        List<String> endpointArguments = new List<String>();
        Boolean isInternational = false;
        
        if (String.isNotBlank(query.country)) {
            if (hasInternationalAutocomplete == null) {
                getInternationalAutocompleteConfigurationMap(null);
            }
            // if somehow country is not blank && international autocomplete is disabled, adding country to US autocomplete URL is harmless
            isInternational = hasInternationalAutocomplete;
            endpointArguments.add(COUNTRY_CONST_REQUEST + '=' + query.country);
        }
        endpointArguments.add(getAutocompleteAuthentication(isInternational));
        endpointArguments.add(SEARCH_CONST + '=' + EncodingUtil.urlEncode(query.searchInput, UTF_8));
        endpointArguments.add(MAX_RESULTS + '=' + query.maxResults);
        if (String.isNotBlank(query.searchSelection)) {
            endpointArguments.add(SELECTED_CONST + '=' + EncodingUtil.urlEncode(query.searchSelection, UTF_8));
        }

        return (isInternational ? INTERNATIONAL_AUTOCOMPLETE_ENDPOINT : US_AUTOCOMPLETE_ENDPOINT) + '?' + String.join(endpointArguments, '&');
    }
    
    /**
     * Get the authentication ID and token for Smarty Streets autocomplete service
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @return String with the authId and authToken formatted as the endpoint URL arguments
     */
    @TestVisible
    protected virtual String getAutocompleteAuthentication(Boolean isInternational) {
        String authIdName = isInternational ? INTERNATIONAL_AUTOCOMPLETE_AUTH_ID : US_AUTOCOMPLETE_AUTH_ID;
        String authTokenName = isInternational ? INTERNATIONAL_AUTOCOMPLETE_AUTH_TOKEN : US_AUTOCOMPLETE_AUTH_TOKEN;
        Map<String, String> developerNameToAuthValueMap = getExternalAPICredentialDeveloperNameToValueMap(new List<String>{authIdName, authTokenName});

        String authId = developerNameToAuthValueMap.get(authIdName);
        String authToken = developerNameToAuthValueMap.get(authTokenName);
        if (String.isBlank(authId) || String.isBlank(authToken)) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_AUTHENTICATION});
        }
    
        return AUTH_ID + '=' + authId + '&' + AUTH_TOKEN + '=' + authToken;
    }
    
    /**
     * Get the values of External API Credential custom metadata records with the given developer names
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param developerNameList     List<String>: the developer names of the External API Credential custom metadata records
     * 
     * @return Map of External API Credential custom metadata records' developer names to values
     */
    protected virtual Map<String, String> getExternalAPICredentialDeveloperNameToValueMap(List<String> developerNameList) {
        List<ucinn_ascendv2__External_API_Credential__mdt> externalAPICredentialList = (List<ucinn_ascendv2__External_API_Credential__mdt>) getCustomMetadataRecordList(
            EXTERNAL_API_CREDENTIAL, 
            new Set<String>{DEVELOPER_NAME, VALUE_C}, 
            developerNameList, 
            ERROR_AUTHENTICATION
        );

        Map<String, String> developerNameToAuthValueMap = new Map<String, String>();
        for (ucinn_ascendv2__External_API_Credential__mdt eachCredential : externalAPICredentialList) {
            String value = Test.isRunningTest() ? TEST_CONST : (String) eachCredential.get(VALUE_C);
            developerNameToAuthValueMap.put((String) eachCredential.get(DEVELOPER_NAME), value);
        }

        return developerNameToAuthValueMap;
    }

    /**
     * Helper method to handle creation of the parameter map and error checking for the PORTAL_Utils method of the same name 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param sObjectName           String: Which custom metadata type to use
     * @param fieldSet              Set<String>: Which fields to query for
     * @param developerNameList     List<String>: Which custom metadata records to query for
     * @param errorMessage          String: error message to use in Aura Handled Exception
     * 
     * @return List<SObject> of custom metadata records with values of specified fields
     */
    @TestVisible
    protected virtual List<SObject> getCustomMetadataRecordList(String sObjectName, Set<String> fieldSet, List<String> developerNameList, String errorMessage) {
        if (String.isBlank(sObjectName) || fieldSet == null || fieldSet.isEmpty() || developerNameList == null || developerNameList.isEmpty()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => errorMessage}); 
        }

        Map<String, Object> params = new Map<String, Object>{
            PORTAL_Utils.SOBJECT_NAME => sObjectName,
            PORTAL_Utils.FIELD_SET => fieldSet,
            PORTAL_Utils.DEVELOPER_NAME_LIST => developerNameList
        };

        List<SObject> metadataRecordList = PORTAL_Utils.getCustomMetadataRecordList(params);
        
        if (metadataRecordList.size() != developerNameList.size()) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => errorMessage});
        }

        return metadataRecordList;
    }

    /**
     * Send the HTTP request to Smarty Streets. Only GET requests for now 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param endpoint          String: the Smarty Streets endpoint with query parameters
     * 
     * @return HttpResponse object from API request
     */ 
    protected virtual HttpResponse executeAPIRequest(String endpoint) {        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(HTTP_GET);
        HttpResponse response = http.send(request);
        Integer statusCode = response.getStatusCode();
    
        if (statusCode < 200 || statusCode >= 300) {
            List<Object> errorList = (List<Object>) ((Map<String, Object>) JSON.deserializeUntyped(response.getBody())).get(ERRORS_CONST);
            String message = errorList.isEmpty() ? ERROR_UNEXPECTED : (String) ((Map<String, Object>) errorList[0]).get(MESSAGE_CONST);
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => statusCode + ': ' + message});
        }
        
        return response;
    }

    /**
     * Convert addresses in an AutocompleteResponse into a list of AddressWrappers
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param response      AutocompleteResponse: contains a list of addresses Suggestions (US) or Candidates (international)
     * 
     * @return List of AutocompleteAddressWrappers, each address wrapper has its fields populated by Suggestion's or Candidate's getAddressWrapper()
     */
    protected virtual List<PORTAL_AutocompleteAddressWrapper> parseAutocompleteResponse(AutocompleteResponse response) {
        List<PORTAL_AutocompleteAddressWrapper> addressList = new List<PORTAL_AutocompleteAddressWrapper>();
        // US
        if (response.suggestions != null) {
            for (Suggestion eachSuggestion : response.suggestions) {
                addressList.add(parseSuggestion(eachSuggestion));
            }
        }
        // international
        else if (response.candidates != null) {
            for (Candidate eachCandidate : response.candidates) {
                addressList.add(parseCandidate(eachCandidate));
            }
        }

        return addressList;
    }

    /**
     * Convert an address Suggestion supplied by US autocomplete callout into an AddressWrapper 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param address       Suggestion: address object supplied by US autocomplete
     * 
     * @return PORTAL_AutocompleteAddressWrapper with fields populated by Suggestion.getAddressWrapper()
     */
    protected virtual PORTAL_AutocompleteAddressWrapper parseSuggestion(Suggestion address) {
        String formattedSecondary = String.isBlank(address.secondary) ? '' : ' ' + address.secondary;
        if (address.entries > 1) {
            formattedSecondary += ' (' + address.entries + ' options...)';
        }
        address.id = address.street_line + formattedSecondary + ', ' + address.city + ', ' + address.state + ' ' + address.zipcode;
        address.label = address.id;

        return address.getAddressWrapper();
    }

     /**
     * Convert an address Candidate supplied by international autocomplete callout into an AddressWrapper 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param address       Candidate: address object supplied by international autocomplete
     * 
     * @return PORTAL_AutocompleteAddressWrapper with fields populated by Candidate.getAddressWrapper()
     */
    protected virtual PORTAL_AutocompleteAddressWrapper parseCandidate(Candidate address) {
        // street, country_iso3 appear to be the only fields guaranteed to appear
        address.id = address.street;
        address.id += String.isNotBlank(address.locality) ? (', ' + address.locality) : '';
        address.id += String.isNotBlank(address.administrative_area) ? (', ' + address.administrative_area) : ''; 
        address.id += String.isNotBlank(address.postal_code) ? (' ' + address.postal_code) : '';
        address.label = address.id + ' ' + address.country_iso3;
        return address.getAddressWrapper();
    }
}