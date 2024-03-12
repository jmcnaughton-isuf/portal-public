import { LightningElement, api, wire, track } from 'lwc';
import { DateFormatter } from 'c/portal_util_DateFormatter';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import basePath from '@salesforce/community/basePath';
import LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Listing_Details__c';
import REQUEST_LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Request_Listing_Details__c';
import SERVER_getListingButtonText from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingButtonText';
import SERVER_updateActionOnContent from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_updateActionOnContent';
import {formatRelativeUrlWithRootPath} from 'c/portal_util_Urls';

import eventDetailHeader from './portal_EventDetailHeader.html';
import listingDetailHeader from './portal_ListingDetailHeader.html';

import isGuestUser from '@salesforce/user/isGuest';


export default class Portal_ListingDetailHeader extends LightningElement {
    @api hideImage = false;
    @api hideCaption = false;
    @api hideContent = false;
    @api contentModuleName;

    @api notInterestedLogoUrl = '/resource/Portal_ListingDetailHeader/delete-circle.svg';
    @api activeNotInterestedLogoUrl = '/resource/Portal_ListingDetailHeader/delete-circle-active.svg'
    @api bookmarkLogoUrl = '/resource/Portal_ListingDetailHeader/bookmark.svg';
    @api activeBookmarkLogoUrl ='/resource/Portal_ListingDetailHeader/bookmark-active.svg';

    // The Listing details we display to the screen.
    _name;
    _image = null;
    _caption = null;
    _content = null;
    _author = null;
    _publicationDate = null;
    _dateString;

    _subscription = null;

    _isShowSpinner = false;

    _ipAddress;

    @track _registrationUrl;
    @track _listing = null;
    @track _contentModuleList = [];
    @track frontEndDataMap = {};

    dateFormatter

    @wire(MessageContext)
    messageContext;

    @wire(SERVER_getListingButtonText)
    _buttonTextMap = {};

    get isShowActionOnContentIcons() {
        return this._listing?.recordType === 'News' && !isGuestUser;
    }

    get isShowHeaderImage() {
        return !this.hideImage && this._listing && this._listing.headerImage;
    }

    get isDisplayButtons() {
        return this._buttonTextMap?.data && !window.location.href.includes('/s/event-participation-list');
    }

    get isDisplayLookWhosComing() {
        return this.frontEndDataMap.isDisplayLookWhosComing && this.isListingDetailsPage;
    }

    get eventParticipationListURL() {
        return window.location.href.replace('/s/listing-detail', '/s/event-participation-list');
    }

    get isListingDetailsPage() {
        return window.location.href.includes('/s/listing-detail');
    }

    get communityNotInterestedLogoUrl() {
        let logoUrl = this._listing?.isNotInterested ? this.activeNotInterestedLogoUrl : this.notInterestedLogoUrl;
        return formatRelativeUrlWithRootPath(logoUrl);
    }

    get communityBookmarkLogoUrl() {
        let logoUrl = this._listing?.isBookmarked ? this.activeBookmarkLogoUrl : this.bookmarkLogoUrl; 
        return formatRelativeUrlWithRootPath(logoUrl);
    }

    get isFrontEndDataMapEmpty() {
        return (Object.keys(this.frontEndDataMap).length == 0)
    }

    connectedCallback() {
        const Http = new XMLHttpRequest();
        const url='https://api.ipify.org/';
        Http.open("GET", url);
        Http.send();
        Http.onreadystatechange=(e)=>{
            if (Http.readyState == 4) {
                let ipAddress = Http.responseText;
                this._ipAddress = ipAddress;
            }
        }
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        this._subscription = subscribe(this.messageContext, LISTING_DETAILS_CHANNEL, (message) => this.handleMessage(message));
    }

    handleMessage(message) {
        if (message.type === 'Header') {
            if (message.listing) {
                this._listing = message.listing;
            }

            if (message.contentModuleList) {
                this._contentModuleList = message.contentModuleList;
            }

            if (message.frontEndDataMap) {
                this.frontEndDataMap = message.frontEndDataMap;
            }

            this.setContent();
        }
    }

