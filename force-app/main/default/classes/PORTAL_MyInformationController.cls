/*
* Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
*/

/**
* Handles methods related to the logged in constituent profile information.
* Methods can be overwritten for custom functionality
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/

public without sharing class PORTAL_MyInformationController {


    /**
     * method that retrieves the constituent's bio information records
     * to display on the portal. This function calls an overridable function
     * that handles all of the logic.
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @return                 Map that contains all the information necessary to display on the front end
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getConstituentInformation() {
        try {
            Map<String, Object> returnMap = new Map<String, Object>();

            Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
            if (cont != null) {
                returnMap = ((PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController()).getConstituentInformation(new Map<String, Object>{'contactId' => cont.Id});
            } else {
                throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not retrieve the requested information. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => 'Contact Id is null in SERVER_getConstituentInformation'});
            }

            return returnMap;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not retrieve the requested information. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * method that saves the contstituent's bio information updates that were made
     * on the front end. This function calls an overridable function
     * that handles all of the logic.
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     *@param information:              Object that is a map that contains the updated information (very similar to the information map from the getter)
     */
    @AuraEnabled
    public static String SERVER_saveInformation(Object information){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            return ((PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController()).saveInformation(new Map<String, Object>{'information' => information, 'createCase' => true});
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not retrieve the requested information. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getMessage()});
        }
    }

    /**
     * method that saves the contstituent's bio information updates that were made
     * to a record that isn't updatable. All of this information will be saved onto
     * interim records. This function calls an overridable function
     * that handles all of the logic.
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param record:              A map of the populated fields that represent the sobject record
     * @param sObjectName:         The sobject api name of the record we are trying to update (for deserialization)
     * @param recordType:          The record type of the object if there is one
     * @param masterDegreeId       The id of the master degree to populate lookup
     * @param recordToUpdateId     The id of self report record to update
     *
     * @return                     Object that was updated
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_reportUpdate(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            return ((PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController()).reportUpdate(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not retrieve the requested information. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets school name for school degree information after clicking on lookup option
     *
     * @author: Phillip Nguyen
     * @since:  1.0
     *
     * @param objectName  name of object we are querying for, which is either Post Code or Minor Code
     * @param Id          Id of Object
     *
     * @return            returns name of school
     */
    @AuraEnabled
    public static String SERVER_getAcademicOrgName(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_MyInformationControllerBase controller = (PORTAL_MyInformationControllerBase)PORTAL_Utils.getControllerFactory().getMyInformationController();

            return controller.getAcademicOrgName(params);
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => 'AES_Key', PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'Could not retrieve the requested information. Please contact an administrator.', PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

    }
}