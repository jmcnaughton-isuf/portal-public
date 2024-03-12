global with sharing class PORTAL_CONST_Global {
    global static final String DEBUG_AES_KEY_MD_DEVELOPER_NAME = 'Debug_AES_Key';
    global static final String WHERE_CLAUSE_PREFIX = 'where';
    global static final String ORDER_BY_CLAUSE_PREFIX = 'order by';
    global static final String GROUP_BY_CLAUSE_PREFIX = 'group by';

    global static final String SYSTEM_ADMIN_PROFILE = 'System Administrator';
    global static final String COMMUNITY_ADMIN_PROFILE = 'ascend Customer Community Administrator';
    public static final String PORTAL_ADMIN_ACCESS_PERMISSION = 'ucinn_portal_Portal_Administrative_Access';
    public static final Set<String> ADMIN_PROFILE_SET = new Set<String>{'ascend Customer Community Administrator', 'System Administrator'};

    global static final String DEFAULT_PROFILE_NAME = 'ascend Customer Community User';
    global static final String DUMMY_CONTACT_FIRST_NAME = 'My Information Dummy Contact';
    global static final String DUMMY_CONTACT_LAST_NAME = 'Do Not Delete This Record';
    global static final String ACCOUNT_EXTERNAL_ID_METADATA_NAME = 'Organization External Id Setting';

    global static final String ADDRESS_RELATION_STATUS_CURRENT = 'Current';
    global static final String ACCOUNT_EXTERNAL_ID_METADATA_DEVELOPER_NAME = 'Organization_External_Id_Setting';
    global static final Set<String> EXTERNAL_USER_PROFILE_SET = new Set<String> {DEFAULT_PROFILE_NAME};
    global static final String STREET_KEY = 'street';
    global static final String CITY_KEY = 'city';
    global static final String STATE_KEY = 'state';
    global static final String COUNTRY_KEY = 'country';
    global static final String POSTAL_CODE = 'postalCode';
    global static final String DEFAULT_TIME_ZONE = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)';
    global static final String DUMMY_CACHE_NAME = 'Dummy_Cache';
    global static final String INTERIM_SOURCE_URL = 'interimSourceUrl';
}