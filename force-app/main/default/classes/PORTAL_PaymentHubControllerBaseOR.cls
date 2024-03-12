/**
 * Created by UCI on 12/17/2022.
 */

public without sharing class PORTAL_PaymentHubControllerBaseOR {

    public static String reviewTransactionPrefix = 'PORT';
    public static String interimPrefix = 'IMOD';
    public static final String MANUAL_REVIEW = 'Manual Review';
    public static final String STATUS_NEW = 'New';
    public static final String IS_EMAIL_EXCEPTION = 'isEmailException';
    public static final String GIFT_TYPE = 'giftType';
    public static PORTAL_PaymentGateway paymentInterface = null;
    public static Boolean useExternalId = false;
    public static final String DESIGNATION_CUSTOM_METADATA_NAME = 'Designations';
    public static final String RECORDS = 'records';
    public static final String IS_GIVING_AS_ORG = 'isGivingAsOrg';
    public static final String USER_SPECIFIED_ORGANIZATIONAL_GIFT = ' User specified this is an organizational gift';
    public static Decimal totalPaidTodayAmount;

    @AuraEnabled
    public static Map<String, Object> createReviewTransaction(Map<String, Object> params) {
        //FUTURE TODO: take this function and move it to its own review transaction builder wrapper
        if(paymentInterface == null){
            paymentInterface = (PORTAL_StripePaymentGateway)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                    PORTAL_Utils.CLASS_TYPE => PORTAL_StripePaymentGateway.Class});
        }
        if (Test.isRunningTest()) {
            paymentInterface = new PORTAL_TestPaymentGateway();

        }
        validateCreateReviewTransaction(params);
        Map<String, Object> returnMap = new Map<String, Object>();

        String giftType = (String) params.get(GIFT_TYPE);
        Map<String, Object> tributeInformation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(params.get('tributeInformation')));
        Decimal giftAmount =  Decimal.valueOf((String)params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY));
        Map<String, Object> billingInformation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.BILLING_INFORMATION_KEY)));
        Map<Object, Object> additionalPaymentDataMap = (Map<Object, Object>) params.get(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS);
        //FUTURE TODO: Change to payment method billing information if other payment methods also need differently formatted billing information
        Map<String, Object> stripeBillingInformation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(params.get(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY)));
        List<Object> designations = (List<Object>) params.get(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY);
        List<Object> additionalDetails = (List<Object>) params.get('additionalDetails');
        String matchingCompanyName = (String) params.get('matchingCompanyName');
        String matchingCompanyId = (String) params.get('matchingCompanyId');
        String paymentId = ((String) params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY)).replaceAll('"', '');
        String pageName = (String) params.get('pageSectionName');
        String pledgeId = (String) params.get('pledgeId');
        String emailTemplateName = (String) params.get('emailTemplateName');
        String appealCode = (String) params.get('appealCode');
        String frequency = (String) params.get(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY);
        String gatewayName = (String) (String)params.get(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY);
        String apiKeyName = (String) params.get(PORTAL_CONST_OnlineGiving.API_KEY_NAME);
        String accountId = (String) params.get(PORTAL_CONST_OnlineGiving.ACCOUNT_ID_KEY);
        String contactId = (String) params.get('contactId'); // Added for Customization

        if (String.isNotBlank((String)params.get('prefix'))) {
            reviewTransactionPrefix = (String)params.get('prefix');
        }

        Integer numberOfInstallments = getNumberOfInstallments(params.get(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY));

        Date startDate = Date.today();
        if (params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)))) {
            startDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
        }
        Date endDate = null;
        if (params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)))) {
            endDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)));
        }

        ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
        reviewTransaction.ucinn_ascendv2__Total_Transaction_Amount__c = giftAmount;
        reviewTransaction.ucinn_ascendv2__Tender_Type_1__c = 'Credit Card';
        reviewTransaction.ucinn_ascendv2__Status__c = STATUS_NEW;
        reviewTransaction.ucinn_ascendv2__Address_1_Type__c = 'Home';

        if (String.isNotBlank(appealCode)) {
            reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c = appealCode;
        }

        if (giftType == PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE
                || giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE
                || giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE) {
            reviewTransaction.ucinn_ascendv2__Membership_Anniversary_Date_1__c = Date.valueOf((String)params.get(PORTAL_MembershipControllerBase.MEMBERSHIP_ANNIVERSERY_DATE));
            reviewTransaction.ucinn_ascendv2__Membership_Expiration_Date_1__c = Date.valueOf((String)params.get(PORTAL_MembershipControllerBase.MEMBERSHIP_EXPIRATION_DATE));
            reviewTransaction.ucinn_ascendv2__Membership_Level_External_ID_1__c = (String)params.get('membershipExternalId');
            reviewTransaction.ucinn_ascendv2__Campaign__c = (Id)(String.valueOf(params.get(PORTAL_MembershipControllerBase.APPEAL_CONST)));
        }


        returnMap.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY, frequency);
        if (isOneTimePaymentType(giftType)) {
            returnMap.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY, PORTAL_CONST_PaymentHub.ONE_TIME_FREQUENCY);
        }

        returnMap.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, startDate);
        returnMap.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, endDate);

        if (String.isNotBlank(pageName)) {
            setReviewTransactionFieldMap(reviewTransaction, pageName);
        }

        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        if (cont != null) {
            // Added for Customization
            if (String.isNotBlank(contactId)) {
                reviewTransaction.ucinn_ascendv2__Contact__c = contactId; //Added for Authenticated User Logic
            }else{
                reviewTransaction.ucinn_ascendv2__Contact__c = cont.Id;
            }
        }

        List<Map<String, Object>> designationList = populateDesignationInformation(reviewTransaction, designations, giftType, frequency,numberOfInstallments, startDate, giftAmount);

        if (!isOneTimePaymentType(giftType)) {
            //if this is a recurring or pledge there are some special params to create the gift

            Map<String, Object> subscriptionParams = new Map<String, Object>();
            subscriptionParams.put(GIFT_TYPE, giftType);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.GATEWAY_NAME_KEY, gatewayName);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.FREQUENCY_KEY, frequency);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_KEY, numberOfInstallments);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.START_DATE_KEY, startDate);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.END_DATE_KEY, endDate);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.AMOUNT_KEY, giftAmount);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.STRIPE_BILLING_INFORMATION_KEY, stripeBillingInformation);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY, paymentId);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, cont);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.REVIEW_TRANSACTION_KEY, reviewTransaction);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.API_KEY_NAME, apiKeyName);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.ACCOUNT_ID_KEY, accountId);
            subscriptionParams.put(PORTAL_CONST_OnlineGiving.ADDTIONAL_PAYMENT_FIELDS, additionalPaymentDataMap);

            String externalId = paymentInterface.createSubscription(subscriptionParams);

            // Spreedly requires this, other payment processors don't 
            if (endDate != null && giftType == PORTAL_CONST_OnlineGiving.RECURRING_TYPE) {
                reviewTransaction.ucinn_ascendv2__Opportunity_End_Date__c = endDate;
            }
            reviewTransaction.ucinn_ascendv2__External_System_Id__c = reviewTransactionPrefix + '-' + externalId;
            reviewTransaction.ucinn_ascendv2__Transaction_ID__c = externalId;
        } else {
            params.put(PORTAL_CONST_OnlineGiving.CONTACT_KEY, cont);
            PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper responseWrapper = processOneTimePayment(params);
            reviewTransaction.ucinn_ascendv2__External_System_Id__c = reviewTransactionPrefix + '-' + responseWrapper.transactionId;
            reviewTransaction.ucinn_ascendv2__Transaction_ID__c = responseWrapper.transactionId;

            for (String field : responseWrapper.reviewTransactionFieldMap.keySet()) {
                reviewTransaction.put(field, responseWrapper.reviewTransactionFieldMap.get(field));
            }
        }

        reviewTransaction.ucinn_ascendv2__Transaction_Date__c = Date.today();

        populateGiftType(reviewTransaction, giftType, startDate, numberOfInstallments, pledgeId);

        returnMap.put(PORTAL_CONST_OnlineGiving.DESIGNATIONS_KEY, designationList);
        populateBillingInformation(reviewTransaction, billingInformation, pageName);
        populateTributeInformation(reviewTransaction, tributeInformation);
        populateAdditionalDetails(reviewTransaction, additionalDetails);
        populateMatchingCompany(reviewTransaction, matchingCompanyName, matchingCompanyId);

        ucinn_ascendv2__Interim__c newInterim = populateOrganizationalGivingInformation(reviewTransaction, billingInformation, pageName);

        // catch possible validation rule error, e.g. Cybersource end dates beyond 5 years
        // check Interim record

        if(reviewTransaction.ucinn_ascendv2__Interim__c == null) {
            reviewTransaction.Create_Interim__c = true;
            reviewTransaction.ucinn_ascendv2__Status__c = MANUAL_REVIEW;
        }
        try {
            insert reviewTransaction;
        }
        catch (DmlException e) {
            if (e.getDmlType(0) == System.StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: ' + e.getDmlMessage(0)});
            }
            else {
                throw e;
            }
        }

        try {
            sendGiftReceipt(emailTemplateName, designationList, reviewTransaction, startDate, endDate, frequency, giftAmount, newInterim);
        }
        catch (System.EmailException emailException) {
            returnMap.put(IS_EMAIL_EXCEPTION, true);
        }

        return returnMap;
    }
    public  static void validateCreateReviewTransaction(Map<String, Object> params) {
        // recaptcha token verification
        PORTAL_RecaptchaController recaptchaController = getRecaptchaController();

        /* ISUF DOES NOT USE RECAPTCHA
        if (recaptchaController.isRecaptchaTokenValid((String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN), PORTAL_RecaptchaController.PAYMENT_SUBMIT) == false) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_RecaptchaController.GOOGLE_RECAPTCHA_INVALID_MESSAGE});
        }
        */
        if (String.isBlank((String) params.get(GIFT_TYPE))) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: No gift Type was selected.'});
        }

        if (String.isBlank((String)params.get(PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY))) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: No payment found.'});
        }

        if (params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY) == null || Decimal.valueOf((String)params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)) <= 0) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: Payment Amount was negative or unspecified.'});
        }

        Boolean startExists = params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
        Boolean endExists = params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY) != null && String.isNotBlank(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)));
        if (startExists && endExists) {
            Date startDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.START_DATE_KEY)));
            Date endDate = Date.valueOf(String.valueOf(params.get(PORTAL_CONST_OnlineGiving.END_DATE_KEY)));
            if (endDate <= startDate) {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Error processing payment: Recurring gift end date must be after the start date.'});
            }
        }
    }
    public static Integer getNumberOfInstallments(Object numberOfInstallmentsObject) {

        Integer numberOfInstallments = 0;
        if (numberOfInstallmentsObject != null) {
            numberOfInstallments = Integer.valueOf(numberOfInstallmentsObject);
        }

        return numberOfInstallments;
    }
    public  static void setReviewTransactionFieldMap(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String pageName) {
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = [SELECT Active_Record_Field_Map__c FROM Portal_Page_Section_Setting__mdt WHERE Page_Name__c = :pageName AND Page_Main_Section__c = :DESIGNATION_CUSTOM_METADATA_NAME AND Order_By_Clause__c != null];
        //populates required fields such as default appeals
        if (!sectionSettingList.isEmpty()) {
            Portal_Page_Section_Setting__mdt sectionSetting = sectionSettingList.get(0);
            if (String.isNotBlank(sectionSetting.Active_Record_Field_Map__c)) {
                Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped(sectionSetting.Active_Record_Field_Map__c);
                for (String field : fieldMap.keySet()) {
                    if (field == 'ucinn_ascendv2__Campaign_External_ID__c') {
                        continue;
                    }

                    reviewTransaction.put(field, fieldMap.get(field));
                }

                // Query for default appeal information based on external id
                if (fieldMap.containsKey('ucinn_ascendv2__Campaign_External_ID__c')) {
                    String appeal = (String)fieldMap.get('ucinn_ascendv2__Campaign_External_ID__c');

                    if (String.isNotBlank(reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c)) {
                        appeal = reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c;
                    }

                    reviewTransaction.ucinn_ascendv2__Campaign_External_ID__c = appeal;
                    if (!String.isBlank(appeal)) {
                        List<Campaign> lstCampaign = [SELECT Id, ucinn_ascendv2__Motivation_Code__c FROM Campaign WHERE ucinn_ascendv2__Motivation_Code__c = :appeal];
                        if (!lstCampaign.isEmpty()) {
                            Campaign thisCampaign = lstCampaign[0];
                            reviewTransaction.put('ucinn_ascendv2__Campaign__c', thisCampaign.Id);
                        }
                    }
                }
            }
        }
    }
    public static void populateGiftType(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String giftType, Date startDate, Integer numberOfInstallments, String pledgeId) {

        if (giftType == PORTAL_CONST_OnlineGiving.RECURRING_TYPE) {
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_TRANSACTION_TYPE;
            if (startDate != null && startDate <= Date.today()) {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT_PAYMENT;
            } else {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.RECURRING_GIFT;
            }
        } else  if (giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE){
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE;
            if ( startDate != null && startDate <= Date.today()) {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_PAYMENT_TRANSACTION_TYPE;
            } else {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_TRANSACTION_TYPE;
            }

        } else if (giftType == PORTAL_CONST_PaymentHub.ONE_TIME_MEMBERSHIP_TYPE
                || giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE
                || giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE) {
            reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = giftType;
            reviewTransaction.ucinn_ascendv2__Transaction_Type__c = giftType;
            if (startDate != null && startDate <= Date.today()) {
                if (giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE) {
                    reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TRANSACTION_TYPE;
                } else if (giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE) {
                    reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TRANSACTION_TYPE;
                }
            }
        } else {
            if (String.isNotBlank(pledgeId)) {
                List<Opportunity> opportunityList = [SELECT Id FROM Opportunity WHERE ucinn_ascendv2__External_System_ID__c = :pledgeId];
                if (opportunityList != null && !opportunityList.isEmpty()) {
                    Opportunity opp = opportunityList.get(0);
                    reviewTransaction.ucinn_ascendv2__Opportunity__c = opp.Id;
                }

                reviewTransaction.ucinn_ascendv2__Opportunity_External_ID__c = pledgeId;
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE_PAYMENT;
                reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.PLEDGE;
                // appendManualReviewReason(reviewTransaction, ' User has specified that this is a pledge payment;');
            } else {
                reviewTransaction.ucinn_ascendv2__Transaction_Type__c = PORTAL_CONST_OnlineGiving.GIFT;
                reviewTransaction.ucinn_ascendv2__Opportunity_Type__c = PORTAL_CONST_OnlineGiving.OUTRIGHT;
            }

        }
    }
    public  static void populateBillingInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> billingInformation, String pageName) {
        if (billingInformation == null || billingInformation.isEmpty() || String.isBlank(pageName)) {
            return;
        }

        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            //designations can be specified on the same page section name as the billing information, so we need to skip it if it is populated
            //skip populating information on the review transaction record if trying to populate fields that go on the interim (Company_Information)
            if (sectionSetting.Page_Main_Section__c == DESIGNATION_CUSTOM_METADATA_NAME
                    || ((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c) == null
                    || sectionSetting.Page_Main_Section__c == PORTAL_OnlineGivingControllerBase.COMPANY_INFORMATION) {
                continue;
            }

            List<Object> recordsList = new List<Object>();
            if (String.isNotBlank(sectionSetting.Page_Sub_Section__c)) {
                recordsList = (List<Object>) ((Map<String, Object>)((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c)).get(sectionSetting.Page_Sub_Section__c);
            } else {
                recordsList = (List<Object>) ((Map<String, Object>)((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c)).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
            }

            //the records are in a list data structure, but there should only be one preferred record per object
            //the record is a map representation of the sobject data
            Map<String, Object> recordMap = new Map<String, Object>();
            if (recordsList != null && !recordsList.isEmpty()) {
                recordMap = (Map<String, Object>) recordsList.get(0);
            } else {
                continue;
            }
            PORTAL_UTIL_PageSectionSetting.populateRecord(reviewTransaction, recordMap, sectionSetting.Portal_Section_Field_Settings__r);
        }
    }
    public static  PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper processOneTimePayment(Map<String, Object> params) {
        PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper response = new PORTAL_PaymentHubControllerBase.PORTAL_PaymentResponseWrapper();
        return paymentInterface.createOneTimePayment(params);
    }
    public static List<Map<String, Object>> populateDesignationInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction,
            List<Object> designationList,
            String giftType,
            String frequency,
            Integer numberOfInstallments,
            Date startDate,
            Decimal giftAmount) {

        List<Map<String, Object>> returnList = new  List<Map<String, Object>>();
        Integer designationListSize;
        if (designationList == null || designationList.isEmpty()) {
            return returnList;
        } else {
            designationListSize = designationList.size();
        }
        if (startDate == null || startDate <= Date.today()) {
            startDate = Date.today();
        }
        Set<String> designationIdSet = new Set<String>();
        if(isOneTimePaymentType(giftType)) {
            totalPaidTodayAmount = giftAmount;
        }
        for (Integer index = 1; index <= designationList.size(); index++) {
            String nameSpace = PORTAL_CONST_OnlineGiving.NAMESPACE;
            if (index > 5) {
                nameSpace = '';
            }

            //Map<Object, Object> designation = (Map<Object, Object>) designationList.get(index-1);
            Map<String, Object> designation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(designationList.get(index-1)));
            Decimal desAmt = Decimal.valueOf(String.valueOf(designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)));
            reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_AMOUNT_PREFIX + index + '_1__c', desAmt);
            //need to populate installments for subscription based billing
            if (!isOneTimePaymentType(giftType)) {
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_DATE_PREFIX + index + '__c', startDate);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_FREQUENCY_PREFIX + index + '__c', frequency);
                reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.INSTALLMENT_AMOUNT_PREFIX + index+ '__c', Decimal.valueOf(String.valueOf(designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY))));
                if (giftType == PORTAL_CONST_OnlineGiving.PLEDGE_TYPE || giftType == PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE || giftType == PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE) {
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.NUMBER_OF_INSTALLMENTS_PREFIX + index + '__c', numberOfInstallments);
                    if (numberOfInstallments < 2) {
                        appendManualReviewReason(reviewTransaction, ' Installment number was less than 2;');
                    }
                    // Added for Customization - OOTB Issue.
                    if(!Test.isRunningTest()) {
                        Decimal firstAmount = (desAmt/ numberOfInstallments).setScale(2, System.RoundingMode.FLOOR) + (desAmt - ((desAmt / numberOfInstallments).setScale(2, System.RoundingMode.FLOOR) * numberOfInstallments));
                        reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_AMOUNT_PREFIX + index + '_1__c', firstAmount);
                        totalPaidTodayAmount = (giftAmount/numberOfInstallments).setScale(2, RoundingMode.FLOOR);
                        totalPaidTodayAmount = totalPaidTodayAmount + (giftAmount - (totalPaidTodayAmount * numberOfInstallments));
                    }
                }
            }
            //other designations need to go into manual review
            if (designation.get('Id') == null || String.isBlank(String.valueOf(designation.get('Id'))) || String.valueOf(designation.get('Id')) == 'Other') {
                reviewTransaction.ucinn_portal_Other_Designation_Name__c = (String) designation.get('Name');
                appendManualReviewReason(reviewTransaction, ' Other designations were specified;');
            } else {
                if (useExternalId == true) {
                    designationIdSet.add((String)designation.get('ucinn_ascendv2__External_System_ID__c'));
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.DESIGNATION_EXTERNAL_PREFIX + index + '__c', designation.get('ucinn_ascendv2__External_System_ID__c'));
                } else {
                    designationIdSet.add((String)designation.get('Id'));
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.DESIGNATION_PREFIX  + index + '__c', designation.get('Id'));
                }

            }

            reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_DATE_PREFIX + index + '_1__c', startDate);
            //reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_AMOUNT_PREFIX + index + '_1__c', Decimal.valueOf(String.valueOf(designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY))));
            returnList.add(new Map<String, Object>{'Name' => (String)designation.get('Name'), PORTAL_CONST_OnlineGiving.AMOUNT_KEY => designation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)});
        }

        String queryString = 'SELECT Id, ucinn_ascendv2__External_System_ID__c, ucinn_ascendv2__Default_Non_Gift_Amount__c, ucinn_ascendv2__Minimum_Gift_Amount__c FROM ucinn_ascendv2__Designation__c ';
        if (useExternalId == true) {
            queryString += ' WHERE ucinn_ascendv2__External_System_ID__c IN:designationIdSet';
        } else {
            queryString += ' WHERE Id IN:designationIdSet';
        }
        List<ucinn_ascendv2__Designation__c> designationQueryList = Database.query(queryString);

        for (ucinn_ascendv2__Designation__c eachDesignation : designationQueryList) {
            for (Integer index = 1; index <= designationList.size(); index++) {
                String nameSpace = PORTAL_CONST_OnlineGiving.NAMESPACE;
                if (index > 5) {
                    nameSpace = '';
                }
                //Map<Object, Object> eachSelectedDesignation = (Map<Object, Object>) designationList.get(index-1);
                Map<String, Object> eachSelectedDesignation = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(designationList.get(index-1)));

                Boolean matchedId = false;
                if (useExternalId == true && eachSelectedDesignation.get('ucinn_ascendv2__External_System_ID__c') == eachDesignation.ucinn_ascendv2__External_System_ID__c) {
                    matchedId = true;
                } else if (eachSelectedDesignation.get('Id') == eachDesignation.Id) {
                    matchedId = true;
                }

                if (matchedId) {
                    if (eachDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c != null && eachDesignation.ucinn_ascendv2__Minimum_Gift_Amount__c > Decimal.valueOf(String.valueOf(eachSelectedDesignation.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY)))) {
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'amount was less than the minimum for a designation'});
                    }
                    reviewTransaction.put(nameSpace + PORTAL_CONST_OnlineGiving.PAYMENT_NON_GIFT_AMOUNT_PREFIX + index + '_1__c', eachDesignation.ucinn_ascendv2__Default_Non_Gift_Amount__c);
                }
            }
        }

        return returnList;
    }
    public static Boolean isOneTimePaymentType(String giftType) {
        return (giftType != PORTAL_CONST_OnlineGiving.RECURRING_TYPE
                && giftType != PORTAL_CONST_OnlineGiving.PLEDGE_TYPE
                && giftType != PORTAL_CONST_PaymentHub.AUTO_RENEWING_MEMBERSHIP_TYPE
                && giftType != PORTAL_CONST_PaymentHub.INSTALLMENT_BASED_MEMBERSHIP_TYPE);
    }
    public static void populateTributeInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> tributeInformation) {
        Set<String> tributeFieldSet = getTributeFieldSet();

        if (tributeInformation != null && !tributeInformation.isEmpty()) {
            for (String field : tributeInformation.keySet()) {
                if (tributeFieldSet.contains(field)) {
                    reviewTransaction.put(field, tributeInformation.get(field));
                }
            }
        }
    }
    public static void populateAdditionalDetails(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, List<Object> additionalDetailsList) {
        if (additionalDetailsList != null && !additionalDetailsList.isEmpty()) {
            Map<String, Object> idToValueMap = new Map<String, Object>();
            Set<String> customFormFieldIdSet = new Set<String>();
            for (Object additionalDetail : additionalDetailsList) {
                Map<String, Object> additionalDetailMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(additionalDetail));
                if (String.isNotBlank((String)additionalDetailMap.get('Id'))) {
                    customFormFieldIdSet.add((String)additionalDetailMap.get('Id'));
                    idToValueMap.put((String)additionalDetailMap.get('Id'), additionalDetailMap.get('value'));
                }
            }
            if (!customFormFieldIdSet.isEmpty()) {
                List<ucinn_portal_Custom_Form_Field__c> customFormFields = [SELECT Id, SObject_API_Name__c, Field_API_Name__c FROM ucinn_portal_Custom_Form_Field__c WHERE Id IN :customFormFieldIdSet];
                if (customFormFields != null && !customFormFields.isEmpty()) {
                    for (ucinn_portal_Custom_Form_Field__c field : customFormFields) {
                        if (String.isNotBlank(field.Field_API_Name__c)) {
                            try {
                                reviewTransaction.put(field.Field_API_Name__c, idToValueMap.get(String.valueOf(field.Id)));
                            } catch (Exception e) {
                                appendManualReviewReason(reviewTransaction, ' Could not find field ' + field.Field_API_Name__c + ' and user inputted ' +
                                        idToValueMap.get(String.valueOf(field.Id)) + '; ');
                            }
                        }
                    }
                }
            }
        }
    }
    public static void appendManualReviewReason(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String reason) {
        if (String.isNotBlank(reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c)) {
            reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c = reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c + reason;
        } else {
            reviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c = reason;
        }
    }
    public static void sendGiftReceipt(String emailTemplateName, List<Map<String, Object>> designationList, ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Date startDate, Date endDate, String frequency, Decimal totalAmount, ucinn_ascendv2__Interim__c interimRecord) {
        List<EmailTemplate> templateList = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :emailTemplateName];

        if (!templateList.isEmpty()) {
            EmailTemplate emailTemplate = templateList[0];

            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String subject = emailTemplate.Subject;
            String htmlBody = emailTemplate.HtmlValue;

            String designationDetailHtml = '';

            for (Map<String, Object> eachDesig: designationList) {
                String eachDesigRow = '<tr>'
                        + '<td style="padding:20px 10px 20px 0;font-weight:500;letter-spacing:-0.2px;line-height:26px;font-family:&#39;Fira Sans&#39;,Helvetica,Arial,sans-serif;font-size:16px;border-bottom:1px solid #e5e5e5" valign="top">'
                        + eachDesig.get('Name') + '</td>'
                        + '<td style="padding:20px 10px 20px 0;color:#9b9b9b;letter-spacing:-0.2px;line-height:26px;font-family:&#39;Fira Sans&#39;,Helvetica,Arial,sans-serif;font-size:16px;border-bottom:1px solid #e5e5e5" valign="top" align="right"></td>'
                        + '<td style="padding:20px 0;letter-spacing:-0.2px;line-height:26px;font-family:&#39;Fira Sans&#39;,Helvetica,Arial,sans-serif;font-size:16px;border-bottom:1px solid #e5e5e5;color:#151515" valign="top" align="right">'
                        + '$' + eachDesig.get('amount') + '</td>'
                        + '</tr>';

                designationDetailHtml += eachDesigRow;
            }

            String addressString = '';
            if(String.isNotBlank(reviewTransaction.ucinn_ascendv2__First_Name__c)) {
                addressString += reviewTransaction.ucinn_ascendv2__First_Name__c + ' ';
            }
            if(String.isNotBlank(reviewTransaction.ucinn_ascendv2__Last_Name__c)) {
                addressString += reviewTransaction.ucinn_ascendv2__Last_Name__c;
            }
            if(!String.isEmpty(addressString)) {
                addressString += '<br>';
            }

            htmlBody = htmlBody.replace('{!amountPaidTotal}', '$' + String.valueOf(totalAmount));
            htmlBody = htmlBody.replace('{!designationList}', designationDetailHtml);
            htmlBody = htmlBody.replace('{!totalPaidToday}', '$' + String.valueOf(totalPaidTodayAmount != null ? totalPaidTodayAmount : 0));
            htmlBody = htmlBody.replace('{!address}', addressString);
            if (startDate == null) {
                startDate = Date.today();
            }
            String endDateString = '';
            if (endDate != null) {
                endDateString = ' - ' + endDate.format();
            }
            htmlBody = htmlBody.replace('{!dateOfGift}', startDate.format() + endDateString);

            if (String.isBlank(frequency)) {
                htmlBody = htmlBody.replace('{!frequency}', PORTAL_CONST_PaymentHub.ONE_TIME_FREQUENCY);
            } else {
                htmlBody = htmlBody.replace('{!frequency}', frequency);
            }

            String emailInUse = '';
            if (String.isNotBlank(reviewTransaction.ucinn_ascendv2__Email_1__c)) {
                emailInUse = reviewTransaction.ucinn_ascendv2__Email_1__c;
            } else if (String.isNotBlank(interimRecord?.ucinn_ascendv2__Organization_Email_1__c)) {
                emailInUse = interimRecord?.ucinn_ascendv2__Organization_Email_1__c;
            } else if (String.isNotBlank(interimRecord?.ucinn_ascendv2__Email_1__c)) {
                emailInUse = interimRecord?.ucinn_ascendv2__Email_1__c;
            }

            mail.setOrgWideEmailAddressId(System.Label.ISUF_Email);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mail.setToAddresses(new String[]{emailInUse});
            mail.saveAsActivity = false;
            mailList.add(mail);
            if (!Test.isRunningTest()) {
                Messaging.sendEmail(mailList);
            }

        }
    }
    public static  PORTAL_RecaptchaController getRecaptchaController() {
        return new PORTAL_RecaptchaController();
    }
    public static ucinn_ascendv2__Interim__c populateOrganizationalGivingInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> billingInformation, String pageName) {
        Map<String, Object> companyInfoMap = new Map<String, Object>();
        if (billingInformation == null || billingInformation.isEmpty() || !billingInformation.containsKey(IS_GIVING_AS_ORG) || Boolean.valueOf(billingInformation.get(IS_GIVING_AS_ORG)) == false || String.isBlank(pageName)) {
            return null;
        }
        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, PORTAL_OnlineGivingControllerBase.COMPANY_INFORMATION, PORTAL_OnlineGivingControllerBase.COMPANY);

        ucinn_ascendv2__Interim__c newInterim = new ucinn_ascendv2__Interim__c();
        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {
            List<Object> recordsList = (List<Object>) ((Map<String, Object>)((Map<String, Object>)billingInformation.get(RECORDS)).get(sectionSetting.Page_Main_Section__c)).get(sectionSetting.Page_Sub_Section__c);

            //the records are in a list data structure, but there should only be one preferred record per object
            //the record is a map representation of the sobject data
            Map<String, Object> recordMap = new Map<String, Object>();
            if (recordsList != null && !recordsList.isEmpty()) {
                recordMap = (Map<String, Object>) recordsList.get(0);
            } else {
                continue;
            }
            if(Boolean.valueOf(billingInformation.get(IS_GIVING_AS_ORG)) == true) {
                companyInfoMap = (Map<String, Object>) recordMap.get('ucinn_ascendv2__Account__r');
            }
            PORTAL_UTIL_PageSectionSetting.populateRecord(newInterim, recordMap, sectionSetting.Portal_Section_Field_Settings__r);
        }

        newInterim.ucinn_ascendv2__Status__c = MANUAL_REVIEW;
        newInterim.RecordTypeId = reviewTransaction.Interim_Record_Type_ID__c;
        newInterim.ucinn_ascendv2__External_System_ID__c = interimPrefix + '-' +reviewTransaction.ucinn_ascendv2__External_System_ID__c;
        insert newInterim;
        reviewTransaction.ucinn_ascendv2__Interim__c = newInterim.Id;
        reviewTransaction.ucinn_ascendv2__Status__c = MANUAL_REVIEW;
        reviewTransaction.ucinn_ascendv2__Organization_Name__c = (String) companyInfoMap.get('Name');
        appendManualReviewReason(reviewTransaction, USER_SPECIFIED_ORGANIZATIONAL_GIFT);

        return newInterim;
    }
    public static void populateMatchingCompany(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, String matchingCompanyName, String matchingCompanyId) {

        if (String.isNotBlank(matchingCompanyName)) {
            //if there is a company id, the hep integration was used
            if (String.isNotBlank(matchingCompanyId)) {
                reviewTransaction.ucinn_portal_HEP_Company_Id__c = matchingCompanyId;
                reviewTransaction.ucinn_portal_HEP_Company_Name__c = matchingCompanyName;
            } else {
                reviewTransaction.ucinn_portal_Matching_Company_Name__c = matchingCompanyName;
            }
            appendManualReviewReason(reviewTransaction, ' There is a matching company for this gift;');
        }

    }
    public static Set<String> getTributeFieldSet() {
        return new Set<String>{'ucinn_ascendv2__Tribute_Type_1__c',
                'ucinn_ascendv2__In_Memory_Honor_First_Name_1__c',
                'ucinn_ascendv2__In_Memory_Honor_Last_Name_1__c',
                'ucinn_ascendv2__Notify_First_Name_1__c',
                'ucinn_ascendv2__Notify_Last_Name_1__c',
                'ucinn_ascendv2__Notify_Address_Line_1_1__c',
                'ucinn_ascendv2__Notify_Address_Line_2_1__c',
                'ucinn_ascendv2__Notify_City_1__c',
                'ucinn_ascendv2__Notify_State_1__c',
                'ucinn_ascendv2__Notify_Postal_Code_1__c'};
    }


}