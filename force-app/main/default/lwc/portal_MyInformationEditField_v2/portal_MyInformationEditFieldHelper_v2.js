import { ShowToastEvent } from 'lightning/platformShowToastEvent';
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
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;

    displaySettingList() {
        return [{customMetadataDeveloperName: this._lightningElement.customMetadataDeveloperName}];
    }

    checkAndReportValidity() {
        let input = undefined;

        if (this._lightningElement.isDate || this._lightningElement.isCheckbox) {
            input = this._lightningElement.template.querySelector('input');
        } else if (this._lightningElement.isLookup) {
            input = this._lightningElement.template.querySelector('c-portal_-lookup');
            input.setAndReportCustomValidity('');
        } else if (this._lightningElement.isPicklist) {
            input = this._lightningElement.template.querySelector('c-portal_-select');
        } else {
            input = this._lightningElement.template.querySelector('lightning-input');
        }

        if (input && !input.checkValidity()) {
            input.reportValidity();
            return false;
        }

        if (this._lightningElement.isLookup && this._lightningElement.isRequired && (!this._lightningElement.lookupValue && !this._lightningElement.value.value)) {
            input.setAndReportCustomValidity('Please select an option.');
            return false;
        }

        return true;
    }

    handleChange(event) {
        let newValue = this._lightningElement.isCheckbox ? event.currentTarget.checked : event.currentTarget.value;
        this._lightningElement.value = newValue;
        this._lightningElement.handleChangeCallback(newValue, this._lightningElement.fieldId, this._lightningElement.index, this._lightningElement.sectionId);
    }

    updateToggleValue(event) {
        this._lightningElement.toggleValue = event.currentTarget.checked;
        this._lightningElement.handleChangeCallback(event.currentTarget.checked, this._lightningElement.toggleField, this._lightningElement.index, this._lightningElement.sectionId);
    }

    // option is the selected lookup option of form {value: string, label: string}
    handleLookupSelection(option) {
        // autofill Lookup LWC input using the selected option, handleLookupInput will be called once as a result of this
        this._lightningElement.value = option;
        this._lightningElement._isHideLookupOptions = true;
        this._lightningElement.handleLookupSelectionCallback(option, this._lightningElement.fieldId, this._lightningElement.index, this._lightningElement.sectionId, this._lightningElement.lookupFieldId);
    }

    // lookup's <input> oninput handler
    handleLookupInput(value) {
        this._lightningElement._isHideLookupOptions = false;

        // if the user types or clears input, then any previous lookup selection they made is invalid
        let option = value === this._lightningElement.value?.label ? this._lightningElement.value : {label: value, value: undefined};
        this._lightningElement.handleLookupSelectionCallback(option, this._lightningElement.fieldId, this._lightningElement.index, this._lightningElement.sectionId, this._lightningElement.lookupFieldId);
        this._lightningElement.handleChangeCallback(value, this._lightningElement.fieldId, this._lightningElement.index, this._lightningElement.sectionId);
    }
}