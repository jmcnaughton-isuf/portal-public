import { LightningElement, api, track } from 'lwc';
import SERVER_getAllDisplayOptions from '@salesforce/apex/PORTAL_LWC_DirectoryController.SERVER_getAllDisplayOptions';

export default class Portal_DirectoryInputField extends LightningElement {
    @api
    get label() {
        if (!this._label) {
            return 'Enter Value';
        }

        return this._label;
    };

    set label(value) {
        this._label = value;
    }

    @api manuallyApplyValues = false;
    @api get currentSearchSetting() {
        return this._currentSearchSetting;
    }

    set currentSearchSetting(value) {
        this.resetInputValue();

        this._currentSearchSetting = value;
        this._currentValue = {label: "", value: ""};
        if (value && value.Default_Value__c && value.Search_Input_Type__c === 'Text') {
            this.inputText = this._currentSearchSetting.Default_Value__c;
            this._currentValue = {label: this.inputText, value: this.inputText};
        }

        this.setSearchTermOptions();
    }

    @api get currentValue() {return this._currentValue;}

    @api addValueToSearch = () => {};

    @track _currentSearchSetting = {};
    @track _currentValue = {label: "", value: ""};
    @track isLoading = false;
    @track filterOptions = [];
    @track filterValues = [];
    @track inputText = "";
    @track _label = '';

    get isPicklistInputType() {
        if (this.currentSearchSetting) {
            return this.currentSearchSetting.Search_Input_Type__c === 'Picklist';
        }

        return false;
    }

    get isTextInputType() {
        if (this.currentSearchSetting) {
            return this.currentSearchSetting.Search_Input_Type__c === 'Text';
        }

        return false;
    }

    get isLookupInputType() {
        if (this.currentSearchSetting) {
            return this.currentSearchSetting.Search_Input_Type__c === 'Lookup';
        }

        return false;
    }

    get hasLabel() {
        return this.label;
    }

    @api
    getInputValue = () => {
        return this._currentValue;
    }


    connectedCallback() {
        this.setSearchTermOptions();
    }

    setSearchTermOptions() {
        this.filterOptions = [];
        this.filterValues = [];

        if (this.currentSearchSetting && this.currentSearchSetting.staticList) {
            this.setStaticFilterOptions();
        } else if (this.currentSearchSetting && this.currentSearchSetting.Search_Input_Type__c === 'Picklist') {
            this.getAllDisplayOptions();
        }
    }


    setStaticFilterOptions() {
        let filterOptions = [];
        let filterValues = [];
        if (this.currentSearchSetting && this.currentSearchSetting.staticList) {
            if (this.currentSearchSetting.displayList) {
                filterOptions = this.currentSearchSetting.displayList;
            } else {
                filterOptions = this.currentSearchSetting.staticList
            }
            filterValues = this.currentSearchSetting.staticList
        }

        if (!this.currentSearchSetting
                || (this.currentSearchSetting.Search_Input_Type__c !== 'Picklist'
                && this.currentSearchSetting.Search_Input_Type__c !== 'Lookup')) {
            filterOptions = [];
            filterValues = [];
        }

        this.filterOptions = [];

        for (let optionIndex = 0; optionIndex < filterOptions.length; optionIndex++) {
            this.filterOptions[optionIndex] = {label: filterOptions[optionIndex], value: filterValues[optionIndex]}
        }

        this.filterOptions.unshift({label: this.currentSearchSetting.Default_Value__c, value: ""});
    }

    getAllDisplayOptions() {
        this.isLoading = true;
        SERVER_getAllDisplayOptions({params: {displaySettingList : this.currentSearchSetting.displaySettingList,
                                              searchText: this.inputText}})
            .then(result => {
                if (this.currentSearchSetting.displaySettingList[0].isPicklist !== true) {
                    let filterOptions = [];
                    let filterValues = [];
                    // Get the field that's not id dynamically
                    result.forEach((filterObject) => {
                        Object.keys(filterObject).forEach((key) => {
                            if (key !== 'Id' && key !== 'RecordTypeId') {
                                filterOptions.push(filterObject[key]);
                            }
                        });

                        filterValues.push(filterObject.Id);
                    });
                    this.filterOptions = filterOptions;
                    this.filterValues = filterValues;
                } else {
                    let filterOptions = [];
                    let filterObjects = [];

                    result.forEach(picklistValue => {
                        filterOptions.push(picklistValue.label);
                        filterObjects.push(picklistValue.value);
                    })

                    this.filterOptions = filterOptions;
                    this.filterValues = filterObjects;
                }

                for (let optionIndex = 0; optionIndex < this.filterOptions.length; optionIndex++) {
                    this.filterOptions[optionIndex] = {label: this.filterOptions[optionIndex], value: this.filterValues[optionIndex]}
                }

                this.filterOptions.unshift({label: this.currentSearchSetting.Default_Value__c, value: ""});
                this.isLoading = false;
            }).catch(() => {
                this.isLoading = false;
            });
    }


    handleInputTextChange = (event) => {
        this.inputText = event.target.value;
        this._currentValue = {label: this.inputText, value: this.inputText};
    }

    handlePicklistSelection = (event) => {
        this.filterOptions.forEach(option => {
            if (option.value === event.target.value) {
                this._currentValue = Object.assign({}, option);
                this._addValueToSearch(option);
            }
        })
        this.inputText = event.target.value;
    }

    handleApply = () => {
        this._addValueToSearch({label: this.inputText, value: this.inputText});
    }

    @api
    resetInputValue() {
        if (this._currentSearchSetting && this._currentSearchSetting.Default_Value__c && this._currentSearchSetting.Search_Input_Type__c === 'Text') {
            this.inputText = this._currentSearchSetting.Default_Value__c;
        } else {
            this.inputText = '';
        }

        this._currentValue = {label: this.inputText, value: this.inputText};
    }

    handleClear = () => {
        this.inputText = '';

        this._currentValue = {label: this.inputText, value: this.inputText};
    }

    handleLookupOptionSelected = (option) => {
        this._currentValue = Object.assign({}, option);
        this._addValueToSearch(option);
    }

    _addValueToSearch(option) {
        if (this.manuallyApplyValues) {
            return;
        }

        this.addValueToSearch(option);

        if (!this.isLookupInputType) {
            this.resetInputValue();
        }
    }

    handleKeyUp = (event) => {
        if (event.key === 'Enter') {
            this._addValueToSearch(Object.assign({}, this._currentValue));
        }
    }
}