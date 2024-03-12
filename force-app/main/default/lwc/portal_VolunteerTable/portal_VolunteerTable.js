import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import volunteerChannel from '@salesforce/messageChannel/volunteerChannel__c';

import getVolunteerRecords from '@salesforce/apex/PORTAL_LWC_VolunteerTableController.SERVER_getVolunteerRecords';
import { callApexFunction } from 'c/portal_util_ApexCallout';

export default class Portal_VolunteerTable extends LightningElement {
    @api pageName;
    @api mainSectionName;
    @api subSectionName;
    @api isEditTable;
    @api itemsPerPage = 4;
    @api noRecordsMessage = "No Volunteer Shifts Found";

    @wire(MessageContext) messageContext;

    _tableTitle = '';
    _columnTitlesList = [];
    @track _volunteerRecords = [];
    @track _isFresh = false;
    _isDisplayTable = false;
    _showSpinner = false;
    _reportHoursRecordId;
    _modifyAppRecordId;
    _shiftRecord;

    get initializeTableParams() {
        let params = {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};

        return params;
    }

    get conciseColumnData() {
        let resultColumns = [];
        for (const eachColumn of this._columnTitlesList) {
            let summaryCol = {};
            summaryCol.label = eachColumn.label || 'Actions';
            summaryCol.fieldId = eachColumn.fieldId;
            summaryCol.fieldType = eachColumn.fieldType;
            resultColumns.push(summaryCol);
        }
        return resultColumns;
    }

    connectedCallback() {
        this.getRecords();
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
        let tableName = 'Volunteer Table';

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
                frontEndObject.id = frontEndObject.label; 
                columnTitleList.push(frontEndObject);
            }
        }

        columnTitleList.sort((a, b) => (a.orderNumber - b.orderNumber));

        this._columnTitlesList = columnTitleList;
    }

    getRecords() {
        this._showSpinner = true;
        callApexFunction(this, getVolunteerRecords, this.initializeTableParams, (data) => {
            this._isDisplayTable = this.isDisplayTable(data.frontEndDataMap);
            this.setTableName(data.frontEndDataMap);
            this.createTableColumns(data.frontEndDataMap);

            this.setRecords(data.records);
            this._showSpinner = false;
            this._isFresh = true;
        }, () => {
            this._showSpinner = false;
        });
    }

    setRecords(volunteerRecords) {
        let dateFields = [];
        let hyperlinkFields = [];
        for (let eachColumn of this._columnTitlesList) {
            if (eachColumn.fieldType === 'datetime') {
                dateFields.push(eachColumn.fieldId);
            }
            else if (eachColumn.fieldId === 'report') {
                hyperlinkFields.push({'key': eachColumn.fieldId, 
                                      'label': 'Report Hours'});
                eachColumn.fieldType = 'url';
            }
            else if (eachColumn.fieldId === 'modifyApplication') {
                hyperlinkFields.push({'key': eachColumn.fieldId, 
                                      'label': 'Modify Application'});
                eachColumn.fieldType = 'url';
            }
        }

        let duplicateRecords = [];

        for (let eachRecord of volunteerRecords) {
            let recordClone = Object.assign({}, eachRecord);
            for (const key of dateFields) {
                try {
                    recordClone[key] = Date.parse(recordClone[key]);
                } catch(e) {
                    recordClone[key] = '';
                }
            }
            for (const eachHyperlink of hyperlinkFields) {
                recordClone[eachHyperlink.key] = eachHyperlink.label;
                // record.callbackMap['key'] is the callback function for the given key
                recordClone.callbackMap = recordClone.callbackMap || {};
                recordClone.callbackMap[eachHyperlink.key] = this.createCallbackFunction(eachHyperlink.key, recordClone);
            }
            recordClone.key = Date.now();
            duplicateRecords.push(recordClone);
        }

        this._volunteerRecords = duplicateRecords;
    }

    createCallbackFunction = (key, record) => {
        if (key === 'report') {
            return (event) => {
                this._reportHoursRecordId = record.id;
            };
        }
        else if (key === 'modifyApplication') {
            return (event) => {
                this._modifyAppRecordId = record.id;

                let shiftRecord = {volunteerShiftId: record.shiftId,
                                   volunteerJobShiftName: record.volunteerJob,
                                   volunteerJobShiftStartDateTime: record.startDate,
                                   volunteerJobShiftEndDateTime: record.endDate}
        
                this._shiftRecord = shiftRecord
            }
        }
        
        return () => {console.log("invalid or misspelled argument");};
    }

    closeModal = () => {
        this._reportHoursRecordId = '';
        this._modifyAppRecordId = '';
        this._shiftRecord = null;
    }

    refreshComponent = () => {
        this._isFresh = false;
        publish(this.messageContext, volunteerChannel, {type:"refresh"});
        this.getRecords();
    }
}