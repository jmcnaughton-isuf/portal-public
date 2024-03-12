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
* trigger for the job object
*
* @author:  Ashley Tran
* @version: 1.0
* @since:   1.0
*/


global without sharing class PORTAL_TRIG_JobHandler extends ucinn_ascendv2.ascend_TDTM_Runnable {

    public static final String JOB_API_NAME = 'ucinn_portal_Job__c';
    
    public static final Map<String, String> JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP = new Map<String, String>{
        'Address_Line_1__c' => PORTAL_AddressWrapper.STREET_LINE_1,
        'Address_Line_2__c' => PORTAL_AddressWrapper.STREET_LINE_2,
        'Address_Line_3__c' => PORTAL_AddressWrapper.STREET_LINE_3,
        'City__c' => PORTAL_AddressWrapper.CITY_CONST,
        'State__c' => PORTAL_AddressWrapper.STATE_CONST, 
        'Country__c' => PORTAL_AddressWrapper.COUNTRY_CONST,
        'Postal_Code__c' => PORTAL_AddressWrapper.POSTAL_CODE
    };

    /**
     *  Method occurs on every trigger run.
     *
     * @param   newList                         List of the new up to date version of the records from the triggers
     * @param   oldList                         List of the old version of the records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the obect in the trigger
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     * @since                                   1.0
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        if (System.isBatch() == true || System.isFuture() == true) {
            return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
        }

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            geolocateJobs((List<ucinn_portal_Job__c>) newList);
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            geolocateJobs((List<ucinn_portal_Job__c>) oldList, (List<ucinn_portal_Job__c>) newList);
        }
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

     /**
     * method that checks to see if the newly inserted jobs need to be
     * geolocated
     *
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param jobList               the newly inserted jobs
     *
     *
     */

    public static void geolocateJobs(List<ucinn_portal_Job__c> jobList) {

        Map<String, String> jobIdToAddressWrapperMap = new Map<String, String>();

        for (ucinn_portal_Job__c eachNewJob : jobList) {
            PORTAL_AddressWrapper addressWrapper = getAddressWrapper(eachNewJob);
            if (addressWrapper != null) {
                jobIdToAddressWrapperMap.put(eachNewJob.Id, JSON.serialize(addressWrapper, true));
            }
        }

        if (!jobIdToAddressWrapperMap.isEmpty()) {
            geolocateAddresses(jobIdToAddressWrapperMap);
        }

    }

    /**
     * method that compares the address fields of the old job against the new
     * job in order to determine if the job needs to be geolocated
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param oldJobList            the old values for the jobs
     * @param jobList               the newly updated jobs
     *
     *
     */

    public static void geolocateJobs(List<ucinn_portal_Job__c> oldJobList, List<ucinn_portal_Job__c> jobList) {
        Map<String, String> jobIdToAddressWrapperMap = new Map<String, String>();

        for (Integer index = 0; index < jobList.size(); index++) {
            ucinn_portal_Job__c oldJob = oldJobList.get(index);
            ucinn_portal_Job__c newJob = jobList.get(index);

            PORTAL_AddressWrapper addressWrapper = getUpdatedJobAddressWrapper(oldJob, newJob);
            if (addressWrapper != null) {
                jobIdToAddressWrapperMap.put(newJob.Id, JSON.serialize(addressWrapper, true));
            }
        }

        if (!jobIdToAddressWrapperMap.isEmpty()) {
            geolocateAddresses(jobIdToAddressWrapperMap);
        }
    }

    /**
     * Compare two jobs and see if their address fields are different
     * 
     * @author Jacob Huang
     * @since 1.0
     * 
     * @param oldJob        ucinn_portal_Job__c: original/old job
     * @param newJob        ucinn_portal_Job__c: updated/new job 
     * 
     * @return PORTAL_AddressWrapper of the newJob only if the new job has different address fields than old job 
     */
    private static PORTAL_AddressWrapper getUpdatedJobAddressWrapper(ucinn_portal_Job__c oldJob, ucinn_portal_Job__c newJob) {
        for (String eachCurrentField : JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()) {
            if (oldJob?.get(eachCurrentField) != newJob?.get(eachCurrentField)) {
                return getAddressWrapper(newJob); 
            }
        }

        return null;
    }

    /**
     * Use Job address fields to create an Address Wrapper 
     * 
     * @since 1.0
     * 
     * @param jobRecord         ucinn_portal_Job__c: Any job object with street, city, state, country, and/or postal code fields
     * 
     * @return PORTAL_AddressWrapper representing the job address
     */
    private static PORTAL_AddressWrapper getAddressWrapper(ucinn_portal_Job__c jobRecord) {
        Map<Object, Object> paramMap = new Map<Object, Object>();
        for (String eachJobField : JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()) {
            String fieldValue = (String) jobRecord.get(eachJobField);
            if (String.isNotBlank(fieldValue)) {
                paramMap.put(JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.get(eachJobField), fieldValue);
            }
        }

        return paramMap.isEmpty() ? null : new PORTAL_AddressWrapper(paramMap);   
    }

    /**
     * method that takes a map of job id to addresses and makes the geolocation
     * calls to the api. once the geoloation is returned, it will update the job
     *
     * @author: Ashley Tran
     * @since: 1.0
     *
     *
     * @param jobIdToAddressWrapperMap              map of job id to deserialized address wrapper
     */

    @future(callout = true)
    private static void geolocateAddresses(Map<String, String> jobIdToAddressWrapperMap) {

        List<ucinn_portal_Job__c> jobsToUpdate = new List<ucinn_portal_Job__c>();

        for (String eachJobId : jobIdToAddressWrapperMap.keySet()) {
            PORTAL_AddressWrapper address = (PORTAL_AddressWrapper) JSON.deserialize(jobIdToAddressWrapperMap.get(eachJobId), PORTAL_AddressWrapper.class);
            Double latitude = address.getLatitude();
            Double longitude = address.getLongitude();
            if (latitude != null && longitude != null) {
                jobsToUpdate.add(new ucinn_portal_Job__c(Id = eachJobId, Geolocation__latitude__s = latitude, Geolocation__longitude__s = longitude));  
            }
        }

        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(JOB_API_NAME, false);
        update jobsToUpdate;
        ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(JOB_API_NAME, true);
    }
}