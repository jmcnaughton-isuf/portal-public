@isTest
public class PORTAL_SCHEDULER_InterimEmploymentTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testSchedule() {
            Test.startTest();

            try {
                PORTAL_SCHEDULER_InterimEmployment scheduler = new PORTAL_SCHEDULER_InterimEmployment();
                scheduler.execute(null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testSchedule() {
        PORTAL_TestClassFactory.getTestClassFactory().getSchedulerInterimEmploymentTestClass().testSchedule();
    }
}