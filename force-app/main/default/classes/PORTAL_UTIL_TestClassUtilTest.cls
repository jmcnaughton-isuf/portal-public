@isTest
public class PORTAL_UTIL_TestClassUtilTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testPopulateRequiredFieldsOnObject() {
            PORTAL_UTIL_TestClassUtil controller = new PORTAL_UTIL_TestClassUtil();

            Test.startTest();
            System.assertEquals(null, controller.populateRequiredFieldsOnObject(new Map<String, Object>{'SOBJECT' => null}));
            System.assertEquals(null, controller.populateRequiredFieldsOnObject(null));

            Contact testCon = (Contact)controller.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => new Contact()});
            insert testCon;
            Test.stopTest();
        }
    }
    static testMethod void testPopulateRequiredFieldsOnObject() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_TestClassUtilTestClass().testPopulateRequiredFieldsOnObject();
    }
}