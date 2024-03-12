@isTest
global class PORTAL_TRIG_ContactHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Account account;
        public Contact contactRecord;
        public Contact jointContactRecord;
        public String currentFiscalYear;
        public ucinn_portal_Honor_Roll_Name__c honorRollRecord;
        public ucinn_ascendv2__Society_Membership__c societyMembership;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts(String contactName, String jointContactName, String jointPreference) {
            currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period
                                            WHERE Type = 'Year'
                                            AND StartDate <= TODAY
                                            AND EndDate >= TODAY].FiscalYearSettings.Name;

            account = new Account(name = 'Test Account') ;
            account = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => account});
            insert account;

            contactRecord = createContactRecord(contactName, jointPreference);
            contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
            insert contactRecord;

            jointContactRecord = createContactRecord(jointContactName, jointPreference);
            jointContactRecord.ucinn_ascendv2__Preferred_Spouse__c = contactRecord.Id;
            jointContactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jointContactRecord});
            insert jointContactRecord;

            contactRecord.ucinn_ascendv2__Preferred_Spouse__c = jointContactRecord.Id;
            update contactRecord;
        }

        public virtual Contact createContactRecord(String name, String jointPreference) {
            return new Contact(LastName = name,
                                ucinn_portal_Honor_Roll_Joint_Preference__c = jointPreference,
                                ucinn_portal_Is_Honor_Roll_Opt_Out__c = false,
                                ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = false,
                                AccountId = account.Id);
        }

        public virtual void testDeleteExternalContact() {

            ucinn_ascendv2__Trigger_Handler__c contactHandler = new ucinn_ascendv2__Trigger_Handler__c();
            contactHandler.Name = 'PORTAL_TRIG_ContactHandler';
            contactHandler.ucinn_ascendv2__Class__c = 'PORTAL_TRIG_ContactHandler';
            contactHandler.ucinn_ascendv2__Is_Active__c = true;
            contactHandler.ucinn_ascendv2__Is_Asynchronous__c = false;
            contactHandler.ucinn_ascendv2__Is_User_Managed__c = false;
            contactHandler.ucinn_ascendv2__Load_Order__c = 1.0;
            contactHandler.ucinn_ascendv2__Object__c = 'Contact';
            contactHandler.ucinn_ascendv2__Trigger_Action__c = 'BeforeInsert;BeforeUpdate;BeforeDelete;AfterInsert;AfterUpdate;AfterDelete;AfterUndelete';
            contactHandler = (ucinn_ascendv2__Trigger_Handler__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactHandler});
            insert contactHandler;

            Contact con = new Contact(Email = 'testEmail@test.com.invalid', ucinn_portal_External_Email_API_Id__c = 'testExternalId', FirstName = 'test', LastName = 'test');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            //not much to validate since this can act differently depending on the email api
            delete con;

        }

        public virtual void setUpHonorRollNameRecordsInThePast() {
            if (contactRecord == null) {
                setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            }

            honorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                    Starting_Fiscal_Year__c = '2010',
                                                                    Honor_Roll_Name__c = 'Test Honor Roll Name');

            ucinn_portal_Honor_Roll_Name__c jointHonorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = jointContactRecord.Id,
                                                                    Starting_Fiscal_Year__c = '2012',
                                                                    Honor_Roll_Name__c = 'Test Spouse Honor Roll Name');

            honorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => honorRollRecord});
            jointHonorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jointHonorRollRecord});
            insert honorRollRecord;
            insert jointHonorRollRecord;
        }

        public virtual void setUpHonorRollNameRecordsInCurrentFiscalYear() {
            if (contactRecord == null) {
                setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            }

            honorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                    Starting_Fiscal_Year__c = currentFiscalYear,
                                                                    Honor_Roll_Name__c = 'Test Honor Roll Name');

            ucinn_portal_Honor_Roll_Name__c jointHonorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = jointContactRecord.Id,
                                                                    Starting_Fiscal_Year__c = currentFiscalYear,
                                                                    Honor_Roll_Name__c = 'Test Spouse Honor Roll Name');

            honorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => honorRollRecord});
            jointHonorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jointHonorRollRecord});
            insert honorRollRecord;
            insert jointHonorRollRecord;
        }

        public virtual void setUpSocietyMemberships() {
            if (contactRecord == null) {
                setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            }

            ucinn_ascendv2__Giving_Society__c givingSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Test Giving Society',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Annual');
            givingSociety = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety});
            insert givingSociety;

            societyMembership = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership',
                                                                          ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                          ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                          ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            societyMembership = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership});
            insert societyMembership;
        }

        public virtual void setUpDegreeInformation() {
            if (contactRecord == null) {
                setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            }

            ucinn_ascendv2__Degree_Code__c newDegreeCodeBS = new ucinn_ascendv2__Degree_Code__c(Name='BS');
            ucinn_ascendv2__Degree_Code__c newDegreeCodeMS = new ucinn_ascendv2__Degree_Code__c(Name='MS');

            newDegreeCodeBS = (ucinn_ascendv2__Degree_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeCodeBS});
            newDegreeCodeMS = (ucinn_ascendv2__Degree_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeCodeMS});
            insert newDegreeCodeBS;
            insert newDegreeCodeMS;

            ucinn_ascendv2__Degree_Information__c newDegreeBS = new ucinn_ascendv2__Degree_Information__c(Name = 'Test Degree BS',
                                                                                                        ucinn_ascendv2__Degree_Institution__c = account.Id,
                                                                                                        ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                                                        ucinn_ascendv2__Conferred_Degree_Year__c = '2021',
                                                                                                        ucinn_ascendv2__Degree_Code__r = newDegreeCodeBS
                                                                                                        );

            ucinn_ascendv2__Degree_Information__c newDegreeMS = new ucinn_ascendv2__Degree_Information__c(Name = 'Test Degree MS',
                                                                                                        ucinn_ascendv2__Degree_Institution__c = account.Id,
                                                                                                        ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                                                        ucinn_ascendv2__Conferred_Degree_Year__c = '2022',
                                                                                                        ucinn_ascendv2__Degree_Code__r = newDegreeCodeMS
                                                                                                        );

            newDegreeBS = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeBS});
            newDegreeMS = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeMS});
            insert newDegreeBS;
            insert newDegreeMS;
        }

        public virtual void testGlobalOptOut() {
            setUpContacts('Test Contact', 'Test Spouse Contact', 'Joint');
            setUpSocietyMemberships();

            new PORTAL_TRIG_ContactHandler().run(new List<SObject>(),
                                                 new List<SObject>(),
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            List<SObject> oldList = new List<SObject>{contactRecord};

            Contact newContact = contactRecord.clone(true, true, false, false);
            newContact.ucinn_portal_Is_Honor_Roll_Opt_Out__c = true;

            List<SObject> newList = new List<SObject>{newContact};
            newContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newContact});
            update newContact;

            new PORTAL_TRIG_ContactHandler().run(newList,
                                                oldList,
                                                ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                Contact.getSObjectType().getDescribe());
        }

        public virtual void testHonorRollJointPreferenceChangeToJointForPastFiscalYear() {
            setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            setUpHonorRollNameRecordsInThePast();
            setUpDegreeInformation();

            Test.startTest();

            List<SObject> oldList = new List<SObject>{contactRecord};

            Contact newRecord = contactRecord.clone(true, true, false, false);

            newRecord.ucinn_portal_Honor_Roll_Joint_Preference__c = 'Joint';

            List<SObject> newList = new List<SObject>{newRecord};

            // this will update spouse contact joint preference
            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            update newRecord;

            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            Test.stopTest();
        }

        public virtual void testHonorRollJointPreferenceChangeToJointForCurrentFiscalYear() {
            setUpContacts('Test Current Contact', 'Test Current Spouse Contact', 'Individual');
            setUpHonorRollNameRecordsInCurrentFiscalYear();
            setUpDegreeInformation();

            Test.startTest();

            List<SObject> oldList = new List<SObject>{contactRecord};

            Contact newRecord = contactRecord.clone(true, true, false, false);

            newRecord.ucinn_portal_Honor_Roll_Joint_Preference__c = 'Joint';

            List<SObject> newList = new List<SObject>{newRecord};

            // this will update spouse contact joint preference
            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            update newRecord;

            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            Test.stopTest();
        }

        public virtual void testHonorRollJointPreferenceChangeContactToIndividual() {
            setUpContacts('Test New Contact 1', 'Test New Joint Contact 1', 'Joint');

            ucinn_portal_Honor_Roll_Name__c honorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                                                    Joint_Contact__c = jointContactRecord.Id,
                                                                                                    Starting_Fiscal_Year__c = '2010',
                                                                                                    Honor_Roll_Name__c = 'Test Joint Honor Roll Name');
            honorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => honorRollRecord});
            insert honorRollRecord;

            Test.startTest();

            List<SObject> oldList = new List<SObject>{contactRecord};

            Contact newRecord = contactRecord.clone(true, true, false, false);

            newRecord.ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual';

            List<SObject> newList = new List<SObject>{newRecord};

            // this will update spouse contact joint preference
            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            update newRecord;

            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());



            setUpContacts('Test New Contact 2020', 'Test New Joint Contact 2021', 'Joint');

            honorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                    Joint_Contact__c = jointContactRecord.Id,
                                                                    Starting_Fiscal_Year__c = currentFiscalYear,
                                                                    Honor_Roll_Name__c = 'Test New Joint Honor Roll Name');
            honorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => honorRollRecord});
            insert honorRollRecord;

            oldList = new List<SObject>{contactRecord};

            newRecord = contactRecord.clone(true, true, false, false);

            newRecord.ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual';

            newList = new List<SObject>{newRecord};

            // this will update spouse contact joint preference
            new PORTAL_TRIG_ContactHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                    Contact.getSObjectType().getDescribe());

            update newRecord;

            new PORTAL_TRIG_ContactHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                    Contact.getSObjectType().getDescribe());

            Test.stopTest();
        }

        public virtual void testHonorRollJointPreferenceChangeSpouseToIndividual() {
            setUpContacts('Test New Contact 2', 'Test New Joint Contact 2', 'Joint');

            ucinn_portal_Honor_Roll_Name__c honorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                                                    Joint_Contact__c = jointContactRecord.Id,
                                                                                                    Starting_Fiscal_Year__c = '2010',
                                                                                                    Honor_Roll_Name__c = 'Test Joint Honor Roll Name');

            honorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => honorRollRecord});
            insert honorRollRecord;

            Test.startTest();

            List<SObject> oldList = new List<SObject>{contactRecord};

            Contact newRecord = contactRecord.clone(true, true, false, false);

            newRecord.ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual';

            List<SObject> newList = new List<SObject>{newRecord};

            // this will update spouse contact joint preference
            new PORTAL_TRIG_ContactHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            update newRecord;

            List<SObject> oldSpouseList = new List<SObject>{jointContactRecord};

            jointContactRecord = [SELECT Id, ucinn_portal_Honor_Roll_Joint_Preference__c, ucinn_portal_Is_Renewal_Solicit_Opt_Out__c,
                                     ucinn_ascendv2__Preferred_Spouse__c, ucinn_portal_Is_Honor_Roll_Opt_Out__c FROM Contact WHERE Id = :jointContactRecord.Id];

            List<SObject> newSpouseList = new List<SObject>{jointContactRecord};


            new PORTAL_TRIG_ContactHandler().run(newSpouseList,
                                                 oldSpouseList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            Test.stopTest();
        }

        public virtual void testGetContactswithJointPreferenceChanged() {
            PORTAL_TRIG_ContactHandler.getContactswithJointPreferenceChanged(null, null);

            Contact testContactRecord = new Contact();

            List<Contact> testContactList = new List<Contact>{testContactRecord};

            PORTAL_TRIG_ContactHandler.getContactswithJointPreferenceChanged(testContactList, testContactList);
        }

        public virtual void testGetSocietyMembershipsToUpsert() {
            setUpSocietyMemberships();

            Contact testContact = new Contact(LastName='TestId');
            testContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testContact});
            insert testContact;

            List<ucinn_ascendv2__Society_Membership__c> newList = new List<ucinn_ascendv2__Society_Membership__c>{societyMembership};
            Map<Id,Boolean> newMap = new Map<Id,Boolean>();
            newMap.put(testContact.Id, false);


            PORTAL_TRIG_ContactHandler.getSocietyMembershipsToUpsert(newList,
                                                                     null);

            PORTAL_TRIG_ContactHandler.getSocietyMembershipsToUpsert(newList,
                                                                     newMap);

            newMap.put(contactRecord.Id, false);
            PORTAL_TRIG_ContactHandler.getSocietyMembershipsToUpsert(newList,
                                                                     newMap);

            newMap.put(contactRecord.Id, true);
            PORTAL_TRIG_ContactHandler.getSocietyMembershipsToUpsert(newList,
                                                                     newMap);
        }

        public virtual void testGetUnsyncedAndSyncedContactRecordMap() {
            setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            PORTAL_TRIG_ContactHandler.getUnsyncedAndSyncedContactRecordMap(null, null);
            Contact testContact = new Contact(LastName='Test Contact');
            testContact.ucinn_ascendv2__Preferred_Spouse__c = contactRecord.Id;
            testContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testContact});
            insert testContact;

            List<Contact> newList = new List<Contact>{testContact};
            Map<Id,Contact> newMap = new Map<Id,Contact>();
            newMap.put(testContact.Id, testContact);

            PORTAL_TRIG_ContactHandler.getUnsyncedAndSyncedContactRecordMap(newList, newMap);
        }

        public virtual void testUpdateHonorRollNameRecordsEdgeCases() {
            setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            PORTAL_TRIG_ContactHandler.updateHonorRollNameRecords(null, null);
            Contact testContact = new Contact(LastName='Test Contact');
            testContact.ucinn_ascendv2__Preferred_Spouse__c = contactRecord.Id;
            testContact = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testContact});
            insert testContact;

            List<Contact> newList = new List<Contact>{testContact};
            Map<Id,Contact> newMap = new Map<Id,Contact>();
            newMap.put(testContact.Id, testContact);

            PORTAL_TRIG_ContactHandler.updateHonorRollNameRecords(newList, newMap);

            newMap.put(contactRecord.Id, contactRecord);

            PORTAL_TRIG_ContactHandler.updateHonorRollNameRecords(newList, newMap);
        }

        public virtual void testHandleHonorRollNameRecordChanges() {
            PORTAL_TRIG_ContactHandler.handleHonorRollNameRecordChanges(null, null);

            setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            Contact testContact = new Contact(LastName='Test Contact No Insert');
            List<Contact> newList = new List<Contact>{testContact};

            Map<Id,Contact> newMap = new Map<Id,Contact>();
            newMap.put(contactRecord.Id, contactRecord);


            PORTAL_TRIG_ContactHandler.handleHonorRollNameRecordChanges(newList, newMap);
        }

        public virtual void testGlobalOptOutMembershipRenewalSolicitation() {
            setUpContacts('Test Contact', 'Test Spouse Contact', 'Joint');
            setUpSocietyMemberships();

            new PORTAL_TRIG_ContactHandler().run(new List<SObject>(),
                                                 new List<SObject>(),
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 Contact.getSObjectType().getDescribe());

            List<SObject> oldList = new List<SObject>{contactRecord};

            Contact newContact = contactRecord.clone(true, true, false, false);
            newContact.ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = true;

            List<SObject> newList = new List<SObject>{newContact};

            update newContact;

            new PORTAL_TRIG_ContactHandler().run(newList,
                                                oldList,
                                                ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                Contact.getSObjectType().getDescribe());
        }
    }

    @isTest
    global static void testDeleteExternalContact() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testDeleteExternalContact();
    }

    static testMethod void testGlobalOptOut() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testGlobalOptOut();
    }

    static testMethod void testHonorRollJointPreferenceChangeToJointForPastFiscalYear() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testHonorRollJointPreferenceChangeToJointForPastFiscalYear();
    }

    static testMethod void testHonorRollJointPreferenceChangeToJointForCurrentFiscalYear() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testHonorRollJointPreferenceChangeToJointForCurrentFiscalYear();
    }

    static testMethod void testHonorRollJointPreferenceChangeContactToIndividual() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testHonorRollJointPreferenceChangeContactToIndividual();
    }

    static testMethod void testHonorRollJointPreferenceChangeSpouseToIndividual() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testHonorRollJointPreferenceChangeSpouseToIndividual();
    }

    static testMethod void testGetContactswithJointPreferenceChanged() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testGetContactswithJointPreferenceChanged();
    }

    static testMethod void testGetSocietyMembershipsToUpsert() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testGetSocietyMembershipsToUpsert();
    }

    static testMethod void testGetUnsyncedAndSyncedContactRecordMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testGetUnsyncedAndSyncedContactRecordMap();
    }

    static testMethod void testUpdateHonorRollNameRecordsEdgeCases() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testUpdateHonorRollNameRecordsEdgeCases();
    }

    static testMethod void testHandleHonorRollNameRecordChanges() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testHandleHonorRollNameRecordChanges();
    }

    static testMethod void testGlobalOptOutMembershipRenewalSolicitation() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ContactHandlerTestClass().testGlobalOptOutMembershipRenewalSolicitation();
    }

}