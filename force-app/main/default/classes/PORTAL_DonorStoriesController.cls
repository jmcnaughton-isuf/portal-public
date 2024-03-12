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
 * Controller class for the donor stories component.
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global without sharing class PORTAL_DonorStoriesController {
    @TestVisible private static Boolean throwError = false;

    /**
     * Query information realted to the donor stories component.
     *
     * @param                   paramMap
     *                              numOfItemsToShow                        Number of items to display.
     *                              givingSocietyName                       Name of the giving society to pull donor stories from.
     *                              givingSocietyDetailPageURL              Relative URL for the giving societies detail page.
     * @return                  returnMap
     *                              RECORDS_TO_RETURN_KEY                   giving socitiy record to display.
     *                              PERMISSION_MAP_KEY                      Portal page sectiion setting permisison map.
     * @version         1.0
     * @since           1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getDonorStories(Map<String, Object> paramMap){
        Map<String, Object> returnMap = new Map<String, Object>();

        try{
            PORTAL_GivingSocietiesControllerBase baseController = (PORTAL_GivingSocietiesControllerBase)PORTAL_Utils.getControllerFactory().getGivingSocietiesController();

            if (Test.isRunningTest() && throwError == true) {
                throw new AuraHandledException('test');
            }

            return returnMap = baseController.getDonorStories(paramMap);
        }
        catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE, PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }
}