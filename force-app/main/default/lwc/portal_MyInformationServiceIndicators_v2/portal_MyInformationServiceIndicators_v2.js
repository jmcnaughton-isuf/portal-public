import { LightningElement, api, track } from 'lwc';
import viewTemplate from './portal_MyInformationServiceIndicatorsView_v2.html';
import editTemplate from './portal_MyInformationServiceIndicatorsEdit_v2.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationServiceIndicatorsHelper_v2';
export * from './portal_MyInformationServiceIndicatorsHelper_v2';

export default class Portal_MyInformationServiceIndicators_v2 extends LightningElement {
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;
    @track _itemsPerPage = 5;
    @track _currentPage = 1;
    @track _isCalloutFinished = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};

    sectionId = 'serviceIndicators';

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

    get stickyServiceIndicators() {
        return this.componentAttributes?.stickyServiceIndicators || [];
    }

    get isDisplayServiceIndicators() {
        return this._isCalloutFinished && this.componentAttributes?.sectionConfiguration?.serviceIndicators?.isDisplay;
    }

    get isDisplaySearchBar() {
        return this.componentAttributes?.isDisplaySearchBar;
    }

    get searchInput() {
        return this.componentAttributes?.searchInput || '';
    }

    get searchResults() {
        return this.componentAttributes?.searchResults || [];
    }

    get searchResultsToDisplay() {
        return this.componentAttributes?.searchResultsToDisplay || [];
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
        const mainSectionName = 'Privacy_Settings';
        const subSectionNames = [{sectionId: 'serviceIndicators', sectionName: 'Service Indicators'}, 
                                 {sectionId: 'serviceIndicatorValues', sectionName: 'Service Indicator Values'}];
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildPageName(pageName)
                                                         .buildMainSectionName(mainSectionName)
                                                         .buildSubSectionNames(subSectionNames)
                                                         .build();

        this.componentLogic.getComponentData();
        this._isDataLoaded = true;
    }

    handleSearchServiceIndicators = (event) => {
        this.componentLogic.handleSearchForServiceIndicators();
    }

    handleSearchInput = (event) => {
        this.componentLogic.handleSearchInput(event);
    }

    handleReset = (event) => {
        this.componentLogic.handleReset(event);
    }

    handleChange = (value, fieldId, recordIndex, sectionId) => {
        this.componentLogic.handleChange(value, fieldId, recordIndex, sectionId);
    }

    handlePageChange = (searchResultsToDisplay, pageNumber) => {
        this.componentLogic.handlePageChange(searchResultsToDisplay, pageNumber);
    }
}