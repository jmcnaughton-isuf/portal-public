@isTest
public class PORTAL_TRIG_TicketTypeHandlerTest {
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

            newTicketType = new ucinn_portal_Ticket_Type__c(Listing__c = newListing.Id, Price__c = 5, Total_Number_of_Tickets__c = 0);
            newTicketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTicketType});
            insert newTicketType;

            waitlistEntryRecord = new ucinn_portal_Event_Waitlist_Entry__c(Ticket_Type__c = newTicketType.Id,
                                                                           Number_of_Tickets_Awaiting__c = 20,
                                                                           First_Name__c = 'Test',
                                                                           Last_Name__c = 'Test',
                                                                           Email__c = 'test@ucinnovation.com');

            waitlistEntryRecord = (ucinn_portal_Event_Waitlist_Entry__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => waitlistEntryRecord});
            insert waitlistEntryRecord;
        }

        public virtual void runTest() {
            setUpEvent();
            newTicketType = [SELECT id, Total_Tickets_Available__c, Sales_Start_Date_Time__c, Sales_End_Date_Time__c, Actual_Sales_Start_Date_Time__c, Actual_Sales_End_Date_Time__c, Time_Zone__c, Listing__c FROM ucinn_portal_Ticket_Type__c WHERE id = :newTicketType.Id];
            List<SObject> oldList = new List<SObject>{newTicketType};

            ucinn_portal_Ticket_Type__c ticketType2 = newTicketType.clone(true, true, false, false);
            ticketType2.Total_Number_of_Tickets__c = 1;
            ticketType2.Sales_Start_Date_Time__c = Datetime.now();
            ticketType2.Sales_End_Date_Time__c = Datetime.now().addDays(1);

            update ticketType2;

            ticketType2 = [SELECT id, Total_Tickets_Available__c, Sales_Start_Date_Time__c, Sales_End_Date_Time__c, Actual_Sales_Start_Date_Time__c, Actual_Sales_End_Date_Time__c, Time_Zone__c, Listing__c FROM ucinn_portal_Ticket_Type__c WHERE id = :ticketType2.Id];

            List<SObject> newList = new List<SObject>{ticketType2};

            new PORTAL_TRIG_TicketTypeHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert,
                                                    ucinn_portal_Ticket_Type__c.sObjectType.getDescribe());

            new PORTAL_TRIG_TicketTypeHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                    ucinn_portal_Ticket_Type__c.sObjectType.getDescribe());
        }

        /**
         * Test after update / waitlist trigger code
         * 
         * @author Jacob Huang
         * @since 1.1
         */
        public virtual void runAfterUpdateTest() {
            Schema.DescribeSObjectResult ticketTypeDescribe = ucinn_portal_Ticket_Type__c.sObjectType.getDescribe();
            ucinn_ascendv2.ascend_TDTM_Runnable.Action afterUpdateAction = ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate;
            setUpEvent();

            newTicketType = [SELECT Id, Total_Tickets_Available__c, Total_Number_of_Tickets__c, Listing__c FROM ucinn_portal_Ticket_Type__c WHERE Id = :newTicketType.Id];
            List<SObject> oldList = new List<SObject>{newTicketType.clone(true, true, false, false)};
            List<SObject> newList = new List<SObject>{newTicketType};

            Test.startTest();
            new PORTAL_TRIG_TicketTypeHandler().run(null, null, afterUpdateAction, ticketTypeDescribe);
            
            // test increasing Total_Number_of_Tickets__c
            newTicketType.Total_Number_of_Tickets__c = 5;
            update newTicketType;
            System.Formula.recalculateFormulas(newList);
            new PORTAL_TRIG_TicketTypeHandler().run(newList, oldList, afterUpdateAction, ticketTypeDescribe);
            waitlistEntryRecord = [SELECT Number_of_Tickets_Available__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Id = :waitlistEntryRecord.Id];
            System.assertEquals(5, waitlistEntryRecord.Number_of_Tickets_Available__c);

            // test changing Total_Number_of_Tickets__c to null
            newTicketType.Total_Number_of_Tickets__c = null;
            update newTicketType;
            System.Formula.recalculateFormulas(newList);
            new PORTAL_TRIG_TicketTypeHandler().run(newList, oldList, afterUpdateAction, ticketTypeDescribe);
            waitlistEntryRecord = [SELECT Number_of_Tickets_Available__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Id = :waitlistEntryRecord.Id];
            System.assertEquals(20, waitlistEntryRecord.Number_of_Tickets_Available__c);

            // test no changes to ticket availability (pass same list twice)
            new PORTAL_TRIG_TicketTypeHandler().run(newList, newList, afterUpdateAction, ticketTypeDescribe);

            Test.stopTest();
        }
    }

    static testMethod void runTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_TicketTypeHandlerTestClass().runTest();
    }

    static testMethod void runAfterUpdateTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_TicketTypeHandlerTestClass().runAfterUpdateTest();
    }
}