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

@RestResource(urlMapping='/portal/webhook/touchnet/*')

/**
 * Webhook class for TouchNet
 */
global without sharing class PORTAL_TouchNetWebhook {
    public final static String TOUCHNET_PAGE_CLOSE_DEVELOPER_NAME = 'TouchNet_Page_Close';
    public final static String CANCEL_CONST = 'cancel';

    /**
     * Receiving Post after user fills out uPay TouchNet Payment form
     * Filling out the form does not actually make a payment so we still have to make a payment
     * We send platform event so front end can show confirmation and follow the rest of the front end logic like other payment processors
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     */
    @HttpPost
    global static void receivePost() {
        RestRequest request = RestContext.request;
        handleWebhook(JSON.serialize(request.params), false);
    }

    /**
     * Receiving webhook after user cancels the uPay TouchNet Payment form
     * TouchNet sends HttpGet when the user cancels on the uPay page
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     */
    @HttpGet
    global static void receiveCancellation() {
        RestRequest request = RestContext.request;
        handleWebhook(JSON.serialize(request.params), true);
    }

    /**
     * Handles webhook from TouchNet, which sends platform event and closes page
     * 
     * @author  Phillip Nguyen
     * @since   1.5
     * 
     * @param   touchNetPageResponse    Response from touchnet
     * @param   isCancelPayment         This value is if the user cancelled their touchnet payment
     */
    private static void handleWebhook(String touchNetPageResponse, Boolean isCancelPayment) {
        ucinn_portal_TouchNet_Webhook__e touchNetEvent = new ucinn_portal_TouchNet_Webhook__e(TouchNet_Page_Response__c = touchNetPageResponse, Is_Cancel_Payment__c = isCancelPayment);
        Database.SaveResult results = Eventbus.publish(touchNetEvent);

        if (results.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : results.getErrors()) {
                System.debug('Error returned: ' +
                            err.getStatusCode() +
                            ' - ' +
                            err.getMessage());
            }
        }

        //Close page
        String location = PORTAL_Utils.getSecureMetadata(TOUCHNET_PAGE_CLOSE_DEVELOPER_NAME);
        RestContext.response.statusCode = 301;
        RestContext.response.addHeader('Location',location);
        RestContext.response.addHeader('http-equiv','refresh');
    }

}