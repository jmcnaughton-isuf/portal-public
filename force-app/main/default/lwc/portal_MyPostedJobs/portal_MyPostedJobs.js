import { LightningElement, api } from 'lwc';
import SERVER_getMyPostedJobs from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getMyPostedJobs';
import SERVER_archiveJob from '@salesforce/apex/PORTAL_JobBoardController.SERVER_archiveJob';
import PORTAL_GLOBAL_CSS from '@salesforce/resourceUrl/Portal_Global_CSS';
import { loadStyle } from 'lightning/platformResourceLoader';
export default class Portal_MyPostedJobs extends LightningElement {
    @api informationMap;
    @api recordsPerPage = 10;
    @api closedCurrentPage = 1;
    @api openCurrentPage = 1;
    @api openTotalItems = 0;
    @api closedTotalItems = 0;

    @api contentPageName;
    @api contentModuleName;
    @api pageName = 'Job Posting';
    @api mainSectionName = 'Job';
    @api noResultsText = 'No posted jobs were found.';

    _closedOffset = 0;
    _openOffset = 0;
    _openVisibleData = [];
    _closedVisibleData = [];
    _openJobPostingList = [];
    _closedJobPostingList = [];
    _isShowComponent = false;
    _job;
    _isShowSpinner = true;
    _isShowModalSpinner = false;
    _isShowModal = false;
    _isShowArchiveModal = false;
    _isShowViewModal = false;
    _archiveRecordId;
    _viewRecordId;
    _jobModalText = 'Post a Job';

    _resizeObserver;
    _checkForZeroHeightInterval;

    get hasOpenRecords() {
        return this._openJobPostingList.length > 0;
    }

    get hasClosedRecords() {
        return this._closedJobPostingList.length > 0;
    }

    get isShowNoOpenRecordsText() {
        return !this._isShowSpinner && !this.hasOpenRecords;
    }

    get isShowNoClosedRecordsText() {
        return !this._isShowSpinner && !this.hasClosedRecords;
    }

    connectedCallback() {
        loadStyle(this, PORTAL_GLOBAL_CSS);
        window.addEventListener('resize', () => {this.equalHeight(true);});
        this.getRecords('');
    }

    renderedCallback() {
        this.createResizeObserver();
        this.equalHeight(true);
    }

    createResizeObserver() {
        if (this._resizeObserver) { 
            return; 
        }

        let headerElement = this.template.querySelector('.headerEqualHeight');
        if (!headerElement){
            return;
        }

        this._resizeObserver = new ResizeObserver(entries => {
            if (entries[0].contentRect.height == 0){
                if (!this._checkForZeroHeightInterval){
                    
                    this._checkForZeroHeightInterval = setInterval(() => {
                        // any element will do, this one is arbitrarily used
                        if (entries[0].target.style.height === '0px') {
                            this.equalHeight(true);
                        }
                    }, 100);
                }

            } else {
                if (this._checkForZeroHeightInterval){
                    clearInterval(this._checkForZeroHeightInterval);
                    this._checkForZeroHeightInterval = null;
                }
            }
        });
        
        this._resizeObserver.observe(headerElement);
    }

    openJobModal(event) {
        this._jobModalText = 'Post a Job';
        this._job = {};
        this._isShowModal = true;
    }

    handleCloseModal = (saved) => {
        if (saved == true) {
            this._isShowSpinner = true;
            this._openJobPostingList = [];
            this._closedJobPostingList = [];
            this._openCurrentPage = 1;
            this._closedCurrentPage = 1;
            this._openOffset = 0;
            this._closedOffset = 0;
            this._openVisibleData = []; // TODO: Temp fix
            this.getRecords();
        } else {
            this._isShowModal = false;
        }

    }

    closeModal(event) {
        this._isShowArchiveModal = false;
        this._isShowViewModal = false;
    }

    handleJobAction(event) {
        let action = event.currentTarget.getAttribute('data-type');
        let id = event.currentTarget.getAttribute('data-id');
        let index = event.currentTarget.getAttribute('data-index');
        let status = event.currentTarget.getAttribute('data-status');

        if (action == 'edit') {
            this._jobModalText = 'Edit Job Post';
            if (status == "Open") {
                this._job = {...this._openVisibleData[index]};
            } else {
                this._job = {...this._closedVisibleData[index]};
            }
            this._isShowModal = true;
        } else if (action == 'clone') {
            this._jobModalText = 'Clone Job Post';
            if (status == "Open") {
                this._job = {...this._openVisibleData[index]};
            } else {
                this._job = {...this._closedVisibleData[index]};
            }

            // if Expiration Date is today, then the job is still open until the end of the day
            if (this._job.Expiration_Date__c && new Date(this._job.Expiration_Date__c + 'T23:59:59') < new Date()){
                this._job.Expiration_Date__c = null;
            }

            this._job.Id = null;
            this._job.Status__c = null;
            this._job.View_Count__c = 0;
            this._isShowModal = true;
        } else if (action == "archive") {
            this._isShowArchiveModal = true;
            this._archiveRecordId = id;
        } else if (action == 'view') {
            this._viewRecordId = id;
            this._isShowViewModal = true;
        }
    }

