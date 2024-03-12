import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import membershipChannel from '@salesforce/messageChannel/membershipChannel__c';
import getMembershipRecords from '@salesforce/apex/PORTAL_LWC_MembershipController.SERVER_getMembershipRecords';

export default class Portal_MembershipTable extends LightningElement {
    @api pageName;
    @api mainSectionName;
    @api subSectionName;
    @api isEditTable;
    _subscription = null;
    @wire(MessageContext) messageContext;

    _tableTitle = '';
    _membershipRecords = [];
    _isDisplayTable = false;
    _isDisplayMembershipRecords = true;
    @track _columnTitlesList = [];
    @track _headerStyle = 'height: 41px;'

    @api noMembershipsMessage = 'No memberships to display.';

    get initializeMembershipTableParams() {
        let params = {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};

        return params;
    }

    @wire(getMembershipRecords, {params: '$initializeMembershipTableParams'})
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

        this._isDisplayTable = this.isDisplayTable(data.frontEndDataMap);
        this.setTableName(data.frontEndDataMap);
        this.createTableColumns(data.frontEndDataMap);

        this._membershipRecords = Array.from(data.membershipRecords);

        if (!this._membershipRecords || this._membershipRecords.length < 1) {
            this._isDisplayMembershipRecords = false;
        }
        this.equalHeight(false);

        publish(this.messageContext, membershipChannel, {detail: this._isDisplayMembershipRecords, type:"tableDisplaySetup"});
        publish(this.messageContext, membershipChannel, {detail: this._membershipRecords, type:"dataSetup"});
    }

    connectedCallback() {
        window.addEventListener('resize', this.equalHeight);
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
                membershipChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'globalOptOutTable' && message.detail != null) {
            let globalOptOutBooleanValue = Boolean(message.detail);

            let newArray = [];

            for (let record of this._membershipRecords) {
                let newRecord = Object.assign({}, record);
                newRecord.membershipRenewalSolicitOptOut = globalOptOutBooleanValue;
                newRecord.key = Date.now();

                newArray.push(newRecord);
            }

            this._membershipRecords = newArray;
            publish(this.messageContext, membershipChannel, {detail: {records: this._membershipRecords, booleanValue: globalOptOutBooleanValue},type:"globalOptOutTableUpdated"});
        }
    }

    renderedCallback() {
        this.equalHeight(false);
    }

    isDisplayTable(frontEndDataMap) {
        if (!frontEndDataMap) {
            return false;
        }

        for (const key in frontEndDataMap) {
            if (!frontEndDataMap[key].mainSection && frontEndDataMap[key].display === false) {
                return false;
            }
        }

        return true;
    }

    setTableName(frontEndDataMap) {
        let tableName = 'Membership Table';

        if (!frontEndDataMap) {
            this._tableTitle = tableName;
            return;
        }

        for (const key in frontEndDataMap) {
            if (!frontEndDataMap[key].mainSection && frontEndDataMap[key].display === true) {
                tableName = frontEndDataMap[key].label;
                break;
            }
        }

        this._tableTitle = tableName;
    }

    createTableColumns(frontEndDataMap) {
        if (!frontEndDataMap) {
            return;
        }

        let columnTitleList = [];

        for (const key in frontEndDataMap) {
            if (frontEndDataMap[key].mainSection && frontEndDataMap[key].display === true) {
                let frontEndObject = {...frontEndDataMap[key]};
                frontEndObject.key = key;
                columnTitleList.push(frontEndObject);
            }
        }

        columnTitleList.sort((a, b) => (a.orderNumber - b.orderNumber));

        this._columnTitlesList = columnTitleList;
    }

    handleRenewalSolicitOptOut = (data) => {
        publish(this.messageContext, membershipChannel, {detail:data, type:"recordChange"});
    }

    equalHeight = (initialize) => {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let maxHeaderHeight = 41;
        let i = 0;

        if (initialize !== true){
            for(i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
        }

        for(i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            if (elementHeight > maxHeaderHeight) {
                maxHeaderHeight = elementHeight;
            }
        }

        for(i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = maxHeaderHeight + 'px';
        }
    }

    rerenderTable = () => {
        for (let column of this._columnTitlesList) {
            column.key = Date.now();
        }
    }

}