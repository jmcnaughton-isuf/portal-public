/*
 * Copyright (c) 2019, UC Innovation, Inc.  All Rights Reserved.
 *                     http://www.ucinnovation.com
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

public inherited sharing class PORTAL_CommunityUtils {
    @TestVisible
    private static String testExceptionType = '';
    public static final String AURA_HANDLED_EXCEPTION = 'AuraHandledException';
    public static final String NULL_POINTER_EXCEPTION = 'NullPointerException';

    static private String ENCRYPTION_INITIALIZATION_VECTOR = 'Ne3tYAR3Oc09W2T5';
    static private String DEFAULT_ENCRYPTION_KEY = 'AaronAshleyDanielBillIsTheBest!!';
    // These two parameters are used only for test classes since we can't create Network object in test classes.
    static public Boolean testHasUrlPathPrefix;
    static public Boolean testHasNetworkId;
    static public Boolean testHasNetwork;

    public static final String STREET_KEY = 'street';
    public static final String CITY_KEY = 'city';
    public static final String STATE_KEY = 'state';
    public static final String COUNTRY_KEY = 'country';
    public static final String POSTAL_CODE = 'postalCode';

    public static final String PARAM_FIRST_VALUE = 'firstValue';
    public static final String PARAM_SECOND_VALUE = 'secondValue';
    public static final String PARAM_OPERAND_TYPE = 'operandType';
    public static final String PARAM_OPERATOR = 'operator';
    public static final String PARAM_SOBJECT_TYPE = 'sobjType';
    public static final String PARAM_SOBJECT_RECORD = 'sobjRecord';
    public static final String PARAM_LOGIC_STRING = 'logicString';
    public static final String PARAM_USER_ID = 'userId';
    public static final String PARAM_INPUT_STRING = 'inputString';
    public static final String PARAM_STACKTRACE_STRING = 'stackTraceString';
    public static final String PARAM_CUSTOM_ERROR_MESSAGE = 'customErrorMessage';
    public static final String PARAM_KEY_CUSTOM_METADATA_NAME = 'keyCustomMetadataName';
    public static final String PARAM_PICKLISTS = 'picklists';
    public static final String PARAM_CLAUSE = 'clause';
    public static final String PARAM_PREFIX = 'prefix';
    public static final String PARAM_NEW_RECORD = 'newRecord';
    public static final String PARAM_OLD_RECORD = 'oldRecord';
    public static final String PARAM_DATE_TIME_FIELD_API_NAME = 'dateTimeFieldApiName';
    public static final String PARAM_STRING_FIELD_API_NAME = 'stringFieldApiName';
    public static final String PARAM_NEW_TIME_ZONE = 'newTimeZone';
    public static final String PARAM_OLD_TIME_ZONE = 'oldTimeZone';
    public static final String YEAR_KEY = 'Year';
    public static final String UNFORMATTED_DATE = 'unformattedDate';
    public static final String TIME_ZONE = 'timeZone';

    public static final String STRING_CONST = 'String';
    public static final String NUMBER_CONST = 'Number';
    public static final String BOOLEAN_CONST = 'Boolean';
    public static final String DATE_CONST = 'Date';
    public static final String DATETIME_CONST = 'Datetime';
    public static final String EQ_OPERATOR = '=';
    public static final String NE_OPERATOR = '!=';
    public static final String GT_OPERATOR = '>';
    public static final String GE_OPERATOR = '>=';
    public static final String LT_OPERATOR = '<';
    public static final String LE_OPERATOR = '<=';
    public static final String LIKE_OPERATOR = 'LIKE';
    public static final String IN_OPERATOR = 'IN';
    public static final String NOT_IN_OPERATOR = 'NOT IN';
    public static final String INCLUDES_OPERATOR = 'INCLUDES';
    public static final String EXCLUDES_OPERATOR = 'EXCLUDES';
    public static final String BLANK_OPERATOR = 'BLANK';
    public static final String NOTBLANK_OPERATOR = 'NOTBLANK';

    public static final String PARAM_REPLACEMENT = 'replacement';
    public static final String EMAIL_RECIPIENT_LIST = 'emailRecipientList';
    public static final String EMAIL_TO_SEND_LIST = 'emailList';
    public static final String MERGE_FIELD_REPLACEMENT = 'mergeFieldToReplacementValue';
    public static final String MERGE_FIELD_ORIGINAL_TEXT = 'originalText';
    public static final String USER_ID = 'userId';
    public static final String EMAIL_ADDRESS_LIST = 'emailAddressList';
    public static final String SENDER_DISPLAY_NAME = 'senderDisplayName';
    public static final String SUBJECT_KEY = 'subject';
    public static final String EMAIL_BODY = 'emailBody';
    public static final String EMAIL_ATTACHMENTS = 'emailAttachments';
    public static final String EMAIL_TEMPLATE_RECORD = 'emailTemplateRecord';
    public static final String MERGE_FIELD_VALUE_MAP = 'mergeFieldValueMap';
    public static final String DEVELOPER_NAME = 'developerName';
    public static final String T_EDIT_ID_PATTERN = '<td\\s+tEditID="([^"]+)"[^>]*>';
    public static final String CDATA_PATTERN = '<!\\[CDATA\\[(.*?)\\]\\]>';
    public static final String T_EDIT_ID_TD_OPEN_TAG_PATTERN = '<td\\s+tEditID="';
    public static final String T_EDIT_ID_TD_CLOSING_TAG_PATTERN = '"[^>]*>.*?</td>';
    public static final String TD_OPEN_TAG_WITH_T_EDIT_ID = '<td tEditID="';
    public static final String TD_CLOSING_ANGLE_BRACKET = '">';
    public static final String TD_CLOSING_TAG = '</td>';

    public static final Set<String> ADMIN_PROFILE_SET = new Set<String>{'ascend Customer Community Administrator', 'System Administrator'};


    public static Map<String, List<String>> sobjToHashingFieldListForExternalId {
        get {
            if (sobjToHashingFieldListForExternalId == null) {
                sobjToHashingFieldListForExternalId = new Map<String, List<String>>();

                List<ucinn_ascendv2__External_System_ID_Hash_Fields_Setting__mdt> sobjHashingFieldsList = [SELECT Id, ucinn_ascendv2__Object_API_Name__c, ucinn_ascendv2__Field_API_Names__c FROM ucinn_ascendv2__External_System_ID_Hash_Fields_Setting__mdt];

                if (Test.isRunningTest()) {
                    sobjHashingFieldsList = new List<ucinn_ascendv2__External_System_ID_Hash_Fields_Setting__mdt>();
                    ucinn_ascendv2__External_System_ID_Hash_Fields_Setting__mdt testData = new ucinn_ascendv2__External_System_ID_Hash_Fields_Setting__mdt();
                    testData.ucinn_ascendv2__Object_API_Name__c = ucinn_ascendv2__Address__c.sObjectType.getDescribe().getName();
                    testData.ucinn_ascendv2__Field_API_Names__c = ucinn_ascendv2__Address__c.ucinn_ascendv2__Address_Line_1__c.getDescribe().getName() + ',' + ucinn_ascendv2__Address__c.ucinn_ascendv2__Address_Line_2__c.getDescribe().getName();
                    sobjHashingFieldsList.add(testData);
                }

                if (sobjHashingFieldsList != null && sobjHashingFieldsList.size() > 0) {
                    for (ucinn_ascendv2__External_System_ID_Hash_Fields_Setting__mdt record : sobjHashingFieldsList) {
                        sobjToHashingFieldListForExternalId.put(record.ucinn_ascendv2__Object_API_Name__c, new List<String>());
                        if (String.isNotBlank(record.ucinn_ascendv2__Field_API_Names__c)) {
                            List<String> fieldList = record.ucinn_ascendv2__Field_API_Names__c.deleteWhitespace().split(',');
                            if (fieldList != null && fieldList.size() > 0) {
                                sobjToHashingFieldListForExternalId.get(record.ucinn_ascendv2__Object_API_Name__c).addAll(fieldList);
                            }
                        }
                    }
                }
            }
            return sobjToHashingFieldListForExternalId;
        }
        private set;
    }

    /**
     * Get contact information from Id
     * 
     * @author:         Todd Shinto
     * @since:          1.2
     * 
     */
    public static Contact getContactInfoFromId(String contactId) {
        Contact cont = null;

        if (contactId != null) {
            List<Contact> contactList = [SELECT Id,
                                            Name,
                                            FirstName,
                                            LastName,
                                            Email,
                                            Phone,
                                            HomePhone,
                                            MobilePhone,
                                            ucinn_portal_Stripe_Customer_ID__c,
                                            ucinn_ascendv2__Contact_Type__c,
                                            ucinn_portal_Is_Hiring_Manager__c
                                        FROM Contact
                                        WHERE Id = :contactId AND ucinn_portal_Is_Display_On_Portal__c = true];
            if (contactList.size() > 0) {
                cont = contactList.get(0);
            }
        }

        return cont;
    }

    /**
     * Get preferred bio info from Id
     * 
     * @author:         Todd Shinto
     * @since:          1.13
     * 
     * @return a Contact record with subqueried preferred related records
     */
    public static Contact getContactPreferredBioInfo(Id userId) {
        User currentUser = getLoggedInUserInfo(userId);
        Contact cont = null;

        if (currentUser.ContactId == null) {
            return cont;
        }

        List<Contact> contactList = [SELECT Id,
                                            Name,
                                            FirstName,
                                            LastName,
                                            (SELECT ucinn_ascendv2__Phone_Number__c,
                                                    ucinn_ascendv2__Type__c
                                               FROM ucinn_ascendv2__Phones_Contact__r 
                                              WHERE ucinn_ascendv2__Is_Preferred__c = true 
                                                AND ucinn_portal_Is_Display_On_Portal__c = true),
                                            (SELECT ucinn_ascendv2__Email_Address__c,
                                                    ucinn_ascendv2__Type__c
                                               FROM ucinn_ascendv2__Emails_Contact__r 
                                              WHERE ucinn_ascendv2__Is_Preferred__c = true 
                                                AND ucinn_portal_Is_Display_On_Portal__c = true),
                                            (SELECT ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c,
                                                    ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_2__c,
                                                    ucinn_ascendv2__Address__r.ucinn_ascendv2__City__c,
                                                    ucinn_ascendv2__Address__r.ucinn_ascendv2__State__c,
                                                    ucinn_ascendv2__Address__r.ucinn_ascendv2__Postal_Code__c,
                                                    ucinn_ascendv2__Address__r.ucinn_ascendv2__Country__c,
                                                    ucinn_ascendv2__Type__c
                                               FROM ucinn_ascendv2__Address_Relations_Contact__r
                                              WHERE ucinn_ascendv2__Is_Preferred__c = true
                                                AND ucinn_portal_Is_Display_On_Portal__c = true)
                                     FROM Contact
                                     WHERE Id = :currentUser.ContactId AND ucinn_portal_Is_Display_On_Portal__c = true];
        if (!contactList.isEmpty()) {
            cont = contactList.get(0);
        }

        return cont;
    }

    /**
     * Get contact information associated with the logged in user.
     *
     * @param: userId    User ID of logged in user.
     * @return:            Contact associated with the logged in user.
     * @since:             1.0
     */
    public static Contact getContactInfoFromUser(Map<String, Object> params) {

        Id userId = (Id) params.get(PARAM_USER_ID);

        User usr = [SELECT Id,
                           ContactId,
                           AccountId,
                           FirstName,
                           LastName,
                           ucinn_portal_Recommend_Type_1__c,
                           ucinn_portal_Recommend_Type_2__c,
                           ucinn_portal_Recommend_Type_3__c
                    FROM User
                    WHERE Id = :userId];

        Id contactId = usr.ContactId;

        return getContactInfoFromId(contactId);
    }

    /**
     * Get user information of the logged in user.
     *
     * @param: userId    User ID of logged in user.
     * @return:            The user information associated with the logged in user.
     * @since:             1.0
     */
    public static User getLoggedInUserInfo(Id userId) {
        User currentUser = [SELECT Id, Name, ContactId, AccountId
                            FROM User
                            WHERE Id = :userId];

        System.Debug('Current User: ' + currentUser);
        System.Debug('contactId: ' + currentUser.contactId);
        return currentUser;
    }

    /**
     * Get the community prefix name.  For example, if the community base URL is 'https://ascend.cs6.force.com/portal',
     * this function will return 'portal'
     *
     * @return:    The community prefix name.
     * @since:     1.0
     */
    public static String getCommunityPrefixName() {
        /*System.debug('Network.getNetworkId(): ' + Network.getNetworkId());

        // Network.getNetworkId() returns null in test classes:
        // https://help.salesforce.com/articleView?id=000273008&language=en_US&type=1
        if (Network.getNetworkId() != null || (Test.isRunningTest() && testHasNetworkId)) {

            // Using a list so that when running test classes, SOQL won't fail with 'List has no rows for assignments to SObject' error.
            List<Network> netList = [SELECT Id, Name, Description, Status, UrlPathPrefix FROM Network WHERE Id = :Network.getNetworkId()];

            // Using ternary opeator to get test code coverage.
            return netList.isEmpty() ? '' : netList.get(0).UrlPathPrefix;
        }
        else {
            return '';
        }*/
        return '';
    }

    /**
     * Get the base URL of the community portal. For example, if the community base URL is 'https://ascend.cs6.force.com/portal',
     * this function will return 'https://ascend.cs6.force.com/portal'
     *
     * @return:    The base URL of the community portal.
     * @since:     1.0
     */
    public static String getBaseUrl() {        
        URL request = URL.getCurrentRequestUrl();
        String urlString = request.toExternalForm();
        String host = request.getHost();
        String baseUrl = urlString.substringBefore(host) + host;

        System.debug('baseUrl: ' + baseUrl);

        // Network.getNetworkId() returns null in test classes:
        // https://help.salesforce.com/articleView?id=000273008&language=en_US&type=1
        if ((Test.isRunningTest() && testHasNetworkId == true) || Network.getNetworkId() != null) {

            // Using a list so that when running test classes, SOQL won't fail with 'List has no rows for assignments to SObject' error.
            List<Network> netList = [SELECT Id, Name, Description, Status, UrlPathPrefix FROM Network WHERE Id = :Network.getNetworkId()];

            //System.debug('netList: ' + netList);
            //System.debug('netList.get(0).UrlPathPrefix: ' + netList.get(0).UrlPathPrefix);

            if ((!netList.isEmpty() && netList.get(0).UrlPathPrefix == null) ||
                (Test.isRunningTest() && !testHasUrlPathPrefix)) {
                return baseUrl;
            }
            else if ((!netList.isEmpty()) ||
                     (Test.isRunningTest() && testHasNetwork)) {

                // Using ternary opeator to get test code coverage.
                return Test.isRunningTest() ? baseUrl : baseUrl + '/' + netList.get(0).UrlPathPrefix;
            }
            else {
                return baseUrl;
            }
        }
        else {
            return baseUrl;
        }
    }

    // As of now salesforce doesn't have a non-API way to get picklist values by record type
    public static Map<String, String> SERVER_getPicklistByRecordType(String objectType, String recordTypeId, String fieldName) {
        URL urlRequest = URL.getCurrentRequestUrl();
        String urlString = urlRequest.toExternalForm();
        String host = urlRequest.getHost();
        String endpointURL = urlString.substringBefore(host) + host;
        endpointURL += '/services/data/v41.0';
        endpointURL += '/ui-api/object-info/' +  objectType + '/picklist-values/' + recordTypeId +'/' + fieldName;
        EncodingUtil.urlEncode(endpointURL,'UTF-8');

        // Http request
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        request.setEndpoint(endpointURL);
        request.setMethod('GET');
        Http http = new Http();
        HTTPResponse response = http.send(request);

        //Parse response
        Map<String,String> result = new Map<String,String>();
        Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        if(!root.containsKey('values')){
            return result;
        }
        List<Object> pValues = (List<Object>)root.get('values');
        for(Object pValue : pValues){
            Map<String,Object> pValueMap = (Map<String,Object>)pValue;
            result.put((String)pValueMap.get('value'), (String)pValueMap.get('label'));
            System.debug(result);
        }

        return result;
    }

    public static Map<String, Map<String, List<Map<String, String>>>> SERVER_getPicklistEntries(Map<String, Object> params) {
        Map<String, List<String>> picklists = (Map<String, List<String>>) params.get(PARAM_PICKLISTS);
        Map<String, Map<String, List<Map<String, String>>>> returnMap = new Map<String, Map<String, List<Map<String, String>>>>();

        for (String objectAPIName : picklists.keySet()) {
            Map<String, Schema.SObjectField> fieldMap = ( (sObject) (Type.forName(objectAPIName)).newInstance()).getSObjectType().getDescribe().fields.getMap();
            for (String picklistAPIName : picklists.get(objectAPIName)) {
                // If fieldMap does not have this picklist, it could be either misconfiguration or state/country picklist is on. Skip if so.
                if (!fieldMap.containsKey(picklistAPIName)) {
                    continue;
                }
                
                Schema.DescribeFieldResult fieldDescribe =  fieldMap.get(picklistAPIName).getDescribe();
                Schema.DisplayType fieldType = fieldDescribe.getType();
                if (fieldMap.get(picklistAPIName) != null &&
                    (fieldType == Schema.DisplayType.Picklist ||
                    fieldType == Schema.DisplayType.MultiPicklist)) {
                    List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
                    List<Map<String, String>> picklist = new List<Map<String, String>>();
                    for (Schema.PicklistEntry entry : picklistEntries) {
                        Map<String, String> entryMap = new Map<String, String>();
                        entryMap.put('label', entry.getLabel());
                        entryMap.put('value', entry.getValue());
                        picklist.add(entryMap);
                    }
                    if (returnMap.containsKey(objectAPIName)) {
                        returnMap.get(objectAPIName).put(picklistAPIName, picklist);
                    } else {
                        returnMap.put(objectAPIName, new Map<String, List<Map<String, String>>>{picklistApiName => picklist});
                    }
                }                
            }
        }

        return returnMap;
    }

    @AuraEnabled
    public static String SERVER_getUserProfile() {
        Id profileId = UserInfo.getProfileId();
        Profile profile = [SELECT Id,
                           Name
                    FROM Profile
                    WHERE Id = :profileId];
        return profile.Name;
    }


    // @AuraEnabled
    // public static Map<String, Boolean> SERVER_getUserAccessLevelWithZoneList(List<String> permissions, List<String> zone) {
    //     Id userId = UserInfo.getUserId();
    //     Id contactId = [SELECT Id, ContactId FROM User WHERE Id = :userId LIMIT 1].ContactId;
    //     String profile = SERVER_getUserProfile();
    //     Map<String, Boolean> accessPermissions = new Map<String,Boolean>();

    //     if (profile.equals('ascend Customer Community Administrator') || profile.equals('System Administrator')) {
    //         for (String permission : permissions) {
    //             accessPermissions.put(permission, true);
    //         }

    //         return accessPermissions;
    //     }

    //     if (zone == null || zone.size() == 0) {
    //         for (String permission : permissions) {
    //             accessPermissions.put(permission, false);
    //         }

    //         return accessPermissions;
    //     }

    //     Schema.DescribeSObjectResult accessLevelObject = Zone_Access_Level__c.sObjectType.getDescribe();

    //     String queryString = 'SELECT ';
    //     for(string apiName : accessLevelObject.fields.getMap().keySet()){
    //         if (apiName.contains('__c') == true) {
    //             queryString = queryString + ' Zone_Access_Level__r.' + apiName + ',';
    //         }
    //     }

    //     //Drop the last comma
    //     queryString = queryString.substring(0, queryString.length() - 1);

    //    queryString = queryString + ' FROM Zone_Membership__c WHERE Zone__r.Name IN :zone AND Constituent__c = :contactId AND Constituent__r.Is_Display_On_Portal__c = true ';

    //     System.debug(queryString);
    //     List<Zone_Membership__c> memberships = Database.query(queryString);

    //     if (memberships != null && memberships.size() > 0 && memberships[0].Zone_Access_Level__r != null) {
    //         for (Zone_Membership__c membership : memberships) {
    //             if ( membership.Zone_Access_Level__r != null) {
    //                 for (String permission : permissions) {
    //                     if (accessPermissions.get(permission) == null || accessPermissions.get(permission) == false) {
    //                         accessPermissions.put(permission, (Boolean)membership.Zone_Access_Level__r.get(permission));
    //                     }
    //                 }
    //             }
    //         }
    //     }

    //     return accessPermissions;
    // }

    // //Add more permissions to the Zone_Membership__c
    // @AuraEnabled
    // public static Map<String, Boolean> SERVER_getUserAccessLevel(List<String> permissions, String zone) {
    //     Id userId = UserInfo.getUserId();
    //     Id contactId = [SELECT Id, ContactId FROM User WHERE Id = :userId LIMIT 1].ContactId;
    //     String profile = SERVER_getUserProfile();
    //     Map<String, Boolean> accessPermissions = new Map<String,Boolean>();

    //     if (profile.equals('ascend Customer Community Administrator') || profile.equals('System Administrator')) {
    //         for (String permission : permissions) {
    //             accessPermissions.put(permission, true);
    //         }

    //         return accessPermissions;
    //     }

    //     if (zone == null || String.isBlank(zone)) {
    //         for (String permission : permissions) {
    //             accessPermissions.put(permission, false);
    //         }

    //         return accessPermissions;
    //     }

    //     Schema.DescribeSObjectResult accessLevelObject = Zone_Access_Level__c.sObjectType.getDescribe();

    //     String queryString = 'SELECT ';
    //     for(string apiName : accessLevelObject.fields.getMap().keySet()){
    //         if (apiName.contains('__c') == true) {
    //             queryString = queryString + ' Zone_Access_Level__r.' + apiName + ',';
    //         }
    //     }

    //     //Drop the last comma
    //     queryString = queryString.substring(0, queryString.length() - 1);

    //    queryString = queryString + ' FROM Zone_Membership__c WHERE Zone__r.Name=:zone AND Constituent__c = :contactId AND Constituent__r.Is_Display_On_Portal__c = true LIMIT 1';

    //     System.debug(queryString);
    //     List<Zone_Membership__c> memberships = Database.query(queryString);

    //     if (memberships != null && memberships.size() > 0 && memberships[0].Zone_Access_Level__r != null) {
    //         for (String permission : permissions) {
    //             accessPermissions.put(permission, (Boolean)memberships[0].Zone_Access_Level__r.get(permission));
    //         }
    //     }

    //     return accessPermissions;
    // }

    public static String hashDataSha256(String dataStr) {
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(dataStr)));
    }

    public static String hashObjectFields(Map<String, Object> params) {
        sObjectType sobjType = (sObjectType) params.get(PARAM_SOBJECT_TYPE);
        sObject sobjRecord = (sObject) params.get(PARAM_SOBJECT_RECORD);

        if (sobjType == null || sobjRecord == null) {
            return '';
        }

        String sObjectApiName = sobjType.getDescribe().getName();
        if (Test.isRunningTest()) {
            sObjectApiName = 'Test_Object__c';
        }

        List<String> objectHashingFields = sobjToHashingFieldListForExternalId.get(sobjType.getDescribe().getName());
        Integer counter = 0;
        String dataStr = '';

        if (objectHashingFields != null && objectHashingFields.size() > 0) {
            for (String fieldApiName : objectHashingFields) {
                String fieldValue = String.valueOf(sobjRecord.get(fieldApiName));
                counter++;
                dataStr = dataStr + counter + (fieldValue == null ? '' : fieldValue.trim().toLowercase());
            }
        }

        if (String.isBlank(dataStr)) {
            return '';
        }
        else {
            return hashDataSha256(dataStr);
        }
    }


    @AuraEnabled
    public static String getPortalURL(){
        /*
        String baseSiteURL = '';

        List<ConnectApi.Community> communities = ConnectApi.Communities.getCommunities().communities;
        if (!communities.isEmpty()) {
            for (ConnectApi.Community currentCommunity: communities) {
                if (currentCommunity.name == 'Alumni Portal') {
                    baseSiteURL = currentCommunity.siteUrl;
                    if (!baseSiteURL.endsWith('/')) {
                        baseSiteURL += '/';
                    }
                }
            }
        }

        return baseSiteURL;
        */

        /*
        List<Portal_Organization_Setting__mdt> portalOrganizationSettings = [SELECT MasterLabel, Value__c FROM Portal_Organization_Setting__mdt WHERE MasterLabel = 'Community URL'];

        if (portalOrganizationSettings == null || portalOrganizationSettings.size() == 0) {
            return null;
        }

        String portalUrl = portalOrganizationSettings[0].Value__c;
        return portalUrl;
        */

        String portalUrl = '';
        List<Network> test = [SELECT Id FROM Network LIMIT 1];

        if (!test.isEmpty()) {
            String loginURL = Network.getLoginUrl(test[0].Id);
            Pattern urlMatcher = Pattern.compile('.+(\\.edu|\\.com|\\.org)'); // grabs src="<url>"
            Matcher urlMatches = urlMatcher.matcher(loginURL);

            if (urlMatches.find()) {
                portalUrl = urlMatches.group();
                if (!portalUrl.endsWith('/')) {
                    portalUrl += '/';
                }
            }
        }

        return portalUrl;
    }

    /**
     * Gets the portal url using the current networkId
     *
     * @return                          The portal base URL
     * @since                           1.17
     */
    @AuraEnabled
    public static String getPortalURLWithNetworkId(){
        Id networkId = Network.getNetworkId();
        List<Network> networkList = [SELECT Id FROM Network];

        if (!networkList.isEmpty()) {
            for (Network eachNetwork : networkList) {
                if (eachNetwork.Id == networkId) {
                    return Network.getLoginUrl(eachNetwork.Id).substringBeforeLast('/s/') + '/';
                }
            }

            return Network.getLoginUrl(networkList[0].Id).substringBeforeLast('/s/') + '/';
        }

        return '';
    }

    // @AuraEnabled
    // public static Map<String, String> getPortalURLMap(){
    //     Map<String, String> returnMap = new Map<String,String>();
    //     String baseURL = Site.getBaseUrl();
    //     String prefixURL = Site.getPathPrefix();

    //     returnMap.put('baseURL', baseURL);
    //     returnMap.put('prefixURL', prefixURL);
    //     return returnMap;
    // }

    /**
     * Changes a infix expression to a postfix expression.
     * Considers AND, OR as the same precedence.
     * currently allows Integers, 'AND', 'OR', '(', ')'
     *
     * @param   infixNotationString     String of infix expression
     * @return                          postfix expression of the infix expression provided
     * @since                           1.0
     */
    public static List<String> infixToPostfix(Map<String, Object> params) {
        String infixNotationString = (String) params.get(PARAM_LOGIC_STRING);

        List<String> postfix = new List<String>();

        if(String.isBlank(infixNotationString)) {
            return postfix;
        }

        // added these to allow space to be a divider betweens operands and operators
        infixNotationString = infixNotationString.replaceAll('[o|O][r|R]', 'OR'); // replace any version of lower/upper case 'or' with all uppercase 'OR'
        infixNotationString = infixNotationString.replaceAll('[a|A][n|N][d|D]', 'AND'); // replace any version of lower/upper case 'and' with all uppercase 'AND'
        infixNotationString = infixNotationString.replace('AND', ' AND ');
        infixNotationString = infixNotationString.replace('OR', ' OR ');

        if (infixNotationString.length() == 1) {
            postfix.add(infixNotationString);
            return postfix;
        }

        List<String> Stack = new List<String>(); // treat the list as a stack

        String currentChunk = ''; // keeps track of the current chuck of chacters between a space. Keeps track of multi-character operands or operators
        infixNotationString += ' '; // add a space in the end to allow for the last chunck of characters to be processed in the loop
        List<String> filterCharacters = infixNotationString.split('');

        for (Integer i = 0; i < filterCharacters.size(); i++) {
            String currentCharacter = filterCharacters[i];

            if (currentCharacter == ' ') { // marks the end of the currentChunck of characters

                if (!String.isEmpty(currentChunk)) {

                    if (currentChunk.toUpperCase() == 'AND' || currentChunk.toUpperCase() == 'OR') { // AND, OR
                        while (!Stack.isEmpty() && Stack[Stack.size() -1] != ')' && Stack[Stack.size() -1] != '('){
                            postfix.add(Stack.remove(Stack.size() - 1));
                        }
                        Stack.add(currentChunk);
                    }
                    else if (currentChunk.isNumeric()) {
                        postfix.add(currentChunk);
                    }
                    else {
                        System.debug('ERROR IN INFIX TO POSTFIX');
                    }
                }
                currentChunk = '';
                //continue;
            }
            else if (currentCharacter == '(') {
               Stack.add(currentCharacter);
            }
            else if (currentCharacter == ')') {

                if (stack.size() == 0) {
                    System.debug('ERROR. TRIED TO POP FROM EMPTY STACK.');
                }

                if (currentChunk != '') {
                    postfix.add(currentChunk);
                    currentChunk = '';
                }

                String stackChar = stack.remove(stack.size() - 1);
                while (stackChar != '(') {
                    postfix.add(stackChar);
                    stackChar=stack.remove(stack.size() - 1);
                }

            } else {
                currentChunk += currentCharacter;
            }
        }

        while (stack.size() > 0) {
            postfix.add(stack.remove(stack.size() - 1));
        }

        return postfix;
    }

    // /**
    //  * Send single email to the list of ids provided
    //  *
    //  * @param   userIds             Ids of users/contacts you want to send the email to
    //  * @param   htmlBody            html body of the email
    //  * @param   plaintextBody       plaintext body of the email
    //  * @param   subjectLine         subject line for the email
    //  * @param   displayName         display name to show who the email is from
    //  * @since                       1.0
    //  */
    // public static void sendSingleEmail(List<Id> userIds, String htmlBody, String plaintextBody, String subjectLine, String displayName){

    //     for (Id userId: userIds) {
    //         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    //         message.saveAsActivity = false;
    //         message.setTargetObjectId(userId);
    //         message.setSubject(subjectLine);
    //         message.setPlainTextBody(plaintextBody);
    //         message.setHtmlBody(htmlBody);
    //         if (displayName != null) {
    //             message.setSenderDisplayName(displayName);
    //         }
    //         Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
    //         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, false);
    //     }
    //     //if (results[0].getErrors().size() > 0) {
    //     //    throw new AuraHandledException('There was a problem with the emails you sent, double check to make sure it is correct.');
    //     //}
    // }

    /**
     * method that updates a date time time based on a time zone
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param submittedTimeZone:            The time zone on the listing
     * @param acutalTime:                   The string of the time that needs to be converted
     * @return:                             The date time of the actual time in the converted time zone
     */

    public static DateTime getTimeDifference(String submittedTimeZone, String actualTime) {
        String gmtZone = '(' + submittedTimeZone.substringBetween('(', ')') + ')';
        submittedTimeZone = submittedTimeZone.remove(gmtZone);
        submittedTimeZone = submittedTimeZone.substringBetween('(', ')');
        TimeZone listingTimeZone = TimeZone.getTimeZone(submittedTimeZone);
        DateTime testDateTime = DateTime.now();
        Integer offset = listingTimeZone.getOffset(testDateTime)/1000;
        DateTime gmtDate = DateTime.valueOfGMT(actualTime);
        DateTime convertedDate = gmtDate.addSeconds(0-offset);
        return convertedDate;

    }

    /**
    * method that validates the the time fields on sobjects that have both a
    * datetime field and a string field that represents the date time
    * generalizes the code since the logic is the same, but the field names can be different
    *
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    * @param newRecord:                             The sObject record to update
    * @param oldRecord:                             The old version of the newRecord that holds historical data (can be null if called from isInsert)
    * @param dateTimeFieldAPIName:                  The api name of the field that has the type Date Time
    * @param stringFieldAPIName:                    The api name of the field that has the type String
    * @param newTimeZone:                           The time zone that these date fields need to be converted to
    * @param oldTimeZone:                           The old time zone of the record (can be null if called from isInsert or if the parent record holds the time zone)
    */
    public static void validateAndUpdateDateTimeFields(Map<String, Object> params) {
        if (params == null) {
            return;
        }

        sObject newRecord = (sObject)params.get(PARAM_NEW_RECORD);
        SObject oldRecord = (sObject)params.get(PARAM_OLD_RECORD);
        String dateTimeFieldAPIName = (String)params.get(PARAM_DATE_TIME_FIELD_API_NAME);
        String stringFieldAPIName = (String)params.get(PARAM_STRING_FIELD_API_NAME);
        String newTimeZone = (String)params.get(PARAM_NEW_TIME_ZONE);
        String oldTimeZone = (String)params.get(PARAM_OLD_TIME_ZONE);

        if ((oldRecord != null && oldRecord.get(dateTimeFieldAPIName) != newRecord.get(dateTimeFieldAPIName))
            || (oldRecord == null && String.isBlank((String) newRecord.get(stringFieldAPIName)))) {
            if (newRecord.get(dateTimeFieldAPIName) != null) {
                //updates the string field to have the correct time
                //uses GMT time since the date time field is set from the front end in the GMT time zone
                newRecord.put(stringFieldAPIName, String.valueOfGMT((DateTime) newRecord.get(dateTimeFieldAPIName)));
                //updates the date time to the time zone specified by the user
                if (!String.isBlank(newTimeZone)) {
                    newRecord.put(dateTimeFieldAPIName, PORTAL_CommunityUtils.getTimeDifference(newTimeZone, (String) newRecord.get(stringFieldAPIName)));
                }
            } else {
                //if the record was cleared of a date time then clear the string field
                newRecord.put(stringFieldAPIName, null);
            }

        } else if ((oldRecord != null && newRecord.get(stringFieldAPIName) != oldRecord.get(stringFieldAPIName))
            || (oldRecord == null &&  newRecord.get(dateTimeFieldAPIName) == null)){
                if (!String.isBlank((String)newRecord.get(stringFieldAPIName)) && !String.isBlank(newTimeZone)) {
                    //populates the date time field with the value from the string field converted to the right time zone
                    newRecord.put(dateTimeFieldAPIName, PORTAL_CommunityUtils.getTimeDifference(newTimeZone, (String) newRecord.get(stringFieldAPIName)));
                } else if (String.isBlank((String)newRecord.get(stringFieldAPIName))) {
                    //if the string field was cleared then clear the date time field
                    newRecord.put(dateTimeFieldAPIName, null);
                }
        } else if (oldTimeZone != null && oldTimeZone != newTimeZone && !String.isBlank(newTimeZone) && !String.isBlank((String) newRecord.get(stringFieldAPIName))) {
            //updates the date time field if only the time zone was changed
            newRecord.put(dateTimeFieldAPIName, PORTAL_CommunityUtils.getTimeDifference(newTimeZone, (String) newRecord.get(stringFieldAPIName)));
        }
    }

    /**
     * Method that takes two values and compares them based on an operator
     * used when trying to compare constituent attributes against a content filter
     * 
     * @since 1.0
     * 
     * @param firstValue:       The first value to use in the comparison (it will be the value from the constituent record)
     * @param secondValue:      The second value to use in the comparison (it will be the value from the content filter)
     * @param operator:         The operation to perform
     * @param operandType:      The type of the operands (i.e. firstValue and secondValue)
     * 
     * @return The result of the expression
     */
    public static Boolean evaluateExpression(Map<String, Object> params) {
        String firstValue = (String) params.get(PARAM_FIRST_VALUE);
        String secondValue = (String) params.get(PARAM_SECOND_VALUE);
        String operator = (String) params.get(PARAM_OPERATOR);

        String operandType = (String) params.get(PARAM_OPERAND_TYPE);
        if (String.isBlank(operandType)) {
            operandType = STRING_CONST;
        }

        if (operandType == STRING_CONST) {
            return evaluateStringExpression(firstValue, secondValue, operator);
        }
        else if (operandType == NUMBER_CONST) {
            return evaluateNumericExpression(firstValue != null ? Decimal.valueOf(firstValue) : null, secondValue != null ? Decimal.valueOf(secondValue) : null, operator);
        }
        else if (operandType == BOOLEAN_CONST) {
            return evaluateBooleanExpression(firstValue != null ? Boolean.valueOf(firstValue) : null, secondValue != null ? Boolean.valueOf(secondValue) : null, operator);
        }
        else if (operandType == DATE_CONST) {
            return evaluateDateExpression(firstValue != null ? Date.valueOf(firstValue) : null, secondValue != null ? Date.valueOf(secondValue) : null, operator);
        }
        else if (operandType == DATETIME_CONST) {
            return evaluateDatetimeExpression(firstValue != null ? Datetime.valueOf(firstValue) : null, secondValue != null ? Datetime.valueOf(secondValue) : null, operator);
        }
        else {    
            return false;
        }
    }

    /**
     * Method that takes two String values and compares them based on an operator
     * 
     * @since 1.1
     * 
     * @param firstValue:       The first String value to use in the comparison (value from constituent record)
     * @param secondValue:      The second String value to use in the comparison (value from content filter)
     * @param operand:          The operation to perform
     * 
     * @return The result of the expression
     */
    public static Boolean evaluateStringExpression(String firstValue, String secondValue, String operator) {
        if (operator == EQ_OPERATOR) {
            return firstValue == secondValue;
        }
        else if (operator == NE_OPERATOR) {
            return firstValue != secondValue;
        }
        else if (operator == GT_OPERATOR) {
            return firstValue > secondValue;
        }
        else if (operator == GE_OPERATOR) {
            return firstValue >= secondValue;
        }
        else if (operator == LT_OPERATOR) {
            return firstValue < secondValue;
        }
        else if (operator == LE_OPERATOR) {
            return firstValue <= secondValue;
        }
        else if (operator == LIKE_OPERATOR) {
            return ((String)firstValue).contains((String)secondValue);
        }
        //The content filter's values for these operations will be a string with the
        //picklist values separated by a semi-colon
        else if (operator == IN_OPERATOR) {
            Set<String> stringSet = new Set<String>(secondValue.split(';'));
            return stringSet.contains(firstValue);
        }
        else if (operator == NOT_IN_OPERATOR) {
            Set<String> stringSet = new Set<String>(secondValue.split(';'));
            return !stringSet.contains(firstValue);
        }
        else if (operator == INCLUDES_OPERATOR) {
            if (String.isBlank(firstValue)) {
                return false;
            }
            Set<String> stringSet = new Set<String>(secondValue.split(';'));
            Set<String> valueSet = new Set<String>(firstValue.split(';'));
            valueSet.retainAll(stringSet);
            return valueSet.size() > 0;
        }
        else if (operator == EXCLUDES_OPERATOR) {
            if (String.isBlank(firstValue)) {
                return false;
            }
            Set<String> stringSet = new Set<String>(secondValue.split(';'));
            Set<String> valueSet = new Set<String>(firstValue.split(';'));
            valueSet.removeAll(stringSet);
            return valueSet.size() > 0;
        }
        else if (operator == BLANK_OPERATOR) {
            return String.isBlank(firstValue);
        }
        else if (operator == NOTBLANK_OPERATOR) {
            return String.isNotBlank(firstValue);
        }
        else {
            return false;
        }
    }

    /**
     * Method that takes two numeric values and compares them based on an operator
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param firstValue:       The first numeric value to use in the comparison (value from constituent record)
     * @param secondValue:      The second numeric value to use in the comparison (value from content filter)
     * @param operand:          The operation to perform
     * 
     * @return The result of the expression
     */
    public static Boolean evaluateNumericExpression(Decimal firstValue, Decimal secondValue, String operator) {
        if (operator == EQ_OPERATOR) {
            return firstValue == secondValue;
        }
        else if (operator == NE_OPERATOR) {
            return firstValue != secondValue;
        }
        else if (operator == GT_OPERATOR) {
            return firstValue > secondValue;
        }
        else if (operator == GE_OPERATOR) {
            return firstValue >= secondValue;
        }
        else if (operator == LT_OPERATOR) {
            return firstValue < secondValue;
        }
        else if (operator == LE_OPERATOR) {
            return firstValue <= secondValue;
        }
        else if (operator == BLANK_OPERATOR) {
            return firstValue == null;
        }
        else if (operator == NOTBLANK_OPERATOR) {
            return firstValue != null;
        }
        else {
            return false;
        }
    }

    /**
     * Method that takes two Boolean values and compares them based on an operator
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param firstValue:       The first Boolean value to use in the comparison (value from constituent record)
     * @param secondValue:      The second Boolean value to use in the comparison (value from content filter)
     * @param operand:          The operation to perform
     * 
     * @return The result of the expression
     */
    public static Boolean evaluateBooleanExpression(Boolean firstValue, Boolean secondValue, String operator) {
        if (operator == EQ_OPERATOR) {
            return firstValue == secondValue;
        }
        else if (operator == NE_OPERATOR) {
            return firstValue != secondValue;
        }
        else if (operator == BLANK_OPERATOR) {
            return firstValue == null;
        }
        else if (operator == NOTBLANK_OPERATOR) {
            return firstValue != null;
        }
        else {
            return false;
        }
    }

    /**
     * Method that takes two date values and compares them based on an operator
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param firstValue:       The first date value to use in the comparison (value from constituent record)
     * @param secondValue:      The second date value to use in the comparison (value from content filter)
     * @param operand:          The operation to perform
     * 
     * @return The result of the expression
     */
    public static Boolean evaluateDateExpression(Date firstValue, Date secondValue, String operator) {
        if (operator == EQ_OPERATOR) {
            return firstValue == secondValue;
        }
        else if (operator == NE_OPERATOR) {
            return firstValue != secondValue;
        }
        else if (operator == GT_OPERATOR) {
            return firstValue > secondValue;
        }
        else if (operator == GE_OPERATOR) {
            return firstValue >= secondValue;
        }
        else if (operator == LT_OPERATOR) {
            return firstValue < secondValue;
        }
        else if (operator == LE_OPERATOR) {
            return firstValue <= secondValue;
        }
        else if (operator == BLANK_OPERATOR) {
            return firstValue == null;
        }
        else if (operator == NOTBLANK_OPERATOR) {
            return firstValue != null;
        }
        else {
            return false;
        }
    }

    /**
     * Method that takes two datetime values and compares them based on an operator
     * 
     * @author Jacob Huang
     * @since 1.1
     * 
     * @param firstValue:       The first datetime value to use in the comparison (value from constituent record)
     * @param secondValue:      The second datetime value to use in the comparison (value from content filter)
     * @param operand:          The operation to perform
     * 
     * @return The result of the expression
     */
    public static Boolean evaluateDatetimeExpression(Datetime firstValue, Datetime secondValue, String operator) {
        if (operator == EQ_OPERATOR) {
            return firstValue == secondValue;
        }
        else if (operator == NE_OPERATOR) {
            return firstValue != secondValue;
        }
        else if (operator == GT_OPERATOR) {
            return firstValue > secondValue;
        }
        else if (operator == GE_OPERATOR) {
            return firstValue >= secondValue;
        }
        else if (operator == LT_OPERATOR) {
            return firstValue < secondValue;
        }
        else if (operator == LE_OPERATOR) {
            return firstValue <= secondValue;
        }
        else if (operator == BLANK_OPERATOR) {
            return firstValue == null;
        }
        else if (operator == NOTBLANK_OPERATOR) {
            return firstValue != null;
        }
        else {
            return false;
        }
    }

    // /**
    //  * Gets the specified email template.
    //  *
    //  * @author Aaron Wong
    //  *
    //  * @param developerName                     The api name of the email template to get.
    //  * @return                                  SUCCESS if success
    //  * @since                                   1.0
    //  */
    public static EmailTemplate getEmailTemplate(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return null;
        }

        String developerName = (String) params.get(DEVELOPER_NAME);

        List<EmailTemplate> emailTemplateList = [SELECT id, DeveloperName, HtmlValue, Subject, Body FROM EmailTemplate WHERE DeveloperName = :developerName];

        if (emailTemplateList == null || emailTemplateList.isEmpty()) {
            return null;
        }

        return emailTemplateList.get(0);
    }

    /**
     * Sends emails provided.
     *
     * @author Aaron Wong
     *
     * @param emailList             List of emails to send.
     * @since: 1.0
     */
    public static void sendEmails(Map<String,Object> params) {
        String debugLog = 'PORTAL_CommunityUtils.sendEmails: ';

        if (params == null || params.isEmpty()) {
            System.debug(debugLog + 'No Params');
            return;
        }

        List<Messaging.SingleEmailMessage> emailList = (List<Messaging.SingleEmailMessage>) params.get(EMAIL_TO_SEND_LIST);

        if (emailList == null || emailList.isEmpty()) {
            System.debug(debugLog + 'No Email List');
            return;
        }

        // Messaging.sendEmail only allows you to send 10 at a time
        for (Integer emailIndex = 0; emailIndex < emailList.size(); emailIndex = emailIndex + 10) {
            List<Messaging.SingleEmailMessage> batchedEmails = new List<Messaging.SingleEmailMessage>();

            for (Integer emailInBatchIndex = emailIndex; emailInBatchIndex < emailIndex + 10; emailInBatchIndex++) {
                if (emailInBatchIndex < emailList.size() && emailList[emailInBatchIndex] != null) {
                    batchedEmails.add(emailList[emailInBatchIndex]);
                }
            }

            Messaging.sendEmail(batchedEmails);
        }
    }

    /**
     * Get username based on email address.
     * 
     * @author Todd Shinto
     * @since 1.11
     * 
     * @param emailAddress String: The email address to use to query a user.
     * 
     * @return             A user record
     */
    public static User getUserFromEmail(String emailAddress) {
        if (String.isBlank(emailAddress)) {
            return null;
        }

        List<User> userList = [SELECT Id, FirstName, LastName, Email, Username, ContactId
                               FROM User
                               WHERE Email = :emailAddress
                               AND ContactId != null];

        if (userList.isEmpty()) {
            return null;
        }

        return userList.get(0);
    }

    /**
     * Replaces the merge fields with their appropriate values.
     *
     * @author Aaron Wong
     *
     * @param mergeFieldToReplacementValue              Map of merge fields to the value to replace the merge fields with.
     * @param originalText                              String to operate on.
     * @return                                          The original text with the merge fields replaced.
     * @since: 1.0
     */
    public static String replaceMergeFields(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return '';
        }

        Map<String, String> mergeFieldToReplacementValue = (Map<String, String>) params.get(MERGE_FIELD_REPLACEMENT);
        String originalText = (String) params.get(MERGE_FIELD_ORIGINAL_TEXT);
        String resultString = originalText;

        if (mergeFieldToReplacementValue == null || mergeFieldToReplacementValue.isEmpty()
                || String.isBlank(originalText)) {
            return resultString;
        }

        for (String eachMergeField : mergeFieldToReplacementValue.keySet()) {
            if (String.isBlank(eachMergeField) || mergeFieldToReplacementValue.get(eachMergeField) == null) {
                continue;
            }

            String replacementValue = mergeFieldToReplacementValue.get(eachMergeField);

            // Format merge fields
            eachMergeField = '\\{\\!' + eachMergeField + '\\}';

            resultString = resultString.replaceAll(eachMergeField, replacementValue);
        }

        return resultString;
    }

    /**
     * Wrapper class to for an email recipient.
     *
     * @author Aaron Wong
     *
     * @version 1.0
     * @since 1.0
     */
    public class EmailRecipient {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String email {get; set;}

        public EmailRecipient() {}

        public EmailRecipient(String firstName, String lastName, String email) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
        }
    }


    // /**
    //  * Gets users for the email recipients provided. If no user is found, creates one.
    //  *
    //  * @author Aaron Wong
    //  *
    //  * @param emailRecipientList        List of email recipients.
    //  * @return                          Map of emails to their corresponding users.
    //  * @since: 1.0
    //  */
    public static Map<String, User> getUsersToEmail(Map<String, Object> params) {
        Map<String, User> resultMap = new Map<String, User>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        List<EmailRecipient> emailRecipientList = (List<EmailRecipient>) params.get(EMAIL_RECIPIENT_LIST);

        // Get profile Id used to create users to send emails
        String profileId = getEmailProfileId();

        if (String.isBlank(profileId) || emailRecipientList == null || emailRecipientList.isEmpty()) {
            return resultMap;
        }

        Set<String> emailSet = new Set<String>();

        // Get emails for each recipient
        for (EmailRecipient eachRecipient : emailRecipientList) {
            if (String.isNotBlank(eachRecipient.email)) {
                emailSet.add(eachRecipient.email);
            }
        }

        // Search for user with the same email (Can bypass email message limits by sending to users)
        List<User> userList = [SELECT id, Email FROM User WHERE Email IN :emailSet];

        for (User userRecord : userList) {
            resultMap.put(userRecord.email, userRecord);
        }

        List<User> newUserList = new List<User>();

        // Create new users for participations not linked to a user
        for (EmailRecipient eachRecipient : emailRecipientList) {
            if (resultMap.containsKey(eachRecipient.email.toLowerCase())) {
                continue;
            }

            User newUser = new User();
            newUser.firstName = eachRecipient.firstName;
            newUser.lastName = eachRecipient.lastName;
            newUser.Email = eachRecipient.email;
            newUser.Alias = eachRecipient.email.substring(0,8);
            newUser.Username = eachRecipient.email + '.dummyUser.' + UserInfo.getOrganizationId();
            newUser.LocaleSidKey = 'en_US';
            newUser.TimeZoneSidKey = 'GMT';
            newUser.ProfileId = profileId;
            newUser.LanguageLocaleKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.isActive = false;

            newUserList.add(newUser);
            resultMap.put(newUser.email, newUser);
        }

        insert newUserList;

        return resultMap;
    }

    // /**
    //  * Gets the profile to create users to send emails to.
    //  *
    //  * @author Aaron Wong
    //  *
    //  * @return              Profile Ids used to create users to email to.
    //  * @since: 1.0
    //  */
    public static String getEmailProfileId() {
        List<Portal_Organization_Setting__mdt> portalOrganizationSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Email_Profile'}
        });

        if (portalOrganizationSettingList == null || portalOrganizationSettingList.isEmpty() || String.isBlank(portalOrganizationSettingList.get(0).Value__c)) {
            return '';
        }

        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = :portalOrganizationSettingList.get(0).Value__c];

        if (profileList == null || profileList.isEmpty()) {
            return '';
        }

        return profileList.get(0).Id;
    }

    /**
     * Create an email record based on the information given.
     *
     * @author Aaron Wong
     *
     * @param userId                    The user id to use
     * @param emailAddressList          A list of email addresses (recipients)
     * @param senderDisplayName         Display name for the sender
     * @param subject                   Subject of the email
     * @param emailBody                 The email body.  If passed in, merge replacement was already done
     * @param emailTemplateRecord       The email template record to use, required if using classic letterheads
     * @param mergeFieldValueMap        The merge fields to replace, if using classic letterheads
     * @param emailAttachments          A list of attachments to attach to the email
     * @return                          An email message.
     * @since: 1.0
     */
    public static Messaging.SingleEmailMessage createEmailRecord(Map<String, Object> params) {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();

        if (params == null || params.isEmpty()) {
            return null;
        }

        String userId = (String)params.get(USER_ID);
        List<String> emailAddressList = (List<String>)params.get(EMAIL_ADDRESS_LIST);
        String senderDisplayName = (String)params.get(SENDER_DISPLAY_NAME);
        String subject = (String)params?.get(SUBJECT_KEY);
        String emailBody = (String)params?.get(EMAIL_BODY);
        EmailTemplate emailTemplateRecord = (EmailTemplate)params?.get(EMAIL_TEMPLATE_RECORD);
        Map<String, String> mergeFieldValueMap = (Map<String, String>)params?.get(MERGE_FIELD_VALUE_MAP);
        List<Messaging.EmailFileAttachment> emailAttachments = (List<Messaging.EmailFileAttachment>)params.get(EMAIL_ATTACHMENTS);

        if (String.isBlank(userId) && (emailAddressList == null || emailAddressList.isEmpty())) {
            return null;
        }

        if (String.isNotBlank(userId)) {
            emailMessage.setTargetObjectId(userId);
        } else {
            emailMessage.setToAddresses(emailAddressList);
        }

        // Email Template record should set the subject and the html body
        if (emailTemplateRecord != null) {
            emailBody = getRenderedHtmlBody(emailTemplateRecord, mergeFieldValueMap);
            subject = emailTemplateRecord.Subject;
        }

        emailMessage.saveAsActivity = false;
        emailMessage.setBccSender(false);
        emailMessage.setUseSignature(false);
        emailMessage.setSenderDisplayName(senderDisplayName);
        emailMessage.setSubject(subject);

        emailMessage.setHtmlBody(emailBody);

        if (emailAttachments != null && !emailAttachments.isEmpty()) {
            emailMessage.setFileAttachments(emailAttachments);
        }

        return emailMessage;
    }

    /**
     * Gets a rendered HTML body to allow Classic Letterheads to work
     *
     * @author Todd Shinto
     * @since  1.19
     *
     * @param emailTemplateRecord   The email template to render
     * @param mergeFieldValueMap    The fields to replace
     * 
     * @return                      An email html body
     */
    private static String getRenderedHtmlBody(EmailTemplate emailTemplateRecord, Map<String, String> mergeFieldValueMap) {
        Messaging.SingleEmailMessage renderedEmail = Messaging.renderStoredEmailTemplate(emailTemplateRecord.Id, null, null);
        String emailBodyToReturn = getEmailBodyWithRenderedEmailTemplate(emailTemplateRecord, renderedEmail);

        if (mergeFieldValueMap != null && !mergeFieldValueMap.isEmpty()) {
            emailBodyToReturn = replaceMergeFields(new Map<String, Object>{
                MERGE_FIELD_REPLACEMENT => mergeFieldValueMap,
                MERGE_FIELD_ORIGINAL_TEXT => emailBodyToReturn
            });
        }
        
        return emailBodyToReturn;
    }

    /**
     * Returns an email body after doing a comparison between an EmailTemplate record and a renderedEmail
     *
     * @author Todd Shinto
     * @since  1.19
     *
     * @param emailTemplateRecord   The email template to render
     * @param renderedEmail         A rendered email
     * 
     * @return                      An email html body, including merge fields (if a matching pattern is found)
     */
    private static String getEmailBodyWithRenderedEmailTemplate(EmailTemplate emailTemplateRecord, Messaging.SingleEmailMessage renderedEmail) {
        if (String.isBlank(renderedEmail.getHtmlBody())) {
            return emailTemplateRecord.Body;
        }

        String tEditId = getMatchedValueWithRegexp(T_EDIT_ID_PATTERN, emailTemplateRecord.HtmlValue);
        String cDataString = getMatchedValueWithRegexp(CDATA_PATTERN, emailTemplateRecord.HtmlValue);

        if (String.isBlank(tEditId) || String.isBlank(cDataString)) {
            // If there is no tEditId or CDATA string found, we have nothing to compare to, so pass back the html body with no merge fields
            return renderedEmail.getHtmlBody();
        }

        return getRenderedEmailBodyWithMergeFields(tEditId, cDataString, renderedEmail.getHtmlBody());
    }

    /**
     * A method that uses RegExp to find and return a matching string
     *
     * @author Todd Shinto
     * @since  1.19
     *
     * @param patternString     Pattern to use to match
     * @param stringToMatch     The string to search
     * 
     * @return                  The match
     */
    private static String getMatchedValueWithRegexp(String patternString, String stringToMatch) {
        Pattern patternToUse = Pattern.compile(patternString);
        Matcher matcherToUse = patternToUse.matcher(stringToMatch);

        if (!matcherToUse.find()) {
            return '';
        }

        return matcherToUse.group(1);
    }

    /**
     * A method that uses RegExp to find and return a matching string
     *
     * @author Todd Shinto
     * @since  1.19
     *
     * @param tEditId                   The HTML Id of the <td> element that contains the CDATA string
     * @param cDataString               The CDATA String found in EmailTemplates.  Represents the content.  Contains {!MergeFields}
     * @param renderedEmailHtmlBody     The html body rendered by Messaging.renderStoredEmailTemplate(), {!MergeFields} are removed
     * 
     * @return                          The rendered html body, with {!MergeFields} added back in.
     */
    private static String getRenderedEmailBodyWithMergeFields(String tEditId, String cDataString, String renderedEmailHtmlBody) {
        String tdPattern = T_EDIT_ID_TD_OPEN_TAG_PATTERN + tEditId + T_EDIT_ID_TD_CLOSING_TAG_PATTERN;

        renderedEmailHtmlBody = renderedEmailHtmlBody.replaceAll(tdPattern, TD_OPEN_TAG_WITH_T_EDIT_ID + tEditId + TD_CLOSING_ANGLE_BRACKET + cDataString + TD_CLOSING_TAG);

        return renderedEmailHtmlBody;
    }

    // public static String getFullStateName(String abbName) {
    //     if (abbName == 'AL') {
    //         return 'Alabama';
    //     } else if (abbName == 'AK') {
    //         return 'Alaska';
    //     } else if (abbName == 'AZ') {
    //         return 'Arizona';
    //     } else if (abbName == 'AR') {
    //         return 'Arkansas';
    //     } else if (abbName == 'CA') {
    //         return 'California';
    //     } else if (abbName == 'CO') {
    //         return 'Colorado';
    //     } else if (abbName == 'CT') {
    //         return 'Connecticut';
    //     } else if (abbName == 'DE') {
    //         return 'Delaware';
    //     } else if (abbName == 'FL') {
    //         return 'Florida';
    //     } else if (abbName == 'GA') {
    //         return 'Georgia';
    //     } else if (abbName == 'HI') {
    //         return 'Hawaii';
    //     } else if (abbName == 'ID') {
    //         return 'Idaho';
    //     } else if (abbName == 'IL') {
    //         return 'Illinois';
    //     } else if (abbName == 'IN') {
    //         return 'Indiana';
    //     } else if (abbName == 'IA') {
    //         return 'Iowa';
    //     } else if (abbName == 'KS') {
    //         return 'Kansas';
    //     } else if (abbName == 'KY') {
    //         return 'Kentucky';
    //     } else if (abbName == 'LA') {
    //         return 'Louisiana';
    //     } else if (abbName == 'ME') {
    //         return 'Maine';
    //     } else if (abbName == 'MD') {
    //         return 'Maryland';
    //     } else if (abbName == 'MA') {
    //         return 'Massachusetts';
    //     } else if (abbName == 'MI') {
    //         return 'Michigan';
    //     } else if (abbName == 'MN') {
    //         return 'Minnesota';
    //     } else if (abbName == 'MS') {
    //         return 'Mississippi';
    //     } else if (abbName == 'MO') {
    //         return 'Missouri';
    //     } else if (abbName == 'MT') {
    //         return 'Montana';
    //     } else if (abbName == 'NE') {
    //         return 'Nebraska';
    //     } else if (abbName == 'NV') {
    //         return 'Nevada';
    //     } else if (abbName == 'NH') {
    //         return 'New Hampshire';
    //     } else if (abbName == 'NJ') {
    //         return 'New Jersey';
    //     } else if (abbName == 'NM') {
    //         return 'New Mexico';
    //     } else if (abbName == 'NY') {
    //         return 'New York';
    //     } else if (abbName == 'NC') {
    //         return 'North Carolina';
    //     } else if (abbName == 'ND') {
    //         return 'North Dakota';
    //     } else if (abbName == 'OH') {
    //         return 'Ohio';
    //     } else if (abbName == 'OK') {
    //         return 'Oklahoma';
    //     } else if (abbName == 'OR') {
    //         return 'Oregon';
    //     } else if (abbName == 'PA') {
    //         return 'Pennsylvania';
    //     } else if (abbName == 'RI') {
    //         return 'Rhode Island';
    //     } else if (abbName == 'SC') {
    //         return 'South Carolina';
    //     } else if (abbName == 'SD') {
    //         return 'South Dakota';
    //     } else if (abbName == 'TN') {
    //         return 'Tennessee';
    //     } else if (abbName == 'TX') {
    //         return 'Texas';
    //     } else if (abbName == 'UT') {
    //         return 'Utah';
    //     } else if (abbName == 'VT') {
    //         return 'Vermont';
    //     } else if (abbName == 'VA') {
    //         return 'Virginia';
    //     } else if (abbName == 'WA') {
    //         return 'Washington';
    //     } else if (abbName == 'WV') {
    //         return 'West Virginia';
    //     } else if (abbName == 'WI') {
    //         return 'Wisconsin';
    //     } else if (abbName == 'WY') {
    //         return 'Wyoming';
    //     }

    //     return abbName;
    // }

    // public static String getAbbreviatedStateName (String state) {
    //     Map<String, String> stateNameToAbbreviation = new Map<String,String>{ 'alabama'=>'AL','alaska'=>'AK','arizona'=>'AZ','arkansas'=>'AR','california'=>'CA','colorado'=>'CO','connecticut'=>'CT','delaware'=>'DE','district of columbia'=>'DC','florida'=>'FL','georgia'=>'GA','guam'=>'GU','hawaii'=>'HI','idaho'=>'ID','illinois'=>'IL','indiana'=>'IN','iowa'=>'IA','kansas'=>'KS','kentucky'=>'KY','louisiana'=>'LA','maine'=>'ME','maryland'=>'MD','massachusetts'=>'MA','michigan'=>'MI','minnesota'=>'MN','mississippi'=>'MS','missouri'=>'MO','montana'=>'MT','nebraska'=>'NE','nevada'=>'NV','new hampshire'=>'NH','new jersey'=>'NJ','new mexico'=>'NM','new york'=>'NY','north carolina'=>'NC','north dakota'=>'ND','ohio'=>'OH','oklahoma'=>'OK','oregon'=>'OR','pennsylvania'=>'PA','puerto rico'=>'PR','rhode island'=>'RI','south carolina'=>'SC','south dakota'=>'SD','tennessee'=>'TN','texas'=>'TX','utah'=>'UT','vermont'=>'VT','virginia'=>'VA','washington'=>'WA','west virginia'=>'WV','wisconsin'=>'WI','wyoming'=>'WY' };
    //     if (stateNameToAbbreviation.containsKey(state.toLowercase())) {
    //         return stateNameToAbbreviation.get(state.toLowercase());
    //     }

    //     return state;
    // }

    // public static User getPortalOwnerUser() {
    //     List<Portal_Organization_Setting__mdt> internalPortalUsers = [SELECT DeveloperName, Value__c FROM Portal_Organization_Setting__mdt WHERE DeveloperName = 'Internal_Portal_Listing_Owner'];

    //     if (internalPortalUsers.isEmpty()) {
    //         throw new ListException('There is no record called \'Internal Portal Listing Owner\' in Portal Organization Setting custom metadata');
    //     }
    //     else if (internalPortalUsers.size() > 1) {
    //         throw new ListException('There is more than one record called \'Internal Portal Listing Owner\' in Portal Organization Setting custom metadata. There should only be one.');
    //     }
    //     else if (String.isBlank(internalPortalUsers[0].Value__c)) {
    //         throw new ListException('There is no name in the record called \'Internal Portal Listing Owner\' in Portal Organization Setting custom metadata.');
    //     }

    //     String internalPortalUser = internalPortalUsers[0].Value__c;

    //     List<User> users = [SELECT Id FROM User WHERE Name=:internalPortalUser];

    //     if (users.isEmpty()) {
    //         throw new ListException('The name provided in \'Internal Portal Listing Owner \' in Portal Organization Setting custom metadata is not a valid name for a user.');
    //     }

    //     return users[0];
    // }

    // public static List<String> getListOfPortalProfiles() {
    //     List<String> profileNames = new List<String>();
    //     List<Profile> profiles = [SELECT Name FROM Profile WHERE UserLicenseId IN
    //                                 (SELECT Id FROM UserLicense WHERE LicenseDefinitionKey = 'PID_Customer_Community_Login')];

    //     for (profile currentProfile : profiles) {
    //         profileNames.add(currentProfile.Name);
    //     }

    //     return profileNames;
    // }

    // public static UserRecordAccess userAccessToRecord(Id userId, Id recordId) {
    //     List<UserRecordAccess> userRecords = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =:userId  AND RecordId = :recordId];

    //     if (userRecords.size() > 0) {
    //         return userRecords[0];
    //     } else {
    //         return null;
    //     }
    // }

    public static Boolean userIsLoggedInConstituent(String constitunetIdInURL) {
        Id userId = UserInfo.getUserId();

        if (userId == null || String.isBlank(constitunetIdInURL)) {
            return false;
        }

        List<User> contactId = [SELECT Id, ContactId FROM User WHERE Id = :userId LIMIT 1];

        if (contactId.isEmpty() || String.isBlank(contactId[0].ContactId)) {
            return false;
        }

        Id loggedInConstituentId = contactId[0].ContactId;

        if (loggedInConstituentId == constitunetIdInURL) {
            return true;
        }
        else {
            return false;
        }
    }

    // public static String getListingId(String listingName, List<String> recordNames) {
    //     String listingId = '';
    //     List<Listing__c> listings;

    //     if (String.isBlank(listingName)) {
    //         return '';
    //     }

    //     if (recordNames != null && !recordNames.isEmpty()) {
    //         listings = [SELECT Id FROM Listing__c WHERE Name =: listingName AND RecordType.Name IN: recordNames LIMIT 1];
    //     } else {
    //         listings = [SELECT Id FROM Listing__c WHERE Name =: listingName LIMIT 1];
    //     }

    //     if (!listings.isEmpty() && String.isNotBlank(listings[0].Id)) {
    //         listingId = listings[0].Id;
    //     }

    //     return listingId;
    // }

    // public static String getListingName(String listingId) {
    //     String listingName = '';

    //     if (String.isBlank(listingId)) {
    //         return '';
    //     }

    //     List<Listing__c> listings = [SELECT Name FROM Listing__c WHERE Id =: listingId LIMIT 1];

    //     if (!listings.isEmpty() && String.isNotBlank(listings[0].Name)) {
    //         listingName = listings[0].Name;
    //     }

    //     return listingName;
    // }

    /**
     * Encrypts the given string using AES256. Is used in conjunction with the decryptString method.
     *
     * @author Aaron Wong
     * @param inputString               String to encrypt.
     * @param keyCustomMetadataName     Custom Metadata Developer Name for the key.
     * @return                          Encrypted String.
     * @since                           1.0
     */
    public static String encryptString(Map<String, Object> params) {
        String inputString = (String) params.get(PARAM_INPUT_STRING);
        String keyCustomMetadataName = (String) params.get(PARAM_KEY_CUSTOM_METADATA_NAME);

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{keyCustomMetadataName}
        });

        String encrpytionKey = DEFAULT_ENCRYPTION_KEY;

        if (orgSettingList != null && !orgSettingList.isEmpty()) {
            encrpytionKey = orgSettingList.get(0).Value__c;
        }

        return JSON.serialize(Crypto.encrypt('AES256', Blob.valueOf(encrpytionKey), Blob.valueOf(ENCRYPTION_INITIALIZATION_VECTOR), Blob.valueOf(inputString)));
    }

    /**
     * Decrypts the given string using AES256. Is used in conjunction with the encryptString method.
     *
     * @author Aaron Wong
     * @param inputString               String to decrypt.
     * @param keyCustomMetadataName     Custom Metadata Developer Name for the key.
     * @return                          Decrypted String.
     * @since                           1.0
     */
    public static String decryptString(String inputString, String keyCustomMetadataName) {
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{keyCustomMetadataName}
        });


        String encrpytionKey = DEFAULT_ENCRYPTION_KEY;

        if (orgSettingList != null && !orgSettingList.isEmpty()) {
            encrpytionKey = orgSettingList.get(0).Value__c;
        }

        return Crypto.decrypt('AES256', Blob.valueOf(encrpytionKey), Blob.valueOf(ENCRYPTION_INITIALIZATION_VECTOR), (Blob)JSON.deserialize(inputString, Blob.class)).toString();
    }

    /**
     * Creates an AuraHandledException containing custom error message
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param customErrorMessage    User friendly error message that will display in a toast
     *
     * @return                      AuraHandledException
     */
    public static AuraHandledException generateCustomErrorMessage(Map<String, Object> params) {
        String customErrorMessage = (String) params.get(PARAM_CUSTOM_ERROR_MESSAGE);
        String stackTraceString = (String) params.get(PARAM_STACKTRACE_STRING);

        if (String.isBlank(stackTraceString)) {
            stackTraceString = new AuraHandledException(customErrorMessage).getStackTraceString();
        }

        return createAuraHandledException(
                    new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                            PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => customErrorMessage,
                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => stackTraceString});
    }

    /**
     * Creates an AuraHandledException that contains a custom error message and the
     * encrypted stacktracestring that will be thrown to the front end for error handling
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param keyCustomMetadataName             Custom Metadata Developer Name for the key.
     * @param customErrorMessage                User friendly error message that will display in a toast
     * @param stackTraceString                  Stack trace of error that will be encrypted for developer debugging
     *
     * @return                                  AuraHandledException that contains json of the two error messages
     */

    public static AuraHandledException createAuraHandledException(Map<String, Object> params) {
        String keyCustomMetadataName = (String) params.get(PARAM_KEY_CUSTOM_METADATA_NAME);
        String customErrorMessage = (String) params.get(PARAM_CUSTOM_ERROR_MESSAGE);
        String stackTraceString = (String) params.get(PARAM_STACKTRACE_STRING);

        Map<String, String> errorMessageMap = new Map<String, String>();
        if (String.isNotBlank(stackTraceString)) {
            errorMessageMap.put('error', encryptString(new Map<String, Object>{PARAM_INPUT_STRING => stackTraceString, PARAM_KEY_CUSTOM_METADATA_NAME => keyCustomMetadataName}));
            //errorMessageMap.put('error', stackTraceString);
        }
        errorMessageMap.put('message', customErrorMessage);
        return new AuraHandledException(System.JSON.serialize(errorMessageMap));
    }

    /**
     * Creates an AuraHandledException that contains a custom error message and the
     * encrypted stacktracestring that will be thrown to the front end for error handling
     *
     *
     * @author: Daniel Mardirousi
     * @since: 1.0
     *
     * @param   paramMap                        Map including the following:
        * @param keyCustomMetadataName             Custom Metadata Developer Name for the key.
        * @param customErrorMessage                User friendly error message that will display in a toast
        * @param stackTraceString                  Stack trace of error that will be encrypted for developer debugging
     *
     * @return                                  AuraHandledException that contains json of the two error messages
     */
    public static AuraHandledException createAuraHandledExceptionString(Map<String, Object> paramMap) {
        Map<String, String> errorMessageMap = new Map<String, String>();
        String keyCustomMetadataName = (String) paramMap.get(PARAM_KEY_CUSTOM_METADATA_NAME);
        String customErrorMessage = (String) paramMap.get(PARAM_CUSTOM_ERROR_MESSAGE);
        String stackTraceString = (String) paramMap.get(PARAM_STACKTRACE_STRING);
        String error = '';

        if (String.isNotBlank(customErrorMessage)) {
            error += customErrorMessage;
        }

        if (String.isNotBlank(stackTraceString)) {
            if (String.isNotBlank(error)){
                error += '\n';
            }
            error += encryptString(new Map<String, Object>{PARAM_INPUT_STRING => stackTraceString, PARAM_KEY_CUSTOM_METADATA_NAME => keyCustomMetadataName});

        }
        return new AuraHandledException(error);
    }

    /**
     * checks query clauses to see if they are prefaced correctly and if it isn't
     * returns a string with the correct soql format
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param clause                            The clause that we want to verify
     * @param prefix                            The soql prefix that needs to be added to the clause
     * @param replacement                       if we want to replace the prefix, we will specify the string to replace it with here (if no replacement need to use NULL not empty string)
     *
     * @return                                  Clause that is in the correct soql format
     */

    public static String prefaceQueryClause(Map<String, Object> params) {
        String clause = (String) params.get(PARAM_CLAUSE);
        String prefix  = (String) params.get(PARAM_PREFIX);
        String replacement  = (String) params.get(PARAM_REPLACEMENT);

        if (String.isBlank(clause) || String.isBlank(prefix)) {
            return clause;
        }

        String replacementClause = clause.trim().toLowerCase();

        if (!replacementClause.startsWith(prefix.trim().toLowerCase())) {
            if (replacement != null) {
                replacementClause = ' ' + replacement + ' ' + clause;
            } else {
                replacementClause = ' ' + prefix + ' ' + clause;
            }
        } else {
            if (replacement != null) {
                replacementClause = ' ' + replacement + clause.trim().substring(prefix.length());
            } else {
                return clause;
            }
        }

        return replacementClause;
    }

    /**
     * method that returns the public facing community url
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @return                      Community url
     */
    public static String constructOrigin() {
        URL urlRequest = URL.getCurrentRequestUrl();
        String urlString = urlRequest.toExternalForm();
        String host = urlRequest.getHost();
        return urlString.substringBefore(host) + host;
    }
    /**
     * Parses Custom Form Fields into a list of wrappers that can be used for front end forms
     *
     * @author Ashley Tran
     *
     * @param formFieldList     List for Custom Form Field records to parse.
     * @return                  List of parsed Custom Form Field Wrappers.
     * @since 1.0
     */
    public static List<Map<String, Object>> parseCustomFormFieldList(List<ucinn_portal_Custom_Form_Field__c> formFieldList) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        if (formFieldList == null || formFieldList.isEmpty()) {
            return resultList;
        }

        for (ucinn_portal_Custom_Form_Field__c field : formFieldList) {
            Map<String, Object> wrapper = new Map<String, Object>();
            wrapper.put('id', field.Id);
            wrapper.put('name', field.Name);
            wrapper.put('label', field.Field_Label__c);
            wrapper.put('type', field.Field_Type__c);
            wrapper.put('disabled', !field.Editable__c);
            wrapper.put('isRequired', field.Is_Required__c);
            wrapper.put('Id', field.Id);

            //need to transform the default values for these custom fields if they are picklists
            if (field.Field_Type__c == 'Multi-Picklist' || field.Field_Type__c == 'Picklist') {
                if (String.isNotBlank(field.Available_Values__c)) {
                    List<String> values = field.Available_Values__c.split(';');
                    List<Map<String, Object>> valueList = new List<Map<String, Object>>();
                    for (String value : values) {
                        valueList.add(new Map<String, Object>{'label' => value, 'value' => value});
                    }
                    wrapper.put('picklistValues', valueList);
                } else {
                    wrapper.put('picklistValues', new List<Map<String, Object>>());
                }

            } else {
                wrapper.put('picklistValues', new List<Map<String, Object>>());
            }

            wrapper.put('multiPicklistDefaultValues', new List<String>());
            wrapper.put('defaultValue', field.Default_Value__c);
            wrapper.put('isDisplayToGuests', field.Is_Display_To_Guests__c);

            if (field.Field_Type__c == 'Multi-Picklist') {
                if (String.isNotBlank(field.Default_Value__c)) {
                    List<String> defaultValues = field.Default_Value__c.split(';');
                    wrapper.put('multiPicklistDefaultValues', defaultValues);
                    wrapper.put('defaultValue', '');
                }
            } else if (field.Field_Type__c == 'Checkbox'){
                if (String.isNotBlank(field.Default_Value__c)) {
                    wrapper.put('defaultValue', Boolean.valueOf(field.Default_Value__c));
                } else {
                    wrapper.put('defaultValue', false);
                }
            }

            if (String.isNotBlank(field.Registration_Page__c) && field.Registration_Page__r != null) {
                wrapper.put('pageNumber', field.Registration_Page__r.Order_Number__c);
            }

            if (field.Field_Order__c != null) {
                wrapper.put('fieldOrder', field.Field_Order__c);
            }

            if (field.Ticket_Type__c != null) {
                wrapper.put('ticketTypeId', field.Ticket_Type__c);
            }
            resultList.add(wrapper);
        }

        return resultList;
    }

    /**
     * Generates a single line address with the given parameters.
     *
     * @author Aaron Wong
     *
     * @param city          The city of the address.
     * @param state         The state of the address.
     * @param postalCode    The postal code of the address.
     * @param country       The country of the address.
     * @return              The single line address.
     * @since               1.0
     */
    public static String generateSingleLineAddress(Map<String, Object> params) {
        String resultString = '';

        if (params == null || params.isEmpty()) {
            return resultString;
        }

        String street = (String)params.get(STREET_KEY);
        String city = (String)params.get(CITY_KEY);
        String state = (String)params.get(STATE_KEY);
        String postalCode = (String)params.get(POSTAL_CODE);
        String country = (String)params.get(COUNTRY_KEY);

        if (String.isNotBlank(street)) {
            resultString = resultString + street;
        }

        // Irvine
        if (String.isNotBlank(city)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }
            resultString = resultString + city;
        }

        // CA || Irvine, CA
        if (String.isNotBlank(state)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }

            resultString = resultString + state;
        }

        // 92602 || Irvine, 92602 || CA 92602 || Irvine, CA 92602
        if (String.isNotBlank(postalCode)) {
            if (String.isNotBlank(resultString) && String.isBlank(state)) {
                resultString = resultString + ', ';
            } else if (String.isNotBlank(state)) {
                resultString = resultString + ' ';
            }

            resultString = resultString + postalCode;
        }

        // USA || 92602, USA || Irvine, 92602, USA || CA 92602, USA || Irvine, CA 92602, USA
        if (String.isNotBlank(country)) {
            if (String.isNotBlank(resultString)) {
                resultString = resultString + ', ';
            }

            resultString = resultString + country;
        }

        return resultString;
    }

    /**
     * Gets current fiscal year according to fiscal year setup in org
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @return              Returns current fiscal year as a string
     */
    public static Period getCurrentFiscalYear(Map<String, Object> params) {
        // if there are no records within the StartDate & EndDate, then it will return null
        return [SELECT FiscalYearSettings.Name, StartDate, EndDate FROM Period
                WHERE Type = :YEAR_KEY
                AND StartDate <= TODAY
                AND EndDate >= TODAY]?.get(0);
    }

    /**
     * Throws an exception based on the static value given.
     *
     * @author Aaron Wong
     *
     * @since 1.0
     */
    public static void throwTestException(Map<String, Object> params) {
        if (testExceptionType == AURA_HANDLED_EXCEPTION) {
            throw new AuraHandledException('test');
        } else if (testExceptionType == NULL_POINTER_EXCEPTION) {
            throw new NullPointerException();
        }
    }

    public static Set<String> setIntersection(Set<String> set1, List<String> set2) {
        Set<String> returnedSet = new Set<String>();
        returnedSet.addAll(set1);
        returnedSet.retainAll(set2);
        return returnedSet;
    }

    /**
     * Converts Date String into formatted date string for events
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param unformattedDate   Unformatted Date String
     * @param timeZone          Time Zone to parse
     *
     * @return                  Formatted Date String with Time Zone
     */
    public static String createFormattedDateString(Map<String, Object> params) {
        String formattedDateString = '';

        if (params == null || params.isEmpty()) {
            return formattedDateString;
        }

        String unformattedDate = (String)params.get(UNFORMATTED_DATE);
        String timeZone = (String)params.get(TIME_ZONE);

        if (String.isBlank(unformattedDate)) {
            return formattedDateString;
        }

        formattedDateString = DateTime.valueOfGMT(unformattedDate).format('MMMM dd, yyyy hh:mm aa', 'GMT');

        if (String.isBlank(timeZone)) {
            return formattedDateString;
        }

        List<String> timeZoneParts = timeZone.split(' ');

        for (String eachPart : timeZoneParts) {
            if (!eachPart.startsWith('(')) {
                formattedDateString = formattedDateString + ' ' + eachPart;
                continue;
            }

            if (!eachPart.contains('GMT')) {
                break;
            }
        }

        return formattedDateString;
    }
}