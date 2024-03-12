import { LightningElement, api } from 'lwc';

export default class Portal_VolunteerJobCalendarModal extends LightningElement {
    @api frontEndDataMap;
    @api volunteerJob;
    @api handleCloseModal = () => {};
    @api handleVolunterShiftSignUp = () => {};
    _isShowModal = false;

    handleShiftSignUp = (shift, type) => {
        this.handleVolunterShiftSignUp(shift, type);
    }
}