@isTest
public class PORTAL_EventWaitlistCtrlBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Listing__c newListing;
        public ucinn_portal_Ticket_Type__c newTicketType;
        public ucinn_portal_Custom_Form_Field__c formField;
        public ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

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

        public virtual void waitlistRegistrantTest() {
            PORTAL_EventWaitlistControllerBase controller = new PORTAL_EventWaitlistControllerBase();

            try {
                controller.waitlistRegistrant(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.waitlistRegistrant(new Map<String, Object>{'test' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpEvent();

            controller.waitlistRegistrant(new Map<String, Object>{
                PORTAL_EventWaitlistControllerBase.FIRST_NAME => 'test',
                PORTAL_EventWaitlistControllerBase.LAST_NAME => 'test',
                PORTAL_EventWaitlistControllerBase.EMAIL_KEY => 'test@ucinnovation.com',
                PORTAL_EventWaitlistControllerBase.TICKET_TYPE_ID => newTicketType.Id,
                PORTAL_EventWaitlistControllerBase.NUMBER_OF_TICKETS => 4
            });

        }

        public virtual void deleteWaitlistEntryTest() {
            PORTAL_EventWaitlistControllerBase controller = new PORTAL_EventWaitlistControllerBase();

            try {
                controller.deleteWaitlistEntry(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.deleteWaitlistEntry(new Map<String, Object>{'test' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpEvent();

            controller.deleteWaitlistEntry(new Map<String, Object>{
                PORTAL_EventWaitlistControllerBase.WAITLIST_ENTRY_ID => waitlistEntryRecord.Id
            });
        }

        public virtual void getWaitlistEntryByIdTest() {
            PORTAL_EventWaitlistControllerBase controller = new PORTAL_EventWaitlistControllerBase();
            setUpEvent();
            controller.getWaitlistEntryById(null);
            controller.getWaitlistEntryById(new Map<String, Object>{PORTAL_EventWaitlistControllerBase.WAITLIST_ENTRY_ID => waitlistEntryRecord.Id});
        }

        /**
         * Test activating waitlists for some Listings and waitlist entries 
         * 
         * @author Jacob Huang
         * @since 1.1
         */
        public virtual void activateWaitlistsTest() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();

            ucinn_portal_Listing__c listingA = new ucinn_portal_Listing__c(Name = 'Test Event', RecordTypeId = recordTypeId, Status__c = 'Published');
            listingA = (ucinn_portal_Listing__c) testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listingA});
            ucinn_portal_Listing__c listingB = (ucinn_portal_Listing__c) listingA.clone(false, false, false, false);
            listingA.Maximum_Number_of_Enrollment__c = 0;

            insert new List<ucinn_portal_Listing__c>{listingA, listingB};

            ucinn_portal_Ticket_Type__c ticketTypeA = new ucinn_portal_Ticket_Type__c(Listing__c = listingA.Id, Price__c = 0);
            ticketTypeA = (ucinn_portal_Ticket_Type__c) testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketTypeA});
            ucinn_portal_Ticket_Type__c ticketTypeB = (ucinn_portal_Ticket_Type__c) ticketTypeA.clone(false, false, false, false); 
            ticketTypeB.Listing__c = listingB.Id;
            ticketTypeB.Total_Number_of_Tickets__c = 0;

            insert new List<ucinn_portal_Ticket_Type__c>{ticketTypeA, ticketTypeB};

            ucinn_portal_Event_Waitlist_Entry__c waitlistA = new ucinn_portal_Event_Waitlist_Entry__c(Ticket_Type__c = ticketTypeA.Id, 
                                                                                                      Number_of_Tickets_Awaiting__c = 20, 
                                                                                                      First_Name__c = 'Test', 
                                                                                                      Last_Name__c = 'Test',
                                                                                                      Email__c = 'test@ucinnovation.com');
            waitlistA = (ucinn_portal_Event_Waitlist_Entry__c) testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => waitlistA});
            ucinn_portal_Event_Waitlist_Entry__c waitlistB1 = (ucinn_portal_Event_Waitlist_Entry__c) waitlistA.clone(false, false, false, false);
            ucinn_portal_Event_Waitlist_Entry__c waitlistB2 = (ucinn_portal_Event_Waitlist_Entry__c) waitlistA.clone(false, false, false, false);
            waitlistB1.Ticket_Type__c = ticketTypeB.Id;
            waitlistB2.Ticket_Type__c = ticketTypeB.Id;

            insert new List<ucinn_portal_Event_Waitlist_Entry__c>{waitlistA, waitlistB1};
            insert waitlistB2; // guarantee waitlistB2 is created after waitlistB1
            Set<Id> waitlistIdSet = new Set<Id>{waitlistA.Id, waitlistB1.Id, waitlistB2.Id};

            PORTAL_EventWaitlistControllerBase controller = new PORTAL_EventWaitlistControllerBase();

            Test.startTest();
            controller.activateWaitlists(null);
            System.assertEquals(true, controller.getWaitlistEntriesToUpdate(null, null, null).isEmpty());

            // test listingA's max enrollment = 0 and ticketTypeB's total num tickets = 0
            controller.activateWaitlists(new Set<Id>{listingA.Id, listingB.Id});
            List<ucinn_portal_Event_Waitlist_Entry__c> updatedWaitlist = [SELECT Number_of_Tickets_Available__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Id IN :waitlistIdSet];
            for (ucinn_portal_Event_Waitlist_Entry__c eachWaitlistEntry : updatedWaitlist) {
                System.assertEquals(null, eachWaitlistEntry.Number_of_Tickets_Available__c);
            }

            // test waitlist allocation
            listingA.Maximum_Number_of_Enrollment__c = 15;
            update listingA;
            ticketTypeB.Total_Number_of_Tickets__c = 25;
            update ticketTypeB;

            controller.activateWaitlists(new Set<Id>{listingA.Id, listingB.Id});
            Map<Id, ucinn_portal_Event_Waitlist_Entry__c> updatedWaitlistMap = new Map<Id, ucinn_portal_Event_Waitlist_Entry__c>([SELECT Number_of_Tickets_Available__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Id IN :waitlistIdSet]);
            System.assertEquals(15, updatedWaitlistMap.get(waitlistA.Id).Number_of_Tickets_Available__c);
            System.assertEquals(20, updatedWaitlistMap.get(waitlistB1.Id).Number_of_Tickets_Available__c);
            System.assertEquals(5, updatedWaitlistMap.get(waitlistB2.Id).Number_of_Tickets_Available__c);

            Test.stopTest();
        }
    }


    static testMethod void waitlistRegistrantTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventWaitlistCtrlBaseTestClass().waitlistRegistrantTest();
    }

    static testMethod void deleteWaitlistEntryTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventWaitlistCtrlBaseTestClass().deleteWaitlistEntryTest();
    }

    static testMethod void getWaitlistEntryByIdTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventWaitlistCtrlBaseTestClass().getWaitlistEntryByIdTest();
    }

    static testMethod void activateWaitlistsTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventWaitlistCtrlBaseTestClass().activateWaitlistsTest();
    }
}