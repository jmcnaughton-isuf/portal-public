@isTest
public class PORTAL_ListingCreateDraftCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public virtual void SERVER_saveStatusTest() {
            try {
                PORTAL_ListingCreateDraftController.SERVER_createDraft(null);
                PORTAL_ListingCreateDraftController.SERVER_createDraft(new Map<String, Object>{'test' => 'test'});
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

            PORTAL_ListingCreateDraftController.SERVER_createDraft(new Map<String, Object>{'masterRecordId' => newListing.Id});
        }
    }

    static testMethod void SERVER_saveStatusTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getListingCreateDraftCtrlTestClass().SERVER_saveStatusTest();
    }
}