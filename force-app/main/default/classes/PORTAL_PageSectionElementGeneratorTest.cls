@isTest
public without sharing class PORTAL_PageSectionElementGeneratorTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public User communityUser;

        public virtual void setupUserData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com',
                                ucinn_portal_Is_Display_On_Portal__c = true);
                insert con;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        ContactId = con.Id,
                                        timezonesidkey='America/Los_Angeles',
                                        username = 'testCommunityUsermig123@test.com');
                insert communityUser;
            }
        }

        public virtual void testGenerateForm1() {
            setupUserData();

            System.runAs(communityUser) {
                PORTAL_PageSectionAdapter newAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information')
                                                                                              .buildMainSectionName('Volunteer Edit Form')
                                                                                              .build();

                new PORTAL_PageSectionElementGenerator(newAdapter).generateForm();
            }
        }

        public virtual void testGenerateForm2() {
            PORTAL_PageSectionAdapter newAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information')
                                                                                          .build();

            new PORTAL_PageSectionElementGenerator(newAdapter).generateForm();
            new PORTAL_PageSectionElementGenerator(null).generateForm();
        }

        public virtual void testConvertStringToPicklistValues() {
            PORTAL_PageSectionElementGenerator pageSectionElementGenerator = new PORTAL_PageSectionElementGenerator(null);
            pageSectionElementGenerator.convertStringToPicklistValues('test;test\r\ntest1;test1');
            pageSectionElementGenerator.convertStringToPicklistValues(';');
            pageSectionElementGenerator.convertStringToPicklistValues('test;test1');
        }

        public virtual void testQueryPicklistValues() {
            PORTAL_PageSectionElementGenerator pageSectionElementGenerator = new PORTAL_PageSectionElementGenerator(null);
            pageSectionElementGenerator.queryPicklistValues(null, null, null);

            insert new ucinn_portal_Skill_Value__c(Name = 'Test');
            pageSectionElementGenerator.queryPicklistValues('ucinn_portal_Skill_Value__c', 'Name', 'Id != null');
        }

        public virtual void testGetValueFromPickList() {
            String value = 'Test';
            Map<String, String> pickListValue = new Map<String, String>{'value' => value};
            List<Map<String, String>> pickListValueList = new List<Map<String, String>>{pickListValue};

            PORTAL_FormFieldWrapper referenceWrapper = new PORTAL_FormFieldWrapper();
            referenceWrapper.picklistValues = pickListValueList;
            referenceWrapper.fieldType = 'lookup';
            referenceWrapper.fieldId = 'Test Id';
            referenceWrapper.value = value;

            Map<String, Object> recordWrapper = new Map<String, Object>{'Test Id' => null};
            List<Map<String, Object>> recordWrapperList = new List<Map<String,Object>>{recordWrapper};

            List<PORTAL_FormFieldWrapper> formFieldList = new List<PORTAL_FormFieldWrapper>{referenceWrapper};

            PORTAL_FormRowWrapper formRowWrapper = new PORTAL_FormRowWrapper();
            formRowWrapper.formFieldList = formFieldList;

            PORTAL_FormWrapper formWrapper = new PORTAL_FormWrapper();
            formWrapper.formRowList = new List<PORTAL_FormRowWrapper>{formRowWrapper};


            Test.startTest();

            PORTAL_PageSectionAdapter newAdapter = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information')
                                                                                        .buildMainSectionName('Volunteer Edit Form')
                                                                                        .build();
    
            new PORTAL_PageSectionElementGenerator(newAdapter).populateFormValues(formWrapper, recordWrapperList);

            recordWrapper.put('Test Id', value);

            PORTAL_PageSectionAdapter newAdapterWithValue = new PORTAL_PageSectionAdapter.Builder().buildPageName('Volunteer Information')
                                                                                        .buildMainSectionName('Volunteer Edit Form')
                                                                                        .build();
    
            new PORTAL_PageSectionElementGenerator(newAdapterWithValue).populateFormValues(formWrapper, new List<Map<String,Object>>{recordWrapper});

            Test.stopTest();
        }
    }

    static testMethod void testGenerateForm1() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionElementGeneratorTestClass().testGenerateForm1();
    }

    static testMethod void testGenerateForm2() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionElementGeneratorTestClass().testGenerateForm2();
    }

    static testMethod void testConvertStringToPicklistValues() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionElementGeneratorTestClass().testConvertStringToPicklistValues();
    }

    static testMethod void testQueryPicklistValues() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionElementGeneratorTestClass().testQueryPicklistValues();
    }

    static testMethod void testGetValueFromPickList() {
        PORTAL_TestClassFactory.getTestClassFactory().getPageSectionElementGeneratorTestClass().testGetValueFromPickList();
    }
}