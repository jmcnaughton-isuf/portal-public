@isTest
global without sharing class PORTAL_BATCH_PopulateFYContributionTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_BATCH_PopulateFYContributionBase baseClass;
        public List<Contact> contacts = new List<Contact>();
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();


        public virtual void setup() {
            baseClass = new PORTAL_BATCH_PopulateFYContributionBase();
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact contact1 = new Contact(LastName = 'Test_Contact',
                                                AccountId = acct.Id,
                                                Email = 'testCommunityUsermig123@test.com');

                Contact contact2 = new Contact(LastName = 'Test_Contact',
                                                AccountId = acct.Id,
                                                Email = 'testCommunityUsermig123@test.com');

                contact1 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contact1});
                contact2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contact2});
                contacts.add(contact1);
                contacts.add(contact2);

                insert contacts;


                ucinn_ascendv2__Giving_Society__c annualSociety = new ucinn_ascendv2__Giving_Society__c(
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_portal_Type__c = 'Annual',
                    ucinn_ascendv2__Status__c = 'Active',
                    Name = 'TEST 3'
                );
                annualSociety = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => annualSociety});
                insert annualSociety;

                // create society memberships

                List<ucinn_ascendv2__Society_Membership__c> societyMemberships = new List<ucinn_ascendv2__Society_Membership__c>();
                ucinn_ascendv2__Society_Membership__c societyMembership = new ucinn_ascendv2__Society_Membership__c(
                                                                        ucinn_ascendv2__Giving_Society__c = annualSociety.Id,
                                                                        ucinn_ascendv2__Contact__c = contacts[0].Id,
                                                                        ucinn_ascendv2__Expiration_Date__c =  Date.today().addDays(1));
                societyMembership = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership});
                societyMemberships.add(societyMembership);

                insert societyMemberships;

                Formula.recalculateFormulas(societyMemberships);

                // hard and soft credits
                Date today = Date.today();
                RecordType giftOppRecordType = [SELECT Id, Name, Description ,DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Pledge'];

                Opportunity opp = new Opportunity(
                    Name = 'Pledge',
                    StageName = 'Active',
                    Amount = 1000,
                    CloseDate = Date.parse('10/10/2040'),
                    AccountId = acct.Id,
                    RecordTypeId = giftOppRecordType.Id,
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Contact__c = contacts[0].Id
                );
                opp = (Opportunity)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => opp});
                insert opp;

                ucinn_ascendv2__Designation__c designation1 = new ucinn_ascendv2__Designation__c(
                    Name = 'Athletics',
                    ucinn_ascendv2__Designation_Name__c  = 'Athletics',
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                designation1 = (ucinn_ascendv2__Designation__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designation1});
                insert designation1;

                ucinn_ascendv2__Designation_Detail__c designDetail = new ucinn_ascendv2__Designation_Detail__c(
                    ucinn_ascendv2__Opportunity__c = opp.Id,
                    ucinn_portal_Is_Display_On_Portal__c = true
                );
                designDetail = (ucinn_ascendv2__Designation_Detail__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => designDetail});
                insert designDetail;

                ucinn_ascendv2__Payment__c  payment1 = new ucinn_ascendv2__Payment__c(
                    ucinn_ascendv2__Transaction_Type__c = 'Pledge Payment',
                    ucinn_ascendv2__Credit_Date__c = today,
                    ucinn_ascendv2__Contact__c = contacts[0].Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Opportunity__c = opp.Id
                );
                payment1 = (ucinn_ascendv2__Payment__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => payment1});
                insert payment1;

                ucinn_ascendv2__Hard_and_Soft_Credit__c hnsCredit1 = new ucinn_ascendv2__Hard_and_Soft_Credit__c(
                    ucinn_ascendv2__Credit_Type__c = 'Hard',
                    ucinn_portal_Is_Display_On_Portal__c = true,
                    ucinn_ascendv2__Payment__c = payment1.Id,
                    ucinn_ascendv2__Contact__c = contacts[0].Id,
                    ucinn_ascendv2__Designation_Detail__c = designDetail.Id,
                    ucinn_ascendv2__Credit_Amount__c = 2500,
                    ucinn_ascendv2__Designation__c  = designation1.Id
                );
                hnsCredit1 = (ucinn_ascendv2__Hard_and_Soft_Credit__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => hnsCredit1});
                insert hnsCredit1;
            }
        }

            public virtual void batchTest() {
            setup();

            baseClass.start(new Map<String, Object>{PORTAL_BATCH_PopulateFYContributionBase.dailyBatch => true});
            String queryString = baseClass.start(new Map<String, Object>{PORTAL_BATCH_PopulateFYContributionBase.dailyBatch => false});

            List<sObject> records = Database.query(queryString);

            baseClass.execute(new Map<String, Object>{
                PORTAL_BATCH_PopulateFYContributionBase.contactRecords => records
            });
        }

        public virtual void controllerTest() {
            setup();
            Database.executeBatch(new PORTAL_BATCH_PopulateFYContribution(false));
            Database.executeBatch(new PORTAL_BATCH_PopulateFYContribution());
        }

        public virtual void schedulerTest() {
            new PORTAL_ScheduleFYContributionBatch();
            PORTAL_ScheduleFYContributionBatch scheduler = new PORTAL_ScheduleFYContributionBatch(10);

            scheduler.execute(null);
        }
    }

    @isTest
    static void batchTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getPopulateFYContributionTestClass().batchTest();
    }

    @isTest
    static void controllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getPopulateFYContributionTestClass().controllerTest();
    }

    @isTest
    static void schedulerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getPopulateFYContributionTestClass().schedulerTest();
    }
}