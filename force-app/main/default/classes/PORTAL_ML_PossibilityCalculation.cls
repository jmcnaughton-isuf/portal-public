/*
 * Copyright (c) 2019, UC Innovation, Inc.  All Rights Reserved.
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
 * This class is used to calculate the possibility for a constituent to open a specific type of Content and then
 * populate the constituent with 3 Content type with the highest possibility.
 *
 * @author              Bill Lu
 * @version             1.0
 * @since               1.0
 */

public inherited sharing class PORTAL_ML_PossibilityCalculation {

    //The specific constituent will be processed by this class
    public User thisUser = new User();

    //A list of action on Content need to be updated
    public List<ucinn_portal_Action_On_Content__c> actionOnContentListToUpdate = new List<ucinn_portal_Action_On_Content__c>();

    //Weight using to calculate open possibility
    public Double numOfOpenWeight = 0.25;
    public Double timeViewedWeight = 0.25;
    public Double timeCommendedWeight = 0.25;
    public Double timeSpendWeight = 0.25;

    //Indicate if this constituent needs update
    public boolean isNeedUpdate = false;

    //Constructor
    public PORTAL_ML_PossibilityCalculation(User userToProcess){
        thisUser = userToProcess;

        //Initialize each weight in case the weight on the consituent doesn't have a value
        if (thisUser.ucinn_Weight_For_Number_Of_Content__c  != null) {
            numOfOpenWeight = thisUser.ucinn_Weight_For_Number_Of_Content__c ;
        }

        if (thisUser.ucinn_portal_Weight_For_Times_Commented__c != null) {
            timeCommendedWeight = thisUser.ucinn_portal_Weight_For_Times_Commented__c;
        }

        if (thisUser.ucinn_portal_Weight_For_Time_Spent__c != null) {
            timeSpendWeight = thisUser.ucinn_portal_Weight_For_Time_Spent__c;
        }

        if (thisUser.ucinn_portal_Weight_For_Times_Viewed__c != null) {
            timeViewedWeight = thisUser.ucinn_portal_Weight_For_Times_Viewed__c;
        }
    }

    /*
    * Adjust weight on the constituent first then calculate open possibility for each Content type
    * based on the new adjusted weight.
    */
    public void weightAdjustmentAndPossibilityCalculation(List<ucinn_portal_Action_On_Content__c> actionOnContentList){
        //Make sure actionOnContentList is not empty.
        if(actionOnContentList != null && actionOnContentList.isEmpty()){
            return;
        }

        //Indicate if this user is an active user
        Integer numOfTimeViewed = 0;

        //Content that recommended to user since last run
        List<ucinn_portal_Action_On_Content__c> recommendedContent = new List<ucinn_portal_Action_On_Content__c>();

        //Action on Content used to calculate open possibility for this run
        List<ucinn_portal_Action_On_Content__c> calculatePossibilityContent = new List<ucinn_portal_Action_On_Content__c>();

        //Action on Content already been used to calculate open possibility at last run and for this run used to
        //adjust weight for this constituent
        List<ucinn_portal_Action_On_Content__c> historicContent = new List<ucinn_portal_Action_On_Content__c>();

        for(ucinn_portal_Action_On_Content__c eachActionOnContent : actionOnContentList){

            if(eachActionOnContent.Is_Possibility_Processed__c == false ){
                if(eachActionOnContent.Is_Recommended_To__c == true){
                    recommendedContent.add(eachActionOnContent);
                }
                calculatePossibilityContent.add(eachActionOnContent);
                numOfTimeViewed = numOfTimeViewed + (Integer)eachActionOnContent.Times_Viewed__c;
            }
            else if(eachActionOnContent.Is_Adjustment_Processed__c == false){
                historicContent.add(eachActionOnContent);
            }
        }

        System.debug('recommendedContent1: ' + recommendedContent);

        //Means the user never open any Content since last recommendation.
        if(numOfTimeViewed == 0){
            System.debug('Inactive user');
            return;
        }

        System.debug('recommendedContent2: ' + recommendedContent);

        weightAdjustment(recommendedContent, historicContent);
        thisUser.ucinn_Weight_For_Number_Of_Content__c  = numOfOpenWeight;
        thisUser.ucinn_portal_Weight_For_Times_Commented__c = timeCommendedWeight;
        thisUser.ucinn_portal_Weight_For_Time_Spent__c = timeSpendWeight;
        thisUser.ucinn_portal_Weight_For_Times_Viewed__c = timeViewedWeight;
        populateUser(calculatePossibilityContent);
    }

    /*
    * Adjust each weight based on the open rate for historic recommended Content.
    */
    public void weightAdjustment(List<ucinn_portal_Action_On_Content__c> recommendedContent, List<ucinn_portal_Action_On_Content__c> historicContent){

        //Make sure recommendedContent is not empty.
        if(recommendedContent == null || recommendedContent.isEmpty()){
            return;
        }

        //Make sure historicContent is not empty.
        if(historicContent == null || historicContent.isEmpty()){
            return;
        }

        System.debug('Weight Adjust');

        //Map for recommended Content with recommendation type to list of ucinn_portal_Action_On_Content__c
        Map<String, List<ucinn_portal_Action_On_Content__c>> recommendedContentByTypeMap = new Map<String, List<ucinn_portal_Action_On_Content__c>>();

        //Map for recommendation type to open rate
        Map<String, Double> recommendationTypeToOpenRate = new Map<String, Double>();

        //Map for historic Content with recommend type to list of ucinn_portal_Action_On_Content__c
        Map<String, List<ucinn_portal_Action_On_Content__c>> historicContentByTypeMap = new Map<String, List<ucinn_portal_Action_On_Content__c>>();

        //Cluster historicContent by recommend type
        for(ucinn_portal_Action_On_Content__c eachActionOnContent : historicContent){

            if(String.isNotEmpty(eachActionOnContent.Recommend_Type_1__c)){
                populateActionOnContentByTypeMap(eachActionOnContent.Recommend_Type_1__c, eachActionOnContent, historicContentByTypeMap);
            }

            if(String.isNotEmpty(eachActionOnContent.Recommend_Type_2__c)){
                populateActionOnContentByTypeMap(eachActionOnContent.Recommend_Type_2__c, eachActionOnContent, historicContentByTypeMap);
            }

            if(String.isNotEmpty(eachActionOnContent.Recommend_Type_3__c)){
                populateActionOnContentByTypeMap(eachActionOnContent.Recommend_Type_3__c, eachActionOnContent, historicContentByTypeMap);
            }

            if(String.isNotEmpty(eachActionOnContent.Recommend_Type_4__c)){
                populateActionOnContentByTypeMap(eachActionOnContent.Recommend_Type_4__c, eachActionOnContent, historicContentByTypeMap);
            }

            if(String.isNotEmpty(eachActionOnContent.Recommend_Type_5__c)){
                populateActionOnContentByTypeMap(eachActionOnContent.Recommend_Type_5__c, eachActionOnContent, historicContentByTypeMap);
            }

            eachActionOnContent.Is_Adjustment_Processed__c = true;
            actionOnContentListToUpdate.add(eachActionOnContent);
        }

        for(ucinn_portal_Action_On_Content__c eachActionOnContent : recommendedContent){
            if(String.isNotEmpty(eachActionOnContent.Recommendation_Type__c)){
                populateActionOnContentByTypeMap(eachActionOnContent.Recommendation_Type__c, eachActionOnContent, recommendedContentByTypeMap);
            }
        }

        //Calculate open rate for each recommended Content type
        for(String contentType : recommendedContentByTypeMap.keySet()){
            List<ucinn_portal_Action_On_Content__c> thisActionOnContentListByType = recommendedContentByTypeMap.get(contentType);

            if(!thisActionOnContentListByType.isEmpty()){
                Double numOfOpen = 0;
                Double totalContent = (Double)thisActionOnContentListByType.size();

                for(ucinn_portal_Action_On_Content__c eachContent : thisActionOnContentListByType){
                    if(eachContent.Times_Viewed__c > 0){
                        numOfOpen++;
                    }
                }

                Double openRate = (numOfOpen / totalContent) * 100;
                recommendationTypeToOpenRate.put(contentType, openRate);

                System.debug('Content Type:' + contentType + ' => Open Rate:' + openRate);
            }
        }

        Boolean rateMatched = false;
        Double totalDiff = 0;
        List<Boolean> rateMatchingList = new List<Boolean>();

        //Check if the actual open rate matched the possible open rate
        for(String contentType : recommendationTypeToOpenRate.keySet()){
            Double openRate = recommendationTypeToOpenRate.get(contentType);
            Double openRateDiff = 101;
            Boolean typeFound = false;

            if(thisUser.ucinn_portal_Recommend_Type_1__c != null && contentType == String.valueOf(thisUser.ucinn_portal_Recommend_Type_1__c) && thisUser.ucinn_portal_Open_Possibility_For_Type_1__c != null){
                openRateDiff = Math.abs(openRate - (Double)thisUser.ucinn_portal_Open_Possibility_For_Type_1__c);
                typeFound = true;
            }

            if(thisUser.ucinn_portal_Recommend_Type_2__c != null && contentType == String.valueOf(thisUser.ucinn_portal_Recommend_Type_2__c) && thisUser.ucinn_portal_Open_Possibility_For_Type_2__c != null){
                openRateDiff = Math.abs(openRate - (Double)thisUser.ucinn_portal_Open_Possibility_For_Type_2__c);
                typeFound = true;
            }

            if(thisUser.ucinn_portal_Recommend_Type_3__c != null && contentType == String.valueOf(thisUser.ucinn_portal_Recommend_Type_3__c) && thisUser.ucinn_portal_Open_Possibility_For_Type_3__c != null){
                openRateDiff = Math.abs(openRate - (Double)thisUser.ucinn_portal_Open_Possibility_For_Type_3__c);
                typeFound = true;
            }

            if(typeFound == false){
                System.debug(contentType + ' not found in recommend type.');
                recommendationTypeToOpenRate.remove(contentType);
                continue;
            }

            //If open rate difference if less than 3, consider it as a match.
            if(openRateDiff < 3){
                rateMatched = true;
            }
            else {
                rateMatched = false;
            }

            rateMatchingList.add(rateMatched);

            System.debug('Open Rate diff: ' + openRateDiff);

            totalDiff = totalDiff + openRateDiff;
        }

        //If the actual open rate matches the possible open rate, then don't adjust the weight.
        if(!rateMatchingList.isEmpty() && !rateMatchingList.contains(false)){
            System.debug('Rate Matched');
            return;
        }

        //Make sure there's Content type in the map
        if(recommendationTypeToOpenRate.isEmpty()){
            System.debug('recommendationTypeToOpenRate is empty.');
            return;
        }

        Map<Integer, WeightInfo> weightMap = simulateWeightMap();
        Map<Integer, Double> optionToRateDiff = new Map<Integer, Double>();
        AllContentType thisAllContentType = new AllContentType(historicContentByTypeMap);
        Boolean typeExist = false;

        //Make sure the Content type in actual open rate map exist in the histotic Content map
        for(String contentType : recommendationTypeToOpenRate.keySet()){
            if(thisAllContentType.contentTypeInfoMap.containsKey(contentType)){
                typeExist = true;
                break;
            }
        }

        if(typeExist == false){
            System.debug('Historic Content doesnt contains Content type in recommendationTypeToOpenRate.');
            return;
        }

        //Calcualte the open rate difference for each set of adjusted weight.
        for(Integer option : weightMap.keySet()){
            WeightInfo thisWeightInfo = weightMap.get(option);
            thisAllContentType.calculatePossibility(thisWeightInfo.ThisNumOfOpenWeight, thisWeightInfo.ThisTimeViewedWeight, thisWeightInfo.ThisTimeCommendedWeight, thisWeightInfo.ThisTimeSpendWeight);
            Map<String, Double> contentTypeToOpenRate = thisAllContentType.contentTypeToPossibility;
            Double thisTotalDiff = 0;

            for(String contentType : recommendationTypeToOpenRate.keySet()){
                Double openRate = recommendationTypeToOpenRate.get(contentType);
                if(contentTypeToOpenRate.containsKey(contentType)){
                    thisTotalDiff = thisTotalDiff + Math.abs(openRate - contentTypeToOpenRate.get(contentType));
                }
            }

            System.debug('This total Open Rate diff: ' + thisTotalDiff);
            optionToRateDiff.put(option, thisTotalDiff);
        }

        Integer optionToUse = 0;
        for(Integer option : optionToRateDiff.keySet()){
            Double thisDiff = optionToRateDiff.get(option);
            if(thisDiff < totalDiff){
                totalDiff = thisDiff;
                optionToUse = option;
            }
        }

        if(optionToUse != 0){
            WeightInfo weightToUse = weightMap.get(optionToUse);
            numOfOpenWeight = weightToUse.thisNumOfOpenWeight;
            timeViewedWeight = weightToUse.thisTimeViewedWeight;
            timeCommendedWeight = weightToUse.thisTimeCommendedWeight;
            timeSpendWeight = weightToUse.thisTimeSpendWeight;
            isNeedUpdate = true;
        }
    }

    /*
    * Populate the specific constituent with 3 highest open posibility Content type.
    */
    public void populateUser(List<ucinn_portal_Action_On_Content__c> actionOnContentList){

        //Make sure actionOnContentList is not empty.
        if(actionOnContentList.isEmpty()){
            return;
        }

        System.debug('Possibility calculate.');

        //Map for ucinn_portal_Action_On_Content__c with recommend type to list of ucinn_portal_Action_On_Content__c
        Map<String, List<ucinn_portal_Action_On_Content__c>> actionOnContentByTypeMap = new Map<String, List<ucinn_portal_Action_On_Content__c>>();

        //Cluster ucinn_portal_Action_On_Content__c by recommend type
        for(ucinn_portal_Action_On_Content__c actionOnContent : actionOnContentList){

            if(String.isNotEmpty(actionOnContent.Recommend_Type_1__c)){
                populateActionOnContentByTypeMap(actionOnContent.Recommend_Type_1__c, actionOnContent, actionOnContentByTypeMap);
            }

            if(String.isNotEmpty(actionOnContent.Recommend_Type_2__c)){
                populateActionOnContentByTypeMap(actionOnContent.Recommend_Type_2__c, actionOnContent, actionOnContentByTypeMap);
            }

            if(String.isNotEmpty(actionOnContent.Recommend_Type_3__c)){
                populateActionOnContentByTypeMap(actionOnContent.Recommend_Type_3__c, actionOnContent, actionOnContentByTypeMap);
            }

            if(String.isNotEmpty(actionOnContent.Recommend_Type_4__c)){
                populateActionOnContentByTypeMap(actionOnContent.Recommend_Type_4__c, actionOnContent, actionOnContentByTypeMap);
            }

            if(String.isNotEmpty(actionOnContent.Recommend_Type_5__c)){
                populateActionOnContentByTypeMap(actionOnContent.Recommend_Type_5__c, actionOnContent, actionOnContentByTypeMap);
            }

            actionOnContent.Is_Possibility_Processed__c = true;
            actionOnContentListToUpdate.add(actionOnContent);
        }

        //Calculate possibility for each Content type.
        AllContentType thisAllContentType = new AllContentType(actionOnContentByTypeMap);
        thisAllContentType.calculatePossibility(numOfOpenWeight, timeViewedWeight, timeCommendedWeight, timeSpendWeight);
         //Map for each Content type to the open possibility for this constituent.
        Map<String, Double> contentTypeToPossibility = thisAllContentType.contentTypeToPossibility;

        //Get the 3 highest open possibility Content type then update constituent
        if(!contentTypeToPossibility.isEmpty()){
            //Get the old 3 highest open possibility Content type, if the new possibility is higher than the old one,
            //then use the new one, if the new possibility is lower than the old one, then use the average value of the
            //new and old possibility
            averagePossibility(thisUser.ucinn_portal_Recommend_Type_1__c, (Double)thisUser.ucinn_portal_Open_Possibility_For_Type_1__c, contentTypeToPossibility);
            averagePossibility(thisUser.ucinn_portal_Recommend_Type_2__c, (Double)thisUser.ucinn_portal_Open_Possibility_For_Type_2__c, contentTypeToPossibility);
            averagePossibility(thisUser.ucinn_portal_Recommend_Type_3__c, (Double)thisUser.ucinn_portal_Open_Possibility_For_Type_3__c, contentTypeToPossibility);

            //Get the 3 highest open possibility Content type
            List<Double> possibilityList = contentTypeToPossibility.values();
            possibilityList.sort();
            Integer currentPosition = possibilityList.size() - 1;

            for(Integer typeRank = 0; typeRank < 3 && typeRank < possibilityList.size(); typeRank++){
                for(String contentType : contentTypeToPossibility.keySet()){
                    if(contentTypeToPossibility.get(contentType) == possibilityList[currentPosition]){
                        if(typeRank == 0){
                            thisUser.ucinn_portal_Recommend_Type_1__c = contentType;
                            thisUser.ucinn_portal_Open_Possibility_For_Type_1__c = contentTypeToPossibility.get(contentType);
                        }

                        if(typeRank == 1){
                            thisUser.ucinn_portal_Recommend_Type_2__c = contentType;
                            thisUser.ucinn_portal_Open_Possibility_For_Type_2__c = contentTypeToPossibility.get(contentType);
                        }

                        if(typeRank == 2){
                            thisUser.ucinn_portal_Recommend_Type_3__c = contentType;
                            thisUser.ucinn_portal_Open_Possibility_For_Type_3__c = contentTypeToPossibility.get(contentType);
                        }

                        currentPosition--;
                        contentTypeToPossibility.remove(contentType);
                        break;
                    }
                }
            }

            isNeedUpdate = true;
        }
    }

    //Help function for populate actionOnContentByTypeMap
    public void populateActionOnContentByTypeMap(String contentType, ucinn_portal_Action_On_Content__c actionOnContent, Map<String, List<ucinn_portal_Action_On_Content__c>> actionOnContentByTypeMap){
        List<ucinn_portal_Action_On_Content__c> actionOnContentByTypeList = new List<ucinn_portal_Action_On_Content__c>();

        if(actionOnContentByTypeMap.containsKey(contentType)){
            actionOnContentByTypeList = actionOnContentByTypeMap.get(contentType);
        }

        actionOnContentByTypeList.add(actionOnContent);
        actionOnContentByTypeMap.put(contentType, actionOnContentByTypeList);
    }

    //Help function for average the old and new open possibility
    public void averagePossibility(String contentType, Double oldPossibility, Map<String, Double> contentTypeToPossibilityMap){
        if(String.isNotBlank(contentType) && oldPossibility != null){
            Double newPossibility = 0;

            if(contentTypeToPossibilityMap.containsKey(contentType)){
                newPossibility = contentTypeToPossibilityMap.get(contentType);
            }

            System.debug('newPossibility: ' + newPossibility);
            System.debug('oldPossibility: ' + oldPossibility);

            if(newPossibility < oldPossibility){
                newPossibility = (newPossibility + oldPossibility) / 2;
            }

            System.debug('avgPossibility: ' + newPossibility);
            contentTypeToPossibilityMap.put(contentType, newPossibility);
        }
    }

    //Help function to generate a map of adjusted weight set
    public Map<Integer, WeightInfo> simulateWeightMap(){
        Map<Integer, WeightInfo> weightMap = new Map<Integer, WeightInfo>();

        for(Integer option = 1; option < 7; option++){
            WeightInfo thisWeightInfo = new WeightInfo(this.numOfOpenWeight, this.timeViewedWeight, this.timeCommendedWeight, this.timeSpendWeight);
            thisWeightInfo.weightAdjust(option);
            weightMap.put(option, thisWeightInfo);

            System.debug(thisWeightInfo);
        }

        return weightMap;
    }

    /*
    * Class used to store the total number for each field on ucinn_portal_Action_On_Content__c for a specific Content type.
    */
    public class ContentTypeInfo{
        Double totalNumberOfOpen = 0;
        Double totalTimeViewed = 0;
        Double totalTimeCommended = 0;
        Double totalTimeSpend = 0;

        public ContentTypeInfo(Double numberOfOpen, Double timeViewed, Double timeCommended, Double timeSpend){
            totalNumberOfOpen = numberOfOpen;
            totalTimeViewed = timeViewed;
            totalTimeCommended = timeCommended;
            totalTimeSpend = timeSpend;
        }
    }

    /*
    * Class used to store the total number for each field on ucinn_portal_Action_On_Content__c for all Content type.
    */
    public class AllContentType{
        Double maxTotalNumberOfOpen = 0;
        Double maxTotalTimeViewed = 0;
        Double maxTotalTimeCommended = 0;
        Double maxTotalTimeSpend = 0;

        Map<String, ContentTypeInfo> contentTypeInfoMap = new Map<String, ContentTypeInfo>();
        Map<String, Double> contentTypeToPossibility = new Map<String, Double>();

        //Process actionOnContentByTypeMap to initailize ContentTypeInfoMap
        public AllContentType(Map<String, List<ucinn_portal_Action_On_Content__c>> actionOnContentByTypeMap){
            for(String contentType : actionOnContentByTypeMap.keySet()){
                List<ucinn_portal_Action_On_Content__c> actionOnContentByTypeList = actionOnContentByTypeMap.get(contentType);

                if(!actionOnContentByTypeList.isEmpty()){
                    Double totalNumberOfOpen = 0;
                    Double totalTimeViewed = 0;
                    Double totalTimeCommended = 0;
                    Double totalTimeSpend = 0;

                    for(ucinn_portal_Action_On_Content__c eachAction : actionOnContentByTypeList){
                        if(eachAction.Times_Viewed__c > 0){
                            totalNumberOfOpen++;
                            if (eachAction.Times_Viewed__c != null) {
                                totalTimeViewed += (Double)eachAction.Times_Viewed__c;
                            }
                            if (eachAction.Times_Commented__c != null) {
                                totalTimeCommended += (Double)eachAction.Times_Commented__c;
                            }
                            if (eachAction.Time_Spent__c != null) {
                                totalTimeSpend += (Double)eachAction.Time_Spent__c;
                            }
                        }
                    }

                    if(totalNumberOfOpen > maxTotalNumberOfOpen){
                        maxTotalNumberOfOpen = totalNumberOfOpen;
                    }

                    if(totalTimeViewed > maxTotalTimeViewed){
                        maxTotalTimeViewed = totalTimeViewed;
                    }

                    if(totalTimeCommended > maxTotalTimeCommended){
                        maxTotalTimeCommended = totalTimeCommended;
                    }

                    if(totalTimeSpend > maxTotalTimeSpend){
                        maxTotalTimeSpend = totalTimeSpend;
                    }

                    ContentTypeInfo thisContentInfo = new ContentTypeInfo(totalNumberOfOpen, totalTimeViewed, totalTimeCommended, totalTimeSpend);
                    contentTypeInfoMap.put(contentType, thisContentInfo);
                }
            }
        }

        //Calculate open possibility for each Content type based on ContentTypeInfoMap
        public void calculatePossibility(Double numOfOpenWeight, Double timeViewedWeight, Double timeCommendedWeight, Double timeSpendWeight){
            if(!contentTypeInfoMap.isEmpty()){
                for(String contentType : contentTypeInfoMap.keySet()){
                    ContentTypeInfo thisContentTypeInfo = contentTypeInfoMap.get(contentType);
                    Double openPossibility = 0;

                    if(maxTotalNumberOfOpen != 0){
                        openPossibility = thisContentTypeInfo.TotalNumberOfOpen / maxTotalNumberOfOpen * numOfOpenWeight;
                    }

                    if(maxTotalTimeViewed != 0){
                        openPossibility = openPossibility + (thisContentTypeInfo.TotalTimeViewed / maxTotalTimeViewed * timeViewedWeight);
                    }

                    if(maxTotalTimeCommended != 0){
                        openPossibility = openPossibility + (thisContentTypeInfo.TotalTimeCommended / maxTotalTimeCommended * timeCommendedWeight);
                    }

                    if(maxTotalTimeSpend != 0){
                        openPossibility = openPossibility + (thisContentTypeInfo.TotalTimeSpend / maxTotalTimeSpend * timeSpendWeight);
                    }

                    openPossibility = openPossibility * 100;
                    contentTypeToPossibility.put(contentType, openPossibility);
                }
            }
        }
    }

    /*
    * Class contains all weight info
    */
    public class WeightInfo{
        Double thisNumOfOpenWeight = 0.25;
        Double thisTimeViewedWeight = 0.25;
        Double thisTimeCommendedWeight = 0.25;
        Double thisTimeSpendWeight = 0.25;

        public WeightInfo(Double numOfOpenWeight, Double timeViewedWeight, Double timeCommendedWeight, Double timeSpendWeight){
            thisNumOfOpenWeight = numOfOpenWeight;
            thisTimeViewedWeight = timeViewedWeight;
            thisTimeCommendedWeight = timeCommendedWeight;
            thisTimeSpendWeight = timeSpendWeight;
        }

        //Adjust each weight based on the current weight value
        //**Doesn't consider one weight reach to 0 then what we do???
        public void weightAdjust(Integer option){
            if(option == 1){
                if(thisTimeViewedWeight >= 0.01){
                    thisNumOfOpenWeight = thisNumOfOpenWeight + 0.01;
                    thisTimeViewedWeight = thisTimeViewedWeight - 0.01;
                }

                if(thisTimeSpendWeight >= 0.01){
                    thisTimeCommendedWeight = thisTimeCommendedWeight + 0.01;
                    thisTimeSpendWeight = thisTimeSpendWeight - 0.01;
                }
            }

            if(option == 2){
                if(thisTimeCommendedWeight >= 0.01){
                    thisNumOfOpenWeight = thisNumOfOpenWeight + 0.01;
                    thisTimeCommendedWeight = thisTimeCommendedWeight - 0.01;
                }

                if(thisTimeSpendWeight >= 0.01){
                    thisTimeViewedWeight = thisTimeViewedWeight + 0.01;
                    thisTimeSpendWeight = thisTimeSpendWeight - 0.01;
                }
            }

            if(option == 3){
                if(thisTimeViewedWeight >= 0.01){
                    thisNumOfOpenWeight = thisNumOfOpenWeight + 0.01;
                    thisTimeViewedWeight = thisTimeViewedWeight - 0.01;
                }

                if(thisTimeCommendedWeight >= 0.01){
                    thisTimeCommendedWeight = thisTimeCommendedWeight - 0.01;
                    thisTimeSpendWeight = thisTimeSpendWeight + 0.01;
                }
            }

            if(option == 4){
                if(thisNumOfOpenWeight >= 0.01){
                    thisNumOfOpenWeight = thisNumOfOpenWeight - 0.01;
                    thisTimeViewedWeight = thisTimeViewedWeight + 0.01;
                }

                if(thisTimeSpendWeight >= 0.01){
                    thisTimeCommendedWeight = thisTimeCommendedWeight + 0.01;
                    thisTimeSpendWeight = thisTimeSpendWeight - 0.01;
                }
            }

            if(option == 5){
                if(thisNumOfOpenWeight >= 0.01){
                    thisNumOfOpenWeight = thisNumOfOpenWeight - 0.01;
                    thisTimeViewedWeight = thisTimeViewedWeight + 0.01;
                }

                if(thisTimeCommendedWeight >= 0.01){
                    thisTimeCommendedWeight = thisTimeCommendedWeight - 0.01;
                    thisTimeSpendWeight = thisTimeSpendWeight + 0.01;
                }
            }

            if(option == 6){
                if(thisNumOfOpenWeight >= 0.01){
                    thisNumOfOpenWeight = thisNumOfOpenWeight - 0.01;
                    thisTimeCommendedWeight = thisTimeCommendedWeight + 0.01;
                }

                if(thisTimeViewedWeight >= 0.01){
                    thisTimeViewedWeight = thisTimeViewedWeight - 0.01;
                    thisTimeSpendWeight = thisTimeSpendWeight + 0.01;
                }
            }
        }
    }
}