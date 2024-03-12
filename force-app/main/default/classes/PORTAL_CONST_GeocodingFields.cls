public with sharing class PORTAL_CONST_GeocodingFields {

    public static final String STREET_FIELDS_KEY = 'streetFields';
    public static final String OTHER_FIELDS_KEY = 'otherFields';
    public static final String ADDRESS_API_NAME = 'ucinn_ascendv2__Address__c';
    public static final String JOB_API_NAME = 'ucinn_portal_Job__c';
    public static final Set<String> ADDRESS_GEOLOCATION_FIELDS = new Set<String>{'ucinn_ascendv2__Location__longitude__s', 'ucinn_ascendv2__Location__latitude__s'};
    public static final Set<String> JOB_GEOLOCATION_FIELDS = new Set<String>{'Geolocation__longitude__s', 'Geolocation__latitude__s'};
    public static final Map<String, List<String>> JOB_FIELDS = new Map<String, List<String>>{STREET_FIELDS_KEY => new List<String>{'Address_Line_1__c', 'Address_Line_2__c', 'Address_Line_3__c'},
                                                                                           OTHER_FIELDS_KEY => new List<String>{'City__c', 'State__c', 'Country__c', 'Postal_Code__c'}};
    public static final Map<String, List<String>> ADDRESS_FIELDS = new Map<String, List<String>>{STREET_FIELDS_KEY => new List<String>{'ucinn_ascendv2__Address_Line_1__c', 'ucinn_ascendv2__Address_Line_2__c', 'ucinn_ascendv2__Address_Line_3__c', 'ucinn_ascendv2__Address_Line_4__c'},
                                                                                           OTHER_FIELDS_KEY => new List<String>{'ucinn_ascendv2__City__c', 'ucinn_ascendv2__State__c', 'ucinn_ascendv2__Country__c', 'ucinn_ascendv2__Postal_Code__c'}};
}