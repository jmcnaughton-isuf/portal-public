import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';


export default class Portal_OnlineGivingOrganizationalGiving extends LightningElement {

    @api pageName;
    @api orgGivingCheckboxLabel;
    @api showOrgGiving;
    @wire(MessageContext) messageContext;
    _page = 'giving';
    _givingAsOrg = false;
    _isPledgePayment = false;


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
            this._isPledgePayment = message.detail['isPledgePayment'];
            if (this._givingAsOrg && this._isPledgePayment) {
                this._givingAsOrg = false;
                publish(this.messageContext, onlineGivingChannel, {detail: this._givingAsOrg, type: 'donor-change'});
            }
        }
    }

    get isShowComponent() {
        return this._page == this.pageName && this.showOrgGiving && !this._isPledgePayment;
    }

    handleCheckboxChange = (event) => {
        this._givingAsOrg = event.target.checked;
        publish(this.messageContext, onlineGivingChannel, {detail: this._givingAsOrg, type: 'donor-change'});
    }
}