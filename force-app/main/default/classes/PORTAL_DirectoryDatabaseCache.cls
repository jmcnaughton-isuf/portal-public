public virtual without sharing class PORTAL_DirectoryDatabaseCache implements Schedulable {
    Map<String, List<List<PORTAL_SearchCriteria>>> objectApiNameToCriteriaMap;

    public PORTAL_DirectoryDatabaseCache(Map<String, List<List<PORTAL_SearchCriteria>>> objectApiNameToCriteriaMap) {
        this.objectApiNameToCriteriaMap = objectApiNameToCriteriaMap;
    }

    public virtual void execute(SchedulableContext SC) {
        run();
    }

    public void run() {
        for (String objectApiName : objectApiNameToCriteriaMap.keySet()) {
            for (Integer i = 0; i < objectApiNameToCriteriaMap.get(objectApiName).size(); i++) {
                List<PORTAL_SearchCriteria> criteriaList = objectApiNameToCriteriaMap.get(objectApiName).get(i);
                List<PORTAL_SearchCategory> searchGroupList = new List<PORTAL_SearchCategory>();
                PORTAL_SearchCategory searchGroup = new PORTAL_SearchCategory();

                searchGroup.searchCriteriaList = criteriaList;
                searchGroup.objectApiName = objectApiName;

                searchGroupList.add(searchGroup);

                PORTAL_DirectoryControllerBase controller = (PORTAL_DirectoryControllerBase)PORTAL_Utils.getControllerFactory().getDirectoryController();

                Map<String, Object> params = new Map<String, Object>{'searchCriteriaList' => new List<PORTAL_SearchCriteria>(),
                                                                     'searchGroupList' => searchGroupList,
                                                                     'zone' => 'Main'};
                System.debug(controller.getContacts(params));
            }
        }
    }
}