@isTest
public class PORTAL_LWC_VolunteerReminderEmailTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetEmailTemplateList() {
            PORTAL_LWC_VolunteerReminderEmail.SERVER_getEmailTemplateList(null);
        }

        public virtual void testScheduleVolunteerReminderEmails() {
            PORTAL_LWC_VolunteerReminderEmail.SERVER_scheduleVolunteerReminderEmails(null);

            ucinn_portal_Volunteer_Job__c volunteerJob = new ucinn_portal_Volunteer_Job__c();
            insert volunteerJob;

            PORTAL_LWC_VolunteerReminderEmail.SERVER_scheduleVolunteerReminderEmails(new Map<String, Object>{
                PORTAL_LWC_VolunteerReminderEmail.RECORD_ID => volunteerJob.Id,
                PORTAL_LWC_VolunteerReminderEmail.SCHEDULE_DATE_TIME => 12,
                PORTAL_LWC_VolunteerReminderEmail.EMAIL_TEMPLATE_API_NAME => 'test'
            });
        }
    }
    static testMethod void testGetEmailTemplateList() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerReminderEmailTestClass().testGetEmailTemplateList();
    }

    static testMethod void testScheduleVolunteerReminderEmails() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerReminderEmailTestClass().testScheduleVolunteerReminderEmails();
    }
}