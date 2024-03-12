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
 * Utility Class containing logic for converting rich text fields' images into URLs
 * that can be viewed by guest users with sharing rules.
 *
 * @author Sam Longo
 * @version 1.0
 * @since   1.0
 */
public inherited sharing class PORTAL_UTIL_DocumentImageHelper {
    private static final String RTA_FIELD_METADATA_DEVELOPER_NAME = 'Listing_RTA_Fields_with_Images';
    private static final String IMAGE_HTML_REG_EX = '(?:<img[^>]*src=[\'"]([^\'"]*)[\'"])[^>]*\\/?>';
    private static final String ASSET_FILE_REG_EX = '.*\\/file-asset\\/([a-zA-z0-9]*).*';
    private static final String REG_EX_CUSTOM_METADATA = 'Listing_Downloaded_RTA_Image_Reg_Ex';

    public class UrlInfo {
        public String assetDeveloperName;
        public String contentVersionId;
        public String fieldToChange;
        public String newUrl;
        public string originalUrl;

        public Sobject record;

        public UrlInfo(Sobject record, String fieldToChange, String originalUrl) {
            this.record = record;
            this.fieldToChange = fieldToChange;
            this.originalUrl = originalUrl;
        }
    }


    /**
    *
    * Takes in a list of Sobjects from a trigger and the SObject type.
    * Replaces the images with document links
    *
    * @param    newList                         old records. Null if from Delete trigger
    * @param    oldList                         new records. Null if from Insert trigger
    * @param    objectApiName                   object api name so it can be searched for rich text fields
    *
    * @author Sam Longo
    *
    */
    public static void updateImages(List<SObject> newList, List<SObject> oldList, SObjectType objectType) {

        if (objectType == null) {
            System.debug('No Object type passed to updateImages');
            return;
        }

        if (newList != null && newList.size() == 0) {
            newList = null;
        }

        if (oldList != null && oldList.size() == 0) {
            oldList = null;
        }

        Map<String, String> imageFieldToAltTextFieldMap = getImageFieldToAltTextFieldMap(objectType);

        List<UrlInfo> urlInfoListToDelete = new List<UrlInfo>();
        List<UrlInfo> urlInfoListToAdd = new List<UrlInfo>();

        String imgAltTextRegex = '<img.*?alt="(.*?)"';
        Pattern altTextPattern = Pattern.compile(imgAltTextRegex);
        if (newList != null && oldList == null) {
            for (SObject record : newList) {
                for (String eachImageField : imageFieldToAltTextFieldMap.keySet()) {
                    if (record.get(eachImageField) != null) {
                        addUrlInfos(urlInfoListToAdd, record, eachImageField);
                        updateImageAltText(null, record, altTextPattern, eachImageField, imageFieldToAltTextFieldMap.get(eachImageField));
                    }
                }
            }
        }
        else if (newList != null && oldList != null) {
            Map<Id, SObject> oldMap = new Map<Id, SObject>(oldList);
            for (Integer recordIndex = 0; recordIndex < newList.size(); recordIndex++) {
                List<UrlInfo> oldUrlInfoList = new List<UrlInfo>();
                List<UrlInfo> newUrlInfoList = new List<UrlInfo>();

                SObject newRecord = newList.get(recordIndex);
                SObject oldRecord = oldMap.get(newRecord.Id);

                for (String eachImageField : imageFieldToAltTextFieldMap.keySet()) {
                    if (newRecord.get(eachImageField) != oldRecord.get(eachImageField)) {
                        addUrlInfos(oldUrlInfoList, oldRecord, eachImageField);
                        addUrlInfos(newUrlInfoList, newRecord, eachImageField);
                        updateImageAltText(oldRecord, newRecord, altTextPattern, eachImageField, imageFieldToAltTextFieldMap.get(eachImageField));
                    }
                }

                splitUrlInfoList(urlInfoListToAdd, urlInfoListToDelete, newUrlInfoList, oldUrlInfoList);
            }
        }
        else if (newList == null && oldList != null) {
            for (SObject record : oldList) {
                for (String eachField : imageFieldToAltTextFieldMap.keySet()) {
                    if (record.get(eachField) != null) {
                        addUrlInfos(urlInfoListToDelete, record, eachField);
                    }
                }
            }
        }

        String communityUrl = PORTAL_CommunityUtils.getPortalURL();

        if (!urlInfoListToAdd.isEmpty()) {
            getImageUrls(urlInfoListToAdd, communityUrl);
            setRecordImages(urlInfoListToAdd);
        }

        if (!urlInfoListToDelete.isEmpty()) {
            deleteImages(urlInfoListToDelete);
        }
    }

    /**
     * finds and returns the entirety of the first image url for a provided html string
     *
     * @param htmlString            The string being parsed for the first Url occurance
     * @return the url of the first image stored in the provided html string
     */
    public static String getUrlFromImageHtml(String htmlString) {

        if (String.isBlank(htmlString)) {
            return '';
        }

        String imgUrl = '';
        String imgUrlRegex = '<img.*?src="(.*?)"';
        Pattern urlPattern = Pattern.compile(imgUrlRegex);

        Matcher urlMatcher = urlPattern.matcher(htmlString);

        if (urlMatcher.find()) {
            imgUrl = urlMatcher.group(1);
        }

        return imgUrl;
    }

    /**
     * finds all the rich text fields on the record via schema describes and adds them to a map
     * the alt text field must be in the form FIELD_API_Alt_Text__c when the rich text field is FIELD_API__C
     *
     * @param   objectApiName       API name string for the object being processed
     *
     * @return  Map<String, String> of rich text fields to their alt text field
     *
     * @author Sam Longo
     */
    private static Map<String, String> getImageFieldToAltTextFieldMap(SObjectType objectType) {
        Map<String, String> imageFieldToAltTextFieldMap = new Map<String, String>();

        if (objectType == null) {
            System.debug('Did not pass object Type to getImageFieldToAltTextFieldMap');
            return imageFieldToAltTextFieldMap;
        }

        Map<String, Schema.SObjectField> fieldMap =  objectType.getDescribe().fields.getMap();

        for (String eachFieldApi : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(eachFieldApi).getDescribe();
            if (fieldDescribe.type == Schema.DisplayType.TEXTAREA && fieldDescribe.isHtmlFormatted()) {
                String altTextFieldName = eachFieldApi.replace('__c', '_Alt_Text__c');
                if (fieldMap.containsKey(altTextFieldName)) {
                    imageFieldToAltTextFieldMap.put(eachFieldApi, altTextFieldName);
                } else {
                    imageFieldToAltTextFieldMap.put(eachFieldApi, null);
                }
            }
        }

        return imageFieldToAltTextFieldMap;
    }

        /**
     * Replaces the image URLs in the listing with the new URL
     *
     * @author Sam Longo
     *
     * @param urlInfoList   List of URLInfo objects.
     * @since               1.0
     */
    private static void setRecordImages(List<UrlInfo> urlInfoList) {
        for (UrlInfo urlInfo : urlInfoList) {
            String originalUrl = urlInfo.originalUrl;
            String newUrl = urlInfo.newUrl;
            String fieldToChange = urlInfo.fieldToChange;
            SObject recordToChange = urlInfo.record;

            // Replace url if there is a new url
            if (String.isNotBlank(newUrl)) {
                String fieldValue = ((String)recordToChange.get(fieldToChange)).replace(originalUrl, newUrl);
                recordToChange.put(fieldToChange, fieldValue);
            }
        }
    }

    /**
     * Gets regex for parsing downloaded Image URLs.
     *
     * @author Aaron Wong
     *
     * @return      Regular Expression.
     * @since       1.0
     */
    public static String getDownloadedRTAImageRegEx() {
        List<Portal_Organization_Setting__mdt> orgSettingList = [SELECT Value__c FROM Portal_Organization_Setting__mdt WHERE DeveloperName = :REG_EX_CUSTOM_METADATA];

        if (orgSettingList == null || orgSettingList.isEmpty()) {
            return '.*\\/servlet\\.shepherd\\/version\\/download\\/([a-zA-z0-9]*).*';
        }

        return orgSettingList.get(0).Value__c;
    }

    /**
    *
    * Will populate image with alternative text if both are supplied, If image is only supplied in record it will pull out the alt text and place it in the
    * alt text field.
    *
    * @param    oldRecord               old record provided by the trigger. Null if from insert trigger
    * @param    newRecord               new record provided by the trigger.
    * @param    imgAltTextPattern       Pattern for finding alt text withing an image
    * @param    imgFieldName            field name for where the image is stored
    * @param    imgAltTextFieldName     field name for where the image alt text is stored
    *
    * @author Sam Longo
    * @since       1.0
    */
    private static void updateImageAltText(SObject oldRecord, SObject newRecord, Pattern imgAltTextPattern, String imgFieldName, String imgAltTextFieldName) {

        if (String.isBlank(imgAltTextFieldName) || String.isBlank(imgFieldName) || newRecord == null) {
            return;
        }

        String imgAltText = '';
        if (newRecord.get(imgFieldName) != null) {
            Matcher altTextMatcher = imgAltTextPattern.matcher((String)newRecord.get(imgFieldName));

            if (altTextMatcher.find()) {
                imgAltText = altTextMatcher.group(1);
            }
        }

        String newAltTextString = '';
        if (newRecord.get(imgAltTextFieldName) != null && String.isNotBlank((String)newRecord.get(imgAltTextFieldName))) {
            newAltTextString = (String)newRecord.get(imgAltTextFieldName);
        }

        if (String.isNotBlank((String)newRecord.get(imgFieldName)) && String.isNotBlank(newAltTextString)) {
            // If any update in the two field (rich text field or it's alt text field) or insert, pull header image alt text and put it in the header image
            if (oldRecord == null || newRecord.get(imgAltTextFieldName) != oldRecord.get(imgAltTextFieldName) ||
                    newRecord.get(imgFieldName) != oldRecord.get(imgFieldName)) {
                newRecord.put(imgFieldName, updateImgTagAltText(newRecord, imgAltText, newAltTextString, imgFieldName));
            }
        } else if (String.isNotBlank((String)newRecord.get(imgFieldName)) && String.isBlank((String)newRecord.get(imgAltTextFieldName)) && String.isNotBlank(imgAltText)) {
            //only image field is populated so we put whatever alt text exists into the alt text field so its visible on overview
            newRecord.put(imgAltTextFieldName, imgAltText);
        }
    }

    /**
     * replaces the img tag if it exists with the new alt text string
     *
     * @author Sam Longo
     * @version 1.0
     * @since 1.0
     *
     * @param newRecord         record to update
     * @param imgAltText        old alt text to replace
     * @param newAltTextString  new alt text string
     * @param imgFieldName      rich text field api name
     *
     * @return                  image field string
     *
     */
    @TestVisible
    private static String updateImgTagAltText(SObject newRecord, String imgAltText, String newAltTextString, String imgFieldName) {
        String newImageString = '';

        if (String.isBlank(imgAltText)) {
            newImageString = ((String)newRecord.get(imgFieldName)).replace('<img', '<img alt="' + newAltTextString + '"');
        } else {
            newImageString = ((String)newRecord.get(imgFieldName)).replace(imgAltText, newAltTextString);
        }

        return newImageString;
    }

    /**
     * Uses regex to find image Urls and adds URLInfos to the URL info list.
     *
     * @author Aaron Wong
     *
     * @param urlInfoList       List of URLInfo objects to add to.
     * @param record            record to get URL Info for.
     * @param fieldName         Field on record to get URL Info for.
     * @return urlInfoList       List of URLInfos with additional URLInfos in the record appended.
     * @since                   1.0
     */
    public static List<UrlInfo> addUrlInfos(List<UrlInfo> urlInfoList, SObject record, String fieldName) {
        String regex = IMAGE_HTML_REG_EX;

        if (record == null || (String)record.get(fieldName) == null) {
            return urlInfoList;
        }

        if (urlInfoList == null) {
            urlInfoList = new List<UrlInfo>();
        }

        Matcher m = Pattern.compile(regex).matcher((String)record.get(fieldName));
        while (m.find()) {
            UrlInfo newUrlInfo = new UrlInfo(record, fieldName, m.group(1));
            urlInfoList.add(newUrlInfo);
        }

        return urlInfoList;
    }

    /**
     * Splits the URL infos to a list of URL infos that were added, and a list of URL infos that were deleted.
     *
     * @author Aaron Wong
     *
     * @param urlInfoListToAdd      List of URL infos that were added to the record.
     * @param urlInfoListToDelete   List of URL infos that were deleted from the record.
     * @param newUrlInfoList        List of URL infos found in the new record record on the trigger.
     * @param oldUrlInfoList        List of URL infos found in the old record record on the trigger.
     */
    private static void splitUrlInfoList(List<UrlInfo> urlInfoListToAdd, List<UrlInfo> urlInfoListToDelete, List<UrlInfo> newUrlInfoList, List<UrlInfo> oldUrlInfoList) {
        if (urlInfoListToAdd == null || urlInfoListToDelete == null || newUrlInfoList == null || oldUrlInfoList == null) {
            return;
        }

        Set<String> newUrlSet = new Set<String>();
        Set<String> oldUrlSet = new Set<String>();

        // Populate set of urls in new record and set of urls in old record
        for (UrlInfo newUrlInfo : newUrlInfoList) {
            newUrlSet.add(newUrlInfo.originalUrl);
        }

        for (UrlInfo oldUrlInfo : oldUrlInfoList) {
            oldUrlSet.add(oldUrlInfo.originalUrl);
        }

        // Check for new urls
        for (UrlInfo newUrlInfo : newUrlInfoList) {
            if (!oldUrlSet.contains(newUrlInfo.originalUrl)) {
                urlInfoListToAdd.add(newUrlInfo);
            }
        }

        // Check for removed urls
        for (UrlInfo oldUrlInfo : oldUrlInfoList) {
            if (!newUrlSet.contains(oldUrlInfo.originalUrl)) {
                urlInfoListToDelete.add(oldUrlInfo);
            }
        }
    }

    /**
     * Generates new image URLs based on the format of the original URL.
     *
     * @author Aaron Wong
     *
     * @param urlInfoList   List of URLInfo objects.
     * @param communityUrl  Community URL to use for new URLs.
     * @since               1.0
     */
    private static void getImageUrls(List<UrlInfo> urlInfoList, String communityUrl) {
        String versionUrlRegEx = getDownloadedRTAImageRegEx();
        List<UrlInfo> assetUrlInfoList = new List<UrlInfo>();
        List<UrlInfo> downloadedUrlInfoList = new List<UrlInfo>();
        Set<String> contentVersionIdSet = new Set<String>();

        for (UrlInfo urlInfo : urlInfoList) {
            Matcher versionMatcher = Pattern.compile(versionUrlRegEx).matcher(urlInfo.originalUrl);
            Matcher assetMatcher = Pattern.compile(ASSET_FILE_REG_EX).matcher(urlInfo.originalUrl);

            // Downloaded file logic
            if (versionMatcher.matches()) {
                Id contentVersionId = versionMatcher.group(1);
                urlInfo.contentVersionId = contentVersionId;
                contentVersionIdSet.add(contentVersionId);

                downloadedUrlInfoList.add(urlInfo);
            } else if (assetMatcher.matches()) {
                String assetName = assetMatcher.group(1);

                urlInfo.assetDeveloperName = assetName;
                assetUrlInfoList.add(urlInfo);
            } else {
                urlInfo.newUrl = getImageUrl(urlInfo.originalUrl, communityUrl);
            }
        }

        insertDocumentLinksFromAssets(assetUrlInfoList);

        List<ContentVersion> contentVersionList = [SELECT id, ContentDocumentId, Title, VersionNumber,
                                                    ContentDocument.ContentAssetId, ContentDocument.ContentAsset.DeveloperName
                                                    FROM ContentVersion
                                                    WHERE id IN :contentVersionIdSet];
        List<ContentAsset> assetListToInsert = new List<ContentAsset>();
        Map<String, String> contentVersionIdToUrlMap = new Map<String, String>();
        Map<String, ContentVersion> idToContentVersionMap = new Map<String, ContentVersion>();
        Map<String, ContentAsset> contentDocumentIdToContentAssetMap = new Map<String, ContentAsset>();

        // Create assets for asset files
        for (ContentVersion contentVersionRecord : contentVersionList) {
            if (String.isBlank(ContentVersionRecord.ContentDocument.ContentAssetId)) {
                ContentAsset newAsset = new ContentAsset(Masterlabel = 'e' + contentVersionRecord.id + 'e',
                                                            DeveloperName = 'e' + contentVersionRecord.id + 'e',
                                                            IsVisibleByExternalUsers = true,
                                                            Language = 'en_US');
                assetListToInsert.add(newAsset);
                contentDocumentIdToContentAssetMap.put(contentVersionRecord.ContentDocumentId, newAsset);

                // URL based on asset developer name
                contentVersionIdToUrlMap.put(contentVersionRecord.id, createAssetFileLink(newAsset.DeveloperName, contentVersionRecord.VersionNumber, communityUrl));
            } else {
                contentVersionIdToUrlMap.put(contentVersionRecord.id, createAssetFileLink(contentVersionRecord.ContentDocument.ContentAsset.DeveloperName,
                                                                                        contentVersionRecord.VersionNumber,
                                                                                        communityUrl));
            }
            idToContentVersionMap.put(contentVersionRecord.id, contentVersionRecord);
        }

        insert assetListToInsert;

        List<ContentDocument> contentDocumentListToUpdate = new List<ContentDocument>();

        // update ContentDocument objects
        for (String contentDocumentId : contentDocumentIdToContentAssetMap.keySet()) {
            ContentAsset contentAssetRecord = contentdocumentIdToContentAssetMap.get(contentDocumentId);

            ContentDocument contentDocumentRecord = new ContentDocument(id = contentDocumentId, ContentAssetId = contentAssetRecord.Id);
            contentDocumentListToUpdate.add(contentDocumentRecord);
        }

        update contentDocumentListToUpdate;

        List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
        Map<String, Set<String>> versionIdToRecordIdSetMap = new Map<String, Set<String>>();

        // Set new URLs
        for (UrlInfo urlInfo : downloadedUrlInfoList) {
            if (contentVersionIdToUrlMap.containsKey(urlInfo.contentVersionId)) {
                urlInfo.newUrl = contentVersionIdToUrlMap.get(urlInfo.contentVersionId);
            }

            // Create ContentDocumentLinks to know that the file is linked to this record
            if (idToContentVersionMap.containsKey(urlInfo.contentVersionId)) {
                // Check to make sure no duplicate ids added
                if (!versionIdToRecordIdSetMap.containsKey(urlInfo.contentVersionId)) {
                    Set<String> recordIdSet = new Set<String>();
                    recordIdSet.add(urlInfo.record.id);
                    versionIdToRecordIdSetMap.put(urlInfo.contentVersionId, recordIdSet);
                    contentDocumentLinkList.add(new ContentDocumentLink(ContentDocumentId = idToContentVersionMap.get(urlInfo.contentVersionId).ContentDocumentId,
                                                                        LinkedEntityId  = urlInfo.record.id,
                                                                        ShareType='V',
                                                                        Visibility='AllUsers'));
                } else {
                    Set<String> recordIdSet = versionIdToRecordIdSetMap.get(urlInfo.contentVersionId);
                    // Check to make sure no duplicate ids added
                    if (!recordIdSet.contains(urlInfo.record.id)) {
                        recordIdSet.add(urlInfo.record.id);
                        versionIdToRecordIdSetMap.put(urlInfo.contentVersionId, recordIdSet);
                        contentDocumentLinkList.add(new ContentDocumentLink(ContentDocumentId = idToContentVersionMap.get(urlInfo.contentVersionId).ContentDocumentId,
                                                                            LinkedEntityId  = urlInfo.record.id,
                                                                            ShareType='V',
                                                                            Visibility='AllUsers'));
                    }
                }
            }
            }

        insert contentDocumentLinkList;
    }

    /**
     * Inserts Content Document Links to link new Asset Files to Records.
     *
     * @author Aaron Wong
     *
     * @param urlInfoList   List of URLInfo objects.
     * @since               1.0
     */
    public static void insertDocumentLinksFromAssets(List<UrlInfo> urlInfoList) {
        List<String> assetDeveloperNames = new List<String>();
        // Get list of asset developer names
        for (UrlInfo urlInfo : urlInfoList) {
            if (String.isNotBlank(urlInfo.assetDeveloperName)) {
                assetDeveloperNames.add(urlInfo.assetDeveloperName);
            }
        }

        if (assetDeveloperNames.isEmpty()) {
            return;
        }

        List<ContentDocument> documentList = [SELECT id, ContentAsset.DeveloperName FROM ContentDocument WHERE ContentAsset.DeveloperName IN :assetDeveloperNames];
        Map<String, ContentDocument> assetNameToContentDocumentMap = new Map<String, ContentDocument>();

        // Create map of asset developer names to Content documents
        for (ContentDocument documentRecord : documentList) {
            assetNameToContentDocumentMap.put(documentRecord.ContentAsset.DeveloperName, documentRecord);
        }

        Map<String, Set<String>> assetNameToRecordIdSetMap = new Map<String, Set<String>>();
        List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();

        // Create links
        for (UrlInfo urlInfo : urlInfoList) {
            // Check to make sure no duplicate ids added
            if (!assetNameToRecordIdSetMap.containsKey(urlInfo.assetDeveloperName)) {
                Set<String> recordIdSet = new Set<String>();
                recordIdSet.add(urlInfo.record.id);
                assetNameToRecordIdSetMap.put(urlInfo.assetDeveloperName, recordIdSet);
                contentDocumentLinkList.add(new ContentDocumentLink(ContentDocumentId = assetNameToContentDocumentMap.get(urlInfo.assetDeveloperName).id,
                                                                    LinkedEntityId  = urlInfo.record.id,
                                                                    ShareType='V',
                                                                    Visibility='AllUsers'));
            } else {
                Set<String> recordIdSet = assetNameToRecordIdSetMap.get(urlInfo.assetDeveloperName);
                // Check to make sure no duplicate ids added
                if (!recordIdSet.contains(urlInfo.record.id)) {
                    recordIdSet.add(urlInfo.record.id);
                    assetNameToRecordIdSetMap.put(urlInfo.assetDeveloperName, recordIdSet);
                    contentDocumentLinkList.add(new ContentDocumentLink(ContentDocumentId = assetNameToContentDocumentMap.get(urlInfo.assetDeveloperName).id,
                                                                        LinkedEntityId  = urlInfo.record.id,
                                                                        ShareType='V',
                                                                        Visibility='AllUsers'));
                }
            }
        }

        insert contentDocumentLinkList;
    }

    /**
     * Deletes Content Document and Content Document Links for URLs that are removed from the SObject
     *
     * @author Aaron Wong
     *
     * @param urlInfoListToDelete   List of URLInfo records with image links to delete.
     * @since                       1.0
     */
    private static void deleteImages(List<UrlInfo> urlInfoListToDelete) {

        if (urlInfoListToDelete == null) {
            return;
        }

        Set<String> assetFileDeveloperNameSet = new Set<String>();
        Map<String, List<UrlInfo>> developerNameToUrlInfoListMap = new Map<String, List<UrlInfo>>();

        for (UrlInfo urlInfo : urlInfoListToDelete) {
            Matcher m = Pattern.compile(ASSET_FILE_REG_EX).matcher(urlInfo.originalUrl);

            // Downloaded file logic
            if (m.matches()) {
                String assetFileDeveloperName = m.group(1);
                assetFileDeveloperNameSet.add(m.group(1));

                if (developerNameToUrlInfoListMap.containsKey(assetFileDeveloperName)) {
                    developerNameToUrlInfoListMap.get(assetFileDeveloperName).add(urlInfo);
                } else {
                    List<UrlInfo> urlInfoList = new List<UrlInfo>();

                    urlInfoList.add(urlInfo);
                    developerNameToUrlInfoListMap.put(assetFileDeveloperName, urlInfoList);
                }
            }
        }

        if (assetFileDeveloperNameSet.size() == 0) {
            return;
        }

        List<ContentDocument> contentDocumentList = [SELECT id, ContentAsset.DeveloperName
                                                        FROM ContentDocument
                                                        WHERE ContentAsset.DeveloperName IN :assetFileDeveloperNameSet];

        // Querying for ContentDocumentLinks requires a list of contentDocumentIdSet
        Set<Id> contentDocumentIdSet = new Set<Id>();
        for (ContentDocument documentRecord : contentDocumentList) {
            contentDocumentIdSet.add(documentRecord.id);
        }

        if (contentDocumentIdSet.size() == 0) {
            return;
        }

        List<ContentDocumentLink> contentDocumentLinkList = [SELECT id, ContentDocumentId, LinkedEntityId
                                                                FROM ContentDocumentLink
                                                                WHERE ContentDocumentId IN :contentDocumentIdSet];

        Map<String, List<ContentDocumentLink>> documentIdToLinkListMap = new Map<String, List<ContentDocumentLink>>();

        // Populate map of documentIds to Content Document Links
        for (ContentDocumentLink contentDocumentLinkRecord : contentDocumentLinkList) {
            if (documentIdToLinkListMap.containsKey(contentDocumentLinkRecord.ContentDocumentId)) {
                documentIdToLinkListMap.get(contentDocumentLinkRecord.ContentDocumentId).add(contentDocumentLinkRecord);
            } else {
                List<ContentDocumentLink> newLinkList = new List<ContentDocumentLink>();
                newLinkList.add(contentDocumentLinkRecord);
                documentIdToLinkListMap.put(contentDocumentLinkRecord.ContentDocumentId, newLinkList);
            }
        }

        List<ContentDocumentLink> documentLinksToDelete = new List<ContentDocumentLink>();
        List<ContentDocument> documentsToDelete = new List<ContentDocument>();

        // Delete logic
        for (ContentDocument documentRecord : contentDocumentList) {
            if (developerNameToUrlInfoListMap.containsKey(documentRecord.ContentAsset.DeveloperName) && documentIdToLinkListMap.containsKey(documentRecord.id)) {
                List<UrlInfo> urlInfoList = developerNameToUrlInfoListMap.get(documentRecord.ContentAsset.DeveloperName);
                List<ContentDocumentLink> documentLinkList = documentIdToLinkListMap.get(documentRecord.id);

                // Delete ContentDocumentLinks linked to the records remove them from the list
                for (UrlInfo urlInfo : urlInfoList) {
                    Integer linkIndex = 0;
                    while (linkIndex < documentLinkList.size()) {
                        if (documentLinkList[linkIndex].LinkedEntityId == urlInfo.record.id) {
                            documentLinksToDelete.add(documentLinkList[linkIndex]);
                            documentLinkList.remove(linkIndex);
                        } else {
                            linkIndex++;
                        }
                    }
                }

                Boolean deleteDocument = true;
                // Check if the document needs to be deleted
                for (ContentDocumentLink documentLink : documentLinkList) {
                    Id entityId = documentLink.LinkedEntityId;
                    String entityType = entityId.getSobjectType().getDescribe().getName();

                    if (entityType != 'User' && entityType != 'Contact' && entityType != 'ucinn_portal_Listing__c' && entityType != 'ucinn_portal_Newsletter_Section__c' && entityType != 'ucinn_portal_Zone__c' && entityType != 'Organization') {
                        deleteDocument = false;
                    }
                }

                if (deleteDocument) {
                    documentsToDelete.add(documentRecord);
                }
            }
        }

        delete documentLinksToDelete;
        delete documentsToDelete;
    }

    /**
     * Generates new image URL using the community URL as the domain.
     *
     * @author Aaron Wong
     *
     * @param imageUrl      Original image URL.
     * @param communityURL  URL of the public community.
     * @return              New image URL string.
     * @since               1.0
     */
    public static String getImageUrl(String imageUrl, String communityUrl) {
        imageUrl = imageUrl.replaceAll('&amp;', '&');

        Integer endBaseUrlIndex = imageUrl.indexOf('/servlet/rtaImage');
        if (endBaseUrlIndex < 0) {
            return imageUrl;
        }
        return (communityUrl + imageUrl.substring(endBaseUrlIndex)).replace('//', '/');
    }

    /**
     * Creates an asset file link accessible by portal users.
     *
     * @author Aaron Wong
     * @param title             Developer name of the asset file.
     * @param versionNumber     Content Version number of the asset file.
     * @param communityUrl      Public Community URL domain.
     * @return
     */
    public static String createAssetFileLink(String title, String versionNumber, String communityUrl) {
        return communityUrl + '/file-asset/' + title + '?v=' + versionNumber;
    }
}