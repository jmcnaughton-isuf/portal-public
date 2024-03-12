import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import zoneMembershipChannel from '@salesforce/messageChannel/zoneMembershipChannel__c';
import getZoneMembershipRecords from '@salesforce/apex/PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneMembershipRecords';
import getZoneTableInformation from '@salesforce/apex/PORTAL_LWC_ZoneMembershipTableController.SERVER_getZoneTableInformation';

export default class Portal_ZoneMembershipTable extends LightningElement {
    @api pageName;
    @api mainSectionName;
    @api subSectionName;
    @api isEditTable;
    @api portalMembershipSettingName;
    @api receivingNewsletterDisabledHelpText = 'You are currently not receiving newsletter messages';
    @api noRecordsText = 'No zone memberships available.';
    @api joinZoneSectionText = "Available Groups To Join";
    @wire(MessageContext) messageContext;

    @track _availableZonesToJoinPicklist = [];
    @track _availableZonesToJoinList = [];
    @track _zoneMembershipRecords = [];
    @track _columnTitlesList = [];
    @track _headerStyle = 'height: 41px;'
    @track _deletedZoneIdToZoneMembershipRecord = {};

    _tableTitle = '';
    _isDisplayTable = false;
    _helpText = '';
    _zoneDisplayType = '';
    _zoneRecordType = '';
    _newsletterValues = [];
    _activeServiceIndicatorValues = [];
    _isShowSpinner = true;

    get initializeZoneMembershipTableParams() {
        let params = {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};

        return params;
    }

    get initializeZoneTableInfoParams() {
        let params = {portalMembershipSettingName: this.portalMembershipSettingName};
        return params;
    }

    get showExcessZones() {
        return (this._zoneDisplayType == 'Active zone memberships'
                && this._availableZonesToJoinList
                && this._availableZonesToJoinPicklist.length > 0)
    }

    get isShowNullText() {
        if (!this._zoneMembershipRecords || this._zoneMembershipRecords.length <= 0) {
            return true;
        }
    }

    get isNewsletterFieldDisabled() {
        if (!this._newsletterValues || !this._activeServiceIndicatorValues) {
            return false;
        }

        let serviceIndicatorIntersectionList = this._activeServiceIndicatorValues.filter(value => this._newsletterValues.includes(value));
        return (serviceIndicatorIntersectionList.length > 0);
    }

