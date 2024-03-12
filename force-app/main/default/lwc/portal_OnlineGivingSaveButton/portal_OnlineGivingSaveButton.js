import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import recaptchaChannel from '@salesforce/messageChannel/recaptchaChannel__c';
import save from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_createReviewTransaction';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRelativeUrl } from 'c/portal_util_Urls';

export default class Portal_OnlineGivingSaveButton extends LightningElement {
    @api componentLabel;
    @api paymentMethod;
    @api baseButtonColor;
    @api textColor;
    @api pageListString;
    @api pageSectionName;
    @api externalGatewayName;
    @api emailTemplateName;
    @wire(MessageContext) messageContext;

    _currentPage = 1;
    _designationList = [];
    _billingInformation = {};
    _dtdBillingInformation = {};
    _stripeBillingInformation = {};
    _giftType = '';
    _numberOfInstallments = 0;
    _additionalDetails = [];
    _giftAmount = 0;
    _pledgeStartDate;
    _isPledgeStartDateValid;
    _pledgeFrequency;
    _recurringFrequency;
    _recurringStartDate;
    _recurringEndDate;
    _isRecurringDatesValid;
    _colorSet = false;
    _subscription = null;
    _buttonSize = 12;
    _pageList = ['giving', 'additional', 'billing', 'credit'];
    _companyName = '';
    _companyId = '';
    _matchingCompanyIntegration = '';
    _isInstallmentsValid = false;
    _designationsAreValid = false;
    _amountIsValid = true;
    _pledgeId;
    _appeal = '';
    _isShowSpinner = false;
    _acct;
    _paymentMethod;
    _additionalPaymentDataMap;
    _currentlySaving = false;
    _givingAsOrg = false;
    _isPledgePayment = false;
    _isValidPledge = false;
    _recaptchaToken;
    _paymentId;
    _isCreatePledgeSubscription = undefined;
    _hasAddressAutocomplete = false;

    get containerClass() {
        if (this._currentPage == 1) {
            return 'container large';
        }

        if(this._currentPage == 2) {
            return 'container small';
        }

        return '';
    }

    connectedCallback() {
        if (this.pageListString) {
            this._pageList = this.pageListString.split(',');
        }
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        if (vars['appeal']) {
            this._appeal = vars['appeal'].replaceAll('+', ' ');
        }
        this._paymentMethod = this.paymentMethod;
        this.subscribeToMessageChannel();
    }

    handleSave(paymentId) {
        if (this._currentlySaving) {
            return;
        }
        this._currentlySaving = true;
        this._isShowSpinner = true;
        this._paymentId = paymentId;
        const params = this.createRtv2Params();
        save(params).then(response => {
            if (response.isEmailException) {
                const warn = new ShowToastEvent({
                    title: 'Warning!',
                    message: 'Your payment was saved, but we are unable to send a confirmation email',
                    variant:"warning",
                    mode:"sticky"
                });
                this.dispatchEvent(warn);
            }
            publish(this.messageContext, onlineGivingChannel, {detail:response, type:"saved"});

        }).catch(error => {
            console.log(error);
            let errorMap = JSON.parse(error.body.message);

            // in case of error, reset recaptcha v2
            publish(this.messageContext, recaptchaChannel, {type: "recaptcha-v2-reset"});

            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this._currentlySaving = false; //don't put this in finally since we only want to reenable button on an error
        }).finally(() => {
            this._isShowSpinner = false;
        })
    }

