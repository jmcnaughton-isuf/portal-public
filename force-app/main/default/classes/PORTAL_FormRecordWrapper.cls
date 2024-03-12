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
 * Wrapper class for form data submitted from LWC.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing virtual class PORTAL_FormRecordWrapper {
    public static final String FORM_DATA = 'formData';
    public static final String IS_DELETED = 'isDeleted';

    @AuraEnabled
    public Map<String, Object> formData {get; set;}
    @AuraEnabled
    public Boolean isDeleted {get; set;}

    /**
     * Constructor for the wrapper class using form data.
     *
     * @author Aaron wong
     *
     * @param formData      Form data to create the wrapper with.
     * @since               1.0
     */
    public PORTAL_FormRecordWrapper(Map<String, Object> formData) {
        this.formData = formData;
        this.isDeleted = false;
    }

    /**
     * Constructor for the wrapper class using form data and isDeleted.
     *
     * @author Aaron wong
     *
     * @param formData      Form data to create the wrapper with.
     * @param isDeleted     Whether or not the record was deleted from the front end.
     * @since               1.0
     */
    public PORTAL_FormRecordWrapper(Map<String, Object> formData, Boolean isDeleted) {
        this.formData = formData;
        this.isDeleted = isDeleted;
    }

    /**
     * Constructor for the wrapper class using an object from LWC.
     *
     * @author Aaron wong
     *
     * @param objectRecord      Object representation of the form data wrapper.
     * @since                   1.0
     */
    public PORTAL_FormRecordWrapper(Object objectRecord) {
        // objectRecord = {'formData' => Map<String, Object>, 'isDeleted' => Boolean}
        Map<Object, Object> objectMap = (Map<Object, Object>)objectRecord;
        this.formData = this.convertObjectToStringMap(objectMap.get(FORM_DATA));
        this.isDeleted = (Boolean)objectMap.get(IS_DELETED);
    }

    /**
     * Converts to object to a map of string object.
     *
     * @author Aaron Wong
     *
     * @param objectRecord      Object to convert.
     * @return                  Map of String to Object.
     * @since                   1.0
     */
    private Map<String, Object> convertObjectToStringMap(Object objectRecord) {
        Map<String, Object> resultMap = new Map<String, Object>();

        if (objectRecord == null) {
            return resultMap;
        }

        Map<Object, Object> objectMap = (Map<Object, Object>) objectRecord;

        for (Object eachKey : objectMap.keySet()) {
            resultMap.put(String.valueOf(eachKey), objectMap.get(eachKey));
        }

        return resultMap;
    }

}