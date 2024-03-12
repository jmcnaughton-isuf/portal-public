public with sharing class PORTAL_BATCH_NewUserCreationOR extends PORTAL_BATCH_NewUserCreation{
    
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
    public override Database.QueryLocator start(Database.BatchableContext BC){
        String queryString = 'SELECT Id, RecordType.DeveloperName, ucinn_ascendv2__Contact__r.FirstName, ucinn_ascendv2__Contact__r.isuf_Username__c, ucinn_ascendv2__Source_File__c, ucinn_ascendv2__Contact__r.LastName, ucinn_ascendv2__Email_1__c'
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
    public override void execute(Database.BatchableContext BC, List<ucinn_ascendv2__Interim__c> interimList){
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
                /*Id profileId = sourceNameToProfileId.get(interim.ucinn_ascendv2__Source_File__c + PORTAL_CONST_CommunityUser.PROFILE_SUFFIX);

                if (String.isBlank(profileId)) {
                    profileId = defaultProfileId;
                }*/
                Id profileId = [select id from profile where name = 'ISUF-Donor Portal User' LIMIT 1].id;
                User u = createUser(interim.ucinn_ascendv2__Contact__c, interim.ucinn_ascendv2__Contact__r.FirstName,
                                                        interim.ucinn_ascendv2__Contact__r.LastName, interim.ucinn_ascendv2__Email_1__c, interim.isuf_Username__c,
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