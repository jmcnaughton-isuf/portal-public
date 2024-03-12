import { LightningElement, api, wire } from 'lwc';
import getFrontEndData from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_getFrontEndDataMap';
import submitApplication from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_submitNewUserApplication';
import getPicklists from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_getPicklists';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import checkUsername from '@salesforce/apex/ISUF_NewUserLoginFormHelper.checkUsername';
import checkEmail from '@salesforce/apex/ISUF_NewUserLoginFormHelper.checkEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRelativeUrl } from 'c/portal_util_Urls';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_NewUserLoginFormOR extends LightningElement {

    @api frontEndDataMap;
    @api emailTypeString;
    @api phoneTypeString;
    @api addressTypeString;
    @api isConfirmEmail = false;
    @api redirectPage;
    @api emailTemplateDeveloperName = undefined;
    _isRecaptchaEnabled = false;
    _callbackDone = false;
    _interim = {};
    _showSpinner = true;
    _emailConfirmation = '';
    _emailTypes = [];
    _phoneTypes = [];
    _addressTypes = [];
    _degree = '';
    _degreeYear = '';
    _picklists = {};
    _phoneNumberLimit = 15;
    _messageOnInvalidEmail = 'Please enter a valid email address (Example: \'email@example.com\').';

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_CommunityUserControllerBase.submitNewUserApplication'}})
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

        if (this.addressTypeString) {
            let addressTypeList = this.addressTypeString.split(',');
            for (let address of addressTypeList) {
                this._addressTypes.push({'value': address, 'label': address});
            }
        }

        const params = {params:{pageName:'New User Login'}};
        getFrontEndData(params).then(res => {
            this.frontEndDataMap = res;
            this._callbackDone = true;
            console.log('this.frontEndDataMap');
            console.log(res);
        }).catch(console.error);
        getPicklists(params).then(res => {
            this._picklists = res;
            this._showSpinner = false;
            console.log('this._picklists');
            console.log(res);
        }).catch(console.error);
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

    get prefix() {
        return this.getRecordValue('prefix');
    }

    get suffix() {
        return this.getRecordValue('suffix');
    }

    get gender() {
        return this.getRecordValue('gender');
    }

    get birthdate() {
        return this.getRecordValue('birthdate');
    }

    get nicknameFirstName() {
        return this.getRecordValue('nicknameFirstName');
    }

    get nicknameLastName() {
        return this.getRecordValue('nicknameLastName');
    }

    get maidenFirstName() {
        return this.getRecordValue('maidenFirstName');
    }

    get maidenMiddleName() {
        return this.getRecordValue('maidenMiddleName');
    }

    get maidenLastName() {
        return this.getRecordValue('maidenLastName');
    }

    get degree() {
        return this._degree;
    }

    get degreeYear() {
        return this._degreeYear;
    }

    get studentId() {
        return this.getRecordValue('studentId');
    }

    setDegreeYear(event) {
        this._degreeYear = event.currentTarget.value;
    }

    setDegree = (event) => {
        this._degree = event.currentTarget.value;
    }

    get emailAddress() {
        return this.getRecordValue('emailAddress');
    }

    get username() {
        return this.getRecordValue('username');
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

    get addressType() {
        return this.getRecordValue('addressType');
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
        if (this._interim[stagingRecordFieldName]) {
            return this._interim[stagingRecordFieldName];
        }
        return '';
    }

    setRecordValue = (event) => {
        let fieldId = event.currentTarget.name;
        let stagingRecordFieldName = this.frontEndDataMap[fieldId].stagingRecordFieldName;
        this._interim[stagingRecordFieldName] = event.currentTarget.value;
        event.currentTarget.setCustomValidity('');
    }

    handleSubmit(event) {
        if (!this.checkInputValidity()) {
            return;
        }

        if (!this.getRecordValue('username') && this.getRecordValue('username').length < 5) {
            this.showErrorToast('Please make sure your username is at least 5 characters.');
        } 
        else{
            if (!this.getRecordValue('firstName') || !this.getRecordValue('lastName') || !this.getRecordValue('emailAddress')
                    || (this.isConfirmEmail && !this._emailConfirmation)) {
                this.showErrorToast('Please fill out all required fields.');
            } 
            else{
                callApexFunction(this, checkUsername, {'username' : this.getRecordValue('username')}, (result) => {
                    if(result){
                        callApexFunction(this, checkEmail, {'email' : this.getRecordValue('emailAddress')}, (result2) => {
                            if(result2){
                                submitForm(this, this.submissionLogic, (error) => {
                                console.log(error);
                                });
                            }
                            else{
                                this.showErrorToast('This email is not unique.');
                            }
                            
                        }, (error) => {
                            console.log(error);
                        });
                    }
                    else{
                        this.showErrorToast('This username is not unique.');
                    }
                    
                }, (error) => {
                    console.log(error);
                });
            }
        }
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        this._showSpinner = true;
        console.log('this._interim');
        console.log(this._interim);
        console.log(JSON.stringify(this._interim));

        const params = {interim:this._interim, degree:this._degree, degreeYear: this._degreeYear, interimSourceUrl: getRelativeUrl(), recaptchaToken: recaptchaToken, emailTemplateDeveloperName: this.emailTemplateDeveloperName};

        callApexFunction(this, submitApplication, params, (result) => {
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
            
        }, (error) => {
            console.log(error);
            this._showSpinner = false;
            errorRecaptchaCallback();
        });
    }

    handlePhoneType = (event) => {
        let stagingRecordFieldName = this.frontEndDataMap['phoneType'].stagingRecordFieldName;
        this._interim[stagingRecordFieldName] = event.currentTarget.value;
    }

    handleEmailType = (event) => {
        let stagingRecordFieldName = this.frontEndDataMap['emailType'].stagingRecordFieldName;
        this._interim[stagingRecordFieldName] = event.currentTarget.value;
    }

    handleAddressType = (event) => {
        let stagingRecordFieldName = this.frontEndDataMap['addressType'].stagingRecordFieldName;
        this._interim[stagingRecordFieldName] = event.currentTarget.value;
    }

    hasValidEmailInput() {
        let validity = true;

        let email = this.template.querySelector('[name="emailAddress"]');
        let emailVal = email.value;

        // Email validation regex, this would accept any string that follows the rules of:
        // Must have non-empty name and domain strings separated by a single '@' character (cannot have more than 1 '@')
        // Domain string must also have two non-empty strings separated by a '.', such as name@domain.part
        const validEmailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailVal.match(validEmailRegex)) {
            email.setCustomValidity(this._messageOnInvalidEmail);
            email.reportValidity();
            validity = false;
        } else {
            email.setCustomValidity('');
        }

        return validity;
    }

    checkInputValidity() {
        if (!this.checkMatchingEmails(this.template.querySelector('[data-name="verify"]'))) {
            return false;
        }

        let inputs = this.template.querySelectorAll('c-portal_-input');
        let validity = true;

        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (input.value) {
                        input.setCustomValidity('');
                        input.reportValidity('');
                        return false;
                    }
                    this.showErrorToast('Please fill out all required fields.');
                    return false;
                }
            }
        }

        let phoneNumberInput = this.template.querySelector('[data-name="phoneNumber"]')
        let phoneNumberValue = this.getRecordValue('phoneNumber').toString().replace(/\D/g, '');
        if (phoneNumberInput && phoneNumberValue.length > this._phoneNumberLimit) {
            phoneNumberInput.setCustomValidity('The phone number format is not valid.');
            phoneNumberInput.reportValidity();
            return false;
        }

        validity = this.hasValidEmailInput() && validity;

        return validity;
    }

    showErrorToast(message) {
        const errorEvent = new ShowToastEvent({
            title: 'Error!',
            message: message,
            variant:"error",
            mode:"sticky"
        });
        this.dispatchEvent(errorEvent);
    }
}