@isTest
public class PORTAL_LookupControllerBaseTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetAllLookupOptions() {
            PORTAL_LookupControllerBase controller = new PORTAL_LookupControllerBase();
            Map<String, Object> params = new Map<String, Object>();
            Map<Object, Object> displaySetting = new Map<Object, Object>();
            displaySetting.put('customMetadataDeveloperName', 'Volunteer_Edit_Skill_Name');
            List<Object> displaySettingList = new List<Object>();
            displaySettingList.add(displaySetting);
            params.put('displaySettingList', displaySettingList);
            params.put('customMetadataApiName', 'Portal_Section_Field_Setting__mdt');
            params.put('searchText', 'Test');
            params.put('maxItems', 1);

            Test.startTest();

            try {
                List<Object> result = controller.getAllLookupOptions(params);
                System.assertNotEquals(null, result);

            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetAllLookupOptionsAlternative() {
            PORTAL_LookupControllerBase controller = new PORTAL_LookupControllerBase();
            Map<String, Object> params = new Map<String, Object>();
            Map<Object, Object> displaySetting = new Map<Object, Object>();
            displaySetting.put('customMetadataDeveloperName', 'Directory_School_Degree_Degree');
            List<Object> displaySettingList = new List<Object>();
            displaySettingList.add(displaySetting);
            params.put('displaySettingList', displaySettingList);
            params.put('customMetadataApiName', 'Portal_Section_Field_Setting__mdt');
            params.put('searchText', 'Test');
            params.put('maxItems', 1);

            Test.startTest();

            try {
                List<Object> result = controller.getAllLookupOptions(params);
                System.assertNotEquals(null, result);

            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testGetLookupOptions() {
            Test.startTest();

            try {
                List<Object> result = PORTAL_LookupControllerBase.getLookupOptions('Contact',
                                                                                    'LeadSource',
                                                                                    'Id = \'\'',
                                                                                    'Other',
                                                                                    true,
                                                                                    1);
                System.assertNotEquals(null, result);

            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
        
        public virtual void testGetPicklistValuesFromQueryInfoMap() {
            Map<String, String> queryInfoMap = new Map<String, String>();
            String staticList = ';\r\nSearch;\r\nTest;Test\r\nSearch;Test\r\n';
            queryInfoMap.put(PORTAL_LookupControllerBase.STATIC_LIST, staticList);
            
            String searchText = 'Search';
            Integer maxItems = 2;
            List<Object> picklistValues = new List<Object>();

            Test.startTest();
            PORTAL_LookupControllerBase.getPicklistValuesFromQueryInfoMap(queryInfoMap, searchText, maxItems);
            maxItems = 3;
            PORTAL_LookupControllerBase.getPicklistValuesFromQueryInfoMap(queryInfoMap, searchText, maxItems);
            Test.stopTest();
        }
    }


    static testMethod void testGetAllLookupOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerBaseTestClass().testGetAllLookupOptions();
    }

    static testMethod void testGetAllLookupOptionsAlternative() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerBaseTestClass().testGetAllLookupOptionsAlternative();
    }

    static testMethod void testGetLookupOptions() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerBaseTestClass().testGetLookupOptions();
    }

    static testMethod void testGetPicklistValuesFromQueryInfoMap() {
        PORTAL_TestClassFactory.getTestClassFactory().getLookupControllerBaseTestClass().testGetPicklistValuesFromQueryInfoMap();
    }
}