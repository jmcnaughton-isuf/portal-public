import { LightningElement, api, track } from 'lwc';
import blackHighlightUrl from '@salesforce/resourceUrl/Portal_HighlightOffBlack24' 

export default class Portal_lwc_DirectorySearchCategory extends LightningElement {
    @api searchGroupOptionsMap = {};
    @api searchGroup = {};
    @api categoryIndex = 0;

    @api handleSearchGroupChange = () => {};
    @api handleDeleteSearchCategory = () => {};

    _blackHighlightResourceUrl = blackHighlightUrl

    @track options = [];
    @track selectedGroupValue;
    @track searchCriteriaList;
    @track searchCategory;
    @track selectedOptions = [];
    @track currentSearchSettingList;

    @api
    get isFirstCategory() {
        return this.categoryIndex === 0;
    }

    @api
    get isLocationSearch() {
        if (this.searchGroup.objectApiName === 'ucinn_ascendv2__Address_Relation__c') {
            return true;
        }

        return false;
    }

    get isDisplayCriteriaWithCategoryPicklist() {
        if (this.searchCategory
                && this.searchCategory.Has_Single_Search_Criteria__c
                && this.currentSearchSettingList
                && this.currentSearchSettingList.length === 1) {
            return true;
        }

        return false;
    }

    get isShowAddSearchCriteria() {
        // Don't show Add Search Criteria button if there is no category selected (denoeed if there is no search criteria)
        if (!this.searchCriteriaList || this.searchCriteriaList.length < 1) {
            return false;
        }

        // Don't show add search criteria if the selected options is the same as the total options
        if (this.searchCriteriaList.length === this.currentSearchSettingList.length) {
            return false;
        }

        // Don't show if the user hasn't chosen a search criteria
        if (!this.searchCriteriaList[this.searchCriteriaList.length - 1].searchForSelected) {
            return false;
        }

        if (this.searchCategory && this.searchCategory.Has_Single_Search_Criteria__c) {
            return false;
        }

        return true;
    }

    get categoryDisplayIndex() {
        return this.categoryIndex + 1;
    }

    get isDisplaySingleSearch() {
        return this.currentSearchSetting && this.isSingleSearchCriteria;
    }

    get isSingleSearchCriteria() {
        return this.searchCategory?.Has_Single_Search_Criteria__c;
    }

    get currentSearchSetting() {        
        if (!this.selectedGroupValue || !this.currentSearchSettingList) {
            return {};
        }

        return this.currentSearchSettingList.find(eachSearchSetting => {
            return eachSearchSetting.Search_Criteria_Name__c === this.selectedGroupValue;
        });
    }

    get hasMultipleFields() {        
        return this.searchCriteriaList?.[0].subSettingList;
    }

    get valueListSelected() {
        return this.searchCriteriaList?.[0]?.valueList;
    }

    connectedCallback() {
        if (!this.searchGroupOptionsMap) {
            return;
        }

        let options = [];

        Object.keys(this.searchGroupOptionsMap).forEach(key => {
            let value = this.searchGroupOptionsMap[key][0].Portal_Directory_Search_Category__r.Search_Criteria_Name__c;
            options.push({
                "key" : key,
                "value" : value
            })
        });

        this.options = options;
    }

    addValueToSearch = (option) => {
        if (!option || !option.value || this.valueListSelected.includes(option.value)) {
            return;
        }

        this.valueListSelected.push(option.label);
        let searchCriteriaValues = [...this.searchCriteria.valueList];

        searchCriteriaValues.push(option.value);
        this.handleSearchCriteriaChange({valueList: searchCriteriaValues}, 0);
    }
    
    handleRemoveValue(event) {
        let index = 0;
        this.removeValueFromSearch(index);

        if (this.currentSearchSetting.Search_Input_Type__c === 'Picklist') {
            this.template.querySelector('c-portal_-directory-input-field').resetInputValue();
        }
    }
    
    removeValueFromSearch(index) {
        this.valueListSelected.splice(index, 1);
        if (!this.hasMultipleFields) {
            let searchCriteriaValues = [...this.searchCriteria.valueList];
    
            searchCriteriaValues.splice(index, 1);
            this.handleSearchCriteriaChange({valueList: searchCriteriaValues}, 0);
            return;
        } 

        this.removeFromSubCriteriaList(index);
    }

    removeFromSubCriteriaList(index) {
        let subCriteriaList = [];
        this.searchCriteria.subCriteriaList.forEach(subCriteria => {
            let searchCriteriaValues = [...subCriteria.valueList];
            searchCriteriaValues.splice(index, 1);
            let newSubCriteria = Object.assign({}, subCriteria);

            newSubCriteria.valueList = searchCriteriaValues;
            subCriteriaList.push(newSubCriteria);
        });

        this.handleSearchCriteriaChange({subCriteriaList: subCriteriaList}, 0);
    }

