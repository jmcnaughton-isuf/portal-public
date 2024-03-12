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
 * Abstract class for form submitters.
 *
 * @author  Aaron Wong
 * @version 1.0
 */
public inherited sharing abstract class PORTAL_FormSubmitter {
    /**
     * Default constructor for the object
     *
     * @author  Aaron Wong
     * @since   1.0
     */
    public PORTAL_FormSubmitter(){}

    /**
     * Abstract function for submitting information.
     *
     * @author Aaron Wong
     *
     * @param formDataMap       Map of form Id to list of PORTAL_FormRecordWrappers.
     * @return                  True if submitted successfully, false otherwise.
     * @since                   1.0
     */
    public abstract Boolean submit(Map<String, List<PORTAL_FormRecordWrapper>> formDataMap);

    // Factory Method
    public virtual PORTAL_FormRecordWrapper getFormRecordWrapper(Object objectRecord) {
        // objectRecord = Map<String(formId), List<PORTAL_FormRecordWrapper>>
        return new PORTAL_FormRecordWrapper(objectRecord);
    }

    /* OBJECT CONVERSION LOGIC */

    public Map<String, List<PORTAL_FormRecordWrapper>> convertObjectToFormDataMap(Object formObject) {
        Map<String, List<PORTAL_FormRecordWrapper>> resultMap = new Map<String, List<PORTAL_FormRecordWrapper>>();

        if (formObject == null) {
            return resultMap;
        }

        //Map<String, List<PORTAL_FormRecordWrapper>>
        Map<Object, Object> formMap = (Map<Object, Object>)formObject;

        for (Object eachKey : formMap.keySet()) {
            //List<PORTAL_FormRecordWrapper>
            List<Object> recordObjectList = (List<Object>)formMap.get(eachKey);

            resultMap.put(String.valueOf(eachKey), convertObjectListToWrapperList(recordObjectList));
        }

        return resultMap;
    }

    private List<PORTAL_FormRecordWrapper> convertObjectListToWrapperList(List<Object> objectList) {
        List<PORTAL_FormRecordWrapper> resultList = new List<PORTAL_FormRecordWrapper>();

        for (Object eachObject : objectList) {
            resultList.add(this.getFormRecordWrapper(eachObject));
        }

        return resultList;
    }

}