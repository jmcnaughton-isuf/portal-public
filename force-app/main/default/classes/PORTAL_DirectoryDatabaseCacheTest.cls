@isTest
public class PORTAL_DirectoryDatabaseCacheTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testSchedule() {
            Final String CRON_EXP = '0 0 12 * * ?';

            PORTAL_SearchCriteria criteria= new PORTAL_SearchCriteria();

            List<PORTAL_SearchCriteria> subContent = new List<PORTAL_SearchCriteria>{criteria};

            List<List<PORTAL_SearchCriteria>> content = new List<List<PORTAL_SearchCriteria>>{subContent};
            
            Map<String, List<List<PORTAL_SearchCriteria>>> params = new Map<String, List<List<PORTAL_SearchCriteria>>>();
            params.put('Contact', content);

            Test.startTest();

            try {
                System.schedule('Test schedule', CRON_EXP, new PORTAL_DirectoryDatabaseCache(params));
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }

    static testMethod void testSchedule() {
        PORTAL_TestClassFactory.getTestClassFactory().getDirectoryDatabaseCacheTestClass().testSchedule();
    }
}