public inherited sharing class PORTAL_LWC_DirectoryController {
    public static final String FIRST_NAME = 'firstName';
    public static final String LAST_NAME = 'lastName';
    public static final String DEGREE_LIST = 'degreeList';
    public static final String AFFILIATION_LIST = 'affiliationList';
    public static final String JOB_TITLE = 'jobTitle';
    public static final String ACCOUNT_NAME = 'accountName';
    public static final String DEGREE_YEAR = 'degreeYear';
    public static final String DEGREE_CONST = 'degree';

    /**
     * Gets contacts using the search criteria specified.
     *
     * @author Aaron Wong
     *
     * @param searchText            The search text used for searching constituent names.
     * @param searchCriteriaList    List of search criteria.
     * @param searchGroupList       List of search groups.
     * @param itemsPerPage          Items to get per page.
     * @param zone                  The directory's zone.
     * @return                      List of contact display wrappers.
     * @since                       1.0
     */
    @AuraEnabled
    public static List<PORTAL_DirectoryControllerBase.ContactDisplayWrapper> SERVER_getContacts(Map<String, Object> params) {
        PORTAL_DirectoryControllerBase baseController = (PORTAL_DirectoryControllerBase)PORTAL_Utils.getControllerFactory().getDirectoryController();

        return baseController.getContacts(params);
    }

    @AuraEnabled
    public static List<Portal_Directory_Search_Criteria__mdt> SERVER_getSearchDisplaySettings(Map<String, Object> params){
        PORTAL_DirectoryControllerBase baseController = (PORTAL_DirectoryControllerBase)PORTAL_Utils.getControllerFactory().getDirectoryController();

        return baseController.getSearchDisplaySettings(params);
    }

    /**
     * Gets all the display options for the Directory when searching a lookup or picklist.
     *
     * @author Aaron Wong
     *
     * @param displaySettingList        The list of display settings.
     * @param searchText                Search text for filtering results.
     * @param maxItems                  The maximum number of items to show.
     * @return                          List of display options.
     * @since                           1.0
     */
    @AuraEnabled
    public static List<Object> SERVER_getAllDisplayOptions(Map<String, Object> params) {
        PORTAL_DirectoryControllerBase baseController = (PORTAL_DirectoryControllerBase)PORTAL_Utils.getControllerFactory().getDirectoryController();

        return baseController.getAllDisplayOptions(params);
    }
}