    @wire(getZoneTableInformation, {params: '$initializeZoneTableInfoParams'})
    doInit({error, data}) {
        // for whatever reason, when this LWC loads, it basically ends up calling doInit({'error': undefined, 'data': undefined}) 
        // then shortly after, it will call doInit and actually pass a real error or data value
        if (!error && !data) {
            return;
        }

        if (error) {
            try {
                let errorMap = JSON.parse(error.body.message);
                console.log(errorMap.error);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            } catch {
                console.log(error);
            }
            this._isShowSpinner = false;
        }

        if (!data) {
            this._isShowSpinner = false;
            return;
        }

        this._zoneDisplayType = data.zoneDisplayType;
        this._zoneRecordType = data.zoneRecordType;
        this._activeServiceIndicatorValues = data.activeServiceIndicatorValues;
        this._newsletterValues = data.newsletterValues;

        if (data.availableZonesToJoinMap && data.availableZonesToJoinMap[this._zoneRecordType]) {
            this._availableZonesToJoinList = data.availableZonesToJoinMap[this._zoneRecordType];
        }

        this.createZonesToJoinPicklist(this._availableZonesToJoinList);

        getZoneMembershipRecords({params: this.initializeZoneMembershipTableParams})
        .then(result => {
            if (!result) {
                this._isShowSpinner = false;
                return;
            }

            let zoneMembershipRecords = [];

            result.records.forEach(record => {
                let newRecord = Object.assign({}, record)
                zoneMembershipRecords.push(newRecord)
            })

            if (this._zoneDisplayType == 'Active zone memberships') {
                zoneMembershipRecords = zoneMembershipRecords.filter(record => record.zoneMemStatus !== 'Inactive' && !(this.isEditTable && record.zoneMemStatus === 'Denied'));
            }

            this._zoneMembershipRecords = zoneMembershipRecords;
            this.setTableInformation(result.frontEndDataMap);
            this.createTableColumns(result.frontEndDataMap);
            this._isDisplayTable = this.isDisplayTable(result.frontEndDataMap);

            this.handleAllZoneMembershipRecordsDisplay();

            this.equalHeight(true);
            let cmdObject = {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};

            publish(this.messageContext, zoneMembershipChannel, {detail: cmdObject, type:"dataSetup"});
            this._isShowSpinner = false;
        }).catch(error=> {
            try {
                let errorMap = JSON.parse(error.body.message);
                console.log(errorMap.error);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorMap.message,
                    variant:"error",
                    mode:"sticky"
                });
                this.dispatchEvent(event);
            } catch {
                console.log(error);
            }
            this._isShowSpinner = false;
        });
    }

    connectedCallback() {
        window.addEventListener('resize', this.equalHeight);
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

    setTableInformation(frontEndDataMap) {
        let tableName = 'Clubs/Groups Table';
        let helpText = '';

        if (!frontEndDataMap) {
            this._tableTitle = tableName;
            return;
        }

        for (const key in frontEndDataMap) {
            if (!frontEndDataMap[key].mainSection && frontEndDataMap[key].display === true) {
                tableName = frontEndDataMap[key].label;
                helpText = frontEndDataMap[key].sectionDescription;
                break;
            }
        }

        this._tableTitle = tableName;
        this._helpText = helpText;
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

                if (key == 'zoneMemIsOnNewsletter' && this.isNewsletterFieldDisabled) {
                    frontEndObject.helpText = this.receivingNewsletterDisabledHelpText;
                }

                columnTitleList.push(frontEndObject);
            }
        }

        columnTitleList.sort((a, b) => (a.orderNumber - b.orderNumber));
        this._columnTitlesList = columnTitleList;
    }

    createZonesToJoinPicklist(availableZonesToJoinList) {
        if (this._zoneDisplayType != 'Active zone memberships' || !availableZonesToJoinList) {
            return;
        }

        let picklistOptions = [];
        availableZonesToJoinList.forEach((availableZone => {
            picklistOptions.push({label: availableZone.Name, value: availableZone.Id});
        }));

        this._availableZonesToJoinPicklist = picklistOptions;
    }

    handleAllZoneMembershipRecordsDisplay() {
        if (!this.isEditTable || this._zoneDisplayType != 'All' || !this._availableZonesToJoinList || this._availableZonesToJoinList.length <= 0) {
            return;
        }

        this._availableZonesToJoinList.forEach((availableZone => {
            let isAlreadyInList = false;
            this._zoneMembershipRecords.forEach(zoneMembership => {
                if (zoneMembership.zoneId == availableZone.Id) {
                    isAlreadyInList = true;
                    return;
                }
            })

            if (!isAlreadyInList) {
                this._zoneMembershipRecords.push({zoneId: availableZone.Id, zoneMemName: availableZone.Name, zoneMemStatus: 'Inactive', zoneMemIsOnNewsletter: false, zoneMemIsOnDirectory: false, zoneRecordType: this._zoneRecordType});
            }
        }))
    }

    handleLeaveZoneMembership = (zoneMembershipId, index) => {
        if (this._zoneDisplayType == 'Active zone memberships' && this._zoneMembershipRecords && this._zoneMembershipRecords[index]) {
            let picklistOptions = [];

            if (index != null && index != undefined && this._zoneMembershipRecords && this._zoneMembershipRecords[index]) {
                picklistOptions.push({label: this._zoneMembershipRecords[index].zoneMemName, value: this._zoneMembershipRecords[index].zoneId});
            }

            this._availableZonesToJoinPicklist = [...this._availableZonesToJoinPicklist, ...picklistOptions];
        }

        if (this._zoneDisplayType == 'All') {
            this.handleLeaveZoneMembershipForAllDisplay(zoneMembershipId, index);
            return;
        }

        if (zoneMembershipId == null && index != null) { // this is for when they add and remove without saving
            let removedZoneMembershipList = this._zoneMembershipRecords.splice(index, 1);  // only removes 1
            publish(this.messageContext, zoneMembershipChannel, {detail:{zoneId: removedZoneMembershipList[0].zoneId}, type:"leaveZoneMembership"});
        } else {
            this._deletedZoneIdToZoneMembershipRecord[this._zoneMembershipRecords[index].zoneId] = Object.assign({}, this._zoneMembershipRecords[index]);
            this._zoneMembershipRecords = this._zoneMembershipRecords.filter(zoneMembership => zoneMembership.Id != zoneMembershipId);
            publish(this.messageContext, zoneMembershipChannel, {detail:{zoneMembershipId: zoneMembershipId}, type:"leaveZoneMembership"});
        }

        this.rerenderTable()
    }

    handleCheckboxChange = (data) => {
        if (data && data.index != null && data.index != undefined && this._zoneMembershipRecords && this._zoneMembershipRecords[data.index]) {
            this._zoneMembershipRecords[data.index][data.fieldId] = data.checkedValue;
        } else {
            return;
        }

        publish(this.messageContext, zoneMembershipChannel, {detail:data, type:"checkboxUpdate"});
        this.rerenderTable();
    }

    handleLeaveZoneMembershipForAllDisplay(zoneMembershipId, index) {
        if (index != null && index != undefined && this._zoneMembershipRecords && this._zoneMembershipRecords[index]) {
            this._zoneMembershipRecords[index].zoneMemStatus = 'Inactive';
            this.rerenderTable()
        }

        if (zoneMembershipId == null && index != null && index != undefined) {
            publish(this.messageContext, zoneMembershipChannel, {detail:{zoneId: this._zoneMembershipRecords[index].zoneId}, type:"leaveZoneMembership"});
        } else {
            publish(this.messageContext, zoneMembershipChannel, {detail:{zoneMembershipId: zoneMembershipId}, type:"leaveZoneMembership"});
        }
    }

    handleAddZoneMembership = (event) => {
        let zoneName = '';
        this._availableZonesToJoinPicklist.forEach(option => {
            if (option.value == event.target.value) {
                zoneName = option.label;
            }
        });

        let zoneMembership = {};

        this._availableZonesToJoinPicklist = this._availableZonesToJoinPicklist.filter(option => option.value != event.target.value);

        if (this._deletedZoneIdToZoneMembershipRecord[event.target.value]) {
            zoneMembership = Object.assign({}, this._deletedZoneIdToZoneMembershipRecord[event.target.value]);
            zoneMembership.zoneMemStatus = 'Pending';
            zoneMembership.zoneRecordType = this._zoneRecordType;
            zoneMembership.zoneMemIsOnNewsletter = true;
            zoneMembership.zoneMemIsOnDirectory = true;
        } else {
            zoneMembership = {zoneId: event.target.value,
                            zoneMemName: zoneName,
                            zoneMemStatus: 'Pending',
                            zoneMemIsOnNewsletter: true,
                            zoneMemIsOnDirectory: true,
                            zoneRecordType: this._zoneRecordType};
        }

        this._zoneMembershipRecords.push(zoneMembership);
        publish(this.messageContext, zoneMembershipChannel, {detail:zoneMembership, type:"addZoneMembership"});
    }

    // different from add, joining is when active zone memberships metadata is on
    // the join button is on the row of the zone membership available to join
    handleJoinZoneMembership = (index) => {
        let zoneMembershipRecord = this._zoneMembershipRecords[index];
        zoneMembershipRecord.zoneMemStatus = 'Pending';
        zoneMembershipRecord.zoneMemIsOnNewsletter = true;
        zoneMembershipRecord.zoneMemIsOnDirectory = true;

        if (!zoneMembershipRecord.zoneRecordType) {
            zoneMembershipRecord.zoneRecordType = this._zoneRecordType;
        }

        this.rerenderTable();

        publish(this.messageContext, zoneMembershipChannel, {detail:zoneMembershipRecord, type:"addZoneMembership"});
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
        for (let record of this._zoneMembershipRecords) {
            record.key = Date.now();
        }
    }

    goToEditPage = (event) => {
        window.location.href = './edit-zone-memberships';
    }
}