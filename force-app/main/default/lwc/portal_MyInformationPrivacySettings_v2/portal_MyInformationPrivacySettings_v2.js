import { LightningElement, track, api } from 'lwc';
import viewTemplate from './portal_MyInformationPrivacySettingsView_v2.html';
import editTemplate from './portal_MyInformationPrivacySettingsEdit_v2.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationPrivacySettingsHelper_v2';
export * from './portal_MyInformationPrivacySettingsHelper_v2';

export default class Portal_MyInformationPrivacySettings_v2 extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};
    
    @api 
    get isDisplay() {
        return this._isDisplay
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

    get recordMap() {
        return this.componentAttributes.recordMap;
    }

    get directorySetting() {
        if (!this.componentLogic) {
            return [];
        }

        return this.componentLogic.directorySetting;
    }

    get directoryOptOut() {
        return this.componentAttributes?.recordMap?.directoryOptOut || [];
    }

    get isDirectoryOptIn() {
        return !this.directoryOptOut?.[0]?.isDirectoryOptOut;
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
        const mainSectionName = 'Privacy_Settings';
        const subSectionNames = [{sectionId: 'directorySetting', sectionName: 'Directory_Setting'}, 
                                 {sectionId: 'directoryOptOut', sectionName: 'Directory_Opt_Out'}];

        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildPageName(pageName)
                                                         .buildMainSectionName(mainSectionName)
                                                         .buildSubSectionNames(subSectionNames)
                                                         .build();

        this.componentLogic.getComponentData();
        this._isDataLoaded = true;
    }

    handlePendingUpdate = (event) => {
        // TODO future case
    }

    handleReportUpdate = (event) => {
        // TODO future case
    }

    handleChange = (value, fieldId, recordIndex, sectionId) => {
        this.componentLogic.handleChange(value, fieldId, recordIndex, sectionId);
    }
}