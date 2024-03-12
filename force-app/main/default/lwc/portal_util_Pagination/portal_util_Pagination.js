import { LightningElement, api, track } from 'lwc';

export default class Portal_util_Pagination extends LightningElement {
    @api recordsPerPage;
    @api totalNumberOfItems;
    @api isNotResetWithNewData = false;
    @api queryMore = () => {};
    @api handlePageChange = () => {};

    @api
    set currentPageNumber(pageNumber) {
        if (pageNumber && pageNumber !== this._currentPageNumber) {
            this._currentPageNumber = pageNumber;
            this.createPageList();
        }
    }

    get currentPageNumber() {
        return this._currentPage;
    }

    @api
    set queriedData(data) {
        if (data) {
            if (!this.isNotResetWithNewData) {
                this._currentPageNumber = 1;
            }

            this._currentNumberOfItems = data.length;
            this._currentData = data;
            this.createPageList();
        }
    }

    get queriedData() {
        return this._currentData;
    }

    @track showPagination = false;
    @track _pageList = [];
    @track _numberOfPages = 1;
    @track _currentData = [];
    @track _currentPageNumber = 1;
    @track _currentNumberOfItems;

    // flag needed to prevent infinite renderedCallback loop
    _isCheckPageListLength = true; 

    connectedCallback() {
        this.createPageList();
        window.addEventListener('resize', (event) => {this._isCheckPageListLength = true; this.addEllipsisToPageList();}); 
    }

    renderedCallback() {
        this.addEllipsisToPageList();
    }

    addEllipsisToPageList() {
        // return early if renderedCallback already did this or if the div doesn't exist or is not visible on the page
        let containerDiv = this.template.querySelector('.pagination-container');
        if (this._isCheckPageListLength === false || !containerDiv || containerDiv.offsetWidth === 0) {
            return;
        }
        this._isCheckPageListLength = false;
        
        // this code assumes the current list is [1, _numberOfPages]
        this._pageList = [];
        this.pushPageRange(1, this._numberOfPages);  
        // 40px is the <a> "slot" max width in the CSS file
        let maximumSlots = Math.floor(containerDiv.offsetWidth / 40);
        // +2 bc of the back << and next >> arrows
        if (maximumSlots >= this._pageList.length + 2) {
            return;
        }

        // -3 bc we want to always show <<, >>, and the current page
        this.replacePageNumbersWithEllipsis(maximumSlots - 3);

        if (this._pageList.length === 0) {
            this.pushPageRange(this._currentPageNumber, this._currentPageNumber);
        }
    }

