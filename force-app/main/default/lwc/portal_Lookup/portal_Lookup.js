import { LightningElement, api, track } from 'lwc';
import SERVER_getLookupOptions from '@salesforce/apex/PORTAL_LWC_LookupController.SERVER_getLookupOptions';

export default class Portal_Lookup extends LightningElement {
    @api allLookupOptions = [];
    @api getCustomLookupOptions;
    @api customMetadataApiName = '';
    @api label;
    @api maxItems = 5;
    @api maxLength;
    @api minCharToLookup = 3;
    @api waitTime = 800;
    @api clearList;
    @api defaultWhereClause;
    @api orderByField;
    @api required = false;
    @api disabled = false;
    @api placeholder = '';
    @api hasSearchIcon = false;
    @api hideClearButton = false;
    @api classes = 'slds-input';
    @api isShowSpinner;
    @api isHideOptionsOnBlur = false;
    @api isHideOptionsAfterSelection = false;
    @api iconStyle = '';
    @api dropdownStyle = '';

    @api handleChange = () => {};
    @api handleLookupOptionSelected = () => {};
    @api handleKeyUp = () => {};
    @api handleInputFocus = () => {};
    @api handleInputBlur = () => {};

    @api get inputValue() {
        return this._inputValue;
    }

    set inputValue(value) {
        if (value === this.value) {
            return;
        }
        this._valueObject = null;
        if (value) {
            if (value.value) {
                this._valueObject = value;
                this._inputValue = value.label;
            } else {
                this._inputValue = value;
            }
        } else {
            this._inputValue = '';
        }

        this.handleChange(this._inputValue);

        if (!this._valueObject) {
            this.handleLookup();
        }
    }

    @api get displaySettingList() {
        return this._displaySettingList;
    }

    set displaySettingList(value) {
        this._displaySettingList = value;

        this._lookupOptionsToDisplay = [];
    }

    @api checkValidity() {
        let input = this.template.querySelector('c-portal_-input');
        return input.checkValidity();
    }

    @api reportValidity() {
        let input = this.template.querySelector('c-portal_-input');
        input.reportValidity();
    }

    @api setAndReportCustomValidity(value) {
        let input = this.template.querySelector('c-portal_-input');
        input.setAndReportCustomValidity(value);
    }

    @api setFocusOnInput() {
        this.template.querySelector('c-portal_-input').setFocus();
    }
    
    @track _valueObject;
    @track _inputValue = '';
    @track _isLoadingLookupOptions = false;
    @track _lookupOptionsToDisplay = [];
    @track _displaySettingList = [];

    _numberOfOperations = 0;
    _numberOfOperationsAtLastSearch = 0;


    // necessary bc @api variables cannot have true as the default value
    get hasClearButton() {
        return !this.hideClearButton;
    }

    get hasLookupOptionsToDisplay() {
        if (this._lookupOptionsToDisplay && this._lookupOptionsToDisplay.length !== 0 && !this.clearList) {
            return true;
        }
        return false;
    }

    get hasLabel() {
        if (this.label) {
            return true;
        }

        return false;
    }

    get isDisabled() {
        if (this.disabled) {
            return true;
        }

        if (this._valueObject) {
            return true;
        }

        return false;
    }

    get _isShowSpinner() {
        return this.isShowSpinner || this._isLoadingLookupOptions;
    }

    handleInputValueChange = (event) => {
        this.inputValue = event.target.value;
    }

    handleInputValueClear = () => {
        this.inputValue = '';
    }

    handleLookup() {
        this._numberOfOperations++;
        let operationsBeforeWait = this._numberOfOperations;

        if (!this._inputValue || this._inputValue.length < this.minCharToLookup) {
            this._lookupOptionsToDisplay = [];
            return;
        }

        // Timeout needed for waiting on lookup
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setTimeout(() => {
            if (operationsBeforeWait >= this._numberOfOperations && this._inputValue.length >= this.minCharToLookup
                    && this._numberOfOperationsAtLastSearch !== this._numberOfOperations) {
                this.getLookupOptions(operationsBeforeWait);
            }
        }, this.waitTime);
    }

