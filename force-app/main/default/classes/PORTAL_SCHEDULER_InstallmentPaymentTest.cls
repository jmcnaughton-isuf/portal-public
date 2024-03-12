@isTest
public class PORTAL_SCHEDULER_InstallmentPaymentTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testSchedule() {
            Test.startTest();

            try {
                PORTAL_SCHEDULER_InstallmentPayment scheduler = new PORTAL_SCHEDULER_InstallmentPayment();
                scheduler.execute(null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testSchedule() {
        PORTAL_TestClassFactory.getTestClassFactory().getSchedulerInstallmentPaymentTestClass().testSchedule();
    }
}