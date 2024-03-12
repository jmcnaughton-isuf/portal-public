@isTest
public class PORTAL_SObjectInfoPoolTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public virtual void testSObjectInfoPool() {
            PORTAL_SObjectInfoPool infoPool = PORTAL_SObjectInfoPool.getInstance();

            infoPool.getSObjectType('Contact');
        }
    }
    static testMethod void testSObjectInfoPool() {
        PORTAL_TestClassFactory.getTestClassFactory().getSObjectInfoPoolTestClass().testSObjectInfoPool();
    }

}