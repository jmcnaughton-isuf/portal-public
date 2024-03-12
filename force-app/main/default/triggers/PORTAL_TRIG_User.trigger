trigger PORTAL_TRIG_User on User (before insert, before update, after delete, after insert, after update) {
       ucinn_ascendv2.ascend_TDTM_GlobalAPI.run(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
         Trigger.isUnDelete, Trigger.new, Trigger.old, Schema.Sobjecttype.User);
}