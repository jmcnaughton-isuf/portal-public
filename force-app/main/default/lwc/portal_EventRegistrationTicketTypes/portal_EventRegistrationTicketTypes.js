import { LightningElement, api, track } from 'lwc';

export default class Portal_EventRegistrationTicketTypes extends LightningElement {
    @api ticketTypeList;
    @api registrant;
    @api allowWaitlisting = false;
    @api handleWaitlistClick = () => {};
    @api handleTicketChange = () => {};
}