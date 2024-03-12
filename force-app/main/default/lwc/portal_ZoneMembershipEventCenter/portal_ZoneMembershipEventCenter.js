import { LightningElement, wire} from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import zoneMembershipChannel from '@salesforce/messageChannel/zoneMembershipChannel__c';

export default class Portal_ZoneMembershipEventCenter extends LightningElement {
    _originalMembershipIdToBooleanMap;
    _membershipIdToBooleanMap;
    _zoneMembershipsToAdd = [];
    _zoneMembershipsToLeave = [];
    _zoneMembershipsIdToCheckboxMap = {};
    _subscription = null;
    _cmdObject = {};
    @wire(MessageContext) messageContext;

    connectedCallback() {
        this._membershipIdToBooleanMap = {};
        this._originalMembershipIdToBooleanMap = {};
        this.subscribeToMessageChannel();

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('message') === 'success') {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your changes have been saved.',
                variant: 'success',
                mode: 'sticky'
            });
            this.dispatchEvent(event);
        }
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
        if (message.type == 'addZoneMembership') {
            let zoneMembership = Object.assign({}, message.detail);
            this._zoneMembershipsToAdd.push(zoneMembership);

            if (zoneMembership && zoneMembership.zoneId) {
                this._zoneMembershipsToLeave = this._zoneMembershipsToLeave.filter(zoneMembershipId => zoneMembershipId != zoneMembership.Id);
            }
        } else if (message.type == 'leaveZoneMembership') {
            let zoneMembershipId = String(message.detail.zoneMembershipId);
            let zoneId = String(message.detail.zoneId)

            if (zoneMembershipId != 'null' && zoneMembershipId != 'undefined' && !this._zoneMembershipsToLeave.includes(zoneMembershipId)) {
                this._zoneMembershipsToLeave.push(zoneMembershipId);
                
                // Adding the de-dupe process from below to here for MembershipId as well
                if (this._zoneMembershipsToAdd.some(zoneMembership => zoneMembership.Id == zoneMembershipId)) {
                    this._zoneMembershipsToAdd = this._zoneMembershipsToAdd.filter(zoneMembership => zoneMembership.Id != zoneMembershipId);
                }
            } else if (zoneId != 'null' && zoneId != 'undefined' && this._zoneMembershipsToAdd.some(zoneMembership => zoneMembership.zoneId == zoneId)) {  // check zone mems to add since if they add and remove, there will be a duplicate zone membership
                this._zoneMembershipsToAdd = this._zoneMembershipsToAdd.filter(zoneMembership => zoneMembership.zoneId != zoneId);
            }

        } else if (message.type == 'checkboxUpdate') {
            if (message.detail.id == null && message.detail.zoneId != null) {
                this._zoneMembershipsToAdd.forEach(zoneMembership => {
                    if (zoneMembership.zoneId == message.detail.zoneId) {
                        zoneMembership[message.detail.fieldId] = message.detail.checkedValue;
                    }
                });
            } else if (this._zoneMembershipsIdToCheckboxMap.hasOwnProperty(message.detail.id)) {
                this._zoneMembershipsIdToCheckboxMap[message.detail.id][message.detail.fieldId] = message.detail.checkedValue;
            } else {
                let newZoneMembershipToUpdateObject = {};
                newZoneMembershipToUpdateObject[message.detail.fieldId] = message.detail.checkedValue;
                this._zoneMembershipsIdToCheckboxMap[message.detail.id] = newZoneMembershipToUpdateObject;
            }

        } else if (message.type == 'dataSetup') {
            this._cmdObject = message.detail;

            if (this._cmdObject) {
                publish(this.messageContext, zoneMembershipChannel, {detail: this._cmdObject, type:"setupComplete"});
            }
        } else if (message.type == 'saveClick') {
            let zoneMembershipSaveObject = {};
            zoneMembershipSaveObject.zoneMembershipsToAdd = this._zoneMembershipsToAdd;
            zoneMembershipSaveObject.zoneMembershipsToLeaveList = this._zoneMembershipsToLeave;
            zoneMembershipSaveObject.zoneMembershipIdsToCheckboxValuesMap = this._zoneMembershipsIdToCheckboxMap;
            zoneMembershipSaveObject.cmdObject = this._cmdObject;

            publish(this.messageContext, zoneMembershipChannel, {detail: zoneMembershipSaveObject, type:"savedData"});
        }
    }
}