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
 * LWC controller for the Edit Content Module Metadata quickaction button.
 *
 * @author  Aaron Wong
 * @version 1.0
 * @since   1.0
 */
global virtual inherited sharing class PORTAL_LWC_EditContentModuleController {
    /**
     * Gets a list of Content Module Templates from Custom Metadata.
     *
     * @author Aaron Wong
     *
     * @return  List of Content Module Templates.
     * @since   1.0
     */
    @AuraEnabled(cacheable=true)
    public static List<Portal_Content_Module_Metadata_Template__mdt> SERVER_getContentModuleTemplateList(Map<String, Object> params) {
        PORTAL_StaticContentControllerBase controller = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();

        return controller.getContentModuleTemplateList(params);
    }

    /**
     * Gets a content module by record Id.
     *
     * @author Aaron Wong
     *
     * @param recordId      Id of the content module record.
     * @return              Content Module with the record Id given.
     * @since               1.0
     */
    @AuraEnabled(cacheable=true)
    public static ucinn_portal_Content_Module__c SERVER_getContentModuleByRecordId(Map<String, Object> params) {
        PORTAL_StaticContentControllerBase controller = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();

        return controller.getContentModuleByRecordId(params);
    }

    /**
     * Saves the content module with the information gien.
     *
     * @author Aaron Wong
     *
     * @param contentModuleMetadata     Content Module Metadata to save.
     * @param lwcName                   LWC name to save.
     * @param recordId                  Record Id of the content module to save to.
     * @return                          Boolean determining if the content module saved.
     * @since                           1.0
     */
    @AuraEnabled
    public static String SERVER_saveContentModule(Map<String, Object> params){
        PORTAL_StaticContentControllerBase controller = (PORTAL_StaticContentControllerBase)PORTAL_Utils.getControllerFactory().getStaticContentController();

        return controller.saveContentModule(params);
    }
}