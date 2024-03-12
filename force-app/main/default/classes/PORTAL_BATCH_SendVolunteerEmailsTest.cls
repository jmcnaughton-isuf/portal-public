@isTest
public class PORTAL_BATCH_SendVolunteerEmailsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Account acc;
        public Contact con;
        public ucinn_portal_Volunteer_Job__c volunteerJobRecord;
        public ucinn_portal_Volunteer_Shift__c volunteerShiftRecord;
        public ucinn_portal_Volunteer__c volunteerRecord;

        private virtual void setupData() {
            volunteerJobRecord = new ucinn_portal_Volunteer_Job__c();

            insert volunteerJobRecord;

            volunteerShiftRecord = new ucinn_portal_Volunteer_Shift__c(Volunteer_Job__c = volunteerJobRecord.Id);
            insert volunteerShiftRecord;

            Account acct = new Account(name = 'ACME Co') ;
            insert acct;

            con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUsermig123@test.com');
            insert con;
        }

        public virtual void testBatch() {
            setupData();
            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails('ucinn_portal_Volunteer_Job__c', volunteerJobRecord.Id, 'Volunteer_Test'));
            Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails('ucinn_portal_Volunteer_Shift__c', volunteerShiftRecord.Id, 'Volunteer_Test'));
            volunteerRecord = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShiftRecord.Id, Contact__c = con.Id);
            insert volunteerRecord;
            Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails('ucinn_portal_Volunteer_Job__c', volunteerJobRecord.Id, 'test'));
            Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails('ucinn_portal_Volunteer_Shift__c', volunteerShiftRecord.Id, 'Volunteer_Test'));
            Test.stopTest();
        }

        public virtual void testBatchValidDeveloperName() {
            setupData();

            Test.startTest();

            volunteerRecord = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShiftRecord.Id, Contact__c = con.Id);
            insert volunteerRecord;
            Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails('ucinn_portal_Volunteer_Job__c', volunteerJobRecord.Id, 'Portal_Volunteer_Shift_Sign_Up_Email'));
            Database.executeBatch(new PORTAL_BATCH_SendVolunteerEmails('ucinn_portal_Volunteer_Shift__c', volunteerShiftRecord.Id, 'Portal_Volunteer_Shift_Sign_Up_Email'));
            Test.stopTest();
        }
    }

    @isTest
    private static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendVolunteerEmailsTestClass().testBatch();
    }

    @isTest
    private static void testBatchValidDeveloperName() {
        PORTAL_TestClassFactory.getTestClassFactory().getSendVolunteerEmailsTestClass().testBatchValidDeveloperName();
    }
}