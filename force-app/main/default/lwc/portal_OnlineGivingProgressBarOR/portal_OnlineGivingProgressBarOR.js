import { api, LightningElement, track, wire } from 'lwc';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import progressBarStep1 from '@salesforce/resourceUrl/portal_progressstep1';
import progressBarStep2 from '@salesforce/resourceUrl/portal_progressstep2';
import progressBarStep3 from '@salesforce/resourceUrl/portal_progressstep3';
import savebuttonnext from '@salesforce/resourceUrl/portal_savebuttonnextlogo';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';
import FORM_FACTOR from "@salesforce/client/formFactor";

export default class Portal_OnlineGivingProgressBarOR extends LightningElement {
    @api pageLabels = '["Gift Type", "Billing Details", "Payment Information", "Confirmation"]';
    @api pageValues = '["gift", "billing", "credit"]';

    @wire(MessageContext) messageContext;
    
    @track _pageLabels = [];
    @track _pageValues = [];
    @track _currentPage;
    @track _currentPageValue;
    @track _currentPageNo = '1';
    @track _subscription;
    @track progressBarLogo = progressBarStep1;
    @track savebuttonnextlogo = savebuttonnext;
    _showModal = false;
    @track _firstPage = true;
    @track _finalPageStyle = true;
    @track _contentModuleMetadata;
    mobileVersion;

    get giftText() {
        console.log('The device form factor is: ' + FORM_FACTOR);
        switch(FORM_FACTOR) {
            case 'Large':
                return 'color: #C8102E !important; font-size: 60px !important;  font-family: Merriweather; font-weight: normal;';
            case 'Medium':
                return 'color: #C8102E !important; font-size: 45px !important;  font-family: Merriweather; font-weight: normal;';
            case 'Small':
                return 'color: #C8102E !important; font-size: 20px !important;  font-family: Merriweather; font-weight: normal;';
        }
    }


    get steps() {
        let resultList = [];

        for (let pageIndex = 0; pageIndex < this._pageLabels.length; pageIndex++) {
            let step = {label: this._pageLabels[pageIndex], value: this._pageValues[pageIndex], key: Date.now()};
            
            resultList.push(step);
        }

        console.log(JSON.stringify(resultList));

        return resultList;
    }

    connectedCallback() {
        this._pageLabels = JSON.parse(this.pageLabels);
        this._pageValues = JSON.parse(this.pageValues);
        this._pageValues.push('confirmation');
        this._currentPage = this._pageValues[0];
        this._currentPageValue = this._pageLabels[0];
        this._currentPageNo = this._pageLabels[0];

        SERVER_getContentModuleMetadata({params: {pageName: 'Give',
                moduleName: 'NeedHelpText',
                subPageName: '',
                pageUrl: ''}}).then(result => {
            this._contentModuleMetadata = result;
            //console.log('This.Content :: ',result);
        }).catch(error => {
            console.log('error',error);
        })
        //this.progressBarLogo = progressBarStep1;
        //console.log(JSON.stringify(this._pageLabels));
        //console.log(JSON.stringify(this._pageValues));
        //console.log(this._currentPage);
        //console.log('_currentPageValue'+this._currentPageValue);
        this.subscribeToMessageChannel();

        switch(FORM_FACTOR) {
            case 'Large':
                return this.mobileVersion = false;
            case 'Medium':
                return this.mobileVersion = false;
            case 'Small':
                return this.mobileVersion = true;
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

    handleShowMoreClicked(event) {
        this._showModal = true;
    }

    closeModal(event) {
        this._showModal = false;
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            this._currentPage = message.detail['page'];
            //console.log('message:: '+this._currentPage);
            if(this._currentPage === 'giving'){
                this._currentPageNo = '1';
                this._currentPageValue = 'Set Up Your Gift';
                this.progressBarLogo = progressBarStep1;
                this._firstPage = true;
            }else if(this._currentPage === 'billing'){
                this._currentPageNo = '2';
                this._currentPageValue = 'Billing Information';
                this.progressBarLogo = progressBarStep2;
                this._firstPage = false;
            }else if(this._currentPage === 'credit'){
                this._currentPageNo = '3';
                this._currentPageValue = 'Payment Details';
                this.progressBarLogo = progressBarStep3;
                this._firstPage = false;
            }
            //console.log('this._pageLabels:: '+this._pageLabels);
        }
        if (message.type == 'data-saved') {
            this._currentPage = 'confirmation';
            this._finalPageStyle = false;
            this._currentPageValue = 'Confirmation';
            this._firstPage = false;
            //this.progressBarLogo = '';
        }
    }
}