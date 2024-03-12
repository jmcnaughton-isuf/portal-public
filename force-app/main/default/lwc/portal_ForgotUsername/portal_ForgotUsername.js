import { LightningElement, api, track } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_ForgotUsernameHelper';
export * from './portal_ForgotUsernameHelper';

export default class Portal_ForgotUsername extends LightningElement {
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
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
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