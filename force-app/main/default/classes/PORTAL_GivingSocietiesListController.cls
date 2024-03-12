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
 * Controller class for the giving socities list component.
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global without sharing class PORTAL_GivingSocietiesListController {

    /**
     * Query information for giving socities list component.
     *
     * @param                   paramMap
     *                              itemsPerPage                    Item per page to display.
     *                              offset                          Offset for pagination query.
     *                              givingSocietyType               The type of giving societies to display.
     *                              givingSocietyDetailURL          The relative URL for the giving societies detail page.
     *                              nameSearch                      Text name search for giving socities to display.
     * @return                  returnMap
     *                              RECORDS_TO_RETURN_KEY           Records returned to display.
     *                              PERMISSION_MAP_KEY              Portal page section permission map.
     *                              TOTAL_NUMBER_OF_RECORDS_KEY     Total number of records in the query.
     *                              PICKLIST_OPTIONS                Picklist options for giving socities type search.
     * @version         1.0
     * @since           1.0
     */
    @AuraEnabled
    global static Map<String, Object> SERVER_getGivingSocietiesList(Map<String, Object> paramMap){
        Map<String, Object> returnMap = new Map<String, Object>();

        try{
            PORTAL_GivingSocietiesControllerBase baseController = (PORTAL_GivingSocietiesControllerBase)PORTAL_Utils.getControllerFactory().getGivingSocietiesController();
            returnMap = baseController.getGivingSocietiesList(paramMap);
        }
        catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                                                                                                    PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage(),
                                                                                                    PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                                                                                                    PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                                                                                                    PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }

        return returnMap;
    }
}