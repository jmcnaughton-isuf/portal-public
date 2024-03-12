public without sharing class PORTAL_ProfilePictureController {

    @AuraEnabled(cacheable = true)
    public static Map<String, Object> getProfilePictureFromConstituent(Id recordId) {

        Map<String, Object> profilePictureInfoMap = new Map<String, Object>();
        String profilePictureId = [SELECT ucinn_ascendv2__Picture_Record_ID__c FROM Contact WHERE Id =: recordId LIMIT 1].ucinn_ascendv2__Picture_Record_ID__c;
        if (String.isBlank(profilePictureId)) {
            return null;
        }
        List<ContentVersion> contentVersionList = [SELECT VersionData FROM ContentVersion WHERE Id = :profilePictureId];
        if (contentVersionLIst.isEmpty()) {
            return null;
        }
        String profilePictureVersionDataBase64 = EncodingUtil.base64Encode(contentVersionList[0].VersionData);

        profilePictureInfoMap.put('profilePictureId', contentVersionList[0].Id);
        profilePictureInfoMap.put('profilePictureVersionDataBase64', profilePictureVersionDataBase64);
        return profilePictureInfoMap;
    }

    @AuraEnabled
    public static Map<String, String> getProfilePictureFromContentVersion(Id parentId) {
        Map<String, String> profilePictureMap = new Map<String, String>();

        List<ContentDocumentLink> contentLinkList = [Select Id, ContentDocumentId, LinkedEntityId From ContentDocumentLink
                                                     Where LinkedEntityId =: parentId AND
                                                     (ContentDocument.FileExtension = 'png' OR ContentDocument.FileExtension = 'jpg')
                                                      ORDER BY ContentDocument.CreatedDate DESC Nulls Last];
        if (!contentLinkList.isEmpty()) {
            ContentDocumentLink link = contentLinkList[0];
            List<ContentVersion> contentVersionList = [Select Id, VersionData From ContentVersion Where ContentDocumentId =: link.ContentDocumentId];

            if (!contentVersionList.isEmpty()) {

                String profilePictureVersionDataBase64 = EncodingUtil.base64Encode(contentVersionList[0].VersionData);
                if(!Test.isRunningTest()){
                    ConnectApi.Photo photo = ConnectApi.UserProfiles.setPhoto(null, UserInfo.getUserId(), link.ContentDocumentId, null);
                }
                profilePictureMap.put('profilePictureId', contentVersionList[0].Id);
                profilePictureMap.put('profilePictureVersionDataBase64', profilePictureVersionDataBase64);

                return profilePictureMap;
            } else {
                return null;
            }
        } else {
            return null;
        }

    }

    @AuraEnabled
    public static void updateProfilePicture(Id recordId, String profilePictureId, List<Id> uploadedPhotoIds) {
        List<ContentDocumentLink> links = [SELECT ID, ShareType, Visibility FROM ContentDocumentLink WHERE LinkedEntityId =:recordId AND
                                           ContentDocumentId IN (SELECT ContentDocumentId
                                                                FROM ContentVersion WHERE Id = :profilePictureId)];
        for (ContentDocumentLink link : links) {
            link.Visibility = 'AllUsers';
        }
        update links;
        deleteProfilePicture(recordId);
        update new Contact(Id=recordId, ucinn_ascendv2__Picture_Record_ID__c=profilePictureId);
        if (uploadedPhotoIds.size() > 1) {
            uploadedPhotoIds.remove(uploadedPhotoIds.size()-1);
            deleteUnusedPhotos(recordId, uploadedPhotoIds);
        }

    }

    @AuraEnabled
    public static void deleteProfilePicture(Id recordId) {
        String profilePictureId = [SELECT ucinn_ascendv2__Picture_Record_ID__c FROM Contact WHERE Id =: recordId LIMIT 1].ucinn_ascendv2__Picture_Record_ID__c;
        List<ContentDocumentLink> links = [SELECT ID FROM ContentDocumentLink WHERE LinkedEntityId =:recordId AND
                                           ContentDocumentId IN (SELECT ContentDocumentId
                                                                FROM ContentVersion WHERE Id = :profilePictureId)];
       delete links;
       List<ContentDocument> documents = [SELECT ID FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId
                                                                FROM ContentVersion WHERE Id = :profilePictureId)];
        delete documents;
    }

    @AuraEnabled
    public static void deleteUnusedPhotos(Id recordId, List<Id> uploadedPhotoIds) {
        List<ContentDocumentLink> links = [SELECT ID FROM ContentDocumentLink WHERE LinkedEntityId =:recordId AND
                                           ContentDocumentId IN (SELECT ContentDocumentId
                                                                FROM ContentVersion WHERE Id IN :uploadedPhotoIds)];
       delete links;
       List<ContentDocument> documents = [SELECT ID FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId
                                                                FROM ContentVersion WHERE Id IN :uploadedPhotoIds)];
        delete documents;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,Object> getProfilePictureInfoFromConstituentOrOrganization(String recordId, Boolean getCurrentUser){
        if (getCurrentUser != null && getCurrentUser == true){
            if (String.isEmpty(recordId) ) {
                Id userId = UserInfo.getUserId();
                User usr = [SELECT Id,
                        ContactId,
                        ucinn_portal_Recommend_Type_1__c, ucinn_portal_Recommend_Type_2__c, ucinn_portal_Recommend_Type_3__c
                        FROM User
                        WHERE Id = :userId];
                if (usr != null) {
                    recordId = usr.ContactId;
                }
            }
        }

        if (String.isBlank(recordId)) {
            return new Map<String, Object>();
        }

        Id recordIdType = Id.valueOf(recordId);
        String sObjectType = recordIdType.getSobjectType().getDescribe().getName();
        String profilePictureId;
        Map<String,Object> profilePictureInfoMap = new Map<String, Object>();

        if (sObjectType.equals('Account')) {

            profilePictureId = [SELECT ucinn_ascendv2__Picture_Record_ID__c FROM Account WHERE Id=: recordId Limit 1].ucinn_ascendv2__Picture_Record_ID__c;

        } else if (sObjectType.equals('Contact')) {

            profilePictureId = [SELECT ucinn_ascendv2__Picture_Record_ID__c FROM Contact WHERE Id=: recordId Limit 1].ucinn_ascendv2__Picture_Record_ID__c;
        }

        List<ContentVersion> contentVersionList = [SELECT VersionData FROM ContentVersion WHERE Id =: profilePictureId];


        if (String.isBlank(profilePictureId) || contentVersionList.isEmpty()) {
            return new Map<String, Object>();
        } else {

            Blob profilePictureVersionDataBlob = contentVersionList[0].VersionData;
            String profilePictureVersionDataBase64 = EncodingUtil.base64Encode(profilePictureVersionDataBlob);

            profilePictureInfoMap.put('profilePictureId', profilePictureId);
            profilePictureInfoMap.put('profilePictureVersionDataBase64', profilePictureVersionDataBase64);

            return profilePictureInfoMap;
        }
    }

}