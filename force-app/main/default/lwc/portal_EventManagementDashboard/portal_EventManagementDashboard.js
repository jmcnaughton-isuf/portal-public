import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import isUserAdministrator from '@salesforce/apex/PORTAL_LWC_EventManagementController.SERVER_isUserAdministrator';
import LISTING_DETAILS_CHANNEL from '@salesforce/messageChannel/Listing_Details__c';
export default class Portal_EventManagementDashboard extends LightningElement {
    @track isAdmin = false;
    @track _listing = {};
    @track _subscription;


    @wire(MessageContext)
    messageContext;

    get displayDashboard() {
        return this.isAdmin && this._listing && this._listing.recordType === 'Event';
    }

    eventListingName = '';

    connectedCallback() {
        isUserAdministrator()
        .then(res => {
            if (res) {
                // get listing name from url
                let urlQueryString = window.location.search;
                let urlParams = new URLSearchParams(urlQueryString);

                this.eventListingName = urlParams.get('listingName');

                // display the dashboard component
                this.isAdmin = true;
            }
        })
        .catch(e => {
            let errorMap = JSON.parse(e.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);

        });

        this.subscribeToMessageChannel()
    }

    subscribeToMessageChannel() {
        this._subscription = subscribe(this.messageContext, LISTING_DETAILS_CHANNEL, (message) => this.handleMessage(message));
    }

    handleMessage(message) {
        if (message.type === 'Body') {
            if (message.listing) {
                this._listing = message.listing;
            }
        }
    }

    handleDownloadNameTags () {
        window.open("/apex/PORTAL_EventNameTags?name=" + encodeURIComponent(this.eventListingName));
    }

    handleDownloadRSVPList () {
        window.open("/apex/PORTAL_EventAttendees?name=" + encodeURIComponent(this.eventListingName));
    }

    handleManageRSVPList () {
        window.location.href = './event-management?name=' + encodeURIComponent(this.eventListingName);
    }
}