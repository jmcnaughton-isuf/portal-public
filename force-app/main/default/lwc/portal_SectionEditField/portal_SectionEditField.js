import { LightningElement, api } from 'lwc';
import SERVER_getLookupOptions from '@salesforce/apex/PORTAL_LWC_LookupController.SERVER_getLookupOptions';

export default class Portal_MyInformationEditField extends LightningElement {
    @api inputClasses = '';
    @api labelClasses = '';
    @api selectChevronDownStyle = 'background-repeat: no-repeat !important; background-position: calc(100% - 3px) center !important; background-size: 20px !important; padding-right: 20px !important;';

    get _inputClasses() {
        return "slds-input " + this.inputClasses;
    }

    get _labelClasses() {
        return "slds-form-element__label " + this.labelClasses;
    }

    @api fieldId;
    
    @api get picklistValues() {
        return this._picklistValues;
    }

    // this api setter allows the parent to populate the picklist values, bypassing this LWC's Apex call in the fieldData setter
    // however, ensure that parent LWC HTML assigns picklist-values before field-data, otherwise the Apex call will still happen
    set picklistValues(value) {
        this._picklistValues = value;
    }

    @api get fieldData() {
        return this._fieldData;
    }

    @api checkValidity() {
        if (this.showInputBox) {
            let input = this.template.querySelector('c-portal_-input');
            return input.checkValidity();
        } else if (this.fieldData.isRequired) {
            // the lookup may set value to {label: x, value: y}
            let localValue = this._value?.value ? this._value.value : this._value;
            return localValue;
        }
        return true;
    }

    @api reportValidity() {
        let input = this.template.querySelector('c-portal_-input');
        input?.reportValidity();
    }

    set fieldData(value) {
        this._fieldData = value;
        
        if (value.isPicklist === true && !this.picklistValues?.length > 0) {
            this.getPicklistValues();
        }
    }

    @api handleValueChange = () => {};

    @api get value() {
        return this._value;
    }

    set value(param) {
        this._value = param;

        this.handleValueChange(this.fieldId, param);
    }

    _value = '';
    _fieldData = {};
    _picklistValues = [];
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
    getEditInformation = () => {
        return {value: this._value, fieldId: this.fieldId};
    }

    get showInputBox() {
        if (this.fieldData) {
            return !this.fieldData.isPicklist && !this.fieldData.isLookup && !this.fieldData.isRichText && !this.fieldData.isTextArea
        }

        return true;
    }

    get displaySettingList() {
        if (this.fieldData.isLookup) {
            return [this.fieldData];
        }

        return [];
    }

    get isShowLookup() {
        return this.fieldData.isLookup && !this.fieldData.isPicklist;
    }

    getPicklistValues() {
        let displaySettingList = [Object.assign({}, this.fieldData)];

        displaySettingList[0].isPicklist = false;
        this._isShowSpinner = true;
        SERVER_getLookupOptions({params: {displaySettingList: displaySettingList,
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
}