import { LightningElement, api } from 'lwc';
import SERVER_getSearchFilterPicklists from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getSearchFilterPicklists';
import SERVER_searchForJobWithFilters from '@salesforce/apex/PORTAL_JobBoardController.SERVER_searchForJobWithFilters';
import isGuestUser from '@salesforce/user/isGuest';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Portal_JobSearch extends LightningElement {

    @api keywordLabel = 'Keyword';
    @api isShowKeyword;
    @api cityLabel = 'City';
    @api isShowCity;
    @api stateLabel = 'State';
    @api isShowState;
    @api postalCodeLabel = 'Postal Code';
    @api isShowPostalCode;
    @api radiusLabel = 'Radius';
    @api isShowRadius;
    @api multipleLocationsLabel = 'Multiple Locations?';
    @api isShowMultipleLocations;
    @api remoteLabel = 'Remote?';
    @api isShowRemote;
    @api salaryLabel = 'Salary';
    @api isShowSalary;
    @api nullSalariesLabel = 'Include jobs without specified salaries?';
    @api isShowNullSalaries;
    @api positionTypeLabel = 'Position Type';
    @api isShowPositionType;
    @api classDegreeLevelLabel = 'Class Or Degree Level';
    @api isShowClassDegreeLevel;
    @api noResultsText = 'There are no results for your search.';
    @api picklists;
    @api records = [];
    @api frontEndData;
    @api recordsPerPage = 2;
    @api currentPage = 1;
    @api totalItems = 0;
    _callbackDone = false;
    _filterMap = {radius:50};
    _offset = 0;
    _visibleData = [];
    _isShowSpinner = true;

    get isLoggedInUser() {
        if (isGuestUser) {
            return false;
        }

        return true;
    }

    connectedCallback() {
        if (!this.isShowRadius) {
            this._filterMap = {};
        }

        const params = {params:{}};
        SERVER_getSearchFilterPicklists(params).then(res => {
            this.picklists = res;
            this.getRecords();
        }).catch(error => {

        });
        
    }

    get hasRecords() {
        return this.records.length > 0;
    }

    get keyword() {
        return this._filterMap['keyword'] ? this._filterMap['keyword'] : '';
    }

    get city() {
        return this._filterMap['city'] ? this._filterMap['city'] : '';
    }

    get state() {
        return this._filterMap['state'] ? this._filterMap['state'] : '';
    }

    get postalCode() {
        return this._filterMap['postalCode'] ? this._filterMap['postalCode'] : '';
    }

    get radius() {
        return this._filterMap['radius'] ? this._filterMap['radius'] : null;
    }

    get multipleLocations() {
        return this._filterMap['multipleLocations'] ? this._filterMap['multipleLocations'] : false;
    }

    get isRemote() {
        return this._filterMap['isRemote'] ? this._filterMap['isRemote'] : false;
    }

    get lowerBoundSalary() {
        return this._filterMap['lowerBoundSalary'] ? this._filterMap['lowerBoundSalary'] : null;
    }

    get upperBoundSalary() {
        return this._filterMap['upperBoundSalary']  ? this._filterMap['upperBoundSalary'] : null;
    }

    get includeNulls() {
        return this._filterMap['includeNulls']  ? this._filterMap['includeNulls'] : false;
    }

    get positionType() {
        return this._filterMap['positionType']  ? this._filterMap['positionType'] : '';
    }

    get classDegreeLevel() {
        return this._filterMap['classDegreeLevel'] ? this._filterMap['classDegreeLevel'] : '';
    }

    setRecordValue = (event) => {
        let fieldId = event.currentTarget.name;
        if (event.currentTarget.type == 'checkbox') {
            this._filterMap[fieldId] = event.currentTarget.checked;
            this._filterMap = {...this._filterMap};
        } else {
            this._filterMap[fieldId] = event.currentTarget.value;
            this._filterMap = {...this._filterMap};
        }
    }

    setAddressFieldsToDisplay() {
        for (let jobRecord of this.records) {
            jobRecord.cityToDisplay = this.frontEndData.jobCity.display ? jobRecord.City__c : '';
            jobRecord.stateToDisplay = this.frontEndData.jobState.display ? jobRecord.State__c : '';
            jobRecord.postalCodeToDisplay = this.frontEndData.jobPostalCode.display ? jobRecord.Postal_Code__c : '';
        }
    }

    getRecords() {
        const params = {params:{filterMap:this._filterMap, offset:this._offset}};
        SERVER_searchForJobWithFilters(params).then(res => {
            if (res) {
                this.frontEndData = res.frontEndData;
                if (res.records) {
                    this.records = [...this.records,...res.records];
                    this.setAddressFieldsToDisplay();
                } else {
                    this.records = [];
                }
                this.totalItems = res.count ? res.count : 0;
            }
            this._isShowSpinner = false;
            this._callbackDone = true;
        }).catch(error => {
            console.log(JSON.stringify(error));
        });
    }

    checkInputValidity() {
        let inputs = this.template.querySelectorAll('c-portal_-input');
        let validity = true;

        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (validity === true) {
                        input.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        return validity;
    }

    handleClear(event) {
        this._filterMap = this.isShowRadius ? {radius:50} : {};
    }

    handleSearch(event) {
        if (!this.checkInputValidity()) {
            return;
        }

        this._isShowSpinner = true;
        this.records = [];
        this.getRecords();
    }

    handleQueryMore = (event) => {
        this._isShowSpinner = true;
        this._offset = event.detail.offset;
        this.getRecords();
        this.currentPage = event.detail.pageNumber + 1;
    }


    handlePageChange = (paginatedData) => {
        this._visibleData = paginatedData;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'sticky'
        });

        this.dispatchEvent(evt);
    }
}