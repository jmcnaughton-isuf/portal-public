import { LightningElement, api, wire, track } from 'lwc';
import { DateFormatter } from 'c/portal_util_DateFormatter';
import { getCookie } from 'c/portal_util_Cookie';
import basePath from '@salesforce/community/basePath';
import SERVER_getListingConfigurations from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingConfigurations';
import SERVER_getFrontEndDataMap from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap';
import searchListings from '@salesforce/apex/PORTAL_LWC_ListingSearchController.SERVER_searchListings';
import SERVER_getListingButtonText from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingButtonText';
import allEventsTemplate from './portal_ListingAllEvents.html';
import allNewsTemplate from './portal_ListingAllNews.html';
import allAnnouncementsTemplate from './portal_ListingAllAnnouncements.html';
import allHomeAnnouncementsTemplate from './portal_ListingHomeAnnoucements.html';
import allZoneHomeEventsTemplate from './portal_ListingZoneHomeEvents.html';
import noneTemplate from './portal_Listing.html';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const URL_PARAM_ZONE_NAME = 'zname';

export default class Portal_Listing extends LightningElement {
    @api pageName = "";
    @api mainSectionName = "";
    @api subSectionName = "";
    @api design = "";
    @api setSectionTitles = () => {};

    //optional param. if set to true, this component will not query by default and will expect parent components to call the query and/or pass in listings
    @api preventLoadQuery = false;

    @api get listingList() {
        return this._listingList;
    }

    set listingList(value) {
        if (value) {
            this._listingList = this.parseListingData(value);
            this._currentPage = 1;
            this.setPageList();

            if (!this._listingList || this._listingList.length <= 0) {
                return;
            }

            for (let eachListing of this._listingList) {
                if (!eachListing || Object.keys(eachListing).length === 0) {
                    continue;
                }

                if (eachListing.thumbnailImage) {
                    eachListing.thumbnailImageUrl = this.parseRichTextForImageUrl(eachListing.thumbnailImage);
                }
                if (eachListing.headerImage) {
                    eachListing.headerImageUrl = this.parseRichTextForImageUrl(eachListing.headerImage);
                }
            }
        }
    }

    @track _isShowSpinner = true;

    @api handleListingChange = () => {}
    @api handleFrontEndDataMap = () => {};
    @track _listingList = [];
    @track _currentPage = 1;
    @track _itemsPerPage = 5;
    @track _itemsPerRow = 4;
    @track _numberOfPages = 1;
    @track _pageList = [];
    @track _noResultsText = '';
    @track _sizing = 3;
    @track _zoneName = '';
    @track _listingListToDisplay = [];
    @track frontEndDataMap = null;
    _cookieId = getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

    @wire(SERVER_getListingButtonText)
    _buttonTextMap

    get getListingParams() {
        return {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};
    }

    get isLastPage() {
        // using >= to capture the case where current page is 1 and number of pages is 0
        return (this._currentPage >= this._numberOfPages);
    }

    get listingListToDisplay() {
        let listingListToDisplay = [];

        if (!this._listingList || !this._currentPage || !this._itemsPerPage) {
            return listingListToDisplay;
        }

        let startIndex = (this._currentPage - 1) * this._itemsPerPage;
        if (this.design === 'All News') {
            startIndex = 0;
        }

        let endIndex = (this._currentPage) * this._itemsPerPage;

        listingListToDisplay = this._listingList.slice(startIndex, endIndex);

        return listingListToDisplay;
    }

    get hasNoResults() {
        if (!this._listingList || this._listingList.length === 0) {
            return true;
        }

        return false;
    }

    get isDisplayNoResultsMessage() {
        return this.hasNoResults && !this._isShowSpinner;
    }

    get showComponent() {
        if (this._listingList && this.frontEndDataMap) {
            return true;
        }

        return false;
    }

    get isDisplayEventDate() {
        return this.frontEndDataMap.eventActualStartDateTime.display && this.frontEndDataMap.eventActualEndDateTime.display;
    }

    get allAnnouncementsLink() {
        return 'zone-announcements?zname=' + encodeURIComponent(this._zoneName);
    }

    get allZoneEventsLink() {
        return 'zone-events?zname=' + encodeURIComponent(this._zoneName);
    }

    get allEventsContainer() {
        return 'event-list ' + (this.design === 'All My Events' ? 'event-tabs tabs' : 'all-events');
    }

