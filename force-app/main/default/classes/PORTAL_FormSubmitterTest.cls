@isTest
public class PORTAL_FormSubmitterTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testConvertObjectToFormDataMap() {
            PORTAL_PageSectionFormSubmitter submitter = new PORTAL_PageSectionFormSubmitter(null);
            Map<Object, Object> objectRecord = new Map<Object, Object>();
            Map<Object, Object> subListContent = new Map<Object, Object>();
            List<Object> subList = new List<Object>();
            subList.add(subListContent);
            objectRecord.put('Test', subList);

            Test.startTest();

            Map<String, List<PORTAL_FormRecordWrapper>> result = submitter.convertObjectToFormDataMap(objectRecord);
            System.assertNotEquals(null, result);

            Test.stopTest();
        }
    }


    static testMethod void testConvertObjectToFormDataMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getFormSubmitterTestClass().testConvertObjectToFormDataMap();
    }
}