    handleSearchForChange(event) {
        let groupValue = event.currentTarget.value;

        this.currentSearchSettingList = this.searchGroupOptionsMap[groupValue];

        if (!this.currentSearchSettingList) {
            this.currentSearchSettingList = [];
        }

        let searchCriteriaList = [this.createSearchCriteria()];

        if (groupValue === 'Location') {
            searchCriteriaList[0].searchForSelected = 'Location';
            searchCriteriaList[0].subSettingList = this.currentSearchSettingList;
            searchCriteriaList[0].subCriteriaList = []
            this.currentSearchSettingList.forEach(searchSetting => {
                let newSearchCriteria = this.createSearchCriteria();
                newSearchCriteria.searchForSelected = searchSetting.Search_Criteria_Name__c;
                searchCriteriaList[0].subCriteriaList.push(newSearchCriteria);
            });
        }

        let objectApiName = this.searchGroup.objectApiName;

        if (!groupValue) {
            searchCriteriaList = [];
        } else {
            this.searchCategory = this.searchGroupOptionsMap[groupValue][0].Portal_Directory_Search_Category__r;
            objectApiName = this.searchGroupOptionsMap[groupValue][0].Portal_Directory_Search_Category__r.Object_API_Name__c;
            searchCriteriaList[0].searchForSelected = groupValue;
        }

        this.handleSearchGroupChange({objectApiName: objectApiName, searchCriteriaList: searchCriteriaList}, this.categoryIndex);
        // this.dispatchEvent(new CustomEvent('searchgroupchange', {detail: {objectApiName: objectApiName, searchCriteriaList: searchCriteriaList, index: this.categoryIndex}}))

        this.setSelectedOptions();

        this.selectedGroupValue = groupValue;
        this.searchCriteriaList = searchCriteriaList;
    }

    createSearchCriteria() {
        let searchCriteria = {};

        searchCriteria.searchRule = '';
        searchCriteria.searchForSelected = '';
        searchCriteria.filterSearchText = '';
        searchCriteria.lookupFilterObjects = [];
        searchCriteria.currentSetting = {};
        searchCriteria.valueList = [];
        searchCriteria.displayValue = [];
        searchCriteria.zipCode = '';
        searchCriteria.distance = '';
        searchCriteria.key = Date.now();

        return searchCriteria;
    }

    getSearchCriteriaListWithSearchSettings() {
        let searchCriteriaList = [];

        if (!this.currentSearchSettingList) {
            return searchCriteriaList;
        }

        this.currentSearchSettingList.forEach(searchSetting => {
            let searchCriteria = this.createSearchCriteria();
            searchCriteria.searchForSelected = searchSetting.Search_Criteria_Name__c;
            searchCriteriaList.push(searchCriteria);
        })

        return searchCriteriaList;
    }

    setSelectedOptions() {
        let searchCriteriaList = this.searchCriteriaList;
        let selectedOptions = [];

        if (searchCriteriaList) {
            searchCriteriaList.forEach(searchCriteria => {
                if (searchCriteria && searchCriteria.searchForSelected) {
                    selectedOptions.push(searchCriteria.searchForSelected);
                }
            });
        }

        this.selectedOptions = selectedOptions;
    }

    handleAddSearchCriteria() {
        this.searchCriteriaList.push(this.createSearchCriteria());
    }

    handleSearchCriteriaChange = (payload, index) => {
        let searchCriteria = this.searchCriteriaList[index];

        for (const key in payload) {
            if (Object.prototype.hasOwnProperty.call(payload, key)) {
                searchCriteria[key] = payload[key];
            }
        }

        this.setSelectedOptions();

        this.handleSearchGroupChange({searchCriteriaList: [...this.searchCriteriaList]}, this.categoryIndex);
    }

    // TODO: REMOVE
    handleSetSearchCriteria(event) {
        let searchCriteria = this.searchCriteriaList[event.detail.index];

        if (event.detail.hasOwnProperty('searchForSelected')) {
            searchCriteria.searchForSelected = event.detail.searchForSelected;
        }

        if (event.detail.hasOwnProperty('addressList')) {
            searchCriteria.addressList = event.detail.addressList;
        }

        if (event.detail.hasOwnProperty('searchCriteria')) {
            searchCriteria = event.detail.searchCriteria;
        }

        this.searchCriteriaList.splice(event.detail.index, 1, searchCriteria);

        this.dispatchEvent(new CustomEvent('searchgroupchange', {detail: {searchCriteriaList: this.searchCriteriaList, index: this.categoryIndex}}))
        this.setSelectedOptions();
    }

    handleDeleteSearchTerm = (event) => {
        let index = event.currentTarget.dataset.index;

        this.searchCriteriaList.splice(index, 1);
        this.handleSearchGroupChange({searchCriteriaList: [...this.searchCriteriaList]}, this.categoryIndex);

        this.setSelectedOptions();
    }
}