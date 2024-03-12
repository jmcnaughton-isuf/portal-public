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
 * class that handles SSO
 *
 *
 * @author: Bill Lu
 * @since: 1.0
 *
 */
global class PORTAL_SocialLoginHandler {
    //private static final String ORG_SUFFIX = '.ascendu';
    private static final String PARAM_FIRST_NAME = 'firstName';
    private static final String PARAM_LAST_NAME = 'lastName';
    private static final String CUSTOMER_COMMUNITY = 'Customer Community';
    private static final String CUSTOMER_COMMUNITY_LOGIN = 'Customer Community Login';
    private static final String CUSTOMER_COMMUNITY_PLUS = 'Customer Community Plus';
    private static final String CUSTOMER_COMMUNITY_PLUS_LOGIN = 'Customer Community Plus Login';
    private static final String PARTNER_COMMUNITY_LOGIN = 'Partner Community Login';
    private static final String PARTNER_COMMUNITY = 'Partner Community';


    /**
     * method that finds a matching contact based
     * on the data returned by the external party
     *
     * @author: Bill Lu
     * @since: 1.0
     *
     * @param data                   data from the third party
     *
     * @return                       the contact id that matches the data
     */
    global static String findContactId(Auth.UserData data){
        String contactIdToUse = '';

        Map<String, String> nameMap = getNames(data);
        String firstName = nameMap.get(PARAM_FIRST_NAME);
        String lastName = nameMap.get(PARAM_LAST_NAME);

        List<Contact> contactListForEmail = [Select Id, (Select Id, ucinn_ascendv2__First_Name__c, ucinn_ascendv2__Last_Name__c From ucinn_ascendv2__Contact_Names_Contact__r
                                             WHERE ucinn_ascendv2__First_Name__c = :firstName AND ucinn_ascendv2__Last_Name__c = :lastName)
                                             From Contact
                                             Where Id IN (Select ucinn_ascendv2__Contact__c From ucinn_ascendv2__Email__c Where ucinn_ascendv2__Email_Address__c = :data.email)];

        if (contactListForEmail != null && !contactListForEmail.isEmpty()) {
            if (contactListForEmail.size() == 1) {
                contactIdToUse = contactListForEmail.get(0).Id;
            }
            else {

                for (Contact eachContact : contactListForEmail) {
                    if (eachContact.ucinn_ascendv2__Contact_Names_Contact__r != null && !eachContact.ucinn_ascendv2__Contact_Names_Contact__r.isEmpty()) {
                        contactIdToUse = eachContact.Id;
                        break;
                    }
                }
            }
        }

        return contactIdToUse;
    }

    /**
     * method that finds a matching user based
     * on the data returned by the external party and the contact found for the user
     *
     * @author: Bill Lu
     * @since: 1.0
     *
     * @param contactIdToUse         the contact id for the matching contact
     * @param data                   data from the third party
     *
     * @return                       the user for this contact
     */

    global static User findUser(String contactIdToUse, Auth.UserData data) {
        List<User> existingUserList = [SELECT Id, Email 
                                       FROM User 
                                       WHERE ContactId = :contactIdToUse 
                                       AND Profile.UserLicense.Name IN (:CUSTOMER_COMMUNITY, 
                                                                        :CUSTOMER_COMMUNITY_LOGIN, 
                                                                        :CUSTOMER_COMMUNITY_PLUS, 
                                                                        :CUSTOMER_COMMUNITY_PLUS_LOGIN, 
                                                                        :PARTNER_COMMUNITY, 
                                                                        :PARTNER_COMMUNITY_LOGIN)];

        if (existingUserList != null && !existingUserList.isEmpty()) {
            return existingUserList.get(0);
        }
        else {
            User newUser = new User();
            List<Profile> defaultProfileList = [SELECT Id, Name FROM Profile WHERE Name = :PORTAL_CONST_Global.DEFAULT_PROFILE_NAME];

            if (!defaultProfileList.isEmpty()) {
                newUser.ProfileId = defaultProfileList.get(0).Id;
            }

            Map<String, String> nameMap = getNames(data);
            String firstName = nameMap.get(PARAM_FIRST_NAME);
            String lastName = nameMap.get(PARAM_LAST_NAME);

            // Social provider returns null for data.username, so use data.email instead.
            String usernamePrefix = '';
            String usernameSuffix = '';

            // TODO: change to developer name
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

            newUser.Username = (String.isNotBlank(usernamePrefix) ? usernamePrefix : '') + data.email + (String.isNotBlank(usernameSuffix) ? usernameSuffix : '');
            newUser.email = data.email;
            newUser.lastName = lastName;
            newUser.firstName = firstName;

            String alias = ((newUser.firstName != null && newUser.firstName.length() > 0) ? newUser.firstName.substring(0,1) : '' ) + newUser.lastName.substring(0,1);
            alias += String.valueOf(Crypto.getRandomInteger()).substring(1,7);

            newUser.alias = alias;
            newUser.languagelocalekey = UserInfo.getLocale();
            newUser.localesidkey = UserInfo.getLocale();
            newUser.emailEncodingKey = 'UTF-8';
            newUser.timeZoneSidKey = 'GMT';
            newUser.contactId = contactIdToUse;

            String networkId = data.attributeMap.get('sfdc_networkid');

            List<Network> networkList = [SELECT Id,Name FROM Network where Id = :networkId];

            if (networkList.size() > 0) {
                String networkName = networkList[0].Name;

                newUser.ucinn_portal_Origin_Site__c = networkName;

                String customMetadataLabel = networkName + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX;
                // TODO: change to developer name
                List<Portal_Organization_Setting__mdt> profileNameList = [SELECT Value__c FROM Portal_Organization_Setting__mdt WHERE Label = :customMetadataLabel];
                if (profileNameList != null && !profileNameList.isEmpty()) {
                    String profileName = profileNameList.get(0).Value__c;
                    if (String.isNotBlank(profileName) && profileName != PORTAL_CONST_Global.DEFAULT_PROFILE_NAME) {
                        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name = :profileName];
                        if (!profileList.isEmpty()) {
                            newUser.ProfileId = profileList.get(0).Id;
                        }
                    }
                }
            }


            return newUser;
        }
    }

    /**
     * method that creates a map of name fields from the data's name field
     *
     * @author: Bill Lu
     * @since: 1.0
     *
     * @param data                   data from the third party
     *
     * @return                       the map of the name fields
     */

    global static Map<String, String> getNames(Auth.UserData data) {
        String firstName = '';
        String lastName = '';

        if (String.isBlank(data.firstName) && String.isBlank(data.lastName) && String.isNotBlank(data.fullname)) {
            String fullName = data.fullname;
            String[] nameArray = fullName.split(' ');

            if (nameArray.size() == 1) {
                lastName = nameArray[0];
            }
            else if (nameArray.size() == 2) {
                firstName = nameArray[0];
                lastName = nameArray[1];
            }
            else if (nameArray.size() >= 3) {
                firstName = nameArray[0];
                lastName = nameArray[nameArray.size() - 1];
            }
        }
        else {
            firstName = data.firstName;
            lastName = data.lastName;
        }

        Map<String, String> nameMap = new Map<String, String>();
        nameMap.put(PARAM_FIRST_NAME, firstName);
        nameMap.put(PARAM_LAST_NAME, lastName);

        return nameMap;
    }
}