global without sharing class PORTAL_TRIG_ActionOnContentHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    /**
     *  Method occurs on every trigger run.
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @param   oldList                         List of the old version of the records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the obect in the trigger
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     * @since                                   1.0
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert || triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            updateUserRecommendation((List<ucinn_portal_Action_On_Content__c>)newList);

        }
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     *  Method that checks to see if the action on content records meet or exceed the org limit to recalculate
     * the recommendations for the user
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @author                                  Ashley Tran
     * @since                                   1.0
     */
    @testVisible
    private static void updateUserRecommendation(List<ucinn_portal_Action_On_Content__c> newList) {
        Set<Id> userIds = getUserIds(newList);
        Integer actionOnContentLimit = getActionOnContentLimit();

        List<AggregateResult> actionOnContentForUsers = [SELECT COUNT_DISTINCT(Id), User__c FROM ucinn_portal_Action_On_Content__c
                                                                            WHERE User__c In :userIds AND Is_Possibility_Processed__c = false
                                                                            AND Times_Viewed__c > 0 GROUP BY User__c];

        for (AggregateResult actionOnContentRecordCount : actionOnContentForUsers) {
            if (Integer.valueOf(actionOnContentRecordCount.get('expr0')) >= actionOnContentLimit) {
                PORTAL_ActionOnContentController.SERVER_runRecommendationCalculation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => (Id) actionOnContentRecordCount.get('User__c')});
            }
        }
    }

     /**
     *  Method gets the user ids for a list of action on content
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @author                                  Ashley Tran
     * @since                                   1.0
     */

    private static Set<Id> getUserIds(List<ucinn_portal_Action_On_Content__c> newList) {
        Set<Id> userIds = new Set<Id>();

        for (ucinn_portal_Action_On_Content__c eachActionOnContentRecord : newList) {
            Id currentUserId = eachActionOnContentRecord.User__c;

            if (currentUserId != null) {
                userIds.add(currentUserId);
            }
        }

        return userIds;
    }

     /**
     *  Method that gets the limit for how many action on content need to be generated before rerunning the calculation
     *
     *
     * @author                                  Ashley Tran
     * @since                                   1.0
     *
     * @return                                  The limit to recalculate
     */

    private static Integer getActionOnContentLimit() {
        try {
            return Integer.valueOf(((List<Portal_Organization_Setting__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
                                        PORTAL_Utils.FIELD_SET => new Set<String>{'Id', 'Value__c'},
                                        PORTAL_Utils.SOBJECT_NAME => 'Portal_Organization_Setting__mdt',
                                        PORTAL_Utils.DEVELOPER_NAME_LIST => new List<String>{'Action_On_Content_Recalculation_Limit'}
                                    })).get(0).Value__c);
        } catch (Exception e) {
            return 10;
        }
    }


}