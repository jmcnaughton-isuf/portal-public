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
 * controller class for lwcs that will change user data
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */

public with sharing class PORTAL_CommunityUserController {
    public static final String ERROR_MESSAGE_NO_USER_FOUND = 'There is no user associated with that email.';

   /**
    * method that gets the data that tells us how to display a user form
    * on the front end from the custom metadata records for that page
    *
    *
    * @param pageName                    the name of the page we are trying to display
    *
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    * @return                           the map of front end id to display information
    */

    @AuraEnabled
    public static Map<String, Map<String, Object>> SERVER_getFrontEndDataMap(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            return controller.getFrontEndDataMap(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }


    /**
    * method that inserts an interim based on data that was inputted
    * by the user who is trying to create a portal account
    *
    *
    * @param interim                    the map that represents the interim
    * @param degree                     the degree value for the degree field on the degree information
    * @param degreeYear                 the conferred degree year value for the degree information
    * @param interimSourceUrl           Relative Url that this request was sent from
    * @param recaptchaToken             The client side recaptcha token to be verified
    * @param emailTemplateDeveloperName String: developer name of new user registration email template
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    */
    @AuraEnabled
    public static void SERVER_submitNewUserApplication(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            controller.submitNewUserApplication(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem submitting your application.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
    * method that inserts an interim and interim employment based on data that was inputted
    * by the user who is trying to create a hiring manager account
    *
    *
    * @param data                    the map that holds the interim and interim employment data
    * @param interimSourceUrl           Relative Url that this request was sent from
    * @param recaptchaToken             The client side recaptcha token to be verified
    * @param emailTemplateDeveloperName String: developer name of new user registration email template
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    */
    @AuraEnabled
    public static void SERVER_submitHiringManagerApplication(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            controller.submitHiringManagerApplication(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem submitting your application',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
    * method that gets picklist values for a page to display on the front end
    *
    *
    * @param pageName                    the page that we need picklist values for
    *
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    * @return                            the map of front end field id to picklist values
    */

    @AuraEnabled
    public static Map<String, List<Map<String, Object>>> SERVER_getPicklists(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            return controller.getPicklists(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
    * method that gets the user's email and username to display
    * on the account management page
    *
    *
    *
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    * @return                            the user record for the logged in user
    */

    @AuraEnabled
    public static User SERVER_getUserData(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            return controller.getUserData(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving your account information.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
    * method that resets the users password
    *
    *
    * @param oldPassword                the user's old password
    * @param newPassword                the user's new password
    * @param passwordConfirmation       the new password that was typed again as confirmation
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    *
    */

    @AuraEnabled
    public static void SERVER_changePassword(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            controller.changePassword(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem changing your password.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
    * method that changes a user's email
    *
    *
    * @param email                      the new email the user wants to change to
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    * @return                            the user record for the logged in user
    */

    @AuraEnabled
    public static User SERVER_changeEmail(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            return controller.changeEmail(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem changing your email.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }


     /**
    * method that changes a user's username
    *
    *
    * @param username                    the new username the user wants to change to
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    * @return                            the user record for the logged in user
    */

    @AuraEnabled
    public static User SERVER_changeUsername(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            return controller.changeUsername(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem changing your username.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
    * method that creates a user from an interim
    *
    *
    * @param interimId                  the id for the interim we are trying to create a user for
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    */

    @AuraEnabled
    public static void SERVER_createUserFromInterim(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            controller.createUser(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem creating the user.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Tries to find a user based on email.  If one is found, send username to the user's email address.
     *
     *
     * @param emailAddress                String: The email address to use to query a user.
     * @param emailTemplateDeveloperName  String: The developer name of the email template to use when sending email.
     * @param recaptchaToken              The client side recaptcha token to be verified
     *
     * @author: Todd Shinto
     * @since: 1.11
     *
    */
    @AuraEnabled
    public static void SERVER_sendUsernameToEmail(Map<String, Object> params){
        try {
            PORTAL_CommunityUserControllerBase controller = (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getControllerFactory().getCommunityUserController();
            controller.sendUsernameToEmail(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_NO_USER_FOUND,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }
}