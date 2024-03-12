@isTest
public class PORTAL_ListingChangeStatusCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void SERVER_createDraftTest() {
            try {
                PORTAL_ListingChangeStatusController.SERVER_saveStatus(null);
                PORTAL_ListingChangeStatusController.SERVER_saveStatus(new Map<String, Object>{'test' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_ListingChangeStatusController.SERVER_saveStatus(new Map<String, Object>{'recordId' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_ListingChangeStatusController.SERVER_saveStatus(new Map<String, Object>{'recordId' => 'test',
                                                                                               'newStatus' => 'Draft'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', Header_Content__c = 'This is a Test.', RecordTypeId = recordTypeId, Status__c = 'Published');

            DateTime currentDateTime = DateTime.now().addDays(-10);
            newListing.Start_Date_Time__c = currentDateTime;
            newListing.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/Indiana/Indianapolis)';
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            PORTAL_ListingChangeStatusController.SERVER_saveStatus(new Map<String, Object>{'recordId' => newListing.Id,
                                                                                           'newStatus' => 'Published'});
        }

        public virtual void SERVER_saveDraftTest() {
            try {
                PORTAL_ListingChangeStatusController.SERVER_saveDraft(null);
                PORTAL_ListingChangeStatusController.SERVER_saveDraft(new Map<String, Object>{'test' => 'test'});
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c(Name = 'Test Event', Header_Content__c = 'This is a Test.', RecordTypeId = recordTypeId, Status__c = 'Published');

            DateTime currentDateTime = DateTime.now().addDays(-10);
            newListing.Start_Date_Time__c = currentDateTime;
            newListing.Time_Zone__c = '(GMT–04:00) Eastern Daylight Time (America/Indiana/Indianapolis)';
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            String masterListingId = newListing.Id;

            newListing.Id = null;
            newListing.Master_Listing__c = masterListingId;
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            PORTAL_ListingChangeStatusController.SERVER_saveDraft(new Map<String, Object>{'recordId' => newListing.Id});

            newListing.Id = null;
            newListing.Status__c = 'Draft';
            newListing = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => newListing});
            insert newListing;

            PORTAL_ListingChangeStatusController.SERVER_saveDraft(new Map<String, Object>{'recordId' => newListing.Id});
        }
    }

    static testMethod void SERVER_createDraftTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingChangeStatusCtrlTestClass().SERVER_createDraftTest();
    }

    static testMethod void SERVER_saveDraftTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingChangeStatusCtrlTestClass().SERVER_saveDraftTest();
    }
}