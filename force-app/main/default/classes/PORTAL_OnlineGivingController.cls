public without sharing class PORTAL_OnlineGivingController {

    public static final String ERROR_CONTACT_ADMIN = 'There was an issue retrieving content. Please contact an administrator.';

    /**
     * method that queries the picklist values for online giving fields. The field can be frequency or
     * tribute type currently
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param field:                the api name of the field we are trying to get
     * @param sObjectType:          the api name of the sobject 
     * 
     * @return                      the map of sobject to field to list of picklist values
     */
    @AuraEnabled
    public static Map<String,Map<String, List<Map<String, String>>>> SERVER_getPicklists(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getPicklists(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(),
                                                                                            PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

   /**
     * method that queries for the designation data that the online giving page should
     * show by default
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param designations:         comma separated string of ids for the feature designations we want to show
     * @param pageName:             the page name of the portal page section setting custom metadata that we want to use to filter the query
     * 
     * @return                      list of designation data for featured designations
     */
    
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getFeaturedDesignations(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getFeaturedDesignations(params);
            
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(),
                                                                                            PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * method that queries for the all designations a user can choose from
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param pageName:             the page name of the custom metadata that we want to use to filter the query
     * 
     * @return                      list of designations that can be chosen
     */

    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getAllDesignations(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getAllDesignations(params);
            
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(),
                                                                                            PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * method that queries for the all designations a user can choose from that are grouped by
     * a specific field chosen by the university (i.e grouping designations by academic organizations)
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param pageName:             the page name of the custom metadata that we want to use to filter the query
     * 
     * @return                      list of designations that are grouped by categories
     */

    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getDesignationsByCategory(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getDesignationsByCategory(params);
            
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(),
                                                                                            PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * Gets designation records with a specific key word.
     *
     * @author Sam Longo
     * 
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param keyword                   Keyword to search for.
     * @param offset                    The query offset for pagination purposes
     * @return                          List of designations.
     * @since                           1.0
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_searchDesignations(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            
            return controller.searchDesignations(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }

    
    /**
     * Gets designation records with specified designation parent Id
     *
     * @author Sam Longo
     * 
     * @param pageName                  Page name of the Portal Page Section Setting to use.
     * @param parentId                  designation parent Id to find child records of. null for getting top level designations
     * @return                          List of designations.
     * @since                           1.0
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getDesignationsByParentId(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            
            return controller.getDesignationsByParentId(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e);
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String,Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => '' + e.getMessage() + e.getStackTraceString()});
            //throw PORTAL_CommunityUtils.createAuraHandledException(
            //                    new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //                                            PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
            //                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * method that queries for custom form fields that should show on the the online
     * giving page and wraps them in a wrapper to show on the front end
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param contentPageName:      the name of the content page that corresponds to this online giving page
     * @param contentModuleName:    the name of the content module that holds the custom form fields
     * 
     * @return                      list of custom form field wrappers
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getCustomFields(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getCustomFields(params);
            
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(),
                                                                                            PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

     /**
     * method that queries for the logged in constituent's data
     * to prepopulate the billing information on the front end. also
     * gets the front end data display information
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @param   pageName            Page Name of Page Section Setting
     * @param   donorId             Donor Id of Constituent (passed in from url param)
     * @param   passcode            Passcode to match to Constituent (passed in from url param)
     * 
     * @return                      the map of data need to show things on the front end
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getConstituentInformation(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getConstituentInformation(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error retrieving your user information.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * method creates the review transaction for the constituent's gift
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param giftType:                     The type of gift the user is giving
     * @param numberOfInstallments:         The number of installments if the user is making a pledge
     * @param startDate:                    The day to start payments if it is a recurring gift or pledge
     * @param endDate:                      Optional: the last day for a payment if it is a recurring gift
     * @param frequency:                    The frequency of the payments if it is a recurring gift or pledge
     * @param tributeInformation:           A map of data that will be used to create the tribute if there is one
     * @param isGivingAsOrg                 Boolean that specifies whether the user is making an organizational gift
     * @param billingInformation:           A map of data that contains the billing information
     * @param designations:                 List that contains the designation information such as id and amount
     * @param stripeBillingInformation:     A map of data that contains stripe formatted billing information (only used if using stripe)
     * @param giftAmount:                   The total amount for the gift
     * @param matchingCompanyName:          Name of matching company if there is one
     * @param matchingCompanyId:            The HEP id for the matching company if the org is HEP enabled
     * @param paymentId:                    The external id for the payment taken from the billing external gateway
     * @param pageName:                     The page name for the custom metadata records
     * @param paymentMethod:                The name of the external gateway we are using
     * @param appealCode:                   The external id of the appeal code to default to
     * @param emailTemplateName:            Developer name of the email template used to send the receipt
     * @param recaptchaToken:               The recaptcha client side token for this transaction submission
     * @param controllerVersion             Version of the Payment Hub Controller
     * @param isCreatePledgeSubscription    Boolean: create a subscription for a pledge
     * @param hasAddressAutocomplete        Boolean: Is Address Autocomplete Enabled
     * 
     * @return                              the map of data that shows on the receipt page
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_createReviewTransaction(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            controller.paymentMethod = (String)params.get('paymentMethod');

            return controller.SERVER_createReviewTransaction(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error processing your gift', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStacktraceString(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }

    }


    /**
     * method that returns the community url for communication between the lwc and visualforce page
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * @return                      Community url
     */
    @AuraEnabled
    public static string SERVER_getOrigin(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getOrigin(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error retrieving origin site', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * method that returns the external public api key
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * 
     * 
     * @param paymentMethod:                The name of the external gateway we are using
     * 
     * 
     * @return                  the public api key
     */
    @AuraEnabled
    public static string SERVER_getAPIKey(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            controller.paymentMethod = (String)params.get('paymentMethod');
            return controller.SERVER_getAPIKey(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error retrieving the payment information.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * method that gets the pledge payment information for one or more pledges. if no pledges are
     * found then an empty list is returned.
     * 
     * 
     * @author: Ashley Tran
     * @since: 1.0
     * @param pledgeId          A pledge Id provided by the user (if user is a guest).
     * @param pageName          The page name for the custom metadata records 
     * 
     * @return                  the list of pledge information maps
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getPledgeData(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.SERVER_getPledgeData(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error retrieving the pledge information.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * Gets online giving base url from Portal Org Setting CMT
     * 
     * @author  Phillip Nguyen
     * @since: 1.1
     * 
     * @return  Value from Portal Org Setting CMT which should be the Base URL for the Give Page
     */
    @AuraEnabled(cacheable=true)
    public static String SERVER_getOnlineGivingBaseURL(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.getOnlineGivingBaseURL(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error retrieving the pledge information.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }
    
    /**
     * Generates a link to the give page using base url that can be modified on front end.
     * Appends the donor Id & page encryption (SHA-256 encryption on current date time with 30 random nums appended)
     * Takes in and returns a map so admins can use the function if they want to process multiple constituents
     * 
     * @author  Phillip Nguyen
     * @since: 1.1
     * 
     * @param   contactId   Contact Id(s) in the form of a list that we need to generate a giving link
     * @param   givingUrl   Giving Page Url passed in from the front end
     * 
     * @return  Map of Contact Ids To Generated URLS
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_generateOnlineGivingLink(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.generateOnlineGivingLink(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error retrieving the pledge information.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * Make the callout to DTD to register the donation info and insert an organization interim for the matching company
     * 
     * @author Jacob Huang
     * @since 1.2
     * 
     * @param externalDonationIdentifier    String: ID to use for the Double the Donation record
     * @param matchingCompanyIntegration    String: Matching company integration, e.g. Double The Donation
     * @param matchingCompanyId             String: ID used by DTD to identify the company 
     * @param amount                        String: Gift amount
     * @param dtdBillingInformation         Map<String, Object>: Billing info map with the fields needed for the DTD callout
     * @param isGivingAsOrg                 Boolean: Indicates if user is giving as org
     * @param appealCode                    String: appeal code to use for the gift, nullable
     * @param pageSectionName               String: Page section setting name for getting the default appeal code
     * 
     * @return Double the Donation identifier
     */
    @AuraEnabled
    public static String SERVER_createDTDDonationAndInterim(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.createDTDDonationAndInterim(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error during the payment process. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }

    /**
     * Get the giving form record for the page
     * 
     * @author Todd Shinto
     * @since 1.13
     * 
     * @param givingFormName The name of the giving form record
     * @param pageUrl        The page URL to use to filter the giving form records
     * @param urlParamValue  The url param value to filter for a specific giving form record
     * 
     * @return A map of configuration data for the contextual giving form
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getContextualGivingFormData(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_OnlineGivingControllerBase controller = (PORTAL_OnlineGivingControllerBase)PORTAL_Utils.getControllerFactory().getOnlineGivingController();
            return controller.getContextualGivingFormData(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw  PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage(), PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME});
        }
    }
}