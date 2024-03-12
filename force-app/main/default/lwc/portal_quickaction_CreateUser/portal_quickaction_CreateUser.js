import { LightningElement, api, track } from 'lwc';
import createUser from '@salesforce/apex/PORTAL_CommunityUserController.SERVER_createUserFromInterim';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Portal_quickaction_CreateUser extends LightningElement {
    @api recordId;

    @track _showSpinner = false;

    handleSave() {
        this._showSpinner = true;

        createUser({params: {interimId: this.recordId}}).then(() => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'User created successfully.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this._showSpinner = false;
        }).catch(error => {
            let errorMap = JSON.parse(error.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this._showSpinner = false;
        });
    }

    handleCancel() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA)
    }
}