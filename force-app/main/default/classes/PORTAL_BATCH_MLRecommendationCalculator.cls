public virtual class PORTAL_BATCH_MLRecommendationCalculator implements Database.Batchable<sObject>{

    public PORTAL_BATCH_MLRecommendationCalculator() {

    }

    public virtual Database.QueryLocator start(Database.BatchableContext context) {
        String queryString = 'SELECT Id FROM User WHERE ID IN (SELECT User__c FROM ucinn_portal_Action_On_Content__c WHERE Is_Possibility_Processed__c = false) AND UserType != \'Guest\'';
        return Database.getQueryLocator(queryString);
    }

    public virtual void execute(Database.BatchableContext context, List<sObject> userList) {
        PORTAL_ActionOnContentBase controller = (PORTAL_ActionOnContentBase)PORTAL_Utils.getControllerFactory().getActionOnContentController();

        for (sObject usr : userList) {
            try {
                controller.runRecommendationCalculation(new Map<String, Object>{PORTAL_CONST_ActionOnContent.USER_ID_KEY => String.valueOf(usr.get('Id'))});
            } catch (Exception e) {

            }
        }
    }

    public virtual void finish(Database.BatchableContext context) {
        System.debug('Job has finished');
    }

}