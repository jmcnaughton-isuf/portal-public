@isTest
public class PORTAL_TRIG_ListingHandlerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public ContentVersion contentVersion1;
        public ContentVersion contentVersion2;
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void setupDataForImages() {
            contentVersion1 = new ContentVersion(title = 'ABC', PathOnClient='test.jpg', IsMajorVersion = true);
            Blob b = Blob.valueOf('Unit Test Attachment Body');
            contentVersion1.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
            contentVersion1 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentVersion1});
            insert contentVersion1;

            contentVersion2 = new ContentVersion(title = 'ABC1', PathOnClient='test1.jpg', IsMajorVersion = true);
            Blob b1 = Blob.valueOf('Unit Test Attachment Body1');
            contentVersion2.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body1');
            contentVersion2 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentVersion2});
            insert contentVersion2;
        }

        public virtual void setupTriggerHandler() {
            ucinn_ascendv2__Trigger_Handler__c triggerHandler = new ucinn_ascendv2__Trigger_Handler__c(ucinn_ascendv2__Class__c = 'PORTAL_TRIG_ListingHandler',
                                                                                                        ucinn_ascendv2__Object__c = 'ucinn_portal_Listing__c',
                                                                                                        ucinn_ascendv2__Is_Active__c = true,
                                                                                                        ucinn_ascendv2__Load_Order__c = 1,
                                                                                                        ucinn_ascendv2__Trigger_Action__c = 'BeforeInsert;AfterInsert;BeforeUpdate;AfterUpdate;BeforeDelete;AfterDelete');

            triggerHandler = (ucinn_ascendv2__Trigger_Handler__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => triggerHandler});
            insert triggerHandler;
        }

        public virtual void runTriggerForImages() {
            setupDataForImages();
            setupTriggerHandler();
            ucinn_portal_Listing__c listing1 = new ucinn_portal_Listing__c(Header_Image__c = 'image', Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
            ucinn_portal_Listing__c listing3 = new ucinn_portal_Listing__c(Header_Image__c = 'image', Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
            listing1 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing1});
            listing3 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing3});
            insert listing1;
            insert listing3;
            List<SObject> oldList = new List<SObject>{};
            List<SObject> newList = new List<SObject>{listing1};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert,
                                                    ucinn_portal_Listing__c.sObjectType.getDescribe());

            oldList = new List<SObject>{listing1.clone(true, true, true, true)};

            listing1.Header_Image__c = '<p><img src="https://uchicago--full--c.documentforce.com/servlet/rtaImage?eid=a425B00000054vf&amp;feoid=00N5B000003r7Sr&amp;refid=0EM5B000000E2Il" alt="Basketball-Tournament-1.png"></img></p>';
            listing1.Body_Content__c = 'Body Content1';
            listing1.Header_Content__c = 'Header Content1';
            listing1.Footer_Content__c = 'Footer Content';

            newList = new List<SObject>{listing1};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                    ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                    ucinn_portal_Listing__c.sObjectType.getDescribe());

            update listing1;

            oldList = new List<SObject>{listing1.clone(true, true, true, true), listing3.clone(true, true, true, true)};

            listing1.Header_Image__c = '<p><img src="https://uchicago--full--c.documentforce.com/servlet.shepherd/version/download/' + contentVersion1.Id + '" alt="Basketball-Tournament-1.png"></img></p>';
            listing3.Header_Image__c = '<p><img src="https://uchicago--full--c.documentforce.com/servlet.shepherd/version/download/' + contentVersion1.Id + '" alt="Basketball-Tournament-1.png"></img></p>';

            newList = new List<SObject>{listing1, listing3};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            update new List<ucinn_portal_Listing__c>{listing1, listing3};

            listing1.Footer_Content__c = '';

            listing1.Header_Image__c = [SELECT Header_Image__c FROM ucinn_portal_Listing__c WHERE id = :listing1.Id].Header_Image__c;

            oldList = new List<SObject>{listing1.clone(true, true, true, true)};

            listing1.Header_Image__c = 'test';
            newList = new List<SObject>{listing1};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            update new ucinn_portal_Listing__c(id = listing1.Id, Footer_Content__c = listing1.Footer_Content__c);


            ucinn_portal_Listing__c listing2 = new ucinn_portal_Listing__c(Header_Image__c = '<p><img src="https://uchicago--full--c.documentforce.com/servlet/rtaImage?eid=a425B00000054vf&amp;feoid=00N5B000003r7Sr&amp;refid=0EM5B000000E2Il" alt="Basketball-Tournament-1.png"></img></p>', Body_Content__c = 'Body', Header_Content__c = 'Header Content', Footer_Content__c = 'Footer Content');
            listing2 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing2});
            insert listing2;

            oldList = new List<SObject>();
            newList = new List<SObject>{listing2};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            oldList = new List<SObject>{listing2.clone(true, true, true, true)};

            listing2.Header_Image__c = '<p><img src="https://uchicago--full--c.documentforce.com/servlet.shepherd/version/download/' + contentVersion1.Id + '" alt="Basketball-Tournament-1.png"></img></p>';
            listing2.Footer_Content__c = listing2.Header_Image__c;
            listing2.Body_Content__c = '<p><img src="https://uchicago--full--c.documentforce.com/servlet.shepherd/version/download/' + contentVersion2.Id + '" alt="Basketball-Tournament-1.png"></img></p>';
            listing2.Header_Content__c = listing2.Body_Content__c;

            newList = new List<SObject>{listing2};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            update listing2;

            listing2 = [SELECT Body_Content__c FROM ucinn_portal_Listing__c WHERE id = :listing2.Id];

            oldList = new List<SObject>{listing1.clone(true, true, true, true), listing3.clone(true, true, true, true)};

            listing1.Header_Image__c = listing2.Body_Content__c;
            listing3.Header_Image__c = listing2.Body_Content__c;

            newList = new List<SObject>{listing1, listing3};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            update new List<ucinn_portal_Listing__c>{listing1, listing3};

            newList = new List<SObject>();
            oldList = new List<SObject>{listing1};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeDelete,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());
            delete listing1;

            oldList = new List<SObject>{listing3};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeDelete,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());
            delete listing3;
        }

        public virtual void runTriggerForEvents() {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event',
                                                                             Header_Content__c = 'This is a Test.',
                                                                             RecordTypeId = recordTypeId,
                                                                             Status__c = 'Pending',
                                                                             State__c = 'CA');

            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            List<SObject> oldList = new List<SObject>{};
            List<SObject> newList = new List<SObject>{newListing};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                    oldList,
                                                    ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert,
                                                    ucinn_portal_Listing__c.sObjectType.getDescribe());

            oldList = new List<SObject>{newListing.clone(true, true, true, true)};
            newListing.Country__c = 'United States';
            newList = new List<SObject>{newListing};

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());

            new PORTAL_TRIG_ListingHandler().run(newList,
                                                 oldList,
                                                 ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate,
                                                 ucinn_portal_Listing__c.sObjectType.getDescribe());
        }

        /**
         * Test after update waitlist code
         * 
         * @author Jacob Huang
         * @since 1.1
         */
        public virtual void runTriggerForEventWaitlist() {
            Schema.DescribeSObjectResult listingDescribe = ucinn_portal_Listing__c.sObjectType.getDescribe();
            ucinn_ascendv2.ascend_TDTM_Runnable.Action afterUpdateAction = ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate;

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', RecordTypeId = recordTypeId, Status__c = 'Published', Maximum_Number_of_Enrollment__c = 0);
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            List<SObject> oldList = new List<SObject>{newListing.clone(true, true, true, true)};
            List<SObject> newList = new List<SObject>{newListing};

            ucinn_portal_Ticket_Type__c newTicketType = new ucinn_portal_Ticket_Type__c(Listing__c = newListing.Id, Price__c = 5);
            newTicketType = (ucinn_portal_Ticket_Type__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newTicketType});
            insert newTicketType;

            ucinn_portal_Event_Waitlist_Entry__c waitlistEntryRecord = new ucinn_portal_Event_Waitlist_Entry__c(Ticket_Type__c = newTicketType.Id, 
                                                                                                                Number_of_Tickets_Awaiting__c = 20, 
                                                                                                                First_Name__c = 'Test', 
                                                                                                                Last_Name__c = 'Test',
                                                                                                                Email__c = 'test@ucinnovation.com');
            waitlistEntryRecord = (ucinn_portal_Event_Waitlist_Entry__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => waitlistEntryRecord});
            insert waitlistEntryRecord;

            Test.startTest();

            new PORTAL_TRIG_ListingHandler().run(new List<SObject>(), new List<SObject>(), afterUpdateAction, listingDescribe);
            System.assertEquals(0, PORTAL_TRIG_ListingHandler.getListingsWithAvailableTickets(null, null).size());

            newListing.Maximum_Number_of_Enrollment__c = 5;
            update newListing;
            new PORTAL_TRIG_ListingHandler().run(newList, oldList, afterUpdateAction, listingDescribe);
            waitlistEntryRecord = [SELECT Number_of_Tickets_Available__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Id = :waitlistEntryRecord.Id];
            System.assertEquals(5, waitlistEntryRecord.Number_of_Tickets_Available__c);

            newListing.Maximum_Number_of_Enrollment__c = null;
            update newListing;
            new PORTAL_TRIG_ListingHandler().run(newList, oldList, afterUpdateAction, listingDescribe);
            waitlistEntryRecord = [SELECT Number_of_Tickets_Available__c FROM ucinn_portal_Event_Waitlist_Entry__c WHERE Id = :waitlistEntryRecord.Id];
            System.assertEquals(20, waitlistEntryRecord.Number_of_Tickets_Available__c);
      
            new PORTAL_TRIG_ListingHandler().run(oldList, oldList, afterUpdateAction, listingDescribe);

            Test.stopTest();
        }
    }

    static testMethod void runTriggerForImages() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ListingHandlerTestClass().runTriggerForImages();
    }

    static testMethod void runTriggerForEvents() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ListingHandlerTestClass().runTriggerForEvents();
    }

    static testMethod void runTriggerForEventWaitlist() {
        PORTAL_TestClassFactory.getTestClassFactory().getTRIG_ListingHandlerTestClass().runTriggerForEventWaitlist();

    }
}