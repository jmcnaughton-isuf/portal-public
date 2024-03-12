import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import recaptchaChannel from '@salesforce/messageChannel/recaptchaChannel__c';
import getOrigin from "@salesforce/apex/PORTAL_LWC_PaymentHubController.SERVER_getOrigin";
import getRecaptchaOption from "@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getRecaptchaOption";

export default class Portal_Recaptcha extends LightningElement {
    @wire(MessageContext) messageContext;
    @api recaptchaOption = '';

    @api handleRecaptchaRequest() {
        switch (this.recaptchaOption.toUpperCase()) {
            case "reCAPTCHA V2 Checkbox".toUpperCase(): {
                // verified is false when there is no verification
                // or when verification expired
                if (!this._isRecaptchaVerified) {
                    this.handleRecaptchaMissing();
                    break;
                }

                break;
            }
            case "reCAPTCHA V3".toUpperCase(): {
                this.handleRecaptchaV3Request();
                break;
            }
        }
    }

    @api isRecaptchaVerified() {
        return this._isRecaptchaVerified;
    }

    @api resetRecaptchaForLogin() {
        this.resetRecaptchaV2();
    }

    @api resetRecaptchaV2 = () => {
        this._isRecaptchaVerified = false;
        this.handleMessage({type: "recaptcha-v2-reset"});
    }

    @api isCurrentRecaptchaOptionValid() {
        return this.isDisplayRecaptchaV2Checkbox || this.isDisplayRecaptchaV3;
    }

    @api setCallbacks(thisRef, functionCallback, errorCallback) {
        this._recaptchaCallbackObject = new RecaptchaCallback(thisRef, functionCallback, errorCallback);
    }

    @api getRecaptchaVersion() {
        return this.recaptchaOption;
    }

    @api getToken() {
        return this._recaptchaToken;
    }

    @api isCenterRecaptcha = false;
    
    @track _origin;
    
    _recaptchaToken = '';
    _recaptchaV2Style = '';
    _params = {};
    _isRecaptchaVerified = false;
    _subscription = null;
    _recaptchaIframeHeight = '100px';
    _recaptchaCallbackObject = null;

    get isDisplayRecaptchaV2Checkbox() {
        return this.recaptchaOption?.toUpperCase() == 'reCAPTCHA V2 Checkbox'.toUpperCase();
    }

    get isDisplayRecaptchaV3() {
        return this.recaptchaOption?.toUpperCase() == 'reCAPTCHA V3'.toUpperCase();
    }

    messageHandler = (message) => {
        this.handleWindowMessage(message);
    }

    connectedCallback() {
        const params = {'params':{}}
        getOrigin(params).then(res => {
            if (res) {
                this._origin = res;
            }
        }).catch(error => {
            console.log(error);
        })

        if (this.recaptchaOption == null || this.recaptchaOption == '') {
            getRecaptchaOption(params).then(res => {
                if (res) {
                    this.recaptchaOption = res;
                }
            }).catch(error => {
                console.log(error);
            })
        }
        this.subscribeToMessageChannel();
        window.addEventListener("message", this.messageHandler);
    }

