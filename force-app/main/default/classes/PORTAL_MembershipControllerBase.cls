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
 * Base Controller for Memberships
 *
 * @author  Phillip Nguyen
 * @version 1.0
 * @since   1.0
*/
global virtual inherited sharing class PORTAL_MembershipControllerBase {
    public static final String PAGE_NAME = 'pageName';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String SUB_SECTION_NAME = 'subSectionName';
    public static final String FRONT_END_DATA_MAP = 'frontEndDataMap';
    public static final String MEMBERSHIP_RECORDS = 'membershipRecords';
    public static final String MEMBERSHIP_RECORD_LIST = 'membershipRecordList';
    public static final String MEMBERSHIP_IS_SHOW_RENEWAL_BUTTON = 'membershipIsShowRenewalButton';

    public static final String MEMBERSHIPS_TO_UPDATE = 'membershipsToUpdate';
    public static final String GLOBAL_MEMBERSHIP_RENEWAL_SOLICIT_OPT_OUT_VALUE = 'globalMembershipRenewalSolicitOptOutValue';

    public static final String ERROR_GENERAL_MESSAGE = 'There was an issue getting your information. Please contact an administrator.';
    public static final String DEBUG_MESSAGE_COULD_NOT_FIND_LOGGED_IN_USER = 'Could not find logged in user';

    public static final String MEMBERSHIP_LEVEL_ID = 'membershipLevelId';
    public static final String GIVING_SOCIETY_ID = 'givingSocietyId';
    public static final String MEMBERSHIP_CREATED_DATE = 'membershipCreatedDate';
    public static final String MEMBERSHIP_PRICE = 'membershipPrice';
    public static final String MEMBERSHIP_NAME = 'membershipName';
    public static final String DESIGNATION_ID = 'designationId';
    public static final String MEMBERSHIP_ANNIVERSERY_DATE = 'membershipAnniverseryDate';
    public static final String MEMBERSHIP_EXPIRATION_DATE = 'membershipExpirationDate';
    public static final String PAYMENT_METHOD = 'paymentMethod';
    public static final String CONTACT_CONST = 'contact';
    public static final String MEMBERSHIP_RECORD_ID = 'membershipRecordId';
    public static final String MEMBERSHIP_FIELDS = 'membershipFields';
    public static final String SECTION_ID = 'sectionId';
    public static final String APPEAL_CONST = 'appeal';
    public static final String NAME_CONST = 'name';
    public static final String VALUE_CONST = 'value';
    public static final String DESIGNATIONS_CONST = 'designations';
    public static final String MONTHS_ALLOCATED = 'monthsAllocated';
    public static final String FREQUENCY_CONST = 'frequency';
    public static final String AMOUNT_CONST = 'amount';
    public static final String USER_CONTACT_ID = 'userContactId';
    public static final String ID_CONST = 'Id';
    public static final String MEMBERSHIP_PAYMENT_OPTIONS = 'membershipPaymentOptions';
    public static final String ACTIVE_CONST = 'Active';
    public static final String HAS_EXISTING_MEMBERSHIP_MATCHING_MEMBERSHIP_TYPE = 'hasExistingMembershipMatchingMembershipType';
    public static final String BENEFIT_AMOUNT = 'benefitAmount';
    public static final String RECORDS_KEY = 'records';
    public static final String MEMBERSHIP_BENEFIT_MAIN_SECTION_NAME = 'Membership Benefits';
    public static final String MEMBERSHIP_PURCHASE_PAGE_NAME = 'Membership Purchase';
    public static final String PERSONAL_INFORMATION = 'Personal_Information';
    public static final String MEMBERSHIP_BENEFIT_RECORDS = 'membershipBenefitRecords';
    public static final String PRODUCT2ID_CONST = 'Product2Id';
    public static final String ASSET_PRICE_API_NAME = 'ucinn_ascendv2__Total__c';

    public static final Map<String, String> PAYMENT_OPTION_TO_SUBSECTION_NAME_MAP =
                                        new Map<String, String>{'One-Time Membership' => 'One Time Membership',
                                                                'Auto Renewing Membership' => 'Auto Renewing Membership',
                                                                'Installment Based Membership' => 'Installment Based Membership'};
    public static final Map<String, String> OPPORTUNITY_TYPE_TO_SECTION_ID_MAP =
                                        new Map<String, String>{'One-Time Membership' => 'oneTimeSection',
                                                                'Auto Renewing Membership' => 'autoRecurringSection',
                                                                'Installment Based Membership' => 'installmentBasedSection'};

    public static final Map<String, String> SUBSECTION_NAME_TO_PAYMENT_OPTION_MAP =
                                        new Map<String, String>{'One Time Membership' => 'One-Time Membership',
                                                                'Auto Renewing Membership' => 'Auto Renewing Membership',
                                                                'Installment Based Membership' => 'Installment Based Membership'};


    public static final Map<Decimal, String> MONTHS_TO_FREQUENCY_MAP =
                                        new Map<Decimal, String>{1 => 'Monthly',
                                                                 2 => 'Bi-Monthly',
                                                                 3 => 'Quarterly',
                                                                 6 => 'Semi-Annual',
                                                                 12 => 'Annual'};

    private static PORTAL_PageSectionAdapter.Builder getPageSectionAdapterBuilder() {
        return new PORTAL_PageSectionAdapter.Builder();
    }

    /**
     * Initializes the membership purchase page.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param membershipRecordId    The Id of the membership record to prepopulate fields with.
     * @param paymentMethod         String: Specify the payment processor, determines what needs to be queried
     * 
     * @return                      Map containing information to initialize the membership purchase page.
     * @since                       1.0
     */
    public virtual Map<String, Object> initializeMembershipPurchase(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String membershipRecordId = (String)params.get(MEMBERSHIP_RECORD_ID);
        String paymentMethod = (String)params.get(PAYMENT_METHOD);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            return resultMap;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, null);

        if (pageSectionSettingList == null || pageSectionSettingList.isEmpty()) {
            return resultMap;
        }

        Map<String, Map<String, Object>> frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList);
        resultMap.put(FRONT_END_DATA_MAP, frontEndDataMap);

        Map<String, Object> contactMap = this.getContactInfo(paymentMethod);
        String contactId = (String)contactMap.get(ID_CONST);
        resultMap.put(CONTACT_CONST, contactMap);
        
        // Prepopulates membership information
        if (String.isNotBlank(membershipRecordId) && String.isNotBlank(contactId)) {
            ucinn_ascendv2__Society_Membership__c membershipRecord = getMembershipRecordWithId(membershipRecordId, contactId);

            if (membershipRecord != null) {
                resultMap.put(MEMBERSHIP_FIELDS, getMembershipFieldsWithRecord(pageName, mainSectionName, contactId, membershipRecord));
                resultMap.put(SECTION_ID, OPPORTUNITY_TYPE_TO_SECTION_ID_MAP.get(membershipRecord.ucinn_ascendv2__Designation_Detail__r?.ucinn_ascendv2__Opportunity__r?.Type));
            }
        }

        return resultMap;
    }

    /**
     * Get membership fields to prepopulate using Portal Page Section Settings.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param subSectionName        The main section name of the Portal Page Section Settings to use.
     * @param membershipLevelId     The Id of the membership level to query for.
     * @return                      Map of fields to prepopulate on the front end.
     * @since                       1.0
     */
    global virtual Map<String, Object> getMembershipFieldsToPrepopulate(Map<String, Object> params){
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        String membershipLevelId = (String)params.get(MEMBERSHIP_LEVEL_ID);
        String userContactId = (String)params.get(USER_CONTACT_ID);

        if (String.isBlank(pageName) || String.isBlank(mainSectionName)
                || String.isBlank(subSectionName) || String.isBlank(membershipLevelId)) {
            return resultMap;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (pageSectionSettingList == null || pageSectionSettingList.isEmpty()) {
            return resultMap;
        }

        Portal_Page_Section_Setting__mdt pageSectionSettingRecord = pageSectionSettingList.get(0);

        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass();
        dynamicQueryObject.dynamicWhereClause = ' WHERE Id = \'' + membershipLevelId + '\' ';

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(null, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList), new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{subSectionName => dynamicQueryObject}, false, true);

        if (recordsMap == null || recordsMap.get(mainSectionName) == null || recordsMap.get(mainSectionName).get(subSectionName) == null || recordsMap.get(mainSectionName).get(subSectionName).isEmpty()) {
            return resultMap;
        }

        resultMap = recordsMap.get(mainSectionName).get(subSectionName).get(0);

        if (String.isBlank(userContactId)) {
            Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});

            if (userContact != null) {
                userContactId = userContact.Id;
            }
        }

        resultMap.put(MEMBERSHIP_PRICE, '$' + String.valueOf(ucinn_ascendv2.ascend_GIFT_MembershipUtils.getPricebookValueFromMembershipLevel(membershipLevelId)));
        resultMap.put(MEMBERSHIP_ANNIVERSERY_DATE, ucinn_ascendv2.ascend_GIFT_MembershipUtils.getAnniversaryDateBasedOnRecipientInformation(userContactId, membershipLevelId));
        resultMap.put(MEMBERSHIP_EXPIRATION_DATE, ucinn_ascendv2.ascend_GIFT_MembershipUtils.getExpirationDateBasedOnRecipientInformation(userContactId, membershipLevelId, SUBSECTION_NAME_TO_PAYMENT_OPTION_MAP.get(subSectionName)));
        resultMap.put(FREQUENCY_CONST, MONTHS_TO_FREQUENCY_MAP.get((Decimal)resultMap.get(MONTHS_ALLOCATED)));
        resultMap.put(HAS_EXISTING_MEMBERSHIP_MATCHING_MEMBERSHIP_TYPE, hasExistingMembershipMatchingMembershipType(userContactId, (String)resultMap.get(MEMBERSHIP_PAYMENT_OPTIONS), (String)resultMap.get(ID_CONST)));

        return resultMap;
    }

    /**
     * Checks to see if the user has an existing, active membership matches the membership product that was selected
     * and that has a membership purchase type that matches the membership product payment options list
     *
     * @author Phillip Nguyen
     *
     * @param userContactId                         Current logged in user's contact Id
     * @param membershipProductPaymentOptions       String of membership product's payment options. A multi-select picklist so this value is a string with semi colon separated values
     * @param membershipProductId                   The Id of the membership product that was selected on the front end
     *
     * @return                                      Boolean value indicating if the current user has an active society membership that looks up to the membership product
     *                                               and a membership purchase type that matches the values in the membership product payment options field
     */
    public virtual Boolean hasExistingMembershipMatchingMembershipType(String userContactId, String membershipProductPaymentOptions, String membershipProductId) {
        if (String.isBlank(userContactId) || String.isBlank(membershipProductPaymentOptions) || String.isBlank(membershipProductId)) {
            return false;
        }

        List<String> membershipProductPaymentOptionsList = membershipProductPaymentOptions.split(';');

        List<ucinn_ascendv2__Society_Membership__c> userSocietyMembershipList = [SELECT Id FROM ucinn_ascendv2__Society_Membership__c
                                                                                 WHERE ucinn_ascendv2__Contact__c = :userContactId
                                                                                  AND ucinn_ascendv2__Membership_Level_Product__c = :membershipProductId
                                                                                  AND ucinn_ascendv2__Membership_Status__c = :ACTIVE_CONST
                                                                                  AND ucinn_ascendv2__Giving_Society__r.ucinn_ascendv2__Status__c = :ACTIVE_CONST
                                                                                  AND ucinn_portal_Is_Display_On_Portal__c = true
                                                                                  AND ucinn_ascendv2__Membership_Purchase__r.Type IN :membershipProductPaymentOptionsList];

        return (userSocietyMembershipList != null && !userSocietyMembershipList.isEmpty());
    }

    /**
     * Delegates to the Payment Hub to create a review transaction.
     *
     * @author Aaron Wong
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (only used if using stripe)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The HEP id for the matching company if the org is HEP enabled
     * @param paymentId:                    The external id for the payment taken from the billing external gateway
     * @param appealCode:                   The external id of the appeal code to default to
     * @param recaptchaToken:               The recaptcha client side token for this transaction submission
     * @param membershipLevelId             Membership Level Id
     * @param paymentOrigin                 Where the payment originated in the portal
     *
     * @return                              Information regarding the review transaction created.
     * @since 1.0
     */
    public virtual Map<String, Object> createReviewTransaction(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return resultMap;
        }

        if ((String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ORIGIN) != PORTAL_CONST_OnlineGiving.MEMBERSHIP_PAYMENT_ELEMENT
                && (String)params.get(PAYMENT_METHOD) != PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME) {
            PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
            recaptchaController.verifyRecaptcha('PORTAL_MembershipControllerBase.createReviewTransaction', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));
        }

        PORTAL_PaymentHubControllerBase controller = (PORTAL_PaymentHubControllerBase)PORTAL_Utils.getControllerFactory().getPaymentHubController((String)params.get(PAYMENT_METHOD));
        controller.setPaymentInterface((String)params.get(PAYMENT_METHOD));

        resultMap = controller.createReviewTransaction(createReviewTransactionParams(params));

        return resultMap;
    }

     /**
      * Gets Membership Records for Membership Table depending on page name, main section name, subsection name
      *
      * @author                  Phillip Nguyen
      * @since                   1.0
      *
      * @param pageName          Page Name of Page Section Setting
      * @param mainSectionName   Main Section Name of Page Section Setting
      * @param subSectionName    Sub Section Name of Page Section Setting
      *
      * @return                  Returns front end data map & membership records
      */
    public virtual Map<String, Object> getMembershipRecords(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String pageName = (String) params.get(PAGE_NAME);
        String mainSectionName = (String) params.get(MAIN_SECTION_NAME);
        String subSectionName = (String) params.get(SUB_SECTION_NAME);

        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString) || String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(subSectionName)) {
            System.debug('Could not find logged in user or params are blank');
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        List<Portal_Page_Section_Setting__mdt> membershipPageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (membershipPageSectionList == null || membershipPageSectionList.isEmpty()) {
            return returnMap;
        }

        returnMap.put(FRONT_END_DATA_MAP, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(membershipPageSectionList));

        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(contactIdString,
                                                                                                                        PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(membershipPageSectionList),
                                                                                                                        new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(),
                                                                                                                        false,
                                                                                                                        true);

        List<Map<String, Object>> dedupedRecordsList = parseMembershipRecordsForDuplicates(recordsMap?.get(mainSectionName)?.get(subSectionName));
        List<Map<String, Object>> membershipList = setMembershipShowRenewalLink(new Map<String, Object>{MEMBERSHIP_RECORD_LIST => dedupedRecordsList});
        returnMap.put(MEMBERSHIP_RECORDS, membershipList);

        return returnMap;
    }

    /**
      * Returns a list of membership records containing only the most recently purchased membership of each 
      * membership level.
      *
      * @author                  Curtis Ung
      * @since                   1.0
      *
      * @param membershipList    List of membership records in {frontEndFieldId => value} format to be deduped
      *
      * @return                  List of deduped membership records in {frontEndFieldId => value} format
     */
    private List<Map<String, Object>> parseMembershipRecordsForDuplicates(List<Map<String,Object>> membershipList){
        if (membershipList == null || membershipList.isEmpty()) {
            return new List<Map<String, Object>>();
        }

        Map<String, Map<String, Object>> membershipKeyToMembershipMap = new Map<String, Map<String, Object>>();
        for (Map<String,Object> eachMembership : membershipList) {
            String eachMembershipKey = (String) eachMembership.get(GIVING_SOCIETY_ID) + (String) eachMembership.get(MEMBERSHIP_LEVEL_ID);

            if (membershipKeyToMembershipMap.get(eachMembershipKey) != null) {

                Datetime createdDate = Datetime.valueOf(eachMembership.get(MEMBERSHIP_CREATED_DATE));
                Datetime mostRecentCreatedDate = Datetime.valueOf(membershipKeyToMembershipMap.get(eachMembershipKey).get(MEMBERSHIP_CREATED_DATE));
                if (mostRecentCreatedDate < createdDate) {
                    membershipKeyToMembershipMap.put(eachMembershipKey, eachMembership);
                }

            } else {
                membershipKeyToMembershipMap.put(eachMembershipKey, eachMembership);
            }
        }

        return membershipKeyToMembershipMap.values();
    }

    /**
     * Gets Current Logged In User's Contact Membership Information
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @return                  Returns user contact's membership renewal solicitation boolean value
     */
    public virtual Map<String, Object> getMembershipContactInformation(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString)) {
            System.debug(DEBUG_MESSAGE_COULD_NOT_FIND_LOGGED_IN_USER);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        List<Contact> contactInfoList = [SELECT Id, ucinn_portal_Is_Renewal_Solicit_Opt_Out__c FROM Contact WHERE Id = :contactIdString];

        if (contactInfoList == null || contactInfoList.isEmpty()) {
            return returnMap;
        }

        returnMap.put(GLOBAL_MEMBERSHIP_RENEWAL_SOLICIT_OPT_OUT_VALUE, contactInfoList.get(0).ucinn_portal_Is_Renewal_Solicit_Opt_Out__c);

        return returnMap;
    }

    /**
     * Updates membership renewal solicitation options on the memberships and/or the contact
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param membershipsToUpdate                         Map of membership Id to Boolean value
     * @param globalMembershipRenewalSolicitOptOutValue   Boolean value for membership renenwal solicitation field on contact
     *
     */
    public virtual void saveMembershipRecords(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return;
        }

        Boolean globalMembershipRenewalSolicitOptOutValue = (Boolean) params.get(GLOBAL_MEMBERSHIP_RENEWAL_SOLICIT_OPT_OUT_VALUE);  // convert null to boolean results in null still
        Map<Object,Object> membershipIdToBooleanMap = (Map<Object,Object>) params.get(MEMBERSHIPS_TO_UPDATE);

        String contactIdString = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.contactId;

        if (String.isBlank(contactIdString)) {
            System.debug(DEBUG_MESSAGE_COULD_NOT_FIND_LOGGED_IN_USER);
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE});
        }

        updateContactGlobalMembershipRenewalSolicitationOptOut(contactIdString, globalMembershipRenewalSolicitOptOutValue);
        updateMembershipsRenewalSolicitation(membershipIdToBooleanMap);
    }

    /**
     * Overridable function that determines whether or not to show the Renewal Button for each membership record
     *
     * @author                               Phillip Nguyen
     * @since                                1.0
     *
     * @param membershipRecordsList          List of membership records to pass to front end
     *
     * @return                               Returns list of membership records with new key determining whether or not to display membership renewal button
     */
    public virtual List<Map<String, Object>> setMembershipShowRenewalLink(Map<String, Object> params) {
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();

        if (params == null || params.isEmpty()) {
            return returnList;
        }

        List<Map<String, Object>> membershipRecordsList = (List<Map<String, Object>>) params.get(MEMBERSHIP_RECORD_LIST);

        if (membershipRecordsList == null || membershipRecordsList.isEmpty()) {
            return returnList;
        }

        returnList = membershipRecordsList;

        for (Map<String, Object> eachMembershipMap : returnList) {
            eachMembershipMap.put(MEMBERSHIP_IS_SHOW_RENEWAL_BUTTON, true);
        }

        return returnList;
    }

    /**
     * Overridable function that gets all the membership benefits related to the selected membership level
     *
     * @author                               Phillip Nguyen
     * @since                                1.0
     *
     * @param membershipLevelId              Id of membership level product to query for correct junction object
     *
     * @return                               Returns list of membership benefit records
     */
    public virtual Map<String, Object> getMembershipBenefitInformation(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            return returnMap;
        }

        String membershipLevelId = (String)params.get(MEMBERSHIP_LEVEL_ID);

        if (String.isBlank(membershipLevelId)) {
            return returnMap;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = getPageSectionAdapterBuilder().buildPageName(MEMBERSHIP_PURCHASE_PAGE_NAME)
                                                                                     .buildMainSectionName(MEMBERSHIP_BENEFIT_MAIN_SECTION_NAME)
                                                                                     .buildParentFieldId(membershipLevelId)
                                                                                     .build();

        returnMap.put(MEMBERSHIP_BENEFIT_RECORDS, getMembershipBenefitRecords(pageSectionAdapter, membershipLevelId));
        returnMap.put(FRONT_END_DATA_MAP, pageSectionAdapter?.getFrontEndDataMap());

        return returnMap;
    }

    /**
     * Updates global membership renewal solicitation opt out on contact
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param contactId                                   Contact Id of current logged in user
     * @param globalMembershipRenewalSolicitOptOutValue   Boolean value for membership renenwal solicitation field on contact
     *
     */
    private void updateContactGlobalMembershipRenewalSolicitationOptOut(Id contactId, Boolean globalMembershipRenewalSolicitOptOutValue) {
        if (String.isBlank(contactId) || globalMembershipRenewalSolicitOptOutValue == null) {
            return;
        }

        Contact contactToUpdate = new Contact(Id = contactId, ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = globalMembershipRenewalSolicitOptOutValue);
        update contactToUpdate;
    }

    /**
     * Updates membership renewal solicitation opt out for membership records
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param membershipIdToBooleanMap      Map of Membership Id -> Renewal Solicitation Opt Out Boolean Value
     *
     */
    private void updateMembershipsRenewalSolicitation(Map<Object, Object> membershipIdToBooleanMap) {
        if (membershipIdToBooleanMap == null || membershipIdToBooleanMap.isEmpty()) {
            return;
        }

        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToUpdateList = new List<ucinn_ascendv2__Society_Membership__c>();

        for (Object eachMembershipId : membershipIdToBooleanMap.keySet()) {
            societyMembershipsToUpdateList.add(new ucinn_ascendv2__Society_Membership__c(Id = (Id) eachMembershipId,
                                                                                         ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = (Boolean) membershipIdToBooleanMap.get(eachMembershipId)));
        }

        update societyMembershipsToUpdateList;
    }

    /**
     * Creates review transaction parameters with the parameters given.
     *
     * @author Aaron Wong
     *
     * @param designationId     Id of the Designation to create the review transaction for.
     * @param membershipLevelId Id of Membership level to get membership benefits for
     * @return                  Parameters to give to the payment hub for creating a review transaction.
     * @since                   1.0
     */
    private static Map<String, Object> createReviewTransactionParams(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>(params);

        String designationId = (String)params.get(DESIGNATION_ID);
        String membershipLevelId = (String)params.get(MEMBERSHIP_LEVEL_ID);

        List<Object> designationObjectList = new List<Object>{new Map<String, Object>{'Id' => designationId, AMOUNT_CONST => params.get(AMOUNT_CONST)}};

        resultMap.put(DESIGNATIONS_CONST, designationObjectList);

        PORTAL_PageSectionAdapter pageSectionAdapter = getPageSectionAdapterBuilder().buildPageName(MEMBERSHIP_PURCHASE_PAGE_NAME)
                                                                                     .buildMainSectionName(MEMBERSHIP_BENEFIT_MAIN_SECTION_NAME)
                                                                                     .buildParentFieldId(membershipLevelId)
                                                                                     .build();

        resultMap.put(MEMBERSHIP_BENEFIT_RECORDS, getMembershipBenefitRecords(pageSectionAdapter, membershipLevelId));

        return resultMap;
    }

    /**
     * Gets a membership record with the given Id and user contact.
     *
     * @author Aaron Wong
     *
     * @param membershipRecordId        Id of the membership record to get.
     * @param userContactId             Id of the users contact.
     * @return                          The membership record, if any.
     * @since                           1.0
     */
    private static ucinn_ascendv2__Society_Membership__c getMembershipRecordWithId(String membershipRecordId,
                                                                                   String userContactId) {
        if (String.isBlank(membershipRecordId) || String.isBlank(userContactId)) {
            return null;
        }

        List<ucinn_ascendv2__Society_Membership__c> membershipList = [SELECT id, ucinn_ascendv2__Membership_Level_Product__c,
                                                                             ucinn_ascendv2__Designation_Detail__r.ucinn_ascendv2__Opportunity__r.Type,
                                                                             ucinn_ascendv2__Appeal__c,
                                                                             ucinn_ascendv2__Appeal__r.Name
                                                                      FROM ucinn_ascendv2__Society_Membership__c
                                                                      WHERE Id = :membershipRecordId
                                                                      AND ucinn_ascendv2__Contact__c = :userContactId];

        if (membershipList == null || membershipList.isEmpty()) {
            return null;
        }

        return membershipList.get(0);
    }

    /**
     * Gets membership fields to prepopulate given a membership record.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param membershipRecord      The membership record to user to prepopulate fields.
     * @return                      Map of fields to prepopulate.
     * @since                       1.0
     */
    private Map<String, Object> getMembershipFieldsWithRecord(String pageName,
                                                              String mainSectionName,
                                                              String userContactId,
                                                              ucinn_ascendv2__Society_Membership__c membershipRecord) {
        Map<String, Object> resultMap = new Map<String, Object>{};

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || membershipRecord == null) {
            return resultMap;
        }

        String subSectionName = PAYMENT_OPTION_TO_SUBSECTION_NAME_MAP.get(membershipRecord.ucinn_ascendv2__Designation_Detail__r?.ucinn_ascendv2__Opportunity__r?.Type);

        resultMap = getMembershipFieldsToPrepopulate(new Map<String, Object>{PAGE_NAME => pageName,
                                                                             MAIN_SECTION_NAME => mainSectionName,
                                                                             SUB_SECTION_NAME => subSectionName,
                                                                             MEMBERSHIP_LEVEL_ID => membershipRecord.ucinn_ascendv2__Membership_Level_Product__c,
                                                                             USER_CONTACT_ID => userContactId});

        resultMap.put(MEMBERSHIP_NAME, membershipRecord.ucinn_ascendv2__Membership_Level_Product__c);
        resultMap.put(APPEAL_CONST, membershipRecord.ucinn_ascendv2__Appeal__c);

        return resultMap;
    }

    /**
     * Get contact and possibly related record (e.g. address, email, etc.) fields.
     * Certain payment methods may need more info than others for (pre)populating constituent fields.
     *
     * @author Jacob Huang
     * @since 1.9 
     * 
     * @param paymentMethod     String: Specify the payment processor, determines what needs to be queried 
     * 
     * @return Map of contact and various related records
     */
    private Map<String, Object> getContactInfo(String paymentMethod) {
        if (paymentMethod == PORTAL_CONST_OnlineGiving.TOUCHNET_METHOD_NAME) {
            return this.getContactInfoFromPageSectionSettings();
        }

        Contact userContact = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        return new Map<String, Object>{
            ID_CONST => userContact?.Id,
            NAME_CONST => userContact?.Name
        };
    }

    /**
     * Get contact and related record fields using page section settings
     *
     * @author Jacob Huang
     * @since 1.9
     *
     * @return Map of contact and various related records
     */
    private Map<String, Object> getContactInfoFromPageSectionSettings() {
        Map<String, Object> emptyMap = new Map<String, Object>();

        String contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).ContactId;
        if (String.isBlank(contactId)) {
            return emptyMap;
        }

        PORTAL_PageSectionAdapter pageSectionAdapter = getPageSectionAdapterBuilder().buildPageName(MEMBERSHIP_PURCHASE_PAGE_NAME)
                                                                                     .buildMainSectionName(PERSONAL_INFORMATION)
                                                                                     .buildParentFieldId(contactId)
                                                                                     .build();

        List<Map<String, Object>> contactList = pageSectionAdapter.getRecords()?.get(PERSONAL_INFORMATION)?.get(RECORDS_KEY);
        
        if (contactList == null || contactList.isEmpty()) {
            return emptyMap;
        }

        return contactList[0];
    }

    /**
     * Get list of membership benefit records and set the benefit amount using ascends pricebook exposed function
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   pageSectionAdapter      Page Section Adapter
     * @param   membershipLevelId       Membership Level Id
     * @return                          List of membership benefit records
     */
    private static List<Map<String, Object>> getMembershipBenefitRecords(PORTAL_PageSectionAdapter pageSectionAdapter, String membershipLevelId) {
        List<Map<String, Object>> membershipBenefitRecordList = new List<Map<String, Object>>();

        if (pageSectionAdapter == null || String.isBlank(membershipLevelId)) {
            return membershipBenefitRecordList;
        }

        membershipBenefitRecordList = pageSectionAdapter.getRecords()?.get(MEMBERSHIP_BENEFIT_MAIN_SECTION_NAME)?.get(RECORDS_KEY);
        Map<String, Object> benefitIdToPriceMap = getBenefitIdToPriceMap(ucinn_ascendv2.ascend_GIFT_MembershipUtils.getListOfProductsToAddAsAssets(membershipLevelId));

        if (membershipBenefitRecordList == null || membershipBenefitRecordList.isEmpty() || benefitIdToPriceMap == null || benefitIdToPriceMap.isEmpty()) {
            return membershipBenefitRecordList;
        }

        for (Map<String, Object> eachMembershipBenefit : membershipBenefitRecordList) {
            eachMembershipBenefit.put(BENEFIT_AMOUNT, benefitIdToPriceMap.get((String)eachMembershipBenefit?.get(MEMBERSHIP_LEVEL_ID)));
        }
        
        return membershipBenefitRecordList;
    }

    /**
     * Gets benefit Id to price map
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   assetList   List of assets that represent benefits
     * 
     * @return              Map of Benefit Ids to Price
     */
    private static Map<String, Object> getBenefitIdToPriceMap(List<SObject> assetList) {
        Map<String, Object> returnMap = new Map<String, Object>();

        if (assetList == null || assetList.isEmpty()) {
            return returnMap;
        }

        for (SObject eachAsset : assetList) {
            returnMap.put((String)eachAsset.get(PRODUCT2ID_CONST), eachAsset.get(ASSET_PRICE_API_NAME));
        }

        return returnMap;
    }
}