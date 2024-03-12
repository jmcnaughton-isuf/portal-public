import { LightningElement, wire, api, track } from 'lwc';
import LISTING_OBJECT from '@salesforce/schema/ucinn_portal_Listing__c';
import STATUS_FIELD from '@salesforce/schema/ucinn_portal_Listing__c.Status__c';

import { reduceErrors, redirectToNewRecordId, displayErrorAlert } from 'c/portal_Util_Listing';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import saveStatus from '@salesforce/apex/PORTAL_ListingChangeStatusController.SERVER_saveStatus';
import saveDraft from '@salesforce/apex/PORTAL_ListingChangeStatusController.SERVER_saveDraft';

const RECORD_FIELDS = [STATUS_FIELD];
const STATUS_DRAFT = 'Draft';
const CANCEL_EVENT = 'Cancel';

export default class Portal_Quickaction_ListingChangeStatus extends LightningElement {
    /**
     * The Id of the Record Object.
     */
    @api recordId;

    // Variables used to control what's displayed on the screen.
    _selectedValue;
    _isDraft;

    get isDraft() {
        return this._selectedValue === STATUS_DRAFT;
    }

    // Variables containing the Record Object's information
    @track _objectInfo;
    @track _recordInfo;
    @track _picklistValuesInfo;

    get recordTypeId() {
        return this._objectInfo.defaultRecordTypeId;
    }

    get picklistList() {
        if (!this._picklistValuesInfo) {
            return [];
        }
        return this._picklistValuesInfo.picklistFieldValues.Status__c.values.filter((option) => {
            return option.value !== STATUS_DRAFT;
        });
    }

    handleChange(event) {
        this._selectedValue = event.detail.value;
    }

    @wire(getRecord, { recordId: '$recordId',  fields: RECORD_FIELDS })
    wiredGetRecordInfo({ data, error }) {
        if (data) {
            this._recordInfo = data;
            this._selectedValue = getFieldValue(this._recordInfo, STATUS_FIELD);
        }

        else if (error) {
            console.log(error);
            alert(reduceErrors(error));
        }
    }

    @wire(getObjectInfo, { objectApiName: LISTING_OBJECT })
    wiredObjectInfo({ data, error }) {
        if (data) {
            this._objectInfo = data;
        }

        else if (error) {
            console.log(error);
            alert(reduceErrors(error));
        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: LISTING_OBJECT, recordTypeId:'$recordTypeId' })
    wiredPicklistValuesByRecordType({data, error}) {
        if (data) {
            this._picklistValuesInfo = data;
        }
        else if (error) {
            alert(reduceErrors(error));
            this._statusOptionList = [];
        }
    }

    handleCancel() {
        const cancelEvent = new CustomEvent(CANCEL_EVENT);
        this.dispatchEvent(cancelEvent);
    }

    handleSaveStatus() {
        saveStatus({ params: {recordId: this.recordId, newStatus: this._selectedValue} }).then(response => {
            if (response.baseUrl && response.newRecordId) {
                redirectToNewRecordId(response);
            }
        }).catch(error => {
            displayErrorAlert(error);
        });
    }

    handleMergeDraftWithMaster() {
        saveDraft({ params: {recordId: this.recordId} }).then(response => {
            if (response.baseUrl && response.newRecordId) {
                redirectToNewRecordId(response);
            }
        }).catch(error => {
            displayErrorAlert(error);
        });
    }
}