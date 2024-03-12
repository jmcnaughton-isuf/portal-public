import { LightningElement, api, wire } from 'lwc';
import { MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';


export default class Portal_OnlineGivingPledgeInfo extends LightningElement {

    @api pageName;
    @api componentLabel;
    @api totalPledgeAmountLabel;
    @api amountPaidToDateLabel;
    @api currentDueDateLabel;
    @api pastDueAmountLabel;
    @api currentDueAmountLabel;
    @api totalDueAmountLabel;
    @wire(MessageContext) messageContext;
    _page = 'giving';
    _isValidPledge = false;
    _selectedPledgeInfo = {};


    get isShowComponent() {
        return this._page == this.pageName  && this._isValidPledge;
    }

    connectedCallback() {
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
            this._page = message.detail['page'];
            this._isValidPledge = message.detail['isValidPledge'];
        }
        if (message.type == 'data-display') {
            this._selectedPledgeInfo = message.detail['pledgePaymentInfo'];
        }
    }
}