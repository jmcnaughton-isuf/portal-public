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
 * Gift Receipt visualforce page controller
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
public without sharing class PORTAL_VF_GiftReceiptController {

    public class GiftReceiptException extends Exception {}

    // front end information maps
    public Map<String, Object> paymentInfo {get; set;}
    public Map<String, Object> paymentPermissionInfo {get; set;}
    public Map<String, Object> staticContentInfo {get; set;}
    public List<Map<String, Object>> securitiesWrapper {get; set;}
    public ConstituentWrapper constituentWrapper {get; set;}
    public Boolean isSecurities {get; set;} {isSecurities = false;}
    public String bannerResourceName {get; set;}

    private Id contactId;

    // content modules fields
    private final static String CONTENT_MODULE_NAME = 'Receipt Info';
    public final static String CONTENT_MODULE_TITLE_HTML_KEY {get; set;} {CONTENT_MODULE_TITLE_HTML_KEY = 'titleHTML';}
    public final static String CONTENT_MODULE_BANNER_IMAGE_KEY {get; set;} {CONTENT_MODULE_BANNER_IMAGE_KEY = 'banerImageName';}
    public final static String CONTENT_MODULE_BANNER_IMAGE_ALT_TEXT_KEY {get; set;} {CONTENT_MODULE_BANNER_IMAGE_ALT_TEXT_KEY = 'banerImageAltText';}
    public final static String CONTENT_MODULE_POST_BANNER_HTML_KEY {get; set;} {CONTENT_MODULE_POST_BANNER_HTML_KEY = 'postBannerHTML';}
    public final static String CONTENT_MODULE_FOTTER_TEXT_KEY {get; set;} {CONTENT_MODULE_FOTTER_TEXT_KEY = 'footerText';}
    public final static String CONTENT_MODULE_SECURITIES_TOP_HTML {get; set;} {CONTENT_MODULE_SECURITIES_TOP_HTML = 'securitiesTopHTML';}

    // page section payment fields
    public final static String PAGE_SECTION_CREDIT_DATE_KEY {get; set;} {PAGE_SECTION_CREDIT_DATE_KEY = 'creditDate';}
    public final static String PAGE_SECTION_PAYMENT_AMOUNT_KEY {get; set;} {PAGE_SECTION_PAYMENT_AMOUNT_KEY = 'paymentAmount';}
    public final static String PAGE_SECTION_DESIGNATION_KEY {get; set;} { PAGE_SECTION_DESIGNATION_KEY = 'designationName';}
    public final static String PAGE_SECTION_RECEIPT_NUMBER_KEY {get; set;} {PAGE_SECTION_RECEIPT_NUMBER_KEY = 'receiptNumber';}

    // page section fields
    private final static String PAGE_SECTION_MAIN_SECTION_NAME = 'Giving History Gift Receipt';
    private final static String PAGE_SECTION_PAGE_NAME = 'Gift Receipt';
    private final static String PAGE_SECTION_CONTACT_SUB_SECTION = 'Contact Info';
    private final static String PAGE_SECTION_SECURITIES_SUB_SECTION = 'Securities';

    // page section securities field
    public final static  String PAGE_SECTION_STOCK_TICKER_SYMBOL {get; set;} { PAGE_SECTION_STOCK_TICKER_SYMBOL = 'tickerSymbol';}
    public final static String PAGE_SECTION_LOW_SHARE_PRICE_KEY {get; set;} {PAGE_SECTION_LOW_SHARE_PRICE_KEY = 'lowStockValue';}
    public final static String PAGE_SECTION_HIGH_SHARE_PRICE_KEY {get; set;} {PAGE_SECTION_HIGH_SHARE_PRICE_KEY = 'highStockValue';}
    public final static String PAGE_SECTION_MEAN_SHARE_PRICE_KEY {get; set;} {PAGE_SECTION_MEAN_SHARE_PRICE_KEY = 'meanStockValue';}
    public final static String PAGE_SECTION_NUMBER_OF_SHARES_KEY {get; set;} {PAGE_SECTION_NUMBER_OF_SHARES_KEY = 'numberOfShares';}
    public final static String PAGE_SECTION_STOCK_AMOUNT_KEY {get; set;} {PAGE_SECTION_STOCK_AMOUNT_KEY = 'stockAmount';}

    // Visualforce page URL params
    public final static String RECORD_ID = 'pid';
    public final static String CONTENT_PAGE_NAME = 'pageName';

    // class keys
    private final static String WRAPPER_KEY = 'wrapper';
    private final static String PERMISSION_MAP_KEY = 'permissionMap';
    private final static String UNFORMATTED_RECORDS_KEY = 'unformattedRecords';
    private final static String SECURITIES_INFO_KEY = 'securitiesInfo';
    private final static String CONSTITUENT_ADDRESS_INFO_KEY = 'constituentAddressInfo';

    /**
     *  Queries for hard and soft credit, contact information, and secrities if needed.
     *
     */
    public PORTAL_VF_GiftReceiptController() {

        Id hardAndSoftCreditId;
        Id paymentId;
        String contentPageName;

        if (Apexpages.currentPage().getParameters().containsKey(RECORD_ID)
            && Apexpages.currentPage().getParameters().containsKey(CONTENT_PAGE_NAME)) {
                contentPageName = Apexpages.currentPage().getParameters().get(CONTENT_PAGE_NAME).trim();
                hardAndSoftCreditId = Apexpages.currentPage().getParameters().get(RECORD_ID).trim();
        } else {
            throw new GiftReceiptException('Required data is missing. Error Code: 301.');
        }

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass additonalFields = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('ucinn_ascendv2__Opportunity__c, ucinn_ascendv2__Contact__c, ucinn_ascendv2__Payment__r.ucinn_ascendv2__Tender_Type_Formula__c', '', '', '', null, null, false);

        // query payment infomation for receipt
        Map<String, Object> hardAndSoftCreditInformation = generateQueryAndWrapper(PAGE_SECTION_PAGE_NAME, PAGE_SECTION_MAIN_SECTION_NAME, null, PAGE_SECTION_MAIN_SECTION_NAME, hardAndSoftCreditId, false, additonalFields, true, true);
        List<Map<String, Object>> paymentRecords = (List<Map<String, Object>>)hardAndSoftCreditInformation.get(WRAPPER_KEY);

        if (paymentRecords.isEmpty()) {
            throw new GiftReceiptException('Required data is missing. Error Code: 310.');
        }

        paymentInfo = paymentRecords[0];
        paymentPermissionInfo = (Map<String, Object>)hardAndSoftCreditInformation.get(PERMISSION_MAP_KEY);
        List<ucinn_ascendv2__Hard_and_Soft_Credit__c> giftInfo = new List<ucinn_ascendv2__Hard_and_Soft_Credit__c>();

        try {
            giftInfo =  (List<ucinn_ascendv2__Hard_and_Soft_Credit__c>)hardAndSoftCreditInformation.get(UNFORMATTED_RECORDS_KEY);
        }
        catch (TypeException e) {
            throw new GiftReceiptException('There was an error with the data. Error Code: 311.');
        }


        if (giftInfo.isEmpty()) {
            throw new GiftReceiptException('Data not found. Error Code: 303.');
        }

        contactId = giftInfo[0].ucinn_ascendv2__Contact__c;
        paymentId = giftInfo[0].ucinn_ascendv2__Opportunity__c;

        if (giftInfo[0].ucinn_ascendv2__Payment__r.ucinn_ascendv2__Tender_Type_Formula__c == 'Stock Gift') {
            isSecurities = true;
        }

        Boolean hasAccess = PORTAL_CommunityUtils.userIsLoggedInConstituent(contactId);

        if (!hasAccess || contactId == null) {
            throw new GiftReceiptException('You do not have access to this constituent. Error Code: 305.');
        }

        // get content page/content module information
        PORTAL_StaticContentControllerBase staticContentController = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();
        staticContentInfo =  staticContentController.getContentModuleMetadata(new Map<String, Object> {
            PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => contentPageName,
            PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => CONTENT_MODULE_NAME,
            PORTAL_StaticContentControllerBase.PARAM_ZONE_NAME => null
        });
        bannerResourceName = (String)staticContentInfo.get(CONTENT_MODULE_BANNER_IMAGE_KEY);

        // query contact and address info
        Map<String, Object> contactAndAddressInfo = generateQueryAndWrapper(PAGE_SECTION_PAGE_NAME, PAGE_SECTION_MAIN_SECTION_NAME, PAGE_SECTION_CONTACT_SUB_SECTION, PAGE_SECTION_CONTACT_SUB_SECTION, contactId, false, null, true, false);
        List<sObject> addressRelations = (List<sObject>)contactAndAddressInfo.get(UNFORMATTED_RECORDS_KEY);
        List<Map<String, Object>> addressRelationWrapper = (List<Map<String, Object>>)contactAndAddressInfo.get(WRAPPER_KEY);

        constituentWrapper = new ConstituentWrapper(new Map<String, Object>{CONSTITUENT_ADDRESS_INFO_KEY => addressRelationWrapper});

        // if secutities query secuties info
        if (isSecurities) {
            List<Portal_Page_Section_Setting__mdt> sectionSettingsSecurities = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(PAGE_SECTION_PAGE_NAME, PAGE_SECTION_MAIN_SECTION_NAME, PAGE_SECTION_SECURITIES_SUB_SECTION);
            Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> sectionMapSecurities =  PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettingsSecurities);
            Map<String, Map<String, List<Map<String, Object>>>> mapSectionSubSectionSecuritiesWrapper = PORTAL_UTIL_PageSectionSetting.queryForRecords(paymentId, sectionMapSecurities, null, false, true);
            securitiesWrapper = formatSecurities(new Map<String, Object>{SECURITIES_INFO_KEY => mapSectionSubSectionSecuritiesWrapper.get(PAGE_SECTION_MAIN_SECTION_NAME).get(PAGE_SECTION_SECURITIES_SUB_SECTION)});
        }

    }

    /**
     * Add the mean stock price to securities if it does not exist.
     *
     * @param                                                               List of parameters passed in by the calling function.
     *                                                                          List<Map<String, Object> SECURITIES_INFO_KEY: List of formatted securites records.
     * @return                                                              List of formatted securities records with added information.
     */
    public virtual List<Map<String, Object>> formatSecurities(Map<String, Object> paramMap) {

        List<Map<String, Object>> securitiesInfo = (List<Map<String, Object>>)paramMap.get(SECURITIES_INFO_KEY);

        if (securitiesInfo == null) {
            throw new GiftReceiptException('Error with gift info query. Error Code: 309.');
        }

        for(Map<String, Object> securitiesRow : securitiesInfo) {
            if (!securitiesRow.containsKey(PAGE_SECTION_MEAN_SHARE_PRICE_KEY) && securitiesRow.containsKey(PAGE_SECTION_LOW_SHARE_PRICE_KEY) && securitiesRow.containsKey(PAGE_SECTION_HIGH_SHARE_PRICE_KEY)) {
                Decimal stockLowPrice = (Decimal)securitiesRow.get(PAGE_SECTION_LOW_SHARE_PRICE_KEY);
                Decimal stockHighPrice = (Decimal)securitiesRow.get(PAGE_SECTION_HIGH_SHARE_PRICE_KEY);
                securitiesRow.put(PAGE_SECTION_MEAN_SHARE_PRICE_KEY, ((stockHighPrice + stockLowPrice) / 2).setScale(2));
            }
        }

        return securitiesInfo;
    }

    /**
     * Constituent Wrapper for the gift receipt page. Holds constituents name and address information for display.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    public virtual class ConstituentWrapper {
        public String name {get; set;}
        public String addressHTML {get; set;}
        public String city {get; set;}
        public String state {get; set;}
        public String postalCode {get; set;}

        /**
         * Put constituent infomration into class variables for dispaly.
         *
         * @param   paramMap                                                    List of parameters passed in by the calling function.
         *                                                                          List<Map<String, Object> SECURITIES_INFO_KEY: List of formatted securites records.
         * @return                                                              List of formatted securities records with added information.
         */
        public ConstituentWrapper (Map<String, Object> paramMap) {
            List<Map<String, Object>> addressRelationWrapper = (List<Map<String, Object>>)paramMap.get(CONSTITUENT_ADDRESS_INFO_KEY);
            if (addressRelationWrapper == null || addressRelationWrapper.isEmpty()) {
                return;
            }

            Map<String, Object> addressInfo = addressRelationWrapper[0];

            name = (String)getField(addressInfo, 'contactName', '');
            addressHTML = createAddress(addressHTML, (String)getField(addressInfo, 'addressLine1', ''));
            addressHTML = createAddress(addressHTML, (String)getField(addressInfo, 'addressLine2', ''));
            addressHTML = createAddress(addressHTML, (String)getField(addressInfo, 'addressLine3', ''));
            addressHTML = createAddress(addressHTML, (String)getField(addressInfo, 'addressLine4', ''));
            city = (String)getField(addressInfo, 'addressCity', '');
            state = (String)getField(addressInfo, 'addressState', '');
            postalCode = (String)getField(addressInfo, 'addressPostalCode', '');
        }

        /**
         * Create address html string
         *
         * @param   fullAddress                                                 The Entire address string to be being created.
         * @param   addressLine                                                 The current address line being added to fullAddress.
         * @return                                                              Entire address made up of the two addresses passed in.
         */
        private String createAddress(String fullAddress, String addressLine) {

            if (String.isNotBlank(addressLine)) {
                if (String.isBlank(fullAddress)) {
                    fullAddress = addressLine;
                } else {
                    fullAddress += '<br/>' + addressLine;
                }
            }

            return fullAddress;
        }


        /**
         * Get field from the passed in object. If the field is empty return the empty value provided.
         *
         * @param   contactFields                                               Map containting fields related to the contact
         * @param   key                                                         A possible key for the contact map provided
         * @param   emptyValue                                                  If the key is missing from the map the empty value will be returned.
         * @return                                                              If the key exists in the map its associated value is returned, else the empty value is returned.
         */
        private Object getField(Map<String, Object> contactFields, String key, String emptyValue) {
            Object fieldValue = contactFields.get(key);
            if (fieldValue == null) {
                return emptyValue;
            } else {
                return fieldValue;
            }
        }

    }

    /**
     * Generate query and possibly the wrapper and permission map for a given portal page section.
     *
     * @param   pageName                                                        Name of Portal Page Section Page.
     * @param   mainSectionName                                                 Name of Portal Page Section Main Section Name.
     * @param   subSectionName                                                  Name of Portal Page Section Sub Section Name.
     * @param   sectionToGet                                                    Either the main section name or sub section name.
     * @param   parentObjectId                                                  Id for the controlling parent object.
     * @param   queryAllFields                                                  If all records should be queried or not.
     * @param   dynamicQueryClass                                               Dynamic query override class for the query.
     * @param   generateWrapper                                                 Determines if a wrapper will be generated.
     * @param   generatePermissionMap                                           Determines if a permission map will be generated.
     * @return                                                                  Returns map of unformatted records, permission map, and wrapper.
     */
    private Map<String, Object> generateQueryAndWrapper(String pageName, String mainSectionName, String subSectionName, String sectionToGet, Id parentObjectId, Boolean queryAllFields,
                                                            PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryClass, Boolean generateWrapper, Boolean generatePermissionMap) {
        Map<String, Object> returnMap = new Map<String, Object> ();
        List<Portal_Page_Section_Setting__mdt> sectionSettings = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);
        System.debug(sectionSettings);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> sectionMap =  PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettings);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = sectionMap.get(sectionToGet);

        if (mainSection == null) {
            throw new GiftReceiptException('Error querying the needed information. Error Code: 302.');
        }

        String queryString = PORTAL_UTIL_PageSectionSetting.generateQueryString(parentObjectId, mainSection, queryAllFields, dynamicQueryClass);
        List<sObject> objectList;

        try {
            objectList = Database.query(queryString);
        }
        catch (QueryException e) {
            throw new GiftReceiptException('Error with gift info query. Error Code: 308.');
        }

        returnMap.put(UNFORMATTED_RECORDS_KEY, objectList);

        if (generateWrapper) {
            returnMap.put(WRAPPER_KEY, PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(objectList, mainSection));
        }

        if (generatePermissionMap) {
            returnMap.put(PERMISSION_MAP_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionSettings));
        }

        return returnMap;

    }
}