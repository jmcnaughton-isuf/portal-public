@isTest
public class PORTAL_BATCH_DeleteTemporaryListingsTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testBatch() {
            PORTAL_BATCH_DeleteTemporaryListings deleteTemporaryListing = new PORTAL_BATCH_DeleteTemporaryListings();
            List<sObject> params = new List<sObject>();

            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c();
            insert listing;
            params.add(listing);

            ContentVersion version = new ContentVersion(Title = 'Temporary Title',
                                                        PathOnClient = 'Test.jpg',
                                                        VersionData = Blob.valueOf('Test Content'),
                                                        isMajorVersion = true);
            insert version;

            List<ContentDocument> documents = [SELECT Id FROM ContentDocument];

            ContentDocumentLink link = new ContentDocumentLink(ContentDocumentId = documents[0].Id,
                                                                LinkedEntityId = listing.Id);
            insert link;

            Test.startTest();

            try {
                Database.QueryLocator startResult = deleteTemporaryListing.start(null);
                System.assertNotEquals(null, startResult);

                deleteTemporaryListing.execute(null, params);
                List<sObject> remainingListings = [SELECT Id FROM ucinn_portal_Listing__c];
                System.assert(remainingListings.isEmpty());

                deleteTemporaryListing.finish(null);
                
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    static testMethod void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getBatchDeleteTemporaryListingsTestClass().testBatch();
    }
}