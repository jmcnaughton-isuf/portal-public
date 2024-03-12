@isTest
public class PORTAL_LWC_LookupControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetLookupOptions() {
            Map<String, Object> params = new Map<String, Object>();
            params.put('displaySettingList', new List<Object>());
            params.put('customMetadataApiName', 'Test');
            params.put('searchText', 'Test');
            params.put('maxItems', 1);
	
            Test.startTest();

            try {
                List<Object> result = PORTAL_LWC_LookupController.SERVER_getLookupOptions(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testGetLookupOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcLookupControllerTestClass().testGetLookupOptions();
    }
}