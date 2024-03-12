import { LightningElement, api, track } from 'lwc';
import { submitForm } from 'c/portal_Recaptcha';
import { ComponentLogic, ComponentLogicBuilder } from 'c/portal_ForgotUsername';

export default class Portal_ForgotUsernameExample extends LightningElement {
    @api forgotUsernameLabel = 'Forgot Username';
    @api emailAddressLabel = 'Email Address';
    @api submitLabel = 'Submit';
    @api cancelLabel = 'Cancel';
    @api emailTemplateDeveloperName = 'Portal_Send_Username';
    @api isRecaptchaEnabled = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};

    get emailAddress() {
        return this.componentAttributes.emailAddress || '';
    }

    get errorMessage() {
        return this.componentAttributes.errorMessage || '';
    }

    get isShowSpinner() {
        return this.componentAttributes.isShowSpinner || false;
    }

    connectedCallback() {
        this.setup();
    }
    
    setup() {
        // Instantiating the extension instead of the product ComponentLogicBuilder class.
        this.componentLogic = new ComponentLogicBuilderExtension().buildLightningElement(this)
                                                                  .buildEmailTemplateDeveloperName(this.emailTemplateDeveloperName)
                                                                  .build();
    }

    clearErrorMessage = () => {
        this.componentLogic.clearErrorMessage();
    }

    handleEmailChange = (event) => {
        this.componentLogic.handleEmailChange(event.currentTarget.value);
    }

    handleCancel = (event) => {
        this.componentLogic.handleCancel();
    }

    handleSubmit = (event) => {
        this.componentLogic.handleSubmit();
    }
}

class ComponentLogicBuilderExtension extends ComponentLogicBuilder {
    constructor() {
        super();
        this.result = new ComponentLogicExtension();
    }
}

class ComponentLogicExtension extends ComponentLogic {
    // This is an example of overriding a function in the product ComponentLogic class.
    handleSubmit(event) {
        this.errorMessage = '';
        let emailInput = this._lightningElement.template.querySelector('input');
        if (!this.emailAddress || !emailInput.checkValidity()) {
            this.errorMessage = "That email address won't work.";
            return;
        }

        this.isShowSpinner = true;
        submitForm(this._lightningElement, this.submissionLogic, (error) => {
            this.errorMessage = error;
        });
    }
}