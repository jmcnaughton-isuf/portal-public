import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingEventCenterOR extends LightningElement {

    _dataMap = {};
    _receiptData = {};
    _subscription = null;
    @wire(MessageContext) messageContext;


    connectedCallback() {
        this.subscribeToMessageChannel();
        this._dataMap['amount'] = 0;
        this._dataMap['defaultSelectedAmount'] = 0;
        this._dataMap['isPledgePayment'] = false;
        this._dataMap['isValidPledge'] = false;
        this._dataMap['pledgePaymentInfo'] = {};
        this._dataMap['designationList'] = [];
        this._dataMap['giftType'] = 'gift';
        this._dataMap['numberOfInstallments'] = 0;
        this._dataMap['billingInformation']= {};
        this._dataMap['pledgeStartDate'] = null;
        this._dataMap['isPledgeStartDateValid'] = false;
        this._dataMap['pledgeFrequency'] = '';
        this._dataMap['recurringStartDate'] = null;
        this._dataMap['recurringEndDate'] = null;
        this._dataMap['isRecurringDatesValid'] = false;
        this._dataMap['recurringFrequency'] = '';
        this._dataMap['additionalDetails'] = [];
        this._dataMap['type'] = '';
        this._dataMap['paymentId'] = '';
        this._dataMap['tribute'] = {};
        this._dataMap['matchingCompanyIntegration'] = '';
        this._dataMap['matchingCompanyName'] = '';
        this._dataMap['matchingCompanyId'] = '';
        this._dataMap['stripeBillingInformation'] = {};
        this._dataMap['dtdBillingInformation'] = {};
        this._dataMap['billingIsValid'] = false;
        this._dataMap['designationsAreValid'] = false;
        this._dataMap['amountIsValid'] = true;
        this._dataMap['typeIsValid'] = true;
        this._dataMap['tributeValid'] = true;
        this._dataMap['pledgeId'] = '';
        this._dataMap['page'] = 'giving';
        this._dataMap['paymentChoice'] = '';
        this._dataMap['givingAsOrg'] = false;
        this._dataMap['recaptchaToken'] = '';
        this._dataMap['isCreatePledgeSubscription'] = undefined;
        this._dataMap['firstPledgePaymentAmount'] = undefined;
        this._dataMap['firstTimeFund'] = true;
        this._dataMap['contactId'] = '';
        this._dataMap['totalAmount'] = 0;
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
        if (message.type == "amount") {
            this._dataMap['amount'] = parseFloat(message.detail).toFixed(2);
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'resetSelectedAmount') {
            publish(this.messageContext, onlineGivingChannel, {detail :'true', type:"reset-amount"});
        } else if (message.type == 'isPledgePayment') {
            this._dataMap['isPledgePayment'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'isValidPledge') {
            this._dataMap['isValidPledge'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'pledgePaymentInfo') {
            this._dataMap['pledgePaymentInfo'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-display"});
        } else if (message.type == 'designation') {
            this._dataMap['designationList'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'giftType') {
            this._dataMap['giftType'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'installments') {
            this._dataMap['numberOfInstallments'] = parseInt(message.detail);
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'billingDetails') {
            this._dataMap['billingInformation']= message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'pledgeStartDate') {
            this._dataMap['pledgeStartDate'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'isPledgeStartDateValid') {
            this._dataMap['isPledgeStartDateValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'pledgeFrequency') {
            this._dataMap['pledgeFrequency'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'recurringStartDate') {
            this._dataMap['recurringStartDate'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'recurringEndDate') {
            this._dataMap['recurringEndDate'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'recurringFrequency') {
            this._dataMap['recurringFrequency'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'isRecurringDatesValid') {
            this._dataMap['isRecurringDatesValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'customFields') {
            this._dataMap['additionalDetails'] = message.detail;
        } else if (message.type == 'save') {
            this._dataMap['type'] = 'save';
            this._dataMap['paymentId'] = message.detail;
            this._dataMap['additionalPaymentDataMap'] = message.additionalPaymentDataMap;
            this._dataMap['acct'] = message.acct;
            this._dataMap['recaptchaToken'] = message.recaptchaToken;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'tribute') {
            this._dataMap['tribute'] = message.detail;
        } else if (message.type == 'matchingCompanyIntegration') {
            this._dataMap['matchingCompanyIntegration'] = message.detail;
        } else if (message.type == 'matchingCompanyName') {
            this._dataMap['matchingCompanyName'] =  message.detail;
        } else if (message.type == 'matchingCompanyId') {
            this._dataMap['matchingCompanyId'] = message.detail;
        } else if (message.type == 'stripeBillingInformation') {
            this._dataMap['stripeBillingInformation'] = message.detail;
        } else if (message.type == 'dtdBillingInformation') {
            this._dataMap['dtdBillingInformation'] = message.detail;
        } else if (message.type == 'startBillingDetailsCheckValidity') {
            publish(this.messageContext, onlineGivingChannel, {type: "beginValidation"});
        } else if (message.type == 'billingDetailsCheckValidityResults') {

            publish(this.messageContext, onlineGivingChannel, {detail :message.detail, type:"validationResults"});
        } else if (message.type == 'billingValidity') {
            this._dataMap['billingIsValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'designationValidity') {
            this._dataMap['designationsAreValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'amountValidity') {
            this._dataMap['amountIsValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'amountValidity') {
            this._dataMap['typeIsValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        }  else if (message.type == 'isInstallmentsValid') {
            this._dataMap['isInstallmentsValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'previous') {
            this._dataMap['type'] = 'previous';
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'pledgeId') {
            this._dataMap['pledgeId'] = message.detail;
        } else if (message.type == 'designationWithAmount') {
            this._dataMap['designationList'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'saved') {
            this._receiptData = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._receiptData, type:"data-saved"});
        } else if (message.type == 'pageChange') {
            this._dataMap['type'] = ['eventPageChange'];
            this._dataMap['page'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else  if (message.type == "totalAmount") {
            this._dataMap['amount'] = parseFloat(message.detail).toFixed(2);
            this._dataMap['totalAmount'] = parseFloat(message.detail).toFixed(2);
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'paymentChoice') {
            this._dataMap['paymentChoice'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'donor-change') {
            this._dataMap['givingAsOrg'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type: "data-change"});
        } else if (message.type == 'startAdditionalMetadataRetrieve') {
            publish(this.messageContext, onlineGivingChannel, {type:"additionalMetadataRetrieve"});
        } else if (message.type == 'additionalMetadata') {
            publish(this.messageContext, onlineGivingChannel, {detail :message.detail, type: "metadataResults"});
        } else if (message.type == 'isCreatePledgeSubscription') {
            this._dataMap['isCreatePledgeSubscription'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail: this._dataMap, type: 'data-change'});
        } else if (message.type == 'firstPledgePaymentAmount') {
            this._dataMap['firstPledgePaymentAmount'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail: this._dataMap, type: 'data-change'}); 
        } else if (message.type == 'firstTimeFund') {
            this._dataMap['firstTimeFund'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'contactId') {
            this._dataMap['contactId'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        } else if (message.type == 'tributeValid') {
            this._dataMap['tributeValid'] = message.detail;
            publish(this.messageContext, onlineGivingChannel, {detail :this._dataMap, type:"data-change"});
        }
    }

}