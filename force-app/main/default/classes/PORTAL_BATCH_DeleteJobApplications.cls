/*
* Copyright (c) 2021, UC Innovation, Inc.  All Rights Reserved.
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
* batch that deletes temporary job applications
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/
public virtual class PORTAL_BATCH_DeleteJobApplications implements Database.Batchable<sObject> {


    /**
     * start method for the batch that gets the query locator
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @return                 the query locator for this batch
     */
    public virtual Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM ucinn_portal_Job_Application__c WHERE Status__c = \'Temporary\'');
    }

    /**
     * method that retrieves the content documents and deletes them along with the
     * job application
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     *
     */
    public virtual void execute(Database.BatchableContext context, List<sObject> jobApplications) {
        Map<Id, sObject> idToJobApplicationMap = new Map<Id, sObject>(jobApplications);
        List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :idToJobApplicationMap.keySet()];
        if (links != null && !links.isEmpty()) {
            List<Id> documentIds = new List<Id>();
            for (ContentDocumentLink link : links) {
                documentIds.add(link.ContentDocumentId);
            }
            delete [SELECT Id FROM ContentDocument WHERE Id IN :documentIds];
        }
        delete jobApplications;
    }

    /**
     * finish method
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     */

    public virtual void finish(Database.BatchableContext context) {

    }

}