import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SERVER_cloneNewsletter from '@salesforce/apex/PORTAL_NewsletterController.SERVER_cloneNewsletter';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class Portal_quickaction_CountNewsletterRecipients extends NavigationMixin(LightningElement) {
    @api set recordId(value) {
        this._recordId = value;
        this._isShowSpinner = false;
    }

    get recordId() {
        return this._recordId;
    }
    _recordIdAvailable = false;
    _isShowSpinner = true;
    _recordId;

   connectedCallback() {

   }

    @api invoke() {

    }

    handleSave(event) {
        this._isShowSpinner = true;
        const params = {params:{newsletterId: this._recordId}};
        SERVER_cloneNewsletter(params).then(res => {
            if (res) {
                console.log(res);
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: res,
                        objectApiName: 'ucinn_portal_Listing__c',
                        actionName: 'view'
                    },
                });
            } else {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'There was a problem cloning the newsletter.',
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            }
            this. _isShowSpinner = false;
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

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


}