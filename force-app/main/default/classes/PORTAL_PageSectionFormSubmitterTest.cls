@isTest
public without sharing class PORTAL_PageSectionFormSubmitterTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public virtual void testSubmit() {
            System.runAs(thisUser) {
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                insert con;

                ucinn_portal_Skill_Value__c skillValue = new ucinn_portal_Skill_Value__c(Name = 'Test');

                insert skillValue;

                PORTAL_PageSectionAdapter newAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information')
                                                                                            .buildMainSectionName('Volunteer Edit Form')
                                                                                            .build();

                PORTAL_PageSectionFormSubmitter formSubmitter = new PORTAL_PageSectionFormSubmitter(newAdapter);
                formSubmitter.submit(null);

                Map<String, List<PORTAL_FormRecordWrapper>> formDataMap = new Map<String, List<PORTAL_FormRecordWrapper>>();

                List<PORTAL_FormRecordWrapper> recordWrapperList = new List<PORTAL_FormRecordWrapper>();
                Map<String, Object> formData = new Map<String, Object>{'skillName' => skillValue.Id, 'contactId' => con.Id};
                recordWrapperList.add(new PORTAL_FormRecordWrapper(formData));
                formData = new Map<String, Object>{'skillName' => skillValue.Id, 'contactId' => con.Id};
                recordWrapperList.add(new PORTAL_FormRecordWrapper(formData, true));

                formDataMap.put('skillList', recordWrapperList);
                formDataMap.put('neverRuns', null);

                formSubmitter.submit(formDataMap);

                List<ucinn_portal_Constituent_Skill__c> skillList = [SELECT id FROM ucinn_portal_Constituent_Skill__c];

                recordWrapperList = new List<PORTAL_FormRecordWrapper>();
                formData = new Map<String, Object>{'skillName' => skillValue.Id, 'skillId' => skillList.get(0).Id,'contactId' => con.Id};
                recordWrapperList.add(new PORTAL_FormRecordWrapper(formData, true));
                formDataMap.put('skillList', recordWrapperList);

                formSubmitter.submit(formDataMap);
            }
        }
    }

    static testMethod void testSubmit() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionFormSubmitterTestClass().testSubmit();
    }
}