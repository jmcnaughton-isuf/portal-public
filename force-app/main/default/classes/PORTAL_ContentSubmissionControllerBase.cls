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
 * Base class containing logic for Content Submission.
 *
 * @author Aaron Wong
 * @version     1.0
 * @since       1.0
 */
global inherited sharing virtual class PORTAL_ContentSubmissionControllerBase {
    public static final String CASE_STATUS_RESUBMITTED = 'Resubmitted';
    public static final String FIELD_NAME = 'fieldName';
    public static final String FRONT_END_DATA_MAP_KEY = 'frontEndDataMap';
    public static final String LISTING_ID_KEY = 'listingId';
    public static final String LISTING_WRAPPER = 'listingWrapper';
    public static final String LISTING_WRAPPER_MAP = 'listingWrapperMap';
    public static final String MAIN_SECTION_NAME = 'mainSectionName';
    public static final String NEW_CONST = 'New';
    public static final String PAGE_NAME = 'pageName';
    public static final String PICKLISTS = 'picklists';
    public static final String CONTENT_VERSION_ID = 'contentVersionId';
    public static final String RECORD_ID = 'recordId';
    public static final String RECORD_TYPE = 'recordType';
    public static final String SUB_SECTION_NAME = 'subSectionName';
    public static final String WEB_CONST = 'Web';
    public static final String UPLOADED_FILES = 'uploadedFiles';
    public static final String NAME_CONST = 'name';
    public static final String DOCUMENT_ID = 'documentId';
    public static final String IS_CLONE = 'isClone';

    public static final String CLASS_NOTE = 'Class_Note';
    public static final String CLASS_NOTES = 'Class Notes';
    public static final String CONTENT_SUBMISSION_FORM = 'Content Submission Form';
    public static final String PERSONAL_INFORMATION = 'Personal_Information';
    public static final String DEGREE_INFO = 'degreeInfo';
    public static final String ID_CONST = 'Id';
    public static final String CONTENT_MODULE_METADATA = 'contentModuleMetadata';
    public static final String CLASS_NOTE_SUBMISSION = 'Class Note Submission';
    public static final String CONTENT_MODULE_NAME = 'contentModuleName';
    public static final Id FAKE_GUEST_ID = '000000000000000000';

    public static final String EVENT_CASE_QUEUE = 'Event Case Queue';
    public static final String QUEUE_CONST = 'Queue';

    public static final String ERROR_CONTACT_ADMIN = 'The server could not process your application. Please contact an administrator.';
    public static final String ERROR_NOT_FOUND = 'The server could not find the associated application.';

    /**
     * Sets up and retrieves data for content submission.
     *
     * @author Aaron wong
     *
     * @param pageName          The page name for the Portal Page Section Setting.
     * @param mainSectionName   The main section name for the Portal Page Section Setting.
     * @param subSectionName    The sub section name for the Portal Page Section Setting
     * @param recordId          The record Id of the Listing if editing a Listing.
     * @param recordType        The Record Type Developer Name of the Listing that is being submitted.
     * @param isClone           Whether the record retrieved using the recordId should be cloned
     * 
     * @return Map with frontEndDataMap, picklists, and (listingWrapperMap, uploadedFiles) OR (listingId)
     */
    public virtual Map<String, Object> initializeContentSubmission(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null || params.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }

        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        String recordId = (String)params.get(RECORD_ID);
        String recordType = (String)params.get(RECORD_TYPE);
        Boolean isClone = (String)params?.get(IS_CLONE) != null ? Boolean.valueOf((String)params.get(IS_CLONE)) : false;

        if (String.isBlank(pageName) || String.isBlank(mainSectionName) || String.isBlank(recordType)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (pageSectionList == null || pageSectionList.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});

        }

        resultMap.put(FRONT_END_DATA_MAP_KEY, PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionList));
        resultMap.put(PICKLISTS, PORTAL_UTIL_PageSectionSetting.getPicklists(pageSectionList));

        ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c(Status__c = PORTAL_CONST_Listing.LISTING_STATUS_TEMPORARY);

        if (String.isNotBlank(recordId)) {
            String whereClause = 'WHERE id = \'' + recordId + '\' ';
            PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = new PORTAL_UTIL_PageSectionSetting.DynamicQueryClass('', whereClause, '', '', null, null, false);

            String sectionToApply = subSectionName;
            if (String.isBlank(subSectionName)) {
                sectionToApply = mainSectionName;
            }

            Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(UserInfo.getUserId(), PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList), new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{sectionToApply => dynamicQueryObject}, false, true);
            
            if (isClone == true) {
                insert listing;
                resultMap.put(LISTING_WRAPPER_MAP, getClonedListingRecord(recordsMap, params, listing.Id));
            } else {
                resultMap.put(LISTING_WRAPPER_MAP, recordsMap);
                resultMap.put(UPLOADED_FILES, getAttachedContentDocuments(params));
            }
        } else {
            Id recordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName()
                              .get(recordType).getRecordTypeId();
            listing.RecordTypeId = recordTypeId;
            insert listing;

            resultMap.put(LISTING_ID_KEY, listing.Id);
        }

        return resultMap;
    }

    /**
     * Adds a new listing record Id to the listing records
     *
     * @author Todd Shinto
     * @since  1.19
     *
     * @param pageName          The page name for the Portal Page Section Setting.
     * @param mainSectionName   The main section name for the Portal Page Section Setting.
     * @param subSectionName    The sub section name for the Portal Page Section Setting.
     * @param recordId          The record Id of the Listing if editing a Listing.
     * @param recordType        The Record Type Developer Name of the Listing that is being submitted.
     * @param recordsMap        The records map retrieved by PORTAL_UTIL_PageSectionSetting.queryForRecords
     * @param listingId         The new listingId to replace the retrieved listing record
     * 
     * @return Map with frontEndDataMap, picklists, and (listingWrapperMap, uploadedFiles) OR (listingId)
     */
    public virtual Map<String, Map<String, List<Map<String, Object>>>> getClonedListingRecord(Map<String, Map<String, List<Map<String, Object>>>> recordsMap, Map<String, Object> params, Id listingId) {
        if (recordsMap == null || recordsMap.isEmpty()) {
            return recordsMap;
        }
        
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        String recordsKey = PORTAL_CONST_PageSectionSetting.RECORDS_CONST;

        if (String.isNotBlank(subSectionName)) {
            recordsKey = subSectionName;
        }

        Map<String, Object> listingRecordToClone = recordsMap.get(mainSectionName).get(recordsKey)[0];
        listingRecordToClone.put(PORTAL_CONST_PageSectionSetting.ID_CONST, listingId);
        listingRecordToClone.put(PORTAL_CONST_LISTING.STATUS_API_NAME, PORTAL_CONST_Listing.LISTING_STATUS_TEMPORARY);

        return recordsMap;
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
    public virtual Map<String, Object> initializeClassNoteSubmission(Map<String, Object> params) {
        Map<String, Object> initializationParams = new Map<String, Object>{
            PAGE_NAME => CLASS_NOTES,
            MAIN_SECTION_NAME => CONTENT_SUBMISSION_FORM,
            RECORD_TYPE => CLASS_NOTE
        };

        Map<String, Object> resultMap = this.initializeContentSubmission(initializationParams);
        resultMap.put(LISTING_WRAPPER_MAP, this.getInitialClassNoteWrapperMap((String)resultMap.get(LISTING_ID_KEY)));

        PORTAL_StaticContentControllerBase staticContentController = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();
        resultMap.put(CONTENT_MODULE_METADATA, staticContentController.getContentModuleMetadata(new Map<String, Object>{
            PORTAL_StaticContentControllerBase.PARAM_PAGE_NAME => CLASS_NOTE_SUBMISSION,
            PORTAL_StaticContentControllerBase.PARAM_MODULE_NAME => (String)params?.get(CONTENT_MODULE_NAME)
        }));

        return resultMap;
    }

    /**
     * Get the information needed for submitting another class note. For now, it's just making a new temporary listing.
     * 
     * @author                  Jacob Huang
     * @since                   1.18
     * 
     * @return                  Map with new listingId 
     */
    public virtual Map<String, Object> resetClassNoteSubmission(Map<String, Object> params) {
        ucinn_portal_Listing__c listing = new ucinn_portal_Listing__c(
            RecordTypeId = Schema.SObjectType.ucinn_portal_Listing__c.getRecordTypeInfosByDeveloperName().get(CLASS_NOTE).getRecordTypeId(),
            Status__c = PORTAL_CONST_Listing.LISTING_STATUS_TEMPORARY
        );

        insert listing;

        return new Map<String, Object>{LISTING_ID_KEY => listing.Id};
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
    public virtual void attachContentDocument(Map<String, Object> params) {
        String contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.ContactId;
        if (String.isNotBlank(contactId)) {
            return;
        }

        String contentVersionId = (String)params?.get(CONTENT_VERSION_ID);
        String recordId = (String)params?.get(RECORD_ID);
        List<ContentVersion> contentVersionList = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId];

        if (contentVersionList == null || contentVersionList.isEmpty()) {
            return;
        }

        insert new ContentDocumentLink(ContentDocumentId = contentVersionList[0].ContentDocumentId, LinkedEntityId = recordId);
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
    public virtual void submitContent(Map<String, Object> params){
        if (params == null || params.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }

        PORTAL_RecaptchaController recaptchaController = (PORTAL_RecaptchaController)PORTAL_Utils.getControllerFactory().getRecaptchaController();
        recaptchaController.verifyRecaptcha('PORTAL_ContentSubmissionControllerBase.submitContent', (String)params?.get(PORTAL_RecaptchaController.RECAPTCHA_TOKEN));

        Map<Object, Object> listingWrapper = (Map<Object, Object>)params.get(LISTING_WRAPPER);
        String pageName = (String)params.get(PAGE_NAME);
        String mainSectionName = (String)params.get(MAIN_SECTION_NAME);
        String subSectionName = (String)params.get(SUB_SECTION_NAME);
        String recordId = (String)params.get(RECORD_ID);

        if (listingWrapper == null || listingWrapper.isEmpty() || String.isBlank(pageName) || String.isBlank(mainSectionName)) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }

        List<Portal_Page_Section_Setting__mdt> pageSectionList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, mainSectionName, subSectionName);

        if (pageSectionList == null || pageSectionList.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }


        // eventDescription => {fieldName => Header_Content__c, isPicklist => true, ...}
        Map<String, Object> frontEndDataMap = PORTAL_UTIL_PageSectionSetting.getFrontEndDataMap(pageSectionList);

        if (frontEndDataMap == null || frontEndDataMap.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }

        ucinn_portal_Listing__c listingToUpsert = new ucinn_portal_Listing__c();

        for (Object eachListingAttribute : listingWrapper.keySet()) {
            if (frontEndDataMap.containsKey((String)eachListingAttribute)) {
                Map<String, Object> eachFrontEndData = (Map<String, Object>)frontEndDataMap.get((String)eachListingAttribute);

                if (String.isNotBlank((String)eachFrontEndData.get(FIELD_NAME))) {
                    listingToUpsert.put((String)eachFrontEndData.get(FIELD_NAME), listingWrapper.get((String)eachListingAttribute));
                }
            }
        }

        if (isValidSubmittedListing(recordId) == false) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_CONTACT_ADMIN});
        }

        listingToUpsert.Status__c = PORTAL_CONST_Listing.LISTING_STATUS_PENDING;

        if (String.isNotBlank(recordId)) {
            listingToUpsert.Id = recordId;
            // Creates a new case if one doesn't exist for the listing, otherwise updates existing case
            String caseId = handleCaseLogic(recordId);

            if (String.isNotBlank(caseId)) {
                listingToUpsert.Case__c = caseId;
            }
        }

        upsert listingToUpsert;
    }

    /**
     * Gets content submitted by the user.
     *
     * @author Aaron Wong
     *
     * @param pageName              The page name of the Portal Page Section Custom Metadata.
     * @param mainSectionName       The main section name of the Portal Page Section Custom Metadata.
     * @param subSectionName        The sub section name of the Portal Page Section Custom Metadata.
     * @return                      List of submitted content.
     * @since                       1.0
     */
    public virtual List<Map<String, Object>> getMySubmittedContent(Map<String, Object> params) {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();

        User usr = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId());

        if (usr == null) {
            return resultList;
        }

        Id userContactId = usr.ContactId;

        if (String.isBlank(usr.ContactId) || params == null || params.isEmpty()) {
            return resultList;
        }

        Map<Object, Object> additionalParams = new Map<Object, Object>{PORTAL_ListingControllerBase.CREATED_BY_USER_ID => usr.Id};

        params.put(PORTAL_ListingControllerBase.ADDITIONAL_PARAMS, additionalParams);

        PORTAL_ListingControllerBase listingController = (PORTAL_ListingControllerBase)PORTAL_Utils.getControllerFactory().getListingController();

        return listingController.getListings(params);
    }

    /**
     * Get information from the ContentDocument records (aka uploaded files) attached to the specified record ID
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param recordId    String: record ID of a record (likely a Listing here in this controller) whose files are desired
     * 
     * @return List<Map<String, Object>> with each file's name (of form title.ext) and documentId.
     *         These key names match the keys returned by the frontend lightning-file-upload component
     */
    public virtual List<Map<String, Object>> getAttachedContentDocuments(Map<String, Object> params) {
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        String linkedEntityId = (String) params?.get(RECORD_ID);
        if (String.isBlank(linkedEntityId)) {
            return returnList;
        }
        linkedEntityId = String.escapeSingleQuotes(linkedEntityId);

        for (ContentDocumentLink eachContentDocumentLink : [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId = :linkedEntityId]) {
            String fileExtension = String.isNotBlank(eachContentDocumentLink.ContentDocument.FileExtension) ? ('.' + eachContentDocumentLink.ContentDocument.FileExtension) : '';
            returnList.add(new Map<String, Object>{
                NAME_CONST => eachContentDocumentLink.ContentDocument.Title + fileExtension,
                DOCUMENT_ID => eachContentDocumentLink.ContentDocumentId
            });
        }

        return returnList;
    }

    /**
     * Creates a new Case for a listing.
     *
     * @author Aaron Wong
     *
     * @param recordType    The record type developer name of the listing.
     * @return              The Id of the case.
     * @since               1.0
     */
    private static String createCaseForNewListing(String recordType) {
        if (String.isBlank(recordType)) {
            return '';
        }

        Id userId = UserInfo.getUserId();
        User usr = [SELECT Id, ContactId FROM User WHERE Id = :userId];

        Id userContactId = usr.ContactId;

        String subject = 'A new ' + recordType + ' has been submitted for approval';

        List<Group> groupList = [SELECT Id
                                 FROM Group
                                 WHERE Type = :QUEUE_CONST
                                 AND Name = :EVENT_CASE_QUEUE LIMIT 1];

        String groupId = null;

        if (groupList != null && !groupList.isEmpty()) {
            groupId = groupList.get(0).Id;
        }

        Case newCase = new Case (Origin = WEB_CONST,
                                 Subject = subject,
                                 Status = NEW_CONST,
                                 Type = recordType,
                                 ContactId = userContactId);

        if (String.isNotBlank(groupId)) {
            newCase.OwnerId = groupId;
        }

        insert newCase;
        return newCase.Id;
    }

    /**
     * Handles the case logic for submitting content.
     *
     * @author Aaron Wong
     *
     * @param listingId     Id of the listing.
     * @return              Id of the case.
     * @since               1.0
     */
    private static String handleCaseLogic(String listingId) {
        if (String.isBlank(listingId)) {
            return '';
        }

        List<ucinn_portal_Listing__c> listingList = [SELECT Id, Case__c, Case__r.Status, RecordType.DeveloperName
                                                     FROM ucinn_portal_Listing__c
                                                     WHERE Id = :listingId LIMIT 1];

        if (listingList.isEmpty()) {
            throw PORTAL_CommunityUtils.generateCustomErrorMessage(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_NOT_FOUND});
        }

        ucinn_portal_Listing__c listingRecord = listingList.get(0);

        // If a case is present, the listing was submitted through content submission and is being adjusted.
        if (String.isNotBlank(listingRecord.Case__c)) {
            listingRecord.Case__r.Status = CASE_STATUS_RESUBMITTED;
            update listingRecord.Case__r;

            return listingRecord.Case__c;
        }

        return createCaseForNewListing(listingRecord.RecordType.DeveloperName);
    }

    /**
     * Checks if the submitted listing is valid.
     *
     * @author Aaron Wong
     *
     * @param listingId     Id of the listing to check.
     * @return              If the listing is valid or not.
     * @since               1.0
     */
    private static Boolean isValidSubmittedListing(String listingId) {
        if (String.isBlank(listingId)) {
            return true;
        }

        List<ucinn_portal_Listing__c> listingList = [SELECT Status__c
                                                     FROM ucinn_portal_Listing__c
                                                     WHERE Id = :listingId];

        if (listingList == null || listingList.isEmpty()) {
            return false;
        }

        if (listingList.get(0).Status__c == PORTAL_CONST_Listing.LISTING_STATUS_PUBLISHED) {
            return false;
        }

        return true;
    }

    /**
     * Get the class note listing wrapper with initial fields populated.
     * Prepopulate the listing ID, and an authenticated user's personal info using page section settings
     * 
     * @author Jacob Huang
     * @since 1.18
     *
     * @param newListingId      String: Id of new class note listing with temporary status. Add the Id to the return value
     * 
     * @return map of frontend field Id to value for the class note fields that can be prepopulated
     */
    private Map<String, Object> getInitialClassNoteWrapperMap(String newListingId) {
        String contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.ContactId;
        PORTAL_PageSectionAdapter personalInformationAdapter = new PORTAL_PageSectionAdapter.Builder()
            .buildPageName(CLASS_NOTES)
            .buildMainSectionName(PERSONAL_INFORMATION)
            .buildParentFieldId(String.isNotBlank(contactId) ? contactId : FAKE_GUEST_ID)
            .build();

        List<Map<String, Object>> contactList = personalInformationAdapter?.getRecords()?.get(PERSONAL_INFORMATION)?.get(PORTAL_CONST_PageSectionSetting.RECORDS_CONST);
        Map<String, Object> classNoteWrapper = (contactList != null && !contactList.isEmpty()) ? contactList.get(0) : new Map<String, Object>();

        // merge the first element of the degreeInfo related list and remove the rest of the list
        List<Object> degreeList = (List<Object>)classNoteWrapper.remove(DEGREE_INFO);
        Map<String, Object> degreeMap = (degreeList != null && !degreeList.isEmpty()) ? (Map<String, Object>)degreeList.get(0) : new Map<String, Object>();
        classNoteWrapper.putAll(degreeMap);

        classNoteWrapper.put(ID_CONST, newListingId);

        return classNoteWrapper;
    }
}