    @wire(SERVER_getListingConfigurations, {params: '$getListingParams'})
    setListingConfigurations({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        this.setSectionTitles(data.searchSectionTitle, data.listingSectionTitle);

        if (data.itemsPerPage) {
            this._itemsPerPage = parseInt(data.itemsPerPage, 10);
        }

        if (data.itemsPerRow) {
            this._itemsPerRow = parseInt(data.itemsPerRow, 10);
        }
        this._sizing = Math.floor(12 / this._itemsPerRow);

        this._noResultsText = data.noResultsText;

        let urlParams = new URLSearchParams(window.location.search);
        this._zoneName = urlParams.get(URL_PARAM_ZONE_NAME);

        if (!this.preventLoadQuery) {
            this.searchListings({pageName: this.pageName,
                                mainSectionName: this.mainSectionName,
                                subSectionName: this.subSectionName,
                                additionalParams: {
                                    zoneName: this._zoneName
                                },
                                cookieId: this._cookieId});
        } else if (this._listingList?.length > 0) {
            // timeout allows the pagination LWC (if it exists) to use the updated items per page value 
            setTimeout(() => {
                this._listingList = [...this._listingList];
                this._currentPage = 1;
                this.setPageList(); 
            });
        }
    }

    @wire(SERVER_getFrontEndDataMap, {params: '$getListingParams'})
    setFrontEndDataMap({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        this.frontEndDataMap = data;
        this.handleFrontEndDataMap(data);
    }

    @api
    searchListings(params) {
        this._isShowSpinner = true;

        searchListings({params: params})
        .then(result => {
            let resultClone = [];
            result?.forEach(listing => {
                resultClone.push({...listing, isRegisteredForEvent: ((listing.listingParticipations && listing.listingParticipations.length > 0) || listing.primaryParticipationId)});
            });

            this.listingList = resultClone;
            this.handleListingChange(this._listingList);

            this.setPageList();

            return this._listingList;
        }).catch(error => {
            console.log(error)
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }).finally(() => {
            this._isShowSpinner = false;
        })
    }

    render() {
        if (this.design === 'All Events' || this.design === 'All My Events') {
            return allEventsTemplate;
        } else if (this.design === 'All News') {
            return allNewsTemplate;
        } else if (this.design === 'All Announcements') {
            return allAnnouncementsTemplate;
        } else if (this.design === 'Home Announcements') {
            return allHomeAnnouncementsTemplate;
        } else if (this.design === 'Zone Home Events') {
            return allZoneHomeEventsTemplate;
        } else if (this.design === 'None') {
            return noneTemplate;
        }

        return allEventsTemplate;
    }

    renderedCallback() {
        let renderedListingsList = this.template.querySelectorAll('a.grid-item.equalHeight.card.show');
        let startIndex = (this._currentPage - 1) * this._itemsPerPage;
        let endIndex = (this._currentPage) * this._itemsPerPage;

        for (let listingIndex = startIndex; listingIndex < endIndex; listingIndex++) {
            if (renderedListingsList[listingIndex]) {
                renderedListingsList[listingIndex].style.setProperty('opacity', 0);
            }
        }

        setTimeout(() => {
            for (let listingIndex = startIndex; listingIndex < endIndex; listingIndex++) {
                if (renderedListingsList[listingIndex]) {
                    renderedListingsList[listingIndex].style.setProperty('opacity', 1);
                }
            }
        }, 150);
    }

    parseListingData(data) {
        if (!data) {
            return data;
        }

        let resultList = [];

        for (let listing of data) {
            let newListing = Object.assign({}, listing);

            // News listings use listingDetailUrl as the front end id
            // Event and Announcement listings use titleUrl
            if (newListing.listingDetailUrl || newListing.titleUrl) {
                newListing.listingUrl = newListing.listingDetailUrl || newListing.titleUrl;
                newListing.listingUrlTarget = '_blank';
            } else {
                newListing.listingUrl = basePath + '/listing-detail?listingName=' + encodeURIComponent(newListing.name) + '&recordId=' + newListing.Id;
            }

            if (newListing.registrationUrl) {
                newListing.registrationUrl = newListing.registrationUrl;
                newListing.registrationUrlTarget = '_blank';
            } else {
                newListing.registrationUrl = basePath + '/event-registration?recordId=' + newListing.Id + (newListing.primaryParticipationId ? '&participationId=' + newListing.primaryParticipationId : '');
            }

            //strip html tags to get plaintext on header content
            if (newListing.headerContent) {
                newListing.headerContent = newListing.headerContent.replace(/<[^>]*>?/gm, '');
            }

            newListing.formattedDate = this.getFormattedDateRange(newListing.eventActualStartDateTime, newListing.eventActualEndDateTime, newListing.timeZone);
            resultList.push(newListing);
        }

        return resultList;
    }

    parseRichTextForImageUrl(richText) {
        if (richText?.includes("<img")) {
            // to get src from img tag inside of lightning-formatted-rich-text
            let urlStartIndex = richText.indexOf("\"") + 1;
            let urlEndIndex = richText.indexOf("\"", urlStartIndex);
            return richText.substring(urlStartIndex, urlEndIndex).replaceAll('amp;', '');
        }
    }

    getFormattedDateRange(startDateString, endDateString, timeZone) {
        if (!this.dateFormatter) {
            this.dateFormatter = new DateFormatter();
        }

        if (!startDateString && !endDateString) {
            return;
        }

        let startDate = this.dateFormatter.convertStringToDate(startDateString);
        let endDate = this.dateFormatter.convertStringToDate(endDateString);

        return this.dateFormatter.getFormattedDateRange(startDate, endDate, ' | ') + ' ' + this.dateFormatter.getTimeZoneInitials(timeZone);
    }

    setPageList() {
        this._pageList = [];

        if (this._listingList) {
            this._numberOfPages = Math.ceil(this._listingList.length/this._itemsPerPage);
        }

        for (let pageNumber = 1; pageNumber <= this._numberOfPages; pageNumber++) {
            let page = {number: pageNumber, class: ""}
            if (pageNumber === this._currentPage) {
                page.class = "active";
            }
            this._pageList.push(page);
        }
    }

    handleNextClick() {
        if (this._currentPage < this._pageList.length) {
            this._currentPage = this._currentPage + 1;
            this.setPageList();
        }
    }

    handlePageChange = (listingsToDisplay) => {
        this._listingListToDisplay = listingsToDisplay;
    }
}