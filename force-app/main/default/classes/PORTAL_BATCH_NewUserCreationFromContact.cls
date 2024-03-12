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
 * batch class that creates users from a list of constituent ids
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */


public with sharing virtual class PORTAL_BATCH_NewUserCreationFromContact implements Database.Batchable<String>, Database.Stateful{

    public String sourceCommunity = PORTAL_CONST_CommunityUser.ALUMNI_PORTAL;
    public String emailTemplate;
    public String usernamePrefix = '';
    public String usernameSuffix = '';
    public Id profileId;
    List<String> contactIdList = new List<String>();
    List<Id> failedContactIdList = new List<Id>();

    /**
     * constructor that gets the username prefix for the organization if it exists,
     * the profile needed for these constituents, and the email template to send out
     *
     *
     * @param contactIds                    the list of contact ids we are trying to process
     * @param source                        the network name if it is different from alumni portal
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     */

    public PORTAL_BATCH_NewUserCreationFromContact(List<String> contactIds, String source) {
        if (contactIds != null) {
            contactIdList = contactIds;
        }

        if (String.isNotBlank(source)) {
            sourceCommunity = source;
        }

        Set<String> customMetadataLabelSet = new Set<String>{sourceCommunity + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX, sourceCommunity + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX, 
                                                            PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_NAME, PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_NAME};

        // TODO: change to developer names
        List<Portal_Organization_Setting__mdt> orgSettingList = [SELECT Label, Value__c FROM Portal_Organization_Setting__mdt WHERE Label IN :customMetadataLabelSet AND Value__c != null];
        if (orgSettingList != null && !orgSettingList.isEmpty()) {
            for (Portal_Organization_Setting__mdt orgSetting : orgSettingList) {
                if (orgSetting.Label == sourceCommunity + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX) {
                    String profileName = orgSetting.Value__c;
                    List<Profile> profileList = [SELECT Id FROM Profile WHERE Name = :profileName];
                    if (profileList != null && !profileList.isEmpty()) {
                        profileId = profileList.get(0).Id;
                    }
                } else if (orgSetting.Label == sourceCommunity + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX) {
                    emailTemplate = orgSetting.Value__c;
                } else if (orgSetting.Label == PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_NAME) {
                    this.usernamePrefix = orgSetting.Value__c;
                } else if (orgSetting.Label == PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_NAME) {
                    this.usernameSuffix = orgSetting.Value__c;
                }
            }
        }

        if (String.isBlank(profileId)) {
            List<Profile> profileList = [Select Id, Name FROM Profile WHERE Name = :PORTAL_CONST_Global.DEFAULT_PROFILE_NAME];
            if (!profileList.isEmpty()) {
                profileId = profileList.get(0).Id;
            }
        }

        if (String.isBlank(emailTemplate)) {
            emailTemplate = PORTAL_CONST_CommunityUser.DEFAULT_EMAIL_TEMPLATE;
        }

    }


    /**
     * batch start method that will return the list of contact ids
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @return                  list of contact ids we are trying to process
     *
     */

    public virtual Iterable<String> start(Database.BatchableContext BC) {
        return contactIdList;
    }


  /**
     * batch execute method that creates the new user for the constituents
     * and sends out the welcome email for them
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param interimList                   the list of contact ids we are processing for this batch
     */
    public virtual void execute(Database.BatchableContext BC, List<String> batchedContactIdList) {

        List<Contact> contactList = [SELECT Id, Email, FirstName, LastName FROM Contact WHERE Id IN :batchedContactIdList AND Id NOT IN (SELECT ContactId FROM User)];

        List<User> usersToInsert = new List<User>();

        for(Contact eachContact : contactList) {
            if (String.isNotBlank(eachContact.Email)) {
                User u = PORTAL_UTIL_CommunityUser.createUser(eachContact.Id, eachContact.FirstName, eachContact.LastName, eachContact.Email, this.usernamePrefix, this.usernameSuffix, profileId);
                if (u != null) {
                    usersToInsert.add(u);
                } else {
                    failedContactIdList.add(eachContact.Id);
                }
            } else {
                failedContactIdList.add(eachContact.Id);
            }
        }

        List<Database.SaveResult> saveResult = Database.insert(usersToInsert, false);
        for (Integer index = 0; index < saveResult.size(); index++) {
            if (saveResult.get(index).isSuccess()) {
                User u = usersToInsert.get(index);
                PORTAL_UTIL_CommunityUser.sendWelcomeEmails(u, emailTemplate);
            } else {
                User u = usersToInsert.get(index);
                failedContactIdList.add(u.ContactId);
            }
        }

    }

     /**
     * batch finish method
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     */

    public virtual void finish(Database.BatchableContext BC) {
        for (Id eachContactId : failedContactIdList) {
            System.debug(eachContactId);
        }
    }

}