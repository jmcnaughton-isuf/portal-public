/*
 * Copyright (c) 2024, UC Innovation, Inc.  All Rights Reserved.
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
 * Controller for portal file downloads
 *
 * @author Jacob Huang
 * @since 1.19
 */
public without sharing class PORTAL_LWC_FileDownloadController {
    public static final String ERROR_MESSAGE = 'There was an error on this page. Please contact an administrator.';

    /**
     * Get the list of files available for the current portal user to download.
     *
     * @author Jacob Huang
     * @since 1.19
     *
     * @param componentName     String: Downloadable Content record component name to use 
     *
     * @return Map with records key, the list of {file name => download url}
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getFilesForDownload(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_FileDownloadControllerBase controller = (PORTAL_FileDownloadControllerBase)PORTAL_Utils.getControllerFactory().getFileDownloadController();
            return controller.getFilesForDownload(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_FileDownloadController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_FileDownloadController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }
}