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
 * controller class surrounding recaptcha features
 *
 * @author      Sean Tang
 * @version 1.0
 * @since   1.0
 */

public with sharing virtual class PORTAL_RecaptchaController {
    public static final String SITE_API_KEY_DEVELOPER_NAME = 'Google_reCAPTCHA_Site_Key';
    public static final String SECRET_API_KEY_DEVELOPER_NAME = 'Google_reCAPTCHA_Secret_Key';
    public static final String RECAPTCHA_V3_REJECTING_SCORE_DEVELOPER_NAME = 'Google_reCAPTCHA_Rejecting_Score';
    public static final String RECAPTCHA_OPTION_DEVELOPER_NAME = 'Google_reCAPTCHA_Option';
    public static final String RECAPTCHA_MISSING_ERROR_MESSAGE = 'Missing Recaptcha Option.';
    public static final String RECAPTCHA_OPTION_NONE_OPTION = 'None';
    public static final String GOOGLE_RECAPTCHA_VERIFY_ENDPOINT = 'https://www.google.com/recaptcha/api/siteverify';
    public static final String RECAPTCHA_TOKEN = 'recaptchaToken';
    public static final String GOOGLE_RECAPTCHA_INVALID_MESSAGE = 'Something went wrong with your reCAPTCHA verification, please contact an Administrator';
    public static final String FORM_SUBMIT = 'form_submit';
    public static final String SUCCESS_CONST = 'success';
    public static final String SCORE_CONST = 'score';
    public static final String ACTION_CONST = 'action';
    public static final String POST_CONST = 'POST';
    public static final String SECRET_CONST = 'secret=';
    public static final String RESPONSE_CONST = '&response=';
    public static final Decimal RECAPTCHA_V3_LOWEST_SCORE = 0.0;
    public static final Decimal RECAPTCHA_V3_HIGHEST_SCORE = 1.0;
    public static final String CLASS_FUNCTION_NAME = 'classFunctionName';

    protected List<String> classesWithRecaptchaEnabledList;

    /**
     * Return the recaptcha display option
     * 
     * @author Sean Tang
     * @since  1.0
     * 
     * @return      recaptcha display option as a string
     */
    public virtual String getRecaptchaOption() {
        String recaptchaOption = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => RECAPTCHA_OPTION_DEVELOPER_NAME});

        if (String.isBlank(recaptchaOption)) {
            return RECAPTCHA_OPTION_NONE_OPTION;
        }

        return recaptchaOption;
    }

    /**
     * Check if recaptcha is enabled for specific LWC by checking if the base apex class/function exists in the list
     * Example string: PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction
     * 
     * @author  Phillip Nguyen
     * @since   1.2
     * 
     * @param classFunctionName     String of the base class function name
     * 
     * @return                      Boolean, whether recaptcha is enabled
     */
    public virtual Boolean getIsRecaptchaEnabled(Map<String, Object> params) {
        String classFunctionName = (String)params?.get(CLASS_FUNCTION_NAME);

        if (String.isBlank(classFunctionName)) {
            return false;
        }

        // Retrieve org settings from custom metadata
        String recaptchaOption = this.getRecaptchaOption();
        
        if (recaptchaOption?.equalsIgnoreCase(RECAPTCHA_OPTION_NONE_OPTION) != false) {
            return false;
        }

        classesWithRecaptchaEnabledList = getClassesWithRecaptchaEnabled();
        return classesWithRecaptchaEnabledList?.contains(classFunctionName);
    }

    /**
     * Overridable function that contains list of strings of class functions 
     * i.e. PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction
     * 
     * @author  Phillip Nguyen
     * @since   1.2
     * 
     * @return List of strings of class functions
     */
    protected virtual List<String> getClassesWithRecaptchaEnabled() {
        if (classesWithRecaptchaEnabledList == null || classesWithRecaptchaEnabledList.isEmpty()) {
            classesWithRecaptchaEnabledList = new List<String>{
                'PORTAL_ShoppingCartControllerBase.eventPaymentCheckout',
                'PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction',
                'PORTAL_MembershipControllerBase.createReviewTransaction',
                'PORTAL_RecaptchaController.verifyRecaptchaToken'
            };
        }

        return classesWithRecaptchaEnabledList;
    }

    /**
    * Method that returns the site (public) key for Recaptcha from
    * Custom Metadata
    *
    * @author:                                 Sean Tang
    * @since:                                  1.0
    *
    * @return                                  recaptcha site key as string
    */
    @TestVisible
    protected virtual String getSiteKey() {
        return PORTAL_Utils.getSecureMetadata(SITE_API_KEY_DEVELOPER_NAME);
    }
    
    /**
    * Method that returns the secret key for Recaptcha from
    * Custom Metadata
    *
    * @author:                                 Sean Tang
    * @since:                                  1.0
    *
    * @return                                  recaptcha secret key as string
    */
    @TestVisible
    protected virtual String getSecretKey() {
        return PORTAL_Utils.getSecureMetadata(SECRET_API_KEY_DEVELOPER_NAME);
    }
    
    /**
    * Method that returns the rejecting score for Recaptcha v3 from
    * Custom Metadata, returns lowest possible score if value is empty
    * And returns highest possible score if value is any higher than that
    *
    * @author:                                 Sean Tang
    * @since:                                  1.0
    *
    * @return                                  recaptcha rejecting score as decimal
    */
    @TestVisible
    protected virtual Decimal getRejectingScore() {
        String rejectingScore = PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => RECAPTCHA_V3_REJECTING_SCORE_DEVELOPER_NAME});

        if (String.isBlank(rejectingScore)) {
            return RECAPTCHA_V3_LOWEST_SCORE;
        }

        Decimal rejectingScoreDecimalValue = Decimal.valueOf(rejectingScore);

        return Math.min(rejectingScoreDecimalValue, RECAPTCHA_V3_HIGHEST_SCORE);
    }

    /**
    * Method that makes the http request for recaptcha server verification
    *
    * @author:                                 Sean Tang
    * @since:                                  1.0
    *
    * @param recaptchaToken:       The client side recaptcha token to be verified
    * @param action:               The client side action submitted with the recaptcha request (only checked while for v3 result)
    *
    * @return                                  result of verification as boolean
    */
    @TestVisible
    protected virtual Boolean isRecaptchaRequestVerified(String recaptchaToken, String action) {
        String recaptchaSecretKey = this.getSecretKey();

        // https://developers.google.com/recaptcha/docs/verify#api-request
        // google's doc on server side verification

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(GOOGLE_RECAPTCHA_VERIFY_ENDPOINT);
        request.setMethod(POST_CONST);
        String body = SECRET_CONST + recaptchaSecretKey + RESPONSE_CONST + recaptchaToken;
        request.setBody(body);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            return false;
        }

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        if (result == null || result.isEmpty()) {
            return false;
        }

        // Check JSON result, content format in google's doc
        if (result.get(SUCCESS_CONST) == true) {
            // Check for v2 case, which does not have a score
            if (result.containsKey(SCORE_CONST) == false) {
                return true;
            }

            // Check for v3, that action name matches and score is sufficient
            if (result.get(ACTION_CONST) == action && (Decimal)result.get(SCORE_CONST) >= this.getRejectingScore()) {
                return true;
            }
        }

        return false;
    }

    /**
     *
     * @author:                 Sean Tang
     * @since:                  1.0
     *
     * @param recaptchaToken:       The client side recaptcha token to be verified
     * @param action:               The client side action submitted with the recaptcha request
     *
     * @return                      Boolean value for the status of recaptcha verification
     */
    public virtual Boolean isRecaptchaTokenValid(String recaptchaToken, String action) {
        // Retrieve org settings from custom metadata
        String recaptchaOption = this.getRecaptchaOption();
        
        // if recaptcha option is none or when running test, return true
        if (recaptchaOption?.equalsIgnoreCase(RECAPTCHA_OPTION_NONE_OPTION) != false || Test.isRunningTest()) {
            return true;
        }
        
        // if token is empty, and recaptcha option wasn't none
        if (String.isBlank(recaptchaToken)) {
            return false;
        }
        
        return this.isRecaptchaRequestVerified(recaptchaToken, action);
    }

    /**
     * Verifies if recaptcha token is valid. If not valid, throws error
     * 
     * @author Phillip Nguyen
     * @since  1.2
     * 
     * @param classFunctionName          Name of class function to verify recaptcha i.e. PORTAL_OnlineGivingController.SERVER_createReviewTransaction
     * @param recaptchaToken             The client side recaptcha token to be verified
     */
    public virtual void verifyRecaptcha(String classFunctionName, String recaptchaToken) {        
        if (this.getIsRecaptchaEnabled(new Map<String, Object>{CLASS_FUNCTION_NAME => classFunctionName}) == true && this.isRecaptchaTokenValid(recaptchaToken, FORM_SUBMIT) != true) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GOOGLE_RECAPTCHA_INVALID_MESSAGE});
        }
    }

    /**
     * Verifies if recaptcha token is valid. If not valid, throws error
     * This method exists to match existing structure of base controllers passing their own method name
     * 
     * @author Jacob Huang
     * @since 1.3
     * 
     * @param recaptchaToken             The client side recaptcha token to be verified
     */
    public virtual void verifyRecaptchaToken(Map<String, Object> params) {
        verifyRecaptcha('PORTAL_RecaptchaController.verifyRecaptchaToken', (String)params?.get(RECAPTCHA_TOKEN));
    }
    
    public String siteKey {
        get {
            return this.getSiteKey();
        }
        set;
    }

    public String lexOrigin {
        get {
            return PORTAL_CommunityUtils.constructOrigin();
        }
        set;
    }
}