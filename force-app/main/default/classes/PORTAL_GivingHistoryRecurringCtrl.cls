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
 * Controller in charge of the recurring gift table
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
public without sharing class PORTAL_GivingHistoryRecurringCtrl {

    /**
     * Retrieve and format data for the Recurring gift table component.
     *
     * @param   params                                  List of parameters passed in by the calling function.
     *                                                      Integer itemsPerPage: Max number of rows to show per page.
     *                                                      Integer offset: Offset used for pagination query.
     *                                                      Boolean showUpdateCreditCard: indicates whether to make callouts for credit card last 4 digits or not
     *                                                      String paymentMethod: payment processor used (Stripe, Spreedly, Cybersource)
     * 
     * @return                                          Formatted records and its associated permission map.
     * @since                                           1.0
     * @version                                         1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getRecurringGiftTableData(Map<String, Object> params){
        Map<String, Object> returnMap = new Map<String, Object>();

        try {
            PORTAL_MyGivingHistoryControllerBase baseController = (PORTAL_MyGivingHistoryControllerBase)PORTAL_Utils.getControllerFactory().getGivingHistoryBaseController();

            returnMap = baseController.getRecurringGiftTableData(params);
        }
        catch (PORTAL_MyGivingHistoryControllerBase.GivingHistoryException e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME, 
                                                                                                    PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage(), 
                                                                                                    PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                                                                    PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                                                                                                    PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }

        return returnMap;
    }
}