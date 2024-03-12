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
* batch that calls EmailHub's create or update Lists to batch out calls especially for services that must process zones one at a time
*
* @author:  Sam Longo
* @version: 1.0
* @since:   1.0
*/
global virtual class PORTAL_BATCH_EmailApiZones implements Database.Batchable<sObject>, Database.AllowsCallouts {

    Set<Id> zoneIds = null;

    /**
     * constructor for batching over ALL zones
     */
    global PORTAL_BATCH_EmailApiZones() {

    }

    /**
     * constructor for restricting batch to a set of zones
     */
    public PORTAL_BATCH_EmailApiZones(Set<Id> Ids) {
        zoneIds = Ids;
    }

    /**
     * start method for the batch
     *
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     *
     * @return                 the query locator for this batch
     */
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        String whereClause = '';
        if (zoneIds != null) {
            whereClause = 'WHERE Id IN :zoneIds';
        }
        return Database.getQueryLocator('SELECT Id FROM ucinn_portal_Zone__c ' + whereClause);
    }

    /**
     * method that calls the emailhub's createOrUpdateExternalMailingLists to process the zones
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     */
    global virtual void execute(Database.BatchableContext context, List<sObject> zones) {

        Set<Id> idsToProcess = new Set<Id>();
        for(SObject zone : zones) {
            idsToProcess.add(zone.Id);
        }

        PORTAL_API_EmailHubBase.createOrUpdateExternalMailingListsNonFuture(idsToProcess);
    }

    /**
     * finish method
     *
     * @author: Sam Longo
     * @since: 1.0
     *
     *
     */
    global virtual void finish(Database.BatchableContext context) {
    }

}