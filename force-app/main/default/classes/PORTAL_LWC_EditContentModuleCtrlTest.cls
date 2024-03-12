@isTest
public class PORTAL_LWC_EditContentModuleCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void SERVER_getContentModuleTemplateListTest() {
            try {
                PORTAL_LWC_EditContentModuleController.SERVER_getContentModuleTemplateList(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void SERVER_getContentModuleByRecordIdTest() {
            try {
                PORTAL_LWC_EditContentModuleController.SERVER_getContentModuleByRecordId(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

        public virtual void SERVER_saveContentModuleTest() {
            try {
                PORTAL_LWC_EditContentModuleController.SERVER_saveContentModule(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    static testMethod void SERVER_getContentModuleTemplateListTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEditContentModuleCtrlTestClass().SERVER_getContentModuleTemplateListTest();
    }

    static testMethod void SERVER_getContentModuleByRecordIdTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEditContentModuleCtrlTestClass().SERVER_getContentModuleByRecordIdTest();
    }

    static testMethod void SERVER_saveContentModuleTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcEditContentModuleCtrlTestClass().SERVER_saveContentModuleTest();

    }
}