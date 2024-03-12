/*
 * Copyright (c) 2024, UC Innovation, Inc.  All Rights Reserved.
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
 * Base controller for portal file downloads
 * 
 * @author Jacob Huang
 * @since 1.19
 */
public without sharing virtual class PORTAL_FileDownloadControllerBase {
    public static final String COMPONENT_NAME = 'componentName';
    public static final String RECORDS_CONST = 'records';
    public static final String COLUMN_INFO = 'columnInfo';
    public static final String DOWNLOAD_URL = '/sfc/servlet.shepherd/version/download/';

    /**
     * Get the list of files available for the current portal user to download.
     *
     * @author Jacob Huang
     * @since 1.19
     *
     * @param componentName     String: Downloadable Content record component name to use 
     *
     * @return Map with records key, the list of {file name => download url}
     */
    public virtual Map<String, Object> getFilesForDownload(Map<String, Object> params) {
        Map<String, Object> fileInfoMap = new Map<String, Object>();
        String componentName = (String)params?.get(COMPONENT_NAME);

        if (String.isBlank(componentName)) {
            return fileInfoMap;
        }

        List<ucinn_portal_Downloadable_Content__c> downloadableContentList = [SELECT Id, Recipient__c FROM ucinn_portal_Downloadable_Content__c WHERE Component_Name__c = :componentName];
        Set<String> filteredContentIdSet = this.getFilteredDownloadableContentIdSet(downloadableContentList);
        return this.getFileInfoMap(filteredContentIdSet);
    }

    /**
     * Filter out downloadable content IDs that do not match recipient logic,
     * and return the IDs that do match or don't have a recipient lookup
     * 
     * @author Jacob Huang
     * @since 1.19
     * 
     * @param downloadableContentList       List<ucinn_portal_Downloadable_Content__c> with Id and recipient lookup field
     * 
     * @return set of downloadable content IDs that match recipient logic or don't have a recipient lookup
     */
    private Set<String> getFilteredDownloadableContentIdSet(List<ucinn_portal_Downloadable_Content__c> downloadableContentList) {
        Set<String> filteredDownloadableContentIdSet = new Set<String>();
        if (downloadableContentList == null || downloadableContentList.isEmpty()) {
            return filteredDownloadableContentIdSet;
        }

        Set<String> recipientIdSet = new Set<String>();
        for (ucinn_portal_Downloadable_Content__c eachContent : downloadableContentList) {
            recipientIdSet.add(eachContent.Recipient__c);
        }

        Set<String> matchingRecipientIdSet = PORTAL_UTIL_Recipients.getContentFiltersThatMatchConstituentAttributes(
            new Map<String, Object>{
                PORTAL_UTIL_Recipients.CONTACT_ID => PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId()).ContactId,
                PORTAL_UTIL_Recipients.RECIPIENT_ID_SET => recipientIdSet
            }
        );

        for (ucinn_portal_Downloadable_Content__c eachContent : downloadableContentList) {
            if (String.isBlank(eachContent.Recipient__c) || matchingRecipientIdSet.contains(eachContent.Recipient__c)) {
                filteredDownloadableContentIdSet.add(eachContent.Id);
            }
        }

        return filteredDownloadableContentIdSet;
    }

    /**
     * Get the list of file titles and download urls
     * 
     * @author Jacob Huang
     * @since 1.19
     * 
     * @param downloadableContentIdSet      Set<String>: downloadable content IDs to get the attached files for
     * 
     * @return Map with records key, the list of {file name => download url}
     */
    private Map<String, Object> getFileInfoMap(Set<String> downloadableContentIdSet) {
        Map<String, Object> fileInfoMap = new Map<String, Object>();
        if (downloadableContentIdSet == null || downloadableContentIdSet.isEmpty()) {
            return fileInfoMap;
        }

        String baseUrl = PORTAL_CommunityUtils.getBaseUrl();
        List<Map<String, Object>> recordList = new List<Map<String, Object>>();
        for (ContentDocumentLink eachContentDocumentLink : [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN :downloadableContentIdSet]) {
            Map<String, Object> documentMap = this.convertContentDocumentLink(baseUrl, eachContentDocumentLink);
            if (documentMap != null) {
                recordList.add(documentMap);
            }
        }

        fileInfoMap.put(RECORDS_CONST, recordList);
        return fileInfoMap;
    }

    /**
     * Helper method that converts a ContentDocumentLink record into a map for frontend
     * 
     * @author Jacob Huang
     * @since 1.19
     *
     * @param baseUrl           String: portal base URL, if empty the download url will be a relative link
     * @param documentLink      ContentDocumentLink record
     * 
     * @return Map of the file name mapped to the download URL, returns null if there's not enough data
     */
    protected virtual Map<String, Object> convertContentDocumentLink(String baseUrl, ContentDocumentLink documentLink) {
        if (baseUrl == null || documentLink == null || String.isBlank(documentLink.ContentDocument?.LatestPublishedVersionId) || String.isBlank(documentLink.ContentDocument?.Title)) {
            return null;
        }

        return new Map<String, Object>{
            documentLink.ContentDocument.Title => baseUrl + DOWNLOAD_URL + documentLink.ContentDocument.LatestPublishedVersionId
        };
    }
}