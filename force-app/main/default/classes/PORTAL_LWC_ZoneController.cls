/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
 *
 * This source code is licensed, not sold, and is subject to a written
 * license agreement.  Among other things, no portion of this source
 * code may be copied, transmitted, disclosed, displayed, distributed,
 * translated, used as the basis for a derivative work, or used, in
 * whole or in part, for any program or purpose other than its intended
 * use in compliance with the license agreement as part of UC Innovation's
 * software.  This source code and certain of the algorithms contained
 * within it are confidential trade secrets of UC Innovation, Inc.
 * and may not be used as the basis for any other
 * software, hardware, product or service.
 */

/**
 *
 * LWC Controller for all zone components excluding zone search and zone membership table
 *
 * @author              Phillip Nguyen
 * @version             1.0
 * @since               1.0
 */
public without sharing class PORTAL_LWC_ZoneController {
    private final static String ERROR_INITIALIZATION = 'There was an error getting your zone membership information. Please contact the administrator.';
    private final static String ERROR_SAVE = 'There was an error saving your zone membership information. Please contact the administrator.';

   /*
    * Return a single formatted zone membership bio detail information
    *
    * @param    zoneMembershipId                                Id of zone membership record to filter on
    * @return                                                   Map containing bio information related to the zone membership record
    * @since                                                    1.0
    */
    @AuraEnabled
    public static Map<String, Object> SERVER_getZoneBioDetailInfo(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return baseController.getZoneBioDetailInfo(params);
        } catch (AuraHandledException ahe) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ahe.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ahe.getStackTraceString()});
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }

    /**
    * Get zoneboard memebrs for a given zone
    *
    * @param    pageName                                        page name of the Portal Page Section Setting to use
    * @param    mainSectionName                                 main section name of Portal Page Section Setting to use
    * @param    zoneId                                          Zone id used to filter zone memberships
    * @param    orderBy                                         Determines the order of featured board memberships returned
    * @return                                                   Map of featured board memebrs and button links
    * @since                                                    1.0
    */
    @AuraEnabled
    public static Map<String, Object> SERVER_getZoneBoardMembers(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return baseController.getZoneBoardMembers(params);
        } catch (AuraHandledException ahe) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ahe.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ahe.getStackTraceString()});
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }


    /**
    * Get zone records name based on URL paramaters
    *
    * @param    urlParams                                       URL parameters from the community page it is on
    * @return                                                   name of the zone record
    * @since                                                    1.0
    */
    @AuraEnabled
    public static String SERVER_getZoneTitle(Map<String, String> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return baseController.getZoneTitle(params);
        } catch (AuraHandledException ahe) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ahe.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ahe.getStackTraceString()});
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }


    /**
     * Query for the zone related links static information from content page
     *
     * @param   paramMap
     *  @param      contentPage                                  Name of the content page to pull data from.
     *  @param      subPageName                                  Sub page name of the content page to pull the data from.
     *  @param      contentModule                                Name of the related content module to pull the data from.
     * @return                                                   Content module metadata for the related record.
     * @since                                                    1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getContentToDisplay(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();
            return baseController.getZoneRelatedLinks(params);
        } catch (AuraHandledException ahe) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ahe.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ahe.getStackTraceString()});
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }


    // /**
    //  * Save zone membership records that have been updated on the front end
    //  * Also process zone memberships that we want to join and handle creating cases for certain record types
    //  *
    //  * @author Phillip Nguyen
    //  * @since 1.0
    //  *
    //  * @param pageName                              The page name of the Portal Page Section Setting to use.
    //  * @param mainSectionName                       The main section name of the Portal Page Section Setting to use.
    //  * @param zoneMembershipIdsToLeave              List of zone membership ids that we want to set to inactive (leave)
    //  * @param zoneMembershipIdsToCheckboxValues     Map of zone membership ids to their new checbox values (is show on director/newsletter)
    //  * @param zoneMembershipsToAdd                  List of zone membership ids that we want to join
    //  */
    // @AuraEnabled
    // public static void SERVER_saveZoneMembershipRecords(Map<String, Object> params){
    //     try {
    //         PORTAL_CommunityUtils.throwTestException(null);

    //         PORTAL_ZoneMembershipTableControllerBase controller = PORTAL_Utils.getControllerFactory().getZoneMembershipTableController();
    //         controller.saveZoneMembershipRecords(params);
    //     } catch (AuraHandledException ahe) {
    //         PORTAL_ErrorEmailHandler errorEmailHandler = PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
    //         errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ZoneMembershipTableController.class.getName());

    //         throw ahe;
    //     } catch (Exception e) {
    //         PORTAL_ErrorEmailHandler errorEmailHandler = PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
    //         errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ZoneMembershipTableController.class.getName());

    //         throw PORTAL_CommunityUtils.createAuraHandledException(
    //                             new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
    //                                                     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SAVE,
    //                                                     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
    //     }
    // }

    // /**
    //  * Grabs information for zone membership table such as the zone display type, the zone record type, and the available zones to join
    //  *
    //  * @author Phillip Nguyen
    //  * @since  1.0
    //  *
    //  * @param  portalMembershipSettingName  Name of the portal membership setting name to query
    //  * @return                              Map that contains zone display type and zone record type, and the available zones to join
    //  */
    // @AuraEnabled(cacheable=true)
    // public static Map<String, Object> SERVER_getZoneTableInformation(Map<String, Object> params){
    //     try {
    //         PORTAL_CommunityUtils.throwTestException(null);

    //         PORTAL_ZoneMembershipTableControllerBase controller = PORTAL_Utils.getControllerFactory().getZoneMembershipTableController();
    //         return controller.getZoneTableInformation(params);
    //     } catch (AuraHandledException ahe) {
    //         PORTAL_ErrorEmailHandler errorEmailHandler = PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
    //         errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ZoneMembershipTableController.class.getName());

    //         throw ahe;
    //     } catch (Exception e) {
    //         PORTAL_ErrorEmailHandler errorEmailHandler = PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
    //         errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ZoneMembershipTableController.class.getName());

    //         throw PORTAL_CommunityUtils.createAuraHandledException(
    //                             new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
    //                                                     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
    //                                                     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
    //     }
    // }

    /**
    * method that unsubscribes a contact from all newsletters
    * we unsubcribe from everything instead of per zone to satisfy CAN-SPAM act
    *
    * @param id:                                the contact id for the person unsubscribing, prioritized over email if both available
    * @param contactEmail:                      The email address for the person unsubscribing, used if id is not available
    * @author:                                  Sam Longo
    * @since:                                   1.0
    */
    @AuraEnabled
    public static void SERVER_unsubscribeFromNewsletter(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase controller = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            controller.unsubscribeFromNewsletter(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ZoneMembershipTableController.class.getName());

            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ZoneMembershipTableController.class.getName());

            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
    * Query and return zone banner related to the specific zone from content module record
    * Look for a default one without zoneName if there isn't one
    *
    * @author              Sean Tang
    *
    * @param pageName      The page name of the content module to get.
    * @param moduleName    The module name of the content module to get.
    * @param zoneName      The zone name of the content module to get.
    * @return              Content Module Metadata in the form of a map.
    * @since:                                   1.0
    */
    @AuraEnabled
    public static Map<String, Object> SERVER_getZoneBanner(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ZoneControllerBase controller = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();

            return controller.getZoneBanner(params);
        } catch (AuraHandledException ahe) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ahe.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ahe.getStackTraceString()});
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }

}