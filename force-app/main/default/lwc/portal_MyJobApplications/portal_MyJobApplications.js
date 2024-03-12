import { LightningElement, api, track } from 'lwc';
import SERVER_getMyApplications from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getMyApplications';
import SERVER_withdrawApplication from '@salesforce/apex/PORTAL_JobBoardController.SERVER_withdrawApplication';
export default class Portal_MyJobApplications extends LightningElement {

    @api noResultsText = 'No job applications were found.';

    @api informationMap;
    @api recordsPerPage = 10;
    @api closedCurrentPage = 1;
    @api openCurrentPage = 1;
    @api openTotalItems = 0;
    @api closedTotalItems = 0;
    _closedOffset = 0;
    _openOffset = 0;
    @track _openVisibleData = [];
    @track _closedVisibleData = [];
    @track _callbackDone = false;
    @track _openApplicationsList= [];
    @track _closedApplicationsList = [];
    _isShowModal = false;
    _isShowSpinner = true;
    _recordId;

    connectedCallback() {
        this.getRecords('');
        window.addEventListener('resize', () => {this.equalHeight(true);});
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

    get hasOpenRecords() {
        return this._openApplicationsList.length > 0;
    }

    get hasClosedRecords() {
        return this._closedApplicationsList.length > 0;
    }

    get isShowNoOpenRecordsText() {
        return !this._isShowSpinner && !this.hasOpenRecords;
    }

    get isShowNoClosedRecordsText() {
        return !this._isShowSpinner && !this.hasClosedRecords;
    }

    getRecords(mode) {
        const params = {params:{closedOffset:this._closedOffset, openOffset:this._openOffset}};
        SERVER_getMyApplications(params).then(res => {
            this.informationMap = res;
            if ((!mode || mode == 'open') && this.informationMap && this.informationMap.records && this.informationMap.records.Open_Applications && this.informationMap.records.Open_Applications.records) {
                (Object.keys(this.informationMap.records.Open_Applications.records)).forEach(key => {
                    this._openApplicationsList = [...this._openApplicationsList, this.informationMap.records.Open_Applications.records[key]];
                })
            }
            if ( (!mode || mode == 'closed') && this.informationMap && this.informationMap.records && this.informationMap.records.Closed_Applications && this.informationMap.records.Closed_Applications.records) {
                (Object.keys(this.informationMap.records.Closed_Applications.records)).forEach(key => {
                    this._closedApplicationsList = [...this._closedApplicationsList, this.informationMap.records.Closed_Applications.records[key]];
                })
            }
            if (res) {
                this.openTotalItems = res.openCount ? res.openCount : 0;
                this.closedTotalItems = res.closedCount ? res.closedCount : 0;
            }
            this._callbackDone = true;
            this._isShowSpinner = false;
            this._isShowModal = false;
            this.equalHeight(true);
        }).catch(error => {
            console.log(error);
        })
    }

    showModal(event) {
        this._recordId = event.currentTarget.getAttribute("data-field-id");
        this._isShowModal = true;
    }

    withdrawApplication(event) {
        this._isShowSpinner = true;
        const params = {params:{recordId:this._recordId}};
        SERVER_withdrawApplication(params).then(res => {
            this._openOffset = 0;
            this._openApplicationsList = [];
            this.openCurrentPage = 1;

            this._closedOffset = 0;
            this._closedApplicationsList = [];
            this.closedCurrentPage = 1;
            this._openVisibleData = []; // TODO: Temp fix
            this.connectedCallback();
            //this.getRecords('');
        }).catch(error => {

        });
    }

    closeModal(event) {
        this._isShowModal = false;
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

    handleTabChange = () => {
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
}