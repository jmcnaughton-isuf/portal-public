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
 *
 *
 *
 */

 /**
  * class that manages action on content records
  * @author                     Bill Lu
  * @since                      1.0
  */

public virtual inherited sharing class PORTAL_ActionOnContentBase {

    public static final String TIME_DIFFERENCE_KEY = 'timeDifference';
    public static final String CONTENT_NAME_KEY = 'contentName';
    public static final String AUTHENTICATED_USER_LABEL = 'Authenticated_User';
    public static final String LISTING_ITEM_LIST_KEY = 'listingItemList';
    public static final String RECOMMENDED_TYPE_KEY = 'recommendedType';
    public static final String QUERY_STRING_KEY = 'queryString';
    public static final String LISTING_ID_LIST_KEY = 'listingIdList';
    public static final String MAX_TIME_LIMIT_CUSTOM_METADATA_NAME = 'Max_Time_Limit_For_Content';
    public static final String PUBLISHED_STATUS = 'Published';


    /**
     * Helper function for getting recommendation setting based on the current user type.
     *
     * @param userType          User type for current user.
     * @return                  Recommendation setting record.
     * @author                  Bill Lu
     * @since                   1.0
     */
    public virtual Portal_Recommendation_Setting__mdt getRecommendationSetting(String userType){
        String developerName = AUTHENTICATED_USER_LABEL;

        List<Portal_Recommendation_Setting__mdt> portalRecommendationSetting = (List<Portal_Recommendation_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'MasterLabel', 'Is_Recommendation_Enabled__c', 'Number_Of_Recommendations__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Recommendation_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{developerName}
        });

        if (portalRecommendationSetting.isEmpty()) {
            return null;
        }

        return portalRecommendationSetting.get(0);
     }

    /**
     * Helper function that determines if the recommendation engine is enabled for current user.
     *
     * @param userType         User type for current user.
     * @return                 True if recommendation is enabled for current user, else false.
     * @author                 Bill Lu
     * @since                  1.0
     */
    public virtual Boolean recommendationEnabled(String userType){

        Portal_Recommendation_Setting__mdt portalRecommendationSetting = getRecommendationSetting(userType);

        if (portalRecommendationSetting == null) {
            return false;
        }
        else {
            return portalRecommendationSetting.Is_Recommendation_Enabled__c;
        }
    }

    /**
     * Method for tracking how much time user spent on a specific content record
     *
     * @param contentId          Id for the specific content.
     * @param timeDifference     Time user spend on this content in milliseconds.
     * @author                   Bill Lu
     * @since                    1.0
     */
    public virtual void timeTrack(Map<String, Object> params) {
        String contentId =  (String) params.get(PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY);
        Decimal timeDifference = (Decimal) params.get(TIME_DIFFERENCE_KEY);
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        Id currentUserId = UserInfo.getUserId();
        String currentUserType = UserInfo.getUserType();

        //Check if recommendation is enabled for current user
        if (recommendationEnabled(currentUserType) == false) {
            return;
        }

        String identifier = getReferenceId(contentId, currentUserId, currentUserType, ipAddress);

        List<ucinn_portal_Action_On_Content__c> thisActionOnContentList = [Select Id, Time_Spent__c From ucinn_portal_Action_On_Content__c WHERE Reference_ID__c = :identifier];

        if (thisActionOnContentList.isEmpty()) {
            return;
        }

        ucinn_portal_Action_On_Content__c thisActionOnContent = thisActionOnContentList[0];

        Decimal timeInSeconds = timeDifference / 1000;

        Integer maxTimeLimit = 1000;

        List<Portal_Organization_Setting__mdt> orgSettingList = (List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
            PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{MAX_TIME_LIMIT_CUSTOM_METADATA_NAME}
        });

        if (!orgSettingList.isEmpty() && String.isNotBlank(orgSettingList.get(0).Value__c)) {
            maxTimeLimit = Integer.valueOf(orgSettingList.get(0).Value__c);
        }

         // set a max time spent on page for a single visit
         if (timeInSeconds >= maxTimeLimit) {
            timeInSeconds = maxTimeLimit;
        }

        if (thisActionOnContent.Time_Spent__c != null) {
            timeInSeconds += thisActionOnContent.Time_Spent__c;
        }

        thisActionOnContent.Time_Spent__c = timeInSeconds;
        update thisActionOnContent;
    }

    /**
     * Method for tracking how much time user spent on a specific content record using the record name
     *
     * @param contentName          name of the content record
     * @param timeDifference       Time user spend on this content in milliseconds.
     * @author                     Ashley Tran
     * @since                      1.0
     */
    public virtual void timeTrackByName(Map<String, Object> params) {
        String contentName =  (String) params.get(CONTENT_NAME_KEY);
        Decimal timeDifference = (Decimal) params.get(TIME_DIFFERENCE_KEY);
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        List<ucinn_portal_Listing__c> listings = [SELECT Id FROM ucinn_portal_Listing__c WHERE Name =: contentName AND Status__c = :PUBLISHED_STATUS];

        if (!listings.isEmpty()) {
            timeTrack(new Map<String, Object>{PORTAL_CONST_ActionOnContent.CONTENT_ID_KEY => listings[0].Id, TIME_DIFFERENCE_KEY => timeDifference, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
        }
    }

    /**
     * Method for creating an action on content record using the content record id
     *
     * @param listingId            id of the content record
     * @param userId               the id of the user we are creating the record for
     * @author                     Bill Lu
     * @since                      1.0
     */

    public virtual ucinn_portal_Action_On_Content__c createActionOnContentWithListingId(Map<String, Object> params) {
        String userId = (String) params.get(PORTAL_CONST_ActionOnContent.USER_ID_KEY);
        String listingId = (String) params.get(PORTAL_CONST_ActionOnContent.LISTING_ID_KEY);
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        if (String.isBlank(userId) || String.isBlank(listingId)) {
            return null;
        }

        ucinn_portal_Action_On_Content__c thisActionOnContent = new ucinn_portal_Action_On_Content__c();

        List<ucinn_portal_Listing__c> listings = [SELECT Id, Name, Recommend_Type_1__c, RecordTypeId, Recommend_Type_2__c, Recommend_Type_3__c,
                                                    Recommend_Type_4__c, Recommend_Type_5__c FROM ucinn_portal_Listing__c WHERE Id =: listingId];

        if (!listings.isEmpty()) {
            thisActionOnContent = createActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => userId, PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY => listings[0], PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
        }

        return thisActionOnContent;
    }

    /**
     * Help function for create a new ucinn_portal_Action_On_Content__c record.
     *
     * @param userId          Id for current user.
     * @param listingItem     The listing__c record used to create this Action_On_Content__c record.
     * @return                ucinn_portal_Action_On_Content__c record that is been created.
     * @author                Bill Lu
     * @since 1.0
     */
    public virtual ucinn_portal_Action_On_Content__c createActionOnContent(Map<String, Object> params){
        String userId = (String) params.get(PORTAL_CONST_ActionOnContent.USER_ID_KEY);
        ucinn_portal_Listing__c listingItem = (ucinn_portal_Listing__c) params.get(PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY);
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        if (String.isBlank(userId) || listingItem == null) {
            return null;
        }

        String recordTypeName = '';

        if (String.isNotBlank(listingItem.RecordTypeId)) {
            recordTypeName = Schema.getGlobalDescribe().get(PORTAL_CONST_Listing.LISTING).getDescribe().getRecordTypeInfosById().get(listingItem.RecordTypeId).getName();
        }

        ucinn_portal_Action_On_Content__c thisActionOnContent = new ucinn_portal_Action_On_Content__c(User__c = userId,
                                                                                                        Listing__c = listingItem.Id,
                                                                                                        Related_Object_ID__c = listingItem.Id,
                                                                                                        Related_Object_Type__c = PORTAL_CONST_Listing.LISTING,
                                                                                                        Related_Content_Name__c = listingItem.Name,
                                                                                                        Related_Content_Type__c = recordTypeName,
                                                                                                        Reference_ID__c = getReferenceId(listingItem.Id, userId, UserInfo.getUserType(), ipAddress),
                                                                                                        IP_Address__c = ipAddress,
                                                                                                        Recommend_Type_1__c = listingItem.Recommend_Type_1__c,
                                                                                                        Recommend_Type_2__c = listingItem.Recommend_Type_2__c,
                                                                                                        Recommend_Type_3__c = listingItem.Recommend_Type_3__c,
                                                                                                        Recommend_Type_4__c = listingItem.Recommend_Type_4__c,
                                                                                                        Recommend_Type_5__c = listingItem.Recommend_Type_5__c);
        return thisActionOnContent;
    }

    /**
     * Helper function to create the action on content external id
     *
     * @param listingId          Id for current user.
     * @param userId             Id for current user.
     * @param userType           Type for the current user
     * @param ipAddress          IP address of the current user
     * @return                   String value of external id
     * @author                   Ashley Tran
     * @since 1.0
     */

    public virtual String getReferenceId(String listingId, String userId, String userType, String ipAddress) {
        String identifier;


        if (String.isBlank(listingId)) {
            throw new AuraHandledException('There was an issue. Error Code: 900.');
        }

        if (userType == PORTAL_CONST_ActionOnContent.GUEST_USER_TYPE) {
            //only use ip address if it is a guest user
            if (String.isBlank(ipAddress)) {
                throw new AuraHandledException('There was an issue. Error Code: 901.');
            }
            identifier = listingId + ipAddress;

        } else {

            if (String.isBlank(userId)) {
                throw new AuraHandledException('There was an issue. Error Code: 902.');
            }

            identifier = listingId + userId;
        }

        return identifier;
    }

    /**
     * Method for getting recommend content for the current user.
     *
     * @param userId                        Id for current user.
     * @param userType                      User type for current user.
     * @param maxItemsInt                   Max number of items needs to be returned.
     * @param recommendationTypeList        All the recommendation type for the current user.
     * @param queryString                   String used to query the content.
     * @return                              A list of recommended content for the current user.
     * @author                              Bill Lu
     * @since                               1.0
     */
    public virtual List<Map<String, Object>> getRecommendedContent(Map<String, Object> params){
        String userId = (String) params.get(PORTAL_CONST_ActionOnContent.USER_ID_KEY);
        String userType = (String) params.get(PORTAL_CONST_ActionOnContent.USER_TYPE_KEY);
        Integer maxItemsInt = (Integer) params.get(PORTAL_CONST_ActionOnContent.MAX_ITEMS_KEY);
        String pageName = (String) params.get(PORTAL_CONST_ActionOnContent.PAGE_NAME_KEY);
        String mainSectionName = (String) params.get(PORTAL_CONST_ActionOnContent.MAIN_SECTION_NAME_KEY);
        String subSectionName = (String) params.get(PORTAL_CONST_ActionOnContent.SUB_SECTION_NAME_KEY);
        List<Portal_Page_Section_Setting__mdt> pageSectionList = (List<Portal_Page_Section_Setting__mdt>) params.get(PORTAL_CONST_ActionOnContent.PAGE_SECTION_LIST_KEY);
        PORTAL_UTIL_PageSectionSetting.DynamicQueryClass dynamicQueryObject = ( PORTAL_UTIL_PageSectionSetting.DynamicQueryClass) params.get(PORTAL_CONST_ActionOnContent.DYNAMIC_QUERY_OBJECT_KEY);
        List<String> recommendationTypeList = (List<String>) params.get(PORTAL_CONST_ActionOnContent.RECOMMENDATION_TYPE_LIST_KEY);


        List<Map<String, Object>> recommendedListingList = new List<Map<String, Object>>();
        List<Map<String, Object>> tempListingList = new List<Map<String, Object>>();
        List<String> recommendationFrontEndFieldNameList = new List<String>{'recommendedType1', 'recommendedType2', 'recommendedType3', 'recommendedType4', 'recommendedType5'};

        Set<String> recommendedListingIdSet = new Set<String>();

        Map<String, List<String>> recommendationTypeToListingIds = new Map<String, List<String>>();
        DateTime currentGMTTime = Datetime.now();
        Integer numOfRecommendation = getNumOfRecommendation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_TYPE_KEY => userType});

        if (numOfRecommendation > maxItemsInt) {
            numOfRecommendation = maxItemsInt;
        }

        if (!recommendationTypeList.isEmpty() && numOfRecommendation > 0) {
            String dynamicWhereClause = dynamicQueryObject.dynamicWhereClause;

            String whereClausePrefix = ' AND ';

            if (String.isBlank(dynamicWhereClause)) {
                // in case the string is null
                dynamicWhereClause = '';
                whereClausePrefix = ' WHERE ';
            }

            if (recommendedListingIdSet.size() > 0) {
                dynamicWhereClause = dynamicWhereClause + whereClausePrefix + ' Id NOT IN (\'' + String.join(new List<String>(recommendedListingIdSet), '\', \'') + '\')';
                whereClausePrefix = ' AND ';
            }

            String recommendationTypeListString = '(\'' + String.join(recommendationTypeList, '\', \'')+ '\') ';


            dynamicWhereClause = dynamicWhereClause + whereClausePrefix
                               + ' (Recommend_Type_1__c IN ' + recommendationTypeListString
                               + ' OR Recommend_Type_2__c IN ' + recommendationTypeListString
                               + ' OR Recommend_Type_3__c IN ' + recommendationTypeListString
                               + ' OR Recommend_Type_4__c IN ' + recommendationTypeListString
                               + ' OR Recommend_Type_5__c IN ' + recommendationTypeListString + ')';

            dynamicQueryObject.dynamicWhereClause = dynamicWhereClause;

            String sectionToApply = subSectionName;
            if (String.isBlank(subSectionName)) {
                subSectionName = 'records';
                sectionToApply = mainSectionName;
            }

            Map<String, Map<String, List<Map<String, Object>>>> recordsMap = PORTAL_UTIL_PageSectionSetting.queryForRecords(null, PORTAL_UTIL_PageSectionSetting.generatePageSectionSettingMap(pageSectionList), new Map<String, PORTAL_UTIL_PageSectionSetting.DynamicQueryClass>{sectionToApply => dynamicQueryObject}, false, true);

            tempListingList = recordsMap.get(mainSectionName).get(subSectionName);

            if (tempListingList != null && !tempListingList.isEmpty()) {
                for (Map<String, Object> eachListing : tempListingList) {
                    recommendedListingIdSet.add((String)eachListing.get('Id'));
                }

                recommendedListingList.addAll(tempListingList);
                numOfRecommendation = numOfRecommendation - tempListingList.size();

                // Map all the listings above to its recommended type
                for (Map<String, Object> eachListing : tempListingList) {
                    String recommendType = '';

                    for (String currentRecommendationType : recommendationFrontEndFieldNameList) {
                        String currentRecommendationValue = (String)eachListing.get(currentRecommendationType);
                        System.debug(currentRecommendationType);
                        System.debug(eachListing);
                        System.debug(currentRecommendationValue);
                        System.debug(recommendationTypeList);
                        if (String.isNotBlank(currentRecommendationValue) && recommendationTypeList.contains(currentRecommendationValue)) {
                            recommendType = currentRecommendationValue;
                            break;
                        }
                    }

                    if (String.isNotBlank(recommendType)) {
                        List<String> listingIdList = new List<String>();

                        if (recommendationTypeToListingIds.containsKey(recommendType)) {
                            listingIdList = recommendationTypeToListingIds.get(recommendType);
                        }


                        listingIdList.add((String)eachListing.get('Id'));
                        recommendationTypeToListingIds.put(recommendType, listingIdList);
                    }
                }

                //Upsert recommended content on Action_On_Content
                for (String recommendedType : recommendationTypeToListingIds.keySet()) {
                    upsertRecommendedContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => userId, LISTING_ID_LIST_KEY => recommendationTypeToListingIds.get(recommendedType), RECOMMENDED_TYPE_KEY => recommendedType, PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ''});
                }
            }
        }

        return recommendedListingList;
    }

    /**
     * Method for upsert the action on content record with Is_Recommended_To__c equal to True.
     *
     * @param userId              Id for current user.
     * @param listingItemList     A list of ucinn_portal_Listing__c records used to upsert the ucinn_portal_Action_On_Content__c records.
     * @param recommendType       The recommendation type for Action_On_Content__c records.
     * @author                    Bill Lu
     * @since                     1.0
     */
    public virtual void upsertRecommendedContent(Map<String, Object> params){
        String userId = (String) params.get(PORTAL_CONST_ActionOnContent.USER_ID_KEY);
        List<String> listingIdList = (List<String>) params.get(LISTING_ID_LIST_KEY);
        String recommendedType = (String) params.get(RECOMMENDED_TYPE_KEY);
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        if (String.isBlank(userId) || String.isBlank(recommendedType) || listingIdList == null) {
            return;
        }
        //No need to check recommendation setting here because if we need to upsert a recommended content
        //that means recommendation is enabled for current user
        List<ucinn_portal_Action_On_Content__c> actionOnContentList = new List<ucinn_portal_Action_On_Content__c>();

        for (String eachItem : listingIdList) {
            ucinn_portal_Action_On_Content__c thisActionOnContent = createActionOnContentWithListingId(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => userId,
                                                                                                                               PORTAL_CONST_ActionOnContent.LISTING_ID_KEY => eachItem,
                                                                                                                               PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            thisActionOnContent.Is_Recommended_To__c = true;
            thisActionOnContent.Recommendation_Type__c = recommendedType;
            thisActionOnContent.Is_Possibility_Processed__c = false;
            actionOnContentList.add(thisActionOnContent);
        }

        upsert actionOnContentList Reference_ID__c;
    }

    /**
     * Method for insert or update Action_On_Content__c for a specific User and content.
     *
     * @param userId          Id for current user.
     * @param userType        User type for current user.
     * @param thisContent     The ucinn_portal_Listing__c record used to insert or update the Action_On_Content__c record.
     * @author                Bill Lu
     * @since                 1.0
     */
    public virtual void upsertActionOnContent(Map<String, Object> params){
        Id userId = (Id) params.get(PORTAL_CONST_ActionOnContent.USER_ID_KEY);
        String userType = (String) params.get(PORTAL_CONST_ActionOnContent.USER_TYPE_KEY);
        ucinn_portal_Listing__c thisContent = (ucinn_portal_Listing__c) params.get(PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY);
        String ipAddress = (String) params.get(PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY);

        if (String.isBlank(userId) || String.isBlank(userType) || thisContent == null) {
            return;
        }
        //Check if recommendation is enabled for current user
        if (recommendationEnabled(userType) == false) {
            return;
        }

        String referenceId = getReferenceId(thisContent.Id, userId, userType, ipAddress);

        List<ucinn_portal_Action_On_Content__c> actionOnContentList = [SELECT Id, Times_Viewed__c, Related_Content_Type__c, Related_Content_Name__c,
                                                                             Related_Object_Type__c, Related_Object_ID__c
                                                                            FROM ucinn_portal_Action_On_Content__c
                                                                            WHERE Reference_ID__c = :referenceId];

        //If thisAOC is null, we will need to insert a new Action_On_Content__c
        if (actionOnContentList.isEmpty()) {
            ucinn_portal_Action_On_Content__c thisActionOnContent = createActionOnContent(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => userId, 
                                                                                          PORTAL_CONST_ActionOnContent.LISTING_ITEM_KEY => thisContent,
                                                                                          PORTAL_CONST_ActionOnContent.IP_ADDRESS_KEY => ipAddress});
            thisActionOnContent.Times_Viewed__c = 1;

            insert thisActionOnContent;
        }
        else {
            if (actionOnContentList[0].Times_Viewed__c == null) {
                actionOnContentList[0].Times_Viewed__c = 1;
            }
            else {
                actionOnContentList[0].Times_Viewed__c += 1;
            }

            actionOnContentList[0].Is_Possibility_Processed__c = false;

            update actionOnContentList;
        }
    }

    /**
     * Method for calculating user's recommendation type based on their action on content.
     *
     * @param userId          Id for current user.
     * @author                Bill Lu
     * @since                 1.0
     */
    public virtual void runRecommendationCalculation(Map<String, Object> params) {
        String userId = (String) params.get(PORTAL_CONST_ActionOnContent.USER_ID_KEY);

        if (String.isBlank(userId)) {
            return;
        }

        List<User> userList = [SELECT Id, ucinn_portal_Open_Possibility_For_Type_1__c, ucinn_portal_Open_Possibility_For_Type_2__c,
                           ucinn_portal_Open_Possibility_For_Type_3__c, ucinn_portal_Recommend_Type_1__c, ucinn_portal_Recommend_Type_2__c,
                           ucinn_portal_Recommend_Type_3__c, ucinn_Weight_For_Number_Of_Content__c, ucinn_portal_Weight_For_Times_Commented__c,
                           ucinn_portal_Weight_For_Time_Spent__c, ucinn_portal_Weight_For_Times_Viewed__c
                           FROM User
                           WHERE Id = :userId];

        if (userList.isEmpty()) {
            return;
        }
        User usr = userList[0];

        PORTAL_ML_PossibilityCalculation probabilityCalculator = new PORTAL_ML_PossibilityCalculation(usr);

        List<ucinn_portal_Action_On_Content__c> actionOnContentList = [SELECT Is_Adjustment_Processed__c, Is_Possibility_Processed__c, Recommendation_Type__c,
                                                                                Is_Recommended_To__c, Recommend_Type_1__c, Recommend_Type_2__c, Recommend_Type_3__c, Recommend_Type_4__c, Recommend_Type_5__c,
                                                                                Times_Commented__c, Time_Spent__c, Times_Viewed__c, Related_Object_Type__c, Related_Content_Type__c, Related_Content_Name__c
                                                                        FROM ucinn_portal_Action_On_Content__c
                                                                        WHERE Is_Adjustment_Processed__c = false and User__c = :userId AND (Times_Viewed__c > 0 OR Is_Recommended_To__c = false)];


        probabilityCalculator.weightAdjustmentAndPossibilityCalculation(actionOnContentList);

        if (probabilityCalculator.isNeedUpdate == true && !Test.isRunningTest()) {
            update probabilityCalculator.thisUser;
        }

        if (probabilityCalculator.actionOnContentListToUpdate != null && !probabilityCalculator.actionOnContentListToUpdate.isEmpty()) {
            update probabilityCalculator.actionOnContentListToUpdate;
        }
    }

    /**
     * Help function for getting number of contents needs to be recommended to the current user.
     *
     * @param userType       User type for current user.
     * @return               The number of contents needs to be recommended to the current user.
     * @author               Bill Lu
     * @since                1.0
     */
    public virtual Integer getNumOfRecommendation(Map<String, Object> params){

        String userType = (String) params?.get(PORTAL_CONST_ActionOnContent.USER_TYPE_KEY);

        if (String.isBlank(userType)) {
            return 0;
        }

        Portal_Recommendation_Setting__mdt portalRecommendationSetting = getRecommendationSetting(userType);

        if (portalRecommendationSetting != null && portalRecommendationSetting.Is_Recommendation_Enabled__c && portalRecommendationSetting.Number_Of_Recommendations__c != null) {
            return Integer.valueOf(portalRecommendationSetting.Number_Of_Recommendations__c);
        }

        return 0;
    }
}