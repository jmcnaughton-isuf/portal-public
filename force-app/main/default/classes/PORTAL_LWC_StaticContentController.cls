/**
 * LWC controller for standard static content LWCs.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
global virtual inherited sharing class PORTAL_LWC_StaticContentController {
    public static final String ERROR_GENERAL_MESSAGE = 'There was an error retrieving the information. Please contact an administrator';

    /**
     * Gets the Content Module Metadata with the given parameters.
     *
     * @author Aaron Wong
     * @param pageName      The page name of the content module to get.
     * @param moduleName    The module name of the content module to get.
     * @param zoneName      The zone name of the content module to get.
     * @return              Content Module Metadata in the form of a map.
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getContentModuleMetadata(Map<String, Object> params) {
        PORTAL_StaticContentControllerBase controller = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();

        return controller.getContentModuleMetadata(params);
    }

    /**
     * Gets the Page CSS classes for the current content page
     *
     * @author Sean Tang
     * @param pageUrl       The pathname part of the page's URL to get the content page for.
     * 
     * @return              A content page's css classes as a string that should be applied to the current page
     * @since               1.1
     */
    @AuraEnabled(cacheable=true)
    public static String SERVER_getContentPageCSSClasses(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_StaticContentControllerBase controller = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();
    
            return controller.getContentPageCSSClasses(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}