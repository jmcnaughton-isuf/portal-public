@isTest
public class PORTAL_DonorStoriesControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetDonorStoriesAlternativeException() {
            Map<String, Object> params = new Map<String, Object>{'givingSocietyName' => '', 'numOfItemsToShow' => 'Invalid'};
            try {
                PORTAL_DonorStoriesController.SERVER_getDonorStories(params);
            } catch(AuraHandledException ahe) {
                System.debug(ahe);
            }
        }
    }


    static testMethod void testGetDonorStoriesAlternativeException() {
        PORTAL_TestClassFactory.getTestClassFactory().getDonorStoriesControllerTestClass().testGetDonorStoriesAlternativeException();
    }
}