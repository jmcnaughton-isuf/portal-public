import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingMatchingCompany extends LightningElement {

    @api componentLabel = 'Does your employer have a Matching Gift Program?';
    @api matchingCompanyLabel;
    @api isHepIntegrated;
    @api pageName;
    @wire(MessageContext) messageContext;
    _showMatchingCompany = false;
    _companyName = "";
    _companyId = "";
    _subscription = null;
    _page = 'giving';
    _isPledgePayment = false;
    _isValidPledge = false;

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
                (message) => this.handleMessage(message)
            );
        }
    }

    handleCompanySelected(event) {
        if (event.detail) {
            let data = JSON.parse(event.detail);
            if (data) {
                if (data.name) {
                    this._companyName = data.name;
                    publish(this.messageContext, onlineGivingChannel, {detail : JSON.stringify(this._companyName), type:"matchingCompanyName"});
                }
                if (data.id) {
                    this._companyId = data.id;
                    publish(this.messageContext, onlineGivingChannel, {detail : JSON.stringify(this._companyId), type:"matchingCompanyId"});
                }
            }
        }

    }

    handleCompanyNameChange(event) {
        this._companyName = event.currentTarget.value;
        publish(this.messageContext, onlineGivingChannel, {detail : JSON.stringify(this._companyName), type:"matchingCompanyName"});
    }

    deleteMatchingCompany(event) {
        this._companyName = "";
    }

    handleMatchinGiftChecked(event) {
        this._showMatchingCompany = event.currentTarget.checked;
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._page = message.detail['page'];
            this._isPledgePayment = message.detail['isPledgePayment'];
            this._isValidPledge = message.detail['isValidPledge'];
        }
    }

    get isShowComponent() {
        let isGivingPage = this._page == this.pageName;
        if (this._isPledgePayment) {
            return isGivingPage && this._isValidPledge;
        }

        return isGivingPage;
    }
}