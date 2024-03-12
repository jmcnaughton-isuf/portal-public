import { LightningElement, api, track } from 'lwc';

export default class Portal_Input extends LightningElement {
    @api inputStyle = '';
    @api classes = '';
    @api label = '';
    @api labelClass = '';
    @api minLength;
    @api maxLength;
    @api type = 'text';
    @api min = 0;
    @api max;
    @api step;
    @api value = '';
    @api includeClearButton = false;
    @api includeSearchIcon = false;
    @api inputName = '';
    @api disabled = false;
    @api required = false;
    @api checked = false;
    @api index;
    @api placeholder = '';
    @api autocomplete = 'on';
    @api iconStyle = '';

    _stylingForIcons = 'padding-right: 38px !important;';
    
    get _inputStyle() {
        if (this.includeClearButton || this.includeSearchIcon){
            return [this._stylingForIcons, this.inputStyle].join(' ');
        }
    
        if (this.inputStyle) {
            return this.inputStyle;
        }

        return '';
    }

    get _clearButtonStyle() {
        return (this.disabled ? 'input-icon clear-term-search disabled' : 'input-icon clear-term-search');
    }

    @api getCustomValidity() {
        return this._customValidity;
    }

    @api checkValidity() {
        let inputComponent = this.template.querySelector("input");

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

    @api setCustomValidity(value) {
        this._customValidity = value;
        let inputComponent = this.template.querySelector("input");

        if (inputComponent) {
            inputComponent.setCustomValidity(value);
        }
    }

    @api reportValidity() {
        let inputComponent = this.template.querySelector("input");

        if (inputComponent) {
            inputComponent.reportValidity();
        }
    }

    @api setAndReportCustomValidity(value) {
        this._customValidity = value
        let inputComponent = this.template.querySelector("input");

        if (inputComponent) {
            inputComponent.setCustomValidity(value);
            inputComponent.reportValidity();
        }
    }

    @api setFocus() {
        this.template.querySelector('input').focus();
    }

    @api handleClear = () => {}
    @api handleChange = () => {};
    @api handleInput = () => {};
    @api handleKeyUp = () => {};
    @api handleFocus = () => {};
    @api handleBlur = () => {};

    get _labelClass() {
        if (this._isValid) {
            return this.labelClass;
        }

        return this.labelClass + ' invalid'
    }

    @track _isValid = true;
    @track _customValidity = '';

    _handleInput = (event) => {
        this.setCustomValidity('');
        this.handleInput(event);
    };
}