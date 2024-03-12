@isTest
public class PORTAL_FormWrapperTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testFields() {
            PORTAL_FormWrapper wrapper = new PORTAL_FormWrapper();

            Test.startTest();

            wrapper.heading = 'Test';
            wrapper.formId = 'Test';
            wrapper.subSectionList = new List<PORTAL_FormWrapper>();
            wrapper.formRowList = new List<PORTAL_FormRowWrapper>();
            wrapper.isMultipleRecordForm = true;
            wrapper.isDisplay = true;

            String heading = wrapper.heading;
            String formId = wrapper.formId;
            List<PORTAL_FormWrapper> subSectionList = wrapper.subSectionList;
            List<PORTAL_FormRowWrapper> formRowList = wrapper.formRowList;
            Boolean isMultipleRecordForm = wrapper.isMultipleRecordForm;
            Boolean isDisplay = wrapper.isDisplay;
            
            System.assertEquals('Test', heading);
            System.assertEquals('Test', formId);
            System.assert(subSectionList.isEmpty());
            System.assert(formRowList.isEmpty());
            System.assertEquals(true, isMultipleRecordForm);
            System.assertEquals(true, isDisplay);

            Test.stopTest();
        }
    }


    static testMethod void testFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getFormWrapperTestClass().testFields();
    }
}