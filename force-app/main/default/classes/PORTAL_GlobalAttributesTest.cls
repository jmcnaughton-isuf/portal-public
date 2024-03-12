@isTest
public class PORTAL_GlobalAttributesTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();

        public virtual void testSourceUrl() {
            PORTAL_GlobalAttributes testGlobalAttributes = PORTAL_GlobalAttributes.getInstance();
            
            testGlobalAttributes.setPathUrl('testValue');
            System.assertEquals('testValue', testGlobalAttributes.getPathUrl());
        }
    }

    @isTest
    public static void testInterimSourceUrl() {
        PORTAL_TestClassFactory.getTestClassFactory().getGlobalAttributesTestClass().testSourceUrl();
    }
}