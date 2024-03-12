import { LightningElement, api, wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import publishDraft from '@salesforce/apex/PORTAL_JobBoardController.SERVER_publishDraft';

export default class portal_quickaction_PublishDraftJob extends LightningElement {
    @api recordId;
    _recordIdAvailable = false;
    _showSpinner = false;

    renderedCallback() {
        if (!this._recordIdAvailable && this.recordId) {
            this._recordIdAvailable = true;
        }
    }

    @api invoke() {

    }

    handleSubmit() {
        this._showSpinner = true;
        publishDraft({params: {recordId: this.recordId}}).then((masterRecordId) => {
            this._showSpinner = false;
            window.location.href = '/' + masterRecordId;
            this.dispatchEvent(new CloseActionScreenEvent());
        }).catch((e) => {
            console.log(e);
            this._showSpinner = false;
            alert(e.body.message);
            this.dispatchEvent(new CloseActionScreenEvent());
        });
    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}