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
 */

 trigger PORTAL_TRIG_ActionOnContent on ucinn_portal_Action_On_Content__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    ucinn_ascendv2.ascend_TDTM_GlobalAPI.run(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
    Trigger.isUnDelete, Trigger.new, Trigger.old, Schema.Sobjecttype.ucinn_portal_Action_On_Content__c);
}