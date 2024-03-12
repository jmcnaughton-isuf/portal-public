import { LightningElement, wire} from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import membershipChannel from '@salesforce/messageChannel/membershipChannel__c';

export default class Portal_MembershipEventCenter extends LightningElement {
    _membershipIdToBooleanMap;
    _subscription = null;
    _uncheckingGlobalOptOutCheckbox = false;
    _globalOptOutBooleanValue = false;
    @wire(MessageContext) messageContext;

    connectedCallback() {
        this._membershipIdToBooleanMap = {};
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
                membershipChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'recordChange') {
            let id = String(message.detail.id);
            let boolValue = Boolean(message.detail.checkedValue);

            if (this._membershipIdToBooleanMap.hasOwnProperty(id)) {
                this._membershipIdToBooleanMap[id] = boolValue;
            }

            if (!this._uncheckingGlobalOptOutCheckbox) {
                if (this._globalOptOutBooleanValue == true && boolValue != this._globalOptOutBooleanValue) {
                    this._uncheckingGlobalOptOutCheckbox = true;
                    this._globalOptOutBooleanValue = false;
                    publish(this.messageContext, membershipChannel, {detail: false,type:"globalOptOutUnchecked"});
                    return;
                }
            }

            if (boolValue === true && !this._globalOptOutBooleanValue) {
                let isAllCheckboxesTrue = Object.values(this._membershipIdToBooleanMap).every(value => value === true);

                if (isAllCheckboxesTrue) {
                    this._uncheckingGlobalOptOutCheckbox = false;
                    this._globalOptOutBooleanValue = true;
                    publish(this.messageContext, membershipChannel, {detail: true,type:"globalOptOutChecked"});
                }
            }

        } else if (message.type == 'dataSetup') {
            let membershipRecordMap = {};

            for (let record in message.detail) {
                let id = message.detail[record].membershipId;
                let boolValue = message.detail[record].membershipRenewalSolicitOptOut;

                membershipRecordMap[id] = boolValue;
            }

            this._membershipIdToBooleanMap = {...this._membershipIdToBooleanMap, ...membershipRecordMap};
        } else if (message.type == 'saveClick') {
            let societyMembershipsToModifyMap = {};

            for (const key in this._membershipIdToBooleanMap) {
                societyMembershipsToModifyMap[key] = Boolean(this._membershipIdToBooleanMap[key]);
            }

            publish(this.messageContext, membershipChannel, {detail: societyMembershipsToModifyMap,type:"savedData"});
        } else if (message.type == 'globalOptOutClick') {
            // receives checkbox either true or false
            let globalOptOutBooleanValue = Boolean(message.detail);
            this._uncheckingGlobalOptOutCheckbox = false;
            this._globalOptOutBooleanValue = globalOptOutBooleanValue;

            // publish to table
            publish(this.messageContext, membershipChannel, {detail: globalOptOutBooleanValue,type:"globalOptOutTable"});
        } else if (message.type == 'globalOptOutTableUpdated') {
            // need to update the mapping in case where the follow happens:
            // opt out = true, then they click to false, and then true again.
            // if some of the records were not originally true, but now they are after clicking twice, it must be updated in the backend
            let membershipRecords = message.detail.records;
            let globalOptOutBooleanValue = Boolean(message.detail.booleanValue);

            for (let record of membershipRecords) {
                if (record && record.membershipId) {
                    this._membershipIdToBooleanMap[record.membershipId] = globalOptOutBooleanValue;
                }
            }
        } else if (message.type == 'membershipManagementSetup') {
            this._globalOptOutBooleanValue = message.detail;

        } else if (message.type == 'tableDisplaySetup'){
            publish(this.messageContext, membershipChannel, {isShowEditButton: message.detail, type:"tableDisplaySetupComplete"});
        }
    }
}