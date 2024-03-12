import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';

import getOrigin from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getOrigin";
import getApiKey from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getAPIKey";
import getCybersourceMerchantId from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getCybersourceMerchantId";
import getSpreedlyTransactionToken from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getSpreedlyTransactionToken";
import getRecaptchaOption from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getRecaptchaOption";
import verifyRecaptchaToken from "@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_verifyRecaptchaToken";
import createGooglePayPaymentMethod from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_createGooglePayPaymentMethod";
import createApplePayPaymentMethod from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_createApplePayPaymentMethod";
import getStripeClientSecret from '@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getStripeClientSecret';

// html
import cybersource from './portal_PaymentFormCybersource.html';
import cybersourceCompact from './portal_PaymentFormCybersourceCompact.html';
import cybersourceSelector from './portal_PaymentFormCybersourceSelector.html';
import cybersourceSelectorCompact from './portal_PaymentFormCybersourceSelectorCompact.html';
import spreedly from './portal_PaymentFormSpreedly.html';
import spreedlyCompact from './portal_PaymentFormSpreedlyCompact.html';
import spreedlySelector from './portal_PaymentFormSpreedlySelector.html';
import spreedlySelectorCompact from './portal_PaymentFormSpreedlySelectorCompact.html';
import stripe from './portal_PaymentFormStripe.html';
import stripeCompact from './portal_PaymentFormStripeCompact.html';
import stripePaymentElement from './portal_PaymentFormStripePaymentElement.html';
import stripePaymentElementCompact from './portal_PaymentFormStripePaymentElementCompact.html';
import touchNet from './portal_PaymentFormTouchNet.html';

import { submitForm } from 'c/portal_Recaptcha';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import recaptchaChannel from '@salesforce/messageChannel/recaptchaChannel__c';

// TouchNet Imports
import getTouchNetSettings from '@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getTouchNetSettings';
import generateSecureLinkTicket from '@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_generateSecureLinkTicket';

import { loadScript } from "lightning/platformResourceLoader";
import cometdlwc from "@salesforce/resourceUrl/Portal_CometD";
import getSessionId from '@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getCometDSessionId';

export default class Portal_PaymentForm extends LightningElement {
    @api isRecaptchaEnabled;
    @api paymentMethod = 'Stripe';
    @api paymentType = 'event';
    @api billingInformation = {};
    @api organizationBillingInformation = {};
    @api amount = 0;
    @api numberOfInstallments = undefined; 
    @api frequency = undefined;
    @api startDate = undefined; 
    @api endDate = undefined;
    @api externalGatewayName = '';
    @api isUpdate = false;
    @api isGivingAsOrg = false;
    @api isCompact = false;
    @api additionalMetadata;
    @api paymentOrigin;
    @wire(MessageContext) messageContext;
    _additionalMetadata;

    @api handlePaymentConfirmation = () => {};
    @api handlePreviousClick = () => {};

    // true by default for contextual giving form
    _isCreatePledgeSubscription = true;

    @api get isCreatePledgeSubscription() {
        return this._isCreatePledgeSubscription;
    }

    set isCreatePledgeSubscription(isCreatePledgeSubscription) {
        this._isCreatePledgeSubscription = isCreatePledgeSubscription;
    }

    @track _origin;
    
    @track _apiKey;
    @track _isShowSpinner = false;
    
    @track _isShowComponent = false;
    
    @track _recaptchaOption;
    @track _isVerifyingRecaptcha = false;

    _currentPaymentChoice = 'Credit';
    _messageListener;

    //touchnet
    @track _nameValuePairsList = [];
    @track _touchNetTicket = '';
    @track _touchNetSessionIdentifier = '';

    _isShowPreviousButton = false;
    _touchNetDisplayMessage = 'Please wait to be taken to the hosted checkout page.';

    // cometD
    _isCometdLibInitialized = false;
    @track cometDSessionId;
    @track cometDError;

    get isPayWithACH() {
        return this._currentPaymentChoice == 'ACH';
    } 

