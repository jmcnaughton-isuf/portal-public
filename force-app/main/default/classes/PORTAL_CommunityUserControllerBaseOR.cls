public without sharing class PORTAL_CommunityUserControllerBaseOR extends PORTAL_CommunityUserControllerBase{
    
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
    public override void createUser(Map<String, Object> params) {
        Id interimId = (Id) params.get('interimId');
        if (interimId == null) {
            return;
        }
        List<ucinn_ascendv2__Interim__c> interimList = [SELECT ucinn_ascendv2__Source_File__c, ucinn_ascendv2__Contact__r.FirstName,
                                                        ucinn_ascendv2__Contact__r.LastName, ucinn_ascendv2__Contact__r.Email,
                                                        ucinn_ascendv2__Contact__r.isuf_Username__c,
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
                    List<Profile> defaultProfileList = [Select Id, Name FROM Profile WHERE Name = 'ISUF-Donor Portal User'];
                    if (!defaultProfileList.isEmpty()) {
                        profileId = defaultProfileList.get(0).Id;
                    }
                }

                User u = createUser(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName,  interim.ucinn_ascendv2__Contact__r.LastName,  interim.ucinn_ascendv2__Contact__r.Email,interim.ucinn_ascendv2__Contact__r.isuf_Username__c, usernamePrefix, usernameSuffix, profileId);
                if (u != null) {
                    insert u;
                } else {
                    Map<String, Object> errorParams = new Map<String, Object>();
                    errorParams.put(PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME, PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME);
                    errorParams.put(PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE, PORTAL_UTIL_CommunityUser.getUserCreationErrorMessage(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName,  interim.ucinn_ascendv2__Contact__r.LastName,  interim.ucinn_ascendv2__Contact__r.Email, profileId));
                    errorParams.put(PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING, 'PORTAL_CommunityUserControllerBase.changeEmail');
                    throw PORTAL_CommunityUtils.createAuraHandledException(errorParams);
                }
                PermissionSetAssignment psa = new PermissionSetAssignment(
                    PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'ISUF_Portal_Authenticated_User_ps' LIMIT 1].Id,
                    AssigneeId = u.Id
                );

                // Insert the PermissionSetAssignment record
                insert psa;

            }
        }
    }
    
    /**
    * method that creates a portal user, has prefix
    *
    * @param contactId                  the contact id for the user
    * @param firstName                  the first name for the user
    * @param lastName                   the last name for the user
    * @param email                      the email for the user
    * @param usernamePrefix             String: string to prepend to the beginning of the username for the organization
    * @param usernameSuffix             the string to append to the end of the username for the organization
    * @param profileId                  the id for the user's profile
    *
    * @author: Jacob Huang, added prefix param
    * @since: 1.11
    *
    * @return                           the new user to be inserted
    */
    public User createUser(Id contactId, String firstname, String lastName, String email, String username, String usernamePrefix, String usernameSuffix, Id profileId) {

        if (String.isNotBlank(firstName) && String.isNotBlank(lastName)  && String.isNotBlank(email)  && String.isNotBlank(contactId) && String.isNotBlank(profileId)) {
            User u = new User();
            u.firstName = firstName;
            u.lastName = lastName;
            u.Email = email;

            String alias = ((firstName != null && firstName.length() > 0) ? firstName.substring(0,1) : '' ) + lastName.substring(0,1);
            alias += String.valueOf(Crypto.getRandomInteger()).substring(1,7);


            u.Alias = alias;

            u.Username = username + usernameSuffix;

            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'GMT';
            u.ProfileId = profileId;
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.isActive = true;
            u.ContactId = contactId;
            return u;
        }
        return null;
    }
}