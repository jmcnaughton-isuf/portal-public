/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     http://www.ucinnovation.com
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
 * class that handles SSO user creation
 *
 *
 * @author: Bill Lu
 * @since: 1.0
 *
 */

global class PORTAL_SocialLoginController implements Auth.RegistrationHandler {

    class RegHandlerException extends Exception {}

    private static final String INTERNAL_USER_PROFILE = 'Standard User';

    global boolean canCreateUser(Auth.UserData data) {
        return true;
    }

    /**
     * method that finds creates a user for someone who has a contact,
     * but no user
     *
     * @author: Bill Lu
     * @since: 1.0
     *
     * @param portalId
     * @param data                   data from the third party
     *
     * @return                       the new user
     */

    global User createUser(Id portalId, Auth.UserData data){

        if (!canCreateUser(data)) {
            //Returning null or throwing an exception fails the SSO flow
            return null;
        }

        if (data.attributeMap.containsKey('sfdc_networkid')) {
            String contactIdToUse = PORTAL_SocialLoginHandler.findContactId(data);

            if (String.isNotBlank(contactIdToUse)) {
                //FUTURE TODO: handle special cases for different third parties here
                return PORTAL_SocialLoginHandler.findUser(contactIdToUse, data);
            }
            else {
                throw new RegHandlerException('Contact Not Found.');
            }

        } else {

            //This is not a community, so create a regular standard user
            User u = new User();

            List<Profile> profileList = [SELECT Id FROM Profile WHERE Name  = :INTERNAL_USER_PROFILE];
            if (profileList != null && !profileList.isEmpty()) {
                u.profileId = profileList.get(0).Id;
            }

            String usernamePrefix = '';
            String usernameSuffix = '';

            // TODO: Use developer Name
            Set<String> customMetadataLabelSet = new Set<String>{PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_NAME, PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_NAME};
            List<Portal_Organization_Setting__mdt> orgSettings = [SELECT Label, Value__c FROM Portal_Organization_Setting__mdt WHERE Label IN :customMetadataLabelSet];
            if (orgSettings != null && !orgSettings.isEmpty()) {
                for (Portal_Organization_Setting__mdt eachSetting : orgSettings) {
                    if (eachSetting.Label == PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_NAME) {
                        usernamePrefix = eachSetting.Value__c;
                    } else if (eachSetting.Label == PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_NAME) {
                        usernameSuffix = eachSetting.Value__c;
                    }
                }
            }

            u.Username = (String.isNotBlank(usernamePrefix) ? usernamePrefix : '') + data.username + (String.isNotBlank(usernameSuffix) ? usernameSuffix : '');
            u.email = data.email;
            u.lastName = data.lastName;
            u.firstName = data.firstName;
            String alias = ((data.firstName != null && data.firstName.length() > 0) ? data.firstName.substring(0,1) : '' ) + data.lastName.substring(0,1);
            alias += String.valueOf(Crypto.getRandomInteger()).substring(1,7);

            u.alias = alias;
            u.languagelocalekey = UserInfo.getLocale();
            u.localesidkey = UserInfo.getLocale();
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = 'GMT';
            return u;
        }
    }


    /**
     * method that updates a user
     *
     * @author: Bill Lu
     * @since: 1.0
     *
     * @param userId                 the id of the user to update
     * @param portalId
     * @param data                   data from the third party
     *
     * @return                       the new user
     */
    global void updateUser(Id userId, Id portalId, Auth.UserData data){

        User u = new User(id=userId);
        u.email = data.email;
        update(u);
    }
}