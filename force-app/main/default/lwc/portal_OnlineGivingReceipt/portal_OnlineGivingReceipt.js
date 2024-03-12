import { LightningElement, wire, api, track} from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingReceipt extends LightningElement {

    _saved = false;
    @wire(MessageContext) messageContext;
    @api htmlText;
    @api imgSrc;
    @api labelList;
    _labelSize = "3";
    _labels = [];
    _subscription = null;
    _data = {};

    get columnDataList() {
        if (this._labels.length == 0) {
            return [];
        }

        return [{label: this._labels[0], fieldId: 'Name', fieldType: 'text'},
                {label: this._labels[1], fieldId: 'amount', fieldType: 'currency'}];
    }

    connectedCallback() {
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
        if (message.type == 'data-saved') {
            this._data = message.detail;
            this._saved = true;
        }
    }

}