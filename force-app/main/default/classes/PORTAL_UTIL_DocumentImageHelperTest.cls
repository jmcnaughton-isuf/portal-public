@isTest
public inherited sharing class PORTAL_UTIL_DocumentImageHelperTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        // public PORTAL_UTIL_DocumentImageHelperTest() {

        // }
        public ContentVersion contentVersion1;
        public ContentVersion contentVersion2;
        public ContentVersion contentVersion3;

        public virtual void setupDataForImages() {
            contentVersion1 = new ContentVersion(title = 'ABC', PathOnClient='test.jpg', IsMajorVersion = true);
            Blob b = Blob.valueOf('Unit Test Attachment Body');
            contentVersion1.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
            contentVersion1 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentVersion1});
            insert contentVersion1;

            contentVersion2 = new ContentVersion(title = 'ABC1', PathOnClient='test1.jpg', IsMajorVersion = true, IsAssetEnabled = true);
            Blob b1 = Blob.valueOf('Unit Test Attachment Body1');
            contentVersion2.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body1');
            contentVersion2 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentVersion2});
            insert contentVersion2;

            contentVersion3 = new ContentVersion(title = 'ABC2', PathOnClient='test.jpg', IsMajorVersion = true);
            Blob b2 = Blob.valueOf('Unit Test Attachment Body');
            contentVersion3.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
            contentVersion3 = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentVersion3});
            insert contentVersion3;


            contentVersion2 = [SELECT id, ContentDocumentId, Title, VersionNumber, ContentDocument.ContentAssetId, ContentDocument.ContentAsset.DeveloperName FROM ContentVersion WHERE Id =:contentVersion2.Id];
        }

        public virtual void testUpdateImgTagAltText() {

            String altText = 'testAltText';
            String imageFieldName = 'Header_Image__c';
            SObject listing = new ucinn_portal_Listing__c(Header_Image__c = '<img src="/testsource/" style="height="210" width="420">');

            listing.put(imageFieldName, PORTAL_UTIL_DocumentImageHelper.updateImgTagAltText(listing, '', altText, imageFieldName));

            System.assertEquals('<img alt="testAltText" src="/testsource/" style="height="210" width="420">', listing.get(imageFieldName));

            String replacementAltText = 'replacedAltText';

            listing.put(imageFieldName, PORTAL_UTIL_DocumentImageHelper.updateImgTagAltText(listing, altText, replacementAltText, imageFieldName));

            System.assertEquals('<img alt="replacedAltText" src="/testsource/" style="height="210" width="420">', listing.get(imageFieldName));

        }

        public virtual void runTriggerForImages() {
            setupDataForImages();
            ucinn_portal_Listing__c listing1 = new ucinn_portal_Listing__c(Header_Image__c = 'image', Header_Image_Alt_Text__c='alt text', Header_Content__c = 'Header Content');
            ucinn_portal_Listing__c listing2 = new ucinn_portal_Listing__c(Header_Image__c = 'image', Header_Image_Alt_Text__c='alt text', Header_Content__c = 'Header Content');
            ucinn_portal_Listing__c listing3 = new ucinn_portal_Listing__c(Header_Image__c = 'image', Header_Content__c = 'Header Content');
            listing1 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing1});
            listing2 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing2});
            listing3 = (ucinn_portal_Listing__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => listing3});
            insert listing1;
            insert listing2;
            insert listing3;

            SObject record1 = (SObject) listing1;
            List<SObject> triggerNew = new List<SObject>{record1};
            List<SObject> triggerOld = null;

            PORTAL_UTIL_DocumentImageHelper.updateImages(triggerNew, triggerOld, ucinn_portal_Listing__c.getSObjectType());

            listing1.Header_Image__c = '<p><img src="https://domain.documentforce.com/servlet.shepherd/version/download/' + contentVersion1.Id + '" alt="Basketball-Tournament-1.png"></img></p>';
            listing1.Header_Content__c = 'Header Content1';

            listing2.Header_Image__c = '<p><img alt="alt text" src="https://domain.my.salesforce.com/file-asset/' + contentVersion2.ContentDocument.ContentAsset.DeveloperName + '?oid=orgId" alt="Basketball-Tournament-1.png"></img></p>';
            listing3.Header_Image__c = '<p><img alt="alt text" src="https://domain.my.salesforce.com/file-asset/' + contentVersion2.ContentDocument.ContentAsset.DeveloperName + '?oid=orgId" alt="Basketball-Tournament-1.png"></img></p>';

            record1 = (SObject) listing1;
            SObject record2 = (SObject) listing2;
            SObject record3 = (SObject) listing3;

            triggerNew = new List<SObject>{record1};

            PORTAL_UTIL_DocumentImageHelper.updateImages(triggerNew, triggerOld, ucinn_portal_Listing__c.getSObjectType());

            triggerNew = new List<SObject>{record2, record3};

            PORTAL_UTIL_DocumentImageHelper.updateImages(triggerNew, triggerOld, ucinn_portal_Listing__c.getSObjectType());

            System.debug('1:' + listing1.Header_Image__c);
            System.debug('2:' + listing2.Header_Image__c);
            System.debug('3:' + listing3.Header_Image__c);

            ucinn_portal_Listing__c listing1Copy = new ucinn_portal_Listing__c(Id = listing1.Id, Header_Image__c = '<p><img src="https://domain.documentforce.com/servlet.shepherd/version/download/' + contentVersion3.Id + '" alt="Basketball-Tournament-1.png"></img></p>');

            record1 = (SObject) listing1;
            SObject record1Copy = (SObject) listing1Copy;
            triggerOld = new List<SObject>{record1};
            triggerNew = new List<SObject>{record1Copy};

            PORTAL_UTIL_DocumentImageHelper.updateImages(triggerNew, triggerOld, ucinn_portal_Listing__c.getSObjectType());

            update record1;

            PORTAL_UTIL_DocumentImageHelper.getUrlFromImageHtml(listing1.Header_Image__c);

            triggerOld = new List<SObject>{record1, record3};
            triggerNew = null;
            PORTAL_UTIL_DocumentImageHelper.updateImages(triggerNew, triggerOld, ucinn_portal_Listing__c.getSObjectType());

        }
    }

    static testMethod void testUpdateImgTagAltText() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DocumentImageHelperTestClass().testUpdateImgTagAltText();
    }

    static testMethod void runTriggerForImages() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_DocumentImageHelperTestClass().runTriggerForImages();
    }
}