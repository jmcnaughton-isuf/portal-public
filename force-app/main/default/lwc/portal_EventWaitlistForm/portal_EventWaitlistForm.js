import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import waitlistRegistrant  from '@salesforce/apex/PORTAL_LWC_EventWaitlistFormController.SERVER_waitlistRegistrant';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_EventWaitlistForm extends LightningElement {
    @api ticketTypeId;
    @api maxTickets;
    @api closeModal = () => {}

    @api
    get primaryRegistrant() {
        return this._primaryRegistrant;
    }

    set primaryRegistrant(value) {
        this._primaryRegistrant = Object.assign({firstName: '', lastName: '', email: ''}, value);
    }

    @track _isRecaptchaEnabled = false;
    @track _primaryRegistrant;
    @track _numberOfTickets = 1;
    @track _showSpinner;

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_EventWaitlistControllerBase.waitlistRegistrant'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    handleRegistrantInput = (event) => {
        let value = event.target.value;
        let name = event.target.name;

        this._primaryRegistrant[name] = value;
    }

    handleTicketInput = (event) => {
        let value = event.target.value;

        if (!event.target.checkValidity()) {
            event.target.reportValidity();
        }

        this._numberOfTickets = parseInt(value, 10);
    }

    handleSubmitClick() {
        let inputs = this.template.querySelectorAll('c-portal_-input');
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

        if (validity === false) {
            return;
        }

        submitForm(this, this.submissionLogic, (error) => {
            this._showSpinner = false;
            console.log(error);
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        this._showSpinner = true;
        let params = {firstName: this._primaryRegistrant.firstName,
                      lastName: this._primaryRegistrant.lastName,
                      email: this._primaryRegistrant.email,
                      ticketTypeId: this.ticketTypeId,
                      numberOfTickets: this._numberOfTickets,
                      recaptchaToken: recaptchaToken};

        callApexFunction(this, waitlistRegistrant, params, (result) => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'You have successfully waitlisted for the event!',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);

            this.closeModal();
            this._showSpinner = false;
        }, (error) => {
            this._showSpinner = false;
            console.log(error);
            errorRecaptchaCallback();
        });
    }
}