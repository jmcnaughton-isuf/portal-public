@isTest
public class PORTAL_LWC_SubmittedContentCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testSubmitContentSetup() {
            PORTAL_LWC_SubmittedContentController.SERVER_getMySubmittedContent(null);

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_SubmittedContentController.SERVER_getMySubmittedContent(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_SubmittedContentController.SERVER_getMySubmittedContent(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void testSubmitContentSetup() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcSubmittedContentCtrlTestClass().testSubmitContentSetup();
    }
}