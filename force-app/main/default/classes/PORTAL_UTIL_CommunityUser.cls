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
 * utility class for any functions that deal with the community user and
 * can be used by many other classes
 *
 * @author      Ashley Tran
 * @version 1.0
 * @since   1.0
 */

public with sharing class PORTAL_UTIL_CommunityUser {

    /**
    * method that creates a portal user, no prefix option
    *
    * @param contactId                  the contact id for the user
    * @param firstName                  the first name for the user
    * @param lastName                   the last name for the user
    * @param email                      the email for the user
    * @param usernameSuffix             the string to append to the end of the username for the organization
    * @param profileId                  the id for the user's profile
    *
    *
    * @author: Ashley Tran
    * @since: 1.0
    *
    * @return                           the new user to be inserted
    */
    public static User createUser(Id contactId, String firstname, String lastName, String email, String usernameSuffix, Id profileId) {
        return createUser(contactId, firstname, lastName, email, '', usernameSuffix, profileId);
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
    public static User createUser(Id contactId, String firstname, String lastName, String email, String usernamePrefix, String usernameSuffix, Id profileId) {

        if (String.isNotBlank(firstName) && String.isNotBlank(lastName)  && String.isNotBlank(email)  && String.isNotBlank(contactId) && String.isNotBlank(profileId)) {
            User u = new User();
            u.firstName = firstName;
            u.lastName = lastName;
            u.Email = email;

            String alias = ((firstName != null && firstName.length() > 0) ? firstName.substring(0,1) : '' ) + lastName.substring(0,1);
            alias += String.valueOf(Crypto.getRandomInteger()).substring(1,7);


            u.Alias = alias;

            u.Username = (String.isNotBlank(usernamePrefix) ? usernamePrefix : '') + email + (String.isNotBlank(usernameSuffix) ? usernameSuffix : '');

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

    /**
    * method that sends the welcome email for a user
    *
    *
    * @param u                          the user we are sending an email to
    * @param emailTemplate              the email template for the welcome email
    *
    *
    * @author: Ashley Tran
    * @since: 1.0
    */

    public static void sendWelcomeEmails(User u, String emailTemplate) {

        if (String.isNotBlank(emailTemplate)) {
            if (!Test.isRunningTest()) {
                try {
                    System.resetPasswordWithEmailTemplate(u.Id, true, emailTemplate);
                } catch (Exception e) {

                }
            }
        }
    }


    public static String getUserCreationErrorMessage(Id contactId, String firstName, String lastName, String email, String profileId) {

        Set<String> blankFields = new Set<String>();

        if (String.isBlank(contactId)) {
            blankFields.add('contact');
        }
        if (String.isBlank(firstName)) {
            blankFields.add('first name');
        }
        if (String.isBlank(lastName)) {
            blankFields.add('last name');
        }
        if (String.isBlank(email)) {
            blankFields.add('email');
        }

        if (String.isBlank(profileId)) {
            blankFields.add('profile id');
        }

        return 'Could not create user because the ' + String.join(new List<String>(blankFields), ', ') + ' field' + (blankFields.size() == 1 ? ' is empty.' : 's are empty.');
    }
}