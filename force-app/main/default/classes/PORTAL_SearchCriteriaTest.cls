@isTest
public class PORTAL_SearchCriteriaTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testConstructor() {
            PORTAL_SearchCriteria controller = new PORTAL_SearchCriteria('Test');
            Map<Object, Object> objectMap = new Map<Object, Object>{'addressList' => new List<Object>{new Map<Object, Object>()},
                                                                    'searchForSelected' => ''};

            Test.startTest();

            controller.addressList = new List<PORTAL_AddressWrapper>();
            List<Object> verifyContent = controller.addressList;

            System.assert(verifyContent.isEmpty());

            Object objectRecord = null;

            PORTAL_SearchCriteria emptyController = new PORTAL_SearchCriteria(objectRecord);

            PORTAL_SearchCriteria objectController = new PORTAL_SearchCriteria(objectMap);

            Test.stopTest();
        }
    }


    static testMethod void testConstructor() {
        PORTAL_TestClassFactory.getTestClassFactory().getSearchCriteriaTestClass().testConstructor();
    }
}