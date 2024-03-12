@isTest
public without sharing class PORTAL_NewsletterControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();


        public virtual void testGetSubmissionSetupInfoNoParams() {
            Map<String, Object> params = new Map<String, Object>();
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
            Id clubrecordId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
            ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
            zone.Is_Display_On_Portal__c = true;
            zone.RecordTypeId = clubrecordId;
            ucinn_portal_Zone__c zoneAll = new ucinn_portal_Zone__c();
            zoneAll.Is_Display_On_Portal__c = true;
            zoneAll.Social_Media_Order__c = 'Facebook';
            zoneAll.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            zoneAll.RecordTypeId = clubrecordId;
            List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
            zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
            zoneAll = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneAll});
            zoneList.add(zone);
            zoneList.add(zoneAll);
            insert zoneList;
            Test.startTest();
            Map<String, Object> result = controller.getSubmissionSetupInfo(params);
            Test.stopTest();
            //doesn't really have an return, just needs to not fail null checks
        }


        public virtual void testGetSubmissionSetupInfoWithParams() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                        AccountId = acct.Id,
                                        Email = 'testCommunityUsermig123@test.com');
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                User communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        ContactId = con.Id,
                                        IsActive = true,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testPortalUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                Id clubrecordId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
                ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
                zone.Is_Display_On_Portal__c = true;
                zone.RecordTypeId = clubrecordId;
                ucinn_portal_Zone__c zoneAll = new ucinn_portal_Zone__c();
                zoneAll.Is_Display_On_Portal__c = true;
                zoneAll.Social_Media_Order__c = 'Facebook';
                zoneAll.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
                zoneAll.RecordTypeId = clubrecordId;
                zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
                zoneAll = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneAll});
                List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
                zoneList.add(zone);
                zoneList.add(zoneAll);
                insert zoneList;

                ucinn_portal_Recipient__c filter = new ucinn_portal_Recipient__c();
                filter.Filter_Logic__c = '';
                filter.Zone__c = zone.Id;
                ucinn_portal_Recipient__c filterAll = new ucinn_portal_Recipient__c();
                filterAll.Filter_Logic__c = '';
                filterAll.Zone__c = zoneAll.Id;
                List<ucinn_portal_Recipient__c> recipientList = New List<ucinn_portal_Recipient__c>();
                filter = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filter});
                filterAll = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => filterAll});
                recipientList.add(filter);
                recipientList.add(filterAll);
                insert recipientList;

                ucinn_portal_Zone_Membership__c membership = new ucinn_portal_Zone_Membership__c(
                    Is_On_Newsletter__c = true,
                    Is_Show_On_Directory__c = true,
                    Zone__c = zone.Id,
                    Status__c = 'Active',
                    Constituent__c = con.Id
                );
                membership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => membership});
                insert membership;


                Map<String, Object> params = new Map<String, Object>();
                PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
                Map<String, Object> result;
                Test.startTest();
                System.runAs(communityUser) {
                    result = controller.getSubmissionSetupInfo(params);
                }
                Test.stopTest();

                System.debug(result);
                System.assert(result.get('templates') != null);
                System.assert(result.get('mergeFields') != null);
                System.assert(result.get('filterList') != null);
                System.assert(result.get('portalZones') != null);
                System.assert(result.get('timezones') != null);
            }
        }


        public virtual void testGetPreviewNewsletterHtml() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                        AccountId = acct.Id,
                                        Email = 'testCommunityUsermig123@test.com');
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                User communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        ContactId = con.Id,
                                        IsActive = true,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testPortalUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                Id templateRecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Newsletter_Template').getRecordTypeId();
                ucinn_portal_Listing__c listingTemplate = new ucinn_portal_Listing__c(Name = PORTAL_NewsletterControllerBase.NEWSLETTER_TEMPLATE_NAME,
                    Header_Content__c = 'This is a Test.',
                    RecordTypeId = templateRecordTypeId,
                    Newsletter_HTML_Format__c = 'format for the newsletter');
                listingTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listingTemplate});
                insert listingTemplate;

                ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c(Name = 'Module 1',
                    Newsletter_HTML__c = 'module html',
                    Newsletter_Listing__c = listingTemplate.Id);
                section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
                insert section;

                Id clubrecordId = Schema.SObjectType.ucinn_portal_Zone__c.getRecordTypeInfosByDeveloperName().get('Club').getRecordTypeId();
                ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
                zone.Is_Display_On_Portal__c = true;
                zone.Name = 'Main'; //due to the zone picklist on listing being restricted this needs to match something from that list that isnt the default for coverage
                zone.RecordTypeId = clubrecordId;

                ucinn_portal_Zone__c zoneAll = new ucinn_portal_Zone__c();
                zoneAll.Is_Display_On_Portal__c = true;
                zoneAll.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
                zoneAll.Social_Media_Order__c = 'Twitter;Instagram;LinkedIn;Facebook';
                zoneAll.Footer_Content__c = 'test footer content';
                zoneAll.RecordTypeId = clubrecordId;
                zoneAll.Newsletter_HTML_Format__c = 'format for the newsletter';
                List<ucinn_portal_Zone__c> zoneList = new List<ucinn_portal_Zone__c>();
                zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
                zoneAll = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneAll});
                zoneList.add(zone);
                zoneList.add(zoneAll);
                insert zoneList;

                Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_NewsletterControllerBase.NEWSLETTER_RECORD_TYPE).getRecordTypeId();
                ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Newsletter',
                    Header_Content__c = 'This is a Test.',
                    RecordTypeId = recordTypeId,
                    Portal_Zone__c = zone.Name,
                    Status__c = 'Pending');
                newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
                insert newListing;

                ucinn_portal_Newsletter_Section__c newListingSection = new ucinn_portal_Newsletter_Section__c(
                    Name = 'Section 1',
                    Newsletter_Listing__c = newListing.Id,
                    Selected_Module__c = section.Name,
                    Start_Date_Time__c = '2012-02-21T15:01:00.14Z');
                newListingSection = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListingSection});
                insert newListingSection;

                Map<String, Object> params = new Map<String, Object>();
                params.put(PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY, newListing.Id);
                PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
                String result;
                Test.startTest();
                System.runAs(communityUser) {
                    try{
                        result = controller.getPreviewNewsletterHtml(params);
                    } catch (Exception e) { }
                }
                Test.stopTest();

                System.debug(result);
            }
        }


        public virtual void testFormatDate() {
            String testNoTime = '2012-02-21';
            List<String> resultNoTime;
            List<String> expectedNotime = new List<String>();

            String testNoDate = '12T15:01:00.14Z';
            List<String> resultNoDate;
            List<String> expectedNoDate = new List<String>();

            String testPm = '2012-02-21T15:01:00.14Z';
            List<String> resultPm;
            List<String> expectedPm = new List<String>{'02/21/2012', '3:01 p.m.'};

            String test12Pm = '2012-02-21T12:02:00.14Z';
            List<String> result12Pm;
            List<String> expected12Pm = new List<String>{'02/21/2012', '12:02 p.m.'};

            String test12Am = '2012-02-21T00:03:00.14Z';
            List<String> result12Am;
            List<String> expected12Am = new List<String>{'02/21/2012', '12:03 a.m.'};

            String testAm = '2012-02-21T11:04:00.14Z';
            List<String> resultAm;
            List<String> expectedAm = new List<String>{'02/21/2012', '11:04 a.m.'};

            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
            Test.startTest();
            resultNoTime = controller.formatDate(testNoTime);
            resultNoDate = controller.formatDate(testNoDate);
            resultPm = controller.formatDate(testPm);
            result12Pm = controller.formatDate(test12Pm);
            result12Am = controller.formatDate(test12Am);
            resultAm = controller.formatDate(testAm);
            Test.stopTest();

            System.assertEquals(expectedNotime, resultNotime);
            System.assertEquals(expectedNoDate, resultNoDate);
            System.assertEquals(expectedPm, resultPm);
            System.assertEquals(expected12Pm, result12Pm);
            System.assertEquals(expected12Am, result12Am);
            System.assertEquals(expectedAm, resultAm);
        }


        public virtual void testGetNewsletterSectionTemplates() {
            List<ucinn_portal_Newsletter_Section__c> sectionList = new PORTAL_NewsletterControllerBase().getNewsletterSectionTemplates(new Map<String, Object>());
            System.assert(sectionList.isEmpty());
            ucinn_portal_Listing__c newsletterTemplate = new ucinn_portal_Listing__c();
            newsletterTemplate.Name = PORTAL_NewsletterControllerBase.NEWSLETTER_TEMPLATE_NAME;
            newsletterTemplate.Newsletter_HTML_Format__c = 'Test';
            newsletterTemplate.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_TEMPLATE).getRecordTypeId();
            newsletterTemplate = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newsletterTemplate});
            insert newsletterTemplate;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.RecordTypeId = Schema.SObjectType.ucinn_portal_Newsletter_Section__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Newsletter.NEWSLETTER_SECTION_TEMPLATE_RECORD_TYPE).getRecordTypeId();
            section.Newsletter_Listing__c = newsletterTemplate.Id;
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;
            sectionList = new PORTAL_NewsletterControllerBase().getNewsletterSectionTemplates(new Map<String, Object>());
            System.assert(sectionList.size() == 1);
        }


        public virtual void testSearchForListings() {
            List<ucinn_portal_Listing__c> listingList = new PORTAL_NewsletterControllerBase().searchForListings(new Map<String, Object>());
            System.assert(listingList.isEmpty());
            ucinn_portal_Listing__c news = new ucinn_portal_Listing__c();
            news.Name = 'Test News';
            news.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            news.Status__c = 'Published';
            news.Start_Date_Time__c = Datetime.now();
            news.Actual_Start_Date_Time__c = '2021-08-08 00:00:00';
            news.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWS).getRecordTypeId();
            news = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => news});
            insert news;
            listingList = new PORTAL_NewsletterControllerBase().searchForListings(new Map<String, Object>{'searchText' => 'News', 'maxItems' => '5'});
            System.assert(listingList.size() == 1);
        }


        public virtual void testRemoveMargins() {
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
            String text =  controller.removeMargins('<p>Test</p>');
            System.assert(text == '<p style="margin-top: 0px; margin-bottom: 0px;">Test</p>');
            text =  controller.removeMargins('<h1>Test</h1>');
            System.assert(text == '<h1 style="margin-top: 0px; margin-bottom: 0px;">Test</h1>');
            text =  controller.removeMargins('<h2>Test</h2>');
            System.assert(text == '<h2 style="margin-top: 0px; margin-bottom: 0px;">Test</h2>');
            text =  controller.removeMargins('<h3>Test</h3>');
            System.assert(text == '<h3 style="margin-top: 0px; margin-bottom: 0px;">Test</h3>');
            text =  controller.removeMargins('<h4>Test</h4>');
            System.assert(text == '<h4 style="margin-top: 0px; margin-bottom: 0px;">Test</h4>');
            text =  controller.removeMargins('<h5>Test</h5>');
            System.assert(text == '<h5 style="margin-top: 0px; margin-bottom: 0px;">Test</h5>');

        }


        public virtual void testSubmitNewsletter() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                Contact con = new Contact(LastName = 'Test_Contact',
                                AccountId = acct.Id,
                                Email = 'testCommunityUsermig123@test.com');
                con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
                insert con;

                User communityUser = new User(alias = 'comUser',
                                        email = 'testCommunityUsermig123@test.com',
                                        emailencodingkey='UTF-8',
                                        lastname = 'Batman',
                                        languagelocalekey='en_US',
                                        localesidkey='en_US',
                                        profileid = profileId,
                                        IsActive = true,
                                        timezonesidkey='America/Los_Angeles',
                                        username = System.now().millisecond() + 'testPortalUsermig123@test.com',
                                        ContactId = con.Id,
                                        ucinn_portal_Recommend_Type_1__c = 'Law',
                                        ucinn_portal_Recommend_Type_2__c = 'Culture',
                                        ucinn_portal_Recommend_Type_3__c = 'Global',
                                        ucinn_portal_Open_Possibility_For_Type_1__c = .5,
                                        ucinn_portal_Open_Possibility_For_Type_2__c = .24,
                                        ucinn_portal_Open_Possibility_For_Type_3__c = .33,
                                        ucinn_Weight_For_Number_Of_Content__c = .67,
                                        ucinn_portal_Weight_For_Times_Commented__c = .45,
                                        ucinn_portal_Weight_For_Time_Spent__c = .8,
                                        ucinn_portal_Weight_For_Times_Viewed__c = .5);
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;

                ucinn_portal_Zone__c zone = new ucinn_portal_Zone__c();
                zone.Name = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
                zone.Is_Display_On_Portal__c = true;
                zone = (ucinn_portal_Zone__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zone});
                insert zone;

                ucinn_portal_Zone_Membership__c zoneMembership = new ucinn_portal_Zone_Membership__c();
                zoneMembership.Zone__c = zone.Id;
                zoneMembership.Constituent__c = con.Id;
                zoneMembership.Status__c = PORTAL_NewsletterControllerBase.ACTIVE_STATUS;
                zoneMembership.Zone_Permission_Set__c = PORTAL_NewsletterControllerBase.SUBMIT_NEWSLETTER_PERMISSION;
                zoneMembership = (ucinn_portal_Zone_Membership__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => zoneMembership});
                insert zoneMembership;

                System.runAs(communityUser) {

                    ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
                    listing.Name = 'Test Newsletter';
                    listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
                    listing.Body_Content__c = 'Dear Test';

                    ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
                    section.Name = 'Test Section';
                    section.Order_In_Section__c = 0;
                    section.Section_Number__c = 0;
                    section.Section_Title__c = 'First Section';

                    List<ucinn_portal_Newsletter_Section__c> newsletterSectionList = new List<ucinn_portal_Newsletter_Section__c>{section};

                    Test.startTest();
                    try {
                        new PORTAL_NewsletterControllerBase().submitNewsletter(new Map<String, Object>{'listing' => listing, 'newsletterSectionsList' => newsletterSectionList});
                    } catch (Exception e) { }
                    Test.stopTest();
                }
            }
        }


        public virtual void testParsePlainText() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            Id listingId = listing.Id;

            Test.startTest();
            new PORTAL_NewsletterControllerBase().parseNewsletterPlainText(new Map<String, Object>{'newsletterId' => listingId});

            delete listing;
            try {
                new PORTAL_NewsletterControllerBase().parseNewsletterPlainText(new Map<String, Object>{'newsletterId' => listingId});
            } catch (Exception e) {

            }
            Test.stopTest();
        }


        public virtual void testCountRecipients() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            try {
                new PORTAL_NewsletterControllerBase().countRecipients(new Map<String, Object>{'newsletterId' => null});
            } catch(Exception e) {

            }

            try {
                new PORTAL_NewsletterControllerBase().countRecipients(new Map<String, Object>{'newsletterId' => listing.Id});
            } catch(Exception e) {

            }

            ucinn_portal_Recipient__c recipient = new ucinn_portal_Recipient__c();
            recipient.Name = 'Test';
            recipient.Filter_Logic__c = '';
            recipient = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => recipient});
            insert recipient;

            listing.Recipient__c = recipient.Id;
            update listing;

            Test.startTest();
            try {
                new PORTAL_NewsletterControllerBase().countRecipients(new Map<String, Object>{'newsletterId' => listing.Id});
            } catch(Exception e) {
            }
            Test.stopTest();
        }


        public virtual void testScheduleNewsletter() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Time_Zone__c = '(GMT–07:00) Pacific Daylight Time (America/Tijuana)';
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            try {
                new PORTAL_NewsletterControllerBase().scheduleNewsletter(new Map<String, Object>{'newsletterId' => null});
            } catch(Exception e) {

            }

            try {
                new PORTAL_NewsletterControllerBase().scheduleNewsletter(new Map<String, Object>{'newsletterId' => listing.Id, 'deliveryTime' => null});
            } catch(Exception e) {

            }

            try {
                new PORTAL_NewsletterControllerBase().scheduleNewsletter(new Map<String, Object>{'newsletterId' => listing.Id, 'deliveryTime' => Datetime.now()});
            } catch(Exception e) {

            }

            ucinn_portal_Recipient__c recipient = new ucinn_portal_Recipient__c();
            recipient.Name = 'Test';
            recipient.Filter_Logic__c = '1 AND 2';
            recipient = (ucinn_portal_Recipient__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => recipient});
            insert recipient;

            listing.Recipient__c = recipient.Id;
            listing.Number_of_Newsletter_Recipients__c = 1;
            update listing;

            Test.startTest();
            try {
                new PORTAL_NewsletterControllerBase().scheduleNewsletter(new Map<String, Object>{'newsletterId' => listing.Id, 'deliveryTime' => Datetime.now()});
            } catch(Exception e) {

            }
            Test.stopTest();
        }


        public virtual void testCloneNewsletter() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            try {
                System.assert(new PORTAL_NewsletterControllerBase().cloneNewsletter(new Map<String, Object>{'newsletterId' => listing.Id}) != null);
            } catch(Exception e) {

            }

            try {
                System.assert(new PORTAL_NewsletterControllerBase().cloneNewsletter(new Map<String, Object>{'newsletterId' => null}) == null);
            } catch(Exception e) {

            }

        }


        public virtual void testSendNewsletter() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            try {
                new PORTAL_NewsletterControllerBase().sendNewsletter(new Map<String, Object>{'newsletterId' => null});
            } catch(Exception e) {

            }

            try {
                new PORTAL_NewsletterControllerBase().sendNewsletter(new Map<String, Object>{'newsletterId' => listing.Id});
            } catch(Exception e) {

            }

            listing.Number_of_Newsletter_Recipients__c = 1;
            update listing;

            try {
                new PORTAL_NewsletterControllerBase().sendNewsletter(new Map<String, Object>{'newsletterId' => listing.Id});
            } catch(Exception e) {

            }
        }


        public virtual void testGetMyNewsletters() {
            try {
                new PORTAL_NewsletterControllerBase().getMyNewsletters(new Map<String, Object>());
            } catch(Exception e) {

            }

            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            try {
                Map<String,Object> returnMap = new PORTAL_NewsletterControllerBase().getMyNewsletters(new Map<String, Object>());

            } catch(Exception e) {

            }

            try {
                new PORTAL_NewsletterControllerBase().getMyNewsletters(new Map<String, Object>{'offset' => 1});
            } catch(Exception e) {

            }
        }

        public virtual void testGetMyNewslettersWithSosl() {
            Id recordType = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();

            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c(
                Name = 'This is a test', 
                Subject_Line__c = 'test',
                Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME,
                Body_Content__c = 'Dear Test',
                RecordTypeId = recordType
            );

            listing = (ucinn_portal_Listing__c) testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;

            PORTAL_NewsletterControllerBase base = new PORTAL_NewsletterControllerBase();

            Test.startTest();
            
            // unfortunately, SOSL doesn't actually work in tests (much like callouts don't work)
            Test.setFixedSearchResults(new List<Id>{listing.Id});
            Map<String, Object> resultMap = base.getMyNewsletters(new Map<String, Object>{PORTAL_NewsletterControllerBase.OFFSET_KEY => 0, PORTAL_NewsletterControllerBase.SEARCH_TEXT_KEY => 'test'});
            System.assertEquals(1, ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) 
                                    resultMap.get(PORTAL_NewsletterControllerBase.RECORDS_MAP_KEY))
                                    .get(PORTAL_NewsletterControllerBase.SUBMITTED_NEWSLETTER_MAIN_SECTION))
                                    .get(PORTAL_CONST_PageSectionSetting.RECORD_KEY))
                                    .size());
            
            Test.setFixedSearchResults(new List<Id>());
            resultMap = base.getMyNewsletters(new Map<String, Object>{PORTAL_NewsletterControllerBase.SEARCH_TEXT_KEY => 'foo'});
            System.assertEquals(0, ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) 
                                    resultMap.get(PORTAL_NewsletterControllerBase.RECORDS_MAP_KEY))
                                    .get(PORTAL_NewsletterControllerBase.SUBMITTED_NEWSLETTER_MAIN_SECTION))
                                    .get(PORTAL_CONST_PageSectionSetting.RECORD_KEY))
                                    .size());
                                    
            resultMap = base.getMyNewsletters(new Map<String, Object>{PORTAL_NewsletterControllerBase.SEARCH_TEXT_KEY => 'a'});
            System.assertEquals(false, resultMap.containsKey(PORTAL_NewsletterControllerBase.RECORDS_MAP_KEY));

            List<SObject> resultList = base.executeSoslQuery(null, '', null);
            System.assert(resultList.isEmpty());

            Test.stopTest();
        }

        public virtual void testSendTestNewsletter() {
            try {
                new PORTAL_NewsletterControllerBase().sendTestNewsletter(new Map<String, Object>{'listing' => new ucinn_portal_Listing__c(), 'email' => ''});
            } catch(Exception e) {

            }

            try {
                new PORTAL_NewsletterControllerBase().sendTestNewsletter(new Map<String, Object>{'listing' => new ucinn_portal_Listing__c(Subject_Line__c = 'Test Newsletter'), 'email' => 'atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com;atran@ucinnovation.com'});
            } catch(Exception e) {

            }

            try {
                ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
                listing.Name = 'Test Newsletter';
                listing.Subject_Line__c = 'Test Newsletter';
                listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
                listing.Body_Content__c = 'Dear Test';

                ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
                section.Name = 'Test Section';
                section.Header_Content__c = 'Test';
                section.Order_In_Section__c = 0;
                section.Section_Number__c = 0;
                section.Section_Title__c = 'First Section';

                List<ucinn_portal_Newsletter_Section__c> newsletterSectionList = new List<ucinn_portal_Newsletter_Section__c>{section};

                new PORTAL_NewsletterControllerBase().sendTestNewsletter(new Map<String, Object>{'listing' => listing, 'newsletterSectionsList' => newsletterSectionList, 'email' => 'atran@ucinnovation.com'});
            } catch(Exception e) {

            }
        }


        public virtual void testGetPortalZoneFromListing() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
            String portalZone = controller.getPortalZoneForListing(new Map<String, Object>());
            System.assert(portalZone == '');
            portalZone = controller.getPortalZoneForListing(new Map<String, Object>{'newsletterId' => listing.Id});
            System.assert(portalZone == PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME);
        }

        public virtual void testGetFrontEndNewsLetter() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;
    
            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            Map<String, Object> params = new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => listing.Id,
                                                                PORTAL_NewsletterControllerBase.CLONE_KEY => false};

            Map<String, Object> paramsCloneTrue = new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => listing.Id,
                                                                PORTAL_NewsletterControllerBase.CLONE_KEY => true};

            Map<String, Object> emptyParams = new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_ID_KEY => null,
                                                                PORTAL_NewsletterControllerBase.CLONE_KEY => false};

            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();

            Test.startTest();
            ucinn_portal_Listing__c result = controller.getFrontendNewsletter(params);
            ucinn_portal_Listing__c result2 = controller.getFrontendNewsletter(paramsCloneTrue);
            ucinn_portal_Listing__c result3 = controller.getFrontendNewsletter(emptyParams);

            System.assertEquals(listing.Name, result.Name);
            System.assertEquals(listing.Name, result2.Name);
            System.assertEquals(null, result3);

            Test.stopTest();
        }

        public virtual void testUpdateNewsLetterMetrics() {
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
            Campaign testCampaign = new Campaign(Name = 'Test Campaign');
            insert testCampaign;

            Test.startTest();

            controller.updateNewsletterMetrics(new Map<String, Object>{PORTAL_NewsletterControllerBase.CAMPAIGN_ID => testCampaign.Id});

            try {
                controller.updateNewsletterMetrics(new Map<String, Object>{PORTAL_NewsletterControllerBase.CAMPAIGN_ID => ''});
            } catch (Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetMergeFields() {
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();
            Map<String, Object> params = new Map<String, Object>{PORTAL_NewsletterControllerBase.RECORD_TYPE_KEY => 'Test key',
                                                                PORTAL_NewsletterControllerBase.SOBJECT_TYPE_KEY => 'ucinn_portal_Zone__c'};

            Map<String, Object> paramsAlternative = new Map<String, Object>{PORTAL_NewsletterControllerBase.RECORD_TYPE_KEY => 'Test key',
                                                                PORTAL_NewsletterControllerBase.SOBJECT_TYPE_KEY => 'ucinn_portal_Newsletter_Section__c'};


            Test.startTest();

            controller.getMergeFields(params);
            controller.getMergeFields(paramsAlternative);

            Test.stopTest();
        }

        public virtual void testGetNewsLetterZonesInvalidInput() {
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();

            Test.startTest();

            try {
                controller.getNewsletterZones(new Map<String, Object>());
            } catch (Exception e) {
                System.assertEquals('Listing is not defined.', e.getMessage());
            }

            Test.stopTest();
        }

        public virtual void testGetFormattedDateTimeLocation() {
            PORTAL_NewsletterControllerBase controller = new PORTAL_NewsletterControllerBase();

            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            listing.Name = 'Test Newsletter';
            listing.Portal_Zone__c = PORTAL_NewsletterControllerBase.DEFAULT_ZONE_NAME;
            listing.Body_Content__c = 'Dear Test';
            listing.RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(PORTAL_CONST_Listing.NEWSLETTER).getRecordTypeId();
            listing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing});
            insert listing;
    
            ucinn_portal_Newsletter_Section__c section = new ucinn_portal_Newsletter_Section__c();
            section.Name = 'Test Section';
            section.Header_Content__c = 'Test';
            section.Order_In_Section__c = 0;
            section.Section_Number__c = 0;
            section.Newsletter_Listing__c = listing.Id;
            section.Body_Content__c = 'Test';
            section.Section_Title__c = 'First Section';
            section.Start_Date_Time__c = '2012-02-21T15:01:00.14Z';
            section.End_Date_Time__c = '2012-03-21T15:01:00.14Z';
            section.Location__c = 'Test Location';
            section = (ucinn_portal_Newsletter_Section__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => section});
            insert section;

            Map<String, Object> invalidParams = new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_SECTION_KEY => section,
                PORTAL_NewsletterControllerBase.html_KEY => ''};

            Map<String, Object> params = new Map<String, Object>{PORTAL_NewsletterControllerBase.NEWSLETTER_SECTION_KEY => section,
                                                                PORTAL_NewsletterControllerBase.html_KEY => ''};

            Test.startTest();

            controller.parseSectionHtml(invalidParams);

            controller.parseSectionHtml(params);

            Test.stopTest();
        }
    }

    @isTest
    public static void testGetSubmissionSetupInfoNoParams() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetSubmissionSetupInfoNoParams();
    }

    @isTest
    public static void testGetSubmissionSetupInfoWithParams() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetSubmissionSetupInfoWithParams();
    }

    @isTest
    public static void testGetPreviewNewsletterHtml() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetPreviewNewsletterHtml();
    }

    @isTest
    public static void testFormatDate() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testFormatDate();
    }

    @isTest
    public static void testGetNewsletterSectionTemplates() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetNewsletterSectionTemplates();
    }

    @isTest
    public static void testSearchForListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testSearchForListings();
    }

    @isTest
    public static void testRemoveMargins() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testRemoveMargins();
    }

    @isTest
    public static void testSubmitNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testSubmitNewsletter();
    }

    @isTest
    public static void testParsePlainText() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testParsePlainText();
    }

    @isTest
    public static void testCountRecipients() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testCountRecipients();

    }

    @isTest
    public static void testScheduleNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testScheduleNewsletter();
    }

    @isTest
    public static void testCloneNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testCloneNewsletter();
    }

    @isTest
    public static void testSendNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testSendNewsletter();
    }

    @isTest
    public static void testGetMyNewsletters() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetMyNewsletters();
    }

    @isTest
    public static void testGetMyNewslettersWithSosl() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetMyNewslettersWithSosl();
    }

    @isTest
    public static void testSendTestNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testSendTestNewsletter();
    }

    @isTest
    public static void testGetPortalZoneFromListing() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetPortalZoneFromListing();
    }

    @isTest
    public static void testGetFrontEndNewsLetter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetFrontEndNewsLetter();
    }

    @isTest
    public static void testUpdateNewsLetterMetrics() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testUpdateNewsLetterMetrics();
    }

    @isTest
    public static void testGetMergeFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetMergeFields();
    }

    @isTest
    public static void testGetNewsLetterZonesInvalidInput() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetNewsLetterZonesInvalidInput();
    }

    @isTest
    public static void testGetFormattedDateTimeLocation() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerBaseTestClass().testGetFormattedDateTimeLocation();
    }
}