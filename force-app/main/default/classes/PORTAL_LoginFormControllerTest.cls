@IsTest
public without sharing class PORTAL_LoginFormControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{
        public void isUsernamePasswordEnabled() {
            System.assertEquals(true, PORTAL_LoginFormController.getIsUsernamePasswordEnabled());
        }

        public void isSelfRegistrationEnabled() {
            System.assertEquals(false, PORTAL_LoginFormController.getIsSelfRegistrationEnabled());
        }

        public void getSelfRegistrationURL() {
            System.assertEquals(null, PORTAL_LoginFormController.getSelfRegistrationUrl());
        }

        public void getAuthConfig() {
            Auth.AuthConfiguration authConfig = PORTAL_LoginFormController.getAuthConfig();
            System.assertNotEquals(null, authConfig);
        }

        public virtual void testLogin() {
            Test.startTest();

            try {
                String result = PORTAL_LoginFormController.login('', '', '', '');
                System.assertEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testInvalidLogin() {
            Test.startTest();

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LoginFormController.login('', '', '', '');
            } catch (AuraHandledException ahe) {
                System.assert(String.isNotBlank(ahe.getMessage()));
            }

            Test.stopTest();
        }

        public virtual void testGetForgotPasswordUrl() {
            Test.startTest();

            try {
                String result = PORTAL_LoginFormController.getForgotPasswordUrl();
                System.assertEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public virtual void testSetExperienceId() {
            PORTAL_UTIL_TestClassUtil testClassUtil = new PORTAL_UTIL_TestClassUtil();
            Id profileId = [select id from profile where name=: 'ascend Customer Community User'].id;

            Account acct = new Account(name = 'Test_Account') ;
            acct = (Account)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => acct});
            insert acct;
    
            Contact con = new Contact(LastName = 'Test_Contact',
                              AccountId = acct.Id,
                              Email = 'testCommunityUserf14@test.com',
                              ucinn_portal_Is_Display_On_Portal__c = true);
            con = (Contact)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => con});
            insert con;

            User comUser = new User(alias = 'testUser',
                                    email = 'testCommunityUserf14@test.com',
                                    emailencodingkey='UTF-8',
                                    lastname = 'Batman',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = profileId,
                                    contactId = con.Id,
                                    IsActive = true,
                                    timezonesidkey='America/Los_Angeles',
                                    username = System.now().millisecond() + 'testCommunityUserf14@test.com');
            comUser = (User)testClassUtil.populateRequiredFieldsOnObject(new Map<String, Object>{PORTAL_UTIL_TestClassUtil.S_OBJECT_TO_POPULATE_KEY => comUser});
            insert comUser;

            Test.startTest();

            System.runAs(comUser) {
                try {
                    String result = PORTAL_LoginFormController.setExperienceId('');
                    System.debug(result);
                    // System.assertEquals(null, result);
                } catch (Exception e) {
                    System.debug(e);
                }
            }

            Test.stopTest();
        }

        public virtual void testSetNullExperienceId() {
            Test.startTest();

            try {
                String result = PORTAL_LoginFormController.setExperienceId(null);
                // System.assertNotEquals(null, result);
            } catch (Exception e) {
                System.debug(e);
            }

            Test.stopTest();
        }

        public void getIsRecaptchaEnabled() {
            Boolean isRecaptchaEnabledForTestClass = PORTAL_LoginFormController.getIsRecaptchaEnabled('testStringLoginFunction');
            System.assertNotEquals(true, isRecaptchaEnabledForTestClass);
        }
    }

    static testMethod void testIsUsernamePasswordEnabled() {
        Test.startTest();
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().isUsernamePasswordEnabled();
        Test.stopTest();
    }

    static testMethod void testIsSelfRegistrationEnabled() {
        Test.startTest();
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().isSelfRegistrationEnabled();
        Test.stopTest();
    }

    static testMethod void testGetSelfRegistrationURL() {
        Test.startTest();
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().getSelfRegistrationURL();
        Test.stopTest();
    }

    static testMethod void testAuthConfig() {
        Test.startTest();
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().getAuthConfig();
        Test.stopTest();
    }

    static testMethod void testLogin() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().testLogin();
    }

    static testMethod void testInvalidLogin() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().testInvalidLogin();
    }

    static testMethod void testGetForgotPasswordUrl() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().testGetForgotPasswordUrl();
    }

    static testMethod void testSetExperienceId() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().testSetExperienceId();
    }
    
    static testMethod void testSetNullExperienceId() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().testSetExperienceId();
    }

    static testMethod void testGetIsRecaptchaEnabled() {
        PORTAL_TestClassFactory.getTestClassFactory().getPortalLoginFormControllerTestClass().getIsRecaptchaEnabled();
    }
}