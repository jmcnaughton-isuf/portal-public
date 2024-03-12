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
 * Address geolocation batch using ArcGis geocoding API.
 *
 * @author      Daniel Mardirousi
 * @version     1.0
 * @since       1.0
*/
global virtual without sharing class PORTAL_BATCH_ArcGisAddressGeocoding implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    PORTAL_AddressGeocodingBatchBase batchBaseController;

    /**
     * Set base class on initialization and calls its constructor method.
     *
     * @version                                         1.0
     * @since                                           1.0
     */
    global PORTAL_BATCH_ArcGisAddressGeocoding(String sobjectAPIName, Set<String> geolocationFieldSet, Map<String, List<String>> fieldMap) {
        batchBaseController = (PORTAL_AddressGeocodingBatchBase)PORTAL_Utils.getControllerFactory().getAddressGeocodingBatchBase();
        batchBaseController.sobjectAPIName = sobjectAPIName;
        batchBaseController.geolocationFieldSet = geolocationFieldSet;
        batchBaseController.fieldMap = fieldMap;

        batchBaseController.arcGisGeolocationBatchConstructor();
    }

    /**
     * Calls the base classes start method.
     *
     * @param       bc                                  Context of the current batch.
     * @return                                          Query locator for the specified address query.
     * @version                                         1.0
     * @since                                           1.0
     */
    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        return batchBaseController.arcGisGeolocationBatchStart(bc);
    }

    /**
     * Calls the base classes execute method.
     *
     * @param       bc                                  Context of the current batch.
     * @param       addressRecords                      Address records to geolocate.
     * @version                                         1.0
     * @since                                           1.0
     */
    global virtual void execute (Database.BatchableContext bc, List<sObject> recordList) {
        batchBaseController.arcGisGeolocationBatchExecute(bc, recordList);
    }

    /**
     * Calls the base classes finish method
     *
     * @version                                         1.0
     * @since                                           1.0
     */
    global virtual void finish(Database.BatchableContext bc) {
        batchBaseController.arcGisGeolocationBatchFinish(bc);
    }

}