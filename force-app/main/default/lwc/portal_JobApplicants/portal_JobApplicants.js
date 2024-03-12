import { LightningElement, api, track } from 'lwc';
import SERVER_getJobApplicants from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getJobApplicants';
import SERVER_changeApplicationStatus from '@salesforce/apex/PORTAL_JobBoardController.SERVER_changeApplicationStatus';
import basePath from '@salesforce/community/basePath';
export default class Portal_JobApplicants extends LightningElement {

    @api informationMap = {};
    @api status;
    @track _applicants = [];
    _jobName = "";
    _recruitingCompany = "";
    _callbackDone = false;
    _recordId;
    _isShowModal = false;
    _isShowSpinner = false;
    _recordId;
    _jobApplicationId;
    @track _statusOptions = [{"label":"Submitted", "value":"Submitted"}, {"label":"Under Review", "value":"Under Review"}, {"label":"Not Selected", "value":"Not Selected"}, {"label":"Accepted", "value":"Accepted"}];
    _jobApplicationStatus;
    @api recordsPerPage = 10;
    @api currentPage = 1;
    @api totalItems = 0;
    _offset = 0;
    _visibleData = [];

    get hasRecords() {
        return this._applicants.length > 0;
    }

    get showJobName() {
        return this._jobName && this.informationMap.frontEndData.jobName.display;
    }

    get showRecruitingCompany() {
        return this._recruitingCompany && this.informationMap.frontEndData.recruitingCompany.display;
    }

    get isDisplayJobApplicants() {
        return this.informationMap?.frontEndData && this._visibleData;
    }

    connectedCallback() {
        var vars = {};

        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });

        if (vars.recordId) {
            this._recordId = vars.recordId;
        }

        // if (this.status) {
        //     this._statusOptions = JSON.parse(JSON.stringify(this.status));
        //     this._statusOptions.forEach(status => {
        //         console.log(status);
        //     })
        // }

        this.getRecords();
        this.equalHeight(true);
        
    }

    renderedCallback() {
        this.equalHeight(true);
        window.addEventListener('resize', (event) => {this.equalHeight(true);});
    }

    getRecords() {
        const params ={params:{recordId:this._recordId, offset: this._offset}};
        SERVER_getJobApplicants(params).then(res => {
            this.informationMap = res;
            if(res && res.records && res.records.Open_Applications && res.records.Open_Applications.records) {
                (Object.keys(this.informationMap.records.Open_Applications.records)).forEach(key => {
                    this._applicants = [...this._applicants, this.informationMap.records.Open_Applications.records[key]];
                    
                    if (!this._jobName){
                        this._jobName = this.informationMap.records.Open_Applications.records[key].record.Job__r.Name;                  
                    }
                    
                    if (!this._recruitingCompany){
                        this._recruitingCompany = this.informationMap.records.Open_Applications.records[key].record.Job__r.Recruiting_Company__c;
                    }
                })
            }
            if (res) {
                this.totalItems = res.count ? res.count : 0;
            }
            this._callbackDone = true;
            this._isShowModal = false;
            this._isShowSpinner = false;
        }).catch(error => {
            console.log(error);
        });
    }

    handleBackButtonClick(event) {
        window.location.href = basePath + '/job-board?viewPostedJobs=true';
    }

    showModal(event) {
        this._jobApplicationId = event.currentTarget.getAttribute("data-field-id");
        this._jobApplicationStatus = event.currentTarget.getAttribute('data-field-status');
        this._statusOptions.forEach(option => {
            if (option.value == this._jobApplicationStatus) {
                option.checked = true;
            } else {
                option.checked = false;
            }
        })
        this._isShowModal = true;
    }

    handleStatusChange(event) {
        this._jobApplicationStatus = event.currentTarget.value;
        this._statusOptions.forEach(option => {
            if (option.value == this._jobApplicationStatus) {
                option.checked = true;
            } else {
                option.checked = false;
            }
        })
    }

    closeModal(event) {
        this._isShowModal = false;
    }

    handleCheckStatus(event) {
        console.log(event.currentTarget.value)
        if (event.currentTarget.value === this._jobApplicationStatus) {
            return true;
        } else {
            return false;
        }
    }

    changeStatus(event) {
        this._isShowSpinner = true;
        const params = {params:{recordId:this._jobApplicationId, status:this._jobApplicationStatus}};
        SERVER_changeApplicationStatus(params).then(res => {
            this._applicants = [];
            this.currentPage = 1;
            this._offset = 0;
            this.getRecords();
        }).catch(error => {

        })
    }

    handleQueryMore = (event) => {
        this.showSpinner = true;
        this._offset = event.detail.offset;
        this.getRecords();
        this.currentPage = event.detail.pageNumber + 1;
    }


    handlePageChange = (paginatedData) => {
        this._visibleData = paginatedData;
    }

    @api
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
}