import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateSubscriptionCreditCard from '@salesforce/apex/PORTAL_GivingHistoryPaymentController.SERVER_updateSubscriptionCreditCard';

export default class Portal_GivingHistoryCreditCard extends LightningElement {
    @api giftId;
    @api subscriptionId;
    @api externalPaymentGatewayId;
    @api paymentMethod;
    @api paymentType;
    @api externalGatewayName;
    @api closeModal;

    @track showSpinner = false;

    /**
     * params: {paymentId: <str>, additionalPaymentDataMap: {}}
     *      paymentId is the resulting token from the payment processor/new credit card info
     *      additionalPaymentDataMap is used with Spreedly ACH bank accounts, but will be undefined or {} for any credit card 
     */
    handlePaymentConfirmation = (params) => {  
        const paramMap = {'paramMap': 
            {
                'giftId': this.giftId,
                'subscriptionId': this.subscriptionId,
                'paymentId': params.paymentId,
                'paymentMethod': this.paymentMethod,
                'externalPaymentGatewayId': this.externalPaymentGatewayId
            }
        };

        // ascend and the payment processor will replace the old payment method (credit card) with a new one
        this.showSpinner = true;
        updateSubscriptionCreditCard(paramMap)
        .then(result => {
            if (result) {
                this.showNotification('Success!', 'Your credit card information has been updated', 'success');
                this.showSpinner = false;
                this.closeModal(result);
            }
            else {
                this.showNotification('Error!', 'Payment information could not be saved', 'error', 'sticky');
                this.showSpinner = false;
            }
        })
        .catch(error => {
            let errorMap = JSON.parse(error.body.message);
            this.showNotification('Error!', errorMap.message, 'error', 'sticky');
            this.showSpinner = false;
        });
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