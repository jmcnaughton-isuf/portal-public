import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_EventRegistrantForm extends LightningElement {
    @api registrant;
    @api registrantIndex;
    @api registrationTemplate;
    @api customFormFields;
    @api promoCode;
    @api hasPromoCodes = false;
    @api isShowTickets = false;
    @api isGuestRegistrationModifiable;
    @api isWaitlistEnabled = false;
    @api isLookWhosComingEnabled = false;
    @api handleInput = () => {};
    @api handleTicketInput = () => {};
    @api handleTicketCheckbox = () => {};
    @api handleWaitlistClick = () => {};

    @api handlePromoCodeChange = () => {};
    @api handleApplyPromoCode = () => {};
    @api handleAdditionalInfoChange = () => {};

    @api checkInputValidity() {
        let inputs = this.template.querySelectorAll('c-portal_-input');
        let customFormFieldInputs = this.template.querySelectorAll('c-portal_-Custom-Form-Field');
        let validity = true;

        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (validity === true) {
                        input.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        if (customFormFieldInputs) {
            for (const customFormFieldInput of customFormFieldInputs) {
                if (customFormFieldInput.checkValidity() === false) {
                    if (validity === true) {
                        customFormFieldInput.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        if (validity === false) {
            return false;
        }

        if (this.hasSelectedTickets() != true) {
            const toastEvent = new ShowToastEvent({
                title: 'Error!',
                message: 'Please select a ticket before continuing.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(toastEvent);

            return false;
        }

        return true;
    }

    @api resetInputValidity() {
        let inputs = this.template.querySelectorAll('c-portal_-input');

        if (inputs) {
            for (const input of inputs) {
                input.setCustomValidity('');
            }
        }
    }

    get isPromoCodeButtonDisabled() {
        if (this.promoCode) {
            return false;
        }

        return true;
    }

    get _isShowTickets() {
        if (this.isShowTickets && this.registrant && this.registrant.ticketList) {
            return true;
        }

        return false;
    }

    get isEmailRequired() {
        if (this.registrantIndex === 0 || !this.registrationTemplate) {
            return true;
        }

        return this.registrationTemplate.Is_Guest_Email_Required__c;
    }

    get isBioInfoDisabled() {
        if (this.registrant && this.registrant.participationStatus === 'Registered'
                && (this.registrantIndex === 0 || !this.isGuestRegistrationModifiable)) {
            return true;
        }

        return false;
    }

    hasSelectedTickets() {
        if (!this.registrant.ticketList || this.isShowTickets != true) {
            return true;
        }

        for (let ticket of this.registrant.ticketList) {
            if (ticket.isSelected) {
                return true;
            }
        }

        return false;
    }
}