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
 * LWC Controller for portal_VolunteerInformation
 *
 * @author              Aaron Wong
 * @version             1.0
 * @since               1.0
 */
public inherited sharing class PORTAL_LWC_VolunteerTableController {
    private final static String ERROR_INITIALIZATION = 'There was an error getting your volunteer information. Please contact an administrator.';

    /**
     * Gets volunteer information for the logged in Constituent.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Setting to use.
     * @param mainSectionName       The main section name of the Portal Page Section Setting to use.
     * @return                      Map containing the front end layout and volunteer information.
     * @since                       1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getVolunteerRecords(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            return controller.getVolunteerRecords(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerTableController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerTableController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}