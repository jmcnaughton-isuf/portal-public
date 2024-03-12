@isTest
public without sharing class PORTAL_BATCH_RegistrationSessionCUTest {
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

            ucinn_portal_Registration_Session__c registrationSession = new ucinn_portal_Registration_Session__c(Expiration_Date_Time__c = DateTime.now().addMinutes(-4));
            registrationSession = (ucinn_portal_Registration_Session__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => registrationSession});
            insert registrationSession;

            ucinn_portal_Participation__c participation = (ucinn_portal_Participation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new ucinn_portal_Participation__c(Listing__c = listing.Id)});
            insert participation;

            ucinn_portal_Ticket__c ticket = (ucinn_portal_Ticket__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new ucinn_portal_Ticket__c(Ticket_Type__c = ticketType.Id, Participation__c = participation.Id, Registration_Session__c = registrationSession.Id)});
            insert ticket;

            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_RegistrationSessionCleanup());
            Test.stopTest();
        }

        public virtual void testScheduler() {
            Test.startTest();
            String chron = '0 0 23 * * ?';
            System.schedule('Test Sched', chron, new PORTAL_BATCH_RegistrationSessionCleanup());
            Test.stopTest();

        }
    }

    @IsTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getRegistrationSessionCUTest().testBatch();
    }

    @IsTest
    public static void testScheduler() {
        PORTAL_TestClassFactory.getTestClassFactory().getRegistrationSessionCUTest().testScheduler();
    }
}