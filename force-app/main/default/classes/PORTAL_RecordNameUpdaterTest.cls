@isTest
public class PORTAL_RecordNameUpdaterTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testUpdateRecordNames() {
            ucinn_portal_Listing__c newListing = new ucinn_portal_Listing__c();
            insert newListing;
            
            List<ucinn_portal_Listing__c> listingList = new List<ucinn_portal_Listing__c>();
            listingList.add(newListing);

            PORTAL_RecordNameUpdater recordNameUpdater = new PORTAL_RecordNameUpdater();
            recordNameUpdater.updateRecordNames(listingList, 'Listing_Name_Auto_Number__c');
        }
    }

    static testMethod void testUpdateRecordNames() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalRecordNameUpdaterTestClass().testUpdateRecordNames();
    }
}