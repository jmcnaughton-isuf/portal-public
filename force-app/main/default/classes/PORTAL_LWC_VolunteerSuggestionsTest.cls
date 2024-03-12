@isTest
public class PORTAL_LWC_VolunteerSuggestionsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testGetVolunteerSuggestions() {
            ucinn_portal_Volunteer_Job__c volunteerJobRecord = new ucinn_portal_Volunteer_Job__c();
            insert volunteerJobRecord;

            PORTAL_LWC_VolunteerSuggestions.SERVER_getVolunteerSuggestions(null);
            PORTAL_LWC_VolunteerSuggestions.SERVER_getVolunteerSuggestions(new Map<String, Object>{
                PORTAL_LWC_VolunteerSuggestions.RECORD_ID => volunteerJobRecord.Id
            });

            ucinn_portal_Skill_Value__c skillValueRecord = new ucinn_portal_Skill_Value__c(Name = 'test');
            insert skillValueRecord;

            insert new ucinn_portal_Volunteer_Skill__c(Skill_Value__c = skillValueRecord.Id, Volunteer_Job__c = volunteerJobRecord.Id);

            PORTAL_LWC_VolunteerSuggestions.SERVER_getVolunteerSuggestions(new Map<String, Object>{
                PORTAL_LWC_VolunteerSuggestions.RECORD_ID => volunteerJobRecord.Id
            });
        }
    }
    static testMethod void testGetVolunteerSuggestions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcVolunteerSuggestionsTestClass().testGetVolunteerSuggestions();
    }
}