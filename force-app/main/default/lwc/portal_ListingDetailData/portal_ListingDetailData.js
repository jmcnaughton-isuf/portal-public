import { LightningElement, wire, api, track} from 'lwc';
import SERVER_getFrontEndDataMap from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap';

import IS_GUEST from '@salesforce/user/isGuest'
import isUserAdministrator from '@salesforce/apex/PORTAL_LWC_EventManagementController.SERVER_isUserAdministrator';

import getListingDetailsById from '@salesforce/apex/PORTAL_LWC_ListingDetailController.SERVER_getListingDetailsById';
import getListingDetailsByName from '@salesforce/apex/PORTAL_LWC_ListingDetailController.SERVER_getListingDetailsByName';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { getCookie } from 'c/portal_util_Cookie';

import { subscribe, publish, MessageContext } from 'lightning/messageService';
import LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Listing_Details__c';
import REQUEST_LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Request_Listing_Details__c';

const URL_PARAM_RECORD_ID = 'recordId';
const URL_PARAM_LISTING_NAME = 'listingName';
const URL_PARAM_ERROR_MESSAGE= 'errorMessage';



const CANNOT_VALIDATE_USER_PROFILE_NAME_ERROR =  'There was an error trying to validate your User Profile ' +
                                                 'Name, which is needed to check if your Profile can request ' +
                                                 'Listing Details by their Record ID. Either try again, login as a ' +
                                                 'different user, or try searching by Record Name instead.';
const NO_URL_PARAMETERS_GIVEN_ERROR = 'No Record ID or Listing Name were provided. Please make sure to specify at ' +
                                      'least one of these Listing search parameters.'


export default class Portal_ListingDetailData extends LightningElement {
    @api statusPriorityOrder;
    @track isShowSpinner = true;

    frontEndDataMap = {};

    _pageName = 'Listing Detail Page';
    _mainSectionName = 'Listing Detail';

    _recordId = null;
    _recordName = null;

    _listingList = [];
    _profileData = null;
    _subscription = null;
    _isSoldOut = false;
    _primaryParticipationId = '';
    _isBookmarked = false;
    _isNotInterested = false;
    _cookieId = getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

    @wire(MessageContext)
    messageContext;

    get frontEndDataMapParams() {
        return {pageName: this._pageName, mainSectionName: this._mainSectionName};
    }

    get listing() {
        if (this._listingList && this._listingList.length != 0) {
            this._listingList[0] = Object.assign({isSoldOut: this._isSoldOut, primaryParticipationId: this._primaryParticipationId, isBookmarked: this._isBookmarked, isNotInterested: this._isNotInterested}, this._listingList[0]);
        }

        if (!this._listingList || !this._listingList.length || this._listingList.length === 0) {
            return null;
        } else if (this._listingList.length > 1 && this.statusPriorityOrder) {
            return this.getTopPriorityListing(this._listingList, this.statusPriorityOrder);
        }

        return this._listingList[0];
    }

    connectedCallback() {
        let urlParams = new URLSearchParams(window.location.search);
        let URLrecordId = urlParams.get(URL_PARAM_RECORD_ID);
        let URLrecordName = urlParams.get(URL_PARAM_LISTING_NAME);
        if (URLrecordId || URLrecordName) {
            this._recordId = URLrecordId;
            this._recordName = URLrecordName;
        }

        if (this._recordId && !this._recordName) { // if only record Id is in link, keep it for admins
            if (IS_GUEST) {
                this.redirectToLogin();
            }

            isUserAdministrator().then((isCurrentUserAnAdmin) =>{
                if (isCurrentUserAnAdmin) {
                    this.getListingById();
                } else {
                    this.redirectToLogin();
                }
            }).catch(error => {
                this.redirectToErrorPage(CANNOT_VALIDATE_USER_PROFILE_NAME_ERROR);
            });
        } else if (this._recordName && !this._recordId) { // if only name in the link, search on name, this is to keep backwards compatibility
            this.getListingByName();
        } else if (this._recordName && this._recordId) {
           this.getListingById();
        }

        this.subscribeToMessageChannel();
    }

    renderedCallback() {
        this.publishAll(this.listing);
    }

    getListingById() {
        this.getListing(getListingDetailsById, {recordId: this._recordId, recordName: this._recordName, cookieId: this._cookieId}, (error) => {
            this.redirectToErrorPage(this.createFailedQueryErrorMessage([{label: 'Record ID', value: this._recordId}]))
        });
    }

    getListingByName() {
        this.getListing(getListingDetailsByName, {recordName: this._recordName, cookieId: this._cookieId}, () => {});
    }

    getListing(apexFunction, params, errorCallback) {
        Promise.all([callApexFunction(this, apexFunction, params, this.handleListingDetailResponse, errorCallback),
                     callApexFunction(this, SERVER_getFrontEndDataMap, this.frontEndDataMapParams, (data) => {this.frontEndDataMap = data;}, () => {})])
        .then(() => {
            this.publishAll(this.listing);
        })
        .catch((error) => {
            console.log(error);
        })
        .finally(() => {
            this.isShowSpinner = false;
        });
    }

