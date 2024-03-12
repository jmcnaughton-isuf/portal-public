import { LightningElement, api} from 'lwc';
export default class Portal_ShoppingCartEventModificationButtons extends LightningElement {
    @api event;
    @api disableButtons;
    @api sessionId;
    @api deleteRegistrationForEvent = () => {};
    @api modificationForEvent = () => {};

    registeredEventId;
    primaryParticipationId;

    showSpinner = false;

    connectedCallback() {
        if (this.event.participationsPerEvent) {
            this.registeredEventId = this.event.participationsPerEvent[0].eventId;
            this.primaryParticipationId = this.event.participationsPerEvent[0].Id
        }
    }

    handleModifyEventRegistrationClick() {
        this.modificationForEvent(this.registeredEventId, this.primaryParticipationId);
    }

    handleDeleteAllEventTickets() {
        this.deleteRegistrationForEvent(this.primaryParticipationId);
    }
}