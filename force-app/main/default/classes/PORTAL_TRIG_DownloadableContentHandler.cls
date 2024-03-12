/*
* Copyright (c) 2024, UC Innovation, Inc.  All Rights Reserved.
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

/**
 * Downloadable_Content__c trigger
 *
 * @author: Jacob Huang
 * @since: 1.19
 */
global virtual without sharing class PORTAL_TRIG_DownloadableContentHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    public static final String DOWNLOADABLE_CONTENT_AUTO_NUMBER_FIELD = 'Downloadable_Content_Name_Auto_Number__c';

    /**
     * Method occurs on every trigger run.
     *
     * @since                                   1.19
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @param   oldList                         List of the old version of the records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the obect in the trigger
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        List<ucinn_portal_Downloadable_Content__c> newContent = (List<ucinn_portal_Downloadable_Content__c>)newList;

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            updateRecordNames(newContent);
        }
    
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    /**
     * Gets a PORTAL_RecordNameUpdater instance. Overridable
     *
     * @author: Jacob Huang (copied Todd Shinto's listing method)
     * @since: 1.19
     *
     * @return An instance of PORTAL_RecordNameUpdater
     * 
     */
    public virtual PORTAL_RecordNameUpdater getRecordNameUpdater() {
        return new PORTAL_RecordNameUpdater();
    }

    /**
     * Updates the names of downloadable content records to the auto name number
     * if the name is blank or [Default Name] or the record's Id
     *
     * @author Jacob Huang (copied Todd Shinto's listing method)
     * @since 1.19
     *
     * @param newContent    The Downloadable Content records from trigger new
     */
    public void updateRecordNames(List<ucinn_portal_Downloadable_Content__c> newContent) {
        PORTAL_RecordNameUpdater controller = this.getRecordNameUpdater();
        controller.updateRecordNames(newContent, DOWNLOADABLE_CONTENT_AUTO_NUMBER_FIELD);
    }
}