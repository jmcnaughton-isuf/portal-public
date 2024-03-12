@isTest
public class PORTAL_SpreedlyACHFormControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testController() {
	
            Test.startTest();

            try {
                PORTAL_SpreedlyACHFormController controller = new PORTAL_SpreedlyACHFormController();
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
        PORTAL_TestClassFactory.getTestClassFactory().getSpreedlyACHFormControllerTestClass().testController();
    }
}