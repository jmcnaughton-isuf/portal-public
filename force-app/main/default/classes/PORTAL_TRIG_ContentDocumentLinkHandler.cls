/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * ContentDocumentLink trigger handler to change visibility of uploaded files
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */
global virtual inherited sharing class PORTAL_TRIG_ContentDocumentLinkHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{

    /**
     *  Method occurs on every trigger run on ContentDocumentLink Object
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param   newList                         List of the new up to date version of the ContentDocumentLink records from the triggers
     * @param   oldList                         List of the old version of the ContentDocumentLink records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the object in the trigger
     *
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            List<ContentDocumentLink> newContentDocumentLinkList = (List<ContentDocumentLink>) newList;

            for(ContentDocumentLink eachContentDocumentLink : newContentDocumentLinkList) {
                eachContentDocumentLink.Visibility = 'AllUsers';
            }
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }
}