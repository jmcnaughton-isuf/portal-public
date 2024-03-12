import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import membershipChannel from '@salesforce/messageChannel/membershipChannel__c';
import saveMembershipRecords from '@salesforce/apex/PORTAL_LWC_MembershipController.SERVER_saveMembershipRecords';
import getMembershipContactInformation from '@salesforce/apex/PORTAL_LWC_MembershipController.SERVER_getMembershipContactInformation';

export default class Portal_MembershipManagement extends LightningElement {
    @api membershipSolicitOptOutLabel;
    @api cancelEditMembershipUrl = '/ascendportal/s/memberships';
    @wire(MessageContext) messageContext;

    isShowSpinner = true;
    isSetupComplete = false;

    _subscription = null;
    _globalMembershipSolicitOptOutValue;

    @wire(getMembershipContactInformation)
    doInit({error, data}) {
        if (error) {
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }

        if (!data) {
            return;
        }

        this._globalMembershipSolicitOptOutValue = data.globalMembershipRenewalSolicitOptOutValue;
        this.subscribeToMessageChannel();
        publish(this.messageContext, membershipChannel, {detail: this._globalMembershipSolicitOptOutValue, type:"membershipManagementSetup"});
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
        if (message.type == 'savedData') {
            let params = {};

            if (Object.keys(message.detail).length > 0) {
                params.membershipsToUpdate = message.detail;
            }

            params.globalMembershipRenewalSolicitOptOutValue = this._globalMembershipSolicitOptOutValue;

            saveMembershipRecords({params: params})
            .then(() => {
                this.isShowSpinner = false;
                window.location.href = './memberships?message=success';
            }).catch(error => {
                let errorMap = JSON.parse(error.body.message);
                console.log(errorMap.error);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            });
        } else if (message.type == 'globalOptOutUnchecked') {
            this._globalMembershipSolicitOptOutValue = message.detail;
        } else if (message.type == 'globalOptOutChecked') {
            this._globalMembershipSolicitOptOutValue = message.detail;
        } else if (message.type === 'tableDisplaySetupComplete') {
            this.isShowSpinner = false;
            this.isSetupComplete = true;
        }
    }

    handleMembershipSaveClick(event) {
        this.isShowSpinner = true;
        publish(this.messageContext, membershipChannel, {type:"saveClick"});
    }

    handleCancelClick(event) {
        this.isShowSpinner = true;
    }

    handleMembershipRenewalSolicitationChange = (event) => {
        this._globalMembershipSolicitOptOutValue = event.target.checked;
        publish(this.messageContext, membershipChannel, {detail: event.target.checked, type:"globalOptOutClick"});
    }
}