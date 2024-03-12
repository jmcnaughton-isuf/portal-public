/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
 *                     http://www.ucinnovation.com
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
 *
 *
 *
 */

 /**
  * class that manages action on content records
  * @author                     Bill Lu
  * @since                      1.0
  */

public with sharing class PORTAL_ActionOnContentController {

    /**
     * Method for insert or update Action_On_Content__c for a specific User and content.
     *
     * @param userId          Id for current user.
     * @param userType        User type for current user.
     * @param thisContent     The ucinn_portal_Listing__c record used to insert or update the Action_On_Content__c record.
     * @author                Bill Lu
     * @since                 1.0
     */

    public static void upsertActionOnContent(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();
            controller.upsertActionOnContent(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem. Please contact an administrator for help.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

     /**
     * Help function for create a new ucinn_portal_Action_On_Content__c record.
     *
     * @param userId          Id for current user.
     * @param listingItem     The listing__c record used to create this Action_On_Content__c record.
     * @return                ucinn_portal_Action_On_Content__c record that is been created.
     * @author                Bill Lu
     * @since 1.0
     */

    public static ucinn_portal_Action_On_Content__c createActionOnContent(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();
            return controller.createActionOnContent(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem. Please contact an administrator for help.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

     /**
     * Method for getting recommend content for the current user.
     *
     * @param userId                        Id for current user.
     * @param userType                      User type for current user.
     * @param maxItemsInt                   Max number of items needs to be returned.
     * @param recommendationTypeList        All the recommendation type for the current user.
     * @param queryString                   String used to query the content.
     * @return                              A list of recommended content for the current user.
     * @author                              Bill Lu
     * @since                               1.0
     */

     public static List<Map<String, Object>> getRecommendedContent(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();
            return controller.getRecommendedContent(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem. Please contact an administrator for help.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Method for tracking how much time user spent on a specific content record
     *
     * @param contentId          Id for the specific content.
     * @param timeDifference     Time user spend on this content in milliseconds.
     * @author                   Bill Lu
     * @since                    1.0
     */

    @AuraEnabled
    public static void SERVER_timeTrack(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();
            controller.timeTrack(params);
         } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem. Please contact an administrator for help.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Method for tracking how much time user spent on a specific content record using the record name
     *
     * @param contentName          name of the content record
     * @param timeDifference       Time user spend on this content in milliseconds.
     * @author                     Ashley Tran
     * @since                      1.0
     */

    @AuraEnabled
    public static void SERVER_timeTrackByName(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();
            controller.timeTrackByName(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem. Please contact an administrator for help.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Method for calculating user's recommendation type based on their action on content.
     *
     * @param userId          Id for current user.
     * @author                Bill Lu
     * @since                 1.0
     */

    public static void SERVER_runRecommendationCalculation(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();
            controller.runRecommendationCalculation(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem. Please contact an administrator for help.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }
}