@isTest
public class PORTAL_ShoppingCartControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Listing__c newListing;
        public ucinn_portal_Ticket_Type__c newTicketType;
        public ucinn_portal_Registration_Session__c sessionRecord;
        public ucinn_portal_Registration_Session__c completedSessionRecord;

        public ucinn_ascendv2__Interim__c interimRecord;
        public Contact contactRecord;
        public User communityUser;
        public ucinn_portal_Participation__c participationRecord;
        public ucinn_portal_Participation__c participationRecord2;

        public String cookieId = '4783912350050510501015';
        public String cookieId2 = '350050510501015';
        public String cookieId3 = '69499929292';
        public String cookieIdInvalid = '5190480194810';

        public String testFirstName = 'Test';
        public String testLastName = 'Person';
        public String testEmail = 'test@test.com';

        public String testAddress = '222 test';

        public String testChargeId = '58390192380131';
        public Decimal testStripeChargeAmount = 200;
        public String testStripePaymentMethod = 'Stripe';
        public Map<Object, Object> testRegistrantInfo;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpEvent() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            newListing = new ucinn_portal_Listing__c(Name = 'Test Event',
                                                     Header_Content__c = 'This is a Test.',
                                                     RecordTypeId = recordTypeId,
                                                     Status__c = 'Published',
                                                     Email_Confirmation_Details__c = 'Test',
                                                     Event_Actual_Start_Date_Time__c = '2021-01-30 00:00:00',
                                                     Time_Zone__c = '(GMT–05:00) Central Daylight Time (America/Chicago)');

            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            newTicketType = new ucinn_portal_Ticket_Type__c(Listing__c = newListing.Id, Price__c = 5);
            newTicketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTicketType});
            insert newTicketType;
        }

        public virtual void setUpInterim() {
            interimRecord = new ucinn_ascendv2__Interim__c(ucinn_ascendv2__Email_1__c = testEmail,
                                                            ucinn_ascendv2__First_Name__c = testFirstName,
                                                            ucinn_ascendv2__Last_Name__c = testLastName,
                                                            ucinn_ascendv2__Address_1_Line_1__c = testAddress,
                                                            ucinn_ascendv2__Address_1_Line_2__c = testAddress,
                                                            ucinn_ascendv2__City_1__c = testAddress,
                                                            ucinn_ascendv2__State_1__c = testAddress,
                                                            ucinn_ascendv2__Country_1__c = testAddress,
                                                            ucinn_ascendv2__Postal_Code_1__c = testAddress);

            interimRecord = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimRecord});
            insert interimRecord;
        }

        public virtual void setUpContact() {
            contactRecord = new Contact(Email = testEmail,
                                        FirstName = testFirstName,
                                        LastName = testLastName,
                                        ucinn_ascendv2__Preferred_Address_Line_1__c = testAddress,
                                        ucinn_ascendv2__Preferred_Address_Line_2__c = testAddress,
                                        ucinn_ascendv2__Preferred_Address_City__c = testAddress,
                                        ucinn_ascendv2__Preferred_Address_State__c = testAddress,
                                        ucinn_ascendv2__Preferred_Address_Country__c = testAddress,
                                        ucinn_ascendv2__Preferred_Address_Postal_Code__c = testAddress,
                                        ucinn_portal_Is_Display_On_Portal__c = true);

            contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
            insert contactRecord;
        }

        public virtual void setUpParticipation() {
            if (newListing == null) {
                setUpEvent();
            }

            if (interimRecord == null) {
                setUpInterim();
            }

            participationRecord = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                    Interim__c = interimRecord.Id,
                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING);

            participationRecord = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord});
            insert new List<ucinn_portal_Participation__c>{participationRecord};

            sessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                          Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                                          Session_Id__c = cookieId);

            completedSessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                                   Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED,
                                                                                                                   Session_Id__c = cookieId);

            sessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => sessionRecord});
            completedSessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => completedSessionRecord});
            insert new List<ucinn_portal_Registration_Session__c>{sessionRecord, completedSessionRecord};

            ucinn_portal_Ticket__c ticketRecord = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                             Number_of_Tickets__c = 10,
                                                                             Price_Per_Ticket__c = 20,
                                                                             Registration_Session__c = sessionRecord.Id,
                                                                             Participation__c = participationRecord.Id);

            ucinn_portal_Ticket__c ticketRecord2 = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Price_Per_Ticket__c = 20,
                                                                              Registration_Session__c = completedSessionRecord.Id,
                                                                              Participation__c = participationRecord.Id);

            ticketRecord = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord});
            ticketRecord2 = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord2});
            insert new List<ucinn_portal_Ticket__c>{ticketRecord, ticketRecord2};
        }

        public virtual void setUpModificationParticipation() {
            if (newListing == null) {
                setUpEvent();
            }

            if (interimRecord == null) {
                setUpInterim();
            }

            if (contactRecord == null) {
                setUpContact();
            }

            participationRecord2 = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                     Interim__c = interimRecord.Id,
                                                                     Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED);

            ucinn_portal_Participation__c guestOfParticipation2 = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                                                    Contact__c = contactRecord.Id,
                                                                                                    Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING,
                                                                                                    Primary_Participation__c = participationRecord2.Id,
                                                                                                    Is_Send_Confirmation_Email__c = true);

            participationRecord2 = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participationRecord2});
            guestOfParticipation2 = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => guestOfParticipation2});
            insert participationRecord2;
            insert guestOfParticipation2;

            ucinn_portal_Registration_Session__c modifiedSessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                                 Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT,
                                                                                                                 Session_Id__c = cookieId2);

            modifiedSessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => modifiedSessionRecord});
            insert modifiedSessionRecord;

            ucinn_portal_Ticket__c ticketRecord3 = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Price_Per_Ticket__c = 20,
                                                                              Registration_Session__c = modifiedSessionRecord.Id,
                                                                              Participation__c = participationRecord2.Id);


            ucinn_portal_Ticket__c guestTicket = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                              Number_of_Tickets__c = 10,
                                                                              Price_Per_Ticket__c = 20,
                                                                              Registration_Session__c = modifiedSessionRecord.Id,
                                                                              Participation__c = guestOfParticipation2.Id);

            ticketRecord3 = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord3});
            guestTicket = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => guestTicket});
            insert ticketRecord3;
            insert guestTicket;
        }

        public virtual void setUpEmptyInterimParticipation() {
            if (newListing == null) {
                setUpEvent();
            }

            ucinn_ascendv2__Interim__c emptyInterimRecord = new ucinn_ascendv2__Interim__c();
            emptyInterimRecord = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => emptyInterimRecord});
            insert emptyInterimRecord;

            ucinn_portal_Participation__c emptyParticipationRecord = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                                                        Interim__c = emptyInterimRecord.Id,
                                                                                                        Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING);

            emptyParticipationRecord = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => emptyParticipationRecord});
            insert emptyParticipationRecord;

            ucinn_portal_Registration_Session__c sessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                          Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                                          Session_Id__c = cookieId);

            sessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => sessionRecord});
            insert sessionRecord;

            ucinn_portal_Ticket__c ticketRecord = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                             Number_of_Tickets__c = 10,
                                                                             Price_Per_Ticket__c = 20,
                                                                             Registration_Session__c = sessionRecord.Id,
                                                                             Participation__c = emptyParticipationRecord.Id);

            ticketRecord = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord});
            insert ticketRecord;
        }

        public virtual void setUpEmptyContactParticipation() {
            if (newListing == null) {
                setUpEvent();
            }

            Contact emptyContactRecord = new Contact(LastName = testLastName);
            emptyContactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => emptyContactRecord});
            insert emptyContactRecord;

            ucinn_portal_Participation__c emptyParticipationRecord2 = new ucinn_portal_Participation__c(Listing__c = newListing.Id,
                                                                                                        Contact__c = emptyContactRecord.Id,
                                                                                                        Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED);

            emptyParticipationRecord2 = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => emptyParticipationRecord2});
            insert emptyParticipationRecord2;

            ucinn_portal_Registration_Session__c sessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                          Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                                          Session_Id__c = cookieId3);

            sessionRecord = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => sessionRecord});
            insert sessionRecord;

            ucinn_portal_Ticket__c ticketRecord = new ucinn_portal_Ticket__c(Ticket_Type__c = newTicketType.Id,
                                                                             Number_of_Tickets__c = 10,
                                                                             Price_Per_Ticket__c = 20,
                                                                             Registration_Session__c = sessionRecord.Id,
                                                                             Participation__c = emptyParticipationRecord2.Id);

            ticketRecord = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketRecord});
            insert ticketRecord;
        }

        public virtual void setupCommunityUser() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

                if (contactRecord == null) {
                    setUpContact();
                }

                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                contactRecord.AccountId = acct.Id;
                update contactRecord;

                communityUser = new User(alias = 'comUser',
                                         email = testEmail,
                                         emailencodingkey='UTF-8',
                                         lastname = testLastName,
                                         languagelocalekey='en_US',
                                         localesidkey='en_US',
                                         profileid = profileId,
                                         IsActive = true,
                                         ContactId = contactRecord.Id,
                                         timezonesidkey='America/Los_Angeles',
                                         username = System.now().millisecond() + testEmail);
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;
            }
        }

        public virtual void testGetParticipations() {
            setUpParticipation();
            setUpModificationParticipation();
            setUpEmptyInterimParticipation();
            setUpEmptyContactParticipation();

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();
            controller.getParticipationsMapInSession(null);

            controller.getParticipationsMapInSession(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => null,
                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART}
                                                                            );

            controller.getParticipationsMapInSession(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieIdInvalid,
                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART}
                                                                            );

            controller.getParticipationsMapInSession(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART}
                                                                            );

            controller.getParticipationsMapInSession(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId2,
                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT}
                                                                            );

            controller.getParticipationsMapInSession(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId3,
                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART}
                                                                            );


        }

        public virtual void testCheckForTicketsInShoppingCart() {
            setUpParticipation();

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();
            controller.checkForTicketsInShoppingCart(null);
            controller.checkForTicketsInShoppingCart(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => null});
            controller.checkForTicketsInShoppingCart(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId});
        }

        public virtual void testhandleUniquePaymentSession() {
            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            controller.handleUniquePaymentSession(null);
            controller.handleUniquePaymentSession(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId});
            setUpParticipation();
            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT});
            controller.handleUniquePaymentSession(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId});
            controller.handleUniquePaymentSession(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId});
        }

        public virtual void testGetEventConfirmationDetails() {
            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            setUpParticipation();
            participationRecord.Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_REGISTERED;
            update participationRecord;
            controller.getEventConfirmationDetails(null);
            controller.getEventConfirmationDetails(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.SESSION_ID => completedSessionRecord.Id});

        }

        public virtual void testModfiyStatusAndExtend() {
            setUpParticipation();

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            controller.modifyRegistrationStatusAndExtendExpirationDate(null);
            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => null,
                                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                            PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT});

            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieIdInvalid,
                                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                            PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT});

            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                            PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT});

            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT,
                                                                                            PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART});

            try {
                controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                            PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }
        }

        public virtual void testPaymentPageExit() {
            setUpParticipation();
            setUpModificationParticipation();

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT});

            controller.handlePaymentPageExit(null);
            controller.handlePaymentPageExit(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => null});
            controller.handlePaymentPageExit(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieIdInvalid});
            controller.handlePaymentPageExit(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId});
            controller.handlePaymentPageExit(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId2});
        }

        public virtual void testDeleteParticipation() {
            setUpParticipation();

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            try{
                controller.deleteRegistrationForEvent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try{
                controller.deleteRegistrationForEvent(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.PRIMARY_PARTICIPATION => null});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            controller.deleteRegistrationForEvent(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.PRIMARY_PARTICIPATION => participationRecord.Id});
        }

        public virtual void testChargeCreditCard() {
            setUpParticipation();

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();
            controller.modifyRegistrationStatusAndExtendExpirationDate(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                                            PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                            PORTAL_ShoppingCartControllerBase.NEXT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT});


            try{
                controller.isChargeCreditCard(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try{
                controller.isChargeCreditCard(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => null});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try{
                controller.isChargeCreditCard(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                     PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT,
                                                                     PORTAL_ShoppingCartControllerBase.AMOUNT_KEY => 5});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            controller.isChargeCreditCard(new Map<String,Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId,
                                                                PORTAL_ShoppingCartControllerBase.CURRENT_STATUS => PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_PENDING_PAYMENT,
                                                                PORTAL_ShoppingCartControllerBase.AMOUNT_KEY => 200});
        }

        public virtual void testEventPaymentCheckout() {
            setUpParticipation();
            setUpModificationParticipation();  // we test with cookieId2 and this will change ticket prices, double the amount

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            testRegistrantInfo = new Map<Object, Object>{PORTAL_ShoppingCartControllerBase.FIRST_NAME => testFirstName,
                                                         PORTAL_ShoppingCartControllerBase.LAST_NAME => testLastName,
                                                         PORTAL_ShoppingCartControllerBase.EMAIL_KEY => testEmail};

            Map<Object, Object> invalidTestRegistrantInfo = new Map<Object, Object>{PORTAL_ShoppingCartControllerBase.FIRST_NAME => null,
                                                         PORTAL_ShoppingCartControllerBase.LAST_NAME => testLastName,
                                                         PORTAL_ShoppingCartControllerBase.EMAIL_KEY => testEmail};

            try{
                controller.eventPaymentCheckout(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try{
                controller.eventPaymentCheckout(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => null,
                                                                        PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => testChargeId,
                                                                        PORTAL_CONST_OnlineGiving.AMOUNT_KEY => testStripeChargeAmount,
                                                                        PORTAL_ShoppingCartControllerBase.PAYMENT_METHOD => testStripePaymentMethod,
                                                                        PORTAL_ShoppingCartControllerBase.REGISTRANT_INFORMATION => testRegistrantInfo});

            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try{
                controller.eventPaymentCheckout(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId2,
                                                                        PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => testChargeId,
                                                                        PORTAL_CONST_OnlineGiving.AMOUNT_KEY => testStripeChargeAmount * 2,
                                                                        PORTAL_ShoppingCartControllerBase.PAYMENT_METHOD => testStripePaymentMethod,
                                                                        PORTAL_ShoppingCartControllerBase.REGISTRANT_INFORMATION => invalidTestRegistrantInfo});

            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }


            controller.eventPaymentCheckout(new Map<String, Object>{PORTAL_ShoppingCartControllerBase.COOKIE_ID => cookieId2,
                                                                    PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => testChargeId,
                                                                    PORTAL_CONST_OnlineGiving.AMOUNT_KEY => testStripeChargeAmount * 2,
                                                                    PORTAL_ShoppingCartControllerBase.PAYMENT_METHOD => testStripePaymentMethod,
                                                                    PORTAL_ShoppingCartControllerBase.REGISTRANT_INFORMATION => testRegistrantInfo});

        }

        public virtual void testCompleteEventPaymentCheckout() {
            setupContact();
            setUpParticipation();
            
            sessionRecord.Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION;
            completedSessionRecord.Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_AWAITING_GATEWAY_CONFIRMATION;
            update new List<ucinn_portal_Registration_Session__c>{sessionRecord, completedSessionRecord};

            Map<String, Object> successParams = new Map<String, Object>{
                PORTAL_ShoppingCartControllerBase.REGISTRANT_INFORMATION => new Map<String, Object>{
                    PORTAL_ShoppingCartControllerBase.FIRST_NAME => testFirstName,
                    PORTAL_ShoppingCartControllerBase.LAST_NAME => testLastName,
                    PORTAL_ShoppingCartControllerBase.EMAIL_KEY => testEmail
                },
                PORTAL_CONST_OnlineGiving.PAYMENT_ID_KEY => testChargeId,
                PORTAL_ShoppingCartControllerBase.AMOUNT_KEY => testStripeChargeAmount,
                PORTAL_ShoppingCartControllerBase.SESSION_ID => sessionRecord.Id,
                PORTAL_StripeWebhookBase.CONTACT_ID => contactRecord.Id,
                PORTAL_PaymentHubControllerBase.PAGE_NAME => 'Event Payment Form'
            };

            Map<String, Object> failureParams = new Map<String, Object>{
                PORTAL_StripeWebhookBase.IS_FAILURE => true,
                PORTAL_ShoppingCartControllerBase.SESSION_ID => completedSessionRecord.Id
            };

            PORTAL_ShoppingCartControllerBase controller = new PORTAL_ShoppingCartControllerBase();

            Test.startTest();
            controller.completeEventPaymentCheckout(null);
            controller.completeEventPaymentCheckout(successParams);
            controller.completeEventPaymentCheckout(failureParams);
            // Run again for early return code coverage
            controller.completeEventPaymentCheckout(successParams);
            controller.completeEventPaymentCheckout(failureParams);
            Test.stopTest();

            List<ucinn_portal_Receipt__c> receiptList = [SELECT Id FROM ucinn_portal_Receipt__c];
            System.assertEquals(1, receiptList.size());
            
            List<ucinn_portal_Registration_Session__c> registrationSessionList = [SELECT Id, Status__c FROM ucinn_portal_Registration_Session__c];
            System.assertEquals(1, registrationSessionList.size());
            System.assertEquals(PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED, registrationSessionList.get(0).Status__c);
        }
    }

    static testMethod void testGetParticipations() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testGetParticipations();
    }

    static testMethod void testCheckForTicketsInShoppingCart() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testCheckForTicketsInShoppingCart();
    }

    static testMethod void testhandleUniquePaymentSession() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testhandleUniquePaymentSession();
    }

    static testMethod void testGetEventConfirmationDetails() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testGetEventConfirmationDetails();

    }

    static testMethod void testModfiyStatusAndExtend() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testModfiyStatusAndExtend();

    }

    static testMethod void testPaymentPageExit() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testPaymentPageExit();
    }

    static testMethod void testDeleteParticipation() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testDeleteParticipation();
    }

    static testMethod void testChargeCreditCard() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testChargeCreditCard();
    }

    static testMethod void testEventPaymentCheckout() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testEventPaymentCheckout();
    }

    /**
     * test complete event payment checkout used in Stripe webhook 
     * @author Jacob Huang
     * @since 1.3
     */
    static testMethod void testCompleteEventPaymentCheckout() {
        PORTAL_TestClassFactory.getTestClassFactory().getShoppingCartControllerBaseTestClass().testCompleteEventPaymentCheckout();
    }
}