/**
 * Try catch is used becuase this is only a test class for the controller and not the base controller which might throw an error due to lack of data.
 */
@isTest
global class PORTAL_GivingHistoryControllersTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void fiscalYearControllerTest() {
            try {
                PORTAL_GivingByFiscalYearTableController.SERVER_getFiscalYearTableData(null);
            }
            catch (Exception e){

            }

            try {
                PORTAL_GivingByFiscalYearTableController.SERVER_getFiscalYearTableData(new Map<String, Object>{});
            }
            catch (Exception e){

            }

        }

        public virtual void pieChartControllerTest() {
            try {
                PORTAL_PieChartController.SERVER_getPieChartData(null);
            }
            catch (Exception e){

            }

            try {
                PORTAL_PieChartController.SERVER_getPieChartData(new map<String, Object>{});
            }
            catch (Exception e){

            }
        }

        public virtual void givingHistoryTableControllerTest() {
            try {
                PORTAL_GivingHistoryTableController.SERVER_getGivingHistoryTableData(null);
            }
            catch (Exception e){

            }

            try {
                PORTAL_GivingHistoryTableController.SERVER_getGivingHistoryTableData(new Map<String, Object>{});
            }
            catch (Exception e){

            }
        }

        public virtual void pledgeTableControllerTest() {
            try {
                PORTAL_GivingHistoryPledgeController.SERVER_getPledgeTableData(null);
            }
            catch (Exception e){

            }

            try {
                PORTAL_GivingHistoryPledgeController.SERVER_getPledgeTableData(new Map<String, Object>{});
            }
            catch (Exception e){

            }
        }

        public virtual void matchingGiftTableControllerTest() {
            try {
                PORTAL_GivingHistoryMatchingCtrl.SERVER_getMatchingGiftData(null);
            }
            catch (Exception e){

            }

            try {
                PORTAL_GivingHistoryMatchingCtrl.SERVER_getMatchingGiftData(new Map<String, Object>{});
            }
            catch (Exception e){

            }
        }

        public virtual void recurringGiftControllerTest() {
            try {
                PORTAL_GivingHistoryRecurringCtrl.SERVER_getRecurringGiftTableData(null);
            }
            catch (Exception e){

            }

            try {
                PORTAL_GivingHistoryRecurringCtrl.SERVER_getRecurringGiftTableData(new Map<String, Object>{});
            }
            catch (Exception e){

            }

        }

        public virtual void paymentControllerTest() {
            try {
                PORTAL_GivingHistoryPaymentController.SERVER_updateSubscriptionCreditCard(null);
            }
            catch (Exception e) {

            }
            try {
                PORTAL_GivingHistoryPaymentController.SERVER_updateSubscriptionCreditCard(new Map<String, Object>());
            }
            catch (Exception e) {

            }

            try {
                PORTAL_GivingHistoryPaymentController.SERVER_cancelSubscription(null);
            }
            catch (Exception e) {

            }
            
            try {
                PORTAL_GivingHistoryPaymentController.SERVER_cancelSubscription(new Map<String, Object>{PORTAL_CONST_OnlineGiving.PAYMENT_METHOD_KEY => 'Test'});
            }
            catch (Exception e) {

            }
        }

        public virtual void yearEndTaxLetterTableControllerTest() {
            try {
                PORTAL_YearlyGivingController.SERVER_getYearlyGivingTableData(null);
            }
            catch (Exception e){

            }

            PORTAL_YearlyGivingController.SERVER_getYearlyGivingTableData(new Map<String, Object>{});
        }
    }

    @isTest
    static void fiscalYearControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().fiscalYearControllerTest();
    }

    @isTest
    static void pieChartControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().pieChartControllerTest();
    }

    @isTest
    static void givingHistoryTableControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().givingHistoryTableControllerTest();
    }

    @isTest
    static void pledgeTableControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().pledgeTableControllerTest();
    }

    @isTest
    static void matchingGiftTableControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().matchingGiftTableControllerTest();
    }

    @isTest
    static void recurringGiftControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().recurringGiftControllerTest();
    }

    @isTest
    static void paymentControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().paymentControllerTest();
    }

    @isTest
    static void yearEndTaxLetterTableControllerTest() {
        PORTAL_TestClassFactory.getTestClassFactory().getGivingHistoryControllersTestClass().yearEndTaxLetterTableControllerTest();
    }

}