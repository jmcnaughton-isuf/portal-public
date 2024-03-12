import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';

import initializeMembershipPurchase from '@salesforce/apex/PORTAL_LWC_MembershipPurchaseController.SERVER_initializeMembershipPurchase';
import getMembershipFieldsToPrepopulate from '@salesforce/apex/PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipFieldsToPrepopulate';
import createReviewTransaction from '@salesforce/apex/PORTAL_LWC_MembershipPurchaseController.SERVER_createReviewTransaction';
import getMembershipBenefitInformation from '@salesforce/apex/PORTAL_LWC_MembershipPurchaseController.SERVER_getMembershipBenefitInformation';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { publish, MessageContext } from 'lightning/messageService';
import recaptchaChannel from '@salesforce/messageChannel/recaptchaChannel__c';

export default class Portal_MembershipPurchaseForm extends LightningElement {
    @api pageName = 'Membership Purchase';
    @api mainSectionName = 'Membership Purchase';
    @api paymentMethod = 'Stripe';
    @api apiKeyCMDDeveloperName;
    @api secretKeyCMDDeveloperName;
    @api externalGatewayName;

    @track _isRecaptchaEnabled = true;
    @track _subSectionList = [];
    @track _subSectionIdToFieldMap = {};
    @track _subSectionName = '';
    @track _subSectionLabel = '';
    @track _currentMembershipOption = '';
    @track _fieldList = [];
    @track _dataMap = {};
    @track _userContact = {};
    @track _isShowMembershipPurchase = true;
    @track _isShowSpinner = true;
    @track _currentStep = 'step-1';
    @track _currentStepIndex = 0;
    @track _isRenewal = false;
    @track _membershipDescription;
    @track _currentlySaving = false;
    @track _isDisableNextClick = false;
    @track _membershipBenefits = [];
    @track _membershipBenefitsFrontEndDataMap = {};
    @track _membershipBenefitsColumnDataList = [];
    @track _membershipLevelId = '';
    @track _membershipInformation = {};

    @track steps = [
        { label: 'Membership Type', value: 'step-1', key: 1 },
        { label: 'Membership Information', value: 'step-2', key: 2 },
        { label: 'Payment Information', value: 'step-3', key: 3 },
        { label: 'Confirmation', value: 'step-4', key: 4 }
    ];

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_MembershipControllerBase.createReviewTransaction'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    @wire(MessageContext) messageContext;

    set currentMembershipOption(value) {
        if (this._currentMembershipOption == value) {
            return;
        }

        this._currentMembershipOption = value;

        this._subSectionList.forEach(subSection => {
            if (subSection.id === value) {
                this._subSectionName = subSection.subSectionName;
                this._subSectionLabel = subSection.label;
                this._membershipDescription = subSection.sectionDescription;
            }
        })

        let fieldList = this._subSectionIdToFieldMap[this._currentMembershipOption];

        if (!fieldList) {
            this._fieldList = [];
            return;
        }

        fieldList.sort((a, b) => {
            let aNumber = a.orderNumber;
            let bNumber = b.orderNumber;

            if (!aNumber) {
                aNumber = 0;
            }

            if (!bNumber) {
                bNumber = 0;
            }

            return aNumber - bNumber;
        });

        this._fieldList = fieldList;

        this.clearCurrentValues();
        this.handleValueChange('recipient', this._userContact.name);
        this.handleValueChange('recipientId', this._userContact.Id);
    }

    get paymentOrigin() {
        if (this.paymentMethod === "TouchNet") {
            return 'membershipsTicketName';
        } else {
            return 'membershipPaymentElement'
        }
    }

    get isShowCreditCardComponent() {
        return !this._isShowMembershipPurchase;
    }

    get recordId() {
        let searchParams = new URLSearchParams(window.location.search);

        return searchParams.get('recordId');
    }

    get initializeMembershipPurchaseParams() {
        return {
            pageName: this.pageName, 
            mainSectionName: this.mainSectionName,
            membershipRecordId: this.recordId, 
            paymentMethod: this.paymentMethod
        };
    }

    get membershipSelectionClass() {
        if (!this._isShowMembershipPurchase) {
            return 'slds-hide';
        }

        return '';
    }

    get membershipOptions() {
        if (!this._subSectionList) {
            return [];
        }

        let membershipOptions = [];

        this._subSectionList.forEach(subSection => {
            let membershipOption = {label: subSection.label, 'value': subSection.id};
            if (this._currentMembershipOption === subSection.id) {
                membershipOption.checked = true;
            }
            membershipOptions.push(membershipOption);
        });

        return membershipOptions;
    }

