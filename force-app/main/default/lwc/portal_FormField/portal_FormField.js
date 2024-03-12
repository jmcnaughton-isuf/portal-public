import { api, LightningElement, track } from 'lwc';
import SERVER_getLookupOptions from '@salesforce/apex/PORTAL_LWC_LookupController.SERVER_getLookupOptions';

export default class Portal_FormField extends LightningElement {
    @api handleValueChange = () => {};

    @api get fieldData() {
        return this._fieldData;
    }

    set fieldData(param) {
        if (!param) {
            return;
        }

        this.value = param.value;

        this._fieldData = param;

        if (this._fieldData.fieldType === 'picklist' && !this._fieldData.picklistValues) {
            this.getPicklistValues();
        } else {
            this._picklistValues = this._fieldData.picklistValues;
        }
    }

    @api get value() {
        return this._value;
    }

    set value(param) {
        this._value = param;

        this.handleValueChange(this.fieldData.fieldId, param);
    }

    get lookupValue() {
        if (!this.fieldData.picklistValues) {
            return this._value;
        }

        for (let picklistValue of this.fieldData.picklistValues) {
            if (picklistValue.value === this._value) {
                return picklistValue;
            }
        }

        return this._value;
    }

    get isPicklist() {
        return this.fieldData && this.fieldData.fieldType === 'picklist';
    }

    get isRichText() {
        return this.fieldData && this.fieldData.fieldType === 'richText';
    }

    get isTextArea() {
        return this.fieldData && this.fieldData.fieldType === 'textarea';
    }

    get isLookup() {
        return this.fieldData && this.fieldData.fieldType === 'lookup';
    }

    _fieldData = {};
    @track _picklistValues;
    _isShowSpinner = false;

    updateValue = (event) => {
        if (this.fieldData.fieldType === 'checkbox') {
            this.value = event.target.checked;
        } else if (this.fieldData.fieldType === 'number') {
            this.value = parseFloat(event.target.value, 10);
        } else {
            this.value = event.target.value;
        }
    }

    @api
    getFieldInfo = () => {
        let result = {value: this._value, fieldId: this.fieldData.fieldId};

        if (this.fieldData.fieldType === 'lookup' && this._value.value) {
            result.value = this._value.value;
        }

        return result;
    }

    get isInputBox() {
        if (this.fieldData && this.fieldData.fieldType) {
            if (this.fieldData.fieldType !== 'picklist'
                    && this.fieldData.fieldType !== 'richtext'
                    && this.fieldData.fieldType !== 'textarea'
                    && this.fieldData.fieldType !== 'lookup') {
                return true;
            }
        }

        return false;
    }

    get isCheckbox() {
        return this.fieldData?.fieldType === 'checkbox';
    }

    get inputClasses() {
        return this.isCheckbox ? 'radio' : 'slds-input';
    }

    get labelStyle() {
        return this.isCheckbox ? 'top: -1px' : '';
    }

    get containerStyle() {
        return this.isCheckbox ? 'display: flex' : '';
    }

    get isShowLookup() {
        return this.fieldData.isLookup && !this.fieldData.isPicklist;
    }

    getPicklistValues() {
        this._isShowSpinner = true;
        SERVER_getLookupOptions({params: {displaySettingList: this.fieldData.displaySettingList,
                                          customMetadataApiName: 'Portal_Section_Field_Setting__mdt',
                                          maxItems: null}})
        .then(result => {
            if (!result || !result[0] || !result[0].Id ){
                this._picklistValues = result;
                this._picklistValues.unshift({label:'Please select a value', value: ''});
                this._isShowSpinner = false;
                return;
            }

            let values = [];
            result.forEach((filterObject) => {
                Object.keys(filterObject).forEach((key) => {
                    if (key !== 'Id') {
                        values.push({label: filterObject[key], value: filterObject.Id});
                    }
                });
            });

            this._picklistValues = values;
            this._picklistValues.unshift({label:'Please select a value', value: ''});

            this._isShowSpinner = false;
        }).catch((e) => {
            console.log(e);
            this._isShowSpinner = false;
        });


    }

    local_handleLookup = (value) => {
        this.value = value;
    }

    @api checkValidity() {
        let input = this.template.querySelector('c-portal_-input');
        if (input) {
            return input.checkValidity();
        }
        return true;
    }

    @api reportValidity() {
        let input = this.template.querySelector('c-portal_-input');
        if (input) {
            input.reportValidity();
        }
    }
}