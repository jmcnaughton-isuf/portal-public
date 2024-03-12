@isTest
public class PORTAL_SCHEDULER_MLRecommendationEngTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testSchedule() {
            Test.startTest();

            try {
                PORTAL_SCHEDULER_MLRecommendationEngine scheduler = new PORTAL_SCHEDULER_MLRecommendationEngine();
                scheduler.execute(null);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testSchedule() {
        PORTAL_TestClassFactory.getTestClassFactory().getSchedulerMLRecommendationEngTestClass().testSchedule();
    }
}