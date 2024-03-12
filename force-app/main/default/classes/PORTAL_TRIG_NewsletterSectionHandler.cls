/**
 * @author UC Innovation
 * @date 9/16/2021
 * @group Trigger Handlers
 * @description Handler class for Zone Trigger
 */
global virtual without sharing class PORTAL_TRIG_NewsletterSectionHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {
    private ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper dmlWrapper = new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();

    /*******************************************************************************************************
     * @description Overridden method that handles the trigger actions and calls the relevant logic
     * @return The dmlWrapper with any sObjects to be inserted/updated/deleted
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Newsletter_Section__c.getSObjectType());
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Newsletter_Section__c.getSObjectType());
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterDelete) {
            PORTAL_UTIL_DocumentImageHelper.updateImages(newList, oldList, ucinn_portal_Newsletter_Section__c.getSObjectType());
        }

        return dmlWrapper;
    }
}