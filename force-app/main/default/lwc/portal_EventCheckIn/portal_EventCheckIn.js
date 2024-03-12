import { LightningElement, api, track } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_EventCheckInHelper';
export * from './portal_EventCheckInHelper';

export default class Portal_EventCheckIn extends LightningElement {
    @api loadingMessage = 'Please wait while the user is being checked in.'
    @api checkInMessage = 'has been succesfully checked in.';
    @track componentLogic = undefined;
    @track componentAttributes = {};

    get loadingMessageText() {
        return this.componentAttributes.loadingMessage || '';
    }

    get checkInMessageText() {
        return this.componentAttributes.checkInMessage || '';
    }

    get isShowSpinner() {
        return this.componentAttributes.isShowSpinner || false;
    }

    connectedCallback() {
        this.checkInRegistrant();
    }
    
    checkInRegistrant() {
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildLoadingMessage(this.loadingMessage)
                                                         .buildCheckInMessage(this.checkInMessage)
                                                         .build();

        this.componentLogic.handleCheckIn();
    }
}