@isTest
public with sharing class PORTAL_LWC_FileDownloadControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testGetFilesForDownload() {
            ucinn_portal_Downloadable_Content__c dlc = new ucinn_portal_Downloadable_Content__c(Name = 'Test', Component_Name__c = 'mytest');
            dlc = (ucinn_portal_Downloadable_Content__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => dlc});
            insert dlc;

            ContentVersion content = new ContentVersion(Title = 'Test', PathOnClient = 'test.txt', VersionData = Blob.valueOf('Test'));
            content = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => content});
            insert content;

            List<ContentVersion> contentWithContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id];
            ContentDocumentLink link = new ContentDocumentLink(ContentDocumentId = contentWithContentDocumentId[0].ContentDocumentId, LinkedEntityId = dlc.Id);
            link = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => link});
            insert link;

            Test.startTest();
            Assert.isTrue(PORTAL_LWC_FileDownloadController.SERVER_getFilesForDownload(null).isEmpty());

            Map<String, Object> params = new Map<String, Object>{PORTAL_FileDownloadControllerBase.COMPONENT_NAME => 'doesnotexist'};
            Assert.isTrue(PORTAL_LWC_FileDownloadController.SERVER_getFilesForDownload(params).isEmpty());

            params = new Map<String, Object>{PORTAL_FileDownloadControllerBase.COMPONENT_NAME => 'mytest'};
            Map<String, Object> resultMap = PORTAL_LWC_FileDownloadController.SERVER_getFilesForDownload(params);
            Assert.isFalse(resultMap.isEmpty());
            Assert.areEqual(1, ((List<Object>)resultMap.get(PORTAL_FileDownloadControllerBase.RECORDS_CONST)).size());

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_FileDownloadController.SERVER_getFilesForDownload(null);
                Assert.isTrue(false);
            } catch (AuraHandledException ahe) { }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_FileDownloadController.SERVER_getFilesForDownload(null);
                Assert.isTrue(false);
            } catch (Exception e) { }

            Test.stopTest();
        }
    }

    /**
     * Test getFilesForDownload
     * @author Jacob Huang
     * @since 1.19
     */
    @isTest
    public static void testGetFilesForDownload() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcFileDownloadControllerTestClass().testGetFilesForDownload();
    }
}