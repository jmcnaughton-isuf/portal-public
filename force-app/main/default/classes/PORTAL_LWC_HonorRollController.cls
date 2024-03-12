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
 * LWC Controller for Honor Roll, connects front end to back end
 *
 * @author              Phillip Nguyen
 * @since               1.0
 */
public inherited sharing class PORTAL_LWC_HonorRollController {
    public static final String ERROR_GENERAL_MESSAGE = 'There was an error retrieving the information. Please contact an administrator';
    public static final String ERROR_SUBMIT_MESSAGE = 'There was an error submitting the information. Please contact an administrator';

    /**
     * Creates mapping for Honor Roll Name records to pass back to front end
     *
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param fiscalYear                Specific fiscal year selected to query for
     * @param nameSearchString          String of name to search for
     * @param givingSociety             Specific giving society selected to query for
     * @param classYear                 Specific class year selected to query for
     * @param academicOrganization      Specific academic organization to query for
     * @param queryLimit                Limit number of records that are queried
     * @param offset                    Offset value to use for offset pagination
     *
     * @return                          Returns List of Honor Roll Name record mapped information
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getHonorRollNames(Map<String, Object> params) {
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_HonorRollControllerBase controller = (PORTAL_HonorRollControllerBase)PORTAL_Utils.getControllerFactory().getHonorRollController();

            return controller.getHonorRollNames(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_HonorRollController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_HonorRollController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Acquires all information to populate picklists in honor roll filter section
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param oldestClassYear           Oldest class year to display under Class Year Picklist
     * @return                          A map containing lists for fiscal years, giving societies, class years
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getHonorRollFilterInformation(Map<String, Object> params) {
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_HonorRollControllerBase controller = (PORTAL_HonorRollControllerBase)PORTAL_Utils.getControllerFactory().getHonorRollController();

            return controller.getHonorRollFilterInformation(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_HonorRollController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_HonorRollController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets honor roll name details to display when honor roll name is clicked on
     *
     * @author                          Phillip Nguyen
     * @since                           1.0
     *
     * @param contactId                 The contact ID linked to honor roll name
     * @param fiscalYear                The contact's honor roll information in this specific year
     *
     * @return                          A list of honor roll detail maps which contains giving society and membership information
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getHonorRollNameDetails(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_HonorRollControllerBase controller = (PORTAL_HonorRollControllerBase)PORTAL_Utils.getControllerFactory().getHonorRollController();

            return controller.getHonorRollNameDetails(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_HonorRollController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_HonorRollController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * get information that user may modify regarding honor roll
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @return          contact's honor roll opt out value; honor roll joint preference; most recent honor roll
     */
    @AuraEnabled
    public static Map<String,Object> SERVER_getHonorRollManagementInformation(){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_HonorRollControllerBase controller = (PORTAL_HonorRollControllerBase)PORTAL_Utils.getControllerFactory().getHonorRollController();

            return controller.getHonorRollManagementInformation();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_HonorRollController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_HonorRollController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

       /**
     * Submit changes to honor including global opt out, honor roll name change, and
     * honor roll joint preference change
     *
     * @author          Phillip Nguyen
     * @since           1.0
     *
     * @param honorRollOptOut                                   New value for global honor roll opt out
     * @param honorRollNameUpdateString                         New honor roll name to display for current honor roll record
     * @param honorRollJointPreferenceUpdateString              New Honor Roll joint preference value
     * @param membershipIdToBooleanMap                          Mapping of society membership Ids to Boolean values
     *
     */
    @AuraEnabled
    public static void SERVER_submitHonorRollChanges(Map<String, Object> params){
        try{
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_HonorRollControllerBase controller = (PORTAL_HonorRollControllerBase)PORTAL_Utils.getControllerFactory().getHonorRollController();

            controller.submitHonorRollChanges(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_HonorRollController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_HonorRollController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SUBMIT_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}