    createRtv2Params() {
        let startDate = null;
        let endDate = null;
        let frequency = "";
        let numberOfInstallments = this._numberOfInstallments;
        if (this._recurringStartDate && this._giftType == 'recurring') {
            startDate = this._recurringStartDate;
            // endDate is optional for recurring gifts
            endDate = this._recurringEndDate;
            frequency = this._recurringFrequency;
            numberOfInstallments = 0;
        } else if (this._pledgeStartDate && this._giftType == 'pledge') {
            startDate = this._pledgeStartDate;
            frequency = this._pledgeFrequency;
        }

        const params = {
           params : {
                giftType : this._giftType,
                numberOfInstallments : numberOfInstallments,
                startDate : startDate,
                endDate : endDate,
                frequency : frequency,
                tributeInformation : this._tribute,
                amount : this._giftAmount,
                isGivingAsOrg: this._givingAsOrg,
                billingInformation : this._billingInformation,
                designations : this._designationList,
                additionalDetails : this._additionalDetails,
                matchingCompanyName : this._companyName,
                matchingCompanyId : this._companyId,
                matchingCompanyIntegration: this._matchingCompanyIntegration,
                paymentId:  this._paymentId,
                dtdBillingInformation: this._dtdBillingInformation,
                stripeBillingInformation : this._stripeBillingInformation,
                pageSectionName : this.pageSectionName,
                externalGatewayName: this.externalGatewayName,
                pledgeId: this._pledgeId,
                emailTemplateName: this.emailTemplateName,
                paymentMethod: this._paymentMethod,
                appealCode: this._appeal,
                accountId: this._acct,
                additionalPaymentDataMap: this._additionalPaymentDataMap,
                recaptchaToken: this._recaptchaToken,
                isCreatePledgeSubscription: this._isCreatePledgeSubscription,
                hasAddressAutocomplete: this._hasAddressAutocomplete,
                interimSourceUrl: getRelativeUrl()
           }
        }
        return params;
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }


