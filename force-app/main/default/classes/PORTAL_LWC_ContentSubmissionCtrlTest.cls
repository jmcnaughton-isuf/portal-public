@isTest
public class PORTAL_LWC_ContentSubmissionCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testInitializeContentSubmission() {
            try {
                PORTAL_LWC_ContentSubmissionController.SERVER_initializeContentSubmission(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_initializeContentSubmission(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_initializeContentSubmission(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testSubmitContent() {
            try {
                PORTAL_LWC_ContentSubmissionController.SERVER_submitContent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_submitContent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_submitContent(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testGetAttachedContentDocuments() {
            ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c(Name = 'Test');
            insert listing;

            Blob testData = Blob.valueOf('Test');
            ContentVersion content = new ContentVersion(
                Title = 'My Test',
                PathOnClient = 'mytest.txt',
                VersionData = testData
            );
            insert content;

            List<ContentVersion> contentWithContentDocumentId = [SELECT ContentDocumentId
                                                                FROM ContentVersion
                                                                WHERE Id = :content.Id];

            insert new ContentDocumentLink(
                ContentDocumentId = contentWithContentDocumentId[0].ContentDocumentId,
                LinkedEntityId = listing.Id
            );

            Test.startTest();

            List<Map<String, Object>> result = PORTAL_LWC_ContentSubmissionController.SERVER_getAttachedContentDocuments(null);
            System.assertEquals(0, result.size());

            Map<String, Object> params = new Map<String, Object>{PORTAL_ContentSubmissionControllerBase.RECORD_ID => listing.Id};
            result = PORTAL_LWC_ContentSubmissionController.SERVER_getAttachedContentDocuments(params);
            System.assertEquals(1, result.size());

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_getAttachedContentDocuments(null);
                System.assert(false);
            } catch (AuraHandledException ahe) { }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_getAttachedContentDocuments(null);
                System.assert(false);
            } catch (Exception e) { }

            Test.stopTest();
        }

        public virtual void testInitializeClassNoteSubmission() {
            try {
                PORTAL_LWC_ContentSubmissionController.SERVER_initializeClassNoteSubmission(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_initializeClassNoteSubmission(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_initializeClassNoteSubmission(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testResetClassNoteSubmission() {
            try {
                PORTAL_LWC_ContentSubmissionController.SERVER_resetClassNoteSubmission(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_resetClassNoteSubmission(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_resetClassNoteSubmission(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void testAttachContentDocument() {
            try {
                PORTAL_LWC_ContentSubmissionController.SERVER_attachContentDocument(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_attachContentDocument(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_ContentSubmissionController.SERVER_attachContentDocument(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    static testMethod void testInitializeContentSubmission() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcContentSubmissionCtrlTestClass().testInitializeContentSubmission();
    }

    static testMethod void testSubmitContent() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcContentSubmissionCtrlTestClass().testSubmitContent();
    }

    static testMethod void testGetAttachedContentDocuments() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcContentSubmissionCtrlTestClass().testGetAttachedContentDocuments();

    }

    /**
     * Test initializeClassNoteSubmission
     * @author Jacob Huang
     * @since 1.18
     */
    static testMethod void testInitializeClassNoteSubmission() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcContentSubmissionCtrlTestClass().testInitializeClassNoteSubmission();
    }

    /**
     * Test resetClassNoteSubmission
     * @author Jacob Huang
     * @since 1.18
     */
    static testMethod void testResetClassNoteSubmission() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcContentSubmissionCtrlTestClass().testResetClassNoteSubmission();
    }

    /**
     * Test attachContentDocument
     * @author Jacob Huang
     * @since 1.18
     */
    static testMethod void testAttachContentDocument() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcContentSubmissionCtrlTestClass().testAttachContentDocument();
    }
}