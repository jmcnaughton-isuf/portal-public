import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import blackHighlightUrl from '@salesforce/resourceUrl/Portal_HighlightOffBlack24' 

export default class Portal_lwc_DirectorySearchRow extends LightningElement {
    @api index = 0;
    @api searchCriteria;
    @api searchCategory;
    @api searchSettingList;

    @api get selectedOptionList() {
        return this._selectedOptionList;
    }

    set selectedOptionList(value) {
        this._selectedOptionList = value;
        this.getOptions();
    }


    @api handleSearchCriteriaChange = () => {}
    @api handleDeleteSearchTerm = () => {}

    _blackHighlightResourceUrl = blackHighlightUrl

    @track options = [];
    @track allOptions = [];
    @track filterOptions = [];
    @track filterValues = [];
    @track lookupText = "";
    @track address;
    @track currentSearchSetting = {};
    @track valueListSelected = [];

    @track _selectedOptionList = [];

    get searchCriteriaName() {
        if (this.currentSearchSetting) {
            return this.currentSearchSetting.Search_Criteria_Name__c;
        }

        return '';
    }

    get hasOptions() {
        if (this.options && this.options.length > 0) {
            return true;
        }

        return false;
    }

    get isFirstIndex() {
        return this.index === 0;
    }

    get hasOneOptionInCategory() {
        if (this.searchCategory) {
            return this.searchCategory.Has_Single_Search_Criteria__c;
        }

        return false;
    }

    get hasMultipleFields() {
        if (this.searchCriteria && this.searchCriteria.subSettingList) {
            return true;
        }

        return false;
    }

    connectedCallback() {
        this.getOptions();

        let searchForSelected = this.searchCriteria.searchForSelected;

        // Set search criteria if only one option is available (besides the default option)
        if (this.options.length === 2) {
            searchForSelected = this.options[1].value;
        }

        let searchSettingName = searchForSelected;
        if (searchSettingName) {
            this.searchSettingList.forEach((searchSetting) => {
                if (searchSetting.Search_Criteria_Name__c === searchSettingName) {
                    this.currentSearchSetting = searchSetting;
                }
            })
        }

        this.handleSearchCriteriaChange({searchForSelected: searchForSelected}, this.index);
    }

    getOptions() {
        let options = [];

        this.searchSettingList.forEach((searchSetting) => {
            options.push({label: searchSetting.Search_Criteria_Name__c, value: searchSetting.Search_Criteria_Name__c});
        });

        options.unshift({label: 'Select Criteria', value: ''});
        this.allOptions = options;
        this.options = options;

        this.setFilteredOptions();
    }

    setFilteredOptions() {
        let options = [];
        let selectedOption = this.searchCriteria;

        if (this.searchCriteria) {
            selectedOption = this.searchCriteria.searchForSelected;
        }

        if (this.selectedOptionList.length === 0) {
            return
        }

        this.allOptions.forEach(option => {
            if (!this.selectedOptionList.includes(option.value, 0) || (selectedOption && option.value === selectedOption)) {
                options.push(option);
            }
        });
        this.options = options;
    }

    handleSearchForChange = (event) => {
        let searchSettingName = event.currentTarget.value;

        // Propogate search criteria upwards
        let newSearchCriteria = this.getResettedSearchCriteria();
        newSearchCriteria.searchForSelected = searchSettingName;

        this.handleSearchCriteriaChange(newSearchCriteria, this.index);

        this.currentSearchSetting = null;

        this.searchSettingList.forEach((searchSetting) => {
            if (searchSetting.Search_Criteria_Name__c === searchSettingName) {
                this.currentSearchSetting = searchSetting;
            }
        })
    }


    getResettedSearchCriteria() {
        let newSearchCriteria = Object.assign({}, this.searchCriteria);

        newSearchCriteria.valueList = [];
        newSearchCriteria.displayValue = [];
        newSearchCriteria.zipCode = '';
        newSearchCriteria.distance = '';
        newSearchCriteria.searchForSelected = '';

        this.valueListSelected = [];

        return newSearchCriteria;
    }

    handleInputTextChange = (event) => {
        this.inputText = event.target.value;
    }

    handlePicklistSelection = (event) => {
        this.filterOptions.forEach(option => {
            if (option.value === event.target.value) {
                this.addValueToSearch(option);
            }
        })
    }

    handleMultiValueApply = () => {
        let displayValue = "";
        let inputFields = this.template.querySelectorAll('c-portal_-directory-input-field');

        let labelToSearchCriteriaMap = {};
        this.searchCriteria.subCriteriaList.forEach(subCriteria => {
            labelToSearchCriteriaMap[subCriteria.searchForSelected] = subCriteria;
        });

        let subCriteriaList = [];

        if (!this.isValidMultiApplyValue(inputFields)) {
            return;
        }

        for (let inputIndex = 0; inputIndex < inputFields.length; inputIndex++) {
            let inputField = inputFields[inputIndex];

            if (displayValue && inputField.currentValue.label) {
                displayValue = displayValue + '; ';
            }

            displayValue = displayValue + inputField.currentValue.label;
            let value = inputField.currentValue.value;

            let newSearchCriteria = Object.assign({}, labelToSearchCriteriaMap[inputField.label]);
            newSearchCriteria.valueList = [...newSearchCriteria.valueList];
            newSearchCriteria.valueList.push(value);

            subCriteriaList.push(newSearchCriteria);
            inputField.resetInputValue();
        }

        this.valueListSelected.push(displayValue);
        this.handleSearchCriteriaChange({subCriteriaList: subCriteriaList}, this.index);
    }

