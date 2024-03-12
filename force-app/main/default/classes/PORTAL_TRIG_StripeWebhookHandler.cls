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
 * Trigger handler for Stripe Webhook
 * @author  Phillip Nguyen
 * @since   1.0
 */
global without sharing class PORTAL_TRIG_StripeWebhookHandler extends ucinn_ascendv2.ascend_TDTM_Runnable{

    /**
     *  Contains code to fire after Portal Stripe Webhook platform event insertion
     *
     * @author                                  Phillip Nguyen
     * @since                                   1.0
     *
     * @param   newList                         List of the new up to date version of the Society Membership records from the triggers
     * @param   oldList                         List of the old version of the Society Membership records from the trigger
     * @param   triggerAction                   Contains information about the trigger
     * @param   objResult                       Information about the object in the trigger
     *
     * @return                                  a new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper
     */
    global override ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper run(List<SObject> newList, List<SObject> oldList, ucinn_ascendv2.ascend_TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
        List<Portal_Stripe_Webhook__e> newStripeWebhookEvents = (List<Portal_Stripe_Webhook__e>) newList;

        if (triggerAction == ucinn_ascendv2.ascend_TDTM_Runnable.Action.AfterInsert) {
            for (Portal_Stripe_Webhook__e eachStripeEvent : newStripeWebhookEvents) {
                    PORTAL_StripeWebhook.finishReceivingPost(eachStripeEvent.Stripe_Event_Body__c);
            }
        }

        return new ucinn_ascendv2.ascend_TDTM_Runnable.DmlWrapper();
    }
}