import { LightningElement, api, track} from 'lwc';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import getLookWhosComingList from '@salesforce/apex/PORTAL_LWC_ListingDetailController.SERVER_getLookWhosComingList';

const URL_PARAM_RECORD_ID = 'recordId';
const URL_PARAM_LISTING_NAME = 'listingName';

export default class Portal_EventParticipationList extends LightningElement {
    @api listTitle = "Look Who's Coming!";
    @api itemsPerPage = 9;

    @track lookWhosComingMinimum = undefined;
    @track listingParticipations = [];
    @track visibleData = [];
    @track listingParticipationsToDisplay = [];

    get isDisplayList() {
        return this.listingParticipations?.length && (this.lookWhosComingMinimum === undefined || this.listingParticipations.length >= this.lookWhosComingMinimum);
    }

    get isDisplayReset() {
        return this.listingParticipations?.length !== this.listingParticipationsToDisplay?.length;
    }

    get isDisplayNoResults() {
        return this.listingParticipationsToDisplay?.length < 1;
    }

    connectedCallback() {
        let urlParams = new URLSearchParams(window.location.search);
        const params = {'recordId': urlParams.get(URL_PARAM_RECORD_ID), 'recordName': urlParams.get(URL_PARAM_LISTING_NAME)};
        callApexFunction(this, getLookWhosComingList, params, (data) => {
            this.lookWhosComingMinimum = data?.lookWhosComingMinimum;
            this.listingParticipations = data?.listingParticipations;
            this.listingParticipationsToDisplay = this.listingParticipations;
        }, () => {});
    }

    handlePageChange = (paginatedData) => {
        this.visibleData = paginatedData;
    }

    handleSearch(event) {
        event.preventDefault();

        let searchInput = this.template.querySelector(`[data-id="search-input"]`).value.toLowerCase();

        const tempResults = this.listingParticipations.filter(eachParticipation => eachParticipation.participationNameTag.toLowerCase().includes(searchInput));

        this.listingParticipationsToDisplay = tempResults;
    }

    handleReset() {
        this.template.querySelector(`[data-id="search-input"]`).value = '';
        this.listingParticipationsToDisplay = this.listingParticipations;
    }
}