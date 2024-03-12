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
 * Override giving summary batch base class to without sharing so 
 * when a portal user makes gifts/pledges through the portal,
 * the giving summary tab updates correctly.
 *
 * @author  Phillip Nguyen
 * @version 1.0
 * @since   1.0
 */
global without sharing class PORTAL_UpdateGivingSummaryBatchOverride extends ucinn_ascendv2.ascend_GIFT_UpdateGivingSummaryBatchBase {

    /**
     * Override batchStart so it runs without sharing. Makes sure all the constituents' HSCs and Opps are getting queried
     * 
     * @author Phillip Nguyen
     * @since 1.0
     * 
     */
    global override Database.Querylocator batchStart(Database.BatchableContext bc) {
        return super.batchStart(bc);
    }

    /**
     * Override batchExecute to run without sharing. Makes sure the sObjects are updated so giving summary tab information is correct.
     * 
     * @author Phillip Nguyen
     * @since 1.0
     * 
     */
    global override void batchExecute(Database.BatchableContext bc, List<sObject> hardAndSoftCreditList) {
        super.batchExecute(bc, hardAndSoftCreditList);
    }
}