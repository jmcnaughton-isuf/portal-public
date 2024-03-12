/*
 * Copyright (c) 2022, UC Innovation, Inc.  All Rights Reserved.
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
 * Override update household giving batch base class to without sharing so 
 * when a portal user makes gifts/pledges through the portal,
 * the update household giving batch does not fail.
 *
 * @author  Phillip Nguyen
 * @version 1.0
 * @since   1.0
 */
global without sharing class PORTAL_UpdateHouseholdGivingOverride extends ucinn_ascendv2.ascend_GIFT_UpdateHouseholdGivingBase {
 
    /**
     * Override batchStart so it runs without sharing. Makes sure all the constituents' HSCs are getting queried
     * 
     * @author Phillip Nguyen
     * @since 1.0
     * 
     */
    global override Database.Querylocator batchStart(Database.BatchableContext bc) {
        return super.batchStart(bc);
    }

    /**
     * Override batchExecute to run without sharing. 
     * Makes sure the user has permissions to the sObjects that are updated so batch does not fail when portal user makes a gift.
     * 
     * @author Phillip Nguyen
     * @since 1.0
     * 
     */
    global override void batchExecute(Database.BatchableContext bc, List<ucinn_ascendv2__Hard_and_Soft_Credit__c> hardAndSoftCreditList) {
        super.batchExecute(bc, hardAndSoftCreditList);
    }

    /**
     * Override batchFinish to run without sharing. 
     * Makes sure the user has permissions to the sObjects that are updated so batch does not fail when portal user makes a gift.
     * Need to override this as well so the test appeal campaign does not fail on DML statement.
     * 
     * @author Phillip Nguyen
     * @since 1.0
     * 
     */
    global override void batchFinish(Database.BatchableContext bc) {
        super.batchFinish(bc);
    }
}