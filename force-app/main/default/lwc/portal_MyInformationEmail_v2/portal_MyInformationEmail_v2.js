import { LightningElement, track, api } from 'lwc';
import deleteIconResource from '@salesforce/resourceUrl/Portal_Delete_Icon';

import viewTemplate from './portal_MyInformationEmailView_v2.html';
import editTemplate from './portal_MyInformationEmailEdit_v2.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationEmailHelper_v2';
export * from './portal_MyInformationEmailHelper_v2';

export default class Portal_MyInformationEmail_v2 extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};
    
    sectionId = 'emails';

    // self report modal attributes
    @track _isDisplaySelfReportModal = false;
    @track _selfReportModalType = undefined;
    @track _selfReportConfiguration = undefined;
    @track _selfReportSaveParams = undefined;
    @track _selfReportRecord = undefined;
    _selfReportOriginalRecordIndex = undefined;
    _selfReportRecordIndex = undefined;
    _requestUpdateRichText = '';

    @api 
    get isDisplay() {
        return this._isDisplay;
    }

    set isDisplay(isDisplay) {
        this._isDisplay = isDisplay;
        this.setup();
    }

    @api
    get displayMode() {
        return this._displayMode;
    }

    set displayMode(displayMode) {
        this._displayMode = displayMode;        
        this.setup();
    }

    @api
    checkAndReportInputValidity() {
        if (!this.componentLogic) {
            return true;
        }

        return this.componentLogic.checkAndReportInputValidity();
    }

    @api
    getInvalidFieldList() {
        if (!this.componentLogic) {
            return [];
        }

        return this.componentLogic.getInvalidFieldList();
    }

    @api
    getUpdatedRecordsMap() {
        if (!this.componentLogic) {
            return {};
        }

        return this.componentLogic.getUpdatedRecordsMap();
    }

    get sectionConfiguration() {
        return this.componentAttributes.sectionConfiguration || {};
    }

    get recordList() {
        return this.componentAttributes.recordList;
    }

    get deleteIcon() {
        return deleteIconResource;
    }

    get isShowAdd() {
        return this.componentAttributes.isMultipleCurrentEmailsEnabled || !this.componentAttributes.recordList.some(eachEmail => eachEmail.emailTypePicklistValues.length <= 1);
    }

    connectedCallback() {
        this.setup();
    }

    render() {
        return this.displayMode == 'view' ? viewTemplate : editTemplate;
    }

    setup() {
        if (this._isDataLoaded || !this.isDisplay) {
            return;
        }

        const pageName = 'My Information';
        const mainSectionName = 'Emails';
        const selfReportPageName = 'My Information Self Report';
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildPageName(pageName)
                                                         .buildMainSectionName(mainSectionName)
                                                         .buildSelfReportPageName(selfReportPageName)
                                                         .build();

        this.componentLogic.getComponentData();
        this._isDataLoaded = true;
    }

    handleSelfReport = (event) => {
        this.componentLogic.handleSelfReport(event);
    }

    handleSelfReportClose = (newSelfReportRecord) => {
        this.componentLogic.handleSelfReportClose(newSelfReportRecord);
    }

    handleAddEmail = (event) => {
        this.componentLogic.handleAddEmail();
    }

    handleDeleteEmail = (event) => {
        this.componentLogic.handleDeleteEmail(event.currentTarget.dataset.index);
    }

    handleChange = (value, fieldId, recordIndex) => {
        this.componentLogic.handleChange(value, fieldId, recordIndex);
    }
}