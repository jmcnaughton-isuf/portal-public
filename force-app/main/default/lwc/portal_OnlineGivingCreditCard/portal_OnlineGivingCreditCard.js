import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';

import { callApexFunction } from 'c/portal_util_ApexCallout';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import createDTDDonationAndInterim from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_createDTDDonationAndInterim';

export default class Portal_OnlineGivingCreditCard extends LightningElement {
    @api pageName;
    @api paymentMethod;
    @api apiKeyName;
    @api apiKey;
    @api externalGatewayName;

    @wire(MessageContext) messageContext;

    @track _amount = 0;
    @track _giftType;
    @track _constituentBillingInformation = {};
    @track _organizationBillingInformation = {};
    @track _isRecaptchaEnabled = true;

    _subscription = null;
    _page = 'giving';
    _informationMap;
    _frequency;
    _startDate;
    _endDate;
    _numberOfInstallments = 0;
    _isCreatePledgeSubscription = undefined;
    _firstPledgePaymentAmount = undefined;
    _lastPledgePaymentAmount = undefined;
    _saved = false;
    _apiKey;
    _isGivingAsOrg = false;
    _additionalMetadata;
    _designationList = [];
    metadataRetrieved = false;
        
    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_OnlineGivingControllerBase.SERVER_createReviewTransaction'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }
  
    get isShowComponent() {
        return this._page == this.pageName && !this._saved;
    }    

    get paymentConfirmationHandler() {
        if (this.paymentMethod === "Stripe Payment Element") {
            return this.handleStripePaymentElementConfirmation;
        }

        return this.handlePaymentConfirmation;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    get giftType() {
        switch(this._giftType) {
            case 'recurring':
                return 'Recurring Gift';
                break;
            case 'pledge':
                return 'Multi-Payment';
                break;
            case 'gift':
                return 'One-Time Gift';
                break;
            default:
                return '';
        }
    }

    get isRenderPaymentForm() {        
        if (this.paymentMethod !== "Stripe Payment Element") {
            return this.isShowComponent;
        } else {
            if (this.isShowComponent == true) {
                this.getAdditionalMetadata();
            }
            
            if (this.metadataRetrieved == true) {
                return this.isShowComponent;
            }
        }
    }

    get paymentOrigin() {
        if (this.paymentMethod === "TouchNet") {
            return 'onlineGivingTicketName';
        } else {
            return 'onlineGivingPaymentElement'
        }
    }

    get isShowNumberOfInstallments() {
        return this._numberOfInstallments && this._giftType === 'pledge';
    }

    get isShowLastPledgePaymentAmount() {
        return this._lastPledgePaymentAmount && this._lastPledgePaymentAmount !== this.paymentAmount && this._giftType === 'pledge';
    }

    get paymentAmount() {
        if (this._giftType !== 'pledge' || this._isCreatePledgeSubscription || !this._firstPledgePaymentAmount) {
            return this._amount;
        }

        return this._firstPledgePaymentAmount;
    }

    get isDisplayTotalAmount() {
        return this.paymentAmount !== this._amount;
    }

    get isShowStartDate() {
        return !this.isOneTimeGift && this._startDate;
    }

    get isShowEndDate() {
        return !this.isOneTimeGift && this._endDate;
    }

    get isShowNumberOfInstallments() {
        return this._numberOfInstallments && this._giftType === 'pledge';
    }

    get isOneTimeGift() {
        return this._giftType === 'gift';
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                onlineGivingChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._page = message.detail['page'];
            this.isShowComponent ? '' : this.isShowMoreDetails = false;
            this._isGivingAsOrg = message.detail['givingAsOrg'];
            if (message.detail['amount']) {
                this._amount = parseFloat(message.detail['amount']).toFixed(2);
            }
            if (message.detail['firstPledgePaymentAmount']) {
                this._firstPledgePaymentAmount = parseFloat(message.detail['firstPledgePaymentAmount']).toFixed(2);
            }
            if (message.detail['lastPledgePaymentAmount']) {
                this._lastPledgePaymentAmount = parseFloat(message.detail['lastPledgePaymentAmount']).toFixed(2);
            }
            if (message.detail['designationList']) {
                this._designationList = message.detail['designationList'];
            }
            this._informationMap = message.detail['billingInformation'];
            if (this._informationMap && Object.keys(this._informationMap) && Object.keys(this._informationMap).length > 0) {
                //FUTURE TODO: make it work with other payment methods
                this.populateConstituentBillingInfo();
                this.populateOrganizationBillingInfo();

                publish(this.messageContext, onlineGivingChannel, {detail : this._isGivingAsOrg ? this._organizationBillingInformation : this._constituentBillingInformation, type:"stripeBillingInformation"});

            }

            this._giftType = message.detail['giftType'];
            this._isCreatePledgeSubscription = message.detail['isCreatePledgeSubscription'];
            if (this._giftType == 'recurring') {
                this._startDate = message.detail['recurringStartDate'];
                this._endDate = message.detail['recurringEndDate'];
                this._frequency = message.detail['recurringFrequency'];
            } else if (this._giftType == 'pledge') {
                this._startDate = message.detail['pledgeStartDate'];
                this._frequency = message.detail['pledgeFrequency'];
                this._numberOfInstallments = parseInt(message.detail['numberOfInstallments']);
            }

        } else if (message.type == 'data-saved') {
            this._saved = true;
        } else if (message.type == 'metadataResults') {
            this._additionalMetadata = message.detail;
            this._additionalMetadata = {...this._additionalMetadata};
            this._additionalMetadata.params = {...this._additionalMetadata.params, externalDonationIdentifier: window.crypto.getRandomValues(new Uint32Array(2)).join() + Date.now()};
            this.metadataRetrieved = true;
        }
    }

