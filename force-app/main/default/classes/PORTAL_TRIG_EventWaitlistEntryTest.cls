@isTest
public class PORTAL_TRIG_EventWaitlistEntryTest {
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

        public virtual void runTest() {
            setUpEvent();
            List<SObject> oldList = new List<SObject>{waitlistEntryRecord};

            ucinn_portal_Event_Waitlist_Entry__c newEntry = waitlistEntryRecord.clone(true, true, false, false);
            newEntry.Number_of_Tickets_Available__c = 21;

            List<SObject> newList = new List<SObject>{newEntry};

            new PORTAL_TRIG_EventWaitlistEntryHandler().run(newList,
                                                            oldList,
                                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                            ucinn_portal_Event_Waitlist_Entry__c.sObjectType.getDescribe());
        }
    }

    static testMethod void runTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_EventWaitlistEntryTestClass().runTest();
    }
}