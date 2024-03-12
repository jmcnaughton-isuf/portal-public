import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import createDTDDonationAndInterim from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_createDTDDonationAndInterim';

export default class Portal_OnlineGivingCreditCardOR extends LightningElement {
    @api pageName;
    @api paymentMethod;
    @api apiKeyName;
    @api apiKey;
    @api externalGatewayName;

    @wire(MessageContext) messageContext;

    @track _amount = 0;
    @track _totalAmount = 0;
    @track _giftType;
    @track _constituentBillingInformation = {};
    @track _organizationBillingInformation = {};
    @track _isRecaptchaEnabled = true;
    @track _billingInformation = {};
    @track _billingInformationOnPaymentPage = {};
    @track _designations = [];
    @track _currentPage = 3;
    _pageList = ['giving', 'billing', 'credit'];
    _subscription = null;
    _page = 'giving';
    _informationMap;
    _frequency;
    _startDate;
    _endDate;
    _numberOfInstallments = 0;
    _isCreatePledgeSubscription = undefined;
    _firstPledgePaymentAmount = undefined;
    _saved = false;
    _givingAsOrg = false;
    _apiKey;
    _totalForDisplay = 0;
    _isGivingAsOrg = false;
    _additionalMetadata;
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

    get paymentAmount() {
        if (this._giftType !== 'pledge' || this._isCreatePledgeSubscription || !this._firstPledgePaymentAmount) {
            return this._amount;
        }

        return this._firstPledgePaymentAmount;
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
            if (message.detail['amount']) {
                this._amount = parseFloat(message.detail['amount']).toFixed(2);
            }            
            if (message.detail['firstPledgePaymentAmount']) {
                this._firstPledgePaymentAmount = parseFloat(message.detail['firstPledgePaymentAmount']).toFixed(2);
            }
            
            if (message.detail['givingAsOrg']){
                this._isGivingAsOrg = message.detail['givingAsOrg'];
            }
            if (message.detail['designationList']) {
                this._designations  = message.detail['designationList'];
                if(this._numberOfInstallments > 0){
                    let des = [];
                    let totalForDisp = 0;
                    for (let designation of this._designations) {
                        let perInstallationAmount = parseFloat(Math.floor((parseFloat(designation.amount) / this._numberOfInstallments)*100)/100).toFixed(2);
                        let difference = (parseFloat(designation.amount) - (perInstallationAmount * this._numberOfInstallments)).toFixed(2);
                        let amountForDisplay = parseFloat(perInstallationAmount) + parseFloat(difference);
                        des.push({Name: designation.Name, amount: amountForDisplay});
                        totalForDisp += amountForDisplay;
                    }
                    this._totalForDisplay = totalForDisp;
                    this._designations = des;
                }
            }
            if (message.detail['totalAmount']) {
                this._totalAmount  = parseFloat(message.detail['totalAmount']).toFixed(2);
                if(this._numberOfInstallments > 0){
                    this._billingInformationOnPaymentPage['totalAmount'] = this._totalForDisplay;
                }else {
                    this._billingInformationOnPaymentPage['totalAmount'] = this._totalAmount;
                }

            }
            if (message.detail['givingAsOrg']) {
                this._givingAsOrg = message.detail['givingAsOrg'];
            }
            this._informationMap = message.detail['billingInformation'];

            if (this._informationMap && Object.keys(this._informationMap) && Object.keys(this._informationMap).length > 0) {
                //FUTURE TODO: make it work with other payment methods
                this.populateConstituentBillingInfo();
                this.populateOrganizationBillingInfo();
                //console.log(' _Billing Info Inside: ',this._givingAsOrg);
                // this._billingInformation['address'] = {};
                // this._billingInformation['address']['city'] = this.getRecordValue('addressCity');
                // this._billingInformation['address']['line1'] = this.getRecordValue('addressLine1');
                // this._billingInformation['address']['line2'] = this.getRecordValue('addressLine2');
                // this._billingInformation['address']['postal_code'] = this.getRecordValue('addressPostalCode');
                // this._billingInformation['email'] = this.getRecordValue('emailAddress');
                // this._billingInformation['address']['state'] = this.getRecordValue('addressState');
                // this._billingInformation['address']['country'] = 'US';//this.getRecordValue('addressCountry');
                // //added for BillingInfo

                // this._billingInformationOnPaymentPage['address'] = {};
                // this._billingInformationOnPaymentPage['address']['city'] = this.getRecordValue('addressCity');
                // this._billingInformationOnPaymentPage['address']['line1'] = this.getRecordValue('addressLine1');
                // this._billingInformationOnPaymentPage['address']['line2'] = this.getRecordValue('addressLine2');
                // this._billingInformationOnPaymentPage['address']['postal_code'] = this.getRecordValue('addressPostalCode');
                // this._billingInformationOnPaymentPage['email'] = this.getRecordValue('emailAddress');
                // this._billingInformationOnPaymentPage['firstName'] = this.getRecordValue('firstName');
                // this._billingInformationOnPaymentPage['lastName'] = this.getRecordValue('lastName');
                // this._billingInformationOnPaymentPage['address']['state'] = this.getRecordValue('addressState');
                // if(this.getRecordValue('addressCountry')){
                //     this._billingInformationOnPaymentPage['address']['country'] = this.getRecordValue('addressCountry');
                // }else {
                //     this._billingInformationOnPaymentPage['address']['country'] = 'US';
                // }

                // this._billingInformationOnPaymentPage['phoneNumber'] = this.getRecordValue('phoneNumber');
                // /*if (this.paymentMethod == 'Cybersource') {
                //     this._billingInformation['firstName'] = this.getRecordValue('firstName'); 
                //     this._billingInformation['lastName'] = this.getRecordValue('lastName');
                //     this._billingInformation['address']['state'] = this.getRecordValue('addressState'); 
                //     this._billingInformation['address']['country'] = this.getRecordValue('addressCountry');
                // }*/

                // let firstName = this.getRecordValue('firstName');
                // let middleName = this.getRecordValue('middleName');
                // let lastName = this.getRecordValue('lastName');
                // let suffix = this.getRecordValue('suffix');
                // let name = firstName;
                // if (middleName) {
                //     name = name + ' ' + middleName;
                // }
                // name = name + ' ' + lastName;
                // if (suffix) {
                //     name = name + ' ' + suffix;
                // }
                // this._billingInformation['name'] = name;
                // this._billingInformationOnPaymentPage['name'] = name;
                // if (this._givingAsOrg) {
                //     this._billingInformationOnPaymentPage['address'] = {};
                //     this._billingInformationOnPaymentPage['address']['city'] = this.getRecordValue('organizationCity');
                //     this._billingInformationOnPaymentPage['address']['line1'] = this.getRecordValue('organizationAddressLine1');
                //     this._billingInformationOnPaymentPage['address']['line2'] = this.getRecordValue('organizationAddressLine2');
                //     this._billingInformationOnPaymentPage['address']['postal_code'] = this.getRecordValue('organizationPostalCode');
                //     this._billingInformationOnPaymentPage['email'] = this.getRecordValue('organizationalContactEmail');
                //     this._billingInformationOnPaymentPage['firstName'] = this.getRecordValue('organizationalContactFirstName');
                //     this._billingInformationOnPaymentPage['lastName'] = this.getRecordValue('organizationalContactLastName');
                //     this._billingInformationOnPaymentPage['address']['state'] = this.getRecordValue('organizationState');
                //     if(this.getRecordValue('organizationCountry')){
                //         this._billingInformationOnPaymentPage['address']['country'] = this.getRecordValue('organizationCountry');
                //     }else {
                //         this._billingInformationOnPaymentPage['address']['country'] = 'US';
                //     }
                //     this._billingInformationOnPaymentPage['name'] =  this.getRecordValue('organizationalContactFirstName') +' '+this.getRecordValue('organizationalContactLastName');
                //     this._billingInformationOnPaymentPage['phoneNumber'] = this.getRecordValue('organizationalContactPhone');
                // }

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
        this._constituentBillingInformation['phone'] = this.getRecordValue('phoneNumber');
        
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
        // console.log(this.getRecordValue('organizationPhoneNumber'));
        // this._organizationBillingInformation['email'] = this._informationMap['records']['Company_Information']['Company'][0][fields[0]][fields[1]];
        // this._organizationBillingInformation['name'] = this.getRecordValue('organizationName');
        // this._organizationBillingInformation['phone'] = this.getRecordValue('organizationPhoneNumber');
        this._organizationBillingInformation['email'] = this.getRecordValue('organizationalContactEmail');
        this._organizationBillingInformation['name'] = this.getRecordValue('organizationName');
        this._organizationBillingInformation['phone'] = this.getRecordValue('organizationalContactPhone');
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
                                return record[fields[0]][fields[1]];
                            }
                            return record[fieldName];
                        }
                    }
                } else {
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0] && this._informationMap['records'][mainSection][subSection][0][fields[0]]) {
                            return this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]];
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
    handlePaymentSubmitButton(event){
        publish(this.messageContext, onlineGivingChannel, {detail : params.paymentId, additionalPaymentDataMap : params.additionalPaymentDataMap, type:"save"});
    }
    handlePaymentConfirmation = (params) =>  {
        publish(this.messageContext, onlineGivingChannel, {detail : params.paymentId, additionalPaymentDataMap : params.additionalPaymentDataMap, recaptchaToken : params.recaptchaToken, type:"save"});
    }

    handlePreviousButtonClick = (params) => {
        publish(this.messageContext, onlineGivingChannel, {type:"previous"});
    }
}