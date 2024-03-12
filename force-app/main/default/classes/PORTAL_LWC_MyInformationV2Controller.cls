/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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
 * LWC Controller for portal_MyInformation components
 *
 * @author              Todd Shinto
 * @version             1.7
 * @since               1.7
 */
public without sharing class PORTAL_LWC_MyInformationV2Controller {
    public static final String ERROR_GENERAL_RETRIEVE_MESSAGE = 'There was an error retrieving the information. Please contact an administrator';
    public static final String ERROR_GENERAL_SAVE_MESSAGE = 'There was an error saving the information. Please contact an administrator'; 

    /**
     * Gets View info for My Information
     *
     * @author                  Todd Shinto
     * @since                   1.7
     *
     * @param params             Contains the following:
     * @param pageName          Page Name of Page Section Setting
     * @param mainSectionName   Main Section Name of Page Section Setting
     * @param subSectionName    Sub Section Name of Page Section Setting
     *
     * @return                  Returns front end configurations & record list
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getViewInfo(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationViewControllerBase controller = (PORTAL_MyInformationViewControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2ViewController();

            return controller.getViewInfo(params);

        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_RETRIEVE_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Gets info for My Information edit section initialization
     *
     * @author                  Jacob Huang
     * @since                   1.8
     *
     * @param pageName              String: Page Name of Page Section Setting
     * @param mainSectionName       String: Main Section Name of Page Section Setting
     * @param subSectionName        String: Sub Section Name of Page Section Setting
     * @param selfReportPageName    String: page name for self reported records, assumes main section and subsection have the same name
     *
     * @return                  Returns front end configurations & record list
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getEditInfo(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationEditControllerBase controller = (PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController();

            return controller.getEditInfo(params);

        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_RETRIEVE_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Save records that the user changed/added/deleted
     * 
     * @author Jacob Huang
     * @since 1.8
     * 
     * @param sectionIdToUpdatedRecordsMap  Map<String, List<Map<String, Object>>>: Map of section id to a list of records that have been updated
     * @param interimSourceUrl              Relative Url that this request was sent from              
     */
    @AuraEnabled
    public static void SERVER_saveInformation(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationEditControllerBase controller = (PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController();

            controller.saveInformation(params);

        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_SAVE_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Save staging records for values that the user requests to update in frontend  
     * 
     * @author Jacob Huang
     * @since 1.10
     * 
     * @param selfReportRecordMap   Map<String, Object>: self-reported information as a map
     * @param pageName              String: page name
     * @param mainSectionName       String: main section
     * @param subSectionName        String: subsection
     * @param sectionId             String: front end section id
     * @param originalRecordId      String: id of original record (i.e. pre-existing non-self-reported record)
     * @param interimSourceUrl      String: Relative Url that this request was sent from
     * 
     * @return SObject (as a map) that was just inserted/updated, fields (including lookup and formula) are updated with what was changed
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_selfReportInformation(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationEditControllerBase controller = (PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController();
            return controller.selfReportInformation(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_MyInformationV2Controller.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_SAVE_MESSAGE,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Gets Service Indicator Values by doing SOSL search
     *
     * @author Phillip Nguyen
     * 
     * @param searchText                Text to search for
     * @param pageName                  String: page name
     * @param mainSectionName           String: main section
     * @param subSectionName            String: subsection
     * @param sectionId                 String: front end section id
     * @return                          List of service indicators
     * @since                           1.12
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_searchServiceIndicatorValues(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationEditControllerBase controller = (PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController();
            return controller.searchServiceIndicatorValues(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_RETRIEVE_MESSAGE,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }

     /**
     * Checks to see if we are displaying the search bar, we display if there are service indicator values that are not always showing on portal
     *
     * @author Phillip Nguyen
     * 
     * @return                          Boolean if we display search bar
     * @since                           1.12
     */
    @AuraEnabled
    public static Boolean SERVER_isDisplaySearchBar(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationEditControllerBase controller = (PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController();
            return controller.isDisplaySearchBar(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_RETRIEVE_MESSAGE,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }

    /**
     * Get Page Section Setting configs
     *
     * @author Phillip Nguyen
     * 
     * @return                          Map of CMT configurations
     * @since                           1.13
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> SERVER_getCustomMetadataConfiguration(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationEditControllerBase controller = (PORTAL_MyInformationEditControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationv2EditController();
            return controller.getCustomMetadataConfiguration(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e);
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_RETRIEVE_MESSAGE,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }
}