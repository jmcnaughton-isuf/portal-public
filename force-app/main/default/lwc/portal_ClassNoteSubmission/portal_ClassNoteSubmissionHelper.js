import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { formatRelativeUrlWithRootPath } from 'c/portal_util_Urls';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

import isGuestUser from '@salesforce/user/isGuest';
import initializeClassNoteSubmission from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_initializeClassNoteSubmission';
import attachContentDocument from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_attachContentDocument';
import submitContent from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_submitContent';
import resetClassNoteSubmission from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_resetClassNoteSubmission';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildContentModuleName(contentModuleName) {
        this.result._contentModuleName = contentModuleName;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement = undefined;
    
    _contentModuleName = '';
    _isShowSpinner = true;
    _isDisplayComponent = false;
    _isRecaptchaEnabled = false;
    _recordId = undefined; 
    _currentPageIndex = undefined;
    _frontEndDataMap = {};
    _picklists = {};
    _contentModuleMetadata = {};
    _record = {};
    _uploadedFileName = '';
    _uploadedFileSrc = '';

    _isDisableNavigationInterrupt = true;
    _pageList = ['personalInfo', 'classNoteContent', 'preview', 'confirmation'];

    setComponentAttribute(field, value) {
        this['_' + field] = value;
        this._lightningElement[field] = value;
    }

    getComponentData() {
        const initializationParams = {
            contentModuleName: this._contentModuleName
        };

        const recaptchaParams = {
            classFunctionName: 'PORTAL_ContentSubmissionControllerBase.submitContent'
        }

        this.setComponentAttribute('isShowSpinner', true);

        Promise.all([
            callApexFunction(this._lightningElement, initializeClassNoteSubmission, initializationParams, (response) => {
                this.setInitializationAttributes(response);
            }, () => {}),
            callApexFunction(this._lightningElement, getIsRecaptchaEnabled, recaptchaParams, (response) => {
                this.setComponentAttribute('isRecaptchaEnabled', response);
            }, () => {})
        ]).then(() => {
            this.initializeNavigationInterrupt();
            this.setComponentAttribute('currentPageIndex', 0);
            this.setComponentAttribute('isDisplayComponent', true);
        }).finally(() => {
            this.setComponentAttribute('isShowSpinner', false);
        });
    }

    setInitializationAttributes(response) {
        this.setComponentAttribute('frontEndDataMap', response.frontEndDataMap);
        this.setComponentAttribute('picklists', response.picklists);
        this.setComponentAttribute('contentModuleMetadata', response.contentModuleMetadata);

        this.setComponentAttribute('recordId', response.listingId);
        // text input fields need default '' values instead of undefined so that the string 'undefined' isn't displayed
        this.setComponentAttribute('record', {firstName: '', lastName: '', emailAddress: '', classYear: '', ...response.listingWrapperMap});
    }

    initializeNavigationInterrupt() {
        this._isDisableNavigationInterrupt = false;
        window.addEventListener('beforeunload', (event) => {
            if (this._isDisableNavigationInterrupt) {
                return;
            }

            // Recommended
            event.preventDefault();

            // Included for legacy support, e.g. Chrome/Edge < 119
            event.returnValue = true;
        });
    }

    progressBarStepList(currentPageIndex) {
        let stepList = [];
        let timestamp = Date.now();

        for (let pageIndex = 0; pageIndex < this._pageList.length - 1; ++pageIndex) {
            let stepClasses = 'step';
            let connectorClasses = 'connector';
            if (pageIndex < currentPageIndex) {
                stepClasses += ' complete';
                connectorClasses += ' complete';
            } else if (pageIndex === currentPageIndex) {
                stepClasses += ' active';
            }

            stepList.push({class: stepClasses, timestamp: ++timestamp});

            if (pageIndex === this._pageList.length - 2) {
                continue;
            }

            stepList.push({class: connectorClasses, timestamp: ++timestamp});
        }

        return stepList;
    }

    isDisplayPersonalInfoPage(currentPageIndex) {
        return this._pageList[currentPageIndex] === 'personalInfo';
    }

    isDisplayClassNoteContentPage(currentPageIndex) {
        return this._pageList[currentPageIndex] === 'classNoteContent';
    }

    isDisplayPreviewPage(currentPageIndex) {
        return this._pageList[currentPageIndex] === 'preview';
    }

    isDisplayImagePreview() {
        return this._uploadedFileSrc || this._record.classNoteImageCaption;
    }

    isDisplayConfirmationPage(currentPageIndex) {
        return this._pageList[currentPageIndex] === 'confirmation';
    }

    isDisplayBackButton(currentPageIndex) {
        return currentPageIndex > 0 && currentPageIndex < (this._pageList.length - 1);
    }
    
    isDisplayNextButton(currentPageIndex) {
        return currentPageIndex < (this._pageList.length - 2);
    }

    isDisplaySubmitButton(currentPageIndex) {
        return currentPageIndex === (this._pageList.length - 2);
    }
    
    isDisplayRestartButton(currentPageIndex) {
        return currentPageIndex === (this._pageList.length - 1);
    }

    handleInput = (event) => {
        // reset email invalid message bc it's annoying to see it while typing
        if (event.currentTarget.type === 'email') {
            event.currentTarget.setCustomValidity('');
        }
    }

    handleChange = (event) => {
        let value = (event.currentTarget.type === 'checkbox') ? event.currentTarget.checked : event.currentTarget.value;
        let name = event.currentTarget.name;

        if (name === 'submissionCategory') {
            value = event.detail.value; // list of strings, lightning-dual-listbox's event.currentTarget.value is a comma separated string
        }

        this.setComponentAttribute('record', {...this._record, [name]: value});
    }

    handleBack = (event) => {
        this.setComponentAttribute('currentPageIndex', this._currentPageIndex - 1);
    }

    handleNext = (event) => {
        if (this.reportValidity()) {
            this.setComponentAttribute('currentPageIndex', this._currentPageIndex + 1);
        }
    }

    // returns true if everything on screen is valid
    reportValidity() {
        this.setCustomEmailValidity();
        return this.reportInputValidity();
    }

    reportInputValidity() {
        const inputFields = this._lightningElement.template.querySelectorAll('input,textarea,lightning-dual-listbox,lightning-file-upload');
        // const inputFields = this._lightningElement.template.querySelectorAll('input,textarea,c-portal_-select,lightning-file-upload');
        if (!inputFields || inputFields.length === 0) {
            return true;
        }

        for (const eachField of inputFields) {
            if (!eachField.reportValidity()) {
                return false;
            }
        }

        return true;
    }

    // stole this from new user login and made small modifications
    setCustomEmailValidity() {
        const inputFields = this._lightningElement.template.querySelectorAll('input[type="email"]');
        if (!inputFields || inputFields.length === 0) {
            return;
        }

        // Email validation regex, this would accept any string that follows the rules of:
        // Must have non-empty name and domain strings separated by a single '@' character (cannot have more than 1 '@')
        // Domain string must also have two non-empty strings separated by a '.', such as name@domain.part
        const validEmailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        for (const eachInput of inputFields) {
            if (!eachInput.value.match(validEmailRegex)) {
                eachInput.setCustomValidity('Please enter a valid email address (Example: \'email@example.com\').');
                return;
            }
             
            eachInput.setCustomValidity('');
        }
    }

    handleSubmit = (event) => {
        if (!this.reportValidity()) {
            return;
        }
        
        this.setComponentAttribute('isShowSpinner', true);
        submitForm(this._lightningElement, this.submissionLogic, (error) => {
            this.setComponentAttribute('isShowSpinner', false);
            console.log(error);
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        let recordCopy = {...this._record, submissionCategory: this._record.submissionCategory?.join(';')};

        const params = {
            pageName: 'Class Notes', 
            mainSectionName: 'Content Submission Form', 
            listingWrapper: recordCopy, 
            // recordId: this._recordId, // including this value will create a case, remains to be seen if that's good or bad
            recaptchaToken: recaptchaToken
        };

        callApexFunction(this._lightningElement, submitContent, params, () => {
            this._isDisableNavigationInterrupt = true;
            this.setComponentAttribute('currentPageIndex', this._currentPageIndex + 1);
            this.setComponentAttribute('isShowSpinner', false);
            this._lightningElement.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'You have successfully submitted your class note.',
                variant: 'success'
            }));
        }, (error) => {
            this.setComponentAttribute('isShowSpinner', false);
            errorRecaptchaCallback();
        });
    }

    handleRestart = (event) => {
        this.setComponentAttribute('isShowSpinner', true);
        callApexFunction(this._lightningElement, resetClassNoteSubmission, {}, (response) => {
            this.setComponentAttribute('recordId', response.listingId);
            this.setComponentAttribute('record', {Id: response.listingId, firstName: this._record.firstName, lastName: this._record.lastName, emailAddress: this._record.emailAddress, classYear: this._record.classYear});

            this._isDisableNavigationInterrupt = false; 
            this.setComponentAttribute('uploadedFileName', '');
            this.setComponentAttribute('uploadedFileSrc', '');
            this.setComponentAttribute('currentPageIndex', 0);
            this.setComponentAttribute('isShowSpinner', false);
        }, (error) => {
            this.setComponentAttribute('isShowSpinner', false);
        });
    }

    handleFileUpload = (event) => {
        // event.detail.files has the following format (documentId is only present for authenticated users):
        // [{"name":"hi.txt","documentId":"069DR000003Buy6YAC","contentVersionId":"068DR000003CNPuYAO","contentBodyId":"05TDR000006sr352AA","mimeType":"text/plain"}]
        const contentVersionId = event.detail.files[0].contentVersionId;
        this.setComponentAttribute('uploadedFileName', event.detail.files[0].name);
        this.setComponentAttribute('uploadedFileSrc', formatRelativeUrlWithRootPath('/sfc/servlet.shepherd/version/download/') + contentVersionId);

        if (!isGuestUser) {
            return;
        }

        this.setComponentAttribute('isShowSpinner', true);
        const params = {contentVersionId: contentVersionId, recordId: this._recordId};
        callApexFunction(this._lightningElement, attachContentDocument, params, () => {}, () => {}).finally(() => {
            this.setComponentAttribute('isShowSpinner', false);
        });
    }
}