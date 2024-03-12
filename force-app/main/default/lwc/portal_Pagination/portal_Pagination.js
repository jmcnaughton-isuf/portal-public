import ContactMobile from '@salesforce/schema/Case.ContactMobile';
import { api, LightningElement } from 'lwc';

export default class Portal_Pagination extends LightningElement {
    // pagination info
    paginationInfo = [];
    showPagination = false;
    currentPageNumber = 1;
    _totalNumberOfRows = 0;

    // ensure variables are loaded before instantiating this component
    @api itemsPerPage;
    @api totalNumberOfRows = 0;

    @api
    get currentPage() {
        return this.currentPageNumber;
    }

    set currentPage(data) {
        if (data) {
            this.currentPageNumber = data;
            this.connectedCallback();
        }
    }

    @api
    get numberOfRows () {
        return this.totalNumberOfRows;
    }

    set numberOfRows(data) {
        if (data) {
            this.connectedCallback();
        }
    }

    connectedCallback() {
        this.createPaginationInfo();
    }

    createPaginationInfo() {
        let numberOfPages = this.getNumberOfPages();
        this.paginationInfo = [];

        if (numberOfPages <= 1) {
            this.showPagination = false;
            return;
        }

        for (let i = 1; i <= numberOfPages; i++) {
            let active = false;

            if (i == this.currentPageNumber) {
                active = true;
            }

            this.paginationInfo.push({'label' : i, 'pageNumber' : i, 'active' : active, 'class': active ? 'active' : ''});
        }

        this.showPagination = true;
    }

    onClickChangePage(event) {
        let pageNumber = event.target.dataset.page;

        if (pageNumber == this.currentPageNumber) {
            return;
        }

        this.changePage(pageNumber);

        const pageClickEvent = new CustomEvent(
            'pagechange', {'detail' : {'offset' : ((this.currentPageNumber - 1) * this.itemsPerPage), 'itemsPerPage' : this.itemsPerPage, 'pageNumber': this.currentPageNumber}}
        );

        this.dispatchEvent(pageClickEvent);

    }

    changePage(pageNumber) {
        let numberOfPages = this.getNumberOfPages();

        if (pageNumber == this.currentPageNumber || pageNumber < 1 || pageNumber > numberOfPages) {
            return;
        }

        this.currentPageNumber = pageNumber;
        this.createPaginationInfo();
    }

    handlePrev() {
        this.changePage(this.currentPageNumber - 1);

        const pageClickEvent = new CustomEvent(
            'pagechange', {'detail' : {'offset' : ((this.currentPageNumber - 1) * this.itemsPerPage), 'itemsPerPage' : this.itemsPerPage, 'pageNumber': this.currentPageNumber}}
        );

        this.dispatchEvent(pageClickEvent);

    }

    handleNext() {
        this.changePage(this.currentPageNumber + 1);

        const pageClickEvent = new CustomEvent(
            'pagechange', {'detail' : {'offset' : ((this.currentPageNumber - 1) * this.itemsPerPage), 'itemsPerPage' : this.itemsPerPage, 'pageNumber': this.currentPageNumber}}
        );

        this.dispatchEvent(pageClickEvent);

    }

    getNumberOfPages() {
        if (this.itemsPerPage <= 0) {
            return 0;
        }
        return Math.ceil(this.totalNumberOfRows / this.itemsPerPage);
    }

}