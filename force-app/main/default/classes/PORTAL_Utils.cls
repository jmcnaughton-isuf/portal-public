public without sharing class PORTAL_Utils {
    public static final String CLASS_TYPE = 'classType';
    public static final String DEVELOPER_NAME = 'DeveloperName';
    public static final String DEVELOPER_NAME_LIST = 'developerNameList';
    public static final String FIELD_SET = 'fieldSet';
    public static final String OVERRIDE_SUFFIX = '_OR';
    public static final String QUERY_STRING = 'queryString';
    public static final String SOBJECT_NAME = 'sObjectName';
    public static final String WHERE_CLAUSE = 'whereClause';

    public static final String ORG_SETTING_MDT = 'Portal_Organization_Setting__mdt';

    static Map<String, List<Portal_Package_Extension__mdt>> extDefinitionsMap = new Map<String, List<Portal_Package_Extension__mdt>>();

    public static PORTAL_ControllerFactory getControllerFactory() {
        List<Portal_Organization_Setting__mdt> portalOrganizationSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Apex_Controller_Factory_Name'}
        });

        if (portalOrganizationSettingList == null || portalOrganizationSettingList.isEmpty()) {
            return new PORTAL_ControllerFactory();
        } else {
            Type controllerFactoryType = Type.forName(portalOrganizationSettingList.get(0).Value__c);

            return (PORTAL_ControllerFactory)controllerFactoryType.newInstance();
        }
    }

    /*
     * Helper method to find class overriding definition and return class instance.
     *
     * @param: classType -> System.Type                     record(s) that need to be parsed
     * @return: Object
     *
     */
    public static Object getHandlerClassDefinition(Map<String, Object> params) {
        System.Type classType = (System.Type)params?.get(CLASS_TYPE);

        if (classType == null) {
            return null;
        }

        // custom setting that checks if there's an external definition for this function
        String baseClassName = classType.getName();

        Portal_Package_Extension__mdt extDefinition;
        List<Portal_Package_Extension__mdt> extDefinitions;

        if (!extDefinitionsMap.containsKey(baseClassName)) {
            extDefinitions = [SELECT Base_Class_Name__c,
                                     Override_Class_Name__c,
                                     Override_Class_Namespace__c
                              FROM Portal_Package_Extension__mdt
                              WHERE Base_Class_Name__c =: baseClassName];

            extDefinitionsMap.put(baseClassName, extDefinitions);
        }
        else {
            extDefinitions = extDefinitionsMap.get(baseClassName);
        }

        //This method seems to assume that only one override will exist for this class. Thus we will return the first one.
        if (!extDefinitions.isEmpty()) {
            extDefinition = extDefinitions[0];
        }

        Object handlerClass;

        if (extDefinition != null) {
            // Users defined overriding definition for the class
            System.Type externalDefinition = Type.forName(extDefinition.Override_Class_Namespace__c, extDefinition.Override_Class_Name__c);

            if (externalDefinition != null) {
                handlerClass = externalDefinition.newInstance();
            } else {
                handlerClass = classType.newInstance();
            }
        }
        else {
            // Users did not define overriding definition for the class, just return our base instance
            handlerClass = classType.newInstance();
        }

        return handlerClass;
    }

    /**
     * Takes in the developername for a secure organization setting custom metadata record
     * and returns the value__c of its override or of the record if no override exists
     *
     * @author Sam Longo
     *
     * @param developerName         developerName field on the secure setting to be found.
     * @return      the string for the found Value__c, or '' if no settings were found.
     *
     */
    public static String getSecureMetadata(String developerName) {

        if (String.isBlank(developerName)) {
            throw new AuraHandledException('Attempted to collect org setting custom metadata without name.');
        }

        Map<String, Object> queryParams = new Map<String, Object>();
        queryParams.put(PORTAL_Utils.FIELD_SET, new Set<String>{'Value__c'});
        queryParams.put(PORTAL_Utils.SOBJECT_NAME, PORTAL_CONST_OnlineGiving.SECURE_METADATA_MDT);
        queryParams.put(PORTAL_Utils.DEVELOPER_NAME_LIST, new List<String>{developerName});

        List<Portal_Secure_Organization_Setting__mdt> emailApiTypeList = (List<Portal_Secure_Organization_Setting__mdt>) PORTAL_Utils.getCustomMetadataRecordList(queryParams);


        String valueResult = '';

        if (emailApiTypeList.size() == 1) {
            valueResult = emailApiTypeList[0].Value__c;
        }

        return valueResult;
    }

    /**
     * Takes in the developername for an organization setting custom metadata record
     * and returns the value__c of its override or of the record if no override exists
     *
     * @author Sam Longo
     *
     * @param developerName         developerName field on the setting to be found.
     * @return      the string for the found Value__c, or '' if no settings were found.
     */
    public static String getOrganizationSettingMetadata(Map<String, Object> params) {
        String developerName = (String) params?.get(DEVELOPER_NAME);

        if (String.isBlank(developerName)) {
            throw new AuraHandledException('Attempted to collect org setting custom metadata without name.');
        }

        Map<String, Object> queryParams = new Map<String, Object>();
        queryParams.put(FIELD_SET, new Set<String>{'Value__c'});
        queryParams.put(SOBJECT_NAME, ORG_SETTING_MDT);
        queryParams.put(DEVELOPER_NAME_LIST, new List<String>{developerName});

        List<Portal_Organization_Setting__mdt> emailAPITypeList = (List<Portal_Organization_Setting__mdt>) PORTAL_Utils.getCustomMetadataRecordList(queryParams);


        String valueResult = '';

        if (emailAPITypeList.size() == 1) {
            valueResult = emailAPITypeList[0].Value__c;
        }

        return valueResult;
    }

    /**
     * Gets a list of custom metadata records with the query string and developer names provided. Includes
     * logic to handle overrides.
     *
     * @author Aaron Wong
     *
     * @param queryString           The query string to query for. If present, will query through this string directly.
     * @param fieldSet              The fields used to query the custom metadata records.
     * @param sObjectName           The SObject API Name to query for.
     * @param whereClause           The where clause used to query the custom metadata records.
     * @param developerNameList     List of developer names for the custom metadata records to query for.
     * @return                      List of custom metadata records with overridden records replaced.
     * @since                       1.0
     */
    public static List<SObject> getCustomMetadataRecordList(Map<String, Object> params) {
        List<SObject> resultList = new List<SObject>();

        String queryString = (String)params?.get(QUERY_STRING);
        Set<String> fieldSet = (Set<String>)params?.get(FIELD_SET);
        String sObjectName = (String)params?.get(SOBJECT_NAME);
        String whereClause = (String)params?.get(WHERE_CLAUSE);
        List<String> developerNameList = (List<String>)params?.get(DEVELOPER_NAME_LIST);

        if (String.isNotBlank(queryString)) {
            return parseCustomMetadataForOverrides(Database.query(queryString));
        }

        if (fieldSet == null || fieldSet.isEmpty() || String.isBlank(sObjectName)) {
            return resultList;
        }

        if (!fieldSet.contains(DEVELOPER_NAME)) {
            fieldSet.add(DEVELOPER_NAME);
        }

        queryString = 'SELECT ' + String.join(new List<String>(fieldSet), ', ') + ' FROM ' + sObjectName;

        if (String.isNotBlank(whereClause)) {
            queryString = queryString + ' ' + whereClause;
        }

        if (developerNameList != null && !developerNameList.isEmpty()) {
            List<String> developerNameListCopy = new List<String>(developerNameList);

            for (String eachDeveloperName : developerNameList) {
                if (String.isNotBlank(eachDeveloperName) && !eachDeveloperName.endsWith(OVERRIDE_SUFFIX)) {
                    developerNameListCopy.add(eachDeveloperName + OVERRIDE_SUFFIX);
                }
            }

            String whereClausePrefix = ' AND ';

            if (String.isBlank(whereClause)) {
                whereClausePrefix = ' WHERE ';
            }

            queryString = queryString + whereClausePrefix + ' DeveloperName IN (\'' + String.join(developerNameListCopy, '\', \'') + '\')';
        }

        resultList = parseCustomMetadataForOverrides(Database.query(queryString));

        return resultList;
    }

    /**
     * Parses a list of custom metadata records and replaces original records with overrides.
     *
     * @author Aaron Wong
     *
     * @param customMetadataRecordList      List of custom metadata records to parse.
     * @return                              List of parsed custom metadata records.
     * @since                               1.0
     */
    private static List<SObject> parseCustomMetadataForOverrides(List<SObject> customMetadataRecordList) {
        List<SObject> resultList = new List<SObject>();

        if (customMetadataRecordList == null || customMetadataRecordList.isEmpty()) {
            return resultList;
        }

        Map<String, SObject> developerNameToCustomMetadataRecordMap = new Map<String, SObject>();

        for (SObject eachCustomMetadataRecord : customMetadataRecordList) {
            String eachDeveloperName = (String)eachCustomMetadataRecord.get(DEVELOPER_NAME);

            if (String.isBlank(eachDeveloperName)) {
                continue;
            }

            if (eachDeveloperName.endsWith(OVERRIDE_SUFFIX)) {
                developerNameToCustomMetadataRecordMap.put(eachDeveloperName.removeEnd(OVERRIDE_SUFFIX), eachCustomMetadataRecord);
            } else if (!developerNameToCustomMetadataRecordMap.containsKey(eachDeveloperName)){
                developerNameToCustomMetadataRecordMap.put(eachDeveloperName, eachCustomMetadataRecord);
            }
        }

        resultList = developerNameToCustomMetadataRecordMap.values();

        return resultList;
    }
}