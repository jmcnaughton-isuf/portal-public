import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';
import sendUsernameToEmail from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_sendUsernameToEmail';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildEmailTemplateDeveloperName(emailTemplateDeveloperName) {
        this.result._emailTemplateDeveloperName = emailTemplateDeveloperName;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;
    _emailTemplateDeveloperName = '';
    _emailAddress = '';
    _errorMessage = '';
    _isShowSpinner = false;

    get emailTemplateDeveloperName() {
        return this._emailTemplateDeveloperName;
    }

    get emailAddress() {
        return this._emailAddress;
    }

    get errorMessage() {
        return this._errorMessage;
    }

    get isShowSpinner() {
        return this._isShowSpinner;
    }

    set emailTemplateDeveloperName(emailTemplateDeveloperName) {
        this._emailTemplateDeveloperName = emailTemplateDeveloperName;
    }

    set emailAddress(emailAddress) {
        this._emailAddress = emailAddress;
        this._lightningElement.componentAttributes.emailAddress = emailAddress;
    }

    set errorMessage(errorMessage) {
        this._errorMessage = errorMessage;
        this._lightningElement.componentAttributes.errorMessage = errorMessage;
    }

    set isShowSpinner(isShowSpinner) {
        this._isShowSpinner = false;
        this._lightningElement.componentAttributes.isShowSpinner = isShowSpinner;
    }

    handleEmailChange(emailAddress) {
        this.emailAddress = emailAddress;
    }

    handleCancel(event) {
        window.location.href = '/s/login';
    }

    handleSubmit(event) {
        this.errorMessage = '';
        let emailInput = this._lightningElement.template.querySelector('input');
        if (!this.emailAddress || !emailInput.checkValidity()) {
            this.errorMessage = 'Please enter a valid email address.';
            return;
        }

        this.isShowSpinner = true;
        submitForm(this._lightningElement, this.submissionLogic, (error) => {
            this.errorMessage = error;
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        const params = {emailAddress: this.emailAddress,
                        emailTemplateDeveloperName: this.emailTemplateDeveloperName,
                        recaptchaToken: recaptchaToken};

        callApexFunction(this._lightningElement, sendUsernameToEmail, params, (result) => {
            this._lightningElement.dispatchEvent(new ShowToastEvent({
                title: "Success!",
                message: "Your request has been successfully submitted. Please check your email address.",
                variant: "success",
                mode: "sticky"
            }));
        }, (error) => {
            console.log(error);
            errorRecaptchaCallback();
        }).finally(() => {
            this.isShowSpinner = false;
        });
    }

    clearErrorMessage() {
        this.errorMessage = '';
    }
}