import { LightningElement, api, track } from 'lwc';

export default class Portal_ShoppingCartRegisteredEventList extends LightningElement {
    @api sessionId;
    @api totalPrice;
    @api eventList;
    @api showModificationButtons;
    @api disableButtons;
    @api deleteRegistrationForEvent = () => {};
    @api modificationForEvent = () => {};

    @track columnData = [{label: 'Ticket', fieldId: 'ticketType', fieldType: 'text'},
                         {label: 'Quantity', fieldId: 'numberOfTickets', fieldType: 'text'},
                         {label: 'Price', fieldId: 'pricePerTicketString', fieldType: 'text'}];
}