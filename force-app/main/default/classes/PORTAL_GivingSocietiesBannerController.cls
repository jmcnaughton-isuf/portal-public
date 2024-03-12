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
 * Banner to thank constituent for being a member of a giving society.
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global without sharing class PORTAL_GivingSocietiesBannerController {
    @TestVisible private static Boolean throwError = false;
    /**
     * Determine if constituent is in any (or if on a detail page a specific) giving society.
     *
     * @param                   paramMap
     *                              givingSocietyName               Name of the giving society to search. If null will search all giving socities.
     *                              bannerText                              Default banner text.
     * @return                  returnMap
     *                              RETURN_VALUE                    Boolean if constituent is in the giving society or not.
     *                              PERMISSION_MAP_KEY              Portal page section permission map.
     * @version         1.0
     * @since           1.0
     */
    @AuraEnabled
    global static Map<String, Object> SERVER_isConstituentInGivingSocieties(Map<String, Object> paramMap){
        try {
            PORTAL_GivingSocietiesControllerBase baseController = (PORTAL_GivingSocietiesControllerBase)PORTAL_Utils.getControllerFactory().getGivingSocietiesController();

            if (Test.isRunningTest() && throwError == true) {
                throw new AuraHandledException('test');
            }

            return baseController.checkIfInGivingSociety(paramMap);
        }
        catch (PORTAL_GivingSocietiesControllerBase.GivingSocietiesException e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null, PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => e.getMessage(), PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                                                                                                    PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                                                                                                    PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }

    }
}