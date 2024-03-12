public inherited sharing class PORTAL_CONST_ClubAndGroups {
    public static final String ZONE_MEMBERSHIP_STATUS_ACTIVE = 'Active';
    public static final String ZONE_MEMBERSHIP_STATUS_INACTIVE = 'Inactive';
    public static final String ZONE_MEMBERSHIP_STATUS_DENIED = 'Denied';
    public static final String ZONE_MEMBERSHIP_STATUS_PENDING = 'Pending';

    public static final List<String> ZONE_MEMBERSHIP_ACTIVE_STATUS_LIST = new List<String>{ZONE_MEMBERSHIP_STATUS_ACTIVE};
    public static final List<String> ZONE_MEMBERSHIP_INACTIVE_STATUS_LIST = new List<String>{ZONE_MEMBERSHIP_STATUS_INACTIVE, ZONE_MEMBERSHIP_STATUS_DENIED};

    public final static Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String> LOCATION_FIELD_MAPPING = new Map<PORTAL_AddressWrapper.ADDRESS_FIELD, String>{
        PORTAL_AddressWrapper.ADDRESS_FIELD.STREET1 => 'Street__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.CITY => 'City__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.STATE => 'State__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.COUNTRY => 'Country__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.POSTCODE => 'Postal_Code__c',
        PORTAL_AddressWrapper.ADDRESS_FIELD.GEOLOCATION => 'Geolocation__c'
    };
}