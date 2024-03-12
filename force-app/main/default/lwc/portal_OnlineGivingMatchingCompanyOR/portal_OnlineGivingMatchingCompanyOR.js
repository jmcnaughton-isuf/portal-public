import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingMatchingCompanyOR extends LightningElement {

    @api componentLabel;
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
    showHepSearch = false;

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

    handleHepSearch(event) {
        this.showHepSearch = true;
    }

    handleCompanySelected(event) {
        if (event.detail) {
            let data = JSON.parse(event.detail);
            console.log('companyselected: ',data);
            if (data) {
                if (data.name) {
                    this._companyName = data.name;
                    console.log('_companyName: ',this._companyName);
                    //this._companyName = 'IBM Canada, Ltd.';//'[ { "name": "IBM Canada, Ltd.", "subsidiary": false, "subsidiary_id": null, "company_id": "73780000", "city": "Markham", "state": "ON", "last_updated": "10/20/2017" }, { "name": "AIBMR Life Sciences", "subsidiary": false, "subsidiary_id": null, "company_id": "15000331", "city": "Puyallup", "state": "WA", "last_updated": "03/31/2014" }, { "name": "International Business Machines", "subsidiary": true, "subsidiary_id": 66179, "company_id": "4870000", "city": "Research Triangle Park", "state": "NC", "last_updated": "06/25/2019" }, { "name": "IBM", "subsidiary": false, "subsidiary_id": null, "company_id": "4870000", "city": "Research Triangle Park", "state": "NC", "last_updated": "06/25/2019" } ]';
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