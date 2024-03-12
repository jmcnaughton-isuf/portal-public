import { callApexFunction } from 'c/portal_util_ApexCallout';
import getViewInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo';
import getEditInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo';
import getInternationalAutocompleteConfigurationMap from '@salesforce/apex/PORTAL_LWC_AddressServiceHubController.SERVER_getInternationalAutocompleteConfigurationMap';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildPageName(pageName) {
        this.result._pageName = pageName;
        return this;
    }

    buildMainSectionName(mainSectionName) {
        this.result._mainSectionName = mainSectionName;
        return this;
    }

    buildSubSectionName(subSectionName) {
        this.result._subSectionName = subSectionName;
        return this;
    }

    buildSelfReportPageName(selfReportPageName) {
        this.result._selfReportPageName = selfReportPageName;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;
    _pageName = '';
    _mainSectionName = '';
    _subSectionName = '';
    _selfReportPageName = '';

    _recordList = [];
    _sectionConfiguration = {};
    _selfReportSectionConfiguration = {};
    _selfReportRecordList = [];
    _isMultipleCurrentAddressesEnabled = false;

    _countryPicklistValues = [];
    _countryToListOfStatesMap = {};

    _hasAddressAutocomplete = false;
    _hasInternationalAutocomplete = false;
    _countryNameToIso3CodeMap = {};
    _autocompleteCountryPicklistValues = [];
    _defaultCountryLabel = undefined;
    _defaultCountryCode = undefined;
    _autocompleteFieldNameMap = {streetLine1: 'addressLine1', streetLine2: 'addressLine2', city: 'addressCity', 
                                 state: 'addressState', postalCode: 'addressPostalCode', country: 'addressCountry'};

    get pageName() {
        return this._pageName;
    }  
    
    get mainSectionName() {
        return this._mainSectionName;
    }

    get subSectionName() {
        return this._subSectionName;
    }
    
    get selfReportPageName() {
        return this._selfReportPageName;
    }

    get recordList() {
        return this._recordList;
    }

    get selfReportRecordList() {
        return this._selfReportRecordList;
    }

    get sectionConfiguration() {
        return this._sectionConfiguration;
    }

    get selfReportSectionConfiguration() {
        return this._selfReportSectionConfiguration;
    }

    get isMultipleCurrentAddressesEnabled() {
        return this._isMultipleCurrentAddressesEnabled;
    }

    get countryPicklistValues() {
        return this._countryPicklistValues;
    }

    get hasAddressAutocomplete() {
        return this._hasAddressAutocomplete;   
    }

    get hasInternationalAutocomplete() {
        return this._hasInternationalAutocomplete;
    }

    get autocompleteCountryPicklistValues() {
        return this._autocompleteCountryPicklistValues;
    }

    set recordList(recordList) {
        this._recordList = recordList;
        this._lightningElement.componentAttributes.recordList = recordList;
    }

    set sectionConfiguration(sectionConfiguration) {
        this._sectionConfiguration = sectionConfiguration;
        this._lightningElement.componentAttributes.sectionConfiguration = sectionConfiguration;
    }

    set selfReportSectionConfiguration(selfReportSectionConfiguration) {
        this._selfReportSectionConfiguration = selfReportSectionConfiguration;
        this._lightningElement._selfReportConfiguration = selfReportSectionConfiguration;
    }

    set isMultipleCurrentAddressesEnabled(isMultipleCurrentAddressesEnabled) {
        this._isMultipleCurrentAddressesEnabled = isMultipleCurrentAddressesEnabled;
        this._lightningElement.componentAttributes.isMultipleCurrentAddressesEnabled = isMultipleCurrentAddressesEnabled;
    }

    set countryPicklistValues(countryPicklistValues) {
        this._countryPicklistValues = countryPicklistValues;
        this._lightningElement.componentAttributes.countryPicklistValues = countryPicklistValues;
    }

    set hasAddressAutocomplete(hasAddressAutocomplete) {
        this._hasAddressAutocomplete = hasAddressAutocomplete;
        this._lightningElement.componentAttributes.hasAddressAutocomplete = hasAddressAutocomplete;
    }

    set hasInternationalAutocomplete(hasInternationalAutocomplete) {
        this._hasInternationalAutocomplete = hasInternationalAutocomplete;
        this._lightningElement.componentAttributes.hasInternationalAutocomplete = hasInternationalAutocomplete;
    }

    set autocompleteCountryPicklistValues(autocompleteCountryPicklistValues) {
        this._autocompleteCountryPicklistValues = autocompleteCountryPicklistValues;
        this._lightningElement.componentAttributes.autocompleteCountryPicklistValues = autocompleteCountryPicklistValues;
    }

    getComponentData() {
        let params = {
            pageName: this.pageName,
            mainSectionName: this.mainSectionName,
            subSectionName: this.subSectionName
        }

        this._lightningElement._isShowSpinner = true;

        if (this._lightningElement.displayMode === 'view') {
            callApexFunction(this._lightningElement, getViewInfo, params, (response) => {
                this.setComponentViewAttributes(response);
            }, () => {}).finally(() => {
                this._lightningElement._isShowSpinner = false;
            });
        } else if (this._lightningElement.displayMode === 'edit') {
            params.selfReportPageName = this.selfReportPageName;
            callApexFunction(this._lightningElement, getEditInfo, params, async (response) => {
                await this.setComponentEditAttributes(response);
            }, () => {}).finally(() => {
                this._lightningElement._isShowSpinner = false;
            });
        }
    }

    setComponentViewAttributes(response) {
        this.recordList = response?.recordListWithStagedChanges;
        this.sectionConfiguration = JSON.parse(response?.configString)?.sectionConfigurationMap?.[this._lightningElement.sectionId];
    }

    async setComponentEditAttributes(response) {
        if (!response) {
            return;
        }

        let selfReportOriginalIdSet = new Set();
        if (response?.selfReportRecordList) {
            for (let eachSelfReportRecord of response.selfReportRecordList) {
                selfReportOriginalIdSet.add(eachSelfReportRecord.originalRecord);
                this._selfReportRecordList.push(eachSelfReportRecord);
            }
        }

        let configuration = JSON.parse(response?.configString || '{}');
        this.sectionConfiguration = configuration?.sectionConfigurationMap?.[this._lightningElement.sectionId];
        this.selfReportSectionConfiguration = configuration?.selfReportSectionConfigurationMap?.[this._lightningElement.sectionId];
        this.isMultipleCurrentAddressesEnabled = configuration?.isMultipleCurrentAddressesEnabled;
        this._lightningElement._requestUpdateRichText = configuration?.requestUpdateRichText;
        await this.setComponentAutocompleteConfiguration(configuration?.hasAddressAutocomplete);

        // make a copy so the map can be edited
        let recordListClone = [];
        let timestamp = Date.now();
        for (let eachRecord of response?.recordListWithStagedChanges) {
            let selectedCountryCode = this._countryNameToIso3CodeMap[eachRecord.addressCountry];
            selectedCountryCode = (eachRecord.addressCountry && selectedCountryCode !== undefined) ? selectedCountryCode : this._defaultCountryCode;
            let selectedCountry = selectedCountryCode === this._defaultCountryCode ? this._defaultCountryLabel : eachRecord.addressCountry;
            recordListClone.push({
                                    ...eachRecord,
                                    selectedCountryCode: selectedCountryCode,
                                    selectedCountry: selectedCountry,
                                    isCityRequired: this.sectionConfiguration?.fieldConfigurationMap?.addressCity?.isRequired,
                                    isPostalCodeRequired: this.sectionConfiguration?.fieldConfigurationMap?.addressPostalCode?.isRequired,
                                    isStateRequired: this.sectionConfiguration?.fieldConfigurationMap?.addressState?.isRequired,
                                    timestampHtmlKey: ++timestamp,  // key name is unlikely to collide with fields, distinct values needed for HTML iteration
                                    isDelete: false,                // backend requires isDelete to be true or false
                                    hasSelfReportChange: selfReportOriginalIdSet.has(eachRecord.Id),
                                    addressTypePicklistValues: this.getAddressTypePicklistValues(eachRecord.addressType)
                                });
        }
        this.recordList = recordListClone;
    }
    
    setComponentAutocompleteConfiguration(hasAddressAutocomplete) {
        this.hasAddressAutocomplete = hasAddressAutocomplete;
        if (!this.hasAddressAutocomplete) {
            return;
        }

        return callApexFunction(this._lightningElement, getInternationalAutocompleteConfigurationMap, {}, (response) => {
            if (!response?.hasInternationalAutocomplete) {
                return;
            }

            this._countryNameToIso3CodeMap = response.countryCodeMap;
            this.autocompleteCountryPicklistValues = Object.entries(this._countryNameToIso3CodeMap).map(([label, value]) => {return {'label': label, 'value': value}});
            this._defaultCountryLabel = response.defaultCountry;
            this._defaultCountryCode = this._countryNameToIso3CodeMap[this._defaultCountryLabel];
            this.hasInternationalAutocomplete = response.hasInternationalAutocomplete;
        }, () => {});
    }

    get stateInputType() {
        return this.hasAddressAutocomplete ? 'text' : this.sectionConfiguration.fieldConfigurationMap.addressState.fieldType;
    }

    get countryInputType() {
        return this.hasAddressAutocomplete ? 'text' : this.sectionConfiguration.fieldConfigurationMap.addressCountry.fieldType;
    }

    get newAddress() {
        let addressTypePicklistValues = this.getAddressTypePicklistValues();
        return {
            Id: null,
            addressId: null,
            addressType: addressTypePicklistValues[0].value,
            addressLine1: "",
            addressLine2: "",
            addressLine3: "",
            addressCity: "",
            addressState: "",
            addressCountry: "",
            selectedCountryCode: this._defaultCountryCode || "", // frontend field
            selectedCountry: this._defaultCountryLabel || "", // frontend field
            addressPostalCode: "",
            addressStatus: "Current",
            addressShowOnDirectory: true,
            isCityRequired: this.sectionConfiguration?.fieldConfigurationMap?.addressCity?.isRequired, // isRequired fields are frontend only
            isPostalCodeRequired: this.sectionConfiguration?.fieldConfigurationMap?.addressPostalCode?.isRequired,
            isStateRequired: this.sectionConfiguration?.fieldConfigurationMap?.addressState?.isRequired,
            isShowAddressLines: true,
            isShowCity: true,
            isShowCountry: true,
            isShowPostalCode: true,
            isShowState: true,
            isDisplayOnPortal: true,
            addressIsPreferred: false,
            timestampHtmlKey: Date.now(),
            addressTypePicklistValues: addressTypePicklistValues,
            isDelete: false
        };
    }

    handleAddAddress() {
        this._recordList.push(this.newAddress);
        this._lightningElement.componentAttributes.recordList = [...this._recordList];

        if (!this.isMultipleCurrentAddressesEnabled) {
            this.setAddressTypePicklists();
        }
    }

    handleDeleteAddress(recordIndex) {
        let record = this._recordList[recordIndex];
        if (record.Id) {
            record.isDelete = true;
            record.timestampHtmlKey = Date.now();
        } else {
            this._recordList.splice(recordIndex, 1);
        }

        this._lightningElement.componentAttributes.recordList = [...this._recordList];

        if (!this.isMultipleCurrentAddressesEnabled) {
            this.setAddressTypePicklists();
        }
    }

    handleChange(value, fieldId, recordIndex) {
        this._recordList[recordIndex][fieldId] = value;

        if (fieldId === 'addressIsPreferred' && value === true) {
            this.setAddressesToUnpreferred(recordIndex);
        }

        if (fieldId === 'addressType' && !this.isMultipleCurrentAddressesEnabled) {
            this.setAddressTypePicklists();
        }

        if (fieldId === 'addressCountry') {
            this.setStatePicklistValues(recordIndex);
        }
    }

    setAddressesToUnpreferred(recordIndex) {
        for (let eachAddressIndex = 0; eachAddressIndex < this.recordList.length; eachAddressIndex++) {
            if (eachAddressIndex !== recordIndex) {
                this.recordList[eachAddressIndex].addressIsPreferred = false;
            }
        }
        
        this.recordList = [...this.recordList];
    }

    setAddressTypePicklists() {
        for (let eachRecord of this.recordList) {
            eachRecord.addressTypePicklistValues = this.getAddressTypePicklistValues(eachRecord.addressType);
        }

        this.recordList = [...this.recordList];
    }

    getAddressTypePicklistValues(addressType) {
        if (this.isMultipleCurrentAddressesEnabled) {
            return this.sectionConfiguration.fieldConfigurationMap.addressType.picklistValues;
        }

        let existingPicklistValues = new Set(this.recordList.map(eachRecord => !eachRecord.isDelete ? eachRecord.addressType : ''));
        let addressTypePicklistValues = this.sectionConfiguration.fieldConfigurationMap.addressType.picklistValues.filter(eachValue => (eachValue.value == addressType || !existingPicklistValues.has(eachValue.value)));
        return addressTypePicklistValues;
    }

    setStatePicklistValues(recordIndex) {
        let thisRecord = this.recordList[recordIndex];
        thisRecord.statePicklistValues = this.getStatePicklistValues(thisRecord.addressCountry);

        this.recordList = [...this.recordList];
    }

    getStatePicklistValues(addressCountry) {
        return this._countryToListOfStatesMap[addressCountry] || [];
    }

    setAddressStreetToggle(event) {
        let index = event.currentTarget.dataset.index;
        this.recordList[index].isShowAddressLines = event.currentTarget.checked;
    }

    handleCountrySelection(event) {
        let select = event.currentTarget;
        let recordIndex = select.getAttribute('name');

        this.handleChange(this.sectionConfiguration?.fieldConfigurationMap?.addressCity?.isRequired, 'isCityRequired', recordIndex);
        this.handleChange(this.sectionConfiguration?.fieldConfigurationMap?.addressPostalCode?.isRequired, 'isPostalCodeRequired', recordIndex);
        this.handleChange(this.sectionConfiguration?.fieldConfigurationMap?.addressState?.isRequired, 'isStateRequired', recordIndex);
        this.handleChange(select.value, 'selectedCountryCode', recordIndex);
        this.handleChange(select.options[select.selectedIndex].text, 'selectedCountry', recordIndex);
        this.recordList = [...this.recordList];
    }

    handleAddressSelection(selectedAddress, recordIndex) {
        if (this.recordList[recordIndex].selectedCountry) {
            this.handleChange(this.recordList[recordIndex].selectedCountry, 'addressCountry', recordIndex);
        }
        // There's never a line 3 in the autocomplete response
        this.handleChange('', 'addressLine3', recordIndex);
        this.handleChange(Date.now(), 'timestampHtmlKey', recordIndex);
        
        for (let [addressWrapperField, value] of Object.entries(selectedAddress)) {
            let addressField = this._autocompleteFieldNameMap[addressWrapperField];
            if (!addressField) {
                continue;
            }
            
            this.handleChange(value, addressField, recordIndex);
            if (addressWrapperField === 'city') {
                this.handleChange((value !== '') && this.sectionConfiguration?.fieldConfigurationMap?.addressCity?.isRequired, 'isCityRequired', recordIndex);
            } else if (addressWrapperField === 'postalCode') {
                this.handleChange((value !== '') && this.sectionConfiguration?.fieldConfigurationMap?.addressPostalCode?.isRequired, 'isPostalCodeRequired', recordIndex);
            } else if (addressWrapperField === 'state') {
                this.handleChange((value !== '') && this.sectionConfiguration?.fieldConfigurationMap?.addressState?.isRequired, 'isStateRequired', recordIndex);
            }
        }

        this.recordList = [...this.recordList];
    }

    handleSelfReport(event) {
        let recordIndex = event.currentTarget.dataset.index;

        let originalRecord = this.recordList[recordIndex];
        let currentSelfReportRecord = undefined;

        this._lightningElement._selfReportOriginalRecordIndex = recordIndex;
        let selfReportRecordIndex = 0;
        for (let eachSelfReportRecord of this.selfReportRecordList) {
            if (eachSelfReportRecord.originalRecord === originalRecord.Id) {
                currentSelfReportRecord = eachSelfReportRecord;
                this._lightningElement._selfReportRecordIndex = selfReportRecordIndex;
                break;
            }
            ++selfReportRecordIndex;
        }

        this._lightningElement._selfReportRecord = currentSelfReportRecord || {...originalRecord, Id: undefined, originalRecord: undefined};
        this._lightningElement._selfReportModalType = this._lightningElement.sectionId;

        this._lightningElement._selfReportSaveParams = {
            originalRecordId: originalRecord.Id,
            pageName: this.selfReportPageName,
            mainSectionName: this.mainSectionName,
            sectionId: this._lightningElement.sectionId
        };

        this._lightningElement._isDisplaySelfReportModal = true; 
    }

    handleSelfReportClose(newSelfReportRecord) {
        this.setNewSelfReportRecord(newSelfReportRecord);

        this._lightningElement._selfReportModalType = undefined;
        this._lightningElement._selfReportRecord = undefined;
        this._lightningElement._selfReportSaveParams = undefined;
        this._lightningElement._selfReportOriginalRecordIndex = undefined;
        this._lightningElement._selfReportRecordIndex = undefined;

        this._lightningElement._isDisplaySelfReportModal = false; 
    }

    setNewSelfReportRecord(newSelfReportRecord) {
        if (!newSelfReportRecord) {
            return;
        }

        this._lightningElement.componentAttributes.recordList[this._lightningElement._selfReportOriginalRecordIndex].hasSelfReportChange = true

        let selfReportIndex = this._lightningElement._selfReportRecordIndex;
        if (selfReportIndex === undefined) {
            this.selfReportRecordList.push(newSelfReportRecord);
            return;
        }

        this.selfReportRecordList[selfReportIndex] = newSelfReportRecord;
    }

    checkAndReportInputValidity() {
        let editFieldList = this._lightningElement.template.querySelectorAll('c-portal_-My-Information-Edit-Field_v2');
        if (!editFieldList || editFieldList.length === 0) {
            return true;
        }

        for (let eachField of editFieldList) {
            let isValid = eachField.checkAndReportValidity();
            if (!isValid) {
                return false;
            }
        }

        return true;
    }

    getInvalidFieldList() {
        let invalidFieldList = [];
        const editFieldList = this._lightningElement.template.querySelectorAll('c-portal_-My-Information-Edit-Field_v2');
        if (!editFieldList || editFieldList.length === 0) {
            return invalidFieldList;
        }

        for (const eachField of editFieldList) {
            if (eachField.checkAndReportValidity()) {
                continue;
            }

            const invalidFieldLabel = eachField.label || this.sectionConfiguration.fieldConfigurationMap?.[eachField.fieldId]?.label;
            if (invalidFieldLabel) {
                invalidFieldList.push(invalidFieldLabel);
            }
        }

        return invalidFieldList;
    }

    getUpdatedRecordsMap() {
        let returnMap = {};
        returnMap[this._lightningElement.sectionId] = this._recordList;
        return returnMap;
    }

    handleWireGetObjectInfo(data, error) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        this._lightningElement.countryPicklistField = {
            fieldApiName: data.fields.MailingCountryCode?.apiName,
            objectApiName: 'Contact'
        };
        this._lightningElement.statePicklistField = {
            fieldApiName: data.fields.MailingStateCode?.apiName,
            objectApiName: 'Contact'
        };
        this._lightningElement.defaultRecordTypeId = data.defaultRecordTypeId;
        
    }

    handleWireGetCountryPicklists(data, error) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        // Need to do this because ascend converts value into label when saved to address record. 
        // For example Portal will save as US, ascend converts into United States. When portal tries to load front end, it cannot find United States as a value so nothing renders on picklist.
        // To avoid this problem we align the value with the label in the picklist we pass into portal front end.
        let countryPicklistClone = [];
        let countryCodeToLabelMap = {};
        for (let eachCountry of data?.values) {
            countryPicklistClone.push({
                ...eachCountry,
                value: eachCountry.label
            });

            countryCodeToLabelMap[eachCountry.value] = eachCountry.label;            
        }

        this.countryPicklistValues = countryPicklistClone;
        this._lightningElement.countryCodeToLabelMap = countryCodeToLabelMap;
    }

    handleWireGetStatePicklists(data, error) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        // This holds country iso code(233) to country code(US). 
        const validForNumberToCountry = Object.fromEntries(Object.entries(data.controllerValues).map(([key, value]) => [value, key]));
 
        let listOfStates = [];
        for (let eachState of data?.values) {
            listOfStates.push({
                ...eachState,
                value: eachState.label
            });
        }

        this._countryToListOfStatesMap = listOfStates.reduce((accumulatedStates, statePicklistValues) => {
            const countryIsoCode = this._lightningElement.countryCodeToLabelMap[validForNumberToCountry[statePicklistValues.validFor[0]]];
            accumulatedStates[countryIsoCode] = accumulatedStates[countryIsoCode] || [];
            accumulatedStates[countryIsoCode].push(statePicklistValues);
            return accumulatedStates;
        }, {});

        let recordListClone = [];
        for (let eachRecord of this.recordList) {
            recordListClone.push({
                                    ...eachRecord,
                                    statePicklistValues: this.getStatePicklistValues(eachRecord.addressCountry)
                                });
        }

        this.recordList = recordListClone;
    }
}