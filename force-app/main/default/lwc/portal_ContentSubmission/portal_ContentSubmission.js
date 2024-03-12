import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';

import SERVER_initializeContentSubmission from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_initializeContentSubmission';
import SERVER_getAttachedContentDocuments from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_getAttachedContentDocuments';
import SERVER_submitContent from '@salesforce/apex/PORTAL_LWC_ContentSubmissionController.SERVER_submitContent';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';

import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_Accordian extends LightningElement {
    @api pageName;
    @api mainSectionName = 'Content Submission Form';
    @api recordType = 'Event';
    
    @track _isRecaptchaEnabled;
    @track pageMetadata;
    @track picklists;
    @track _listing = {};
    @track _recordId = '';
    @track _isClone = false;
    @track _showSpinner = false;
    @track _isAcceptedTermsOfAgreement = false;
    @track _uploadedFiles = [];

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_ContentSubmissionControllerBase.submitContent'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    get isShowPage() {
        return this._listing && this.pageMetadata;
    }
    
    get isSubmitDisabled() {
        return !this._isAcceptedTermsOfAgreement;
    }

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        this._recordId = urlParams.get('recordId');
        this._isClone = urlParams.get('isClone');

        this._showSpinner = true;
        SERVER_initializeContentSubmission({params: {pageName: this.pageName,
                                                     mainSectionName: this.mainSectionName,
                                                     recordId: this._recordId,
                                                     recordType: this.recordType,
                                                     isClone: this._isClone}}).then(result => {
            this.picklists = result.picklists;
            if (this.picklists) {
                for (let key in this.picklists) {
                    if (this.picklists[key]) {
                        this.picklists[key].unshift({label: 'Please Select a Value', value: ''});
                    }
                }
            }

            if (result.listingWrapperMap) {
                this._listing = result.listingWrapperMap['Content Submission Form'].records[0];
                this._recordId = result.listingWrapperMap['Content Submission Form'].records[0].Id;

                // _listing is undefined if the user lacks permission
                if (!this._listing) {
                    throw new Error();
                }

            } else {
                this._recordId = result.listingId;
            }

            if (result.uploadedFiles) {
                this._uploadedFiles = result.uploadedFiles;
            }

            this.pageMetadata = {};

            if (result.frontEndDataMap) {
                for (const key in result.frontEndDataMap) {
                    if (result.frontEndDataMap[key].display === true) {
                        if ((key === 'eventStartDateTime' || key === 'eventEndDateTime') && this._listing[key]) {
                            let tempDate = new Date(this._listing[key]);
                            // Adjust for time zone when parsing ISO String
                            this._listing[key] = new Date(tempDate.getTime() - tempDate.getTimezoneOffset() * 60000).toISOString().slice(0, -8);
                        }

                        if (!this._listing[key]) {
                            this._listing[key] = ''
                        }

                        this.pageMetadata[key] = result.frontEndDataMap[key];
                    }
                }

                result.frontEndDataMap.eventStartDateTime.max = "4000-12-31T23:59";
                result.frontEndDataMap.eventEndDateTime.max = "4000-12-31T23:59";
            }

            this._showSpinner = false;
        }).catch(error => {
            this.displayErrorToast('The event was not found.');
            this._showSpinner = false;
        })

    }

    handleInputChange = (event) => {
        if (event.target.name) {
            this._listing[event.target.name] = event.target.value;
        }
    }
    
    handleFileUpload = (event) => {
        // event.detail.files has the following format:
        // [{"name":"hi.txt","documentId":"069DR000003Buy6YAC","contentVersionId":"068DR000003CNPuYAO","contentBodyId":"05TDR000006sr352AA","mimeType":"text/plain"}]
        this._uploadedFiles = [...this._uploadedFiles, ...event.detail.files];
    }

    async handleSubmit() {
        this._showSpinner = true;
        let sectionEditFields = this.template.querySelectorAll('c-portal_-Section-Edit-Field');
        if (!(await this.checkValidity(sectionEditFields))) {
            this._showSpinner = false;
            return;
        }

        this.updateListingForSubmit(sectionEditFields);

        submitForm(this, this.submissionLogic, (error) => {
            this._showSpinner = false;
            console.log(error);
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        const params = {pageName: this.pageName, 
                        mainSectionName: this.mainSectionName, 
                        listingWrapper: this._listing, 
                        recordId: this._recordId,
                        recaptchaToken: recaptchaToken};

        callApexFunction(this, SERVER_submitContent, params, () => {
            this._showSpinner = false;
            window.location.href = 'submitted-content';
        }, (error) => {
            this._showSpinner = false;
            console.log(error);
            errorRecaptchaCallback();
        });
    }

    async checkValidity(sectionEditFields) {
        let isValid = this.checkSectionEditFieldValidity(sectionEditFields);
        isValid = isValid && (await this.checkFileUploadValidity());
        return isValid;
    }

    checkSectionEditFieldValidity(sectionEditFields) {
        if (!sectionEditFields || sectionEditFields.length === 0) {
            return true;
        }

        for (const eachSectionEditField of sectionEditFields) {
            if (!eachSectionEditField.checkValidity()) {
                // for consistency, use toast error instead of reportValidity
                this.displayErrorToast(this.pageMetadata[eachSectionEditField.fieldId].label + ' is invalid.');
                return false;
            }
        }

        return true;
    }

    checkFileUploadValidity = () => {
        if (!this.pageMetadata.eventPhotos?.isRequired) {
            return true;
        }

        // this returns a promise that the caller can await on
        return callApexFunction(this, SERVER_getAttachedContentDocuments, {recordId: this._recordId}, (result) => {
            let backendFileIdSet = new Set();
            for (const eachFile of result) {
                backendFileIdSet.add(eachFile.documentId);
            }
    
            // "required" implies that only 1 file needs to uploaded and verified
            for (const eachFile of this._uploadedFiles) {
                if (backendFileIdSet.has(eachFile.documentId)) {
                    return true;
                }
            }
    
            // either there were no files uploaded or no files match backend file IDs
            this.displayErrorToast('Please upload a file for ' + this.pageMetadata.eventPhotos.label);
            return false;
        }, () => {});
    }

    updateListingForSubmit(sectionEditFields) {
        if (sectionEditFields && sectionEditFields.length > 0) {
            try {
                sectionEditFields.forEach(element => {
                    let fieldChanges = element.getEditInformation();

                    if ((fieldChanges.fieldId === 'eventStartDateTime'
                                || fieldChanges.fieldId === 'eventEndDateTime')
                            && fieldChanges.value) {
                        let dt = new Date(fieldChanges.value);

                        fieldChanges.value = `${dt.getFullYear().toString().padStart(4, '0')}-${
                                                 (dt.getMonth()+1).toString().padStart(2, '0')}-${
                                                 dt.getDate().toString().padStart(2, '0')} ${
                                                 dt.getHours().toString().padStart(2, '0')}:${
                                                 dt.getMinutes().toString().padStart(2, '0')}:${
                                                 dt.getSeconds().toString().padStart(2, '0')}`
                    }

                    this._listing[fieldChanges.fieldId] = fieldChanges.value;
                })
            } catch (e) {
                console.log(e);
            }
        }
    }

    handleTermsChange = (event) => {
        this._isAcceptedTermsOfAgreement = event.target.checked;
    }

    displayErrorToast(message) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error!',
            message: message,
            variant:"error",
            mode:"sticky"
        }));
    }
}