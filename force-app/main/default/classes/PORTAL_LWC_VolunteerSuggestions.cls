public inherited sharing class PORTAL_LWC_VolunteerSuggestions {
    public static final String RECORD_ID = 'recordId';

    @AuraEnabled(cacheable=true)
    public static List<Contact> SERVER_getVolunteerSuggestions(Map<String, Object> params) {
        String volunteerJobId = (String)params?.get(RECORD_ID);

        if (String.isBlank(volunteerJobId)) {
            return new List<Contact>();
        }

        List<ucinn_portal_Volunteer_Skill__c> volunteerSkillList = [SELECT Skill_Value__c
                                                                    FROM ucinn_portal_Volunteer_Skill__c
                                                                    WHERE Volunteer_Job__c = :volunteerJobId];

        if (volunteerSkillList == null || volunteerSkillList.isEmpty()) {
            return new List<Contact>();
        }

        Set<String> skillValueIdSet = new Set<String>();

        for (ucinn_portal_Volunteer_Skill__c eachVolunteerSkill : volunteerSkillList) {
            skillValueIdSet.add(eachVolunteerSkill.Skill_Value__c);
        }

        return [SELECT Id, FirstName, LastName, Email,
                       (SELECT Id, Skill_Value__r.Name
                        FROM ucinn_portal_Constituent_Skills_Contact__r
                        WHERE Skill_Value__c IN :skillValueIdSet)
                FROM Contact
                WHERE Id IN (SELECT Contact__c
                             FROM ucinn_portal_Constituent_Skill__c
                             WHERE Skill_Value__c IN :skillValueIdSet)
                AND Id NOT IN (SELECT Contact__c
                               FROM ucinn_portal_Volunteer__c
                               WHERE Volunteer_Shift__r.Volunteer_Job__c = :volunteerJobId)
                ORDER BY FirstName
                LIMIT 15];
    }

}