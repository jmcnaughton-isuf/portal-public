/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
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
 * LWC Controller for portal_MembershipTable
 *
 * @author              Phillip Nguyen
 * @version             1.0
 * @since               1.0
 */
public without sharing class PORTAL_LWC_MembershipController {
    public static final String ERROR_GENERAL_MESSAGE = 'There was an error retrieving the information. Please contact an administrator';
    public static final String ERROR_SAVE_MESSAGE = 'There was an error saving your information. Please contact an administrator';

    /**
     * Gets Membership Records for Membership Table
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param pageName          Page Name of Page Section Setting
     * @param mainSectionName   Main Section Name of Page Section Setting
     * @param subSectionName    Sub Section Name of Page Section Setting
     *
     * @return                  Returns front end data map & membership records
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getMembershipRecords(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            return controller.getMembershipRecords(params);

        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets Current Logged In User's Contact Membership Information
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @return                  Returns user contact's membership renewal solicitation boolean value
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getMembershipContactInformation(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            return controller.getMembershipContactInformation(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Updates membership management related options
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param membershipsToUpdate                         Map of membership Id to Boolean value
     * @param globalMembershipRenewalSolicitOptOutValue   Boolean value for membership renenwal solicitation field on contact
     *
     */
    @AuraEnabled
    public static void SERVER_saveMembershipRecords(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MembershipControllerBase controller = (PORTAL_MembershipControllerBase)PORTAL_Utils.getControllerFactory().getMembershipController();

            controller.saveMembershipRecords(params);

        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MembershipController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MembershipController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SAVE_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}