@isTest
global class PORTAL_API_ConstantContactTest extends PORTAL_TestClassBase{
    public virtual class TestClass{
        public PORTAL_HttpMockCallout mockcallouts;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setup() {
            mockcallouts = new PORTAL_HttpMockCallout();
            Test.setMock(HttpCalloutMock.class, mockcallouts);
        }

        public virtual void addOrUpdateContactsToExternalApiAndListTest() {
            setup();

            List<Contact> contactList = new List<Contact>();
            Contact con = new Contact(Email = 'testEmail@test.com.invalid', FirstName = 'test', LastName = 'test');
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            contactList.add(con);
            insert contactList;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;
            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
            zoneList.add(zone);

            ucinn_portal_Zone_Membership__c membership = new ucinn_portal_Zone_Membership__c(
                Is_On_Newsletter__c = true,
                Is_Show_On_Directory__c = true,
                Zone__c = zone.Id,
                Status__c = 'Active',
                Constituent__c = con.Id
            );
            membership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membership});
            insert membership;


            Test.startTest();
            PORTAL_API_ConstantContact constCont = new PORTAL_API_ConstantContact();

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.ZONE_LIST_KEY, zoneList);

            //test list creation failure
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.LISTS_ENDPOINT);
            System.debug('in test: ' + PORTAL_API_ConstantContact.LISTS_ENDPOINT);
            try {
                constCont.createOrUpdateExternalMailingLists(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {

            }

            //test list creation success
            mockcallouts.addRequest(200, 'Request Successful', '{"list_id": "testExternalListId"}', PORTAL_API_ConstantContact.LISTS_ENDPOINT);
            constCont.createOrUpdateExternalMailingLists(params);

            //test list creation failure from already having external Id
            try {
                constCont.createOrUpdateExternalMailingLists(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test failure to create new contact
            params.put(PORTAL_API_EmailHubBase.CONTACT_LIST_KEY, contactList);
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.CONTACTS_ENDPOINT);
            try {
                constCont.addOrUpdateContactsToExternalApi(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test success with creating new contact and updating
            mockcallouts.addRequest(201, 'Request Successful.', '{"contact_id" : "testExternalConId"}', PORTAL_API_ConstantContact.CONTACTS_ENDPOINT);
            mockcallouts.addRequest(200, 'Request Successful.', '{}', PORTAL_API_ConstantContact.CONTACTS_ENDPOINT + 'testExternalConId');
            constCont.addOrUpdateContactsToExternalApi(params);

            //test failure to update existing contact
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.CONTACTS_ENDPOINT + con.ucinn_portal_External_Email_API_Id__c);
            try {
                constCont.addOrUpdateContactsToExternalApi(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test contact deletion failure
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.ENDPOINT_PREFIX + 'activities/contact_delete');
            params.put(PORTAL_API_EmailHubBase.EXTERNAL_CONTACT_IDS_KEY, new Set<String>{'testExternalConId'});
            try {
                constCont.removeContactsFromExternalApi(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            Test.stopTest();
        }

        public virtual void collectMetricsTest() {
            setup();

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter').getRecordTypeId();
            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Name = 'Test listing',
                                                                            Header_Content__c = 'This is a Test.',
                                                                            RecordTypeId = recordTypeId,
                                                                            Status__c = 'Pending');
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;


            Test.startTest();
            PORTAL_API_ConstantContact constCont = new PORTAL_API_ConstantContact();

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.NEWSLETTER_ID_KEY, testListing.Id);

            //test unsuccessful metrics collection from no external Id
            try {
                constCont.updateMetrics(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            params.put(PORTAL_API_EmailHubBase.EXTERNAL_EMAIL_ID_KEY, 'testExternalId');

            //test unsuccessful metrics collection with new campaign
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.ENDPOINT_PREFIX + 'reports/stats/email_campaign_activities/testExternalId');
            try {
                constCont.updateMetrics(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test successful metrics collection with new campaign
            mockcallouts.addRequest(200, 'Request Successful.', '{"errors": [{"error_key": "reportingsvc.not_found.invalid_path_param.campaign_ids.","error_message": "Could not find any campaign stats for all requested campaigns."}],"results": [{"campaign_id": "string","campaign_activity_id": "string","stats": {"em_bounces": 10,"em_clicks": 280,"em_clicks_all": 387,"em_clicks_all_computer": 123,"em_clicks_all_mobile": 211,"em_clicks_all_tablet": 85,"em_clicks_all_other": 4,"em_clicks_all_none": 2,"em_forwards": 39,"em_not_opened": 25,"em_opens": 220,"em_opens_all": 399,"em_opens_all_computer": 65,"em_opens_all_mobile": 270,"em_opens_all_tablet": 199,"em_opens_all_other": 10,"em_opens_all_none": 2,"em_optouts": 2,"em_sends": 308,"em_abuse": 1,"em_bounces_blocked": 1,"em_bounces_mailbox_full": 2,"em_bounces_nonexistent_address": 3,"em_bounces_other": 2,"em_bounces_suspended": 1,"em_bounces_undeliverable": 19,"em_bounces_vacation": 2},"last_refresh_time": "string"}]}', PORTAL_API_ConstantContact.ENDPOINT_PREFIX + 'reports/stats/email_campaign_activities/testExternalId');
            constCont.updateMetrics(params);

            //test dml
            constCont.performDML(params);

            Test.stopTest();
        }

        public virtual void sendEmailsTest() {
            setup();

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter').getRecordTypeId();
            ucinn_portal_Listing__c testListing = new ucinn_portal_Listing__c(Name = 'Test listing',
                                                                            Header_Content__c = 'This is a Test.',
                                                                            RecordTypeId = recordTypeId,
                                                                            Status__c = 'Pending');
            testListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => testListing});
            insert testListing;

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.LISTING_KEY, testListing);
            params.put(PORTAL_API_EmailHubBase.ZONE_EXTERNAL_ID_KEY, 'testExternalId');
            params.put(PORTAL_API_EmailHubBase.FROM_EMAIL_KEY, 'testEmail.test.com.invalid');
            params.put(PORTAL_API_EmailHubBase.SUBJECT_KEY, 'test listing Name');
            params.put(PORTAL_API_EmailHubBase.HTML_KEY, 'html Text');
            params.put(PORTAL_API_EmailHubBase.PLAIN_TEXT_KEY, 'PLAINTEXT FIELD');
            params.put(PORTAL_API_EmailHubBase.FROM_NAME_KEY, 'test from Name');
            params.put(PORTAL_API_EmailHubBase.DELIVERY_TIME_KEY, Datetime.newInstance(3000, 1, 1));

            Test.startTest();
            PORTAL_API_ConstantContact constCont = new PORTAL_API_ConstantContact();

            //test unsuccessful new campaign
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '[{"error_message" : "error"}]', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT);
            try {
                constCont.sendCampaignEmails(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test successful new campaign, unsuccessful update campaign
            mockcallouts.addRequest(200, 'Request Successful', '{"campaign_activities": [{"campaign_activity_id": "testExternalId"}]}', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT);
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT + 'activities/testExternalId');
            try {
                constCont.sendCampaignEmails(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test successful new and update campaign, unsuccessful schedule
            mockcallouts.addRequest(200, 'Request Successful', '{"campaign_activities": [{"campaign_activity_id": "testExternalId"}]}', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT);
            mockcallouts.addRequest(200, 'Request Successful', '{}', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT + 'activities/testExternalId');
            mockcallouts.addRequest(400, 'Bad request. Either the JSON was malformed or there was a data validation error.', '{}', PORTAL_API_ConstantContact.ENDPOINT_PREFIX + 'emails/activities/testExternalId/schedules');
            try {
                constCont.sendCampaignEmails(params);
            } catch (PORTAL_API_ConstantContact.ConstantContactException e) {
            }

            //test successful new, update and schedule campaign
            mockcallouts.addRequest(200, 'Request Successful', '{"campaign_activities": [{"campaign_activity_id": "testExternalId"}]}', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT);
            mockcallouts.addRequest(200, 'Request Successful', '{}', PORTAL_API_ConstantContact.CAMPAIGNS_ENDPOINT + 'activities/testExternalId');
            mockcallouts.addRequest(201, 'Request Successful', '{}', PORTAL_API_ConstantContact.ENDPOINT_PREFIX + 'emails/activities/testExternalId/schedules');
            constCont.sendCampaignEmails(params);

            //test dml
            constCont.performDML(params);

            Test.stopTest();
        }

        public virtual void testCreateContactsPastLimit() {
            setup();

            mockcallouts.addRequest(201, 'Request Successful.', '{"contact_id" : "testExternalConId"}', PORTAL_API_ConstantContact.CONTACTS_ENDPOINT);
            mockcallouts.addRequest(200, 'Request Successful.', '{}', PORTAL_API_ConstantContact.CONTACTS_ENDPOINT + 'testExternalConId');

            List<Contact> contactList = new List<Contact>();
            for (Integer eachConIndex = 0; eachConIndex <= PORTAL_API_ConstantContact.MAX_RECORD_PER_BATCH; eachConIndex++) {
                Contact con = new Contact(Email = 'testEmail' + eachConIndex + '@test.com.invalid', FirstName = 'test', LastName = 'test' + eachConIndex);
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                contactList.add(con);
            }
            insert contactList;

            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            insert zone;
            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
            zoneList.add(zone);

            List<ucinn_portal_Zone_Membership__c> membershipList = new List<ucinn_portal_Zone_Membership__c>();
            for (Integer eachIndex = 0; eachIndex <= PORTAL_API_ConstantContact.MAX_RECORD_PER_BATCH; eachIndex++) {
                ucinn_portal_Zone_Membership__c membership = new ucinn_portal_Zone_Membership__c(
                    Is_On_Newsletter__c = true,
                    Is_Show_On_Directory__c = true,
                    Zone__c = zone.Id,
                    Status__c = 'Active',
                    Constituent__c = contactList[eachIndex].Id
                );
                membership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membership});
                membershipList.add(membership);
            }
            insert membershipList;

            Test.startTest();
            PORTAL_API_ConstantContact constCont = new PORTAL_API_ConstantContact();

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.CONTACT_LIST_KEY, contactList);

            constCont.addOrUpdateContactsToExternalApi(params);

            //test dml
            constCont.performDML(params);

            Test.stopTest();
        }

        public virtual void testCreateListsPastLimit() {
            setup();

            mockcallouts.addRequest(200, 'Request Successful', '{"list_id": "testExternalListId"}', PORTAL_API_ConstantContact.LISTS_ENDPOINT);

            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
            for (Integer eachZoneIndex = 0; eachZoneIndex <= PORTAL_API_ConstantContact.MAX_RECORD_PER_BATCH; eachZoneIndex++) {
                ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
                zone.Is_Display_On_Portal__c = true;
                zone.RecordTypeId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
                zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
                zoneList.add(zone);
            }
            insert zoneList;

            Test.startTest();
            PORTAL_API_ConstantContact constCont = new PORTAL_API_ConstantContact();

            Map<String, Object> params = new Map<String, Object>();
            params.put(PORTAL_API_EmailHubBase.ZONE_LIST_KEY, zoneList);

            constCont.createOrUpdateExternalMailingLists(params);

            //test dml
            constCont.performDML(params);

            Test.stopTest();
        }

    }

    @isTest
    global static void addOrUpdateContactsToExternalApiAndListTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIConstantContactTestClass().addOrUpdateContactsToExternalApiAndListTest();
    }

    @isTest
    global static void collectMetricsTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIConstantContactTestClass().collectMetricsTest();
    }

    @isTest
    global static void sendEmailsTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIConstantContactTestClass().sendEmailsTest();
    }

    @IsTest
    global static void testCreateContactsPastLimit() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIConstantContactTestClass().testCreateContactsPastLimit();
    }

    @IsTest
    global static void testCreateListsPastLimit() {
        PORTAL_TestClassFactory.getTestClassFactory().getAPIConstantContactTestClass().testCreateListsPastLimit();
    }

}