    renderedCallback() {
        this._windowWidth = window.innerWidth;
        if (window.innerWidth < 300 && this.recaptchaOption.toUpperCase() === "reCAPTCHA V2 Checkbox".toUpperCase()) {
            this._recaptchaIframeHeight = '160px';
            let recaptchaElement = this.template.querySelector("iframe");
            if (recaptchaElement) {
                recaptchaElement.style = "height: 160px; width: 110%; display: block; padding-top: 1rem; justify-content: center; border-style: none;";
            }
        }
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
        window.removeEventListener("message", this.messageHandler);
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                recaptchaChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'recaptcha-v2-reset') {
            this.template.querySelector("iframe")?.contentWindow.postMessage(JSON.stringify({ type: "recaptcha_v2_reset_request"}), this._origin);
        }
    }

    handleWindowMessage(message) {
        if (message.origin === this._origin) {
            switch (message.data.type) {
                case "recaptcha_v2_verified": {
                    this._recaptchaToken = message.data.token;
                    this._isRecaptchaVerified = true;
                    break;
                }
                case "recaptchaChallengeVisible": {
                    // handling resizing of recaptcha iframe when the challenge appears
                    let recaptchaElement = this.template.querySelector("iframe");
                    if (message.data.visible === "visible") {
                        recaptchaElement.style = "height: 520px; width: 340px; display: block; padding-top: 1rem; justify-content: center; border-style: none; overflow: visible;";
                    } else {
                        recaptchaElement.style = "height: " + this._recaptchaIframeHeight + "; width: 110%; display: block; padding-top: 1rem; justify-content: center; border-style: none;";
                    }
                    break;
                }
                case "recaptcha_v2_expired": {
                    this._isRecaptchaVerified = false;
                    break;
                }
                case "recaptcha_v2_error": {
                    this.handleRecaptchaError();
                    break;
                }
                case "recaptcha_v3_response": {
                    // this is to handle all the other forms that support recaptcha
                    if (this._recaptchaCallbackObject) {
                        let functionCallback = this._recaptchaCallbackObject.getFunctionCallbackReference()
                        return functionCallback(message.data.token);
                    }

                    // event is for login form
                    const recaptchaReponseEvent = new CustomEvent('recaptchaReponse', {
                        detail: {token: message.data.token},
                    });

                    this.dispatchEvent(recaptchaReponseEvent);

                    break;
                }                
                case "recaptcha-rendered": {
                    if (!this.isCenterRecaptcha) {
                        break;
                    }

                    // combining slds-align_absolute-center with display grid will center recaptcha iframe
                    this._recaptchaV2Style = 'display: grid;'
                    break;
                }
            }
        }
    }

    handleRecaptchaV3Request() {
        // get token from vf page first
        this.template.querySelector("iframe").contentWindow.postMessage(JSON.stringify({ type: "recaptcha_v3_request"}), this._origin);
    }

    handleRecaptchaMissing() {
        const message = "Please verify with reCAPTCHA before submitting.";
        
        const toastEvent = new ShowToastEvent({
            "title": "Error",
            "message": message,
            "variant": "error"
        });
        
        this.dispatchEvent(toastEvent);
    }

    handleRecaptchaError() {
        const message = "There was an error loading reCAPTCHA on this page, please contact an Administrator";
        
        const toastEvent = new ShowToastEvent({
            "title": "Error",
            "message": message,
            "variant": "error"
        });
        
        this.dispatchEvent(toastEvent);
    }
}

export function submitForm(thisRef, functionCallback, errorCallback) {
    let recaptchaInstance = thisRef.template.querySelector('c-portal_-Recaptcha');

    if (recaptchaInstance && recaptchaInstance.isCurrentRecaptchaOptionValid()) {
        recaptchaInstance.setCallbacks(thisRef, functionCallback, errorCallback);

        recaptchaInstance.handleRecaptchaRequest();

        if (recaptchaInstance.getRecaptchaVersion().toUpperCase() == "reCAPTCHA V3".toUpperCase()) {
            return;
        }

        if (!recaptchaInstance.isRecaptchaVerified()) {
            return errorCallback();
        }

        functionCallback(recaptchaInstance.getToken(), recaptchaInstance.resetRecaptchaV2);
    } else {
        functionCallback();
    }
}

class RecaptchaCallback {
    _objectRef;
    _functionCallback;
    _errorCallback;

    constructor(thisObjectRef, functionCallback, errorCallback) {
        this._objectRef = thisObjectRef;
        this._functionCallback = functionCallback;
        this._errorCallback = errorCallback;
    }

    getObjectReference() {
        return this._objectRef;
    }

    getFunctionCallbackReference() {
        return this._functionCallback;
    }

    getErrorCallbackFunction() {
        return this._errorCallback;
    }
}