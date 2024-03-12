/*
 * Copyright (c) 2019, UC Innovation, Inc.  All Rights Reserved.
 *                     http://www.ucinnovation.com
 *
 * This source code is licensed, not sold, and is subject to a written
 * license agreement.  Among other things, no portion of this source
 * code may be copied, transmitted, disclosed, displayed, distributed,
 * translated, used as the basis for a derivative work, or used, in
 * whole or in part, for any program or purpose other than its intended
 * use in compliance with the license agreement as part of UC Innovation's
 * software.  This source code and certain of the algorithms contained
 * within it are confidential trade secrets of UC Innovation, Inc.
 * and may not be used as the basis for any other
 * software, hardware, product or service.
 */

@isTest
public class PORTAL_ML_PossibilityCalculationTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact con;
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'System Administrator'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');

                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testPortalUsermig123@test.com',
                                        ucinn_portal_Recommend_Type_1__c = 'Law',
                                        ucinn_portal_Recommend_Type_2__c = 'Culture',
                                        ucinn_portal_Recommend_Type_3__c = 'Global');

                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.EVENT).getRecordTypeId();

                ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                        Recommend_Type_2__c = 'Culture',
                                                                        Recommend_Type_3__c = 'Global',
                                                                        RecordTypeId = recordTypeId,
                                                                        Portal_Zone__c = 'All',
                                                                        Name = 'a');

                testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
                insert testListing;

                ucinn_portal_Listing__c testListing1 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                        Recommend_Type_2__c = 'Culture',
                                                                                        Recommend_Type_3__c = 'Global',
                                                                                        RecordTypeId = recordTypeId,
                                                                                        Portal_Zone__c = 'All',
                                                                                        Name = 'b');
                testListing1 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing1});
                insert testListing1;

                ucinn_portal_Listing__c testListing2 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Law',
                                                                                    Recommend_Type_2__c = 'Culture',
                                                                                    Recommend_Type_3__c = 'Global',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Name = 'c');
                testListing2 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing2});
                insert testListing2;

                ucinn_portal_Listing__c testListing3 = new ucinn_portal_Listing__c(Recommend_Type_1__c = 'Medicine',
                                                                                    Recommend_Type_2__c = 'History',
                                                                                    Recommend_Type_3__c = 'Space',
                                                                                    RecordTypeId = recordTypeId,
                                                                                    Portal_Zone__c = 'All',
                                                                                    Name = 'ab');
                testListing3 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing3});
                insert testListing3;
            }
        }

        public virtual void simulateWeightMap() {

            setupData();

            PORTAL_ML_PossibilityCalculation calc = new PORTAL_ML_PossibilityCalculation(communityUser);

            calc.simulateWeightMap();
        }
    }


    @isTest
    public static void simulateWeightMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getMlPossibilityCalculationTestClass().simulateWeightMap();
    }
}