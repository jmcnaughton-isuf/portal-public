import { LightningElement, api } from 'lwc';
import SERVER_getMergeFields from '@salesforce/apex/PORTAL_NewsletterController.SERVER_getMergeFields';
export default class Portal_NewsletterMergeFields extends LightningElement {


    @api recordType;
    @api sobjectType;
    _isCallbackDone = false;
    _data = [];

    connectedCallback() {
        const params = {params:{recordType: this.recordType, sobjectType: this.sobjectType}}
        SERVER_getMergeFields(params).then(res => {
            if (res && res.length > 0) {
                for (let index = 0; index < res.length; index++) {
                    this._data.push({"mergeField":res[index].value});
                }
            }
            this._isCallbackDone = true;
        }).catch(error => {
            console.log(error);
        });
    }

    getSelectedMergeField(event) {
        let mergeField = event.currentTarget.getAttribute('data-id');
        console.log(mergeField);
        if (this.template.querySelector('[data-name="text"]')) {
            let row = this.template.querySelector('[data-name="text"]');
            row.value = mergeField;
            row.focus();
            row.select();
            document.execCommand('copy');
        }
    }
}