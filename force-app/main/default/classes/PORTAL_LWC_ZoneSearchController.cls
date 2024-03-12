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
 * LWC controller for zone search.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
global inherited sharing class PORTAL_LWC_ZoneSearchController {
    public static final String GEOLOCATION_REQUEST_ERROR = 'There was an error with your geolocation request. Please contact an administrator';

    /**
    * Init function for the zone search component. Grabs zones and list of searchable countries for zones.
    *
    * @param    params                      Parameters provided by lightning web component used to search for zones.
    * @return                               Map containing list of zones and a list of searchable countries found on the zone records.
    * @since                                1.0
    */
    @AuraEnabled
    global static Map<String, Object> SERVER_initZoneSearch(Map<String,Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);

            PORTAL_ZoneSearchControllerBase baseController = (PORTAL_ZoneSearchControllerBase)PORTAL_Utils.getControllerFactory().getZoneSearchControllerBase();
            return baseController.initZoneSearch(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ZoneSearchController.class.getName());

            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }

    /**
    * Query zones by either text or geolocation search.
    *
    * @param    params                      Parameters provided by lightning web component used to search for zones.
    * @since                                1.0
    */
    @AuraEnabled
    global static Map<String, Object> SERVER_getZoneRecords(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);

            PORTAL_ZoneSearchControllerBase baseController = (PORTAL_ZoneSearchControllerBase)PORTAL_Utils.getControllerFactory().getZoneSearchControllerBase();
            return baseController.getZoneRecords(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ZoneSearchController.class.getName());

            throw ahe;
        } catch (PORTAL_ArcGisApi.ArcGisException ae) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GEOLOCATION_REQUEST_ERROR}
            );
        } catch (PORTAL_GoogleGeocodingApi.GoogleGeocodingException ge) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => GEOLOCATION_REQUEST_ERROR}
            );
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledExceptionString(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => null,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => PORTAL_MyGivingHistoryControllerBase.GENERIC_ERROR_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()}
            );
        }
    }
}