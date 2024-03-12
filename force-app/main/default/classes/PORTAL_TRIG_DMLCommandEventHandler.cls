/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
 *                     https://www.ucinnovation.com
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
 * DML Command Event Trigger Handler
 * Used for RTv2 in payment hub controller base by moving the dml call to be ran as an Automated Process User.
 * Is not restricted just for RTv2
 * 
 * @author  Phillip Nguyen
 * @since   1.0
 */
global without sharing class PORTAL_TRIG_DMLCommandEventHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{

    /**
     *  Code to fire after Portal DML Command Event platform event insertion
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param   newList                         List of the new platform event
     * @param   oldList                         List of the old platform event
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the object in the trigger
     *
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        List<Portal_DML_Command_Event__e> newDmlCommandEventList = (List<Portal_DML_Command_Event__e>) newList;

        PORTAL_DMLCommandEventBase controller = (PORTAL_DMLCommandEventBase)PORTAL_Utils.getControllerFactory().getDMLCommandEventBase();

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            for (Portal_DML_Command_Event__e eachDmlCommandEvent : newDmlCommandEventList) {
                controller.handleDMLCommandEvent(eachDmlCommandEvent);
            }
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }
}