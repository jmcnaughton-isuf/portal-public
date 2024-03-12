import { LightningElement, api, track, wire } from 'lwc';
import getFrontEndData from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_getFrontEndDataMap';
import getPicklists from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_getPicklists';
import submitApplication from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_submitHiringManagerApplication';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRelativeUrl } from 'c/portal_util_Urls';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_HiringManagerApplication extends LightningElement {
    @api redirectPage;
    @api frontEndDataMap;
    @api emailTypeString;
    @api phoneTypeString;
    @api applicantHeader;
    @api companyHeader;
    @api emailTemplateDeveloperName = undefined;

    @track _isRecaptchaEnabled = false;
    @track _currentPage = 1;
    _callbackDone = false;
    _picklists = {};
    _showSpinner = false;
    _emailConfirmation = '';
    _emailTypes = [];
    _phoneTypes = [];
    _data = {};
    _buttonSize=12;
    _phoneNumberLimit = 15;

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_CommunityUserControllerBase.submitHiringManagerApplication'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    connectedCallback() {
        if (this.emailTypeString) {
            let emailTypeList = this.emailTypeString.split(',');
            for (let email of emailTypeList) {
                this._emailTypes.push({'value': email, 'label': email});
            }
        }

        if (this.phoneTypeString) {
            let phoneTypeList = this.phoneTypeString.split(',');
            for (let phone of phoneTypeList) {
                this._phoneTypes.push({'value': phone, 'label': phone});
            }
        }

        const params = {params:{pageName:'Hiring Manager'}};
        getFrontEndData(params).then(res => {
            this.frontEndDataMap = res;
            this._callbackDone = true;
        }).catch(console.error);
        getPicklists(params).then(res => {
            this._picklists = res;
        }).catch(console.error);
    }

    get isShowFirstPage() {
        return this._callbackDone && this._currentPage == 1;
    }

    get isShowSecondPage() {
        return this._callbackDone && this._currentPage == 2;
    }

    get isShowPrevious() {
        return this._currentPage == 2;
    }

    get isShowNext() {
        return this._currentPage == 1;
    }


    get isShowSubmit() {
        return this._currentPage == 2;
    }

    get firstName() {
        return this.getRecordValue('firstName');
    }

    get middleName() {
        return this.getRecordValue('middleName');
    }

    get lastName() {
        return this.getRecordValue('lastName');
    }

    get emailAddress() {
        return this.getRecordValue('emailAddress');
    }

    get emailType() {
        return this.getRecordValue('emailType');
    }

    get phoneNumber() {
        return this.getRecordValue('phoneNumber');
    }

    get phoneType() {
        return this.getRecordValue('phoneType');
    }

    get jobTitle() {
        return this.getRecordValue('jobTitle');
    }

    get companyName() {
        return this.getRecordValue('companyName');
    }

    get description() {
        return this.getRecordValue('description');
    }

    get website() {
        return this.getRecordValue('website');
    }

    get linkedIn() {
        return this.getRecordValue('linkedIn');
    }

    get industry() {
        return this.getRecordValue('industry');
    }

    get companyPhoneNumber() {
        return this.getRecordValue('companyPhoneNumber');
    }

    get companyEmailAddress() {
        return this.getRecordValue('companyEmailAddress');
    }

    get addressLine1() {
        return this.getRecordValue('addressLine1');
    }

    get addressLine2() {
        return this.getRecordValue('addressLine2');
    }

    get addressCity() {
        return this.getRecordValue('addressCity');
    }

    get addressState() {
        return this.getRecordValue('addressState');
    }

    get addressCountry() {
        return this.getRecordValue('addressCountry');
    }

    get addressPostalCode() {
        return this.getRecordValue('addressPostalCode');
    }

    get emailConfirmation() {
        return this._emailConfirmation;
    }

    confirmEmail = (event) => {
        this._emailConfirmation = event.currentTarget.value;
        this.checkMatchingEmails(event.currentTarget);
    }

    checkMatchingEmails(emailVerificationInput) {
        if (this._emailConfirmation && this._emailConfirmation != this.getRecordValue('emailAddress')) {
            if (emailVerificationInput) {
                emailVerificationInput.setCustomValidity('The emails do not match.');
                emailVerificationInput.reportValidity();
            } else {
                this.showErrorToast('The emails you have entered do not match.');
            }
            return false;
        } else {
            if (emailVerificationInput) {
                emailVerificationInput.setCustomValidity('');
            }
            return true;
        }
    }

    getRecordValue(fieldId) {
        let stagingRecordFieldName = this.frontEndDataMap[fieldId].stagingRecordFieldName;
        let stagingRecordObjectName = this.frontEndDataMap[fieldId].stagingRecordObjectName;
        if (this._data[stagingRecordObjectName] && this._data[stagingRecordObjectName][stagingRecordFieldName]) {
            return this._data[stagingRecordObjectName][stagingRecordFieldName];
        }
        return '';
    }

    setRecordValue = (event) => {
        let fieldId = event.currentTarget.name;
        let stagingRecordFieldName = this.frontEndDataMap[fieldId].stagingRecordFieldName;
        let stagingRecordObjectName = this.frontEndDataMap[fieldId].stagingRecordObjectName;
        if (this._data[stagingRecordObjectName]) {
            this._data[stagingRecordObjectName][stagingRecordFieldName] = event.currentTarget.value;
        } else {
            this._data[stagingRecordObjectName] = {};
            this._data[stagingRecordObjectName][stagingRecordFieldName] = event.currentTarget.value;
        }
    }

    getFieldLabel(stagingRecordObjectName, stagingRecordFieldName) {
        for (let eachField of Object.values(this.frontEndDataMap)) {
            if (eachField.stagingRecordObjectName === stagingRecordObjectName && eachField.stagingRecordFieldName === stagingRecordFieldName) {
                return eachField.label;
            }
        }

        return '';
    }

    handleNextPage(event) {
        if (this._currentPage == 1) {
            if (!this.checkInputValidity()) {
                return;
            }

            if (!this.getRecordValue('firstName') || !this.getRecordValue('lastName') || !this.getRecordValue('emailAddress')
                || !this.getRecordValue('jobTitle') || !this._emailConfirmation) {
                this.showErrorToast('Please fill out all required fields.');
            } else {
                this._currentPage = 2;
                this._buttonSize = 6;
            }
        }
    }

    handlePreviousPage(event) {
        this._currentPage = 1;
        this._buttonSize = 12;
    }

    handleSubmit(event) {
        if (!this.checkInputValidity()) {
            return;
        }

        if (!this.getRecordValue('firstName') || !this.getRecordValue('lastName') || !this.getRecordValue('emailAddress') 
               || !this._emailConfirmation || !this.getRecordValue('companyName')) {
            this.showErrorToast('Please fill out all required fields.');
        } else {
            submitForm(this, this.submissionLogic, (error) => {
                console.log(error);
            });
        }
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        this._showSpinner = true;
        const params = {data:this._data, interimSourceUrl: getRelativeUrl(), recaptchaToken: recaptchaToken, emailTemplateDeveloperName: this.emailTemplateDeveloperName};
        
        submitApplication({params: params}).then(() => {
            this._showSpinner = false;

            if (this.redirectPage) {
                window.location.href = './' + this.redirectPage;
                return;
            }
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your request has been submitted.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);  
            
        }).catch((error) => {
            console.log(error);
            let errorMap = JSON.parse(error.body.message);
            try {
                errorMap = JSON.parse(errorMap.message);
            } catch (e) { }
        
            if (errorMap.sObjectApiName) {
                this.showErrorToast(this.getFieldLabel(errorMap.sObjectApiName, errorMap.fieldApiName) + ' must be ' + errorMap.maxLength + ' characters or less.');
            } else {
                this.showErrorToast(errorMap.message);
            }

            this._showSpinner = false;
            errorRecaptchaCallback();
        });
    }

    clearValidity(event) {
        event.target.setCustomValidity('');
    }

    checkInputValidity() {
        // check if both emails match
        if (!this.checkMatchingEmails(this.template.querySelector('[data-name="verify"]'))) {
            return false;
        }
        
        // check input validity based on input type, input required
        let inputs = this.template.querySelectorAll('input');
        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (input.value) {
                        input.setCustomValidity('');
                        input.reportValidity();
                        return false;
                    }
                    this.showErrorToast('Please fill out all required fields.');
                    return false;
                }
            }
        }

        // check phone number
        let phoneNumberInput = this.template.querySelector('[data-name="phoneNumber"]')
        let phoneNumberValue = this.getRecordValue('phoneNumber').toString().replace(/\D/g, '');
        if (phoneNumberInput && phoneNumberValue.length > this._phoneNumberLimit) {
            phoneNumberInput.setCustomValidity('The phone number format is not valid.');
            phoneNumberInput.reportValidity();
            return false;
        }

        return true;
    }

    showErrorToast(errorMessage) {
        const event = new ShowToastEvent({
            title: 'Error!',
            message: errorMessage,
            variant:"error",
            mode:"sticky"
        });
        this.dispatchEvent(event);
    }

}