@isTest
public class PORTAL_BATCH_DeleteJobApplicationsTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
        public virtual void setupData() {
            ucinn_portal_Job__c job = new ucinn_portal_Job__c();
            job.Status__c = 'Posted';
            job.Name = 'Test Job';
            job = (ucinn_portal_Job__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => job});
            insert job;

            ucinn_portal_Job_Application__c application = new ucinn_portal_Job_Application__c(Status__c = 'Temporary',
                                                                                              Job__c = job.Id,
                                                                                              Name = 'Test Application');
            application = (ucinn_portal_Job_Application__c)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => application});
            insert application;

            ContentVersion cv = new ContentVersion(Title = 'Test',
                                                    PathOnClient = 'Test.jpg',
                                                    VersionData = blob.valueOf('Test CV data'),
                                                    IsMajorVersion = true);
            cv = (ContentVersion)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => cv});
            insert cv;
            ContentDocumentLink contentLink = new ContentDocumentLink();
            contentLink.LinkedEntityId = application.Id;
            contentLink.ShareType = 'V';
            contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion Where Id =: cv.Id].ContentDocumentId;
            contentLink = (ContentDocumentLink)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => contentLink});
            insert contentLink;
        }

        public virtual void testBatch() {
            setupData();
            Test.startTest();
            Database.executeBatch(new PORTAL_BATCH_DeleteJobApplications());
            Test.stopTest();
        }
    }

    @isTest
    public static void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getDeleteJobApplicationsTestClass().testBatch();
    }
}