@isTest
public class PORTAL_UTIL_HonorRollTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Account accountRecord;
        public Contact contactRecord;
        public ucinn_ascendv2__Society_Membership__c societyMembership;
        public ucinn_ascendv2__Society_Membership__c societyMembershipInThePast;
        public Date startDate;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts() {
            System.runAs(thisUser) {
                accountRecord = new Account(name = 'Test Account') ;
                accountRecord = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => accountRecord});
                insert accountRecord;

                contactRecord = new Contact(LastName = 'Test Contact',
                                            AccountId = accountRecord.Id,
                                            ucinn_portal_Is_Honor_Roll_Opt_Out__c = false);

                contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
                insert contactRecord;
            }
        }

        public virtual void setUpSocietyMemberships() {
            if (contactRecord == null) {
                setUpContacts();
            }

            Period fiscalYearInfo = PORTAL_CommunityUtils.getCurrentFiscalYear(null);
            startDate = fiscalYearInfo.StartDate;

            Date pastDate = date.parse('12/27/2009');

            ucinn_ascendv2__Giving_Society__c givingSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Test Giving Society',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Lifetime');

            givingSociety = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety});
            insert givingSociety;

            ucinn_ascendv2__Membership_Level__c membershipLevel = new ucinn_ascendv2__Membership_Level__c(Name = 'Test Level',
                                                                                                          ucinn_ascendv2__Giving_Society__c = givingSociety.Id);

            membershipLevel = (ucinn_ascendv2__Membership_Level__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membershipLevel});
            insert membershipLevel;

            societyMembership = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership',
                                                                          ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                          ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                          ucinn_ascendv2__Member_Since__c = startDate,
                                                                          ucinn_ascendv2__Membership_Level__c = membershipLevel.Id,
                                                                          ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            societyMembership = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership});
            insert societyMembership;

            societyMembershipInThePast = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership in the Past',
                                                                                    ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                                    ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                                    ucinn_ascendv2__Member_Since__c = pastDate,
                                                                                    ucinn_ascendv2__Membership_Level__c = membershipLevel.Id,
                                                                                    ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                                    ucinn_portal_Is_Display_On_Portal__c = true);
            societyMembershipInThePast = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembershipInThePast});
            insert societyMembershipInThePast;
        }

        public virtual void setUpDegreeInformation() {
            if (contactRecord == null) {
                setUpContacts();
            }

            Id recordTypeId = Schema.SObjectType.ucinn_ascendv2__Degree_Information__c.getRecordTypeInfosByDeveloperName().get('School_Degree_Information').getRecordTypeId();

            ucinn_ascendv2__Degree_Code__c newDegreeCodeBS = new ucinn_ascendv2__Degree_Code__c(Name='BS');
            ucinn_ascendv2__Degree_Code__c newDegreeCodeMS = new ucinn_ascendv2__Degree_Code__c(Name='MS');
            newDegreeCodeBS = (ucinn_ascendv2__Degree_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeCodeBS});
            newDegreeCodeMS = (ucinn_ascendv2__Degree_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeCodeMS});
            insert newDegreeCodeBS;
            insert newDegreeCodeMS;

            ucinn_ascendv2__Degree_Information__c newDegreeBS = new ucinn_ascendv2__Degree_Information__c(Name = 'Test Degree',
                                                                                                        ucinn_ascendv2__Degree_Institution__c = accountRecord.Id,
                                                                                                        ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                                                        ucinn_ascendv2__Conferred_Degree_Year__c = '2021',
                                                                                                        ucinn_ascendv2__Degree_Code__r = newDegreeCodeBS,
                                                                                                        RecordTypeId = recordTypeId
                                                                                                        );

            ucinn_ascendv2__Degree_Information__c newDegreeMS = new ucinn_ascendv2__Degree_Information__c(Name = 'Test Degree',
                                                                                                        ucinn_ascendv2__Degree_Institution__c = accountRecord.Id,
                                                                                                        ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                                                        ucinn_ascendv2__Conferred_Degree_Year__c = '2022',
                                                                                                        ucinn_ascendv2__Degree_Code__r = newDegreeCodeMS,
                                                                                                        RecordTypeId = recordTypeId
                                                                                                        );

            newDegreeBS = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeBS});
            newDegreeMS = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeMS});
            insert newDegreeBS;
            insert newDegreeMS;
        }

        public virtual void testGetContactInformation(){
            setUpContacts();

            Set<Id> newTestSet = new Set<Id>{contactRecord.Id};

            PORTAL_UTIL_HonorRoll.getContactInformation(null);
            PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{'Test Param' => newTestSet});
            PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => newTestSet});
        }

        public virtual void testQuerySocietyMemberships(){
            setUpContacts();
            setUpSocietyMemberships();
            Set<Id> newContactTestSet = new Set<Id>{contactRecord.Id};
            Set<Id> newSocietyMembershipSet = new Set<Id>{societyMembership.Id};

            PORTAL_UTIL_HonorRoll.queryForSocietyMembershipsWithAllFields(null);

            PORTAL_UTIL_HonorRoll.queryForSocietyMembershipsWithAllFields(new Map<String, Object>{'Test Param' => newContactTestSet,
                                                                                                  PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_ID_SET => newSocietyMembershipSet});

            PORTAL_UTIL_HonorRoll.queryForSocietyMembershipsWithAllFields(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => newContactTestSet,
                                                                                                  PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_ID_SET => newSocietyMembershipSet});
        }

        public virtual void testParseSocietyMembershipToUpsert(){
            setUpContacts();
            setUpSocietyMemberships();

            PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(null);

            Test.startTest();
            ucinn_ascendv2__Society_Membership__c societyMembershipInThePastRecord = [SELECT Id, ucinn_ascendv2__Giving_Society__r.ucinn_portal_Type__c,
                                                                                        ucinn_portal_Is_Show_on_Honor_Roll__c, ucinn_ascendv2__Member_Since__c, ucinn_ascendv2__Expiration_Date__c
                                                                                        FROM ucinn_ascendv2__Society_Membership__c WHERE Id = :societyMembershipInThePast.Id];

            PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(new Map<String, Object>{PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_RECORD => null,
                                                                                         PORTAL_UTIL_HonorRoll.CURRENT_FISCAL_YEAR_START_DATE => startDate});

            PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(new Map<String, Object>{PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_RECORD => societyMembership,
                                                                                         PORTAL_UTIL_HonorRoll.CURRENT_FISCAL_YEAR_START_DATE => startDate});

            PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(new Map<String, Object>{PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_RECORD => societyMembership,
                                                                                         PORTAL_UTIL_HonorRoll.CURRENT_FISCAL_YEAR_START_DATE => startDate,
                                                                                         PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => false});


            PORTAL_UTIL_HonorRoll.parseSocietyMembershipToUpsert(new Map<String, Object>{PORTAL_UTIL_HonorRoll.SOCIETY_MEMBERSHIP_RECORD => societyMembershipInThePastRecord,
                                                                                         PORTAL_UTIL_HonorRoll.CURRENT_FISCAL_YEAR_START_DATE => startDate,
                                                                                         PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => false});

            Test.stopTest();
        }

        public virtual void testGetSpouseIdList(){
            setUpContacts();

            Contact newSpouseRecord = new Contact(LastName = 'Test Spouse',
                                                  AccountId = accountRecord.Id);

            Test.startTest();
            newSpouseRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newSpouseRecord});
            insert newSpouseRecord;

            contactRecord.ucinn_ascendv2__Preferred_Spouse__c = newSpouseRecord.Id;
            update contactRecord;

            List<Contact> newTestContactList = new List<Contact>{contactRecord};

            PORTAL_UTIL_HonorRoll.getSpouseIdSet(null);
            PORTAL_UTIL_HonorRoll.getSpouseIdSet(new Map<String, Object>{'Test Param' => newTestContactList});
            PORTAL_UTIL_HonorRoll.getSpouseIdSet(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => newTestContactList});
            Test.stopTest();
        }

        public virtual void testFormatHonorRollName(){
            setUpContacts();
            setUpDegreeInformation();

            Test.startTest();
            Set<Id> newTestSet = new Set<Id>{contactRecord.Id};

            List<Contact> contactList = PORTAL_UTIL_HonorRoll.getContactInformation(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_ID_SET => newTestSet});

            if (contactList == null || contactList.isEmpty()) {
                return;
            }

            PORTAL_UTIL_HonorRoll.formatHonorRollName(null);
            PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{'Test Param' => new Contact(LastName='', AccountId = accountRecord.Id)});
            PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_RECORD => new Contact(LastName='', AccountId = accountRecord.Id)});
            PORTAL_UTIL_HonorRoll.formatHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_RECORD => contactList.get(0)});
            Test.stopTest();
        }

        public virtual void testCreateIdToContactMap(){
            setUpContacts();

            Test.startTest();

            List<Contact> contactList = new List<Contact>{contactRecord};

            PORTAL_UTIL_HonorRoll.createContactIdToContactMap(null);
            PORTAL_UTIL_HonorRoll.createContactIdToContactMap(new Map<String, Object>{'Test Param'=> contactList});
            PORTAL_UTIL_HonorRoll.createContactIdToContactMap(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_LIST => contactList});
            Test.stopTest();
        }

        public virtual void testCreateJointHonorRollName() {
            PORTAL_UTIL_HonorRoll.createJointHonorRollName(null);
            PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => '',
                                                                                   PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => ''});

            PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => 'Test',
                                                                                   PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => ''});

            PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => '',
                                                                                   PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => 'Test'});

            PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => 'AA TEST',
                                                                                   PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => 'BB Test'});

            PORTAL_UTIL_HonorRoll.createJointHonorRollName(new Map<String, Object>{PORTAL_UTIL_HonorRoll.CONTACT_HONOR_ROLL_NAME => 'BB TEST',
                                                                                   PORTAL_UTIL_HonorRoll.SPOUSE_HONOR_ROLL_NAME => 'AA Test'});
        }

        public virtual void testUpdateContactGlobalHonorRollOptOut() {
            setUpContacts();

            PORTAL_UTIL_HonorRoll.updateContactGlobalHonorRollOptOut(null);

            PORTAL_UTIL_HonorRoll.updateContactGlobalHonorRollOptOut(new Map<String, Object>{PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => null,
                                                                                             PORTAL_UTIL_HonorRoll.CONTACT_ID => contactRecord.Id});

            PORTAL_UTIL_HonorRoll.updateContactGlobalHonorRollOptOut(new Map<String, Object>{PORTAL_UTIL_HonorRoll.HONOR_ROLL_OPT_OUT_VALUE => true,
                                                                                            PORTAL_UTIL_HonorRoll.CONTACT_ID => contactRecord.Id});
        }

    }

    static testMethod void testGetContactInformation(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testGetContactInformation();
    }

    static testMethod void testQuerySocietyMemberships(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testQuerySocietyMemberships();
    }

    static testMethod void testParseSocietyMembershipToUpsert(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testParseSocietyMembershipToUpsert();
    }

    static testMethod void testGetSpouseIdList(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testGetSpouseIdList();
    }

    static testMethod void testFormatHonorRollName(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testFormatHonorRollName();
    }

    static testMethod void testCreateIdToContactMap(){
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testCreateIdToContactMap();
    }

    static testMethod void testCreateJointHonorRollName() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testCreateJointHonorRollName();
    }

    static testMethod void testUpdateContactGlobalHonorRollOptOut() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_HonorRollTestClass().testUpdateContactGlobalHonorRollOptOut();
    }

}