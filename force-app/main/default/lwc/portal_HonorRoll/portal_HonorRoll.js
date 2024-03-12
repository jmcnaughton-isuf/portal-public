import { LightningElement, track, api, wire } from 'lwc';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import getHonorRollNames from '@salesforce/apex/PORTAL_LWC_HonorRollController.SERVER_getHonorRollNames';
import getHonorRollFilterInformation from '@salesforce/apex/PORTAL_LWC_HonorRollController.SERVER_getHonorRollFilterInformation';

export default class Portal_HonorRoll extends LightningElement {
    // design attributes
    @api honorYearLabel;
    @api givingSocietyLabel;
    @api divisionOrSchoolLabel;
    @api classYearLabel;

    @api showHonorRollYearFilter;
    @api showGivingSocietyFilter;
    @api showDivisionOrSchoolFilter;
    @api showClassYearLabel;

    @api itemsPerPage;
    @api oldestClassYear;

    @track honorRollNameList;
    @track listOfFiscalYears;
    @track selectedFiscalYear;
    @track givingSocietiesNameList;
    @track selectedGivingSociety;
    @track classYearList;
    @track selectedClassYear;
    @track divisionsAndSchoolList;
    @track selectedDivisionOrSchool;
    @track honorRollNameSearchString = '';

    @track showSpinner = true;
    @track dataLoaded = true;

    @track currentPage = 1;
    @track visibleData;
    @track totalItems = 2000;

    _queryLimit;
    _anyPicklistString = '- Any -';
    _hasMoreData = false;

    get getFilterParams() {
        return {oldestClassYear: this.oldestClassYear};
    }

    @wire(getHonorRollFilterInformation, {params: '$getFilterParams'})
    populateFilterInformationLists({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        if (data.fiscalYears) {
            this.populateFiscalYearList(data.fiscalYears);
        }

        if (data.givingSocieties) {
            this.populateGivingSocietyList(data.givingSocieties);
        }

        if (data.classYears) {
            this.populateClassYearList(data.classYears);
        }

        if (data.academicOrganizations) {
            this.populateDivisionAndSchoolList(data.academicOrganizations);
        }

        this._queryLimit = 10 * this.itemsPerPage;

        // queryLimit + 1 to check for potential additional querying
        const params = {fiscalYear : this.selectedFiscalYear, queryLimit: this._queryLimit + 1};
        this.queryForRecords(params, false);
        this.showSpinner = false;
    }

    queryForRecords(params, append) {
        callApexFunction(this, getHonorRollNames, params, (res) => {
            if (res && res.length > 0) {
                let honorRollNameList = [];
                res.forEach(record => {
                    honorRollNameList.push(record);
                });

                // Potentially 1 above limit to indicate there's more to query
                this._hasMoreData = false;
                if (honorRollNameList.length > this._queryLimit) {
                    // Removing the records over limit
                    honorRollNameList.length = this._queryLimit;
                    this._hasMoreData = true;
                }

                if (append) {  // due to query more, we need to appned records
                    this.currentPage = this.currentPage + 1;
                    this.honorRollNameList = [...this.honorRollNameList, ...honorRollNameList];

                } else {
                    this.honorRollNameList = honorRollNameList;
                }

                this.dataLoaded = true;
            } else if ((!res || res.length <= 0) && append) {
                // do nothing
            } else {
                this.dataLoaded = false;
            }
            this.showSpinner = false;
        }, () => {this.showSpinner = false;});
    }

    populateFiscalYearList(fiscalYears) {
        let yearsList = [];
        fiscalYears.forEach(year => {
            yearsList.push({label: year, value: year});
        });

        this.listOfFiscalYears = yearsList;
        this.selectedFiscalYear = fiscalYears[0];
    }

    populateGivingSocietyList(givingSocieties) {
        let givingSocietyList = [];
        givingSocietyList.push({label: this._anyPicklistString, value: ''});

        givingSocieties.forEach(givingSocietyName => {
            givingSocietyList.push({label: givingSocietyName, value: givingSocietyName});
        });

        this.givingSocietiesNameList = givingSocietyList;
        this.selectedGivingSociety = '';
    }

    populateClassYearList(classYears) {
        // get current year first
        let yearList = [];
        yearList.push({label: this._anyPicklistString, value: ''});

        classYears.forEach(classYear => {
            yearList.push({label: classYear, value: classYear});
        })

        this.classYearList = yearList;
        this.selectedClassYear = '';
    }

    populateDivisionAndSchoolList(academicOrganizations) {
        let academicOrgList = [];
        academicOrgList.push({label: this._anyPicklistString, value: ''});

        academicOrganizations.forEach(org => {
            academicOrgList.push({label: org, value: org});
        })

        this.divisionsAndSchoolList = academicOrgList;
        this.selectedDivisionOrSchool = '';
    }

    handleHonorRollNameClick = (event) => {
        // event variable contains contactId and jointContactId
        console.log('id: ' + event.detail.contactId);
    }

    handleApplyFilter = () => {
        this.showSpinner = true;
        this.currentPage = 1;

        // queryLimit + 1 to check for potential additional querying
        const params = {nameSearchString : this.honorRollNameSearchString,
                                givingSociety: this.selectedGivingSociety,
                                classYear: this.selectedClassYear,
                                fiscalYear: this.selectedFiscalYear,
                                academicOrganization: this.selectedDivisionOrSchool,
                                queryLimit: this._queryLimit + 1};
        this.queryForRecords(params, false);

    }

    handleQueryMore = (event) => {
        if (!this._hasMoreData) {
            return;
        }

        this.showSpinner = true;

        // queryLimit + 1 to check for potential additional querying
        const params = {nameSearchString : this.honorRollNameSearchString,
                                givingSociety: this.selectedGivingSociety,
                                classYear: this.selectedClassYear,
                                fiscalYear: this.selectedFiscalYear,
                                academicOrganization: this.selectedDivisionOrSchool,
                                queryLimit: this._queryLimit + 1,
                                offset: event.detail.offset};

        this.queryForRecords(params, true);
    }

    handlePageChange = (paginatedData, pageNumber) => {
        this.visibleData = paginatedData;
        this.currentPage = pageNumber;
    }

    handleHonorRollYearChange = (event) => {
        this.selectedFiscalYear = event.target.value;
    }

    handleNameSearch = (event) => {
        this.honorRollNameSearchString = event.target.value;
    }

    handleGivingSocietyChange = (event) => {
        this.selectedGivingSociety = event.target.value;
    }

    handleClassYearChange = (event) => {
        this.selectedClassYear = event.target.value;
    }

    handleDivisionAndSchoolChange = (event) => {
        this.selectedDivisionOrSchool = event.target.value;
    }

    handleClearInput = (event) => {
        this.selectedFiscalYear = this.listOfFiscalYears[0].value;
        this.honorRollNameSearchString = '';
        this.selectedDivisionOrSchool = this.divisionsAndSchoolList[0].value;
        this.selectedClassYear = this.classYearList[0].value;
        this.selectedGivingSociety = this.givingSocietiesNameList[0].value;
    }
}