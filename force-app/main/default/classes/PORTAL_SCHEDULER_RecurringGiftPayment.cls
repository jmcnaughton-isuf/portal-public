public virtual with sharing class PORTAL_SCHEDULER_RecurringGiftPayment implements Schedulable{
    public virtual void execute(SchedulableContext ctx){
        ucinn_ascendv2.ascend_UTIL_RunBatch.ascend_GIFT_RecurringGiftPayment(null, 1);
    }
}