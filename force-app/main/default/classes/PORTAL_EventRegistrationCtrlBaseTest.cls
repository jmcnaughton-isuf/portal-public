@isTest
public class PORTAL_EventRegistrationCtrlBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Listing__c newListing;
        public ucinn_portal_Ticket_Type__c newTicketType;
        public ucinn_portal_Custom_Form_Field__c formField;
        public ucinn_portal_Participation__c participationRecord;
        public ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord;
        public Map<Object, Object> objectRegistrantMap;
        public PORTAL_EventRegistrationControllerBase.EventRegistrant registrantRecord;
        public Contact con;
        public User communityUser;
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

            formField = new ucinn_portal_Custom_Form_Field__c(Field_Label__c = 'test',
                                                              Field_Type__c = 'Picklist',
                                                              Registration_Template__c = newTemplate.Id);
            formField = (ucinn_portal_Custom_Form_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => formField});
            insert formField;

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

            waitlistEntryRecord = new ucinn_portal_Event_Waitlist_Entry__c(Ticket_Type__c = newTicketType.Id,
                                                                           Number_of_Tickets_Available__c = 20,
                                                                           First_Name__c = 'Test',
                                                                           Last_Name__c = 'Test',
                                                                           Email__c = 'test@ucinnovation.com');
            waitlistEntryRecord = (ucinn_portal_Event_Waitlist_Entry__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => waitlistEntryRecord});
            insert waitlistEntryRecord;
        }

        public virtual void setUpParticipation() {
            if (newListing == null) {
                setUpEvent();
            }

            ucinn_ascendv2__Interim__c interimRecord = new ucinn_ascendv2__Interim__c();
            interimRecord = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimRecord});
            insert interimRecord;

            participationRecord = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                    Interim__c = interimRecord.Id,
                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING);
            participationRecord = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord});
            insert participationRecord;

            ucinn_portal_Registration_Session__c sessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                          Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART);

            ucinn_portal_Registration_Session__c completedSessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                                   Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED);

            sessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => sessionRecord});
            completedSessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => completedSessionRecord});

            insert new List<ucinn_portal_Registration_Session__c>{sessionRecord, completedSessionRecord};

            ucinn_portal_Ticket__c ticketRecord = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                             Number_of_Tickets__c = 10,
                                                                             Registration_Session__c = sessionRecord.Id,
                                                                             Participation__c = participationRecord.Id);

            ucinn_portal_Ticket__c ticketRecord2 = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Registration_Session__c = completedSessionRecord.Id,
                                                                              Participation__c = participationRecord.Id);

            ticketRecord = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord});
            ticketRecord2 = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord2});

            insert new List<ucinn_portal_Ticket__c>{ticketRecord, ticketRecord2};

            ucinn_portal_Registration_Add_Info__c addInfoRecord = new ucinn_portal_Registration_Add_Info__c(Participation__c = participationRecord.Id,
                                                                                                            Custom_Form_Field__c = formField.Id);

            addInfoRecord = (ucinn_portal_Registration_Add_Info__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => addInfoRecord});
            insert addInfoRecord;

        }

        public virtual void setupRegistrant() {
            Map<Object, Object> ticketObjectMap = new Map<Object, Object>{PORTAL_EventRegistrationControllerBase.TICKET_ID => 'test',
                                                                          PORTAL_EventRegistrationControllerBase.TICKET_TYPE_ID => 'test',
                                                                          PORTAL_EventRegistrationControllerBase.TICKET_DISCOUNT_ID => 'test',
                                                                          PORTAL_EventRegistrationControllerBase.PRICE_KEY => 5,
                                                                          PORTAL_EventRegistrationControllerBase.QUANTITY_KEY => '10'};
            PORTAL_EventRegistrationControllerBase.RegistrationTicket newRegistrationTicket = new PORTAL_EventRegistrationControllerBase.RegistrationTicket(ticketObjectMap);

            Map<Object, Object> addInfoMap = new Map<Object, Object>{PORTAL_EventRegistrationControllerBase.ADDITIONAL_INFO_ID => 'test',
                                                                     PORTAL_EventRegistrationControllerBase.CUSTOM_FORM_FIELD_ID => 'test',
                                                                     PORTAL_EventRegistrationControllerBase.NAME_KEY => 'test',
                                                                     PORTAL_EventRegistrationControllerBase.LABEL_KEY => 'test',
                                                                     PORTAL_EventRegistrationControllerBase.VALUE_KEY => 'test'};
            PORTAL_EventRegistrationControllerBase.RegistrationAdditionalInfo newAddInfo = new PORTAL_EventRegistrationControllerBase.RegistrationAdditionalInfo((Object)addInfoMap);

            objectRegistrantMap = new Map<Object, Object>{PORTAL_EventRegistrationControllerBase.CONTACT_ID => 'test',
                                                          PORTAL_EventRegistrationControllerBase.INTERIM_ID => 'test',
                                                          PORTAL_EventRegistrationControllerBase.PARTICIPATION_ID => 'test',
                                                          PORTAL_EventRegistrationControllerBase.FIRST_NAME => 'test',
                                                          PORTAL_EventRegistrationControllerBase.LAST_NAME => 'test',
                                                          PORTAL_EventRegistrationControllerBase.EMAIL_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.NAME_TAG => 'test',
                                                          PORTAL_EventRegistrationControllerBase.DEGREE_AND_YEAR => 'test',
                                                          PORTAL_EventRegistrationControllerBase.EMPLOYER_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.PHONE_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.STREET_1_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.STREET_2_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.CITY_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.STATE_KEY => 'test',
                                                          PORTAL_EventRegistrationControllerBase.POSTAL_CODE => 'test',
                                                          PORTAL_EventRegistrationControllerBase.IS_SEND_CONFIRMATION => true,
                                                          PORTAL_EventRegistrationControllerBase.IS_DISPLAY_ON_LOOK_WHOS_COMING_LIST => true,
                                                          PORTAL_EventRegistrationControllerBase.HAS_INTERIM => true,
                                                          PORTAL_EventRegistrationControllerBase.TICKET_LIST => new List<Object>{ticketObjectMap},
                                                          PORTAL_EventRegistrationControllerBase.ADDITIONAL_INFO_LIST => new List<Object>{addInfoMap}};

            registrantRecord = new PORTAL_EventRegistrationControllerBase.EventRegistrant(objectRegistrantMap);
        }

        public virtual void testEventRegistrant() {
            setupRegistrant();
            setUpParticipation();
            String queryString = ' SELECT ';
            String fields = ' id, Degree_And_Year__c, Interim__c, Interim__r.ucinn_ascendv2__First_Name__c, Status__c, Is_Send_Confirmation_Email__c, Is_Display_On_Look_Who_s_Coming_List__c, Name_Tag__c,'
                          + ' Interim__r.ucinn_ascendv2__Last_Name__c, Interim__r.ucinn_ascendv2__Email_1__c, '
                          + ' Interim__r.ucinn_ascendv2__Phone_1__c, Interim__r.ucinn_ascendv2__Employer__c, '
                          + ' Interim__r.ucinn_ascendv2__Address_1_Line_1__c, Interim__r.ucinn_ascendv2__Address_1_Line_2__c, Interim__r.ucinn_ascendv2__City_1__c, '
                          + ' Interim__r.ucinn_ascendv2__State_1__c, Interim__r.ucinn_ascendv2__Country_1__c, '
                          + ' Interim__r.ucinn_ascendv2__Postal_Code_1__c, Contact__r.FirstName, Contact__r.LastName, '
                          + ' Contact__r.Email, Contact__r.Phone, Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_State__c, Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                          + ' (SELECT id, Number_of_Tickets__c, Ticket_Type__c, Ticket_Type__r.Name, Ticket_Type__r.Max_Tickets_Per_Registrant__c, Price_Per_Ticket__c, Ticket_Discount__c, Registration_Session__r.Status__c, Status__c '
                          + '  FROM ucinn_portal_Tickets_Participation__r WHERE Is_Valid_Ticket__c = true), '
                          + ' (SELECT id, Name, Value__c, Custom_Form_Field__c, Custom_Form_Field__r.Name, Custom_Form_Field__r.Field_Label__c, Custom_Form_Field__r.Is_Required__c '
                          + '  FROM ucinn_portal_Registration_Add_Infos__r) ';

            queryString = queryString + fields + ' FROM ucinn_portal_Participation__c LIMIT 1';
            List<ucinn_portal_Participation__c> participationList = Database.query(queryString);
            registrantRecord = new PORTAL_EventRegistrationControllerBase.EventRegistrant(participationList.get(0));
        }


        public virtual void testInitEventRegistration() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            controller.initEventRegistration(null);
            controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => null});
            setUpEvent();
            controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id});
            controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                     PORTAL_EventRegistrationControllerBase.WAITLIST_ENTRY_ID => waitlistEntryRecord.Id});
            setupUserData();
            setUpParticipation();
            System.runAs(communityUser) {
                controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id});
                controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                         PORTAL_EventRegistrationControllerBase.IS_WALK_IN => true});
            }

            participationRecord.Purchasing_Constituent__c = con.Id;
            participationRecord.Contact__c = con.Id;
            update participationRecord;

            System.runAs(communityUser) {
                controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id});
            }

            participationRecord.Interim__c = null;
            update participationRecord;
            System.runAs(communityUser) {
                controller.initEventRegistration(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id});
            }
        }

        public virtual void testGetPromoCodeDiscount() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            controller.getPromoCodeDiscount(null);
            setUpEvent();
            controller.getPromoCodeDiscount(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id});
            controller.getPromoCodeDiscount(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.PROMO_CODE => 'testPromo'});
            ucinn_portal_Ticket_Discount__c newDiscount = new ucinn_portal_Ticket_Discount__c(Ticket_Type__c = newTicketType.Id,
                                                                                              Adjusted_Price__c = 15,
                                                                                              Discount_Type__c = 'Price',
                                                                                              Promo_Code__c = 'testPromo');

            newDiscount = (ucinn_portal_Ticket_Discount__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDiscount});
            insert newDiscount;
            controller.getPromoCodeDiscount(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.PROMO_CODE => 'testPromo'});
        }

        public virtual void testRegisterParticipants() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            try {
                controller.registerParticipants(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpEvent();
            setupRegistrant();
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.PARTICIPATION_ID, null);
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.CONTACT_ID, null);
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.INTERIM_ID, null);
            Map<Object, Object> ticketObjectMap = new Map<Object, Object>{PORTAL_EventRegistrationControllerBase.TICKET_TYPE_ID => newTicketType.Id,
                                                                          PORTAL_EventRegistrationControllerBase.PRICE_KEY => 5,
                                                                          PORTAL_EventRegistrationControllerBase.QUANTITY_KEY => '10'};

            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.TICKET_LIST, new List<Object>{ticketObjectMap});
            Map<Object, Object> addInfoMap = new Map<Object, Object>{PORTAL_EventRegistrationControllerBase.CUSTOM_FORM_FIELD_ID => formField.Id,
                                                                     PORTAL_EventRegistrationControllerBase.NAME_KEY => 'test',
                                                                     PORTAL_EventRegistrationControllerBase.LABEL_KEY => 'test',
                                                                     PORTAL_EventRegistrationControllerBase.VALUE_KEY => 'test'};
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.ADDITIONAL_INFO_LIST, new List<Object>{addInfoMap});

            controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap, objectRegistrantMap},
                                                                    PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie'});

            controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap, objectRegistrantMap},
                                                                    PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie',
                                                                    PORTAL_EventRegistrationControllerBase.WAITLIST_ENTRY_ID => waitlistEntryRecord.Id});

            controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap},
                                                                    PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie',
                                                                    PORTAL_EventRegistrationControllerBase.IS_WALK_IN => true,
                                                                    PORTAL_EventRegistrationControllerBase.PAYMENT_METHOD => 'Cash'});

            controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap},
                                                                    PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie',
                                                                    PORTAL_EventRegistrationControllerBase.IS_WALK_IN => true,
                                                                    PORTAL_EventRegistrationControllerBase.PAYMENT_METHOD => PORTAL_EventRegistrationControllerBase.CREDIT_CARD_ONLINE});
                
            controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap, objectRegistrantMap},
                                                                    PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie',
                                                                    PORTAL_EventRegistrationControllerBase.IS_WALK_IN => true});

            newListing.Is_Non_Ticketed_Event__c = true;

            update newListing;
            controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap},
                                                                    PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                    PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie',
                                                                    PORTAL_EventRegistrationControllerBase.IS_WALK_IN => true,
                                                                    PORTAL_EventRegistrationControllerBase.PAYMENT_METHOD => PORTAL_EventRegistrationControllerBase.CREDIT_CARD_ONLINE});

        }

        public virtual void testHandleRegistrationRecordDeletion() {
            setUpParticipation();
            ucinn_portal_Participation__c guestParticipation = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                                                 Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING,
                                                                                                 Primary_Participation__c = participationRecord.Id);

            guestParticipation = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => guestParticipation});
            insert guestParticipation;

            String queryString = ' SELECT ';
            String fields = ' id, Degree_And_Year__c, Interim__c, Interim__r.ucinn_ascendv2__First_Name__c, Status__c, Is_Send_Confirmation_Email__c, Is_Display_On_Look_Who_s_Coming_List__c, Name_Tag__c,'
                          + ' Interim__r.ucinn_ascendv2__Last_Name__c, Interim__r.ucinn_ascendv2__Email_1__c, '
                          + ' Interim__r.ucinn_ascendv2__Phone_1__c, Interim__r.ucinn_ascendv2__Employer__c, '
                          + ' Interim__r.ucinn_ascendv2__Address_1_Line_1__c, Interim__r.ucinn_ascendv2__Address_1_Line_2__c, Interim__r.ucinn_ascendv2__City_1__c, '
                          + ' Interim__r.ucinn_ascendv2__State_1__c, Interim__r.ucinn_ascendv2__Country_1__c, '
                          + ' Interim__r.ucinn_ascendv2__Postal_Code_1__c, Contact__r.FirstName, Contact__r.LastName, '
                          + ' Contact__r.Email, Contact__r.Phone, Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_State__c, Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                          + ' (SELECT id, Number_of_Tickets__c, Ticket_Type__c, Ticket_Type__r.Name, Ticket_Type__r.Max_Tickets_Per_Registrant__c, Price_Per_Ticket__c, Ticket_Discount__c, Registration_Session__r.Status__c, Status__c '
                          + '  FROM ucinn_portal_Tickets_Participation__r), '
                          + ' (SELECT id, Name, Value__c, Custom_Form_Field__c, Custom_Form_Field__r.Name, Custom_Form_Field__r.Field_Label__c, Custom_Form_Field__r.Is_Required__c '
                          + '  FROM ucinn_portal_Registration_Add_Infos__r) ';

            queryString = queryString + fields + ' FROM ucinn_portal_Participation__c WHERE id = \'' + participationRecord.Id + '\' LIMIT 1';
            List<ucinn_portal_Participation__c> participationList = Database.query(queryString);

            registrantRecord = new PORTAL_EventRegistrationControllerBase.EventRegistrant(participationList.get(0));
            PORTAL_EventRegistrationControllerBase.handleRegistrationRecordDeletion(new List<ucinn_portal_Participation__c>{participationList.get(0), guestParticipation},
                                                                                    new List<PORTAL_EventRegistrationControllerBase.EventRegistrant>{registrantRecord});
        }

        public virtual void testValidateRegistrants() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            controller.validateRegistrants(null);
            controller.validateRegistrants(new Map<String, Object>{'test' => 'test'});
        }

        public virtual void testFormatDegreeAndYears() {
            setupUserData();

            PORTAL_EventRegistrationControllerBase.formatDegreeAndYears(null);
            PORTAL_EventRegistrationControllerBase.formatDegreeAndYears(new List<ucinn_ascendv2__Degree_Information__c>());

            ucinn_ascendv2__Post_Code__c postCode = new ucinn_ascendv2__Post_Code__c(ucinn_ascendv2__Degree__c = 'AB');
            postCode = (ucinn_ascendv2__Post_Code__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => postCode});
            insert postCode;
            ucinn_ascendv2__Degree_Information__c newDegree = new ucinn_ascendv2__Degree_Information__c(ucinn_ascendv2__Contact__c = con.Id,
                                                                                                        ucinn_ascendv2__Post_Code__c = postCode.Id,
                                                                                                        ucinn_ascendv2__Conferred_Degree_Year__c = '2013');
            newDegree = (ucinn_ascendv2__Degree_Information__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDegree});
            insert newDegree;

            List<ucinn_ascendv2__Degree_Information__c> degreeList = [SELECT id, ucinn_ascendv2__Conferred_Degree_Year__c, ucinn_ascendv2__Major_Degree_Short_Formula__c
                                                                      FROM ucinn_ascendv2__Degree_Information__c];

            PORTAL_EventRegistrationControllerBase.formatDegreeAndYears(new List<ucinn_ascendv2__Degree_Information__c>{
                new ucinn_ascendv2__Degree_Information__c(),
                degreeList.get(0),
                degreeList.get(0)
            });
        }

        public virtual void testCreateReceiptRecordForWalkIns() {
            PORTAL_EventRegistrationControllerBase.createReceiptRecordForWalkIns(null, null);

            setUpParticipation();

            String queryString = ' SELECT ';
            String fields = ' id, Degree_And_Year__c, Interim__c, Interim__r.ucinn_ascendv2__First_Name__c, Status__c, Is_Send_Confirmation_Email__c, Is_Display_On_Look_Who_s_Coming_List__c, Name_Tag__c,'
                          + ' Interim__r.ucinn_ascendv2__Last_Name__c, Interim__r.ucinn_ascendv2__Email_1__c, '
                          + ' Interim__r.ucinn_ascendv2__Phone_1__c, Interim__r.ucinn_ascendv2__Employer__c, '
                          + ' Interim__r.ucinn_ascendv2__Address_1_Line_1__c, Interim__r.ucinn_ascendv2__Address_1_Line_2__c, Interim__r.ucinn_ascendv2__City_1__c, '
                          + ' Interim__r.ucinn_ascendv2__State_1__c, Interim__r.ucinn_ascendv2__Country_1__c, '
                          + ' Interim__r.ucinn_ascendv2__Postal_Code_1__c, Contact__r.FirstName, Contact__r.LastName, '
                          + ' Contact__r.Email, Contact__r.Phone, Contact__r.ucinn_ascendv2__Preferred_Address_Line_1__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_Line_2__c, Contact__r.ucinn_ascendv2__Preferred_Address_City__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_State__c, Contact__r.ucinn_ascendv2__Preferred_Address_Country__c, '
                          + ' Contact__r.ucinn_ascendv2__Preferred_Address_Postal_Code__c, '
                          + ' (SELECT id, Number_of_Tickets__c, Ticket_Type__c, Ticket_Type__r.Name, Ticket_Type__r.Max_Tickets_Per_Registrant__c, Price_Per_Ticket__c, Ticket_Discount__c, Registration_Session__r.Status__c, Status__c '
                          + '  FROM ucinn_portal_Tickets_Participation__r), '
                          + ' (SELECT id, Name, Value__c, Custom_Form_Field__c, Custom_Form_Field__r.Name, Custom_Form_Field__r.Field_Label__c, Custom_Form_Field__r.Is_Required__c '
                          + '  FROM ucinn_portal_Registration_Add_Infos__r) ';

            queryString = queryString + fields + ' FROM ucinn_portal_Participation__c WHERE id = \'' + participationRecord.Id + '\' LIMIT 1';
            List<ucinn_portal_Participation__c> participationList = Database.query(queryString);

            registrantRecord = new PORTAL_EventRegistrationControllerBase.EventRegistrant(participationList.get(0));
            PORTAL_EventRegistrationControllerBase.createReceiptRecordForWalkIns(new List<PORTAL_EventRegistrationControllerBase.EventRegistrant>{registrantRecord}, 'Cash');

            registrantRecord.ticketList.get(0).price = 10;
            PORTAL_EventRegistrationControllerBase.createReceiptRecordForWalkIns(new List<PORTAL_EventRegistrationControllerBase.EventRegistrant>{registrantRecord}, 'Cash');

            registrantRecord.ticketList = null;
            PORTAL_EventRegistrationControllerBase.createReceiptRecordForWalkIns(new List<PORTAL_EventRegistrationControllerBase.EventRegistrant>{registrantRecord}, 'Cash');
        }

        public virtual void getTicketTypeIdToTicketTypeMap() {
            setUpEvent();
            PORTAL_EventRegistrationControllerBase.getTicketTypeIdToTicketTypeMap(null);
            PORTAL_EventRegistrationControllerBase.getTicketTypeIdToTicketTypeMap(newListing.Id);
            delete newTicketType;
            PORTAL_EventRegistrationControllerBase.getTicketTypeIdToTicketTypeMap(newListing.Id);
        }

        public virtual void testGetRegistrationTemplate() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            setUpEvent();
            controller.getRegistrationTemplate(null);

            controller.getRegistrationTemplate(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.TEMPLATE_ID => null});
            controller.getRegistrationTemplate(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.TEMPLATE_ID => newListing.Registration_Template__c});
        }

        public virtual void testCreateFormattedDateString() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            controller.createFormattedDateString('2022-04-10 00:00:00', null);
            controller.createFormattedDateString('2022-04-10 00:00:00', '(GMT–04:00) Eastern Daylight Time (America/Indiana/Indianapolis)');
        }

        public virtual void testRegisterWithStaleRecords() {
            PORTAL_EventRegistrationControllerBase controller = new PORTAL_EventRegistrationControllerBase();

            setupUserData();
            setUpEvent();
            setupRegistrant();
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.CONTACT_ID, communityUser.ContactId);
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.PARTICIPATION_ID, null);
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.HAS_INTERIM, false);
            objectRegistrantMap.put(PORTAL_EventRegistrationControllerBase.ADDITIONAL_INFO_LIST, new List<Object>());
            Map<Object, Object> ticketMap = (Map<Object, Object>) ((List<Object>) objectRegistrantMap.get(PORTAL_EventRegistrationControllerBase.TICKET_LIST))[0];
            ticketMap.put(PORTAL_EventRegistrationControllerBase.TICKET_TYPE_ID, newTicketType.Id);
            ticketMap.put(PORTAL_EventRegistrationControllerBase.TICKET_ID, null);
            ticketMap.put(PORTAL_EventRegistrationControllerBase.TICKET_DISCOUNT_ID, null);

            Test.startTest();

            System.runAs(communityUser) {
                // get tickets normally
                Map<String, Object> results = controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap},
                                                                        PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                        PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie'});

                System.assert(String.isBlank((String) results.get(PORTAL_EventRegistrationControllerBase.EXISTING_PRIMARY_PARTICIPATION_STATUS)));

                // repeat the same call using a registrant whose primary participation is now outdated, make sure there is still 1 primary participation after
                results = controller.registerParticipants(new Map<String, Object>{PORTAL_EventRegistrationControllerBase.REGISTRANT_LIST => new List<Object>{objectRegistrantMap},
                                                                        PORTAL_EventRegistrationControllerBase.LISTING_ID => newListing.Id,
                                                                        PORTAL_EventRegistrationControllerBase.SESSION_ID => 'testCookie'});
                System.assertEquals(PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING, results.get(PORTAL_EventRegistrationControllerBase.EXISTING_PRIMARY_PARTICIPATION_STATUS));
            }

            Test.stopTest();

            List<ucinn_portal_Participation__c> primaryParticipationList = [SELECT Id FROM ucinn_portal_Participation__c 
                                                                            WHERE Purchasing_Constituent__c = :communityUser.ContactId AND Primary_Participation__c = null AND Listing__c = :newListing.Id];
            System.assertEquals(1, primaryParticipationList.size());
        }
    }

    static testMethod void testEventRegistrant() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testEventRegistrant();
    }


    static testMethod void testInitEventRegistration() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testInitEventRegistration();
    }

    static testMethod void testGetPromoCodeDiscount() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testGetPromoCodeDiscount();
    }

    static testMethod void testRegisterParticipants() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testRegisterParticipants();
    }

    static testMethod void testHandleRegistrationRecordDeletion() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testHandleRegistrationRecordDeletion();
    }

    static testMethod void testValidateRegistrants() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testValidateRegistrants();
    }

    static testMethod void testFormatDegreeAndYears() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testFormatDegreeAndYears();
    }

    static testMethod void testCreateReceiptRecordForWalkIns() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testCreateReceiptRecordForWalkIns();
    }

    static testMethod void getTicketTypeIdToTicketTypeMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().getTicketTypeIdToTicketTypeMap();
    }

    static testMethod void testGetRegistrationTemplate() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testGetRegistrationTemplate();
    }

    static testMethod void testCreateFormattedDateString() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testCreateFormattedDateString();
    }

    static testMethod void testRegisterWithStaleRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventRegistrationCtrlBaseTestClass().testRegisterWithStaleRecords();
    }
}