    isValidMultiApplyValue(inputFields) {
        if (this.isMultiValueApplyAlreadySelected(inputFields)) {
            return false;
        }

        if (this.isGeolocationSearch()) {
            return this.isGeolocationEntryValid(inputFields);
        }

        return true;
    }

    isMultiValueApplyAlreadySelected(inputFields) {
        if (!this.searchCriteria.subCriteriaList || !this.searchCriteria.subCriteriaList.length) {
            return false;
        }

        let labelToSearchCriteriaMap = {};
        let labelToInputValueMap = {}
        this.searchCriteria.subCriteriaList.forEach(subCriteria => {
            labelToSearchCriteriaMap[subCriteria.searchForSelected] = subCriteria;
        });

        for (let inputField of inputFields) {
            labelToInputValueMap[inputField.label] = inputField.currentValue.value;
        }

        let totalValues = this.searchCriteria.subCriteriaList[0].valueList.length;

        for (let index = 0; index < totalValues; index++) {
            let isMatching = true;
            for (let eachLabel in labelToInputValueMap) {
                let searchCriteria = labelToSearchCriteriaMap[eachLabel];
                let inputValue = labelToInputValueMap[eachLabel];

                if (searchCriteria.valueList[index] !== inputValue) {
                    isMatching = false;
                }
            }

            if (isMatching) {
                return true;
            }
        }

        return false;
    }

    isGeolocationSearch() {
        if (!this.searchCriteria.subSettingList || !this.searchCriteria.subSettingList.length) {
            return false;
        }

        if (this.searchCriteria.subSettingList[0].Geolocation_Address_Input__c) {
            return true;
        }

        return false;
    }

    isGeolocationEntryValid(inputFields) {
        let labelToSettingMap = {};
        this.searchCriteria.subSettingList.forEach(eachSubSetting => {
            labelToSettingMap[eachSubSetting.Search_Criteria_Name__c] = eachSubSetting;
        });

        let locationObject = {};
        for (let inputIndex = 0; inputIndex < inputFields.length; inputIndex++) {
            let inputField = inputFields[inputIndex];

            let value = inputField.currentValue.value;
            let subSetting = labelToSettingMap[inputField.label];

            locationObject[subSetting.Geolocation_Address_Input__c] = value;
        }

        if (!this.isValidLocationObject(locationObject)) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'The location provided is invalid. Please ensure that the location is not empty and if distance is populated, the city or postal code is also populated.',
                variant:"error",
                mode:"sticky"
            });

            this.dispatchEvent(event);

            return false;
        }

        return true;
    }

    isValidLocationObject(locationObject) {
        if (locationObject.Distance) {
            return locationObject.City || locationObject['Postal Code']
        }

        if (!locationObject.City && !locationObject.State && !locationObject.Country && !locationObject['Postal Code']) {
            return false;
        }

        return true;
    }

    handleClear = () => {
        this.inputText = '';
    }

    handleRemoveValue(event) {
        let index = event.currentTarget.dataset.index;
        this.removeValueFromSearch(index);

        if (this.currentSearchSetting.Search_Input_Type__c === 'Picklist') {
            this.template.querySelector('c-portal_-directory-input-field').resetInputValue();
        }
    }

    handleLookupOptionSelected = (option) => {
        this.addValueToSearch(option);
    }

    addValueToSearch = (option) => {
        if (!option || !option.value || this.searchCriteria.valueList.includes(option.value)) {
            return;
        }

        this.valueListSelected.push(option.label);
        let searchCriteriaValues = [...this.searchCriteria.valueList];

        searchCriteriaValues.push(option.value);
        this.handleSearchCriteriaChange({valueList: searchCriteriaValues}, this.index);
    }

    removeValueFromSearch(index) {
        this.valueListSelected.splice(index, 1);
        if (this.hasMultipleFields) {
            let subCriteriaList = [];
            this.searchCriteria.subCriteriaList.forEach(subCriteria => {
                let searchCriteriaValues = [...subCriteria.valueList];
                searchCriteriaValues.splice(index, 1);
                let newSubCriteria = Object.assign({}, subCriteria);

                newSubCriteria.valueList = searchCriteriaValues;
                subCriteriaList.push(newSubCriteria);
            });

            this.handleSearchCriteriaChange({subCriteriaList: subCriteriaList}, this.index);
            return;
        }

        let searchCriteriaValues = [...this.searchCriteria.valueList];

        searchCriteriaValues.splice(index, 1);
        this.handleSearchCriteriaChange({valueList: searchCriteriaValues}, this.index);
    }

    handleKeyUp = (event) => {
        if (event.key === 'Enter') {
            this.handleMultiValueApply();
        }
    }
}