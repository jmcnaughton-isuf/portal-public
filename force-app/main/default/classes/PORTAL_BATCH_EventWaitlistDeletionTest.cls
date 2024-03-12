@isTest
public without sharing class PORTAL_BATCH_EventWaitlistDeletionTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testBatch() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Event';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();
            listing.Start_Date_Time__c = Datetime.now().addDays(-30);
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            ucinn_portal_Ticket_Type__c ticketType = new ucinn_portal_Ticket_Type__c(Listing__c = listing.Id, Name = 'Test');
            ticketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => ticketType});
            insert ticketType;

            ucinn_portal_Event_Waitlist_Entry__c waitlistEntry = new ucinn_portal_Event_Waitlist_Entry__c(Ticket_Type__c = ticketType.Id, First_Name__c = 'Test', Last_Name__c = 'Test', Email__c = 'test@test.com', Expiration_Date_Time__c = DateTime.now().addMinutes(-5));
            waitlistEntry = (ucinn_portal_Event_Waitlist_Entry__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => waitlistEntry});
            insert waitlistEntry;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_EventWaitlistDeletion());
            Test.stopTest();
        }

        public virtual void testScheduler() {
            Test.startTest();
            String chron = '0 0 23 * * ?';
            System.schedule('Test Sched', chron, new PORTAL_BATCH_EventWaitlistDeletion());
            Test.stopTest();

        }
    }
    @IsTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventWaitlistDeletionTestClass().testBatch();
    }

    @IsTest
    public static void testScheduler() {
        PORTAL_TestClassFactory.getTestClassFactory().getEventWaitlistDeletionTestClass().testScheduler();
    }
}