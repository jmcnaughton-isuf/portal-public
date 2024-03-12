/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Performs dml operations on the objects provided. Allows for delayed dml operations
 * to efficiently batch them.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing virtual class PORTAL_DMLWrapper {
    public enum DmlOperation {INSERT_OP, UPDATE_OP, UPSERT_OP, DELETE_OP}

    private Map<String, List<SObject>> insertMap;
    private Map<String, List<SObject>> updateMap;
    private Map<String, List<SObject>> upsertMap;
    private Map<String, List<SObject>> deleteMap;

    /**
     * Getter for insert map.
     *
     * @author Aaron Wong
     *
     * @return  The insert map.
     * @since   1.0
     */
    public Map<String, List<SObject>> getInsertMap() {
        if (this.insertMap == null) {
            this.insertMap = new Map<String, List<SObject>>();
        }

        return this.insertMap;
    }

    /**
     * Setter for insert map.
     *
     * @author Aaron Wong
     *
     * @param insertMap     The insert map to set
     * @return              The insert map.
     * @since   1.0
     */
    public Map<String, List<SObject>> setInsertMap(Map<String, List<SObject>> insertMap) {
        this.insertMap = insertMap;

        return insertMap;
    }

    /**
     * Getter for update map.
     *
     * @author Aaron Wong
     *
     * @return  The update map.
     * @since   1.0
     */
    public Map<String, List<SObject>> getUpdateMap() {
        if (this.updateMap == null) {
            this.updateMap = new Map<String, List<SObject>>();
        }

        return this.updateMap;
    }

    /**
     * Setter for update map.
     *
     * @author Aaron Wong
     *
     * @param insertMap     The update map to set
     * @return              The update map.
     * @since   1.0
     */
    public Map<String, List<SObject>> setUpdateMap(Map<String, List<SObject>> updateMap) {
        this.updateMap = updateMap;

        return updateMap;
    }

    /**
     * Getter for upsert map.
     *
     * @author Aaron Wong
     *
     * @return  The upsert map.
     * @since   1.0
     */
    public Map<String, List<SObject>> getUpsertMap() {
        if (this.upsertMap == null) {
            this.upsertMap = new Map<String, List<SObject>>();
        }

        return this.upsertMap;
    }

    /**
     * Setter for upsert map.
     *
     * @author Aaron Wong
     *
     * @param insertMap     The upsert map to set
     * @return              The upsert map.
     * @since   1.0
     */
    public Map<String, List<SObject>> setUpsertMap(Map<String, List<SObject>> upsertMap) {
        this.upsertMap = upsertMap;

        return upsertMap;
    }

    /**
     * Getter for delete map.
     *
     * @author Aaron Wong
     *
     * @return  The delete map.
     * @since   1.0
     */
    public Map<String, List<SObject>> getDeleteMap() {
        if (this.deleteMap == null) {
            this.deleteMap = new Map<String, List<SObject>>();
        }

        return this.deleteMap;
    }

    /**
     * Setter for delete map.
     *
     * @author Aaron Wong
     *
     * @param insertMap     The delete map to set
     * @return              The delete map.
     * @since   1.0
     */
    public Map<String, List<SObject>> setDeleteMap(Map<String, List<SObject>> deleteMap) {
        this.deleteMap = deleteMap;

        return deleteMap;
    }

    /**
     * Constructor for the object
     *
     * @author Aaron wong
     * @since   1.0
     */
    public PORTAL_DMLWrapper() {
        this.insertMap = new Map<String, List<SObject>>();
        this.updateMap = new Map<String, List<SObject>>();
        this.upsertMap = new Map<String, List<SObject>>();
        this.deleteMap = new Map<String, List<SObject>>();
    }

    /**
     * Copy Constructor for the object
     *
     * @author Aaron wong
     * @since   1.0
     */
    public PORTAL_DMLWrapper(PORTAL_DmlWrapper dmlWrapper) {
        this.insertMap = new Map<String, List<SObject>>(dmlWrapper.getInsertMap());
        this.updateMap = new Map<String, List<SObject>>(dmlWrapper.getUpdateMap());
        this.upsertMap = new Map<String, List<SObject>>(dmlWrapper.getUpsertMap());
        this.deleteMap = new Map<String, List<SObject>>(dmlWrapper.getDeleteMap());
    }

    /**
     * Adds an sobject record for DML.
     *
     * @author Aaron Wong
     *
     * @param objectApiName     The object api name of the record.
     * @param objectRecord      The object record to add.
     * @param dmlOp             The DML operation to perform on the record.
     * @since                   1.0
     */
    public void addRecordForDML(String objectApiName, SObject objectRecord, DmlOperation dmlOp) {
        Map<String, List<SObject>> dmlMap = this.getMapByDmlOperation(dmlOp);

        if (!dmlMap.containsKey(objectApiName)) {
            dmlMap.put(objectApiName, new List<SObject>());
        }

        dmlMap.get(objectApiName).add(objectRecord);
    }

    /**
     * Adds an sobject record list for DML.
     *
     * @author Aaron Wong
     *
     * @param objectApiName     The object api name of the record.
     * @param recordList        The object record list to add.
     * @param dmlOp             The DML operation to perform on the record.
     * @since                   1.0
     */
    public void addRecordListForDML(String objectApiName, List<SObject> recordList, DmlOperation dmlOp) {
        if (recordList == null || recordList.isEmpty()) {
            return;
        }

        Map<String, List<SObject>> dmlMap = this.getMapByDmlOperation(dmlOp);

        if (!dmlMap.containsKey(objectApiName)) {
            dmlMap.put(objectApiName, new List<SObject>());
        }

        dmlMap.get(objectApiName).addAll(recordList);
    }

    public void addDMLWrapper(PORTAL_DMLWrapper dmlWrapper) {
        if (dmlWrapper == null) {
            return;
        }
        
        List<DmlOperation> dmlList = new List<DmlOperation>{DmlOperation.INSERT_OP, DmlOperation.UPDATE_OP, 
                                                            DmlOperation.UPSERT_OP, DmlOperation.DELETE_OP};

        for (DmlOperation eachDmlOp : dmlList) {
            Map<String, List<SObject>> dmlMap = dmlWrapper.getMapByDmlOperation(eachDmlOp);

            for (String eachObjectName : dmlMap.keySet()) {
                this.addRecordListForDML(eachObjectName, dmlMap.get(eachObjectName), eachDmlOp);
            }
        }
    }

    /**
     * Inserts the records in the insert map.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    public virtual void insertRecords() {
        Map<String, List<SObject>> insertMap = this.getInsertMap();

        for (List<SObject> sObjectList : insertMap.values()) {
            insert sObjectList;
        }
    }

    /**
     * Updates the records in the update map.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    public virtual void updateRecords() {
        Map<String, List<SObject>> updateMap = this.getUpdateMap();

        for (List<SObject> sObjectList : updateMap.values()) {
            update sObjectList;
        }
    }

    /**
     * Upserts the records in the upsert map.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    public virtual void upsertRecords() {
        Map<String, List<SObject>> upsertMap = this.getUpsertMap();

        for (List<SObject> sObjectList : upsertMap.values()) {
            upsert sObjectList;
        }
    }

    /**
     * Deletes the records in the delete map.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    public virtual void deleteRecords() {
        Map<String, List<SObject>> deleteMap = this.getDeleteMap();

        for (List<SObject> sObjectList : deleteMap.values()) {
            delete sObjectList;
        }
    }

    /**
     * Performs all DML operations cached in the object.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    public virtual void performDmlOperations() {
        this.insertRecords();
        this.updateRecords();
        this.upsertRecords();
        this.deleteRecords();
        
    }

    /**
     * Gets a map using the given dml operation.
     *
     * @author Aaron Wong
     *
     * @param dmlOp     Dml Operation to get the map by.
     * @return          Map used to store objects for the DML operation.
     * @since           1.0
     */
    private Map<String, List<SObject>> getMapByDmlOperation(DmlOperation dmlOp) {
        if (dmlOp === DmlOperation.INSERT_OP) {
            return this.getInsertMap();
        }

        if (dmlOp === DmlOperation.UPDATE_OP) {
            return this.getUpdateMap();
        }

        if (dmlOp === DmlOperation.UPSERT_OP) {
            return this.getUpsertMap();
        }

        if (dmlOp === DmlOperation.DELETE_OP) {
            return this.getDeleteMap();
        }

        return new Map<String, List<SObject>>();
    }
}