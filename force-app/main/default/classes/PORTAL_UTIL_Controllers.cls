public without sharing class PORTAL_UTIL_Controllers {
    public static PORTAL_MyGivingHistoryControllerBase getGivingHistoryBaseController() {
        return (PORTAL_MyGivingHistoryControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_MyGivingHistoryControllerBase.Class});
    }

    public static PORTAL_MyInformationControllerBase getMyInformationController() {
        return (PORTAL_MyInformationControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_MyInformationControllerBase.Class});
    }

    public static PORTAL_StaticContentControllerBase getStaticContentController() {
        return (PORTAL_StaticContentControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_StaticContentControllerBase.Class});
    }

    public static PORTAL_EventRegistrationControllerBase getEventRegistrationController() {
        return (PORTAL_EventRegistrationControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_EventRegistrationControllerBase.Class});
    }

    public static PORTAL_GivingSocietiesControllerBase getGivingSocietiesController() {
        return (PORTAL_GivingSocietiesControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_GivingSocietiesControllerBase.Class});
    }

    public static PORTAL_BATCH_PopulateFYContributionBase getFYContributionBatchController() {
        return (PORTAL_BATCH_PopulateFYContributionBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_BATCH_PopulateFYContributionBase.Class});
    }

    public static PORTAL_LookupControllerBase getLookupController() {
        return (PORTAL_LookupControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_LookupControllerBase.Class});
    }

    public static PORTAL_OnlineGivingControllerBase getOnlineGivingController() {
        return (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_OnlineGivingControllerBase.Class});
    }

    public static PORTAL_ListingControllerBase getListingController() {
        return (PORTAL_ListingControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_ListingControllerBase.Class});
    }

    public static PORTAL_EventManagementControllerBase getEventManagementController() {
        return (PORTAL_EventManagementControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_EventManagementControllerBase.Class});
    }

    public static PORTAL_CommunityUserControllerBase getCommunityUserController() {
        return (PORTAL_CommunityUserControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_CommunityUserControllerBase.Class});
    }

    public static PORTAL_DirectoryControllerBase getDirectoryController() {
        return new PORTAL_DirectoryControllerBase();
    }

    public static PORTAL_HonorRollControllerBase getHonorRollController() {
        return (PORTAL_HonorRollControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_HonorRollControllerBase.Class});
    }

    public static PORTAL_AddressGeocodingBatchBase getAddressGeocodingBatchBase() {
        return (PORTAL_AddressGeocodingBatchBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_AddressGeocodingBatchBase.Class});
    }

    public static PORTAL_ZoneControllerBase getZoneControllerBase() {
        return (PORTAL_ZoneControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_ZoneControllerBase.Class});
    }

    public static PORTAL_ShoppingCartControllerBase getShoppingCartController() {
        return (PORTAL_ShoppingCartControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_ShoppingCartControllerBase.Class});
    }

    public static PORTAL_ContentSubmissionControllerBase getContentSubmissionController() {
        return (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_ContentSubmissionControllerBase.Class});
    }

    public static PORTAL_PaymentHubControllerBase getPaymentHubController(String paymentMethod) {
        //TODO: Aaron will factory this

        return new PORTAL_PaymentHubControllerBase(paymentMethod);
    }

    public static PORTAL_EventWaitlistControllerBase getEventWaitlistController() {
        return (PORTAL_EventWaitlistControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_EventWaitlistControllerBase.Class});
    }

    public static PORTAL_JobBoardControllerBase getJobBoardController() {
        return (PORTAL_JobBoardControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_JobBoardControllerBase.Class});
    }

    public static PORTAL_MembershipControllerBase getMembershipController() {
        return (PORTAL_MembershipControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_MembershipControllerBase.Class});
    }

    public static PORTAL_ActionOnContentBase getActionOnContentController() {
        return (PORTAL_ActionOnContentBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                        PORTAL_Utils.CLASS_TYPE => PORTAL_ActionOnContentBase.Class});
    }

    public static PORTAL_VolunteerControllerBase getVolunteerController() {
        return (PORTAL_VolunteerControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
            PORTAL_Utils.CLASS_TYPE => PORTAL_VolunteerControllerBase.Class});
    }

    public static PORTAL_NewsletterControllerBase getNewsletterController() {
        return (PORTAL_NewsletterControllerBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                            PORTAL_Utils.CLASS_TYPE => PORTAL_NewsletterControllerBase.Class});
    }

    public static PORTAL_BATCH_AddZoneMembershipsBase getBatchAddZoneMembershipsBase() {
        return (PORTAL_BATCH_AddZoneMembershipsBase)PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{
                    PORTAL_Utils.CLASS_TYPE => PORTAL_BATCH_AddZoneMembershipsBase.Class});
    }
}