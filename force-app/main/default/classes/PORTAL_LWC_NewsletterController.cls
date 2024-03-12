public with sharing class PORTAL_LWC_NewsletterController {
    public final static string ERROR_CONTACT_ADMIN = 'Could not process the action. Please contact an administrator.';
    public final static String ERROR_SUBMIT_NEWSLETTER = 'Failed to submit your newsletter. Please contact an administrator.';
    @AuraEnabled
    public static Map<String, Object> SERVER_getSubmissionSetupInfo(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getSubmissionSetupInfo(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static List<ucinn_portal_Newsletter_Section__c> SERVER_getNewsletterSectionTemplates(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getNewsletterSectionTemplates(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static List<ucinn_portal_Listing__c> SERVER_searchForListings(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.searchForListings(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static string SERVER_getPreviewNewsletterHtml(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getPreviewNewsletterHtml(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_submitNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.submitNewsletter(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SUBMIT_NEWSLETTER,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static ucinn_portal_Listing__c SERVER_getFrontendNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getFrontendNewsletter(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static Map<String, Object> SERVER_getMyNewsletters(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getMyNewsletters(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_sendTestNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.sendTestNewsletter(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static String SERVER_getPortalZoneForListing(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getPortalZoneForListing(params);
        } catch(AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }
}