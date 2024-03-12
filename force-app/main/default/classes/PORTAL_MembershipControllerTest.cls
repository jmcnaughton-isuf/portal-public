@isTest
public without sharing class PORTAL_MembershipControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact contactRecord;
        public ucinn_ascendv2__Society_Membership__c societyMembership;
        public User contactUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setUpContacts() {
            System.runAs(thisUser) {
                Account account = new Account(name = 'Test Account');
                account = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => account});
                insert account;

                contactRecord = new Contact(LastName = 'Test Contact',
                                            AccountId = account.Id,
                                            ucinn_portal_Honor_Roll_Joint_Preference__c = 'Individual',
                                            ucinn_portal_Is_Honor_Roll_Opt_Out__c = false,
                                            ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = false);

                contactRecord = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contactRecord});
                insert contactRecord;

                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                User newUser = new User(ContactId = contactRecord.Id,
                                        ProfileId = profileId,
                                        Username = System.now().millisecond() + 'testuser@test.com',
                                        Alias = 'testers',
                                        Email='testuser1@test.com',
                                        EmailEncodingKey='UTF-8',
                                        Firstname='Test',
                                        Lastname='User',
                                        LanguageLocaleKey='en_US',
                                        LocaleSidKey='en_US',
                                        TimeZoneSidKey='America/Chicago');

                newUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newUser});
                insert newUser;

                contactUser = newUser;
            }
        }

        public virtual void setUpSocietyMemberships() {
            if (contactRecord == null) {
                setUpContacts();
            }

            Period fiscalYearInfo = PORTAL_CommunityUtils.getCurrentFiscalYear(null);

            ucinn_ascendv2__Giving_Society__c givingSociety = new ucinn_ascendv2__Giving_Society__c(Name = 'Test Giving Society',
                                                                                                    ucinn_ascendv2__Status__c = 'Active',
                                                                                                    ucinn_portal_Is_Display_On_Portal__c = true,
                                                                                                    ucinn_portal_Type__c = 'Annual');

            givingSociety = (ucinn_ascendv2__Giving_Society__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => givingSociety});
            insert givingSociety;

            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c(
                Name = 'Athletics',
                ucinn_ascendv2__Designation_Name__c  = 'Athletics',
                ucinn_portal_Is_Display_On_Portal__c = true
            );

            Product2 membershipLevel = new Product2(ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                    ucinn_ascendv2__Months_Allocated_on_Payment__c = 12,
                                                    ucinn_ascendv2__Payment_Options__c = 'One-Time Membership',
                                                    Name = 'Test',
                                                    ucinn_ascendv2__Designation__c = designation.Id);

            membershipLevel = (Product2)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membershipLevel});
            insert membershipLevel;

            societyMembership = new ucinn_ascendv2__Society_Membership__c(Name = 'Test Membership',
                                                                          ucinn_ascendv2__Membership_Level_Product__c = membershipLevel.Id,
                                                                          ucinn_ascendv2__Giving_Society__c = givingSociety.Id,
                                                                          ucinn_ascendv2__Contact__c = contactRecord.Id,
                                                                          ucinn_ascendv2__Member_Since__c = fiscalYearInfo.StartDate,
                                                                          ucinn_portal_Is_Show_on_Honor_Roll__c = true,
                                                                          ucinn_portal_Is_Display_On_Portal__c = true,
                                                                          ucinn_portal_Is_Renewal_Solicit_Opt_Out__c = false);

            societyMembership = (ucinn_ascendv2__Society_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => societyMembership});
            insert societyMembership;
        }

        public virtual void setUpBenefits() {
            if (societyMembership == null) {
                setUpSocietyMemberships();
            }

            String benefitId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Membership_Benefit').getRecordTypeId();

            Product2 benefitProduct = new Product2(Description = 'Benefit Description',
                                                    Name = 'Test Benefit',
                                                    RecordTypeId = benefitId);

            benefitProduct = (Product2)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => benefitProduct});
            insert benefitProduct;

            ucinn_ascendv2__Level_Benefit__c junctionBenefit = new ucinn_ascendv2__Level_Benefit__c(ucinn_ascendv2__Membership_Benefit_Product__c = benefitProduct.Id, 
                                                                                                    ucinn_ascendv2__Membership_Level_Product__c = societyMembership.ucinn_ascendv2__Membership_Level_Product__c);
            
            junctionBenefit = (ucinn_ascendv2__Level_Benefit__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => junctionBenefit});
            insert junctionBenefit;

            PricebookEntry pricebookEntry = new PricebookEntry(Product2Id = benefitProduct.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 50);
            pricebookEntry = (PricebookEntry)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => pricebookEntry});
            insert pricebookEntry;
        }

        public virtual void testinitializeMembershipPurchase() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();

            controller.initializeMembershipPurchase(null);

            controller.initializeMembershipPurchase(new Map<String, Object>{'test' => 'test'});

            controller.initializeMembershipPurchase(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'test',
                                                                            PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'test'});

            controller.initializeMembershipPurchase(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'Membership Purchase',
                                                                            PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'Membership Purchase'});

            controller.initializeMembershipPurchase(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'Membership Purchase',
                                                                            PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'Membership Purchase',
                                                                            PORTAL_MembershipControllerBase.PAYMENT_METHOD => 'TouchNet'});

            setUpContacts();

            setUpSocietyMemberships();

            System.runAs(contactUser){
                controller.initializeMembershipPurchase(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'Membership Purchase',
                                                                                PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'Membership Purchase',
                                                                                PORTAL_MembershipControllerBase.MEMBERSHIP_RECORD_ID => societyMembership.Id});

                controller.initializeMembershipPurchase(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'Membership Purchase',
                                                                                PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'Membership Purchase',
                                                                                PORTAL_MembershipControllerBase.MEMBERSHIP_RECORD_ID => societyMembership.Id,
                                                                                PORTAL_MembershipControllerBase.PAYMENT_METHOD => 'TouchNet'});
            }
        }

        public virtual void testGetMembershipFieldsToPrepopulate() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();

            setUpContacts();
            setUpSocietyMemberships();

            controller.getMembershipFieldsToPrepopulate(null);

            controller.getMembershipFieldsToPrepopulate(new Map<String, Object>{'test' => 'test'});

            controller.getMembershipFieldsToPrepopulate(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'test',
                                                                                PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'test',
                                                                                PORTAL_MembershipControllerBase.SUB_SECTION_NAME => 'test',
                                                                                PORTAL_MembershipControllerBase.MEMBERSHIP_LEVEL_ID => societyMembership.ucinn_ascendv2__Membership_Level_Product__c});
            System.runAs(contactUser){
                controller.getMembershipFieldsToPrepopulate(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'Membership Purchase',
                                                                                PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'Membership Purchase',
                                                                                PORTAL_MembershipControllerBase.SUB_SECTION_NAME => 'One Time Membership',
                                                                                PORTAL_MembershipControllerBase.MEMBERSHIP_LEVEL_ID => societyMembership.ucinn_ascendv2__Membership_Level_Product__c});
            }

        }

        public virtual void testCreateReviewTransaction() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();

            setUpContacts();
            setUpSocietyMemberships();

            ucinn_ascendv2__Designation__c designation = new ucinn_ascendv2__Designation__c(
                Name = 'Athletics',
                ucinn_ascendv2__Designation_Name__c  = 'Athletics',
                ucinn_portal_Is_Display_On_Portal__c = true
            );
            insert designation;

            System.runAs(contactUser) {
                try {
                    controller.createReviewTransaction(null);
                } catch(Exception e) {}
                try {
                controller.createReviewTransaction(new Map<String, Object>{PORTAL_MembershipControllerBase.PAYMENT_METHOD => 'test', PORTAL_MembershipControllerBase.AMOUNT_CONST => 50, PORTAL_MembershipControllerBase.DESIGNATION_ID => designation.Id});
                } catch(Exception e) {}
            }
        }


        public virtual void testGetMembershipRecords() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();

            controller.getMembershipRecords(null);

            try {
                controller.getMembershipRecords(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'no logged in'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpSocietyMemberships();

            System.runAs(contactUser){
                controller.getMembershipRecords(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => '1Giving History',
                                                                        PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'TestActive Membership Table',
                                                                        PORTAL_MembershipControllerBase.SUB_SECTION_NAME => 'TestActive Memberships'});


                Map<String, Object> returnMap = controller.getMembershipRecords(new Map<String, Object>{PORTAL_MembershipControllerBase.PAGE_NAME => 'Memberships',
                                                                                                        PORTAL_MembershipControllerBase.MAIN_SECTION_NAME => 'Membership Table',
                                                                                                        PORTAL_MembershipControllerBase.SUB_SECTION_NAME => 'Active Memberships'});

                System.assert(!((List<Map<String, Object>>)returnMap.get(PORTAL_MembershipControllerBase.MEMBERSHIP_RECORDS)).isEmpty());
            }
        }

        public virtual void testGetMembershipContactInformation() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();

            try {
                controller.getMembershipContactInformation(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();

            System.runAs(contactUser){
                controller.getMembershipContactInformation(null);
            }
        }

        public virtual void testSaveMembershipRecords() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();
            controller.saveMembershipRecords(null);

            try {
                controller.saveMembershipRecords(new Map<String, Object>{'String' => 'Test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpSocietyMemberships();

            System.runAs(contactUser){
                controller.saveMembershipRecords(new Map<String, Object>{PORTAL_MembershipControllerBase.GLOBAL_MEMBERSHIP_RENEWAL_SOLICIT_OPT_OUT_VALUE => null,
                    PORTAL_MembershipControllerBase.MEMBERSHIPS_TO_UPDATE => new Map<Object, Object>{societyMembership.Id => true}});

                controller.saveMembershipRecords(new Map<String, Object>{PORTAL_MembershipControllerBase.GLOBAL_MEMBERSHIP_RENEWAL_SOLICIT_OPT_OUT_VALUE => true});

                controller.saveMembershipRecords(new Map<String, Object>{PORTAL_MembershipControllerBase.GLOBAL_MEMBERSHIP_RENEWAL_SOLICIT_OPT_OUT_VALUE => true,
                    PORTAL_MembershipControllerBase.MEMBERSHIPS_TO_UPDATE => new Map<Object, Object>{societyMembership.Id => true}});
            }
        }

        public virtual void testGetMembershipBenefitInformation() {
            PORTAL_MembershipControllerBase controller = new PORTAL_MembershipControllerBase();
            controller.saveMembershipRecords(null);

            try {
                controller.saveMembershipRecords(new Map<String, Object>{'String' => 'Test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            setUpContacts();
            setUpSocietyMemberships();
            setUpBenefits();

            System.runAs(contactUser){
                controller.getMembershipBenefitInformation(new Map<String, Object>{PORTAL_MembershipControllerBase.MEMBERSHIP_LEVEL_ID => null});

                controller.getMembershipBenefitInformation(new Map<String, Object>{PORTAL_MembershipControllerBase.MEMBERSHIP_LEVEL_ID => societyMembership.ucinn_ascendv2__Membership_Level_Product__c});
            }
        }
    }


    static testMethod void testinitializeMembershipPurchase() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testinitializeMembershipPurchase();
    }

    static testMethod void testGetMembershipFieldsToPrepopulate() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testGetMembershipFieldsToPrepopulate();
    }

    static testMethod void testCreateReviewTransaction() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testCreateReviewTransaction();
    }


    static testMethod void testGetMembershipRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testGetMembershipRecords();
    }

    static testMethod void testGetMembershipContactInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testGetMembershipContactInformation();
    }

    static testMethod void testSaveMembershipRecords() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testSaveMembershipRecords();
    }

    static testMethod void testGetMembershipBenefit() {
        PORTAL_TestClassFactory.getTestClassFactory().getMembershipControllerTestClass().testGetMembershipBenefitInformation();
    }

}