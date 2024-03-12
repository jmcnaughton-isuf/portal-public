/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Controller class for Double the Donation integration
 *
 * @author  Isaiah Rodriguez, Jacob Huang
 * @version 1.0
 * @since   1.0
 */

public with sharing virtual class PORTAL_DoubleTheDonationController {
    private static String publicKey;


    public static final String DOUBLE_THE_DONATION_API_KEY_PUBLIC = 'Double_The_Donation_API_Key_Public';
    public static final String BASE_URL = 'callout:dtd__double_the_donation_api/';
    public static final String REGISTER_DONATION_ENDPOINT = 'api/360matchpro/v1/register_donation';
    public static final String DONATION_IDENTIFIER = 'donation_identifier';
    public static final String MATCHED_COMPANY = 'matched-company';
    public static final String RATIO_CONST = 'ratio';
    public static final String ORGANIZATION_INTERIM_EXTERNAL_ID_PREFIX = 'ORGN';
    public static final String CONFIRMED_CONST = 'Confirmed';
    public static final String COMPANY_NAME = 'company_name';
    public static final String ID_CONST = 'id';
    public static final String CORPORATE_CONTACT_EMAIL = 'corporate_contact_email';
    public static final String CORPORATE_CONTACT_PHONE = 'corporate_contact_phone';
    public static final String MINIMUM_MATCHED_AMOUNT = 'minimum_matched_amount';
    public static final String MAXIMUM_MATCHED_AMOUNT = 'maximum_matched_amount';

    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String EMAIL_ADDRESS = 'emailAddress';
    public static final String ADDRESS_LINE_1 = 'addressLine1';
    public static final String ADDRESS_LINE_2 = 'addressLine2';
    public static final String ADDRESS_CITY = 'addressCity';
    public static final String ADDRESS_STATE = 'addressState';
    public static final String ADDRESS_POSTAL_CODE = 'addressPostalCode';
    public static final String ADDRESS_COUNTRY = 'addressCountry';
    public static final String PHONE_NUMBER = 'phoneNumber';
    public static final String FRONT_END_DATA = 'frontEndData';
    public static final String STAGING_RECORD_FIELD_NAME = 'stagingRecordFieldName';

    /**
     * Basic inner class, purpose is to return multiple values to the caller.
     * Fields: 
     *      donationIdentifier      Double the Donation gift identifier
     *      organizationInterim     Interim for an organization with data from the DTD callout response, not inserted yet
     * 
     * @author: Jacob Huang
     * @since: 1.0
     */
    public class PORTAL_DTDResponseWrapper {
        public String donationIdentifier;
        public ucinn_ascendv2__Interim__c organizationInterim;
        public Boolean isAutoMatch;
    }

    /**
     * Performs a callout to register a donation in 360MatchPro (by Double the Donation) and returns donation identifier
     * 
     * @author: Isaiah Rodriguez, Jacob Huang
     * @since: 1.0
     * 
     * @param matchingCompanyId             String: DTD id for a gift-matching company
     * @param dtdBillingInformation         Map<String, Object>: user inputted billing information details
     * @param amount                        Decimal: gift amount
     * @param transactionDate               Date: date of gift transaction
     * @param campaignName                  String: name of campaign
     * @param externalDonationIdentifier    String: potential pre-generated identifier to use
     *
     * @return                      Donation identifier generated for DTD donation creation, any error during the process will return null
     */
    public virtual PORTAL_DTDResponseWrapper createDonationInDtd(Map<String, Object> params) {
        PORTAL_DTDResponseWrapper responseWrapper = new PORTAL_DTDResponseWrapper();
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setEndpoint(BASE_URL + REGISTER_DONATION_ENDPOINT);
        request.setMethod('POST');
        
        String body = buildRegisterPaymentCalloutBody(params);
        if (String.isBlank(body)) {
            return responseWrapper;
        }
        request.setBody(body);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            return responseWrapper;
        }

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseWrapper.organizationInterim = createOrganizationInterim(responseMap);
        responseWrapper.donationIdentifier = (String) responseMap?.get(DONATION_IDENTIFIER);
        responseWrapper.isAutoMatch = this.getIsAutoMatch((Map<String, Object>)responseMap?.get(MATCHED_COMPANY), (String)params?.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID));

        return responseWrapper;
    }

    /**
     * Determines whether DTD has auto match enabled based on if the HTTP callout returns a matched company
     * and the matchingCompanyId from the front end is blank.
     * 
     * @author: Todd Shinto
     * @since: 1.17
     * 
     * @param matchingCompanyId             String: DTD id for a gift-matching company
     * @param matchedCompany                Map<String, Object>: a map of the matched company returned from DTD
     *
     * @return                              Boolean indicating whether auto matching is enabled in DTD
     */
    private Boolean getIsAutoMatch(Map<String, Object> matchedCompany, String matchingCompanyId) {
        if ((matchedCompany != null || matchedCompany?.isEmpty() == false) && String.isBlank(matchingCompanyId)) {
            return true;
        }

        return false;
    }

    /**
     * Validate the arguments passed in to create/register a gift with Double the Donation
     * 
     * @author: Jacob Huang
     * @since: 1.0
     * 
     * @param matchingCompanyId             String: DTD id for a gift-matching company
     * @param dtdBillingInformation         Map<String, Object>: user inputted billing information details
     * @param amount                        Decimal: gift amount
     * @param transactionDate               Date: date of gift transaction
     * @param campaignName                   String: name of campaign
     * @param externalDonationIdentifier    String: potential pre-generated identifier to use
     *
     * @return                      true if the arguments are valid
     */
    protected virtual Boolean validateCreateDonationParams(Map<String, Object> params) {
        String campaignName = (String) params?.get(PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME);
        String matchingCompanyId = (String) params?.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID);

        // check required parameters for DTD
        if (String.isBlank(getDtdPublicKey()) || String.isBlank(campaignName)) {
            System.debug('Missing required parameter for DTD donation creation.');
            return false;
        }

        Map<String, Object> dtdBillingInformation = (Map<String, Object>) params?.get(PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION);
        String firstName = (String) dtdBillingInformation?.get(FIRST_NAME);
        String lastName = (String) dtdBillingInformation?.get(LAST_NAME);
        String emailAddress = (String) dtdBillingInformation?.get(EMAIL_ADDRESS);
        Decimal paymentAmount = (Decimal) params?.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY);

        // check recommended parameters for DTD, ascend requires these
        if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(emailAddress) || paymentAmount == null) {
            System.debug('Missing recommended parameter for DTD donation creation.');
            return false;
        }

        return true;
    }

    /**
     * Build json body for registering a gift with Double the Donation
     * 
     * @author: Isaiah Rodriguez, Jacob Huang
     * @since: 1.0
     *
     * @param matchingCompanyId             String: DTD id for a gift-matching company
     * @param dtdBillingInformation         Map<String, Object>: user inputted billing information details
     * @param amount                        Decimal: gift amount
     * @param transactionDate               Date: date of gift transaction
     * @param campaignname                  String: name of campaign
     * @param externalDonationIdentifier    String: potential pre-generated identifier to use
     *
     * @return                      Body of request
     */
    protected virtual String buildRegisterPaymentCalloutBody(Map<String, Object> params) {
        if (validateCreateDonationParams(params) != true) {
            return null;
        }

        Map<String, Object> dtdBillingInformation = (Map<String, Object>) params.get(PORTAL_CONST_OnlineGiving.DTD_BILLING_INFORMATION);
        Date donationDate = (Date) params.get(PORTAL_CONST_OnlineGiving.TRANSACTION_DATE);
        String donationDateString = donationDate == null ? Date.today().format() : donationDate.format();

        String donationIdentifier = (String)params.get(PORTAL_CONST_OnlineGiving.EXTERNAL_DONATION_IDENTIFIER);
        donationIdentifier = String.isNotBlank(donationIdentifier) ? donationIdentifier : String.valueOf(DateTime.now().getTime()) + Math.abs(Crypto.getRandomInteger());

        // Build body using payment fields
        String body = JSON.serialize(new Map<String,Object> {
            '360matchpro_public_key'=> getDtdPublicKey(),
            'doublethedonation_company_id'=> params.get(PORTAL_CONST_OnlineGiving.MATCHING_COMPANY_ID),
            'campaign'=> params.get(PORTAL_CONST_OnlineGiving.CAMPAIGN_NAME),
            'donation_identifier'=> donationIdentifier,
            'donor_first_name'=> dtdBillingInformation.get(FIRST_NAME),
            'donor_last_name'=> dtdBillingInformation.get(LAST_NAME),
            'donation_amount'=> params.get(PORTAL_CONST_OnlineGiving.AMOUNT_KEY),
            'donor_email'=> dtdBillingInformation.get(EMAIL_ADDRESS),
            'donation_datetime'=> donationDateString,
            'donor_address'=> new Map<String,Object> {
                'address1'=> dtdBillingInformation.get(ADDRESS_LINE_1),
                'address2'=> dtdBillingInformation.get(ADDRESS_LINE_2),
                'city'=> dtdBillingInformation.get(ADDRESS_CITY),
                'state'=> dtdBillingInformation.get(ADDRESS_STATE),
                'zip'=> dtdBillingInformation.get(ADDRESS_POSTAL_CODE),
                'country'=> dtdBillingInformation.get(ADDRESS_COUNTRY)
            },
            'donor_phone'=> dtdBillingInformation.get(PHONE_NUMBER)
        });

        return body;
    }

    /**
     * Get the public key for Double the Donation
     * 
     * @author: Isaiah Rodriguez
     * @since: 1.0
     * 
     * @return public key as a String, null if not found 
     */
    protected virtual String getDtdPublicKey() {
        if (String.isNotBlank(PORTAL_DoubleTheDonationController.publicKey)) {
            return PORTAL_DoubleTheDonationController.publicKey;
        }

        List<ucinn_ascendv2__External_API_Credential__mdt> externalApiCredentialList = [SELECT ucinn_ascendv2__Value__c
                                                                                        FROM ucinn_ascendv2__External_API_Credential__mdt
                                                                                        WHERE DeveloperName = :DOUBLE_THE_DONATION_API_KEY_PUBLIC];

        if (externalApiCredentialList == null || externalApiCredentialList.isEmpty()) {
            System.debug('External Api Credential not found: Double_The_Donation_API_Key_Public.');
            return null;
        }

        PORTAL_DoubleTheDonationController.publicKey = Test.isRunningTest() ? 'testKey' : externalApiCredentialList.get(0)?.ucinn_ascendv2__Value__c;
        return PORTAL_DoubleTheDonationController.publicKey;
    }

    /**
     * Use DTD info about a company to make an organizational interim (no insert)
     *
     * @author Jacob Huang
     * @since 1.0
     *
     * @param responseMap           Map<String, Object> response map received from DTD callout
     * 
     * @return ucinn_ascendv2__Interim__c with info from DTD callout
     */
    @testVisible
    protected virtual ucinn_ascendv2__Interim__c createOrganizationInterim(Map<String, Object> responseMap) {
        Map<String, Object> companyInfo = (Map<String, Object>) responseMap?.get(MATCHED_COMPANY);
        String donationIdentifier = (String) responseMap?.get(DONATION_IDENTIFIER);
        if (responseMap == null || companyInfo == null || String.isBlank(donationIdentifier)) {
            return null;
        }

        ucinn_ascendv2__Interim__c organizationInterim = new ucinn_ascendv2__Interim__c(
            ucinn_ascendv2__External_System_Id__c = ORGANIZATION_INTERIM_EXTERNAL_ID_PREFIX + '-' + donationIdentifier,
            ucinn_portal_DTD_Matching_Status__c = CONFIRMED_CONST,
            ucinn_ascendv2__Organization_Name__c = (String) companyInfo.get(COMPANY_NAME),
            ucinn_portal_Double_the_Donation_ID__c = (Integer) companyInfo.get(ID_CONST),
            ucinn_ascendv2__Organization_Email_1__c = (String) companyInfo.get(CORPORATE_CONTACT_EMAIL),
            ucinn_ascendv2__Organization_Phone_1__c = (String) companyInfo.get(CORPORATE_CONTACT_PHONE),
            ucinn_portal_Min_Amount_Matched__c = (Decimal) companyInfo.get(MINIMUM_MATCHED_AMOUNT),
            ucinn_portal_Max_Amount_Matched__c = (Decimal) companyInfo.get(MAXIMUM_MATCHED_AMOUNT),
            ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl()
        );

        try {
            // String of form '1:1', '2:1', '0.5:1', etc., ascend code also notes it can be 'Up to 2:1'
            List<String> ratioColonSeparated = ((String) companyInfo.get(RATIO_CONST))?.split(':');
            if (ratioColonSeparated?.size() > 1) {
                List<String> ratioSpaceSeparated = ratioColonSeparated[0].split(' ');
                organizationInterim.ucinn_ascendv2__Organization_Matching_Ratio__c = Decimal.valueOf(ratioSpaceSeparated[ratioSpaceSeparated.size() - 1]);
            }
        }
        catch (Exception e) {
            System.debug('Invalid matching ratio');
        }

        return organizationInterim;
    }
}