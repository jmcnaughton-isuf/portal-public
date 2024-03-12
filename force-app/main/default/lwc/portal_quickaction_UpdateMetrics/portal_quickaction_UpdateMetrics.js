import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import SERVER_updateNewsletterMetrics from '@salesforce/apex/PORTAL_NewsletterController.SERVER_updateNewsletterMetrics';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Portal_quickaction_UpdateMetrics extends LightningElement {
    @api set recordId(value) {
        this._recordId = value;
    }
    @api handleClose = () => {};

    get recordId() {
        return this._recordId;
    }

    _isShowSpinner = false;

   connectedCallback() {

   }


    @api invoke() {

    }

    handleCancel(event) {
        this.handleClose();
    }

    handleSave(event) {
        this._isShowSpinner = true;
        const params = {params:{campaignId: this.recordId}};

        SERVER_updateNewsletterMetrics(params).then(res => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your newsletter metrics are being updated.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this.handleClose();
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
            this.handleClose();
        });
    }
}