    renderedCallback() {
        this.setColor();
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                onlineGivingChannel,
                (message) => this.handleMessage(message)
            );
        }
    }

    handleMessage = (message) => {
        if (message.type == 'data-change') {
            this._isInstallmentsValid = message.detail['isInstallmentsValid'];
            this._designationsAreValid = message.detail['designationsAreValid'];
            this._amountIsValid = message.detail['amountIsValid'];

            if (message.detail['amount'] && parseFloat(message.detail['amount']).toFixed(2) > 0) {
                this._giftAmount = parseFloat(message.detail['amount']).toFixed(2);
            }

            this._designationList = message.detail['designationList'];

            this._giftType = message.detail['giftType'];
            this._numberOfInstallments = parseInt(message.detail['numberOfInstallments']);
            this._pledgeStartDate = message.detail['pledgeStartDate'];
            this._isPledgeStartDateValid = message.detail['isPledgeStartDateValid'];
            this._pledgeFrequency = message.detail['pledgeFrequency'];
            this._recurringStartDate = message.detail['recurringStartDate'];
            this._recurringEndDate = message.detail['recurringEndDate'];
            this._recurringFrequency = message.detail['recurringFrequency'];
            this._isRecurringDatesValid = message.detail['isRecurringDatesValid'];
            this._givingAsOrg = message.detail['givingAsOrg'];
            this._isPledgePayment = message.detail['isPledgePayment'];
            this._isValidPledge = message.detail['isValidPledge'];
            this._billingInformation = message.detail['billingInformation'];
            this._additionalDetails = message.detail['additionalDetails'];
            this._tribute = message.detail['tribute'];
            this._companyName = message.detail['matchingCompanyName'];
            this._companyId = message.detail['matchingCompanyId'];
            this._matchingCompanyIntegration = message.detail['matchingCompanyIntegration'];
            this._dtdBillingInformation = message.detail['dtdBillingInformation'];
            this._stripeBillingInformation = message.detail['stripeBillingInformation'];
            this._pledgeId = message.detail['pledgeId'];
            this._acct = message.detail['acct'];
            this._additionalPaymentDataMap = message.detail['additionalPaymentDataMap'];
            this._recaptchaToken = message.detail['recaptchaToken'];
            this._isCreatePledgeSubscription = message.detail['isCreatePledgeSubscription'];

            if (message.detail['type'] == 'save') {
                this.handleSave(message.detail['paymentId']);
            } else if (message.detail['type'] == 'previous') {
                this.goToPreviousPage();
            }
        } else if (message.type == 'validationResults') {
            this.billingDetailsHandleNext(message.detail);
        } else if (message.type == 'additionalMetadataRetrieve') {    
            let params = this.createRtv2Params();
            publish(this.messageContext, onlineGivingChannel, {detail:params, type:"additionalMetadata" });
        } else if (message.type == 'hasAddressAutocomplete') {    
            this._hasAddressAutocomplete = message.detail;
        }

    }

    billingDetailsHandleNext(billingDetailsIsValid) {
        if (billingDetailsIsValid) {
            this._buttonSize = 6;
            if (this._currentPage == this._pageList.length-1) {
                this._buttonSize = 12;
            }
            this._currentPage++;
            let pageValue = this._pageList[this._currentPage-1];
            publish(this.messageContext, onlineGivingChannel, {detail:pageValue, type:"pageChange"});
        } else {
            this.displayError();
        }
    }

    setColor() {
        if (this.template.querySelectorAll('.button') && this.template.querySelectorAll('.button').length > 0) {
            this.template.querySelectorAll('.button').forEach(element => {
                    element.style.setProperty('background-color', this.baseButtonColor);
                    element.style.setProperty('border-color', this.textColor);
                    element.style.setProperty('color', this.textColor);
            });
            return true;
        }
        return false;
    }

    get showNext() {
        return this._currentPage != this._pageList.length;
    }

    get showPrev() {
        return this._currentPage > 1 && this._currentPage != this._pageList.length;
    }

    handlePrevious(event) {
        this.goToPreviousPage();
    }

    goToPreviousPage() {
        this._currentPage--;
        if (this._currentPage == 1) {
            this._buttonSize = 12;
        } else {
            this._buttonSize = 6;
        }
        let pageValue = this._pageList[this._currentPage-1];
        publish(this.messageContext, onlineGivingChannel, {detail:pageValue, type:"pageChange"});
    }

    displayError = (errorMessage) => {
        publish(this.messageContext, onlineGivingChannel, {type:"display-field-errors"});

        let currentPage = this._pageList[this._currentPage - 1];
        if (currentPage != 'billing') {
            let event = new ShowToastEvent({
                title: 'Error!',
                message: errorMessage,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }
    }

    handleNext = (event) => {
        if (this._currentPage == 1) {
            const pledgeErrorMessage = this.invalidPledgeErrorMessage();
            const recurringGiftErrorMessage = this.invalidRecurringGiftErrorMessage();

            if (this._isPledgePayment && !this._isValidPledge) {
                this.displayError('Please enter a valid Pledge Id or select a different payment option.');
                return;
            } else if (this._giftType == 'pledge' && pledgeErrorMessage) {
                this.displayError(pledgeErrorMessage);
                return;
            } else if (this._giftType == 'recurring' && recurringGiftErrorMessage) {
                this.displayError(recurringGiftErrorMessage);
                return;
            } else if (this._designationList.length <= 0) {
                this.displayError('Please select a designation.');
                return;
            } else if (!this._designationsAreValid) {
                this.displayError('Please ensure designation information is populated, amounts are above their minimum, and are valid increments.');
                return;
            } else if (this._giftAmount <= 0) {
                this.displayError('Please complete the gift amount.');
                return;
            } else if (!this._amountIsValid) {
                this.displayError('Please ensure the amount is valid.');
                return;
            }
        } else if (this._pageList[this._currentPage-1] == 'billing') {
            publish(this.messageContext, onlineGivingChannel, {type:"startBillingDetailsCheckValidity"});
            return;
        }

        this._buttonSize = 6;
        if (this._currentPage == this._pageList.length-1) {
            this._buttonSize = 12;
        }

        this._currentPage++;
        let pageValue = this._pageList[this._currentPage-1];
        publish(this.messageContext, onlineGivingChannel, {detail:pageValue, type:"pageChange"});
    }

    invalidPledgeErrorMessage() {
        if (!this._isInstallmentsValid) {
            return 'Please select a valid number of installlments.'
        } else if (!this._pledgeFrequency) {
            return 'Please select a frequency.';
        } else if (!this._isPledgeStartDateValid) {
            return 'Please select a valid starting date.';
        }

        return '';
    }

    invalidRecurringGiftErrorMessage() {
        if (!this._recurringFrequency) {
            return 'Please select a frequency.';
        } else if (!this._isRecurringDatesValid && !this._recurringEndDate) {
            return 'Please select a valid starting date.';
        } else if (!this._isRecurringDatesValid && this._recurringEndDate) {
            return 'Please select a valid starting and ending date.';
        } else if (this._recurringEndDate && this._recurringStartDate >= this._recurringEndDate) {
            return 'Please ensure the start date is before the end date.';
        }

        return '';
    }
}