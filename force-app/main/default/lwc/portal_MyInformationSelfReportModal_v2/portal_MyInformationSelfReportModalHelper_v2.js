import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { getRelativeUrl } from 'c/portal_util_Urls';
import selfReportInformation from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_selfReportInformation';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    build() {
        this.result._lightningElement.selfReportRecord = {...this.result._lightningElement.selfReportRecord};
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;

    get fieldValue() {
        let actualValue = this._lightningElement.selfReportRecord[this._lightningElement.fieldId];
        return actualValue === this._lightningElement.isDeletedValue ? '' : actualValue;
    }

    handleChange(value, fieldId) {
        this._lightningElement.selfReportRecord[fieldId] = value;
    }

    handleLookupSelection(option, fieldId, recordIndex, sectionId, lookupFieldId) {
        this._lightningElement.selfReportRecord[lookupFieldId] = option.value;
    }

    updateToggleValue(event) {
        this.handleChange(event.currentTarget.checked, event.currentTarget.dataset.fieldId);
    }

    handleCancel(event) {
        this._lightningElement.handleClose(undefined);
    }

    handleSave(event) {
        this._lightningElement._isShowSpinner = true;

        if (!this.checkAndReportInputValidity()) {
            this._lightningElement._isShowSpinner = false;
            return;
        }

        let recordToSubmit = this._lightningElement.selfReportRecord;
        if (this._lightningElement.modalType === 'field') {
            recordToSubmit = {};
            let fieldValue = this._lightningElement.selfReportRecord[this._lightningElement.fieldId];
            recordToSubmit[this._lightningElement.fieldId] = fieldValue;

            if (this._lightningElement.fieldId === 'birthdate') {
                recordToSubmit.isBirthdateDeleted = !recordToSubmit.birthdate;
            } else if (!fieldValue) {
                recordToSubmit[this._lightningElement.fieldId] = this._lightningElement.isDeletedValue;
            }
        }

        const params = {...this._lightningElement.saveParams, selfReportRecordMap: recordToSubmit, interimSourceUrl: getRelativeUrl()};
        callApexFunction(this._lightningElement, selfReportInformation, params, (response) => {
            this._lightningElement._isShowSpinner = false;
            this._lightningElement.dispatchEvent(new ShowToastEvent({
                title: 'Success!',
                message: 'Your changes have been saved.',
                variant: 'success',
                mode: 'sticky'
            }));
            this._lightningElement.handleClose(response);
        }, () => {
            this._lightningElement._isShowSpinner = false;
        });
    }

    checkAndReportInputValidity() {
        let editFieldList = this._lightningElement.template.querySelectorAll('c-portal_-My-Information-Edit-Field_v2');
        if (!editFieldList || editFieldList.length === 0) {
            // something is wrong
            return false;
        }

        for (let eachField of editFieldList) {
            let isValid = eachField.checkAndReportValidity();
            if (!isValid) {
                return false;
            }
        }

        return true;
    }
}