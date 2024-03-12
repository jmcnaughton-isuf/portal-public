import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api } from 'lwc';

export default class Portal_NewsletterTemplateSelection extends LightningElement {

    @api templates = [];

    templateChosen(event) {
        let index = event.currentTarget.getAttribute('data-index');
        let template = this.templates[index];
        this.dispatchEvent(new CustomEvent('selected', {detail:JSON.stringify(template)}));
    }
}