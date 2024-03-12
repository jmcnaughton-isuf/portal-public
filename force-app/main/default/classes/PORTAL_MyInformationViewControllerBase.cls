/*
* Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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

public inherited sharing virtual class PORTAL_MyInformationViewControllerBase {
    private final String PAGE_NAME = 'pageName';
    private final String MAIN_SECTION_NAME = 'mainSectionName';
    private final String SUB_SECTION_NAME = 'subSectionName';
    private final String PARENT_FIELD_ID = 'parentFieldId';
    private final String STAGING_RECORD_PARENT_FIELD_ID = 'stagingRecordParentFieldId';

    /**
     * Gets the display info retriever
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @return: PORTAL_MyInfoRetriever
     */
    protected virtual PORTAL_MyInfoRetriever getMyInfoRetriever(PORTAL_MyInfoRetriever.EngineAdapter engine) {
        return new PORTAL_MyInfoRetriever(engine);
    }

    /**
     * Builds page section adapter, then uses it to build Data Retriever
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @param pageName                      String: page name
     * @param mainSectionName               String: main section name 
     * @param subSectionName                String: sub section name
     * @param parentFieldId                 String: parent field id (e.g. contact ID)
     * @param stagingRecordParentFieldId    String: staging record parent field id (e.g. interim ID)
     * 
     * @return: PORTAL_MyInfoRetriever.EngineAdapter
     */
    protected virtual PORTAL_MyInfoRetriever.EngineAdapter getEngine(Map<String, Object> params) {
        PORTAL_PageSectionAdapter pageSectionAdapter = new PORTAL_PageSectionAdapter.Builder()
            .buildPageName((String)params?.get(PAGE_NAME))
            .buildMainSectionName((String)params?.get(MAIN_SECTION_NAME))
            .buildSubSectionName((String)params?.get(SUB_SECTION_NAME))
            .buildParentFieldId((String)params?.get(PARENT_FIELD_ID))
            .buildStagingRecordParentFieldId((String)params?.get(STAGING_RECORD_PARENT_FIELD_ID))
            .build();

        PORTAL_MyInfoPageSectionEngine pageSectionEngine = new PORTAL_MyInfoPageSectionEngine.Builder()
            .buildPageSectionAdapter(pageSectionAdapter)
            .build();

        return pageSectionEngine;
    }

    /**
     * Gets the information for the front end, including records and configuration settings
     *
     * @author: Todd Shinto
     * @since:  1.5
     *
     * @param pageName              String: page name
     * @param mainSectionName       String: main section
     * @param subSectionName        String: subsection
     * 
     * @return: A map of the data required to display information on the front end
     */
    public virtual Map<String, Object> getViewInfo(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return new Map<String, Object>();
        }

        String contactId = PORTAL_CommunityUtils.getLoggedInUserInfo(UserInfo.getUserId())?.ContactId;
        params.put(PARENT_FIELD_ID, contactId);
        params.put(STAGING_RECORD_PARENT_FIELD_ID, getStagingRecordParentFieldId(contactId));
        PORTAL_MyInfoRetriever displayInfoRetriever = this.getMyInfoRetriever(this.getEngine(params));
        return displayInfoRetriever.getDisplayInfo();
    }

    /**
     * Gets the interim Id
     *
     * @author: Todd Shinto
     * @since:  1.5
     * 
     * @return: The ID of the constituent's interim that hasn't been processed yet
     */
    protected virtual String getStagingRecordParentFieldId(String contactId) {
        List<ucinn_ascendv2__Interim__c> interimList = [SELECT Id 
                                                        FROM ucinn_ascendv2__Interim__c 
                                                        WHERE ucinn_ascendv2__Contact__c = :contactId 
                                                        AND ucinn_ascendv2__Status__c = :PORTAL_CONST_PageSectionSetting.INTERIM_DISPLAY_STATUS 
                                                        AND RecordType.DeveloperName = :PORTAL_CONST_PageSectionSetting.INTERIM_RECORD_TYPE_NAME];
        return !interimList.isEmpty() ? (String)(interimList.get(0).Id) : '';
    }
}