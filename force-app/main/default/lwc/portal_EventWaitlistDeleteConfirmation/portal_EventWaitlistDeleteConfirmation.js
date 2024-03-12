import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import basePath from '@salesforce/community/basePath';
import getWaitlistEntryById from '@salesforce/apex/PORTAL_LWC_EventWaitlistFormController.SERVER_getWaitlistEntryById';
import deleteWaitlistEntry from '@salesforce/apex/PORTAL_LWC_EventWaitlistFormController.SERVER_deleteWaitlistEntry';

export default class Portal_EventWaitlistDeleteConfirmation extends LightningElement {
    @api waitlistEntryId;

    @track _showSpinner;
    @track _showModal;

    closeModal() {
        window.location.href = basePath + '/events';
    }

    connectedCallback() {
        this._showSpinner = true;
        getWaitlistEntryById({params: {waitlistEntryId: this.waitlistEntryId}}).then((waitlistEntry) => {
            if (!waitlistEntry) {
                window.location.href = basePath + '/events';
                return;
            }
            this._showModal = true;
            this._showSpinner = false;
        }).catch(e => {
            console.log(e);
            this._showSpinner = false;
            let errorMap = JSON.parse(e.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        })
    }

    handleConfirmClick() {
        this._showSpinner = true;
        deleteWaitlistEntry({params: {waitlistEntryId : this.waitlistEntryId}}).then(() => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'You have successfully removed yourself from the waitlist!',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);

            window.location.href = basePath + '/events';
            this._showSpinner = false;
        }).catch(e => {
            console.log(e);
            this._showSpinner = false;
            let errorMap = JSON.parse(e.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        })
    }
}