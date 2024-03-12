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
 * Batch populates FY Contributions on society membership based on the yearly giving of a constituent.
 * Note: Batch is recommded to be ran at midnight daily when dailyMode is set to True.
 *
 * @author          Daniel Mardirousi
 * @version         1.0
 * @since           1.0
 */
global virtual inherited sharing class PORTAL_BATCH_PopulateFYContribution implements Database.Batchable<sObject>{
    private Boolean dailyMode = true;
    private PORTAL_BATCH_PopulateFYContributionBase baseClass;

    /**
     * Default constructor sets base class.
     *
     * @version     1.0
     * @since       1.0
     */
    global PORTAL_BATCH_PopulateFYContribution() {
        this.baseClass = (PORTAL_BATCH_PopulateFYContributionBase)PORTAL_Utils.getControllerFactory().getFYContributionBatchController();
    }

    /**
     * Constructor sets base class and allows daily mode to be toggled.
     *
     * @version     1.0
     * @since       1.0
     */
    global PORTAL_BATCH_PopulateFYContribution(Boolean dailyMode) {
        this.dailyMode = dailyMode;
        this.baseClass = (PORTAL_BATCH_PopulateFYContributionBase)PORTAL_Utils.getControllerFactory().getFYContributionBatchController();
    }

    /**
     * Creates query string for batch
     *
     * @param       bc          Batch Context.
     * @return                  Query locator based on the created query string.
     * @version     1.0
     * @since       1.0
     */
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        String queryString = baseClass.start(new Map<String, Object>{PORTAL_BATCH_PopulateFYContributionBase.dailyBatch => this.dailyMode,
                                                                     PORTAL_BATCH_PopulateFYContributionBase.batchableContext => bc});
        return Database.getQueryLocator(queryString);
    }

    /**
     * Calls base class execute method.
     *
     * @param       bc          Batch Context.
     * @param       contacts    list of contact records from the batch query.
     * @version     1.0
     * @since       1.0
     */
    global virtual void execute(Database.BatchableContext bc, List<Contact> contacts) {
        baseClass.execute(new Map<String, Object>{PORTAL_BATCH_PopulateFYContributionBase.contactRecords => contacts,
                                                    PORTAL_BATCH_PopulateFYContributionBase.batchableContext => bc});
    }

    /**
     * Calls base class finish method.
     *
     * @param       bc          Batch Context.
     * @version     1.0
     * @since       1.0
     */
    global virtual void finish(Database.BatchableContext bc) {
        baseClass.finish(new Map<String, Object>{PORTAL_BATCH_PopulateFYContributionBase.batchableContext => bc});
    }
}