    get amountToPay() {
        if (this._fieldList) {
            for (const fieldMap of this._fieldList) {
                if (fieldMap.id === 'membershipPrice') {
                    return parseFloat(fieldMap.value?.substring(1));
                }
            }
        }

        return 0;
    }

    get nonGiftAmount() {
        let nonGiftAmount = 0;
        if (this._membershipBenefits) {
            this._membershipBenefits.forEach(benefit => {
                if (isNaN(benefit?.benefitAmount)) {
                    return;
                }
                
                nonGiftAmount = nonGiftAmount + parseFloat(benefit?.benefitAmount);
            })
        }

        return nonGiftAmount;
    }

    get giftAmount() {
        return this.amountToPay - this.nonGiftAmount;
    }

    get rtv2BillingInformation() {
        if (this._fieldList) {
            for (const fieldMap of this._fieldList) {
                if (fieldMap.id === 'recipient') {
                    return {name: fieldMap.value};
                }
            }
        }

        return {};
    }

    get paymentBillingInformation() {
        if (this.paymentMethod !== 'TouchNet') {
            return this.rtv2BillingInformation;
        } 
 
        let emailInformation = this._userContact.emailInformation?.[0] || {};
        let addressInformation = this._userContact.addressInformation?.[0] || {};
        let nameInformation = this._userContact.nameInformation?.[0] || {};

        let firstName = nameInformation.firstName || '';
        let middleName = nameInformation.middleName || '';
        let lastName = nameInformation.lastName || '';
        let suffix = nameInformation.suffix || '';
        middleName = (middleName ? ' ' : '') + middleName;
        lastName = (lastName ? ' ' : '') + lastName;
        suffix = (suffix ? ' ' : '') + suffix;

        return {
            name: firstName + middleName + lastName + suffix,
            email: emailInformation.email,
            address: {
                line1: addressInformation.line1,
                line2: addressInformation.line2,
                city: addressInformation.city,
                state: addressInformation.state,
                postal_code: addressInformation.postalCode,
                country: addressInformation.country
            }
        };
    }

    get paymentType() {
        if (this._currentMembershipOption === 'autoRecurringSection'
                || this._currentMembershipOption === 'installmentBasedSection') {
            return 'subscription';
        }

        return 'outright';
    }

    get isShowMembershipOptions() {
        return !this._currentStep || this._currentStep === 'step-1';
    }

    get isShowMembershipInfo() {
        return this._currentStep === 'step-2';
    }

    get isShowPaymentInfo() {
        return this._currentStep === 'step-3';
    }

    get isShowConfirmation() {
        return this._currentStep === 'step-4';
    }

    get isShowMembershipBenefits() {
        return this._membershipBenefits?.length > 0 && Object.keys(this._membershipBenefitsFrontEndDataMap)?.length > 0;
    }

    get conciseColumnData() {
        let resultColumns = [];

        for (const eachColumn of this._membershipBenefitsColumnDataList) {
            let summaryCol = {};
            summaryCol.label = eachColumn.label;
            summaryCol.fieldId = eachColumn.fieldId;
            summaryCol.fieldType = eachColumn.fieldType;
            resultColumns.push(summaryCol);
        }

        return resultColumns;
    }

    get membershipBenefitTableName() {
        return (Object.keys(this._membershipBenefitsFrontEndDataMap)?.length > 0 ? this._membershipBenefitsFrontEndDataMap.membershipBenefits.label : 'Membership Benefits');
    }

    get additionalMetadata() {
        if (this.paymentMethod === 'Stripe Payment Element') {
            return {params: this.generateReviewTransactionParams()};
        }
    }

    getValue(fieldId) {
        for (const fieldMap of this._fieldList) {
            if (fieldMap.id === fieldId) {
                return fieldMap.value;
            }
        }

        return null;
    }

