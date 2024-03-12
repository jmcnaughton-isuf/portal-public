import { api, LightningElement, track } from 'lwc';

export default class Portal_MembershipRadioButtons extends LightningElement {
    @api membershipOptions;
    @api handleRadioButtonChange = () => {};
    @api handleNextClick = () => {};
    @api membershipDescription;

    _selectedValue = '';

    @api
    getSelectedValue = () => {
        return this._selectedValue;
    }
}