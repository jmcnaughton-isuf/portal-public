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
 * Resource pool for SObject Information.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing class PORTAL_SObjectInfoPool {
    public Map<String, Schema.sObjectType> objectNameToSObjectTypeMap;
    private static PORTAL_SObjectInfoPool instance;

    /**
     * Private constructor for the resource pool.
     *
     * @author Aaron Wong
     * @since  1.0
     */
    private PORTAL_SObjectInfoPool() {
        objectNameToSObjectTypeMap = new Map<String, Schema.sObjectType>();
    }

    /**
     * Gets the SObject Type for the given object api name.
     *
     * @author Aaron Wong
     *
     * @param objectApiName     The object api name to get the type for.
     * @return                  The SObject Type of the given object API name.
     * @since                   1.0
     */
    public Schema.sObjectType getSObjectType(String objectApiName) {
        if (!this.objectNameToSObjectTypeMap.containsKey(objectApiName)) {
            this.objectNameToSObjectTypeMap.put(objectApiName, ((SObject)(Type.forName('Schema.' +  objectApiName)?.newInstance()))?.getSObjectType());
        }

        return this.objectNameToSObjectTypeMap.get(objectApiName);
    }

    /**
     * Get the instance of the resource pool.
     *
     * @author Aaron Wong
     *
     * @return  Global instance of the resource pool.
     * @since   1.0
     */
    public static PORTAL_SObjectInfoPool getInstance() {
        if (instance == null) {
            instance = new PORTAL_SObjectInfoPool();
        }

        return instance;
    }
}