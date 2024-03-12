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
 * Handles trigger logic for the Volunteer object.
 *
 * @author      Aaron Wong
 * @version     1.0
 * @since       1.0
 */

global virtual inherited sharing class PORTAL_TRIG_VolunteerJobHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    public static final Map<String, String> STRING_DATE_TO_DATE_TIME_FIELD_MAP = new Map<String, String> {'Actual_Start_Date_Time__c' => 'Start_Date_Time__c', 'Actual_End_Date_Time__c' => 'End_Date_Time__c'};
    public static final String TIME_ZONE_API_NAME = 'Time_Zone__c';

    public static final Map<String, String> VOLUNTEER_JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP = new Map<String, String>{
        'Street__c' => PORTAL_AddressWrapper.STREET_LINE_1,
        'City__c' => PORTAL_AddressWrapper.CITY_CONST,
        'State__c' => PORTAL_AddressWrapper.STATE_CONST, 
        'Country__c' => PORTAL_AddressWrapper.COUNTRY_CONST,
        'Postal_Code__c' => PORTAL_AddressWrapper.POSTAL_CODE
    };

    public static final String VOLUNTEER_JOB_API_NAME = 'ucinn_portal_Volunteer_Job__c';

    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        if (System.isFuture() == false) {
            handleGeolocationUpdate(newList, oldList, triggerAction);
        }
        setDateTimeFields(newList, oldList, triggerAction);
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

    private static void handleGeolocationUpdate(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        List<SObject> volunteerJobListToUpdate = new List<SObject>();

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            volunteerJobListToUpdate = newList;
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterUpdate) {
            Map<String, SObject> oldMap = new Map<String, SObject>();

            for (SObject eachOldRecord : oldList) {
                oldMap.put(eachOldRecord.Id, eachOldRecord);
            }

            for (SObject eachNewRecord : newList) {
                SObject eachOldRecord  = oldMap.get(eachNewRecord.Id);

                for (String eachFieldApiName : VOLUNTEER_JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()) {
                    System.debug(eachNewRecord.get(eachFieldApiName));
                    System.debug(eachOldRecord.get(eachFieldApiName));
                    if ((String)eachNewRecord.get(eachFieldApiName) != (String)eachOldRecord.get(eachFieldApiName)) {
                        volunteerJobListToUpdate.add(eachNewRecord);
                        break;
                    }
                }
            }
        }

        if (volunteerJobListToUpdate == null || volunteerJobListToUpdate.isEmpty()) {
            return;
        }

        System.debug(volunteerJobListToUpdate);

        for (SObject eachVolunteerJob : volunteerJobListToUpdate) {
            updateVolunteerGeolocation(eachVolunteerJob.Id);
        }
    }

    @future (callout=true)
    public static void updateVolunteerGeolocation(String jobId){
        String queryString = ' SELECT id, ' + String.join(new List<String>(VOLUNTEER_JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()), ', ') + ' FROM ucinn_portal_Volunteer_Job__c WHERE id = \'' + jobId + '\'';

        List<ucinn_portal_Volunteer_Job__c> volunteerJobList = Database.query(queryString);

        if (volunteerJobList == null || volunteerJobList.isEmpty()) {
            return;
        }

        ucinn_portal_Volunteer_Job__c jobRecord = volunteerJobList.get(0);

        PORTAL_AddressWrapper address = getAddressWrapper(jobRecord);
        Double latitude = address.getLatitude();
        Double longitude = address.getLongitude();

        if (latitude != null && longitude != null) { 
            jobRecord.put('Geolocation__Latitude__s', latitude);
            jobRecord.put('Geolocation__Longitude__s', longitude);

            ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(VOLUNTEER_JOB_API_NAME, false);
            update jobRecord;
            ucinn_ascendv2.ascend_UTIL_TDTMTrigger.toggleTDTMTrigger(VOLUNTEER_JOB_API_NAME, true);
        }
    }

    /**
     * Use Volunteer Job address fields to create an Address Wrapper 
     * 
     * @since 1.0
     * 
     * @param jobRecord         ucinn_portal_Volunteer_Job__c: Any volunteer job object with street, city, state, country, and/or postal code fields
     * 
     * @return PORTAL_AddressWrapper representing the volunteer job address
     */
    private static PORTAL_AddressWrapper getAddressWrapper(ucinn_portal_Volunteer_Job__c jobRecord) {
        Map<Object, Object> paramMap = new Map<Object, Object>();
        for (String eachVolunteerJobField : VOLUNTEER_JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.keySet()) {
            String fieldValue = (String) jobRecord.get(eachVolunteerJobField);
            if (String.isNotBlank(fieldValue)) {
                paramMap.put(VOLUNTEER_JOB_FIELD_TO_ADDRESS_WRAPPER_FIELD_MAP.get(eachVolunteerJobField), fieldValue);
            }
        }

        return paramMap.isEmpty() ? null : new PORTAL_AddressWrapper(paramMap);   
    }

    /**
     * Syncs text and DateTime typed text fields for Volunteer Jobs.
     * 
     * @author Aaron Wong
     * 
     * @param newList           Trigger new list
     * @param oldList           Trigger old list
     * @param triggerAction     Trigger Action being taken.
     * 
     * @since           1.0
     */
    private static void setDateTimeFields(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction) {
        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeInsert) {
            for (SObject newRecord : newList) {
                validateAndUpdateDateTimeFields(newRecord, null);
            }
        } else if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.BeforeUpdate) {
            Map<String, SObject> oldMap = new Map<String, SObject>();

            for (SObject eachOldRecord : oldList) {
                oldMap.put(eachOldRecord.Id, eachOldRecord);
            }

            for (SObject eachNewRecord : newList) {
                validateAndUpdateDateTimeFields(eachNewRecord, oldMap.get(eachNewRecord.Id));
            }
        }
    }

    /**
     * Syncs text and DateTime typed text fields for a Volunteer Job.
     * 
     * @author Aaron Wong
     * 
     * @param newList           Trigger new list
     * @param oldList           Trigger old list
     * 
     * @since           1.0
     */
    private static void validateAndUpdateDateTimeFields(sObject newRecord, sObject oldRecord) {
        for (String eachStringField : STRING_DATE_TO_DATE_TIME_FIELD_MAP.keySet()) {
            try {
                PORTAL_CommunityUtils.validateAndUpdateDateTimeFields(new Map<String, Object>{PORTAL_CommunityUtils.PARAM_NEW_RECORD => newRecord,
                                                                                              PORTAL_CommunityUtils.PARAM_OLD_RECORD => oldRecord,
                                                                                              PORTAL_CommunityUtils.PARAM_DATE_TIME_FIELD_API_NAME => STRING_DATE_TO_DATE_TIME_FIELD_MAP.get(eachStringField),
                                                                                              PORTAL_CommunityUtils.PARAM_STRING_FIELD_API_NAME => eachStringField,
                                                                                              PORTAL_CommunityUtils.PARAM_NEW_TIME_ZONE => newRecord.get(TIME_ZONE_API_NAME),
                                                                                              PORTAL_CommunityUtils.PARAM_OLD_TIME_ZONE => newRecord.get(TIME_ZONE_API_NAME)});
            } catch (System.TypeException e) {// invalid format for datetimte
                System.debug(e);
            }
        }
    }

}