/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Data Creation used for fresh portal installations or sandbox refreshes. Creates demo records for portal modules
 *
 * @author  Phillip Nguyen
 * @since   1.0
 */
public without sharing class PORTAL_UTIL_DataCreation {
    public static final String CONTACT_ID = 'contactId';
    public static final String FIRST_NAME = 'firstName';
    public static final String MIDDLE_NAME = 'middleName';
    public static final String LAST_NAME = 'lastName';
    public static final String SUFFIX_CONST = 'suffix';
    public static final String FIRST_NAME_NICKNAME = 'firstNameNickname';
    public static final String LAST_NAME_NICKNAME = 'lastNameNickname';
    public static final String GENDER_CONST = 'gender';
    public static final String PRONOUNS_CONST = 'pronouns';
    public static final String BIRTH_DAY = 'birthDay';
    public static final String BIRTH_MONTH = 'birthMonth';
    public static final String BIRTH_YEAR = 'birthYear';
    public static final String PHONE_CONST = 'phone';
    public static final String EMAIL_CONST = 'email';
    public static final String CONTACT_EMAIL = 'contactEmail';
    public static final String ADDRESS_LINE_1 = 'addressLine1';
    public static final String CITY_CONST = 'city';
    public static final String STATE_CONST = 'state';
    public static final String COUNTRY_CONST = 'country';
    public static final String POSTAL_CODE = 'postalCode';
    public static final String ADDRESS_LATITUDE = 'addressLatitude';
    public static final String ADDRESS_LONGITUDE = 'addressLongitude';
    public static final String SCHOOL_INSTITUTION = 'schoolInstitution';
    public static final String SCHOOL_ACADEMIC_ORG = 'schoolAcademicOrg';
    public static final String SCHOOL_MAJOR_SPECIALTY = 'schoolMajorSpecialty';
    public static final String SCHOOL_MINOR = 'schoolMinor';
    public static final String SCHOOL_DEGREE = 'schoolDegree';
    public static final String SCHOOL_DEGREE_YEAR = 'schoolDegreeYear';
    public static final String NON_SCHOOL_INSTITUTION = 'nonSchoolInstitution';
    public static final String NON_SCHOOL_ACADEMIC_ORG = 'nonSchoolAcademicOrg';
    public static final String NON_SCHOOL_MAJOR_SPECIALTY = 'nonSchoolMajorSpecialty';
    public static final String NON_SCHOOL_MAJOR = 'nonSchoolMajor';
    public static final String NON_SCHOOL_DEGREE = 'nonSchoolDegree';
    public static final String NON_SCHOOL_DEGREE_YEAR = 'nonSchoolDegreeYear';
    public static final String EMPLOYER_CONST = 'employer';
    public static final String JOB_TITLE = 'jobTitle';
    public static final String SOCIAL_MEDIA_PLATFORM = 'socialMediaPlatform';
    public static final String SOCIAL_MEDIA_URL = 'socialMediaUrl';

    public class DataCreationException extends Exception {}

    public static Map<String, String> tonyStarkMap = new Map<String, String>{
        FIRST_NAME => 'Anthony',
        MIDDLE_NAME => 'Edward',
        LAST_NAME => 'Stark', 
        SUFFIX_CONST => 'Jr.',
        FIRST_NAME_NICKNAME => 'Tony',
        LAST_NAME_NICKNAME => 'Stark',
        GENDER_CONST => 'Male',
        PRONOUNS_CONST => 'He/Him/His',
        BIRTH_DAY => '29',
        BIRTH_MONTH => '5',
        BIRTH_YEAR => '1970',
        PHONE_CONST => '212-970-4133',
        EMAIL_CONST => 'anthonyStarkIronMan@gmail.com',
        ADDRESS_LINE_1 => '10880 Malibu Point',
        CITY_CONST => 'Malibu',
        STATE_CONST => 'California',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '90265',
        ADDRESS_LATITUDE => '34.0311358',
        ADDRESS_LONGITUDE => '-118.6926072',
        SCHOOL_INSTITUTION => 'MIT',
        SCHOOL_ACADEMIC_ORG => 'MIT School of Engineering',
        SCHOOL_MAJOR_SPECIALTY => 'Engineering Physics',
        SCHOOL_MINOR => 'Mathematics',
        SCHOOL_DEGREE => 'MS',
        SCHOOL_DEGREE_YEAR => '1998',
        NON_SCHOOL_INSTITUTION => 'Harvard',
        NON_SCHOOL_ACADEMIC_ORG => 'Harvard School of Engineering',
        NON_SCHOOL_MAJOR_SPECIALTY => 'Physics',
        NON_SCHOOL_MAJOR => 'Electrical Engineering',
        NON_SCHOOL_DEGREE => 'MS',
        NON_SCHOOL_DEGREE_YEAR => '1990',
        EMPLOYER_CONST => 'Stark Industries',
        JOB_TITLE => 'CEO of Stark Industries',
        SOCIAL_MEDIA_PLATFORM => 'Twitter',
        SOCIAL_MEDIA_URL => 'twitter.com/iron_man'
    };

    public static Map<String, String> steveRogersMap = new Map<String, String>{
        FIRST_NAME => 'Steven',
        MIDDLE_NAME => 'Grant',
        LAST_NAME => 'Rogers',
        SUFFIX_CONST => null,
        FIRST_NAME_NICKNAME => 'Steve',
        LAST_NAME_NICKNAME => 'Rogers',
        GENDER_CONST => 'Male',
        PRONOUNS_CONST => 'He/Him/His',
        BIRTH_DAY => '4',
        BIRTH_MONTH => '7',
        BIRTH_YEAR => '1920',
        PHONE_CONST => '123-456-7890',
        EMAIL_CONST => 'cap@test.com',
        ADDRESS_LINE_1 => '4 Pennsylvania Plaza',
        CITY_CONST => 'New York',
        STATE_CONST => 'New York',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '10001',
        ADDRESS_LATITUDE => '40.7505906',
        ADDRESS_LONGITUDE => '-73.9977892',
        SCHOOL_INSTITUTION => null,
        SCHOOL_ACADEMIC_ORG => null,
        SCHOOL_MAJOR_SPECIALTY => null,
        SCHOOL_MINOR => null,
        SCHOOL_DEGREE => null,
        SCHOOL_DEGREE_YEAR => null,
        NON_SCHOOL_INSTITUTION => null,
        NON_SCHOOL_ACADEMIC_ORG => null,
        NON_SCHOOL_MAJOR_SPECIALTY => null,
        NON_SCHOOL_MAJOR => null,
        NON_SCHOOL_DEGREE => null,
        NON_SCHOOL_DEGREE_YEAR => null,
        EMPLOYER_CONST => 'Strategic Homeland Intervention, Enforcement and Logistics Division',
        JOB_TITLE => 'Consultant',
        SOCIAL_MEDIA_PLATFORM => 'Facebook',
        SOCIAL_MEDIA_URL => 'facebook.com/CaptainAmerica'
    };

    public static Map<String, String> bruceBannerMap = new Map<String, String>{
        FIRST_NAME => 'Bruce',
        MIDDLE_NAME => null,
        LAST_NAME => 'Banner',
        SUFFIX_CONST => null,
        FIRST_NAME_NICKNAME => 'Bruce',
        LAST_NAME_NICKNAME => 'Banner',
        GENDER_CONST => 'Male',
        PRONOUNS_CONST => 'He/Him/His',
        BIRTH_DAY => '8',
        BIRTH_MONTH => '5',
        BIRTH_YEAR => '1973',
        PHONE_CONST => '123-456-7891',
        EMAIL_CONST => 'angry@test.com',
        ADDRESS_LINE_1 => '123 Main St',
        CITY_CONST => 'Dayton',
        STATE_CONST => 'Ohio',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '45377',
        ADDRESS_LATITUDE => '39.8114756',
        ADDRESS_LONGITUDE => '-84.3669674',
        SCHOOL_INSTITUTION => null,
        SCHOOL_ACADEMIC_ORG => null,
        SCHOOL_MAJOR_SPECIALTY => null,
        SCHOOL_MINOR => null,
        SCHOOL_DEGREE => null,
        SCHOOL_DEGREE_YEAR => null,
        NON_SCHOOL_INSTITUTION => 'Harvard',
        NON_SCHOOL_ACADEMIC_ORG => 'Harvard Department of Physics',
        NON_SCHOOL_MAJOR_SPECIALTY => 'Nuclear Physics',
        NON_SCHOOL_MAJOR => 'Nuclear Physics',
        NON_SCHOOL_DEGREE => 'MS',
        NON_SCHOOL_DEGREE_YEAR => '1990',
        EMPLOYER_CONST => 'Strategic Homeland Intervention, Enforcement and Logistics Division',
        JOB_TITLE => 'Contractor',
        SOCIAL_MEDIA_PLATFORM => 'Facebook',
        SOCIAL_MEDIA_URL => 'facebook.com/Hulk'
    };

    public static Map<String, String> thorMap = new Map<String, String>{
        FIRST_NAME => 'Thor',
        MIDDLE_NAME => null,
        LAST_NAME => 'Odinson',
        SUFFIX_CONST => null,
        FIRST_NAME_NICKNAME => 'Thor',
        LAST_NAME_NICKNAME => 'Odinson',
        GENDER_CONST => 'Male',
        PRONOUNS_CONST => 'He/Him/His',
        BIRTH_DAY => '1',
        BIRTH_MONTH => '1',
        BIRTH_YEAR => '1900',
        PHONE_CONST => '123-456-7892',
        EMAIL_CONST => 'godofthunder@test.com',
        ADDRESS_LINE_1 => '321 Main St',
        CITY_CONST => 'Albuquerque',
        STATE_CONST => 'New Mexico',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '87101',
        ADDRESS_LATITUDE => '35.0825794',
        ADDRESS_LONGITUDE => '-106.8412904',
        SCHOOL_INSTITUTION => null,
        SCHOOL_ACADEMIC_ORG => null,
        SCHOOL_MAJOR_SPECIALTY => null,
        SCHOOL_MINOR => null,
        SCHOOL_DEGREE => null,
        SCHOOL_DEGREE_YEAR => null,
        NON_SCHOOL_INSTITUTION => null,
        NON_SCHOOL_ACADEMIC_ORG => null,
        NON_SCHOOL_MAJOR_SPECIALTY => null,
        NON_SCHOOL_MAJOR => null,
        NON_SCHOOL_DEGREE => null,
        NON_SCHOOL_DEGREE_YEAR => null,
        EMPLOYER_CONST => 'Strategic Homeland Intervention, Enforcement and Logistics Division',
        JOB_TITLE => 'Consulting God',
        SOCIAL_MEDIA_PLATFORM => 'Instagram',
        SOCIAL_MEDIA_URL => 'instagram.com/thorofficial'
    };

    public static Map<String, String> natashaRomanoffMap = new Map<String, String>{
        FIRST_NAME => 'Natalia',
        MIDDLE_NAME => 'Alianovna',
        LAST_NAME => 'Romanova',
        SUFFIX_CONST => null,
        FIRST_NAME_NICKNAME => 'Natasha',
        LAST_NAME_NICKNAME => 'Romanoff',
        GENDER_CONST => 'Female',
        PRONOUNS_CONST => 'She/Her/Hers',
        BIRTH_DAY => '3',
        BIRTH_MONTH => '12',
        BIRTH_YEAR => '1984',
        PHONE_CONST => '123-456-7893',
        EMAIL_CONST => 'blackwidow@test.com',
        ADDRESS_LINE_1 => '1111 S Figueroa St',
        CITY_CONST => 'Los Angeles',
        STATE_CONST => 'California',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '90015',
        ADDRESS_LATITUDE => '34.0424169',
        ADDRESS_LONGITUDE => '-118.2673759',
        SCHOOL_INSTITUTION => 'MIT',
        SCHOOL_ACADEMIC_ORG => 'MIT School of Business',
        SCHOOL_MAJOR_SPECIALTY => 'Economics',
        SCHOOL_MINOR => null,
        SCHOOL_DEGREE => 'BA',
        SCHOOL_DEGREE_YEAR => '2009',
        NON_SCHOOL_INSTITUTION => null,
        NON_SCHOOL_ACADEMIC_ORG => null,
        NON_SCHOOL_MAJOR_SPECIALTY => null,
        NON_SCHOOL_MAJOR => null,
        NON_SCHOOL_DEGREE => null,
        NON_SCHOOL_DEGREE_YEAR => null,
        EMPLOYER_CONST => 'Strategic Homeland Intervention, Enforcement and Logistics Division',
        JOB_TITLE => 'Agent',
        SOCIAL_MEDIA_PLATFORM => 'Facebook',
        SOCIAL_MEDIA_URL => 'facebook.com/blackwidow/'
    };

    public static Map<String, String> clintBartonMap = new Map<String, String>{
        FIRST_NAME => 'Clinton',
        MIDDLE_NAME => 'Francis',
        LAST_NAME => 'Barton',
        SUFFIX_CONST => null,
        FIRST_NAME_NICKNAME => 'Clint',
        LAST_NAME_NICKNAME => 'Barton',
        GENDER_CONST => 'Male',
        PRONOUNS_CONST => 'He/Him/His',
        BIRTH_DAY => '1',
        BIRTH_MONTH => '9',
        BIRTH_YEAR => '1975',
        PHONE_CONST => '123-456-7894',
        EMAIL_CONST => 'hawkeye@test.com',
        ADDRESS_LINE_1 => '456 Carver Hawkeye Arena',
        CITY_CONST => 'Iowa City',
        STATE_CONST => 'Iowa',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '52242',
        ADDRESS_LATITUDE => '41.663916',
        ADDRESS_LONGITUDE => '-91.5565379',
        SCHOOL_INSTITUTION => null,
        SCHOOL_ACADEMIC_ORG => null,
        SCHOOL_MAJOR_SPECIALTY => null,
        SCHOOL_MINOR => null,
        SCHOOL_DEGREE => null,
        SCHOOL_DEGREE_YEAR => null,
        NON_SCHOOL_INSTITUTION => 'University of Iowa',
        NON_SCHOOL_ACADEMIC_ORG => 'College of Nursing',
        NON_SCHOOL_MAJOR_SPECIALTY => 'Nursing',
        NON_SCHOOL_MAJOR => 'Nursing',
        NON_SCHOOL_DEGREE => 'BS',
        NON_SCHOOL_DEGREE_YEAR => '2000',
        EMPLOYER_CONST => 'Strategic Homeland Intervention, Enforcement and Logistics Division',
        JOB_TITLE => 'Agent',
        SOCIAL_MEDIA_PLATFORM => 'Facebook',
        SOCIAL_MEDIA_URL => 'facebook.com/hawkeyeofficial/'
    };

    public static Map<String, String> pepperPottsMap = new Map<String, String>{
        FIRST_NAME => 'Virginia',
        MIDDLE_NAME => null,
        LAST_NAME => 'Potts',
        SUFFIX_CONST => null,
        FIRST_NAME_NICKNAME => 'Pepper',
        LAST_NAME_NICKNAME => 'Potts',
        GENDER_CONST => 'Female',
        PRONOUNS_CONST => 'She/Her/Hers',
        BIRTH_DAY => '10',
        BIRTH_MONTH => '4',
        BIRTH_YEAR => '1972',
        PHONE_CONST => '123-456-7895',
        EMAIL_CONST => 'pepperpotts@test.com',
        ADDRESS_LINE_1 => '20 W 34th St',
        CITY_CONST => 'New York',
        STATE_CONST => 'New York',
        COUNTRY_CONST => 'United States',
        POSTAL_CODE => '10001',
        ADDRESS_LATITUDE => '40.7487698',
        ADDRESS_LONGITUDE => '-73.9905957',
        SCHOOL_INSTITUTION => 'MIT',
        SCHOOL_ACADEMIC_ORG => 'MIT School of Business',
        SCHOOL_MAJOR_SPECIALTY => 'Finance',
        SCHOOL_MINOR => null,
        SCHOOL_DEGREE => 'MBA',
        SCHOOL_DEGREE_YEAR => '2010',
        NON_SCHOOL_INSTITUTION => null,
        NON_SCHOOL_ACADEMIC_ORG => null,
        NON_SCHOOL_MAJOR_SPECIALTY => null,
        NON_SCHOOL_MAJOR => null,
        NON_SCHOOL_DEGREE => null,
        NON_SCHOOL_DEGREE_YEAR => null,
        EMPLOYER_CONST => 'Stark Industries',
        JOB_TITLE => 'CEO',
        SOCIAL_MEDIA_PLATFORM => 'Twitter',
        SOCIAL_MEDIA_URL => 'twitter.com/iron_man'
    };

    public static Map<String, Map<String, String>> heroContactMaps = new Map<String, Map<String, String>>{
        tonyStarkMap.get(LAST_NAME) => tonyStarkMap,
        steveRogersMap.get(LAST_NAME) => steveRogersMap,
        bruceBannerMap.get(LAST_NAME) => bruceBannerMap,
        thorMap.get(LAST_NAME) => thorMap,
        natashaRomanoffMap.get(LAST_NAME) => natashaRomanoffMap,
        clintBartonMap.get(LAST_NAME) => clintBartonMap,
        pepperPottsMap.get(LAST_NAME) => pepperPottsMap
    };

    /**
     * Function that creates ALL demo data, this includes ascend Objects and standard objects.
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    public static void createAllData() {
        checkAndAssignForExistingConstituents();
        createMyInformationAndDirectoryData();
        createStaticContentManagementData();
        createEventsData();
        createGivingSocietyHonorRollData();
        createMembershipData();
        createOnlineGivingAndGivingHistoryData();
        createNewsletterHtmlTemplate();
        createDefaultZone();
        createZoneDataWithConstituent();
        createNewsAndLearningData();
        createVolunteerDataWithConstituent();
        createJobsBoardData();
        createMatchingRule();
        createDownloadableContentData();
    }

    /**
     * Function that creates all data for a Interim to Contact Matching Rule
     *
     * @author  Todd Shinto
     * @since   1.16
     */
    @future
    public static void createMatchingRule() {
        // MATCHING KEY RULES
        Map<String, ucinn_ascendv2__Matching_Key_Rule__c> matchingKeyRuleMap = new Map<String, ucinn_ascendv2__Matching_Key_Rule__c>();
        ucinn_ascendv2__Matching_Key_Rule__c interimFirstKey = new ucinn_ascendv2__Matching_Key_Rule__c(
            Name = 'Interim First Key',
            ucinn_ascendv2__Key_Value_Field_API_Name__c = 'ucinn_ascendv2__Matching_Key_Value_1__c',
            ucinn_ascendv2__Object_Name__c = 'ucinn_ascendv2__Interim__c',
            ucinn_ascendv2__Is_for_Source_Object_Use__c = true
        );
        matchingKeyRuleMap.put('interimFirstKey', interimFirstKey);
        ucinn_ascendv2__Matching_Key_Rule__c interimSecondKey = new ucinn_ascendv2__Matching_Key_Rule__c(
            Name = 'Interim Second Key',
            ucinn_ascendv2__Key_Value_Field_API_Name__c = 'ucinn_ascendv2__Matching_Key_Value_2__c',
            ucinn_ascendv2__Object_Name__c = 'ucinn_ascendv2__Interim__c',
            ucinn_ascendv2__Is_for_Source_Object_Use__c = true
        );
        matchingKeyRuleMap.put('interimSecondKey', interimSecondKey);
        ucinn_ascendv2__Matching_Key_Rule__c interimThirdKey = new ucinn_ascendv2__Matching_Key_Rule__c(
            Name = 'Interim Third Key',
            ucinn_ascendv2__Key_Value_Field_API_Name__c = 'ucinn_ascendv2__Matching_Key_Value_3__c',
            ucinn_ascendv2__Object_Name__c = 'ucinn_ascendv2__Interim__c',
            ucinn_ascendv2__Is_for_Source_Object_Use__c = true
        );
        matchingKeyRuleMap.put('interimThirdKey', interimThirdKey);

        ucinn_ascendv2__Matching_Key_Rule__c contactFirstKey = new ucinn_ascendv2__Matching_Key_Rule__c(
            Name = 'Contact First Key',
            ucinn_ascendv2__Key_Value_Field_API_Name__c = 'ucinn_ascendv2__Matching_Key_Value_1__c',
            ucinn_ascendv2__Object_Name__c = 'Contact',
            ucinn_ascendv2__Is_for_Source_Object_Use__c = true,
            ucinn_ascendv2__Is_for_Target_Object_Use__c = true,
            ucinn_ascendv2__Create_Matching_Keys__c = true,
            ucinn_ascendv2__Key_Value_Set_Created__c = true
        );
        matchingKeyRuleMap.put('contactFirstKey', contactFirstKey);
        ucinn_ascendv2__Matching_Key_Rule__c contactSecondKey = new ucinn_ascendv2__Matching_Key_Rule__c(
            Name = 'Contact Second Key',
            ucinn_ascendv2__Key_Value_Field_API_Name__c = 'ucinn_ascendv2__Matching_Key_Value_2__c',
            ucinn_ascendv2__Object_Name__c = 'Contact',
            ucinn_ascendv2__Is_for_Source_Object_Use__c = true,
            ucinn_ascendv2__Is_for_Target_Object_Use__c = true,
            ucinn_ascendv2__Create_Matching_Keys__c = true,
            ucinn_ascendv2__Key_Value_Set_Created__c = true
        );
        matchingKeyRuleMap.put('contactSecondKey', contactSecondKey);
        ucinn_ascendv2__Matching_Key_Rule__c contactThirdKey = new ucinn_ascendv2__Matching_Key_Rule__c(
            Name = 'Contact Third Key',
            ucinn_ascendv2__Key_Value_Field_API_Name__c = 'ucinn_ascendv2__Matching_Key_Value_3__c',
            ucinn_ascendv2__Object_Name__c = 'Contact',
            ucinn_ascendv2__Is_for_Source_Object_Use__c = true,
            ucinn_ascendv2__Is_for_Target_Object_Use__c = true,
            ucinn_ascendv2__Create_Matching_Keys__c = true,
            ucinn_ascendv2__Key_Value_Set_Created__c = true
        );
        matchingKeyRuleMap.put('contactThirdKey', contactThirdKey);

        insert matchingKeyRuleMap.values();

        // MATCHING KEYS
        List<ucinn_ascendv2__Matching_Keys__c> matchingKeysToInsert = new List<ucinn_ascendv2__Matching_Keys__c>();

        ucinn_ascendv2__Matching_Keys__c interimFirstKeyFirstKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('interimFirstKey').Id,
            Name = 'First Key',
            ucinn_ascendv2__Creation_Method__c = 'FirstName(1,1)',
            ucinn_ascendv2__Field_API_Name__c = 'ucinn_ascendv2__First_Name__c',
            ucinn_ascendv2__Field_Index__c = 1
        );
        matchingKeysToInsert.add(interimFirstKeyFirstKey);
        ucinn_ascendv2__Matching_Keys__c interimFirstKeySecondKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('interimFirstKey').Id,
            Name = 'Second Key',
            ucinn_ascendv2__Creation_Method__c = 'First 4 Characters',
            ucinn_ascendv2__Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c',
            ucinn_ascendv2__Field_Index__c = 2
        );
        matchingKeysToInsert.add(interimFirstKeySecondKey);
        ucinn_ascendv2__Matching_Keys__c interimSecondKeyFirstKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('interimSecondKey').Id,
            Name = 'First Key',
            ucinn_ascendv2__Creation_Method__c = 'First 3 Characters',
            ucinn_ascendv2__Field_API_Name__c = 'ucinn_ascendv2__First_Name__c',
            ucinn_ascendv2__Field_Index__c = 1
        );
        matchingKeysToInsert.add(interimSecondKeyFirstKey);
        ucinn_ascendv2__Matching_Keys__c interimSecondKeySecondKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('interimSecondKey').Id,
            Name = 'Second Key',
            ucinn_ascendv2__Creation_Method__c = 'LastName(Double Metaphone)',
            ucinn_ascendv2__Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c',
            ucinn_ascendv2__Field_Index__c = 2
        );
        matchingKeysToInsert.add(interimSecondKeySecondKey);
        ucinn_ascendv2__Matching_Keys__c interimThirdKeyFirstKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('interimThirdKey').Id,
            Name = 'First Key',
            ucinn_ascendv2__Creation_Method__c = 'FirstName(1,1)',
            ucinn_ascendv2__Field_API_Name__c = 'ucinn_ascendv2__First_Name__c',
            ucinn_ascendv2__Field_Index__c = 1
        );
        matchingKeysToInsert.add(interimThirdKeyFirstKey);
        ucinn_ascendv2__Matching_Keys__c interimThirdKeySecondKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('interimThirdKey').Id,
            Name = 'Second Key',
            ucinn_ascendv2__Creation_Method__c = 'LastName(Double Metaphone)',
            ucinn_ascendv2__Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c',
            ucinn_ascendv2__Field_Index__c = 2
        );
        matchingKeysToInsert.add(interimThirdKeySecondKey);

        ucinn_ascendv2__Matching_Keys__c contactFirstKeyFirstKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('contactFirstKey').Id,
            Name = 'First Key',
            ucinn_ascendv2__Creation_Method__c = 'FirstName(1,1)',
            ucinn_ascendv2__Field_API_Name__c = 'FirstName',
            ucinn_ascendv2__Field_Index__c = 1
        );
        matchingKeysToInsert.add(contactFirstKeyFirstKey);
        ucinn_ascendv2__Matching_Keys__c contactFirstKeySecondKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('contactFirstKey').Id,
            Name = 'Second Key',
            ucinn_ascendv2__Creation_Method__c = 'First 4 Characters',
            ucinn_ascendv2__Field_API_Name__c = 'LastName',
            ucinn_ascendv2__Field_Index__c = 2
        );
        matchingKeysToInsert.add(contactFirstKeySecondKey);
        ucinn_ascendv2__Matching_Keys__c contactSecondKeyFirstKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('contactSecondKey').Id,
            Name = 'First Key',
            ucinn_ascendv2__Creation_Method__c = 'First 3 Characters',
            ucinn_ascendv2__Field_API_Name__c = 'FirstName',
            ucinn_ascendv2__Field_Index__c = 1
        );
        matchingKeysToInsert.add(contactSecondKeyFirstKey);
        ucinn_ascendv2__Matching_Keys__c contactSecondKeySecondKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('contactSecondKey').Id,
            Name = 'Second Key',
            ucinn_ascendv2__Creation_Method__c = 'LastName(Double Metaphone)',
            ucinn_ascendv2__Field_API_Name__c = 'LastName',
            ucinn_ascendv2__Field_Index__c = 2
        );
        matchingKeysToInsert.add(contactSecondKeySecondKey);
        ucinn_ascendv2__Matching_Keys__c contactThirdKeyFirstKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('contactThirdKey').Id,
            Name = 'First Key',
            ucinn_ascendv2__Creation_Method__c = 'FirstName(1,1)',
            ucinn_ascendv2__Field_API_Name__c = 'FirstName',
            ucinn_ascendv2__Field_Index__c = 1
        );
        matchingKeysToInsert.add(contactThirdKeyFirstKey);
        ucinn_ascendv2__Matching_Keys__c contactThirdKeySecondKey = new ucinn_ascendv2__Matching_Keys__c(
            ucinn_ascendv2__Matching_Key_Rule__c = matchingKeyRuleMap.get('contactThirdKey').Id,
            Name = 'Second Key',
            ucinn_ascendv2__Creation_Method__c = 'LastName(Double Metaphone)',
            ucinn_ascendv2__Field_API_Name__c = 'LastName',
            ucinn_ascendv2__Field_Index__c = 2
        );
        matchingKeysToInsert.add(contactThirdKeySecondKey);

        insert matchingKeysToInsert;

        // MATCHING RULE
        ucinn_ascendv2__Matching_Rule__c matchingRule = new ucinn_ascendv2__Matching_Rule__c(
            Name = 'Interim to Contact',
            ucinn_ascendv2__Common_Threshold__c = 100,
            ucinn_ascendv2__Is_Active__c = true,
            ucinn_ascendv2__Source_Object_Name__c = 'ucinn_ascendv2__Interim__c',
            ucinn_ascendv2__Target_Object_Name__c = 'Contact',
            ucinn_ascendv2__Source_Matching_Rule_1__c = matchingKeyRuleMap.get('interimFirstKey').Id,
            ucinn_ascendv2__Source_Matching_Rule_2__c = matchingKeyRuleMap.get('interimSecondKey').Id,
            ucinn_ascendv2__Source_Matching_Rule_3__c = matchingKeyRuleMap.get('interimThirdKey').Id,
            ucinn_ascendv2__Target_Matching_Rule_1__c = matchingKeyRuleMap.get('contactFirstKey').Id,
            ucinn_ascendv2__Target_Matching_Rule_2__c = matchingKeyRuleMap.get('contactSecondKey').Id,
            ucinn_ascendv2__Target_Matching_Rule_3__c = matchingKeyRuleMap.get('contactThirdKey').Id
        );
        insert matchingRule;

        // GLOBAL MATCHING
        ucinn_ascendv2__Global_Matching__c globalMatching = new ucinn_ascendv2__Global_Matching__c(
            Name = 'Email',
            ucinn_ascendv2__Matching_Rule__c = matchingRule.Id,
            ucinn_ascendv2__Score__c = 500,
            ucinn_ascendv2__Source_Object_Field__c = 'ucinn_ascendv2__Email_1__c',
            ucinn_ascendv2__Target_Object_Field__c = 'ucinn_ascendv2__Email_Address__c',
            ucinn_ascendv2__Target_Object_Name__c = 'ucinn_ascendv2__Email__c',
            ucinn_ascendv2__Target_Object_Result_Field__c = 'ucinn_ascendv2__Contact__c'
        );
        insert globalMatching;

        // MATCHING FIELDS
        List<ucinn_ascendv2__Matching_Field__c> matchingFieldsToInsert = new List<ucinn_ascendv2__Matching_Field__c>();
        ucinn_ascendv2__Matching_Field__c firstNameMatchingField = new ucinn_ascendv2__Matching_Field__c(
            Name = 'First Name',
            ucinn_ascendv2__Matching_Rule__c = matchingRule.Id,
            ucinn_ascendv2__Matching_Method__c = 'Fuzzy: First Name',
            ucinn_ascendv2__Matching_Score__c = 50,
            ucinn_ascendv2__Source_Object_Field__c = 'ucinn_ascendv2__First_Name__c',
            ucinn_ascendv2__Target_Related_List_Object_Field__c = 'ucinn_ascendv2__First_Name__c',
            ucinn_ascendv2__Target_Related_List_Object_Name__c = 'Contact_Names_Contact__r'
        );
        matchingFieldsToInsert.add(firstNameMatchingField);
        ucinn_ascendv2__Matching_Field__c lastNameMatchingField = new ucinn_ascendv2__Matching_Field__c(
            Name = 'Last Name',
            ucinn_ascendv2__Matching_Rule__c = matchingRule.Id,
            ucinn_ascendv2__Matching_Method__c = 'Fuzzy: Last Name',
            ucinn_ascendv2__Matching_Score__c = 60,
            ucinn_ascendv2__Source_Object_Field__c = 'ucinn_ascendv2__Last_Name__c',
            ucinn_ascendv2__Target_Related_List_Object_Field__c = 'ucinn_ascendv2__Last_Name__c',
            ucinn_ascendv2__Target_Related_List_Object_Name__c = 'Contact_Names_Contact__r'
        );
        matchingFieldsToInsert.add(lastNameMatchingField);
        ucinn_ascendv2__Matching_Field__c phoneMatchingField = new ucinn_ascendv2__Matching_Field__c(
            Name = 'Phone',
            ucinn_ascendv2__Matching_Rule__c = matchingRule.Id,
            ucinn_ascendv2__Matching_Method__c = 'Fuzzy: Phone',
            ucinn_ascendv2__Matching_Score__c = 20,
            ucinn_ascendv2__Source_Object_Field__c = 'ucinn_ascendv2__Phone_1__c',
            ucinn_ascendv2__Target_Related_List_Object_Field__c = 'ucinn_ascendv2__Phone_Number__c',
            ucinn_ascendv2__Target_Related_List_Object_Name__c = 'Phones_Contact__r'
        );
        matchingFieldsToInsert.add(phoneMatchingField);
        ucinn_ascendv2__Matching_Field__c emailMatchingField = new ucinn_ascendv2__Matching_Field__c(
            Name = 'Email',
            ucinn_ascendv2__Matching_Rule__c = matchingRule.Id,
            ucinn_ascendv2__Matching_Method__c = 'Fuzzy: Email',
            ucinn_ascendv2__Matching_Score__c = 40,
            ucinn_ascendv2__Source_Object_Field__c = 'ucinn_ascendv2__Email_1__c',
            ucinn_ascendv2__Target_Related_List_Object_Field__c = 'ucinn_ascendv2__Email_Address__c',
            ucinn_ascendv2__Target_Related_List_Object_Name__c = 'Emails_Contact__r'
        );
        matchingFieldsToInsert.add(emailMatchingField);

        insert matchingFieldsToInsert;

    }

    /**
     * Function that creates ONLY ascend Portal data, this does NOT include constituents, accounts, etc
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    public static void createAscendPortalData() {
        createStaticContentManagementData();
        createPortalOnlyEventsData();
        createNewsletterHtmlTemplate();
        createDefaultZone();
        createZoneDataWithoutConstituent();
        createNewsAndLearningData();
        createVolunteerDataWithoutConstituent();
        createJobsBoardData();
        createDownloadableContentData();
    }

    /**
     * Function that creates My Information and Directory Data (since they are usually linked)
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createMyInformationAndDirectoryData() {
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        Contact dummyContact = new Contact(FirstName = 'My Information Dummy Contact', LastName='Do Not Delete This Record', ucinn_portal_Is_Directory_Opt_Out__c = true);
        insert new List<Contact>{dummyContact};

        Account dummyDegreeInstitution = new Account(Name = 'Dummy Degree Institution Organization *DO NOT DELETE*');
        Account dummyEmployer = new Account(Name = 'Dummy Employer Organization *DO NOT DELETE*');
        insert new List<Account>{dummyDegreeInstitution, dummyEmployer};

        // Data structures for first pass through contact maps
        List<ucinn_ascendv2__Contact_Name__c> contactNameList = new List<ucinn_ascendv2__Contact_Name__c>();
        List<ucinn_ascendv2__Address__c> addressList = new List<ucinn_ascendv2__Address__c>();
        List<Account> accountList = new List<Account>();
        List<ucinn_ascendv2__Academic_Organization__c> academicOrgList = new List<ucinn_ascendv2__Academic_Organization__c>();
        List<ucinn_ascendv2__Social_Media__c> socialMediaList = new List<ucinn_ascendv2__Social_Media__c>();

        // for storing IDs for use in later iterations
        Map<Id, ucinn_ascendv2__Address__c> contactIdToAddressMap = new Map<Id, ucinn_ascendv2__Address__c>();
        Map<String, Account> nameToAccountMap = new Map<String, Account>();
        Map<String, ucinn_ascendv2__Academic_Organization__c> nameToAcademicOrgMap = new Map<String, ucinn_ascendv2__Academic_Organization__c>();

        // Data structures for second pass through contact maps
        List<ucinn_ascendv2__Post_Code__c> postCodeList = new List<ucinn_ascendv2__Post_Code__c>();
        List<ucinn_ascendv2__Minor_Code__c> minorCodeList = new List<ucinn_ascendv2__Minor_Code__c>();
        List<ucinn_ascendv2__Address_Relation__c> addressRelationList = new List<ucinn_ascendv2__Address_Relation__c>();
        List<ucinn_ascendv2__Affiliation__c> affiliationList = new List<ucinn_ascendv2__Affiliation__c>();

        // keys are post code/minor code name concatenated with related academic org Id
        Map<String, ucinn_ascendv2__Post_Code__c> nameAndOrgIdToPostCodeMap = new Map<String, ucinn_ascendv2__Post_Code__c>();
        Map<String, ucinn_ascendv2__Minor_Code__c> nameAndOrgIdToMinorCodeMap = new Map<String, ucinn_ascendv2__Minor_Code__c>();

        // Data structure and record ID for third pass through contact maps
        List<ucinn_ascendv2__Degree_Information__c> degreeList = new List<ucinn_ascendv2__Degree_Information__c>();
        String schoolDegreeInformation = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('School_Degree_Information').getRecordTypeId();
        String nonSchoolDegreeInformation = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('Non_School_Degree_Information').getRecordTypeId();

        // First iteration
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            // Contact Names
            contactNameList.add(new ucinn_ascendv2__Contact_Name__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Type__c='Full Name',
                ucinn_ascendv2__First_Name__c=eachContactMap.get(FIRST_NAME),
                ucinn_ascendv2__Middle_Name__c=eachContactMap.get(MIDDLE_NAME),
                ucinn_ascendv2__Last_Name__c=eachContactMap.get(LAST_NAME),
                ucinn_portal_Is_Display_On_Portal__c=true,
                ucinn_ascendv2__Suffix__c=eachContactMap.get(SUFFIX_CONST))
            );

            contactNameList.add(new ucinn_ascendv2__Contact_Name__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Type__c='Maiden',
                ucinn_ascendv2__First_Name__c=eachContactMap.get(FIRST_NAME),
                ucinn_ascendv2__Middle_Name__c=eachContactMap.get(MIDDLE_NAME),
                ucinn_ascendv2__Last_Name__c=eachContactMap.get(LAST_NAME),
                ucinn_portal_Is_Display_On_Portal__c=true)
            );

            contactNameList.add(new ucinn_ascendv2__Contact_Name__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Type__c='Nickname',
                ucinn_ascendv2__First_Name__c=eachContactMap.get(FIRST_NAME_NICKNAME),
                ucinn_ascendv2__Last_Name__c=eachContactMap.get(LAST_NAME_NICKNAME),
                ucinn_portal_Is_Display_On_Portal__c=true)
            );

            contactNameList.add(new ucinn_ascendv2__Contact_Name__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Type__c='Directory',
                ucinn_ascendv2__First_Name__c=eachContactMap.get(FIRST_NAME_NICKNAME),
                ucinn_ascendv2__Last_Name__c=eachContactMap.get(LAST_NAME_NICKNAME),
                ucinn_portal_Is_Display_On_Portal__c=true)
            );

            // Phone - ascend trigger bug: when Org_Wide_Configuration__c Is_Multiple_Current_Phones_Enabled__c = false
            // the trigger assumes all phones are for the same constituent, so it changes status Current to Former
            insert new ucinn_ascendv2__Phone__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Type__c='Home',
                ucinn_ascendv2__Phone_Number__c=eachContactMap.get(PHONE_CONST),
                ucinn_portal_Is_Display_On_Portal__c=true,
                ucinn_portal_Is_Show_On_Directory__c=true,
                ucinn_ascendv2__Status__c='Current',
                ucinn_ascendv2__Is_Preferred__c = true
            );

            // Email - same ascend trigger bug as phone but for ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c
            insert new ucinn_ascendv2__Email__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Type__c='Personal',
                ucinn_ascendv2__Email_Address__c=eachContactMap.get(EMAIL_CONST),
                ucinn_portal_Is_Display_On_Portal__c=true,
                ucinn_portal_Is_Show_On_Directory__c=true,
                ucinn_ascendv2__Status__c='Current',
                ucinn_ascendv2__Is_Preferred__c = true
            );

            // Address
            Decimal latitude = eachContactMap.get(ADDRESS_LATITUDE) != null ? Decimal.valueOf(eachContactMap.get(ADDRESS_LATITUDE)) : null;
            Decimal longitude = eachContactMap.get(ADDRESS_LONGITUDE) != null ? Decimal.valueOf(eachContactMap.get(ADDRESS_LONGITUDE)) : null;
            ucinn_ascendv2__Address__c address = new ucinn_ascendv2__Address__c(
                ucinn_ascendv2__Address_Line_1__c=eachContactMap.get(ADDRESS_LINE_1),
                ucinn_ascendv2__City__c=eachContactMap.get(CITY_CONST),
                ucinn_ascendv2__State__c=eachContactMap.get(STATE_CONST),
                ucinn_ascendv2__Country__c=eachContactMap.get(COUNTRY_CONST),
                ucinn_ascendv2__Postal_Code__c=eachContactMap.get(POSTAL_CODE),
                ucinn_ascendv2__Location__latitude__s = latitude,
                ucinn_ascendv2__Location__longitude__s = longitude
            );

            addressList.add(address);
            contactIdToAddressMap.put(eachContactMap.get(CONTACT_ID), address);

            // Accounts
            String schoolInstitutionName = eachContactMap.get(SCHOOL_INSTITUTION);
            String nonSchoolInstitutionName = eachContactMap.get(NON_SCHOOL_INSTITUTION);
            String employerName = eachContactMap.get(EMPLOYER_CONST);

            if (String.isNotBlank(schoolInstitutionName) && nameToAccountMap.containsKey(schoolInstitutionName) != true) {
                Account schoolInstitution = new Account(Name=schoolInstitutionName);
                accountList.add(schoolInstitution);
                nameToAccountMap.put(schoolInstitutionName, schoolInstitution);
            }
            
            if (String.isNotBlank(nonSchoolInstitutionName) && nameToAccountMap.containsKey(nonSchoolInstitutionName) != true) {
                Account nonSchoolInstitution = new Account(Name=nonSchoolInstitutionName);
                accountList.add(nonSchoolInstitution);
                nameToAccountMap.put(nonSchoolInstitutionName, nonSchoolInstitution);
            }

            if (String.isNotBlank(employerName) && nameToAccountMap.containsKey(employerName) != true) {
                Account employerOrg = new Account(Name=employerName);
                accountList.add(employerOrg);
                nameToAccountMap.put(employerName, employerOrg);
            }

            // Academic organizations
            String schoolAcademicOrgName = eachContactMap.get(SCHOOL_ACADEMIC_ORG);
            String nonSchoolAcademicOrgName = eachContactMap.get(NON_SCHOOL_ACADEMIC_ORG);

            if (String.isNotBlank(schoolAcademicOrgName) && nameToAccountMap.containsKey(schoolAcademicOrgName) != true) {
                ucinn_ascendv2__Academic_Organization__c academicOrg = new ucinn_ascendv2__Academic_Organization__c(
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Type__c='Academic Org',
                    Name=schoolAcademicOrgName
                );
                academicOrgList.add(academicOrg);
                nameToAcademicOrgMap.put(schoolAcademicOrgName, academicOrg);   
            }

            if (String.isNotBlank(nonSchoolAcademicOrgName) && nameToAccountMap.containsKey(nonSchoolAcademicOrgName) != true) {
                ucinn_ascendv2__Academic_Organization__c academicOrg = new ucinn_ascendv2__Academic_Organization__c(
                    ucinn_portal_Is_Display_On_Portal__c = true, 
                    ucinn_ascendv2__Type__c='Academic Org',
                    Name=nonSchoolAcademicOrgName
                );

                academicOrgList.add(academicOrg);
                nameToAcademicOrgMap.put(nonSchoolAcademicOrgName, academicOrg);
            }
            
            // Social media
            socialMediaList.add(new ucinn_ascendv2__Social_Media__c(
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Platform__c=eachContactMap.get(SOCIAL_MEDIA_PLATFORM),
                ucinn_portal_Status__c='Active',
                ucinn_ascendv2__URL__c=eachContactMap.get(SOCIAL_MEDIA_URL),
                ucinn_portal_Is_Display_On_Portal__c=true,
                ucinn_portal_Is_Show_On_Directory__c=true)
            );
        }

        insert contactNameList;
        insert addressList;
        insert accountList;
        insert academicOrgList;
        insert socialMediaList;

        // Second iteration 
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            // Address Relation
            addressRelationList.add(new ucinn_ascendv2__Address_Relation__c(
                ucinn_ascendv2__Address__c=contactIdToAddressMap.get(eachContactMap.get(CONTACT_ID)).Id,
                ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                ucinn_ascendv2__Status__c='Current',
                ucinn_ascendv2__Type__c='Home',
                ucinn_portal_Is_Show_Address_Lines__c = true,
                ucinn_portal_Is_Display_On_Portal__c=true,
                ucinn_portal_Is_Show_On_Directory__c=true,
                ucinn_portal_Is_Show_City__c=true,
                ucinn_portal_Is_Show_Country__c=true,
                ucinn_portal_Is_Show_State__c=true,
                ucinn_portal_Is_Show_Postal_Code__c=true,
                ucinn_ascendv2__Is_Preferred__c = true)
            );

            // Post Code
            String schoolMajorName = eachContactMap.get(SCHOOL_MAJOR_SPECIALTY);
            String schoolAcademicOrg = nameToAcademicOrgMap.get(eachContactMap.get(SCHOOL_ACADEMIC_ORG))?.Id;

            if (String.isNotBlank(schoolMajorName) && String.isNotBlank(schoolAcademicOrg) && nameAndOrgIdToPostCodeMap.containsKey(schoolMajorName + schoolAcademicOrg) != true) {
                ucinn_ascendv2__Post_Code__c postCode = new ucinn_ascendv2__Post_Code__c(
                    ucinn_ascendv2__Major_Specialty__c=schoolMajorName,
                    ucinn_ascendv2__Major_Specialty_Description__c=schoolMajorName,
                    ucinn_ascendv2__Degree__c=eachContactMap.get(SCHOOL_DEGREE),
                    ucinn_ascendv2__Is_Active__c=true,
                    ucinn_ascendv2__School_1__c=schoolAcademicOrg
                );

                postCodeList.add(postCode);
                nameAndOrgIdToPostCodeMap.put(schoolMajorName + schoolAcademicOrg, postCode);
            }

            String nonSchoolMajorName = eachContactMap.get(NON_SCHOOL_MAJOR_SPECIALTY);
            String nonSchoolAcademicOrg = nameToAcademicOrgMap.get(eachContactMap.get(NON_SCHOOL_ACADEMIC_ORG))?.Id;

            if (String.isNotBlank(nonSchoolMajorName) && String.isNotBlank(nonSchoolAcademicOrg) && nameAndOrgIdToPostCodeMap.containsKey(nonSchoolMajorName + nonSchoolAcademicOrg) != true) {
                ucinn_ascendv2__Post_Code__c postCode = new ucinn_ascendv2__Post_Code__c(
                    ucinn_ascendv2__Major_Specialty__c=nonSchoolMajorName,
                    ucinn_ascendv2__Major_Specialty_Description__c=nonSchoolMajorName,
                    ucinn_ascendv2__Degree__c=eachContactMap.get(NON_SCHOOL_DEGREE),
                    ucinn_ascendv2__Is_Active__c=true,
                    ucinn_ascendv2__School_1__c=nonSchoolAcademicOrg
                );

                postCodeList.add(postCode);
                nameAndOrgIdToPostCodeMap.put(nonSchoolMajorName + nonSchoolAcademicOrg, postCode);
            }

            // Minor
            String schoolMinorName = eachContactMap.get(SCHOOL_MINOR);
            if (String.isNotBlank(schoolMinorName) && String.isNotBlank(schoolAcademicOrg) && nameAndOrgIdToMinorCodeMap.containsKey(schoolMinorName + schoolAcademicOrg) != true) {
                ucinn_ascendv2__Minor_Code__c minorCode = new ucinn_ascendv2__Minor_Code__c(
                    ucinn_ascendv2__Academic_Organization__c=schoolAcademicOrg,
                    ucinn_ascendv2__Description__c=schoolMinorName
                );

                minorCodeList.add(minorCode);
                nameAndOrgIdToMinorCodeMap.put(schoolMinorName + schoolAcademicOrg, minorCode);
            }

            // Affiliation
            if (String.isNotBlank(eachContactMap.get(EMPLOYER_CONST)) && String.isNotBlank(eachContactMap.get(JOB_TITLE))) {
                affiliationList.add(new ucinn_ascendv2__Affiliation__c(
                    ucinn_ascendv2__Account__c=nameToAccountMap.get(eachContactMap.get(EMPLOYER_CONST)).Id,
                    ucinn_ascendv2__Contact__c=eachContactMap.get(CONTACT_ID),
                    ucinn_ascendv2__Status__c='Current',
                    ucinn_portal_Employer_Text__c=eachContactMap.get(EMPLOYER_CONST),
                    ucinn_portal_Is_Display_On_Portal__c =true,
                    ucinn_portal_Is_Deleted_By_User__c =false,
                    ucinn_portal_Is_Show_Job_Title__c=true,
                    ucinn_portal_Is_Show_Employer__c=true,
                    ucinn_ascendv2__Start_Date__c= Date.today().addDays(-10),
                    ucinn_ascendv2__End_Date__c= Date.today().addDays(15),
                    ucinn_ascendv2__Job_Title__c=eachContactMap.get(JOB_TITLE),
                    ucinn_ascendv2__Constituent_Role__c='Employee',
                    ucinn_ascendv2__Organization_Role__c='Employer')
                );
            }
        }
        
        insert addressRelationList;
        insert postCodeList;
        insert minorCodeList;
        insert affiliationList;

        // third iteration
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            String schoolInstitutionId = nameToAccountMap.get(eachContactMap.get(SCHOOL_INSTITUTION))?.Id;
            String schoolAcademicOrgId = nameToAcademicOrgMap.get(eachContactMap.get(SCHOOL_ACADEMIC_ORG))?.Id;
            String schoolPostCodeId = nameAndOrgIdToPostCodeMap.get(eachContactMap.get(SCHOOL_MAJOR_SPECIALTY) + schoolAcademicOrgId)?.Id;
            String minorCodeId = nameAndOrgIdToMinorCodeMap.get(eachContactMap.get(SCHOOL_MINOR) + schoolAcademicOrgId)?.Id;

            if (String.isNotBlank(schoolInstitutionId) && String.isNotBlank(schoolPostCodeId)) {
                degreeList.add(new ucinn_ascendv2__Degree_Information__c(
                    ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID),
                    recordTypeId = schoolDegreeInformation,
                    ucinn_ascendv2__Degree_Institution__c = schoolInstitutionId,
                    ucinn_ascendv2__Post_Code__c = schoolPostCodeId,
                    ucinn_ascendv2__Minor_Code__c = minorCodeId,
                    ucinn_ascendv2__Degree__c = eachContactMap.get(SCHOOL_DEGREE),
                    ucinn_ascendv2__Conferred_Degree_Year__c = eachContactMap.get(SCHOOL_DEGREE_YEAR),
                    ucinn_portal_Status__c='Active',
                    ucinn_portal_Is_Display_On_Portal__c=true,
                    ucinn_portal_Is_Show_On_Directory__c=true,
                    ucinn_portal_Is_Show_Degree__c=true,
                    ucinn_portal_Is_Show_Degree_Year__c=true,
                    ucinn_portal_Is_Show_Institution__c=true,
                    ucinn_portal_Is_Show_Major__c=true)
            );
            }

            String nonSchoolInstitutionId = nameToAccountMap.get(eachContactMap.get(NON_SCHOOL_INSTITUTION))?.Id;
            if (String.isNotBlank(nonSchoolInstitutionId)) {
                degreeList.add(new ucinn_ascendv2__Degree_Information__c(
                    ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID),
                    recordTypeId = nonSchoolDegreeInformation,
                    ucinn_ascendv2__Degree_Institution__c = nonSchoolInstitutionId,
                    ucinn_ascendv2__Non_School_Major__c = eachContactMap.get(NON_SCHOOL_MAJOR),
                    ucinn_ascendv2__Degree__c = eachContactMap.get(NON_SCHOOL_DEGREE),
                    ucinn_ascendv2__Conferred_Degree_Year__c = eachContactMap.get(NON_SCHOOL_DEGREE_YEAR),
                    ucinn_portal_Degree_Institution_Text__c=eachContactMap.get(SCHOOL_INSTITUTION),
                    ucinn_portal_Status__c='Active',
                    ucinn_portal_Is_Display_On_Portal__c=true,
                    ucinn_portal_Is_Show_On_Directory__c=true,
                    ucinn_portal_Is_Show_Degree__c=true,
                    ucinn_portal_Is_Show_Degree_Year__c=true,
                    ucinn_portal_Is_Show_Institution__c=true,
                    ucinn_portal_Is_Show_Major__c=true)
                );
            }
        }

        insert degreeList;
    }

    /**
     * Function that creates Static Content Management data, which includes content pages & modules
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createStaticContentManagementData() {
        List<sObject> pagesToInsert = new List<sObject>();
        String pathPrefix = getCommunityPathPrefix();

        if (String.isNotBlank(pathPrefix)) {
            pathPrefix = '/' + pathPrefix;
        }

        ucinn_portal_Content_Page__c alumniPage = new ucinn_portal_Content_Page__c();
        alumniPage.Name = 'Alumni Directory';
        alumniPage.Page_URL__c = pathPrefix + '/s/alumni-directory';
        pagesToInsert.add(alumniPage);

        ucinn_portal_Content_Page__c createNewUserPage = new ucinn_portal_Content_Page__c();
        createNewUserPage.Name = 'Create New User';
        createNewUserPage.Page_URL__c = pathPrefix + '/s/create-new-user';
        pagesToInsert.add(createNewUserPage);

        ucinn_portal_Content_Page__c hiringManagerApplicationPage = new ucinn_portal_Content_Page__c();
        hiringManagerApplicationPage.Name = 'Hiring Manager Application';
        hiringManagerApplicationPage.Page_URL__c = pathPrefix + '/s/hiring-manager-application';
        pagesToInsert.add(hiringManagerApplicationPage);

        ucinn_portal_Content_Page__c eventsPage = new ucinn_portal_Content_Page__c();
        eventsPage.Name = 'Events';
        eventsPage.Page_URL__c = pathPrefix + '/s/events';
        pagesToInsert.add(eventsPage);


        ucinn_portal_Content_Page__c giftPage = new ucinn_portal_Content_Page__c();
        giftPage.Name = 'Gift Receipt Page';
        pagesToInsert.add(giftPage);


        ucinn_portal_Content_Page__c honorPage = new ucinn_portal_Content_Page__c();
        honorPage.Name = 'Giving Honor Rolls';
        honorPage.Page_URL__c = pathPrefix + '/s/giving-honor-rolls';
        pagesToInsert.add(honorPage);


        ucinn_portal_Content_Page__c givingPage = new ucinn_portal_Content_Page__c();
        givingPage.Name = 'Giving Page';
        givingPage.Page_URL__c = pathPrefix + '/s/give';
        pagesToInsert.add(givingPage);


        ucinn_portal_Content_Page__c homePage = new ucinn_portal_Content_Page__c();
        homePage.Name = 'Home Page';
        pagesToInsert.add(homePage);


        ucinn_portal_Content_Page__c loginPage = new ucinn_portal_Content_Page__c();
        loginPage.Name = 'Login';
        pagesToInsert.add(loginPage);


        ucinn_portal_Content_Page__c membershipPurchasePage = new ucinn_portal_Content_Page__c();
        membershipPurchasePage.Name = 'Membership Purchase';
        membershipPurchasePage.Page_URL__c = pathPrefix + '/s/membership-purchase';
        pagesToInsert.add(membershipPurchasePage);


        ucinn_portal_Content_Page__c myInfoPage = new ucinn_portal_Content_Page__c();
        myInfoPage.Name = 'My Information';
        myInfoPage.Page_URL__c = pathPrefix + '/s/my-information';
        pagesToInsert.add(myInfoPage);


        ucinn_portal_Content_Page__c societyPage = new ucinn_portal_Content_Page__c();
        societyPage.Name = 'Society Memberships';
        societyPage.Page_URL__c = pathPrefix + '/s/society-memberships';
        pagesToInsert.add(societyPage);


        ucinn_portal_Content_Page__c yearEndPage = new ucinn_portal_Content_Page__c();
        yearEndPage.Name = 'Year End Receipt Page';
        pagesToInsert.add(yearEndPage);

        ucinn_portal_Content_Page__c membershipPage = new ucinn_portal_Content_Page__c();
        membershipPage.Name = 'Membership';
        membershipPage.Page_URL__c = pathPrefix + '/s/memberships';
        pagesToInsert.add(membershipPage);

        ucinn_portal_Content_Page__c editMembershipsPage = new ucinn_portal_Content_Page__c();
        editMembershipsPage.Name = 'Edit Memberships';
        editMembershipsPage.Page_URL__c = pathPrefix + '/s/edit-memberships';
        pagesToInsert.add(editMembershipsPage);

        ucinn_portal_Content_Page__c registrationConfirmationPage = new ucinn_portal_Content_Page__c();
        registrationConfirmationPage.Name = 'Registration Confirmation';
        registrationConfirmationPage.Page_URL__c = pathPrefix + '/s/registration-confirmation';
        pagesToInsert.add(registrationConfirmationPage);

        ucinn_portal_Content_Page__c zoneSearchPage = new ucinn_portal_Content_Page__c();
        zoneSearchPage.Name = 'Club and Groups';
        zoneSearchPage.Page_URL__c = pathPrefix + '/s/zone-search';
        pagesToInsert.add(zoneSearchPage);

        ucinn_portal_Content_Page__c zoneSearchClubPage = new ucinn_portal_Content_Page__c();
        zoneSearchClubPage.Name = 'Club';
        zoneSearchClubPage.Page_URL__c = pathPrefix + '/s/zone-search-club';
        pagesToInsert.add(zoneSearchClubPage);

        ucinn_portal_Content_Page__c zoneSearchGroupsPage = new ucinn_portal_Content_Page__c();
        zoneSearchGroupsPage.Name = 'Groups';
        zoneSearchGroupsPage.Page_URL__c = pathPrefix + '/s/zone-search-group';
        pagesToInsert.add(zoneSearchGroupsPage);

        ucinn_portal_Content_Page__c zoneHomePage = new ucinn_portal_Content_Page__c();
        zoneHomePage.Name = 'Zone Homepage';
        zoneHomePage.Page_URL__c = pathPrefix + '/s/zone-home-page';
        pagesToInsert.add(zoneHomePage);

        ucinn_portal_Content_Page__c zoneLeadership = new ucinn_portal_Content_Page__c();
        zoneLeadership.Name = 'Zone Leadership';
        zoneLeadership.Page_URL__c = pathPrefix + '/s/zone-leadership';
        pagesToInsert.add(zoneLeadership);


        ucinn_portal_Content_Page__c zoneBioDetailPage = new ucinn_portal_Content_Page__c();
        zoneBioDetailPage.Name = 'Zone Bio Detail';
        zoneBioDetailPage.Page_URL__c = pathPrefix + '/s/zone-bio-detail';
        pagesToInsert.add(zoneBioDetailPage);

        ucinn_portal_Content_Page__c zoneAnnouncementsPage = new ucinn_portal_Content_Page__c();
        zoneAnnouncementsPage.Name = 'Zone Announcements';
        zoneAnnouncementsPage.Page_URL__c = pathPrefix + '/s/zone-announcements';
        pagesToInsert.add(zoneAnnouncementsPage);


        ucinn_portal_Content_Page__c zoneEventsPage = new ucinn_portal_Content_Page__c();
        zoneEventsPage.Name = 'Zone Events';
        zoneEventsPage.Page_URL__c = pathPrefix + '/s/zone-events';
        pagesToInsert.add(zoneEventsPage);


        ucinn_portal_Content_Page__c jobBoardPage = new ucinn_portal_Content_Page__c();
        jobBoardPage.Name = 'Job Board';
        jobBoardPage.Page_URL__c = pathPrefix + '/s/job-board';
        pagesToInsert.add(jobBoardPage);


        ucinn_portal_Content_Page__c jobApplicantsPage = new ucinn_portal_Content_Page__c();
        jobApplicantsPage.Name = 'Job Applicants';
        jobApplicantsPage.Page_URL__c = pathPrefix + '/s/job-applicants';
        pagesToInsert.add(jobApplicantsPage);


        ucinn_portal_Content_Page__c zoneMembershipsPage = new ucinn_portal_Content_Page__c();
        zoneMembershipsPage.Name = 'Zone Memberships';
        zoneMembershipsPage.Page_URL__c = pathPrefix + '/s/zone-memberships';
        pagesToInsert.add(zoneMembershipsPage);


        ucinn_portal_Content_Page__c editZoneMembershipsPage = new ucinn_portal_Content_Page__c();
        editZoneMembershipsPage.Name = 'Edit Zone Memberships';
        editZoneMembershipsPage.Page_URL__c = pathPrefix + '/s/edit-zone-memberships';
        pagesToInsert.add(editZoneMembershipsPage);


        ucinn_portal_Content_Page__c givingHistoryPage = new ucinn_portal_Content_Page__c();
        givingHistoryPage.Name = 'Giving History';
        givingHistoryPage.Page_URL__c = pathPrefix + '/s/giving-history';
        pagesToInsert.add(givingHistoryPage);


        ucinn_portal_Content_Page__c myNewsletterPage = new ucinn_portal_Content_Page__c();
        myNewsletterPage.Name = 'My Newsletters';
        myNewsletterPage.Page_URL__c = pathPrefix + '/s/my-newsletters';
        pagesToInsert.add(myNewsletterPage);


        ucinn_portal_Content_Page__c eventManagementPage = new ucinn_portal_Content_Page__c();
        eventManagementPage.Name = 'Event Management';
        eventManagementPage.Page_URL__c = pathPrefix + '/s/event-management';
        pagesToInsert.add(eventManagementPage);


        ucinn_portal_Content_Page__c eventSubmissionPage = new ucinn_portal_Content_Page__c();
        eventSubmissionPage.Name = 'Event Submission';
        eventSubmissionPage.Page_URL__c = pathPrefix + '/s/event-submission';
        pagesToInsert.add(eventSubmissionPage);

        ucinn_portal_Content_Page__c classNoteSubmissionPage = new ucinn_portal_Content_Page__c();
        classNoteSubmissionPage.Name = 'Class Note Submission';
        classNoteSubmissionPage.Page_URL__c = pathPrefix + '/s/class-note-submission';
        pagesToInsert.add(classNoteSubmissionPage);

        ucinn_portal_Content_Page__c submittedContentPage = new ucinn_portal_Content_Page__c();
        submittedContentPage.Name = 'Submitted Content';
        submittedContentPage.Page_URL__c = pathPrefix + '/s/submitted-content';
        pagesToInsert.add(submittedContentPage);

        ucinn_portal_Content_Page__c newsletterSubmissionPage = new ucinn_portal_Content_Page__c();
        newsletterSubmissionPage.Name = 'Newsletter Submission';
        newsletterSubmissionPage.Page_URL__c = pathPrefix + '/s/newsletter-submission';
        pagesToInsert.add(newsletterSubmissionPage);

        ucinn_portal_Content_Page__c volunteersPage = new ucinn_portal_Content_Page__c();
        volunteersPage.Name = 'Volunteer';
        volunteersPage.Page_URL__c = pathPrefix + '/s/volunteers';
        pagesToInsert.add(volunteersPage);

        ucinn_portal_Content_Page__c volunteerInformationPage = new ucinn_portal_Content_Page__c();
        volunteerInformationPage.Name = 'Volunteer Information';
        volunteerInformationPage.Page_URL__c = pathPrefix + '/s/volunteer-information';
        pagesToInsert.add(volunteerInformationPage);

        ucinn_portal_Content_Page__c newsAndLearningPage = new ucinn_portal_Content_Page__c();
        newsAndLearningPage.Name = 'News and Learning';
        newsAndLearningPage.Page_URL__c = pathPrefix + '/s/news-and-learning';
        pagesToInsert.add(newsAndLearningPage);

        ucinn_portal_Content_Page__c accountManagementPage = new ucinn_portal_Content_Page__c();
        accountManagementPage.Name = 'Account Management';
        accountManagementPage.Page_URL__c = pathPrefix + '/s/account-management';
        pagesToInsert.add(accountManagementPage);

        ucinn_portal_Content_Page__c eventCheckInPage = new ucinn_portal_Content_Page__c();
        eventCheckInPage.Name = 'Event Check-In';
        eventCheckInPage.Page_URL__c = pathPrefix + '/s/event-check-in';
        pagesToInsert.add(eventCheckInPage);

        try {
            insert pagesToInsert;
        }
        catch (DmlException e) {
            throw e;
        }

        List<sObject> modulesToInsert = new List<sObject>();

        ucinn_portal_Content_Module__c module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = alumniPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <!--<img src=\\"../../assets/img/AdobeStock_364843654.jpg\\">-->\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Alumni Directory</h1>\\n <!-- <p style=\\"margin-bottom: 1.5em !important\\">Search and share career opportunities through the network. </p>\\n <a href=\\"../demo/login.html\\" class=\\"tertiary light button\\">Sign in to view, post, or apply</a> -->\\n </div>\\n </div>\\n </div>\\n</div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = eventsPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_EventHeader\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Events</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = eventCheckInPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_EventHeader\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Event Check-In</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Receipt Info';
        module.content_page__c = giftPage.Id;
        module.content_module_metadata__c = '{"imageAltText":"Sample alt text", "titleHTML":"<h1 style=\\"text-align: center\\">Gift Receipt</h1>","banerImageName":"Year_end_receipt_top_logo","banerImageAltText":"Sample alt text","footerText":"University of ascend","postBannerHTML":"<br/><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Magna fringilla urna porttitor rhoncus dolor purus. Pretium lectus quam id leo in vitae. Auctor urna nunc id cursus metus aliquam eleifend mi. Morbi tristique senectus et netus et malesuada. Lectus urna duis convallis convallis. Leo in vitae turpis massa sed elementum tempus egestas sed. Diam donec adipiscing tristique risus. Vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam. Lacus sed viverra tellus in hac. Convallis posuere morbi leo urna molestie at elementum. Enim diam vulputate ut pharetra sit amet aliquam. Nunc congue nisi vitae suscipit tellus mauris a. Tellus molestie nunc non blandit massa enim nec dui nunc. Ultrices eros in cursus turpis massa tincidunt dui ut ornare. Gravida in fermentum et sollicitudin ac orci.</p>","securitiesTopHTML":"<p>Laoreet id donec ultrices tincidunt arcu non. In hac habitasse platea dictumst quisque sagittis. Dictum at tempor commodo ullamcorper a lacus vestibulum. Turpis massa tincidunt dui ut. Tortor at risus viverra adipiscing at. Vestibulum lorem sed risus ultricies tristique nulla aliquet. Laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt eget. Imperdiet dui accumsan sit amet nulla facilisi. Volutpat odio facilisis mauris sit. Diam vulputate ut pharetra sit amet aliquam id diam. In metus vulputate eu scelerisque felis. Eu turpis egestas pretium aenean pharetra magna. Aenean vel elit scelerisque mauris pellentesque pulvinar pellentesque habitant morbi. Et pharetra pharetra massa massa ultricies mi. Diam vel quam elementum pulvinar etiam non quam lacus. Leo integer malesuada nunc vel risus. Pulvinar elementum integer enim neque volutpat ac tincidunt vitae semper. Ipsum faucibus vitae aliquet nec ullamcorper sit amet risus. Augue ut lectus arcu bibendum at.</p>"}';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = honorPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Thank you for investing in students, faculty, patients, and communities.</h1>\\n <p style=\\"margin-bottom: 0 !important\\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. Quisque vel interdum odio, in interdum magna.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = createNewUserPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">New User Registration</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/PORTAL_NewUserBanner\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = hiringManagerApplicationPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">Hiring Manager Registration</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/PORTAL_NewUserBanner\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = givingPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\" style=\\"margin-bottom: 0.75rem\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">Give</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/Give_Banner\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Header CTA Block';
        module.content_page__c = homePage.Id;
        module.content_module_metadata__c = '{"heading":"Welcome, University of ascend!","image":{"imageUrl":"../resource/UCInnovationHeader"},"button1":{"label":"View the Directory","link":"/s/alumni-directory"},"eyebrow":"Join Us!","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."}';
        module.related_lwc__c = 'portal_HeaderCTABlock';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Accordion';
        module.content_page__c = homePage.Id;
        module.content_module_metadata__c = '{"heading":"Some of our modules!","items":[{"text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","isOpen":"false","topicName":"My Information"},{"topicName":"Online Giving","text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","isOpen":"false"},{"topicName":"Giving History","text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","isOpen":"false"}]}';
        module.related_lwc__c = 'portal_Accordion';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Large CTA Blocks';
        module.content_page__c = homePage.Id;
        module.content_module_metadata__c = '{"ctaBlocks":[{"heading":"View our Events page!","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","image":{"imageUrl":"../resource/EventImageTA"},"button":{"label":"View the Events Page","link":"events"},"eyebrow":"Join Us!","imagePosition":"right"},{"button":{"label":"View the Honor Rolls","link":"giving-honor-rolls"},"eyebrow":"Part of a Giving Society?","heading":"Look for yourself on the Honor Rolls!","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\\n","image":{"imageUrl":"../resource/HonorRollTA"},"imagePosition":"left"}]}';
        module.related_lwc__c = 'portal_LargeCTABlocks';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Quotation';
        module.content_page__c = homePage.Id;
        module.content_module_metadata__c = '{"quote":"The greatest glory in living lies not in never falling, but in rising every time we fall","citation":"Nelson Mandela","image":{"imageUrl":"../resource/NeslonMandelaTA"}}';
        module.related_lwc__c = 'portal_Quotation';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Helper Text';
        module.content_page__c = loginPage.Id;
        module.content_module_metadata__c = '{"htmlText":" <div class=\\"section-wrapper footer-text\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_8-of-12 slds-large-size_8-of-12 slds-var-p-horizontal_medium\\" style=\\"margin: 0 auto; text-align: left\\">\\n<p>Interested in being a hiring manager? <a href=\\"../hiring-manager-application\\">Sign up here!</a></p>\\n <p>Additional information here <a href=\\"javascript:void(0)\\">lorem ipsum dolor</a> sit amet, consectetur adipiscing elit. Sed pulvinar dapibus aliquet. In hac habitasse platea dictumst. Ut quam odio, volutpat vitae urna sed, posuere dictum justo. </p>\\n <p>Sed mattis libero vel libero feugiat, congue suscipit risus facilisis. Mauris egestas leo sit amet laoreet vehicula. Etiam eleifend porttitor augue non pharetra. Duis eleifend enim sit amet leo dignissim fermentum. In ultricies purus ac leo blandit aliquam sed sit amet metus. Etiam vitae purus sed tortor aliquet molestie.</p>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = loginPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"section-body-content center-content\\">\\n <div class=\\"content-header-bar\\">\\n <h1 class=\\"contentTitle\\">Log In</h1>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = membershipPurchasePage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Purchase Memberships</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = membershipPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Memberships</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Cancel Membership';
        module.content_page__c = editMembershipsPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"container\\" style=\\"display: flex; justify-content: flex-start;\\"><p style=\\"font-family: \'Noah-Regular\'\\"><b>To cancel your membership, please contact an administrator.</b></p></div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = editMembershipsPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Edit Memberships</h1>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);
        

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = myInfoPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">My Information</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/PORTAL_MyInformationHeader\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = societyPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Society Memberships</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Receipt Info';
        module.content_page__c = yearEndPage.Id;
        module.content_module_metadata__c = '{"imageName":"Year_end_receipt_top_logo","imageAltText":"Sample alt text","addressInfo":"<div>Danny\'s House</div><div>2855 Michelle Dr Suite 190</div><div>Irvine, CA 92606</div>","preTableText":"<p>Dear -!firstName- -!lastName-</p><p>Thank you for your support of the UC Innovation\'s Portal Team. </p></br><p>Our records indicate that the following cash gifts were received during the calendar year -!year-.</p>","postTableText":"<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum..</p>"}';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Thank You Text';
        module.content_page__c = registrationConfirmationPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div>\\n<h1 style=\\"color: black !important; font-size: 4.5em !important; text-align: center; margin-top: 80px; margin-bottom: 30px;\\" class=\\"contentTitle\\"><img src=\\"../resource/Green_Check_Mark_Solid\\" width=\\"70\\" height=\\"70\\" style=\\"padding: 10px\\"></img>Thank you for registering.</h1>\\n<p style=\\"color: #000000; text-align: center; text-shadow: 1px 1px 0 rgba(15, 72, 106, 0.7); font-size: 2em;\\"> It may take up to 48 hours to process your request.</p>\\n<div style=\\"text-align: center\\">\\n<a class=\\"button secondary\\" href=\\"login\\" style=\\"margin-bottom: 100px; margin-top: 10px;\\">Back To Login</a>\\n</div>\\n</div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = zoneSearchPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Alumni Club and Groups</h1>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = zoneSearchClubPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Alumni Clubs</h1>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = zoneSearchGroupsPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Alumni Groups</h1>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Zone Banner';
        module.Content_Page__c = zoneHomePage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom:1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">{_zoneName}</span>\\n <h1 class=\\"contentTitle\\">Welcome</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent malesuada lobortis sem, nec aliquam lacus ultrices vitae. In a turpis id dui dignissim lacinia. Fusce sed commodo nisl. Pellentesque laoreet at nibh nec consectetur.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Zone Banner';
        module.Content_Page__c = zoneLeadership.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom:1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">{_zoneName}</span>\\n <h1 class=\\"contentTitle\\">Featured Members</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent malesuada lobortis sem, nec aliquam lacus ultrices vitae. In a turpis id dui dignissim lacinia. Fusce sed commodo nisl. Pellentesque laoreet at nibh nec consectetur.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Zone Banner';
        module.Content_Page__c = zoneBioDetailPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom:1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">{_zoneName}</span>\\n <h1 class=\\"contentTitle\\">Featured Profile</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent malesuada lobortis sem, nec aliquam lacus ultrices vitae. In a turpis id dui dignissim lacinia. Fusce sed commodo nisl. Pellentesque laoreet at nibh nec consectetur.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Zone Banner';
        module.Content_Page__c = zoneAnnouncementsPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom: 1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">{_zoneName}</span>\\n <h1 class=\\"contentTitle\\">Announcements</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent malesuada lobortis sem, nec aliquam lacus ultrices vitae. In a turpis id dui dignissim lacinia. Fusce sed commodo nisl. Pellentesque laoreet at nibh nec consectetur.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>\\n"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);
        

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Zone Banner';
        module.Content_Page__c = zoneEventsPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom: 1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">{_zoneName}</span>\\n <h1 class=\\"contentTitle\\">Zone Events</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent malesuada lobortis sem, nec aliquam lacus ultrices vitae. In a turpis id dui dignissim lacinia. Fusce sed commodo nisl. Pellentesque laoreet at nibh nec consectetur.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>\\n"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);
        

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = jobBoardPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_JobBoardBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Job Board</h1>\\n <p style=\\"margin-bottom: 1.5em !important\\">Search and share career opportunities through the network. </p>\\n </div>\\n </div>\\n </div>\\n </div>\\n"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = jobApplicantsPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_JobBoardBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Job Applicants</h1>\\n <p style=\\"margin-bottom: 1.5em !important\\">View applicants that have applied for a job.</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = zoneMembershipsPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Alumni Clubs and Groups Memberships</h1>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = editZoneMembershipsPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <div class=\\"slds-size_12-of-12\\">\\n <h1 class=\\"contentTitle\\">Edit Clubs and Groups Memberships</h1>\\n </div>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = givingHistoryPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">Giving History</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/Portal_GivingHistoryBanner\\">\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = myNewsletterPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">My Newsletters</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = eventManagementPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_EventHeader\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Event Management</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);


        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = eventSubmissionPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_EventHeader\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Event Submission</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.Content_Page__c = classNoteSubmissionPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_EventHeader\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Class Note Submission</h1>\\n </div>\\n </div>\\n </div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Description';
        module.Content_Page__c = classNoteSubmissionPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div style=\\"background:#cccccc\\">\\n<div class=\\"container small\\" style=\\"padding:1rem;margin:0 auto;max-width:700px;font-weight:800\\">\\n<p>Did you recently get a new job, reunite virtually with University friends, graduate with an advanced degree, receive an award or expand your family? Your University classmates want to know!</p>\\n<p>Share what’s going on in your life with the University community by submitting a class note and photo below. Your submission will appear in edited form in the print and online versions of University Magazine.</p>\\n<p>For more information, email classnotes@university.edu.</p>\\n</div>\\n</div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Confirmation';
        module.Content_Page__c = classNoteSubmissionPage.Id;
        module.Content_Module_Metadata__c = '{"htmlText":"<div>\\n<h3 style=\\"text-align:center\\">Thank you!</h3>\\n<div>\\n<div style=\\"text-align:center\\">\\n<img src=\\"../resource/Portal_DataCreationPictures/giving.png\\">\\n</div>\\n<div>\\n<div>\\n<p>Thank you for submitting a class note. Once approved, your class note will be published in the following edition of University Magazine.</p>\\n<p>To contact us, please email <a href=\\"mailto:classnotes@university.edu\\">classnotes@university.edu</a>.</p>\\n<p>If you would like to submit another class note, please click the button below.</p>\\n</div>\\n</div>\\n</div>\\n</div>"}';
        module.Related_LWC__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = submittedContentPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <img src=\\"../resource/Portal_EventHeader\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Submitted Content</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = newsletterSubmissionPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"slds-grid align-center\\">\\n <h1 class=\\"contentTitle\\">Newsletter Submission</h1>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = volunteersPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">Volunteer</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/PORTAL_VolunteerBanner\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = volunteerInformationPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">Volunteer</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/PORTAL_VolunteerBanner\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'News Footer';
        module.content_page__c = newsAndLearningPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"button-block\\" style=\\"position: relative; bottom: -1em; margin-bottom: 0; padding: 70px 0 !important; background: #005595; margin: 0 auto; text-align: center; box-sizing: border-box; display: block\\">\\n <div class=\\"container\\">\\n <div class=\\"news-footer\\">\\n <h3 style=\\"color: white; margin-bottom: 1em; font-size: 2em !important; \\">\\n ascend Portal Is The Best!\\n </h3>\\n <p style=\\"margin-bottom: 2em !important; color: white; font-size: 1.1rem; line-height: 1.3; \\">\\n Supplemental body text could go here (optional). Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque tristique pulvinar nisi, in dignissim velit. Curabitur in scelerisque ex, non imperdiet dolor. Phasellus auctor purus ac nisi pharetra scelerisque.\\n </p>\\n </div>\\n <div class=\\"list col-3\\">\\n <a href=\\"my-not-interested-news\\" class=\\"list-item button white full-mobile\\">\\n View all news marked as \\"Not Interested\\"\\n </a>\\n <a href=\\"news-show-all\\" class=\\"list-item button white full-mobile\\">\\n View all news\\n </a>\\n </div>\\n </div>\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        module = new ucinn_portal_Content_Module__c();
        module.Name = 'Banner';
        module.content_page__c = accountManagementPage.Id;
        module.content_module_metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"widthContainer slds-grid align-center\\">\\n <div class=\\"content\\">\\n <h1 class=\\"contentTitle\\">Account Management</h1>\\n </div>\\n </div>\\n </div>\\n <img src=\\"../resource/PORTAL_NewUserBanner\\">\\n </div>"}';
        module.related_lwc__c = 'portal_HtmlEditor';
        modulesToInsert.add(module);

        try {
            insert modulesToInsert;
        }
        catch (DmlException e) {
            throw e;
        }
    }

    /**
     * Create events data without any related ascend records 
     * 
     * @author Jacob Huang
     * @since 1.13
     */
    @future
    public static void createPortalOnlyEventsData() {
        createEventsData(true);
    }

    /**
     * Create events data
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    @future
    public static void createEventsData() {
        createEventsData(false);
    }

    /**
     * Function that creates events data which includes listings and ticket types. Option to create only portal data (no base ascend objects) 
     *
     * @author  Phillip Nguyen, Jacob Huang
     * @since   1.13
     */
    private static void createEventsData(Boolean isPortalDataOnly) {
        String baseUrl = getBaseUrl();

        Campaign appeal = null;
        ucinn_ascendv2__Designation__c listingDesignation = null;
        ucinn_ascendv2__Designation__c ticketTypeDesignation = null;
        if (!isPortalDataOnly) {
            appeal = new Campaign(Name = 'General Event Appeal', ucinn_ascendv2__Motivation_Code__c = 'General Event Appeal', IsActive = true);
            insert appeal;

            listingDesignation = new ucinn_ascendv2__Designation__c(
                Name = 'ascend Event Fund',
                ucinn_ascendv2__G_L_Short_Description__c = 'ascend Event Fund',
                ucinn_ascendv2__G_L_Effective_Date__c = Date.newInstance(2020, 10, 01),
                ucinn_ascendv2__Designation_Name__c = 'ascend Event Fund'
            );

            ticketTypeDesignation = new ucinn_ascendv2__Designation__c(
                Name = 'ascend Portal Event Fund',
                ucinn_ascendv2__G_L_Short_Description__c = 'ascend Portal Event Fund',
                ucinn_ascendv2__G_L_Effective_Date__c = Date.newInstance(2020, 10, 01),
                ucinn_ascendv2__Designation_Name__c = 'ascend Portal Event Fund'
            );

            insert new List<ucinn_ascendv2__Designation__c>{listingDesignation, ticketTypeDesignation};
        }

        // registration template, registration page, and custom form fields for The Clash Between event
        ucinn_portal_Registration_Template__c gameEventRegistrationTemplate = new ucinn_portal_Registration_Template__c(
            Name = 'Clash Between Template',
            Is_Display_Address_Fields__c = true,
            Is_Display_Degree_and_Year_Field__c = false,
            Is_Display_Employer_Field__c = false,
            Is_Display_Phone_Field__c = true,
            Is_Display_Registration_Helper_Text__c = true,
            Is_Guest_Email_Required__c = true,
            Registration_Helper_Text__c = 'Please complete this form, and fill in all required fields, which are denoted with a red asterisk.',
            Terms_and_Conditions_Text__c = 'By checking this box and submitting this form, you are giving the organizer\'s of this event permission to store the personal information submitted ' + 
                                           'in this form for up to one year. Furthermore, you give permission for any pictures taken of you during this event to be posted on our website ' +
                                           'indefinitely or until you contact us to remove them. Any ticket obtained for this event may be canceled without prior notice.'
        );

        insert gameEventRegistrationTemplate;

        ucinn_portal_Registration_Page__c gameEventRegistrationPage = new ucinn_portal_Registration_Page__c(
            Name = 'Page 1',
            Order_Number__c = 1,
            Registration_Template__c = gameEventRegistrationTemplate.Id
        );

        insert gameEventRegistrationPage;

        insert new List<ucinn_portal_Custom_Form_Field__c>{
            new ucinn_portal_Custom_Form_Field__c(
                Name = 'Interests Multi-Picklist',
                Field_Type__c = 'Multi-Picklist',
                Field_Label__c = 'What Areas of This Event Most Interest You?',
                Available_Values__c = 'Main Stage;Secondary Stage;Blue Theater;Green Area;Garden;Food Court',
                Editable__c = true,
                Is_Display_To_Guests__c = true,
                Field_Order__c = 1,
                Registration_Template__c = gameEventRegistrationTemplate.Id
            ),

            new ucinn_portal_Custom_Form_Field__c(
                Name = 'Previously Attended Checkbox',
                Field_Type__c = 'Checkbox',
                Field_Label__c = 'Have you attended this event in a previous year?',
                Default_Value__c = 'false',
                Editable__c = true,
                Is_Display_To_Guests__c = true,
                Field_Order__c = 1,
                Registration_Template__c = gameEventRegistrationTemplate.Id,
                Registration_Page__c = gameEventRegistrationPage.Id
            ),

            new ucinn_portal_Custom_Form_Field__c(
                Name = 'T-Shirt Size Picklist',
                Field_Type__c = 'Picklist',
                Field_Label__c = 'T-Shirt Size',
                Default_Value__c = 'M',
                Available_Values__c = 'XS;S;M;L;XL',
                Editable__c = true,
                Is_Display_To_Guests__c = true,
                Field_Order__c = 2,
                Registration_Template__c = gameEventRegistrationTemplate.Id,
                Registration_Page__c = gameEventRegistrationPage.Id
            ),

            new ucinn_portal_Custom_Form_Field__c(
                Name = 'Origin Text',
                Field_Type__c = 'Text',
                Field_Label__c = 'How Did You Hear About This Event?',
                Editable__c = true,
                Is_Display_To_Guests__c = false,
                Field_Order__c = 3,
                Registration_Template__c = gameEventRegistrationTemplate.Id,
                Registration_Page__c = gameEventRegistrationPage.Id
            )
        };

        // Events to insert
        List<ucinn_portal_Listing__c> eventsToInsert = new List<ucinn_portal_Listing__c>();

        String eventInformation = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();

        DateTime dateTimeYesterday = DateTime.now().addDays(-1);
        DateTime dateTimeInOneYear = DateTime.now().addYears(1);

        ucinn_portal_Listing__c gameEvent = new ucinn_portal_Listing__c(RecordTypeId = eventInformation,
                                                                        Name = 'The Clash Between US and Asia Comparative Approaches in Video Games',
                                                                        Start_Date_Time__c = dateTimeYesterday,
                                                                        End_Date_Time__c = dateTimeInOneYear,
                                                                        Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(2), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(4), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_158878085_cropped.jpg">',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_308210749_small.jpg">',
                                                                        Header_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Geolocation__latitude__s = 34.0430086, // Staples Center
                                                                        Geolocation__longitude__s = -118.2698896,
                                                                        Registration_Template__c = gameEventRegistrationTemplate.Id);
        eventsToInsert.add(gameEvent);


        ucinn_portal_Listing__c clubEvent = new ucinn_portal_Listing__c(RecordTypeId = eventInformation,
                                                                        Name = 'Alumni Club of Ohio and Chicago Women\'s Alliance (CWA)',
                                                                        Start_Date_Time__c = dateTimeYesterday,
                                                                        End_Date_Time__c =  dateTimeInOneYear,
                                                                        Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(6), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(7), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Header_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_158878085.jpg">',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.', 
                                                                        Geolocation__latitude__s = 41.8337734, // Chicago
                                                                        Geolocation__longitude__s = -88.0616122,
                                                                        Campaign__c = appeal?.Id,
                                                                        Designation__c = listingDesignation?.Id);
        eventsToInsert.add(clubEvent);


        ucinn_portal_Listing__c storyEvent = new ucinn_portal_Listing__c(RecordTypeId = eventInformation,
                                                                        Name = 'A Story about lorem ipsum dolor sit amet',
                                                                        Start_Date_Time__c = dateTimeYesterday,
                                                                        End_Date_Time__c = dateTimeInOneYear,
                                                                        Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(14), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(15), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/news-AdobeStock_464335783.jpg">',
                                                                        Header_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Geolocation__latitude__s = 34.0337408, // Malibu Beach
                                                                        Geolocation__longitude__s = -118.9190151);
        eventsToInsert.add(storyEvent);


        ucinn_portal_Listing__c newsEvent = new ucinn_portal_Listing__c(RecordTypeId = eventInformation,
                                                                        Name = 'CEO Speaks: Benefits of Paying a Competitive Salary',
                                                                        Start_Date_Time__c = dateTimeYesterday,
                                                                        End_Date_Time__c = dateTimeInOneYear,
                                                                        Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(22), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(27), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_211651043.jpg">',
                                                                        Header_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Geolocation__latitude__s = 33.7195803, // 2855 Michelle Dr
                                                                        Geolocation__longitude__s = -117.8029437,
                                                                        Campaign__c = appeal?.Id,
                                                                        Designation__c = listingDesignation?.Id);
        eventsToInsert.add(newsEvent);


        ucinn_portal_Listing__c bookEvent = new ucinn_portal_Listing__c(RecordTypeId = eventInformation,
                                                                        Name = 'Virtual Book Club: Swann\'s Way, by Marcel Proust',
                                                                        Start_Date_Time__c = dateTimeYesterday,
                                                                        End_Date_Time__c = dateTimeInOneYear,
                                                                        Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(26), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(29), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss'),
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/news-AdobeStock_464335783.jpg">',
                                                                        Header_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Is_Non_Ticketed_Event__c = true,
                                                                        Is_Online_Event__c = true);
        eventsToInsert.add(bookEvent);

		for (Integer daysToAdd = 30; daysToAdd < 180; daysToAdd += 30) {
            ucinn_portal_Listing__c futureGameEvent = gameEvent.clone();
            futureGameEvent.Author__c = 'Edward';
            futureGameEvent.Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(2 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            futureGameEvent.Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(3 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
			eventsToInsert.add(futureGameEvent);

			ucinn_portal_Listing__c futureClubEvent = clubEvent.clone();
            futureClubEvent.Author__c = 'Steven';
            futureClubEvent.Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(8 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            futureClubEvent.Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(10 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
			eventsToInsert.add(futureClubEvent);

			ucinn_portal_Listing__c futureStoryEvent = storyEvent.clone();
            futureStoryEvent.Author__c = 'Edward';
            futureStoryEvent.Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(13 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            futureStoryEvent.Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(14 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            eventsToInsert.add(futureStoryEvent);

			ucinn_portal_Listing__c futureNewsEvent = newsEvent.clone();
            futureNewsEvent.Author__c = 'Steven';
            futureNewsEvent.Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(18 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            futureNewsEvent.Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(24 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            eventsToInsert.add(futureNewsEvent);

			ucinn_portal_Listing__c futureBookEvent = bookEvent.clone();
            futureBookEvent.Author__c = 'Edward';
            futureBookEvent.Event_Actual_Start_Date_Time__c = DateTime.newInstance(Date.today().addDays(28 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            futureBookEvent.Event_Actual_End_Date_Time__c = DateTime.newInstance(Date.today().addDays(29 + daysToAdd), Time.newInstance(12, 0, 0, 0)).format('yyyy-MM-dd hh:mm:ss');
            eventsToInsert.add(futureBookEvent);
		}

        insert eventsToInsert;

        // Delete free ticket types created in listing trigger, except for the ticket typed required for the non-ticketed event and the future events (Author__c is populated)
        List<ucinn_portal_Ticket_Type__c> ticketTypesToDelete = [SELECT Id FROM ucinn_portal_Ticket_Type__c WHERE Listing__c IN :eventsToInsert AND Listing__r.Is_Non_Ticketed_Event__c = false AND Listing__r.Author__c = null];

        delete ticketTypesToDelete;

        // Ticket Types to insert
        List<ucinn_portal_Ticket_Type__c> ticketTypesToInsert = new List<ucinn_portal_Ticket_Type__c>();

        ucinn_portal_Ticket_Type__c gameEventMorningAdmission = new ucinn_portal_Ticket_Type__c(Name = 'Morning Admission',
                                                                                                Listing__c = gameEvent.Id,
                                                                                                Price__c = 0,
                                                                                                Description__c = 'Admission to the morning session.');
        
        ucinn_portal_Ticket_Type__c gameEventAfternoonAdmission = new ucinn_portal_Ticket_Type__c(Name = 'Afternoon Admission',
                                                                                                Listing__c = gameEvent.Id,
                                                                                                Price__c = 0,
                                                                                                Description__c = 'Admission to the afternoon session.');

        ticketTypesToInsert.add(gameEventMorningAdmission);
        ticketTypesToInsert.add(gameEventAfternoonAdmission);

        ucinn_portal_Ticket_Type__c clubEventGeneralAdmission = new ucinn_portal_Ticket_Type__c(Name = 'General Admission',
                                                                                                Listing__c = clubEvent.Id,
                                                                                                Price__c = 10,
                                                                                                Gift_Amount__c = 8,
                                                                                                Description__c = 'General admission to the event.',
                                                                                                Order_Number__c = 1);

        ucinn_portal_Ticket_Type__c clubEventVIPAdmission = new ucinn_portal_Ticket_Type__c(Name = 'VIP Admission',
                                                                                                Listing__c = clubEvent.Id,
                                                                                                Price__c = 25,
                                                                                                Gift_Amount__c = 15,
                                                                                                Designation__c = ticketTypeDesignation?.Id,
                                                                                                Description__c = 'General admission to the event plus access to the meet and greet and Q&A after.',
                                                                                                Order_Number__c = 2);

        ticketTypesToInsert.add(clubEventGeneralAdmission);
        ticketTypesToInsert.add(clubEventVIPAdmission);

        ucinn_portal_Ticket_Type__c storyEventGeneralAdmission = new ucinn_portal_Ticket_Type__c(Name = 'General Admission',
                                                                                                Listing__c = storyEvent.Id,
                                                                                                Price__c = 0,
                                                                                                Description__c = 'Tickets for lorem ipsum dolor sit amet.');

        ticketTypesToInsert.add(storyEventGeneralAdmission);


        ucinn_portal_Ticket_Type__c newsEventSilverAdmission = new ucinn_portal_Ticket_Type__c(Name = 'Silver Level Admission',
                                                                                                Listing__c = newsEvent.Id,
                                                                                                Price__c = 50,
                                                                                                Gift_Amount__c = 10.10,
                                                                                                Description__c = 'Premium access to this presentation and all of the industry secrets you never knew you needed!',
                                                                                                Order_Number__c = 1);

        ucinn_portal_Ticket_Type__c newsEventGoldAdmission = new ucinn_portal_Ticket_Type__c(Name = 'Gold Level Admission',
                                                                                                Listing__c = newsEvent.Id,
                                                                                                Price__c = 100,
                                                                                                Gift_Amount__c = 25.25,
                                                                                                Total_Number_Of_Tickets__c = 20,
                                                                                                Max_Tickets_Per_Registrant__c = 1,
                                                                                                Description__c = 'All the perks of Silver Admission plus an exclusive opportunity to purchase a signed copy of the speaker\'s book!',
                                                                                                Order_Number__c = 2);

        ucinn_portal_Ticket_Type__c newsEventPlatinumAdmission = new ucinn_portal_Ticket_Type__c(Name = 'Platinum Level Admission',
                                                                                                Listing__c = newsEvent.Id,
                                                                                                Price__c = 500,
                                                                                                Gift_Amount__c = 50.50,
                                                                                                Total_Number_Of_Tickets__c = 5,
                                                                                                Max_Tickets_Per_Registrant__c = 1,
                                                                                                Description__c = 'Everything in Gold Admission but now in Platinum!',
                                                                                                Order_Number__c = 3);

        ticketTypesToInsert.add(newsEventSilverAdmission);
        ticketTypesToInsert.add(newsEventGoldAdmission);
        ticketTypesToInsert.add(newsEventPlatinumAdmission);

        insert ticketTypesToInsert;

        // recipient logic
        ucinn_portal_Recipient__c generousOrAlumni = new ucinn_portal_Recipient__c(
            Name = 'Generous or Alumni',
            Filter_Logic__c = '1 OR 2'
        );

        ucinn_portal_Recipient__c generousAndAlumniOrStark = new ucinn_portal_Recipient__c(
            Name = 'Generous and either Alumni or Stark',
            Filter_Logic__c = '1 AND (2 OR 3)'
        );

        insert new List<ucinn_portal_Recipient__c>{generousOrAlumni, generousAndAlumniOrStark};

        // Generous or Alumni
        ucinn_portal_Recipient_Filter__c generous1 = new ucinn_portal_Recipient_Filter__c(
            Name = 'Generous',
            Recipient__c = generousOrAlumni.Id,
            Contact_Relationship_Api_Name__c = 'ucinn_ascendv2__Opportunities_Contact__r',
            Contact_Lookup_Field_API_Name__c = 'ucinn_ascendv2__Contact__c',
            Field_API_Name__c = 'Amount',
            Object_API_Name__c = 'Opportunity',
            Order_Number__c = '1',
            Operator__c = '>=',
            Field_Value__c = '200',
            Field_Type__c = 'Number'
        );

        ucinn_portal_Recipient_Filter__c alumni = new ucinn_portal_Recipient_Filter__c(
            Name = 'Alumni',
            Recipient__c = generousOrAlumni.Id,
            Field_API_Name__c = 'ucinn_ascendv2__Contact_Type__c',
            Object_API_Name__c = 'Contact',
            Order_Number__c = '2',
            Operator__c = 'INCLUDES',
            Field_Value__c = 'Alumni;Alumni No Degree'
        );

        // Generous Alumni Named Stark
        ucinn_portal_Recipient_Filter__c generous2 = new ucinn_portal_Recipient_Filter__c(
            Name = 'Generous',
            Recipient__c = generousAndAlumniOrStark.Id,
            Contact_Relationship_Api_Name__c = 'ucinn_ascendv2__Opportunities_Contact__r',
            Contact_Lookup_Field_API_Name__c = 'ucinn_ascendv2__Contact__c',
            Field_API_Name__c = 'Amount',
            Object_API_Name__c = 'Opportunity',
            Order_Number__c = '1',
            Operator__c = '>=',
            Field_Value__c = '200',
            Field_Type__c = 'Number'
        );

        ucinn_portal_Recipient_Filter__c alumniWithFilterFields = new ucinn_portal_Recipient_Filter__c(
            Name = 'Alumni',
            Recipient__c = generousAndAlumniOrStark.Id,
            Object_API_Name__c = 'Contact',
            Order_Number__c = '2',
            Has_Multiple_Fields__c = true,
            Field_Logic__c = '1 OR 2'
        );

        ucinn_portal_Recipient_Filter__c stark = new ucinn_portal_Recipient_Filter__c(
            Name = 'Stark',
            Recipient__c = generousAndAlumniOrStark.Id,
            Field_API_Name__c = 'LastName',
            Object_API_Name__c = 'Contact',
            Order_Number__c = '3',
            Operator__c = '=',
            Field_Value__c = 'Stark'
        );

        insert new List<ucinn_portal_Recipient_Filter__c>{
            generous1,
            alumni,
            generous2,
            alumniWithFilterFields,
            stark
        };

        insert new List<ucinn_portal_Recipient_Filter_Field__c>{
            new ucinn_portal_Recipient_Filter_Field__c(
                Name = 'Alumni',
                Recipient_Filter__c = alumniWithFilterFields.Id,
                Order_Number__c = '1',
                Field_API_Name__c = 'ucinn_ascendv2__Primary_Contact_Type__c',
                Operator__c = '=',
                Field_Value__c = 'Alumni'
            ),

            new ucinn_portal_Recipient_Filter_Field__c(
                Name = 'Alumni No Degree',
                Recipient_Filter__c = alumniWithFilterFields.Id,
                Order_Number__c = '2',
                Field_API_Name__c = 'ucinn_ascendv2__Primary_Contact_Type__c',
                Operator__c = '=',
                Field_Value__c = 'Alumni No Degree'
            )
        };

        // ticket discounts
        List<ucinn_portal_Ticket_Discount__c> ticketDiscounts = new List<ucinn_portal_Ticket_Discount__c>{
            // Alumni Club of Ohio and Chicago Women's Alliance (CWA)
            new ucinn_portal_Ticket_Discount__c(
                Name = '10% Off VIP',
                Discount_Type__c = 'Percentage',
                Discount_Percentage__c = 10,
                Promo_Code__c = 'edward',
                Ticket_Type__c = clubEventVIPAdmission.Id
            ),

            new ucinn_portal_Ticket_Discount__c(
                Name = '$5.01 Off VIP',
                Discount_Type__c = 'Price',
                Adjusted_Price__c = 19.99,
                Promo_Code__c = 'steven',
                Ticket_Type__c = clubEventVIPAdmission.Id
            ),

            new ucinn_portal_Ticket_Discount__c(
                Name = 'Free General Admission',
                Discount_Type__c = 'Free',
                Promo_Code__c = 'Let me in!',
                Ticket_Type__c = clubEventGeneralAdmission.Id
            ),

            // CEO Speaks, with recipient logic
            new ucinn_portal_Ticket_Discount__c(
                Name = 'Free Gold',
                Discount_Type__c = 'Price',
                Adjusted_Price__c = 0,
                Promo_Code__c = 'edward=cool',
                Ticket_Type__c = newsEventGoldAdmission.Id,
                Recipient__c = generousOrAlumni.Id
            ),

            new ucinn_portal_Ticket_Discount__c(
                Name = '99% Off Platinum',
                Discount_Type__c = 'Percentage',
                Discount_Percentage__c = 99,
                Promo_Code__c = 'steven=cool',
                Ticket_Type__c = newsEventPlatinumAdmission.Id,
                Recipient__c = generousAndAlumniOrStark.Id
            )
        };

        insert ticketDiscounts;
    }

    @future
    public static void createNewsAndLearningData(){
        String baseUrl = getBaseUrl();

        // news Listings to insert
        List<ucinn_portal_Listing__c> newsToInsert = new List<ucinn_portal_Listing__c>();

        String newsRecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('News').getRecordTypeId();
        String startDateTimeString = Datetime.now().addDays(-1).format('yyyy-MM-dd hh:mm:ss');
        String endDateTimeString = Datetime.now().addDays(14).format('yyyy-MM-dd hh:mm:ss');

        ucinn_portal_Listing__c newsListing1 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = '10 Benefits of Paying a Competitive Salary',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_158878085_cropped.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/University-Seal.jpg">',
                                                                        Header_Content__c = 'How to have happier workers, generate more revenue, and more.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now(),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Arts',
                                                                        Recommend_Type_2__c = 'Biology');
                                                                        
        newsToInsert.add(newsListing1);


        ucinn_portal_Listing__c newsListing2 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'Government Newsom Changes Single-Family Lot Laws',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_211651043.jpg">',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/news-AdobeStock_464335783.jpg">',
                                                                        Header_Content__c = 'The latest on the how his policies impact family life.',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(1),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Biology',
                                                                        Recommend_Type_2__c = 'Breakthroughs');
        newsToInsert.add(newsListing2);


        ucinn_portal_Listing__c newsListing3 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'SoCal Gas Settles for $1.8 billion',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/giving.png">',
                                                                        Header_Content__c = 'SoCal Gas agrees to settle over Aliso Canyon gas leak.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(2),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Breakthroughs',
                                                                        Recommend_Type_2__c = 'Business');
        newsToInsert.add(newsListing3);


        ucinn_portal_Listing__c newsListing4 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'Cancer Without Chemotherapy',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_479379625.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/new-york-city-sunset.jpg">',
                                                                        Header_Content__c = 'There are now alternate treatments to cancer that aren\'t chemotherapy.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(3),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Business',
                                                                        Recommend_Type_2__c = 'Child Development');
        newsToInsert.add(newsListing4);

        ucinn_portal_Listing__c newsListing5 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'Elton John Takes Action Against Magazine for Slander',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/companyCertificationImage.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_479379625.jpg">',
                                                                        Header_Content__c = 'Celebrities give their take on publication culture surrounding show business.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(4),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Child Development',
                                                                        Recommend_Type_2__c = 'Computation');
                                                                        
        newsToInsert.add(newsListing5);


        ucinn_portal_Listing__c newsListing6 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'The Largest Showcase of PC Games Ever at Expo 2022',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/giving.png">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Header_Content__c = 'Get a sneak peak of what games hitting the market next year.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(5),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Computation',
                                                                        Recommend_Type_2__c = 'Culture');
        newsToInsert.add(newsListing6);


        ucinn_portal_Listing__c newsListing7 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'Unisoft Boasts 50 billion Streams in 2022 Alone',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/news-AdobeStock_464335783.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_211651043.jpg">',
                                                                        Header_Content__c = 'Take a look inside the company that begins to rival spotify.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(6),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Culture',
                                                                        Recommend_Type_2__c = 'Economics');
        newsToInsert.add(newsListing7);

        ucinn_portal_Listing__c newsListing8 = new ucinn_portal_Listing__c(RecordTypeId = newsRecordTypeId,
                                                                        Name = 'Even After $200 Billion, Self-Driving Cars Are Going Nowhere',
                                                                        Actual_Start_Date_Time__c = startDateTimeString,
                                                                        Actual_End_Date_Time__c = endDateTimeString,
                                                                        Start_Date_Time__c = DateTime.now().addDays(-1),
                                                                        End_Date_Time__c =  DateTime.now().addDays(14),
                                                                        Event_Actual_Start_Date_Time__c = '2022-07-01 12:00:00',
                                                                        Event_Actual_End_Date_Time__c =  '2022-09-01 12:00:00',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/University-Seal.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_158878085_cropped.jpg">',
                                                                        Header_Content__c = 'The future is now.',
                                                                        Body_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.',
                                                                        Footer_Content__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu.',
                                                                        Top_Story_Date__c = DateTime.now().addDays(7),
                                                                        Is_Featured__c = true,
                                                                        Format__c = 'Article',
                                                                        Recommend_Type_1__c = 'Economics',
                                                                        Recommend_Type_2__c = 'Arts');
        newsToInsert.add(newsListing8);

        insert newsToInsert;
    }


    /**
     * Function that creates giving society and honor roll data.
     * This data includes, giving societies, membership levels & benefits, honor roll names, society memberships, and donor stories
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createGivingSocietyHonorRollData() {
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        String baseUrl = getBaseUrl();

        insertGivingSocietyAndHonorRollRecords(baseUrl);
        insertDonorStoriesForGivingSocietyAndHonorRolls(baseUrl);
    }

    /**
     * Function that creates membership data.
     * This data includes, giving societies, membership level products, society memberships, and opportunities
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createMembershipData() {
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }
        String baseUrl = getBaseUrl();

        Date today = Date.today();
        Date nextYear = today.addYears(1);

        List<ucinn_ascendv2__Giving_Society__c> societiesToInsert = new List<ucinn_ascendv2__Giving_Society__c>();


        ucinn_ascendv2__Giving_Society__c badinSociety = new ucinn_ascendv2__Giving_Society__c( Name = 'Badin Guild Alternative',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Lifetime',
                                                                                                ucinn_portal_Label__c = 'Badin Guild Alternative',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_479379625.jpg">',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(badinSociety);


        ucinn_ascendv2__Giving_Society__c carlosSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Carlos Museum Alternative',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Lifetime',
                                                                                                ucinn_portal_Label__c = 'Carlos Museum Alternative',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(carlosSociety);


        ucinn_ascendv2__Giving_Society__c longhornSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'UC Innovation Loyal Alternative',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Label__c = 'UC Innovation Loyal',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/University-Seal.jpg">',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(longhornSociety);

        ucinn_ascendv2__Giving_Society__c ucinnSociety = new ucinn_ascendv2__Giving_Society__c( Name = 'UC Innovation Society Alternative',
                                                                                        ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                        ucinn_portal_Type__c = 'Annual',
                                                                                        ucinn_ascendv2__Status__c = 'Active',
                                                                                        ucinn_portal_Label__c = 'UC Innovation Society',
                                                                                        ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/Ascend-img.jpeg">',
                                                                                        ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                    + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                    + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                    + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(ucinnSociety);

        insert societiesToInsert;


        ucinn_ascendv2__Designation__c ascendDesignation = new ucinn_ascendv2__Designation__c(Name = 'ascend Annual Fund Alternative',
                                                                     ucinn_ascendv2__G_L_Short_Description__c = 'ascend Annual Fund Alternative',
                                                                     ucinn_portal_Is_Display_On_Portal__c = true,
                                                                     ucinn_ascendv2__G_L_Effective_Date__c = Date.newInstance(2020, 10, 01),
                                                                     ucinn_ascendv2__Designation_Name__c = 'ascend Annual Fund Alternative');


        insert ascendDesignation;


        List<Product2> membershipsAndBenefitsToInsert = new List<Product2>();

        String productInformation = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Membership_Level').getRecordTypeId();
        String benefitInformation = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Membership_Benefit').getRecordTypeId();

        Product2 businessMembership = new Product2(Name = 'Business Membership',
                                                ExternalId = 'Unique Business ID',
                                                ucinn_ascendv2__Designation__c = ascendDesignation.Id,
                                                IsActive = true,
                                                ucinn_ascendv2__Giving_Society__c = badinSociety.Id,
                                                RecordTypeId = productInformation,
                                                ucinn_ascendv2__Months_Allocated_on_Purchase__c = 24,
                                                ucinn_ascendv2__Months_Allocated_on_Payment__c = 12,
                                                ucinn_ascendv2__Months_Allocated_on_Payment_in_Full__c = 12,
                                                ucinn_ascendv2__Payment_Options__c = 'One-Time Membership');
        membershipsAndBenefitsToInsert.add(businessMembership);

        Product2 designMembership = new Product2(Name = 'Design Membership',
                                                ExternalId = 'Unique Design ID',
                                                ucinn_ascendv2__Designation__c = ascendDesignation.Id,
                                                IsActive = true,
                                                ucinn_ascendv2__Giving_Society__c = carlosSociety.Id,
                                                RecordTypeId = productInformation,
                                                ucinn_ascendv2__Months_Allocated_on_Purchase__c = 36,
                                                ucinn_ascendv2__Months_Allocated_on_Payment__c = 12,
                                                ucinn_ascendv2__Months_Allocated_on_Payment_in_Full__c = 12,
                                                ucinn_ascendv2__Payment_Options__c = 'One-Time Membership');
        membershipsAndBenefitsToInsert.add(designMembership);


        Product2 ucinnMembership = new Product2(Name = 'New Membership',
                                                ExternalId = 'Unique New Membership ID',
                                                ucinn_ascendv2__Designation__c = ascendDesignation.Id,
                                                IsActive = true,
                                                ucinn_ascendv2__Giving_Society__c = ucinnSociety.Id,
                                                RecordTypeId = productInformation,
                                                ucinn_ascendv2__Months_Allocated_on_Purchase__c = 12,
                                                ucinn_ascendv2__Months_Allocated_on_Payment__c = 12,
                                                ucinn_ascendv2__Months_Allocated_on_Payment_in_Full__c = 12,
                                                ucinn_ascendv2__Payment_Options__c = 'Auto Renewing Membership');
        membershipsAndBenefitsToInsert.add(ucinnMembership);


        Product2 alumniMembership = new Product2(Name = 'Alumni Membership',
                                                ExternalId = 'Unique Alumni ID',
                                                ucinn_ascendv2__Designation__c = ascendDesignation.Id,
                                                IsActive = true,
                                                ucinn_ascendv2__Giving_Society__c = longhornSociety.Id,
                                                RecordTypeId = productInformation,
                                                ucinn_ascendv2__Months_Allocated_on_Purchase__c = 12,
                                                ucinn_ascendv2__Months_Allocated_on_Payment__c = 12,
                                                ucinn_ascendv2__Months_Allocated_on_Payment_in_Full__c = 12,
                                                ucinn_ascendv2__Payment_Options__c = 'Installment Based Membership');
        membershipsAndBenefitsToInsert.add(alumniMembership);

        Product2 premiumMembership = new Product2(Name = 'Premium Membership',
                                                 ExternalId = 'Unique Premium ID',
                                                 ucinn_ascendv2__Designation__c = ascendDesignation.Id,
                                                 IsActive = true,
                                                 ucinn_ascendv2__Giving_Society__c = carlosSociety.Id,
                                                 RecordTypeId = productInformation,
                                                 ucinn_ascendv2__Months_Allocated_on_Purchase__c = 36,
                                                 ucinn_ascendv2__Months_Allocated_on_Payment__c = 12,
                                                 ucinn_ascendv2__Months_Allocated_on_Payment_in_Full__c = 12,
                                                 ucinn_ascendv2__Payment_Options__c = 'One-Time Membership');
        membershipsAndBenefitsToInsert.add(premiumMembership);

        Product2 premiumMembershipBenefit = new Product2(Name = 'Premium Membership Benefits',
                                                         Description = 'With this Premium Membership, you get free entry to all of our lounges around the globe.',
                                                         IsActive = true,
                                                         RecordTypeId = benefitInformation);
        membershipsAndBenefitsToInsert.add(premiumMembershipBenefit);

        insert membershipsAndBenefitsToInsert;


        Pricebook2 priceBook = new Pricebook2(Name = 'Standard Price Book',
                                            IsActive = true);
        insert priceBook;

        String priceBookId = '';

        if (!Test.isRunningTest()) {
            Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
            priceBookId = standardPricebook?.Id;
        } else {
            priceBookId = Test.getStandardPricebookId();
        }


        List<PricebookEntry> pricebookEntriesToInsert = new List<PricebookEntry>();


        PricebookEntry businessPricebookEntry = new PricebookEntry(Product2Id = businessMembership.Id,
                                                                    Pricebook2Id = priceBookId,
                                                                    UnitPrice = 100,
                                                                    IsActive = true);
        pricebookEntriesToInsert.add(businessPricebookEntry);


        PricebookEntry designPricebookEntry = new PricebookEntry(Product2Id = designMembership.Id,
                                                                    Pricebook2Id = priceBookId,
                                                                    UnitPrice = 150,
                                                                    IsActive = true);
        pricebookEntriesToInsert.add(designPricebookEntry);


        PricebookEntry ucinnPricebookEntry = new PricebookEntry(Product2Id = ucinnMembership.Id,
                                                                    Pricebook2Id = priceBookId,
                                                                    UnitPrice = 50,
                                                                    IsActive = true);
        pricebookEntriesToInsert.add(ucinnPricebookEntry);


        PricebookEntry alumniPricebookEntry = new PricebookEntry(Product2Id = alumniMembership.Id,
                                                                    Pricebook2Id = priceBookId,
                                                                    UnitPrice = 60,
                                                                    IsActive = true);
        pricebookEntriesToInsert.add(alumniPricebookEntry);

        PricebookEntry premiumPricebookEntry = new PricebookEntry(Product2Id = premiumMembership.Id,
                                                                  Pricebook2Id = priceBookId,
                                                                  UnitPrice = 150,
                                                                  IsActive = true);
        pricebookEntriesToInsert.add(premiumPricebookEntry);

        PricebookEntry premiumBenefitPricebookEntry = new PricebookEntry(Product2Id = premiumMembershipBenefit.Id,
                                                                         Pricebook2Id = priceBookId,
                                                                         UnitPrice = 50,
                                                                         IsActive = true);
        pricebookEntriesToInsert.add(premiumBenefitPricebookEntry);


        insert pricebookEntriesToInsert;

        List<ucinn_ascendv2__Level_Benefit__c> levelBenefitJunctionToInsert = new List<ucinn_ascendv2__Level_Benefit__c>();

        ucinn_ascendv2__Level_Benefit__c premiumMembershipJunction = new ucinn_ascendv2__Level_Benefit__c(ucinn_ascendv2__Membership_Benefit_Product__c = premiumMembershipBenefit.Id, 
                                                                                                          ucinn_ascendv2__Membership_Level_Product__c = premiumMembership.Id);
        levelBenefitJunctionToInsert.add(premiumMembershipJunction);

        insert levelBenefitJunctionToInsert;


        String campaignInformation = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Appeal').getRecordTypeId();


        List<Campaign> campaignsToInsert = new List<Campaign>();


        Campaign mariahCampaign = new Campaign(Name = 'The Mariah Foundation',
                                                IsActive = true,
                                                ucinn_ascendv2__Motivation_Code__c = 'The Mariah Foundation',
                                                RecordTypeId = campaignInformation);
        campaignsToInsert.add(mariahCampaign);


        insert campaignsToInsert;


        // inserting RTV2 records triggers the creation of other related records, such as society memberships
        List<ucinn_ascendv2__Review_Transaction_v2__c> reviewTransactionsToInsert = new List<ucinn_ascendv2__Review_Transaction_v2__c>();
        Integer externalIdSuffix = 1;
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            ucinn_ascendv2__Review_Transaction_v2__c firstRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c(Name = 'rtv2Portal5',
                                                                                        ucinn_ascendv2__Status__c = 'New',
                                                                                        ucinn_ascendv2__Membership_Anniversary_Date_1__c = today,
                                                                                        ucinn_ascendv2__Membership_Expiration_Date_1__c = nextYear,
                                                                                        ucinn_ascendv2__Transaction_Date__c = today,
                                                                                        ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID),
                                                                                        ucinn_ascendv2__Transaction_Type__c = 'One-Time Membership',
                                                                                        ucinn_ascendv2__Opportunity_Type__c = 'One-Time Membership',
                                                                                        ucinn_ascendv2__Designation_1__c = ascendDesignation.Id,
                                                                                        ucinn_ascendv2__Tender_Type_1__c = 'Cash',
                                                                                        ucinn_ascendv2__Payment_Amount_1_1__c = 100.00,
                                                                                        ucinn_ascendv2__Payment_Date_1_1__c = today,
                                                                                        ucinn_ascendv2__External_System_ID__c = 'PORT-ONETIME1-' + externalIdSuffix,
                                                                                        ucinn_ascendv2__Campaign__c = mariahCampaign.Id,
                                                                                        ucinn_ascendv2__Membership_Level_External_ID_1__c = designMembership.ExternalId);

            reviewTransactionsToInsert.add(firstRTV2);

            ucinn_ascendv2__Review_Transaction_v2__c secondRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c(Name = 'rtv2Portal6',
                                                                                        ucinn_ascendv2__Status__c = 'New',
                                                                                        ucinn_ascendv2__Membership_Anniversary_Date_1__c = today,
                                                                                        ucinn_ascendv2__Membership_Expiration_Date_1__c = nextYear,
                                                                                        ucinn_ascendv2__Transaction_Date__c = today,
                                                                                        ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID),
                                                                                        ucinn_ascendv2__Transaction_Type__c = 'One-Time Membership',
                                                                                        ucinn_ascendv2__Opportunity_Type__c = 'One-Time Membership',
                                                                                        ucinn_ascendv2__Designation_1__c = ascendDesignation.Id,
                                                                                        ucinn_ascendv2__Tender_Type_1__c = 'Cash',
                                                                                        ucinn_ascendv2__Payment_Amount_1_1__c = 100.00,
                                                                                        ucinn_ascendv2__Payment_Date_1_1__c = today,
                                                                                        ucinn_ascendv2__External_System_ID__c = 'PORT-ONETIME2-' + externalIdSuffix,
                                                                                        ucinn_ascendv2__Campaign__c = mariahCampaign.Id,
                                                                                        ucinn_ascendv2__Membership_Level_External_ID_1__c = businessMembership.ExternalId);

            reviewTransactionsToInsert.add(secondRTV2);

            ucinn_ascendv2__Review_Transaction_v2__c thirdRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c(ucinn_ascendv2__Membership_Anniversary_Date_1__c = today,        
                                                                                        ucinn_ascendv2__Membership_Expiration_Date_1__c = nextYear,
                                                                                        ucinn_ascendv2__Membership_Level_External_ID_1__c = alumniMembership.ExternalId,
                                                                                        Name = 'rtv2Portal7',
                                                                                        ucinn_ascendv2__Status__c = 'New',
                                                                                        ucinn_ascendv2__Transaction_Type__c = 'Installment Based Membership with Payment',
                                                                                        ucinn_ascendv2__Transaction_Date__c = today,
                                                                                        ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID),
                                                                                        ucinn_ascendv2__Designation_1__c = ascendDesignation.Id,
                                                                                        ucinn_ascendv2__Campaign__c = mariahCampaign.Id,
                                                                                        ucinn_ascendv2__Opportunity_Type__c = 'Installment Based Membership',
                                                                                        ucinn_ascendv2__Installment_Frequency_1__c = 'Annual',
                                                                                        ucinn_ascendv2__Number_of_Installments_1__c = 4,
                                                                                        ucinn_ascendv2__Installment_Amount_1__c = 60.00,
                                                                                        ucinn_ascendv2__Installment_Date_1__c = today,
                                                                                        ucinn_ascendv2__External_System_ID__c = 'PORT-INSTALLMENTBASED1-' + externalIdSuffix,
                                                                                        ucinn_ascendv2__Tender_Type_1__c = 'Cash',
                                                                                        ucinn_ascendv2__Payment_Amount_1_1__c = 15.00,
                                                                                        ucinn_ascendv2__Payment_Date_1_1__c = today);

            reviewTransactionsToInsert.add(thirdRTV2);

            ucinn_ascendv2__Review_Transaction_v2__c fourthRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c(ucinn_ascendv2__Membership_Anniversary_Date_1__c = today,        
                                                                                        ucinn_ascendv2__Membership_Expiration_Date_1__c = nextYear,
                                                                                        ucinn_ascendv2__Membership_Level_External_ID_1__c = ucinnMembership.ExternalId,
                                                                                        Name = 'rtv2Portal8',
                                                                                        ucinn_ascendv2__Status__c = 'New',
                                                                                        ucinn_ascendv2__Transaction_Date__c = today,
                                                                                        ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID),
                                                                                        ucinn_ascendv2__Transaction_Type__c = 'Auto Renewing Membership',
                                                                                        ucinn_ascendv2__Designation_1__c = ascendDesignation.Id,
                                                                                        ucinn_ascendv2__Campaign__c = mariahCampaign.Id,
                                                                                        ucinn_ascendv2__Opportunity_Type__c = 'Auto Renewing Membership',
                                                                                        ucinn_ascendv2__Installment_Frequency_1__c = 'Annual',
                                                                                        ucinn_ascendv2__Installment_Amount_1__c = 60.00,
                                                                                        ucinn_ascendv2__Installment_Date_1__c = today,
                                                                                        ucinn_ascendv2__Tender_Type_1__c = 'Cash',
                                                                                        ucinn_ascendv2__External_System_ID__c = 'PORT-AUTORENEWING1-' + externalIdSuffix);

            reviewTransactionsToInsert.add(fourthRTV2);
            ++externalIdSuffix;
        }

        insert reviewTransactionsToInsert;

    }

    /**
     * Function that creates online giving and giving history data
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createOnlineGivingAndGivingHistoryData() {
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        List<ucinn_ascendv2__Designation__c> designationsToInsert = new List<ucinn_ascendv2__Designation__c>();

        ucinn_ascendv2__Designation__c ascendDesignation = new ucinn_ascendv2__Designation__c(Name = 'ascend Annual Fund',
                                                                     ucinn_ascendv2__G_L_Short_Description__c = 'ascend Annual Fund',
                                                                     ucinn_portal_Is_Display_On_Portal__c = true,
                                                                     ucinn_ascendv2__External_System_ID__c = 'ascend Annual Fund',
                                                                     ucinn_portal_Display_Order__c = '1',
                                                                     ucinn_ascendv2__G_L_Effective_Date__c = Date.newInstance(2020, 10, 01),
                                                                     ucinn_ascendv2__Designation_Name__c = 'ascend Annual Fund');
        designationsToInsert.add(ascendDesignation);


        ucinn_ascendv2__Designation__c membDesignation = new ucinn_ascendv2__Designation__c(Name = '02-Memb',
                                                                     ucinn_ascendv2__Designation_Name__c = '02-Memb',
                                                                     ucinn_portal_Is_Display_On_Portal__c = true,
                                                                     ucinn_ascendv2__External_System_ID__c = '02-Memb',
                                                                     ucinn_portal_Display_Order__c = '2',
                                                                     ucinn_ascendv2__G_L_Effective_Date__c = Date.newInstance(2021, 08, 01));
        designationsToInsert.add(membDesignation);


        ucinn_ascendv2__Designation__c neurologyDesignation = new ucinn_ascendv2__Designation__c(Name = 'Neurology',
                                                                     ucinn_portal_Is_Display_On_Portal__c = true,
                                                                     ucinn_portal_Display_Order__c = '3',
                                                                     ucinn_ascendv2__External_System_ID__c = 'Neurology',
                                                                     ucinn_ascendv2__G_L_Effective_Date__c = Date.newInstance(2021, 08, 01),
                                                                     ucinn_ascendv2__Designation_Name__c = 'Neurology');
        designationsToInsert.add(neurologyDesignation);


        insert designationsToInsert;

        Campaign testAppeal = new Campaign(Name = 'Test Appeal',Status = 'In Progress',
                                           ucinn_ascendv2__Motivation_Code__c = 'Test Appeal',
                                           IsActive = true);

        insert testAppeal;

        List<ucinn_ascendv2__Review_Transaction_v2__c> rtv2List = new List<ucinn_ascendv2__Review_Transaction_v2__c>();
        Integer externalIdSuffix = 1;
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            ucinn_ascendv2__Review_Transaction_v2__c firstRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c();
            firstRTV2.Name = 'rtv2Portal1';
            firstRTV2.ucinn_ascendv2__Status__c = 'New';
            firstRTV2.ucinn_ascendv2__Transaction_Date__c = Date.today();
            firstRTV2.ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID);
            firstRTV2.ucinn_ascendv2__Transaction_Type__c = 'Gift';
            firstRTV2.ucinn_ascendv2__Opportunity_Type__c = 'Outright';
            firstRTV2.ucinn_ascendv2__Designation_1__c = neurologyDesignation.Id;
            firstRTV2.ucinn_ascendv2__Tender_Type_1__c = 'Cash';
            firstRTV2.ucinn_ascendv2__Payment_Amount_1_1__c = 100.00;
            firstRTV2.ucinn_ascendv2__Payment_Date_1_1__c = Date.today();
            firstRTV2.ucinn_ascendv2__External_System_ID__c = 'PORT-0011-' + externalIdSuffix;
            firstRTV2.ucinn_ascendv2__Campaign__c = testAppeal.Id;

            ucinn_ascendv2__Review_Transaction_v2__c secondRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c();
            secondRTV2.Name = 'rtv2Portal2';
            secondRTV2.ucinn_ascendv2__Status__c = 'New';
            secondRTV2.ucinn_ascendv2__Transaction_Date__c = Date.today();
            secondRTV2.ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID);
            secondRTV2.ucinn_ascendv2__Transaction_Type__c = 'Matching Gift with Payment';
            secondRTV2.ucinn_ascendv2__Opportunity_Type__c = 'Matching';
            secondRTV2.ucinn_ascendv2__Designation_1__c = ascendDesignation.Id;
            secondRTV2.ucinn_ascendv2__Tender_Type_1__c = 'Cash';
            secondRTV2.ucinn_ascendv2__Payment_Amount_1_1__c = 100.00;
            secondRTV2.ucinn_ascendv2__Payment_Date_1_1__c = Date.today();
            secondRTV2.ucinn_ascendv2__External_System_ID__c = 'PORT-MATCHING' + externalIdSuffix;
            secondRTV2.ucinn_ascendv2__Campaign__c = testAppeal.Id;
            secondRTV2.ucinn_ascendv2__Installment_Frequency_1__c = 'Weekly';
            secondRTV2.ucinn_ascendv2__Number_of_Installments_1__c = 1;
            secondRTV2.ucinn_ascendv2__Installment_Amount_1__c = 150.00;
            secondRTV2.ucinn_ascendv2__Installment_Date_1__c = Date.today().addDays(1);
            secondRTV2.ucinn_ascendv2__Confirmation_Date__c = Date.today();
            secondRTV2.ucinn_ascendv2__Confirmation_Method__c = 'Automatic Process';

            ucinn_ascendv2__Review_Transaction_v2__c thirdRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c();
            thirdRTV2.Name = 'rtv2Portal3';
            thirdRTV2.ucinn_ascendv2__Status__c = 'New';
            thirdRTV2.ucinn_ascendv2__Transaction_Date__c = Date.today();
            thirdRTV2.ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID);
            thirdRTV2.ucinn_ascendv2__Transaction_Type__c = 'Pledge with Payment';
            thirdRTV2.ucinn_ascendv2__Opportunity_Type__c = 'Annual';
            thirdRTV2.ucinn_ascendv2__Designation_1__c = membDesignation.Id;
            thirdRTV2.ucinn_ascendv2__Tender_Type_1__c = 'Cash';
            thirdRTV2.ucinn_ascendv2__Payment_Amount_1_1__c = 50.00;
            thirdRTV2.ucinn_ascendv2__Payment_Date_1_1__c = Date.today();
            thirdRTV2.ucinn_ascendv2__External_System_ID__c = 'PORT-PLEDGE' + externalIdSuffix;
            thirdRTV2.ucinn_ascendv2__Campaign__c = testAppeal.Id;
            thirdRTV2.ucinn_ascendv2__Installment_Frequency_1__c = 'Weekly';
            thirdRTV2.ucinn_ascendv2__Number_of_Installments_1__c = 1;
            thirdRTV2.ucinn_ascendv2__Installment_Amount_1__c = 200.00;
            thirdRTV2.ucinn_ascendv2__Installment_Date_1__c = Date.today().addDays(1);

            ucinn_ascendv2__Review_Transaction_v2__c fourthRTV2 = new ucinn_ascendv2__Review_Transaction_v2__c();
            fourthRTV2.Name = 'rtv2Portal4';
            fourthRTV2.ucinn_ascendv2__Status__c = 'New';
            fourthRTV2.ucinn_ascendv2__Transaction_Date__c = Date.today();
            fourthRTV2.ucinn_ascendv2__Contact__c = eachContactMap.get(CONTACT_ID);
            fourthRTV2.ucinn_ascendv2__Transaction_Type__c = 'Recurring Gift with Payment';
            fourthRTV2.ucinn_ascendv2__Opportunity_Type__c = 'Recurring';
            fourthRTV2.ucinn_ascendv2__Designation_1__c = neurologyDesignation.Id;
            fourthRTV2.ucinn_ascendv2__Tender_Type_1__c = 'Cash';
            fourthRTV2.ucinn_ascendv2__Payment_Amount_1_1__c = 50.00;
            fourthRTV2.ucinn_ascendv2__Payment_Date_1_1__c = Date.today();
            fourthRTV2.ucinn_ascendv2__External_System_ID__c = 'PORT-RECUR' + externalIdSuffix;
            fourthRTV2.ucinn_ascendv2__Campaign__c = testAppeal.Id;
            fourthRTV2.ucinn_ascendv2__Installment_Frequency_1__c = 'Weekly';
            fourthRTV2.ucinn_ascendv2__Number_of_Installments_1__c = 1;
            fourthRTV2.ucinn_ascendv2__Installment_Amount_1__c = 200.00;
            fourthRTV2.ucinn_ascendv2__Installment_Date_1__c = Date.today().addDays(1);
        
            rtv2List.add(firstRTV2);
            rtv2List.add(secondRTV2);
            rtv2List.add(thirdRTV2);
            rtv2List.add(fourthRTV2);

            ++externalIdSuffix;
        }

        insert rtv2List;

        String baseUrl = getBaseUrl();
        insert new ucinn_portal_Giving_Form__c(
            Name = 'Home',
            Page_URL__c = '/ascendportal/s/',
            Appeal__c = testAppeal.Id,
            Gift_Types__c = 'outright;pledge;recurring',
            Gift_Frequency__c = 'Annual;Monthly;Weekly',
            Email_Type_Picklist_Values__c = 'Personal;Other',
            Phone_Type_Picklist_Values__c = 'Mobile;Home;Other',
            Address_Type_Picklist_Values__c = 'Home;Mailing;Other',
            Is_End_Date_Enabled__c = true,
            Default_Number_of_Installments__c = 4,
            Default_Amount__c = 25,
            Gift_Details_Label__c = 'Gift Details',
            Billing_Details_Label__c = 'Billing',
            Payment_Form_Label__c = 'Payment',
            Confirmation_Label__c = 'Thank You',
            Confirmation_Text__c = '<p>Thank you for your gift. Your generosity will make a difference at the University.</p><img src="' + baseUrl + '/resource/Portal_DataCreationPictures/news-AdobeStock_464335783.jpg">'
        );
    }

    /**
     * Function that creates newsletter html template
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createNewsletterHtmlTemplate() {
        String baseUrl = getBaseUrl();

        // newsletter html template to insert
        List<ucinn_portal_Listing__c> newsletterTemplateListingList = new List<ucinn_portal_Listing__c>();

        String newsletterTemplateRecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter_Template').getRecordTypeId();

        ucinn_portal_Listing__c newsletterHtmlTemplate = new ucinn_portal_Listing__c(RecordTypeId = newsletterTemplateRecordTypeId,
                                                                                     Name = 'Newsletter HTML Template');
        newsletterTemplateListingList.add(newsletterHtmlTemplate);

        insert newsletterTemplateListingList;

        createNewsletterHtmlTemplateSections(newsletterTemplateListingList.get(0).Id);
    }

    /**
     * Function that creates default zone
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    @future
    public static void createDefaultZone() {
        String baseUrl = getBaseUrl();

        List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();

        ucinn_portal_Zone__c defaultZone = new ucinn_portal_Zone__c(Name = 'All', Social_Media_Order__c= 'LinkedIn;Twitter',
                                                                    Is_Display_on_Portal__c = true, Search_Radius__c = 50,
                                                                    Twitter_Link__c = 'https://twitter.com/ucinnovationinc', State__c = 'California',
                                                                    City__c = 'Irvine', Country__c = 'United States',
                                                                    LinkedIn_Link__c = 'https://www.linkedin.com/company/uc-innovation',
                                                                    Header_Image_Alt_Text__c = 'UC Innovation', Logo_Image_Alt_Text__c = 'UC Innovation'
                                                                    );

        defaultZone.Footer_Content__c = '<table width="600" cellspacing="0" cellpadding="0" bgcolor="#155f83" style="background-color:#155f83; border-collapse: collapse; max-width:600px;">'
                                        + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                        + '<tr>'
                                        + '<td width="90"style="padding: 0px;"></td>'
                                        + '<td width="420" align="center" style="padding: 0px; line-height:20px; text-align:center;color:#ffffff;">For questions, please email {organizationName} at <a style="font-weight:900;color:white;" href="mailto:info@ucinnovation.com">info@ucinnovation.com</a> or via phone at (949) 415-8246</td>'
                                        + '<td width="90"></td>'
                                        + '</tr>'
                                        + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                        + '</table>'
                                        + '<table width="600" cellspacing="0" cellpadding="0" bgcolor="#15425f" style="background-color:#15425f;border-collapse: collapse; max-width:600px;">'
                                        + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                        + '<tr>'
                                        + '<td width="90" height="15"style="padding: 0px;"></td>'
                                        + '<td width="420" height="15"style="padding: 0px;">'
                                        + '<table align="center">'
                                        + '<tr>'
                                        + '{socialMediaContent}'
                                        + '</tr>'
                                        + '</table>'
                                        + '</td>'
                                        + '<td width="90" height"15"style="padding: 0px;"></td>'
                                        + '</tr>'
                                        + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                        + '</table>'
                                        + '<table width="600" cellspacing="0" cellpadding="0" bgcolor="#000000" style="background-color:#000000;border-collapse: collapse; max-width:600px;">'
                                        + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                        + '<tr>'
                                        + '<td width="90"style="padding: 0px;"></td>'
                                        + '<td width="420" style="padding:0px;color:#ffffff; text-align:center;">'
                                        + '<a href="{portalURL}" target="_blank"><img style="width: 50px" src={logoImageURL} alt="{logoImageAltText}"></img></a>'
                                        + '</td>'
                                        + '<td width="90"style="padding: 0px;"></td>'
                                        + '</tr>'
                                        + '<tr><td Colspan="3" height="14" style="padding:0px;">&nbsp;</td></tr>'
                                        + '<tr>'
                                        + '<td width="90" height"14"style="padding: 0px;"></td>'
                                        + '<td height="19" width="420" style="padding:0px;color:#ffffff;text-align:center;">UC Innovation<br>2855 Michelle Dr. Suite 190, Irvine, CA 92606</td>'
                                        + '<td width="90" height"14"style="padding: 0px;"></td>'
                                        + '</tr>'
                                        + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                        + '</table>'
                                        + '<div>If you no longer wish to receive these newsletters, you may <a style="color: #800000; font-weight: bold;" href={unsubscribeURL}> unsubscribe</a>.</div><div>Sign in to UC Innovation\'s Portal to <a style="color: #800000; font-weight: bold;" href={changePreferencesURL}>manage your preferences</a> for all clubs and groups.</div>';

        defaultZone.Newsletter_HTML_Format__c = '<table border="0" cellspacing="0" cellpadding="0" width="600" style="max-width:600px;">'
                                                + '<tr><td style="padding: 0px;"><div style="font-size: 0px">{preHeader}</div></td></tr>'
                                                + '<tr><td style="padding: 0px;"><div style="width: 600px;"><img style="width: 600px" src={headerImageURL} alt="{headerImageAltText}"></img></a></div></td></tr>'
                                                + '</table>'
                                                + '<table cellspacing="0" cellpadding="0" border="0" width="600" style="max-width:600px; border-collapse: collapse;">'
                                                + '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>'
                                                + '<tr>'
                                                + '<td width="90" style="padding: 0px;"></td>'
                                                + '<td width="420" style="padding: 0px;"><div width="420" style="width:420px;">{bodyContent}</div></td>'
                                                + '<td width="90"style="padding: 0px;"></td>'
                                                + '</tr>'
                                                + '<tr><td Colspan="3" height="30" style="padding:0px;">&nbsp;</td></tr>'
                                                + '<tr>'
                                                + '<td width="90"style="padding: 0px;"></td>'
                                                + '<td width="420"style="padding: 0px;"><hr heigh="1" style="margin: 0px 0px 0px 0px;"></td>'
                                                + '<td width="90"style="padding: 0px;"></td>'
                                                + '</tr>'
                                                + '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>'
                                                + '<tr>'
                                                + '</table>'
                                                + '{sectionContent}'
                                                + '{footerContent}';

        defaultZone.Social_Media_Content__c = '<td style="text-align:right; padding-left: 10px; padding-right: 10px;">'
                                                + '<a href="{SocialMediaLink_1}" target="_blank"><img width="40" style="width:40px;" alt="{SocialMediaDefaultAltText_1}" src="{SocialMediaImageSource_1}"/></a>'
                                                + '</td>'
                                                + '<td style="text-align:right; padding-left: 10px; padding-right: 10px;">'
                                                + '<a href="{SocialMediaLink_2}" target="_blank"><img width="40" style="width:40px;" alt="{SocialMediaDefaultAltText_2}" src="{SocialMediaImageSource_2}"/></a>'
                                                + '</td>';

        defaultZone.Logo_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/companyLogo.jpg">';
        defaultZone.Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/companyCertificationImage.jpg">';

        zoneList.add(defaultZone);
        insert zoneList;
    }

    /**
     * Function that creates event listings, volunteer jobs, volunteer shifts
     * Also creates volunteer and volunteer skill records using the Anthony Stark test constituent
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    @future
    public static void createVolunteerDataWithConstituent() {
        createVolunteerData(true);
    }

    /**
     * Function that creates event listings, volunteer jobs, volunteer shifts
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    @future
    public static void createVolunteerDataWithoutConstituent() {
        createVolunteerData(false);
    }

    /**
     * Function that creates event listings, volunteer jobs, volunteer shifts
     * Potentially creates volunteer and volunteer skill records
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param isUsingConstituent    Boolean: use demo constituent for additional volunteer-related records
     */
    private static void createVolunteerData(Boolean isUsingConstituent) {
        String baseUrl = getBaseUrl();
        String pathPrefix = getCommunityPathPrefix();
        if (String.isNotBlank(pathPrefix)) {
            pathPrefix = '/' + pathPrefix;
        }

        String eventRecordType = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();

        List<ucinn_portal_Listing__c> listings = new List<ucinn_portal_Listing__c>{
            new ucinn_portal_Listing__c(Name = 'School Spirit Day', RecordTypeId = eventRecordType),
            new ucinn_portal_Listing__c(Name = 'Game Night', RecordTypeId = eventRecordType),
            new ucinn_portal_Listing__c(Name = 'Silent Auction', RecordTypeId = eventRecordType)
        };
        insert listings;
        
        Date today = Date.today();
        String currentYear = String.valueOf(today.year());
        String currentMonth = String.valueOf(today.month()).leftPad(2, '0');
        String currentDay = String.valueOf(today.day()).leftPad(2, '0');

        Date nextWeek = today.addDays(7);
        String yearInOneWeek = String.valueOf(nextWeek.year());
        String monthInOneWeek = String.valueOf(nextWeek.month()).leftPad(2, '0');
        String dayInOneWeek = String.valueOf(nextWeek.day()).leftPad(2, '0');
 
        Date oneWeekAgo = today.addDays(-7);
        String yearOneWeekAgo = String.valueOf(oneWeekAgo.year());
        String monthOneWeekAgo = String.valueOf(oneWeekAgo.month()).leftPad(2, '0');
        String dayOneWeekAgo = String.valueOf(oneWeekAgo.day()).leftPad(2, '0');

        Date twoWeeksAgo = today.addDays(-14);
        String yearTwoWeeksAgo = String.valueOf(twoWeeksAgo.year());
        String monthTwoWeeksAgo = String.valueOf(twoWeeksAgo.month()).leftPad(2, '0');
        String dayTwoWeeksAgo = String.valueOf(twoWeeksAgo.day()).leftPad(2, '0');

        List<ucinn_portal_Volunteer_Job__c> jobs = new List<ucinn_portal_Volunteer_Job__c>{
            new ucinn_portal_Volunteer_Job__c(
                Name = 'Campus Clean Up',
                Description__c = '<p>Help make our campus beautiful by picking up garbage!</p>',
                Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/University-Seal.jpg">',
                Location_Venue__c = 'University Hall',
                Actual_Start_Date_Time__c = currentYear + '-' + currentMonth + '-' + '01 00:00:00',
                Actual_End_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 00:00:00',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Listing__c = listings[0].Id
            ),

            new ucinn_portal_Volunteer_Job__c(
                Name = 'Bake Sale',
                Description__c = '<p>Volunteer at a booth to sell cookies, advertise for clubs, and raise funds.</p>',
                Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                Location_Venue__c = 'Outside the Library',
                Actual_Start_Date_Time__c = currentYear + '-' + currentMonth + '-' + '01 00:00:00',
                Actual_End_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 00:00:00',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Listing__c = listings[0].Id
            ),

            new ucinn_portal_Volunteer_Job__c(
                Name = 'Game Night Volunteer',
                Description__c = '<p>Volunteer at this fun fundraiser!</p>',
                Actual_Start_Date_Time__c = yearTwoWeeksAgo + '-' + monthTwoWeeksAgo + '-' + dayTwoWeeksAgo + ' 00:00:00',
                Actual_End_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 00:00:00',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Listing__c = listings[1].Id
            ),

            new ucinn_portal_Volunteer_Job__c(
                Name = 'Silent Auction Volunteer',
                Description__c = '<p>Help with various tasks at our annual silent auction.</p>',
                Actual_Start_Date_Time__c = yearTwoWeeksAgo + '-' + monthTwoWeeksAgo + '-' + dayTwoWeeksAgo + ' 00:00:00',
                Actual_End_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 00:00:00',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Listing__c = listings[2].Id
            )
        };

        insert jobs;

        List<ucinn_portal_Volunteer_Shift__c> shifts = new List<ucinn_portal_Volunteer_Shift__c>{
            new ucinn_portal_Volunteer_Shift__c(
                Name = 'Morning Shift',
                Description__c = '<p>Volunteer in the morning to clean up our campus.</p>',
                Status__c = 'Open',
                Actual_Start_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 08:00:00',
                Actual_End_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 12:00:00',
                Report_Hours_Cut_Off_Date_Time__c = today.addDays(14),
                Volunteer_Job__c = jobs[0].Id
            ),

            new ucinn_portal_Volunteer_Shift__c(
                Name = 'Afternoon Shift',
                Description__c = '<p>Volunteer in the afternoon to clean up our campus.</p>',
                Status__c = 'Open',
                Actual_Start_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 13:00:00',
                Actual_End_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 16:00:00',
                Report_Hours_Cut_Off_Date_Time__c = today.addDays(14),
                Volunteer_Job__c = jobs[0].Id
            ),

            new ucinn_portal_Volunteer_Shift__c(
                Name = 'Debate Team Booth',
                Description__c = '<p>Help out the debate team at their booth.</p>',
                Status__c = 'Open',
                Maximum_Number_of_Volunteers__c = 2,
                Actual_Start_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 13:00:00',
                Actual_End_Date_Time__c = yearInOneWeek + '-' + monthInOneWeek + '-' + dayInOneWeek + ' 15:00:00',
                Report_Hours_Cut_Off_Date_Time__c = today.addDays(14),
                Volunteer_Job__c = jobs[1].Id
            ),

            new ucinn_portal_Volunteer_Shift__c(
                Name = 'Game Night Volunteer',
                Description__c = '<p>Help with whatever the event supervisor needs you to do.</p>',
                Status__c = 'Completed',
                Maximum_Number_of_Volunteers__c = 5,
                Actual_Start_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 17:00:00',
                Actual_End_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 22:00:00',
                Report_Hours_Cut_Off_Date_Time__c = today.addDays(14),
                Volunteer_Job__c = jobs[2].Id
            ),

            new ucinn_portal_Volunteer_Shift__c(
                Name = 'Silent Auction Volunteer',
                Description__c = '<p>Help with whatever the event supervisor needs you to do.</p>',
                Status__c = 'Closed',
                Maximum_Number_of_Volunteers__c = 5,
                Actual_Start_Date_Time__c = yearTwoWeeksAgo + '-' + monthTwoWeeksAgo + '-' + dayTwoWeeksAgo + ' 18:00:00',
                Actual_End_Date_Time__c = yearTwoWeeksAgo + '-' + monthTwoWeeksAgo + '-' + dayTwoWeeksAgo + ' 23:00:00',
                Report_Hours_Cut_Off_Date_Time__c = today.addDays(-7),
                Volunteer_Job__c = jobs[3].Id
            )
        };
        
        insert shifts;

        if (isUsingConstituent != true) {
            return;
        }

        // Create portal records that require a constituent
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        // Volunteer Email formula field uses Contact or Interim Email
        // Contact.Email will be populated if the My Info data creation method runs before this
        Id contactId = tonyStarkMap.get(CONTACT_ID);
        List<ucinn_ascendv2__Interim__c> interimList = new List<ucinn_ascendv2__Interim__c>{null, null, null};
        if (String.isBlank(tonyStarkMap.get(CONTACT_EMAIL))) {
            ucinn_ascendv2__Interim__c starkInterim = new ucinn_ascendv2__Interim__c(
                ucinn_ascendv2__First_Name__c = tonyStarkMap.get(FIRST_NAME),
                ucinn_ascendv2__Last_Name__c = tonyStarkMap.get(LAST_NAME),
                ucinn_ascendv2__Email_1__c = tonyStarkMap.get(EMAIL_CONST),
                ucinn_portal_Source_Url__c = pathPrefix + '/s/volunteers'
            );

            interimList = new List<ucinn_ascendv2__Interim__c>{starkInterim, starkInterim.clone(false, false, false, false), starkInterim.clone(false, false, false, false)};
            insert interimList;
            contactId = null;
        }

        List<ucinn_portal_Volunteer__c> volunteers = new List<ucinn_portal_Volunteer__c>{
            new ucinn_portal_Volunteer__c(
                Application_Status__c = 'Completed',
                Contact__c = contactId,
                Interim__c = interimList[0]?.Id,
                Registering_Constituent__c = tonyStarkMap.get(CONTACT_ID),
                Volunteer_Shift__c = shifts[0].Id
            ),

            new ucinn_portal_Volunteer__c(
                Application_Status__c = 'Completed',
                Comments__c = 'The event was very well organized and I had a blast helping out!',
                Hours_Reported__c = 5,
                Contact__c = contactId,
                Interim__c = interimList[1]?.Id,
                Registering_Constituent__c = tonyStarkMap.get(CONTACT_ID),
                Volunteer_Shift__c = shifts[3].Id
            ),

            new ucinn_portal_Volunteer__c(
                Application_Status__c = 'Completed',
                Comments__c = 'You will certainly see me again next year',
                Hours_Reported__c = 5,
                Contact__c = contactId,
                Interim__c = interimList[2]?.Id,
                Registering_Constituent__c = tonyStarkMap.get(CONTACT_ID),
                Volunteer_Shift__c = shifts[4].Id
            )
        };

        insert volunteers;

        List<ucinn_portal_Skill_Value__c> skillValues = new List<ucinn_portal_Skill_Value__c>{
            new ucinn_portal_Skill_Value__c(
                Is_Display_on_Portal__c = true,
                Name = 'Customer Service'
            ),

            new ucinn_portal_Skill_Value__c(
                Is_Display_on_Portal__c = true,
                Name = 'Creativity'
            )
        };

        insert skillValues;

        ucinn_portal_Constituent_Skill__c constituentSkill = new ucinn_portal_Constituent_Skill__c(
            Contact__c = tonyStarkMap.get(CONTACT_ID),
            Skill_Value__c = skillValues[1].Id
        );

        insert constituentSkill;
    }

    /**
     * Function that creates zones and zone-related records (content pages and modules for banners and related links, listings for events and announcements)
     * Also creates zone memberships with the Anthony Stark demo constituent 
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    @future(callout=true)
    public static void createZoneDataWithConstituent() {
        createZoneData(true);
    }

    /**
     * Function that creates zones and zone-related records (content pages and modules for banners and related links, listings for events and announcements)
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    @future
    public static void createZoneDataWithoutConstituent() {
        createZoneData(false);
    }
    
    /**
     * Function that creates zones and zone-related records (content pages and modules for banners and related links, listings for events and announcements)
     * Potentially creates zone memberships 
     * 
     * @author  Jacob Huang
     * @since   1.0
     * 
     * @param isUsingConstituent    Boolean: use demo constituent for additional zone-related records
     */
    private static void createZoneData(Boolean isUsingConstituent) {
        // this goes first bc there's a "callout"
        if (isUsingConstituent == true) {
            createProfilePicture();
        }

        // both methods creates a zone, a related link content page/module, and potentially a zone membership 
        // only the ski club creates content pages/modules for banners and event/announcement listings
        createSkiClubZone(isUsingConstituent);
        createRockClimbingGroupZone(isUsingConstituent);
    }

    /**
     * Helper method to create the ski club zone and other relevant records
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param isUsingConstituent    Boolean: use demo constituent for additional zone-related records
     */
    private static void createSkiClubZone(Boolean isUsingConstituent) {
        String skiClubName = 'Stark Foundation Skiing Club';
        String clubRecordType = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
        String eventRecordType = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
        String announcementRecordType = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Announcements').getRecordTypeId();
        String baseUrl = getBaseUrl();

        ucinn_portal_Zone__c skiClub = new ucinn_portal_Zone__c(
            Name = skiClubName,
            RecordTypeId = clubRecordType,
            Social_Media_Order__c = 'Twitter;Facebook',
            Facebook_Link__c = 'https://www.facebook.com',
            Twitter_Link__c = 'https://www.twitter.com',
            City__c = 'South Lake Tahoe',
            State__c = 'California',
            Postal_Code__c = '96150',
            Country__c = 'United States',
            Geolocation__latitude__s = 38.9397195,
            Geolocation__longitude__s = -119.9773589,
            Is_Display_on_Portal__c = true,
            Section_Content_Html__c = '<table width="600" cellspacing="0" cellpadding="0" border="0" style=" max-width:600px; '
                                    + ' background-color:{backgroundColor}; border-top: 3px solid black;"> <tr><td Colspan="3" height="15"'
                                    + ' style="padding:0px;">&nbsp;</td></tr> <tr><td Colspan="3" height="15" width="600" style="padding:0px;">'
                                    + ' <h1 style="text-align:center">{sectionTitle}</h1></td></tr> {newsletterSections} <tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr> </table>'
        );

        insert skiClub;

        // Related links
        ucinn_portal_Content_Page__c skiClubRelatedLinks = new ucinn_portal_Content_Page__c(
            Name = 'Zone Leadership Page',
            Sub_Page_Name__c = skiClubName
        );

        // Banners specific to ski club, replaces default banners that may be created in static content data creation
        ucinn_portal_Content_Page__c skiClubHomePage = new ucinn_portal_Content_Page__c(
            Name = 'Zone Homepage',
            Sub_Page_Name__c = skiClubName
         );

        ucinn_portal_Content_Page__c skiClubLeadershipPage = new ucinn_portal_Content_Page__c(
            Name = 'Zone Leadership',
            Sub_Page_Name__c = skiClubName
        );

        ucinn_portal_Content_Page__c skiBioDetailPage = new ucinn_portal_Content_Page__c(
            Name = 'Zone Bio Detail',
            Sub_Page_Name__c = skiClubName
        );

        ucinn_portal_Content_Page__c skiClubAnnouncementsPage = new ucinn_portal_Content_Page__c(
            Name = 'Zone Announcements',
            Sub_Page_Name__c = skiClubName
        );

        ucinn_portal_Content_Page__c skiClubEventsPage = new ucinn_portal_Content_Page__c(
            Name = 'Zone Events',
            Sub_Page_Name__c = skiClubName
        );

        List<ucinn_portal_Content_Page__c> skiClubContentPages = new List<ucinn_portal_Content_Page__c>{skiClubRelatedLinks, skiClubHomePage, skiClubLeadershipPage, skiBioDetailPage, skiClubAnnouncementsPage, skiClubEventsPage};
        insert skiClubContentPages;

        List<ucinn_portal_Content_Module__c> skiClubContentModules = new List<ucinn_portal_Content_Module__c>{
            // Related links
            new ucinn_portal_Content_Module__c(
                Name = 'Related Links',
                Content_Page__c = skiClubRelatedLinks.Id,
                Content_Module_Metadata__c = '{"title": "Related Links for Stark Foundation Skiing Club", "relatedLinks": [{"link": "https://www.twitter.com", "label": "Our Twitter"}, {"link": "https://www.facebook.com", "label": "Our Facebook Page"}, {"link": "zone-search", "label": "See Other Cool Clubs and Groups"}, {"link": "zone-memberships", "label": "Manage Other Memberships"}]}'
            ),

            // Banners
            new ucinn_portal_Content_Module__c(
                Name = 'Zone Banner',
                Content_Page__c = skiClubHomePage.Id,
                Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom:1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">Stark Foundation Skiing Club</span>\\n <h1 class=\\"contentTitle\\">Welcome to Tony Stark\'s Ski Club!</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Here, we embrace a shared passion for skiing by planning ski trips and sharing tips for improving</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}'
            ),

            new ucinn_portal_Content_Module__c(
                Name = 'Zone Banner',
                Content_Page__c = skiClubLeadershipPage.Id,
                Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom:1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">Stark Foundation Skiing Club</span>\\n <h1 class=\\"contentTitle\\">Featured Members</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Meet the Ski Club\'s VIPs</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}'
            ),

            new ucinn_portal_Content_Module__c(
                Name = 'Zone Banner',
                Content_Page__c = skiBioDetailPage.Id,
                Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom:1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">Stark Foundation Skiing Club</span>\\n <h1 class=\\"contentTitle\\">Leadership Profile</h1>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>"}'
            ),

            new ucinn_portal_Content_Module__c(
                Name = 'Zone Banner',
                Content_Page__c = skiClubAnnouncementsPage.Id,
                Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom: 1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">Stark Foundation Skiing Club</span>\\n <h1 class=\\"contentTitle\\">Announcements</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">Stay up to date on the latest Ski Club news</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>\\n"}'
            ),

            new ucinn_portal_Content_Module__c(
                Name = 'Zone Banner',
                Content_Page__c = skiClubEventsPage.Id,
                Content_Module_Metadata__c = '{"htmlText":"<div class=\\"forceCommunityThemeHeroBase forceCommunityThemeHeroStarter giving\\" style=\\"margin-bottom: 1.5em\\">\\n <img src=\\"../resource/Portal_ZoneBanner\\">\\n <div class=\\"contentContainer\\">\\n <div class=\\"container medium\\" style=\\"margin-bottom: 0\\">\\n <div class=\\"slds-grid slds-wrap full-width align-center\\">\\n <div class=\\"slds-size_12-of-12 slds-small-size_12-of-12 slds-medium-size_12-of-12 slds-large-size_12-of-12\\">\\n <span class=\\"eyebrow white\\" style=\\"color: #8bc2d1 !important\\">Stark Foundation Skiing Club</span>\\n <h1 class=\\"contentTitle\\">See Our Events</h1>\\n <p class=\\"lead\\" style=\\"margin-bottom: 0 !important\\">See when you\'ll need to plan your next vacation</p>\\n </div>\\n </div>\\n </div>\\n </div>\\n </div>\\n"}'
            )
        };

        insert skiClubContentModules;

        // Listings for events and announcements
        Date nextMonth = Date.today().addMonths(1);
        String yearInOneMonth = String.valueOf(nextMonth.year());
        String monthInOneMonth = String.valueOf(nextMonth.month()).leftPad(2, '0');
        String dayInOneMonth = String.valueOf(nextMonth.day()).leftPad(2, '0');
 
        Date twoDaysFromNow = Date.today().addDays(2);
        String yearInTwoDays= String.valueOf(twoDaysFromNow.year());
        String monthInTwoDays = String.valueOf(twoDaysFromNow.month()).leftPad(2, '0');
        String dayInTwoDays = String.valueOf(twoDaysFromNow.day()).leftPad(2, '0');

        Date oneWeekAgo = Date.today().addDays(-7);
        String yearOneWeekAgo = String.valueOf(oneWeekAgo.year());
        String monthOneWeekAgo = String.valueOf(oneWeekAgo.month()).leftPad(2, '0');
        String dayOneWeekAgo = String.valueOf(oneWeekAgo.day()).leftPad(2, '0');

        List<ucinn_portal_Listing__c> skiClubListings = new List<ucinn_portal_Listing__c>{
            new ucinn_portal_Listing__c(
                RecordTypeId = eventRecordType,
                Name = 'Beginner Training Day',
                Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder.png">',
                Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder-3.png">',
                Header_Content__c = '<p>This event is designed to teach less experienced skiiers tips and tricks to become more comfortable at skiing.</p>',
                Actual_Start_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 00:00:00',
                Actual_End_Date_Time__c = yearInOneMonth + '-' + monthInOneMonth + '-' + dayInOneMonth + ' 23:59:59',
                Event_Actual_Start_Date_Time__c = yearInOneMonth + '-' + monthInOneMonth + '-' + dayInOneMonth + ' 08:00:00',
                Event_Actual_End_Date_Time__c = yearInOneMonth + '-' + monthInOneMonth + '-' + dayInOneMonth + ' 16:00:00',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Status__c = 'Published',
                Geolocation__latitude__s = 34.2364127,
                Geolocation__longitude__s = -116.8941771
            ),
            
            new ucinn_portal_Listing__c(
                RecordTypeId = eventRecordType,
                Name = 'Ski Race Down Big Bear',
                Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder.png">',
                Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder-3.png">',
                Header_Content__c = '<p>Join us in our monthly race.</p>',
                Actual_Start_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 00:00:00',
                Actual_End_Date_Time__c = yearInTwoDays + '-' + monthInTwoDays + '-' + dayInTwoDays + ' 23:59:59',
                Event_Actual_Start_Date_Time__c = yearInTwoDays + '-' + monthInTwoDays + '-' + dayInTwoDays + ' 08:00:00',
                Event_Actual_End_Date_Time__c = yearInTwoDays + '-' + monthInTwoDays + '-' + dayInTwoDays + ' 11:00:00',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Status__c = 'Published',
                Geolocation__latitude__s = 34.2364127,
                Geolocation__longitude__s = -116.8941771
            ),

            new ucinn_portal_Listing__c(
                RecordTypeId = announcementRecordType,            
                Name = 'Ski lifts will be under maintenance in one month',
                Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder-3.png">',
                Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder.png">',
                Header_Content__c = '<p>The ski lifts are being repaired and upgraded on ' + monthInOneMonth + '/' + dayInOneMonth + '/' + yearInOneMonth + '.</p>',
                Actual_Start_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 00:00:00',
                Actual_End_Date_Time__c = yearInOneMonth + '-' + monthInOneMonth + '-' + dayInOneMonth + ' 23:59:59',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Status__c = 'Published'
            ),

            new ucinn_portal_Listing__c(
                RecordTypeId = announcementRecordType,            
                Name = 'We will be giving away a single annual pass next month!',
                Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder.png">',
                Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/club-placeholder-3.png">',
                Header_Content__c = '<p>Since there will be no skiing in one month, we are hosting a giveaway instead. More information will be announced in the future!</p>',
                Actual_Start_Date_Time__c = yearOneWeekAgo + '-' + monthOneWeekAgo + '-' + dayOneWeekAgo + ' 00:00:00',
                Actual_End_Date_Time__c = yearInOneMonth + '-' + monthInOneMonth + '-' + dayInOneMonth + ' 23:59:59',
                Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                Status__c = 'Published'
            )
        };
        insert skiClubListings;

        if (isUsingConstituent != true) {
            return;
        }

        // Create portal records that require a constituent
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        List<ucinn_portal_Zone_Membership__c> zoneMembershipList = new List<ucinn_portal_Zone_Membership__c>();
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            ucinn_portal_Zone_Membership__c zoneMembership = new ucinn_portal_Zone_Membership__c(
                Zone__c = skiClub.Id,
                Constituent__c = eachContactMap.get(CONTACT_ID),
                Status__c = 'Active'
            );

            if (eachContactMap.get(CONTACT_ID) == tonyStarkMap.get(CONTACT_ID)) { 
                zoneMembership.Zone_Permission_Set__c = 'Submit Newsletter';
                zoneMembership.Is_Board_Member__c = true;
                zoneMembership.Is_Featured_Board_Member__c = true;
                zoneMembership.Is_Primary_Contact__c = true;
                zoneMembership.Board_Member_Title__c = 'President';
                zoneMembership.Bio_Description__c = 'One of Tony\'s lifelong passions is skiing, and he is thrilled to help others enjoy skiing through this club.';
            }
            
            zoneMembershipList.add(zoneMembership);
        }

        insert zoneMembershipList;
    }

    /**
     * Helper method to create the rock climbing group zone and other relevant records
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param isUsingConstituent    Boolean: use demo constituent for additional zone-related records
     */
    private static void createRockClimbingGroupZone(Boolean isUsingConstituent) {
        String rockClimbingGroupName = 'Stark\'s Rock Climbing Group';
        String groupRecordType = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();
        String baseUrl = getBaseUrl();

        ucinn_portal_Zone__c rockClimbingGroup = new ucinn_portal_Zone__c(
            Name = rockClimbingGroupName,
            RecordTypeId = groupRecordType,
            Social_Media_Order__c = 'Instagram',
            Instagram_Link__c = 'https://www.instagram.com',
            City__c = 'Irvine',
            State__c = 'California',
            Postal_Code__c = '92617',
            Country__c = 'United States',
            Geolocation__latitude__s = 33.7195976,
            Geolocation__longitude__s = -117.7981296,
            Is_Display_on_Portal__c = true,
            Section_Content_Html__c = '<table width="600" cellspacing="0" cellpadding="0" border="0" style=" max-width:600px; '
                                    + ' background-color:{backgroundColor}; border-top: 3px solid black;"> <tr><td Colspan="3" height="15"'
                                    + ' style="padding:0px;">&nbsp;</td></tr> <tr><td Colspan="3" height="15" width="600" style="padding:0px;">'
                                    + ' <h1 style="text-align:center">{sectionTitle}</h1></td></tr> {newsletterSections} <tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr> </table>'
        );

        insert rockClimbingGroup;

        // Related links
        ucinn_portal_Content_Page__c rockClimbingGroupRelatedLinks = new ucinn_portal_Content_Page__c(
            Name = 'Zone Leadership Page',
            Sub_Page_Name__c = rockClimbingGroupName
        );
        insert rockClimbingGroupRelatedLinks; 

        insert new ucinn_portal_Content_Module__c(
            Name = 'Related Links',
            Content_Page__c = rockClimbingGroupRelatedLinks.Id,
            Content_Module_Metadata__c = '{"title": "Related Links for Stark\'s Rock Climbing Group", "relatedLinks": [{"link": "https://www.instagram.com", "label": "Follow on Instagram"}, {"link": "zone-home-page?zname=Stark%20Foundation%20Skiing%20Club", "label": "Check out Tony\'s skiing club"}]}'
        );

        if (isUsingConstituent != true) {
            return;
        }

        // Create portal records that require a constituent
        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        ucinn_portal_Zone_Membership__c starkRockClimbing = new ucinn_portal_Zone_Membership__c(
            Zone__c = rockClimbingGroup.Id,
            Constituent__c = tonyStarkMap.get(CONTACT_ID),
            Status__c = 'Active',
            Zone_Permission_Set__c = 'Submit Newsletter',
            Is_Board_Member__c = true,
            Is_Featured_Board_Member__c = true,
            Is_Primary_Contact__c = true,
            Board_Member_Title__c = 'Founder',
            Bio_Description__c = 'Tony has recently taken up rock climbing as a hobby and he hopes others will join him in his latest endeavor.'
        );

        insert starkRockClimbing;
    }

    /**
     * Give Tony Stark a profile picture
     * 
     * @author Jacob Huang
     * @since 1.0
     */
    private static void createProfilePicture() {
        Blob profilePicture = null;
        if (Test.isRunningTest()) {
            profilePicture = Blob.valueOf('Test'); 
        }
        else {
            // Salesforce treats getContent() as a callout so this needs to be done first thing
            profilePicture = PageReference.forResource('Portal_DataCreationPictures2', 'member-tony-stark.png').getContent();
        }

        if (String.isBlank(tonyStarkMap.get(CONTACT_ID))) {
            checkAndAssignForExistingConstituents();
        }

        ContentVersion content = new ContentVersion(
            Title = 'Tony Stark Profile Picture',
            PathOnClient = 'member-tony-stark.png',
            VersionData = profilePicture
        );

        insert content;

        Contact tonyStarkContact = new Contact(Id = tonyStarkMap.get(CONTACT_ID), ucinn_ascendv2__Picture_Record_ID__c = content.Id);
        update tonyStarkContact;

        List<ContentVersion> contentWithContentDocumentId = [SELECT ContentDocumentId
                                                            FROM ContentVersion
                                                            WHERE Id = :content.Id];

        if (contentWithContentDocumentId?.isEmpty() == false) {
            insert new ContentDocumentLink(
                ContentDocumentId = contentWithContentDocumentId[0].ContentDocumentId,
                LinkedEntityId = tonyStarkContact.Id
            );
        }
    }

    /**
     * Function that creates newsletter html template sections
     *
     * @author  Phillip Nguyen
     * @since   1.0
     */
    private static void createNewsletterHtmlTemplateSections(String newsletterHtmlTemplateId) {
        if (String.isBlank(newsletterHtmlTemplateId)) {
            return;
        }

        String newsletterSectionRecordType = Schema.SObjectType.ucinn_portal_Newsletter_Section__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_SECTION_TEMPLATE_RECORD_TYPE).getRecordTypeId();
        List<ucinn_portal_Newsletter_Section__c> newsletterSectionsToInsert = new List<ucinn_portal_Newsletter_Section__c>();
        
        String baseUrl = getBaseUrl();

        ucinn_portal_Newsletter_Section__c module1 = new ucinn_portal_Newsletter_Section__c(Name = 'Module 1', 
                                                                                            RecordTypeId = newsletterSectionRecordType,
                                                                                            Newsletter_Listing__c = newsletterHtmlTemplateId, 
                                                                                            Selected_Module__c = 'Module 1',
                                                                                            Newsletter_HTML__c = '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr> <td width="90" style="padding: 0px;"></td><td width="420" style="padding: 0px;"><img width="420" height="210" '
                                                                                                + 'style="width:420px; height: 210px; margin: 0px 0px 0px; padding-bottom: 5px;" src="{imageURL}" '
                                                                                                + 'alt="{imageAltText}"></img></td><td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" '
                                                                                                + 'style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td><td width="420" '
                                                                                                + 'style="padding: 0px;"><h3 style="color: rgb(128, 0 ,0); margin-top: 0px; margin-bottom: 0px;">{headerContent}</h3></td><td width="90" '
                                                                                                + 'style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" '
                                                                                                + 'style="padding:0px;"></td><td width="420" style="padding:0px;">{bodyContent}</td><td width="90" style="padding:0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>',
                                                                                            Image__c = '<img src="' + baseUrl + '/resource/Portal_NewsletterTemplate650x440Image">'
                                                                                            );

        newsletterSectionsToInsert.add(module1);

        ucinn_portal_Newsletter_Section__c module2 = new ucinn_portal_Newsletter_Section__c(Name = 'Module 2', 
                                                                                            RecordTypeId = newsletterSectionRecordType,
                                                                                            Newsletter_Listing__c = newsletterHtmlTemplateId, 
                                                                                            Selected_Module__c = 'Module 2',
                                                                                            Newsletter_HTML__c = '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr> '
                                                                                                + '<td width="90" style="padding: 0px;"></td><td width="420" style="padding: 0px;"><img width="420" height="210" style="width:auto; height: auto; margin: 0px 0px 0px; padding-bottom: 5px;" src="{imageURL}" alt="{imageAltText}"></img></td>'
                                                                                                + '<td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td>'
                                                                                                + '<td width="420" style="padding: 0px;"><table cellpadding="0" cellspacing="0" border="0" width="420" style="border: 2px solid rgb(128,0,0); width:100%;"><tr>'
                                                                                                + '<td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr width="420" style="width:420px;">'
                                                                                                + '<td width="30" style="padding:0px;"></td><td valign="top" style="padding:0px; vertical-align:top"><h3 style="margin-top: 0px; margin-bottom: 0px; color: rgb(128,0,0); text-align: center;">{headerContent}</h3></td>'
                                                                                                + '<td width="30"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr></table></td><td width="90" style="padding: 0px;"></td></tr>'
                                                                                                + '<tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td><td width="420" style="padding: 0px;"><div style="color:#155F83;">{dateTimeLocation}</div></td>'
                                                                                                + '<td width="90" style="padding: 0px;"></td></tr><tr><td width="90" style="padding:0px;"></td><td width="420" style="padding:0px;">{bodyContent}</td><td width="90" style="padding:0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>',
                                                                                            Image__c = '<img src="' + baseUrl + '/resource/Portal_NewsletterTemplate420x210Image">'
                                                                                            );

        newsletterSectionsToInsert.add(module2);

        ucinn_portal_Newsletter_Section__c module3 = new ucinn_portal_Newsletter_Section__c(Name = 'Module 3', 
                                                                                            RecordTypeId = newsletterSectionRecordType,
                                                                                            Newsletter_Listing__c = newsletterHtmlTemplateId, 
                                                                                            Selected_Module__c = 'Module 3',
                                                                                            Newsletter_HTML__c = '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td><td width="420" style="padding: 0px;">'
                                                                                                + '<table cellspacing="0" cellpadding="0" width="420"><tr><td width="290" style="width:290px; padding: 0px;"><div width="290" style="padding-bottom: 0px; padding-top: 0px; min-height: 130px; width:100%;">'
                                                                                                + '<h3 style="color: rgb(128, 0 ,0); margin-top: 0px; margin-bottom: 0px;">{headerContent}</h3><br></br>{bodyContent}</div></td>'
                                                                                                + '<td width="130" valign="top" style="padding: 0px; vertical-align: top;"><img width="120" height="120" style="height:auto;width:auto;padding-left:10px;max-width:120px;" src="{imageURL}" alt="{imageAltText}"></img></td></tr></table></td>'
                                                                                                + '<td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>',
                                                                                            Image__c = '<img src="' + baseUrl + '/resource/Portal_NewsletterTemplate120x120Image">'
                                                                                            );

        newsletterSectionsToInsert.add(module3);

        ucinn_portal_Newsletter_Section__c module4 = new ucinn_portal_Newsletter_Section__c(Name = 'Module 4', 
                                                                                            RecordTypeId = newsletterSectionRecordType,
                                                                                            Newsletter_Listing__c = newsletterHtmlTemplateId, 
                                                                                            Selected_Module__c = 'Module 4',
                                                                                            Newsletter_HTML__c = '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td>'
                                                                                                + '<td width="420" style="padding: 0px;"><table cellpadding="0" cellspacing="0" border="0" width="420" style="border: 2px solid rgb(128,0,0); width:100%;"><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td>'
                                                                                                + '</tr><tr width="420" style="width:420px;">'
                                                                                                + '<td width="30" style="padding:0px;"></td><td valign="top" style="padding:0px; vertical-align:top"><h3 style="margin-top: 0px; margin-bottom: 0px; color: rgb(128,0,0); text-align: center;">{headerContent}</h3></td>'
                                                                                                + '<td width="30"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr></table></td><td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr>'
                                                                                                + '<td width="90" style="padding: 0px;"></td><td width="420" style="padding: 0px;"><div style="color:#155F83;">{dateTimeLocation}</div>'
                                                                                                + '</td><td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td>'
                                                                                                + '<td width="420" style="padding: 0px;">{bodyContent}</td><td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>'
                                                                                            );

        newsletterSectionsToInsert.add(module4);

        ucinn_portal_Newsletter_Section__c module5 = new ucinn_portal_Newsletter_Section__c(Name = 'Module 5', 
                                                                                            RecordTypeId = newsletterSectionRecordType,
                                                                                            Newsletter_Listing__c = newsletterHtmlTemplateId, 
                                                                                            Selected_Module__c = 'Module 5',
                                                                                            Newsletter_HTML__c = '<tr><td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td>'
                                                                                                + '<td width="420" style="padding: 0px;"><table cellpadding="0" cellspacing="0" border="0" width="420" style="border: 2px solid rgb(128,0,0); width:100%;"><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td>'
                                                                                                + '</tr><tr width="420" style="width:420px;"><td width="30" style="padding:0px;"></td>'
                                                                                                + '<td valign="top" style="padding:0px; vertical-align:top"><h3 style="margin-top: 0px; margin-bottom: 0px; color: rgb(128,0,0); text-align: center;">{headerContent}</h3></td><td width="30"></td></tr><tr>'
                                                                                                + '<td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr></table></td><td width="90" style="padding: 0px;"></td></tr><tr>'
                                                                                                + '<td Colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr><tr><td width="90" style="padding: 0px;"></td>'
                                                                                                + '<td width="420" style="padding: 0px;">{bodyContent}</td><td width="90" style="padding: 0px;"></td></tr><tr><td colspan="3" height="15" style="padding:0px;">&nbsp;</td></tr>'
                                                                                            );

        newsletterSectionsToInsert.add(module5);

        insert newsletterSectionsToInsert;
    }

    /**
     * Creates job board data.
     * 
     * @author Isaiah Rodriguez
     * @since 1.0
     */
    @future
    public static void createJobsBoardData() {
        List<ucinn_portal_Job__c> jobs = new List<ucinn_portal_Job__c>{
            new ucinn_portal_Job__c(
                Name = 'Salesforce Developer',
                Recruiting_Company__c = 'Stark Industries',
                Address_Line_1__c = '2855 Michelle Drive',
                City__c = 'Irvine',
                State__c = 'California',
                Postal_Code__c = '92606',
                Country__c = 'United States',
                Geolocation__latitude__s = 33.7195976,
                Geolocation__longitude__s = -117.7981296,
                Position_Type__c = 'Full Time Experienced',
                Class_Or_Degree_Level__c = 'Bachelors',
                Description__c = '<ul><li>Primarily responsible for the successful delivery of an implementation project or manage a team.</li>'
                                + '<li>Provide overall coordination between the client and consultant resources or team.</li>'
                                + '<li>Responsible for the continuous communication with the client and/or team.</li>'
                                + '<li>For PM role: Escalation of project risks to appropriate Delivery leader such as:'
                                    + '<ul><li>Impact to deadlines</li><li>Impact to scope</li><li>Impact to hours</li><li>Client satisfaction</li>'
                                    + '<li>Management of Hours of project</li><li>Deliver on budget</li><li>Ensure delivery against the Methodology</li>'
                                    + '<li>Ensure proper knowledge transfer from team to client</li><li>Send on Status reports</li><li>Submit Change Control documents as required</li>'
                                    + '<li>Ensure the project is delivered on time, on budget and with the highest quality</li></ul></li>'
                                + '<li>Assist in presales activities as schedule permits.</li></ul>',
                Desired_Skills__c = '<ul><li>Proficiency in the following:<ul><li>Apex</li><li>Javascript</li><li>HTML/CSS</li></ul></li></ul>',
                Qualifications__c = '<ul><li>Bachelor’s degree.</li><li>5+ years managing projects or teams (Project Manager).</li>'
                                    + '<li>Manages at least 2 direct reports and completes annual performance reviews.</li>'
                                    + '<li>Experience in managing both functional and technical resources.</li>'
                                    + '<li>Strong organizational, analytical and problem solving skills.</li>'
                                    + '<li>Familiarity with implementing Salesforce projects.</li>'
                                    + '<li>Must be open to travel to client sites as required.</li>'
                                    + '<li>Strong documentation skills including experience with responding to RFPs.</li>'
                                    + '<li>PMP, Salesforce certification or Advancement Experience a plus</li></ul>',
                Can_Work_Remote__c = true,
                Work_Hours_Per_Week__c = 40,
                Approximate_Salary__c = 70000,
                Has_Contact_Information__c = true,
                Job_Poster_Name__c = 'Bob Johnson',
                Job_Poster_Company__c = 'Stark Industries',
                Job_Poster_Job_Title__c = 'Director of Sales',
                Job_Poster_Phone__c = '(123) 456-7890',
                Job_Poster_Email__c = 'bjohnson@stark.com',
                Job_Poster_School_Degree__c = 'MS,\'88',
                Status__c = 'Posted'
            ),

            new ucinn_portal_Job__c(
                Name = 'Project Manager',
                Recruiting_Company__c = 'Stark Industries',
                Address_Line_1__c = '2855 Michelle Drive',
                City__c = 'Irvine',
                State__c = 'California',
                Postal_Code__c = '92606',
                Country__c = 'United States',
                Geolocation__latitude__s = 33.7195976,
                Geolocation__longitude__s = -117.7981296,
                Position_Type__c = 'Full Time Experienced',
                Class_Or_Degree_Level__c = 'Masters',
                Description__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                    + 'Vel facilisis volutpat est velit egestas. Erat pellentesque adipiscing commodo elit at imperdiet dui. Sagittis purus sit amet volutpat. '
                                    + 'Sit amet consectetur adipiscing elit. Ultrices vitae auctor eu augue ut lectus arcu bibendum at. Consectetur a erat nam at.</p>',
                Desired_Skills__c = '<ul><li>Vitae justo eget magna fermentum iaculis</li>'
                                    + '<li>Ligula ullamcorper malesuada proin libero</li>'
                                    + '<li>Pharetra massa massa ultricies mi quis hendrerit dolor magna</li></ul>',
                Qualifications__c = '<ul><li>Cursus vitae congue mauris rhoncus. Velit dignissim sodales ut eu sem integer vitae</li>'
                                    + '<li>Ipsum consequat nisl vel pretium lectus. Eget arcu dictum varius duis at consectetur</li>'
                                    + '<li>Quisque non tellus orci ac auctor augue mauris augue</li>'
                                    + '<li>Viverra maecenas accumsan lacus vel facilisis volutpat est velit</li>'
                                    + '<li>Sit amet risus nullam eget</li></ul>',
                Work_Hours_Per_Week__c = 40,
                Has_Contact_Information__c = true,
                Job_Poster_Name__c = 'Bob Johnson',
                Job_Poster_Company__c = 'Stark Industries',
                Job_Poster_Job_Title__c = 'Director of Sales',
                Job_Poster_Phone__c = '(123) 456-7890',
                Job_Poster_Email__c = 'bjohnson@stark.com',
                Job_Poster_School_Degree__c = 'MS,\'88',
                Status__c = 'Posted'),

            new ucinn_portal_Job__c(
                Name = 'Data Architect',
                Recruiting_Company__c = 'Stark Industries',
                Address_Line_1__c = '2855 Michelle Drive',
                City__c = 'Irvine',
                State__c = 'California',
                Postal_Code__c = '92606',
                Country__c = 'United States',
                Geolocation__latitude__s = 33.7195976,
                Geolocation__longitude__s = -117.7981296,
                Position_Type__c = 'Full Time Experienced',
                Class_Or_Degree_Level__c = 'Bachelors',
                Description__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                    + 'Vel facilisis volutpat est velit egestas. Erat pellentesque adipiscing commodo elit at imperdiet dui. Sagittis purus sit amet volutpat. '
                                    + 'Sit amet consectetur adipiscing elit. Ultrices vitae auctor eu augue ut lectus arcu bibendum at. Consectetur a erat nam at. '
                                    + 'Consectetur a erat nam at lectus urna duis. Leo duis ut diam quam nulla porttitor massa. Odio ut enim blandit volutpat maecenas volutpat blandit aliquam. '
                                    + 'Hac habitasse platea dictumst vestibulum. Urna id volutpat lacus laoreet non curabitur. Ac auctor augue mauris augue neque gravida in fermentum et. '
                                    + 'Diam vel quam elementum pulvinar. Est placerat in egestas erat imperdiet sed. Pretium quam vulputate dignissim suspendisse in est ante. '
                                    + 'Sed felis eget velit aliquet sagittis. Tristique et egestas quis ipsum suspendisse ultrices. Sagittis vitae et leo duis ut diam quam nulla porttitor. '
                                    + 'Turpis massa tincidunt dui ut ornare.</p>',
                Desired_Skills__c = '<ul><li>Vitae justo eget magna fermentum iaculis</li>'
                                    + '<li>Ligula ullamcorper malesuada proin libero</li>'
                                    + '<li>Pharetra massa massa ultricies mi quis hendrerit dolor magna</li></ul>',
                Qualifications__c = '<ul><li>Cursus vitae congue mauris rhoncus. Velit dignissim sodales ut eu sem integer vitae</li>'
                                    + '<li>Ipsum consequat nisl vel pretium lectus. Eget arcu dictum varius duis at consectetur</li>'
                                    + '<li>Quisque non tellus orci ac auctor augue mauris augue</li>'
                                    + '<li>Viverra maecenas accumsan lacus vel facilisis volutpat est velit</li>'
                                    + '<li>Sit amet risus nullam eget</li></ul>',
                Can_Work_Remote__c = true,
                Work_Hours_Per_Week__c = 40,
                Approximate_Salary__c = 105000,
                Has_Contact_Information__c = true,
                Job_Poster_Name__c = 'Bob Johnson',
                Job_Poster_Company__c = 'Stark Industries',
                Job_Poster_Job_Title__c = 'Director of Sales',
                Job_Poster_Phone__c = '(123) 456-7890',
                Job_Poster_Email__c = 'bjohnson@stark.com',
                Job_Poster_School_Degree__c = 'MS,\'88',
                Status__c = 'Posted'),

            new ucinn_portal_Job__c(
                Name = 'Senior Business Analyst',
                Recruiting_Company__c = 'Stark Industries',
                Address_Line_1__c = '2855 Michelle Drive',
                City__c = 'Irvine',
                State__c = 'California',
                Postal_Code__c = '92606',
                Country__c = 'United States',
                Geolocation__latitude__s = 33.7195976,
                Geolocation__longitude__s = -117.7981296,
                Position_Type__c = 'Full Time Experienced',
                Class_Or_Degree_Level__c = 'Bachelors',
                Description__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                    + 'Vel facilisis volutpat est velit egestas. Erat pellentesque adipiscing commodo elit at imperdiet dui. Sagittis purus sit amet volutpat. '
                                    + 'Sit amet consectetur adipiscing elit. Ultrices vitae auctor eu augue ut lectus arcu bibendum at. Consectetur a erat nam at.</p>',
                Desired_Skills__c = '<ul><li>Vitae justo eget magna fermentum iaculis</li>'
                                    + '<li>Ligula ullamcorper malesuada proin libero</li>'
                                    + '<li>Pharetra massa massa ultricies mi quis hendrerit dolor magna</li></ul>',
                Qualifications__c = '<ul><li>Cursus vitae congue mauris rhoncus. Velit dignissim sodales ut eu sem integer vitae</li>'
                                    + '<li>Ipsum consequat nisl vel pretium lectus. Eget arcu dictum varius duis at consectetur</li>'
                                    + '<li>Quisque non tellus orci ac auctor augue mauris augue</li>'
                                    + '<li>Viverra maecenas accumsan lacus vel facilisis volutpat est velit</li>'
                                    + '<li>Sit amet risus nullam eget</li></ul>',
                Can_Work_Remote__c = true,
                Work_Hours_Per_Week__c = 40,
                Has_Contact_Information__c = true,
                Job_Poster_Name__c = 'Bob Johnson',
                Job_Poster_Company__c = 'Stark Industries',
                Job_Poster_Job_Title__c = 'Director of Sales',
                Job_Poster_Phone__c = '(123) 456-7890',
                Job_Poster_Email__c = 'bjohnson@stark.com',
                Job_Poster_School_Degree__c = 'MS,\'88',
                Status__c = 'Posted'),

            new ucinn_portal_Job__c(
                Name = 'Administrative Assistant',
                Recruiting_Company__c = 'Stark Industries',
                Address_Line_1__c = '2855 Michelle Drive',
                City__c = 'Irvine',
                State__c = 'California',
                Postal_Code__c = '92606',
                Country__c = 'United States',
                Geolocation__latitude__s = 33.7195976,
                Geolocation__longitude__s = -117.7981296,
                Position_Type__c = 'Full Time Entry Level',
                Description__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                    + 'Vel facilisis volutpat est velit egestas. Erat pellentesque adipiscing commodo elit at imperdiet dui. Sagittis purus sit amet volutpat. '
                                    + 'Sit amet consectetur adipiscing elit. Ultrices vitae auctor eu augue ut lectus arcu bibendum at. Consectetur a erat nam at.</p>',
                Desired_Skills__c = '<ul><li>Vitae justo eget magna fermentum iaculis</li>'
                                    + '<li>Ligula ullamcorper malesuada proin libero</li>'
                                    + '<li>Pharetra massa massa ultricies mi quis hendrerit dolor magna</li></ul>',
                Qualifications__c = '<ul><li>Cursus vitae congue mauris rhoncus. Velit dignissim sodales ut eu sem integer vitae</li>'
                                    + '<li>Ipsum consequat nisl vel pretium lectus. Eget arcu dictum varius duis at consectetur</li>'
                                    + '<li>Quisque non tellus orci ac auctor augue mauris augue</li>'
                                    + '<li>Viverra maecenas accumsan lacus vel facilisis volutpat est velit</li>'
                                    + '<li>Sit amet risus nullam eget</li></ul>',
                Can_Work_Remote__c = true,
                Work_Hours_Per_Week__c = 40,
                Approximate_Salary__c = 60000,
                Has_Contact_Information__c = true,
                Job_Poster_Name__c = 'Bob Johnson',
                Job_Poster_Company__c = 'Stark Industries',
                Job_Poster_Job_Title__c = 'Director of Sales',
                Job_Poster_Phone__c = '(123) 456-7890',
                Job_Poster_Email__c = 'bjohnson@stark.com',
                Job_Poster_School_Degree__c = 'MS,\'88',
                Status__c = 'Posted')
        };

        insert jobs;
    }

    /**
     * Function that creates Downloadable Content
     *
     * @author  Jacob Huang
     * @since   1.19
     */
    @future(callout=true)
    public static void createDownloadableContentData() {
        // this method does a "callout" right away, so all DML goes after
        String contentDocumentId = insertDownloadableContentFiles();

        ucinn_portal_Downloadable_Content__c dlc = new ucinn_portal_Downloadable_Content__c(
            Name = 'Endowment Reports',
            Component_Name__c = 'Endowment Reports'
        );

        insert dlc;

        insert new ContentDocumentLink(
            ContentDocumentId = contentDocumentId,
            LinkedEntityId = dlc.Id
        );
    }

    /**
     * Insert the file that will be linked to the downloadable content record
     * 
     * @author Jacob Huang
     * @since 1.19
     * 
     * @return ContentDocumentId of the ContentVersion to use for ContentDocumentLink
     */
    private static String insertDownloadableContentFiles() {
        Blob fileData = null;
        if (Test.isRunningTest()) {
            fileData = Blob.valueOf('Test');
        } else {
            // Salesforce treats getContent() as a callout so this needs to be done first thing
            fileData = PageReference.forResource('Portal_DataCreationPictures2', 'Annual_Report_Cover_Template.jpg').getContent();
        }

        ContentVersion content = new ContentVersion(
            Title = 'Endowment Report',
            PathOnClient = 'Endowment_Report.jpg',
            VersionData = fileData
        );

        insert content;

        List<ContentVersion> contentWithContentDocumentId = [SELECT ContentDocumentId
                                                            FROM ContentVersion
                                                            WHERE Id = :content.Id];

        return contentWithContentDocumentId[0].ContentDocumentId;
    }

    /**
     * Function that assigns 7 Contact Ids to static variables
     * If not all expected constituents (based on Contact FirstName and LastName) exist, then all will be created
     * 
     * @author  Phillip Nguyen, Jacob Huang
     * @since   1.2
     */
    private static void checkAndAssignForExistingConstituents() {
        List<Contact> contactList = getExistingDataCreationConstituents();

        if (contactList == null || contactList.size() != heroContactMaps.size()) {
            contactList = insertDataCreationConstituents();
        } 
        
        // save Contact Ids, other useful info in static map
        for (Contact eachContact : contactList) {
            if (isContactFromDataCreation(eachContact)) {
                Map<String, String> eachHeroContactMap = heroContactMaps.get(eachContact.LastName);
                
                eachHeroContactMap.put(CONTACT_ID, eachContact.Id);
                // Volunteer data creation needs to know if Contact.Email is populated (as a result of My Info data creation)
                eachHeroContactMap.put(CONTACT_EMAIL, eachContact.Email);
            }
        }

        // redundant check to absolutely guarantee the Constituents were actually found
        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            if (String.isBlank(eachContactMap.get(CONTACT_ID))) {
                throw new DataCreationException('PORTAL_UTIL_DataCreation failed to create or access all expected constituents.');
            }
        }
    }

    /**
     * Query for the list of constituents that data creation might have previously created
     * Locks records that are queried, will wait as long as possible for the lock to become available
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @return list of existing Contacts with populated LastName and Id fields
     */
    private static List<Contact> getExistingDataCreationConstituents() {
        while (true) {
            try {
                // If the record is already locked, attempting to lock it again here should cause the process to wait up to 10 seconds before throwing a QueryException
                List<Contact> contactList = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE LastName IN :heroContactMaps.keySet() FOR UPDATE];

                List<Contact> heroContactList = new List<Contact>();
                // Need to ensure FirstName and LastName match data creation names
                for (Contact eachContact : contactList) {
                    if (isContactFromDataCreation(eachContact)) {
                        heroContactList.add(eachContact);
                    }
                }

                return heroContactList;
            } catch (QueryException e) {
                continue; 
            }
        }

        // SF compiler is bad so this unreachable line of code is required
        return new List<Contact>();
    }

    /**
     * Helper method to figure out if a particular Contact's FirstName and LastName match a contact that's created in this data creation file
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @param cont      Contact: constituent with FirstName and LastName
     * 
     * @return          Boolean: true if the Contact's FirstName and LastName match a data creation contact 
     */
    private static Boolean isContactFromDataCreation(Contact cont) {
        Map<String, String> candidateContactMap = heroContactMaps.get(cont?.LastName); 
        return String.isNotBlank(cont?.LastName) && cont?.FirstName == candidateContactMap?.get(FIRST_NAME) && cont?.LastName == candidateContactMap?.get(LAST_NAME);
    }

    /**
     * Insert data creation constituent records, assume they have not been created yet
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @return list of newly inserted Contacts with populated FirstName, LastName, Id, and some other fields
     */
    private static List<Contact> insertDataCreationConstituents() {
        List<Contact> newContactList = new List<Contact>();
        Contact starkContact = null;
        Contact pottsContact = null;

        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            Contact newContact = new Contact(
                FirstName = eachContactMap.get(FIRST_NAME),
                MiddleName = eachContactMap.get(MIDDLE_NAME),
                LastName = eachContactMap.get(LAST_NAME),
                ucinn_ascendv2__Gender__c = eachContactMap.get(GENDER_CONST),
                ucinn_ascendv2__Preferred_Pronouns__c = eachContactMap.get(PRONOUNS_CONST),
                ucinn_ascendv2__Marital_Status__c = 'Single',
                ucinn_portal_Is_Display_On_Portal__c = true,
                ucinn_portal_Is_Directory_Opt_Out__c = false
            );

            String birthYear = eachContactMap.get(BIRTH_YEAR);
            String birthMonth = eachContactMap.get(BIRTH_MONTH);
            String birthDay = eachContactMap.get(BIRTH_DAY);
            if (String.isNotBlank(birthYear) && String.isNotBlank(birthMonth) && String.isNotBlank(birthDay)) {
                newContact.Birthdate = Date.newInstance(Integer.valueOf(birthYear), Integer.valueOf(birthMonth), Integer.valueOf(birthDay));
            }

            newContactList.add(newContact);

            if (eachContactMap.get(LAST_NAME) == tonyStarkMap.get(LAST_NAME)) {
                starkContact = newContact;
            } else if (eachContactMap.get(LAST_NAME) == pepperPottsMap.get(LAST_NAME)) {
                pottsContact = newContact;
            }
        }

        insert newContactList;

        starkContact.ucinn_ascendv2__Preferred_Spouse__c = pottsContact.Id;
        pottsContact.ucinn_ascendv2__Preferred_Spouse__c = starkContact.Id;

        update new List<Contact>{starkContact, pottsContact};

        return newContactList;
    }

    public static String getBaseUrl() {
        String resultString = '';
        List<Site> siteList = [SELECT Id FROM Site WHERE MasterLabel = 'ascend Portal'];

        if (!siteList.isEmpty()) {
            resultString = [SELECT SecureUrl FROM SiteDetail WHERE DurableId = :siteList.get(0).Id].SecureUrl;
        }

        resultString = resultString.removeEnd('/s');

        return resultString;
    }

    public static String getCommunityPathPrefix() {
        List<Network> netList = [SELECT Id, UrlPathPrefix FROM Network WHERE Name = 'ascend Portal'];

        if (netList.isEmpty()) {
            return '';
        }

        return netList.get(0).UrlPathPrefix;
    }

    /**
     * Private function that inserts giving soc, membership benefits, membership levels, society memberships, etc for 
     * Giving Society and Honor Roll module
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param   baseUrl     Base URL of Portal Site
     */
    private static void insertGivingSocietyAndHonorRollRecords(String baseUrl) {
        String startDateTimeString = Datetime.now().addDays(-1).format('yyyy-MM-dd hh:mm:ss');
        String endDateTimeString = Datetime.now().addDays(14).format('yyyy-MM-dd hh:mm:ss');
        Date today = date.today();
        Date oneYearLater = today.addYears(1);

        List<ucinn_ascendv2__Giving_Society__c> societiesToInsert = new List<ucinn_ascendv2__Giving_Society__c>();


        ucinn_ascendv2__Giving_Society__c xavierSociety = new ucinn_ascendv2__Giving_Society__c(Name = '1831 Society',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Label__c = '1831 Society',
                                                                                                ucinn_ascendv2__Status__c = 'Inactive',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(xavierSociety);


        ucinn_ascendv2__Giving_Society__c alumniSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Alumni Association',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Label__c = 'Alumni Association',
                                                                                                ucinn_ascendv2__Status__c = 'Inactive',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(alumniSociety);


        ucinn_ascendv2__Giving_Society__c annualSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Annual Giving Society',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Label__c = 'Annual Giving Society',
                                                                                                ucinn_ascendv2__Status__c = 'Inactive',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(annualSociety);


        ucinn_ascendv2__Giving_Society__c ascendSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Ascend Membership',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/Ascend-img.jpeg">',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Label__c = 'Ascend Membership',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(ascendSociety);


        ucinn_ascendv2__Giving_Society__c badinSociety = new ucinn_ascendv2__Giving_Society__c( Name = 'Badin Guild',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Lifetime',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_479379625.jpg">',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Label__c = 'Badin Guild',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(badinSociety);


        ucinn_ascendv2__Giving_Society__c carlosSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Carlos Museum',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Lifetime',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Label__c = 'Carlos Museum',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(carlosSociety);


        ucinn_ascendv2__Giving_Society__c ucInnovationLoyalSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'UC Innovation Loyal',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Label__c = 'UC Innovation Loyal',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/University-Seal.jpg">',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(ucInnovationLoyalSociety);


        ucinn_ascendv2__Giving_Society__c lifetimeSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'The Lifetime Giving Societies',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Lifetime',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/giving.png">',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Label__c = 'The Lifetime Giving Societies',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(lifetimeSociety);


        ucinn_ascendv2__Giving_Society__c ucinnSociety = new ucinn_ascendv2__Giving_Society__c( Name = 'UC Innovation Society',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_ascendv2__Status__c = 'Active',
                                                                                                ucinn_portal_Label__c = 'UC Innovation Society',
                                                                                                ucinn_portal_Society_Logo__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/Ascend-img.jpeg">',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(ucinnSociety);


        ucinn_ascendv2__Giving_Society__c utkSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'UTK Giving Society',
                                                                                                ucinn_ascendv2__Society_Website__c = 'https://www.ucinnovation.com/s/',
                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                ucinn_ascendv2__School__c = 'School of Law',
                                                                                                ucinn_ascendv2__Status__c = 'Inactive',
                                                                                                ucinn_portal_Label__c = 'UTK Giving Society',
                                                                                                ucinn_portal_Type__c = 'Annual',
                                                                                                ucinn_portal_Description__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                                                                                                            + 'sed do eiusmod tempor incididunt ut labore et dolore magna '
                                                                                                            + 'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                                                                                                            + 'ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        societiesToInsert.add(utkSociety);

        insert societiesToInsert;

        List<ucinn_ascendv2__Membership_Benefit__c> benefitsToInsert = new List<ucinn_ascendv2__Membership_Benefit__c>();


        ucinn_ascendv2__Membership_Benefit__c ascendBenefit = new ucinn_ascendv2__Membership_Benefit__c(ucinn_ascendv2__Benefit__c = 'Museum Tickets',
                                                                                                        ucinn_ascendv2__Giving_Society__c = ascendSociety.Id,
                                                                                                        Name = '[Default Name]');
        benefitsToInsert.add(ascendBenefit);

        ucinn_ascendv2__Membership_Benefit__c longhornPin = new ucinn_ascendv2__Membership_Benefit__c(ucinn_ascendv2__Benefit__c = 'Lapel Pin',
                                                                                                        ucinn_ascendv2__Giving_Society__c = ucInnovationLoyalSociety.Id,
                                                                                                        Name = '[Default Name]');
        benefitsToInsert.add(longhornPin);


        ucinn_ascendv2__Membership_Benefit__c longhornShirt = new ucinn_ascendv2__Membership_Benefit__c(ucinn_ascendv2__Benefit__c = 'T-Shirt',
                                                                                                        ucinn_ascendv2__Giving_Society__c = ucInnovationLoyalSociety.Id,
                                                                                                        Name = '[Default Name]');
        benefitsToInsert.add(longhornShirt);


        ucinn_ascendv2__Membership_Benefit__c longhornRing = new ucinn_ascendv2__Membership_Benefit__c(ucinn_ascendv2__Benefit__c = 'Ring',
                                                                                                        ucinn_ascendv2__Giving_Society__c = ucInnovationLoyalSociety.Id,
                                                                                                        Name = '[Default Name]');
        benefitsToInsert.add(longhornRing);


        ucinn_ascendv2__Membership_Benefit__c carlosCD = new ucinn_ascendv2__Membership_Benefit__c(ucinn_ascendv2__Benefit__c = 'Musical CD',
                                                                                                        ucinn_ascendv2__Giving_Society__c = carlosSociety.Id,
                                                                                                        Name = '[Default Name]');
        benefitsToInsert.add(carlosCD);


        ucinn_ascendv2__Membership_Benefit__c carlosBookmark = new ucinn_ascendv2__Membership_Benefit__c(ucinn_ascendv2__Benefit__c = 'Bookmark',
                                                                                                        ucinn_ascendv2__Giving_Society__c = carlosSociety.Id,
                                                                                                        Name = '[Default Name]');
        benefitsToInsert.add(carlosBookmark);


        insert benefitsToInsert;

        
        // Insert membership levels in reverse hierarchy order
        List<ucinn_ascendv2__Membership_Level__c> secondLevelsToInsert = new List<ucinn_ascendv2__Membership_Level__c>();

        ucinn_ascendv2__Membership_Level__c xavierLevel2 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = xavierSociety.Id,
                                                                                                    Name = '1831 Society Annual Membership Level 2',
                                                                                                    ucinn_portal_Label__c = '1831 Annual Membership 2',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership 2 for 1831 Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level 2',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 160);
        secondLevelsToInsert.add(xavierLevel2);


        ucinn_ascendv2__Membership_Level__c utkLevel2 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = utkSociety.Id,
                                                                                                    Name = 'UTK Giving Society Annual Membership Level 2',
                                                                                                    ucinn_portal_Label__c = 'UTK Annual Membership 2',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership 2 for UTK Giving Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level 2',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 100);
        secondLevelsToInsert.add(utkLevel2);


        ucinn_ascendv2__Membership_Level__c annualLevel2 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = annualSociety.Id,
                                                                                                    Name = 'Annual Giving Society Annual Membership Level 2',
                                                                                                    ucinn_portal_Label__c = 'Annual Membership 2',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership 2 for Annual Giving Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 200);
        secondLevelsToInsert.add(annualLevel2);


        ucinn_ascendv2__Membership_Level__c ucinnLevel2 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = ucinnSociety.Id,
                                                                                                    Name = 'UC Innovation Society Annual Membership Level 2',
                                                                                                    ucinn_portal_Label__c = 'Veteran Innovator Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains annual Veteran Innovator Membership for The UC Innovation Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Veteran Innovator Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 100);
        secondLevelsToInsert.add(ucinnLevel2);

        insert secondLevelsToInsert;


        List<ucinn_ascendv2__Membership_Level__c> firstLevelsToInsert = new List<ucinn_ascendv2__Membership_Level__c>();

        ucinn_ascendv2__Membership_Level__c xavierLevel1 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = xavierSociety.Id,
                                                                                                    Name = '1831 Society Annual Membership Level 1',
                                                                                                    ucinn_portal_Label__c = '1831 Annual Membership 1',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership 1 for 1831 Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level 1',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 80,
                                                                                                    ucinn_portal_Next_Level_Min_Amount__c = 160,
                                                                                                    ucinn_portal_Next_Membership_Level__c = xavierLevel2.Id);
        firstLevelsToInsert.add(xavierLevel1);


        ucinn_ascendv2__Membership_Level__c alumniLevel = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = alumniSociety.Id,
                                                                                                    Name = 'Alumni Association Annual Membership Level',
                                                                                                    ucinn_portal_Label__c = 'Alumni Annual Membership 1',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership for Alumni Association',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 90);
        firstLevelsToInsert.add(alumniLevel);


        ucinn_ascendv2__Membership_Level__c annualLevel1 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = annualSociety.Id,
                                                                                                    Name = 'Annual Giving Society Annual Membership Level 1',
                                                                                                    ucinn_portal_Label__c = 'Annual Membership 1',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership 1 for Annual Giving Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 100,
                                                                                                    ucinn_portal_Next_Level_Min_Amount__c = 200,
                                                                                                    ucinn_portal_Next_Membership_Level__c = annualLevel2.Id);
        firstLevelsToInsert.add(annualLevel1);


        ucinn_ascendv2__Membership_Level__c ascendLevel = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = ascendSociety.Id,
                                                                                                    Name = 'Ascend Membership Annual Membership Level',
                                                                                                    ucinn_portal_Label__c = 'Ascend Annual Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership for Ascend Membership',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 150);
        firstLevelsToInsert.add(ascendLevel);


        ucinn_ascendv2__Membership_Level__c badinLevel = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = badinSociety.Id,
                                                                                                    Name = 'Badin Guild Lifetime Membership Level',
                                                                                                    ucinn_portal_Label__c = 'Badin Lifetime Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Lifetime Membership for Badin Guild',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Lifetime Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 120);
        firstLevelsToInsert.add(badinLevel);


        ucinn_ascendv2__Membership_Level__c carlosLevel = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = carlosSociety.Id,
                                                                                                    Name = 'Carlos Museum Lifetime Membership Level',
                                                                                                    ucinn_portal_Label__c = 'Carlos Museum Lifetime Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Lifetime Membership for Carlos Museum',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Lifetime Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 1000);
        firstLevelsToInsert.add(carlosLevel);


        ucinn_ascendv2__Membership_Level__c ucInnovationLoyalLevel = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = ucInnovationLoyalSociety.Id,
                                                                                                    Name = 'UC Innovation Loyal Annual Membership Level',
                                                                                                    ucinn_portal_Label__c = 'Loyal Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership for UC Innovation Loyal',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 50);
        firstLevelsToInsert.add(ucInnovationLoyalLevel);


        ucinn_ascendv2__Membership_Level__c lifetimeLevel = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = lifetimeSociety.Id,
                                                                                                    Name = 'The Lifetime Giving Societies Lifetime Membership Level',
                                                                                                    ucinn_portal_Label__c = 'Lifetime Giving Society Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Lifetime Membership for The Lifetime Giving Societies',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Lifetime Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 2000);
        firstLevelsToInsert.add(lifetimeLevel);


        ucinn_ascendv2__Membership_Level__c ucinnLevel1 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = ucinnSociety.Id,
                                                                                                    Name = 'UC Innovation Society Annual Membership Level 1',
                                                                                                    ucinn_portal_Label__c = 'Innovator Membership',
                                                                                                    ucinn_portal_Summary__c = 'Obtains annual Innovator Membership for The UC Innovation Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Innovator Annual Membership Level',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 50,
                                                                                                    ucinn_portal_Next_Level_Min_Amount__c = 100,
                                                                                                    ucinn_portal_Next_Membership_Level__c = ucinnLevel2.Id);
        firstLevelsToInsert.add(ucinnLevel1);

        ucinn_ascendv2__Membership_Level__c utkLevel1 = new ucinn_ascendv2__Membership_Level__c(ucinn_ascendv2__Giving_Society__c = utkSociety.Id,
                                                                                                    Name = 'UTK Giving Society Annual Membership Level 1',
                                                                                                    ucinn_portal_Label__c = 'UTK Annual Membership 1',
                                                                                                    ucinn_portal_Summary__c = 'Obtains Annual Membership 1 for UTK Giving Society',
                                                                                                    ucinn_ascendv2__Eligibility__c = 'Subscription for Annual Membership Level 1',
                                                                                                    ucinn_portal_Current_Level_Min_Amount__c = 50,
                                                                                                    ucinn_portal_Next_Level_Min_Amount__c = 100,
                                                                                                    ucinn_portal_Next_Membership_Level__c = utkLevel2.Id);
        firstLevelsToInsert.add(utkLevel1);

        insert firstLevelsToInsert;

        List<ucinn_ascendv2__Society_Membership__c> societyMembershipsToInsert = new List<ucinn_ascendv2__Society_Membership__c>();

        insert new ucinn_portal_Honor_Roll_Name__c(
            Honor_Roll_Name__c = 'Tony Stark MS\'88 and Pepper Potts',
            Starting_Fiscal_Year__c = '2021',
            Contact__c = tonyStarkMap.get(CONTACT_ID),
            Joint_Contact__c = pepperPottsMap.get(CONTACT_ID)
        );

        for (Map<String, String> eachContactMap : heroContactMaps.values()) {
            String eachContactId = eachContactMap.get(CONTACT_ID); 
            if (eachContactId == pepperPottsMap.get(CONTACT_ID)) {
                continue;
            }

            ucinn_ascendv2__Society_Membership__c xavierSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = xavierSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = xavierLevel1.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(xavierSocietyMember);

            if (eachContactId != tonyStarkMap.get(CONTACT_ID)) {
                continue;
            }

            ucinn_ascendv2__Society_Membership__c alumniSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = alumniSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = alumniLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(alumniSocietyMember);


            ucinn_ascendv2__Society_Membership__c annualSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = annualSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = annualLevel1.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(annualSocietyMember);


            ucinn_ascendv2__Society_Membership__c ascendSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = ascendSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = ascendLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(ascendSocietyMember);

            ucinn_ascendv2__Society_Membership__c ascendSocietyMember2 = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = ascendSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = ascendLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(ascendSocietyMember2);



            ucinn_ascendv2__Society_Membership__c badinSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = badinSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = badinLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId,
                                                                                                                ucinn_portal_Elevate_Condition__c = '$100,000 to elevate');
            societyMembershipsToInsert.add(badinSocietyMember);


            ucinn_ascendv2__Society_Membership__c carlosSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = carlosSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = carlosLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId,
                                                                                                                ucinn_portal_Elevate_Condition__c = '$500,000 to elevate');
            societyMembershipsToInsert.add(carlosSocietyMember);


            ucinn_ascendv2__Society_Membership__c longhornSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = ucInnovationLoyalSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = ucInnovationLoyalLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(longhornSocietyMember);


            ucinn_ascendv2__Society_Membership__c lifetimeSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = lifetimeSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = lifetimeLevel.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId,
                                                                                                                ucinn_portal_Elevate_Condition__c = '$250,000 to elevate');
            societyMembershipsToInsert.add(lifetimeSocietyMember);


            ucinn_ascendv2__Society_Membership__c ucinnSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = ucinnSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = ucinnLevel1.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(ucinnSocietyMember);


            ucinn_ascendv2__Society_Membership__c utkSocietyMember = new ucinn_ascendv2__Society_Membership__c(Name = '[Default Name]',
                                                                                                                ucinn_ascendv2__Giving_Society__c = utkSociety.Id,
                                                                                                                ucinn_ascendv2__Membership_Level__c = utkLevel1.Id,
                                                                                                                ucinn_ascendv2__FY_Contributions__c = 10.00,
                                                                                                                ucinn_ascendv2__Member_Since__c = today,
                                                                                                                ucinn_ascendv2__Expiration_Date__c = oneYearLater,
                                                                                                                ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                                                ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                                ucinn_ascendv2__Contact__c = eachContactId);
            societyMembershipsToInsert.add(utkSocietyMember);
        }

        insert societyMembershipsToInsert;
    }

    /**
     * Private function that inserts Donor Stories for
     * Giving Society and Honor Roll module
     * 
     * @author  Phillip Nguyen
     * @since   1.1
     * 
     * @param   baseUrl     Base URL of Portal Site
     */
    private static void insertDonorStoriesForGivingSocietyAndHonorRolls(String baseUrl) {
        String donorStoryRecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();

        List<ucinn_portal_Listing__c> donorStoriesToInsert = new List<ucinn_portal_Listing__c>();

        ucinn_portal_Listing__c donorStory1 = new ucinn_portal_Listing__c(RecordTypeId = donorStoryRecordTypeId,
                                                                        Name = 'The Ascend Society takes a leap forward',
                                                                        Author__c = 'Jane Doe',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_349698210_Editorial_Use_Only.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/sunrise_arch.jpg">',
                                                                        Header_Content__c = '<p>Join the Ascend Society, where the future is today.<p>',
                                                                        Body_Content_Plain_Text__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.'
                                                                        + 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.</p>');
                                                                        
        donorStoriesToInsert.add(donorStory1);

        ucinn_portal_Listing__c donorStory2 = new ucinn_portal_Listing__c(RecordTypeId = donorStoryRecordTypeId,
                                                                        Name = '\"Everybody Starts Somewhere\"',
                                                                        Author__c = 'Jane Doe',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/AdobeStock_211651043.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/Public-Speaker-Photo.jpg">',
                                                                        Header_Content__c = '<p>Take a dive into the philosophy of the Carlos Museum Alternative\'s founder.<p>',
                                                                        Body_Content_Plain_Text__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.'
                                                                                        + 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.</p>');
        
        donorStoriesToInsert.add(donorStory2);

        ucinn_portal_Listing__c donorStory3 = new ucinn_portal_Listing__c(RecordTypeId = donorStoryRecordTypeId,
                                                                        Name = 'Leaps and Bounds in Computer Advancement',
                                                                        Author__c = 'Jane Doe',
                                                                        Portal_Zones_To_Exclude__c = '',
                                                                        Status__c = 'Published',
                                                                        Header_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/100_computing_banner_desktop.jpg">',
                                                                        Header_Caption__c = 'Optional Caption: This is a caption for the picture above.',
                                                                        Thumbnail_Image__c = '<img src="' + baseUrl + '/resource/Portal_DataCreationPictures/hi-tech-interface-54-4k.jpg">',
                                                                        Header_Content__c = '<p>Recent research indicates that technological advancement is dictated by a few simple factors.<p>',
                                                                        Body_Content_Plain_Text__c = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.'
                                                                                        + 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at facilisis arcu. '
                                                                                        + 'Quisque vel interdum odio, in interdum magna. Maecenas molestie a nisl sed iaculis. '
                                                                                        + 'Etiam nec erat sit amet mauris porttitor feugiat sed ut urna. Class aptent taciti sociosqu '
                                                                                        + 'ad litora torquent per conubia nostra, per inceptos himenaeos.</p>');
        
        donorStoriesToInsert.add(donorStory3);

        insert donorStoriesToInsert;
    }
}