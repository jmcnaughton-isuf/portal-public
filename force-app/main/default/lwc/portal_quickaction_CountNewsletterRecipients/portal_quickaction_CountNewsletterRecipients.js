import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import SERVER_countRecipients from '@salesforce/apex/PORTAL_NewsletterController.SERVER_countRecipients';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Portal_quickaction_CountNewsletterRecipients extends LightningElement {
    @api recordId;
    _recordIdAvailable = false;
    _email = '';

   connectedCallback() {

   }

    renderedCallback() {
        if (!this._recordIdAvailable && this.recordId) {
            this._recordIdAvailable = true;
        }
    }

    @api invoke() {

    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleSave(event) {
        this._isShowSpinner = true;
        const params = {params:{newsletterId: this.recordId, email: this._email}};
        SERVER_countRecipients(params).then(() => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your recipient count has been initiated. Please wait for an email to let you know the newsletter is ready to be scheduled.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
        }).catch(error => {
            console.log(error);
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

    setRecordValue = (event) => {
        this._email = event.currentTarget.value;
    }
}