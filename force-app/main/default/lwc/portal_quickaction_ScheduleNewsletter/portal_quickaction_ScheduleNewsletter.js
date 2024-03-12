import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import SERVER_scheduleNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_scheduleNewsletter';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SERVER_getNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_getNewsletter';
import TickerSymbol from '@salesforce/schema/Account.TickerSymbol';
export default class Portal_quickaction_ScheduleNewsletter extends LightningElement {
    @api set recordId(value) {
        this._recordId = value;
        const params = {params:{newsletterId: this.recordId}};
            SERVER_getNewsletter(params).then(res => {
                this._startDateTime = res.Start_Date_Time__c;
            }).catch(console.error).finally(this._isShowSpinner = false)

    }

    get recordId() {
        return this._recordId;
    }

    get todaysDate() {
        var today = new Date();
        return today.toISOString();
    }

    _isShowSpinner = true;
    _startDateTime = null;

   connectedCallback() {

   }




    @api invoke() {

    }

    handleInputChange(event) {
        this._startDateTime = event.detail.value;
    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleSave(event) {
        this._isShowSpinner = true;
        this._startDateTime = this._startDateTime.replace('T', ' ').replace('.000Z', '');
        const params = {params:{newsletterId: this.recordId, deliveryTime: this._startDateTime}};
        SERVER_scheduleNewsletter(params).then(res => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your newsletter has been scheduled.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
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
        }).finally(this.dispatchEvent(new CloseActionScreenEvent()));
    }
}