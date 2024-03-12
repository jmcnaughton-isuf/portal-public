import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingInstallmentsOR extends LightningElement {

    @api firstPaymentLabel;
    @api remainingPaymentsLabel;
    @api minNumberOfPayments;
    @api pageName;
    @wire(MessageContext) messageContext;
    _giftType;
    _amount;
    _firstAmount;
    _totalAmount;
    _numberOfInstallments;
    _subscription = null;
    _page = 'giving';

    get isShowComponent() {
        return this._giftType == 'pledge' && this._totalAmount && this._page == this.pageName;
    }

    get remainingInstallments() {
        return this._numberOfInstallments - 1;
    }

    connectedCallback() {
        this._numberOfInstallments = this.minNumberOfPayments;
        this.subscribeToMessageChannel();
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
                (message) => this.handleMessage(message)
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._giftType = message.detail['giftType'];
            if (this._giftType == 'pledge') {
                if (message.detail['numberOfInstallments'] && message.detail['amount']) {
                    this._numberOfInstallments = parseInt(message.detail['numberOfInstallments']);
                    this._totalAmount = parseFloat(message.detail['amount']).toFixed(2);
                    this._amount = parseFloat(Math.floor(parseFloat(this._totalAmount/parseFloat(this._numberOfInstallments))*100)/100).toFixed(2);
                    let newTotalAmt = 0;
                    let desParse = [...message.detail.designationList];
                    let desList = [];
                    for(let des of desParse) {
                        console.log(`des2 ${des.amount}`);
                        desList.push({"Name" : des.Name, "Amount" : des.amount});
                        let desAmount = Math.floor((parseFloat(des.amount)/this._numberOfInstallments)*100)/100;
                        newTotalAmt += desAmount;
                    }
                    this._amount = newTotalAmt;
                    let totalAmnt = parseFloat(this._totalAmount);
                    let totalxInstl = newTotalAmt * this._numberOfInstallments;
                    if(totalxInstl != totalAmnt) {
                        this._firstAmount = (newTotalAmt + totalAmnt - (newTotalAmt * this._numberOfInstallments)).toFixed(2);
                    } else {
                        this._firstAmount = newTotalAmt;
                    }
                    /*if (this._amount * this._numberOfInstallments != this._totalAmount) {
                        this._firstAmount = (parseFloat(this._amount) + parseFloat((this._totalAmount - this._amount*this._numberOfInstallments))).toFixed(2);
                    } else {
                        this._firstAmount = this._amount;
                    }*/
                    console.log(' amount: ',this._amount , ' F amount: ',this._firstAmount, 'T amount: ',totalAmnt);
                }
            }
            this._page = message.detail['page'];
        }
    }


}