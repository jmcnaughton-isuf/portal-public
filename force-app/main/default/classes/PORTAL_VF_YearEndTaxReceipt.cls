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
 * Year end tax letter visualforce page controller
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
public virtual without sharing class PORTAL_VF_YearEndTaxReceipt {

    public class YearEndTaxReceiptException extends Exception {}

    // page section fields
    private final static String PAGE_SECTION_PAGE_NAME = 'Year end tax letter';
    private final static String PAGE_SECTION_MAIN_SECTION_NAME = 'Year End Tax Letter';
    private final static String PAGE_SECTION_CONTACT_SUB_SECTION = 'Contact Info';
    public final static String CREDIT_DATE_FIELD_ID {get; set;} {CREDIT_DATE_FIELD_ID = 'creditDate';}
    public final static String DESIGNATION_FIELD_ID {get; set;} {DESIGNATION_FIELD_ID = 'designation';}
    public final static String PAYMENT_AMOUNT_FIELD_ID {get; set;} {PAYMENT_AMOUNT_FIELD_ID = 'paymentAmount';}

    // content modules fields
    private final static String CONTENT_MODULE_NAME = 'Receipt Info';
    public final static String CONTENT_MODULE_TOP_LOGO_KEY {get; set;} {CONTENT_MODULE_TOP_LOGO_KEY = 'imageName';}
    public final static String CONTENT_MODULE_TOP_LOGO_ALT_TEXT_KEY {get; set;}{CONTENT_MODULE_TOP_LOGO_ALT_TEXT_KEY = 'imageAltText';}
    public final static String CONTENT_MODULE_SCHOOL_ADDRESS_KEY {get; set;} {CONTENT_MODULE_SCHOOL_ADDRESS_KEY = 'addressInfo';}
    public final static String CONTENT_MODULE_PRE_TABLE_TEXT_KEY {get; set;} {CONTENT_MODULE_PRE_TABLE_TEXT_KEY = 'preTableText';}
    public final static String CONTENT_MODULE_POST_TABLE_TEXT_KEY {get; set;} {CONTENT_MODULE_POST_TABLE_TEXT_KEY = 'postTableText';}

    // merge fields
    private final static String MERGE_CONSTITUENT_NAME = '-!name-';
    private final static String MERGE_CONSTITUENT_FIRST_NAME = '-!firstName-';
    private final static String MERGE_CONSTITUENT_LAST_NAME = '-!lastName-';
    private final static String MERGE_CONSTITUENT_SALUTATION = '-!salutation-';
    private final static String MERGE_YEAR = '-!year-';

    // visualforce page fields
    public String topLogoImageName {get; set;}
    public ConstituentWrapper constituentWrapper {get; set;}
    public List<Map<String, Object>> tableData {get; set;}
    public Map<String, Map<String, Object>> frontEndDataMap {get; set;}
    public Map<String, Object> staticContentInfo {get; set;}
    public Decimal totalAmountDecimal {get; set;}

    // constituent wrapper contact fields
    public static final String CONTACT_FIRST_NAME = 'contactFirstName';
    public static final String CONTACT_LAST_NAME = 'contactLastName';
    public static final String CONTACT_NAME = 'contactName';
    public static final String CONTACT_SALUTATION = 'contactSalutation';
    public static final String ADDRESS_CITY = 'addressCity';
    public static final String ADDRESS_STATE = 'addressState';
    public static final String ADDRESS_POSTAL_CODE = 'addressPostalCode';
    public static final String ADDRESS_LINE_1 = 'addressLine1';
    public static final String ADDRESS_LINE_2 = 'addressLine2';
    public static final String ADDRESS_LINE_3 = 'addressLine3';
    public static final String ADDRESS_LINE_4 = 'addressLine4';

    // class keys
    private final static String CONTACT_INFO_KEY = 'contactInfo';

    // URL params
    public static final String CALENDAR_YEAR_URL_PARAM = 'year';
    public static final String CONTENT_PAGE_NAME_URL_PARAM = 'pageName';
    public static final String CONTACT_ID_URL_PARAM = 'contactId';

    /**
     * Query and format all giving in the given year and cosntituent information
     *
     */
    public PORTAL_VF_YearEndTaxReceipt() {
        // URL params
        Id contactId;
        String contentPageName;
        Integer year;

        if (Apexpages.currentPage().getParameters().containsKey(CALENDAR_YEAR_URL_PARAM) && Apexpages.currentPage().getParameters().containsKey(CONTACT_ID_URL_PARAM)
            && Apexpages.currentPage().getParameters().containsKey(CONTENT_PAGE_NAME_URL_PARAM)) {
                contactId = Apexpages.currentPage().getParameters().get(CONTACT_ID_URL_PARAM).trim();
                contentPageName = Apexpages.currentPage().getParameters().get(CONTENT_PAGE_NAME_URL_PARAM).trim();
                year = Integer.valueOf(Apexpages.currentPage().getParameters().get(CALENDAR_YEAR_URL_PARAM).trim());
        } else {
            throw new YearEndTaxReceiptException('Required data is missing.');
        }

        PORTAL_MyGivingHistoryControllerBase givingHistoryBaseController = (PORTAL_MyGivingHistoryControllerBase)PORTAL_Utils.getControllerFactory().getGivingHistoryBaseController();
        Integer cutoffYear = givingHistoryBaseController.getOfficialTaxLetterCutoffDate().year();

        if (year > cutoffYear) {
            throw new YearEndTaxReceiptException('Invalid year.');
        }

        Boolean hasAccess = PORTAL_CommunityUtils.userIsLoggedInConstituent(contactId);

        if (!hasAccess || contactId == null) {
            throw new YearEndTaxReceiptException('You do not have access to this constituent.');
        }

        // query table data
        List<Portal_Page_Section_Setting__mdt> sectionSettings = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(PAGE_SECTION_PAGE_NAME, PAGE_SECTION_MAIN_SECTION_NAME, null);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> sectionMap =  PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(sectionSettings);
        Map<String, List<Portal_Page_Section_Setting__mdt>> mainSection = sectionMap.get(PAGE_SECTION_MAIN_SECTION_NAME);
        String queryString = PORTAL_UTIL_PageSectionSetting.generateQueryString(contactId, mainSection, false, null);
        List<ucinn_ascendv2__Payment__c> payments = new List<ucinn_ascendv2__Payment__c>();

        try {
            payments = Database.query(queryString);
        }
        catch (QueryException e) {
            throw new YearEndTaxReceiptException('Invalid Query.');
        }

        tableData = PORTAL_UTIL_PageSectionSetting.convertRecordsToWrapper(payments, mainSection);
        frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionSettings);

        this.formatTableData(new Map<String, Object>{});

        // query contact data
        List<Portal_Page_Section_Setting__mdt> contactSectionSettings = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(PAGE_SECTION_PAGE_NAME, PAGE_SECTION_MAIN_SECTION_NAME,
                                                                                                                                    PAGE_SECTION_CONTACT_SUB_SECTION);
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> contactSectionMap =  PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(contactSectionSettings);
        Map<String, Map<String, List<Map<String, Object>>>> mainSectionToSubSectionContactInfo = PORTAL_UTIL_PageSectionSetting.queryForRecords(contactId, contactSectionMap, null, false, true);

        List<Map<String, Object>> contactInfo = new List<Map<String, Object>>();

        if (mainSectionToSubSectionContactInfo != null && String.isNotBlank(PAGE_SECTION_MAIN_SECTION_NAME)) {
            Map<String, List<Map<String, Object>>> subSectionContactInfo = mainSectionToSubSectionContactInfo.get(PAGE_SECTION_MAIN_SECTION_NAME);

            if (subSectionContactInfo != null && String.isNotBlank(PAGE_SECTION_CONTACT_SUB_SECTION)) {
                contactInfo = subSectionContactInfo.get(PAGE_SECTION_CONTACT_SUB_SECTION);
            }

            if (contactInfo == null || contactInfo.isEmpty()) {
                contactInfo = this.getFormattedContactInfoList(contactId);
            }
        }

        constituentWrapper = new ConstituentWrapper(new Map<String, Object>{CONTACT_INFO_KEY => contactInfo});

        // Grab static content from content modules
        Map<String, String> mergeFieldsAndValues = new Map<String, String>{MERGE_CONSTITUENT_NAME => constituentWrapper.name, MERGE_CONSTITUENT_FIRST_NAME => constituentWrapper.firstName,
                                                                            MERGE_CONSTITUENT_LAST_NAME => ConstituentWrapper.lastName, MERGE_CONSTITUENT_SALUTATION => ConstituentWrapper.salutation,
                                                                            MERGE_YEAR => String.valueOf(year)};

        PORTAL_StaticContentControllerBase staticContentController = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();
        staticContentInfo =  staticContentController.getContentModuleMetadata(new Map<String, Object> {
            PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => contentPageName,
            PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => CONTENT_MODULE_NAME,
            PORTAL_StaticContentControllerBase.PARAM_ZONE_NAME => null
        });

        staticContentInfo.put(CONTENT_MODULE_PRE_TABLE_TEXT_KEY, replaceMergeFields((String)staticContentInfo.get(CONTENT_MODULE_PRE_TABLE_TEXT_KEY), mergeFieldsAndValues, ''));
        staticContentInfo.put(CONTENT_MODULE_POST_TABLE_TEXT_KEY, replaceMergeFields((String)staticContentInfo.get(CONTENT_MODULE_POST_TABLE_TEXT_KEY), mergeFieldsAndValues, ''));

        topLogoImageName = (String)staticContentInfo.get(CONTENT_MODULE_TOP_LOGO_KEY);
    }

    /**
     * Retrieve and format contact information to display on receipt
     * 
     * @author  Todd Shinto
     * @since   1.17
     * 
     * @param   contactId   The Id of the Contact
     * 
     * @return  The first name, last name, and Name of the Contact
     */
    private List<Map<String, Object>> getFormattedContactInfoList(String contactId) {
        List<Map<String, Object>> contactInfoList = new List<Map<String, Object>>();

        if (String.isBlank(contactId)) {
            return contactInfoList;
        }

        Contact currentContact = PORTAL_CommunityUtils.getContactInfoFromId(contactId);

        if (currentContact == null) {
            return contactInfoList;
        }

        Map<String, Object> contactFields = new Map<String, Object>{
            CONTACT_FIRST_NAME => currentContact.FirstName,
            CONTACT_LAST_NAME => currentContact.LastName,
            CONTACT_NAME => currentContact.Name
        };

        contactInfoList.add(contactFields);

        return contactInfoList;
    } 

    /**
     * Calculate the total amount a constituent has gave for the current year.
     * @param   paramMap                                            List of parameters passed in by the calling function.
     */
    public virtual void formatTableData(Map<String, Object> paramMap) {
        totalAmountDecimal = 0;

        for (Map<String, Object> tableRow : tableData) {
            totalAmountDecimal += (Decimal)tableRow.get(PAYMENT_AMOUNT_FIELD_ID);
        }
    }

    /**
     * Replace all merge fields with its associated value. The matching indicies of merge fields and values are related.
     *
     * @param   text                                                The original text to be searched.
     * @param   mergeFieldsAndValues                                Map of merge fields to map values.
     * @param   valueEmpty                                          Default to replace merge field with if there is no value.
     * @return                                                      text returned with merge fields replaced.
     */
    private String replaceMergeFields(String text, Map<String, String> mergeFieldsAndValues, String valueEmpty) {
        if (String.isBlank(text)) {
            return text;
        }

        for (String mergeField : mergeFieldsAndValues.keySet()) {
            String value = mergeFieldsAndValues.get(mergeField);
            text = replaceMergeFieldsHelper(text, mergeField, value, valueEmpty);
        }

        return text;
    }

    /**
     * Replace mergefields with avlue if provided, if value is blank then use valueEmpty.
     *
     * @param   text                                                The original text to be searched.
     * @param   mergeField                                          The merge field to repalce within the text.
     * @param   value                                               Value to replace merge field if not blank.
     * @param   valueEmpty                                          Value to replace if value is empty.
     * @return                                                      Text with merge field replaced.
     */
    private String replaceMergeFieldsHelper(String text, String mergeField, String value, String valueEmpty) {
        String valueToReplace;

        if (String.isBlank(text) || String.isBlank(mergeField)) {
            return text;
        }

        if (String.isBlank(value)) {
            valueToReplace = valueEmpty;
        } else {
            valueToReplace = value;
        }

        return text.replaceAll(mergeField, valueToReplace);
    }

    /**
     * Format and store constituent and address information.
     *
     * @author      Daniel Mardirousi
     * @version     1.0
     * @since       1.0
     */
    public virtual class ConstituentWrapper {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String name {get; set;}
        public String salutation {get; set;}
        public String addressHTML {get; set;}
        public String city {get; set;}
        public String state {get; set;}
        public String postalCode {get; set;}


        /**
         * Format and store constituent and address information
         *
         * @param   paramMap                                        List of parameters passed in by the calling function.
         *                                                              List<Map<String, Object>> CONTACT_INFO_KEY: contact and address information information
         */
        public ConstituentWrapper (Map<String, Object> paramMap) {
            List<Map<String, Object>> contactInfo = (List<Map<String, Object>> )paramMap.get(CONTACT_INFO_KEY);

            if ( contactInfo != null && !contactInfo.isEmpty() ) {
                Map<String, Object> contactFields = contactInfo.get(0);
                firstName = (String)getField(contactFields, CONTACT_FIRST_NAME, '');
                lastName = (String)getField(contactFields, CONTACT_LAST_NAME, '');
                name = (String)getField(contactFields, CONTACT_NAME, '');
                salutation = (String)getField(contactFields, CONTACT_SALUTATION, '');
                city = (String)getField(contactFields, ADDRESS_CITY, '');
                state = (String)getField(contactFields, ADDRESS_STATE, '');
                postalCode = (String)getField(contactFields, ADDRESS_POSTAL_CODE, '');

                addressHTML = createAddress(addressHTML, (String)getField(contactFields, ADDRESS_LINE_1, ''));
                addressHTML = createAddress(addressHTML, (String)getField(contactFields, ADDRESS_LINE_2, ''));
                addressHTML = createAddress(addressHTML, (String)getField(contactFields, ADDRESS_LINE_3, ''));
                addressHTML = createAddress(addressHTML, (String)getField(contactFields, ADDRESS_LINE_4, ''));

            }
        }

        /**
         * Create an HTML address string based on the running total address and the newly provided address
         *
         * @param   fullAddress                                     The running total address when the functions is repeatedly called.
         * @param   addressLine                                     The new address line to add to the running total
         * @return                                                  both address line combined.
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
         * Get field using the key from the provided map, if there is no value, return empty value.
         *
         * @param   contactFields                                   Map used to search for values based on provided key.
         * @param   key                                             Provided key used to search the map for its associded value.
         * @param   emptyValue                                      If there is no value associated with the key, then use empty value.
         * @return                                                  return the value associated with the key if found, if not found return empty value.
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

}