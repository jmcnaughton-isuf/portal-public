import getContextualGivingFormData from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getContextualGivingFormData';
import getPicklists from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getPicklists';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { publish, createMessageContext } from 'lightning/messageService';
import recaptchaChannel from '@salesforce/messageChannel/recaptchaChannel__c';
import save from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_createReviewTransaction';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildGivingFormName(givingFormName) {
        this.result._givingFormName = givingFormName;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;
    _givingFormName = '';
    _isShowSpinner = false;
    _isDisplay = false;

    _formConfiguration = {};
    _currentPage = 'gift-details';
    _pageList = ['gift-details', 'billing-details', 'payment-form', 'confirmation'];
    _billingInformation = {};
    _designationList = [];
    _emailTypes = [];
    _phoneTypes = [];
    _addressTypes = [];
    _giftFrequencies = [];
    _giftTypes = [];
    _additionalDetails = [];

    _pageName = 'Contextual Giving Form';
    _emailTemplateDeveloperName = undefined;
    _defaultControllerVersion = 'V2';
    messageContext = createMessageContext();

    get givingFormName() {
        return this._givingFormName;
    }

    get formConfiguration() {
        return this._formConfiguration;
    }

    get currentPage() {
        return this._currentPage;
    }

    get isShowSpinner() {
        return this._isShowSpinner;
    }

    get billingInformation() {
        return this._billingInformation || {};
    }

    get isDisplay() {
        return this._isDisplay;
    }

    get designationList() {
        return this._designationList;
    }

    get emailTypes() {
        return this._emailTypes;
    }

    get phoneTypes() {
        return this._phoneTypes;
    }

    get addressTypes() {
        return this._addressTypes;
    }

    get giftFrequencies() {
        return this._giftFrequencies;
    }

    get giftTypes() {
        return this._giftTypes;
    }

    get minimumStartDate() {
        let tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);

        return this.formatDate(tomorrow);
    }

    get maximumEndDate() {
        return '4000-12-31';
    }

    get minimumRecurringEndDate() {
        let startDate = new Date(this.billingInformation.startDate + 'T00:00:00');
        if (!this.billingInformation.startDate) {
            startDate = new Date();
            startDate.setDate(startDate.getDate() + 1);
        }

        switch (this.billingInformation.frequency) {
            case 'Annual':
                startDate.setFullYear(startDate.getFullYear() + 1);
                break;
            case 'Semi-Annual':
                startDate.setMonth(startDate.getMonth() + 6);
                break;
            case 'Quarterly':
                startDate.setMonth(startDate.getMonth() + 3);
                break;
            case 'Monthly':
                startDate.setMonth(startDate.getMonth() + 1);
                break;
            case 'Bi-Weekly':
                startDate.setDate(startDate.getDate() + 14);
                break;
            case 'Weekly':
                startDate.setDate(startDate.getDate() + 7);
                break;
            default:
                // Error case treated as Annual
                startDate.setFullYear(startDate.getFullYear() + 1);
                break;
        }

        return this.formatDate(startDate);
    }

    formatDate(date) {
        let year = date.getFullYear().toString();
        let month = (date.getMonth() + 1).toString().padStart(2, '0');
        let dayOfMonth = date.getDate().toString().padStart(2, '0');
        
        return `${year}-${month}-${dayOfMonth}`;
    }

    get designationName() {        
        for (let eachDesignation of this.designationList) {
            if (this.billingInformation.designation === eachDesignation.value) {
                return eachDesignation.label;
            }
        }

        return '';
    }

    get additionalMetadata() {
        let numberOfInstallments = 0;
        if (this.billingInformation.giftType === 'pledge') {
            numberOfInstallments = this.billingInformation.numberOfInstallments;
        }
        let frequency = this.billingInformation.giftType === 'outright' ? '' : this.billingInformation.frequency;

        const params = {
            params: {
                giftType: this.billingInformation.giftType,
                startDate: this.billingInformation.startDate,
                endDate: this.billingInformation.endDate,
                amount: this.billingInformation.giftAmount.toString(),
                billingInformation: this.billingInformation,
                designations: this.getRtv2DesignationList(),
                paymentMethod: this.formConfiguration.paymentProcessor,
                pageSectionName : this._pageName,
                appealCode: this.formConfiguration.appeal,
                controllerVersion: this._defaultControllerVersion,
                frequency: frequency,
                numberOfInstallments: numberOfInstallments,
                emailTemplateName : this._emailTemplateDeveloperName
            }
        }

        return params;
    }

    get paymentBillingInformation() {
        return {
            name: this.billingInformation.firstName + ' ' + this.billingInformation.lastName,
            email: this.billingInformation.emailAddress,
            address: {
                line1: this.billingInformation.addressLine1,
                line2: this.billingInformation.addressLine2,
                city: this.billingInformation.addressCity,
                state: this.billingInformation.addressState,
                postal_code: this.billingInformation.addressPostalCode,
                country: this.billingInformation.addressCountry
            }
        };
    }

    get currentPageTitle() {
        switch(this.currentPage) {
            case 'gift-details': return this.formConfiguration?.giftDetailsLabel || 'Gift Details';
            case 'billing-details': return this.formConfiguration?.billingDetailsLabel || 'Billing Details';
            case 'payment-form': return this.formConfiguration?.paymentFormLabel || 'Payment Form';
            case 'confirmation': return this.formConfiguration?.confirmationLabel || 'Confirmation';
        }
    }

    get startDateStyle() {
        if (this.billingInformation.giftType === 'recurring' && !this.formConfiguration.isEndDateEnabled) {
            return 'width: 100%;';
        }

        return 'width: 48%;';
    }

    set formConfiguration(formConfiguration) {
        this._formConfiguration = formConfiguration;
        this._lightningElement.componentAttributes.formConfiguration = formConfiguration;
    }

    set currentPage(currentPage) {
        this._currentPage = currentPage;
        this._lightningElement.componentAttributes.currentPage = currentPage;
    }

    set isShowSpinner(isShowSpinner) {
        this._isShowSpinner = isShowSpinner;
        this._lightningElement.componentAttributes.isShowSpinner = isShowSpinner;
    }

    set billingInformation(billingInformation) {
        this._billingInformation = billingInformation;
        this._lightningElement.componentAttributes.billingInformation = billingInformation;
    }

    set isDisplay(isDisplay) {
        this._isDisplay = isDisplay;
        this._lightningElement.componentAttributes.isDisplay = isDisplay;
    }

    set designationList(designationList) {
        this._designationList = designationList;
        this._lightningElement.componentAttributes.designationList = designationList;
    }

    set phoneTypes(phoneTypes) {
        this._phoneTypes = phoneTypes;
        this._lightningElement.componentAttributes.phoneTypes = phoneTypes;
    }

    set emailTypes(emailTypes) {
        this._emailTypes = emailTypes;
        this._lightningElement.componentAttributes.emailTypes = emailTypes;
    }

    set addressTypes(addressTypes) {
        this._addressTypes = addressTypes;
        this._lightningElement.componentAttributes.addressTypes = addressTypes;
    }

    set giftTypes(giftTypes) {
        this._giftTypes = giftTypes;
        this._lightningElement.componentAttributes.giftTypes = giftTypes;
    }

    set giftFrequencies(giftFrequencies) {
        this._giftFrequencies = giftFrequencies;
        this._lightningElement.componentAttributes.giftFrequencies = giftFrequencies;
    }

    getComponentData() {
        const currentUrlObject = new URL(window.location.href);
        const pathName = currentUrlObject.pathname;

        const urlParams = new URLSearchParams(window.location.search);
        const urlParamValue = urlParams.get(this._lightningElement.urlParamName);

        let params = {
            givingFormName: this.givingFormName,
            pageUrl: pathName,
            urlParamValue: urlParamValue
        }

        this.isShowSpinner = true;
        callApexFunction(this._lightningElement, getContextualGivingFormData, params, (response) => {
            this.setComponentAttributes(response);
        }, () => {}).finally(() => {
            this.isShowSpinner = false;
        });
    }

    setComponentAttributes(response) {
        if (Object.keys(response).length === 0) {
            return;
        }

        this.formConfiguration = response;
        this.billingInformation = {...this.formConfiguration.contactInformation};
        this.billingInformation.giftAmount = this.formConfiguration.defaultAmount ? parseFloat(this.formConfiguration.defaultAmount).toFixed(2) : '';
        this.billingInformation.numberOfInstallments = this.formConfiguration.defaultNumberOfInstallments || 1;
        this.currentPage = this._pageList[0];

        let tempDesignationList = [];
        for (let eachDesignation of this.formConfiguration.designationList) {
            tempDesignationList.push({label: eachDesignation.designationName, value: eachDesignation.designationId});
        }
        this.designationList = tempDesignationList;
        this.billingInformation.designation = this.designationList[0].value;

        this.emailTypes = this.formatPicklistValues(this.formConfiguration?.emailTypes);
        this.addressTypes = this.formatPicklistValues(this.formConfiguration?.addressTypes);
        this.phoneTypes = this.formatPicklistValues(this.formConfiguration?.phoneTypes);        
        this.giftFrequencies = this.formatPicklistValues(this.formConfiguration?.giftFrequencies);
        this.billingInformation.frequency = this.giftFrequencies[0].value;

        this._emailTemplateDeveloperName = this.formConfiguration?.emailTemplateDeveloperName;

        const giftTypesParams = {field: 'Gift_Types__c', sobjectType: 'ucinn_portal_Giving_Form__c'};        
        callApexFunction(this._lightningElement, getPicklists, giftTypesParams, (response) => {
            this.giftTypes = this.getValidGiftTypes(this.formConfiguration?.giftTypes, response.ucinn_portal_Giving_Form__c?.Gift_Types__c);      
            this.billingInformation.giftType = this.giftTypes[0].value;      
            this.isDisplay = true;
        }, (error) => {
            console.log(error);
        });
    }

    getValidGiftTypes(selectedGiftTypesString, giftTypePicklistValues) {
        if (!selectedGiftTypesString || !giftTypePicklistValues) {
            return [];
        }

        let selectedGiftTypes = selectedGiftTypesString.split(';');
        
        return giftTypePicklistValues.filter((eachGiftTypePicklistValue) => selectedGiftTypes.includes(eachGiftTypePicklistValue.value));
    }

    formatPicklistValues(recordListString) {
        if (!recordListString) {
            return [];
        }

        return recordListString.split(';').map(eachType => ({ label: eachType, value: eachType }));
    }

    handleChange(event) {
        let value = event.currentTarget.value;
        const fieldId = event.currentTarget.getAttribute('name');
        if (fieldId === 'giftAmount' && value) {
            value = parseFloat(value).toFixed(2);
            event.currentTarget.value = value;
        }
        
        this.billingInformation[fieldId] = value;

        this.billingInformation = {...this.billingInformation};
    }

    handleNext() {
        if (!this.isCurrentPageDetailsValid()) {
            return;
        }

        const pageIndex = this._pageList.indexOf(this.currentPage);
        if (pageIndex + 1 < this._pageList.length) {
            this.currentPage = this._pageList[pageIndex + 1];
        }
    }

    isCurrentPageDetailsValid() {
        if (this.currentPage === 'gift-details' && this.getGiftDetailsErrors().length > 0) {
            this._lightningElement.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: 'Please review your gift details: ' + this.getGiftDetailsErrors().join(', '),
                variant: 'error',
                mode: 'sticky'
            }));

            return false;
        }

        if (this.currentPage === 'billing-details' && this.getBillingInformationErrors().length > 0) {
            this._lightningElement.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: 'Please review your information: ' + this.getBillingInformationErrors().join(', '),
                variant: 'error',
                mode: 'sticky'
            }));

            return false;
        }

        return true;
    }

    handleBack() {
        const pageIndex = this._pageList.indexOf(this.currentPage);
        if (pageIndex > 0) {
            this.currentPage = this._pageList[pageIndex - 1];
        }
    }

    handleReset() {
        this.billingInformation.giftAmount = this.formConfiguration.defaultAmount ? parseFloat(this.formConfiguration.defaultAmount).toFixed(2) : '';
        this.billingInformation.designation = this.designationList[0].value;
        this.billingInformation.giftType = this.giftTypes[0].value;
        this.currentPage = this._pageList[0];
    }

    handlePaymentConfirmation(params) {
        if (this.formConfiguration.paymentProcessor == 'Stripe Payment Element') {
            this.handleNext();
            return;
        }

        this.isShowSpinner = true;
        const apexParams = this.createRtv2Params(params);
        callApexFunction(this._lightningElement, save, apexParams, (response) => {
            if (response.isEmailException) {
                const warn = new ShowToastEvent({
                    title: 'Warning!',
                    message: 'Your payment was saved, but we are unable to send a confirmation email',
                    variant:"warning",
                    mode:"sticky"
                });
                this.dispatchEvent(warn);
            }

            this.currentPage = 'confirmation';
        }, (error) => {
            console.log(error);
            let errorMap = JSON.parse(error.body.message);

            // in case of error, reset recaptcha v2
            publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});

            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant: 'error',
                mode: 'sticky'
            });
            this.dispatchEvent(event);
        }).finally(() => {
            this.isShowSpinner = false;
        });
    }

    createRtv2Params(paymentParams) {
        let frequency = this.billingInformation.giftType === 'outright' ? '' : this.billingInformation.frequency;
        let numberOfInstallments = this.billingInformation.giftType == 'recurring' ? 0 : this.billingInformation.numberOfInstallments;

        const params = {
            controllerVersion: this._defaultControllerVersion,
            giftType : this.billingInformation.giftType,
            amount : this._billingInformation.giftAmount,
            billingInformation : this._billingInformation,
            designations : this.getRtv2DesignationList(),
            additionalDetails : this._additionalDetails,
            paymentId: paymentParams.paymentId,
            paymentMethod: this.formConfiguration.paymentProcessor,
            additionalPaymentDataMap: paymentParams.additionalPaymentDataMap,
            pageSectionName : this._pageName,
            appealCode: this.formConfiguration.appeal,
            numberOfInstallments : numberOfInstallments,
            startDate : this.billingInformation.startDate,
            endDate : this.billingInformation.endDate,
            frequency : frequency,
            recaptchaToken: paymentParams.recaptchaToken,
            stripeBillingInformation : this.paymentBillingInformation,
            emailTemplateName : this._emailTemplateDeveloperName
            // externalGatewayName: this.externalGatewayName,
            // pledgeId: this._pledgeId,
            // accountId: this._acct,
            // interimSourceUrl: getRelativeUrl()
        }

        return params;
    }

    getRtv2DesignationList() {
        let designationName = '';
        this.formConfiguration.designationList.forEach(eachDesignation => {
            if (eachDesignation.designationId == this._billingInformation.designation) {
                designationName = eachDesignation.designationName;
            }
        });

        return [{Id: this._billingInformation.designation, amount: this._billingInformation.giftAmount, Name: designationName}];
    }

    getGiftDetailsErrors() {
        let giftDetailsErrors = [];
        if (!this.billingInformation.designation) {
            giftDetailsErrors.push('Designation');
        }

        if (this.billingInformation.giftAmount <= 0) {
            giftDetailsErrors.push('Gift Amount');
        }

        if (!this.billingInformation.giftType) {
            giftDetailsErrors.push('Gift Type');
        }

        if (this.billingInformation.giftType === 'pledge' && (!this.billingInformation.numberOfInstallments || this.billingInformation.numberOfInstallments <= 1)) {
            giftDetailsErrors.push('Number of Installments');
        }

        if ((this.billingInformation.giftType === 'pledge' || this.billingInformation.giftType === 'recurring') && !this.billingInformation.frequency) {
            giftDetailsErrors.push('Gift Frequency');
        }

        if ((this.billingInformation.giftType === 'pledge' || this.billingInformation.giftType === 'recurring') 
                && (!this.billingInformation.startDate 
                        || (this._lightningElement.template.querySelector('input[name="startDate"]') && !this._lightningElement.template.querySelector('input[name="startDate"]').checkValidity()))) {
            giftDetailsErrors.push('Start Date');
        }

        if (this.billingInformation.giftType === 'recurring'
                && this.formConfiguration.isEndDateEnabled
                && this.billingInformation.endDate 
                && (new Date(this.billingInformation.startDate).getTime() > new Date(this.billingInformation.endDate).getTime())) {
            giftDetailsErrors.push('End Date must be after Start Date');
        }

        if (this.billingInformation.giftType === 'recurring'
                && this.formConfiguration.isEndDateEnabled
                && this._lightningElement.template.querySelector('input[name="endDate"]')
                && !this._lightningElement.template.querySelector('input[name="endDate"]').checkValidity()) {
            giftDetailsErrors.push('Invalid End Date');
        }
        
        return giftDetailsErrors;
    }

    getBillingInformationErrors() {
        let validEmailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        let billingInformationErrors = [];

        if (!this.billingInformation.firstName) {
            billingInformationErrors.push('First Name');
        }
        
        if (!this.billingInformation.lastName) {
            billingInformationErrors.push('Last Name');
        }
        
        if (!this.billingInformation.emailAddress || !this.billingInformation.emailAddress.match(validEmailPattern)) {
            billingInformationErrors.push('Email Address');
        }
        
        if (!this.billingInformation.emailType) {
            billingInformationErrors.push('Email Type');
        }
        
        if (!this.billingInformation.phoneNumber) {
            billingInformationErrors.push('Phone Number');
        }
        
        if (!this.billingInformation.phoneType) {
            billingInformationErrors.push('Phone Type');
        }
        
        if (!this.billingInformation.addressLine1) {
            billingInformationErrors.push('Street Address Line 1');
        }
        
        if (!this.billingInformation.addressCity) {
            billingInformationErrors.push('City');
        }
        
        if (!this.billingInformation.addressState) {
            billingInformationErrors.push('State');
        }
        
        if (!this.billingInformation.addressPostalCode) {
            billingInformationErrors.push('Postal Code');
        }
        
        if (!this.billingInformation.addressCountry) {
            billingInformationErrors.push('Country');
        }
        
        if (!this.billingInformation.addressType) {
            billingInformationErrors.push('Address Type');
        }

        return billingInformationErrors;
    }
}