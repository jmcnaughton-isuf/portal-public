import { LightningElement, wire, track, api} from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import FORM_FACTOR from '@salesforce/client/formFactor';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import thankyouLogoWhite from '@salesforce/resourceUrl/portal_thankyou';
export default class Portal_OnlineGivingReceipt extends LightningElement {

    _saved = false;
    @wire(MessageContext) messageContext;
    @api htmlText;
    @api imgSrc = thankyouLogoWhite;
    @api labelList;
    @track htmlAddText;
    @track _totalAmount = 0;
    @track _totalPledgeAmount = 0;
    _numberOfInstallments;
    _labelSize = "3";
    _labels = [];
    _subscription = null;
    _data = {}
    _designationData = [];
    _showMultiPayment = false;

    get multiPaymentColumnList() {
        if (this._labels.length == 0) {
            return [];
        }

        return [{label: this._labels[1], fieldId: 'Name', fieldType: 'text'},
            {label: '', fieldId: 'amount', fieldType: 'currency'}];

    }
    get columnDataList() {
        if (this._labels.length == 0) {
            return [];
        }
        return [{label: this._labels[0], fieldId: 'Name', fieldType: 'text'},
            {label: '', fieldId: 'amount', fieldType: 'currency'}];

    }

    get imgStyle() {
        return 'margin-top: -4.5em;';//margin-left: -4em;max-width: 122% !important;';
    }

    connectedCallback() {
        console.log(thankyouLogoWhite);
        this.subscribeToMessageChannel();
        if (this.labelList) {
            this._labels = this.labelList.split(',');
            let labelSize = Math.floor(12/this._labels.length);
            if (labelSize < parseInt(this._labelSize)) {
                this._labelSize = labelSize;
            }
        }
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
            this._numberOfInstallments = parseInt(message.detail['numberOfInstallments']);
        }
        if (message.type == 'data-saved') {
            this._data = message.detail;
            let totalAmt = 0.00;
            let frequency = this._data.frequency;
            this._designationData = this._data.designations;
            let des = [];
            console.log('this._data: ',this._data);
            for (let designation of this._data.designations) {
                totalAmt = totalAmt + parseFloat(designation.amount);
                console.log('totalAmt:: ',parseFloat(totalAmt) +' designation.amount',parseFloat(designation.amount));
                if(frequency != 'One-time') {
                    this._showMultiPayment = true;
                    let perInstallationAmount = parseFloat(Math.floor((parseFloat(designation.amount) / this._numberOfInstallments)*100)/100).toFixed(2);
                    console.log(`perInstallationAMount: ${perInstallationAmount}`);
                    let difference = (parseFloat(designation.amount) - (perInstallationAmount * this._numberOfInstallments)).toFixed(2);
                    console.log(`difference: ${difference}`);
                    let amountForDisplay = parseFloat(perInstallationAmount) + parseFloat(difference);
                    let amt = parseFloat(designation.amount).toFixed(2) / this._numberOfInstallments;
                    let newDesignation = {"Name":designation.Name, "amount": amountForDisplay};
                    des.push(newDesignation);
                    //this._totalAmount = this._totalAmount + parseFloat(designation.amount).toFixed(2);
                    //this._totalPledgeAmount = this._totalPledgeAmount + parseFloat(designation.amount).toFixed(2);
                    console.log('amount:: ',designation.amount);
                }
            }
            //this._totalAmount = parseFloat(totalAmt).toFixed(2);
            if(frequency != 'One-time') {
                this._totalPledgeAmount = parseFloat(totalAmt).toFixed(2);
                let baseTotal = parseFloat(Math.floor((this._totalPledgeAmount / this._numberOfInstallments)*100)/100).toFixed(2);
                console.log(`baseTotal: ${baseTotal}`);
                let totalDiff = (this._totalPledgeAmount - (baseTotal * this._numberOfInstallments)).toFixed(2);
                console.log(`difference: ${totalDiff}`);
                this._totalAmount = parseFloat(parseFloat(baseTotal) + parseFloat(totalDiff)).toFixed(2);
                this._designationData = [...des];
            } else {
                this._totalAmount = (totalAmt).toFixed(2);
            }
            console.log('_designationData: ',this._designationData);

            this._saved = true;
        }
    }

}