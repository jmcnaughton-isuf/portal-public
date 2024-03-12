@isTest
public class PORTAL_BATCH_VolunteerReminderEmailsTest {
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

            volunteerRecord = new ucinn_portal_Volunteer__c(Volunteer_Shift__c = volunteerShiftRecord.Id, Contact__c = con.Id);
            insert volunteerRecord;
        }

        public virtual void testBatch() {
            setupData();
            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_VolunteerReminderEmails());
            volunteerJobRecord.Reminder_Email_Date_Time__c = DateTime.now().addHours(-1);
            volunteerJobRecord.Reminder_Email_Template__c = 'Volunteer_Test';
            update volunteerJobRecord;
            Database.executeBatch(new PORTAL_BATCH_VolunteerReminderEmails());
            volunteerShiftRecord.Reminder_Email_Date_Time__c = DateTime.now().addHours(-1);
            volunteerShiftRecord.Reminder_Email_Template__c = 'Volunteer_Test';
            update volunteerShiftRecord;
            Database.executeBatch(new PORTAL_BATCH_VolunteerReminderEmails());
            System.schedule('Hourly', '0 0 * * * ?', new PORTAL_BATCH_VolunteerReminderEmails() );
            Test.stopTest();
        }
    }


    @isTest
    private static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getVolunteerReminderEmailsTestClass().testBatch();
    }
}