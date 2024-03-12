@isTest
public class PORTAL_LookupControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetLookupOptions() {
            Map<String, Object> subContent = new Map<String, Object>();
            subContent.put('objectApiName', 'Contact');
            subContent.put('fieldApiName', 'LeadSource');
            subContent.put('filterClause', '');
            subContent.put('isPicklist', true);

            List<Map<String, Object>> content = new List<Map<String, Object>>{subContent};
	
            Test.startTest();

            try {
                List<Object> result = PORTAL_LookupController.SERVER_getLookupOptions(content, '', 1);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetLookupOptionsFalsePicklist() {
            Map<String, Object> subContent = new Map<String, Object>();
            subContent.put('objectApiName', 'Contact');
            subContent.put('fieldApiName', 'Name');
            subContent.put('filterClause', 'Id = \'\'');
            subContent.put('isPicklist', false);

            List<Map<String, Object>> content = new List<Map<String, Object>>{subContent};
	
            Test.startTest();

            try {
                List<Object> result = PORTAL_LookupController.SERVER_getLookupOptions(content, '', 1);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetDefaultLookupOptions() {	
            Test.startTest();

            try {
                List<Object> result = PORTAL_LookupController.SERVER_getDefaultLookupOptions('Test = \'\'',
                                                                                            'Contact',
                                                                                            'Name',
                                                                                            'Test',
                                                                                            1);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetDefaultLookupOptionsEmptyInputs() {	
            Test.startTest();

            try {
                List<Object> result = PORTAL_LookupController.SERVER_getDefaultLookupOptions('',
                                                                                            '',
                                                                                            '',
                                                                                            '',
                                                                                            1);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testGetLookupOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerTestClass().testGetLookupOptions();
    }

    static testMethod void testGetLookupOptionsFalsePicklist() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerTestClass().testGetLookupOptionsFalsePicklist();
    }

    static testMethod void testGetDefaultLookupOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerTestClass().testGetDefaultLookupOptions();
    }

    static testMethod void testGetDefaultLookupOptionsEmptyInputs() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerTestClass().testGetDefaultLookupOptionsEmptyInputs();
    }
}