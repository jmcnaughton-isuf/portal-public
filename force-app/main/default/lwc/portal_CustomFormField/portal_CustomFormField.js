import { LightningElement, api, track } from 'lwc';

export default class Portal_CustomFormField extends LightningElement {
    @api type;
    @api label;
    @api isRequired;
    @api labelClass = '';
    @api picklistValues;
    @api defaultValue;
    @api multiPicklistDefaultValues;
    @api disabled;
    @api value;
    @api variant = "label-hidden";
    @api handleOnChange = (event) => {};
    @api index;
    _value = '';
    _checked;

    @track _isValid = true;

    get returnFalse() {
        return false;
    }

    get isCheckbox() {
        return this.type == 'Checkbox';
    }

    get isShowLabel() {
        return this.label && !this.isCheckbox;
    }

    get isText() {
        return this.type == 'Text';
    }

    get isPicklist() {
        return this.type == 'Picklist';
    }

    get isMultiPicklist() {
        return this.type == 'Multi-Picklist';
    }

    get isRequiredNonCheckbox() {
        return this.isRequired && !this.isCheckbox
    }

    get _labelClass() {
        if (this._isValid) {
            return this.labelClass;
        }

        return this.labelClass + ' invalid';
    }

    get inputComponentFromType() {
        if (this.type == 'Checkbox' || this.type == 'Text') {
            return this.template.querySelector('lightning-input');
        } else if (this.type == 'Picklist') {
            return this.template.querySelector('lightning-combobox');
        } else {
            return this.template.querySelector('lightning-dual-listbox');
        }
    }

    connectedCallback() {
        if (this.defaultValue) {
            if (this.type == 'Checkbox') {
                this._checked = this.defaultValue;
            } else {
                this._value = this.defaultValue;
            }

        } else if (this.multiPicklistDefaultValues && this.multiPicklistDefaultValues.length > 0) {
            this._value = this.multiPicklistDefaultValues;
        }
    }

    valueChanged = (event) => {
        this.handleOnChange(event, this.label);
        if (this.type == 'Checkbox') {
            this._checked = event.currentTarget.checked;
        } else {
            this._value = event.currentTarget.value;
        }
    }

    @api checkValidity() {
        let inputComponent = this.inputComponentFromType;

        if (inputComponent) {
            if (inputComponent.checkValidity()) {
                this._isValid = true;
                return true;
            }

            this._isValid = false;
            return false;
        }

        return true;
    }

    @api reportValidity() {
        let inputComponent = this.inputComponentFromType;

        if (inputComponent) {
            console.log(inputComponent.type);
            inputComponent.reportValidity();
        }
    }

}