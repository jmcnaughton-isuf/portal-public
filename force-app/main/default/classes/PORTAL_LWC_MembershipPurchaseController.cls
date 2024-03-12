public without sharing class PORTAL_LWC_MembershipPurchaseController {
    public static final String ERROR_INIT_LOADING_MESSAGE = 'There was an loading this page. Please contact an administrator.';
    public static final String ERROR_MEMBERSHIP_LOADING_MESSAGE = 'There was an loading information for this membership. Please contact an administrator.';
    public static final String ERROR_PAYMENT_MESSAGE = 'There was an issue processing your payment. Please contact an administrator.';

    /**
     * Initializes the membership purchase page.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param membershipRecordId    The Id of the membership record to prepopulate fields with.
     * @return                      Map containing information to initialize the membership purchase page.
     * @since                       1.0
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_initializeMembershipPurchase(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            return controller.initializeMembershipPurchase(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INIT_LOADING_MESSAGE,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Get membership fields to prepopulate using Portal Page Section Settings.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param subSectionName        The main section name of the Portal Page Section Settings to use.
     * @param membershipLevelId     The Id of the membership level to query for.
     * @return                      Map of fields to prepopulate on the front end.
     * @since                       1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getMembershipFieldsToPrepopulate(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            return controller.getMembershipFieldsToPrepopulate(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MEMBERSHIP_LOADING_MESSAGE,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets all the membership benefits related to the selected membership level
     *
     * @author                               Phillip Nguyen
     * @since                                1.0
     *
     * @param membershipLevelId              Id of membership level product to query for correct junction object
     *
     * @return                               Returns list of membership benefit records
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getMembershipBenefitInformation(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            return controller.getMembershipBenefitInformation(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MEMBERSHIP_LOADING_MESSAGE,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Delegates to the Payment Hub to create a review transaction.
     *
     * @author Aaron Wong
     *
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (only used if using stripe)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The HEP id for the matching company if the org is HEP enabled
     * @param paymentId:                    The external id for the payment taken from the billing external gateway
     * @param appealCode:                   The external id of the appeal code to default to
     * @param recaptchaToken:               The recaptcha client side token for this transaction submission
     * @param membershipLevelId             membership level id
     *
     * @return                              Information regarding the review transaction created.
     * @since 1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_createReviewTransaction(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            return controller.createReviewTransaction(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipPurchaseController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_PAYMENT_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}