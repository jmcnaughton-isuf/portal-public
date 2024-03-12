@isTest
public without sharing class PORTAL_VolunteerControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact contactRecord;
        public User contactUser;
        public ucinn_portal_Volunteer_Job__c volunteerJob;
        public ucinn_portal_Volunteer_Shift__c volunteerShift;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts() {
            System.runAs(thisUser) {
                Account account = new Account(name = 'Test Account');
                account = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => account});
                insert account;

                contactRecord = new Contact(LastName = 'Test Contact Last Name',
                                            AccountId = account.Id,
                                            FirstName = 'First Name Test',
                                            Email = 'testEmail1@test.com',
                                            ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual');
                contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
                insert contactRecord;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                User newUser = new User(ContactId = contactRecord.Id,
                                        ProfileId = profileId,
                                        Username = System.now().millisecond() + 'testuser@test.com.user',
                                        Alias = 'testers',
                                        Email='testvolunteer@test.com',
                                        EmailEncodingKey='UTF-8',
                                        Firstname='Test',
                                        Lastname='User',
                                        LanguageLocaleKey='en_US',
                                        LocaleSidKey='en_US',
                                        TimeZoneSidKey='America/Chicago');
                newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
                insert newUser;

                contactUser = newUser;
            }
        }

        public virtual void setUpVolunteerJobs() {
            if (volunteerJob == null) {
                volunteerJob = new ucinn_portal_Volunteer_Job__c(Name = 'Test Volunteer Job', Start_Date_Time__c = DateTime.now(), City__c = 'Irvine', State__c = 'California', Country__c='USA', Postal_Code__c='92880');
                volunteerJob = (ucinn_portal_Volunteer_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => volunteerJob});
                insert volunteerJob;
            }

            if (volunteerShift == null) {
                volunteerShift = new ucinn_portal_Volunteer_Shift__c(Name = 'Test Morning Shift',
                                                                    Start_Date_Time__c = DateTime.now(),
                                                                    Maximum_Number_of_Volunteers__c = 5,
                                                                    Volunteer_Job__c = volunteerJob.Id);
                volunteerShift = (ucinn_portal_Volunteer_Shift__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => volunteerShift});
                insert volunteerShift;
            }
        }

        public virtual void testGetVolunteerJobs() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            Map<String, Object> returnMap = controller.getVolunteerJobList(null);
            System.assert(returnMap.isEmpty());

            try {
                controller.getVolunteerJobList(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'invalid page name'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpVolunteerJobs();

            ucinn_portal_Volunteer__c newVolunteerObject = new ucinn_portal_Volunteer__c(Application_Status__c = 'Pending', Volunteer_Shift__c = volunteerShift.Id, Registering_Constituent__c = contactRecord.Id);
            newVolunteerObject = (ucinn_portal_Volunteer__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newVolunteerObject});
            insert newVolunteerObject;

            Map<Object,Object> locationObject = new Map<Object,Object>{'city' => 'Irvine', 'state' => 'California', 'country' => 'USA', 'postalCode' => '92880'};
            Map<Object,Object> locationObjectWithRadius = new Map<Object,Object>{'city' => 'Irvine', 'state' => 'California', 'country' => 'USA', 'postalCode' => '92880', 'radius' => 25};

            System.runAs(contactUser){
                controller.getVolunteerJobList(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Invalid Page',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Invalid Main Section',
                                                                        PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => 'Invalid Sub Section'});


                returnMap = controller.getVolunteerJobList(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                   PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Job List',
                                                                                   PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => ''});

                System.assert((returnMap != null || !returnMap.isEmpty()));

                returnMap = controller.getVolunteerJobList(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                   PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Job List',
                                                                                   PORTAL_VolunteerControllerBase.SEARCH_STRING => 'Job',
                                                                                   PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => ''});

                System.assert((returnMap != null || !returnMap.isEmpty()));

                returnMap = controller.getVolunteerJobList(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                   PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Job List',
                                                                                   PORTAL_VolunteerControllerBase.LOCATION_KEY => locationObject,
                                                                                   PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => ''});

                System.assert((returnMap != null || !returnMap.isEmpty()));

                returnMap = controller.getVolunteerJobList(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Job List',
                                                                        PORTAL_VolunteerControllerBase.LOCATION_KEY => locationObjectWithRadius,
                                                                        PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => ''});
            }
        }

        public virtual void testGetShiftInfo() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            Map<String, Object> returnMap = controller.getShiftInfo(null);
            System.assert(returnMap == null);

            returnMap = controller.getShiftInfo(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => ''});
            System.assert(returnMap == null);

            setUpContacts();
            setUpVolunteerJobs();

            System.runAs(contactUser){
                controller.getShiftInfo(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Invalid Page',
                                                                PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Invalid Main Section',
                                                                PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => 'Invalid Sub Section',
                                                                PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id});


                returnMap = controller.getShiftInfo(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                   PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Job List',
                                                                                   PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id});
            }
        }

        public virtual void testInitializeVolunteerSignUp() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            Map<String, Object> returnMap = controller.initializeVolunteerSignUp(null);
            System.assert(returnMap.isEmpty());

            returnMap = controller.initializeVolunteerSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => ''});
            System.assert(returnMap.isEmpty());

            setUpContacts();
            setUpVolunteerJobs();

            System.runAs(contactUser){
                controller.initializeVolunteerSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Invalid Page',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Invalid Main Section',
                                                                        PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => 'Invalid Sub Section',
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id});


                returnMap = controller.initializeVolunteerSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                   PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Sign Up',
                                                                                   PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id});

                System.assert((returnMap != null || !returnMap.isEmpty()));
            }
        }

        public virtual void testInitializeVolunteerModifyModal() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            Map<String, Object> returnMap = controller.initializeVolunteerModifyModal(null);
            System.assert(returnMap.isEmpty());

            returnMap = controller.initializeVolunteerModifyModal(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => ''});
            System.assert(returnMap.isEmpty());

            setUpContacts();
            setUpVolunteerJobs();

            ucinn_portal_Volunteer__c newVolunteerObject = new ucinn_portal_Volunteer__c(Application_Status__c = 'Pending', Volunteer_Shift__c = volunteerShift.Id, Registering_Constituent__c = contactRecord.Id);
            newVolunteerObject = (ucinn_portal_Volunteer__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newVolunteerObject});
            insert newVolunteerObject;

            System.runAs(contactUser){
                controller.initializeVolunteerModifyModal(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Invalid Page',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Invalid Main Section',
                                                                        PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => 'Invalid Sub Section',
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id});

                returnMap = controller.initializeVolunteerModifyModal(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                            PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Modify',
                                                                                            PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id,
                                                                                            PORTAL_VolunteerControllerBase.VOLUNTEER_ID => newVolunteerObject.Id});

                System.assert((returnMap != null || !returnMap.isEmpty()));

                returnMap = controller.initializeVolunteerModifyModal(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                                   PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Modify',
                                                                                   PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id});

                System.assert((returnMap != null || !returnMap.isEmpty()));
            }
        }

        public virtual void testVolunteerModifyApplicationSave() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            try {
                controller.volunteerModifyApplicationSave(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.volunteerModifyApplicationSave(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => ''});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpVolunteerJobs();

            ucinn_portal_Volunteer__c newVolunteerObject = new ucinn_portal_Volunteer__c(Application_Status__c = 'Pending', Volunteer_Shift__c = volunteerShift.Id, Registering_Constituent__c = contactRecord.Id);
            newVolunteerObject = (ucinn_portal_Volunteer__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newVolunteerObject});
            insert newVolunteerObject;
            Map<Object,Object> volunteerInfoMap = new Map<Object, Object>{'volunteerLastName' => 'NewModifyLastName'};

            System.runAs(contactUser){
                try {
                    controller.volunteerModifyApplicationSave(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Invalid Page',
                                                                            PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Invalid Main Section',
                                                                            PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => 'Invalid Sub Section'});
                } catch (AuraHandledException ahe) {
                    System.debug(ahe);
                }

                try {
                    controller.volunteerModifyApplicationSave(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Modify',
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_BIO_INFO_MAP => volunteerInfoMap,
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_ID => newVolunteerObject.Id});
                } catch (AuraHandledException ahe) {
                    System.debug(ahe);
                }

            }
        }

        public virtual void testVolunteerShiftSignUp() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            try {
                controller.volunteerShiftSignUp(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.volunteerShiftSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => ''});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpVolunteerJobs();

            Map<Object,Object> volunteerInfoMap = new Map<Object, Object>{'volunteerEmail' => 'testemail@testemail.com', 'volunteerFirstName' => 'testfirstnameSign', 'volunteerLastName' => 'testlastSign'};
            Map<Object,Object> volunteerGuestInfoMap = new Map<Object, Object>{'volunteerEmail' => 'guestEmail@testemail.com', 'volunteerFirstName' => 'guestFirstNm', 'volunteerLastName' => 'guestLastNm'};
            Map<Object,Object> volunteerNoChangesMap = new Map<Object, Object>{'volunteerEmail' => 'testEmail1@test.com', 'volunteerFirstName' => 'First Name Test', 'volunteerLastName' => 'Test Contact Last Name'};

            System.runAs(contactUser){
                try {
                    controller.volunteerShiftSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Invalid Page',
                                                                            PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Invalid Main Section',
                                                                            PORTAL_VolunteerControllerBase.SUB_SECTION_NAME => 'Invalid Sub Section'});
                } catch (AuraHandledException ahe) {
                    System.debug(ahe);
                }

                controller.volunteerShiftSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Sign Up',
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id,
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_BIO_INFO_MAP => volunteerNoChangesMap});

                controller.volunteerShiftSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Sign Up',
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id,
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_BIO_INFO_MAP => volunteerGuestInfoMap});


                controller.volunteerShiftSignUp(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => 'Volunteers',
                                                                        PORTAL_VolunteerControllerBase.MAIN_SECTION_NAME => 'Volunteer Sign Up',
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_SHIFT_ID => volunteerShift.Id,
                                                                        PORTAL_VolunteerControllerBase.VOLUNTEER_BIO_INFO_MAP => volunteerInfoMap});
            }
        }


        public virtual void testInitializeVolunteerEditForm() {
            PORTAL_VolunteerControllerBase controller = new PORTAL_VolunteerControllerBase();
            controller.initializeVolunteerEditForm(null);
            controller.initializeVolunteerEditForm(new Map<String, Object>());
            controller.initializeVolunteerEditForm(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Edit Form'});
        }


        public virtual void testUpdateVolunteerInformation() {
            PORTAL_VolunteerControllerBase controller = new PORTAL_VolunteerControllerBase();
            controller.updateVolunteerInformation(null);
            controller.updateVolunteerInformation(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Edit Form'});
        }


        public virtual void testGetVolunteerInformation() {
            PORTAL_VolunteerControllerBase controller = new PORTAL_VolunteerControllerBase();
            controller.getVolunteerInformation(null);
            controller.getVolunteerInformation(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Information'});
        }


        public virtual void testInitializeReportHoursForm() {
            PORTAL_VolunteerControllerBase controller = new PORTAL_VolunteerControllerBase();
            Account acct = new Account(name = 'ACME Co') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            ucinn_portal_Volunteer_Job__c volunteerJob = new ucinn_portal_Volunteer_Job__c(Name = 'Test Job');
            volunteerJob = (ucinn_portal_Volunteer_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => volunteerJob});
            insert volunteerJob;

            ucinn_portal_Volunteer_Shift__c volunteerShift = new ucinn_portal_Volunteer_Shift__c(Name = 'Test Shift', Volunteer_Job__c = volunteerJob.Id);
            volunteerShift = (ucinn_portal_Volunteer_Shift__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => volunteerShift});
            insert volunteerShift;

            ucinn_portal_Volunteer__c volunteerRecord = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShift.Id, Contact__c = con.Id, Registering_Constituent__c = con.Id, Application_Status__c = 'Completed');
            volunteerRecord = (ucinn_portal_Volunteer__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => volunteerRecord});
            insert volunteerRecord;

            controller.initializeReportHoursForm(null);
            controller.initializeReportHoursForm(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Report Form'});
            controller.initializeReportHoursForm(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Report Form', 'recordId' => volunteerRecord.Id});
        }


        public virtual void testReportVolunteerHours() {
            PORTAL_VolunteerControllerBase controller = new PORTAL_VolunteerControllerBase();
            controller.reportVolunteerHours(null);
            controller.reportVolunteerHours(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Report Form'});
        }


        public virtual void testGetVolunteerRecords() {
            PORTAL_VolunteerControllerBase controller = new PORTAL_VolunteerControllerBase();
            controller.getVolunteerRecords(null);
            controller.getVolunteerRecords(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Tables', 'subSectionName' => 'Open Volunteer Shifts'});
            setUpContacts();
            System.runAs(contactUser){
                controller.getVolunteerRecords(new Map<String, Object>{'pageName' => 'Volunteer Information', 'mainSectionName' => 'Volunteer Tables', 'subSectionName' => 'Open Volunteer Shifts'});
            }
        }

        public virtual void testVolunteerCreatCase() {
            Case newCase = PORTAL_VolunteerControllerBase.createCase('Test Case Subject', 'Test Case Description');
            System.assert(newCase != null);
        }

        public virtual void testWithdrawVolunteerApplication() {
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            try {
                controller.withdrawVolunteerApplication(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.withdrawVolunteerApplication(new Map<String, Object>{PORTAL_VolunteerControllerBase.PAGE_NAME => ''});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpVolunteerJobs();

            Test.startTest();
            ucinn_portal_Volunteer__c newVolunteerObject = new ucinn_portal_Volunteer__c(Application_Status__c = 'Pending', Volunteer_Shift__c = volunteerShift.Id, Registering_Constituent__c = contactRecord.Id);
            newVolunteerObject = (ucinn_portal_Volunteer__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newVolunteerObject});
            insert newVolunteerObject;

            System.runAs(contactUser){
                try {
                    controller.withdrawVolunteerApplication(new Map<String, Object>{PORTAL_VolunteerControllerBase.VOLUNTEER_ID => newVolunteerObject.Id});
                } catch (AuraHandledException ahe) {
                    System.debug(ahe);
                }

                List<ucinn_portal_Volunteer__c> volunteerList = [SELECT Application_Status__c FROM ucinn_portal_Volunteer__c WHERE Id = :newVolunteerObject.Id];
                System.assert(volunteerList.get(0).Application_Status__c == PORTAL_VolunteerControllerBase.CANCELLED_STATUS);
            }
            Test.stopTest();
        }

    }

    static testMethod void testGetVolunteerJobs() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testGetVolunteerJobs();
    }

    static testMethod void testGetShiftInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testGetShiftInfo();
    }

    static testMethod void testInitializeVolunteerSignUp() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testInitializeVolunteerSignUp();
    }

    static testMethod void testInitializeVolunteerModifyModal() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testInitializeVolunteerModifyModal();
    }

    static testMethod void testVolunteerModifyApplicationSave() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testVolunteerModifyApplicationSave();
    }

    static testMethod void testVolunteerShiftSignUp() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testVolunteerShiftSignUp();
    }

    @isTest
    static void testInitializeVolunteerEditForm() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testInitializeVolunteerEditForm();
    }

    @isTest
    static void testUpdateVolunteerInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testUpdateVolunteerInformation();
    }

    @isTest
    static void testGetVolunteerInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testGetVolunteerInformation();
    }

    @isTest
    static void testInitializeReportHoursForm() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testInitializeReportHoursForm();
    }

    @isTest
    static void testReportVolunteerHours() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testReportVolunteerHours();
    }

    @isTest
    static void testGetVolunteerRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testGetVolunteerRecords();

    }

    static testMethod void testVolunteerCreatCase() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testVolunteerCreatCase();
    }

    static testMethod void testWithdrawVolunteerApplication() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerControllerBaseTestClass().testWithdrawVolunteerApplication();
    }

}