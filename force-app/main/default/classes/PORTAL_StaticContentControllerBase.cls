/*
 * Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
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
 * Base controller containing logic for Static Content Management.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
global inherited sharing virtual class PORTAL_StaticContentControllerBase {
    static final String ERROR_GENERAL_GET_MESSAGE = 'There was an issue getting the desired content.';
    static final String ERROR_NO_TEMPLATE_DEFINED = 'There are no Content Module Templates defined in Custom Metadata.';
    static final String ERROR_SAVE_INVALID_PARAMTER = 'There was an issue saving this Content Module: Invalid parameters.';

    public static final String PARAM_PAGE_NAME = 'pageName';
    public static final String PARAM_SUB_PAGE_NAME = 'subPageName';
    public static final String PARAM_MODULE_NAME = 'moduleName';
    public static final String PARAM_ZONE_NAME = 'zoneName';
    public static final String PARAM_PAGE_URL = 'pageUrl';

    public static final String PARAM_RECORD_ID = 'recordId';
    public static final String PARAM_LWC_NAME = 'lwcName';
    public static final String PARAM_CONTENT_MODULE_METADATA = 'contentModuleMetadata';

    @testVisible
    private static Boolean forceException = false;

    /**
     * Gets Content Module Metadata for the Content Module described.
     *
     * @author Aaron Wong
     * @param pageName      Name of the Content Module's Content Page.
     * @param moduleName    Name of the Content Module.
     * @param zoneName      Name of the Zone the Content Module is for (if any).
     * @param pageUrl       URL of the page.
     * @return              Content Module Metadata in the form of a Map.
     */
    global virtual Map<String, Object> getContentModuleMetadata(Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (params == null) {
            return resultMap;
        }

        String pageName = (String)params.get(PARAM_PAGE_NAME);
        String subPageName = (String)params.get(PARAM_SUB_PAGE_NAME);
        String moduleName = (String)params.get(PARAM_MODULE_NAME);
        String pageUrl = (String)params.get(PARAM_PAGE_URL);

        if (String.isBlank(moduleName)) {
            return resultMap;
        }

        String queryString = ' SELECT Content_Module_Metadata__c FROM ucinn_portal_Content_Module__c WHERE Name = :moduleName ';

        if (String.isNotBlank(pageName)) {
            queryString = queryString + ' AND Content_Page__r.Name = :pageName ';
        }

        if (subPageName != null) {
            queryString = queryString + ' AND Content_Page__r.Sub_Page_Name__c = :subPageName ';
        }

        if (String.isBlank(pageName) && String.isNotBlank(pageUrl)) {
            queryString = queryString + ' AND Content_Page__r.Page_URL__c = :pageUrl ';
        }

        queryString = queryString + ' ORDER BY Content_Page__r.Page_URL__c DESC';

        try {
            System.debug(queryString);
            List<ucinn_portal_Content_Module__c> contentModuleList = Database.query(queryString);

            if (contentModuleList == null || contentModuleList.isEmpty() || String.isBlank(contentModuleList.get(0).Content_Module_Metadata__c)) {
                return resultMap;
            }

            String content = contentModuleList.get(0).Content_Module_Metadata__c;

            resultMap = (Map<String, Object>)JSON.deserializeUntyped(content);
        } catch (Exception e) {
        }

        return resultMap;
    }

    /**
     * Gets all Content Module Metadata Template Custom Metadata records.
     *
     * @author  Aaron Wong
     * @return  All Content Module Metadata Template Custom Metadata records.
     * @since   1.0
     */
    global virtual List<Portal_Content_Module_Metadata_Template__mdt> getContentModuleTemplateList(Map<String, Object> params) {
        List<Portal_Content_Module_Metadata_Template__mdt> templateList = (List<Portal_Content_Module_Metadata_Template__mdt>)PORTAL_Utils.getCustomMetadataRecordList(new Map<String, Object>{
            PORTAL_Utils.FIELD_SET => new Set<String>{'LWC_Name__c', 'Metadata_Template__c'},
            PORTAL_Utils.SOBJECT_NAME => 'Portal_Content_Module_Metadata_Template__mdt'
        });

        if (templateList == null || templateList.isEmpty() || forceException == true) {
            throw PORTAL_CommunityUtils.createAuraHandledException(
                        new Map<String, Object>{PORTAL_CommunityUtils.PARAM_KEY_CUSTOM_METADATA_NAME => PORTAL_CONST_Global.DEBUG_AES_KEY_MD_DEVELOPER_NAME,
                                                PORTAL_CommunityUtils.PARAM_CUSTOM_ERROR_MESSAGE => ERROR_NO_TEMPLATE_DEFINED,
                                                PORTAL_CommunityUtils.PARAM_STACKTRACE_STRING => ''});
        }

        return templateList;
    }


    /**
     * Gets the Content Module record with the given record Id.
     *
     * @author Aaron Wong
     * @param recordId          Id of the record to query for.
     * @return                  The content module with the record Id.
     * @since                   1.0
     */
    global virtual ucinn_portal_Content_Module__c getContentModuleByRecordId(Map<String, Object> params) {
        if (params == null) {
            return new ucinn_portal_Content_Module__c();
        }

        String recordId = (String)params.get(PARAM_RECORD_ID);

        if (String.isBlank(recordId)) {
            return new ucinn_portal_Content_Module__c();
        }

        List<ucinn_portal_Content_Module__c> contentModuleList = [SELECT Content_Module_Metadata__c, Related_LWC__c
                                                    FROM ucinn_portal_Content_Module__c
                                                    WHERE id = :recordId];

        if (contentModuleList == null || contentModuleList.isEmpty()) {
            return new ucinn_portal_Content_Module__c();
        }

        return contentModuleList.get(0);
    }

    /**
     * Saves the content module changes.
     *
     * @author Aaron Wong
     * @param recordId                  Id of the Content Module to save.
     * @param lwcName                   LWC name to save.
     * @param contentModuleMetadata     Content Module Metadata to save.
     * @return                          True if the update was a success.
     * @since                           1.0
     */
    global virtual String saveContentModule(Map<String, Object> params) {
        if (params == null) {
            return ERROR_SAVE_INVALID_PARAMTER;
        }

        String recordId = (String)params.get(PARAM_RECORD_ID);
        String lwcName = (String)params.get(PARAM_LWC_NAME);
        String contentModuleMetadata = (String)params.get(PARAM_CONTENT_MODULE_METADATA);

        if (String.isBlank(recordId) || String.isBlank(lwcName)) {
            return ERROR_SAVE_INVALID_PARAMTER;
        }

        try {
            update new ucinn_portal_Content_Module__c(id = recordId,
                                                      Related_LWC__c = lwcName,
                                                      Content_Module_Metadata__c = contentModuleMetadata);
        } catch (Exception e) {
            return e.getMessage();
        }

        return 'SUCCESS';
    }

    /**
     * Gets the Page CSS classes for the current content page
     *
     * @author Sean Tang
     * @param pageUrl           The pathname part of the page's URL to get the content page for.
     * 
     * @return                  A content page's css classes as a string that should be applied to the current page
     * @since                   1.1
     */
    global virtual String getContentPageCSSClasses(Map<String, Object> params) {
        String pageUrl = getParsedPageUrl((String)params?.get(PARAM_PAGE_URL));

        if (String.isBlank(pageUrl)) {
            return '';
        }

        List<ucinn_portal_Content_Page__c> contentPageList = [SELECT Page_CSS_Classes__c
                                                              FROM ucinn_portal_Content_Page__c
                                                              WHERE Page_URL__c = :pageUrl
                                                              ORDER BY Page_CSS_Classes__c NULLS LAST];

        if (contentPageList != null && !contentPageList.isEmpty() && String.isNotBlank(contentPageList.get(0).Page_CSS_Classes__c)) {
            return contentPageList.get(0).Page_CSS_Classes__c;
        }
        
        // If not specific content page's found, look from wildcard pages
        // returns empty string if none found
        return getWildcardContentPageCSS(pageUrl);
    }

    /**
     * Gets the page css classes from potential content pages that contains wildcard URL's
     *
     * @author Sean Tang
     * @param pageUrl       The URL for the current page in the content page field value format
     * 
     * @return              Page css classes from a wildcard containing content page
     *                      if there is a regular expression match, returns empty string if none found
     * 
     * @since               1.1
     */
    protected virtual String getWildcardContentPageCSS(String pageUrl) {
        List<ucinn_portal_Content_Page__c> contentPageList = [SELECT Page_URL__c, Page_CSS_Classes__c
                                                              FROM ucinn_portal_Content_Page__c
                                                              WHERE Page_URL__c LIKE '%*%'];
                                                              
        for (ucinn_portal_Content_Page__c eachContentPage : contentPageList) {
            String wildcardUrlAsRegex = '^' + eachContentPage.Page_URL__c.replaceAll('\\*', '.*') + '$';

            Pattern urlMatcher = Pattern.compile(wildcardUrlAsRegex);
            Matcher urlMatches = urlMatcher.matcher(pageUrl);

            if (urlMatches.find()) {
                return eachContentPage.Page_CSS_Classes__c;
            }
        }

        return '';
    }

    /**
     * Gets the Page url thats in the format of a content page's url field value
     *
     * @author Sean Tang
     * @param pageUrl       The pathname part of the page's URL to get the content page for.
     * 
     * @return              Page url thats in the format of a content page's url field value as a string
     * @since               1.1
     */
    protected virtual String getParsedPageUrl(String pageUrl) {
        if (String.isBlank(pageUrl)) {
            return '';
        }

        Integer searchStart = pageUrl.indexOf('/s/') + 3;
        Integer slashIndex = pageUrl.indexOf('/', searchStart);

        return (slashIndex == -1) ? pageUrl : pageUrl.substring(0, slashIndex);
    }
}