    getRecords(mode) {
        const params = {params:{openOffset:this._openOffset, closedOffset:this._closedOffset}};
            SERVER_getMyPostedJobs(params).then(res => {
                this.informationMap = res;
                if ((!mode || mode == 'open') && res.records && res.records.Open_Jobs && res.records.Open_Jobs.records) {
                    res.records.Open_Jobs.records.forEach(record => {
                        let newRecord = {...record};
                        if (newRecord['ucinn_portal_Job_Applications__r'] && newRecord['ucinn_portal_Job_Applications__r'].totalSize > 0) {
                            newRecord['showApplications'] = true;
                        } else {
                            newRecord['showApplications'] = false;
                        }
                        if (newRecord['CreatedDate']) {
                            newRecord['CreatedDate'] = newRecord['CreatedDate'].split('T')[0];
                        }
                        newRecord['applicantsLink'] = 'job-applicants?recordId=' + record['Id'];
                        this._openJobPostingList = [...this._openJobPostingList, newRecord];
                    })

                }

                if ((!mode || mode == 'closed') && res.records && res.records.Closed_Jobs && res.records.Closed_Jobs.records) {
                    res.records.Closed_Jobs.records.forEach(record => {
                        let newRecord = {...record};
                        if (newRecord['ucinn_portal_Job_Applications__r'] && newRecord['ucinn_portal_Job_Applications__r'].totalSize > 0) {
                            newRecord['showApplications'] = true;
                        } else {
                            newRecord['showApplications'] = false;
                        }
                        if (newRecord['CreatedDate']) {
                            newRecord['CreatedDate'] = newRecord['CreatedDate'].split('T')[0];
                        }
                        newRecord['applicantsLink'] = 'job-applicants?recordId=' + record['Id'];
                        this._closedJobPostingList = [...this._closedJobPostingList, newRecord];
                    })

                }

                if (res) {
                    this.openTotalItems = res.openCount ? res.openCount : 0;
                    this.closedTotalItems = res.closedCount ? res.closedCount : 0;
                }

                this._isShowModal = false;
                this._isShowComponent = true;
                this._isShowSpinner = false;
                this._isShowArchiveModal = false;
                this._isShowViewModal = false;
                this.equalHeight(true);
            }).catch(console.error);
    }

    archiveJob(event) {
        this._isShowSpinner = true;
        const params = {params: {recordId : this._archiveRecordId}};
            SERVER_archiveJob(params).then(res => {
                this._openOffset = 0;
                this._openJobPostingList = [];
                this.openCurrentPage = 1;
                this._closedOffset = 0;
                this._closedJobPostingList = [];
                this.closedCurrentPage = 1;
                this._openVisibleData = []; // TODO: Temp fix
                this.getRecords('');
                window.location.reload();
            }).catch(error => {
                console.log(error);
            })
    }

    handleQueryOpenMore = (event) => {
        this.showSpinner = true;
        this._openOffset = event.detail.offset;
        this.getRecords('open');
        this.openCurrentPage = event.detail.pageNumber + 1;
    }

    handleQueryClosedMore = (event) => {
        this.showSpinner = true;
        this._closedOffset = event.detail.offset;
        this.getRecords('closed');
        this.closedCurrentPage = event.detail.pageNumber + 1;
    }


    handleClosedPageChange = (paginatedData) => {
        this._closedVisibleData = paginatedData;
    }

    handleOpenPageChange = (paginatedData) => {
        this._openVisibleData = paginatedData;
    }

    handleEqualHeight() {
        this.equalHeight(true);
    }

    equalHeight(independentRows = false) {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = {}; 
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        for(let elemIndex = 0; elemIndex < elements.length; elemIndex++){
            elements[elemIndex].style.height = 'auto';
        }
        for(let elemIndex = 0; elemIndex < headerElements.length; elemIndex++){
            headerElements[elemIndex].style.height = 'auto';
        }
        for(let elemIndex = 0; elemIndex < expandedElements.length; elemIndex++){
            expandedElements[elemIndex].style.height = 'auto';
        }

        // get expected heights, option to treat each row independent
        for(let elemIndex = 0; elemIndex < elements.length; elemIndex++){
            var elementHeight = elements[elemIndex].clientHeight;
            let rowIndex = independentRows ? elements[elemIndex].dataset.index : 0;
            allHeights[rowIndex] = allHeights[rowIndex] || [];
            allHeights[rowIndex].push(elementHeight);
        }

        for(let elemIndex = 0; elemIndex < headerElements.length; elemIndex++){
            var elementHeight = headerElements[elemIndex].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let elemIndex = 0; elemIndex < expandedElements.length; elemIndex++){
            var elementHeight = expandedElements[elemIndex].clientHeight;
            allRowHeights.push(elementHeight);
        }

        // use max height
        for(let elemIndex = 0; elemIndex < elements.length; elemIndex++){
            let rowIndex = independentRows ? elements[elemIndex].dataset.index : 0;
            elements[elemIndex].style.height = Math.max.apply( Math, allHeights[rowIndex]) + 'px';
        }

        for(let elemIndex = 0; elemIndex < headerElements.length; elemIndex++){
            headerElements[elemIndex].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
        }

        for(let elemIndex = 0; elemIndex < expandedElements.length; elemIndex++){
            expandedElements[elemIndex].style.height = Math.max.apply( Math, allRowHeights) + 'px';
        }
    }
    
    handleUpdateModalSpinner = (isShowModalSpinner) => {
        this._isShowModalSpinner = isShowModalSpinner;
    }
}