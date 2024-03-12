import { LightningElement, api } from 'lwc';

export default class Portal_MyInformationEditField extends LightningElement {
    @api isToggled;
    @api isPicklist;
    @api label;
    @api picklistValues;
    @api value;
    @api isDisabled;
    @api index;
    @api fieldName;
    @api fieldType;
    @api inputType;
    @api changeSetValue;
    @api toggleValue;
    @api toggleField;
    @api isLookup;
    @api lookupField;
    @api displaySettingList;
    @api lookupValue;
    @api customMetadataApiName;
    @api isRequired;
    @api picklistClass = '';
    @api lookupClass = '';
    @api isNullOptionDisabled;
    @api handleChange = (value, index, fieldType) => {};
    @api handleLookupAdditionalInfo = () => {};
    @api handleToggleChange = () => {};

    _lookupValue;
    _lookupLabel;
    _toggleValue;
    _value;
    _changeSetValue;
    _clearList = true;
    _lookupLabelSet = true;

    connectedCallback() {
        this._value = this.value;
        this._toggleValue = this.toggleValue;
        this._lookupLabel = this.value;
        this._lookupValue = this.lookupValue;

    }

    @api checkValidity() {
        if (this.inputBoxIsLookup) {
            let input = this.template.querySelector('c-portal_-lookup');
            return input.checkValidity();

        } else if (this.showInputBox && this.isCheckbox || this.showInputBox && this.isDate) {
            let input = this.template.querySelector('input');
            return input.checkValidity();
        } else if (this.showInputBox) {
            let input = this.template.querySelector('lightning-input');

            if (this.inputType === 'email') {
                return this.isEmailInputValid(input);
            }

            return input.checkValidity();
        } else if (this.isPicklist) {
            let input = this.template.querySelector('c-portal_-select');
            return input.checkValidity();
        }

        return true;
    }

    @api reportValidity() {
        if (this.inputBoxIsLookup) {
            let input = this.template.querySelector('c-portal_-lookup');
            return input.reportValidity();

        } else if (this.showInputBox && this.isCheckbox) {
            let input = this.template.querySelector('input');
            return input.reportValidity();
        } else if(this.showInputBox) {
            let input = this.template.querySelector('lightning-input');
            return input.reportValidity();
        } else if (this.isPicklist) {
            let input = this.template.querySelector('c-portal_-select');
            return input.reportValidity();
        }

        return true;
    }

    @api
    setValue(value) {
        this._value = value;
        this._changeSetValue = this.changeSetValue;
    }

    @api
    getValue(){
        return this._value;
    }

    get _picklistClass() {
        return this.picklistClass;
    }

    get _lookupClass() {
        let defaultLookupClass = 'slds-p-top_large slds-p-bottom_large';

        if (this.lookupClass == 'none') {
            return '';
        } else {
            return defaultLookupClass;
        }
    }

    get isCheckbox() {
        return this.inputType == 'checkbox';
    }

    get isDate() {
        return this.inputType == 'date';
    }

    get isNullOptionEnabled() {
        // Passing in a inverse so that by default
        // if the value is missing, then null option
        // would be included for default picklists
        return (!this.isNullOptionDisabled || this.isNullOptionDisabled == 'false')
    }

    // stole this from new user login
    isEmailInputValid(input) {
        let validity = true;

        let emailValue = this._value;

        // Email validation regex, this would accept any string that follows the rules of:
        // Must have non-empty name and domain strings separated by a single '@' character (cannot have more than 1 '@')
        // Domain string must also have two non-empty strings separated by a '.', such as name@domain.part
        const validEmailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailValue.match(validEmailRegex)) {
            input.setCustomValidity('Please enter a valid email address (Example: \'email@example.com\').');
            validity = false;
        } else {
            input.setCustomValidity('');
        }

        return validity;
    }

    // fireEvent = this.debounce(function(){
    //         if (this.eventType) {
    //             let customEvent = new CustomEvent(this.eventType, {index: this.index, fieldName : this.fieldName});
    //             this.dispatchEvent(customEvent);
    //         }
    //     }, 1000);


    // debounce(func, timer, immediate) {
    //     var timeout;
    //     return function() {
    //         var context = this;
    //         var args = arguments;
    //         var later = function() {
    //             timeout = null;
    //             if (!immediate) {
    //                 func.apply(context, args);
    //             }
    //         }
    //         var callNow = immediate && !timeout;
    //         clearTimeout(timeout);
    //         timeout = setTimeout(later, timer);
    //         if (callNow) {
    //             func.apply(context, args);
    //         }
    //     }
    // }

    updateValue = (event) => {
        if (this.inputType == 'checkbox') {
            this._value = event.target.checked;
        } else {
            this._value = event.target.value;
        }
        this._changeSetValue = this.changeSetValue;
        this.handleChange(this._value, this.index, this.fieldType, this.inputType);

    }

    updateToggleValue (event) {
        this._toggleValue = event.target.checked;
        this._changeSetValue = this.changeSetValue;

        this.handleToggleChange(this._toggleValue, this.toggleField, this.index, this.fieldType)
    }

    @api
    getEditInformation() {
        if (this.isLookup) {
            this._value = this.template.querySelector('c-portal_-lookup').inputValue;
            if (this._value != this._lookupLabel) {
                this._lookupValue = null;
            }
        }
        if (this.toggleField && !this._toggleValue) {
            this._toggleValue = false;
        }
        return {value: this._value, index:this.index, fieldName:this.fieldName, fieldType: this.fieldType, changeSetValue : this._changeSetValue, toggleValue: this._toggleValue, toggleField: this.toggleField, lookupValue: this._lookupValue, lookupField: this.lookupField};
    }

    get inputBoxIsLookup() {
        return !this.isPicklist && this.isLookup;
    }

    get showInputBox() {
        return !this.isPicklist && !this.isLookup;
    }

    handleLookup = (option) => {
        if (option && option.value) {
            this._lookupLabel = option.label;
            this._lookupValue = option.value;
            this._value = option.label;
            this.handleLookupAdditionalInfo(option, this.fieldName, this.index, this.fieldType);
        }
        this._clearList = true;
        this._lookupLabelSet = true;
    }

    handleLookupChange = (value) => {
        if (this._lookupLabelSet) {
            this._clearList = true;
            this._lookupLabelSet = false;
        } else {
            this._clearList = false;
        }
        this._value = value;
        this._changeSetValue = this.changeSetValue;

        if (this.fieldType == "School_Degree_Information") {  // this is currently used for report update for school degree
            this.handleChange(value, this.lookupField, this.fieldType);
        }
    }
}