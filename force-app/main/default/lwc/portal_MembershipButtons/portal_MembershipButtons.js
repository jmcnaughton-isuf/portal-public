import { wire, api, LightningElement } from 'lwc';

import membershipChannel from '@salesforce/messageChannel/membershipChannel__c';
import { subscribe, MessageContext } from 'lightning/messageService';

export default class Portal_MembershipButtons extends LightningElement {
    @api editMembershipsUrl = "edit-memberships";
    @api purchaseMembershipsUrl = "membership-purchase";
    @api editMembershipsButtonLabel = "Edit Memberships";
    @api purchaseMembershipsButtonLabel = "Purchase Memberships";

    _isShowEditButton = false;
    _isShowPurchaseButton = false;
    _isShowSpinner = true;

    @wire(MessageContext)
    messageContext;

    get isShowEditButton(){
        return this._isShowEditButton && this.editMembershipsButtonLabel;
    }

    get isShowPurchaseButton(){
        return this._isShowPurchaseButton && this.purchaseMembershipsButtonLabel;
    }

    connectedCallback(){
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        this.subscription = subscribe(
          this.messageContext,
          membershipChannel,
          (message) => this.handleMessage(message)
        );
    }

    handleMessage(message){
        if (message.type === "tableDisplaySetupComplete"){
            if (message.isShowEditButton === true){
                this._isShowEditButton = true;
            }
            // implemented so buttons render at same time
            this._isShowPurchaseButton = true;
            this._isShowSpinner = false;
        }
    }
}