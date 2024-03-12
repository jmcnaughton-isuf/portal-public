import { LightningElement, api, track } from 'lwc';
import SERVER_getPreviewNewsletterHtml from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getPreviewNewsletterHtml';

export default class Portal_NewsletterDetail extends LightningElement {
    @track _processedSampleHTML = '';
    @api newsletterId;
    _newsletterId = '';
    _isShowSpinner = true;

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('rid')) {
            this._newsletterId = urlParams.get('rid');
        } else if (this.newsletterId) {
            this._newsletterId = this.newsletterId;
        }

        this.getPersonalizedHTML();
    }

    getPersonalizedHTML() {
        this._isShowSpinner = true;
        if(this._newsletterId) {
            SERVER_getPreviewNewsletterHtml({params: {newsletterId: this._newsletterId}})
            .then(res => {
                if (res) {
                    this._processedSampleHTML = res;
                } else {
                    this._processedSampleHTML = '<p>Newsletter not found<p>';
                }
                this._isShowSpinner = false;
            })
            .catch(e => {
                console.log(e);
                this._processedSampleHTML = '<p>Newsletter not found<p>';
                this._isShowSpinner = false;
            });
        } else {
            this._processedSampleHTML = '<p>Newsletter not found<p>';
            this._isShowSpinner = false;
        }
    }
}