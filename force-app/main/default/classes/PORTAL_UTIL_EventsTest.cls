@isTest
public class PORTAL_UTIL_EventsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Listing__c newListing;
        public ucinn_portal_Ticket_Type__c newTicketType;
        public ucinn_portal_Custom_Form_Field__c formField;
        public ucinn_portal_Participation__c participationRecord;
        public ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord;
        public Map<Object, Object> objectRegistrantMap;
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

            ucinn_portal_Ticket_Discount__c newDiscount = new ucinn_portal_Ticket_Discount__c(Ticket_Type__c = newTicketType.Id,
                                                                                              Adjusted_Price__c = 15,
                                                                                              Discount_Type__c = 'Price',
                                                                                              Promo_Code__c = 'testPromo');

            ucinn_portal_Ticket_Discount__c newDiscount2 = new ucinn_portal_Ticket_Discount__c(Ticket_Type__c = newTicketType.Id,
                                                                                               Adjusted_Price__c = 15,
                                                                                               Discount_Type__c = 'Price',
                                                                                               Promo_Code__c = 'testPromo2');

            newDiscount = (ucinn_portal_Ticket_Discount__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDiscount});
            newDiscount2 = (ucinn_portal_Ticket_Discount__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newDiscount2});
            insert new List<ucinn_portal_Ticket_Discount__c>{newDiscount, newDiscount2};

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

            ucinn_portal_Registration_Session__c sessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(-15),
                                                                                                          Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                                                                                                          Session_Id__c = 'cookie');

            ucinn_portal_Registration_Session__c completedSessionRecord = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                                                                                                                   Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_COMPLETED,
                                                                                                                   Session_Id__c = 'cookie');

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

        public virtual void testGetDiscountFromPromoCodes() {
            PORTAL_UTIL_Events.getDiscountFromPromoCodes(null);
            PORTAL_UTIL_Events.getDiscountFromPromoCodes(new Map<String, Object>{'test' => 'test'});
            PORTAL_UTIL_Events.getDiscountFromPromoCodes(new Map<String, Object>{PORTAL_UTIL_Events.PROMO_CODE_LIST => new List<String>{'test'}});

            setUpEvent();
            PORTAL_UTIL_Events.getDiscountFromPromoCodes(new Map<String, Object>{PORTAL_UTIL_Events.PROMO_CODE_LIST => new List<String>{'testPromo'}});
        }

        public virtual void testIsListingHasPromoCodes() {
            PORTAL_UTIL_Events.isListingHasPromoCodes(null);
            PORTAL_UTIL_Events.isListingHasPromoCodes(new Map<String, Object>{'test' => 'test'});
            setUpEvent();
            PORTAL_UTIL_Events.isListingHasPromoCodes(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID => newListing.Id});
            PORTAL_UTIL_Events.isListingHasPromoCodes(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID => null});
        }

        public virtual void testGetDiscountedPrice() {
            PORTAL_UTIL_Events.getDiscountedPrice(null);
            PORTAL_UTIL_Events.getDiscountedPrice(new Map<String, Object>{PORTAL_UTIL_Events.DISCOUNT_RECORD => null});
            setUpEvent();
            List<ucinn_portal_Ticket_Discount__c> discountList = PORTAL_UTIL_Events.getTicketDiscountList(null, null, null, null);
            PORTAL_UTIL_Events.getDiscountedPrice(new Map<String, Object>{PORTAL_UTIL_Events.DISCOUNT_RECORD => discountList.get(0)});
            discountList.get(0).Discount_Type__c = 'Free';
            PORTAL_UTIL_Events.getDiscountedPrice(new Map<String, Object>{PORTAL_UTIL_Events.DISCOUNT_RECORD => discountList.get(0)});
            discountList.get(0).Discount_Type__c = 'Percentage';
            discountList.get(0).Discount_Percentage__c = .20;
            PORTAL_UTIL_Events.getDiscountedPrice(new Map<String, Object>{PORTAL_UTIL_Events.DISCOUNT_RECORD => discountList.get(0)});
            discountList.get(0).Discount_Percentage__c = null;
            PORTAL_UTIL_Events.getDiscountedPrice(new Map<String, Object>{PORTAL_UTIL_Events.DISCOUNT_RECORD => discountList.get(0)});
            discountList.get(0).Discount_Type__c = '';
            PORTAL_UTIL_Events.getDiscountedPrice(new Map<String, Object>{PORTAL_UTIL_Events.DISCOUNT_RECORD => discountList.get(0)});
        }

        public virtual void testGetAvailableTicketsForListing() {
            PORTAL_UTIL_Events.getAvailableTicketsForListing(null);
            setUpEvent();
            PORTAL_UTIL_Events.getAvailableTicketsForListing(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID => newListing.Id});
            setUpParticipation();
            PORTAL_UTIL_Events.getAvailableTicketsForListing(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID => newListing.Id});
            newTicketType.Total_Number_of_Tickets__c = 10;
            update newTicketType;
            newListing.Maximum_Number_of_Enrollment__c = 10;
            update newListing;
            PORTAL_UTIL_Events.getAvailableTicketsForListing(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID => newListing.Id});
        }

        public virtual void testGetTicketAvailabilityForListings() {
            PORTAL_UTIL_Events.getTicketAvailabilityForListings(null);
            PORTAL_UTIL_Events.getTicketAvailabilityForListings(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID_SET => new Set<String>()});
            PORTAL_UTIL_Events.getTicketAvailabilityForListings(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID_SET => new Set<String>{'test'}});
            setUpEvent();
            setUpParticipation();
            newListing.Maximum_Number_of_Enrollment__c = 10;
            update newListing;
            PORTAL_UTIL_Events.getTicketAvailabilityForListings(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID_SET => new Set<String>{newListing.Id}});
        }

        public virtual void testGetTicketTypeIdToDiscountMapFromListingId() {
            PORTAL_UTIL_Events.getTicketTypeIdToDiscountMapFromListingId(null);
            setUpEvent();
            PORTAL_UTIL_Events.getTicketTypeIdToDiscountMapFromListingId(new Map<String, Object>{PORTAL_UTIL_Events.LISTING_ID => newListing.Id});
        }

        public virtual void testGetTicketTypeDiscountsForConstituent() {
            PORTAL_UTIL_Events.getTicketTypeDiscountsForConstituent(null);
            setUpEvent();
            setupUserData();
            PORTAL_UTIL_Events.getTicketTypeDiscountsForConstituent(new Map<String, Object>{'test' => 'test'});
            PORTAL_UTIL_Events.getTicketTypeDiscountsForConstituent(new Map<String, Object>{PORTAL_UTIL_Events.TICKET_TYPE_ID_SET => new Set<String>{newTicketType.Id},
                                                                                            PORTAL_UTIL_Events.CONTACT_ID => con.Id});
        }

        public virtual void testGetAvailableTicketsForTicketTypes() {
            PORTAL_UTIL_Events.getAvailableTicketsForTicketTypes(null);
            PORTAL_UTIL_Events.getAvailableTicketsForTicketTypes(new Map<String, Object>{'test' => 'test'});
            setUpEvent();
            newTicketType.Total_Number_of_Tickets__c = 10;
            update newTicketType;

            PORTAL_UTIL_Events.getAvailableTicketsForTicketTypes(new Map<String, Object>{PORTAL_UTIL_Events.TICKET_TYPE_ID_SET => new Set<String>{newTicketType.Id}});
            PORTAL_UTIL_Events.getAvailableTicketsForTicketTypes(new Map<String, Object>{PORTAL_UTIL_Events.TICKET_TYPE_ID_SET => new Set<String>{newListing.Id}});
        }

        public virtual void testEmailWaitlistEntryList() {
            PORTAL_UTIL_Events.emailWaitlistEntryList(null);
            PORTAL_UTIL_Events.emailWaitlistEntryList(new Map<String, Object>{'test' => 'test'});
            setUpEvent();

            PORTAL_UTIL_Events.emailWaitlistEntryList(new Map<String, Object>{
                PORTAL_UTIL_Events.WAITLIST_ENTRY_LIST => new List<ucinn_portal_Event_Waitlist_Entry__c>{waitlistEntryRecord},
                PORTAL_UTIL_Events.MERGE_FIELD_TO_WAITLIST_ENTRY_FIELD_MAP => PORTAL_TRIG_EventWaitlistEntryHandler.mergeFieldToWaitlistEntryFieldMap,
                PORTAL_UTIL_Events.EMAIL_TEMPLATE_NAME => 'Portal_Event_Waitlist_Available'
            });
        }

        public virtual void testGetEventAvailability() {
            setUpEvent();
            PORTAL_UTIL_Events.getEventAvailability(null);
            PORTAL_UTIL_Events.getEventAvailability(new Set<String>{newListing.Id});
        }

        public virtual void testGetGuestSessionPrimaryParticipationForListings() {
            setUpParticipation();

            ucinn_ascendv2__Interim__c interimRecord = new ucinn_ascendv2__Interim__c();
            interimRecord = (ucinn_ascendv2__Interim__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => interimRecord});
            insert interimRecord;

            ucinn_portal_Participation__c participation = new ucinn_portal_Participation__c(
                Listing__c = newListing.Id,
                Interim__c = interimRecord.Id,
                Status__c = PORTAL_CONST_Events.PARTICIPATION_STATUS_PAYMENT_PENDING
            );
            participation = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => participation});
            insert participation;

            ucinn_portal_Registration_Session__c session = new ucinn_portal_Registration_Session__c(
                Expiration_Date_Time__c = DateTime.now().addMinutes(15),
                Status__c = PORTAL_CONST_Events.REGISTRATION_SESSION_STATUS_IN_SHOPPING_CART,
                Session_Id__c = 'cookie2'
            );
            session = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => session});
            insert session;
            
            ucinn_portal_Ticket__c ticket = new ucinn_portal_Ticket__c(
                Ticket_Type__c = newTicketType.Id,
                Number_of_Tickets__c = 1,
                Registration_Session__c = session.Id,
                Participation__c = participation.Id
            );
            ticket = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticket});
            insert ticket;

            Test.startTest();
            PORTAL_UTIL_Events.getGuestSessionPrimaryParticipationForListings(null, null);

            Map<String, String> listingToParticipationMap = PORTAL_UTIL_Events.getGuestSessionPrimaryParticipationForListings(new Set<String>{newListing.Id}, 'cookie');
            // the setup code creates a completed registration session and an expired one
            System.assert(listingToParticipationMap.isEmpty());

            listingToParticipationMap = PORTAL_UTIL_Events.getGuestSessionPrimaryParticipationForListings(new Set<String>{newListing.Id}, 'cookie2');
            System.assertEquals(participation.Id, listingToParticipationMap.get(newListing.Id));

            Test.stopTest();
        }
    }

    static testMethod void testGetDiscountFromPromoCodes() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetDiscountFromPromoCodes();
    }

    static testMethod void testIsListingHasPromoCodes() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testIsListingHasPromoCodes();
    }

    static testMethod void testGetDiscountedPrice() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetDiscountedPrice();
    }

    static testMethod void testGetAvailableTicketsForListing() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetAvailableTicketsForListing();
    }

    static testMethod void testGetTicketAvailabilityForListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetTicketAvailabilityForListings();
    }

    static testMethod void testGetTicketTypeIdToDiscountMapFromListingId() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetTicketTypeIdToDiscountMapFromListingId();
    }

    static testMethod void testGetTicketTypeDiscountsForConstituent() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetTicketTypeDiscountsForConstituent();
    }

    static testMethod void testGetAvailableTicketsForTicketTypes() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetAvailableTicketsForTicketTypes();
    }

    static testMethod void testEmailWaitlistEntryList() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testEmailWaitlistEntryList();
    }

    static testMethod void testGetEventAvailability() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetEventAvailability();
    }

    /**
     * Test guest participation
     * @author Jacob Huang
     * @since 1.11
     */
    static testMethod void testGetGuestSessionPrimaryParticipationForListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_EventsTestClass().testGetGuestSessionPrimaryParticipationForListings();
    }
}