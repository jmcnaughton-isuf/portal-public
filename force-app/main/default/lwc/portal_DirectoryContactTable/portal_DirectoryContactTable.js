import { LightningElement, api, track } from 'lwc';

export default class Portal_DirectoryContactTable extends LightningElement {
    @api get contactList() {
        return this._contactList;
    }

    set contactList(value) {
        if (this.template.querySelector('c-portal_-table')) {
            this.template.querySelector('c-portal_-table').resetTable();
        }

        this._contactList = value;
        this.handleSetContactList();
    }

    @api itemsPerPage = 15;

    @track _contactList = [];
    @track _contactListToDisplay = [];
    @track _currentPageNumber = 1;
    @track _numberOfPages = 1;

    @track _pageList = [];

    get hasMoreThanOnePage() {
        return this._pageList.length > 1;
    }

    get hasContactList() {
        if (this.contactList && this.contactList.length !== 0) {
            return true;
        }

        return false
    }

    get columnDataList() {
        return [{label: 'First Name', fieldId: 'firstNameHtml', fieldType: 'html'},
                {label: 'Last Name', fieldId: 'lastNameHtml', fieldType: 'html'},
                {label: 'Degree', fieldId: 'degree', fieldType: 'text'},
                {label: 'Degree Year', fieldId: 'degreeYear', fieldType: 'text'},
                {label: 'Job Title', fieldId: 'jobTitle', fieldType: 'text'},
                {label: 'Employer', fieldId: 'companyName', fieldType: 'text'}]
    }

    handleSetContactList() {
        let resultList = [];
        if (!this._contactList) {
            return;
        }

        for (let eachContact of this._contactList) {
            resultList.push(Object.assign({firstNameHtml: '<a target="_blank" href="directory-profile?recordId=' + eachContact.contactId + '">' + (eachContact.firstName ? eachContact.firstName : '') + '</a>',
                                           lastNameHtml: '<a target="_blank" href="directory-profile?recordId=' + eachContact.contactId + '">' + eachContact.lastName + '</a>'}, eachContact));
        }

        this._contactList = resultList;
    }

    // setContactListToDisplay() {
    //     let startIndex = (this._currentPageNumber - 1) * this.itemsPerPage;
    //     let endIndex = this._currentPageNumber * this.itemsPerPage;

    //     if (endIndex > this._contactList.length) {
    //         endIndex = this._contactList.length;
    //     }

    //     this._contactListToDisplay = this._contactList.slice(startIndex, endIndex);
    // }

    // setPageList() {
    //     this._pageList = [];

    //     for (let pageNumber = 1; pageNumber <= this._numberOfPages; pageNumber++) {
    //         let page = {number: pageNumber, class: ""}
    //         if (pageNumber === this._currentPageNumber) {
    //             page.class = "active";
    //         }
    //         this._pageList.push(page);
    //     }
    // }

    // handlePreviousClick() {
    //     if (this._currentPageNumber > 1) {
    //         this._currentPageNumber = this._currentPageNumber - 1;
    //         this.setPageList();
    //         this.setContactListToDisplay();
    //     }
    // }

    // handleNextClick() {
    //     if (this._currentPageNumber < this._pageList.length) {
    //         this._currentPageNumber = this._currentPageNumber + 1;
    //         this.setPageList();
    //         this.setContactListToDisplay();
    //     }
    // }

    // handlePageNumberClick(event) {
    //     let pageNumber = parseInt(event.target.dataset.pagenumber, 10);
    //     if (this._currentPageNumber !== pageNumber) {
    //         this._currentPageNumber = pageNumber;
    //         this.setPageList();
    //         this.setContactListToDisplay();
    //     }
    // }

    // handleNameClick(event) {
    //     let recordId = event.target.dataset.id;

    //     window.open('/s/directory-profile?recordId=' + recordId);
    // }
}