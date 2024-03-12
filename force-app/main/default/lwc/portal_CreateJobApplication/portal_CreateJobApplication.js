import { LightningElement, api, track, wire } from 'lwc';
import SERVER_createJobApplication from '@salesforce/apex/PORTAL_JobBoardController.SERVER_createJobApplication';
import SERVER_submitJobApplication from '@salesforce/apex/PORTAL_JobBoardController.SERVER_submitJobApplication';
import SERVER_getJobApplicationFileUploads from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getJobApplicationFileUploads';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import PORTAL_GLOBAL_CSS from '@salesforce/resourceUrl/Portal_Global_CSS';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_CreateJobApplication extends LightningElement {
    @api job;
    @api informationMap;
    @api handleClose = () => {};
    
    _isRecaptchaEnabled = false;
    _jobApplication;
    _callbackDone = false;
    _isShowModal = true;
    _messageOnInvalidEmail = 'Please enter a valid email address (Example: \'email@example.com\').';
    @track _resumeFiles = [];
    @track _optionalFiles = [];
    _isShowResume = false;
    _isShowOptionalFiles = false;
    _backEndFilesData = [];

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_JobBoardControllerBase.submitJobApplication'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    connectedCallback() {
        loadStyle(this, PORTAL_GLOBAL_CSS).then(() => {
            // your code with calls to the JS library
        }).catch(error => {console.log(error)});
        if (this.job) {
            const params = {params:{recordId:this.job.Id}};
            SERVER_createJobApplication(params).then(res => {
                if (res.jobApplication) {
                    this._jobApplication = JSON.parse(JSON.stringify(res.jobApplication));
                }
                this.informationMap = res;
                this._callbackDone = true;
                this._isShowModal = false;
            }).catch(error => {
                console.log(error);
            })
        }
    }

    get firstName() {
        return this.getRecordValue('firstName');
    }

    get lastName() {
        return this.getRecordValue('lastName');
    }

    get phone() {
        return this.getRecordValue('phone');
    }

    get email() {
        return this.getRecordValue('email');
    }

    get portfolioLink() {
        return this.getRecordValue('portfolioLink');
    }

    getRecordValue(fieldId) {
        if (!this.informationMap || !this.informationMap.frontEndData || !this.informationMap.frontEndData[fieldId] || !this._jobApplication) {
            return "";
        }

        let fieldName = this.informationMap.frontEndData[fieldId].stagingRecordFieldName;
        let fieldType = this.informationMap.frontEndData[fieldId].fieldType;
        let isPicklist = this.informationMap.frontEndData[fieldId].isPicklist;

        if (isPicklist) {
            if (!this.picklists || !this.picklists[fieldId]) {
                return '';
            }
            for (let picklistValue of this.picklists[fieldId]) {
                if (picklistValue.value == this._jobApplication[fieldName]) {
                    return picklistValue.label;
                }
            }
            return '';
        } else {
            if (this._jobApplication[fieldName]) {
                return this._jobApplication[fieldName];
            }
            if (fieldType == 'checkbox') {
                return false;
            }
            return '';
        }
    }

    setRecordValue = (event) => {
        let fieldId = event.currentTarget.name;
        let fieldName = this.informationMap.frontEndData[fieldId].stagingRecordFieldName;
        if (this.informationMap.frontEndData[fieldId].fieldType == 'checkbox') {
            this._jobApplication[fieldName] = event.currentTarget.checked;
            this._jobApplication = {...this._jobApplication};
        } else {
            this._jobApplication[fieldName] = event.currentTarget.value;
            this._jobApplication = {...this._jobApplication};
        }
        event.currentTarget.setCustomValidity("");
    }

    async checkInputValidity() {
        let inputs = this.template.querySelectorAll('input');
        let validity = true;

        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (validity === true) {
                        // input.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        if (this._jobApplication['Email__c']) {
            validity = this.hasValidEmailInput() && validity;
        }

        if (this.informationMap.frontEndData.resume.isRequired || this.informationMap.frontEndData.optionalFiles.isRequired) {
            validity = await this.hasValidFileUpload() && validity;
        }

        if (!validity) {
            let event = new ShowToastEvent({
                title: 'Error!',
                message: 'There are required fields missing.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }

        return validity;
    }

    hasValidEmailInput() {
        let validity = true;

        let email = this.template.querySelector('[name="email"]');
        let emailVal = email.value;

        // Email validation regex, this would accept any string that follows the rules of:
        // Must have non-empty name and domain strings separated by a single '@' character (cannot have more than 1 '@')
        // Domain string must also have two non-empty strings separated by a '.', such as name@domain.part
        const validEmailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailVal.match(validEmailRegex)) {
            email.setCustomValidity(this._messageOnInvalidEmail);
            validity = false;
        } else {
            email.setCustomValidity("");
        }

        email.reportValidity();
        return validity;
    }

    async hasValidFileUpload() {
        let validity = true;

        const params = {params: {jobApplicationId: this._jobApplication.Id}};
        this._backEndFilesData = await SERVER_getJobApplicationFileUploads(params);

        if (this.informationMap.frontEndData.resume.isRequired) {
            validity = this.verifyUploadedFilesExistInBackend(this._resumeFiles, this._backEndFilesData);
        }
        if (this.informationMap.frontEndData.optionalFiles.isRequired) {
            validity = this.verifyUploadedFilesExistInBackend(this._optionalFiles, this._backEndFilesData) && validity;
        }

        return validity;
    }

    verifyUploadedFilesExistInBackend(frontEndFilesData, backEndFilesData) {
        if (!frontEndFilesData || frontEndFilesData.length == 0 ||
            !backEndFilesData || backEndFilesData.length == 0) {
            return false
        }

        let validity = true;

        if (frontEndFilesData && frontEndFilesData.length > 0) {
            for (let eachFrontEndFileData of frontEndFilesData) {
                for (let eachBackEndFileIndex = 0; eachBackEndFileIndex < backEndFilesData.length; eachBackEndFileIndex++) {
                    if (backEndFilesData[eachBackEndFileIndex] == eachFrontEndFileData.documentId) {
                        break;
                    } else {
                        if (eachBackEndFileIndex == backEndFilesData.length - 1) {
                            validity = false;
                        }
                    }
                }
            }
        } else {
            validity = false;
        }

        return validity;
    }

    handleCancel(event) {
        this.handleClose();
    }

    async handleSubmit(event) {
        let isValid = await this.checkInputValidity();
        if (!isValid) {
            return;
        }

        submitForm(this, this.submissionLogic, (error) => {
            console.log(error);
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        const params = {jobApplication:this._jobApplication, recaptchaToken: recaptchaToken};
        callApexFunction(this, SERVER_submitJobApplication, params, () => {
            this.handleClose(true);
        }, (error) => {
            console.log(error);
            errorRecaptchaCallback();
        });
    }

    handleResumeUpload(event) {
        this._resumeFiles = [...this._resumeFiles, ...event.detail.files];
        this._isShowResume = true;
    }

    handleOptionalUpload(event) {
        this._optionalFiles = [...this._optionalFiles, ...event.detail.files];
        this._isShowOptionalFiles = true;
    }
}