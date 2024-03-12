import IsRecurrence from '@salesforce/schema/Task.IsRecurrence';
import { api, LightningElement } from 'lwc';

export default class Portal_FormRecord extends LightningElement {
    @api formFieldList;
    @api index;
    @api isDeleted;
    @api handleValueChange = () => {}

    get recordClass() {
        let cssClass = 'flex-grid-1 solo';

        if (this.isDeleted) {
            cssClass = cssClass + ' slds-hide';
        }

        return cssClass;
    }

    getFormFieldList() {
        return this.template.querySelectorAll('c-portal_-Form-Field');
    }

    @api
    getFormRecordInfo = () => {
        let result = {formData : {}};

        let formFieldList = this.getFormFieldList();

        if (!formFieldList) {
            return result;
        }

        for (let element of formFieldList) {
            let fieldInfo = element.getFieldInfo();

            if (!fieldInfo) {
                continue;
            }

            result.formData[fieldInfo.fieldId] = fieldInfo.value;
        }

        if (this.isDeleted) {
            result.isDeleted = true;
        }

        return result;
    }

    local_handleValueChange = (fieldId, value) => {
        this.handleValueChange(this.index, fieldId, value);
    }

    @api 
    checkFormRecordValidity() {
        let formFieldList = this.getFormFieldList();
        for (let eachFormField of formFieldList) {
            if (!eachFormField.checkValidity()) {
                return false;
            }
        }
        return true;
    }

    @api
    reportFormRecordValidity() {
        let formFieldList = this.getFormFieldList();
        for (let eachFormField of formFieldList) {
            eachFormField.reportValidity();
        }
    }
}