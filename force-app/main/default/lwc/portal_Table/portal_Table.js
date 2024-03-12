import { api, LightningElement, track } from 'lwc';

export default class Portal_Table extends LightningElement {
    @api title;
    @api columnMappings = []; // [{label: 'label', fieldId: 'fieldId', fieldType: 'fieldType'}]
    @api rowsPerPage = 10;
    @api currentPageNumber = 1;
    @api queryMore = () => {};
    @api independentRowHeight = false;
    @api tableStyle;

    _resizeObserver;
    _checkForZeroHeightInterval;

    @api checkValidity() {
        let entries = this.template.querySelectorAll('c-portal_-table-entry');
        for (let eachEntry of entries) {
            if (!eachEntry.checkValidity()) {
                return false;
            }
        }
        return true;
    }

    @api reportValidity() {
        let entries = this.template.querySelectorAll('c-portal_-table-entry');
        for (let entry of entries) {
            entry.reportValidity();
        }
    }

    // sync user input with underlying data structure
    syncInputText = (pageOffset, subitemIndex, fieldId, value) => {
        let recordIndex = (this._currentPage - 1) * this.rowsPerPage + pageOffset;
        if (subitemIndex === undefined) {
            this._records[recordIndex][fieldId] = value;
        }
        else {
            let newRecord = {...this._records[recordIndex].expandedData[subitemIndex]};
            newRecord[fieldId] = value;
            let newExpandedData = [...this._records[recordIndex].expandedData];
            newExpandedData[subitemIndex] = newRecord;
            this._records[recordIndex].expandedData = newExpandedData; 
        }
    }

    @api get records() {
        return this._records;
    }

    set records(value) {
        this._records = [];
        if (!value) {
            return;
        }

        let index = 0;
        for (let eachRecord of value) {
            this._records.push(Object.assign({index: index}, eachRecord));
            index++;
        }

    }

    @api
    resetTable() {
        this._currentPage = 1;
        this._records = [];
    }

    @track _currentPage = 1;
    @track _recordsToDisplay = [];
    @track _records = [];

    get totalNumberOfRows() {
        return this.records.length;
    }

    get isShowPagination() {
        return this.records.length > this.rowsPerPage;
    }

    handlePageChange = (recordsToDisplay, currentPage) => {
        this._recordsToDisplay = recordsToDisplay;
        this._currentPage = currentPage;
    }

    handleExpandData = (record) => {
        for (let eachRecord of this._records) {
            if (eachRecord.index == record.index) {
                if (eachRecord.isShowExpandedData)  {
                    eachRecord.isShowExpandedData = false;
                    break;
                }

                eachRecord.isShowExpandedData = true;
                eachRecord.key = Date.now();
            }
        }
    }

    renderedCallback() {
        try {
            this.createResizeObserver();
        } catch (error) {
            setInterval(() => {this.fixZeroHeight();}, 100);
        }
        this.equalHeight(true, this.independentRowHeight);
        window.addEventListener('resize', (event) => {this.equalHeight(true, this.independentRowHeight);});
    }

    fixZeroHeight = () => {
        let headerElement = this.template.querySelector('.headerEqualHeight');
        if (headerElement) {
            if (headerElement.style.height === '0px') {
                this.equalHeight(true, this.independentRowHeight);
            }
        }
    }

    createResizeObserver() {
        if (this._resizeObserver) { 
            return; 
        }

        let headerElement = this.template.querySelector('.headerEqualHeight');

        this._resizeObserver = new ResizeObserver(entries => {
            if (entries[0].contentRect.height == 0){
                if (!this._checkForZeroHeightInterval){
                    
                    this._checkForZeroHeightInterval = setInterval(() => {
                        // any element will do, this one is arbitrarily used
                        if (entries[0].target.style.height === '0px') {
                            this.equalHeight(true, this.independentRowHeight);
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

    @api
    equalHeight(resize, independentRows = false) {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = {}; 
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        for(let i = 0; i < elements.length; i++){
            elements[i].style.height = 'auto';
        }
        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = 'auto';
        }
        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = 'auto';
        }

        // get expected heights, option to treat each row independent
        for(let i = 0; i < elements.length; i++){
            var elementHeight = elements[i].clientHeight;
            let rowIndex = independentRows ? elements[i].dataset.index : 0;
            allHeights[rowIndex] = allHeights[rowIndex] || [];
            allHeights[rowIndex].push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < expandedElements.length; i++){
            var elementHeight = expandedElements[i].clientHeight;
            allRowHeights.push(elementHeight);
        }

        // use max height
        for(let i = 0; i < elements.length; i++){
            let rowIndex = independentRows ? elements[i].dataset.index : 0;
            elements[i].style.height = Math.max.apply( Math, allHeights[rowIndex]) + 'px';
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
        }

        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = Math.max.apply( Math, allRowHeights) + 'px';
        }
    }
}