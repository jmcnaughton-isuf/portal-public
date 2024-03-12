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
 * Batch class for adding constituent to zone memberships based on geolocation.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
 */
public virtual class PORTAL_BATCH_AddZoneMemberships implements Database.Batchable<sObject>, Database.Stateful{
    PORTAL_BATCH_AddZoneMembershipsBase batchBase;

    /**
     * Batch class default constructor
     *
     * @since                                               1.0
     */
    public PORTAL_BATCH_AddZoneMemberships() {
        initHelper(new Set<Id>());
    }

    /**
     * Batch class constructor
     *
     * @param   zoneIdsToSkipSet                            Id's that should be skiped
     * @since                                               1.0
     */
    public PORTAL_BATCH_AddZoneMemberships(Set<Id> zoneIdsToSkipSet) {
        initHelper(zoneIdsToSkipSet);
    }

    /**
     * Batch class constructor helper
     *
     * @param   zoneIdsToSkipSet                            Id's that should be skipped
     * @since                                               1.0
     */
    public void initHelper(Set<Id> zoneIdsToSkipSet) {
        batchBase = (PORTAL_BATCH_AddZoneMembershipsBase)PORTAL_Utils.getControllerFactory().getBatchAddZoneMembershipsBase();

        batchBase.batchConstructor(zoneIdsToSkipSet);
    }

    /**
     * Batch class start method
     *
     * @param   context                                     Current batch context.
     * @return                                              Query locator for constituents to potentially add to zone.
     * @since                                               1.0
     */
    public virtual Database.QueryLocator start(Database.BatchableContext context) {
        return batchBase.batchStart(context);
    }

    /**
     * Batch execute start method
     *
     * @param   context                                     Current batch context.
     * @param   contacts                                    Contact records to potentinally add to zone.
     * @since                                               1.0
     */
    public virtual void execute(Database.BatchableContext context, List<Contact> contacts) {
        batchBase.batchExecute(context, contacts);
    }

    /**
     * Batch class finish method
     *
     * @param   context                                     Current batch context.
     * @since                                               1.0
     */
    public virtual void finish(Database.BatchableContext context) {
        batchBase.batchFinish(context);
    }

}