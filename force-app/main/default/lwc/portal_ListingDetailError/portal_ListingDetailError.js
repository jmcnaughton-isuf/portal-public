import { LightningElement } from 'lwc';


const URL_PARAM_ERROR_MESSAGE = 'errorMessage';

export default class Portal_ListingDetailsError extends LightningElement {

    _errorMessage;

    connectedCallback() {
        let urlParams = new URLSearchParams(window.location.search);
        this._errorMessage = urlParams.get(URL_PARAM_ERROR_MESSAGE);
    }
}