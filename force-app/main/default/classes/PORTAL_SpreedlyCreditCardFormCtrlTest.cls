@isTest
public class PORTAL_SpreedlyCreditCardFormCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testController() {
	
            Test.startTest();

            try {
                PORTAL_SpreedlyCreditCardFormController controller = new PORTAL_SpreedlyCreditCardFormController();
                controller.lexOrigin = 'Test';
                String lOrogin = controller.lexOrigin;
                System.assertNotEquals(null, lOrogin);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testController() {
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyCreditCardFormCtrlTestClass().testController();
    }
}