    getLookupOptions(operationsBeforeWait) {
        this._numberOfOperationsAtLastSearch = operationsBeforeWait;

        if (!this.inputValue) {
            this._lookupOptionsToDisplay = [];
            return;
        }

        if (this.allLookupOptions && this.allLookupOptions.length !== 0) {
            this._lookupOptionsToDisplay = this.getLookupOptionsToDisplayFromStaticList();
        } 
        else if (this.getCustomLookupOptions) {
            this.getCustomLookupOptions(this.inputValue)
            .then((result) => {
                this._lookupOptionsToDisplay = result;
            });
        }
        else {
            this.queryAndSetLookupOptionsToDisplay();
        }
    }

    getLookupOptionsToDisplayFromStaticList() {
        let values = [];

        for (let itemIndex = 0; itemIndex < this.allLookupOptions.length; itemIndex++) {
            let item = this.allLookupOptions[itemIndex];

            if (item.label.toLowerCase().startsWith(this.inputValue.toLowerCase())) {
                values.push(item);
            }

            if (values.length === this.maxItems) {
                break;
            }
        }

        return values;
    }

    queryAndSetLookupOptionsToDisplay() {
        this._isLoadingLookupOptions = true;
        SERVER_getLookupOptions({params: {displaySettingList: this.displaySettingList,
                                          customMetadataApiName: this.customMetadataApiName,
                                          searchText: this._inputValue,
                                          maxItems: this.maxItems}})
        .then(result => {
            if (this.displaySettingList[0].isPicklist === true) {
                this._lookupOptionsToDisplay = result;
                return;
            }

            let values = [];
            result.forEach((filterObject) => {
                Object.keys(filterObject).forEach((key) => {
                    // Also excluding RecordTypeId field since if filter clause
                    // checks on RecordType, RecordTypeId is automatically included
                    if (key !== 'Id' && key !== 'RecordTypeId') {
                        values.push({label: filterObject[key], value: filterObject.Id});
                    }
                });
            });

            this._lookupOptionsToDisplay = values;

            this._isLoadingLookupOptions = false;
        }).catch((e) => {
            this._isLoadingLookupOptions = false;
        });
    }

    async handleLookupOptionClick(event) {
        let clickedOption = {label: event.target.dataset.label,
                             value: event.target.dataset.value}
        let result = await this.handleLookupOptionSelected(clickedOption);
        if (result) {
            this._lookupOptionsToDisplay = result;
        } else if (this.isHideOptionsAfterSelection) {
            this._lookupOptionsToDisplay = [];
        }
    }

    _handleKeyUp = (event) => {
        if (event.key === 'Enter') {
            this.handleEnterKeyPress();
        }

        this.handleKeyUp(event);
    }

    handleEnterKeyPress() {
        let inputComponent = this.template.querySelector("c-portal_-input");

        if (this._numberOfOperations !== this._numberOfOperationsAtLastSearch && this._inputValue.length >= this.minCharToLookup) {
            this.getLookupOptions(this._numberOfOperations);
        } else if (this._lookupOptionsToDisplay && this._lookupOptionsToDisplay.length === 1) {
            this.handleLookupOptionSelected(this._lookupOptionsToDisplay[0]);
        } else if (!this._lookupOptionsToDisplay ||  this._lookupOptionsToDisplay.length === 0) {
            inputComponent.setAndReportCustomValidity('Invalid Value');
        } else if (this._lookupOptionsToDisplay.length > 1) {
            inputComponent.setAndReportCustomValidity('Pick a value from the drop down list below');
        }
    }

    _handleInputFocus = () => {
        if (!this.isHideOptionsOnBlur) {
            return;
        }
        
        setTimeout(() => {
            this.clearList = false;
        }, 175);
        this.handleInputFocus();
    }
    
    _handleInputBlur = () => {
        // clicking an suggestion counts as a blur/losing focus, and the blur event happens before the suggestion click event
        if (!this.isHideOptionsOnBlur) {
            return;
        }
        
        setTimeout(() => {
            this.clearList = true;
        }, 175); // a timeout is needed such that option list can have a chance to be filled before closed
        this.handleInputBlur();
    }
}