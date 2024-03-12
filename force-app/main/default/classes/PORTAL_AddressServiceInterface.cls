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
 * Abstract class that specifies desired Address Service methods/functionality
 * Has simple inner classes for representing parameters for those common methods
 *
 * @author          Jacob Huang
 * @version         1.0
 * @since           1.0
 */
public abstract class PORTAL_AddressServiceInterface {
    public static final String SEARCH_INPUT = 'searchInput';
    public static final String SEARCH_SELECTION = 'searchSelection';
    public static final String COUNTRY_CONST = 'country';
    public static final String MAX_RESULTS = 'maxResults';

    /**
     * Class representing arguments for autocomplete API calls 
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public class AutocompleteQuery {
        public String searchInput {get; set;}
        public String searchSelection {get; set;}
        public String country {get; set;}
        public Integer maxResults {get; set;}
    }

    /**
     * Builder class for Autocomplete Query
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    public class QueryBuilder {
        public AutocompleteQuery query;

        /**
         * Constructor for builder class
         * 
         * @author Jacob Huang
         * @since 1.0
         */
        public QueryBuilder() {
            query = new AutocompleteQuery();
        }

        /**
         * Set search input value
         *
         * @author Jacob Huang
         * @since 1.0
         * 
         * @param searchInput       String: user input string to try to autocomplete 
         * 
         * @return this builder class instance 
         */
        public QueryBuilder buildSearchInput(String searchInput) {
            this.query.searchInput = searchInput;
            return this;
        }

        /**
         * Set search selection value
         *
         * @author Jacob Huang
         * @since 1.0
         * 
         * @param searchSelection   String: user selection in case where a suggestion has multiple address line 2 options
         * 
         * @return this builder class instance 
         */
        public QueryBuilder buildSearchSelection(String searchSelection) {
            this.query.searchSelection = searchSelection;
            return this;
        }

        /**
         * Set country value
         *
         * @author Jacob Huang
         * @since 1.0
         * 
         * @param country           String: specifies which country the autocomplete service should search in
         * 
         * @return this builder class instance 
         */
        public QueryBuilder buildCountry(String country) {
            this.query.country = country;
            return this;
        }

        /**
         * Set max results value
         *
         * @author Jacob Huang
         * @since 1.0
         * 
         * @param maxResults        Integer: max number of results to show
         * 
         * @return this builder class instance 
         */
        public QueryBuilder buildMaxResults(Integer maxResults) {
            this.query.maxResults = maxResults;
            return this;
        }

        /**
         * Return an instance of AutocompleteQuery
         *
         * @author Jacob Huang
         * @since 1.0
         * 
         * @return AutocompleteQuery with populated fields
         */
        public AutocompleteQuery build() {
            return this.query;
        }
    }

    /**
     * Factory method to convert a params map into an AutocompleteQuery object 
     * 
     * @param searchInput       String: user input string to try to autocomplete
     * @param searchSelection   String: user selection in case where a suggestion has multiple address line 2 options
     * @param country           String: specifies which country the autocomplete service should search in
     * @param maxResults        String or Integer: max number of results in response, converted to Integer
     * 
     * @return AutocompleteQuery instance with popuplated fields
     */
    public abstract AutocompleteQuery buildAutocompleteQuery(Map<String, Object> params);

    /**
     * Given autocomplete arguments as input, use some address autocomplete service and return a list of suggested addresses
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param query     AutocompleteQuery: object whose fields are parameters needed for the API callout
     * 
     * @return List of AutocompleteAddressWrappers, each wrapper has various address fields populated with autocomplete suggestions
     */
    public abstract List<PORTAL_AutocompleteAddressWrapper> getAutocompleteSuggestions(AutocompleteQuery query);
}