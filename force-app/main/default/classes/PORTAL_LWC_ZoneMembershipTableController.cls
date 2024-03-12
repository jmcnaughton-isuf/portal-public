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
 * LWC Controller for portal_ZoneMembershipTable
 *
 * @author              Phillip Nguyen
 * @version             1.0
 * @since               1.0
 */
public inherited sharing class PORTAL_LWC_ZoneMembershipTableController {
    private final static String ERROR_INITIALIZATION = 'There was an error getting your zone membership information. Please contact the administrator.';
    private final static String ERROR_SAVE = 'There was an error saving your zone membership information. Please contact the administrator.';

    /**
     * Gets zone membership records based on the portal page section settings.
     *
     * @author Phillip Nguyen
     *
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @param subSectionName        The sub section name of the Portal Page Section Setting to use.
     * @return                      Map containing the front end layout and zone membership records.
     * @since                       1.0
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getZoneMembershipRecords(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);

            PORTAL_ZoneMembershipTableControllerBase controller = (PORTAL_ZoneMembershipTableControllerBase)PORTAL_Utils.getControllerFactory().getZoneMembershipTableController();
            return controller.getZoneMembershipRecords(params);
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
     * Save zone membership records that have been updated on the front end
     * Also process zone memberships that we want to join and handle creating cases for certain record types
     *
     * @author Phillip Nguyen
     * @since 1.0
     *
     * @param pageName                              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName                       The main section name of the Portal Page Section Setting to use.
     * @param zoneMembershipIdsToLeave              List of zone membership ids that we want to set to inactive (leave)
     * @param zoneMembershipIdsToCheckboxValues     Map of zone membership ids to their new checbox values (is show on director/newsletter)
     * @param zoneMembershipsToAdd                  List of zone membership ids that we want to join
     */
    @AuraEnabled
    public static void SERVER_saveZoneMembershipRecords(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);

            PORTAL_ZoneMembershipTableControllerBase controller = (PORTAL_ZoneMembershipTableControllerBase)PORTAL_Utils.getControllerFactory().getZoneMembershipTableController();
            controller.saveZoneMembershipRecords(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ZoneMembershipTableController.class.getName());

            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ZoneMembershipTableController.class.getName());

            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SAVE,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Grabs information for zone membership table such as the zone display type, the zone record type, and the available zones to join
     *
     * @author Phillip Nguyen
     * @since  1.0
     *
     * @param  portalMembershipSettingName  Name of the portal membership setting name to query
     * @return                              Map that contains zone display type and zone record type, and the available zones to join
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getZoneTableInformation(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);

            PORTAL_ZoneMembershipTableControllerBase controller = (PORTAL_ZoneMembershipTableControllerBase)PORTAL_Utils.getControllerFactory().getZoneMembershipTableController();
            return controller.getZoneTableInformation(params);
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
}