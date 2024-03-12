import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import SERVER_sendTestNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_sendTestNewsletter';
import SERVER_getNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_getNewsletter';
export default class Portal_quickaction_SendTestNewsletter extends LightningElement {

    _listing = {};
    _emailString = '';
    _recordId = '';

    @api set recordId(value) {
        this._recordId = value;
        const params = {params:{'newsletterId' : value}};
        SERVER_getNewsletter(params).then(res => {
            this._listing['Subject_Line__c'] = res.Subject_Line__c;
            this._listing['Id'] = value;
            this._isShowSpinner = false;
        })
    }

    get recordId() {
        return this._recordId;
    }

    _isShowSpinner = true;

   connectedCallback() {

   }


    @api invoke() {

    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    sendTestNewsletter(event) {
        this._isShowSpinner = true;
        const params = {params: {listing:this._listing, newsletterSectionsList: [], email: this._emailString}};
        SERVER_sendTestNewsletter(params).then(res => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your test newsletter was sent successfully.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
            this._isShowSpinner = false;
        }).catch(error => {
            console.log(error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'There was an error processing this action.',
                variant:"error",
                mode:"sticky"
            });
            //this.dispatchEvent(event);
            //this.dispatchEvent(new CloseActionScreenEvent());
            this._isShowSpinner = false;
        });
    }

    handleEmailStringChange = (event) => {
        this._emailString = event.currentTarget.value;
    }

}