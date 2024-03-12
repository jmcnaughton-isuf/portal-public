import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import checkInRegistrant from '@salesforce/apex/PORTAL_LWC_EventManagementController.SERVER_checkInRegistrant';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildLoadingMessage(loadingMessage) {
        this.result._loadingMessage = loadingMessage;
        return this;
    }

    buildCheckInMessage(checkInMessage) {
        this.result._checkInMessage = checkInMessage;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;
    _loadingMessage = ''
    _checkInMessage = '';
    _isShowSpinner = true;

    get isShowSpinner() {
        return this._isShowSpinner;
    }
    
    get loadingMessage() {
        return this._loadingMessage;
    }

    get checkInMessage() {
        return this._checkInMessage;
    }

    set loadingMessage(loadingMessage) {
        this._loadingMessage = loadingMessage;
        this._lightningElement.componentAttributes.loadingMessage = loadingMessage;
    }

    set checkInMessage(checkInMessage) {
        this._checkInMessage = checkInMessage;
        this._lightningElement.componentAttributes.checkInMessage = checkInMessage;

    }

    set isShowSpinner(isShowSpinner) {
        this._isShowSpinner = false;
        this._lightningElement.componentAttributes.isShowSpinner = isShowSpinner;
    }

    handleCheckIn(event) {
        const urlParams = new URLSearchParams(window.location.search);
        let participationIdParam = urlParams.get('participationId');

        const params = {participationId: participationIdParam};

        callApexFunction(this._lightningElement, checkInRegistrant, params, (name) => {
            let registrantName = name ? name : 'Guest Registrant';
            this.checkInMessage = registrantName + ' ' + this.checkInMessage;
            this.isShowSpinner = false;
        }, (error) => {
            this.isShowSpinner = false;
            this.checkInMessage = 'There was an error while checking in.';
            console.log(error);
        });
    }
}