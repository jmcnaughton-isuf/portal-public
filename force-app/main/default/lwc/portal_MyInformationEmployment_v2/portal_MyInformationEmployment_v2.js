import { LightningElement, track, api } from 'lwc';
import viewTemplate from './portal_MyInformationEmploymentView_v2.html';
import editTemplate from './portal_MyInformationEmploymentEdit_v2.html';
import deleteIconResource from '@salesforce/resourceUrl/Portal_Delete_Icon';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationEmploymentHelper_v2';
export * from './portal_MyInformationEmploymentHelper_v2';

export default class Portal_MyInformationEmployment_v2 extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};
    
    sectionId = 'employment';

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
        const mainSectionName = 'Employment';
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

    handleAddEmployment = (event) => {
        this.componentLogic.handleAddEmployment();
    }

    handleDeleteEmployment = (event) => {
        this.componentLogic.handleDeleteEmployment(event.currentTarget.dataset.index);
    }

    handleChange = (value, fieldId, recordIndex, sectionId) => {
        this.componentLogic.handleChange(value, fieldId, recordIndex, sectionId);
    }

    handleLookupSelection = (option, fieldId, recordIndex, sectionId, lookupFieldId) => {
        this.componentLogic.handleLookupSelection(option, fieldId, recordIndex, sectionId, lookupFieldId);
    }
}