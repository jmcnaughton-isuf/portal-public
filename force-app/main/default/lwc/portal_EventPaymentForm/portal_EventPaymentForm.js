import { LightningElement, api} from 'lwc';

export default class Portal_EventPaymentForm extends LightningElement {
    @api addressRequired;
    @api primaryRegistrant;
    @api handleInput = () => {};

    @api isShowBillingInformation;

    @api checkInputValidity() {
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

        return validity;

    }

}