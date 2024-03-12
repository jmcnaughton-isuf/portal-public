import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import SERVER_sendNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_sendNewsletter';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SERVER_getNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_getNewsletter';
export default class Portal_quickaction_SendNewsletter extends LightningElement {

    @api set recordId(value) {
        this._recordId = value;
        const params = {params:{newsletterId: this.recordId}};
            SERVER_getNewsletter(params).then(res => {
                this._isShowSpinner = false;
            }).catch(console.error);
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

    handleSave(event) {
        this._isShowSpinner = true;
        const params = {params:{newsletterId: this.recordId}};
        SERVER_sendNewsletter(params).then(res => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your newsletter has been scheduled.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
        }).catch(error => {

            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
        });
    }
}