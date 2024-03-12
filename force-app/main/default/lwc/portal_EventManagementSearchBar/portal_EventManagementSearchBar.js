import { LightningElement, api } from 'lwc';

export default class Portal_EventManagementSearchBar extends LightningElement {
    @api handleInput = () => {};
    @api searchString;

    handleSearchClick() {
        this.dispatchEvent(new CustomEvent('search'));
    }
}