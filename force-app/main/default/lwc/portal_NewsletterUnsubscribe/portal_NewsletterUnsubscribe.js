import { LightningElement, track } from 'lwc';
import SERVER_unsubscribeFromNewsletter from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_unsubscribeFromNewsletter';

export default class Portal_NewsletterUnsubscribe extends LightningElement {
    _isShowSpinner = false;
    _isShowUnsubscribe = true;
    _cid = '';
    _email = '';

    @track _richTextMessage = '';
    _confirmRichTextMessage = '<p>Do you want to unsubscribe from all mailing lists?<br><br>If you want to unsubscribe from individual mailing lists, log in and manage your club and group preferences <a href="edit-zone-memberships">here</a>.</p>';
    _successRichTextMessage = '<p>You have successfully unsubscribed from all mailing lists.</p>';
    _errorRichTextMessage = '<p>An error occurred while unsubscribing.</p>.';

    connectedCallback() {
        this._richTextMessage = this._confirmRichTextMessage;

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('cid')) {
            this._cid = urlParams.get('cid');
        }

        if (urlParams.get('email')) {
            this._email = urlParams.get('email');
        }
    }

    handleUnsubscribe(event) {
        this._isShowUnsubscribe = false;
        this._isShowSpinner = true;
        const params = {params: {'id': this._cid, 'contactEmail': this._email}};

        SERVER_unsubscribeFromNewsletter(params).then(res => {
            this._richTextMessage = this._successRichTextMessage;
        }).catch(error => {
            this._richTextMessage = this._errorRichTextMessage;
        }).finally(() => {
            this._isShowSpinner = false;
        })
    }
}