public virtual with sharing class PORTAL_SCHEDULER_InterimEmployment implements Schedulable{
    public virtual void execute(SchedulableContext ctx){
        Database.executeBatch(new PORTAL_BATCH_ProcessNewInterimEmployment());
    }
}