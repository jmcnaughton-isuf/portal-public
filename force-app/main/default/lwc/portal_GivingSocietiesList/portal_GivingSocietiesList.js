import { api, track, LightningElement } from 'lwc';
import getGivingSocietiesList from '@salesforce/apex/PORTAL_GivingSocietiesListController.SERVER_getGivingSocietiesList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_GivingSocietiesList extends LightningElement {   
    tableData = []; 
    @track visibleTableData
    @track showSpinner = true;
    @track currentPage = 1;

    @api itemsPerPage; 
    @api nameSearchLabel;
    @api typeSearchLabel;
    @api givingSocietiesDetailPageURL;
    @api searchOptions;
    @api detailPageLinkText;
    @api noResultsText = "There are no giving societies that match your search.";
    
    totalNumberOfRecords = 0; // totalNumberOfItems
    callbackDone = false;
    
    permissionMap = {};
    picklistOptions = [{'label': '- None -', 'value' : ''}];
    typeSelected = '';
    nameSearch = '';

    connectedCallback() {
        this.queryGivingSocietiesList();
    }

    queryGivingSocietiesList() {
        getGivingSocietiesList({'paramMap' : {'itemsPerPage' : this.itemsPerPage, 'givingSocietyType' : this.typeSelected,
                                            'givingSocietyDetailURL' : this.givingSocietiesDetailPageURL, 'nameSearch' : this.nameSearch}})
        .then(result => {
            this.tableData = result['records'];
            this.permissionMap = result['permissionMap'];
            this.totalNumberOfRecords = result['totalNumberOfRecords'];
            
            if (!this.callbackDone && result['picklistOptions'] != null) {
                this.picklistOptions = this.picklistOptions.concat(result['picklistOptions']);
            }

            this.callbackDone = true;
            this.showSpinner = false;
        })
        .catch( error => {
            this.showSpinner = false;
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    handleSearch() {
        this.currentPage = 1;
        this.handleRefresh();
    }

    handleRefresh(){
        this.showSpinner = true;
        this.tableData = []
        this.queryGivingSocietiesList()
    }

    handleClear() {
        this.currentPage = 1;
        this.nameSearch = '';
        this.typeSelected = '';
        this.handleRefresh();
    }

    handleChange = (event) => {
        this.nameSearch = event.target.value;
    }

    typeChange = (event) => {
        this.typeSelected = event.currentTarget.value;
    }

    get hideSearch() {
        return this.searchOptions == 'Hide';
    }

    get showNameSearch() {
        return this.searchOptions == 'Show all' || this.searchOptions == 'Show name';
    }

    get showTypeSearch(){
        return this.searchOptions == 'Show all' || this.searchOptions == 'Show type';
    }

    get hasNoResults() {
        return this.totalNumberOfRecords <= 0;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }

    handlePageChange = (paginatedData, pageNumber) => {
        this.visibleTableData = paginatedData;
        this.currentPage = pageNumber;
    }
}