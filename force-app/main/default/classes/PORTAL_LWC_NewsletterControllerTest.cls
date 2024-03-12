@isTest
public with sharing class PORTAL_LWC_NewsletterControllerTest {
    public virtual class TestClass extends PORTAL_TestClassBase{

        public virtual void testGetSetupInformation() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_getSubmissionSetupInfo(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getSubmissionSetupInfo(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getSubmissionSetupInfo(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetNewsletterSectionTemplates() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_getNewsletterSectionTemplates(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getNewsletterSectionTemplates(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getNewsletterSectionTemplates(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSearchForListings() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_searchForListings(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_searchForListings(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_searchForListings(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetPersonalizedHtml() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_getPreviewNewsletterHtml(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getPreviewNewsletterHtml(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getPreviewNewsletterHtml(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSubmitNewsletter() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_submitNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_submitNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_submitNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetFrontendNewsletter() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_getFrontendNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getFrontendNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getFrontendNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetMyNewsletters() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_getMyNewsletters(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getMyNewsletters(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getMyNewsletters(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testSendTestNewsletter() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_sendTestNewsletter(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_sendTestNewsletter(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_sendTestNewsletter(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }


        public virtual void testGetPortalZoneForListing() {
            try {
                PORTAL_LWC_NewsletterController.SERVER_getPortalZoneForListing(null);
            } catch (Exception e) {

            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.AURA_HANDLED_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getPortalZoneForListing(null);
            } catch (AuraHandledException ahe) {
                System.debug(ahe);
            }

            try {
                PORTAL_CommunityUtils.testExceptionType = PORTAL_CommunityUtils.NULL_POINTER_EXCEPTION;
                PORTAL_LWC_NewsletterController.SERVER_getPortalZoneForListing(null);
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }

    @isTest
    public static void testGetSetupInformation() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testGetSetupInformation();
    }

    @isTest
    public static void testGetNewsletterSectionTemplates() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testGetNewsletterSectionTemplates();
    }

    @isTest
    public static void testSearchForListings() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testSearchForListings();
    }

    @isTest
    public static void testGetPersonalizedHtml() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testGetPersonalizedHtml();
    }

    @isTest
    public static void testSubmitNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testSubmitNewsletter();

    }

    @isTest
    public static void testGetFrontendNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testGetFrontendNewsletter();
    }

    @isTest
    public static void testGetMyNewsletters() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testGetMyNewsletters();
    }

    @isTest
    public static void testSendTestNewsletter() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testSendTestNewsletter();
    }

    @isTest
    public static void testGetPortalZoneForListing() {
        PORTAL_TestClassFactory.getTestClassFactory().getLwcNewsletterControllerTestClass().testGetPortalZoneForListing();

    }

}