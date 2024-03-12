@isTest
public with sharing class PORTAL_NewsletterControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void testCloneNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_cloneNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_cloneNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_cloneNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testCountRecipients() {
            try {
                PORTAL_NewsletterController.SERVER_countRecipients(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_countRecipients(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_countRecipients(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetMergeFields() {
            try {
                PORTAL_NewsletterController.SERVER_getMergeFields(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getMergeFields(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getMergeFields(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetMyNewsletters() {
            try {
                PORTAL_NewsletterController.SERVER_getMyNewsletters(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getMyNewsletters(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getMyNewsletters(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetPreviewNewsletterHTML() {
            try {
                PORTAL_NewsletterController.SERVER_getPreviewNewsletterHTML(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getPreviewNewsletterHTML(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getPreviewNewsletterHTML(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetNewsletterSectionTemplates() {
            try {
                PORTAL_NewsletterController.SERVER_getNewsletterSectionTemplates(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getNewsletterSectionTemplates(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getNewsletterSectionTemplates(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_getNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSearchForListings() {
            try {
                PORTAL_NewsletterController.SERVER_searchForListings(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_searchForListings(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_searchForListings(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetSubmissionSetupInfo() {
            try {
                PORTAL_NewsletterController.SERVER_getSubmissionSetupInfo(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getSubmissionSetupInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_getSubmissionSetupInfo(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testScheduleNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_scheduleNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_scheduleNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_scheduleNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSendNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_sendNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_sendNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_sendNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSendTestNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_sendTestNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_sendTestNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_sendTestNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSubmitNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_submitNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_submitNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_submitNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testUnscheduleNewsletter() {
            try {
                PORTAL_NewsletterController.SERVER_unscheduleNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_NewsletterController.SERVER_unscheduleNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_NewsletterController.SERVER_unscheduleNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }

    }

    @isTest
    public static void testCloneNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testCloneNewsletter();
    }

    @isTest
    public static void testCountRecipients() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testCountRecipients();
    }

    @isTest
    public static void testGetMergeFields() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testGetMergeFields();

    }

    @isTest
    public static void testGetMyNewsletters() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testGetMyNewsletters();
    }

    @isTest
    public static void testGetPreviewNewsletterHTML() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testGetPreviewNewsletterHTML();
    }

    @isTest
    public static void testGetNewsletterSectionTemplates() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testGetNewsletterSectionTemplates();
    }

    @isTest
    public static void testGetNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testGetNewsletter();
    }

    @isTest
    public static void testSearchForListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testSearchForListings();
    }

    @isTest
    public static void testGetSubmissionSetupInfo() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testGetSubmissionSetupInfo();
    }

    @isTest
    public static void testScheduleNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testScheduleNewsletter();
    }

    @isTest
    public static void testSendNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testSendNewsletter();
    }

    @isTest
    public static void testSendTestNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testSendTestNewsletter();
    }

    @isTest
    public static void testSubmitNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testSubmitNewsletter();
    }

    @isTest
    public static void testUnscheduleNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getNewsletterControllerTestClass().testUnscheduleNewsletter();
    }

}