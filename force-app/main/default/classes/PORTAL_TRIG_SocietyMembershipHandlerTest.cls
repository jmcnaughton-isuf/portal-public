@isTest
public class PORTAL_TRIG_SocietyMembershipHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Account account;
        public Contact contactRecord;
        public Contact jointContactRecord;
        public String currentFiscalYear;
        public ucinn_ascendv2__Society_Membership__c societyMembership;
        public ucinn_ascendv2__Society_Membership__c societyMembershipNoDisplay;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts(String contactName, String jointContactName, String jointPreference) {
            currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period
                                            WHERE Type = 'Year'
                                            AND StartDate <= TODAY
                                            AND EndDate >= TODAY].FiscalYearSettings.Name;

            account = new Account(name = 'Test Account');
            account = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => account});
            insert account;

            contactRecord = createContactRecord(contactName, jointPreference);
            contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
            insert contactRecord;

            jointContactRecord = createContactRecord(jointContactName, jointPreference);
            jointContactRecord.ucinn_ascendv2__Preferred_Spouse__c = contactRecord.Id;
            jointContactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => jointContactRecord});
            insert jointContactRecord;

            contactRecord.ucinn_ascendv2__Preferred_Spouse__c = jointContactRecord.Id;
            update contactRecord;
        }

        public virtual Contact createContactRecord(String name, String jointPreference) {
            return new Contact(LastName = name,
                                ucinn_portal_Honor_Roll_Joint_Preference__c = jointPreference,
                                ucinn_portal_Is_Honor_Roll_Opt_Out__c = false,
                                AccountId = account.Id);
        }

        public virtual void setUpSocietyMemberships() {
            if (contactRecord == null) {
                setUpContacts('Test Contact', 'Test Spouse Contact', 'Individual');
            }

            ucinn_ascendv2__Giving_Society__c givingSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Test Giving Society',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Annual');
            givingSociety = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety});
            insert givingSociety;

            societyMembership = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership',
                                                                            ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                            ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                            ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                            ucinn_portal_Is_Display_On_Portal__c = true);

            societyMembershipNoDisplay = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership',
                                                                            ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                            ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                            ucinn_portal_Is_Show_on_Honor_Roll__c = false,
                                                                            ucinn_portal_Is_Display_On_Portal__c = false);


            societyMembership = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership});
            societyMembershipNoDisplay = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembershipNoDisplay});
            insert societyMembership;
            insert societyMembershipNoDisplay;
        }

        public virtual void testAddHonorRollNameJoint(){
            setUpContacts('Test New Contact 1', 'Test New Joint Contact 1', 'Joint');
            setUpSocietyMemberships();

            Test.startTest();
            List<ucinn_ascendv2__Society_Membership__c> newList = new List<ucinn_ascendv2__Society_Membership__c>{societyMembership};
            new PORTAL_TRIG_SocietyMembershipHandler().run(null,
                                                           null,
                                                           ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                           Contact.getSObjectType().getDescribe());

            new PORTAL_TRIG_SocietyMembershipHandler().run(newList,
                                                           null,
                                                           ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                           Contact.getSObjectType().getDescribe());

            Test.stopTest();
        }

        public virtual void testAddHonorRollNameIndividual(){
            setUpContacts('Test New Contact 2', 'Test New Joint Contact 2', 'Individual');
            setUpSocietyMemberships();

            Test.startTest();
            List<ucinn_ascendv2__Society_Membership__c> newList = new List<ucinn_ascendv2__Society_Membership__c>{societyMembership};

            new PORTAL_TRIG_SocietyMembershipHandler().run(newList,
                                                           null,
                                                           ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                           Contact.getSObjectType().getDescribe());

            ucinn_portal_Honor_Roll_Name__c newHonorRoll = new ucinn_portal_Honor_Roll_Name__c(Honor_Roll_Name__c = 'Test Honor Roll Name',
                                                                                               Starting_Fiscal_Year__c = currentFiscalYear, Contact__c = contactRecord.Id);
            newHonorRoll = (ucinn_portal_Honor_Roll_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newHonorRoll});
            insert newHonorRoll;
            new PORTAL_TRIG_SocietyMembershipHandler().run(newList,
                                                           null,
                                                           ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                           Contact.getSObjectType().getDescribe());
            Test.stopTest();
        }

        public virtual void testMembershipNoDisplay(){
            setUpContacts('Test New Contact 3', 'Test New Joint Contact 3', 'Joint');
            setUpSocietyMemberships();

            Test.startTest();
            List<ucinn_ascendv2__Society_Membership__c> newList = new List<ucinn_ascendv2__Society_Membership__c>{societyMembershipNoDisplay};

            new PORTAL_TRIG_SocietyMembershipHandler().run(newList,
                                                           null,
                                                           ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                           Contact.getSObjectType().getDescribe());
            Test.stopTest();
        }

        public virtual void testCreateHonorRollNamesToInsertList() {
            PORTAL_TRIG_SocietyMembershipHandler.createHonorRollNamesToInsertList(null, null);
        }

    }

    static testMethod void testAddHonorRollNameJoint(){
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_SocietyMembershipHandlerTestClass().testAddHonorRollNameJoint();
    }

    static testMethod void testAddHonorRollNameIndividual(){
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_SocietyMembershipHandlerTestClass().testAddHonorRollNameIndividual();
    }

    static testMethod void testMembershipNoDisplay(){
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_SocietyMembershipHandlerTestClass().testMembershipNoDisplay();
    }

    static testMethod void testCreateHonorRollNamesToInsertList() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_SocietyMembershipHandlerTestClass().testCreateHonorRollNamesToInsertList();
    }

}