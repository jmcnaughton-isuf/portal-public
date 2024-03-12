import { LightningElement, api, track } from 'lwc';
import SERVER_sendMessageToContact from '@salesforce/apex/PORTAL_LWC_DirectoryProfileController.SERVER_sendMessageToContact'
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_DirectoryMessagingModal extends LightningElement {
    @api contactId = "";
    @api informationMap = {};

    @api closeModal = () => {};

    @track _subject = "";
    @track _body = "";
    @track _showSpinner = false;

    onSubjectChange = (event) => {
        this._subject = event.target.value;
    }

    onBodyChange = (event) => {
        this._body = event.target.value;
    }

    onSend() {
        this._showSpinner = true;

        if (!this._subject || !this._body) {
            this._showSpinner = false;

            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Please complete both the subject and body sections.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);

            return;
        }

        let params = {receiverContactId: this.contactId,
                      subject: this._subject,
                      body: this._body};

        callApexFunction(this, SERVER_sendMessageToContact, params, () =>{
            this.closeModal();

            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Message sent successfully.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }, (e) => {
            this._showSpinner = false;
        })
    }
}