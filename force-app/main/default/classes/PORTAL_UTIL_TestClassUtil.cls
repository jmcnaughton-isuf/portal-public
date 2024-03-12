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
 * Utility class containing logic for PORTAL Test classes
 *
 * @author      Phillip Nguyen
 * @version     1.0
 * @since       1.0
 */
public inherited sharing virtual class PORTAL_UTIL_TestClassUtil {
    public static final String S_OBJECT_TO_POPULATE_KEY = 'sObjectToPopulate';
    public static final String EMAIL_DEFAULT = 'testclassemail12345@test.com';
    public static final String URL_DEFAULT = 'testClassDefault102942.com';
    public static final String TEXT_DEFAULT = 'testtextdefault';
    public static final String PHONE_DEFAULT = '111-111-111';

    private static Integer uniqueNumber = 1;

    /**
     * Populates required field on object
     * Call this function before master-detail
     *
     * @author                        Phillip Nguyen
     * @since                         1.0
     *
     * @param sObjectToPopulate       Object to populate required fields
     *
     * @return                        Object with required fields populated
     */
    public virtual SObject populateRequiredFieldsOnObject(Map<String, Object> params) {
        SObject sObjectToPopulate = (SObject)params?.get(S_OBJECT_TO_POPULATE_KEY);

        if (sObjectToPopulate == null) {
            return null;
        }

        Schema.SObjectType sObjectType = sObjectToPopulate.getSObjectType();

        // iterate over all fields of the object
        for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
            if (sObjectToPopulate.get(field) != null) {
                continue;
            }

            Schema.DescribeFieldResult eachDescribeFieldResult = field.getDescribe();
            // checks if field is required and needs a value
            if (eachDescribeFieldResult.isCreateable() && !eachDescribeFieldResult.isDefaultedOnCreate() && !eachDescribeFieldResult.isNillable()) {

                Schema.DisplayType fieldType = eachDescribeFieldResult.getType();

                if (fieldType == Schema.DisplayType.STRING || fieldType == Schema.DisplayType.TEXTAREA) {
                    if (eachDescribeFieldResult.isUnique()) {
                        sObjectToPopulate.put(field, TEXT_DEFAULT + String.valueOf(uniqueNumber++));
                    } else {
                        sObjectToPopulate.put(field, TEXT_DEFAULT);
                    }
                } else if (fieldType == Schema.DisplayType.DATETIME) {
                    sObjectToPopulate.put(field, System.now());
                } else if (fieldType == Schema.DisplayType.DATE) {
                    sObjectToPopulate.put(field, System.today());
                } else if (fieldType == Schema.DisplayType.TIME) {
                    sObjectToPopulate.put(field, Time.newInstance(1, 1, 0, 0));
                } else if (fieldType == Schema.DisplayType.EMAIL) {
                    if (eachDescribeFieldResult.isUnique()) {
                        sObjectToPopulate.put(field, EMAIL_DEFAULT + String.valueOf(uniqueNumber++));
                    } else {
                        sObjectToPopulate.put(field, EMAIL_DEFAULT);
                    }
                } else if (fieldType == Schema.DisplayType.CURRENCY
                        || fieldType == Schema.DisplayType.INTEGER
                        || fieldType == Schema.DisplayType.PERCENT) {
                    if (eachDescribeFieldResult.isUnique()) {
                        sObjectToPopulate.put(field, 1 + (uniqueNumber++));
                    } else {
                        sObjectToPopulate.put(field, 1);
                    }
                } else if (fieldType == Schema.DisplayType.PHONE) {
                    sObjectToPopulate.put(field, PHONE_DEFAULT);
                } else if (fieldType == Schema.DisplayType.URL) {
                    sObjectToPopulate.put(field, URL_DEFAULT);
                } else if (fieldType == Schema.DisplayType.DOUBLE) {
                    if (eachDescribeFieldResult.isUnique()) {
                        sObjectToPopulate.put(field, 0.0 + Double.valueOf(uniqueNumber++));
                    } else {
                        sObjectToPopulate.put(field, 0.0);
                    }
                } else if (fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST) {
                    List<Schema.PicklistEntry> picklistValueList = eachDescribeFieldResult.getPicklistValues();

                    for (Schema.PicklistEntry eachPicklistEntry : picklistValueList) {
                        if (!eachPicklistEntry.isActive()) {
                            continue;
                        }

                        sObjectToPopulate.put(field, eachPicklistEntry.getValue());
                        break;
                    }
                }
            }
        }

        return sObjectToPopulate;
    }
}