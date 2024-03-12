@isTest
public class PORTAL_FormRowWrapperTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testConstructor() {
            Test.startTest();

            PORTAL_FormRowWrapper wrapper = new PORTAL_FormRowWrapper();

            Test.stopTest();
        }

        public virtual void testFormRecordWrapper() {
            Map<Object, Object> objectRecord = new Map<Object, Object>{'Test' => 'Test'};
            Object formData = new Map<Object, Object>{'formData' => objectRecord};

            Test.startTest();

            PORTAL_FormRecordWrapper wrapper = new PORTAL_FormRecordWrapper(formData);

            Test.stopTest();
        }
    }


    static testMethod void testConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getFormRowWrapperTestClass().testConstructor();
    }

    static testMethod void testFormRecordWrapper() {
        PORTAL_TestClassFactory.getTestClassFactory().getFormRowWrapperTestClass().testFormRecordWrapper();
    }
}