    get isPayWithCreditCard() {
        return this._currentPaymentChoice == 'Credit';
    }

    get hasSelectedChoice() {
        return this._currentPaymentChoice != '';
    }

    get isDisplayRecaptcha() {
        return this.isRecaptchaEnabled && this._recaptchaOption && this._recaptchaOption.toUpperCase() !== 'None'.toUpperCase();
    }

    get isRecaptchaV3() {
        return this._recaptchaOption?.toUpperCase() === 'reCAPTCHA V3'.toUpperCase();
    }

    get creditCardTitle() {
        return this.isUpdate ? 'Update Credit Card' : 'Pay With Credit Card';
    }

    get achTitle() {
        return this.isUpdate ? 'Update ACH' : 'Pay With ACH';
    }

    get achButtonClass() {
        return this._currentPaymentChoice === 'ACH' ? 'active' : '';
    }

    get ccButtonClass() {
        return this._currentPaymentChoice === 'Credit' ? 'active' : '';
    }

    get spreedlyBillingInformationMap() {
        if (this.isGivingAsOrg) {
            return {email:      this.organizationBillingInformation?.email,
                    address1:   this.organizationBillingInformation?.address?.line1,
                    address2:   this.organizationBillingInformation?.address?.line2,
                    city:       this.organizationBillingInformation?.address?.city,
                    state:      this.organizationBillingInformation?.address?.state, 
                    zip:        this.organizationBillingInformation?.address?.postal_code,
                    country:    this.organizationBillingInformation?.address?.country};
        } else {
            return {email:      this.billingInformation?.email,
                    address1:   this.billingInformation?.address?.line1,
                    address2:   this.billingInformation?.address?.line2,
                    city:       this.billingInformation?.address?.city,
                    state:      this.billingInformation?.address?.state, 
                    zip:        this.billingInformation?.address?.postal_code,
                    country:    this.billingInformation?.address?.country};
        }
    }

    get isSubscription() {
        return this.paymentType === 'recurring' || this.paymentType === 'subscription' || (this.paymentType === 'pledge' && this._isCreatePledgeSubscription);
    }

    get generateSecureLinkTicketParams() {
        let params = {ticketName: this.paymentOrigin, nameValuePairs: this._nameValuePairsList, paymentMethod: this.paymentMethod};
        return params;
    }

    get compactStyle() {
        // Stripe payment element has extra help text about automatic future charges
        if (this.isSubscription) {
            return "width: 100%; max-width: 332px; height: 540px; border-style: none;";
        }

        return "width: 100%; max-width: 332px; height: 560px; border-style: none;";
    }

    async connectedCallback() {
        //TODO: is it possible that this aysnc connected callback can result in the origin and window listeners to be created AFTER the iframe tells this its ready, causing the iframe to lock up without loading?
        this._isShowSpinner = true;

        if (this.paymentMethod === 'TouchNet') {
            this.initializeCometD();
            await this.initializeTouchNet();
            this._isShowSpinner = false;
        } else {
            try {
                const params = {'params':{}}
                this._origin = await getOrigin(params);
                const recaptchaParams = {'params':{'paymentMethod': this.paymentMethod}};
                this._recaptchaOption = await getRecaptchaOption(recaptchaParams);
            }
            catch(err) {
                console.error(err);
            }
            this._messageListener = this.handleWindowMessage.bind(this);
            window.addEventListener("message", this._messageListener);
            if (this.additionalMetadata) {
                let tempAdditionalMetadata = JSON.parse(JSON.stringify(this.additionalMetadata));
                // frontEndData and billingInformation must be deleted to stay within the Stripe metadata character limits
                if (tempAdditionalMetadata.params && tempAdditionalMetadata.params.billingInformation) {
                    if (tempAdditionalMetadata.params.billingInformation.frontEndData) {
                        delete tempAdditionalMetadata.params.billingInformation.frontEndData;
                    }

                    if (tempAdditionalMetadata.params.billingInformation.picklists) {
                        delete tempAdditionalMetadata.params.billingInformation.picklists;
                    }

                    if (tempAdditionalMetadata.params.billingInformation.records && tempAdditionalMetadata.params.billingInformation.records['Gift Type']) {
                        delete tempAdditionalMetadata.params.billingInformation.records['Gift Type'];
                    }
                }
                
                this._additionalMetadata = tempAdditionalMetadata;
            }
        }

        this._isShowComponent = true;
    }

