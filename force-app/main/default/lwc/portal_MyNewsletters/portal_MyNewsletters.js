import { LightningElement, api, track } from 'lwc';
import SERVER_getMyNewsletters from '@salesforce/apex/PORTAL_LWC_NewsletterController.SERVER_getMyNewsletters';
export default class PORTAL_MyNewsletters extends LightningElement {

    @api noNewslettersMessage = "There are no newsletters that match your search."

    @api recordsPerPage = 10;
    _offset = 0;
    _currentPage = 1;
    _totalItems = 0;

    @track _searchTextInInput = '';
    _searchText = '';
    _minimumSearchLength = 2;

    _newsletterList = [];
    _frontEndDataMap = {};
    _isCallbackDone = false;
    _visibleData = [];
    _isShowPreview = false;
    _previewNewsletterId = '';
    _previewName = '';
    _showSpinner = true;
    _isLoaded = false;

    get _hasNewsletters() {
        return this._visibleData.length > 0;
    }

    connectedCallback() {
        this.getRecords();
    }

    renderedCallback() {
        this.equalHeight(true);
    }

    getRecords(pageNumberToSet = 1) {
        this._showSpinner = true;
        const params = {params: {offset: this._offset, searchText: this._searchText}};
        this._isLoaded = false;
        SERVER_getMyNewsletters(params).then(res => {
            let queriedList = [];

            for (let eachNewsletter of res.recordsMap.Submitted_Newsletters.records) {
                let newNewsletter = Object.assign({}, eachNewsletter);
                if (newNewsletter.Status__c != 'Pending' && newNewsletter.Status__c != 'Rejected') {
                    newNewsletter.disabled = true;
                } else {
                    newNewsletter.disabled = false;
                }
                queriedList.push(newNewsletter);
            }

            this._newsletterList = [...this._newsletterList, ...queriedList];
            this._frontEndDataMap = {...res.frontEndDataMap};

            this._totalItems = this._newsletterList.length + (res.hasMoreRecords ? 1 : 0);

            if (this._currentPage !== pageNumberToSet) {
                this._currentPage = pageNumberToSet;
            }

            this._isCallbackDone = true;
        }).catch(console.error).finally(() => {
            this._showSpinner = false;
            this._isLoaded = true;
        });
    }

    handleQueryMore = (event) => {
        this._offset = event.detail.offset;
        this.getRecords(event.detail.pageNumber + 1);
    }

    handlePageChange = (paginatedData) => {
        this._visibleData = paginatedData;
    }

    handleSearchInputChange = (event) => {
        this._searchTextInInput = event.currentTarget.value;
    }

    handleClearSearch = (event) => {
        this._searchTextInInput = '';
    }

    handleSearch = (event) => {
        if (this._searchTextInInput && this._searchTextInInput.length < this._minimumSearchLength) {
            this.template.querySelector('c-portal_-input').reportValidity();
            return;
        }
        
        this._searchText = this._searchTextInInput;
        this._offset = 0;
        this._newsletterList = [];
        this.getRecords();
    }

    openCreateNewsletter(event) {
        window.location.href = 'newsletter-submission';
    }

    openEditNewsletter(event) {
        let index = event.currentTarget.getAttribute('data-index');
        let clone = event.currentTarget.getAttribute('data-c');
        let id = this._visibleData[index].Id;
        window.location.href = 'newsletter-submission?rid=' + id + '&c=' + clone;
    }

    displayPreview(event) {
        let index = event.currentTarget.getAttribute('data-index');
        this._previewNewsletterId = this._visibleData[index].Id;
        this._previewName = this._visibleData[index].Name;
        this._isShowPreview = true;
    }

    closePreview(event) {
        //if clicking on the background of the modal OR the modal's close buttons, we want to close the modal but not click on any buttons behind it
        this._isShowPreview = false;
        event.preventDefault();
        event.stopImmediatePropagation();
    }

    clickIgnore(event) {
        //if clicking INSIDE the modal we want to stop propagating this click so modal doesn't close
        event.preventDefault();
        event.stopImmediatePropagation();
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