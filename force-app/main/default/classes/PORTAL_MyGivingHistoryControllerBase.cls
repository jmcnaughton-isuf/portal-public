/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
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
 * Giving history lwc functionality
 *
 * @author      Daniel Mardirousi
 * @version 1.0
 * @since   1.0
 */

global virtual inherited sharing class PORTAL_MyGivingHistoryControllerBase {

    // Page Section variables
    private static final String GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME = 'Giving History';
    private static final String YEARLY_GIVING_SUMMARY_MAIN_SECTION_NAME = 'Yearly Giving Summary Table';
    private static final String YEARLY_GIVING_SUMMARY_FUNDRAISING_SUB_SECTION_NAME = 'Fundraising';
    private static final String YEARLY_GIVING_SUMMARY_CASH_SUB_SECTION_NAME = 'Cash';
    private static final String PIE_CHART_MAIN_SECTION_NAME = 'Pie chart';
    private static final String GIVING_HISTORY_TABLE_MAIN_SECTION_NAME = 'Giving History Table';
    private static final String PLEDGE_TABLE_MAIN_SECTION_NAME = 'Pledge table';
    private static final String RECURRING_GIFT_TABLE_MAIN_SECTION_NAME = 'Recurring Gift Table';
    private static final String MATCHING_GIFT_TABLE_MAIN_SECTION_NAME = 'Matching Gift Table';
    private static final String YEAR_END_TAX_LETTER_TABLE_MAIN_SECTION_NAME = 'Year End Tax Letter';

    // class key values
    private final static String PAGE_SECTION_PARENT_FIELD_ID = 'parentFieldId';
    private final static String PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY = 'objectToFieldMap';
    private final static String PAGE_SECTION_QUERY_FOR_ALL_RECORDS_KEY = 'queryForAllRecords';
    private final static String PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY = 'dynamicQueryClass';
    private final static String PERMISSION_MAP_KEY = 'permissionMap';
    private final static String RECORDS_TO_RETURN_KEY = 'records';
    private final static String SECTION_MAP_KEY = 'sectionMap';
    private final static String ERROR_MESSAGE_KEY = 'errorMessage';
    private final static String TOTAL_NUMBER_OF_RECORDS_KEY = 'totalNumberOfRecords';
    private final static String MAX_DESIGNATIONS_TO_DISPLAY = 'maxDesignations';
    private final static String RECEIPT_BASE_URL = 'receiptBaseURL';
    private final static String RECEIPT_FULL_URL = 'receiptURL';
    private final static String RECEIPT_CONTENT_PAGE_NAME = 'receiptContentPageName';
    private final static String AGGREGATE_AMOUNT_FIELD_NAME = 'yearAmount';
    private final static String AGGREGATE_YEAR_FIELD_NAME = 'year';

    // Portal Section Field front end field ID keys
    private static final String ENCRYPTED_PAYMENT_INFO_KEY = 'encryptedPaymentInfo';
    private static final String SUBSCRIPTION_ID_KEY = 'subscriptionId';
    private static final String EXTERNAL_PAYMENT_GATEWAY_ID_KEY = 'externalPaymentGatewayId';
    private static final String INSTALLMENT_DATE_KEY = 'installmentDate';
    private static final String INSTALLMENT_EXPECTED_AMOUNT_KEY = 'installmentExpectedAmount';
    private static final String RECURRING_GIFT_FREQUENCY_KEY = 'recurringGiftFrequency';
    private static final String RECURRING_GIFT_START_DATE_KEY = 'recurringGiftStartDate';
    private static final String RECURRING_GIFT_END_DATE_KEY = 'recurringGiftEndDate';
    private static final String RECURRING_GIFT_AMOUNT_PAID_KEY = 'recurringGiftAmountPaid';
    private static final String RECURRING_GIFT_AMOUNT_KEY = 'recurringGiftAmount';

    // Custom fields created/added to the wrapper, other related constants
    private static final String NUMBER_OF_PAYMENTS_REMAINING_KEY = 'numberOfPaymentsRemaning';
    private static final String NEXT_EXPECTED_PAYMENT_DATE_KEY = 'nextExpectedPaymentDate';
    private static final String UPDATE_CREDIT_CARD_KEY = 'updateCreditCard';
    private static final String SHOW_UPDATE_CREDIT_CARD_KEY = 'showUpdateCreditCard';

    // unformatted data
    private final static String UNFORMATTED_CASH_TABLE_DATA = 'cashGiving';
    private final static String UNFOMRATTED_FUNDRAISING_TABLE_DATA = 'fundraisingGiving';
    private final static String UNFORMATTED_PIE_CHART_DATA = 'pieChartData';
    private final static String UNFORMATTED_GIVING_HISTORY_TABLE_DATA = 'givingHistoryData';
    private final static String UNFORMATTED_PLEGE_TABLE_DATA = 'constituentsPledges';
    private final static String UNFORMATTED_RECURRING_TABLE_DATA = 'recurringTableData';
    private final static String UNFORMATTED_YEAR_END_TABLE_DATA = 'yearEndTableData';

    // fiscal year map keys
    global final static String FISCAL_YEAR_LOWER_BOUND_KEY = 'lowerBound';
    global final static String FISCAL_YEAR_UPPER_BOUND_KEY = 'upperBound';
    global final static String FISCAL_YEAR_PRIOR_YEARS_TO_INCLUDE = 'priorYearsToInclude';

    // frequency conversion map keys
    global final static String FREQUENCY_CONVERSION_MONTHS_KEY = 'months';
    global final static String FREQUENCY_CONVERSION_DAYS_KEY = 'days';
    global final static String FREQUENCY_KEY = 'frequency';

    public final static String ITEMS_PER_PAGE = 'itemsPerPage';
    public final static String OFFSET_CONST = 'offset';
    public final static String MAIN_QUERY = 'mainQuery';


    // private class variables. These variables can be used within the portal page section query.
    private Id contactId;
    private Integer fiscalYearLowerBound = 0;
    private Integer fiscalYearUpperBound = 0;

    private final static String ERROR_MESSAGE_WITH_ERROR_CODE = 'Please contact system adminstration. Error Code: ';
    global final static String GENERIC_ERROR_MESSAGE = 'There was an error, please contact system adminstration.';

    global class GivingHistoryException extends Exception {}


    /**
     * Default construtor which sets class variables for both giving history functions and for executing query strings.
     */
    global PORTAL_MyGivingHistoryControllerBase() {
        contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).contactId;
        Map<String, Object> fiscalYearInfo = getFiscalYearInfo();
        fiscalYearLowerBound = (Integer)fiscalYearInfo.get(FISCAL_YEAR_LOWER_BOUND_KEY);
        fiscalYearUpperBound = (Integer)fiscalYearInfo.get(FISCAL_YEAR_UPPER_BOUND_KEY);

        if (fiscalYearLowerBound == null || fiscalYearUpperBound == null || fiscalYearLowerBound >= fiscalYearUpperBound) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '201.');
        }

    }

    /*
        Giving By fiscal year
    */

    /**
     * Retrieve and format data for the fiscal year table on the giving history page.
     *
     * @param   paramMap                                List of parameters passed in by the calling function.
     *                                                      Boolean hideEmptyRows: hide/show empty rows of giving.
     *                                                      String fiscalyearOrder: Order in which the fiscal year rows display on the table.
     * @return                                          Formatted records and its associated permission map.
     */
    global virtual Map<String, Object> getFiscalYearTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        // Fundraising portal page section
        Map<String, Object> fundraisingPageSectionMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME,
                                                                                    YEARLY_GIVING_SUMMARY_MAIN_SECTION_NAME,
                                                                                    YEARLY_GIVING_SUMMARY_FUNDRAISING_SUB_SECTION_NAME,
                                                                                    YEARLY_GIVING_SUMMARY_FUNDRAISING_SUB_SECTION_NAME);
        Map<String, List<Portal_Page_Section_Setting__mdt>> fundraisingSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)fundraisingPageSectionMetadata.get(SECTION_MAP_KEY);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)fundraisingPageSectionMetadata.get(PERMISSION_MAP_KEY);

        // Cash portal page section
        Map<String, Object> cashPortalSectionMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME,
                                                                                    YEARLY_GIVING_SUMMARY_MAIN_SECTION_NAME,
                                                                                    YEARLY_GIVING_SUMMARY_CASH_SUB_SECTION_NAME,
                                                                                    YEARLY_GIVING_SUMMARY_CASH_SUB_SECTION_NAME);
        Map<String, List<Portal_Page_Section_Setting__mdt>> cashSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)cashPortalSectionMetadata.get(SECTION_MAP_KEY);
        permissionMap.putAll((Map<String, Map<String, Object>>)cashPortalSectionMetadata.get(PERMISSION_MAP_KEY)); // Combine cash and fundraising permission map. Note that cash has presidence over fundraising if there are any key collisions

        // Query data and format records
        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, cashSection);
        List<sObject> cashGivingByFiscalYear = getConstituentYearlyCashGiving(paramMap);

        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, fundraisingSection);
        List<sObject> fundraisingGivingByFiscalYear = getConstituentYearlyFundraisingGiving(paramMap);

        paramMap.put(UNFORMATTED_CASH_TABLE_DATA, cashGivingByFiscalYear);
        paramMap.put(UNFOMRATTED_FUNDRAISING_TABLE_DATA, fundraisingGivingByFiscalYear);
        List<Map<String, Object>> formattedData = formatFiscalYearTableData(paramMap);

        returnMap.put(RECORDS_TO_RETURN_KEY, formattedData);
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        return returnMap;
    }

    /**
     * Build query string and query records for cash column.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          Id parentFieldId: Id for the controlling parent field on the associated portal page section record.
     *                                                          Map<String, List<Portal_Page_Section_Setting__mdt> objectToFieldMap: Map of components needed to build portal page section query string.
     * @return                                              Results of the portal page section query.
     */
    global virtual List<sObject> getConstituentYearlyCashGiving(Map<String, Object> paramMap) {
        List<sObject> cashGiving = new List<sObject>();
        List<String> cashGivingTypes = cashGiftTypes(null); //This variable can be used within the cash giving query below.

        if (cashGivingTypes.isEmpty()) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '202.');
        }

        try {
            cashGiving = Database.query(generateQueryString(paramMap));
        } catch(QueryException e) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '203.');
        }

        return cashGiving;
    }

    /**
     * Build query string and query records for fundraising column.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          Id parentFieldId: Id for the controlling parent field on the associated portal page section record.
     *                                                          Map<String, List<Portal_Page_Section_Setting__mdt> objectToFieldMap: Map of components needed to build portal page section query string.
     * @return                                              Results of the portal page section query.
     */
    global virtual List<sObject> getConstituentYearlyFundraisingGiving(Map<String, Object> paramMap) {
        List<sObject> fundraisingGiving = new List<sObject>();
        List<String> fundraisingGivingTypes = fundraisingGiftTypes(null); //This variable can be used within the fundraising query below.

        if (fundraisingGivingTypes.isEmpty()) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '204.');
        }

        try {
            fundraisingGiving = Database.query(generateQueryString(paramMap));
        } catch(QueryException e) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '205.');
        }

        return fundraisingGiving;
    }

    /**
     * Format fiscal year table data.
     *
     * @param   paramMap                                    Parameters passed in by the calling function.
     *                                                          List<sObject> cashGiving: Unformatted cash data.
     *                                                          List<sObject> fundraisingGiving: Unformatted fundraising data.
     *                                                          String fiscalYearOrder: Order of the fiscal year table.
     *                                                          Boolean hideEmptyRows: Hide/show empty rows on the fiscal year table.
     * @return                                              Returns a list of formatted data for the fiscal year table.
     */
    global virtual List<Map<String, Object>> formatFiscalYearTableData(Map<String, Object> params) {
        if (params.get(UNFORMATTED_CASH_TABLE_DATA) == null || params.get(UNFOMRATTED_FUNDRAISING_TABLE_DATA) == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 224.');
        }

        List<Map<String, Object>> fiscalYearToGivingAmounts = new List<Map<String, Object>>();
        Map<String, Decimal> fiscalYearToCashMap = new Map<String, Decimal>();
        Map<String, Decimal> fiscalYearToFundraisingMap = new Map<String, Decimal>();
        List<sObject> cashGiving = (List<sObject>)params.get(UNFORMATTED_CASH_TABLE_DATA);
        List<sObject> fundraisingGiving  = (List<sObject>)params.get(UNFOMRATTED_FUNDRAISING_TABLE_DATA);

        String amountKey = 'amount';
        String fiscalYearKey = 'fiscalYear';
        String hideEmptyRowsKey = 'hideEmptyRows';

        String fiscalYearOrder = (String)params.get('fiscalYearOrder');
        Boolean hideEmptyRows = false;

        if (params.get(hideEmptyRowsKey) != null) {
            hideEmptyRows = (Boolean)params.get(hideEmptyRowsKey);
        }

        // populate year to cash
        for (sObject currentCashGiving: cashGiving) {
            Decimal amt = (Decimal)currentCashGiving.get(amountKey);
            Integer year = (Integer)currentCashGiving.get(fiscalYearKey);

            fiscalYearToCashMap.put(String.valueOf(year), amt);
        }

        // populate year to fundraising
        for (sObject currentFundraisingGiving: fundraisingGiving) {
            Decimal amt = (Decimal)currentFundraisingGiving.get(amountKey);
            Integer year = (Integer)currentFundraisingGiving.get(fiscalYearKey);

            fiscalYearToFundraisingMap.put(String.valueOf(year), amt);
        }

        for (Integer currentFiscalYear = fiscalYearUpperBound; currentFiscalYear >= fiscalYearLowerBound; currentFiscalYear--) {
            String fiscalYear = String.valueOf(currentFiscalYear);
            Decimal cashAmount = fiscalYearToCashMap.get(fiscalYear) ;
            Decimal fundraisingAmount = fiscalYearToFundraisingMap.get(fiscalYear);

            if (cashAmount == null) {
                cashAmount = 0;
            }

            if (fundraisingAmount == null) {
                fundraisingAmount = 0;
            }

            if (hideEmptyRows == true && cashAmount == 0 && fundraisingAmount == 0) {
                continue;
            }

            Map<String, Object> fisalYearTableDataRow = new Map<String, Object>{'fiscalYear' => currentFiscalYear, 'cashAmount' => cashAmount,
                                                                                 'fiscalAmountFundraising' => fundraisingAmount};

            if (fiscalYearOrder == null || fiscalYearOrder == 'Descending') {
                fiscalYearToGivingAmounts.add(fisalYearTableDataRow);
            }
            else if (fiscalYearOrder == 'Ascending') {

                if (fiscalYearToGivingAmounts.isEmpty()) {
                    fiscalYearToGivingAmounts.add(fisalYearTableDataRow);
                } else {
                    fiscalYearToGivingAmounts.add(0, fisalYearTableDataRow);
                }

            }
        }

        return fiscalYearToGivingAmounts;
    }

    // TODO: Add to portal page section when the where clause field is expanded.
    global virtual List<String> cashGiftTypes(Map<String, Object> paramMap) {
        return new List<String>{'Pledge Payment', 'Outright Gift', 'Recurring Gift Payment', 'Matching Gift Payment'};
    }

    // TODO: Add to portal page section when the where clause field is expanded.
    global virtual List<String> fundraisingGiftTypes(Map<String, Object> paramMap) {
        return new List<String>{'Outright Gift', 'Matching Gift', 'Pledge', 'Recurring Gift'};
    }


    /*
        Pie chart
    */


    /**
     * Retrieve and format data for the pie chart on the giving history page.
     *
     * @param   paramMap                                List of parameters passed in by the calling function.
     *                                                      Integer maxDesginations: Max number of desginations to show on the pie chart.
     * @return                                          Formatted records and its associated permission map.
     */
    global Map<String, Object> getPieChartData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        // Get pie chart portal section data
        Map<String, Object> pieChartPageSectionMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME,
                                                                                PIE_CHART_MAIN_SECTION_NAME,
                                                                                null,
                                                                                PIE_CHART_MAIN_SECTION_NAME);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)pieChartPageSectionMetadata.get(PERMISSION_MAP_KEY);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)pieChartPageSectionMetadata.get(SECTION_MAP_KEY);

        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, mainSection);
        List<sObject> pieChartData = pieChartQuery(paramMap);

        paramMap.put(UNFORMATTED_PIE_CHART_DATA, pieChartData);
        returnMap.put(RECORDS_TO_RETURN_KEY, formatPieChartGiving(paramMap));

        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        return returnMap;
    }

    /**
     * Query pie chart data.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              unformatted pie chart data.
     */
    global virtual List<sObject> pieChartQuery(Map<String, Object> paramMap) {
        List<sObject> pieChartData = new List<sObject>();
        Set<String> pieChartGivingTypes = pieChartGivingTypes(); //This variable can be used in the pie chart giving types query

        try {
            pieChartData = Database.query(generateQueryString(paramMap));
        } catch(QueryException e) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '206.');
        }

        return pieChartData;
    }

    // TODO: Add to portal page section when the where clause field is expanded.
    global virtual Set<String> pieChartGivingTypes() {
        return new Set<String>{'Pledge Payment', 'Outright Gift', 'Recurring Gift Payment', 'Matching Gift Payment'};
    }

    /**
     * Format pie chart data. Grabs the top x number of designations and sums the rest into 'other'.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          List<sObject> UNFORMATTED_PIE_CHART_DATA: unformatted pie chart data.
     *                                                          Integer MAX_DESIGNATIONS_TO_DISPLAY: Max number of desginations to show on the giving pie chart.
     * @return                                              Map of lists with values and labels. Matching index on both lists indicate matching data.
     */
    global virtual Map<String, Object> formatPieChartGiving(Map<String, Object> paramMap) {

        if (paramMap.get(UNFORMATTED_PIE_CHART_DATA) == null || paramMap.get(MAX_DESIGNATIONS_TO_DISPLAY) == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 225.');
        }

        Map<String, Object> returnMap = new Map<String, Object>();
        List<String> designationNames = new List<String>();
        List<Decimal> designationSums = new List<Decimal>();
        List<sObject> givingByDesignation = (List<sObject>) paramMap.get(UNFORMATTED_PIE_CHART_DATA);
        Integer maxDesignations = Integer.valueOf((Decimal)paramMap.get(MAX_DESIGNATIONS_TO_DISPLAY));
        Decimal totalOtherGiving  = 0;
        String amountKey = 'amount';
        String designationNameKey = 'designationName';

        // results passed in are sorted based on the order by clause, if present, in portal page section.
        // If order by clause is not present, then it will be sorted by Id by default.
        for (sObject designationGivingRow : givingByDesignation) {
            Decimal amount = (Decimal)designationGivingRow.get(amountKey);

            if (maxDesignations > 0) {
                String desgintationName = (String)designationGivingRow.get(designationNameKey);

                if (String.isNotBlank(desgintationName)) {
                    designationNames.add(desgintationName);
                    designationSums.add(amount);
                    maxDesignations -= 1;
                } else {
                    totalOtherGiving += amount;
                }

            } else {
                totalOtherGiving += amount;
            }

        }

        if (totalOtherGiving > 0) {
            designationNames.add('Other');
            designationSums.add(totalOtherGiving);
        }

        returnMap.put('labels', designationNames);
        returnMap.put('values', designationSums);

        return returnMap;
    }


    /*
        Giving History Table
    */


    /**
     * Query giving history table data based on portal page section settings, then format the data.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          Integer itemsPerPage: Item to display per page on the table
     *                                                          Integer currentOffset: Current offset for pagination query.
     *                                                          String receiptBaseURL: receipt base URL for the gift receipt page.
     *                                                          String receiptContentPageName: Content page name for gift receipt page.
     * @return                                              Returns formatted records, related metadata for portal page section fields, and total number of records for pagination.
     */
    global virtual Map<String, Object> getGivingHistoryTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        // Get page section data
        Map<String, Object> givingHistoryTablePageSectionMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME,
                                                                                            GIVING_HISTORY_TABLE_MAIN_SECTION_NAME,
                                                                                            null,
                                                                                            GIVING_HISTORY_TABLE_MAIN_SECTION_NAME);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)givingHistoryTablePageSectionMetadata.get(PERMISSION_MAP_KEY);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)givingHistoryTablePageSectionMetadata.get(SECTION_MAP_KEY);

        Integer maxNumberofQueryRecords = Integer.valueOf(mainSection?.get(MAIN_QUERY)?.get(0)?.Max_Number_of_Query_Records__c);
        maxNumberofQueryRecords = maxNumberofQueryRecords != null ? maxNumberofQueryRecords : Integer.valueOf((Decimal)paramMap.get(ITEMS_PER_PAGE));

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass paginationOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', '', '', '', maxNumberofQueryRecords, Integer.valueOf((Decimal)paramMap.get(OFFSET_CONST)), false);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass countQueryOveride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('SELECT Count() ', null, '', '', null, null, true);

        // Query data based on page section info and format it
        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, mainSection);
        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, paginationOverride);
        List<sObject> constituentsHardAndSoftCredits = getGivingHistoryTableQuery(paramMap);

        paramMap.put(UNFORMATTED_GIVING_HISTORY_TABLE_DATA, constituentsHardAndSoftCredits);
        List<Map<String, Object>> formattedHardAndSoftCredit = formatGivingHistoryTableData(paramMap);

        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, countQueryOveride);
        returnMap.put(TOTAL_NUMBER_OF_RECORDS_KEY, getGivingHistoryTableNumberTotalRecords(paramMap));

        returnMap.put(RECORDS_TO_RETURN_KEY, formattedHardAndSoftCredit);
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        return returnMap;
    }

    /**
     * Query giving history table data for the current page.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              unformatted pie chart data.
     */
    global virtual List<sObject> getGivingHistoryTableQuery(Map<String, Object> paramMap) {
        List<sObject> givingHistoryRecords = new List<sObject>();
        List<String> givingHistoryGiftTypes = givingHistoryGiftTypes(null); //This variable can be used within the fundraising query below.

        if (givingHistoryGiftTypes.isEmpty()) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '204.');
        }

        try {
            givingHistoryRecords = Database.query(generateQueryString(paramMap));
        } catch(QueryException e) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '205.');
        }

        return givingHistoryRecords;
    }

    // TODO: Add to portal page section when the where clause field is expanded.
    global virtual List<String> givingHistoryGiftTypes(Map<String, Object> paramMap) {
        return new List<String>{'Pledge Payment', 'Outright Gift', 'Recurring Gift Payment', 'Matching Gift Payment'};
    }

    /**
     * Query total number of records for giving history table query for pagination.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              unformatted pie chart data.
     */
    global virtual Integer getGivingHistoryTableNumberTotalRecords(Map<String, Object> paramMap) {
        Integer count = 0;
        String errorMessage = ERROR_MESSAGE_WITH_ERROR_CODE + '207.';
        List<String> givingHistoryGiftTypes = givingHistoryGiftTypes(null); //This variable can be used within the fundraising query below.

        try {
            count = Database.countQuery(generateQueryString(paramMap));
        } catch(QueryException e) {

            if (String.isBlank(errorMessage)) {
                errorMessage = e.getMessage();
            }

            throw new GivingHistoryException(errorMessage);
        }

        return count;
    }

    /**
     * Foramt giving history data. Converts data to front end wrapper and adds receipt information to the wrapper.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              Formatted giving history table data wrapper.
     */
    global virtual List<Map<String, Object>> formatGivingHistoryTableData(Map<String, Object> paramMap) {

        if (paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY) == null || paramMap.get(UNFORMATTED_GIVING_HISTORY_TABLE_DATA) == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 226.');
        }

        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY);
        List<sObject> hardAndSoftCredits = (List<sObject>)paramMap.get(UNFORMATTED_GIVING_HISTORY_TABLE_DATA);
        List<Map<String, Object>> formattedHardAndSoftCreditList = PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(hardAndSoftCredits, objectToFieldMap);
        String receiptBaseURL = (String)paramMap.get(RECEIPT_BASE_URL);
        String contentPageBaseName = (String)paramMap.get(RECEIPT_CONTENT_PAGE_NAME);

        for (Map<String, Object> formattedHardAndSoftCredit : formattedHardAndSoftCreditList) {
            Boolean showRecipt = showGiftRecipt(formattedHardAndSoftCredit);
            formattedHardAndSoftCredit.put('showReceipt', showRecipt);

            if (showRecipt && String.isNotBlank(receiptBaseURL) && String.isNotBlank(contentPageBaseName) && formattedHardAndSoftCredit.get('Id') != null) {
                formattedHardAndSoftCredit.put(RECEIPT_FULL_URL, generateGiftReceiptURL(new Map<String, Object>{RECEIPT_BASE_URL => receiptBaseURL,
                                                                                                                'contentPageBaseName' => contentPageBaseName,
                                                                                                                'Id' => (Id)formattedHardAndSoftCredit.get('Id')} ));
            }

        }

        return formattedHardAndSoftCreditList;
    }

    /**
     * Determine if receipt should be shown for a given table row.
     *
     * @param   formattedHardAndSoftCredit                  Formatted hard and soft credit wrapper
     * @return                                              Boolean indicating if receipt should be shown or not
     */
    global virtual Boolean showGiftRecipt(Map<String, Object> formattedHardAndSoftCredit) {
        if ((String)formattedHardAndSoftCredit.get('creditType') == 'Hard') {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Generate receipt url for a given table row.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          String RECEIPT_BASE_URL: Base URL for the gift receipt.
     *                                                          String contentPageBaseName: Name for the content page we pull static content from
     *                                                          String Id: Id for the hard and soft credit record we are creating a receipt for.
     * @return                                              Formatted giving history table data.
     */
    global virtual String generateGiftReceiptURL(Map<String, Object> paramMap){
        return '/' + (String)paramMap.get(RECEIPT_BASE_URL) + '?' + PORTAL_VF_GiftReceiptController.CONTENT_PAGE_NAME + '=' + (String)paramMap.get('contentPageBaseName') + '&'
                     + PORTAL_VF_GiftReceiptController.RECORD_ID + '=' +(Id)paramMap.get('Id');
    }


    /*
        Plege Tables functions
    */

     /**
     * Query pledge table data based on portal page section settings, then format the data.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          Integer itemsPerPage: Number of items per page on the table
     *                                                          Integer offset: Offset for pagination query.
     * @return                                              Returns formatted records, related metadata for portal page section fields, and total number of records for pagination.
     */
    global virtual Map<String, Object> getPledgeTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        // Get portal page sections data to build query
        Map<String, Object> pledgeTablePageSectionMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME,
                                                                                    PLEDGE_TABLE_MAIN_SECTION_NAME,
                                                                                    null,
                                                                                    PLEDGE_TABLE_MAIN_SECTION_NAME);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)pledgeTablePageSectionMetadata.get(SECTION_MAP_KEY);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)pledgeTablePageSectionMetadata.get(PERMISSION_MAP_KEY);

        Integer maxNumberofQueryRecords = Integer.valueOf(mainSection?.get(MAIN_QUERY)?.get(0)?.Max_Number_of_Query_Records__c);
        maxNumberofQueryRecords = maxNumberofQueryRecords != null ? maxNumberofQueryRecords : Integer.valueOf((Decimal)paramMap.get(ITEMS_PER_PAGE));

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass countQueryOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('SELECT Count()', null, '', '', null, null, true);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass paginationOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', '', '', '', maxNumberofQueryRecords, Integer.valueOf((Decimal)paramMap.get(OFFSET_CONST)), false);

        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, mainSection);
        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, paginationOverride);
        List<sObject> constituentsPledges = getPledgeTableQuery(paramMap);

        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, countQueryOverride);
        returnMap.put(TOTAL_NUMBER_OF_RECORDS_KEY, getPledgeTableNumberTotalRecords(paramMap));

        paramMap.put(UNFORMATTED_PLEGE_TABLE_DATA, constituentsPledges);
        returnMap.put(RECORDS_TO_RETURN_KEY, formatPledgeData(paramMap));
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        return returnMap;
    }

    /**
     * Query peldge table data for the current page.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              unformatted pie chart data.
     */
    global virtual List<sObject> getPledgeTableQuery(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '213.');
        return getTableQuery(paramMap);
    }

    /**
     * Query total number of records for pledge table query for pagination.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              unformatted pie chart data.
     */
    global virtual Integer getPledgeTableNumberTotalRecords(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '214.');
        return getTableCountQuery(paramMap);
    }

    /**
     * Format pledge table data. Converts data to front end wrapper.
     * Adds receipt information and credit card last 4 digits (if necessary) to the wrapper.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          List<sObject> UNFORMATTED_PLEGE_TABLE_DATA: List of unformatted constituent pledges
     *                                                          Map<String, List<Portal_Page_Section_Setting__mdt>> PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY: Main section for portal page section. Used for creating wrapper map.
     *                                                          Boolean showUpdateCreditCard: indicates whether to make callouts for credit card last 4 digits or not
     *                                                          String paymentMethod: payment processor used (Stripe, Spreedly, Cybersource)
     * @return                                              Formatted giving history table data wrapper.
     */
    global virtual List<Map<String, Object>> formatPledgeData(Map<String, Object> paramMap) {

        if (paramMap.get(UNFORMATTED_PLEGE_TABLE_DATA) == null || paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY) == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 227.');
        }

        List<sObject> constituentsPledges = (List<sObject>)paramMap.get(UNFORMATTED_PLEGE_TABLE_DATA);
        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY);
        List<Map<String, Object>> formattedPledgeWrapper = PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(constituentsPledges, objectToFieldMap);

        Map<String, String> idToCreditCardDigitsMap = getCreditCardIdToLastFourDigitsMap(formattedPledgeWrapper, (Boolean) paramMap.get(SHOW_UPDATE_CREDIT_CARD_KEY), (String) paramMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));

        String relatedOpportunityInstallmentKey = 'ucinn_ascendv2__Installments_Opportunity__r'; // SObject Relationship API Name on portal page section

        for (Map<String, Object> formattedRecord : formattedPledgeWrapper) {

            if (formattedRecord.get(relatedOpportunityInstallmentKey) != null) {
                List<Map<String, Object>> relatedInstallments = (List<Map<String, Object>>)formattedRecord.get(relatedOpportunityInstallmentKey);

                // We are only grabbing the first date and amount for installments since it should be ordered in the portal page section query.
                // We are only displaying the next expected payment amount and date.
                if (!relatedInstallments.isEmpty()) {
                    formattedRecord.put(INSTALLMENT_DATE_KEY, relatedInstallments[0].get(INSTALLMENT_DATE_KEY));
                    formattedRecord.put(INSTALLMENT_EXPECTED_AMOUNT_KEY, relatedInstallments[0].get(INSTALLMENT_EXPECTED_AMOUNT_KEY));
                    formattedRecord.put(NUMBER_OF_PAYMENTS_REMAINING_KEY, relatedInstallments.size()); // new field being created and added to wrapper.
                }

                // remove data from showing on the frontend
                formattedRecord.remove(relatedOpportunityInstallmentKey);
            }

            // new field added to wrapper: credit card digits
            String creditCardLastFour = idToCreditCardDigitsMap.get(getCreditCardIdKey(formattedRecord));
            formattedRecord.put(UPDATE_CREDIT_CARD_KEY, creditCardLastFour != null ? 'Update Card Ending in ' + creditCardLastFour : 'Update');
        }

        return formattedPledgeWrapper;
    }


    /*
        Recurring Gift
    */

    /**
     * Retrieve and format data for the Recurring gift table.
     *
     * @param   paramMap                                List of parameters passed in by the calling function.
     *                                                      Integer itemsPerPage: Max number of rows to show per page.
     *                                                      Integer offset: Offset used for pagination query.
*                                                           Boolean showUpdateCreditCard: indicates whether to make callouts for credit card last 4 digits or not
*                                                           String paymentMethod: payment processor used (Stripe, Spreedly, Cybersource)
     * @return                                          Formatted records and its associated permission map.
     */
    global virtual Map<String, Object> getRecurringGiftTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        Map<String, Object> recurringGiftMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME, RECURRING_GIFT_TABLE_MAIN_SECTION_NAME, null, RECURRING_GIFT_TABLE_MAIN_SECTION_NAME);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)recurringGiftMetadata.get(SECTION_MAP_KEY);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)recurringGiftMetadata.get(PERMISSION_MAP_KEY);

       Integer maxNumberofQueryRecords = Integer.valueOf(mainSection?.get(MAIN_QUERY)?.get(0)?.Max_Number_of_Query_Records__c);
        maxNumberofQueryRecords = maxNumberofQueryRecords != null ? maxNumberofQueryRecords : Integer.valueOf((Decimal)paramMap.get(ITEMS_PER_PAGE));

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass paginationOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', '', '', '', maxNumberofQueryRecords, Integer.valueOf((Decimal)paramMap.get(OFFSET_CONST)), false);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass countQueryOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('SELECT Count()', null, '', '', null, null, true);

        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, mainSection);
        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, paginationOverride);
        List<sObject> recurringGifts = getRecurringGiftQuery(paramMap);

        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, countQueryOverride);
        returnMap.put(TOTAL_NUMBER_OF_RECORDS_KEY, getTotalNumberOfRecordsRecurringGift(paramMap));

        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        paramMap.put(UNFORMATTED_RECURRING_TABLE_DATA, recurringGifts);
        returnMap.put(RECORDS_TO_RETURN_KEY, formatRecurringGiftData(paramMap));

        return returnMap;
    }

    /**
     * Query table data for recurring gift table.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              Unformatted table data for the recurring gift table.
     */
    global virtual List<sObject> getRecurringGiftQuery(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '215.');
        return getTableQuery(paramMap);
    }

    /**
     * Count query for the recurring gift table. Used for pagination.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              Number of total records for the table.
     */
    global virtual Integer getTotalNumberOfRecordsRecurringGift(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '216.');
        return getTableCountQuery(paramMap);
    }

    /**
     * Format data for the recurring gift table. Calculates next expected payment date. Gets credit card last 4 digits if necessary 
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          List<sObject> recurringGifts: unformatted table data
     *                                                          Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection: query information data from portal page section
     *                                                          Boolean showUpdateCreditCard: indicates whether to make callouts for credit card last 4 digits or not
     *                                                          String paymentMethod: payment processor used (Stripe, Spreedly, Cybersource)
     * @return                                              Formatted table data.
     */
    global virtual List<Map<String, Object>> formatRecurringGiftData(Map<String, Object> paramMap) {

        if (paramMap.get(UNFORMATTED_RECURRING_TABLE_DATA) == null || paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY) == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 228.');
        }

        List<sObject> recurringGifts = (List<sObject>)paramMap.get(UNFORMATTED_RECURRING_TABLE_DATA);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY);
        List<Map<String, Object>> formattedWrapper = PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(recurringGifts, mainSection);

        Map<String, String> idToCreditCardDigitsMap = getCreditCardIdToLastFourDigitsMap(formattedWrapper, (Boolean) paramMap.get(SHOW_UPDATE_CREDIT_CARD_KEY), (String) paramMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));

        for (Map<String, Object> formattedRow : formattedWrapper) {
            formattedRow.put(NEXT_EXPECTED_PAYMENT_DATE_KEY, getNextExpectedDate(formattedRow)); // add next expected payment date field to the wrapper
            String creditCardLastFour = idToCreditCardDigitsMap.get(getCreditCardIdKey(formattedRow));
            formattedRow.put(UPDATE_CREDIT_CARD_KEY, creditCardLastFour != null ? 'Update Card Ending in ' + creditCardLastFour : 'Update'); // add credit card digits to wrapper
        }

        return formattedWrapper;
    }

    /**
     * Calulates the next expected payment date.
     *
     * @param   paramMap                                    Formatted table row using portal page section.
     * @return                                              Formatted table data.
     */
    global virtual Date getNextExpectedDate(Map<String, Object> paramMap) {
        // fields retrieved from portal page section using front end field id
        String frequency = (String)paramMap.get(RECURRING_GIFT_FREQUENCY_KEY); 
        Date startDate = (Date)paramMap.get(RECURRING_GIFT_START_DATE_KEY); 
        Date endDate = (Date)paramMap.get(RECURRING_GIFT_END_DATE_KEY); 
        Decimal totalPayment = (Decimal)paramMap.get(RECURRING_GIFT_AMOUNT_PAID_KEY); 
        Decimal recurringPayment = (Decimal)paramMap.get(RECURRING_GIFT_AMOUNT_KEY); 

        if (totalPayment == null) {
            totalPayment = 0;
        }

        if (String.isBlank(frequency) || startDate == null || recurringPayment == null || recurringPayment == 0 ) {
            return null;
        }

        Map<String, Object> frequencyConversion = PORTAL_MyGivingHistoryControllerBase.giftFrequencyConversion(new Map<String, Object>{FREQUENCY_KEY => frequency});

        Integer months = (Integer)frequencyConversion.get(FREQUENCY_CONVERSION_MONTHS_KEY);
        Integer days = (Integer)frequencyConversion.get(FREQUENCY_CONVERSION_DAYS_KEY);

        if (months == 0 && days == 0) {
            return null;
        }

        Integer paymentNumber = (Integer)Math.floor(totalPayment/recurringPayment);

        if (paymentNumber > 0) {

            if (months > 0) {
                months = months * paymentNumber;
            }

            if (days > 0) {
                days = days * paymentNumber;
            }

            startDate = startDate.addDays(days);
            startDate = startDate.addMonths(months);

            if (endDate != null && startDate > endDate) {
                startDate = endDate;
            }

        }

        return startDate;
    }

    /*
        Pledge and Recurring gift table 
    */

    /**
     * For each subscription-based gift, try to get the last 4 digits of the credit card used to pay for it
     * 
     * @author Jacob Huang
     * 
     * @param formattedWrapper          List<Map<String, Object>>: Opportunity record fields
     * @param showUpdateCreditCard      Boolean: indicates whether to make callouts for credit card last 4 digits or not
     * @param paymentMethod             String: payment processor used (Stripe, Spreedly, Cybersource)
     * 
     * @return          map of string ID to last 4 credit card digits 
     */
    global virtual Map<String, String> getCreditCardIdToLastFourDigitsMap(List<Map<String, Object>> formattedWrapper, Boolean showUpdateCreditCard, String paymentMethod) {
        if (showUpdateCreditCard == null || !showUpdateCreditCard || formattedWrapper == null) {
            return new Map<String, String>();
        }

        // Spreedly uses encrypted payment info
        // Stripe uses subscription ID
        // Cybersource uses subscription ID and external payment gateway ID aka merchant reference code
        List<String> creditCardIdList = new List<String>(); 
        List<String> externalPaymentGatewayIdList = new List<String>(); 
        for (Map<String, Object> eachFormattedRow : formattedWrapper) {
            creditCardIdList.add(getCreditCardIdKey(eachFormattedRow));
            externalPaymentGatewayIdList.add((String) eachFormattedRow.get(EXTERNAL_PAYMENT_GATEWAY_ID_KEY));
        }

        PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)(PORTAL_Utils.getControllerFactory().getPaymentHubController(paymentMethod));
        controller.setPaymentInterface(paymentMethod);
        return controller.getCreditCardIdToLastFourDigitsMap(new Map<String, Object>{PORTAL_CONST_OnlineGiving.CREDIT_CARD_ID_LIST_KEY => creditCardIdList, 
                                                                                     PORTAL_CONST_OnlineGiving.EXTERNAL_PAYMENT_GATEWAY_ID_LIST_KEY => externalPaymentGatewayIdList});
    }

    /**
     * Choose one of two Opportunity fields to use as a unique identifier for the 
     * credit card associated with a subscription-based gift
     * 
     * @author Jacob Huang
     * 
     * @param formattedRow      Map<String, Object>: Formatted table row using portal page section with the following keys:
     *      encryptedPaymentInfo, from Opportunity
     *      subscriptionId, from Opportunity 
     * 
     * @return if subscription ID exists use it, else use encrypted payment info 
     */
    global virtual String getCreditCardIdKey(Map<String, Object> formattedRow) {
        String encryptedPaymentInfo = (String) formattedRow.get(ENCRYPTED_PAYMENT_INFO_KEY);
        String subscriptionId = (String) formattedRow.get(SUBSCRIPTION_ID_KEY);
        return subscriptionId != null ? subscriptionId : encryptedPaymentInfo;
    }

    /**
     * For a gift with a subscription (pledge or recurring), update the 
     * credit card information
     *
     * @author Jacob Huang
     * 
     * @param paramMap  List of parameters passed in by the calling function.
     *      String: giftId                      ID of the Opportunity
     *      String: subscriptionId              external ID for the gift's associated subscription
     *      String: paymentId                   ID received from the payment processor representing the credit card
     *      String: paymentMethod               payment processor used (Stripe, Spreedly, Cybersource)
     *      String: externalPaymentGatewayId    Cybersource: merchant reference code of the initial subscription transaction
     * 
     * @return                                  String: last 4 digits of new credit card, null if failure 
     */
    global virtual String updateSubscriptionCreditCard(Map<String, Object> paramMap) {
        PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController((String)paramMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));
        controller.setPaymentInterface((String)paramMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));
        return controller.updateSubscriptionCreditCard(paramMap);
    }

    /**
     * Cancel a constituent's existing subscription-based gift (pledge or recurring gift)
     * 
     * @author Jacob Huang
     * 
     * @param paramMap  List of parameters passed in by the calling function.
     *      String: paymentMethod               Payment processor used
     *      String: giftId                      ID of Opportunity
     *      String: giftType                    'pledge' or 'recurring'
     *      String: subscriptionId              External ID for the gift's associated subscription
     *      String: externalPaymentGatewayId    Merchant reference code of initial subscription transaction
     *      String: externalSystemId            External system ID of Opportunity to cancel
     */
    global virtual void cancelSubscription(Map<String, Object> paramMap) {
        PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController((String)paramMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));
        controller.setPaymentInterface((String)paramMap.get(PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY));
        controller.cancelSubscription(paramMap);
    }

    /*
        Matching gift table
    */

    /**
     * Retrieve and format data for the matching gift table on the giving history page.
     *
     * @param   paramMap                                List of parameters passed in by the calling function.
     *                                                      Integer itemsPerPage: Number of items per page on the table
     *                                                      Integer offset: Offset for pagination query.
     * @return                                          Formatted records and its associated permission map.
     */
    global virtual Map<String, Object> getMatchingGiftTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        Map<String, Object> matchingGiftMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME, MATCHING_GIFT_TABLE_MAIN_SECTION_NAME, null, MATCHING_GIFT_TABLE_MAIN_SECTION_NAME);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)matchingGiftMetadata.get(SECTION_MAP_KEY);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)matchingGiftMetadata.get(PERMISSION_MAP_KEY);

        Integer maxNumberofQueryRecords = Integer.valueOf(mainSection?.get(MAIN_QUERY)?.get(0)?.Max_Number_of_Query_Records__c);
        maxNumberofQueryRecords = maxNumberofQueryRecords != null ? maxNumberofQueryRecords : Integer.valueOf((Decimal)paramMap.get(ITEMS_PER_PAGE));

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass countQueryOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('SELECT Count()', null, '', '', null, null, true);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass paginationOverride = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', '', '', '', maxNumberofQueryRecords, Integer.valueOf((Decimal)paramMap.get(OFFSET_CONST)), false);

        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, mainSection);
        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, paginationOverride);
        List<sObject> matchingGifts = getMatchingGiftTableQuery(paramMap);

        paramMap.put(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY, countQueryOverride);
        returnMap.put(TOTAL_NUMBER_OF_RECORDS_KEY, getTotalNumberOfRecordsMatchingGift(paramMap));

        returnMap.put(RECORDS_TO_RETURN_KEY, PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(matchingGifts, mainSection));
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);


        return returnMap;
    }

    /**
     * Query for unformatted matching gift table records.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              Unformatted matching gift table records.
     */
    global virtual List<sObject> getMatchingGiftTableQuery(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '217.');
        return getTableQuery(paramMap);
    }

    /**
     * Query for count of total number of records in matching gift table. Used for pagination.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              Number of total records.
     */
    global virtual Integer getTotalNumberOfRecordsMatchingGift(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '218.');
        return getTableCountQuery(paramMap);
    }


    /*
        Year end tax letter table
    */

    /**
     * Retrieve and format data for the year end tax letter table on the giving history page.
     *
     * @param   paramMap                                List of parameters passed in by the calling function.
     *                                                      String receiptBaseURL: receipt base URL for the gift receipt page.
     *                                                      String receiptContentPageName: Content page name for gift receipt page.
     * @return                                          Formatted records and its associated permission map.
     */
    global virtual Map<String, Object> getYearlyGivingTableData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        paramMap.put(PAGE_SECTION_PARENT_FIELD_ID, contactId);

        Map<String, Object> yearEndTaxLetterMetadata = getPortalPageSection(GIVING_HISTORY_PORTAL_SECTION_PAGE_NAME,
                                                                            YEAR_END_TAX_LETTER_TABLE_MAIN_SECTION_NAME,
                                                                            null,
                                                                            YEAR_END_TAX_LETTER_TABLE_MAIN_SECTION_NAME);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = (Map<String, List<Portal_Page_Section_Setting__mdt>>)yearEndTaxLetterMetadata.get(SECTION_MAP_KEY);
        Map<String, Map<String, Object>> permissionMap = (Map<String, Map<String, Object>>)yearEndTaxLetterMetadata.get(PERMISSION_MAP_KEY);

        paramMap.put(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY, mainSection);
        List<sObject> payments = getYearEndTaxLetterTableData(paramMap);

        paramMap.put(UNFORMATTED_YEAR_END_TABLE_DATA, payments);
        List<Map<String, Object>> formattedPayments = formatYearEndTaxLetterTableData(paramMap);

        returnMap.put(RECORDS_TO_RETURN_KEY, formattedPayments);
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        return returnMap;
    }

    /**
     * Query for unformatted matching gift table records.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     * @return                                              Unformatted matching gift table records.
     */
    global virtual List<sObject> getYearEndTaxLetterTableData(Map<String, Object> paramMap) {
        paramMap.put(ERROR_MESSAGE_KEY, ERROR_MESSAGE_WITH_ERROR_CODE + '219.');
        return getTableQuery(paramMap);
    }

    /**
     * Format data for the year end tax letter table. Creates receipt URL.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          List<sObject> recurringGifts: unformatted table data
     *                                                          Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection: query information data from portal page section
     * @return                                              Formatted table data.
     */
    global virtual List<Map<String, Object>> formatYearEndTaxLetterTableData(Map<String, Object> paramMap) {

        if(paramMap.get(UNFORMATTED_YEAR_END_TABLE_DATA) == null || paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY) == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 229.');
        }

        List<Map<String, Object>> formattedPayments = new List<Map<String, Object>>();
        List<sObject> payments = (List<sObject>)paramMap.get(UNFORMATTED_YEAR_END_TABLE_DATA);
        Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap = (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY);

        String receiptBaseURL = (String)paramMap.get(RECEIPT_BASE_URL);
        String receiptContentPageName = (String)paramMap.get(RECEIPT_CONTENT_PAGE_NAME);
        Integer cutoffYear = getOfficialTaxLetterCutoffDate().year();

        if (String.isNotBlank(receiptBaseURL)) {
            receiptBaseURL = receiptBaseURL.removeStart('/');
            receiptBaseURL = receiptBaseURL.removeEnd('?');
        }

        for (sObject paymentRow : payments) {
            Map<String, Object> formattedPaymentRow = new Map<String, Object>();
            Decimal year = (Decimal)paymentRow.get(AGGREGATE_YEAR_FIELD_NAME);
            String receiptURL = '/' + receiptBaseURL + '?';

            if (year > cutoffYear || receiptBaseURL == null || receiptContentPageName == null) {
                formattedPaymentRow.put(RECEIPT_FULL_URL, null);
            } else {
                receiptURL += PORTAL_VF_YearEndTaxReceipt.CALENDAR_YEAR_URL_PARAM + '=' + year;
                receiptURL += '&' + PORTAL_VF_YearEndTaxReceipt.CONTACT_ID_URL_PARAM + '=' + contactId;
                receiptURL += '&' + PORTAL_VF_YearEndTaxReceipt.CONTENT_PAGE_NAME_URL_PARAM + '=' + receiptContentPageName;
                formattedPaymentRow.put(RECEIPT_FULL_URL, receiptURL);
            }

            formattedPaymentRow.put(AGGREGATE_YEAR_FIELD_NAME, year);
            formattedPaymentRow.put(AGGREGATE_AMOUNT_FIELD_NAME, paymentRow.get(AGGREGATE_AMOUNT_FIELD_NAME));
            formattedPayments.add(formattedPaymentRow);
        }

        return formattedPayments;
    }

    /**
     * Get the year end tax letter cutoff date for the current year.
     *
     * @return                                              tax letter cut off date
     */
    global virtual Date getOfficialTaxLetterCutoffDate(){
        List<Portal_Organization_Setting__mdt> officialCutOffDateString = [SELECT Value__c FROM Portal_Organization_Setting__mdt WHERE DeveloperName = 'Official_Tax_Letter_Cut_Off_Date' AND Value__c != null];

        if (officialCutOffDateString.isEmpty()) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 221.');
        }

        List<String> cutOffDateParts = officialCutOffDateString.get(0).Value__c.split('-');

        if (cutOffDateParts.size() != 2) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 222.');
        }

        Integer months = Integer.valueOf(cutOffDateParts[0]);
        Integer Days =  Integer.valueOf(cutOffDateParts[1]);

        if (months < 0 || months > 13 || days < 0 || days > 31) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + ' 223.');
        }

        Date cutOffDate = Date.newInstance(DateTime.now().year(), months, Days);

        if (Date.today() < cutOffDate) {
            cutOffDate = cutOffDate.addYears(-1);
        }

        return cutOffDate;
    }


    /*
        Helper functions
    */

    /**
     * Generate fiscal year infomormation based on custom metedata and fiscal year settings.
     * Returns the lower bound, upper bound, and prior years to include when looking as giving history data.
     *
     * @return                                              Returns map of fiscal year information.
     */
    global virtual Map<String, Object> getFiscalYearInfo() {
        Map<String, Object> fiscalYearBoundsMap = new Map<String, Object>();
        Integer yearsBackToInclude = 0;
        Integer currentFiscalYear = 0;

        List<Portal_Organization_Setting__mdt> portalOrganizationSettings = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Giving_history_prior_years_to_include'}
        });

        if (portalOrganizationSettings.isEmpty()) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '209.');
        }

        try {
            yearsBackToInclude = Integer.valueOf(portalOrganizationSettings[0].Value__c);
            currentFiscalYear = Integer.valueOf([SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name);
        }
        catch (Exception e) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '210.');
        }

        if (yearsBackToInclude <= 0) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '211.');
        }

        fiscalYearBoundsMap.put(FISCAL_YEAR_UPPER_BOUND_KEY, currentFiscalYear);
        fiscalYearBoundsMap.put(FISCAL_YEAR_LOWER_BOUND_KEY, currentFiscalYear - yearsBackToInclude);
        fiscalYearBoundsMap.put(FISCAL_YEAR_PRIOR_YEARS_TO_INCLUDE, yearsBackToInclude);

        return fiscalYearBoundsMap;
    }

    /**
     * Generate fiscal year infomormation based on custom metedata and fiscal year settings.
     * Returns the lower bound, upper bound, and prior years to include when looking as giving history data.
     *
     * @param   paramMap                                    List of parameters passed in by the calling function.
     *                                                          String frequency: Expected frequency of payment
     * @return                                              Returns map of fiscal year information.
     */
    global static Map<String, Object> giftFrequencyConversion(Map<String, Object> paramMap) {
        Integer months = 0;
        Integer days = 0;

        String frequency = (String)paramMap.get(FREQUENCY_KEY);

        if (frequency == 'Annual') {
            months = 12;
        }
        else if (frequency == 'Semi-Annual') {
            months = 6;
        }
        else if (frequency == 'Quarterly') {
            months = 3;
        }
        else if (frequency == 'Monthly') {
            months = 1;
        }
        else if (frequency == 'Bi-Weekly') {
            days = 14;
        }
        else if (frequency == 'Weekly') {
            days = 7;
        }

        return new Map<String, Object>{FREQUENCY_CONVERSION_MONTHS_KEY => months, FREQUENCY_CONVERSION_DAYS_KEY => days};
    }

    /**
     * Generate portal page section query string from a map
     *
     * @param                                               List of parameters passed in by the calling function.
     *                                                          Id parentFieldId: hide/show empty rows of giving.
     *                                                          Map<String, List<Portal_Page_Section_Setting__mdt>> objectToFieldMap: portal sections for query builder
     *                                                          Boolean queryForAllRecords: If all records should retrieved regardless of parent id.
     *                                                          PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryClass: Query override class.
     * @return                                              query string
     */
    private string generateQueryString(Map<String, Object> paramMap) {
        return PORTAL_UTIL_PageSectionSetting.generateQueryString((Id)paramMap.get(PAGE_SECTION_PARENT_FIELD_ID),
                                                                 (Map<String, List<Portal_Page_Section_Setting__mdt>>)paramMap.get(PAGE_SECTION_OBJECT_TO_FIELD_MAP_KEY),
                                                                 (Boolean)paramMap.get(RECORDS_TO_RETURN_KEY),
                                                                 (PORTAL_UTIL_PageSectionSetting.DynamicQueryClass) paramMap.get(PAGE_SECTION_DYNAMIC_QUERY_CLASS_KEY));
    }

    /**
     * Get permission map and section map for portal page section.
     *
     * @param   pageName                                  Name of the portal page section.
     * @param   mainSectionName                           Name of the main section page name.
     * @param   subSectionName                            Name of the sub section name for the portal page section.
     * @param   sectionToGetName                          Section name to grab query information from.
     * @return                                            Portal page section information related to sectionToGetName.
     */
    private Map<String, Object> getPortalPageSection(String pageName, String mainSectionName, String subSectionName, String sectionToGetName) {
        Map<String, Object> returnMap = new Map<String, Object>();

        List<Portal_Page_Section_Setting__mdt> sectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName,
                                                                                                                         mainSectionName,
                                                                                                                         subSectionName);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> sections = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionList);
        Map<String, List<Portal_Page_Section_Setting__mdt>> sectionToReturn = sections.get(sectionToGetName);

        if (sectionToReturn == null) {
            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '212.');
        }

        Map<String, Map<String, Object>> permissionMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionList);

        returnMap.put(SECTION_MAP_KEY, sectionToReturn);
        returnMap.put(PERMISSION_MAP_KEY, permissionMap);

        return returnMap;
    }

    /**
     * Query table data from information supplied in paramMap. Throws error if query could not sucessfully be made.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     * @return                                          List of sObjects returned from the query.
     */
    private List<sObject> getTableQuery(Map<String, Object> paramMap) {
        List<sObject> sObjectList;
        String errorMessage = (String)paramMap.get(ERROR_MESSAGE_KEY);

        try {
            sObjectList = Database.query(generateQueryString(paramMap));
        } catch(QueryException e) {

            if (String.isBlank(errorMessage)) {
                errorMessage = e.getMessage();
            }

            throw new GivingHistoryException(errorMessage);
        }

        return sObjectList;
    }

    /**
     * Query number of records in the table data from information supplied in paramMap. Throws error if query could not sucessfully be made.
     *
     * @param    paramMap                               List of parameters passed in by the calling function.
     * @return                                          Number of records in the query.
     */
    private Integer getTableCountQuery(Map<String, Object> paramMap) {
        Integer count = 0;
        String errorMessage = (String)paramMap.get(ERROR_MESSAGE_KEY);

        try {
            count = Database.countQuery(generateQueryString(paramMap));
        } catch(QueryException e) {

            if (String.isBlank(errorMessage)) {
                errorMessage = e.getMessage();
            }

            throw new GivingHistoryException(ERROR_MESSAGE_WITH_ERROR_CODE + '218.');
        }

        return count;
    }
}