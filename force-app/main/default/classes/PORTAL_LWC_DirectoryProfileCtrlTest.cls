@isTest
public class PORTAL_LWC_DirectoryProfileCtrlTest {
    public virtual class TestClass extends PORTAL_TestClassBase {
        public virtual void testGetContactInfo() {
            Map<String, Object> params = new Map<String, Object>();
            params.put('contactIds', 'Test Id');
	
            Test.startTest();

            try {
                Map<String, Object> result = PORTAL_LWC_DirectoryProfileController.SERVER_getContactInfo(params);
                System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testSendMessageToContact() {
            Map<String, Object> params = new Map<String, Object>();
            params.put('receiverContactId', 'Test Id');
            params.put('subject', 'Test Subject');
            params.put('body', 'Test Body');
	
            Test.startTest();

            try {
                PORTAL_LWC_DirectoryProfileController.SERVER_sendMessageToContact(params);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }
    }


    static testMethod void testGetContactInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcDirectoryProfileCtrlTestClass().testGetContactInfo();
    }

    static testMethod void testSendMessageToContact() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcDirectoryProfileCtrlTestClass().testSendMessageToContact();
    }
}