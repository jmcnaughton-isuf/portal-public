import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRegisteredParticipations from '@salesforce/apex/PORTAL_LWC_EventManagementController.SERVER_getRegisteredParticipations';
import markParticipationAsAttended from '@salesforce/apex/PORTAL_LWC_EventManagementController.SERVER_markParticipationAsAttended';
import deleteParticipationRecord from '@salesforce/apex/PORTAL_LWC_EventManagementController.SERVER_deleteParticipationRecord';

export default class Portal_EventManagement extends LightningElement {
    @api rowsPerPage;  // design attribute
    @track participationList = [];
    @track showSpinner = true;
    @track registeredParticipants = 0;
    @track attendedParticipants = 0;
    @track attendedParticipantsToRegistered = 0;
    @track searchString = '';

    @track visibleTableData;
    @track currentPage = 1;

    totalNumberOfPages;
    eventListingName;
    eventListingId;
    totalNumberOfItems = 2000;
    _numberOfRowsWhenSearching;

    connectedCallback() {
        // get all registered participations for this event
        // get listing name from url
        let urlQueryString = window.location.search;
        let urlParams = new URLSearchParams(urlQueryString);

        let eventName = urlParams.get('name');

        const params = {params: {name: eventName, search: this.searchString, offset: 0}};

        this.queryForRecords(params);
    }

    queryForRecords(params) {
        getRegisteredParticipations(params)
        .then(res => {
            if (res.participationList && res.participationList.length > 0) {
                this.eventListingId = res.eventId;
                this.eventListingName = res.eventName;

                this.registeredParticipants = res.participationCountTotal;
                this.attendedParticipants = res.attendedParticipationCountTotal;

                // this value is for the polar gauge
                this.attendedParticipantsToRegistered = (this.attendedParticipants / this.registeredParticipants) * 100;

                // if we are searching for name, the amount of rows to paginate will be different
                if (res.searchParticipationCountTotal > 0) {
                    this._numberOfRowsWhenSearching = res.searchParticipationCountTotal;
                } else {
                    this._numberOfRowsWhenSearching = this.registeredParticipants;
                }

                this.participationList = [...this.participationList, ...res.participationList];

                this.totalNumberOfPages = Math.ceil(this._numberOfRowsWhenSearching / this.rowsPerPage);
                this.totalNumberOfPagesThisQuery = Math.ceil(this.participationList.length / this.rowsPerPage);

                this.checkForAdditionalQuery();
                this.showSpinner = false;
            } else {
                this.eventListingId = res.eventId;
                this.eventListingName = res.eventName;
                this.registeredParticipants = res.participationCountTotal;
                this.attendedParticipants = res.attendedParticipationCountTotal;

                // this value is for the polar gauge
                this.attendedParticipantsToRegistered = (this.attendedParticipants / this.registeredParticipants) * 100;

                this.showSpinner = false;
                this.participationList = [];
            }
        }).catch(e => {
            let errorMap = JSON.parse(e.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        });
    }

    checkForAdditionalQuery() {
        // if user modifies table or hits refresh, we want to keep them on the same page
        if (this.currentPage > this.totalNumberOfPagesThisQuery
            && this.totalNumberOfPagesThisQuery < this.totalNumberOfPages) {
            const params = {params: {name: this.eventListingName,
                                        search: this.searchString,
                                        offset: this.participationList.length
                                    }};
            this.queryForRecords(params);
        } else if (this.currentPage > this.totalNumberOfPagesThisQuery) {
            // if user deletes a record, and that deletion shrinks number of pages, need to make sure the current page is in sync
            this.currentPage = this.totalNumberOfPagesThisQuery;
        }
    }

    handleSearch() {
        this.currentPage = 1;
        this.handleRefresh();
    }

    handleRefresh() {
        this.showSpinner = true;
        this.participationList = [];
        this.queryForRecords({params: {name: this.eventListingName,
                                        search: this.searchString,
                                        offset: 0}});
    }

    handleMarkParticipationAsAttended = (event) => {
        let eventId = event.id;
        let eventAttendNewValue = !event.attendedValue;

        markParticipationAsAttended({params: {participationId: eventId, attendValue : eventAttendNewValue}})
        .then(() => {
            this.handleRefresh();
        }
        ).catch(error => {
            console.log(error);
        });
    }

    handleDeleteParticipationRecord = (event) => {
        this.showSpinner = true;
        deleteParticipationRecord({params: {participationId: event.id}})
        .then( () => {
            this.handleRefresh();
        }
        ).catch(error => {
            console.log(error);
        });
    }

    handleAddAttendee() {
        window.location.href = './event-registration?recordId='
                                + this.eventListingId
                                + '&walkIn=true';
    }

    handleSearchInput = (event) => {
        let value = event.target.value;
        this.searchString = value;
    }

    handleQueryMore = (event) => {
        if (this.currentPage >= Math.ceil(this._numberOfRowsWhenSearching / this.rowsPerPage)) {
            return;
        }

        this.showSpinner = true;
        this.currentPage = event.detail.pageNumber + 1;
        const params = {params: {name: this.eventListingName,
                                search: this.searchString,
                                offset: event.detail.offset
                        }};
        this.queryForRecords(params);
    }

    handlePageChange = (paginatedData, pageNumber) => {
        this.visibleTableData = paginatedData;
        this.currentPage = pageNumber;
    }
}