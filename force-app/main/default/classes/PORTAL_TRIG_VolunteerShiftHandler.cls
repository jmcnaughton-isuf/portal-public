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

global virtual inherited sharing class PORTAL_TRIG_VolunteerShiftHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{
    public static final Map<String, String> STRING_DATE_TO_DATE_TIME_FIELD_MAP = new Map<String, String> {'Actual_Start_Date_Time__c' => 'Start_Date_Time__c', 'Actual_End_Date_Time__c' => 'End_Date_Time__c'};
    public static final String TIME_ZONE_API_NAME = 'Time_Zone__c';

    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        setDateTimeFields(newList, oldList, triggerAction);
        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }

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