import { LightningElement, api, track } from 'lwc';
import chevronDown from '@salesforce/resourceUrl/Portal_Chevron_Down';

export default class Portal_Select extends LightningElement {
    @api isShowNullOption = false;
    @api required = false;
    @api label = '';
    @api labelClass = '';
    @api inputName = '';
    @api disabled = false;
    @api classes = 'slds-input slds-combobox__input';
    @api chevronDownStyle = 'background-repeat: no-repeat !important; background-position: right !important; appearance: none;';

    @api
    get defaultValue() {
        return this._defaultValue;
    }

    set defaultValue(value) {
        this._defaultValue = value

        this.setSelectedValue(value);
    }

    @api
    get optionList() {
        return this._optionList;
    }

    set optionList(value) {
        this.setOptionList(value);
    }

    get hasNullOption() {
        return !(this._defaultValue);
    }

    get _labelClass() {
        return this.labelClass;
    }

    get selectStyle() {
        return chevronDown ? 'background-image: url(' + chevronDown + ') !important; ' + this.chevronDownStyle : '';
    }

    @api handleChange = () => {};

    @track _optionList = [];
    @track _defaultValue = '';

    @api checkValidity() {
        let input = this.template.querySelector('select');
        return input.checkValidity();
    }

    @api reportValidity() {
        let input = this.template.querySelector('select');
        return input.reportValidity();
    }

    connectedCallback() {
        this.setOptionList(this._optionList);
    }

    setOptionList(value) {
        if (!value) {
            return;
        }
        let newOptionList = [];

        value.forEach(option => {
            option = Object.assign({}, option);
            option.isSelected = (option.value === this.defaultValue);
            option.key = Date.now() + option.value;

            newOptionList.push(option);
        })
        this._optionList = newOptionList;
    }

    setSelectedValue(value) {
        if (!this._optionList) {
            return;
        }

        for (let eachOption of this._optionList) {
            if (eachOption.value === value) {
                eachOption.isSelected = true;
            } else {
                eachOption.isSelected = false;
            }
            eachOption.key = Date.now() + eachOption.value;
        }
    }
}