import { LightningElement, api} from 'lwc';

export default class Portal_EventManagementInfoBar extends LightningElement {
    @api registeredParticipants;
    @api attendedParticipants;
    @api attendedParticipantsToRegistered;

    handleRefreshClick() {
        this.dispatchEvent(new CustomEvent('refresh'));
    }

    handleAddAttendeeClick() {
        this.dispatchEvent(new CustomEvent('addattendee'));
    }
}