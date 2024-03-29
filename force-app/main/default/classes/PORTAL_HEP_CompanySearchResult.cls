//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

/**
 * A POJO representing a successful API response from the HEPData "search dynamic result" endpoint
 */
public with sharing class PORTAL_HEP_CompanySearchResult {
    @AuraEnabled public Integer count;
    @AuraEnabled public String next;
    @AuraEnabled public String previous;
    @AuraEnabled public List<Company> results;
    @AuraEnabled public Integer number_requested;
    @AuraEnabled public Integer number_returned;
    @AuraEnabled public Integer number_remaining;
    @AuraEnabled public Boolean all_results;

    public class Company {
        @AuraEnabled public String name;
        @AuraEnabled public String company_id;
        @AuraEnabled public Boolean is_parent;
        @AuraEnabled public Integer parent_raw_id;
        @AuraEnabled public String parent_name;
        @AuraEnabled public String subsidiary_name;
        @AuraEnabled public Integer subsidiary_id;
        @AuraEnabled public Integer subsidiary_raw_id;
        @AuraEnabled public Integer suggested_order;
        @AuraEnabled public String last_updated;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public Boolean is_usa;
    }

    /**
     * Deserializes the given JSON String into an instance of this class.
     * @param json  String to deserialize
     * @return         An Apex object representation of the CompanySearchResult
     */
    public static PORTAL_HEP_CompanySearchResult parse(String json) {
        return (PORTAL_HEP_CompanySearchResult) System.JSON.deserialize(json, PORTAL_HEP_CompanySearchResult.class);
    }
}