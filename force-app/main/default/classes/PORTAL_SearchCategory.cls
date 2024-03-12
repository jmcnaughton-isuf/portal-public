/**
 * This class is equivalent to a Search Category in the Directory. It is used to capture
 * passed in data from the portal_Directory LWC.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing class PORTAL_SearchCategory {
    public static final String OBJECT_API_NAME = 'objectApiName';
    public static final String SEARCH_CRITERIA_LIST = 'searchCriteriaList';

    @AuraEnabled
    public List<PORTAL_SearchCriteria> searchCriteriaList {get; set;}          // List of Search Criteria for the Search Category
    @AuraEnabled
    public String objectApiName {get; set;}                                     // API name of the object tied to this Search Group

    public PORTAL_SearchCategory() {}

    public PORTAL_SearchCategory(Object objectRecord) {
        if (objectRecord == null) {
            return;
        }

        Map<Object, Object> objectMap = (Map<Object, Object>)objectRecord;

        if (objectMap.get(SEARCH_CRITERIA_LIST) != null) {
            this.searchCriteriaList = new List<PORTAL_SearchCriteria>();

            for (Object eachCriteriaObject : (List<Object>)objectMap.get(SEARCH_CRITERIA_LIST)) {
                this.searchCriteriaList.add(new PORTAL_SearchCriteria(eachCriteriaObject));
            }
        }

        this.objectApiName = (String)objectMap.get(OBJECT_API_NAME);
    }
}