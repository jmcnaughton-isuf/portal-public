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
 * DML Command Event Base
 * Used for RTv2 in payment hub controller base by moving the dml call to be ran as an Automated Process User.
 * Is not restricted just for RTv2
 * 
 * @author  Phillip Nguyen
 * @since   1.0
 */
global without sharing virtual class PORTAL_DMLCommandEventBase {
    public static final String INSERT_CONST = 'insert';
    public static final String DELETE_CONST = 'delete';
    public static final String UPSERT_CONST = 'upsert';
    public static final String UPDATE_CONST = 'update';

    public static final String EXTERNAL_SYSTEM_ID_FIELD_API_NAME = 'ucinn_ascendv2__External_System_Id__c';

    /**
     * Finish processing object from DML Command Event Trigger
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     * 
     * @param   dmlCommandEvent     Platform event that contains a serialized list of record(s) to be processed, the api name of the record(s), and the dml action to perform   
     */
    public virtual void handleDMLCommandEvent(Portal_DML_Command_Event__e dmlCommandEvent) {
        if (dmlCommandEvent == null || String.isBlank(dmlCommandEvent.Object_Data__c) || String.isBlank(dmlCommandEvent.DML_Action__c) || String.isBlank(dmlCommandEvent.Object_Api_Name__c)) {
            return;
        }

        List<SObject> convertedObjectList = (List<SObject>)System.JSON.deserialize(dmlCommandEvent.Object_Data__c, Type.forName('List<' + dmlCommandEvent.Object_Api_Name__c + '>'));

        try {
            switch on (dmlCommandEvent.DML_Action__c) {
                when 'insert' {
                    insert convertedObjectList;
                }
                when 'delete' {
                    delete convertedObjectList;
                }
                when 'upsert' {
                    upsert convertedObjectList;
                }
                when 'update' {
                    update convertedObjectList;
                }
                when else {
                    return;
                }
            }
        } catch (Exception e) {
            if (dmlCommandEvent.DML_Action__c == INSERT_CONST && dmlCommandEvent.Object_Api_Name__c == PORTAL_PaymentHubControllerBase.REVIEW_TRANSACTION_OBJECT_API_NAME) {
                handleRTv2Error(convertedObjectList, e);
            } else {
                System.debug('Failed to perform DML Command on Record');
            }
        }
    }

    /**
     * Handles case where rtv2 insertion fails during platform event handling.
     * 
     * @author  Phillip Nguyen
     * @since   1.0
     */
    private void handleRTv2Error(List<SObject> rtv2ObjectList, Exception errorException) {
        if (rtv2ObjectList == null || rtv2ObjectList.isEmpty() || errorException == null) {
            return;
        }

        List<ucinn_ascendv2__Review_Transaction_v2__c> errorReviewTransactionList = new List<ucinn_ascendv2__Review_Transaction_v2__c>();

        for (SObject eachRTv2Object : rtv2ObjectList) {
            ucinn_ascendv2__Review_Transaction_v2__c errorReviewTransaction = new ucinn_ascendv2__Review_Transaction_v2__c();
            errorReviewTransaction.ucinn_ascendv2__External_System_Id__c = (String)eachRTv2Object?.get(EXTERNAL_SYSTEM_ID_FIELD_API_NAME);
            errorReviewTransaction.ucinn_ascendv2__Manual_Review_Reason__c = 'Failed to create review transaction for a payment (' + errorException.getMessage() + ')';

            errorReviewTransactionList.add(errorReviewTransaction);
        }

        insert errorReviewTransactionList;
    }
}