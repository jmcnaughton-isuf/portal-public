public virtual with sharing class PORTAL_SCHEDULER_MLRecommendationEngine implements Schedulable{
    public virtual void execute(SchedulableContext ctx){
        Database.executeBatch(new PORTAL_BATCH_MLRecommendationCalculator());
    }
}