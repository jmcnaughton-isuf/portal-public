import { LightningElement, api, wire } from 'lwc';

import { publish, subscribe, MessageContext } from 'lightning/messageService';
import LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Listing_Details__c';
import REQUEST_LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Request_Listing_Details__c';

import listingDetailFooter from './portal_ListingDetailFooter.html';
import eventDetailFooter from './portal_EventDetailFooter.html';

export default class Portal_ListingDetailFooter extends LightningElement {
    @api contentModuleName;
    @api pageName = "";
    @api mainSectionName = "";
    @api subSectionName = "";
    @api design = "";
    @api titleText = "";
    @api showMoreURL ="";
    @api showMoreLabel = "";

    _subscription = null;
    _listing = null;
    _contentModuleList = [];
    frontEndDataMap = {};

    @wire(MessageContext)
    messageContext;

    get isShowComponent() {
        return this._listing && !this.listingHasMatchingContentModuleName();
    }

    get isShowListingCarousel() {
        return this._listing.recordType === 'News';
    }

    get isFrontEndDataMapEmpty() {
        return (Object.keys(this.frontEndDataMap).length == 0)
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    renderedCallback() {
        this.setContent();
    }

    subscribeToMessageChannel() {
        this._subscription = subscribe(this.messageContext, LISTING_DETAILS_CHANNEL, (message) => this.handleMessage(message));
    }

    handleMessage(message) {
        if (message.type === 'Footer') {
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

    listingHasMatchingContentModuleName() {
        if (this._contentModuleList && this.contentModuleName) {
            for (let i = 0; i < this._contentModuleList.length; i++) {
                if (this._contentModuleList[i].Name === this.contentModuleName.trim()){
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Sets the data to be displayed to the screen.
     */
    setContent() {
        if (this.listingHasMatchingContentModuleName()) {
            return;
        } else if (!this._listing) {
            const requestPayload = {requester: 'Footer'};
            publish(this.messageContext, REQUEST_LISTING_DETAILS_CHANNEL, requestPayload);
        }
    }

    render() {
        if (this._listing && this._listing.recordType === 'Event') {
            return eventDetailFooter;
        }

        return listingDetailFooter;
    }
}