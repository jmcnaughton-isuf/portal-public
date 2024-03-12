public inherited sharing class PORTAL_NewsletterController {
    public static final String ERROR_CONTACT_ADMIN = 'There was an issue retrieving content. Please contact an administrator.';

    @AuraEnabled
    public static Map<String, Object> SERVER_getSubmissionSetupInfo(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getSubmissionSetupInfo(params);
        } catch (AuraHandledException e) {
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
        } catch (AuraHandledException e) {
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
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static string SERVER_getPreviewNewsletterHTML(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getPreviewNewsletterHTML(params);
        } catch (AuraHandledException e) {
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
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN + e.getMessage() + e.getStackTraceString(),
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static ucinn_portal_Listing__c SERVER_getNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getNewsletter(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_countRecipients(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.countRecipients(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_scheduleNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.scheduleNewsletter(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_sendNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.sendNewsletter(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_updateNewsletterMetrics(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.updateNewsletterMetrics(params);
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static void SERVER_unscheduleNewsletter(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            controller.unscheduleNewsletter(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static Id SERVER_cloneNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.cloneNewsletter(params);
        } catch (AuraHandledException e) {
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
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }

    @AuraEnabled
    public static List<Map<String, String>> SERVER_getMergeFields(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_NewsletterControllerBase controller = (PORTAL_NewsletterControllerBase)PORTAL_Utils.getControllerFactory().getNewsletterController();
            return controller.getMergeFields(params);
        } catch (AuraHandledException e) {
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
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage() + e.getStackTraceString()});
        }
    }
}