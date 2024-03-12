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


public virtual without sharing class PORTAL_CommunityUserControllerBase {

    public static String HIRING_MANAGER_CASE_GROUP_NAME = 'Portal Hiring Manager Request';
    public static String LOGIN_CASE_GROUP_NAME = 'Portal Login Request';
    public static String ERROR_MESSAGE_DUPLICATE_USERNAME = 'This username already exists. Please choose a new username.';
    public static final String ERROR_MESSAGE_INVALID_USERNAME = 'Username must be in the form of an email address (eg. \"john@acme.com\")';
    public static final String ERROR_MESSAGE_NO_USER_FOUND = 'There was a problem locating your account.  Please contact a system administrator.';
    public static final String INVALID_EMAIL_ADDRESS = 'Please use a valid email address.';
    public static final String OLD_PASSWORD_INVALID = 'Your old password is invalid.';
    public static final String SEND_USERNAME_EMAIL_TEMPLATE = 'Portal_Send_Username';
    public static final String EMAIL_ADDRESS = 'emailAddress';
    public static final String INTERIM_API_NAME = 'ucinn_ascendv2__Interim__c';
    public static final String INTERIM_EMPLOYMENT_API_NAME = 'ucinn_portal_Interim_Employment__c';
    public static final String SOBJECT_API_NAME = 'sObjectApiName';
    public static final String FIELD_API_NAME = 'fieldApiName';
    public static final String MAX_LENGTH = 'maxLength';
    public static final String EMAIL_TEMPLATE_DEVELOPER_NAME = 'emailTemplateDeveloperName';
    public static final String DEFAULT_EMAIL_SENDER_DISPLAY_NAME = 'UC Innovation';

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

    public virtual Map<String, Map<String, Object>> getFrontEndDataMap(Map<String, Object> params) {
        String pageName = (String) params.get('pageName');
        if (String.isBlank(pageName)) {
            return new Map<String, Map<String, Object>>();
        }
        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');
        return PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionList);
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
    public virtual void submitNewUserApplication(Map<String, Object> params) {
        Map<String, Object> interimMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(params.get('interim')));
        String degree = (String) params.get('degree');
        String degreeYear = (String) params.get('degreeYear');
        String interimSourceUrl = (String) params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
        String emailTemplateDeveloperName = (String)params.get(EMAIL_TEMPLATE_DEVELOPER_NAME);

        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_CommunityUserControllerBase.submitNewUserApplication', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        if (interimMap != null) {
            List<Group> groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :LOGIN_CASE_GROUP_NAME LIMIT 1];
            Case newCase = new Case(Origin='Portal',
                                        Subject='A new user has applied for an account',
                                        Status='New',
                                        Type = PORTAL_CONST_CommunityUser.LOGIN);

            if (!groupList.isEmpty()) {
                newCase.OwnerId = groupList.get(0).Id;
            }
            insert newCase;
            ucinn_ascendv2__Interim__c interim = (ucinn_ascendv2__Interim__c) System.JSON.deserialize(System.JSON.serialize(interimMap), ucinn_ascendv2__Interim__c.class);
            interim.ucinn_portal_Case__c = newCase.Id;
            interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE).getRecordTypeId();
            interim.ucinn_ascendv2__Source_File__c = [SELECT Name FROM Network WHERE Id = :Network.getNetworkId()]?.Name;

            interim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
            insert interim;

            //TODO do not show degree year on front end if degree hasn't been populated yet
            if (String.isNotBlank(degree)) {
                ucinn_ascendv2__Degree_Information__c degreeRecord = new ucinn_ascendv2__Degree_Information__c();
                degreeRecord.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('School_Degree_Information').getRecordTypeId();
                degreeRecord.ucinn_ascendv2__Degree__c = degree;
                degreeRecord.ucinn_ascendv2__Conferred_Degree_Year__c = degreeYear;

                List<Portal_Organization_Setting__mdt> accountIdSetting = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
                    PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
                    PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
                    PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{PORTAL_CONST_Global.ACCOUNT_EXTERNAL_ID_METADATA_DEVELOPER_NAME}
                });

                // Out of box, the Organization External Id Setting custom metadata record does not exist 
                if (!accountIdSetting.isEmpty()) {
                    degreeRecord.ucinn_ascendv2__Degree_Institution__r = new Account(ucinn_ascendv2__External_System_ID__c = accountIdSetting.get(0).Value__c);
                }

                List<Contact> dummyContactList = [SELECT Id FROM Contact WHERE FirstName = :PORTAL_CONST_Global.DUMMY_CONTACT_FIRST_NAME AND LastName = :PORTAL_CONST_Global.DUMMY_CONTACT_LAST_NAME];
                if (dummyContactList.isEmpty()) {
                    Contact dummyContact = new Contact(FirstName = PORTAL_CONST_Global.DUMMY_CONTACT_FIRST_NAME, LastName = PORTAL_CONST_Global.DUMMY_CONTACT_LAST_NAME);
                    insert dummyContact;
                    degreeRecord.ucinn_ascendv2__Contact__c = dummyContact.Id;
                } else {
                    degreeRecord.ucinn_ascendv2__Contact__c = dummyContactList.get(0).Id;
                }

                degreeRecord.ucinn_ascendv2__Interim__c = interim.Id;
                insert degreeRecord;
            }

            this.sendNewUserRegistrationEmails(interim, emailTemplateDeveloperName);
        }
    }

    /**
    * method that inserts an interim and interim employment based on data that was inputted
    * by the user who is trying to create a hiring manager account
    *
    *
    * @param data                       the map that holds the interim and interim employment data
    * @param interimSourceUrl           Relative Url that this request was sent from
    * @param recaptchaToken             The client side recaptcha token to be verified
    * @param emailTemplateDeveloperName String: developer name of new user registration email template
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    *
    */
    public virtual void submitHiringManagerApplication(Map<String, Object> params) {
        Map<String, Object> dataMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(params.get('data')));
        Map<String, Object> interimMap = (Map<String, Object>) dataMap.get('ucinn_ascendv2__Interim__c');
        Map<String, Object> interimEmploymentMap = (Map<String, Object>) dataMap.get('ucinn_portal_Interim_Employment__c');
        String interimSourceUrl = (String) params.get(PORTAL_CONST_Global.INTERIM_SOURCE_URL);
        String emailTemplateDeveloperName = (String)params.get(EMAIL_TEMPLATE_DEVELOPER_NAME);

        PORTAL_GlobalAttributes.getInstance().setPathUrl(interimSourceUrl);

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_CommunityUserControllerBase.submitHiringManagerApplication', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        if (interimMap != null && interimEmploymentMap != null) {
            List<Group> groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :HIRING_MANAGER_CASE_GROUP_NAME LIMIT 1];
            Case newCase = new Case(Origin='Portal',
                                        Subject='A new hiring manager has applied',
                                        Status='New',
                                        Type = PORTAL_CONST_CommunityUser.HIRING_MANAGER);

            if (!groupList.isEmpty()) {
                newCase.OwnerId = groupList.get(0).Id;
            }
            insert newCase;
            ucinn_ascendv2__Interim__c interim = (ucinn_ascendv2__Interim__c) System.JSON.deserialize(System.JSON.serialize(interimMap), ucinn_ascendv2__Interim__c.class);
            interim.RecordTypeId = Schema.SObjectType.ucinn_ascendv2__Interim__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE).getRecordTypeId();
            interim.ucinn_portal_Case__c = newCase.Id;

            interim.ucinn_portal_Source_Url__c = PORTAL_GlobalAttributes.getInstance().getPathUrl();
            try {
                insert interim;
            } catch (DmlException dmlError) {
                handleDmlException(INTERIM_API_NAME, dmlError);
            }

            ucinn_portal_Interim_Employment__c employment = (ucinn_portal_Interim_Employment__c)System.JSON.deserialize(System.JSON.serialize(interimEmploymentMap), ucinn_portal_Interim_Employment__c.class);
            employment.Interim__c = interim.Id;
            
            try {
                insert employment;
            } catch (DmlException dmlError) {
                handleDmlException(INTERIM_EMPLOYMENT_API_NAME, dmlError);
            }

            this.sendNewUserRegistrationEmails(interim, emailTemplateDeveloperName);
        }
    }

    /**
     * Helper method to throw an AuraHandledException with error info for frontend
     * if DML results in a STRING_TOO_LARGE max length error
     * 
     * @author Jacob Huang
     * @since 1.7.0
     * 
     * @param sObjectApiName    String: SObject type that caused the exception
     * @param dmlError          DmlException: caught DML exception 
     *  
     * @return                  throws AuraHandledException whose message is a map with 'sObjectApiName', 'fieldApiName', 'maxLength' keys
     *                          or re-throw DML Exception if not a max length issue
     */
    protected virtual void handleDmlException(String sObjectApiName, DmlException dmlError) {
        if (dmlError.getDmlType(0) != StatusCode.STRING_TOO_LONG) {
            throw dmlError;
        }
        
        String fieldApiName = dmlError.getDmlFieldNames(0)[0];
        // DML message will end with '(max length=<number>)'
        String errorMessage = dmlError.getDmlMessage(0);
        List<String> errorList = errorMessage.split('=');
        String maxLength = errorList.get(errorList.size() - 1);
        maxLength = maxLength.substring(0, maxLength.length() - 1);

        Map<String, String> errorMap = new Map<String, String>{
            SOBJECT_API_NAME => sObjectApiName,
            FIELD_API_NAME => fieldApiName,
            MAX_LENGTH => maxLength
        };

        throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => System.JSON.serialize(errorMap)
        });
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

    public virtual Map<String, List<Map<String, Object>>> getPicklists(Map<String, Object> params) {
        String pageName = (String) params.get('pageName');
        if (String.isBlank(pageName)) {
            return new Map<String, List<Map<String, Object>>>();
        }
        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');
        return PORTAL_UTIL_PageSectionSetting.getPicklists(pageSectionList);
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

    public virtual User getUserData(Map<String, Object> params) {
        Id userId = UserInfo.getUserId();
        if (userId == null) {
            return null;
        } else {
            return [SELECT Username, Email FROM User WHERE Id = :userId];
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

    public virtual void changePassword(Map<String, Object> params) {
        Id userId = UserInfo.getUserId();
        if (userId == null) {
            return;
        } else {
            String oldPassword = (String) params.get('oldPassword');
            String newPassword = (String) params.get('newPassword');
            String passwordConfirmation = (String) params.get('passwordConfirmation');
            if (String.isNotBlank(oldPassword) && String.isNotBlank(newPassword) && String.isNotBlank(passwordConfirmation)) {
                if (!Test.isRunningTest()) {
                    try {
                        Site.changePassword(newPassword, passwordConfirmation, oldPassword);
                    } catch (Exception e){
                        if (e.getMessage() == 'Error: Your old password is invalid.'){
                            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => OLD_PASSWORD_INVALID});
                        }
                        
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage()});
                    }
                }
            } else {
                Map<String, Object> errorParams = new Map<String, Object>();
                errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                Set<String> blankFields = new Set<String>();
                if (String.isBlank(oldPassword)) {
                    blankFields.add('old password');
                }
                if (String.isBlank(newPassword)) {
                    blankFields.add('new password');
                }
                if (String.isBlank(passwordConfirmation)) {
                    blankFields.add('password confirmation');
                }
                String errorString = 'Please fill out ' + String.join(new List<String>(blankFields), ',');
                errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, errorString);
                errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.changePassword');
                throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
            }

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

    public virtual User changeEmail(Map<String, Object> params) {
        Id userId = UserInfo.getUserId();
        if (userId == null) {

            return null;
        } else {

            String newEmail = (String) params.get('email');
            if (String.isNotBlank(newEmail)) {
                try{

                    User u = new User();
                    u.Id = userId;
                    u.Email = newEmail;
                    update u;
                } catch (DmlException e){
                    if (e.getDmlType(0) == StatusCode.INVALID_EMAIL_ADDRESS){
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => INVALID_EMAIL_ADDRESS}); 
                    }

                    throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getDmlMessage(0)});
                }
            } else {

                Map<String, Object> errorParams = new Map<String, Object>();
                errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, 'The new email cannot be blank.');
                errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.changeEmail');
                throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
            }

            return getUserData(new Map<String, Object>());
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

    public virtual User changeUsername(Map<String, Object> params) {
        Id userId = UserInfo.getUserId();
        if (userId == null) {
            return null;
        } else {
            String newUsername = (String) params.get('username');
            if (String.isNotBlank(newUsername) && isNotDuplicateUserName(newUsername)) {
                try{
                    User u = new User();
                    u.Id = userId;
                    u.Username = newUsername;
                    update u;
                } catch (DmlException e){
                    if (e.getDmlType(0) == StatusCode.FIELD_INTEGRITY_EXCEPTION){
                        throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_INVALID_USERNAME});
                    } 
                    
                    throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getDmlMessage(0)});
                }
            } else {
                Map<String, Object> errorParams = new Map<String, Object>();
                errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, 'The new username cannot be blank.');
                errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.changeUsername');
                throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
            }
            return getUserData(new Map<String, Object>());
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
    public virtual void createUser(Map<String, Object> params) {
        Id interimId = (Id) params.get('interimId');
        if (interimId == null) {
            return;
        }
        List<ucinn_ascendv2__Interim__c> interimList = [SELECT ucinn_ascendv2__Source_File__c, ucinn_ascendv2__Contact__r.FirstName,
                                                        ucinn_ascendv2__Contact__r.LastName, ucinn_ascendv2__Contact__r.Email,
                                                        ucinn_ascendv2__Status__c, RecordType.DeveloperName,ucinn_ascendv2__Contact__c,
                                                        (SELECT Status__c FROM ucinn_portal_Interim_Employments__r
                                                        WHERE Status__c != 'Completed')
                                                        FROM ucinn_ascendv2__Interim__c
                                                        WHERE Id = :interimId];
        if (interimList != null && !interimList.isEmpty()) {
            ucinn_ascendv2__Interim__c interim = interimList.get(0);
            if (interim.ucinn_ascendv2__Contact__c == null || interim.ucinn_ascendv2__Status__c != 'Completed') {
                Map<String, Object> errorParams = new Map<String, Object>();
                errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, 'Cannot create user because the interim is not completed yet or there is no contact.');
                errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.createUser');
                throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
            } else if (interim.RecordType.DeveloperName == PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE &&
                       interim.ucinn_portaL_Interim_Employments__r != null && !interim.ucinn_portal_Interim_Employments__r.isEmpty()) {
                Map<String, Object> errorParams = new Map<String, Object>();
                errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, 'Cannot create user because the interim employment is not completed yet.');
                errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.createUser');
                throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
            } else if (String.isBlank(interim.ucinn_ascendv2__Source_File__c)) {
                Map<String, Object> errorParams = new Map<String, Object>();
                errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, 'Cannot create user because the source file field is not populated');
                errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.createUser');
                throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
            } else {

                Id profileId = null;
                String usernamePrefix = '';
                String usernameSuffix = '';

                Set<String> customMetadataLabelSet = new Set<String>{interim.ucinn_ascendv2__Source_File__c + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX, 
                                                                    PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_NAME, PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_NAME};
                // TODO: Use developer Name
                List<Portal_Organization_Setting__mdt> orgSettingList = [SELECT Label, Value__c FROM Portal_Organization_Setting__mdt WHERE Label IN :customMetadataLabelSet AND Value__c != null];
                if (orgSettingList != null) {
                    for (Portal_Organization_Setting__mdt orgSetting : orgSettingList) {
                        if (orgSetting.Label == interim.ucinn_ascendv2__Source_File__c + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX) {
                            String profileName = orgSetting.Value__c;
                            List<Profile> profileList = [SELECT Id FROM Profile WHERE Name = :profileName];
                            if (profileList != null && !profileList.isEmpty()) {
                                profileId = profileList.get(0).Id;
                            }
                        } else if (orgSetting.Label == PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_NAME) {
                            usernamePrefix = orgSetting.Value__c;
                        } else if (orgSetting.Label == PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_NAME) {
                            usernameSuffix = orgSetting.Value__c;
                        }
                    }
                }

                if (String.isBlank(profileId)) {
                    List<Profile> defaultProfileList = [Select Id, Name FROM Profile WHERE Name = :PORTAL_CONST_Global.DEFAULT_PROFILE_NAME];
                    if (!defaultProfileList.isEmpty()) {
                        profileId = defaultProfileList.get(0).Id;
                    }
                }

                User u = PORTAL_UTIL_CommunityUser.createUser(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName,  interim.ucinn_ascendv2__Contact__r.LastName,  interim.ucinn_ascendv2__Contact__r.Email, usernamePrefix, usernameSuffix, profileId);
                if (u != null) {
                    insert u;
                } else {
                    Map<String, Object> errorParams = new Map<String, Object>();
                    errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                    errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, PORTAL_UTIL_CommunityUser.getUserCreationErrorMessage(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName,  interim.ucinn_ascendv2__Contact__r.LastName,  interim.ucinn_ascendv2__Contact__r.Email, profileId));
                    errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.changeEmail');
                    throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
                }
            }
        }
    }

    /**
     * Function that checks if user with username already exists
     *
     * @param  newUsername      New Username entered on the front end
     * @author Phillip Nguyen
     * @since  1.0
     */
    protected virtual Boolean isNotDuplicateUserName(String newUsername) {
        if (String.isBlank(newUsername)) {
            return false;
        }

        Id userId = UserInfo.getUserId();

        if (userId == null) {
            return false;
        }

        List<User> userList = [SELECT Username, Email FROM User WHERE Id != :userId AND Username = :newUsername];

        if (userList != null && userList.size() > 0) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_DUPLICATE_USERNAME});
        }

        return true;
    }

    /**
     * Get username from email and send to user.
     * 
     * @author Todd Shinto
     * @since 1.11
     * 
     * @param emailAddress                String: The email address to use to query a user.
     * @param emailTemplateDeveloperName  String: The developer name of the email template to use when sending email.
     * @param recaptchaToken              String: The client side reCAPTCHA token to be verified
     */
    public virtual void sendUsernameToEmail(Map<String, Object> params) {
        String emailTemplateDeveloperName = (String)params?.get(EMAIL_TEMPLATE_DEVELOPER_NAME);
        String emailAddress = (String)params?.get(EMAIL_ADDRESS);
        if (String.isBlank(emailTemplateDeveloperName)) {
            emailTemplateDeveloperName = SEND_USERNAME_EMAIL_TEMPLATE;
        }

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_CommunityUserControllerBase.sendUsernameToEmail', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        EmailTemplate sendUsernameEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => emailTemplateDeveloperName});
        User userRecord = PORTAL_CommunityUtils.getUserFromEmail(emailAddress);

        if (sendUsernameEmailTemplate == null || userRecord == null) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_NO_USER_FOUND});
        }

        Map<String, String> mergeFieldToValueMap = this.getMergeFieldToValueMap(userRecord);

        Messaging.SingleEmailMessage emailToSend = PORTAL_CommunityUtils.createEmailRecord(new Map<String,Object>{
            PORTAL_CommunityUtils.USER_ID => userRecord.Id,
            PORTAL_CommunityUtils.SENDER_DISPLAY_NAME => DEFAULT_EMAIL_SENDER_DISPLAY_NAME,
            PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => sendUsernameEmailTemplate,
            PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToValueMap
        });

        if (!Test.isRunningTest()){
            PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => new List<Messaging.SingleEmailMessage>{emailToSend}});
        }
    }

    /**
     * Send New User Registration email
     * 
     * @author Jacob Huang
     * @since 1.9
     * 
     * @param interim                           ucinn_ascendv2__Interim__c: interim record created from user input
     * @param emailTemplateDeveloperName        String: developer name of new user registration email template
     */
    @TestVisible
    protected virtual void sendNewUserRegistrationEmails(ucinn_ascendv2__Interim__c interim, String emailTemplateDeveloperName) {
        if (interim == null || String.isBlank(emailTemplateDeveloperName)) {
            return;
        }

        EmailTemplate newUserEmailTemplate = PORTAL_CommunityUtils.getEmailTemplate(new Map<String, Object>{PORTAL_CommunityUtils.DEVELOPER_NAME => emailTemplateDeveloperName});

        if (newUserEmailTemplate == null) {
            return;
        }

        Map<String, String> mergeFieldToValueMap = this.getMergeFieldToValueMap(interim);

        Messaging.SingleEmailMessage emailToSend = PORTAL_CommunityUtils.createEmailRecord(new Map<String,Object>{
            PORTAL_CommunityUtils.EMAIL_ADDRESS_LIST => new List<String>{interim.ucinn_ascendv2__Email_1__c},
            PORTAL_CommunityUtils.SENDER_DISPLAY_NAME => DEFAULT_EMAIL_SENDER_DISPLAY_NAME,
            PORTAL_CommunityUtils.EMAIL_TEMPLATE_RECORD => newUserEmailTemplate,
            PORTAL_CommunityUtils.MERGE_FIELD_VALUE_MAP => mergeFieldToValueMap
        });

        if (!Test.isRunningTest()){
            PORTAL_CommunityUtils.sendEmails(new Map<String, Object>{PORTAL_CommunityUtils.EMAIL_TO_SEND_LIST => new List<Messaging.SingleEmailMessage>{emailToSend}});
        }
    }

    /**
     * Gets the merge field map for a given SObject record. Maps field API name to user-inputted value
     *
     * @author Jacob Huang, borrowed a lot from UTIL_Volunteers
     * @since 1.9
     *
     * @param sObj                  SObject record to get the merge field map for.
     * 
     * @return                      Merge field map of SObject field API name to values
     */
    protected virtual Map<String, String> getMergeFieldToValueMap(SObject sObj) {
        Map<String, String> resultMap = new Map<String, String>();

        if (sObj == null) {
            return resultMap;
        }

        Map<String, Object> populatedFieldMap = sObj.getPopulatedFieldsAsMap();
        for (String eachFieldName : populatedFieldMap.keySet()) {
            resultMap.put(eachFieldName, String.valueOf(populatedFieldMap.get(eachFieldName)));
        }

        return resultMap;
    }
}