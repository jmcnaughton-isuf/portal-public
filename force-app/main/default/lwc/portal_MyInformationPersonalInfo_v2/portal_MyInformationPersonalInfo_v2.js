import { LightningElement, track, api } from 'lwc';
import viewTemplate from './portal_MyInformationPersonalInfoView_v2.html';
import editTemplate from './portal_MyInformationPersonalInfoEdit_v2.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationPersonalInfoHelper_v2';
export * from './portal_MyInformationPersonalInfoHelper_v2';

export default class Portal_MyInformationPersonalInfo_v2 extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;

    // self report modal attributes
    @track _isDisplaySelfReportModal = false;
    @track _selfReportConfiguration = undefined;
    @track _selfReportFieldId = undefined;
    @track _selfReportSaveParams = undefined;
    @track _selfReportRecord = undefined;
    _selfReportOriginalRecordIndex = undefined;
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

    get selfReportChangeMap() {
        return this.componentAttributes.selfReportChangeMap;
    }

    get additionalDetails() {
        return this.recordMap?.additionalDetails[0];
    }

    get maidenName() {
        return this.recordMap?.maidenName[0] || {};
    }

    get nickName() {
        return this.recordMap?.nickname[0] || {};
    }

    get name() {
        return this.recordMap?.name[0];
    }

    get directoryName() {
        return this.recordMap?.directoryName[0] || {};
    }

    get birthdate() {
        return this.componentLogic.getBirthdate(this.additionalDetails);
    }

    get selfReportAdditionalDetailsChanges() {
        return this.selfReportChangeMap?.additionalDetails?.[0] || {};
    }

    get selfReportNameChanges() {
        return this.selfReportChangeMap?.name?.[0] || {};
    }

    get selfReportMaidenNameChanges() {
        return this.selfReportChangeMap?.maidenName?.[0] || {};
    }

    get selfReportNicknameChanges() {
        return this.selfReportChangeMap?.nickname?.[0] || {};
    }

    get selfReportDirectoryNameChanges() {
        return this.selfReportChangeMap?.directoryName?.[0] || {};
    }

    get isDisplayName() {
        return this.sectionConfiguration?.name?.isDisplay;
    }

    get isDisplayAdditionalDetails() {
        return this.sectionConfiguration?.additionalDetails?.isDisplay;
    }

    get isDisplayNickname() {
        return this.sectionConfiguration?.nickname?.isDisplay;
    }

    get isDisplayMaidenName() {
        return this.sectionConfiguration?.maidenName?.isDisplay;
    }

    get isDisplayAlsoKnownAs() {
        return this.isDisplayNickname || this.isDisplayMaidenName;
    }

    get isDisplayDirectoryName() {
        return this.sectionConfiguration?.directoryName?.isDisplay;
    }

    get isShowMaidenNameToggleValue() {
        return this.componentLogic.isShowMaidenNameToggleValue;
    }

    get isShowNicknameToggleValue() {
        return this.componentLogic.isShowNicknameToggleValue;
    }

    get isShowGenderToggleValue() {
        return this.componentLogic.isShowGenderToggleValue;
    }

    get isShowPronounsToggleValue() {
        return this.componentLogic.isShowPronounsToggleValue;
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
        const mainSectionName = 'Personal_Information';
        const subSectionNames = [{sectionId: 'additionalDetails', sectionName: 'Additional_Details'}, 
                                 {sectionId: 'nickname', sectionName: 'Nickname'}, 
                                 {sectionId: 'maidenName', sectionName: 'Maiden Name'}, 
                                 {sectionId: 'directoryName', sectionName: 'Directory_Display_Name'}, 
                                 {sectionId: 'name', sectionName: 'Name'},
                                 {mainSectionName: 'Privacy_Settings', sectionId: 'directorySetting', sectionName: 'Directory_Setting'}];
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

    handleChange = (value, fieldId, index, sectionId) => {
        this.componentLogic.handleChange(value, fieldId, 0, sectionId);
    }

    handleToggleChange = (event) => {
        this.componentLogic.handleToggleChange(event);
    }
}