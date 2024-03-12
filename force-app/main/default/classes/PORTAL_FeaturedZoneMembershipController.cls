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
/** ----------------------------------- DEPRECATED  -----------------------------------------------------------*/


/**
 * Featured zone membership controller for lwc.
 *
 * @author      Daniel Mardirousi
 * @version 1.0
 * @since   1.0
 */
global without sharing class PORTAL_FeaturedZoneMembershipController {

    /**
     *
     * Get featured board members for a given zone
     *
     * @param    paramMap
     *   @param    zoneName                                      Zone name used to filter zone memberships
     *   @param    orderClause                                   Determines the order of featured board memberships returned
     * @return                                                   Map of featured board memebers and button links
     * @since                                                    1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getFeaturedBoardMembers(Map<String, Object> paramMap){
        try {
            PORTAL_ZoneControllerBase baseController = (PORTAL_ZoneControllerBase)PORTAL_Utils.getControllerFactory().getZoneControllerBase();
            return null;
        }
        catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }
}