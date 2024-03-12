@isTest
public without sharing class PORTAL_BATCH_NewsletterFilterTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public Contact cont;
        public Contact cont2;
        public ucinn_portal_Listing__c listing;
        public ucinn_portal_Recipient__c recipient;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setup(){
            System.runAs(thisUser) {
                ucinn_ascendv2__Org_Wide_Configuration__c orgSettings = new ucinn_ascendv2__Org_Wide_Configuration__c();
                orgSettings.Name = 'Default Org Wide Config';
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Addresses_Enabled__c = true;
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Phones_Enabled__c = true;
                orgSettings.ucinn_ascendv2__Is_Multiple_Current_Emails_Enabled__c = true;
                orgSettings = (ucinn_ascendv2__Org_Wide_Configuration__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => orgSettings});
                insert orgSettings;


                Account acct = new Account();
                acct.Name = 'Test Household';
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                cont = new Contact();
                cont.Email = 'demo@ucinnovation.com';
                cont.FirstName = 'Test 1';
                cont.LastName = 'Test';
                cont.AccountId = acct.Id;
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                insert cont;

                cont2 = new Contact();
                cont2.Email = 'demo+test@ucinnovation.com';
                cont2.FirstName = 'Non DupTest 2';
                cont2.LastName = 'Test';
                cont2.AccountId = acct.Id;
                cont2 = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont2});
                insert cont2;

                ucinn_ascendv2__Contact_Name__c name1 = new ucinn_ascendv2__Contact_Name__c();
                name1.ucinn_ascendv2__Last_Name__c = 'Test';
                name1.ucinn_ascendv2__First_Name__c = 'Test 1';
                name1.ucinn_ascendv2__Type__c = 'Full Name';
                name1.ucinn_ascendv2__Contact__c = cont.Id;
                name1 = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => name1});
                insert name1;

                ucinn_ascendv2__Contact_Name__c name2 = new ucinn_ascendv2__Contact_Name__c();
                name2.ucinn_ascendv2__Last_Name__c = 'Test';
                name2.ucinn_ascendv2__First_Name__c = 'Test 2';
                name2.ucinn_ascendv2__Type__c = 'Full Name';
                name2.ucinn_ascendv2__Contact__c = cont2.Id;
                name2 = (ucinn_ascendv2__Contact_Name__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => name2});
                insert name2;

                ucinn_ascendv2__Phone__c phone1 = new ucinn_ascendv2__Phone__c();
                phone1.ucinn_ascendv2__Phone_Number__c = '9876543210';
                phone1.ucinn_ascendv2__Type__c = 'Home - Cell';
                phone1.ucinn_ascendv2__Status__c = 'Current';
                phone1.ucinn_ascendv2__Contact__c = cont.Id;
                phone1 = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => phone1});
                insert phone1;

                ucinn_ascendv2__Phone__c phone2 = new ucinn_ascendv2__Phone__c();
                phone2.ucinn_ascendv2__Phone_Number__c = '9876543210';
                phone2.ucinn_ascendv2__Type__c = 'Home - Cell';
                phone2.ucinn_ascendv2__Status__c = 'Current';
                phone2.ucinn_ascendv2__Contact__c = cont2.Id;
                phone2 = (ucinn_ascendv2__Phone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => phone2});
                insert phone2;

                ucinn_ascendv2__Email__c email1 = new ucinn_ascendv2__Email__c();
                email1.ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com';
                email1.ucinn_ascendv2__Type__c = 'Personal';
                email1.ucinn_ascendv2__Status__c = 'Current';
                email1.ucinn_ascendv2__Contact__c = cont.Id;
                email1 = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email1});
                insert email1;


                ucinn_ascendv2__Email__c email2 = new ucinn_ascendv2__Email__c();
                email2.ucinn_ascendv2__Email_Address__c = 'demo@ucinnovation.com';
                email2.ucinn_ascendv2__Type__c = 'Personal';
                email2.ucinn_ascendv2__Status__c = 'Current';
                email2.ucinn_ascendv2__Contact__c = cont2.Id;
                email2 = (ucinn_ascendv2__Email__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => email2});
                insert email2;


                recipient = new ucinn_portal_Recipient__c();
                recipient.Filter_Logic__c = '1 AND 2 AND 3 AND 4 AND 5';
                recipient.Name = 'Test Filter';
                recipient = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => recipient});
                insert recipient;

                ucinn_portal_Recipient_Filter__c filter1 = new ucinn_portal_Recipient_Filter__c();
                filter1.Contact_Relationship_Api_Name__c = 'ucinn_ascendv2__Contact_Names__r';
                filter1.Field_API_Name__c = 'ucinn_ascendv2__Last_Name__c';
                filter1.Field_Value__c = 'Test';
                filter1.Object_API_Name__c = 'ucinn_ascendv2__Contact_Name__c';
                filter1.Operator__c = '=';
                filter1.Order_Number__c = '1';
                filter1.Recipient__c = recipient.Id;
                filter1 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter1});
                insert filter1;

                ucinn_portal_Recipient_Filter__c filter2 = new ucinn_portal_Recipient_Filter__c();
                filter2.Contact_Relationship_Api_Name__c = '';
                filter2.Field_API_Name__c = 'FirstName';
                filter2.Field_Value__c = 'Test 1';
                filter2.Object_API_Name__c = 'Contact';
                filter2.Operator__c = '=';
                filter2.Order_Number__c = '2';
                filter2.Recipient__c = recipient.Id;
                filter2 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter2});
                insert filter2;

                ucinn_portal_Recipient_Filter__c filter3 = new ucinn_portal_Recipient_Filter__c();
                filter3.Contact_Relationship_Api_Name__c = 'ucinn_ascendv2__Contact_Emails__c';
                filter3.Field_API_Name__c = 'ucinn_ascendv2__Email_Address__c';
                filter3.Field_Value__c = 'demo@ucinnovation.com';
                filter3.Object_API_Name__c = 'ucinn_ascendv2__Email__c';
                filter3.Operator__c = '=';
                filter3.Order_Number__c = '3';
                filter3.Recipient__c = recipient.Id;
                filter3 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter3});
                insert filter3;

                ucinn_portal_Recipient_Filter__c filter4 = new ucinn_portal_Recipient_Filter__c();
                filter4.Contact_Relationship_Api_Name__c = 'ucinn_ascendv2__Contact_Phones__c';
                filter4.Field_API_Name__c = 'ucinn_ascendv2__Phone_Number__c';
                filter4.Field_Value__c = '9876543210';
                filter4.Object_API_Name__c = 'ucinn_ascendv2__Phone__c';
                filter4.Operator__c = '=';
                filter4.Order_Number__c = '4';
                filter4.Recipient__c = recipient.Id;
                filter4 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter4});
                insert filter4;

                ucinn_portal_Recipient_Filter__c filter5 = new ucinn_portal_Recipient_Filter__c();
                filter5.Contact_Relationship_Api_Name__c = '';
                filter5.Field_API_Name__c = 'ucinn_ascendv2__Contact_Type__c';
                filter5.Field_Value__c = 'Friend';
                filter5.Object_API_Name__c = 'Contact';
                filter5.Operator__c = 'INCLUDES';
                filter5.Order_Number__c = '5';
                filter5.Recipient__c = recipient.Id;
                filter5 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter5});
                insert filter5;

                ucinn_portal_Zone__c defaultZone = new ucinn_portal_Zone__c(Name=PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME, Is_Display_on_Portal__c = true);
                defaultZone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => defaultZone});
                insert defaultZone;

                listing = new ucinn_portal_Listing__c();
                listing.Name = 'Test Newsletter';
                listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
                listing.Body_Content__c = 'Dear Test';
                listing.Recipient__c = recipient.Id;
                listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
                listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
                insert listing;
            }
        }

        public virtual void testFirstConstructor() {
            this.setup();

            List<String> postfix = new List<String>();
            String filterId = 'TestFilterId';
            String newsletterId ='TestNewsletterId';
            String cacheId;
            String operator;
            String email;
            Boolean countRecipients;
            Boolean postProcessingFilters;
            PORTAL_BATCH_NewsletterFilter filterBatch;

            // normal working case for constructor #1
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, cacheId, operator, email, countRecipients, postProcessingFilters, DateTime.now());

            Database.executeBatch(filterBatch, 2000);

            try {
                Database.executeBatch(new PORTAL_BATCH_NewsletterFilter(null, filterId, newsletterId, cacheId, operator, email, countRecipients, postProcessingFilters, DateTime.now()));
            } catch (Exception e) {

            }

        }

        public virtual void testNormalBatchRun() {
            this.setup();

            ucinn_portal_Recipient__c filter = [SELECT Id, Filter_Logic__c FROM ucinn_portal_Recipient__c].get(0);
            Id newsletterId = [SELECT Id FROM ucinn_portal_Listing__c].get(0).Id;
            List<String> postFix = PORTAL_CommunityUtils.infixToPostfix(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_LOGIC_STRING => filter.Filter_Logic__c});
            Database.executeBatch(new PORTAL_BATCH_NewsletterFilter(postfix, filter.Id, newsletterId, null, null, 'atran@ucinnovation.com', null, null, DateTime.now()));
        }

        public virtual void testStartMethod() {
            this.setup();

            List<String> postfix = new List<String>{'1', '2' , 'OR'};//, 'AND', 'IDKASDKI', 'OR', 'sefqwerawer', 'AND', 'sdfasdfasdf', 'OR', '2'};
            String filterId = 'TestFilterId';
            String newsletterId ='TestNewsletterId';
            String email = 'atran@ucinnovation.com';
            PORTAL_BATCH_NewsletterFilter filterBatch;
            ucinn_portal_Recipient__c recipientsFilter = new ucinn_portal_Recipient__c(Filter_Logic__c='1 OR 2 AND Fail OR Fail AND Fail OR 2',
                                                             Name='filter');
            recipientsFilter = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => recipientsFilter});
            insert recipientsFilter;
            filterId = recipientsFilter.Id;

            List<ucinn_portal_Recipient_Filter__c> filters = new List<ucinn_portal_Recipient_Filter__c>();
            ucinn_portal_Recipient_Filter__c filter1 = new ucinn_portal_Recipient_Filter__c(Recipient__c = recipientsFilter.Id,
                                                                                    Name='filter1',
                                                                                    Field_API_Name__c='Id',
                                                                                    Field_Value__c='0035B00000Q1yODQAZ',
                                                                                    Object_API_Name__c='Contact',
                                                                                    Order_Number__c = '1',
                                                                                    Operator__c ='=');
            ucinn_portal_Recipient_Filter__c filter2 = new ucinn_portal_Recipient_Filter__c(Recipient__c = recipientsFilter.Id,
                                                                                    Name='filter2',
                                                                                    Field_API_Name__c='ucinn_ascendv2__Contact__r.LastName',
                                                                                    Field_Value__c='Test',
                                                                                    Object_API_Name__c='ucinn_ascendv2__Degree_Information__c',
                                                                                    Order_Number__c = '2',
                                                                                    Operator__c = '=');
            filter1 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter1});
            filter2 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter2});
            filters.add(filter1);
            filters.add(filter2);
            insert filters;

            // both operands are numeric case
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, email, null, null, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // opreand 1 is number
            postfix = new List<String>{'1', 'String', 'OR'};
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, email, null, null, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // operand 2 is number
            postfix = new List<String>{'String', '2', 'OR'};
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, email, null, null, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // postfix size of one
            postfix = new List<String>{'2'};
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, email, null, null, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // Both are caches
            postfix = new List<String>{filter1.Id, filter2.Id, 'OR'};
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, email, null, null, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // post processing filters is true
            postfix = new List<String>();
            Boolean postProcessingFilters = true;
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, email, null, postProcessingFilters, DateTime.now());
        }

        public virtual void testExecuteAndFinishMethod() {
            this.setup();

            List<String> postfix = new List<String>{'1', '2' , 'AND', '1', 'OR', '1', 'AND', '1', '2', 'AND'};
            String newsletterId ='asdfasdf';
            String email = 'atran@ucinnovation.com';
            PORTAL_BATCH_NewsletterFilter filterBatch;
            ucinn_portal_Recipient__c recipientsFilter = new ucinn_portal_Recipient__c(Filter_Logic__c='1 OR 2 AND IDKASDKI OR sefqwerawer AND sdfasdfasdf OR 2',
                                                                        Name='filter');
            recipientsFilter = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => recipientsFilter});
            insert recipientsFilter;
            String filterId = recipientsFilter.Id;

            List<ucinn_portal_Recipient_Filter__c> filters = new List<ucinn_portal_Recipient_Filter__c>();
            ucinn_portal_Recipient_Filter__c filter1 = new ucinn_portal_Recipient_Filter__c(Recipient__c = recipientsFilter.Id,
                                                                                    Name='filter1',
                                                                                    Field_API_Name__c='LastName',
                                                                                    Field_Value__c='testName',
                                                                                    Object_API_Name__c='Contact',
                                                                                    Order_Number__c = '1',
                                                                                    Operator__c ='=');
            ucinn_portal_Recipient_Filter__c filter2 = new ucinn_portal_Recipient_Filter__c(Recipient__c = recipientsFilter.Id,
                                                                                    Name='filter2',
                                                                                    Field_API_Name__c='Email',
                                                                                    Field_Value__c='testCommunityUsermig123@test.com',
                                                                                    Object_API_Name__c='Contact',
                                                                                    Order_Number__c = '2',
                                                                                    Operator__c = '=');
            filter1 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter1});
            filter2 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter2});
            filters.add(filter1);
            filters.add(filter2);
            insert filters;

            Account acct = new Account(name = 'test account');
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;

            List<Contact> contacts = new List<Contact>();
            List<Id> contactsId = new List<Id>();
            Integer numberOfContacts = 10;

            for (Integer index = 0; index < numberOfContacts; index++) {
                Contact cont = new Contact(LastName = 'testName',
                                            AccountId = acct.Id,
                                            Email = 'testCommunityUsermig123@test.com');
                cont = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cont});
                contacts.add(cont);
            }
            insert contacts;

            for (Integer index = 0; index < numberOfContacts; index++) {
                contactsId.add(contacts[index].Id);
            }

            Id newsletterFilterRecordId = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.getRecordTypeInfosByDeveloperName().get('Newsletter_Filter').getRecordTypeId();
            ucinn_portal_Search_Filter_Cache__c searchFilterCache = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = '_All_Contacts_Cache_',
                                                                                                        Order_Number__c = 1,
                                                                                                        Contact_Id_Cache_2__c = String.join(contactsId, ';'),
                                                                                                        recordTypeId = newsletterFilterRecordId);
            searchFilterCache = (ucinn_portal_Search_Filter_Cache__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => searchFilterCache});
            insert searchFilterCache;

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, null, null, null, null, DateTime.now());
            Database.executeBatch(filterBatch, 2000);

            // both are caches
            ucinn_portal_Search_Filter_Cache__c searchFilterCache1 = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = 'cache1',
                                                                                                        Order_Number__c = 1,
                                                                                                        Contact_Id_Cache_2__c = String.join(contactsId, ';'),
                                                                                                        recordTypeId = newsletterFilterRecordId);

            ucinn_portal_Search_Filter_Cache__c searchFilterCache2 = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = 'cache2',
                                                                                                                Order_Number__c = 1,
                                                                                                                Contact_Id_Cache_2__c = String.join(contactsId, ';'),
                                                                                                                recordTypeId = newsletterFilterRecordId);
            searchFilterCache1 = (ucinn_portal_Search_Filter_Cache__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => searchFilterCache1});
            searchFilterCache2 = (ucinn_portal_Search_Filter_Cache__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => searchFilterCache2});
            insert searchFilterCache1;
            insert searchFilterCache2;

            postfix = new List<String>{searchFilterCache1.Cache_API_Name__c, searchFilterCache2.Cache_API_Name__c, 'OR'};

            // both caches with operator or
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, searchFilterCache2.Cache_API_Name__c, 'OR', null, null, false, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // both caches with operator AND
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, searchFilterCache2.Cache_API_Name__c, 'AND', null, null, false, DateTime.now());

            Database.executeBatch(filterBatch, 2000);

            postfix = new List<String>{searchFilterCache1.Cache_API_Name__c, searchFilterCache2.Cache_API_Name__c, 'AND'};

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, searchFilterCache2.Cache_API_Name__c, 'IN', null, null, false, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            ucinn_portal_Recipient_Filter__c filter3 = new ucinn_portal_Recipient_Filter__c(Recipient__c = recipientsFilter.Id,
                                                                                        Name='filter3',
                                                                                        Field_API_Name__c='Email',
                                                                                        Field_Value__c='DOESNT EXIST!',
                                                                                        Object_API_Name__c='Contact',
                                                                                        Order_Number__c = '3',
                                                                                        Operator__c = '=');
            filter3 = (ucinn_portal_Recipient_Filter__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter3});
            insert filter3;
            postfix = new List<String>{filter3.Order_Number__c};

            // no jobs
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, 'OR', null, null, false, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            // finish method

            // count recipients
            Id newsletterListingRecordId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter').getRecordTypeId();

            ucinn_portal_Listing__c newsletterListing = new ucinn_portal_Listing__c(RecordTypeId = newsletterListingRecordId,
                                                                                    Is_Newsletter_Sent__c = false,
                                                                                    Portal_Zone__c = 'Alumni Club of Irvine',
                                                                                    Number_of_Newsletter_Recipients__c = 120,
                                                                                    Start_Date_time__c = DateTime.now().addYears(2),
                                                                                    End_Date_Time__c = DateTime.now().addYears(5),
                                                                                    Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                                                                                    Body_Content__c = '<p>Test Body Content</p>');
            newsletterListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterListing});
            insert newsletterListing;

            ucinn_portal_Zone__c alumniClubOfIrvine = new ucinn_portal_Zone__c(Name='Alumni Club of Irvine', Is_Display_on_Portal__c = true);
            alumniClubOfIrvine = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => alumniClubOfIrvine});
            insert alumniClubOfIrvine;

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterListing.Id, null, 'OR', null, true, true, DateTime.now());

            Database.executeBatch(filterBatch, 2000);


            ucinn_portal_Listing__c newsletterListing2 = new ucinn_portal_Listing__c(RecordTypeId = newsletterListingRecordId,
                                                                                    Is_Newsletter_Sent__c = false,
                                                                                    Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME,
                                                                                    Number_of_Newsletter_Recipients__c = 120,
                                                                                    Start_Date_time__c = DateTime.now().addYears(2),
                                                                                    End_Date_Time__c = DateTime.now().addYears(5),
                                                                                    Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Los_Angeles)',
                                                                                    Body_Content__c = '<p>Test Body Content</p>');
            newsletterListing2 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterListing2});
            insert newsletterListing2;

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterListing2.Id, null, 'OR', null, true, true, DateTime.now());

            Database.executeBatch(filterBatch, 2000);
        }

        public virtual void testGetNextEmptyCache() {
            setup();
            List<String> postfix = new List<String>();
            String filterId = 'TestFilterId';
            String newsletterId ='TestNewsletterId';
            String cacheId;
            String operator;
            String email;
            Boolean countRecipients;
            Boolean postProcessingFilters;
            PORTAL_BATCH_NewsletterFilter filterBatch;

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, cacheId, operator, email, countRecipients, postProcessingFilters, DateTime.now());
            Id newsletterFilterRecordId = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.getRecordTypeInfosByDeveloperName().get('Newsletter_Filter').getRecordTypeId();

            ucinn_portal_Search_Filter_Cache__c hiringManagerCache = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = 'Hiring_Managers_Cache',
                                                                                                            Filter_Value__c = 'true',
                                                                                                            Order_Number__c = 1,
                                                                                                            recordTypeId = newsletterFilterRecordId);


            for (Integer index = 1; index <= 12; index++) {
                String cacheFieldName = 'Contact_Id_Cache_' + index + '__c';

                String cacheField = '';

                Integer fieldMaxSize = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.fields.getMap().get(cacheFieldName).getDescribe().getLength();

                while (cacheField.length() + 19 <= fieldMaxSize) {
                    cacheField = cacheField + 'testertestertester;';
                }

                hiringManagerCache.put(cacheFieldName, cacheField);
            }
            insert hiringManagerCache;

            Test.startTest();

            filterBatch.getNextEmptyCache('Hiring_Managers_Cache');

            Test.stopTest();
        }

        public virtual void testAddSetToCache() {
            setup();
            List<String> postfix = new List<String>();
            String filterId = 'TestFilterId';
            String newsletterId ='TestNewsletterId';
            String cacheId;
            String operator;
            String email;
            Boolean countRecipients;
            Boolean postProcessingFilters;
            PORTAL_BATCH_NewsletterFilter filterBatch;

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, cacheId, operator, email, countRecipients, postProcessingFilters, DateTime.now());

            ucinn_portal_Search_Filter_Cache__c hiringManagerCache = new ucinn_portal_Search_Filter_Cache__c(Cache_API_Name__c = 'Hiring_Managers_Cache',
                                                                                                            Filter_Value__c = 'true',
                                                                                                            Order_Number__c = 1);


            for (Integer index = 1; index <= 12; index++) {
                String cacheFieldName = 'Contact_Id_Cache_' + index + '__c';

                String cacheField = '';

                Integer fieldMaxSize = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.fields.getMap().get(cacheFieldName).getDescribe().getLength();

                while (cacheField.length() + 19 <= fieldMaxSize) {
                    cacheField = cacheField + 'testertestertester;';
                }

                hiringManagerCache.put(cacheFieldName, cacheField);
            }
            Set<String> contactIds = new Set<String>{(String)cont.Id};

            Test.startTest();

            filterBatch.addSetToCache(contactIds, hiringManagerCache);

            String cacheFieldName = 'Contact_Id_Cache_12__c';
            String cacheField = '';
            Integer fieldMaxSize = Schema.SObjectType.ucinn_portal_Search_Filter_Cache__c.fields.getMap().get(cacheFieldName).getDescribe().getLength();
            while (cacheField.length() + 57 <= fieldMaxSize) {
                cacheField = cacheField + 'testertestertester;';
            }
            hiringManagerCache.put(cacheFieldName, cacheField);

            filterBatch.addSetToCache(contactIds, hiringManagerCache);

            cacheFieldName = 'Contact_Id_Cache_11__c';
            hiringManagerCache.put(cacheFieldName, cacheField);

            filterBatch.addSetToCache(contactIds, hiringManagerCache);


            Test.stopTest();
        }

        public virtual void testGetDisplayTypeForFilter() {
            setup();
            List<String> postfix = new List<String>();
            String filterId = 'TestFilterId';
            String newsletterId ='TestNewsletterId';
            String cacheId;
            String operator;
            String email;
            Boolean countRecipients;
            Boolean postProcessingFilters;
            PORTAL_BATCH_NewsletterFilter filterBatch;

            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, cacheId, operator, email, countRecipients, postProcessingFilters, DateTime.now());

            // DescribeSObjectResult filterObjectDescribeResult = new DescribeSObjectResult();

            Test.startTest();

            try {
                filterBatch.getDisplayTypeForFilter(null, 'Test__r.Test', null);
            } catch (Exception e) {
                System.debug(e);
            }

            try {
                filterBatch.getDisplayTypeForFilter(null, 'Test__r.Test.Test', null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testRunNextBatch() {
            setup();
            List<String> postfix = new List<String>{'Test', 'Test' , 'OR', 'Test'};//, 'AND', 'IDKASDKI', 'OR', 'sefqwerawer', 'AND', 'sdfasdfasdf', 'OR', '2'};
            String filterId = 'TestFilterId';
            String newsletterId ='TestNewsletterId';
            String email = 'atran@ucinnovation.com';
            PORTAL_BATCH_NewsletterFilter filterBatch;
            ucinn_portal_Recipient__c recipientsFilter = new ucinn_portal_Recipient__c(Filter_Logic__c='1 OR 2 AND Fail OR Fail AND Fail OR 2',
                                                             Name='filter');
            recipientsFilter = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => recipientsFilter});
            insert recipientsFilter;
            filterId = recipientsFilter.Id;

            Boolean postProcessingFilters = true;
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, 'OR', email, null, postProcessingFilters, DateTime.now());

            Test.startTest();

            try {
                filterBatch.runNextBatch(null, 0);
            } catch (Exception e) {
                System.debug(e);
            }

            postfix = new List<String>{'1', 'Test' , 'OR', 'Test'};
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, 'OR', email, null, postProcessingFilters, DateTime.now());
            try {
                filterBatch.runNextBatch(null, 0);
            } catch (Exception e) {
                System.debug(e);
            }

            postfix = new List<String>{'Test', '1' , 'OR', 'Test'};
            filterBatch = new PORTAL_BATCH_NewsletterFilter(postfix, filterId, newsletterId, null, 'OR', email, null, postProcessingFilters, DateTime.now());
            try {
                filterBatch.runNextBatch(null, 0);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    } //-----Class End------

    // @TestSetup
    // static void setup(){
    //     PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().setup();
    // }

    @isTest
    public static void testFirstConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testFirstConstructor();
    }

    @isTest
    public static void testNormalBatchRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testNormalBatchRun();
    }

    @isTest
    public static void testStartMethod() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testStartMethod();
    }

    @isTest
    static void testExecuteAndFinishMethod() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testExecuteAndFinishMethod();
    }

    @isTest
    static void testGetNextEmptyCache() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testGetNextEmptyCache();
    }

    @isTest
    static void testAddSetToCache() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testAddSetToCache();
    }

    @isTest
    static void testGetDisplayTypeForFilter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testGetDisplayTypeForFilter();
    }

    @isTest
    static void testRunNextBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterFilterTestClass().testRunNextBatch();
    }
}