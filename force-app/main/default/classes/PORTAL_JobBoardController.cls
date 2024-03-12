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
*/

/**
* Handles methods related to the job board
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/
public virtual with sharing class PORTAL_JobBoardController {

    /**
     * method that retrieves the display information for the create a job page
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param pageName:                 page name of the page section setting to get
     * @param mainSectionName:          main section name of the page section setting to get
     *
     * @return                          the map of field id and the data needed to display the field
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_getCreateJobPostingFrontEndData(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getCreateJobPostingFrontEndData(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
            throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
                PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            });
        }
    }

    /**
     * method that retrieves the picklist fields for the create job post page
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @return                 Map that contains the picklists to display on the page
     */
    @AuraEnabled
    public static Map<String, List<Map<String, Object>>> SERVER_getPicklists(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getPicklists(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that submits a new job posting or edits an existing job posting
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param recaptchaToken             The client side recaptcha token to be verified
     * @param jobRecord:                    the job record we are trying to submit
     */

    @AuraEnabled
    public static void SERVER_submitJobPosting(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            controller.submitJobPosting(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             System.debug(e.getMessage());
             System.debug(e.getStacktraceString());
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that gets a user's open and closed jobs to display on the front end
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param openOffset:                   the open offset for the open jobs so we can show different pages
     * @param closedOffset:                 the closed offset for the closed jobs so we can show different pages
     *
     * @return                              the map of the data to display on the front end and how to display it
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getMyPostedJobs(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getMyPostedJobs(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that updates a job to have a status of archived, so it won't
     * show on the job board anymore
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId:               the record id for the job we are trying to update
     */
    @AuraEnabled
    public static void SERVER_archiveJob(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            controller.archiveJob(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

     /**
     * method that gets the fields for a job to display on the job
     * listing detail page
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId:               the record id for the job we are trying to display
     *
     * @return                        the map display data and how to display it
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getJobListing(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getJobListing(params);
        } catch (AuraHandledException e) {
            System.debug(e.getMessage());
            throw e;
        }
         catch (Exception e) {
             System.debug(e.getStackTraceString());
             System.debug(e.getMessage());
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }


    /**
     * method that creates a job application for a job with the status temporary
     * and returns how to display it
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId:               the record id for the job the user is trying to apply for
     *
     * @return                        the map of the job application and the way to display on the front end
     */
    @AuraEnabled
    public static Map<String, Object> SERVER_createJobApplication(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.createJobApplication(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             System.debug(e.getMessage());
             System.debug(e.getStacktraceString());
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that submits a job application
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     * @param recaptchaToken             The client side recaptcha token to be verified
     * @param jobApplication:               the job application to submit
     */

    @AuraEnabled
    public static void SERVER_submitJobApplication(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            controller.submitJobApplication(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that gets the files uploaded during a job application
     *
     *
     * @author: Isaiah Rodriguez
     * @since: 1.0
     *
     *
     * @param jobApplicationId:               the id of the job application that the files are associated with
     * @return                                a list of document ids for the uploaded files
     */

    @AuraEnabled
    public static List<String> SERVER_getJobApplicationFileUploads(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getJobApplicationFileUploads(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getStackTraceString());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that gets a user's open and closed applications to display on the front end
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @return                              the map of the data to display on the front end and how to display it
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getMyApplications(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getMyApplications(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that gets a job's applicants
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId:                     the record id for the job that we are showing the applications for
     *
     * @return                              the map of the data to display on the front end and how to display it
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getJobApplicants(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getJobApplicants(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that withdraws an application
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId                   the record id of the application we are trying to withdraw
     */

    @AuraEnabled
    public static void SERVER_withdrawApplication(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            controller.withdrawApplication(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that changes the status of an application
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId                   the record id of the application we are trying to update
     */

    @AuraEnabled
    public static void SERVER_changeApplicationStatus(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            controller.changeApplicationStatus(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             System.debug(e.getMessage());
             System.debug(e.getStacktraceString());
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that gets the picklist field for the job board search page
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @return                      the picklists for the search page
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getSearchFilterPicklists(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getSearchFilterPicklists(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that gets job postings based on search criteria
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param filterMap:            the map of search criteria
     *
     * @return                      the map of records that fulfill the search criteria
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_searchForJobWithFilters(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.searchForJobWithFilters(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getStackTraceString());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    /**
     * method that retrieves the constituent's information to populate
     * on the job poster contact information section of the create a job page
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @return                 the contact for the logged in user
     */

    @AuraEnabled
    public static Map<String, Object> SERVER_getContactInfo(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.getContactInfo(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }

    @AuraEnabled
    public static String SERVER_publishDraft(Map<String, Object> params){
        try {
            PORTAL_CommunityUtils.throwTestException(null);
            PORTAL_JobBoardControllerBase controller = (PORTAL_JobBoardControllerBase)PORTAL_Utils.getControllerFactory().getJobBoardController();
            return controller.publishDraft(params);
        } catch (AuraHandledException e) {
            throw e;
        }
         catch (Exception e) {
             System.debug(e.getMessage());
             throw new AuraHandledException(e.getMessage());
            // throw PORTAL_CommunityUtils.createAuraHandledException(new Map<String, Object>{
            //     PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
            //     PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => 'There was a problem retrieving the form.',
            //     PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => e.getStackTraceString()
            // });
        }
    }
}