    @wire(initializeMembershipPurchase, {params: '$initializeMembershipPurchaseParams'})
    doInit({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        let frontEndDataMap = data.frontEndDataMap;
        this._userContact = data.contact || {};
        let membershipFields = data.membershipFields;
        let sectionId = data.sectionId;

        for (const key in frontEndDataMap) {
            if (key != null) {
                let dataMap = Object.assign({}, frontEndDataMap[key]);
                if (!frontEndDataMap[key].mainSection) {
                    dataMap.id = key;
                    this._subSectionList.push(dataMap);

                    for (const subKey in dataMap.fieldMap) {
                        if (subKey != null) {
                            let fieldMap = Object.assign({}, dataMap.fieldMap[subKey]);

                            fieldMap.id = subKey;

                            if (this._subSectionIdToFieldMap[fieldMap.sectionId]) {
                                this._subSectionIdToFieldMap[fieldMap.sectionId].push(fieldMap);
                            } else{
                                this._subSectionIdToFieldMap[fieldMap.sectionId] = [fieldMap];
                            }

                            if (fieldMap.id === 'frequency') {
                                fieldMap.picklistValues = [{label: 'Please Select a Value', value: ''},
                                                           {label: 'Annual', value: 'Annual'},
                                                           {label: 'Semi-Annual', value: 'Semi-Annual'},
                                                           {label: 'Quarterly', value: 'Quarterly'},
                                                           {label: 'Bi-Monthly', value: 'Bi-Monthly'},
                                                           {label: 'Monthly', value: 'Monthly'},
                                                           {label: 'Bi-Weekly', value: 'Bi-Weeky'},
                                                           {label: 'Weekly', value: 'Weekly'}];
                            }
                        }
                    }
                }
            }
        }

        if (sectionId) {
            this.currentMembershipOption = sectionId;
        }

        if (membershipFields) {
            this._currentStep = 'step-2';
            this._currentStepIndex = 1;
            this._isRenewal = true;

            for (let eachField of this._fieldList) {
                eachField.disable = true;
                eachField.key = Date.now();
            }

            for (const key in membershipFields) {
                if (membershipFields[key]) {
                    this.handleValueChange(key, membershipFields[key]);
                }
            }
        }

        this._isShowSpinner = false;
    }

    handleMembershipOptionChange = (event) => {
        this.currentMembershipOption = event.target.dataset.id;
    }

    handleValueChange = (fieldId, value) => {
        if (fieldId === 'membershipName' && this._dataMap[fieldId] !== value && value != null) {
            this._membershipLevelId = value;
            this._isShowSpinner = true;
            this.prepopulateFieldsForMembership(value);
            this.handleBenefitInformationForMembership(value);
        }

        if (fieldId === 'membershipPrice'
                && this._currentMembershipOption === 'installmentBasedSection'
                && this._dataMap[fieldId] !== value) {
            this.prepopulateInstallmentAmount(value, this.getValue('numberOfInstallments'));
        } else if (fieldId === 'numberOfInstallments'
                && this._currentMembershipOption === 'installmentBasedSection'
                && this._dataMap[fieldId] !== value) {
            this.prepopulateInstallmentAmount(this.getValue('membershipPrice'), value);
        }

        this._dataMap[fieldId] = value;

        this._fieldList.forEach(fieldMap => {
            if (fieldMap.id === fieldId && fieldMap.value !== value) {
                fieldMap.value = value;
            }
        })
    }

    isShowPaymentForm() {
        for (const fieldMap of this._fieldList) {
            if (fieldMap.isRequired && !fieldMap.value) {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Please complete out all required fields before continuing.',
                    variant:"error",
                    mode:"sticky"
                });

                this.dispatchEvent(event);
                return false;
            }
        }
        this._isShowMembershipPurchase = false;
        return true;
    }

    clearCurrentValues() {
        this._fieldList.forEach(fieldMap => {
            fieldMap.value = null;
        });

        this._membershipBenefits = [];
        this._membershipBenefitsFrontEndDataMap = {};
        this._membershipBenefitsColumnDataList = [];

        this._dataMap = {};
    }

    prepopulateInstallmentAmount(membershipPrice, numberOfInstallments) {
        let installmentPrice = '$';

        if (!membershipPrice || !numberOfInstallments) {
            installmentPrice = '';
            this.handleValueChange('installmentAmount', installmentPrice);
            return;
        }

        this.handleValueChange('installmentAmount', installmentPrice + (membershipPrice.substring(1)/parseFloat(numberOfInstallments)).toFixed(2));
    }

    prepopulateFieldsForMembership(value) {
        if (typeof value === 'object') {
            value = value.value;
        }

        getMembershipFieldsToPrepopulate({params: {
                                          pageName: this.pageName,
                                          mainSectionName: this.mainSectionName,
                                          subSectionName: this._subSectionName,
                                          membershipLevelId: value
        }}).then(result => {
            for (const key in result) {
                if (result[key]) {
                    if (key !== 'membershipName' && key !== 'membershipPaymentOptions' && key !== 'Id') {
                        this.handleValueChange(key, result[key]);
                    }
                }
            }

            this.handleShowProductWarningMessage(result);
            this._membershipInformation = result;
        }).catch (error => {
            console.log(error);
            let errorMap = JSON.parse(error.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        })
    }

    handleBenefitInformationForMembership(value) {
        if (!value) {
            this._membershipBenefitsFrontEndDataMap = {};
            this._membershipBenefits = [];
            this._isShowSpinner = false;
            return;
        }

        if (typeof value === 'object') {
            value = value.value;
        }

        let params = {membershipLevelId: value};

        return callApexFunction(this, getMembershipBenefitInformation, params, (result) => {
            this._membershipBenefitsFrontEndDataMap = result?.frontEndDataMap;
            this._membershipBenefits = result?.membershipBenefitRecords;
            this.createTableColumns(this._membershipBenefitsFrontEndDataMap);
            this._isShowSpinner = false;
        }, () => {
            this._isShowSpinner = false;
        });
    }

    handlePaymentConfirmation = (params) =>  {
        if (this._currentlySaving) {
            return;
        }
        this._currentlySaving = true;

        if (this.paymentMethod === "Stripe Payment Element") {
            this.handleNextClick();
            return;
        }

        this._isShowSpinner = true;
        let paymentId = params.paymentId;
        let additionalPaymentDataMap = params.additionalPaymentDataMap;
        
        createReviewTransaction({params: this.generateReviewTransactionParams(paymentId, additionalPaymentDataMap, params.recaptchaToken)}).then(result => {
            this.handleNextClick();
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
        });
    }

    handlePreviousClick = () => {
        this._currentStepIndex = this._currentStepIndex - 1;
        this._currentStep = this.steps[this._currentStepIndex].value;
    }

    handleNextClick = () => {
        if (this._currentStep == 'step-2' && !this.isShowPaymentForm()) {
            return;
        } else if (this._currentMembershipOption == '') {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Please select a membership type to continue.',
                variant:"error",
                mode:"sticky"
            });

            this.dispatchEvent(event);
            return;
        }

        this._currentStepIndex = this._currentStepIndex + 1;
        this._currentStep = this.steps[this._currentStepIndex].value;
    }

    handleShowProductWarningMessage(membershipProductRecord) {
        if (!membershipProductRecord || !membershipProductRecord.hasExistingMembershipMatchingMembershipType || this.recordId) {
            this._isDisableNextClick = false;
            return;
        }

        this._isDisableNextClick = true;
        const event = new ShowToastEvent({
            title: 'Warning.',
            message: 'You have an existing membership with the same name. Please select a different membership.',
            variant:"error",
            mode:"sticky"
        });
        this.dispatchEvent(event);
    }

    generateReviewTransactionParams(paymentId, additionalPaymentDataMap, recaptchaToken) {
        this._dataMap.amount = this.amountToPay.toString(10);
        if (this._currentMembershipOption === 'oneTimeSection') {
            this._dataMap.giftType = 'One-Time Membership';
        } else if (this._currentMembershipOption === 'autoRecurringSection') {
            this._dataMap.giftType = 'Auto Renewing Membership';
            this._dataMap.numberOfInstallments = '100'
        } else if (this._currentMembershipOption === 'installmentBasedSection') {
            this._dataMap.giftType = 'Installment Based Membership';
            this._dataMap.amount = this.getValue('membershipPrice').substring(1);
            this._dataMap.paymentAmount = this.getValue('installmentAmount').substring(1);
        }
        this._dataMap.additionalPaymentDataMap = additionalPaymentDataMap;
        this._dataMap.paymentId = paymentId;
        this._dataMap.paymentMethod = this.paymentMethod;
        this._dataMap.stripeBillingInformation = this.rtv2BillingInformation;
        this._dataMap.billingInformation = this.rtv2BillingInformation;
        this._dataMap.externalGatewayName = this.externalGatewayName;
        this._dataMap.recaptchaToken = recaptchaToken;
        this._dataMap.membershipLevelId = this._membershipLevelId;
        return this._dataMap;
    }

    createTableColumns(frontEndDataMap) {
        if (!frontEndDataMap) {
            return;
        }

        let columnTitleList = [];

        for (const key in frontEndDataMap) {
            if (frontEndDataMap[key].mainSection && frontEndDataMap[key].display === true && (!frontEndDataMap[key].isFrontEndFieldOnly)) {
                let frontEndObject = {...frontEndDataMap[key]};
                frontEndObject.key = key;
                frontEndObject.id = frontEndObject.label; 
                columnTitleList.push(frontEndObject);
            }
        }

        columnTitleList.sort((a, b) => (a.orderNumber - b.orderNumber));
        this._membershipBenefitsColumnDataList = columnTitleList;
    }
}