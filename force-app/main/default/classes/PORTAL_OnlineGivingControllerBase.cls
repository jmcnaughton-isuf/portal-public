public without sharing virtual class PORTAL_OnlineGivingControllerBase {

    public static final String DESIGNATION_CUSTOM_METADATA_NAME = 'Designations';
    public static final String PAGE_NAME = 'pageName';
    public static final String DEFAULT_GIVING_PAGE_SECTION_NAME = 'Online Giving';
    public static final String GIFT_TYPE = 'Gift Type';
    public static final String PLEDGE_SEARCH = 'Pledge Search';
    public static final String COMPANY_INFORMATION = 'Company_Information';
    public static final String COMPANY = 'Company';
    public static final String PAYMENT_METHOD = 'paymentMethod';
    public static final String KEYWORD_KEY = 'keyword';
    public static final String OFFSET_KEY = 'offset';
    public static final String PARENT_ID_KEY = 'parentId';
    public static final String PLEDGE_ID = 'pledgeId';
    public static final String GROUP_BY = 'groupBy';

    public static final String ID = 'Id';
    public static final String NAME = 'Name';
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
    public static final String DESIGNATION_ID = 'designationId';
    public static final String FIELD_NAMES_LIST = 'fieldNamesList';
    public static final String MINIMUM_GIFT_AMOUNT_API = 'ucinn_ascendv2__Minimum_Gift_Amount__c';
    public static final String EXTERNAL_SYSTEM_ID_API = 'ucinn_ascendv2__External_System_ID__c';
    public static final String DEFAULT_NON_GIFT_AMOUNT_API = 'ucinn_ascendv2__Default_Non_Gift_Amount__c';
    public static final String CAMPAIGN_EXTERNAL_ID = 'ucinn_ascendv2__Campaign_External_ID__c';
    public static final String DESIGNATION_NAME_API = 'ucinn_ascendv2__Designation_Name__c';
    public static final String VALUE_API = 'Value__c';
    public static final String PORTAL_ORGANIZATION_SETTING_MDT = 'Portal_Organization_Setting__mdt';
    public static final String CONTEXTUAL_GIVING_FORM_PAYMENT_PROCESSOR = 'Contextual_Giving_Form_Payment_Processor';
    public static final String CONTEXTUAL_GIVING_FORM_SPREEDLY_GATEWAY = 'Contextual_Giving_Form_Spreedly_Gateway';
    
    public static final String PAST_DUE_AMOUNT = 'pastDueAmount';
    public static final String CURRENT_DUE_AMOUNT = 'currentDueAmount';
    public static final String CURRENT_DUE_DATE = 'currentDueDate';
    public static final String TOTAL_DUE_AMOUNT = 'totalDueAmount';
    public static final String AMOUNT_DUE_FOR_INSTALLMENTS = 'amountDueForInstallments';

    public static final Decimal DEFAULT_DESIGNATION_MINIMUM_GIFT_AMOUNT = 0.01;

    public static final String GIVE_PAGE_BASE_URL_CMT_DEVELOPER_NAME = 'Give_Page_Base_URL';
    public static final String DONOR_ID = 'donorId';
    public static final String PASSCODE_CONST = 'passcode';
    public static final String CONTACT_ID = 'contactId';
    public static final String GIVING_URL = 'givingUrl';
    public static final Integer LENGTH_OF_RANDOM_STRING = 30;

    public static final String GIVING_FORM_NAME = 'givingFormName';
    public static final String PAGE_URL = 'pageUrl';
    public static final String APPEAL_KEY = 'appeal';
    public static final String CONFIRMATION_TEXT = 'confirmationText';
    public static final String DEFAULT_AMOUNT = 'defaultAmount';
    public static final String GIFT_TYPES = 'giftTypes';
    public static final String IS_FIXED_AMOUNT = 'isFixedAmount';
    public static final String IS_FIXED_INSTALLMENTS = 'isFixedInstallments';
    public static final String DEFAULT_NUMBER_OF_INSTALLMENTS = 'defaultNumberOfInstallments';
    public static final String IS_END_DATE_ENABLED = 'isEndDateEnabled';
    public static final String DESIGNATION_LIST = 'designationList';
    public static final String GIFT_FREQUENCIES = 'giftFrequencies';

    public static final String ADDRESS_TYPES = 'addressTypes';
    public static final String EMAIL_TYPES = 'emailTypes';
    public static final String PHONE_TYPES = 'phoneTypes';
    public static final String CONTACT_INFORMATION = 'contactInformation';
    public static final String GIFT_DETAILS_LABEL = 'giftDetailsLabel';
    public static final String BILLING_DETAILS_LABEL = 'billingDetailsLabel';
    public static final String PAYMENT_FORM_LABEL = 'paymentFormLabel';
    public static final String CONFIRMATION_LABEL = 'confirmationLabel';
    public static final String PAYMENT_PROCESSOR = 'paymentProcessor';
    public static final String CONTROLLER_VERSION = 'controllerVersion';
    public static final String EXTERNAL_GATEWAY_NAME = 'externalGatewayName';
    public static final String EMAIL_TEMPLATE_DEVELOPER_NAME = 'emailTemplateDeveloperName';
    public static final String URL_PARAM_VALUE = 'urlParamValue';

    public String paymentMethod;
    public Boolean useExternalId = false;
    
    //FUTURE TODO: refactor pagesectionsettings

    protected virtual PORTAL_PageSectionAdapter.Builder getPageSectionAdapterBuilder() {
        return new PORTAL_PageSectionAdapter.Builder();
    }

    /**
     * method that queries the picklist values for online giving fields. The field can be frequency or
     * tribute type currently
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param field:                the api name of the field we are trying to get
     * @param sObjectType:          the api name of the sobject 
     * 
     * @return                      the map of sobject to field to list of picklist values
     */
    public virtual Map<String,Map<String, List<Map<String, String>>>> SERVER_getPicklists(Map<String, Object> params){
        String field = (String)params?.get('field');
        String sobjectType = (String)params?.get('sobjectType');

        if (String.isNotBlank(sobjectType) && String.isNotBlank(field)) {
            return PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_PICKLISTS => new Map<String, List<String>>{sobjectType => new List<String>{field}}});
        } else {
            return new Map<String,Map<String, List<Map<String, String>>>>();
        }
        
        
    }

   /**
     * method that queries for the designation data that the online giving page should
     * show by default
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param designations:         comma separated string of ids for the feature designations we want to show
     * @param pageName:             the page name of the portal page section setting custom metadata that we want to use to filter the query
     * 
     * @return                      list of designation data for featured designations
     */
    public virtual List<Map<String, Object>> SERVER_getFeaturedDesignations(Map<String, Object> params){
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        String designations = (String) params?.get(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY);
        String pageName = (String) params?.get(PAGE_NAME);

        if (String.isBlank(designations)) {
            return resultList;
        }

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        List<String> designationIdList = designations.split(',');

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.dynamicWhereClause = 'WHERE ucinn_ascendv2__External_System_ID__c IN (\'' + String.join(designationIdList, '\', \'') + '\') ';
        dynamicQueryObject.overrideGroupByClause = true;
        dynamicQueryObject.dynamicGroupByClause = '';

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(pageName)
                                                                                          .buildMainSectionName(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                                          .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{DESIGNATION_CUSTOM_METADATA_NAME => dynamicQueryObject})
                                                                                          .build();

        if (pageSectionAdapter == null) {
            return resultList;
        }

        List<Map<String, Object>> designationDataList = pageSectionAdapter.getRecords()
                                                                          ?.get(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                          ?.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);

        if (designationDataList == null || designationDataList.isEmpty()) {
            return resultList;
        }

        resultList = designationDataList;
        return resultList;

        // String queryString = 'SELECT ' + DESIGNATION_FIELD_CLAUSE + ' FROM ucinn_ascendv2__Designation__c WHERE ucinn_ascendv2__External_System_ID__c IN :designationIdList';

        // //this is to get the order by clause and by default we are using ucinn_portal_Display_Order__c
        // if (String.isNotBlank(pageName)) {
        //     List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Order_By_Clause__c FROM Portal_Page_Section_Setting__mdt WHERE Page_Name__c = :pageName AND Page_Main_Section__c = :DESIGNATION_CUSTOM_METADATA_NAME];
        //     if (!sectionSettingList.isEmpty()) {
        //         Portal_Page_Section_Setting__mdt sectionSetting = sectionSettingList.get(0);
        //         if (String.isNotBlank(sectionSetting.Order_By_Clause__c)) {
        //             queryString = queryString + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        //         }
        //     }
        // }
        // System.debug(designations);
        // System.debug(queryString);
        // return Database.query(queryString);
    }

    /**
     * method that queries for data from all designations a user can choose from
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param pageName:             the page name of the custom metadata that we want to use to filter the query
     * 
     * @return                      list of designation data
     */
    public virtual List<Map<String, Object>> SERVER_getAllDesignations(Map<String, Object> params){
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        String pageName = (String) params?.get(PAGE_NAME);

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.overrideGroupByClause = true;
        dynamicQueryObject.dynamicGroupByClause = '';

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(pageName)
                                                                                          .buildMainSectionName(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                                          .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{DESIGNATION_CUSTOM_METADATA_NAME => dynamicQueryObject})
                                                                                          .build();

        if (pageSectionAdapter == null) {
            return resultList;
        }

        List<Map<String, Object>> designationDataList = pageSectionAdapter.getRecords()
                                                                          ?.get(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                          ?.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);

        if (designationDataList == null || designationDataList.isEmpty()) {
            return resultList;
        }

        resultList = designationDataList;
        return resultList;

        // List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Where_Clause__c, Order_By_Clause__c FROM Portal_Page_Section_Setting__mdt WHERE Page_Name__c = :pageName AND Page_Main_Section__c = :DESIGNATION_CUSTOM_METADATA_NAME];
        // if (!sectionSettingList.isEmpty()) {
        //     Portal_Page_Section_Setting__mdt sectionSetting = sectionSettingList.get(0);

        //     String query = 'SELECT ' + DESIGNATION_FIELD_CLAUSE + ' FROM ucinn_ascendv2__Designation__c ';

        //     if (String.isNotBlank(sectionSetting.Where_Clause__c)) {
        //         query =  query + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        //     }
        //     if (String.isNotBlank(sectionSetting.Order_By_Clause__c)) {
        //         query =  query + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        //     }

        //     return Database.query(query);
        // }
        // return resultList;
    }

    /**
     * method that queries for the all designations a user can choose from that are grouped by
     * a specific field chosen by the university (i.e grouping designations by academic organizations)
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param pageName:             the page name of the custom metadata that we want to use to filter the query
     * 
     * @return                      list of designations that are grouped by categories
     */
    public virtual List<Map<String, Object>> SERVER_getDesignationsByCategory(Map<String, Object> params){
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        String pageName = (String) params.get(PAGE_NAME);

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
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
        String designationNameAPIName = this.getAPINameForDesignationName(sectionSetting);
        //strip order by and group by to get the fields to add them to the query's SELECT 
        String groupByFieldAPIName = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Group_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.GROUP_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
        String orderByFieldAPIName = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
        
        // Phillip and Jacob believe removing the hard-coded field names from the order by fields provided by cmt is the best solution
        // bc it preserves the purpose of the Page Section Setting query clauses
        String filteredOrderByFieldAPIName = filterFieldApiNames(orderByFieldAPIName, new List<String>{ID, designationNameAPIName, EXTERNAL_SYSTEM_ID_API});

        //need to alias the group by field to prevent collisions with other fields that have similar names.
        // NOTE: if any fields are added below, add them to designationDataMap inside of createDesignationCategoryMap()
        String query = 'SELECT ' + groupByFieldAPIName + ' ' + GROUP_BY + ' ,' + filteredOrderByFieldAPIName + ', Id, ' + designationNameAPIName + ' , ucinn_ascendv2__External_System_ID__c, SUM(ucinn_ascendv2__Minimum_Gift_Amount__c)ucinn_ascendv2__Minimum_Gift_Amount__c, SUM(ucinn_ascendv2__Default_Non_Gift_Amount__c)ucinn_ascendv2__Default_Non_Gift_Amount__c FROM ucinn_ascendv2__Designation__c '; 
        
        if (String.isNotBlank(sectionSetting.Where_Clause__c)) {
            query =  query + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }

        //When making a group by clause, all of the fields that are queried need to be aggregated as well
        query =  query + ' GROUP BY ' + groupByFieldAPIName + ', ' + filteredOrderByFieldAPIName + ', Id, ' + designationNameAPIName + ' , ucinn_ascendv2__External_System_ID__c';

        if (String.isNotBlank(sectionSetting.Order_By_Clause__c)) {
            query =  query + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        }

        List<AggregateResult> designations = Database.query(query);

        Map<String, List<Object>> designationMap = createDesignationCategoryMap(designations, sectionSetting);

        for (String eachCategory : designationMap.keyset()) {
            // so each 'category' ends up having a list of designations with the same groupById
            returnList.add(new Map<String, Object>{'category' => eachCategory, PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY => designationMap.get(eachCategory)});
        }

        return returnList;
    }

    /**
     * Find the field setting with the front end field id = "Name" and return it
     * This way, users can configure which field should be used for the "Name"
     * 
     * @author Todd Shinto
     * @since 1.10
     * 
     * @param sectionSetting    The portal page section setting for designations
     * 
     * @return String: Field API name to use when querying for designations
     */
    private String getAPINameForDesignationName(Portal_Page_Section_Setting__mdt sectionSetting) {
        if (sectionSetting == null || sectionSetting.Portal_Section_Field_Settings__r == null || sectionSetting.Portal_Section_Field_Settings__r.isEmpty()) {
            return DESIGNATION_NAME_API;
        }

        for (Portal_Section_Field_Setting__mdt eachFieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
            if (eachFieldSetting.Front_End_Field_Id__c == NAME) {
                return eachFieldSetting.Field_API_Name__c;
            }
        }

        return DESIGNATION_NAME_API;
    }

    /**
     * Given some comma-separated field API names (e.g. for use in a SELECT clause), remove certain fields
     * 
     * @author Jacob Huang
     * @since 1.5
     * 
     * @param fieldApiNames             String: comma-separated field API names, potentially white space around names as well
     * @param fieldApiNamesToRemove     List<String>: A list of field API names that should not be included in the comma separated string
     * 
     * @return String: comma-separated field API names specifically excluding the specified field names
     */
    private String filterFieldApiNames(String commaSeparatedFieldApiNames, List<String> fieldApiNamesToRemove) {
        if (String.isBlank(commaSeparatedFieldApiNames) || fieldApiNamesToRemove == null || fieldApiNamesToRemove.isEmpty()) {
            return commaSeparatedFieldApiNames;
        }

        // regex that looks for comma followed by white space or just white space
        List<String> orderByFieldAPINameList = commaSeparatedFieldApiNames.split(',\\s*|\\s+'); 
        Set<String> filteredOrderByFieldAPINameSet = new Set<String>(orderByFieldAPINameList);
        filteredOrderByFieldAPINameSet.remove('');
        filteredOrderByFieldAPINameSet.removeAll(fieldApiNamesToRemove);
    
        return String.join(new List<String>(filteredOrderByFieldAPINameSet), ',');
    }

    /**
     * Creates a mapping from designation field API names to their associated front end field ids and groups designations
     * together by category.
     * 
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * 
     * @param designations              List of designation data.
     * @param sectionSetting            The page section setting we're using to get the designation front end field ids.
     * 
     * @return                          Map of designation categories
     */
    protected virtual Map<String, List<Object>> createDesignationCategoryMap(List<AggregateResult> designations,  Portal_Page_Section_Setting__mdt sectionSetting) {
        Map<String, List<Object>> resultMap = new Map<String, List<Object>>();

        if (designations == null || designations.isEmpty() || sectionSetting == null || sectionSetting.Portal_Section_Field_Settings__r == null || sectionSetting.Portal_Section_Field_Settings__r.isEmpty()) {
            return resultMap;
        }

        Map<String, String> fieldApiNameToFrontEndFieldIdMap = new Map<String, String>();

        for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
            if (String.isNotBlank(fieldSetting.Field_API_Name__c) && String.isNotBlank(fieldSetting.Front_End_Field_Id__c)) {
                fieldApiNameToFrontEndFieldIdMap.put(fieldSetting.Field_API_Name__c, fieldSetting.Front_End_Field_Id__c);
            }
        }

        // This is technically called once before, but instead of passing into this function as a parameter
        // We are calling this function again for backwards compatibility
        String designationNameAPIName = this.getAPINameForDesignationName(sectionSetting);

        for (AggregateResult designation : designations) {
            String groupById = (String) designation.get(GROUP_BY);

            Map<String, Object> designationDataMap = new Map<String, Object> {GROUP_BY => groupById,
                                                                            fieldApiNameToFrontEndFieldIdMap.get(ID) => designation.get(ID),
                                                                            fieldApiNameToFrontEndFieldIdMap.get(designationNameAPIName) => designation.get(designationNameAPIName),
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

        return resultMap;
    }

    /**
     * Gets a list of designation data where the designation name is like a user-provided keyword.
     *
     * @author Sam Longo
     * 
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param keyword                   Keyword to search for.
     * @param offset                    offset for pagination
     * @param fieldNamesList            list of field api names to that will be searched against for keyword matches
     * @return                          List of designation data.
     * @since                           1.0
     */
    public virtual List<Map<String, Object>> searchDesignations(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        String pageName = (String) params?.get(PAGE_NAME);
        String keyword = (String) params?.get(KEYWORD_KEY);
        List<Object> fieldNamesList = (List<Object>) params?.get(FIELD_NAMES_LIST);
        Integer offset = 0;

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        if (String.isBlank(keyword)) {
            System.debug('No keyword provided in search params.');
            return resultList;
        }

        if (params.containsKey(OFFSET_KEY)) {
            offset = Integer.valueOf(params.get(OFFSET_KEY));
        }

        if (fieldNamesList != null && fieldNamesList.isEmpty() == false){
            return getDesignationsUsingSearchFields(fieldNamesList, keyword, pageName);
        }

        return getDesignationsUsingFullTextSearch(pageName, keyword, offset);
    }

    /**
     * Gets a list of designation data where specific fields in each designation is like the user-provided keyword.
     *
     * @author Curtis Ung
     * @since                           1.0
     * 
     * @param fieldNamesList            List<Object> of Designation field api names to that will be searched against for keyword matches
     * @param keyword                   Keyword to search for in fields supplied by fieldNamesList
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * 
     * @return                          List of designation data (where designation data = {FrontEndfieldId => value})
     */
    protected virtual List<Map<String, Object>> getDesignationsUsingSearchFields(List<Object> fieldNamesList, String keyword, String pageName){        
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        if (String.isBlank(keyword) || fieldNamesList == null || fieldNamesList.isEmpty()){
            System.debug('No keyword or fields to search against were provided in params.');
            return returnList;
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = getDynamicQueryFromSearchFields(keyword, fieldNamesList);
        
        if (String.isBlank(dynamicQueryObject?.dynamicWhereClause)) {
            return returnList;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(pageName)
                                                                                            .buildMainSectionName(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                                            .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{DESIGNATION_CUSTOM_METADATA_NAME => dynamicQueryObject})
                                                                                            .build();
                                            
        List<Map<String, Object>> designationDataList = pageSectionAdapter?.getRecords()
                                                                            ?.get(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                            ?.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);

        if (designationDataList == null || designationDataList.isEmpty()) {
            return returnList;
        }

        return designationDataList;
    }


    /**
     * Creates a DynamicQueryClass object with its WHERE clause formatted to search the keyword against the provided fields;
     * GROUP BY clause is also overridden.
     *
     * @author Curtis Ung
     * @since                           1.0
     * 
     * @param keyword                   Keyword to search for in fields supplied by fieldNamesList
     * @param fieldNamesList            List<Object> of Designation field api names to that will be searched against for keyword similarities
     * 
     * @return                          DynamicQueryClass object with WHERE clause formatted and GROUP BY clause overridden
     */
    protected virtual PORTAL_UTIL_PageSectionSetting.DynamicQueryClass getDynamicQueryFromSearchFields(String keyword, List<Object> fieldNamesList){
        if (String.isBlank(keyword) || fieldNamesList == null || fieldNamesList.isEmpty()){
            System.debug('No keyword or fields to search against were provided in params.');
            return new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        }

        String escapedKeyword = String.escapeSingleQuotes(keyword);
        String keywordWhereClause = '';

        for (Object eachFieldName : fieldNamesList){
            if (String.isBlank((String) eachFieldName)) {
                continue;
            }

            if (String.isBlank(keywordWhereClause)) {
                keywordWhereClause += '(' + (String) eachFieldName + ' LIKE \'%' + escapedKeyword + '%\'';
            } else {
                keywordWhereClause += ' OR ' + (String) eachFieldName + ' LIKE \'%' + escapedKeyword + '%\'';
            }
        }
        keywordWhereClause += String.isBlank(keywordWhereClause) ? '' : ')';

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.dynamicWhereClause = keywordWhereClause;
        dynamicQueryObject.overrideGroupByClause = true;
        dynamicQueryObject.dynamicGroupByClause = '';

        return dynamicQueryObject;
    }


    /**
     * Gets a list of designation data resulting from a full-text search against the user-provided keyword.
     *
     * @author Curtis Ung
     * @since                           1.0
     * 
     * @param keyword                   Keyword to search for in fields supplied by fieldNamesList
     * @param pageName                  Page name of the Portal Page Section Setting to use
     * @param offset                    Offset for pagination
     * 
     * @return                          List of designation data (where designation data = {FrontEndfieldId => value})
     */
    protected virtual List<Map<String, Object>> getDesignationsUsingFullTextSearch(String pageName, String keyword, Integer offset){
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

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

        Set<String> designationFields = getFieldApiNames(pageSectionList);  
        designationFields.add(ID);
        String soslString = 'FIND \'' + String.escapeSingleQuotes(keyword) + '*\' IN ALL FIELDS RETURNING ucinn_ascendv2__Designation__c(' + String.join(new List<String>(designationFields), ',') + ' ' + whereClause + ' ' + orderByClause + ' OFFSET ' + offset + ')';

        List<List<SObject>> searchResults = Search.query(soslString);

        if (searchResults == null || searchResults.isEmpty() || searchResults.get(0) == null || searchResults.get(0).isEmpty()) {
            return resultList;
        }

        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = pageSectionMap.get(DESIGNATION_CUSTOM_METADATA_NAME);
        List<Map<String, Object>> recordList = Portal_UTIL_PageSectionSetting.convertRecordsToWrapper(searchResults.get(0), objectToFieldMap);

        return recordList;
    }

    /**
     * Given a list of page section settings, get the set of all the field api names that are 
     * used within their section field settings
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param pageSectionList       List<Portal_Page_Section_Setting__mdt> page section settings to look through 
     * 
     * @return Set<String> with field api names used in the page section settings
     */
    protected virtual Set<String> getFieldApiNames(List<Portal_Page_Section_Setting__mdt> pageSectionList) {
        Map<String, Map<String, Object>> backendDataMap = PORTAL_UTIL_PageSectionSetting.getBackEndDataMap(pageSectionList);
        Set<String> fieldApiNameSet = new Set<String>();
        for (String eachKey : backendDataMap.keySet()) {
            String fieldApiName = (String) backendDataMap.get(eachKey)?.get(PORTAL_CONST_OnlineGiving.FIELD_API_NAME);
            if (String.isNotBlank(fieldApiName)) {
                fieldApiNameSet.add(fieldApiName);
            }
        }
        
        return fieldApiNameSet; 
    }

    
    /**
     * Gets a list of data for designations that have lookup to provided parentId
     *
     * @author Sam Longo
     * 
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param parentId                  Id of parent designation to search for children of.
     * 
     * @return                          List of designation data.
     * @since                           1.0
     */
    public virtual List<Map<String, Object>> getDesignationsByParentId(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        String pageName = (String) params?.get(PAGE_NAME);
        String parentId = (String) params?.get(PARENT_ID_KEY);

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        if (String.isBlank(parentId)) {
            parentId = ''; //ensure its the right kind of blank
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.dynamicWhereClause = ' WHERE ucinn_ascendv2__Parent_Designation__c = \'' + parentId + '\'';
        dynamicQueryObject.overrideGroupByClause = true;
        dynamicQueryObject.dynamicGroupByClause = '';

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(pageName)
                                                                                          .buildMainSectionName(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                                          .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{DESIGNATION_CUSTOM_METADATA_NAME => dynamicQueryObject})
                                                                                          .build();

        if (pageSectionAdapter == null) {
            return resultList;
        }

        List<Map<String, Object>> designationDataList = pageSectionAdapter.getRecords()
                                                                          ?.get(DESIGNATION_CUSTOM_METADATA_NAME)
                                                                          ?.get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);

        if (designationDataList == null || designationDataList.isEmpty()) {
            return resultList;
        }

        resultList = designationDataList;
        return resultList;

        // List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Where_Clause__c, Order_By_Clause__c FROM Portal_Page_Section_Setting__mdt WHERE Page_Name__c = :pageName AND Page_Main_Section__c = :DESIGNATION_CUSTOM_METADATA_NAME];
        
        // if (sectionSettingList.isEmpty()) {
        //     return new List<ucinn_ascendv2__Designation__c>();
        // }

        // Portal_Page_Section_Setting__mdt sectionSetting = sectionSettingList.get(0);

        // String queryString = 'SELECT ' + DESIGNATION_FIELD_CLAUSE + ', ucinn_ascendv2__Parent_Designation__c FROM ucinn_ascendv2__Designation__c ';

        // if (String.isBlank(parentId)) {
        //     parentId = ''; //ensure its the right kind of blank
        // }
        // String whereClause = ' WHERE ucinn_ascendv2__Parent_Designation__c = \'' + parentId + '\'';
        // if (String.isNotBlank(sectionSetting.Where_Clause__c)) {
        //     whereClause += ' AND (' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''}) + ') ';
        // }

        // queryString =  queryString + ' ' + whereClause;

        // if (String.isNotBlank(sectionSetting.Order_By_Clause__c)) {
        //     queryString =  queryString + ' ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.ORDER_BY_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        // }
        // System.debug(queryString);
        // return Database.query(queryString);
    }

    /**
     * method that queries for custom form fields that should show on the the online
     * giving page and wraps them in a wrapper to show on the front end
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param contentPageName:      the name of the content page that corresponds to this online giving page
     * @param contentModuleName:    the name of the content module that holds the custom form fields
     * 
     * @return                      list of custom form field wrappers
     */
    public virtual List<Map<String, Object>> SERVER_getCustomFields(Map<String, Object> params){
        String contentPageName = (String) params.get('contentPageName');
        String contentModuleName = (String) params.get('contentModuleName');
       
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        
        if (String.isBlank(contentModuleName)) {
            return returnList;    
        }

        String queryString = 'SELECT Id FROM ucinn_portal_Content_Module__c WHERE Name = :contentModuleName ';
        if (String.isNotBlank(contentPageName)) {
            queryString = queryString + ' AND Content_Page__r.Name = :contentPageName';
        }

        List<ucinn_portal_Content_Module__c> contentModules = Database.query(queryString);
        
        if (!contentModules.isEmpty()) {
            Id contentModuleId = contentModules.get(0).Id;
            List<ucinn_portal_Custom_Form_Field__c> formFields = [SELECT Field_Type__c, Field_Label__c, Available_Values__c, Default_Value__c, Editable__c
                                                        FROM ucinn_portal_Custom_Form_Field__c
                                                        WHERE ucinn_portal_Content_Module__c = :contentModuleId
                                                        ORDER BY Field_Order__c ASC];
            for (ucinn_portal_Custom_Form_Field__c field : formFields) {
                Map<String, Object> wrapper = new Map<String, Object>();
                wrapper.put('label', field.Field_Label__c);
                wrapper.put('type', field.Field_Type__c);
                wrapper.put('disabled', !field.Editable__c);
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
                returnList.add(wrapper);
                
            }

        }
        return returnList;
    }


    /**
     * method that queries for the logged in constituent's data
     * to prepopulate the billing information on the front end. also
     * gets the front end data display information
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param   pageName            Page Name of Page Section Setting
     * @param   donorId             Donor Id of Constituent (passed in from url param)
     * @param   passcode            Passcode to match to Constituent (passed in from url param)
     * 
     * @return                      the map of data need to show things on the front end
     */
    public virtual Map<String, Object> SERVER_getConstituentInformation(Map<String, Object> params){

        Map<String, Object> returnMap = new Map<String, Object>();

        String pageName = (String) params.get(PAGE_NAME);
        String donorId = (String) params.get(DONOR_ID);
        String passCode = (String) params.get(PASSCODE_CONST);

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});

        if (cont == null && String.isNotBlank(donorId) && String.isNotBlank(passCode)) {
            cont = getContactFromDonorIdAndPasscode(donorId, passCode);
        }
        
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');

        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettingList);
        
        //remove the designation record if there is one for this page because it is not related to billing information
        pageSectionMap.remove(DESIGNATION_CUSTOM_METADATA_NAME);

        Map<String, Map<String,List<Map<String, Object>>>> recordsMap = new Map<String, Map<String,List<Map<String, Object>>>>();
        
        if (cont != null) {
            recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(cont.Id, pageSectionMap,  new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(),false, false);
        }
        returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordsMap);
        returnMap.put('picklists', PORTAL_UTIL_PageSectionSetting.getPicklists(sectionSettingList));
        returnMap.put('frontEndData', PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionSettingList));
        
        return returnMap;
    }

    /**
     * method creates the review transaction for the constituent's gift
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param endDate:                      Optional: the last day for a payment if it is a recurring gift
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (only used if using stripe)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The HEP id for the matching company if the org is HEP enabled
     * @param paymentId:                    The external id for the payment taken from the billing external gateway
     * @param pageName:                     The page name for the custom metadata records
     * @param appealCode:                   The external id of the appeal code to default to
     * @param emailTemplateName:            Developer name of the email template used to send the receipt
     * @param recaptchaToken:               The recaptcha client side token for this transaction submission
     * @param paymentOrigin                 Where the payment originated in the portal
     * @param controllerVersion             Version of the Payment Hub Controller
     * @param isCreatePledgeSubscription    Boolean: create a subscription for a pledge
     * @param hasAddressAutocomplete        Boolean: Is Address Autocomplete Enabled
     * 
     * @return                              the map of data that shows on the receipt page
     */

    public virtual Map<String, Object> SERVER_createReviewTransaction(Map<String, Object> params) {
        if ((String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN) != PORTAL_CONST_OnlineGiving.ONLINE_GIVING_PAYMENT_ELEMENT
                && (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY) != PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME
                && (String)params?.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY) != PORTAL_CONST_OnlineGiving.STRIPE_PAYMENT_ELEMENT_METHOD_NAME) {
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            recaptchaController.verifyRecaptcha('PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));
        }

        PORTAL_PaymentHubControllerBase controller = null;

        if (String.isBlank((String)params?.get(CONTROLLER_VERSION))) {
            controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController((String)params.get(PAYMENT_METHOD));
        } else {
            controller = (PORTAL_PaymentHubV2ControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubV2Controller();
        }

        controller.setPaymentInterface((String)params.get(PAYMENT_METHOD));
        return controller.createReviewTransaction(params);
    }

     /**
     * method that returns the community url for communication between the lwc and visualforce page
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @return                      Community url
     */
    public virtual String SERVER_getOrigin(Map<String, Object> params) {
        return PORTAL_CommunityUtils.constructOrigin();
    }

     /**
     * method that retrieves the external gateway public api key
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param customMetadataName:       the name of the custom metadata that stores the public key
     * 
     * 
     * @return                          the public key to initialize the credit card form to the correct account
     */
    public String SERVER_getAPIKey(Map<String, Object> params) {
        PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController(this.paymentMethod);
        controller.setPaymentInterface(this.paymentMethod);
        return controller.getAPIKey(params);
    }

    /**
     * method that gets the pledge payment information for one or more pledges. if no pledges are
     * found then an empty list is returned.
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * @param pledgeId          A pledge Id provided by the user (if user is a guest).
     * @param pageName          The page name for the custom metadata records 
     * 
     * 
     * @return                  the list of pledge information maps
     */
    public virtual List<Map<String, Object>> SERVER_getPledgeData(Map<String, Object> params){
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        String pledgeId = (String) params?.get(PLEDGE_ID);
        String pageName = (String) params?.get(PAGE_NAME);

        String fieldApiName = getFieldApiNameForPledgeId(pageName);

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();

        if (cont != null) {
            dynamicQueryObject.dynamicWhereClause = ' WHERE ucinn_ascendv2__Contact__c = \'' + cont.Id + '\' ';
        } else if (String.isNotBlank(pledgeId) && String.isNotBlank(fieldApiName)) {
            dynamicQueryObject.dynamicWhereClause = ' WHERE ' + fieldApiName + ' = \'' + String.escapeSingleQuotes(pledgeId) + '\' ';
        } else {
            return resultList;
        }

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(pageName)
                                                                                          .buildMainSectionName(GIFT_TYPE)
                                                                                          .buildSubSectionName(PLEDGE_SEARCH)
                                                                                          .buildDynamicQuery(new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{PLEDGE_SEARCH => dynamicQueryObject})
                                                                                          .build();

        if (pageSectionAdapter == null) {
            return resultList;
        }

        List<Map<String, Object>> pledgeDataList = pageSectionAdapter.getRecords()
                                                                     ?.get(GIFT_TYPE)
                                                                     ?.get(PLEDGE_SEARCH);

        if (pledgeDataList == null || pledgeDataList.isEmpty()) {
            return resultList;
        }

        resultList = populatePledgeData(pledgeDataList);

        return resultList;
    }

    /**
     * Retrieves the configurable field api name that the current org is using to identify pledges. Specifically, gets the 
     * field api name from the Portal Section Field Setting "Pledge Payment - Pledge Identifier". Determines
     * which field records will be displayed to users on the front end.
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * 
     * 
     * @return                  String represting the field api name being used.
     */
    public virtual String getFieldApiNameForPledgeId(String pageName) {
        String fieldApiName = '';

        if (String.isBlank(pageName)) {
            pageName = DEFAULT_GIVING_PAGE_SECTION_NAME;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = this.getPageSectionAdapterBuilder().buildPageName(pageName)
                                                                                          .buildMainSectionName(GIFT_TYPE)
                                                                                          .buildSubSectionName(PLEDGE_SEARCH)
                                                                                          .build();

        if (pageSectionAdapter == null) {
            return fieldApiName;
        }

        Map<String, Object> backEndDataMap = pageSectionAdapter.getBackEndDataMap();

        if (backEndDataMap?.containsKey(PORTAL_CONST_OnlineGiving.PLEDGE_IDENTIFIER) != true) {
            return fieldApiName;
        }

        Map<String, Object> sectionFieldSettingData = (Map<String, Object>) backEndDataMap.get(PORTAL_CONST_OnlineGiving.PLEDGE_IDENTIFIER);
        fieldApiName = (String) sectionFieldSettingData?.get(PORTAL_CONST_OnlineGiving.FIELD_API_NAME);

        return Test.isRunningTest() ? EXTERNAL_SYSTEM_ID_API : fieldApiName;
    }

    /**
     * Populates each pledge data map with payment information that will be displayed to the user
     * on the front end.
     * 
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * @param pledgeDataList    List of maps that each represent pledge data
     * 
     * 
     * @return                  List of populated pledge data maps.
     */
    protected virtual List<Map<String, Object>> populatePledgeData(List<Map<String, Object>> pledgeDataList) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        if (pledgeDataList == null || pledgeDataList.isEmpty()) {
            return resultList;
        }

        for (Map<String, Object> eachPledgeData : pledgeDataList) {
            List<Map<String, Object>> designationData = (List<Map<String, Object>>) eachpledgeData?.get(PLEDGE_DESIGNATION_LIST);
            if (designationData == null || designationData.isEmpty()) {
                continue;
            }

            Map<String, Decimal> designationIdToTotalDueAmountMap = this.getDesignationIdToTotalDueAmountMap(eachPledgeData);

            for (Map<String, Object> eachDesignationData : designationData) {
                if (!eachDesignationData.containsKey(MINIMUM_GIFT_AMOUNT_API) || eachDesignationData.get(MINIMUM_GIFT_AMOUNT_API) == null || (Decimal) eachDesignationData.get(MINIMUM_GIFT_AMOUNT_API) <= 0) {
                    eachDesignationData.put(MINIMUM_GIFT_AMOUNT_API, DEFAULT_DESIGNATION_MINIMUM_GIFT_AMOUNT);
                }

                Decimal totalDueAmount = designationIdToTotalDueAmountMap.get((String)eachDesignationData.get(ID));
                eachDesignationData.put(AMOUNT_DUE_FOR_INSTALLMENTS, totalDueAmount != null ? totalDueAmount : 0);
            }

            Decimal pastDueAmount = getPledgePastDueAmount(eachPledgeData);
            Decimal currentDueAmount = getPledgeCurrentDueAmount(eachPledgeData);
            Date currentDueDate = getPledgeCurrentDueDate(eachPledgeData);
            eachPledgeData.put(PAST_DUE_AMOUNT, pastDueAmount);
            eachPledgeData.put(CURRENT_DUE_AMOUNT, currentDueAmount);
            eachpledgeData.put(CURRENT_DUE_DATE, currentDueDate);
            eachpledgeData.put(TOTAL_DUE_AMOUNT, pastDueAmount + currentDueAmount);

            eachPledgeData.remove(PLEDGE_INSTALLMENT_LIST);

            resultList.add(eachPledgeData);
        }

        return resultList;
    }

    /**
     * Gets the amount that is past due for a given pledge.
     * 
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * @param installmentDataList   List of maps that each represent installment data for a given pledge
     * 
     * 
     * @return                      Decimal value of the total amount that is past due for a pledge.
     */
    protected virtual Decimal getPledgePastDueAmount(Map<String, Object> pledgeData) {
        Decimal totalPastDueAmount = 0.00;
        List<Map<String, Object>> installmentDataList = (List<Map<String, Object>>) pledgeData?.get(PLEDGE_INSTALLMENT_LIST);

        if (installmentDataList == null || installmentDataList.isEmpty()) {
            return totalPastDueAmount;
        }

        for (Map<String, Object> eachInstallmentData : installmentDataList) {
            Date expectedDate = (Date) eachInstallmentData.get(EXPECTED_DATE);
            if (Date.today() > expectedDate && eachInstallmentData.containsKey(AMOUNT_REMAINING)) {
                // if an open installment's expected date has passed, it's remaining amount is past due
                totalPastDueAmount = totalPastDueAmount + (Decimal) eachInstallmentData.get(AMOUNT_REMAINING);
            }
        }

        return totalPastDueAmount;
    }

    /**
     * Gets the amount that is due for the current installment of a pledge. Current installment is determined
     * as the first installment with an expected date that is after today's date.
     * 
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * @param installmentDataList   List of maps that each represent installment data for a given pledge
     * 
     * 
     * @return                      Decimal value of the amount due for the current installment of a pledge.
     */
    protected virtual Decimal getPledgeCurrentDueAmount(Map<String, Object> pledgeData) {
        Decimal totalCurrentDueAmount = 0.00;
        List<Map<String, Object>> installmentDataList = (List<Map<String, Object>>) pledgeData?.get(PLEDGE_INSTALLMENT_LIST);

        if (installmentDataList == null || installmentDataList.isEmpty()) {
            return totalCurrentDueAmount;
        }

        Date currentDueInstallmentExpectedDate;
        for (Map<String, Object> eachInstallmentData : installmentDataList) {

            Date nextInstallmentExpectedDate = (Date) eachInstallmentData?.get(EXPECTED_DATE);
            if (currentDueInstallmentExpectedDate == null && Date.today() <= nextInstallmentExpectedDate) {
                // if an open installment's due date is after the current date, take the remaining amount of that installment
                totalCurrentDueAmount = totalCurrentDueAmount + (Decimal) eachInstallmentData.get(AMOUNT_REMAINING);
                currentDueInstallmentExpectedDate = nextInstallmentExpectedDate;
            } else if (currentDueInstallmentExpectedDate == nextInstallmentExpectedDate) {
                totalCurrentDueAmount = totalCurrentDueAmount + (Decimal) eachInstallmentData.get(AMOUNT_REMAINING);
            }
        }

        return totalCurrentDueAmount;
    }

    /**
     * Gets the expected date of the current installment of a pledge. Current installment is determined
     * as the first installment with an expected date that is after today's date. If no installment with
     * an expected date after today exists, then gets the expected date of the latest installment.
     * 
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * @param installmentDataList   List of maps that each represent installment data for a given pledge
     * 
     * 
     * @return                      Expected date of the current installment of a pledge if it exists. Else
     *                              will return the expected date of the latest installment.
     */
    protected virtual Date getPledgeCurrentDueDate(Map<String, Object> pledgeData) {
        List<Map<String, Object>> installmentDataList = (List<Map<String, Object>>) pledgeData?.get(PLEDGE_INSTALLMENT_LIST);

        if (installmentDataList == null || installmentDataList.isEmpty()) {
            return null;
        }

        Date latestInstallmentDate;
        for (Map<String, Object> eachInstallmentData : installmentDataList) {
            Date expectedDate = (Date) eachInstallmentData?.get(EXPECTED_DATE);
            latestInstallmentDate = expectedDate;

            if (Date.today() <= expectedDate) {
                // for the first installment that has a due date after the current date, return that date
                return expectedDate;
            }
        }

        // if no current due date is found, return the date of the latest installment
        return latestInstallmentDate;
    }

    /**
     * Calculate the total amount due (sum of past due and current due amounts) for all present designations
     * 
     * @author Jacob Huang
     * @since 1.9
     * 
     * @param pledgeData     Pledge record as a map, with pledgeInstallmentList as a key
     * 
     * @return Map of designation ID to total amount due based on the installments
     */
    protected virtual Map<String, Decimal> getDesignationIdToTotalDueAmountMap(Map<String, Object> pledgeData) {
        Map<String, Decimal> designationIdToTotalDueAmountMap = new Map<String, Decimal>();

        List<Map<String, Object>> pledgeInstallmentList = (List<Map<String, Object>>)pledgeData?.get(PLEDGE_INSTALLMENT_LIST);

        if (pledgeInstallmentList == null) {
            return designationIdToTotalDueAmountMap;
        }

        Date today = Date.today();
        Date currentInstallmentExpectedDate = this.getPledgeCurrentDueDate(pledgeData);

        for (Map<String, Object> eachInstallment : pledgeInstallmentList) {
            Date installmentExpectedDate = (Date)eachInstallment.get(EXPECTED_DATE);

            if (installmentExpectedDate == null || (installmentExpectedDate >= today && installmentExpectedDate != currentInstallmentExpectedDate)) {
                continue;
            }

            String designationId = (String)eachInstallment.get(DESIGNATION_ID);
            Decimal amountDue = (Decimal)eachInstallment.get(AMOUNT_REMAINING);
            if (designationIdToTotalDueAmountMap.containsKey(designationId) == true) {
                amountDue += designationIdToTotalDueAmountMap.get(designationId);
            }

            designationIdToTotalDueAmountMap.put(designationId, amountDue);
        }

        return designationIdToTotalDueAmountMap;
    }

    /**
     * Gets online giving base url from Portal Org Setting CMT
     * 
     * @author  Phillip Nguyen
     * @since: 1.1
     * 
     * @return  Value from Portal Org Setting CMT which should be the Base URL for the Give Page
     */
    public virtual String getOnlineGivingBaseURL(Map<String, Object> params){
        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{ID, VALUE_API},
            PORTAL_Utils.SOBJECT_NAME => PORTAL_ORGANIZATION_SETTING_MDT,
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{GIVE_PAGE_BASE_URL_CMT_DEVELOPER_NAME}
        });

        return orgSettingList?.get(0)?.Value__c;
    }

    /**
     * Generates a link to the give page using base url that can be modified on front end.
     * Appends the donor Id & page encryption (SHA-256 encryption on current date time with 30 random nums appended)
     * Takes in and returns a map so admins can use the function if they want to process multiple constituents
     * 
     * @author  Phillip Nguyen
     * @since:  1.1
     * 
     * @param   contactId   Contact Id(s) in the form of a list that we need to generate a giving link
     * @param   givingUrl   Giving Page Url passed in from the front end
     * 
     * @return  Map of Contact Ids To Generated URLS
     */
    public virtual Map<String, Object> generateOnlineGivingLink(Map<String, Object> params){
        List<Object> contactIdFrontEndList = (List<Object>)params.get(CONTACT_ID);
        String givingUrl = (String)params.get(GIVING_URL);

        Map<String, Object> returnMap = new Map<String, Object>();

        if (contactIdFrontEndList == null || contactIdFrontEndList.isEmpty() || String.isBlank(givingUrl)) {
            return returnMap;
        }

        List<Contact> contactList = getContactsMatchingListOfIDs(contactIdFrontEndList);

        if (contactList == null || contactList.isEmpty()) {
            return returnMap;
        }

        returnMap = generateMapOfContactsToUrlLinks(contactList, givingUrl);

        return returnMap;
    }

    /**
     * Gets Contact from donor id and a unique passcode 
     * This enables guest users to have prepopulated billing info on the give page 
     * when using a link that contains the correct donor id and passcode.
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param donorId   Donor Id of Constituent
     * @param passCode  Give Page Encryption String that serves as the passcode in the URL link given to a constituent
     * 
     * @return          Contact Info of constituent matching the parameters
     */
    protected virtual Contact getContactFromDonorIdAndPasscode(String donorId, String passCode) {
        if (String.isBlank(donorId) || String.isBlank(passCode)) {
            return null;
        }

        List<Contact> contactList = [SELECT Id, Name, FirstName, LastName,
                                            Email, Phone, HomePhone, MobilePhone,
                                            ucinn_portal_Stripe_Customer_ID__c,
                                            ucinn_ascendv2__Contact_Type__c,
                                            ucinn_portal_Is_Hiring_Manager__c
                                    FROM Contact
                                    WHERE ucinn_ascendv2__Donor_ID__c = :donorId AND ucinn_portal_Give_Page_Encryption__c = :passCode];

        return contactList?.get(0);
    }

    /**
     * Checks if URL provided contains any URL parameters
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param url   URL of the give page that is passed in from front end
     * 
     * @return      True if has params and vice versa
     */
    private Boolean hasUrlParameters(String url) {
        if (String.isBlank(url)) {
            return false;
        }

        return url.contains('?');
    }

    /**
     * Generate passcode using SHA-256 hash on the current date time in milliseconds concatenated with 30 random digits
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @return      Encrypted String
     */
    private String generateEncryptedPasscode() {
        String currentDateTimeString = String.valueOf(Datetime.now().getTime());

        String random30DigitString = generateRandomString(LENGTH_OF_RANDOM_STRING);

        String stringToEncrypt = currentDateTimeString + random30DigitString;

        String encryptedString = PORTAL_CommunityUtils.hashDataSha256(stringToEncrypt);

        return encryptedString;
    }

    /**
     * Generates a random string of digits of a specified length using Crypto classes random number generation method
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param   length  Length of random string
     * @return          Random string of digits
     */
    private String generateRandomString(Integer length) {
        String returnString = '';

        if (length == null || length < 0) {
            return returnString;
        }

        while(returnString.length() < length){
           //Math.abs to convert the value into positive number
           returnString += String.valueOf(Math.abs(Crypto.getRandomLong()));
        }

        return returnString.substring(0,length);
    }

    /**
     * Create Map of Contact Ids to Generated Links that redirect to give page with donor id and passcode url params
     * Updates Contact's Give Page Encryption Field if it is initially empty
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param contactList       List of contacts to generate links for
     * @param givingUrl         Base URL of giving page
     * 
     * @return                  Map of Contact Ids to Generated Link
     */
    private Map<String, Object> generateMapOfContactsToUrlLinks(List<Contact> contactList, String givingUrl) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (String.isBlank(givingUrl) || contactList == null || contactList.isEmpty()) {
            return returnMap;
        }

        String urlParamPrefix = '?';

        if (hasUrlParameters(givingUrl)) {
            urlParamPrefix = '&';
        }

        List<Contact> contactListToUpdate = new List<Contact>();

        for (Contact eachContact : contactList) {
            if (String.isBlank(eachContact.ucinn_ascendv2__Donor_ID__c)) {
                continue;
            }

            String passcode = eachContact.ucinn_portal_Give_Page_Encryption__c;

            if (String.isBlank(passcode)) {
                passcode = generateEncryptedPasscode();
                contactListToUpdate.add(new Contact(Id = eachContact.Id, ucinn_portal_Give_Page_Encryption__c = passcode));
            }

            returnMap.put(eachContact.Id, givingUrl + urlParamPrefix + DONOR_ID + '=' + eachContact.ucinn_ascendv2__Donor_ID__c + '&' + PASSCODE_CONST + '=' + passcode);

        }

        update contactListToUpdate;
        return returnMap;
    }

    /**
     * Gets a list of contacts whose Id is in a list passed in from front end or dev console.
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param contactIdList         List of contact ids passed in from front end or dev console
     * 
     * @return                      List of contacts
     */
    private List<Contact> getContactsMatchingListOfIDs(List<Object> contactIdList) {
        List<Contact> returnList = new List<Contact>();

        if (contactIdList == null || contactIdList.isEmpty()) {
            return returnList;
        }

        List<String> contactIds = new List<String>();

        // convert list of objects to list of string for soql
        for (Object eachContactId : contactIdList) {
            contactIds.add(String.valueOf(eachContactId));
        }

        returnList = [SELECT Id, ucinn_ascendv2__Donor_ID__c, ucinn_portal_Give_Page_Encryption__c 
                      FROM Contact WHERE Id IN :contactIds];

        return returnList;
    }

    /**
     * Make the callout to DTD to register the donation info.
     * May insert an organization interim for the matching company if company was chosen in frontend
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @param externalDonationIdentifier    String: ID to use for the Double the Donation record
     * @param matchingCompanyIntegration    String: Matching company integration, e.g. Double The Donation
     * @param matchingCompanyId             String: ID used by DTD to identify the company 
     * @param amount                        String: Gift amount
     * @param dtdBillingInformation         Map<String, Object>: Billing info map with the fields needed for the DTD callout
     * @param isGivingAsOrg                 Boolean: Indicates if user is giving as org
     * @param appealCode                    String: appeal code to use for the gift, nullable
     * @param pageSectionName               String: Page section setting name for getting the default appeal code
     * 
     * @return Double the Donation identifier string
     */
    public virtual String createDTDDonationAndInterim(Map<String, Object> params) {
        String externalDonationIdentifier = (String)params?.get(PORTAL_CONST_OnlineGiving.EXTERNAL_DONATION_IDENTIFIER);
        String matchingCompanyIntegration = (String)params?.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_INTEGRATION);
        String matchingCompanyId = (String)params?.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID);
        String amountString = (String)params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY);
        Object dtdBillingInformation = params?.get(PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION);
        Boolean isGivingAsOrg = (Boolean)params?.get(PORTAL_CONST_OnlineGiving.IS_GIVING_AS_ORG);
        String appealCode = (String)params?.get(PORTAL_CONST_OnlineGiving.APPEAL_CODE);
        String pageSectionName = (String)params?.get(PORTAL_CONST_OnlineGiving.PAGE_SECTION_NAME);

        if (matchingCompanyIntegration != PORTAL_PaymentHubControllerBase.DOUBLE_THE_DONATION || isGivingAsOrg  == true ||
            String.isBlank(externalDonationIdentifier) || dtdBillingInformation == null ||
            String.isBlank(amountString) || Decimal.valueOf(amountString) <= 0 ||  String.isBlank(pageSectionName)) {

            return '';
        }

        Map<String, Object> dtdParams = new Map<String, Object>{
            PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID => matchingCompanyId,
            PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION => (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dtdBillingInformation)),
            PORTAL_CONST_OnlineGiving.AMOUNT_KEY => Decimal.valueOf(amountString),
            PORTAL_CONST_OnlineGiving.TRANSACTION_DATE => Date.today(),
            PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME => String.isNotBlank(appealCode) ? appealCode : getDefaultAppeal(pageSectionName),
            PORTAL_CONST_OnlineGiving.EXTERNAL_DONATION_IDENTIFIER => externalDonationIdentifier
        };

        PORTAL_DoubleTheDonationController controller = (PORTAL_DoubleTheDonationController)PORTAL_Utils.getControllerFactory().getDoubleTheDonationController();
        PORTAL_DoubleTheDonationController.PORTAL_DTDResponseWrapper response = controller.createDonationInDtd(dtdParams);

        if (response?.organizationInterim != null) {
            insert response.organizationInterim;
        }

        return response?.donationIdentifier;
    }

    /**
     * Get the default campaign external ID from the page section setting active record field map
     * Logic is an abridged version of Payment Hub's setReviewTransactionFieldMap
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @param pageName      String: Name of the Portal Page Section Setting record to query
     * 
     * @return default campaign external ID
     */
    @TestVisible
    protected virtual String getDefaultAppeal(String pageName) {
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Active_Record_Field_Map__c FROM Portal_Page_Section_Setting__mdt WHERE Page_Name__c = :pageName AND Page_Main_Section__c = :PORTAL_PaymentHubControllerBase.DESIGNATION_CUSTOM_METADATA_NAME AND Order_By_Clause__c != null];

        if (sectionSettingList == null || sectionSettingList.isEmpty() || String.isBlank(sectionSettingList.get(0).Active_Record_Field_Map__c)) {
            return '';
        }

        Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped(sectionSettingList.get(0).Active_Record_Field_Map__c);
        return (String)fieldMap.get(CAMPAIGN_EXTERNAL_ID);
    }

    /**
     * Get the giving form record for the page
     * 
     * @author Todd Shinto
     * @since 1.13
     * 
     * @param givingFormName The name of the giving form record
     * @param pageUrl        The page URL to use to filter the giving form records
     * @param urlParamValue  The url param value to filter for a specific giving form record
     * 
     * @return A map of configuration data for the contextual giving form
     */
    public virtual Map<String, Object> getContextualGivingFormData(Map<String, Object> params) {
        String givingFormName = (String)params?.get(GIVING_FORM_NAME);
        String pageUrl = (String)params?.get(PAGE_URL);
        String urlParamValue = (String)params?.get(URL_PARAM_VALUE);
        Map<String, Object> returnMap = new Map<String, Object>();

        if (String.isBlank(givingFormName) || String.isBlank(pageUrl)) {
            return returnMap;
        }

        List<ucinn_portal_Giving_Form__c> givingFormList = [SELECT Id,
                                                                   Address_Type_Picklist_Values__c,
                                                                   Appeal__r.ucinn_ascendv2__Motivation_Code__c,
                                                                   Billing_Details_Label__c,
                                                                   Confirmation_Label__c,
                                                                   Confirmation_Text__c,
                                                                   Default_Amount__c,
                                                                   Default_Number_of_Installments__c,
                                                                   Designation_Filter_Clause__c,
                                                                   Email_Template_Developer_Name__c,
                                                                   Email_Type_Picklist_Values__c,
                                                                   Gift_Details_Label__c,
                                                                   Gift_Frequency__c,
                                                                   Gift_Types__c,
                                                                   Is_End_Date_Enabled__c,
                                                                   Is_Fixed_Amount__c,
                                                                   Is_Fixed_Installments__c,
                                                                   Name,
                                                                   Page_URL__c,
                                                                   Payment_Form_Label__c,
                                                                   Phone_Type_Picklist_Values__c
                                                            FROM ucinn_portal_Giving_Form__c
                                                            WHERE Name = :givingFormName
                                                                AND Page_URL__c = :pageUrl
                                                                AND URL_Parameter_Value__c = :urlParamValue
                                                            ORDER BY Page_URL__c 
                                                            DESC NULLS LAST];
        
        if (givingFormList.isEmpty()) {
            return returnMap;
        }

        ucinn_portal_Giving_Form__c givingForm = givingFormList[0];
        String whereClause = givingForm.Designation_Filter_Clause__c;
        whereClause = String.isBlank(whereClause) ? '' : PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => String.escapeSingleQuotes(whereClause), PORTAL_CommunityUtils.PARAM_PREFIX => PORTAL_CONST_Global.WHERE_CLAUSE_PREFIX, PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
        
        String designationQueryString = 'SELECT Id, ucinn_ascendv2__Designation_Name__c FROM ucinn_ascendv2__Designation__c ' + whereClause;
        List<ucinn_ascendv2__Designation__c> designationList = Database.query(designationQueryString);

        if (designationList.isEmpty()) {
            return returnMap;
        }

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{ID, VALUE_API},
            PORTAL_Utils.SOBJECT_NAME => PORTAL_ORGANIZATION_SETTING_MDT,
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{CONTEXTUAL_GIVING_FORM_PAYMENT_PROCESSOR, CONTEXTUAL_GIVING_FORM_SPREEDLY_GATEWAY}
        });

        returnMap = getFormattedContextualGivingFormData(givingForm, designationList, orgSettingList);
        return returnMap;
    }

    
    /**
     * Format the giving form records and get contact info
     * 
     * @author Todd Shinto
     * @since 1.13
     * 
     * @param givingForm        The giving form record
     * @param designationList   The list of designations
     * @param orgSettingList    List of Org setting, should just be one with the payment processor value
     * @return A formatted map of configuration data for the contextual giving form
     */
    protected virtual Map<String, Object> getFormattedContextualGivingFormData(ucinn_portal_Giving_Form__c givingForm, List<ucinn_ascendv2__Designation__c> designationList, List<Portal_Organization_Setting__mdt> orgSettingList) {
        if (givingForm == null || designationList == null || designationList.isEmpty() || orgSettingList == null || orgSettingList.isEmpty()) {
            return new Map<String, Object>();
        }
        List<Map<String, Object>> designationWrapperList = new List<Map<String, Object>>();

        for (ucinn_ascendv2__Designation__c eachDesignation : designationList) {
            designationWrapperList.add(new Map<String, Object>{DESIGNATION_ID => eachDesignation.Id, DESIGNATION_NAME => eachDesignation.ucinn_ascendv2__Designation_Name__c});
        }

        Contact contactBioInformation = PORTAL_CommunityUtils.getContactPreferredBioInfo(UserInfo.getUserId());
        PORTAL_ContactWrapper contactWrapper = new PORTAL_ContactWrapper(contactBioInformation);

        String paymentProcessor = '';
        String externalGatewayName = '';

        for (Portal_Organization_Setting__mdt eachOrgSetting : orgSettingList) {
            if (eachOrgSetting.DeveloperName == CONTEXTUAL_GIVING_FORM_PAYMENT_PROCESSOR) {
                paymentProcessor = eachOrgSetting.Value__c;
            } else if (eachOrgSetting.DeveloperName == CONTEXTUAL_GIVING_FORM_SPREEDLY_GATEWAY) {
                externalGatewayName = eachOrgSetting.Value__c;
            }
        }

        if (String.isBlank(paymentProcessor)) {
            return new Map<String, Object>();
        }

        return new Map<String, Object>{
            APPEAL_KEY => givingForm.Appeal__r.ucinn_ascendv2__Motivation_Code__c,
            CONFIRMATION_TEXT => givingForm.Confirmation_Text__c,
            DEFAULT_AMOUNT => givingForm.Default_Amount__c,
            DEFAULT_NUMBER_OF_INSTALLMENTS => givingForm.Default_Number_of_Installments__c,
            GIFT_TYPES => givingForm.Gift_Types__c,
            GIFT_FREQUENCIES => givingForm.Gift_Frequency__c,
            IS_FIXED_AMOUNT => givingForm.Is_Fixed_Amount__c,
            IS_FIXED_INSTALLMENTS => givingForm.Is_Fixed_Installments__c,
            IS_END_DATE_ENABLED => givingForm.Is_End_Date_Enabled__c,
            DESIGNATION_LIST => designationWrapperList,
            PHONE_TYPES => givingForm.Phone_Type_Picklist_Values__c,
            EMAIL_TYPES => givingForm.Email_Type_Picklist_Values__c,
            ADDRESS_TYPES => givingForm.Address_Type_Picklist_Values__c,
            GIFT_DETAILS_LABEL => givingForm.Gift_Details_Label__c,
            BILLING_DETAILS_LABEL => givingForm.Billing_Details_Label__c,
            PAYMENT_FORM_LABEL => givingForm.Payment_Form_Label__c,
            CONFIRMATION_LABEL => givingForm.Confirmation_Label__c,
            CONTACT_INFORMATION => contactWrapper,
            PAYMENT_PROCESSOR => paymentProcessor,
            EXTERNAL_GATEWAY_NAME => externalGatewayName,
            EMAIL_TEMPLATE_DEVELOPER_NAME => givingForm.Email_Template_Developer_Name__c
        };
    }
}