    disconnectedCallback() {
        window.removeEventListener("message", this._messageListener);
        this._isShowComponent = false;
    }

    render() {
        if (this.paymentMethod === 'Stripe') {
            return this.isCompact ? stripeCompact : stripe;
        } else if (this.paymentMethod === 'Spreedly') {
            return this.isCompact ? spreedlyCompact : spreedly;
        }else if (this.paymentMethod === 'Spreedly w/ ACH') {
            return this.isCompact ? spreedlySelectorCompact : spreedlySelector;
        } else if (this.paymentMethod === 'Cybersource') {
            return this.isCompact ? cybersourceCompact : cybersource;
        } else if (this.paymentMethod === 'Cybersource w/ ACH') {
            return this.isCompact ? cybersourceSelectorCompact : cybersourceSelector;
        } else if (this.paymentMethod === 'Stripe Payment Element') {
            return this.isCompact ? stripePaymentElementCompact : stripePaymentElement;
        } else if (this.paymentMethod === 'TouchNet') {
            return touchNet;
        }

        return stripe;
    }

    sendIsUpdateMessage() {
        let paymentIframe = this.template.querySelector("iframe");
        if (paymentIframe) {
            const opts = {
                type: "isUpdate",
                value: this.isUpdate
            };

            paymentIframe.contentWindow.postMessage(JSON.stringify(opts), this._origin);
        }
    }

    handleWindowMessage(message) {
        // need to assume that iframe is ready before it can receive messages from this LWC
        if (message.origin === this._origin && message.data.type.includes('ready')) {
            this.sendIsUpdateMessage();
        }
        
        if (this.paymentMethod == 'Stripe') {
            this.handleStripePayment(message);
        } else if (this.paymentMethod == 'Spreedly' || this.paymentMethod == 'Spreedly w/ ACH') {
            this.handleSpreedlyMessages(message);
        } else if (this.paymentMethod == 'Cybersource' || this.paymentMethod === 'Cybersource w/ ACH') {
            this.handleCybersourcePayment(message);
        } else if (this.paymentMethod == 'Stripe Payment Element') {
            this.handleStripePaymentElement(message);
        }
    }

