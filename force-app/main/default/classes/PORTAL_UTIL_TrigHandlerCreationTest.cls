@isTest
public class PORTAL_UTIL_TrigHandlerCreationTest {
    public virtual class TestClass extends PORTAL_TestClassBase {

        public virtual void testCreatePortalTriggerHandlers() {
            Test.startTest();
            PORTAL_UTIL_TrigHandlerCreation.createPortalTriggerHandlers();
            Test.stopTest();
        }
    }

    static testMethod void testCreatePortalTriggerHandlers(){
        PORTAL_TestClassFactory.getTestClassFactory().getPortalUtilTrigHandlerCreationTestClass().testCreatePortalTriggerHandlers();
    }
}