import { LightningElement, api } from 'lwc';

export default class Portal_quickaction_PreviewNewsletter extends LightningElement {
    _isCallbackDone = false;
    _recordId = null;

    @api set recordId(value) {
        this._recordId = value;
        this._isCallbackDone = true;
    }

    get recordId() {
        return this._recordId;
    }


   connectedCallback() {

   }


    @api invoke() {

    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}