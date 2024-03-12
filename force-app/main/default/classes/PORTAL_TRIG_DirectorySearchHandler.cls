global without sharing class PORTAL_TRIG_DirectorySearchHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            new PORTAL_SearchFilterCacheUpdater(objResult.getName(), newList, oldList, triggerAction).updateSearchCaches();
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            new PORTAL_SearchFilterCacheUpdater(objResult.getName(), newList, oldList, triggerAction).updateSearchCaches();
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeDelete) {
            new PORTAL_SearchFilterCacheUpdater(objResult.getName(), newList, oldList, triggerAction).updateSearchCaches();
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }
}