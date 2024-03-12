@isTest
public class PORTAL_HonorRollControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Account account;
        public Contact contactRecord;
        public Contact jointContactRecord;
        public ucinn_ascendv2__Society_Membership__c societyMembership;
        public String currentFiscalYear;
        public ucinn_portal_Honor_Roll_Name__c honorRollRecord;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts() {
            currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period
                                            WHERE Type = 'Year'
                                            AND StartDate <= TODAY
                                            AND EndDate >= TODAY].FiscalYearSettings.Name;

            account = new Account(name = 'Test Account') ;
            account = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => account});
            insert account;

            contactRecord = new Contact(LastName = 'Test Contact',
                                        AccountId = account.Id,
                                        ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual',
                                        ucinn_portal_Is_Honor_Roll_Opt_Out__c = false);
            contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
            insert contactRecord;

        }

        public virtual void setUpHonorRollNameRecord() {
            if (contactRecord == null) {
                setUpContacts();
            }

            honorRollRecord = new ucinn_portal_Honor_Roll_Name__c(Contact__c = contactRecord.Id,
                                                                    Starting_Fiscal_Year__c = currentFiscalYear,
                                                                    Honor_Roll_Name__c = 'Test Honor Roll Name');
            honorRollRecord = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => honorRollRecord});
            insert honorRollRecord;
        }

        public virtual void setUpSocietyMemberships() {
            if (contactRecord == null) {
                setUpContacts();
            }

            Period fiscalYearInfo = PORTAL_CommunityUtils.getCurrentFiscalYear(null);

            ucinn_ascendv2__Giving_Society__c givingSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Test Giving Society',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Annual');
            givingSociety = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety});
            insert givingSociety;

            ucinn_ascendv2__Membership_Level__c membershipLevel = new ucinn_ascendv2__Membership_Level__c(Name = 'Test Level',
                                                                                                          ucinn_ascendv2__Giving_Society__c = givingSociety.Id);
            membershipLevel = (ucinn_ascendv2__Membership_Level__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membershipLevel});

            insert membershipLevel;

            societyMembership = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership',
                                                                          ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                          ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                          ucinn_ascendv2__Member_Since__c = fiscalYearInfo.StartDate,
                                                                          ucinn_ascendv2__Membership_Level__c = membershipLevel.Id,
                                                                          ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true);
            societyMembership = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership});

            insert societyMembership;
        }

        public virtual void setUpDegreeInformation() {
            if (contactRecord == null) {
                setUpContacts();
            }

            ucinn_ascendv2__Degree_Code__c newDegreeCodeBS = new ucinn_ascendv2__Degree_Code__c(Name='BS', ucinn_ascendv2__Is_Active__c = true);
            newDegreeCodeBS = (ucinn_ascendv2__Degree_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeCodeBS});

            insert newDegreeCodeBS;

            ucinn_ascendv2__Degree_Information__c newDegreeBS = new ucinn_ascendv2__Degree_Information__c(Name = 'Test Degree',
                                                                                                            ucinn_ascendv2__Degree_Institution__c = account.Id,
                                                                                                            ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                                                            ucinn_ascendv2__Conferred_Degree_Year__c = '2021',
                                                                                                            ucinn_ascendv2__Degree_Code__r = newDegreeCodeBS
                                                                                                            );
            newDegreeBS = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegreeBS});

            insert newDegreeBS;
        }

        public virtual void setUpAcademicOrganization() {
            ucinn_ascendv2__Academic_Organization__c newAcademicOrg = new ucinn_ascendv2__Academic_Organization__c(Name = 'Test Academic Org',
                                                                                                                    ucinn_ascendv2__Effective_Date__c = null,
                                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true);
            newAcademicOrg = (ucinn_ascendv2__Academic_Organization__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newAcademicOrg});

            insert newAcademicOrg;
        }

        public virtual void setUpOrgSettings() {
            ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
            orgSettings.Name = 'Default Org Wide Config';
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
            orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
            orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});

            insert orgSettings;
        }

        public virtual void testGetHonorRollNames() {
            setUpContacts();
            setUpHonorRollNameRecord();
            setUpAcademicOrganization();
            setUpSocietyMemberships();
            setUpDegreeInformation();

            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();
            controller.getHonorRollNames(null);

            controller.getHonorRollNames(new Map<String,Object>{PORTAL_HonorRollControllerBase.CLASS_YEAR => '2021',
                                                                PORTAL_HonorRollControllerBase.FISCAL_YEAR => currentFiscalYear,
                                                                PORTAL_HonorRollControllerBase.NAME_SEARCH_STRING => 'Test',
                                                                PORTAL_HonorRollControllerBase.GIVING_SOCIETY => 'Test Giving Society',
                                                                PORTAL_HonorRollControllerBase.ACADEMIC_ORGANIZATION => 'Test Academic Org',
                                                                PORTAL_HonorRollControllerBase.OFFSET_KEY => 0,
                                                                PORTAL_HonorRollControllerBase.QUERY_LIMIT => 50});
        }

        public virtual void testGetFilterInfo() {
            setUpContacts();
            setUpHonorRollNameRecord();
            setUpSocietyMemberships();
            setUpDegreeInformation();

            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();
            controller.getHonorRollFilterInformation(null);
            controller.getHonorRollFilterInformation(new Map<String,Object>{PORTAL_HonorRollControllerBase.OLDEST_CLASS_YEAR => '1950'});

            setUpAcademicOrganization();
            controller.getHonorRollFilterInformation(new Map<String,Object>{PORTAL_HonorRollControllerBase.OLDEST_CLASS_YEAR => '1950'});
        }

        public virtual void testGetHonorRollDetails() {
            setUpContacts();
            setUpHonorRollNameRecord();
            setUpSocietyMemberships();
            setUpDegreeInformation();

            jointContactRecord = new Contact(LastName = 'Test Joint Contact');
            jointContactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jointContactRecord});
            insert jointContactRecord;

            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();
            controller.getHonorRollNameDetails(null);
            controller.getHonorRollNameDetails(new Map<String,Object>{PORTAL_HonorRollControllerBase.FISCAL_YEAR => currentFiscalYear
                                                                      });

            controller.getHonorRollNameDetails(new Map<String,Object>{PORTAL_HonorRollControllerBase.FISCAL_YEAR => currentFiscalYear,
                                                                      PORTAL_HonorRollControllerBase.CONTACT_ID_KEY => contactRecord.Id,
                                                                      PORTAL_HonorRollControllerBase.JOINT_CONTACT_ID_KEY => jointContactRecord.Id
                                                                      });

            controller.getHonorRollNameDetails(new Map<String,Object>{PORTAL_HonorRollControllerBase.FISCAL_YEAR => currentFiscalYear,
                                                                      PORTAL_HonorRollControllerBase.CONTACT_ID_KEY => contactRecord.Id
                                                                      });
        }

        public virtual void testGetHonorRollManagementInfo() {
            setUpContacts();

            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
            User newUser = new User(ContactId = contactRecord.Id,
                                    ProfileId = profileId,
                                    Username = System.now().millisecond() + 'testuser@test.com',
                                    Alias = 'testers',
                                    Email='testuser1@test.com',
                                    EmailEncodingKey='UTF-8',
                                    Firstname='Test',
                                    Lastname='User',
                                    LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US',
                                    TimeZoneSidKey='America/Chicago');

            newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
            insert newUser;

            Contact newRecord = new Contact(LastName = 'Test 2');
            newRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newRecord});
            insert newRecord;

            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();

            Test.startTest();
            System.runAs(newUser){
                controller.getHonorRollManagementInformation();
                setUpHonorRollNameRecord();
                controller.getHonorRollManagementInformation();
            }

            honorRollRecord.Joint_Contact__c = contactRecord.Id;
            honorRollRecord.Contact__c = newRecord.Id;
            update honorRollRecord;

            System.runAs(newUser){
                controller.getHonorRollManagementInformation();
            }
            Test.stopTest();
        }

        public virtual void testSubmitHonorRollChanges() {
            setUpContacts();

            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            User newUser = new User(ContactId = contactRecord.Id,
                                    ProfileId = profileId,
                                    Username = System.now().millisecond() + 'testuser@test.com',
                                    Alias = 'testers',
                                    Email='testuser1@test.com',
                                    EmailEncodingKey='UTF-8',
                                    Firstname='Test',
                                    Lastname='User',
                                    LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US',
                                    TimeZoneSidKey='America/Chicago',
                                    IsActive = true);
            newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
            insert newUser;

            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();

            System.runAs(newUser){
                setUpHonorRollNameRecord();
                setUpSocietyMemberships();
                setUpOrgSettings();

                controller.submitHonorRollChanges(null);
                controller.submitHonorRollChanges(new Map<String, Object>{
                                                                          PORTAL_HonorRollControllerBase.HONOR_ROLL_OPT_OUT => true,
                                                                          PORTAL_HonorRollControllerBase.HONOR_ROLL_NAME_KEY => 'Test New Name Test',
                                                                          PORTAL_HonorRollControllerBase.HONOR_ROLL_JOINT_PREFERENCE => 'Individual',
                                                                          PORTAL_HonorRollControllerBase.MEMBERSHIPS_TO_UPDATE => new Map<Object,Object>{societyMembership.Id => false}
                                                                        });
            }
        }

        public virtual void testUpsertIsDisplayHonorRollOnSocietyMemberships() {
            setUpContacts();
            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();
            controller.upsertIsDisplayHonorRollOnSocietyMemberships(null, null);

            Map<Object,Object> newMap = new Map<Object,Object>();
            newMap.put('Test', false);

            controller.upsertIsDisplayHonorRollOnSocietyMemberships(contactRecord.Id, newMap);
        }

        public virtual void testCreateCaseForHonorRollUpdate() {
            PORTAL_HonorRollControllerBase controller = new PORTAL_HonorRollControllerBase();
            controller.createCaseForHonorRollUpdate(null, null, null);
        }
    }


    static testMethod void testGetHonorRollNames() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testGetHonorRollNames();
    }

    static testMethod void testGetFilterInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testGetFilterInfo();
    }

    static testMethod void testGetHonorRollDetails() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testGetHonorRollDetails();
    }

    static testMethod void testGetHonorRollManagementInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testGetHonorRollManagementInfo();
    }

    static testMethod void testSubmitHonorRollChanges() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testSubmitHonorRollChanges();
    }

    static testMethod void testUpsertIsDisplayHonorRollOnSocietyMemberships() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testUpsertIsDisplayHonorRollOnSocietyMemberships();
    }

    static testMethod void testCreateCaseForHonorRollUpdate() {
        PORTAL_TestClassFactory.getTestClassFactory().getHonorRollControllerBaseTestClass().testCreateCaseForHonorRollUpdate();
    }
}