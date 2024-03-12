/**
* Created by uci on 10/26/2022.
*/

public without sharing class PORTAL_OnlineGivingCustomExtension {
    
    public static final String ERROR_CONTACT_ADMIN = 'There was an issue retrieving content. Please contact an administrator.';
    public static final String PAGE_NAME = 'pageName';
    public static final String KEYWORD_KEY = 'keyword';
    public static final String DEFAULT_GIVING_PAGE_SECTION_NAME = 'Online Giving';
    public static final String DESIGNATION_CUSTOM_METADATA_NAME = 'Designations';
    public static final String OFFSET_KEY = 'offset';
    public static final String DESIGNATION_FIELD_CLAUSE = 'Id, ucinn_ascendv2__Designation_Name__c,Portal_Display_Name__c, ucinn_ascendv2__External_System_ID__c, Name, ucinn_ascendv2__Minimum_Gift_Amount__c, ucinn_ascendv2__Default_Non_Gift_Amount__c';
    public static final String GROUP_BY = 'groupBy';
    public static final String ID = 'Id';
    public static final String NAME = 'Name';
    public static final String ISUF_NAME = 'ucinn_ascendv2__Designation_Name__c';
    public static final String Search_Name = 'Portal_Display_Name__c';
    public static final String TOTAL_PLEDGE_AMOUNT = 'totalPledgeAmount';
    public static final String AMOUNT_PAID_TO_DATE = 'amountPaidToDate';
    public static final String EXTERNAL_SYSTEM_ID = 'externalSystemId';
    public static final String PLEDGE_DESIGNATION_LIST = 'pledgeDesignationList';
    public static final String DESIGNATION = 'designation';
    public static final String DESIGNATION_NAME = 'designationName';
    public static final String PLEDGE_INSTALLMENT_LIST = 'pledgeInstallmentList';
    public static final String AMOUNT_REMAINING = 'amountRemaining';
    public static final String EXPECTED_DATE = 'expectedDate';
    public static final String INSTALLMENT_AMOUNT = 'installmentAmount';
    public static final String MINIMUM_GIFT_AMOUNT_API = 'ucinn_ascendv2__Minimum_Gift_Amount__c';
    public static final String EXTERNAL_SYSTEM_ID_API = 'ucinn_ascendv2__External_System_ID__c';
    public static final String DEFAULT_NON_GIFT_AMOUNT_API = 'ucinn_ascendv2__Default_Non_Gift_Amount__c';
    
    public static final String PAST_DUE_AMOUNT = 'pastDueAmount';
    public static final String CURRENT_DUE_AMOUNT = 'currentDueAmount';
    public static final String CURRENT_DUE_DATE = 'currentDueDate';
    public static final String TOTAL_DUE_AMOUNT = 'totalDueAmount';
    
    public static final Decimal DEFAULT_DESIGNATION_MINIMUM_GIFT_AMOUNT = 0.01;
    public String paymentMethod;
    
    
    @AuraEnabled
    public static List<Contact> SERVER_getAllContacts(Map<String, Object> params){
        try {
            String pageName = (String) params?.get(PAGE_NAME);
            String keyword = (String) params?.get(KEYWORD_KEY);
            
            List<Map<String, Object>> resultList = new List<Map<String, Object>>();
            
            if (String.isBlank(pageName) || String.isBlank(keyword)) {
                System.debug('No page name or keyword provided in search params.');
                //return resultList;
            }
            
            List<Contact> constituentList = [SELECT Id, ucinn_ascendv2__Donor_ID__c, Name FROM CONTACT WHERE ucinn_ascendv2__Donor_ID__c =: keyword];
            return constituentList;
            
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(),
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }
    
    @AuraEnabled
    public static  Map<String, Object> SERVER_getDonorIdConstituentInformation(Map<String, Object> params){
        
        Map<String, Object> returnMap = new Map<String, Object>();
        
        String pageName = (String) params.get(PAGE_NAME);
        String keyword = (String) params?.get(KEYWORD_KEY);
        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }
        
        List<Contact> cont = [SELECT Id, Name, ucinn_ascendv2__Donor_ID__c FROM CONTACT WHERE ucinn_ascendv2__Donor_ID__c =: keyword];
        //Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');
        
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettingList);
        
        //remove the designation record if there is one for this page because it is not related to billing information
        pageSectionMap.remove(DESIGNATION_CUSTOM_METADATA_NAME);
        
        Map<String, Map<String,List<Map<String, Object>>>> recordsMap = new Map<String, Map<String,List<Map<String, Object>>>>();
        
        if (!cont.isEmpty()) {
            recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(cont[0].Id, pageSectionMap,  new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(),true, false);
        }
        returnMap.put('contactInformation', cont);
        returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordsMap);
        returnMap.put('picklists', PORTAL_UTIL_PageSectionSetting.getPicklists(sectionSettingList));
        returnMap.put('frontEndData', PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionSettingList));
        
        return returnMap;
    }
    
    @AuraEnabled
    public static List<Map<String, Object>> searchDesignations(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        String pageName = (String) params?.get(PAGE_NAME);
        String keyword = (String) params?.get(KEYWORD_KEY);
        Integer offset = 0;
        
        if (String.isBlank(pageName) || String.isBlank(keyword)) {
            System.debug('No page name or keyword provided in search params.');
            return resultList;
        }
        
        if (params.containsKey(OFFSET_KEY)) {
            offset = Integer.valueOf(params.get(OFFSET_KEY));
        }
        
        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, DESIGNATION_CUSTOM_METADATA_NAME, null);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList);
        
        Map<String, Object> queryClauseMap = PORTAL_UTIL_PageSectionSetting.getQueryClauseMap(null, DESIGNATION_CUSTOM_METADATA_NAME, pageSectionMap, null, false);
        
        if (queryClauseMap == null || queryClauseMap.isEmpty()) {
            System.debug('No query clause was found. ensure custom page section is configured correctly.');
            return resultList;
        }
        
        String whereClause = (String)queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.WHERE_CLAUSE);
        
        if (String.isBlank(whereClause)) {
            whereClause = '';
        } else {
            whereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => whereClause, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }
        
        String orderByClause = (String)queryClauseMap.get(PORTAL_UTIL_PageSectionSetting.ORDER_BY_CLAUSE);
        
        if (String.isBlank(orderByClause)) {
            orderByClause = '';
        } else {
            orderByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => orderByClause, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }
        
        String soslString = 'FIND \'' + String.escapeSingleQuotes(keyword) + '\' IN ALL FIELDS RETURNING ucinn_ascendv2__Designation__c(' + DESIGNATION_FIELD_CLAUSE + ' ' + whereClause + ' OFFSET ' + offset + ')';
        //system.debug('SoqlStruing:: '+soslString);
        List<List<SObject>> searchResults = Search.query(soslString);
        
        if (searchResults == null || searchResults.isEmpty() || searchResults.get(0) == null || searchResults.get(0).isEmpty()) {
            return resultList;
        }
        
        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = pageSectionMap.get(DESIGNATION_CUSTOM_METADATA_NAME);
        List<Map<String, Object>> recordList = Portal_UTIL_PageSectionSetting.convertRecordsToWrapper(searchResults.get(0), objectToFieldMap);
        
        return recordList;
    }
    
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getDesignationsByCategory(Map<String, Object> params){
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        String pageName = (String) params.get(PAGE_NAME);
        
        if (String.isBlank(pageName)) {
            return returnList;
        }
        
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Where_Clause__c, Order_By_Clause__c, Group_By_Clause__c,
                                                                     (SELECT Field_API_Name__c, Front_End_Field_Id__c
                                                                      FROM Portal_Section_Field_Settings__r)
                                                                     FROM Portal_Page_Section_Setting__mdt
                                                                     WHERE Page_Name__c = :pageName
                                                                     AND Page_Main_Section__c = :DESIGNATION_CUSTOM_METADATA_NAME
                                                                     AND Group_By_Clause__c != null
                                                                     AND Order_By_Clause__c != null];
        
        if (sectionSettingList.isEmpty()) {
            return returnList;
        }
        
        Portal_Page_Section_Setting__mdt sectionSetting = sectionSettingList.get(0);
        //strip order by and group by to get the fields to add them to the query
        String groupByFieldAPIName = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Group_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.GROUP_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
        String orderByFieldAPIName = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
        
        //need to alias the group by field to prevent collisions with other fields that have similar names.
        // NOTE: if any fields are added below, add them to designationDataMap inside of createDesignationCategoryMap()
        String query = 'SELECT ' + groupByFieldAPIName + ' ' + GROUP_BY + ' ,' + orderByFieldAPIName + ', Id, Name, ucinn_ascendv2__External_System_ID__c, SUM(ucinn_ascendv2__Minimum_Gift_Amount__c)ucinn_ascendv2__Minimum_Gift_Amount__c, SUM(ucinn_ascendv2__Default_Non_Gift_Amount__c)ucinn_ascendv2__Default_Non_Gift_Amount__c FROM ucinn_ascendv2__Designation__c ';
        
        if (String.isNotBlank(sectionSetting.Where_Clause__c)) {
            query =  query + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }
        
        //When making a group by clause, all of the fields that are queried need to be aggregated as well
        query =  query + ' GROUP BY ' + groupByFieldAPIName + ', ' + orderByFieldAPIName + ', Id, Name, ucinn_ascendv2__External_System_ID__c';
        
        if (String.isNotBlank(sectionSetting.Order_By_Clause__c)) {
            query =  query + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }
        
        //system.debug('Query: '+query);
        List<AggregateResult> designations = Database.query(query);
        
        Map<String, List<Object>> designationMap = createDesignationCategoryMap(designations, sectionSetting);
        
        for (String eachCategory : designationMap.keyset()) {
            // so each 'category' ends up having a list of designations with the same groupById
            returnList.add(new Map<String, Object>{'category' => eachCategory, PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY => designationMap.get(eachCategory)});
        }
        
        return returnList;
    }
    
    @AuraEnabled
    public static Map<String, List<Object>> createDesignationCategoryMap(List<AggregateResult> designations,  Portal_Page_Section_Setting__mdt sectionSetting) {
        Map<String, List<Object>> resultMap = new Map<String, List<Object>>();
        
        if (designations == null || designations.isEmpty() || sectionSetting == null || sectionSetting.Portal_Section_Field_Settings__r == null) {
            return resultMap;
        }
        
        Map<String, String> fieldApiNameToFrontEndFieldIdMap = new Map<String, String>();
        //system.debug('sectionSetting:: '+sectionSetting.Portal_Section_Field_Settings__r);
        for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
            if (String.isNotBlank(fieldSetting.Field_API_Name__c) && String.isNotBlank(fieldSetting.Front_End_Field_Id__c)) {
                fieldApiNameToFrontEndFieldIdMap.put(fieldSetting.Field_API_Name__c, fieldSetting.Front_End_Field_Id__c);
            }
        }
        
        
        for (AggregateResult designation : designations) {
            if(!Test.isRunningTest()) {
                String groupById = (String) designation.get(GROUP_BY);
                Map<String, Object> designationDataMap = new Map<String, Object> {GROUP_BY => groupById,
                    fieldApiNameToFrontEndFieldIdMap.get(ID) => designation.get(ID),
                    fieldApiNameToFrontEndFieldIdMap.get(NAME) => designation.get(NAME),
                    fieldApiNameToFrontEndFieldIdMap.get(NAME) => designation.get(ISUF_NAME),
                    fieldApiNameToFrontEndFieldIdMap.get(EXTERNAL_SYSTEM_ID_API) => designation.get(EXTERNAL_SYSTEM_ID_API),
                    fieldApiNameToFrontEndFieldIdMap.get(MINIMUM_GIFT_AMOUNT_API) => designation.get(MINIMUM_GIFT_AMOUNT_API),
                    fieldApiNameToFrontEndFieldIdMap.get(DEFAULT_NON_GIFT_AMOUNT_API) => designation.get(DEFAULT_NON_GIFT_AMOUNT_API)};
                        
                        if (resultMap.containsKey(groupById)) {
                            // adding a designation to an already existing category
                            resultMap.get(groupById).add(designationDataMap);
                        } else {
                            // adding a new category and putting the designation in it
                            resultMap.put(groupById, new List<Object>{designationDataMap});
                        }
            }
        }
        
        return resultMap;
    }
    
    @AuraEnabled
    public static Map<String, Object> SERVER_createReviewTransaction(Map<String, Object> params){
        Map<String, Object> returnMap = PORTAL_PaymentHubControllerBaseOR.createReviewTransaction(params);
        
        return returnMap;
    }
    
}