public with sharing class PORTAL_BATCH_NewUserCreationFromConOR implements Database.Batchable<String>, Database.Stateful{

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

     public PORTAL_BATCH_NewUserCreationFromConOR(List<String> contactIds, String source) {
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
            List<Profile> profileList = [Select Id, Name FROM Profile WHERE Name = 'ISUF-Donor Portal User'];
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

    public Iterable<String> start(Database.BatchableContext BC) {
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
    public void execute(Database.BatchableContext BC, List<String> batchedContactIdList) {

        List<Contact> contactList = [SELECT Id, Email, FirstName, LastName, isuf_Username__c FROM Contact WHERE Id IN :batchedContactIdList AND Id NOT IN (SELECT ContactId FROM User)];

        List<User> usersToInsert = new List<User>();

        for(Contact eachContact : contactList) {
            if (String.isNotBlank(eachContact.Email)) {
                User u = createUser(eachContact.Id, eachContact.FirstName, eachContact.LastName, eachContact.Email, eachContact.isuf_Username__c ,this.usernamePrefix, this.usernameSuffix, profileId);
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

    public void finish(Database.BatchableContext BC) {
        for (Id eachContactId : failedContactIdList) {
            System.debug(eachContactId);
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