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
 * Utility Class containing logic for Honor Roll
 *
 * @author  Phillip Nguyen
 * @version 1.0
 * @since   1.0
 */
public without sharing class PORTAL_UTIL_HonorRoll {
    public static final String CONTACT_RECORD = 'contactRecord';
    public static final String CONTACT_LIST = 'contactList';
    public static final String SOCIETY_MEMBERSHIP_LIST = 'societyMembershipList';

    public static final String CONTACT_ID = 'contactId';
    public static final String CONTACT_ID_SET = 'contactIdSet';

    public static final String SOCIETY_MEMBERSHIP_ID_SET = 'societyMembershipIdSet';
    public static final String CONTACT_HONOR_ROLL_NAME = 'contactHonorRollName';
    public static final String SPOUSE_HONOR_ROLL_NAME = 'spouseHonorRollName';

    public static final String SCHOOL_DEGREE_INFO_DEVELOPER_NAME = 'School_Degree_Information';
    public static final String SOCIETY_MEMBERSHIP_RECORD = 'societyMembershipRecord';
    public static final String HONOR_ROLL_OPT_OUT_VALUE = 'honorRollOptOutValue';
    public static final String CURRENT_FISCAL_YEAR_START_DATE = 'currentFiscalYearStartDate';


    private static final String ACTIVE_KEY = 'Active';

    private static final String ERROR_MESSAGE_SOCIETY_MEMBERSHIP_FIELDS = 'Could not retrieve metadata information about the Society Membership Object'
                                                                            + 'Check that the Society Membership object exists and the current user '
                                                                            + 'has the correct permissions to retrieve its metadata information.';

    /**
     * Gets contact info, contact's degree info, contact's honor roll names
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @param contactIdSet  Set of contact id's
     *
     * @return              List of information for each contact
     */
    public static List<Contact> getContactInformation(Map<String,Object> params) {
        List<Contact> contactInformationList = new List<Contact>();

        if (params == null || params.isEmpty()) {
            return contactInformationList;
        }

        Set<Id> contactIdSet = (Set<Id>) params.get(CONTACT_ID_SET);

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return contactInformationList;
        }

        contactInformationList = [SELECT Id, ucinn_portal_Honor_Roll_Joint_Preference__c, ucinn_ascendv2__First_and_Last_Name_Formula__c, ucinn_portal_Is_Honor_Roll_Opt_Out__c,
                                         ucinn_ascendv2__Preferred_Spouse__c, ucinn_ascendv2__Preferred_Spouse__r.ucinn_portal_Is_Honor_Roll_Opt_Out__c,
                                            (SELECT Id, Honor_Roll_Name__c, Starting_Fiscal_Year__c, Ending_Fiscal_Year__c,
                                                Contact__c, Joint_Contact__c
                                                FROM ucinn_portal_Honor_Roll_Names_Contact__r
                                                WHERE Ending_Fiscal_Year__c = null
                                                ORDER BY Starting_Fiscal_Year__c DESC NULLS LAST),
                                            (SELECT Id, Honor_Roll_Name__c, Starting_Fiscal_Year__c, Ending_Fiscal_Year__c,
                                                Contact__c, Joint_Contact__c
                                                FROM ucinn_portal_Honor_Roll_Names_Joint__r
                                                WHERE Ending_Fiscal_Year__c = null
                                                ORDER BY Starting_Fiscal_Year__c DESC NULLS LAST),
                                            (SELECT ucinn_ascendv2__Major_Degree_Short_Formula__c, ucinn_ascendv2__Conferred_Degree_Year__c
                                                FROM ucinn_ascendv2__Degree_Information_Contact__r
                                                WHERE RecordType.DeveloperName = :SCHOOL_DEGREE_INFO_DEVELOPER_NAME
                                                ORDER BY ucinn_ascendv2__Conferred_Degree_Year__c ASC)
                                         FROM Contact WHERE Id IN :contactIdSet];  //degree value stored on post code, use formula field

        return contactInformationList;
    }

    /**
     * Query for society memberships with all fields that are connected to Contacts
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param societyMembershipIdSet    Set of society membership ids
     * @param contactIdSet              Set of Contact Id's where their honor roll global opt out value is being modified  // TODO Redo comment (Change List -> Set)
     *
     * @return                          List of society memberships
     */
    public static List<ucinn_ascendv2__Society_Membership__c> queryForSocietyMembershipsWithAllFields(Map<String,Object> params) {
        List<ucinn_ascendv2__Society_Membership__c> societyMembershipList = new List<ucinn_ascendv2__Society_Membership__c>();

        if (params == null || params.isEmpty()) {
            return societyMembershipList;
        }

        Set<Id> contactIdSet = (Set<Id>) params.get(CONTACT_ID_SET);
        Set<Id> societyMembershipIdSet = (Set<Id>) params.get(SOCIETY_MEMBERSHIP_ID_SET);

        if (contactIdSet == null || contactIdSet.isEmpty()) {
            return societyMembershipList;
        }

        List<DescribeSObjectResult> describeResultList = Schema.describeSObjects(
                                                         new String[]{PORTAL_CONST_HonorRoll.SOCIETY_MEMBERSHIP_OBJECT_NAME});

        if (describeResultList == null || describeResultList.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{ PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_SOCIETY_MEMBERSHIP_FIELDS});
        }

        List<String> fieldNames = new List<String>(describeResultList[0].fields.getMap().keySet());

        String queryString = ' SELECT ucinn_ascendv2__Giving_Society__r.ucinn_portal_Type__c, ' + String.join(fieldNames, ',')
                             + ' FROM ' + PORTAL_CONST_HonorRoll.SOCIETY_MEMBERSHIP_OBJECT_NAME
                             + ' WHERE ucinn_ascendv2__Contact__c IN :contactIdSet '
                             +  ' AND (ucinn_ascendv2__Expiration_Date__c = null OR ucinn_ascendv2__Expiration_Date__c > TODAY) '
                             + ' AND ucinn_ascendv2__Membership_Status__c = :ACTIVE_KEY '
                             + ' AND ucinn_portal_Is_Display_On_Portal__c = true ';

        // there are cases where we want empty Id Set
        if (societyMembershipIdSet != null) {
            queryString = queryString + ' AND Id IN :societyMembershipIdSet ';
        }

        societyMembershipList = Database.query(queryString);

        return societyMembershipList;
    }

    /**
     * Determines if society membership record is a lifetime record, and upserts it depending on fiscal year
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param societyMembershipRecord   society membership record to check if it is lifetime
     * @param honorRollOptOutValue      Is Show on Honor Roll New
     *
     * @return                          Return list of society memberships to upsert
     */
    public static List<ucinn_ascendv2__Society_Membership__c> parseSocietyMembershipToUpsert(Map<String, Object> params) {
        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToUpsertList = new List<ucinn_ascendv2__Society_Membership__c>();

        if (params == null || params.isEmpty()) {
            return societyMembershipsToUpsertList;
        }

        Date currentFiscalYearStartDate = (Date) params.get(CURRENT_FISCAL_YEAR_START_DATE);
        ucinn_ascendv2__Society_Membership__c societyMembershipRecord = (ucinn_ascendv2__Society_Membership__c) params.get(SOCIETY_MEMBERSHIP_RECORD);
        Boolean honorRollOptOutValue = (Boolean) params.get(HONOR_ROLL_OPT_OUT_VALUE);

        if (currentFiscalYearStartDate == null || societyMembershipRecord == null) {
            return societyMembershipsToUpsertList;
        }

        if (honorRollOptOutValue == null) {
            honorRollOptOutValue = societyMembershipRecord.ucinn_portal_Is_Show_on_Honor_Roll__c;
        }

        // 2020-01-01 (Member Since)
        // if lifetime membership start date is in the past, set expiration date of society membership and create new record (Similar to Honor Roll Name Logic with the starting fiscal year)
        if (societyMembershipRecord.ucinn_ascendv2__Giving_Society__r.ucinn_portal_Type__c == PORTAL_CONST_HonorRoll.GIVING_SOCIETY_TYPE_LIFETIME
                    && societyMembershipRecord.ucinn_ascendv2__Member_Since__c < currentFiscalYearStartDate) {
            // set expiration date & create new lifetime membership record
            societyMembershipRecord.ucinn_ascendv2__Expiration_Date__c = currentFiscalYearStartDate.addDays(-1); // this will handle leap years and roll back to previous year
            societyMembershipsToUpsertList.add(societyMembershipRecord);

            // do not preserve id, deep clone to retain values, do not preserve readonly timestamps, do not preserve auto numbers
            ucinn_ascendv2__Society_Membership__c newSocietyMembershipRecord = societyMembershipRecord.clone(false, true, false, false);

            newSocietyMembershipRecord.ucinn_ascendv2__Expiration_Date__c = null;
            newSocietyMembershipRecord.ucinn_ascendv2__Member_Since__c = currentFiscalYearStartDate;
            newSocietyMembershipRecord.ucinn_portal_Is_Show_on_Honor_Roll__c = honorRollOptOutValue;
            societyMembershipsToUpsertList.add(newSocietyMembershipRecord);
        } else {
            societyMembershipRecord.ucinn_portal_Is_Show_on_Honor_Roll__c = honorRollOptOutValue;
            societyMembershipsToUpsertList.add(societyMembershipRecord);
        }

        return societyMembershipsToUpsertList;
    }

    /**
     * Iterates through contact list and creates a set of spouse Ids
     *
     * @author              Phillip Nguyen
     * @since               1.0
     *
     * @param contactList   List of contacts to find spouse Id
     *
     * @return              Set of spouse Ids
     */
    public static Set<Id> getSpouseIdSet(Map<String,Object> params) {
        Set<Id> spouseIdSet = new Set<Id>();

        if (params == null || params.isEmpty()) {
            return spouseIdSet;
        }

        List<Contact> contactList = (List<Contact>) params.get(CONTACT_LIST);

        if (contactList == null || contactList.isEmpty()) {
            return spouseIdSet;
        }

        for (Contact eachContact : contactList) {
            if (String.isBlank(eachContact.ucinn_ascendv2__Preferred_Spouse__c)) {
                continue;
            }

            spouseIdSet.add(eachContact.ucinn_ascendv2__Preferred_Spouse__c);
        }

        return spouseIdSet;
    }

    /**
     * Formats contact info to create honor roll name
     * Format style for honor roll name: {First Name} {Last Name} [{Degree}'{Degree Year},]
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param contactRecord     contact record to parse for honor roll name
     *
     * @return                  Formatted honor roll name for contact
     */
    public static String formatHonorRollName(Map<String, Object> params) {
        String honorRollName = '';
        String degreeInformationString = '';

        if (params == null || params.isEmpty()) {
            return honorRollName;
        }

        Contact contactRecord = (Contact) params.get(CONTACT_RECORD);

        if (contactRecord == null) {
            return honorRollName;
        }

        honorRollName = honorRollName + contactRecord.ucinn_ascendv2__First_and_Last_Name_Formula__c;

        if (contactRecord.ucinn_ascendv2__Degree_Information_Contact__r == null || contactRecord.ucinn_ascendv2__Degree_Information_Contact__r.isEmpty()) {
            return honorRollName;
        }

        for (ucinn_ascendv2__Degree_Information__c eachDegreeInfo : contactRecord.ucinn_ascendv2__Degree_Information_Contact__r) {
            if (String.isBlank(eachDegreeInfo.ucinn_ascendv2__Major_Degree_Short_Formula__c) ||
                String.isBlank(eachDegreeInfo.ucinn_ascendv2__Conferred_Degree_Year__c) ||
                eachDegreeInfo.ucinn_ascendv2__Conferred_Degree_Year__c.length() < 4) {    
                
                continue;
            }

            if (String.isNotBlank(degreeInformationString)) {  // BS'19, PhD'21
                degreeInformationString = degreeInformationString + ', ';
            }

            // add degree onto string
            degreeInformationString = degreeInformationString + eachDegreeInfo.ucinn_ascendv2__Major_Degree_Short_Formula__c;

            // add degree year onto end of string
            degreeInformationString = degreeInformationString + '\'' + eachDegreeInfo.ucinn_ascendv2__Conferred_Degree_Year__c.substring(eachDegreeInfo.ucinn_ascendv2__Conferred_Degree_Year__c.length()-2);
        }

        honorRollName = honorRollName + ' ' + degreeInformationString;

        return honorRollName;
    }

    /**
     * Creates Contact Id to Contact Record mapping
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param contactList       List of Contacts
     * @return                  returns Contact Id to Contact Record Mapping
     */
    public static Map<Id,Contact> createContactIdToContactMap(Map<String,Object> params) {
        Map<Id, Contact> contactIdToContactRecordMap = new Map<Id, Contact>();

        if (params == null || params.isEmpty()) {
            return contactIdToContactRecordMap;
        }

        List<Contact> contactList = (List<Contact>) params.get(CONTACT_LIST);

        if (contactList == null || contactList.isEmpty()) {
            return contactIdToContactRecordMap;
        }

        for (Contact eachContact : contactList) {
            contactIdToContactRecordMap.put(eachContact.Id, eachContact);
        }

        return contactIdToContactRecordMap;
    }

    /**
     * Determines which honor roll name to put first for honor roll namr record (Alphabetical)
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param contactHonorRollName      Contact's Honor Roll Name
     * @param spouseHonorRollName       Spouse's Honor Roll Name
     *
     * @return                          Joint Honor Roll Name
     */
    public static String createJointHonorRollName(Map<String,Object> params) {
        String jointHonorRollName = '';

        if (params == null || params.isEmpty()) {
            return jointHonorRollName;
        }

        String contactHonorRollName = (String) params.get(CONTACT_HONOR_ROLL_NAME);
        String spouseHonorRollName = (String) params.get(SPOUSE_HONOR_ROLL_NAME);

        if (String.isBlank(contactHonorRollName) && String.isBlank(spouseHonorRollName)) {
            return jointHonorRollName;
        } else if (String.isNotBlank(contactHonorRollName) && String.isBlank(spouseHonorRollName)) {
            return contactHonorRollName;
        } else if (String.isBlank(contactHonorRollName) && String.isNotBlank(spouseHonorRollName)){
            return spouseHonorRollName;
        }

        if (contactHonorRollName <= spouseHonorRollName) {
            jointHonorRollName = contactHonorRollName + ' and ' + spouseHonorRollName;
        } else {
            jointHonorRollName = spouseHonorRollName + ' and ' + contactHonorRollName;
        }

        return jointHonorRollName;
    }

    /**
     * Update contact's honor roll opt out preference
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param contactId                 Contact Id to Update
     * @param honorRollOptOutValue      New Honor Roll Global Opt Out Value
     */
    public static void updateContactGlobalHonorRollOptOut(Map<String,Object> params) {
        if (params == null || params.isEmpty()) {
            return;
        }

        Boolean globalHonorRollOptOut = (Boolean) params.get(HONOR_ROLL_OPT_OUT_VALUE);
        Id contactId = (Id) params.get(CONTACT_ID);

        if (globalHonorRollOptOut == null || String.isBlank(contactId)) {
            return;
        }

        Contact contactToUpdate = new Contact(Id = contactId, ucinn_portal_Is_Honor_Roll_Opt_Out__c = globalHonorRollOptOut);
        update contactToUpdate;
    }
}