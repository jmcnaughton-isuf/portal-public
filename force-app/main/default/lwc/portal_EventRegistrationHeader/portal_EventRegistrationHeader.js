import { api, LightningElement } from 'lwc';
import { DateFormatter } from 'c/portal_util_DateFormatter';

export default class Portal_EventRegistrationHeader extends LightningElement {
    @api listing;
    @api ticketTypeList;

    get ticketTypeColumnData() {
        return [{label: 'Ticket', fieldId: 'name'}, {label: 'Description', fieldId: 'description'}, {label: 'Price', fieldId: 'originalPrice', type: 'currency'}];
    }

    get ticketTypeDisplayList() {
        let resultList = []

        if (!this.ticketTypeList) {
            return resultList;
        }

        for (let eachTicketType of this.ticketTypeList) {
            if (!eachTicketType.isNotForSale) {
                resultList.push(eachTicketType);
            }
        }

        return resultList;
    }

    get formattedDate() {
        if (!this.listing) {
            return;
        }

        if (!this.dateFormatter) {
            this.dateFormatter = new DateFormatter();
        }

        let startDate = this.dateFormatter.convertStringToDate(this.listing.Event_Actual_Start_Date_Time__c);
        let endDate = this.dateFormatter.convertStringToDate(this.listing.Event_Actual_End_Date_Time__c);

        return this.dateFormatter.getFormattedDateRange(startDate, endDate, ' | ') + ' ' + this.dateFormatter.getTimeZoneInitials(this.listing.Time_Zone__c);
    }
}