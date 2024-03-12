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
 * LWC Controller used by portal_EventManagement and portal_EventManagementDashboard
 *
 * @author          Phillip Nguyen
 * @version         1.0
 * @since           1.0
 */
public with sharing class PORTAL_LWC_EventManagementController {
    public static final String ERROR_GENERAL_MESSAGE = 'There was an error obtaining your records. Please contact an administrator.';
    public static final String ERROR_MODIFICATION = 'There was an error modifiying your records. Please contact an administrator.';
    public static final String ERROR_INSUFFICIENT_ACCESS = 'There was an error accessing this page. Please contact an administrator';

    /**
     * Checks if current user is system admin or ascend customer community admin
     *
     * @author      Phillip Nguyen
     * @since       1.0
     *
     * @return      true/false if user is admin
     */
    @AuraEnabled
    public static Boolean SERVER_isUserAdministrator(){

        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            return controller.isUserAdministrator();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INSUFFICIENT_ACCESS,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Gets registered participants information, and supports offset pagination
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param name              Event Name to query for
     * @param offset            Offset value for query, used for pagination
     * @param searchKey         search string to filter query results
     *
     * @return                  Mapped participation info containing a list of participations, total registered participants,
     *                          total attending participants, and total registered participants filtered by name
     */
    @AuraEnabled
    public static Map<String,Object> SERVER_getRegisteredParticipations(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            return controller.getRegisteredParticipations(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Mark Single Participation as Has Attended Event and updates participation
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param participationId   Id of participation to mark as 'Has Attended'
     */
    @AuraEnabled
    public static void SERVER_markParticipationAsAttended(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            controller.markParticipationAsAttended(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MODIFICATION,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Check In Registrant, this is usually done when an admin scans qr code
     *
     * @author                  Phillip Nguyen
     * @since                   1.12
     *
     * @param participationId   Id of participation to mark as 'Has Attended'
     * 
     * @return                  Name of Participant
     */
    @AuraEnabled
    public static String SERVER_checkInRegistrant(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            return controller.checkInRegistrant(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MODIFICATION,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Delete single participation record
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param participationId   Id of participation to delete
     */
    @AuraEnabled
    public static void SERVER_deleteParticipationRecord(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            controller.deleteParticipationRecord(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_MODIFICATION,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    // ---------------- VISUAL FORCE PAGE CONTROLLER FUNCTIONS -----------------------------
    /**
     * Get List of registered attendees for event
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param listingName       Name of event listing to get registered participations
     * @return                  List of List of attendees. Nested list if we split attendee list due to size
     */
    public static List<List<PORTAL_EventManagementControllerBase.Attendee>> getAttendeeLists() {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            return controller.getAttendeeLists();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }

    /**
     * Determines if Degree and Year are needed for event RSVP List
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param listingName       Name of event listing to get registered participations
     * @return                  Boolean string
     */
    public static String getDegreeAndYearNeeded() {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            return controller.getDegreeAndYearNeeded();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }

    }

    /**
     * Creates Title name when downloading rsvp list
     *
     * @author                  Phillip Nguyen
     * @since                   1.0
     *
     * @param listingName       Name of event listing to get registered participations
     * @return                  Name of Event Listing plus "Attendees' appended on
     */
    public static String getDocumentTitle() {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_EventManagementControllerBase controller = (PORTAL_EventManagementControllerBase)PORTAL_Utils.getControllerFactory().getEventManagementController();

            return controller.getDocumentTitle();
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_EventManagementController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_EventManagementController.class.getName());
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_GENERAL_MESSAGE,
                                                                                            PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});
        }
    }
}