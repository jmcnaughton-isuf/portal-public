import { api, LightningElement, track } from 'lwc';

export default class Portal_SocietyMembershipDisplayTable extends LightningElement {
    @api title;
    @api columnMappings = []; // [{label: 'label', fieldId: 'fieldId', fieldType: 'fieldType'}]
    @api rowsPerPage = 10;
    @api queryMore = () => {};
    @api handleCheckboxClick = () => {};

    @api get records() {
        return this._records;
    }

    set records(value) {
        if (!value) {
            return;
        }

        let index = 0;
        for (let eachRecord of value) {
            this._records.push(Object.assign({index: index}, eachRecord));
            index++;
        }

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

    handlePageChange = (recordsToDisplay) => {
        this._recordsToDisplay = recordsToDisplay;
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
        this.equalHeight(true);
        window.addEventListener('resize', (event) => {this.equalHeight(true);});
    }

    equalHeight = (resize) => {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = [];
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        if(resize === true){
            for(let i = 0; i < elements.length; i++){
                elements[i].style.height = 'auto';
            }
            for(let i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
            for(let i = 0; i < expandedElements.length; i++){
                expandedElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < elements.length; i++){
            var elementHeight = elements[i].clientHeight;
            allHeights.push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < expandedElements.length; i++){
            var elementHeight = expandedElements[i].clientHeight;
            allRowHeights.push(elementHeight);
        }

        for(let i = 0; i < elements.length; i++){
            elements[i].style.height = Math.max.apply( Math, allHeights) + 'px';
            if(resize === false){
                elements[i].className = elements[i].className + " show";
            }
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
            if(resize === false){
                headerElements[i].className = headerElements[i].className + " show";
            }
        }

        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = Math.max.apply( Math, allRowHeights) + 'px';
            if(resize === false){
                expandedElements[i].className = expandedElements[i].className + " show";
            }
        }
    }


}