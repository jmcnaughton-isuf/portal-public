@isTest
public class PORTAL_EventManagementControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Listing__c newListing;
        public ucinn_portal_Ticket_Type__c newTicketType;
        public ucinn_portal_Participation__c participationRecord;
        public Map<Object, Object> objectRegistrantMap;
        public Contact con;
        public User communityUser;

        public String testFirstName = 'test';
        public String testLastName = 'test';
        public String testEmail = 'test@test.com';

        public String testAddress = '222 test';
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupUserData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = con.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;
            }
        }

        public virtual void setUpEvent() {
            ucinn_portal_Registration_Template__c newTemplate = new ucinn_portal_Registration_Template__c();
            newTemplate = (ucinn_portal_Registration_Template__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTemplate});
            insert newTemplate;

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            newListing = new ucinn_portal_Listing__c(Name = 'Test Event',
                                                     Header_Content__c = 'This is a Test.',
                                                     RecordTypeId = recordTypeId,
                                                     Status__c = 'Published',
                                                     Registration_Template__c = newTemplate.Id);
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            newTicketType = new ucinn_portal_Ticket_Type__c(Listing__c = newListing.Id, Price__c = 5);
            newTicketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTicketType});
            insert newTicketType;
        }

        public virtual void setUpParticipation() {
            if (newListing == null) {
                setUpEvent();
            }

            ucinn_ascendv2__Interim__c interimRecord = new ucinn_ascendv2__Interim__c(ucinn_ascendv2__Email_1__c = testEmail,
                                                                                        ucinn_ascendv2__First_Name__c = testFirstName,
                                                                                        ucinn_ascendv2__Last_Name__c = testLastName,
                                                                                        ucinn_ascendv2__Address_1_Line_1__c = testAddress,
                                                                                        ucinn_ascendv2__Address_1_Line_2__c = testAddress,
                                                                                        ucinn_ascendv2__City_1__c = testAddress,
                                                                                        ucinn_ascendv2__State_1__c = testAddress,
                                                                                        ucinn_ascendv2__Country_1__c = testAddress,
                                                                                        ucinn_ascendv2__Postal_Code_1__c = testAddress);

            ucinn_ascendv2__Interim__c interimRecord2 = new ucinn_ascendv2__Interim__c(ucinn_ascendv2__Email_1__c = testEmail,
                                                                                        ucinn_ascendv2__First_Name__c = testFirstName,
                                                                                        ucinn_ascendv2__Last_Name__c = 'A TEST LAST NAME',
                                                                                        ucinn_ascendv2__Address_1_Line_1__c = testAddress,
                                                                                        ucinn_ascendv2__Address_1_Line_2__c = testAddress,
                                                                                        ucinn_ascendv2__City_1__c = testAddress,
                                                                                        ucinn_ascendv2__State_1__c = testAddress,
                                                                                        ucinn_ascendv2__Country_1__c = testAddress,
                                                                                        ucinn_ascendv2__Postal_Code_1__c = testAddress);

            Contact contactRecord = new Contact(Email = testEmail,
                                                FirstName = 'A Test Name',
                                                LastName = testLastName,
                                                ucinn_ascendv2__Preferred_Address_Line_1__c = testAddress,
                                                ucinn_ascendv2__Preferred_Address_Line_2__c = testAddress,
                                                ucinn_ascendv2__Preferred_Address_City__c = testAddress,
                                                ucinn_ascendv2__Preferred_Address_State__c = testAddress,
                                                ucinn_ascendv2__Preferred_Address_Country__c = testAddress,
                                                ucinn_ascendv2__Preferred_Address_Postal_Code__c = testAddress);

            interimRecord = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimRecord});
            interimRecord2 = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimRecord2});
            contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
            insert interimRecord;
            insert interimRecord2;
            insert contactRecord;

            participationRecord = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                    Interim__c = interimRecord.Id,
                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED);

            ucinn_portal_Participation__c participationRecord2 = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                    Contact__c = contactRecord.Id,
                                                                    Name_Tag__c = testFirstName,
                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED);

            ucinn_portal_Participation__c participationRecord3 = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                    Interim__c = interimRecord2.Id,
                                                                    Primary_Participation__c = participationRecord2.Id,
                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED);

            ucinn_portal_Participation__c participationRecord4 = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                    Interim__c = interimRecord.Id,
                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED);

            participationRecord = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord});
            participationRecord2 = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord2});
            participationRecord3 = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord3});
            participationRecord4 = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord4});

            insert new List<ucinn_portal_Participation__c>{participationRecord, participationRecord2, participationRecord3, participationRecord4};

            ucinn_portal_Registration_Session__c completedSessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                                   Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED);

            completedSessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => completedSessionRecord});

            insert new List<ucinn_portal_Registration_Session__c>{completedSessionRecord};

            ucinn_portal_Ticket__c ticketRecord = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Registration_Session__c = completedSessionRecord.Id,
                                                                              Participation__c = participationRecord.Id);

            ucinn_portal_Ticket__c ticketRecord2 = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Registration_Session__c = completedSessionRecord.Id,
                                                                              Participation__c = participationRecord2.Id);

            ucinn_portal_Ticket__c ticketRecord3 = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Registration_Session__c = completedSessionRecord.Id,
                                                                              Participation__c = participationRecord3.Id);

            ucinn_portal_Ticket__c ticketRecord4 = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Registration_Session__c = completedSessionRecord.Id,
                                                                              Participation__c = participationRecord4.Id);

            ticketRecord = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord});
            ticketRecord2 = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord2});
            ticketRecord3 = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord3});
            ticketRecord4 = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord4});


            insert new List<ucinn_portal_Ticket__c>{ticketRecord, ticketRecord2, ticketRecord3, ticketRecord4};
        }

        public virtual void setUpPageReference() {
            PageReference pageRef = Page.PORTAL_EventAttendees;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put(PORTAL_EventManagementControllerBase.NAME_KEY, 'Test Event');
        }

        public virtual void testIsUserAdmin(){
            setupUserData();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();
            try {
                System.runAs(communityUser) {
                    controller.isUserAdministrator();
                }
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            controller.isUserAdministrator();
        }

        public virtual void testGetRegisteredParticipations() {
            setupUserData();
            setUpParticipation();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();

            try {
                controller.getRegisteredParticipations(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }


            try {
                controller.getRegisteredParticipations(new Map<String, Object>{PORTAL_EventManagementControllerBase.NAME_KEY => null,
                                                                                PORTAL_EventManagementControllerBase.OFFSET_KEY => 0,
                                                                                PORTAL_EventManagementControllerBase.SEARCH_KEY => ''});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                System.runAs(communityUser){
                    controller.getRegisteredParticipations(new Map<String, Object>{PORTAL_EventManagementControllerBase.NAME_KEY => null,
                                                                                    PORTAL_EventManagementControllerBase.OFFSET_KEY => 0,
                                                                                    PORTAL_EventManagementControllerBase.SEARCH_KEY => ''});
                }
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.getRegisteredParticipations(new Map<String, Object>{PORTAL_EventManagementControllerBase.NAME_KEY => 'Test Event',
                                                                                PORTAL_EventManagementControllerBase.OFFSET_KEY => 5000,
                                                                                PORTAL_EventManagementControllerBase.SEARCH_KEY => ''});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }


            controller.getRegisteredParticipations(new Map<String, Object>{PORTAL_EventManagementControllerBase.NAME_KEY => 'Test Event',
                                                                           PORTAL_EventManagementControllerBase.OFFSET_KEY => null,
                                                                           PORTAL_EventManagementControllerBase.SEARCH_KEY => ''});

            controller.getRegisteredParticipations(new Map<String, Object>{PORTAL_EventManagementControllerBase.NAME_KEY => 'Test Event',
                                                                           PORTAL_EventManagementControllerBase.OFFSET_KEY => 0,
                                                                           PORTAL_EventManagementControllerBase.SEARCH_KEY => 'test'});

            controller.getRegisteredParticipations(new Map<String, Object>{PORTAL_EventManagementControllerBase.NAME_KEY => 'Test Event',
                                                                           PORTAL_EventManagementControllerBase.OFFSET_KEY => 0,
                                                                           PORTAL_EventManagementControllerBase.SEARCH_KEY => ''});
        }

        public virtual void testMarkParticipationAsAttended() {
            setupUserData();
            setUpParticipation();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();
            controller.markParticipationAsAttended(null);
            controller.markParticipationAsAttended(new Map<String,Object>{PORTAL_EventManagementControllerBase.PARTICIPATION_ID => null,
                                                                            PORTAL_EventManagementControllerBase.ATTEND_VALUE => true});
            controller.markParticipationAsAttended(new Map<String,Object>{PORTAL_EventManagementControllerBase.PARTICIPATION_ID => participationRecord.Id,
                                                                            PORTAL_EventManagementControllerBase.ATTEND_VALUE => true});
        }

        public virtual void testDeleteParticipationRecord() {
            setupUserData();
            setUpParticipation();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();
            controller.deleteParticipationRecord(null);
            controller.deleteParticipationRecord(new Map<String,Object>{PORTAL_EventManagementControllerBase.PARTICIPATION_ID => null});
            controller.deleteParticipationRecord(new Map<String,Object>{PORTAL_EventManagementControllerBase.PARTICIPATION_ID => participationRecord.Id});
        }

        public virtual void testGetAttendeeLists() {
            setupUserData();
            setUpParticipation();
            setUpPageReference();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();
            controller.getAttendeeLists();

            try {
                System.runAs(communityUser) {
                    controller.getAttendeeLists();
                }
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

        }

        public virtual void testGetDegreeAndYearNeeded() {
            setupUserData();
            setUpParticipation();
            setUpPageReference();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();
            controller.getDegreeAndYearNeeded();
        }

        public virtual void testGetDocumentTitle() {
            setupUserData();
            setUpParticipation();
            setUpPageReference();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();
            controller.getDocumentTitle();
        }

        public virtual void testCheckInRegistrant() {
            setupUserData();
            setUpParticipation();

            PORTAL_EventManagementControllerBase controller = new PORTAL_EventManagementControllerBase();

            try {
                controller.checkInRegistrant(new Map<String,Object>{PORTAL_EventManagementControllerBase.PARTICIPATION_ID => null});
            } catch (Exception e) {

            }
            
            String returnedName = controller.checkInRegistrant(new Map<String,Object>{PORTAL_EventManagementControllerBase.PARTICIPATION_ID => participationRecord.Id});
            Assert.isTrue(String.isNotBlank(returnedName));
        }
    }

    static testMethod void testIsUserAdmin(){
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testIsUserAdmin();
    }

    static testMethod void testGetRegisteredParticipations() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testGetRegisteredParticipations();
    }

    static testMethod void testMarkParticipationAsAttended() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testMarkParticipationAsAttended();
    }

    static testMethod void testDeleteParticipationRecord() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testDeleteParticipationRecord();
    }

    static testMethod void testGetAttendeeLists() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testGetAttendeeLists();
    }

    static testMethod void testGetDegreeAndYearNeeded() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testGetDegreeAndYearNeeded();
    }

    static testMethod void testGetDocumentTitle() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testGetDocumentTitle();
    }

    static testMethod void testCheckInRegistrant() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventManagementControllerBaseTestClass().testCheckInRegistrant();
    }
}