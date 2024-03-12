/*
 * Copyright (c) 2023, UC Innovation, Inc.  All Rights Reserved.
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
 * Record name updater class
 *
 * @author  Todd Shinto
 * @version 1.0
 * @since   1.18
 */
public virtual inherited sharing class PORTAL_RecordNameUpdater {
    public static final String NAME_CONST = 'Name';
    public static final String ID_CONST = 'Id';
    public static final String DEFAULT_NAME = '[Default Name]';

    /**
     * Updates the name of sObject records to the auto number field if the
     * name is equal to the ID, is blank, or is [Default Name]
     *
     * @author: Todd Shinto
     * @since: 1.18
     *
     * @param triggerNew                List of triggerNew
     * @param autoNumberFieldApiName    The API name of an auto number field
     */
    public virtual void updateRecordNames(List<sObject> triggerNew, String autoNumberFieldApiName) {
        List<sObject> sObjectsToUpdate = new List<sObject>();
        for (sObject eachSObject : triggerNew) {
            sObject updatedSObject = this.updateSObjectRecordName(eachSObject, autoNumberFieldApiName);

            if (updatedSObject != null) {
                sObjectsToUpdate.add(updatedSObject);
            }
        }

        if (sObjectsToUpdate.isEmpty()) {
            return;
        }
        
        String sObjectName = sObjectsToUpdate[0].getSObjectType().getDescribe().getName();

        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(sObjectName, false);
        update sObjectsToUpdate;
        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(sObjectName, true);
    }

    /**
     * Updates the name of an sObject record to the auto number field if the
     * name is equal to the ID, is blank, or is [Default Name]
     *
     * @author: Todd Shinto
     * @since: 1.18
     *
     * @param newSObject                The new sObject
     * @param autoNumberFieldApiName    The API name of an auto number field
     */
    public virtual sObject updateSObjectRecordName(sObject newSObject, String autoNumberFieldApiName) {
        String recordName = (String)newSObject.get(NAME_CONST);
        if (String.isNotBlank(recordName) && recordName != DEFAULT_NAME && !this.isNameRecordId(newSObject)) {
            return null;
        }
        
        sObject clonedObj = newSObject.getSObjectType().newSObject();
        clonedObj.put(ID_CONST, newSObject.get(ID_CONST));
        clonedObj.put(NAME_CONST, newSObject.get(autoNumberFieldApiName));

        return clonedObj;
    }

    /**
     * Determines if the name of a record is the ID
     *
     * @author: Todd Shinto
     * @since: 1.18
     *
     * @param newSObject    The sObject to check
     * 
     * @return  Boolean that describes if the name of a record is equal to the ID
     */
    private Boolean isNameRecordId(sObject newSObject) {
        String recordName = (String)newSObject.get(NAME_CONST);
        Id recordId = (Id)newSObject.get(ID_CONST);
        
        return recordId.to15() == recordName || (String)recordId == recordName;
    }
}