@isTest
public class PORTAL_UTIL_ListingTest {
    public class TestClass extends PORTAL_TestClassBase{
        public void testQueryListingAllFieldsEmptyRecordId() {
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', '');

            Test.startTest();

            try {
                ucinn_portal_Listing__c result = PORTAL_UTIL_Listing.queryListingAllFields(params);
            }
            catch (AuraHandledException ahe) {
                String errorMessage = ahe.getMessage();
                System.assertEquals('Script-thrown exception', errorMessage);
            }

            Test.stopTest();
        }
    }

    static testMethod void testQueryListingAllFieldsEmptyRecordId() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_ListingTestClass().testQueryListingAllFieldsEmptyRecordId();
    }
}