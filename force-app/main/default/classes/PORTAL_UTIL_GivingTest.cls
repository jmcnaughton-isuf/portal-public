@isTest
public class PORTAL_UTIL_GivingTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetNumberOfPayments() {
            Integer futureYear = Date.today().year() + 1;
            System.assertEquals(null, PORTAL_UTIL_Giving.getNumberOfPayments(null, null, null));
            try {
                PORTAL_UTIL_Giving.getNumberOfPayments(Date.newInstance(futureYear, 1, 1), Date.newInstance(futureYear + 1, 1, 1), 'foo');
            }
            catch (Exception e) { }

            Date startDate = Date.newInstance(futureYear, 8, 31);
            Date endDate = Date.newInstance(futureYear, 9, 14);
            String frequency = 'Weekly';
            System.assertEquals(3, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));

            frequency = 'Bi-Weekly';
            System.assertEquals(2, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));
            frequency = 'Quad-Weekly';
            System.assertEquals(1, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));

            startDate = Date.newInstance(futureYear, 8, 31);
            endDate = Date.newInstance(futureYear + 1, 9, 30);
            frequency = 'Monthly';
            System.assertEquals(14, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));

            frequency = 'Quarterly';
            System.assertEquals(5, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));
            frequency = 'Semi-Annual';
            System.assertEquals(3, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));
            frequency = 'Annual';
            System.assertEquals(2, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));

            frequency = 'Semi-Monthly';
            startDate = Date.newInstance(futureYear, 10, 3);
            endDate = Date.newInstance(futureYear + 1, 1, 4);
            System.assertEquals(6, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));

            startDate = Date.newInstance(futureYear, 10, 16);
            endDate = Date.newInstance(futureYear + 1, 1, 16);
            System.assertEquals(6, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));

            startDate = Date.newInstance(futureYear, 10, 15);
            endDate = Date.newInstance(futureYear + 1, 1, 15);
            System.assertEquals(7, PORTAL_UTIL_Giving.getNumberOfPayments(startDate, endDate, frequency));
        }
    }

    public static testMethod void testGetNumberOfPayments() {
        PORTAL_TestClassFactory.getTestClassFactory().getUTIL_GivingTestClass().testGetNumberOfPayments();
    }
}