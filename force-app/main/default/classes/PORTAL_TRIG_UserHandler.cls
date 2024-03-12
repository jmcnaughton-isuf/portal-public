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
 * trigger that handles any portal data modification for the user object
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */
global without sharing class PORTAL_TRIG_UserHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    private static final Map<String, String> USER_FIELD_TO_CONTACT_FIELD_MAP = new Map<String, String>{
        'LastLoginDate' => 'ucinn_portal_Last_Login_Datetime__c'
    };

    public static final String CONTACT_CONST = 'Contact';
    public static final String COMMUNITY_USER_PERMISSION_SET = 'Community_User_Permission_Set';
    public static final String COMMUNITY_USER_PROFILE = 'Community_User_Profile';
    public static final String VALUE_API = 'Value__c';
    public static final String ID_CONST = 'Id';
    public static final String PORTAL_ORGANIZATION_SETTING_MDT = 'Portal_Organization_Setting__mdt';
    public static final String PROFILE_API = 'Profile';
    public static final String PERMISSION_SET_API = 'PermissionSet';

    /**
     *  Method occurs on every trigger run.
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @param   oldList                         List of the old version of the records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the obect in the trigger
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     * @since                                   1.0
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            if (!System.isBatch()) {
                //List<Organization> orgList = [SELECT Name, isSandbox FROM Organization LIMIT 1];
                //if (orgList != null && !orgList.isEmpty() && !orgList.get(0).isSandbox) {
                sendWelcomeEmails((List<User>) newList);
                updateContactsToBePortalUser(new Map<Id, sObject>(newList).keySet());
                //}
            }
            addPermissionSetToUser((new Map<Id,SObject>(newList)).keySet());
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            updateContacts(new Map<Id, sObject>(newList).keySet());
        }
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     *  Method occurs on every AfterInsert.  Adds the permission set name stored in Portal_Organization_Setting.Community_User_Permission_Set
     *  to newly inserted users.  Must be annotated as a future method as there is logic in updateContactsToBePortalUser() that updates Contacts.
     *
     * @author  Todd Shinto
     * @param   newUserIdSet    Set of Id's from newList to requery for.  Future methods don't accept lists of SObjects.
     * @return                                  
     * @since                   1.16
     */
    @future
    public static void addPermissionSetToUser(Set<Id> newUserIdSet) {   
        List<User> newUserList = [SELECT Id, ProfileId FROM User WHERE Id IN :newUserIdSet];

        if (newUserList.isEmpty()) {
            return;
        }

        Map<String, String> communityUserOrgSettingMap = getCommunityUserOrgSettingMap();
        String communityUserProfileId = getRecordIdByName(communityUserOrgSettingMap?.get(COMMUNITY_USER_PROFILE), PROFILE_API);
        String communityUserPermissionSetId = getRecordIdByName(communityUserOrgSettingMap?.get(COMMUNITY_USER_PERMISSION_SET), PERMISSION_SET_API);

        if (String.isBlank(communityUserProfileId) || String.isBlank(communityUserPermissionSetId)) {
            return;
        }

        List<PermissionSetAssignment> permissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();

        for (User eachUser : newUserList) {
            if (eachUser.ProfileId != communityUserProfileId) {
                continue;
            }

            permissionSetAssignmentsToInsert.add(new PermissionSetAssignment(
                AssigneeId = eachUser.Id,
                PermissionSetId = communityUserPermissionSetId
            ));
        }

        if (!permissionSetAssignmentsToInsert.isEmpty()) {
            insert permissionSetAssignmentsToInsert;
        }
    }

    /**
     *  Gets the community user settings stored in Portal Organization Settings.  Creates a map.  Expects 2 CMT records:
     *      1. The name of the Profile to assign permissions to
     *      2. The name of the Permission Set
     *
     * @author  Todd Shinto
     * @return  A map of the setting's API name to the setting's value                             
     * @since   1.16
     */
    private static Map<String, String> getCommunityUserOrgSettingMap() {
        Map<String, String> returnMap = new Map<String, String>();

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{VALUE_API},
            PORTAL_Utils.SOBJECT_NAME => PORTAL_ORGANIZATION_SETTING_MDT,
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{COMMUNITY_USER_PROFILE, COMMUNITY_USER_PERMISSION_SET}
        });

        if (orgSettingList.size() < 2) {
            return returnMap;
        }

        for (Portal_Organization_Setting__mdt eachOrgSetting : orgSettingList) {
            returnMap.put(eachOrgSetting.DeveloperName, eachOrgSetting.Value__c);
        }

        return returnMap;
    }

    /**
     *  Gets the Id of a record based on the record's name
     *
     * @author  Todd Shinto
     * @param   recordName          The name of the record
     * @param   customObjectName    The name of the object to query
     * @return  The Id of a record                     
     * @since   1.16
     */
    private static String getRecordIdByName(String recordName, String customObjectName) {
        if (String.isBlank(recordName) || String.isBlank(customObjectName)) {
            return '';
        }

        String queryString = 'SELECT Id, Name FROM ' + customObjectName + ' WHERE Name = \'' + recordName + '\'';
        List<sObject> results = Database.query(queryString);
        
        if (results.isEmpty()) {
            return '';
        }

        return (String)results.get(0).get(ID_CONST);
    }

    /**
     * Update contact Is Portal User field if user inserted is a portal user
     * 
     * @author  Phillip Nguyen
     * @since   1.8
     * 
     * @param   userIdSet   Id of user's that have been inserted
     */
    @future
    public static void updateContactsToBePortalUser(Set<Id> userIdSet) {
        if (userIdSet == null || userIdSet.isEmpty()) {
            return;
        }

        List<User> userList = [SELECT Id, ContactId FROM User WHERE Id IN :userIdSet AND IsPortalEnabled = true AND ContactId != null];

        if (userList == null || userList.isEmpty()) {
            return;
        }

        List<Contact> contactsToUpdateList = new List<Contact>();

        for (User eachUser : userList) {
            contactsToUpdateList.add(new Contact(Id = eachUser.ContactId, ucinn_portal_Is_Portal_User__c = true));
        }

        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(CONTACT_CONST, false);
        update contactsToUpdateList;
        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(CONTACT_CONST, true);
    }

    /**
     *  Method that sends the user an email if they are newly created
     *
     * @param   userList                        List of users to send emails to
     * @author Ashley Tran
     * @since  1.0
     */

    public static void sendWelcomeEmails(List<User> userList) {

       Set<String> originSiteSet = new Set<String>();
       Map<String, String> originSiteToEmailTemplateMap = new Map<String, String>();

       for (User u : userList) {
           if (String.isNotBlank(u.ucinn_portal_Origin_Site__c)) {
               originSiteSet.add(u.ucinn_portal_Origin_Site__c + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX);
           }
       }

       if (!originSiteSet.isEmpty()) {
           // TODO: change to developer name
            List<Portal_Organization_Setting__mdt> orgSettingList = [SELECT Label, Value__c FROM Portal_Organization_Setting__mdt WHERE Label IN :originSiteSet AND Value__c != null];
            if (orgSettingList != null && !orgSettingList.isEmpty()) {
                for (Portal_Organization_Setting__mdt orgSetting : orgSettingList) {
                    originSiteToEmailTemplateMap.put(orgSetting.Label, orgSetting.Value__c);
                }
            }
        }
        List<Profile> profileList = [SELECT Id, Name FROM profile WHERE name IN :PORTAL_CONST_Global.EXTERNAL_USER_PROFILE_SET];
        Set<Id> profileIdSet = new Map<Id, Profile>(profileList).keySet();

        for (User insertedUser : userList) {
            if ((insertedUser.ProfileId != null && profileIdSet.contains(insertedUser.ProfileId))) {
                String emailTemplate = PORTAL_CONST_CommunityUser.DEFAULT_EMAIL_TEMPLATE;
                if (String.isNotBlank(insertedUser.ucinn_portal_Origin_Site__c) && originSiteToEmailTemplateMap.containsKey(insertedUser.ucinn_portal_Origin_Site__c + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX)
                    && String.isNotBlank(originSiteToEmailTemplateMap.get(insertedUser.ucinn_portal_Origin_Site__c + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX))) {
                        emailTemplate = originSiteToEmailTemplateMap.get(insertedUser.ucinn_portal_Origin_Site__c + PORTAL_CONST_CommunityUser.WELCOME_EMAIL_SUFFIX);
                }

                if (!Test.isRunningTest()) {
                    try {
                        System.resetPasswordWithEmailTemplate(insertedUser.Id, true, emailTemplate);
                    } catch (Exception e) {

                    }
                }

            }
        }

    }

     /**
     *  Method that updates the contact with the user data
     *
     * @param   userList                        List of users that need their contacts updated
     * @author Ashley Tran
     * @since  1.0
     */
    @future
    public static void updateContacts(Set<Id> userIdSet) {

        String queryString = 'SELECT ProfileId, ContactId, Id, ' + String.join(new List<String>(USER_FIELD_TO_CONTACT_FIELD_MAP.keySet()), ',') + ' FROM User WHERE Id IN :userIdSet';
        List<User> userList = Database.query(queryString);
        Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();

        List<Profile> profileList = [SELECT Id, Name FROM profile WHERE name IN :PORTAL_CONST_Global.EXTERNAL_USER_PROFILE_SET];
        Set<Id> profileIdSet = new Map<Id, Profile>(profileList).keySet();

        for (User u : userList) {
            if ((u.ProfileId != null && profileIdSet.contains(u.ProfileId)) && u.ContactId != null) {
                Contact cont = new Contact();
                cont.Id = u.ContactId;
                for (String userField : USER_FIELD_TO_CONTACT_FIELD_MAP.keySet()) {
                    cont.put(USER_FIELD_TO_CONTACT_FIELD_MAP.get(userField), u.get(userField));
                }
                contactsToUpdate.put(u.ContactId, cont);
            }
        }

        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger('Contact', false);
        update contactsToUpdate.values();
        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger('Contact', true);

    }

}