    getAdditionalMetadata() {
        publish(this.messageContext, onlineGivingChannel, {type:"startAdditionalMetadataRetrieve"});
    }

    populateConstituentBillingInfo() {
        this._constituentBillingInformation['address'] = {};
        this._constituentBillingInformation['address']['city'] = this.getRecordValue('addressCity');
        this._constituentBillingInformation['address']['line1'] = this.getRecordValue('addressLine1');
        this._constituentBillingInformation['address']['line2'] = this.getRecordValue('addressLine2');
        this._constituentBillingInformation['address']['postal_code'] = this.getRecordValue('addressPostalCode');
        this._constituentBillingInformation['address']['state'] = this.getRecordValue('addressState');
        this._constituentBillingInformation['address']['country'] = this.getRecordValue('addressCountry');
        this._constituentBillingInformation['email'] = this.getRecordValue('emailAddress');
        if (this.paymentMethod === 'Cybersource' || this.paymentMethod === 'Cybersource w/ ACH') {
            this._constituentBillingInformation['firstName'] = this.getRecordValue('firstName');
            this._constituentBillingInformation['lastName'] = this.getRecordValue('lastName');
        }
        let firstName = this.getRecordValue('firstName');
        let middleName = this.getRecordValue('middleName');
        let lastName = this.getRecordValue('lastName');
        let suffix = this.getRecordValue('suffix');
        let name = firstName;
        if (middleName) {
            name = name + ' ' + middleName;
        }
        name = name + ' ' + lastName;
        if (suffix) {
            name = name + ' ' + suffix;
        }
        this._constituentBillingInformation['name'] = name;
    }

    populateOrganizationBillingInfo() {
        this._organizationBillingInformation['address'] = {};
        this._organizationBillingInformation['address']['city'] = this.getRecordValue('organizationCity');
        this._organizationBillingInformation['address']['line1'] = this.getRecordValue('organizationAddressLine1');
        this._organizationBillingInformation['address']['line2'] = this.getRecordValue('organizationAddressLine2');
        this._organizationBillingInformation['address']['postal_code'] = this.getRecordValue('organizationPostalCode');
        this._organizationBillingInformation['address']['state'] = this.getRecordValue('organizationState');
        this._organizationBillingInformation['address']['country'] = this.getRecordValue('organizationCountry');
        this._organizationBillingInformation['email'] = this.getRecordValue('organizationEmail');
        this._organizationBillingInformation['name'] = this.getRecordValue('organizationName');
        this._organizationBillingInformation['phone'] = this.getRecordValue('organizationPhoneNumber');
    }

