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
 * Apple Pay VF Page controller
 * 
 * @author Aaron Wong
 * @version 1.0
 */
public virtual without sharing class PORTAL_ApplePayController {
    public static final String BASE_URL = 'callout:Apple_Pay';
    public static final String PAYMENT_SESSION_ENDPOINT = BASE_URL + '/paymentservices/paymentSession';

    public static final String APPLE_PAY_MERCHANT_ID = 'Apple_Pay_Merchant_Id';
    public static final String MERCHANT_NAME = 'Merchant_Name';

    public String lexOrigin {
        get {
            return PORTAL_CommunityUtils.constructOrigin();
        }
        set;
    }

    public String merchantName {
        get {
            return PORTAL_Utils.getOrganizationSettingMetadata(new Map<String, Object>{PORTAL_Utils.DEVELOPER_NAME => MERCHANT_NAME});
        }
        set;
    }

    public String merchantSession {
        get {
            return getMerchantSession();
        }
        set;
    }

    public Boolean isApplePayConfigured {
        get {
            return String.isNotBlank(PORTAL_Utils.getSecureMetadata(APPLE_PAY_MERCHANT_ID));
        }
        set;
    }

    /**
     * Gets the merchant session used to validate Apple Pay.
     * 
     * @author Aaron Wong
     * 
     * @return  Stringified merchant session.
     * @since   1.0
     */
    public virtual String getMerchantSession() {
        if (isApplePayConfigured != true && !Test.isRunningTest()) {
            return '';
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(PAYMENT_SESSION_ENDPOINT);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        String body = getPaymentSessionRequestBody();
        request.setBody(body);

        HttpResponse response = http.send(request);

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            throw new AuraHandledException('There was an issue creating a merchant session.');
        }

        return response.getBody();
    }

    /**
     * Creates the payment session request body.
     * 
     * @author Aaron Wong
     * 
     * @return  Body for a payment session API request.
     * @since   1.0
     */
    protected virtual String getPaymentSessionRequestBody() {
        String merchantIdentifier = PORTAL_Utils.getSecureMetadata(APPLE_PAY_MERCHANT_ID);
        String thisMerchantName = this.merchantName;
        URL request = URL.getCurrentRequestUrl();
        String urlString = request.toExternalForm();
        String host = request.getHost();
        String baseUrl = urlString.substringBefore(host) + host;

        baseUrl = baseUrl.substring(baseUrl.indexOf('//') + 2);

        if (String.isBlank(merchantIdentifier) || String.isBlank(thisMerchantName)) {
            return '';
        }

        return '{"merchantIdentifier": "' + merchantIdentifier + '", "displayName": "' + thisMerchantName + '", "initiative": "web", "initiativeContext": "' + baseUrl + '"}';
    }
}