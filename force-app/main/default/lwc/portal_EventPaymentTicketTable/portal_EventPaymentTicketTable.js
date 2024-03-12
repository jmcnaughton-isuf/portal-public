import { LightningElement, api } from 'lwc';

export default class Portal_EventPaymentTicketTable extends LightningElement {
    @api ticketList;
    @api totalPrice;
}