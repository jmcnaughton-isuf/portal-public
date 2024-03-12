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
 * Base controller that contains functions for different payment methods
 *
 * @author          Phillip Nguyen
 * @version         1.14
 * @since           1.14
 */
public without sharing virtual class PORTAL_PaymentHubV2ControllerBase extends PORTAL_PaymentHubControllerBase {

    /**
     * method that populates the billing information for the review transaction
     *
     *
     * @author: Phillip Nguyen
     * @since: 1.14
     *
     *
     * @param billingInformation:           Map of data that contains the billing information
     * @param reviewTransaction:            The review transaction record we are populating
     * @param pageName                      Section Setting Page Name
     *
     */
    protected virtual override void populateBillingInformation(ucinn_ascendv2__Review_Transaction_v2__c reviewTransaction, Map<String, Object> billingInformation, String pageName) {
        if (reviewTransaction == null || billingInformation == null || billingInformation.isEmpty() || String.isBlank(pageName)) {
            return;
        }

        List<Portal_Page_Section_Setting__mdt> sectionSettingList = PORTAL_UTIL_PageSectionSetting.getPageSectionSettingRecords(pageName, '', '');

        for (Portal_Page_Section_Setting__mdt eachSection : sectionSettingList) {
            if (eachSection.Portal_Section_Field_Settings__r == null) {
                continue;
            }

            for (Portal_Section_Field_Setting__mdt eachField : eachSection.Portal_Section_Field_Settings__r) {
                if (String.isBlank(eachField.Staging_Record_Field_API_Name__c) || String.isBlank(eachField.Front_End_Field_Id__c) || String.isBlank((String)billingInformation.get(eachField.Front_End_Field_Id__c))) {
                    continue;
                }

                reviewTransaction.put(eachField.Staging_Record_Field_API_Name__c, billingInformation.get(eachField.Front_End_Field_Id__c));
            }
        }
    }

}