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
 * LWC Controller for portal_VolunteerSignUp
 *
 * @author              Phillip Nguyen
 * @version             1.0
 * @since               1.0
 */
public inherited sharing class PORTAL_LWC_VolunteerController {
    private static final String ERROR_MESSAGE_ACQUIRE_INFORMATION = 'Failed to get information. Please contact an administrator.';
    private static final String ERROR_MESSAGE_SAVE_INFORMATION = 'Failed to save information. Please contact an administrator.';

    /**
     * Initializes the volunteer sign up modal
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param volunteerRecordId     The Id of the volunteer job record to prepopulate fields with.
     *
     * @return                      Map containing information to initialize the volunteer sign up page
     * @since                       1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_initializeVolunteerSignUp(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            return controller.initializeVolunteerSignUp(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Initializes the volunteer modify application modal
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param pageName              The page name of the Portal Page Section Settings to use.
     * @param mainSectionName       The main section name of the Portal Page Section Settings to use.
     * @param volunteerRecordId     The Id of the volunteer job record to prepopulate fields with.
     * @param volunteerId           Id of volunteer object that user is modifying
     *
     * @return                      Map containing information to initialize the volunteer modify application modal
     * @since                       1.0
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_initializeVolunteerModifyModal(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            return controller.initializeVolunteerModifyModal(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets list of Volunteer Jobs to display on the front end
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param pageName          Page Name of Page Section Setting
     * @param mainSectionName   Main Section Name of Page Section Setting
     * @param searchString      Name of Job to Search For
     * @param locationObject    Location Information for geolocation search
     * @param offset            Offset for query search
     *
     * @return                  Returns front end data map & volunteer job list
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getVolunteerJobList(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            return controller.getVolunteerJobList(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Signs user up for shift by creating volunteer object linked to either
     * the contact record (no changes made on front end and user has contact)
     * or an interim (if user does not have contact record or changes were made on front end)
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param volunteerShiftId      Id of shift that user is signing up for
     * @param volunteerBioInfoMap   Bio information of volunteer that was inputted on front end
     * @param pageName              Page Name of page section setting
     * @param mainSectionName       Main Section Name of page section setting
     * @param recaptchaToken             The client side recaptcha token to be verified
     */
    @AuraEnabled
    public static void SERVER_volunteerShiftSignUp(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            controller.volunteerShiftSignUp(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_SAVE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Modifies user's application by editing their interim if one exists or creates a new one of none exists
     *
     * @author  Phillip Nguyen
     * @since   1.0
     *
     * @param volunteerId           Id of volunteer object that user is modifying
     * @param interimId             Id of interim linked to volunteer object
     * @param volunteerBioInfoMap   Bio information of volunteer that was inputted on front end
     * @param pageName              Page Name of page section setting
     * @param mainSectionName       Main Section Name of page section setting
     * @param recaptchaToken             The client side recaptcha token to be verified
     */
    @AuraEnabled
    public static void SERVER_volunteerModifyApplicationSave(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            controller.volunteerModifyApplicationSave(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_SAVE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets shift information when user clicks on modify link in email
     *
     * @author                      Phillip Nguyen
     * @since                       1.0
     *
     * @param pageName              Page Name of Portal Page Section Setting
     * @param mainSectionName       Main Section Name of Portal Page Section Setting
     * @param volunteerShiftId      Id of Volunteer Shift
     *
     * @return                      Returns volunteer shift info as map
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getShiftInfo(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            return controller.getShiftInfo(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Withdraws volunteer application by setting status to cancelled
     *
     * @author                 Phillip Nguyen
     * @since                  1.0
     *
     * @param volunteerId      Id of Volunteer
     */
    @AuraEnabled
    public static void SERVER_withdrawVolunteerApplication(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_VolunteerControllerBase controller = (PORTAL_VolunteerControllerBase)PORTAL_Utils.getControllerFactory().getVolunteerController();

            controller.withdrawVolunteerApplication(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_VolunteerController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_VolunteerController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MESSAGE_ACQUIRE_INFORMATION,
                                                                                           PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}