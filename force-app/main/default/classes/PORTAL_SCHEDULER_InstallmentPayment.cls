public virtual with sharing class PORTAL_SCHEDULER_InstallmentPayment implements Schedulable{
    public virtual void execute(SchedulableContext ctx){
        ucinn_ascendv2.ascend_UTIL_RunBatch.ascend_GIFT_InstallmentPayment(null, 1);
    }
}