    // helper for addEllipsisToPageList
    //      remainingSlots: integer for the number of 40px wide slots to use
    replacePageNumbersWithEllipsis(remainingSlots) {
        let halfRemainingSlots = Math.floor(remainingSlots / 2);
        let slotsBeforeCurrentPage = halfRemainingSlots;
        let slotsAfterCurrentPage = halfRemainingSlots;
        
        // if deleting page numbers, replace them with ...
        let hasFrontEllipsis = true;
        let hasBackEllipsis = true;
        
        // See if ellipsis are needed, redistribute slots if one side doesn't need ...
        if (this._currentPageNumber - 1 <= halfRemainingSlots) {
            hasFrontEllipsis = false;
            slotsBeforeCurrentPage = this._currentPageNumber - 1;
            slotsAfterCurrentPage += (remainingSlots - slotsBeforeCurrentPage - slotsAfterCurrentPage);
        }
        else if (this._numberOfPages - this._currentPageNumber <= halfRemainingSlots) {
            hasBackEllipsis = false;
            slotsAfterCurrentPage = this._numberOfPages - this._currentPageNumber;
            slotsBeforeCurrentPage += (remainingSlots - slotsBeforeCurrentPage - slotsAfterCurrentPage);
        }

        // check if there's enough slots for ellipsis
        hasFrontEllipsis = hasFrontEllipsis && slotsBeforeCurrentPage > 0;
        hasBackEllipsis = hasBackEllipsis && slotsAfterCurrentPage > 0;
        slotsBeforeCurrentPage -= (hasFrontEllipsis ? 1 : 0);
        slotsAfterCurrentPage -= (hasBackEllipsis ? 1 : 0);

        // check if there's enough slots to display the first and last pages
        let hasFirstPage = this._currentPageNumber === 1 || slotsBeforeCurrentPage > 0;
        let hasLastPage = this._currentPageNumber === this._numberOfPages || slotsAfterCurrentPage > 0;
        slotsBeforeCurrentPage -= (slotsBeforeCurrentPage > 0 ? 1 : 0);
        slotsAfterCurrentPage -= (slotsAfterCurrentPage > 0 ? 1 : 0);

        // figure out what to delete from the current [1, _numberOfPages] list 
        let deleteFromFrontCount = this._currentPageNumber - slotsBeforeCurrentPage - (hasFirstPage ? 2 : 1);
        let deleteFromBackCount = this._numberOfPages - (this._currentPageNumber + slotsAfterCurrentPage + (hasLastPage ? 1 : 0));

        // splice: starting at index <arg1>, delete <arg2> elements and replace with <arg3> (if arg3 exists)
        this._pageList.splice(this._currentPageNumber + slotsAfterCurrentPage, 
                              deleteFromBackCount, 
                              ...(hasBackEllipsis ? [{key: '2...' + Date.now(), number: '...', class: "slds-align--absolute-center ellipsis"}] : []));
        this._pageList.splice((hasFirstPage ? 1 : 0), 
                              deleteFromFrontCount, 
                              ...(hasFrontEllipsis? [{key: '1...' + Date.now(), number: '...', class: "slds-align--absolute-center ellipsis"}] : [])); 
    }

    createPageList() {
        this._pageList = [];
        this._numberOfPages = this.getNumberOfPages();

        if (this._numberOfPages <= 1) {
            this.showPagination = false;
            this.setDataToDisplay();
            return;
        }

        this.pushPageRange(1, this._numberOfPages);
        this._isCheckPageListLength = true;
        this.addEllipsisToPageList();
        this.setDataToDisplay();
        this.showPagination = true;
    }

    pushPageRange(start, end) {
        let timestamp = Date.now();
        for (let pageNumber = start; pageNumber <= end; pageNumber++) {
            let page = {key: pageNumber.toString() + timestamp, number: pageNumber, class: "slds-align--absolute-center"}
            if (pageNumber === this._currentPageNumber) {
                page.class += " active";
            }
            this._pageList.push(page);
        }
    }

    handlePreviousClick() {
        if (this._currentPageNumber> 1) {
            this._currentPageNumber= this._currentPageNumber- 1;
            this.createPageList();
        }
    }

    handleNextClick() {
        if (this._currentPageNumber < this._numberOfPages) {
            this._currentPageNumber = this._currentPageNumber+ 1;
            this.createPageList();

        } else {  // query more
            if (this._currentNumberOfItems < this.totalNumberOfItems || !this.totalNumberOfItems) {
                const params = {'detail': {'offset' : this._currentNumberOfItems, 'pageNumber': this._currentPageNumber}};
                this.queryMore(params, (records) => {
                    if (records && records.length > this.queriedData.length) {
                        this._currentPageNumber = this._currentPageNumber + 1;
                        this.queriedData = records;
                    }
                });
            }
        }
    }

    handlePageNumberClick(event) {
        let pageNumber = parseInt(event.target.dataset.pagenumber, 10);

        if (isNaN(pageNumber) || 
                pageNumber == this._currentPageNumber ||
                pageNumber < 1 ||
                pageNumber > this._numberOfPages) {

            return;
        }

        this._currentPageNumber= pageNumber;
        this.createPageList();

    }

    setDataToDisplay() {
        let offset = (this._currentPageNumber- 1) * parseInt(this.recordsPerPage);
        let paginatedData = this._currentData.slice(offset, offset + parseInt(this.recordsPerPage));

        this.handlePageChange(paginatedData, this._currentPageNumber);
    }

    getNumberOfPages() {
        if (this.recordsPerPage <= 0 || this._currentNumberOfItems === undefined) {
            return 0;
        }
        return Math.ceil(this._currentNumberOfItems / this.recordsPerPage);
    }

}