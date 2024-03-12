import { LightningElement, track, wire, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getOnlineGivingBaseURL from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getOnlineGivingBaseURL';
import generateOnlineGivingLink from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_generateOnlineGivingLink';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_quickaction_GenerateGivingURL extends LightningElement {
    @api recordId;

    @track _showSpinner = true;
    @track _baseGivingURL = '';
    @track _generatedGivingUrl = '';

    get initializeGetOnlineGivingBaseUrlParams() {
        return {recordId: this.recordId};
    }

    get initializeGenerateOnlineGivingLinkParams() {
        let params = {givingUrl: this._baseGivingURL, contactId: [this.recordId]};

        return params;
    }

    get isDisableCopyLinkButton() {
        return (!this._generatedGivingUrl || this._generatedGivingUrl.length < 1);
    }

    @wire(getOnlineGivingBaseURL, {params: '$initializeGetOnlineGivingBaseUrlParams'})
    setOnlineGivingBaseURL({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }
        
        this._baseGivingURL = data;
        this._showSpinner = false;
    }

    handleBaseUrlUpdate = (event) => {
        this._baseGivingURL = event.target.value;
    }

    handleGenerateLink() {
        this._showSpinner = true;
        callApexFunction(this, generateOnlineGivingLink, this.initializeGenerateOnlineGivingLinkParams, (data) => {
            this._generatedGivingUrl = data[this.recordId] ? data[this.recordId] : '';
            this._showSpinner = false;
        }, () => {
            this._showSpinner = false;
        });
    }

    handleCopyURLClick = (event) => {
        let copiedString = this._generatedGivingUrl;

        if (!navigator.clipboard || !navigator.clipboard.writeText) {
            return;
        }

        navigator.clipboard.writeText(copiedString).then(() => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Successfully copied URL Link.',
                variant:"success"
            });
            this.dispatchEvent(event);
        });

    }

    handleClose(){
      this.dispatchEvent(new CloseActionScreenEvent());
    }
}