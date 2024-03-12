@isTest
public class PORTAL_LWC_MassEmailVolunteersTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetEmailTemplateList() {
            PORTAL_LWC_MassEmailVolunteers.SERVER_getEmailTemplateList(null);
        }

        public virtual void testScheduleVolunteerReminderEmails() {
            PORTAL_LWC_MassEmailVolunteers.SERVER_massEmailVolunteers(null);

            ucinn_portal_Volunteer_Job__c volunteerJob = new ucinn_portal_Volunteer_Job__c();
            insert volunteerJob;

            PORTAL_LWC_MassEmailVolunteers.SERVER_massEmailVolunteers(new Map<String, Object>{
                PORTAL_LWC_VolunteerReminderEmail.RECORD_ID => volunteerJob.Id,
                PORTAL_LWC_VolunteerReminderEmail.EMAIL_TEMPLATE_API_NAME => 'test'
            });
        }
    }

    static testMethod void testGetEmailTemplateList() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMassEmailVolunteersTestClass().testGetEmailTemplateList();
    }

    static testMethod void testScheduleVolunteerReminderEmails() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcMassEmailVolunteersTestClass().testScheduleVolunteerReminderEmails();
    }

}