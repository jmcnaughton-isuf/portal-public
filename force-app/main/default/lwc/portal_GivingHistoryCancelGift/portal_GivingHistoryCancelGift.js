import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cancelSubscription from '@salesforce/apex/PORTAL_GivingHistoryPaymentController.SERVER_cancelSubscription';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Portal_GivingHistoryCancelGift extends LightningElement {
    @api giftId;
    @api giftType; // 'recurring' or 'pledge'
    @api subscriptionId;
    @api externalPaymentGatewayId;
    @api externalSystemId;
    @api closeModal;
    @api paymentMethod;

    @track showSpinner = false;

    handleConfirmCancelSubscription = (event) => {        
        const params = {
            'giftId': this.giftId,
            'giftType': this.giftType,
            'subscriptionId': this.subscriptionId,
            'externalPaymentGatewayId': this.externalPaymentGatewayId,
            'externalSystemId': this.externalSystemId,
            'paymentMethod': this.paymentMethod
        };

        this.showSpinner = true;
        callApexFunction(this, cancelSubscription, params, this.successCallback, this.failureCallback);
    }

    successCallback = () => {
        this.showNotification('Success!', 'Your gift has been cancelled', 'success');
        this.showSpinner = false;
        this.closeModal(true);
    }

    failureCallback = () => {
        this.showSpinner = false;
        this.closeModal();
    }

    showNotification = (title, message, variant = 'info', mode = 'dismissible') => {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });

        this.dispatchEvent(evt);
    }
}