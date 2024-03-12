import { LightningElement, track, api } from 'lwc';
import deleteIconResource from '@salesforce/resourceUrl/Portal_Delete_Icon';
import viewTemplate from './portal_MyInformationDegreeView_v2.html';
import editTemplate from './portal_MyInformationDegreeEdit_v2.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationDegreeHelper_v2';
export * from './portal_MyInformationDegreeHelper_v2';

export default class Portal_MyInformationDegree_v2 extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;

    // self report modal attributes
    @track _isDisplaySelfReportModal = false;
    @track _selfReportModalType = undefined;
    @track _selfReportConfiguration = undefined;
    @track _selfReportSaveParams = undefined;
    @track _selfReportRecord = undefined;
    _selfReportOriginalRecordIndex = undefined;
    _selfReportRecordIndex = undefined;
    _requestUpdateRichText = '';

    @track componentLogic = undefined;
    @track componentAttributes = {};

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
        return this.componentAttributes.sectionConfiguration;
    }

    get recordMap() {
        return this.componentAttributes.recordMap;
    }

    get schoolDegrees() {
        return this.componentAttributes?.recordMap?.schoolDegrees || [];
    }

    get nonSchoolDegrees() {
        return this.componentAttributes?.recordMap?.nonSchoolDegrees || [];
    }

    get isDisplaySchoolDegrees() {
        return this.componentAttributes?.sectionConfiguration?.schoolDegrees?.isDisplay;
    }

    get isDisplayNonSchoolDegrees() {
        return this.componentAttributes?.sectionConfiguration?.nonSchoolDegrees?.isDisplay;
    }

    get deleteIcon() {
        return deleteIconResource;
    }

    connectedCallback() {
        this.setup();
    }

    render() {
        return this.displayMode === 'view' ? viewTemplate : editTemplate;
    }

    setup() {
        if (this._isDataLoaded || !this.isDisplay) {
            return;
        }

        const pageName = 'My Information';
        const mainSectionName = 'Degrees';
        const subSectionNames = [{sectionId: 'schoolDegrees', sectionName: 'School_Degree_Information'}, 
                                 {sectionId: 'nonSchoolDegrees', sectionName: 'Non_School_Degree_Information'}];
        const selfReportPageName = 'My Information Self Report';

        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildPageName(pageName)
                                                         .buildMainSectionName(mainSectionName)
                                                         .buildSubSectionNames(subSectionNames)
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

    handleAddDegree = (event) => {
        this.componentLogic.handleAddDegree(event.currentTarget.dataset.sectionId);
    }

    handleDeleteDegree = (event) => {
        this.componentLogic.handleDeleteDegree(event.currentTarget.dataset.sectionId, event.currentTarget.dataset.index);
    }

    handleLookupSelection = (option, fieldId, recordIndex, sectionId, lookupFieldId) => {
        this.componentLogic.handleLookupSelection(option, fieldId, recordIndex, sectionId, lookupFieldId);
    }

    handleChange = (value, fieldId, recordIndex, sectionId) => {
        this.componentLogic.handleChange(value, fieldId, recordIndex, sectionId);
    }
}