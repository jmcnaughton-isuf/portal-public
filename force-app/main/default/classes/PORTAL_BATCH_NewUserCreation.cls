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
 * batch class that creates users from completed interims
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */

public virtual with sharing class PORTAL_BATCH_NewUserCreation implements Database.Batchable<sObject>{

    public String usernamePrefix = '';
    public String usernameSuffix = '';
    public Id defaultProfileId = null;
    public Map<String, Id> sourceNameToProfileId = new Map<String, Id>();
    public Map<String, String> sourceNameToEmailTemplate = new Map<String, String>();

     /**
     * constructor that gets the username prefix for the organization if it exists
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     */
    public PORTAL_BATCH_NewUserCreation() {
        List<Portal_Organization_Setting__mdt> orgSettings = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c', 'DeveloperName'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_DEVELOPER_NAME, PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_DEVELOPER_NAME}
        });

        if (orgSettings != null && !orgSettings.isEmpty()) {
            for (Portal_Organization_Setting__mdt eachSetting : orgSettings) {
                if (eachSetting.DeveloperName == PORTAL_CONST_CommunityUser.USERNAME_PREFIX_CUSTOM_METADATA_DEVELOPER_NAME) {
                    this.usernamePrefix = eachSetting.Value__c;
                } else if (eachSetting.DeveloperName == PORTAL_CONST_CommunityUser.USERNAME_SUFFIX_CUSTOM_METADATA_DEVELOPER_NAME) {
                    this.usernameSuffix = eachSetting.Value__c;
                }
            }
        }

        List<Network> networkList = [SELECT Name FROM Network WHERE Status = 'Live'];
        getCustomMetadataRecordsByNetwork(networkList, sourceNameToProfileId, sourceNameToEmailTemplate);

        List<Profile> profileList = [Select Id, Name FROM Profile WHERE Name = :PORTAL_CONST_Global.DEFAULT_PROFILE_NAME];
        if (!profileList.isEmpty()) {
            defaultProfileId = profileList.get(0).Id;
        }

    }

     /**
     * batch start method that creates the query for the interim
     *  records that need to have users created for them
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @return                          the query locator for this batch
     */
    public virtual Database.QueryLocator start(Database.BatchableContext BC){
        String queryString = 'SELECT Id, RecordType.DeveloperName, ucinn_ascendv2__Contact__r.FirstName, ucinn_ascendv2__Source_File__c, ucinn_ascendv2__Contact__r.LastName, ucinn_ascendv2__Email_1__c'
                             + ' FROM ucinn_ascendv2__Interim__c WHERE ucinn_ascendv2__Status__c = \''+ PORTAL_CONST_CommunityUser.COMPLETED + '\' AND ucinn_ascendv2__Contact__c != null '
                             + ' AND ucinn_ascendv2__Contact__c NOT IN (SELECT ContactId FROM User) AND RecordType.DeveloperName IN (\'' + PORTAL_CONST_CommunityUser.LOGIN_REQUEST_RECORDTYPE + '\', \'' + PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE + '\')';
        return Database.getQueryLocator(queryString);
    }


     /**
     * batch execute method that creates the new user for the interim
     * and sends out the welcome email for them
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param interimList                   the list of interims we are trying to create
     */
    public virtual void execute(Database.BatchableContext BC, List<ucinn_ascendv2__Interim__c> interimList){
        List<User> usersToInsert = new List<User>();

        Map<String, String> usernameToEmailTemplateCustomMetadataLabel = new Map<String, String>();

        Map<Id, ucinn_ascendv2__Interim__c> interimIdMap = new Map<Id, ucinn_ascendv2__Interim__c>(interimList);

        List<ucinn_portal_Interim_Employment__c> interimEmploymentList = [SELECT Interim__c FROM ucinn_portal_Interim_Employment__c WHERE Status__c = 'Completed' AND Interim__c IN :interimIdMap.keyset()];

        Map<Id, ucinn_ascendv2__Interim__c> interimsToUpdate = new Map<Id, ucinn_ascendv2__Interim__c>();
        Map<String, Id> usernameToInterimIdMap = new Map<String, Id>();

        Set<Id> interimIdWithCompletedEmploymentSet = new Set<Id>();
        for (ucinn_portal_Interim_Employment__c employment: interimEmploymentList) {
            interimIdWithCompletedEmploymentSet.add(employment.Interim__c);
        }

        for (ucinn_ascendv2__Interim__c interim : interimList) {
            if (interim.RecordType.DeveloperName == PORTAL_CONST_CommunityUser.HIRING_MANAGER_RECORDTYPE && !interimIdWithCompletedEmploymentSet.contains(interim.Id)) {
                continue;
            }
            if (String.isNotBlank(interim.ucinn_ascendv2__Source_File__c)) {
                Id profileId = sourceNameToProfileId.get(interim.ucinn_ascendv2__Source_File__c + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX);

                if (String.isBlank(profileId)) {
                    profileId = defaultProfileId;
                }
                User u = PORTAL_UTIL_CommunityUser.createUser(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName,
                                                        interim.ucinn_ascendv2__Contact__r.LastName, interim.ucinn_ascendv2__Email_1__c,
                                                        this.usernamePrefix, this.usernameSuffix, profileId);
                if (u != null) {
                    usernameToEmailTemplateCustomMetadataLabel.put(u.Username, interim.ucinn_ascendv2__Source_File__c + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX);
                    usersToInsert.add(u);
                    usernameToInterimIdMap.put(u.Username, interim.Id);
                } else {
                    ucinn_ascendv2__Interim__c interimToUpdate = new ucinn_ascendv2__Interim__c();
                    interimToUpdate.ucinn_ascendv2__Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                    String errorMessage = PORTAL_UTIL_CommunityUser.getUserCreationErrorMessage(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName, interim.ucinn_ascendv2__Contact__r.LastName,
                                                                                                interim.ucinn_ascendv2__Email_1__c, profileId);
                    interimToUpdate.ucinn_ascendv2__Manual_Review_Reason_Multiple_Line__c += errorMessage;
                    interimToUpdate.Id = interim.Id;
                    interimsToUpdate.put(interim.Id, interimToUpdate);
                }
            } else {
                ucinn_ascendv2__Interim__c interimToUpdate = new ucinn_ascendv2__Interim__c();
                interimToUpdate.ucinn_ascendv2__Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                interimToUpdate.ucinn_ascendv2__Manual_Review_Reason_Multiple_Line__c += 'Cannot create user for this interim because source file is blank. ';
                interimToUpdate.Id = interim.Id;
                interimsToUpdate.put(interim.Id, interimToUpdate);
            }
        }

        List<Database.SaveResult> saveResult = Database.insert(usersToInsert, false);

        for (Integer index = 0; index < saveResult.size(); index++) {
            if (saveResult.get(index).isSuccess()) {
                User u = usersToInsert.get(index);
                String emailTemplateKey = usernameToEmailTemplateCustomMetadataLabel.get(u.Username);
                if (String.isNotBlank(emailTemplateKey)) {
                    String emailTemplate = sourceNameToEmailTemplate.get(emailTemplateKey);
                    if (String.isBlank(emailTemplate)) {
                        emailTemplate = PORTAL_CONST_CommunityUser.DEFAULT_EMAIL_TEMPLATE;
                    }
                    PORTAL_UTIL_CommunityUser.sendWelcomeEmails(u, emailTemplate);
                }
            } else {
                User u = usersToInsert.get(index);
                if (u != null && String.isNotBlank(u.Username) && usernameToInterimIdMap.containsKey(u.Username)) {
                    ucinn_ascendv2__Interim__c interimToUpdate = new ucinn_ascendv2__Interim__c();
                    interimToUpdate.ucinn_ascendv2__Status__c = PORTAL_CONST_CommunityUser.MANUAL_REVIEW;
                    interimToUpdate.ucinn_ascendv2__Manual_Review_Reason_Multiple_Line__c += 'Could not create a user for this interim. ';
                    interimToUpdate.Id = usernameToInterimIdMap.get(u.Username);
                    interimsToUpdate.put(usernameToInterimIdMap.get(u.Username), interimToUpdate);
                }
            }
        }

        List<Database.SaveResult> updateResult = Database.update(interimsToUpdate.values(), false);


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

    }


     /**
     * method that queries for the profile ids and the email templates
     * from custom metadata based on the network the interim was created
     * from
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param interimList                       the list of interims that we need to get profiles and templates for
     * @param sourceNameToProfileId             the map that will store the source name to profile id
     * @param sourceNameToEmailTemplate         the map that will store the source name to template name
     */
    private void getCustomMetadataRecordsByNetwork(List<Network> networkList,  Map<String, Id> sourceNameToProfileId, Map<String, String> sourceNameToEmailTemplate) {

        Set<String> customMetadataLabelSet = new Set<String>();
        for (Network ntwk : networkList) {
            customMetadatalabelSet.add(ntwk.Name + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX);
            customMetadatalabelSet.add(ntwk.Name + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX);

        }

        Map<String, String> profileNameToSourceName = new Map<String, String>();

        // TODO: change to developer names
        List<Portal_Organization_Setting__mdt> organizationSettings = [SELECT Value__c, Label FROM Portal_Organization_Setting__mdt WHERE Label IN :customMetadataLabelSet AND Value__c != null];
        if (organizationSettings != null && !organizationSettings.isEmpty()) {
            for (Portal_Organization_Setting__mdt setting : organizationSettings) {
                if (setting.Label.contains(PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX)) {
                    sourceNameToEmailTemplate.put(setting.Label, setting.Value__c);
                } else if (setting.Label.contains(PORTAL_CONST_CommunityUser.PROFILE_SUFFIX)) {
                    profileNameToSourceName.put(setting.Value__c, setting.Label);
                }
            }
        }

        List<Profile> profileList = [Select Id, Name FROM Profile WHERE Name IN :profileNameToSourceName.keyset()];
        for (Profile p : profileList) {
            sourceNameToProfileId.put(profileNameToSourceName.get(p.Name), p.Id);
        }
    }
}