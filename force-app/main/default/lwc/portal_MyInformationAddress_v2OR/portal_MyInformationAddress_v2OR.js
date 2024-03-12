import { LightningElement, track, api, wire } from 'lwc';
import deleteIconResource from '@salesforce/resourceUrl/Portal_Delete_Icon';

import viewTemplate from './portal_MyInformationAddressView_v2OR.html';
import editTemplate from './portal_MyInformationAddressEdit_v2OR.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationAddressHelper_v2OR';
export * from './portal_MyInformationAddressHelper_v2OR';

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import COUNTRY_FIELD from '@salesforce/schema/ucinn_ascendv2__Address__c.isuf_Portal_Country__c';
import STATE_FIELD from '@salesforce/schema/ucinn_ascendv2__Address__c.isuf_Portal_State__c';


export default class Portal_MyInformationAddress_v2OR extends LightningElement {    
    @track _isShowSpinner = false;
    @track _isDisplay = false;
    @track _displayMode = 'view';
    @track _isDataLoaded = false;

    @track componentLogic = undefined;
    @track componentAttributes = {};
    
    sectionId = 'addresses';

    // self report modal attributes
    @track _isDisplaySelfReportModal = false;
    @track _selfReportModalType = undefined;
    @track _selfReportConfiguration = undefined;
    @track _selfReportSaveParams = undefined;
    @track _selfReportRecord = undefined;
    _selfReportOriginalRecordIndex = undefined;
    _selfReportRecordIndex = undefined;
    _requestUpdateRichText = '';

    statePicklistField = undefined;
    countryPicklistField = undefined;;
    defaultRecordTypeId = undefined;;
    countryCodeToLabelMap = {};

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

    get isShowStreetAddress() {
        const fieldConfigurationMap = this.componentAttributes?.sectionConfiguration?.fieldConfigurationMap;
        return (fieldConfigurationMap.addressLine1.isDisplay || fieldConfigurationMap.addressLine2.isDisplay || fieldConfigurationMap.addressLine3.isDisplay);
    }

    get isShowAdd() {
        return this.componentAttributes.isMultipleCurrentAddressesEnabled || (this.componentAttributes.recordList && !this.componentAttributes.recordList.some(eachAddress => eachAddress.addressTypePicklistValues.length <= 1));
    }

    get stateInputType() {
        return this.componentLogic.stateInputType;
    }

    get countryInputType() {
        return this.componentLogic.countryInputType;
    }

    get countryPicklistValues() {
        return this.componentAttributes.countryPicklistValues;
    }

    get hasAddressAutocomplete() {
        return this.componentAttributes.hasAddressAutocomplete || false;
    }

    get hasInternationalAutocomplete() {
        return this.componentAttributes.hasInternationalAutocomplete || false;
    }

    get autocompleteCountryPicklistValues() {
        return this.componentAttributes.autocompleteCountryPicklistValues || [];
    }

    get autocompleteFlexGrid() {
        return this.hasInternationalAutocomplete ? 'flex-grid-3' : 'flex-grid';
    }

    get autocompleteSearchStyle() {
        return 'padding-right: 0;' + (this.hasInternationalAutocomplete ? ' flex: 1 1 66.7% !important; max-width: 100%;' : '');
    }

    handleCountrySelection = (event) => {
        this.componentLogic.handleCountrySelection(event);
    }

    handleAddressSelection = (selectedAddress, recordIndex) => {
        this.componentLogic.handleAddressSelection(selectedAddress, recordIndex);
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

        this.initializeComponentLogic();
        this.componentLogic.getComponentData();
        this._isDataLoaded = true;
    }

    initializeComponentLogic() {
        if (this.componentLogic) {
            return;
        }

        const pageName = 'My Information';
        const mainSectionName = 'Addresses';
        const selfReportPageName = 'My Information Self Report';
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this)
                                                         .buildPageName(pageName)
                                                         .buildMainSectionName(mainSectionName)
                                                         .buildSelfReportPageName(selfReportPageName)
                                                         .build();
    }

    // Forced to use wire service here because uiObjectInfoAPI requires it.
    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    wireObjectInfo({ error, data }) {
        this.initializeComponentLogic();
        this.componentLogic.handleWireGetObjectInfo(data, error);
    }

    // Wire methods do not get called if any parameters are undefined. If fieldApiName is undefined because state/country picklist is turned off, then this wire service will not get called.
    @wire(getPicklistValues, {
        recordTypeId: "$defaultRecordTypeId",
        fieldApiName: "$countryPicklistField"
    })
    wiredCountryPicklists({ data, error }) {
        this.initializeComponentLogic();
        this.componentLogic.handleWireGetCountryPicklists(data, error);
    }

    @wire(getPicklistValues, {
        recordTypeId: "$defaultRecordTypeId", 
        fieldApiName: "$statePicklistField",
        countryCodeToLabelMap: "$countryCodeToLabelMap" })
    wiredStatePicklists({ data, error }) {
        this.initializeComponentLogic();
        this.componentLogic.handleWireGetStatePicklists(data, error);
    }

    handleSelfReport = (event) => {
        this.componentLogic.handleSelfReport(event);
    }

    handleSelfReportClose = (newSelfReportRecord) => {
        this.componentLogic.handleSelfReportClose(newSelfReportRecord);
    }

    handleAddAddress = (event) => {
        this.componentLogic.handleAddAddress();
    }

    handleDeleteAddress = (event) => {
        this.componentLogic.handleDeleteAddress(event.currentTarget.dataset.index);
    }

    handleChange = (value, fieldId, recordIndex) => {
        this.componentLogic.handleChange(value, fieldId, recordIndex);
    }

    setAddressStreetToggle = (event) => {
        this.componentLogic.setAddressStreetToggle(event);
    }
}