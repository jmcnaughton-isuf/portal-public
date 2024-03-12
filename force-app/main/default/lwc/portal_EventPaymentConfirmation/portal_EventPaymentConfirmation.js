import { LightningElement, api, track } from 'lwc';
import { DateFormatter } from 'c/portal_util_DateFormatter';
import getEventConfirmationDetails  from '@salesforce/apex/PORTAL_LWC_ShoppingCartController.SERVER_getEventConfirmationDetails';

export default class Portal_EventPaymentConfirmation extends LightningElement {
    @api eventList;

    @track _showSpinner = false;
    @track showEvents = false;
    @track eventFormattedList = [];
    @track dateFormatter;

    connectedCallback() {
        let searchParams = new URLSearchParams(window.location.search);
        let sessionId = searchParams.get('sessionId');

        if (sessionId) {
            this._showSpinner = true;
            getEventConfirmationDetails({params: {sessionId: sessionId}}).then((result) => {
                this.formatEventsList(result);
                this._showSpinner = false;
            });
            return;
        }
        this.formatEventsList(this.eventList);

    }

    formatEventsList(eventList) {
        let newEventList = [];
        eventList.forEach(event => {
            let newEvent = {};

            if (event.ticketsForEvent) {
                event = event.ticketsForEvent;
            }

            newEvent['eventName'] = event.Name;
            newEvent['formattedDate'] = this.getFormattedDateRange(event.Event_Actual_Start_Date_Time__c, event.Event_Actual_End_Date_Time__c, event.Time_Zone__c);

            newEventList.push(newEvent);
        });

        this.eventFormattedList = newEventList;
        this.showEvents = true;
    }

    handleNavigateToHome() {
        window.location.href = './events';
    }

    getFormattedDateRange(startDateString, endDateString, timeZone) {
        if (!this.dateFormatter) {
            this.dateFormatter = new DateFormatter();
        }

        let startDate = this.dateFormatter.convertStringToDate(startDateString);
        let endDate = this.dateFormatter.convertStringToDate(endDateString);

        return this.dateFormatter.getFormattedDateRange(startDate, endDate, ' | ') + ' ' + this.dateFormatter.getTimeZoneInitials(timeZone);
    }
}