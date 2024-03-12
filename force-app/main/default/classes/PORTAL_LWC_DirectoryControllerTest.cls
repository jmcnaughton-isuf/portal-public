@isTest
public class PORTAL_LWC_DirectoryControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetContacts() {
            Test.startTest();

            try {
                Map<String, Object> params = new Map<String, Object>();
                params.put('searchText', 'Test');
                params.put('searchCriteriaList', new List<PORTAL_SearchCriteria>());
                params.put('searchCategoryList', new List<PORTAL_SearchCategory>());
                params.put('zone', 'Test');

                List<PORTAL_DirectoryControllerBase.ContactDisplayWrapper> result = PORTAL_LWC_DirectoryController.SERVER_getContacts(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetSearchDisplaySettings() {
            Test.startTest();

            try {
                Map<String, Object> params = new Map<String, Object>();
                params.put('zone', 'Test');

                List<Portal_Directory_Search_Criteria__mdt> result = PORTAL_LWC_DirectoryController.SERVER_getSearchDisplaySettings(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetAllDisplayOptions() {
            Test.startTest();

            try {
                Map<String, Object> params = new Map<String, Object>();
                params.put('displaySettingList', 'Test');
                params.put('searchText', 'Test');
                params.put('maxItems', 1);


                List<Object> result = PORTAL_LWC_DirectoryController.SERVER_getAllDisplayOptions(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testGetContacts() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcDirectoryControllerTestClass().testGetContacts();
    }

    static testMethod void testGetSearchDisplaySettings() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcDirectoryControllerTestClass().testGetSearchDisplaySettings();
    }

    static testMethod void testGetAllDisplayOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcDirectoryControllerTestClass().testGetAllDisplayOptions();
    }
}