import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingInstallments extends LightningElement {

    @api firstPaymentLabel;
    @api remainingPaymentsLabel;
    @api lastPaymentLabel = 'Last Payment Amount';
    @api minNumberOfPayments;
    @api pageName;
    @wire(MessageContext) messageContext;
    _giftType;
    _amount;
    _firstAmount;
    _lastAmount;
    _totalAmount;
    _numberOfInstallments;
    _designationList = [];
    _subscription = null;
    _page = 'giving';
    _isCreatePledgeSubscription = undefined;

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
            this._isCreatePledgeSubscription = message.detail['isCreatePledgeSubscription'];
            this._designationList = message.detail['designationList'] || [];

            if (this._giftType == 'pledge') {
                this.calculateInstallments(message.detail['numberOfInstallments'], message.detail['amount']);
            }

            this._page = message.detail['page'];
        }
    }

    calculateInstallments(messageNumberOfInstallments, messageAmount) {
        if (!messageNumberOfInstallments || !messageAmount) {
            return;
        }

        this._numberOfInstallments = parseInt(messageNumberOfInstallments);
        this._totalAmount = parseFloat(messageAmount).toFixed(2);

        if (this._isCreatePledgeSubscription) {
            this.roundInstallmentsDown();
        } else {
            this.roundInstallmentsHalfEven();
        }
    }

    // The portal calculation - round the average installment amount down, then assign the remainder to the first payment amount
    roundInstallmentsDown() {
        this._amount = parseFloat(Math.floor(parseFloat(this._totalAmount/parseFloat(this._numberOfInstallments))*100)/100).toFixed(2);
        if (this._amount * this._numberOfInstallments != this._totalAmount) {
            this._firstAmount = (parseFloat(this._amount) + parseFloat((this._totalAmount - this._amount*this._numberOfInstallments))).toFixed(2);
        } else {
            this._firstAmount = this._amount;
        }
    }

    // The ascend calculation - round* the average designation amount, then use whatever remains in the final amount.
    // The overall pledge payment is the sum across all designations
    //      *ascend uses half even rounding, which JS does not natively support
    roundInstallmentsHalfEven() {
        let firstPayment = 0;
        for (let eachDesignation of this._designationList) {
            if (!eachDesignation.amount) {
                continue;
            }

            firstPayment += parseFloat((this.roundNumberHalfEven(parseFloat(eachDesignation.amount) / this._numberOfInstallments * 100) / 100).toFixed(2));
        }

        if (this._designationList.length === 0 || firstPayment === 0) {
            firstPayment = this.roundNumberHalfEven(parseFloat(this._totalAmount) / this._numberOfInstallments * 100) / 100;
        }

        let previousAmount = this._amount;
        let previousLastAmount = this._lastAmount;
        this._amount = firstPayment.toFixed(2);
        this._lastAmount = (parseFloat(this._totalAmount) - ((this._numberOfInstallments - 1) * parseFloat(this._amount))).toFixed(2);

        if (previousAmount !== this._amount) {
            publish(this.messageContext, onlineGivingChannel, {detail: this._amount, type: 'firstPledgePaymentAmount'});
        }

        if (previousLastAmount !== this._lastAmount) {
            publish(this.messageContext, onlineGivingChannel, {detail: this._lastAmount, type: 'lastPledgePaymentAmount'});
        }
    }

    // round a number to an integer with half even rounding
    // follows standard rounding rules unless the tenths place is 5, then round to the nearest even number, examples below
    //      1.4 -> 1
    //      1.6 -> 2
    //      1.5 -> 2
    //      2.5 -> 2
    roundNumberHalfEven(number) {
        const tenthsPlace = Math.trunc((number * 10) % 10);
        const onesPlace = Math.trunc(number % 10);

        if (tenthsPlace !== 5) {
            return Math.round(number);
        }

        if (onesPlace % 2 === 0) {
            return Math.floor(number);
        }

        return Math.ceil(number);
    }
}