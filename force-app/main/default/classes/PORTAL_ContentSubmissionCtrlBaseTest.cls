// test
@isTest
public class PORTAL_ContentSubmissionCtrlBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ucinn_portal_Listing__c newListing;
        public ucinn_portal_Ticket_Type__c newTicketType;
        public ucinn_portal_Custom_Form_Field__c formField;
        public Contact con;
        public User communityUser;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupUserData() {
            System.runAs(thisUser) {
                Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;
                Account acct = new Account(name = 'ACME Co') ;
                acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
                insert acct;

                con = new Contact(LastName = 'Test_Contact',
                                  AccountId = acct.Id,
                                  Email = 'testCommunityUsermig123@test.com',
                                  ucinn_portal_Is_Display_On_Portal__c = true);
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
                                         ContactId = con.Id,
                                         timezonesidkey='America/Los_Angeles',
                                         username = System.now().millisecond() + 'testCommunityUsermig123@test.com');
                communityUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => communityUser});
                insert communityUser;
            }
        }

        public virtual void setUpEvent() {
            ucinn_portal_Registration_Template__c newTemplate = new ucinn_portal_Registration_Template__c();
            newTemplate = (ucinn_portal_Registration_Template__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTemplate});
            insert newTemplate;

            formField = new ucinn_portal_Custom_Form_Field__c(Field_Label__c = 'test',
                                                              Field_Type__c = 'Picklist',
                                                              Registration_Template__c = newTemplate.Id);
            formField = (ucinn_portal_Custom_Form_Field__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => formField});
            insert formField;

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            newListing = new ucinn_portal_Listing__c(Name = 'Test Event',
                                                     Header_Content__c = 'This is a Test.',
                                                     RecordTypeId = recordTypeId,
                                                     Status__c = 'Pending',
                                                     Registration_Template__c = newTemplate.Id);
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            newTicketType = new ucinn_portal_Ticket_Type__c(Listing__c = newListing.Id, Price__c = 5);
            newTicketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTicketType});
            insert newTicketType;
        }

        public virtual void testSubmitContentSetup() {
            PORTAL_ContentSubmissionControllerBase controller = new PORTAL_ContentSubmissionControllerBase();

            try {
                controller.initializeContentSubmission(null);
            } catch (AuraHandledException e) {
                System.debug(e);
            }

            try {
                controller.initializeContentSubmission(new Map<String, Object>{'test' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                controller.initializeContentSubmission(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'testPageName',
                                                                               PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'test',
                                                                               PORTAL_ContentSubmissionControllerBase.RECORD_TYPE => 'Event'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            controller.initializeContentSubmission(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'Event Submission Form',
                                                                  PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'Content Submission Form',
                                                                  PORTAL_ContentSubmissionControllerBase.RECORD_TYPE => 'Event'});

            setUpEvent();
            controller.initializeContentSubmission(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'Event Submission Form',
                                                                  PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'Content Submission Form',
                                                                  PORTAL_ContentSubmissionControllerBase.RECORD_TYPE => 'Event',
                                                                  PORTAL_ContentSubmissionControllerBase.RECORD_ID => newListing.Id});
        }

        public virtual void testSubmitContent() {
            PORTAL_ContentSubmissionControllerBase controller = new PORTAL_ContentSubmissionControllerBase();
            try {
                controller.submitContent(null);
            } catch (AuraHandledException e) {
                System.debug(e);
            }

            try {
                controller.submitContent(new Map<String, Object>{'test' => 'test'});
            } catch (AuraHandledException e) {
                System.debug(e);
            }

            try {
                controller.submitContent(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'testPageName',
                                                                 PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'test',
                                                                 PORTAL_ContentSubmissionControllerBase.LISTING_WRAPPER => new Map<Object, Object>{}});
            } catch (AuraHandledException e) {
                System.debug(e);
            }

            controller.submitContent(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'Event Submission Form',
                                                             PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'Content Submission Form',
                                                             PORTAL_ContentSubmissionControllerBase.LISTING_WRAPPER => new Map<Object, Object>{'test' => 'test', 'eventSummary' => 'test'}});

            setUpEvent();
            controller.submitContent(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'Event Submission Form',
                                                             PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'Content Submission Form',
                                                             PORTAL_ContentSubmissionControllerBase.RECORD_ID => newListing.Id,
                                                             PORTAL_ContentSubmissionControllerBase.LISTING_WRAPPER => new Map<Object, Object>{'test' => 'test', 'eventSummary' => 'test'}});

            controller.submitContent(new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.PAGE_NAME => 'Event Submission Form',
                                                             PORTAL_ContentSubmissionControllerBase.MAIN_SECTION_NAME => 'Content Submission Form',
                                                             PORTAL_ContentSubmissionControllerBase.RECORD_ID => newListing.Id,
                                                             PORTAL_ContentSubmissionControllerBase.LISTING_WRAPPER => new Map<Object, Object>{'test' => 'test', 'eventSummary' => 'test'}});
        }

        public virtual void testGetMySubmittedContent() {
            PORTAL_ContentSubmissionControllerBase controller = new PORTAL_ContentSubmissionControllerBase();

            controller.getMySubmittedContent(null);

            setupUserData();

            System.runAs(communityUser) {
                controller.getMySubmittedContent(new Map<String, Object>{'test' => 'test'});
            }
        }

        public virtual void testInitializeClassNoteSubmission() {
            PORTAL_ContentSubmissionControllerBase controller = new PORTAL_ContentSubmissionControllerBase();
            Map<String, Object> params = new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.CONTENT_MODULE_NAME => 'Confirmation'};

            Test.startTest();
            Map<String, Object> resultMap = controller.initializeClassNoteSubmission(params);
            Assert.isTrue(resultMap.containsKey(PORTAL_ContentSubmissionControllerBase.FRONT_END_DATA_MAP_KEY));
            Assert.isTrue(resultMap.containsKey(PORTAL_ContentSubmissionControllerBase.PICKLISTS));
            Assert.isTrue(resultMap.containsKey(PORTAL_ContentSubmissionControllerBase.LISTING_ID_KEY));
            Assert.isTrue(resultMap.containsKey(PORTAL_ContentSubmissionControllerBase.LISTING_WRAPPER_MAP));
            Assert.isTrue(resultMap.containsKey(PORTAL_ContentSubmissionControllerBase.CONTENT_MODULE_METADATA));
            Test.stopTest();
        }

        public virtual void testResetClassNoteSubmission() {
            PORTAL_ContentSubmissionControllerBase controller = new PORTAL_ContentSubmissionControllerBase();
            Map<String, Object> params = new Map<String, Object>{};

            Test.startTest();
            Map<String, Object> resultMap = controller.resetClassNoteSubmission(params);
            Assert.isTrue(resultMap.containsKey(PORTAL_ContentSubmissionControllerBase.LISTING_ID_KEY));
            Test.stopTest();
        }

        public virtual void testAttachContentDocument() {
            PORTAL_ContentSubmissionControllerBase controller = new PORTAL_ContentSubmissionControllerBase();
            ContentVersion content = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'test.txt',
                VersionData = Blob.valueOf('Test')
            );
            insert content;

            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c();
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            Map<String, Object> params = new Map<String, Object>{
                PORTAL_ContentSubmissionControllerBase.CONTENT_VERSION_ID => content.Id,
                PORTAL_ContentSubmissionControllerBase.RECORD_ID => newListing.Id
            };

            Test.startTest();
            controller.attachContentDocument(params);
            Test.stopTest();

            List<ContentDocumentLink> contentDocuments = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :newListing.Id];
            Assert.isFalse(contentDocuments.isEmpty());
        }
    }


    static testMethod void testSubmitContentSetup() {
        PORTAL_TestClassFactory.getTestClassFactory().getContentSubmissionCtrlBaseTestClass().testSubmitContentSetup();
    }

    static testMethod void testSubmitContent() {
        PORTAL_TestClassFactory.getTestClassFactory().getContentSubmissionCtrlBaseTestClass().testSubmitContent();
    }

    static testMethod void testGetMySubmittedContent() {
        PORTAL_TestClassFactory.getTestClassFactory().getContentSubmissionCtrlBaseTestClass().testGetMySubmittedContent();
    }

    /**
     * Test initializeClassNoteSubmission
     * @author Jacob Huang
     * @since 1.18
     */
    static testMethod void testInitializeClassNoteSubmission() {
        PORTAL_TestClassFactory.getTestClassFactory().getContentSubmissionCtrlBaseTestClass().testInitializeClassNoteSubmission();
    }

    /**
     * Test resetClassNoteSubmission
     * @author Jacob Huang
     * @since 1.18
     */
    static testMethod void testResetClassNoteSubmission() {
        PORTAL_TestClassFactory.getTestClassFactory().getContentSubmissionCtrlBaseTestClass().testResetClassNoteSubmission();
    }

    /**
     * Test attachContentDocument
     * @author Jacob Huang
     * @since 1.18
     */
    static testMethod void testAttachContentDocument() {
        PORTAL_TestClassFactory.getTestClassFactory().getContentSubmissionCtrlBaseTestClass().testAttachContentDocument();
    }
}