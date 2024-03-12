public without sharing class PORTAL_LWC_LookupController {
    @AuraEnabled
    public static List<Object> SERVER_getLookupOptions(Map<String, Object> params) {
        PORTAL_LookupControllerBase controller = (PORTAL_LookupControllerBase)PORTAL_Utils.getControllerFactory().getLookupController();

        return controller.getAllLookupOptions(params);
    }
}