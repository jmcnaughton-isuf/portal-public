@isTest
global class PORTAL_API_EmailHubBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_HttpMockCallout mockcallouts;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetEmailInterface() {
            Test.startTest();
            PORTAL_API_EmailHubBase emailHub = PORTAL_API_EmailHubBase.getEmailHub();

            try {
                emailHub.getEmailInterface();
            } catch (Exception e) {}

            try {
                PORTAL_API_EmailHubBase.getEmailApiService();
            } catch (Exception e) {}
            Test.stopTest();
        }

        public virtual void testGetUnsubscribeUrl() {
            Test.startTest();
            PORTAL_API_EmailHubBase.getUnsubscribeUrl(null);
            Test.stopTest();
        }

        public virtual void testScheduleEmail() {

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            zone.Newsletter_HTML_Format__c = 'test';
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;
            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
            zoneList.add(zone);

            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = PORTAL_NewsletterControllerBase.NEWSLETTER_TEMPLATE_NAME;
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;

            ucinn_portal_Newsletter_Section__c module = new ucinn_portal_Newsletter_Section__c();
            module.Name = 'Test Section';
            module.RecordTypeId = Schema.SObjectType.ucinn_portal_Newsletter_Section__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_SECTION_TEMPLATE_RECORD_TYPE).getRecordTypeId();
            module.Newsletter_Listing__c = newsletterTemplate.Id;
            module = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => module});
            insert module;

            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = zone.Name;
            listing.Body_Content__c = 'Dear Test';
            listing.Status__c = 'Pending';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;


            Map<String,Object> params = new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY, listing.Id);
            params.put(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY, Datetime.now());

            Test.startTest();
            try {
                PORTAL_API_EmailHubBase.scheduleEmail(params);
            } catch(exception e) {}
            Test.stopTest();
        }

        public virtual void testScheduleTransactionalEmail() {
            mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            Map<String, Object> params = new Map<String, Object>();

            Test.startTest();
            PORTAL_API_EmailHubBase.scheduleTransactionalEmail(params);
            Test.stopTest();
        }

        public virtual void testUnscheduleTransactionalEmail() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter').getRecordTypeId();
            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Name = 'Test listing',
                                                                            Header_Content__c = 'This is a Test.',
                                                                            RecordTypeId = recordTypeId,
                                                                            Status__c = PORTAL_NewsletterControllerBase.SCHEDULED_STATUS);
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;

            Map<String, Object> params = new Map<String, Object>{PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY => testListing.Id};

            Test.startTest();
            try {
                PORTAL_API_EmailHubBase.unscheduleEmail(null);
            } catch(exception e) {}

            try {
                PORTAL_API_EmailHubBase.unscheduleEmail(params);
            } catch(exception e) {}

            String chron = '0 0 23 * * ?';        
            System.scheduleBatch(new PORTAL_BATCH_NewsletterFilter(new List<String>(), '', '', null, null, null, null, null, null), 'Test', 1000);

            List<sObject> availableJobs = [Select id from CronTrigger];

            System.debug(availableJobs);

            if (availableJobs != null && !availableJobs.isEmpty()) {
                testListing.Scheduled_Job_Id__c = availableJobs[0].Id;
                update testListing;
            } else {
                testListing.Scheduled_Job_Id__c = 'testId';
                update testListing;
            }

            try {
                PORTAL_API_EmailHubBase.unscheduleEmail(params);
            } catch(exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testcreateOrUpdateExternalMailingLists() {
            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;
            Set<Id> zoneIds = new Set<Id>();
            zoneIds.add(zone.Id);

            Test.startTest();
            PORTAL_API_EmailHubBase.createOrUpdateExternalMailingLists(zoneIds);
            Test.stopTest();
        }

        public virtual void addOrUpdateContactsToExternalApi() {
            List<Contact> contactList = new List<Contact>();
            Contact con = new Contact(Email = 'testEmail@test.com.invalid', FirstName = 'test', LastName = 'test');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;
            Set<Id> conIds = new Set<Id>();

            Test.startTest();
            try {
                PORTAL_API_EmailHubBase.addOrUpdateContactsToExternalApi(conIds);
            } catch(exception e) {}
            Test.stopTest();
        }

        public virtual void testremoveContactsFromExternalApi() {
            Set<String> externalIds = new Set<String>();
            externalIds.add('testExternalId');

            Test.startTest();
            try {
                PORTAL_API_EmailHubBase.removeContactsFromExternalApi(externalIds);
            } catch(exception e) {}
            Test.stopTest();
        }

        public virtual void testUpdateMetrics() {

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter').getRecordTypeId();
            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Name = 'Test listing',
                                                                            Header_Content__c = 'This is a Test.',
                                                                            RecordTypeId = recordTypeId,
                                                                            Status__c = 'Pending');
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;

            mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);

            Set<String> externalIds = new Set<String>();
            String externalId =  'testExternalId';
            String newsletterId = testListing.Id;

            Test.startTest();
            PORTAL_API_EmailHubBase.updateMetrics(newsletterId, externalId);
            Test.stopTest();
        }

        public virtual void testScheduleEmailInvalidInput() {
            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            zone.Newsletter_HTML_Format__c = 'test';
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;
            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
            zoneList.add(zone);

            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = PORTAL_NewsletterControllerBase.NEWSLETTER_TEMPLATE_NAME;
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;

            ucinn_portal_Newsletter_Section__c module = new ucinn_portal_Newsletter_Section__c();
            module.Name = 'Test Section';
            module.RecordTypeId = Schema.SObjectType.ucinn_portal_Newsletter_Section__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_SECTION_TEMPLATE_RECORD_TYPE).getRecordTypeId();
            module.Newsletter_Listing__c = newsletterTemplate.Id;
            module = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => module});
            insert module;

            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = zone.Name;
            listing.Body_Content__c = 'Dear Test';
            listing.Status__c = 'Pending';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            Test.startTest();

            try {
                PORTAL_API_EmailHubBase.scheduleEmail(new Map<String, Object>());
            } catch (Exception e) {
                System.assertEquals('Error scheduling email. newsletter id was not passed as a param', e.getMessage());
            }

            try {
                PORTAL_API_EmailHubBase.scheduleEmail(new Map<String, Object>{'newsletterId'=> listing.Id});
            } catch (Exception e) {
                System.assertEquals('Error scheduling email.  Delivery time was not passed as a param', e.getMessage());
            }
            
            try {
                PORTAL_API_EmailHubBase.scheduleEmail(new Map<String, Object>{'newsletterId'=> listing.Id,
                                                                            'deliveryTime' => Datetime.now()});
            } catch (Exception e) {
                System.debug(e);
            }


            delete zone;
            try {
                PORTAL_API_EmailHubBase.scheduleEmail(new Map<String, Object>{'newsletterId'=> listing.Id,
                                                                            'deliveryTime' => Datetime.now()});
            } catch (Exception e) {
                System.debug(e);
            }


            Id deletedListingId = listing.Id;
            delete listing;
            try {
                PORTAL_API_EmailHubBase.scheduleEmail(new Map<String, Object>{'newsletterId'=> deletedListingId,
                                                                            'deliveryTime' => Datetime.now()});
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testUnscheduleEmailInvalidInput() {
            Test.startTest();

            try {
                PORTAL_API_EmailHubBase.unscheduleEmail(new Map<String, Object>());
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testUpdateMetricsInvalidInput() {
            Test.startTest();

            try {
                PORTAL_API_EmailHubBase.updateMetrics('', '');
            } catch (Exception e) {
                System.assertEquals('No listing Id provided for update metrics.', e.getMessage());
            }

            try {
                PORTAL_API_EmailHubBase.updateMetrics(null, null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testcreateOrUpdateExternalMailingListsException() {
            Test.startTest();
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_API_EmailHubBase.createOrUpdateExternalMailingListsNonFuture(null);
            } catch (Exception e) {
                System.debug(e);
            }


            Test.stopTest();
        }

        public virtual void testAddOrUpdateContactsToExternalApiNonFutureException() {
            Test.startTest();
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_API_EmailHubBase.addOrUpdateContactsToExternalApiNonFuture(null);
            } catch (Exception e) {
                System.debug(e);
            }


            Test.stopTest();
        }

        public virtual void testRemoveContactsFromExternalApiException() {
            Test.startTest();
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_API_EmailHubBase.removeContactsFromExternalApi(null);
            } catch (Exception e) {
                System.debug(e);
            }


            Test.stopTest();
        }

        public virtual void testUpdateMetricsException() {
            Test.startTest();
            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_API_EmailHubBase.updateMetrics('Test', 'Test');
            } catch (Exception e) {
                System.debug(e);
            }


            Test.stopTest();
        }
    }

    @isTest
    global static void testGetEmailInterface() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testGetEmailInterface();
    }

    @isTest
    global static void testGetUnsubscribeUrl() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testGetUnsubscribeUrl();
    }

    @isTest
    global static void testScheduleEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testScheduleEmail();
    }

    @isTest
    global static void testScheduleTransactionalEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testScheduleTransactionalEmail();
    }

    @isTest
    global static void testUnscheduleTransactionalEmail() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testUnscheduleTransactionalEmail();
    }

    @isTest
    global static void testcreateOrUpdateExternalMailingLists() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testcreateOrUpdateExternalMailingLists();
    }

    @isTest
    global static void addOrUpdateContactsToExternalApi() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().addOrUpdateContactsToExternalApi();
    }

    @isTest
    global static void testremoveContactsFromExternalApi() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testremoveContactsFromExternalApi();
    }

    @isTest
    global static void testUpdateMetrics() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testUpdateMetrics();
    }

    @isTest
    global static void testScheduleEmailInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testScheduleEmailInvalidInput();
    }

    @isTest
    global static void testUnscheduleEmailInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testUnscheduleEmailInvalidInput();
    }


    @isTest
    global static void testUpdateMetricsInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testUpdateMetricsInvalidInput();
    }


    @isTest
    global static void testcreateOrUpdateExternalMailingListsException() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testcreateOrUpdateExternalMailingListsException();
    }


    @isTest
    global static void testAddOrUpdateContactsToExternalApiNonFutureException() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testAddOrUpdateContactsToExternalApiNonFutureException();
    }


    @isTest
    global static void testRemoveContactsFromExternalApiException() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testRemoveContactsFromExternalApiException();
    }


    @isTest
    global static void testUpdateMetricsException() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIEmailHubBaseTestClass().testUpdateMetricsException();
    }
}