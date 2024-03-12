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
 * Wrapper class to extend SObject functionality.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing virtual class PORTAL_SObjectWrapper {
    private SObject sObjectRecord;

    private Schema.SObjectType sObjectType;

    /**
     * Gets the SObject record.
     *
     * @author Aaron Wong
     *
     * @return  A clone of the SObject record.
     * @since   1.0
     */
    public SObject getSObjectRecord() {
        return this.sObjectRecord?.clone(true, true, false, false);
    }

    /**
     * Constructor for the wrapper class.
     *
     * @author Aaron Wong
     *
     * @param sObjectRecord     The SObject record.
     * @since                   1.0
     */
    public PORTAL_SObjectWrapper(SObject sObjectRecord) {
        this.sObjectRecord = sObjectRecord;
    }

    /**
     * Puts the value into the field given.
     *
     * @author Aaron wong
     *
     * @param fieldApiName      Field to put the value in.
     * @param value             Value to insert.
     * @return                  True if success, false if failed.
     * @since                   1.0
     */
    public Boolean put(String fieldApiName, Object value) {
        try {
            this.sObjectRecord.put(fieldApiName, value);
        } catch (Exception e) {
            System.debug(e);
            return false;
        }

        return true;
    }

    /**
     * Gets the value of the given field.
     *
     * @author Aaron Wong
     *
     * @param fieldApiName      Field to get the value of.
     * @return                  The value of the field.
     * @since                   1.0
     */
    public Object get(String fieldApiName) {
        Object resultObject = null;

        if (String.isBlank(fieldApiName)) {
            return resultObject;
        }

        List<String> fieldApiNameList = fieldApiName.split('\\.');
        SObject nestedSObject = this.sObjectRecord;

        for (Integer fieldIndex = 0; fieldIndex < fieldApiNameList.size(); fieldIndex++) {
            if (fieldIndex == fieldApiNameList.size() - 1) {
                resultObject = nestedSObject?.get(fieldApiNameList.get(fieldIndex));
                break;
            }

            nestedSObject = nestedSObject.getSObject(fieldApiNameList.get(fieldIndex));
        }

        return resultObject;
    }

    /**
     * Gets a list of SObjects from the SObject.
     *
     * @author Aaron Wong
     *
     * @param fieldApiName      Field containing the list of SObjects.
     * @return                  List of SObjects.
     * @since                   1.0
     */
    public List<SObject> getSObjects(String fieldApiName) {
        return this.sObjectRecord.getSObjects(fieldApiName);
    }

    /**
     * Gets the SObject type of the SObject record.
     *
     * @author Aaron Wong
     *
     * @return  The SObject Type.
     * @since   1.0
     */
    public Schema.SObjectType getSObjectType() {
        if (this.sObjectType == null) {
            this.sObjectType = this.sObjectRecord?.getSObjectType();
        }

        return this.sObjectType;
    }

    /**
     * Creates a new instance of the SObjectWrapper with an object Api Name.
     *
     * @author Aaron Wong
     *
     * @param objectApiName     The object api name to construct the SObject with.
     * @return                  An instance of PORTAL_SObjectWrapper.
     * @since                   1.0
     */
    public static PORTAL_SObjectWrapper newInstance(String objectApiName) {
        SObject newSObject = PORTAL_SObjectInfoPool.getInstance().getSObjectType(objectApiName).newSObject();

        return new PORTAL_SObjectWrapper(newSObject);
    }
}