    handleListingDetailResponse = (data) => {
        this._listingList = [];
        data?.listingDetails?.forEach(listing => {
            this._listingList.push({...listing, isRegisteredForEvent: ((listing.listingParticipations && listing.listingParticipations.length > 0) || data.primaryParticipationId)});
        });

        this._isSoldOut = data.isSoldOut;
        this._primaryParticipationId = data.primaryParticipationId;
        this._isBookmarked = data.isBookmarked;
        this._isNotInterested = data.isNotInterested;
    }

    /**
     * Returns the top priority Listing in "listingList" based
     * on the "statusPriorityOrder" (semicolon deliminated string of status's
     * [highest -> lowest priority]).
     */
    getTopPriorityListing(listingList, statusPriorityOrder) {
        if (!listingList || !listingList.length) {
            return null;
        }

        if (!statusPriorityOrder) {
            return listingList[0];
        }

        let buckets = {};
        let statusList = statusPriorityOrder.trim().split(';');
        //console.log('status list before trimming : ', statusList);

        // Clean up the user input
        statusList = statusList.map(eachStatus => {
            return eachStatus.trim().toLowerCase();
        });
        //console.log('status list after trimming : ', statusList);
        // Remove duplicate status names
        statusList = statusList.filter((eachStatus, index) => {
            return statusList.indexOf(eachStatus) === index;
        });
        //console.log('status list after removing duplicates : ', statusList);

        // Create a listing bucket for each status
        statusList.forEach(eachStatus => {
            buckets[eachStatus] = [];
        });

        // Place listings in status buckets, or return the 1st
        // listing with the most favored status
        for (let i = 0; i < listingList.length; i++) {
            let listing = listingList[i];
            if (listing.status.toLowerCase() === statusList[0]) {
                return listing;
            }

            if (buckets[listing.status.toLowerCase()]) {
                buckets[listing.status.toLowerCase()].push(listing);
            }
        }

        // Find the top priority listing
        for (let i = 0; i < statusList.length; i++) {
            let eachStatus = statusList[i];
            if (buckets[eachStatus].length >= 1) {
                return buckets[eachStatus][0];
            }
        }

        // none of the Listings matched one of the given status
        return listingList[0];
    }

    redirectToLogin() {
        window.location.href = 'login';
    }

    redirectToErrorPage(errorMessage) {
        window.location.href = 'listing-detail/error?' + URL_PARAM_ERROR_MESSAGE + '=' + errorMessage;
    }

    createFailedQueryErrorMessage(searchParams) {
        let errorMessage = 'Could not find the Listing with the provided ';
        searchParams.forEach(eachParam => {
            errorMessage += eachParam.label + ' ( ' + eachParam.value + ' ) and ';
        });

        // Remove the last ' and '
        let lastIndex = errorMessage.lastIndexOf('and ');
        errorMessage = errorMessage.substring(0, lastIndex);

        errorMessage += '. Make sure these parameters are correct, then try again.';
        return errorMessage;
    }

    subscribeToMessageChannel() {
        this._subscription = subscribe(this.messageContext, REQUEST_LISTING_DETAILS_CHANNEL,
                                       (message) => this.handleMessage(message));
    }

    /**
     * When a component requests new Listing data.
     */
    handleMessage(message) {
        switch (message.requester) {
            case 'Header':
                this.publishHeader(this.listing);
                break;
            case 'Body':
                this.publishBody(this.listing);
                break;
            case 'Footer':
                this.publishFooter(this.listing);
                break;
            default:
                break;
        }
    }

    /**
     * Send Listing data to just the Header.
     */
    publishHeader(listing) {
        if (!listing) {
            return;
        }

        const payloadHeader = {type: 'Header', listing: this.listing, contentModuleList: listing.listingContentModules, frontEndDataMap: this.frontEndDataMap};
        publish(this.messageContext, LISTING_DETAILS_CHANNEL, payloadHeader);
    }

    // Listing Detail - <name> (e.g. Listing Detail - Header Content)

    /**
     * Send Listing data to just the Body.
     */
    publishBody(listing) {
        if (!listing) {
            return;
        }
        const payloadBody = {type: 'Body', listing: listing, contentModuleList: listing.listingContentModules, frontEndDataMap: this.frontEndDataMap};
        publish(this.messageContext, LISTING_DETAILS_CHANNEL, payloadBody);
    }

    /**
     * Send Listing data to just the Footer.
     */
    publishFooter(listing) {
        if (!listing) {
            return;
        }
        const payloadFooter = {type: 'Footer', listing: listing, contentModuleList: listing.listingContentModules, frontEndDataMap: this.frontEndDataMap};
        publish(this.messageContext, LISTING_DETAILS_CHANNEL, payloadFooter);
    }

    /**
     * Send Listing data to the Header, Body, & Footer.
     */
    publishAll(listing) {
        if (!listing) {
            return;
        }
        this.publishHeader(listing);
        this.publishBody(listing);
        this.publishFooter(listing);
    }
}