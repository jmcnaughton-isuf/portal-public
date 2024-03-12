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
 * Giving by fiscal year lwc controller
 *
 * @author      Daniel Mardirousi
 * @version 1.0
 * @since   1.0
 */
public without sharing class PORTAL_GivingByFiscalYearTableController {


    /**
     * Retrieve and format data for the fiscal year table on the giving history page.
     *
     * @param   params                                List of parameters passed in by the calling function.
     *                                                      Boolean hideEmptyRows: hide/show empty rows of giving.
     *                                                      String fiscalyearOrder: Order in which the fiscal year rows display on the table.
     * @return                                          Formatted records and its associated permission map.
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getFiscalYearTableData(Map<String, Object> params) {

        Map<String, Object> returnMap = new Map<String, Object>();

        try {
            PORTAL_MyGivingHistoryControllerBase baseController = (PORTAL_MyGivingHistoryControllerBase)PORTAL_Utils.getControllerFactory().getGivingHistoryBaseController();

            returnMap = baseController.getFiscalYearTableData(params);

        }
        catch (PORTAL_MyGivingHistoryControllerBase.GivingHistoryException e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                                                                                                    PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was an error, please contact system adminstration.',
                                                                                                    PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }

        return returnMap;

    }

}