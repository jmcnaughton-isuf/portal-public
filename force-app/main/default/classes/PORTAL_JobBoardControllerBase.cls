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
public with sharing class PORTAL_JobBoardControllerBase {

    public static final String JOB_POSTING_PAGE_NAME = 'Job Posting';
    public static final String JOB_MANAGEMENT_PAGE_NAME = 'Job Management';
    public static final String JOB_VIEW_PAGE_NAME = 'Job Listing';
    public static final String JOB_APPLICATION_PAGE_NAME = 'Job Application';
    public static final String Job_APPLICANTS_PAGE_NAME = 'Job Applicants';
    public static final String JOB_BOARD_QUEUE_METADATA_LABEL =  'Job_Posting_Case_Queue_Name';
    public static final String JOB_SEARCH_PAGE_NAME = 'Job Search';
    public static final String CREATE_CASE_FOR_ALUMNI_METADATA_LABEL = 'Create_Case_For_Alumni_Job_Posting';
    public static final String CREATE_CASE_FOR_HIRING_MANAGER_METADATA_LABEL = 'Create_Case_For_Manager_Job_Posting';
    public static final String CREATE_DRAFT_FOR_ALUMNI_METADATA_LABEL = 'Create_Draft_For_Alumni_Job_Posting';
    public static final String CREATE_DRAFT_FOR_HIRING_MANAGER_METADATA_LABEL = 'Create_Draft_For_Manager_Job_Posting';
    public static final String ALUMNI_CONSTITUENT_TYPE_METADATA_LABEL = 'Alumni_Constituent_Types';
    public static final String POSTED_STATUS = 'Posted';
    public static final String PENDING_STATUS = 'Pending';
    public static final String PENDING_EDIT_STATUS = 'Pending Edit';
    public static final String ARCHIVED_STATUS = 'Archived';
    public static final String CASE_TYPE = 'Job Posting';
    public static final String APPROVED_STATUS = 'Approved';
    public static final String CREATE_CASE = 'createCase';
    public static final String CREATE_DRAFT = 'createDraft';
    public static final String JOB_KEY = 'Job';
    public static final String TEMPORARY_STATUS = 'Temporary';
    public static final String SUBMITTED_STATUS = 'Submitted';
    public static final String WITHDRAWN_STATUS = 'Withdrawn';
    public static final String MY_APPLICATIONS_PAGE_NAME = 'My Applications';
    public static final String RECORD_ID_KEY = 'recordId';
    public static final String OFFSET_KEY = 'offset';
    public static final String OPEN_OFFSET_KEY = 'openOffset';
    public static final String CLOSED_OFFSET_KEY = 'closedOffset';
    public static final String COUNT_KEY = 'count';
    public static final String OPEN_COUNT_KEY = 'openCount';
    public static final String CLOSED_COUNT_KEY = 'closedCount';
    public static final String OPEN_JOBS_MAIN_SECTION = 'Open_Jobs';
    public static final String CLOSED_JOBS_MAIN_SECTION = 'Closed_Jobs';
    public static final String OPEN_APPLICATIONS_MAIN_SECTION = 'Open_Applications';
    public static final String CLOSED_APPLICATIONS_MAIN_SECTION = 'Closed_Applications';
    public static final String FRONT_END_DATA_KEY = 'frontEndData';
    public static final String CAN_CREATE_JOB = 'canCreateJob';
    public static final String JOB_MAIN_SECTION = 'Job';
    public static final String PERSONAL_INFORMATION_MAIN_SECTION = 'Personal_Information';
    public static final String DEGREES_MAIN_SECTION = 'Degrees';
    public static final String STATUS_FIELD = 'Status__c';
    public static final String CASE_FIELD = 'Case__c';
    public static final String DRAFT_JOB_FIELD = 'ucinn_portal_Jobs__r';
    public static final String CREATED_BY_FIELD = 'CreatedById';
    public static final String RESUBMITTED_STATUS = 'Resubmitted';
    public static final String JOB_APPLICATION_KEY = 'jobApplication';
    public static final String JOB_LINK_KEY = 'jobLink';
    public static final String CREATED_DATE_FIELD = 'CreatedDate';
    public static final String SUBMISSION_DATE_KEY = 'submissionDate';
    public static final String RECORDS_MAP_KEY = 'recordsMap';
    public static final String DRAFT_STATUS = 'Draft';
    public static final String CONTENT_MODULE_NAME = 'contentModuleName';
    public static final String CONTENT_PAGE_NAME = 'contentPageName';
    public static final String PAGE_NAME = 'pageName';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String JOB_APPLICATION_ID = 'jobApplicationId';


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
     * @return                 the map of field id and the data needed to display the field
     */
    public virtual Map<String, Object> getCreateJobPostingFrontEndData(Map<String, Object> params) {
        String contentModuleName = (String) params.get(CONTENT_MODULE_NAME);
        String contentPageName = (String) params.get(CONTENT_PAGE_NAME);
        String pageName = (String) params.get(PAGE_NAME);
        String mainSectionName = (String) params.get(MAIN_SECTION_NAME);

        Map<String, Object> returnMap = new Map<String, Object>();

        if (String.isNotBlank(contentModuleName)) {
            String queryString = ' SELECT Content_Module_Metadata__c FROM ucinn_portal_Content_Module__c WHERE Name = :contentModuleName ';

            if (!String.isBlank(contentPageName)) {
                queryString = queryString + ' AND Content_Page__r.Name = :contentPageName ';
            }

            List<ucinn_portal_Content_Module__c> contentModuleList = Database.query(queryString);

            if (!contentModuleList.isEmpty() && String.isNotBlank(contentModuleList.get(0).Content_Module_Metadata__c)) {
                String content = contentModuleList.get(0).Content_Module_Metadata__c;
                Map<String, Object> deserializedContent = (Map<String, Object>)JSON.deserializeUntyped(content);
                returnMap.put('agreement', deserializedContent);
            }


        }
        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, '');
        returnMap.put(FRONT_END_DATA_KEY,PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionList));
        return returnMap;
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
    public virtual Map<String, Object> getContactInfo(Map<String, Object> params) {
        Id userId = UserInfo.getUserId();
        if (userId != null) {
            Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => userId});
            if (cont != null) {
                List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_POSTING_PAGE_NAME, PERSONAL_INFORMATION_MAIN_SECTION, '');
                pageSectionList.addAll(PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_POSTING_PAGE_NAME, DEGREES_MAIN_SECTION, ''));
                Map<String,Map<String,List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList);
                Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(cont.Id, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(), false, false);
                return recordsMap;
            }
        }
        return null;
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

    public virtual Map<String, List<Map<String, Object>>> getPicklists(Map<String, Object> params) {
        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_POSTING_PAGE_NAME, '', '');
        return PORTAL_UTIL_PageSectionSetting.getPicklists(pageSectionList);
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

    public virtual Map<String,Object> getMyPostedJobs(Map<String, Object> params) {
        Map<String, Object> returnMap = new Map<String, Object>();

        Integer openOffset = 0;
        Integer closedOffset = 0;
        if (params.get(OPEN_OFFSET_KEY) != null) {
            openOffset = Integer.valueOf(String.valueOf(params.get(OPEN_OFFSET_KEY)));
        }

        if (params.get(CLOSED_OFFSET_KEY) != null) {
            closedOffset = Integer.valueOf(String.valueOf(params.get(CLOSED_OFFSET_KEY)));
        }

        Map<String, Object> queryMap = queryForRecords(Id.valueOf(UserInfo.getUserId()), JOB_MANAGEMENT_PAGE_NAME, openOffset, closedOffset, OPEN_JOBS_MAIN_SECTION, CLOSED_JOBS_MAIN_SECTION);
        returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, queryMap.get(RECORDS_MAP_KEY));
        returnMap.put(OPEN_COUNT_KEY, queryMap.get(OPEN_COUNT_KEY));
        returnMap.put(CLOSED_COUNT_KEY, queryMap.get(CLOSED_COUNT_KEY));
        returnMap.put(FRONT_END_DATA_KEY, queryMap.get(FRONT_END_DATA_KEY));
        return returnMap;
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

    public virtual void submitJobPosting(Map<String, Object> params) {
        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_JobBoardControllerBase.submitJobPosting', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        Map<Object, Object> jobRecord = (Map<Object, Object>) params.get('jobRecord');
        if (jobRecord != null && !jobRecord.isEmpty()) {
            Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
            if (cont != null) {
                Id userContactId = cont.Id;
                Map<String, Boolean> orgSettingsMap = getCustomMetadataSettings(cont);

                if (orgSettingsMap.get(CAN_CREATE_JOB) != true) {
                    throw new AuraHandledException('You do not have the permissions to post a job.');
                }

                Id groupId = null;

                List<Portal_Organization_Setting__mdt> caseQueueSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
                    PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
                    PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
                    PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{JOB_BOARD_QUEUE_METADATA_LABEL}
                });

                if (!caseQueueSettingList.isEmpty()) {
                    String queueName = caseQueueSettingList.get(0).Value__c;
                    if (String.isNotBlank(queueName)) {
                        List<Group> groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :queueName Limit 1];
                        if (!groupList.isEmpty()) {
                            groupId = groupList.get(0).Id;
                        }
                    }

                }



                ucinn_portal_Job__c jobPosting = (ucinn_portal_Job__c) System.JSON.deserialize(System.JSON.serialize(jobRecord), ucinn_portal_Job__c.class);

                if (String.isBlank(jobPosting.Id)) {
                    if (orgSettingsMap.get(CREATE_CASE) == true) {
                        Case newCase = new Case(Origin='Web',
                        Subject='A new job posting has been submitted for approval.',
                        Status='New',
                        Type= CASE_TYPE,
                        ContactId=userContactId);

                        if (groupId != null) {
                            newCase.OwnerId = groupId;
                        }

                        insert newCase;

                        jobPosting.Case__c = newCase.Id;
                        jobPosting.Status__c = PENDING_STATUS;

                    } else {
                        jobPosting.Status__c = POSTED_STATUS;
                    }

                    insert jobPosting;

                } else {

                    List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_POSTING_PAGE_NAME, '', '');

                    Set<String> fieldSet = new Set<String>{'Case__c', 'CreatedById', 'Status__c', '(SELECT Id FROM ucinn_portal_Jobs__r)'};
                    for (Portal_Page_Section_Setting__mdt pageSection : pageSectionList) {
                        if (pageSection.SObject_API_Name__c == 'ucinn_portal_Job__c' && pageSection.Portal_Section_Field_Settings__r != null) {
                            for (Portal_Section_Field_Setting__mdt fieldSetting : pageSection.Portal_Section_Field_Settings__r) {
                                if (String.isNotBlank(fieldSetting.Field_API_Name__c) && fieldSetting.Field_API_Name__c.containsIgnoreCase('ucinn_portal_jobs__r')) {
                                    fieldSet.add(fieldSetting.Field_API_Name__c);
                                }
                            }
                        }
                    }
                    Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList);
                    Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> sectionNameToDynamicOverrideClassMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>();
                    PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQuery = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('SELECT ' + String.join(new List<String>(fieldSet), ', '), null, null, null, 1, 0, true);
                    sectionNameToDynamicOverrideClassMap.put(JOB_MAIN_SECTION, dynamicQuery);
                    Map<String,Map<String,List<Map<String,Object>>>> backendJobMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(jobPosting.Id, pageSectionMap, sectionNameToDynamicOverrideClassMap, false, false);
                    //the map contains the backend version of the record we are trying to update so we can do a comparison
                    if (!backendJobMap.isEmpty() && backendJobMap.get(JOB_MAIN_SECTION) != null && backendJobMap.get(JOB_MAIN_SECTION).containsKey(PORTAL_CONST_PageSectionSetting.RECORD_KEY) && !backendJobMap.get(JOB_MAIN_SECTION).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY).isEmpty()) {
                        Map<String, Object> backEndJobRecord = (Map<String, Object>) backendJobMap.get(JOB_MAIN_SECTION).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY).get(0);

                        if (backEndJobRecord.get(CREATED_BY_FIELD) != UserInfo.getUserId()) {
                            throw new AuraHandledException('You are not the owner of this job posting, so you cannot edit it.');
                        }

                        if (backEndJobRecord.get(STATUS_FIELD) != POSTED_STATUS) {
                            // Cannot edit a job that is already pending edit
                            if (backEndJobRecord.get(STATUS_FIELD) == PENDING_EDIT_STATUS) {
                                throw new AuraHandledException('You already have a pending edit to this job posting.');
                            }

                            if (backEndJobRecord.get(CASE_FIELD) != null) {
                                Case updatedCase = new Case(Id = (Id) backEndJobRecord.get(CASE_FIELD), Status = RESUBMITTED_STATUS);
                                update updatedCase;
                            }
                            update jobPosting;
                        } else if (orgSettingsMap.get(CREATE_DRAFT) == true) {

                            if (backEndJobRecord.get(DRAFT_JOB_FIELD) != null && !((List<Object>)backEndJobRecord.get(DRAFT_JOB_FIELD)).isEmpty()) {
                                throw new AuraHandledException('You already have a pending update to this job posting.');
                            }

                            ucinn_portal_Job__c draftJob = jobPosting.clone(false, false, false, false);

                            if (orgSettingsMap.get(CREATE_CASE) == true) {

                                Set<String> changedFields = new Set<String>();
                                for (String key : backEndJobRecord.keySet()) {
                                    if (!key.endsWith('__r') && key != CASE_FIELD && key != STATUS_FIELD && key != 'attributes') {
                                        if (backEndJobRecord.get(key) != jobPosting.get(key)) {
                                            changedFields.add(key);
                                        }
                                    }
                                }

                                Case resubmittedCase = new Case(
                                        Origin='Web',
                                        Subject='A job posting has been edited and needs approval.',
                                        Status='New',
                                        Description = 'Fields Changed: ' + String.join(new List<String>(changedFields), ';'),
                                        Type=CASE_TYPE,
                                        ContactId=userContactId);

                                if (groupId != null) {
                                    resubmittedCase.OwnerId = groupId;
                                }

                                insert resubmittedCase;
                                draftJob.Case__c = resubmittedCase.Id;
                            }

                            draftJob.Master_Job__c = jobPosting.Id;
                            draftJob.Id = null;
                            draftJob.Status__c = DRAFT_STATUS;

                            insert draftJob;

                            ucinn_portal_Job__c updatedJob = new ucinn_portal_Job__c();
                            updatedJob.Id = jobPosting.Id;
                            updatedJob.Status__c = PENDING_EDIT_STATUS;

                            update updatedJob;
                        } else {
                            update jobPosting;
                        }
                    }
                }
            }

        }
    }

    /**
     * method that retrieves the default logic for submitting job postings based
     * on the type of user that is submitting the post
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param cont                 contact that we are evaulating the conditions for
     *
     * @return                      map that helps determine the logic for submitting a job post
     */

    public virtual Map<String, Boolean> getCustomMetadataSettings(Contact cont) {
        Set<String> contactTypes = new Set<String>(cont.ucinn_ascendv2__Contact_Type__c.split(';'));

        Boolean isAlumni = false;
        Boolean alumniCreateCase = false;
        Boolean hiringManagerCreateCase = false;
        Boolean alumniCreateDraft = false;
        Boolean hiringManagerCreateDraft = false;

        Set<String> customMetadataLabelSet = new Set<String>{
            CREATE_CASE_FOR_ALUMNI_METADATA_LABEL,
            CREATE_CASE_FOR_HIRING_MANAGER_METADATA_LABEL,
            CREATE_DRAFT_FOR_ALUMNI_METADATA_LABEL,
            CREATE_DRAFT_FOR_HIRING_MANAGER_METADATA_LABEL,
            ALUMNI_CONSTITUENT_TYPE_METADATA_LABEL
        };

        // TODO: change to developer Name
        List<Portal_Organization_Setting__mdt> orgSettings = [SELECT Id, Value__c, DeveloperName FROM Portal_Organization_Setting__mdt WHERE DeveloperName IN :customMetadataLabelSet];
        for (Portal_Organization_Setting__mdt setting : orgSettings) {
            if (setting.DeveloperName == ALUMNI_CONSTITUENT_TYPE_METADATA_LABEL) {
                if (String.isNotBlank(setting.Value__c)) {
                    Set<String> alumniTypes = new Set<String>(setting.Value__c.split(';'));
                    Integer numberOfDifferentAlumniTypes = alumniTypes.size();
                    alumniTypes.removeAll(contactTypes);
                    isAlumni = alumniTypes.size() < numberOfDifferentAlumniTypes;
                }
            } else if (setting.DeveloperName == CREATE_CASE_FOR_ALUMNI_METADATA_LABEL) {
                alumniCreateCase = setting.Value__c.toLowerCase() == 'true' ? true : false;
            } else if (setting.DeveloperName == CREATE_CASE_FOR_HIRING_MANAGER_METADATA_LABEL) {
                hiringManagerCreateCase = setting.Value__c.toLowerCase() == 'true' ? true : false;
            } else if (setting.DeveloperName == CREATE_DRAFT_FOR_ALUMNI_METADATA_LABEL) {
                alumniCreateDraft = setting.Value__c.toLowerCase() == 'true' ? true : false;
            } else if (setting.DeveloperName == CREATE_DRAFT_FOR_HIRING_MANAGER_METADATA_LABEL) {
                hiringManagerCreateDraft = setting.Value__c.toLowerCase() == 'true' ? true : false;
            }
        }

        Map<String, Boolean> returnMap = new Map<String, Boolean>();
        if (isAlumni) {
            returnMap.put(CREATE_DRAFT, alumniCreateDraft);
            returnMap.put(CREATE_CASE, alumniCreateCase);
            returnMap.put(CAN_CREATE_JOB, true);
        } else if (cont.ucinn_portal_Is_Hiring_Manager__c) {
            returnMap.put(CREATE_DRAFT, hiringManagerCreateDraft);
            returnMap.put(CREATE_CASE, hiringManagerCreateCase);
            returnMap.put(CAN_CREATE_JOB, true);
        } else {
            returnMap.put(CAN_CREATE_JOB, false);
        }

        return returnMap;
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

    public virtual void archiveJob(Map<String, Object> params) {
        Id recordId = (Id) params.get(RECORD_ID_KEY);
        Id userId = UserInfo.getUserId();
        if (recordId != null && userId != null) {
            List<ucinn_portal_Job__c> jobList = [SELECT Id, CreatedById FROM ucinn_portal_Job__c WHERE Id = :recordId AND CreatedById = :userId];
            if (jobList.isEmpty()) {
                return;
            }
            ucinn_portal_Job__c job = new ucinn_portal_Job__c();
            job.Status__c = ARCHIVED_STATUS;
            job.Id = recordId;
            update job;
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

    public virtual Map<String, Object> getJobListing(Map<String, Object> params) {
        String userOwned = 'userOwned';
        String applied = 'applied';
        Id jobId = (Id) params.get(RECORD_ID_KEY);
        Id userId = UserInfo.getUserId();
        Map<String, Object> returnMap = new Map<String, Object>();

        if (String.isBlank(jobId) || userId == null) {
            return returnMap;
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_VIEW_PAGE_NAME, '', '');
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList);
        //map that contains the record that matches the record id
        returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, PORTAL_UTIL_PageSectionSetting.queryForRecords(jobId, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(), false, false));
        returnMap.put(FRONT_END_DATA_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList));

        List<ucinn_portal_Job__c> jobList = [SELECT Id, CreatedById, View_Count__c, (SELECT Id FROM ucinn_portal_Job_Applications__r WHERE CreatedById =:userId AND Status__c NOT IN (:WITHDRAWN_STATUS, :TEMPORARY_STATUS))
                                             FROM ucinn_portal_Job__c WHERE Id = :jobId];
        if (jobList.isEmpty()) {
            throw new AuraHandledException('The job you are trying to view does not exist in our system.');
        } else {
            ucinn_portal_Job__c job = jobList.get(0);

            if (job.CreatedById == userId) {
                returnMap.put(userOwned, true);
            } else {
                returnMap.put(userOwned, false);
                ucinn_portal_Job__c jobViewCount = new ucinn_portal_Job__c();
                jobViewCount.Id = job.Id;
                if (job.View_Count__c != null) {
                    jobViewCount.View_Count__c = job.View_Count__c + 1;
                } else {
                    jobViewCount.View_Count__c = 1;
                }
                update jobViewCount;
            }

            if (job.ucinn_portal_Job_Applications__r != null && !job.ucinn_portal_Job_Applications__r.isEmpty()) {
                returnMap.put(applied, true);
            } else {
                returnMap.put(applied, false);
            }
        }

        return returnMap;


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
    public virtual Map<String, Object> createJobApplication(Map<String, Object> params) {
        Id jobId = (Id) params.get(RECORD_ID_KEY);
        Contact cont = PORTAL_CommunityUtils.getContactInfoFromUser(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_USER_ID => UserInfo.getUserId()});
        Map<String, Object> returnMap = new Map<String, Object>();

        if (String.isBlank(jobId) || cont == null) {
            return returnMap;
        }


        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_APPLICATION_PAGE_NAME, '', '');
        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList);
        //the records map holds contact information for the user
        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(cont.Id, pageSectionMap, new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>(), false, false);
        if (recordsMap.containsKey(PERSONAL_INFORMATION_MAIN_SECTION) && recordsMap.get(PERSONAL_INFORMATION_MAIN_SECTION).containsKey(PORTAL_CONST_PageSectionSetting.RECORD_KEY) && !recordsMap.get(PERSONAL_INFORMATION_MAIN_SECTION).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY).isEmpty()) {
            List<Map<String, Object>> recordsList = recordsMap.get(PERSONAL_INFORMATION_MAIN_SECTION).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY);
            //record data is the contact record
            Map<String, Object> contactData = recordsList.get(0);
            ucinn_portal_Job_Application__c jobApplication = new ucinn_portal_Job_Application__c();
            jobApplication.Job__c = jobId;
            jobApplication.Status__c = TEMPORARY_STATUS;

            //the field section settings here map the contact field to the job application field
            for (Portal_Page_Section_Setting__mdt pageSectionSetting : pageSectionSettingList) {
                if (pageSectionSetting.Portal_Section_Field_Settings__r != null) {
                    for (Portal_Section_Field_Setting__mdt fieldSetting : pageSectionSetting.Portal_Section_Field_Settings__r) {
                        if (String.isNotBlank(fieldSetting.Field_API_Name__c) && String.isNotBlank(fieldSetting.Staging_Record_Field_API_Name__c)) {
                            jobApplication.put(fieldSetting.Staging_Record_Field_API_Name__c, contactData.get(fieldSetting.Field_API_Name__c));
                        }
                    }
                }
            }
            insert jobApplication;
            returnMap.put(JOB_APPLICATION_KEY, jobApplication);
        } else {
            throw new AuraHandledException('There was a problem getting the data for the job you are trying to apply for.');
        }
        returnMap.put(FRONT_END_DATA_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList));

        return returnMap;


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
    public virtual void submitJobApplication(Map<String, Object> params) {
        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_JobBoardControllerBase.submitJobApplication', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        Id userId = UserInfo.getUserId();
        if (params.get(JOB_APPLICATION_KEY) != null && userId != null) {
            ucinn_portal_Job_Application__c jobApplication = (ucinn_portal_Job_Application__c) System.JSON.deserialize(System.JSON.serialize(params.get(JOB_APPLICATION_KEY)), ucinn_portal_Job_Application__c.class);
            Id jobId = jobApplication.Job__c;
            if (jobId != null) {
                List<ucinn_portal_Job_Application__c> appliedApplications = [SELECT Id FROM ucinn_portal_Job_Application__c WHERE Job__c = :jobId AND CreatedById = :userId AND Status__c NOT IN (:WITHDRAWN_STATUS, :TEMPORARY_STATUS)];
                if (appliedApplications.isEmpty()) {
                    jobApplication.Status__c = SUBMITTED_STATUS;
                    update jobApplication;
                } else {
                    throw new AuraHandledException('You have already applied to this job.');
                }
            } else {
                System.debug('The job id for this job application is blank in PORTAL_JobBoardControllerBase.submitJobApplication');
            }

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
    public virtual List<String> getJobApplicationFileUploads(Map<String, Object> params) {
        List<String> resultList = new List<String>();

        if (params == null || params.isEmpty()) {
            return resultList;
        }

        String jobApplicationId = (String)params.get(JOB_APPLICATION_ID);

        if (String.isBlank(jobApplicationId)) {
            return resultList;
        }

        List<ContentDocumentLink> contentDocumentLinksList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :jobApplicationId];

        for (ContentDocumentLink eachLink : contentDocumentLinksList) {
            resultList.add(String.valueOf(eachLink.ContentDocumentId));
        }

        return resultList;
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
    public virtual Map<String, Object> getMyApplications(Map<String, Object> params) {

        Id userId = UserInfo.getUserId();
        Map<String, Object> returnMap = new Map<String, Object>();

        Integer openOffset = 0;
        Integer closedOffset = 0;
        if (params.get(OPEN_OFFSET_KEY) != null) {
            openOffset = Integer.valueOf(String.valueOf(params.get(OPEN_OFFSET_KEY)));
        }

        if (params.get(CLOSED_OFFSET_KEY) != null) {
            closedOffset = Integer.valueOf(String.valueOf(params.get(CLOSED_OFFSET_KEY)));
        }

        if (userId != null) {
            Map<String, Object> queryMap = queryForRecords(Id.valueOf(UserInfo.getUserId()), MY_APPLICATIONS_PAGE_NAME, openOffset, closedOffset, OPEN_APPLICATIONS_MAIN_SECTION, CLOSED_APPLICATIONS_MAIN_SECTION);
            Map<String, Map<String, Map<String, Map<String, Object>>>> recordsWithLinks = formatRecordsAndGetAttachments((Map<String, Map<String, List<Map<String, Object>>>>) queryMap.get(RECORDS_MAP_KEY));
            returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordsWithLinks);
            returnMap.put(OPEN_COUNT_KEY, queryMap.get(OPEN_COUNT_KEY));
            returnMap.put(CLOSED_COUNT_KEY, queryMap.get(CLOSED_COUNT_KEY));
            returnMap.put(FRONT_END_DATA_KEY, queryMap.get(FRONT_END_DATA_KEY));

        }

        return returnMap;
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

    public virtual Map<String, Object> getJobApplicants(Map<String, Object> params) {

        Id recordId = (Id) params.get(RECORD_ID_KEY);
        Id userId = UserInfo.getUserId();

        Map<String, Object> returnMap = new Map<String, Object>();
        Integer offset = 0;
        if (params.get(OFFSET_KEY) != null) {
            offset = Integer.valueOf(String.valueOf(params.get(OFFSET_KEY)));
        }

        if (recordId != null && userId != null) {
            List<ucinn_portal_Job__c> jobList = [SELECT Id, CreatedById FROM ucinn_portal_Job__c WHERE Id = :recordId AND CreatedById = :userId];
            if (jobList.isEmpty()) {
                return new Map<String, Object>();
            }

            Map<String, Object> queryMap = queryForRecords(recordId, JOB_APPLICANTS_PAGE_NAME, offset, null, OPEN_APPLICATIONS_MAIN_SECTION, null);
            Map<String, Map<String, Map<String, Map<String, Object>>>> recordsWithLinks = formatRecordsAndGetAttachments((Map<String, Map<String, List<Map<String, Object>>>>) queryMap.get(RECORDS_MAP_KEY));
            returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, recordsWithLinks);
            returnMap.put(COUNT_KEY, queryMap.get(OPEN_COUNT_KEY));
            returnMap.put(FRONT_END_DATA_KEY, queryMap.get(FRONT_END_DATA_KEY));

        }

        return returnMap;
    }

     /**
     * method that gets applications' notes and attachments and provides a download link for them when
     * we are displaying it on the front end
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordsMap                    the map of applications that we are trying to get records for
     *
     * @return                              the map of records with the link downloads
     */

    private Map<String, Map<String, Map<String, Map<String, Object>>>> formatRecordsAndGetAttachments(Map<String, Map<String, List<Map<String, Object>>>> recordsMap) {

        String idField = 'Id';
        String jobField = 'Job__c';
        String recordKey = 'record';
        String nameKey = 'name';
        String linkKey = 'link';
        String linksKey = 'links';

        Set<Id> linkedEntityIdSet = new Set<Id>();
        Map<String, Map<String, Map<String, Map<String, Object>>>> returnMap = new Map<String, Map<String, Map<String, Map<String, Object>>>>();

        for (String mainSection : recordsMap.keySet()) {
            Map<String, List<Map<String, Object>>> sectionMap = recordsMap.get(mainSection);
            if (sectionMap != null) {
                for (String subSection : sectionMap.keySet()) {
                    List<Map<String, Object>> listOfRecords = sectionMap.get(subSection);
                    //this is our return map that will hold the id to the record
                    Map<String, Map<String, Object>> idToRecordMap = new Map<String, Map<String, Object>>();
                    if (listOfRecords != null) {
                        for (Map<String, Object> record : listOfRecords) {
                            if (record.containsKey('Id') && String.isNotBlank( String.valueOf(record.get(idField)))) {
                                String recordId = String.valueOf(record.get(idField));
                                //add the record id to the linked entity id set to query for notes and attachments
                                linkedEntityIdSet.add(Id.valueOf(recordId));
                                if (String.isNotBlank(String.valueOf(record.get(jobField)))) {
                                    record.put(JOB_LINK_KEY, PORTAL_CONST_CommunityUrls.JOB_DETAIL_URL + String.valueOf(record.get(jobField)));
                                }
                                if (record.get(CREATED_DATE_FIELD) != null) {
                                    record.put(SUBMISSION_DATE_KEY, String.valueOf(record.get(CREATED_DATE_FIELD)).split('T').get(0));
                                }
                                idToRecordMap.put(recordId, new Map<String, Object>{recordKey => record});
                            }
                        }
                    }
                    if (returnMap.containsKey(mainSection)) {
                        if (returnMap.containsKey(subSection)) {
                            returnMap.get(mainSection).get(subSection).putAll(idToRecordMap);
                        } else {
                            returnMap.get(mainSection).put(subSection, idToRecordMap);
                        }
                    } else {
                        returnMap.put(mainSection, new Map<String, Map<String, Map<String, Object>>>{subSection => idToRecordMap});
                    }
                }

            }
        }

        if (!linkedEntityIdSet.isEmpty()) {
            List<ContentDocumentLink> links = [SELECT LinkedEntityId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN :linkedEntityIdSet];
            for (ContentDocumentLink link : links) {

                String entityId = String.valueOf(link.LinkedEntityId);

                Map<String, Object> linkData = new Map<String, Object>();
                linkData.put(nameKey, link.ContentDocument.Title);
                linkData.put(linkKey, PORTAL_CommunityUtils.getBaseUrl() + '/sfc/servlet.shepherd/version/download/' + link.ContentDocument.LatestPublishedVersionId);

                //map the link back to the record it belongs to
                for (String mainSection : returnMap.keySet()) {
                    //go through the sections to get the idToRecordMap for that section to see if the linked entity id is in that idToRecordMap
                    Map<String, Map<String, Map<String, Object>>> sectionMap = returnMap.get(mainSection);
                    if (sectionMap != null) {
                        for (String subSection : sectionMap.keySet()) {
                            Map<String, Map<String, Object>> idToRecordMap = sectionMap.get(subSection);
                            if (idToRecordMap.containsKey(entityId)) {
                                if (idToRecordMap.get(entityId).containsKey(linksKey)) {
                                    ((List<Object>) idToRecordMap.get(entityId).get(linksKey)).add(linkData);
                                } else {
                                    idToRecordMap.get(entityId).put(linksKey, new List<Map<String, Object>>{linkData});
                                }
                            }
                        }
                    }
                }
            }
        }

        return returnMap;

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

    public virtual void withdrawApplication(Map<String, Object> params) {
        Id recordId = (Id) params.get(RECORD_ID_KEY);
        Id userId = UserInfo.getUserId();

        if (recordId != null && userId != null) {
            List<ucinn_portal_Job_Application__c> applicationList = [SELECT Id, CreatedById FROM ucinn_portal_Job_Application__c WHERE Id = :recordId AND CreatedById = :userId];
            if (applicationList.isEmpty()) {
                return;
            }
            ucinn_portal_Job_Application__c jobApplication = new ucinn_portal_Job_Application__c();
            jobApplication.Id = recordId;
            jobApplication.Status__c = WITHDRAWN_STATUS;
            update jobApplication;
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

    public virtual void changeApplicationStatus(Map<String, Object> params) {
        Id recordId = (Id) params.get(RECORD_ID_KEY);
        String status = (String) params.get('status');
        Id userId = UserInfo.getUserId();
        if (recordId != null && String.isNotBlank(status) && userId != null) {
            List<ucinn_portal_Job_Application__c> applicationList = [SELECT Id FROM ucinn_portal_Job_Application__c WHERE Id = :recordId AND Job__r.CreatedById = :userId];
            if (applicationList.isEmpty()) {
                return;
            }
            ucinn_portal_Job_Application__c jobApplication = new ucinn_portal_Job_Application__c();
            jobApplication.Id = recordId;
            jobApplication.Status__c = status;
            update jobApplication;
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

    public virtual Map<String, Map<String, List<Map<String, String>>>> getSearchFilterPicklists(Map<String, Object> params) {
        return PORTAL_CommunityUtils.SERVER_getPicklistEntries(new Map<String, Object> {PORTAL_CommunityUtils.PARAM_PICKLISTS => new Map<String, List<String>>{'ucinn_portal_Job__c' => new List<String>{'Class_Or_Degree_Level__c', 'Position_Type__c'}}});
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
    public virtual Map<String, Object> searchForJobWithFilters(Map<String, Object> params) {

        String radiusKey = 'radius';
        String cityKey = 'city';
        String stateKey = 'state';
        String postalCodeKey = 'postalCode';
        String keywordKey = 'keyword';
        String lowerBoundSalaryKey = 'lowerBoundSalary';
        String upperBoundSalaryKey = 'upperBoundSalary';
        String positionTypeKey = 'positionType';
        String classDegreeLevelKey = 'classDegreeLevel';
        String includeNullsKey = 'includeNulls';
        String multipleLocationsKey = 'multipleLocations';
        String isRemoteKey = 'isRemote';


        if (!params.containsKey('filterMap')) {
            return new Map<String, Object>();
        }

        Map<String, Object> filterCriteria = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(params.get('filterMap')));

        Date today = Date.today();

        String keyWord = (string)filterCriteria.get(keywordKey);

        if (String.isNotBlank(keyWord)) {
            keyWord = String.escapeSingleQuotes(keyWord);
        }

        Integer offset = 0;

        if (params.get(OFFSET_KEY) != null) {
            offset = Integer.valueOf(String.valueOf(params.get(OFFSET_KEY)));
        }

        String city = (String)filterCriteria.get(citykey);
        String state = (String)filterCriteria.get(stateKey);
        String postalCode = (String)filterCriteria.get(postalCodeKey);
        Double latitude;
        Double longitude;
        Integer radius = Integer.valueOf(filterCriteria.get(radiusKey)) == null || Integer.valueOf(filterCriteria.get(radiusKey)) <= 0 ? null : Integer.valueOf(filterCriteria.get(radiusKey));

        if (radius != null && (String.isNotBlank(city) || String.isNotBlank(state) || String.isNotBlank(postalCode)) && !Test.isRunningTest()) {
            String address = '';
            if (String.isNotBlank(city)) {
                address = address + city;
            }
            if (String.isNotBlank(state)) {
                if (String.isNotBlank(address)) {
                    address = address + ' , ' + state;
                } else {
                    address = state;
                }
            }
            if (String.isNotBlank(postalCode)) {
                address = address + ' ' + postalCode;
            }
            PORTAL_GeolocationHub geolocationHub = new PORTAL_GeolocationHub();
            Map<String, Object> locationMap = geolocationHub.geolocateSingleLineAddress(address);
            if (locationMap != null && !locationMap.isEmpty()) {
                latitude = (Double)locationMap.get(PORTAL_GeolocationHub.LATITUDE_KEY);
                longitude = (Double)locationMap.get(PORTAL_GeolocationHub.LONGITUDE_KEY);
            }
            if (latitude == null || longitude == null) {
                radius = null;
            }
        } else {
            radius = null;
        }

        String stringSalaryLowerBound = (String)filterCriteria.get(lowerBoundSalaryKey);
        String stringSalaryUpperBound = (String)filterCriteria.get(upperBoundSalaryKey);



        Decimal salaryLowerBound = String.isBlank(stringSalaryLowerBound) ? null : Decimal.valueOf(stringSalaryLowerBound);
        Decimal salaryUpperBound = String.isBlank(stringSalaryUpperBound) ? null : Decimal.valueOf(stringSalaryUpperBound);
        String positionType = (String)filterCriteria.get(positionTypeKey);
        String classDegreeLevel = (String)filterCriteria.get(classDegreeLevelKey);
        Boolean includeNulls = (Boolean) filterCriteria.get(includeNullsKey);
        Boolean multipleLocations = (Boolean)filterCriteria.get(multipleLocationsKey);
        Boolean includeRemoteLocations = (Boolean)filterCriteria.get(isRemoteKey);


        String locationCondition = radius == null ? '' : ' DISTANCE(Geolocation__c, GEOLOCATION(:latitude, :longitude), \'mi\') < :radius ';
        String cityCondition = radius != null || String.isBlank(city) ? '' : ' City__c = :city';
        String stateCondition = radius != null || String.isBlank(city) ? '' : ' State__c =:state';
        String postalCodeCondition = radius != null || String.isBlank(postalCode) ? '' : ' Postal_Code__c = :postalCode';

        String moneyLowerCondition = salaryLowerBound == null ? '' : ' Approximate_Salary__c >= ' + salaryLowerBound;
        String moneyUpperCondition = salaryUpperBound == null ? '' : ' Approximate_Salary__c <= ' + salaryUpperBound;
        String positionTypeCondition = (String.isBlank(positionType)) ? '' : ' Position_Type__c = \'' + positionType  + '\'';
        String levelCondition = (String.isBlank(classDegreeLevel)) ? '' : ' Class_Or_Degree_Level__c = \'' + classDegreeLevel + '\'';
        String includeNullsCondition = includeNulls != true ? '' : ' Approximate_Salary__c = null';
        String multipleLocationsCondition = multipleLocations != true ? '' : ' Has_Multiple_Locations__c = true';
        String remoteLocationCondition = includeRemoteLocations != true ? '' : ' Can_Work_Remote__c = true';


        List<String> conditions = new List<String>{locationCondition, cityCondition, stateCondition, postalCodeCondition, positionTypeCondition, levelCondition, multipleLocationsCondition, remoteLocationCondition};

        String moneyConditions = '';

        if (!String.isBlank(moneyLowerCondition)) {
            moneyConditions = moneyLowerCondition;
        }

        if (!String.isBlank(moneyUpperCondition)) {
            if (!String.isBlank(moneyConditions)) {
                moneyConditions = moneyConditions + ' AND ' + moneyUpperCondition;
            } else {
                moneyConditions = moneyUpperCondition;
            }
        }

        if (!String.isBlank(includeNullsCondition)) {

            if (!String.isBlank(moneyConditions)) {
                moneyConditions = '(' + moneyConditions + ')' + ' OR ' + includeNullsCondition;
            }
        }

        if (!String.isBlank(moneyConditions)) {
            moneyConditions = '(' + moneyConditions + ')';
        }

        conditions.add(moneyConditions);


        String whereClause = '';
        Boolean hasWhere = false;
        for (Integer index = 0; index < conditions.size(); index++) {

            if (String.isNotBlank(conditions[index])) {
                if (hasWhere == false) {
                    hasWhere = true;
                    whereClause = ' WHERE ' + conditions[index];
                } else {
                    whereClause = whereClause + ' AND ' + conditions[index];
                }
            }
        }

        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_SEARCH_PAGE_NAME, '', '');

        Set<String> fieldSet = new Set<String>();
        String orderByClause = '';
        Integer maxItems = 0;

        for (Portal_Page_Section_Setting__mdt sectionSetting : sectionSettingList) {

            //TODO update user story to say that they need to make sure that the where clause doesn't have overlapping conditions
            if (String.isNotBlank(sectionSetting.Where_Clause__c)) {
                if (String.isBlank(whereClause)) {
                    whereClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
                } else {
                    whereClause = whereClause + ' AND ' + PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Where_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => 'where', PORTAL_CommunityUtils.PARAM_REPLACEMENT => ''});
                }

            }
            if (String.isNotBlank(sectionSetting.Order_By_Clause__c)) {
                orderByClause = PORTAL_CommunityUtils.prefaceQueryClause(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CLAUSE => sectionSetting.Order_By_Clause__c, PORTAL_CommunityUtils.PARAM_PREFIX => 'order by', PORTAL_CommunityUtils.PARAM_REPLACEMENT => null});
            }
            if (sectionSetting.Max_Number_of_Query_Records__c != null) {
                maxItems = Integer.valueOf(sectionSetting.Max_Number_of_Query_Records__c);
            }

            if (sectionSetting.Portal_Section_Field_Settings__r != null) {
                for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                    if (String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                        fieldSet.add(fieldSetting.Field_API_Name__c);
                    }
                }
            }
        }

        Map<String, Object> returnMap = new Map<String, Object>();

        List<Map<String, Object>> returnJobList = new List<Map<String, Object>>();

        if (String.isNotBlank(keyword)) {
            String countQuery = 'FIND \'%' +  keyWord + '%\' IN ALL FIELDS RETURNING ucinn_portal_Job__c(' + String.join(new List<String>(fieldSet), ',') + ' ' + whereClause + ')';
            List<List<sObject>> count = Search.query(countQuery);
            returnMap.put(COUNT_KEY, count.isEmpty() ? 0 : count.get(0).size());

            String soslQuery = 'FIND ' + '\'' + keyWord + '\' IN ALL FIELDS RETURNING ucinn_portal_Job__c(' + String.join(new List<String>(fieldSet), ',') + ' ' + whereClause + ' ' + orderByClause;
            if (offset != null && offset > 0) {
                soslQuery = soslQuery + ' OFFSET ' + String.valueOf(offset);
            }
            soslQuery = soslQuery + ')';

            if (maxItems > 0) {
                soslQuery = soslQuery + ' LIMIT ' + String.valueOf(maxItems);
            }
            List<List<sObject>> jobs = Search.query(soslQuery);

            if (!jobs.isEmpty()) {
                for (sObject job : jobs.get(0)) {
                    Map<String, Object> jobMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(job));
                    jobMap.put(JOB_LINK_KEY,  PORTAL_CONST_CommunityUrls.JOB_DETAIL_URL + job.Id);
                    if (job.get(CREATED_DATE_FIELD) != null) {
                        jobMap.put(SUBMISSION_DATE_KEY, String.valueOf(job.get(CREATED_DATE_FIELD)).split(' ').get(0));
                    }
                    returnJobList.add(jobMap);
                }
            }
        } else {
            String countQuery = 'Select COUNT() From ucinn_portal_Job__c ' + whereClause;
            returnMap.put('count', Database.countQuery(countQuery));

            String queryString = 'SELECT Id, ' + String.join(new List<String>(fieldSet), ',') + ' FROM ucinn_portal_Job__c ' + whereClause + ' ' + orderByClause;

            if (maxItems > 0) {
                queryString = queryString + ' LIMIT ' + String.valueOf(maxItems);
            }

            if (offset != null && offset > 0) {
                queryString = queryString + ' OFFSET ' + String.valueOf(offset);
            }

            List<ucinn_portal_Job__c> jobList = Database.query(queryString);
            for (ucinn_portal_Job__c job : jobList) {
                Map<String, Object> jobMap = (Map<String, Object>) System.JSON.deserializeUntyped(System.JSON.serialize(job));
                jobMap.put(JOB_LINK_KEY,  PORTAL_CONST_CommunityUrls.JOB_DETAIL_URL + job.Id);
                if (job.get(CREATED_DATE_FIELD) != null) {
                    jobMap.put(SUBMISSION_DATE_KEY, String.valueOf(job.get(CREATED_DATE_FIELD)).split(' ').get(0));
                }
                returnJobList.add(jobMap);
            }
        }
        returnMap.put(PORTAL_CONST_PageSectionSetting.RECORD_KEY, returnJobList);
        returnMap.put(FRONT_END_DATA_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(sectionSettingList));
        return returnMap;

    }

    /**
     * method that publishes a draft job record
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param recordId:             the record id for the draft job
     * @return                      The master job Id.
     */
    public virtual String publishDraft(Map<String, Object> params) {
        Id recordId = (Id) params.get(RECORD_ID_KEY);
        if (recordId != null) {
            List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(JOB_POSTING_PAGE_NAME, '', '');
            Set<String> fields = new Set<String>();
            for (Portal_Page_Section_Setting__mdt sectionSetting : pageSectionList) {
                if (sectionSetting.SObject_API_Name__c == 'ucinn_portal_Job__c' && sectionSetting.Portal_Section_Field_Settings__r != null) {
                    for (Portal_Section_Field_Setting__mdt fieldSetting : sectionSetting.Portal_Section_Field_Settings__r) {
                        if (String.isNotBlank(fieldSetting.Field_API_Name__c)) {
                            fields.add(fieldSetting.Field_API_Name__c);
                        }
                    }
                }
            }
            String queryString = 'SELECT Id, Master_Job__c, Status__c, Case__c, ' + String.join(new List<String>(fields), ',') + ' FROM ucinn_portal_Job__c WHERE Id = :recordId';
            List<ucinn_portal_Job__c> jobList = Database.query(queryString);

            if (!jobList.isEmpty()) {
                ucinn_portal_Job__c draftJob = jobList.get(0);
                Id resultJobId = draftJob.Id;

                if ((draftJob.Status__c != DRAFT_STATUS || draftJob.Master_Job__c == null) && draftJob.Status__c != PENDING_STATUS) {
                    throw new AuraHandledException('This job is not a draft.');
                } 

                if (draftJob.Case__c != null) {
                    Case jobCase = new Case();
                    jobCase.Id = draftJob.Case__c;
                    jobCase.Status = APPROVED_STATUS;

                    update jobCase;
                }

                ucinn_portal_Job__c jobToUpdate = new ucinn_portal_Job__c();

                if (draftJob.Status__c == DRAFT_STATUS) {
                    ucinn_portal_Job__c masterJob = new ucinn_portal_Job__c();
                    masterJob.Id = draftJob.Master_Job__c;
                    for (String field : fields) {
                        masterJob.put(field, draftJob.get(field));
                    }

                    resultJobId = masterJob.Id;
                    jobToUpdate = masterJob;

                    delete draftJob;
                } else if (draftJob.Status__c == PENDING_STATUS) {
                    jobToUpdate = draftJob;
                }

                if (jobToUpdate != null) {
                    jobToUpdate.Status__c = POSTED_STATUS;

                    update jobToUpdate;
                }

                return resultJobId;
            }
        }

        return '';
    }

    private static Map<String, Object> queryForRecords(Id parentId, String pageName, Integer openOffset, Integer closedOffset, String openOffsetSection, String closedOffsetSection) {

        Map<String, Object> returnMap = new Map<String, Object>();

        List<Portal_Page_Section_Setting__mdt> pageSectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');
        Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> dynamicQueryMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>();


        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass openOffsetClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass(null, null, null, null, 0, openOffset, false);
        dynamicQueryMap.put(openOffsetSection, openOffsetClass);

        if(closedOffset != null && String.isNotBlank(closedOffsetSection)) {
            PORTAL_UTIL_PageSectionSetting.DynamicQueryClass closedOffsetClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass(null, null, null, null, 0, closedOffset, false);
            dynamicQueryMap.put(closedOffsetSection, closedOffsetClass);
        }


        Map<String, Map<String, List<Portal_Page_Section_Setting__mdt>>> pageSectionMap = PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionSettingList);
        //the records map contains two sections with different lists of records, where one list is the open applications and the second list is the list of closed applications
        Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(parentId, pageSectionMap, dynamicQueryMap, false, false);
        returnMap.put(RECORDS_MAP_KEY, recordsMap);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass overrideClass = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass(null, null, null, null, null, 0, true);
        Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass> overrideDynamicQueryMap = new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>();
        overrideDynamicQueryMap.put(openOffsetSection, overrideClass);
        if (String.isNotBlank(closedOffsetSection)) {
            overrideDynamicQueryMap.put(closedOffsetSection, overrideClass);
        }
        Map<String, Map<String, List<Map<String, Object>>>> allRecords = PORTAL_UTIL_PageSectionSetting.queryForRecords(parentId, pageSectionMap, overrideDynamicQueryMap, false, false);
        if (!allRecords.isEmpty() && allRecords.containsKey(openOffsetSection) && !allRecords.get(openOffsetSection).isEmpty() && allRecords.get(openOffsetSection).containsKey(PORTAL_CONST_PageSectionSetting.RECORD_KEY)) {
            returnMap.put(OPEN_COUNT_KEY, allRecords.get(openOffsetSection).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY).size());
        } else {
            returnMap.put(OPEN_COUNT_KEY, 0);
        }

        if (!allRecords.isEmpty() && allRecords.containsKey(closedOffsetSection) && !allRecords.get(closedOffsetSection).isEmpty() && allRecords.get(closedOffsetSection).containsKey(PORTAL_CONST_PageSectionSetting.RECORD_KEY)) {
            returnMap.put(CLOSED_COUNT_KEY, allRecords.get(closedOffsetSection).get(PORTAL_CONST_PageSectionSetting.RECORD_KEY).size());
        } else {
            returnMap.put(CLOSED_COUNT_KEY, 0);
        }

        returnMap.put(FRONT_END_DATA_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionSettingList));

        return returnMap;
    }
}