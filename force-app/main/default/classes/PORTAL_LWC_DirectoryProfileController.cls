public inherited sharing class PORTAL_LWC_DirectoryProfileController {
    @AuraEnabled
    public static Map<String, Object> SERVER_getContactInfo(Map<String, Object> params){
        PORTAL_DirectoryControllerBase controller = (PORTAL_DirectoryControllerBase)PORTAL_Utils.getControllerFactory().getDirectoryController();

        return controller.getContactInfo(params);
    }

    @AuraEnabled
    public static void SERVER_sendMessageToContact(Map<String, Object> params) {
        PORTAL_DirectoryControllerBase controller = (PORTAL_DirectoryControllerBase)PORTAL_Utils.getControllerFactory().getDirectoryController();

        controller.sendMessageToContact(params);
    }
}