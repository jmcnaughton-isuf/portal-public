import { api, LightningElement, track } from 'lwc';

export default class Portal_Form extends LightningElement {
    @api handleValueChange = () => {}
    @api get formData() {
        return this._formData;
    }

    set formData(param) {
        this._formData = param

        if (param.formRowList) {
            this._recordList = [...param.formRowList]
        }
    }

    @track valueChangeMap = {};
    @track _formData = {};
    @track _recordList = [];

    @api getFormInfo() {
        let result = {};
        let thisFormInfo = this.getThisFormInfo();
        let subFormInfo = this.getSubFormInfo();

        if (subFormInfo) {
            result = subFormInfo;
        }

        if (thisFormInfo) {
            result[this.formData.formId] = thisFormInfo;
        }

        return result;
    }

    getFormList() {
        return this.template.querySelectorAll('c-portal_-Form');
    }

    getFormRecordList() {
        return this.template.querySelectorAll('c-portal_-Form-Record');
    }

    getThisFormInfo() {
        let result = [];

        let formRecordList = this.getFormRecordList();

        if (!formRecordList) {
            return result;
        }

        for (let record of formRecordList) {
            let recordInfo = record.getFormRecordInfo();

            if (!recordInfo) {
                continue;
            }

            result.push(recordInfo);
        }

        return Object.values(result);
    }

    getSubFormInfo() {
        let result = {};

        let formList = this.getFormList();

        if (!formList) {
            return result;
        }

        for (let form of formList) {
            let formInfo = form.getFormInfo();

            console.log(JSON.stringify(formInfo));

            if (!formInfo) {
                continue;
            }

            result = Object.assign(result, formInfo);
        }

        return result;
    }

    handleAddRecord(event) {
        let newRecord = [];

        for (let formField of this.formData.formRowList[0].formFieldList) {
            let newFormField = Object.assign({}, formField);

            newFormField.value = null;

            console.log(JSON.stringify(newFormField));
            newRecord.push(newFormField);
        }

        this._recordList.push({formFieldList: newRecord});
    }

    handleDeleteRecord(event) {
        let recordIndex = event.target.dataset.index;

        this._recordList[recordIndex].isDeleted = true;
    }

    local_handleValueChange = (index, fieldId, value) => {
        // console.log(index, fieldId, value)
        this.handleValueChange(this.formData.formId, index, fieldId, value);
    }

    @api
    checkFormValidity() {
        let formRecordList = this.getFormRecordList();
        for (let eachFormRecord of formRecordList) {
            if (!eachFormRecord.checkFormRecordValidity()) {
                return false;
            }
        }
        return true;
    }

    @api
    reportFormValidity() {
        let formRecordList = this.getFormRecordList();
        for (let eachFormRecord of formRecordList) {
            eachFormRecord.reportFormRecordValidity();
        }
    }
}