    handleStripePaymentElement(message) {
        if (message.origin === this._origin) {
            if (message.data.type === 'ready') {
                if (this._apiKey && this.additionalMetadata) {
                    this.initializeStripePaymentElementForm(this._apiKey);
                    this._isShowSpinner = false;
                } else {
                    const params = {'params':{'paymentMethod': 'Stripe Payment Element'}};
                    this._isShowSpinner = true;
                    getApiKey(params).then(apiKey => {
                        this.initializeStripePaymentElementForm(apiKey);
                    }).finally(() => {
                        this._isShowSpinner = false;
                    })
                }
            } else if (message.data.type === 'isApplePay') {
                const successMessage = {type: 'isEnableApplePay'};
                if (this.isRecaptchaV3) {
                    this.verifyStripePaymentElementRecaptcha(successMessage);
                    return;
                }

                this.template.querySelector('iframe')?.contentWindow.postMessage(JSON.stringify(successMessage), this._origin);
            } else if (message.data.type === 'isUserSubmission') {
                const successMessage = {type: 'isValidUserSubmission', isSubscription: this.isSubscription};
                if (message.data.isApplePay && this.isRecaptchaV3) {
                    this.template.querySelector('iframe')?.contentWindow.postMessage(JSON.stringify(successMessage), this._origin);
                    return;
                }

                this.verifyStripePaymentElementRecaptcha(successMessage);
            } else if (message.data.type === 'confirmed') {
                this.handlePaymentConfirmation();
            } else if (message.data.type === 'previous') {
                this.handlePreviousClick();
            } else if (message.data.type == 'error') {
                publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});
            }
        }
    }

    verifyStripePaymentElementRecaptcha(successMessage) {
        if (this._isVerifyingRecaptcha) {
            return;
        }

        this._isVerifyingRecaptcha = true;

        submitForm(this, (recaptchaToken, errorRecaptchaCallback) => {
            callApexFunction(this, verifyRecaptchaToken, {'recaptchaToken': recaptchaToken}, (result) => {
                this.template.querySelector('iframe')?.contentWindow.postMessage(JSON.stringify(successMessage), this._origin);
            }, (error) => {
                console.log(error);
                errorRecaptchaCallback();
            }).finally(() => {
                this._isVerifyingRecaptcha = false;
            });
        }, (error) => {
            this._isVerifyingRecaptcha = false;
            console.log(error);
        });
    }

    handleStripePayment(message) {
        if (message.origin === this._origin) {
            if (message.data.type === 'ready') {
                if (this._apiKey) {
                    this.initializeStripePaymentForm(this._apiKey);
                    this._isShowSpinner = false;
                } else {
                    const params = {'params':{'paymentMethod': 'Stripe'}};
                    this._isShowSpinner = true;
                    getApiKey(params).then(apiKey => {
                        this.initializeStripePaymentForm(apiKey);
                    }).finally(() => {
                        this._isShowSpinner = false;
                    })
                }
            } else if (message.data.type === 'confirmed') {
                submitForm(this, (recaptchaToken) => {
                    this.handlePaymentConfirmation({paymentId: message.data.paymentId, recaptchaToken: recaptchaToken});
                },(error) => {
                    this._isShowSpinner = false;
                    console.log(error);
                })
            } else if (message.data.type === 'previous') {
                this.handlePreviousClick();
            }
        }
    }

    handleSpreedlyMessages(message) {
        if (message && message.data) {
            switch (message.data.type) {
                case "ready": {
                    this._isShowSpinner = true;
                    if (this._apiKey) {
                        this.initializeSpreedlyCreditCardForm(this._apiKey);
                        this._isShowSpinner = false;
                        
                    } else {
                        const params = {'params':{'paymentMethod': 'Spreedly'}};
                        getApiKey(params).then(environmentKey => {
                            this.initializeSpreedlyCreditCardForm(environmentKey);
                            this._isShowSpinner = false;
                        });
                    }
                    break;
                    
                }
                case "readyACH": {
                    //ACH form doesn't need key on frontend so we can load quicker by just passing in details
                    const displayOptions = {
                        full_name: this.billingInformation['name']
                    }
        
                    const opts = {
                        type: "initialize",
                        displayOptions
                    };
                    if (this.template.querySelector("iframe")) {
                        this.template.querySelector("iframe").contentWindow.postMessage(JSON.stringify(opts), this._origin);
                    }
                    break;
                }
                case "payment_method": {
                    this._isShowSpinner = true;
                    this.handleSpreedlyPayment(message.data.token, message.data.additionalPaymentDataMap);
                    break;
                }

                case "googlePayComplete": {
                    this._isShowSpinner = true;
                    createGooglePayPaymentMethod({params: {token: message.data.token, paymentMethod: this.paymentMethod}}).then(paymentMethodId => {
                        this.handleSpreedlyPayment(paymentMethodId, {});
                    }).catch(e => {
                        this._isShowSpinner = false;
                        console.log(e);
                    })
                    break;
                }
                case "applePayComplete": {
                    this._isShowSpinner = true;
                    createApplePayPaymentMethod({params: {token: message.data.token, paymentMethod: this.paymentMethod}}).then(paymentMethodId => {
                        this.handleSpreedlyPayment(paymentMethodId, {});
                    }).catch(e => {
                        this._isShowSpinner = false;
                        console.log(e);
                    })
                    break;
                }
                case "form_errors": {
                    const messages = message.data.errors.map(err => err.message);

                    const toastEvent = new ShowToastEvent({
                        "title": "Error",
                        "message": messages.join("; "),
                        "variant": "error"
                    });

                    this.dispatchEvent(toastEvent);
                    break;
                }
                case "previous": {
                    this.handlePreviousClick();
                    break;
                }
            }
        }
    }

    handleCybersourcePayment(message) {
        if (message && message.data && message.origin == this._origin) {
            switch (message.data.type) {
                case "payment_method": {
                    submitForm(this, (recaptchaToken) => {
                        this.handlePaymentConfirmation({paymentId: message.data.token, additionalPaymentDataMap: message.data.additionalPaymentDataMap, recaptchaToken: recaptchaToken});
                    }, (error) => {
                        console.log(error);
                    })
                    
                    break;
                }
                case "ready": {
                    const params = {'params':{'paymentMethod': 'Cybersource'}};
                    getCybersourceMerchantId(params).then(merchantId => {
                        this.initializeCybersourceCreditCardForm(merchantId);
                    }).catch(e => {
                        console.log(e);
                    });
                    break;
                }
                case "readyACH": {
                    // Google pay / things that require merchantId are not present in the ACH form
                    this.initializeCybersourceCreditCardForm();
                    break;
                }
                case "googlePayComplete": {
                    this.handlePaymentConfirmation({paymentId: window.btoa(message.data.token), additionalPaymentDataMap: {walletType: 'googlePay'}});
                    break;
                }
                case "applePayComplete": {
                    this.handlePaymentConfirmation({paymentId: window.btoa(message.data.token), additionalPaymentDataMap: {walletType: 'applePay'}});
                    break;
                }
                case "previous": {
                    this.handlePreviousClick();
                    break;
                }
            }
        }
    }

    initializeCybersourceCreditCardForm = (merchantId) => {
        const displayOptions = {
            amount: this.amount,
            numberOfInstallments: this.numberOfInstallments, 
            frequency: this.frequency,
            startDate: this.startDate, 
            endDate: this.endDate,
            giftType: this.paymentType,
            isSubscription: this.isSubscription,
            full_name: this.billingInformation.name,
            email: this.billingInformation.email
        }

        const paymentMethodParams = {
            billingInformation:this.billingInformation
        }
        
        let googlePayOptions = {
            gateway: 'cybersource',
            gatewayMerchantId: merchantId
        }

        const opts = {
            type: "initialize",
            displayOptions,
            paymentMethodParams,
            googlePayOptions
        };

        if (this.template.querySelector("iframe")) {
            this.template.querySelector("iframe").contentWindow.postMessage(JSON.stringify(opts), this._origin);
        }
        this._isShowSpinner = false;
    }

    initializeSpreedlyCreditCardForm = (environmentKey) => {
        let displayOptions = {
            amount: this.amount,
            full_name: this.billingInformation['name'],
            email: this.billingInformation['email']
        }

        let paymentMethodParams = this.spreedlyBillingInformationMap;

        let googlePayOptions = {
            gateway: 'spreedly',
            gatewayMerchantId: environmentKey
        }

        let opts = {
            type: "initialize",
            environment_key: environmentKey,
            displayOptions,
            paymentMethodParams,
            googlePayOptions
        };

        if (this.template.querySelector("iframe")) {
            this.template.querySelector("iframe").contentWindow.postMessage(JSON.stringify(opts), this._origin);
        }
    }
    
    initializeStripePaymentElementForm = (apiKey) => {
        try {
            const params =  {'params':  {amount: this.amount,
                                         additionalMetadata: JSON.stringify({'paymentOrigin':this.paymentOrigin, ...this._additionalMetadata}),
                                         stripeBillingInformation: this.isGivingAsOrg ? this.organizationBillingInformation : this.billingInformation,
                                         isGivingAsOrg: this.isGivingAsOrg,
                                         isSubscription: this.isSubscription,
                                         paymentMethod: this.paymentMethod}
                            };
            getStripeClientSecret(params).then(clientSecret => {
                const opts = {
                    type: "initialize",
                    stripeKey: apiKey,
                    clientSecretKey: clientSecret,
                    isSubscription: this.isSubscription
                };
                if (this.template.querySelector("iframe")) {
                    this.template.querySelector("iframe").contentWindow.postMessage(JSON.stringify(opts), this._origin);
                }
            })
        } catch(e) {
            console.error(e);

            const toastEvent = new ShowToastEvent({
                "title": "Error",
                "message": "There was an error.",
                "variant": "error"
            });

            this.dispatchEvent(toastEvent);
        }
    }
    
    initializeStripePaymentForm = (apiKey) => {
        const opts = {
            type: "initialize",
            giftType: this.paymentType,
            stripeKey: apiKey,
            amount: this.amount
        };
        if (this.template.querySelector("iframe")) {
            this.template.querySelector("iframe").contentWindow.postMessage(JSON.stringify(opts), this._origin);
        }
    }

    initializeCometD() {
        callApexFunction(this, getSessionId, {paymentMethod: this.paymentMethod}, (result) => {
            if (result) {
                this.cometDSessionId = result;
                this.cometDError = undefined;
                loadScript(this, cometdlwc).then(() => {
                    this.handleCometDSubscription()
                });
            } else {
                console.log(error);
                this.cometDError = error;
                this.cometDSessionId = undefined;
            }
        }, (error) => {
            console.log(error)
        });
    }

    handleCometDSubscription() {
        if (this._isCometdLibInitialized) {
            return;
        }

        const cometDSubscribeCallback = (response) => {
            let touchNetResponse = JSON.parse(response?.data?.payload?.TouchNet_Page_Response__c);
            let isCancelTouchNetPayment = response?.data?.payload.Is_Cancel_Payment__c

            let isMatchingTouchNetSession = this._touchNetSessionIdentifier == touchNetResponse.EXT_TRANS_ID;
            if (isMatchingTouchNetSession && isCancelTouchNetPayment) {
                this._touchNetDisplayMessage = 'You have cancelled your payment on the hosted site.\nPlease click the button below to return to the billing information page.';
                this._isShowPreviousButton = true;
                return;
            } else if (isMatchingTouchNetSession && !isCancelTouchNetPayment) {
                this._touchNetDisplayMessage = 'Processing your payment.';
                this.handlePaymentConfirmation({paymentId: touchNetResponse.session_identifier, additionalPaymentDataMap: {paymentMethodType: touchNetResponse.pmt_method}});
            } 
        }

        this._isCometdLibInitialized = true;

        //initializing cometD object/class
        let cometdlib = new window.org.cometd.CometD();
        //Calling configure method of cometD class, to setup authentication which will be used in handshaking
        cometdlib.configure({
            url: window.location.protocol + '//' + window.location.hostname + '/cometd/58.0/',
            requestHeaders: { Authorization: 'OAuth ' + this.cometDSessionId},
            appendMessageTypeToURL : false,
            logLevel: 'debug'
        });

        cometdlib.websocketEnabled = false;

        cometdlib.handshake(function(status) {
            if (status.successful) {
                // Successfully connected to the server.
                // Now it is possible to subscribe or send messages
                cometdlib.subscribe('/event/ucinn_portal_TouchNet_Webhook__e', cometDSubscribeCallback);
            } else {
                /// Cannot handshake with the server, alert user.
                console.log('Error in handshaking: ' + JSON.stringify(status));
            }
        });
    }

    initializeTouchNet() {
        this._touchNetSessionIdentifier = (new Date().getMilliseconds()) + (Math.random()).toString(36).slice(2);  // copied this creation from ascend

        callApexFunction(this, getTouchNetSettings, {paymentMethod: this.paymentMethod}, (result) => {
            this._nameValuePairsList = this.generateNameValuePairs(result, this._touchNetSessionIdentifier);

            let touchNetUPaySite = result.touchNetUPaySite;
            let touchNetUPaySiteId = result.touchNetUPaySiteId;
            
            callApexFunction(this, generateSecureLinkTicket, this.generateSecureLinkTicketParams, (ticket) => {
                if (ticket) {
                    this._touchNetTicket = ticket;
                    this.sendToTouchNetForm(this._touchNetTicket, touchNetUPaySite, touchNetUPaySiteId)
                }
            }, (error) => {
                console.log(error)
            });
        }, (error) => {
            console.log(error)
        });
    }

    generateNameValuePairs(touchNetSettings, touchNetSessionIdentifier) {
        let restResourceSite = touchNetSettings.touchNetRestResourceSite;
        // default values needed
        let valuePairs = [{name: 'SUCCESS_LINK', value: restResourceSite}, {name: "CANCEL_LINK", value: restResourceSite}, {name: "ERROR_LINK", value: restResourceSite},
                          {name: "AMT", value: this.amount}, {name: "EXT_TRANS_ID", value: touchNetSessionIdentifier}];
                          
        // not gift's and memberships (copied from ascend)
        if (this.paymentType != 'outright' && this.paymentType != 'One-Time POS' && this.paymentType != 'gift' && this.paymentType != 'event' && !(this.paymentType === 'pledge' && !this.isCreatePledgeSubscription)) {
            valuePairs.push({name: "PARTNER_RECURRING_PMT", value: "True"});
            valuePairs.push({name: "RECURRING_USER_CAN_CHANGE", value: "True"});
            //Recurring gifts and pledges cannot use POS device
            valuePairs.push({name: "POS_TRANSACTION", value: "False"});
        }

        // billing information to send to upay site for prepopulation
        if (this.billingInformation || this.isGivingAsOrg) {
            valuePairs.push({name: "BILL_NAME", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.name || '') : (this.billingInformation.name || ''))});
            valuePairs.push({name: "BILL_EMAIL_ADDRESS", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.email || '') : (this.billingInformation.email || ''))});
            valuePairs.push({name: "BILL_STREET1", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.address?.line1 || '') : (this.billingInformation.address?.line1 || ''))});
            valuePairs.push({name: "BILL_STREET2", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.address?.line2 || '') : (this.billingInformation.address?.line2 || ''))});
            valuePairs.push({name: "BILL_CITY", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.address?.city || '') : (this.billingInformation.address?.city || ''))});
            valuePairs.push({name: "BILL_STATE", value: (this.isGivingAsOrg ? this.abbreviateState(this.organizationBillingInformation?.address?.state) : this.abbreviateState(this.billingInformation.address?.state))});
            valuePairs.push({name: "BILL_POSTAL_CODE", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.address?.postal_code || '') : (this.billingInformation.address?.postal_code || ''))});
            valuePairs.push({name: "BILL_COUNTRY", value: (this.isGivingAsOrg ? (this.organizationBillingInformation?.address?.country || '') : (this.billingInformation.address?.country || ''))});
        }

        return valuePairs;
    }

    sendToTouchNetForm(touchNetTicket, touchNetUPaySite, touchNetUPaySiteId) {
        if (!touchNetTicket || !touchNetUPaySite || !touchNetUPaySiteId) {
            return;
        }

        let form = document.createElement("form");
        form.method = "POST";
        form.action = touchNetUPaySite;
        form.target = "_blank";

        let elementTicket = document.createElement("input");  
        elementTicket.name = "TICKET";
        elementTicket.value = touchNetTicket;
        elementTicket.setAttribute("type", "hidden");
        form.appendChild(elementTicket);  

        let elementTicketName = document.createElement("input"); 
        elementTicketName.name = "TICKET_NAME";
        elementTicketName.value = this.paymentOrigin;
        elementTicketName.setAttribute("type", "hidden");
        form.appendChild(elementTicketName);

        let elementUpaySiteId = document.createElement("input"); 
        elementUpaySiteId.name = "UPAY_SITE_ID";
        elementUpaySiteId.value = touchNetUPaySiteId;
        elementUpaySiteId.setAttribute("type", "hidden");
        form.appendChild(elementUpaySiteId);  

        document.body.appendChild(form);

        form.submit();

        this._touchNetDisplayMessage = 'Please finish the payment process on the hosted checkout page.';
    }

    abbreviateState(input){
        if (!input) {
            return '';
        }

        if (input.length === 2) {
            return input.toUpperCase();
        }

        let statesMapping = {
            'arizona': 'AZ',
            'alabama': 'AL',
            'alaska': 'AK',
            'arkansas': 'AR',
            'california': 'CA',
            'colorado': 'CO',
            'connecticut': 'CT',
            'delaware': 'DE',
            'florida': 'FL',
            'georgia': 'GA',
            'hawaii': 'HI',
            'idaho': 'ID',
            'illinois': 'IL',
            'indiana': 'IN',
            'iowa': 'IA',
            'kansas': 'KS',
            'kentucky': 'KY',
            'louisiana': 'LA',
            'maine': 'ME',
            'maryland': 'MD',
            'massachusetts': 'MA',
            'michigan': 'MI',
            'minnesota': 'MN',
            'mississippi': 'MS',
            'missouri': 'MO',
            'montana': 'MT',
            'nebraska': 'NE',
            'nevada': 'NV',
            'new hampshire': 'NH',
            'new jersey': 'NJ',
            'new mexico': 'NM',
            'new york': 'NY',
            'north carolina': 'NC',
            'north dakota': 'ND',
            'ohio': 'OH',
            'oklahoma': 'OK',
            'oregon': 'OR',
            'pennsylvania': 'PA',
            'rhode island': 'RI',
            'south carolina': 'SC',
            'south dakota': 'SD',
            'tennessee': 'TN',
            'texas': 'TX',
            'utah': 'UT',
            'vermont': 'VT',
            'virginia': 'VA',
            'washington': 'WA',
            'west virginia': 'WV',
            'wisconsin': 'WI',
            'wyoming': 'WY',
            'district of columbia' : 'DC',
            'northern mariana islands' : 'MP',
            'puerto rico' : 'PR',
            'american samoa' : 'AS',
        };

        return statesMapping[input.toLowerCase()];
    }

    handleSpreedlyPayment(paymentId, additionalPaymentDataMap) {
        if (this.isPayWithACH) {
            additionalPaymentDataMap.billingInformation = this.spreedlyBillingInformationMap;
        }
        const opts = { 'params': {
                giftType: this.paymentType,
                paymentMethod: this.paymentMethod,
                amount: this.amount,
                externalGatewayName: this.externalGatewayName,
                paymentId: paymentId,
                additionalPaymentDataMap: additionalPaymentDataMap,
                isCreatePledgeSubscription: this._isCreatePledgeSubscription
            }
        };
        getSpreedlyTransactionToken(opts).then(transactionToken => {
            additionalPaymentDataMap.transactionToken = transactionToken;

            submitForm(this, (recaptchaToken) => {
                    this.handlePaymentConfirmation({paymentId: paymentId, additionalPaymentDataMap: additionalPaymentDataMap, recaptchaToken: recaptchaToken});}, 
                    (error) => {console.log(error)})
        }).catch(e => {
            console.log(e);
            let errorMap = JSON.parse(e.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }).finally(() => {
            this._isShowSpinner = false;
        })
    }

    handleACHChoice(event) {
        this._currentPaymentChoice = 'ACH';
        this._apiKey = '';
    }

    handleCardChoice(event) {
        this._currentPaymentChoice = 'Credit';
        this._apiKey = '';
    }

    handlePreviousButtonClick(event) {
        this._currentPaymentChoice = '';
        this._apiKey = '';
        this.handlePreviousClick();
    }
}