    getRecordValue (field)  {
        let mainSection = this._informationMap.frontEndData[field].mainSection;
        let subSection = this._informationMap.frontEndData[field].subSection;
        let fieldName = this._informationMap.frontEndData[field].fieldName;
        let filterValue = this._informationMap.frontEndData[field].filterValue;
        let filterField = this._informationMap.frontEndData[field].filterField;
        let isPicklist = this._informationMap.frontEndData[field].isPicklist;
        if (!subSection) {
            subSection = 'records';
        }

        try {
            if (!isPicklist) {
                if (filterValue) {
                    for (let record of this._informationMap['records'][mainSection][subSection]) {
                        if (record[filterField] == filterValue) {
                            if (fieldName.includes('.')) {
                                let fields = fieldName.split('.');
                                return record[fields[0]][fields[1]]
                            }
                            return record[fieldName];
                        }
                    }
                } else {
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0] && this._informationMap['records'][mainSection][subSection][0][fields[0]]) {
                            return this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]
                        }
                        return "";
                    }
                    if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0]) {
                        return this._informationMap['records'][mainSection][subSection][0][fieldName];
                    }
                    return "";
                }
            } else {
                for (let picklistValue of this._informationMap.picklists[field]) {


                    if (filterValue) {
                        for (let record of this._informationMap['records'][mainSection][subSection]) {
                            if (record[filterField] == filterValue) {
                                if (fieldName.includes('.')) {
                                    let fields = fieldName.split('.');
                                    if (picklistValue.value == record[fields[0]][fields[1]]) {
                                        return picklistValue.label;
                                    }
                                }
                                if (picklistValue.value == record[fieldName]) {
                                    return picklistValue.label;
                                }
                            }
                        }
                    } else {
                        if (fieldName.includes('.') && this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0]) {
                            let fields = fieldName.split('.');
                            if (picklistValue.value ==  this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]) {
                                return picklistValue.label;
                            }
                        }
                        if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0] && picklistValue.value == this._informationMap['records'][mainSection][subSection][0][fieldName]) {
                            return picklistValue.label;
                        }
                    }

                }
           }
        } catch (e) {
            console.log(e);
        }
        return "";
    }

    handleStripePaymentElementConfirmation = (params) => {
        const dtdParams = {
            externalDonationIdentifier: this._additionalMetadata.params.externalDonationIdentifier,
            matchingCompanyId: this._additionalMetadata.params.matchingCompanyId,
            matchingCompanyIntegration: this._additionalMetadata.params.matchingCompanyIntegration,
            dtdBillingInformation: this._additionalMetadata.params.dtdBillingInformation,
            isGivingAsOrg: this._additionalMetadata.params.isGivingAsOrg,
            appealCode: this._additionalMetadata.params.appealCode,
            pageSectionName: this._additionalMetadata.params.pageSectionName,
            amount: this._additionalMetadata.params.amount,
        };

        if (dtdParams.matchingCompanyIntegration === 'Double The Donation' && dtdParams.dtdBillingInformation && !dtdParams.isGivingAsOrg) {
            callApexFunction(this, createDTDDonationAndInterim, dtdParams, (result) => {
                this.publishStripePaymentElementConfirmation(result);
            }, (error) => {});
        } else {
            this.publishStripePaymentElementConfirmation();
        }
    }

    publishStripePaymentElementConfirmation = (externalDonationIdentifier) => {
        let designations = this._additionalMetadata.params.designations;
        let startDate = this._additionalMetadata.params.startDate ? this._additionalMetadata.params.startDate : new Date().toISOString();
        let endDate = this._additionalMetadata.params.endDate ? this._additionalMetadata.params.endDate : '';
        let frequency = this._additionalMetadata.params.frequency ? this._additionalMetadata.params.frequency : 'One-Time Gift';

        let receiptData = {
            'designations': designations,
            'startDate': startDate,
            'endDate': endDate,
            'frequency': frequency,
            'externalDonationIdentifier': externalDonationIdentifier
        }
        publish(this.messageContext, onlineGivingChannel, {detail: receiptData, type: "saved"});
    }

    handlePaymentConfirmation = (params) =>  {
        publish(this.messageContext, onlineGivingChannel, {detail : params.paymentId, additionalPaymentDataMap : params.additionalPaymentDataMap, recaptchaToken : params.recaptchaToken, type:"save"});
    }

    handlePreviousButtonClick = (params) => {
        publish(this.messageContext, onlineGivingChannel, {type:"previous"});
    }
}