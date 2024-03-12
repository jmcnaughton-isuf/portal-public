import { api, LightningElement, track, wire } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';

export default class Portal_OnlineGivingProgressBar extends LightningElement {
    @api pageLabels = '["Gift Type", "Billing Details", "Payment Information", "Confirmation"]';
    @api pageValues = '["giving", "billing", "credit"]';

    @wire(MessageContext) messageContext;

    @track _pageLabels = [];
    @track _pageValues = [];
    @track _currentPage;
    @track _subscription;

    get steps() {
        let resultList = [];

        for (let pageIndex = 0; pageIndex < this._pageLabels.length; pageIndex++) {
            let step = {label: this._pageLabels[pageIndex], value: this._pageValues[pageIndex], key: Date.now()};

            resultList.push(step);
        }

        return resultList;
    }

    connectedCallback() {
        this._pageLabels = JSON.parse(this.pageLabels);
        this._pageValues = JSON.parse(this.pageValues);
        this._pageValues.push('confirmation');
        this._currentPage = this._pageValues[0];

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
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._currentPage = message.detail['page'];
        }
        if (message.type == 'data-saved') {
            this._currentPage = 'confirmation';
        }
    }
}