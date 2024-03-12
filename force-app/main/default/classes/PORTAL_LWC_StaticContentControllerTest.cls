@isTest
public class PORTAL_LWC_StaticContentControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void SERVER_getContentModuleMetadataTest() {
            try {
                PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
        
        public virtual void SERVER_getContentPageCSSClassesTest() {
            try {
                PORTAL_LWC_StaticContentController.SERVER_getContentPageCSSClasses(null);
            } catch (Exception e) {
                System.debug(e);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_StaticContentController.SERVER_getContentPageCSSClasses(null);
            } catch (Exception e) {
                System.debug(e);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_StaticContentController.SERVER_getContentPageCSSClasses(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    static testMethod void SERVER_getContentModuleMetadataTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcStaticContentControllerTestClass().SERVER_getContentModuleMetadataTest();
    }

    static testMethod void SERVER_getContentPageCSSClassesTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcStaticContentControllerTestClass().SERVER_getContentPageCSSClassesTest();
    }
}