@isTest
public class PORTAL_TRIG_ContentDocumentLinkHdlrTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testRun() {
            ContentVersion version = new ContentVersion(Title = 'Temporary Title',
                                                        PathOnClient = 'Test.jpg',
                                                        VersionData = Blob.valueOf('Test Content'),
                                                        isMajorVersion = true);
            insert version;

            List<ContentDocument> documents = [SELECT Id FROM ContentDocument];

            Opportunity opp = new Opportunity(Name = 'Test',
                                            StageName = 'Planned',
                                            CloseDate = Date.today());
            insert opp;

            ContentDocumentLink link = new ContentDocumentLink(ContentDocumentId = documents[0].Id,
                                                                LinkedEntityId = opp.Id);
            insert link;

            List<sObject> oldList = new List<sObject>();
            List<sObject> newList = new List<sObject>{link};
	
            Test.startTest();

            new PORTAL_TRIG_ContentDocumentLinkHandler().run(newList,
                                                            oldList,
                                                            ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate,
                                                            ContentDocumentLink.getSObjectType().getDescribe());


            Test.stopTest();
        }
    }


    static testMethod void testRun() {
        PORTAL_TestClassFactory.getTestClassFactory().getTrigContentDocumentLinkHdlrTestClass().testRun();
    }
}