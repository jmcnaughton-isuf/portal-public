/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, track, api} from 'lwc';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import SERVER_getSearchDisplaySettings from '@salesforce/apex/PORTAL_LWC_DirectoryController.SERVER_getSearchDisplaySettings';
import SERVER_getContacts from '@salesforce/apex/PORTAL_LWC_DirectoryController.SERVER_getContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class portal_lwc_Directory extends LightningElement {
    @api zone = 'Main';
    @api itemsPerPage = 15;
    @api noResultsText = 'There are no results for your search.'

    @track searchText = '';
    @track displaySettings = [];

    @track searchSettings = [];

    @track searchGroupMap = null;
    @track checkboxSearchSettings = [];

    @track searchGroupList = [{objectApiName : '', searchCriteriaList : [], key: '1'}];
    @track searchGroupOptionsMap = {};

    @track contactList = [];
    @track _showSpinner = false;
    @track _isShowAdvancedSearch = false;
    @track _hasSearchBeenExecuted = false;

    get hasSearchGroupMap() {
        return this.searchGroupMap != null;
    }

    get isShowAddCategory() {
        if (!this.searchGroupList) {
            return true;
        }

        return this.searchGroupList.length < 3;
    }

    get isShowNoResults() {
        return this._hasSearchBeenExecuted && this.contactList.length === 0;
    }

    error = '';

    connectedCallback() {
        this.getDisplaySettings();
    }

    getDisplaySettings() {
        this._showSpinner = true;
        callApexFunction(this, SERVER_getSearchDisplaySettings, {zone: this.zone}, (result) => {
            let searchSettings = [];
            let checkboxSearchSettings = [];

            result.forEach((searchSetting) => {
                let displaySettingList = [];

                // Set up display settings
                if (searchSetting.Portal_Directory_Search_Display_Settings__r) {
                    searchSetting.Portal_Directory_Search_Display_Settings__r.forEach((displaySetting) => {
                        displaySettingList.push({
                            'customMetadataDeveloperName': displaySetting.DeveloperName,
                            'isPicklist': displaySetting.Type__c === 'Picklist Field'});
                    });
                }

                searchSetting.displaySettingList = displaySettingList;

                if (searchSetting.Portal_Directory_Search_Display_Settings__r) {
                    searchSetting.Portal_Directory_Search_Display_Settings__r.forEach(displaySetting => {
                        // Split static values string to list
                        if (displaySetting.Static_Values__c) {
                            if (displaySetting.Static_Values__c.includes('\r\n')) {
                                searchSetting.staticList = displaySetting.Static_Values__c.split('\r\n');
                            } else {
                                searchSetting.staticList = displaySetting.Static_Values__c.split('\n');
                            }
                        }
                    })
                }

                searchSettings.push(searchSetting);

                if (searchSetting.Search_Input_Type__c === 'Checkbox') {
                    searchSetting.checked = false;
                    checkboxSearchSettings.push(searchSetting);
                }
            });

            this.searchGroupMap = this.getSearchGroupMap(searchSettings);
            this.searchSettings = searchSettings;
            this.checkboxSearchSettings = checkboxSearchSettings;

            this._showSpinner = false;
        }, () => {
            this._showSpinner = false;
        });
    }

    getSearchGroupMap(searchCriteriaList) {
        let searchCategoryMap = {};

        searchCriteriaList.forEach(searchCriteria => {
            let searchCriteriaInCategory = [];

            if (searchCriteria.Portal_Directory_Search_Category__r.Type__c !== 'Advanced Search Section') {
                return;
            }

            if (searchCategoryMap[searchCriteria.Portal_Directory_Search_Category__r.Category_Name__c]) {
                searchCriteriaInCategory = searchCategoryMap[searchCriteria.Portal_Directory_Search_Category__r.Category_Name__c];
            }

            searchCriteriaInCategory.push(searchCriteria);
            searchCategoryMap[searchCriteria.Portal_Directory_Search_Category__r.Category_Name__c] = searchCriteriaInCategory;
        });

        return searchCategoryMap;
    }

    genericOnChange(event){
        this[event.target.name] = event.target.value;
    }

    handleCheckbox(event) {
        this.checkboxSearchSettings.forEach(setting => {
            if (setting.DeveloperName === event.currentTarget.id) {
                setting.checked = event.currentTarget.checked;
            }
        });
    }

    handleSearchGroupChange = (payload, index) => {
        let searchGroup = this.searchGroupList[index];

        if (payload) {
            for (const key in payload) {
                if (Object.prototype.hasOwnProperty.call(payload, key)) {
                    searchGroup[key] = payload[key];
                }
            }
        }
    }

    handleSearch() {
        this.searchDirectory();
    }

    handleAddCategory() {
        this.searchGroupList.push(this.createNewCategory());
    }

    createNewCategory() {
        return {objectApiName : '', searchCriteriaList : [], key: Date.now()}
    }

    handleSearchTextChange = (event) => {
        this.searchText = event.target.value;
    }

    handleCheckbox = (event) => {
        this.checkboxSearchSettings.forEach(setting => {
            if (setting.Search_Criteria_Name__c === event.target.dataset.name) {
                setting.checked = event.currentTarget.checked;
            }
        });

        // helper.getContacts(component, helper, 0, false);
        this.searchDirectory();
    }

    searchDirectory = () => {
        this._hasSearchBeenExecuted = false;
        let searchGroupList = [];

        this.searchGroupList.forEach(searchGroup => {
            if (!searchGroup.searchCriteriaList || searchGroup.searchCriteriaList.length === 0) {
                // searchGroupList.push(searchGroup);
                return;
            }

            let searchCriteriaList = [...searchGroup.searchCriteriaList];

            if (!searchCriteriaList[0].subCriteriaList) {
                searchGroupList.push(searchGroup);
                return;
            }

            searchCriteriaList = searchCriteriaList[0].subCriteriaList;

            let newSearchGroup = Object.assign({}, searchGroup);
            newSearchGroup.searchCriteriaList = searchCriteriaList;
            searchGroupList.push(newSearchGroup);
        });

        if (!this.validateSearch(searchGroupList)) {
            return;
        }

        let searchCriteriaList = [];
        if (this.checkboxSearchSettings) {
            this.checkboxSearchSettings.forEach((setting) => {
                if (setting.checked === true) {
                    let checkboxSearchCriteria = {'searchForSelected': setting.MasterLabel,
                                                  'valueList': ['true']};
                    searchCriteriaList.push(checkboxSearchCriteria);
                }
            });
        }

        this._showSpinner = true;

        callApexFunction(this,
                         SERVER_getContacts,
                         {searchText: this.searchText,
                          searchCriteriaList: searchCriteriaList,
                          searchCategoryList: searchGroupList,
                          itemsPerPage: 150,
                          zone: "Main"},
                         (result) => {
            this.contactList = result;
            this._showSpinner = false;
            this._hasSearchBeenExecuted = true;
        }, () => {
            this._showSpinner = false;
        });
    }

    validateSearch = (searchGroupList) => {
        if (searchGroupList && searchGroupList.length === 3
                    && searchGroupList[0].objectApiName == searchGroupList[1].objectApiName
                    && searchGroupList[1].objectApiName == searchGroupList[2].objectApiName) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'You cannot filter by three of the same search categories.',
                variant:"error",
                mode:"sticky"
            });

            this.dispatchEvent(event);

            return false;
        }

        return true;
    }

    handleDeleteSearchCategory = (event) => {
        this.searchGroupList.splice(event.currentTarget.dataset.index, 1);
    }

    handleToggleAdvancedSearch() {
        this._isShowAdvancedSearch = !this._isShowAdvancedSearch;

        if (!this._isShowAdvancedSearch) {
            this.searchGroupList = [{objectApiName : '', searchCriteriaList : [], key: '1'}];
        }
    }
}