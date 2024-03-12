public inherited sharing virtual class PORTAL_ControllerFactory{

    public virtual Object getGivingHistoryBaseController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_MyGivingHistoryControllerBase')});
    }

    public virtual Object getMyInformationController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_MyInformationControllerBase')});
    }

    public virtual Object getStaticContentController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_StaticContentControllerBase')});
    }

    public virtual Object getEventRegistrationController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_EventRegistrationControllerBase')});
    }

    public virtual Object getGivingSocietiesController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_GivingSocietiesControllerBase')});
    }

    public virtual Object getFYContributionBatchController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_BATCH_PopulateFYContributionBase')});
    }

    public virtual Object getLookupController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_LookupControllerBase')});
    }

    public virtual Object getOnlineGivingController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_OnlineGivingControllerBase')});
    }

    public virtual Object getListingController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ListingControllerBase')});
    }

    public virtual Object getEventManagementController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_EventManagementControllerBase')});
    }

    public virtual Object getCommunityUserController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_CommunityUserControllerBase')});
    }

    public virtual Object getHonorRollController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_HonorRollControllerBase')});
    }

    public virtual Object getAddressGeocodingBatchBase() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_AddressGeocodingBatchBase')});
    }

    public virtual Object getZoneSearchControllerBase() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ZoneSearchControllerBase')});
    }

    public virtual Object getShoppingCartController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ShoppingCartControllerBase')});
    }

    public virtual Object getContentSubmissionController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ContentSubmissionControllerBase')});
    }

    public virtual Object getPaymentHubController(String paymentMethod) {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_PaymentHubControllerBase')});
    }

    public virtual Object getPaymentHubV2Controller() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_PaymentHubV2ControllerBase')});
    }

    public virtual Object getEventWaitlistController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_EventWaitlistControllerBase')});
    }

    public virtual Object getJobBoardController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_JobBoardControllerBase')});
    }

    public virtual Object getMembershipController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_MembershipControllerBase')});
    }

    public virtual Object getActionOnContentController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ActionOnContentBase')});
    }

    public virtual Object getVolunteerController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_VolunteerControllerBase')});
    }

    public virtual Object getNewsletterController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_NewsletterControllerBase')});
    }

    public virtual Object getDirectoryController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_DirectoryControllerBase')});
    }

    public virtual Object getErrorEmailHandler() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ErrorEmailHandler')});
    }

    public virtual Object getBatchAddZoneMembershipsBase() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_BATCH_AddZoneMembershipsBase')});
    }

    public virtual Object getZoneMembershipTableController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ZoneMembershipTableControllerBase')});
    }

    public virtual Object getZoneControllerBase() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_ZoneControllerBase')});
    }

    public virtual Object getDoubleTheDonationController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_DoubleTheDonationController')});
    }
    
    public virtual Object getAddressServiceHubController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_AddressServiceHubControllerBase')});
    }

    public virtual Object getDMLCommandEventBase() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_DMLCommandEventBase')});
    }

    public virtual Object getRecaptchaController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_RecaptchaController')});
    }

    public virtual Object getTouchNetController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_TouchNetControllerBase')});
    }

    public virtual Object getMyInformationv2EditController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_MyInformationEditControllerBase')});
    }
    
    public virtual Object getMyInformationv2ViewController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_MyInformationViewControllerBase')});
    }
    
    public virtual Object getSmartyStreetAddressService() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_SmartyStreetsAddressService')});
    }

    public virtual Object getFileDownloadController() {
        return PORTAL_Utils.getHandlerClassDefinition(new Map<String, Object>{PORTAL_Utils.CLASS_TYPE => Type.forName('PORTAL_FileDownloadControllerBase')});
    }
}