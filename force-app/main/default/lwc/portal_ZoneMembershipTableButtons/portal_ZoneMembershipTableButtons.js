import { LightningElement, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import zoneMembershipChannel from '@salesforce/messageChannel/zoneMembershipChannel__c';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import saveZoneMembershipRecords from '@salesforce/apex/PORTAL_LWC_ZoneMembershipTableController.SERVER_saveZoneMembershipRecords';

export default class Portal_ZoneMembershipTableButtons extends LightningElement {
    @wire(MessageContext) messageContext;
    _subscription = null;
    _isShowButtons = false;
    showSpinner = false;

    handleBackClick() {
        window.location.href = './zone-memberships';
    }

    handleSaveClick() {
        this.showSpinner = true;
        publish(this.messageContext, zoneMembershipChannel, {type:"saveClick"});
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                zoneMembershipChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'savedData') {
            let saveData = message.detail;
            let params = {};
            params.zoneMembershipsToLeave = saveData.zoneMembershipsToLeaveList;
            params.zoneMembershipsToJoin = saveData.zoneMembershipsToAdd;
            params.zoneMembershipIdsToCheckboxValuesMap = saveData.zoneMembershipIdsToCheckboxValuesMap;
            params.pageName = saveData.cmdObject.pageName;
            params.mainSectionName = saveData.cmdObject.mainSectionName;
            params.subSectionName = saveData.cmdObject.subSectionName;
            this.showSpinner = true;
            callApexFunction(this, saveZoneMembershipRecords, params, (data) => {
                this.showSpinner = false;
                window.location.href = './zone-memberships?message=success';
            }, () => {
                this._showSpinner = false;
            });
        } else if (message.type == 'setupComplete') {
            this._isShowButtons = true;
        }
    }
}