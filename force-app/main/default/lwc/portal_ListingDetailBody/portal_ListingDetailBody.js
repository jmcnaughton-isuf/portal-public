import { LightningElement, api, wire } from 'lwc';

import { publish, subscribe, MessageContext } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Listing_Details__c';
import REQUEST_LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Request_Listing_Details__c';
import SERVER_updateRecommendationEngine from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_updateRecommendationEngine';
import SERVER_updateActionOnContent from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_updateActionOnContent';

import listingDetailBody from './portal_ListingDetailBody.html';
import eventDetailBody from './portal_EventDetailBody.html';

import isGuestUser from '@salesforce/user/isGuest';

const PRIORITIZE_RICH_TEXT_VALUE = 'Body Content';
const PRIORITIZE_PLAIN_TEXT_VALUE = 'Body Content Plain Text';

export default class Portal_ListingDetailBody extends LightningElement {
    @api contentModuleName;
    @api prioritizedContent = '';

    frontEndDataMap = {};
    _richText = null;
    _plainText = null;

    _subscription = null;
    _listing = null;
    _contentModuleList = [];

    _isShowSpinner = false;

    _ipAddress;


    @wire(MessageContext)
    messageContext;

    get isShowComponent() {
        return this._richText || this._plainText;
    }

    get isLoggedInUser() {
        if (isGuestUser) {
            return false;
        }

        return true;
    }

    get isFrontEndDataMapEmpty() {
        return (Object.keys(this.frontEndDataMap).length == 0)
    }

    subscribeToMessageChannel() {
        this._subscription = subscribe(this.messageContext, LISTING_DETAILS_CHANNEL, (message) => this.handleMessage(message));
    }

    handleMessage(message) {
        if (message.type === 'Body') {
            if (message.listing) {
                this._listing = message.listing;
                this.handleUpdateRecommendationEngine();
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

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    renderedCallback() {
        this.setContent();
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
     * Set the content to display on the screen.
     */
    setContent() {
        if (this.listingHasMatchingContentModuleName()) {
            return;
        }

        if (this._listing) {
            // Decide which content gets displayed
            this._richText = (this.shouldDisplayRichText(this._listing) ? this._listing.bodyContent : '');
            this._plainText = (this.shouldDisplayPlainText(this._listing) ? this._listing.bodyContentPlainText : '');
        } else {
            const requestPayload = {requester: 'Body'};
            publish(this.messageContext, REQUEST_LISTING_DETAILS_CHANNEL, requestPayload);
        }
    }

    shouldDisplayRichText(listing) {
        return listing.bodyContent && (this.prioritizedContent === PRIORITIZE_RICH_TEXT_VALUE ||
                                           !listing.bodyContentPlainText);
    }

    shouldDisplayPlainText(listing) {
        return listing.bodyContentPlainText && (this.prioritizedContent === PRIORITIZE_PLAIN_TEXT_VALUE ||
                                                      !listing.bodyContent);
    }

    render() {
        if (this._listing && this._listing.recordType === 'Event') {
            return eventDetailBody;
        }

        return listingDetailBody;
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

        }).catch(console.error);
    }

    handleUpdateRecommendationEngine() {
        const Http = new XMLHttpRequest();
        const url='https://api.ipify.org/';

        Http.open("GET", url);
        Http.send();
        Http.onreadystatechange = (e)=>{
            if (Http.readyState == 4) {
                let ipAddress = Http.responseText;
                this._ipAddress = ipAddress;

                const params = {params:{contentId: this._listing.Id, ipAddress: this._ipAddress}};
                SERVER_updateRecommendationEngine(params).then(res => {
                }).catch(console.error);
            }
        }
    }
}