    renderedCallback() {
        this.setContent();
    }

    /**
     * Set the content to display on screen.
     */
    setContent() {
        if (this._contentModuleList && this.contentModuleName) {
            for (let i = 0; i < this._contentModuleList.length; i++) {
                if (this._contentModuleList[i].contentModuleName === this.contentModuleName.trim()){
                    return;
                }
            }
        }

        let headerImage = this.getHeaderImageFromRichText();

        if (this._listing) {
            // Decide which content gets displayed
            this._name = this._listing.name;
            this._image = (headerImage && !this.hideImage ? headerImage : '');
            this._caption = (this._listing.headerCaption && !this.hideCaption ? this._listing.headerCaption : '');
            this._content = (this._listing.headerContent && !this.hideContent ? this._listing.headerContent : '');
            this._author = (this._listing.author ? 'By ' + this._listing.author : '');
            this._publicationDate = (this._listing.publicationDate ? this._listing.publicationDate : '');

            if (this._listing.registrationUrl) {
                this._registrationUrl = this._listing.registrationUrl;
            } else {
                this._registrationUrl = basePath + '/event-registration?recordId=' + this._listing.Id + (this._listing.primaryParticipationId ? '&participationId=' + this._listing.primaryParticipationId : '');
            }

            this._dateString = this.getFormattedDateRange(this._listing.eventActualStartDateTime, this._listing.eventActualEndDateTime, this._listing.timeZone);
        }

        else {
            const requestPayload = {requester: 'Header'};
            publish(this.messageContext, REQUEST_LISTING_DETAILS_CHANNEL, requestPayload);
        }
    }

    getHeaderImageFromRichText() {
        if (!this._listing || Object.keys(this._listing) === 0) {
            return;
        }

        let headerImage = this._listing.headerImage;

        if (headerImage && headerImage.includes("<img")) {
            // to get src from img tag inside of lightning-formatted-rich-text
            let urlStartIndex = headerImage.indexOf("\"") + 1;
            let urlEndIndex = headerImage.indexOf("\"", urlStartIndex);

            return headerImage.substring(urlStartIndex, urlEndIndex).replaceAll('amp;', '');
        }
    }

    render() {
        if (this._listing && this._listing.recordType === 'Event') {
            return eventDetailHeader;
        }

        return listingDetailHeader;
    }

    handleActionOnContent(event) {
        this._isShowSpinner = true;
        let actionToTake = event.currentTarget.getAttribute('data-type');
        const params = {params:{actionToTake : actionToTake, listingId : this._listing.Id, ipAddress: this._ipAddress}};
        SERVER_updateActionOnContent(params).then(res => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your preferences have been saved.',
                variant:"success",
                mode:"sticky"
            });
            this._isShowSpinner = false;
            this.dispatchEvent(event);

            if (this._listing) {
                if (actionToTake === 'notInterested') {
                    this._listing = {...this._listing, isNotInterested: !this._listing.isNotInterested, isBookmarked: false};
                }
                else if (actionToTake === 'bookmark') {
                    this._listing = {...this._listing, isBookmarked: !this._listing.isBookmarked, isNotInterested: false}
                }
            }
        }).catch(console.error);
    }

    getFormattedDateRange(startDateString, endDateString, timeZone) {
        if (!startDateString && !endDateString) {
            return '';
        }

        if (!this.dateFormatter) {
            this.dateFormatter = new DateFormatter();
        }

        let startDate = this.dateFormatter.convertStringToDate(startDateString);
        let endDate = this.dateFormatter.convertStringToDate(endDateString);

        return this.dateFormatter.getFormattedDateRange(startDate, endDate, ' | ') + ' ' + this.dateFormatter.getTimeZoneInitials(timeZone);
    }
}