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
 * Controller for portal_ContentSubmission.
 *
 * @author Aaron Wong
 * @version     1.0
 * @since       1.0
 */
public virtual without sharing class PORTAL_LWC_ContentSubmissionController {
    public static final String ERROR_INITIALIZATION = 'There was an issue accessing this page. Please contact an administrator.';
    public static final String ERROR_SUBMISSION = 'There was an issue in submitting the content. Please contact an administrator.';

    /**
     * Sets up and retrieves data for content submission.
     *
     * @author Aaron wong
     *
     * @param pageName      The page name for the Portal Page Section Setting.
     * @param recordId      The record Id of the Listing if editing a Listing.
     * @param recordType    The Record Type Developer Name of the Listing that is being submitted.
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_initializeContentSubmission(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ContentSubmissionControllerBase controller = (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getControllerFactory().getContentSubmissionController();

            return controller.initializeContentSubmission(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }

    /**
     * Get various information needed for initializing class note submission.
     * 
     * @author                  Jacob Huang
     * @since                   1.18
     *
     * @param contentModuleName String: Name of content module record for the confirmation page message
     *  
     * @return                  Map with frontEndDataMap, picklists, contentModuleMetadata, listingId, and listingWrapperMap with authenticated user info for pre-populating fields and Id of class note listing
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_initializeClassNoteSubmission(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ContentSubmissionControllerBase controller = (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getControllerFactory().getContentSubmissionController();
            return controller.initializeClassNoteSubmission(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Get the information needed for submitting another class note. For now, it's just making a new temporary listing.
     * 
     * @author                  Jacob Huang
     * @since                   1.18
     *
     * @return                  Map with new listingId 
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_resetClassNoteSubmission(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ContentSubmissionControllerBase controller = (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getControllerFactory().getContentSubmissionController();
            return controller.resetClassNoteSubmission(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Create a ContentDocumentLink between the uploaded file (ContentDocument) and the listing.
     * Only needed for guests, since lightning-file-upload doesn't do it for guests.
     * 
     * @author Jacob Huang
     * @since 1.18
     * 
     * @param contentVersionId      String: ContentVersion ID of uploaded file, ContentDocument ID would be preferable, but guests aren't given it on frontend
     * @param recordId              String: record ID of a record (likely a Listing here in this controller) to attach the content document to
     */
    @AuraEnabled
    public static void SERVER_attachContentDocument(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ContentSubmissionControllerBase controller = (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getControllerFactory().getContentSubmissionController();
            controller.attachContentDocument(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_INITIALIZATION,
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * Get information for a particular listing's attached content documents (aka uploaded files) 
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param recordId    String: record id for the listing
     * 
     * @return List<Map<String, Object>> with each file's name (of form title.ext) and documentId. 
     *         These key names match the keys returned by the frontend lightning-file-upload component
     */
    @AuraEnabled
    public static List<Map<String, Object>> SERVER_getAttachedContentDocuments(Map<String, Object> params) {
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ContentSubmissionControllerBase controller = (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getControllerFactory().getContentSubmissionController();
            return controller.getAttachedContentDocuments(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SUBMISSION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }

    /**
     * Submits the user's listing and creates a case for staff to view.
     *
     * @author Aaron Wong
     *
     * @param listingWrapper        Wrapper containing listing information to save.
     * @param pageName              The page name for the associated Portal Page Section Setting
     * @param mainSectionName       The main section name for the Portal Page Section Setting.
     * @param subSectionName        The subsection name for the Portal Page Section Setting
     * @param recordId              The record Id of the listing if editing an existing Listing.
     * @param recaptchaToken        The client side recaptcha token to be verified
     */
    @AuraEnabled
    public static void SERVER_submitContent(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_ContentSubmissionControllerBase controller = (PORTAL_ContentSubmissionControllerBase)PORTAL_Utils.getControllerFactory().getContentSubmissionController();

            controller.submitContent(params);
        } catch (AuraHandledException ahe) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(ahe, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw ahe;
        } catch (Exception e) {
            PORTAL_ErrorEmailHandler errorEmailHandler = (PORTAL_ErrorEmailHandler)PORTAL_Utils.getControllerFactory().getErrorEmailHandler();
            errorEmailHandler.publishEmailEvent(e, PORTAL_LWC_ContentSubmissionController.class.getName());
            throw PORTAL_CommunityUtils.createAuraHandledException(
                                new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                        PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_SUBMISSION,
                                                        PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()});

        }
    }
}