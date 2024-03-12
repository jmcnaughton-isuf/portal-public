@isTest
public class PORTAL_BATCH_InitializeDirCacheTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testBatch() {
            PORTAL_BATCH_InitializeDirectoryCaches initializer = new PORTAL_BATCH_InitializeDirectoryCaches('Contact');
            List<sObject> params = new List<sObject>();

            Test.startTest();

            try {
                Database.QueryLocator result = initializer.start(null);
                System.assertNotEquals(null, result);

                initializer.execute(null, params);
                initializer.finish(null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    static testMethod void testBatch() {
        PORTAL_TestClassFactory.getTestClassFactory().getBatchInitializeDirCacheTestClass().testBatch();
    }
}