import { LightningElement, api, wire } from 'lwc';
import SERVER_getCustomFields from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getCustomFields'
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
export default class Portal_OnlineGivingAdditionalDetailsOR extends LightningElement {

    @api componentLabel;
    @api contentPageName;
    @api contentModuleName;
    @api pageName;
    @api textColor;
    @wire(MessageContext) messageContext;
    _page = 'giving';
    _subscription = null;
    _customFields = [];
    _returnValues = [];
    _isPledgePayment = false;

    connectedCallback() {
        const params = {'params':{'contentPageName': this.contentPageName, 'contentModuleName': this.contentModuleName}};
        SERVER_getCustomFields(params).then(res =>  {
            this._customFields = JSON.parse(JSON.stringify(res));
            for (let record of this._customFields) {
                this._returnValues.push({'Id': record.Id});
            }
        }).catch(console.error);
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
        }

    }

    handleValueChange = (event) => {
        let index = event.currentTarget.getAttribute('data-index');
        if (this._customFields[index].type == 'Checkbox') {
            this._returnValues[index]['value'] = event.currentTarget.checked;
        } else if (this._customFields[index].type == 'Multi-Picklist'){
            let allValues = '';
            for (let value of event.currentTarget.value) {
                allValues = allValues + value + ';';
            }
            this._returnValues[index]['value'] = allValues;
        } else {
            this._returnValues[index]['value'] = event.currentTarget.value;
        }

        publish(this.messageContext, onlineGivingChannel, {detail: JSON.parse(JSON.stringify(this._returnValues)), type:"customFields"});
    }

    get isShowComponent() {
        return this._page == this.pageName && !this._isPledgePayment;
    }

    get headerStyle() {
        return 'color:' + this.textColor + ';';
    }
}