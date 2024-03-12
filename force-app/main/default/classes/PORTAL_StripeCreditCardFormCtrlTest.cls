@isTest
public class PORTAL_StripeCreditCardFormCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testController() {
	
            Test.startTest();

            try {
                PORTAL_StripeCreditCardFormController controller = new PORTAL_StripeCreditCardFormController();
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
        PORTAL_TestClassFactory.getTestClassFactory().getStripeCreditCardFormCtrlTestClass().testController();
    }
}