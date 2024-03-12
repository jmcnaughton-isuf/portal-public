import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import getViewInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo';
import getEditInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo';
import searchServiceIndicators from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_searchServiceIndicatorValues';
import isDisplaySearchBar from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_isDisplaySearchBar';

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

    buildSubSectionNames(subSectionNames) {
        this.result._subSectionNames = subSectionNames;
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
    _subSectionNames = [];

    _recordMap = {};
    _sectionConfiguration = {};

    _searchInput = '';
    _searchResults = [];

    _stickyServiceIndicators = [];
    _modifiedServiceIndicatorsMap = {};
    _constituentsNonStickyServiceIndicatorsMap = {};
    _originalAvailableServiceIndicatorsMap = {}; // Original List of Service Indicator values that constituent do not have, use this to concat to _constituentsNonStickyServiceIndicatorsMap values

    get pageName() {
        return this._pageName;
    }  
    
    get mainSectionName() {
        return this._mainSectionName;
    }

    get subSectionNames() {
        return this._subSectionNames;
    }
    
    get recordMap() {
        return this._recordMap;
    }

    get sectionConfiguration() {
        return this._sectionConfiguration;
    }

    getComponentData() {
        this._lightningElement._isShowSpinner = true;
        let calloutPromiseList = this.getCalloutPromiseList();
        Promise.all(calloutPromiseList).finally(() => {
            this.initializeServiceIndicators();
            this._lightningElement._isShowSpinner = false;
            this._lightningElement._isCalloutFinished = true;
        });
    }

    getCalloutPromiseList() {
        let calloutPromiseList = [];

        calloutPromiseList.push(callApexFunction(this._lightningElement, isDisplaySearchBar, {}, (response) => {
            this._lightningElement.componentAttributes.isDisplaySearchBar = response;
        }, () => {}));

        for (let subSection of this.subSectionNames) {
            let params = {
                pageName: this.pageName,
                mainSectionName: this.mainSectionName,
                subSectionName: subSection.sectionName
            }

            if (this._lightningElement.displayMode === 'view') {
                calloutPromiseList.push(callApexFunction(this._lightningElement, getViewInfo, params, (response) => {
                    this.setComponentViewAttributes(response, subSection);
                }, () => {}));
            } else if (this._lightningElement.displayMode === 'edit') {
                calloutPromiseList.push(callApexFunction(this._lightningElement, getEditInfo, params, (response) => {
                    this.setComponentEditAttributes(response, subSection);
                }, () => {}));
            }
        }

        return calloutPromiseList;
    }	

    initializeServiceIndicators() {
        let constituentServiceIndicators = [...this.recordMap.serviceIndicators];
        let stickyConstituentServiceIndicators = constituentServiceIndicators.filter(eachServiceIndicator => eachServiceIndicator.isSticky);
        let nonStickyConstituentServiceIndicators = constituentServiceIndicators.filter(eachServiceIndicator => !eachServiceIndicator.isSticky);

        this._lightningElement.componentAttributes.stickyServiceIndicators = this.getStickyServiceIndicators(stickyConstituentServiceIndicators);
        let initialSearchResults = this.getInitialSearchResults(nonStickyConstituentServiceIndicators);
        this._lightningElement.componentAttributes.searchResults = initialSearchResults;

        initialSearchResults.forEach(eachSearchResult => {
            let eachMap = eachSearchResult.Id ? this._constituentsNonStickyServiceIndicatorsMap : this._originalAvailableServiceIndicatorsMap;
            eachMap[eachSearchResult.serviceIndicatorValue] = eachSearchResult;
        })
    }

    getStickyServiceIndicators(stickyConstituentServiceIndicators) {
        let stickyServiceIndicators = [...stickyConstituentServiceIndicators];
        
        // Add sticky service indicator values to the sticky list (constituent doesnt have these)
        let serviceIndicatorsValueSet = new Set(stickyConstituentServiceIndicators.map(eachServiceIndicator => eachServiceIndicator.serviceIndicatorValue));
        let timeStamp = Date.now();
        this.recordMap.serviceIndicatorValues.forEach(eachServiceIndicatorValue => {
            if (!eachServiceIndicatorValue.isSticky || serviceIndicatorsValueSet.has(eachServiceIndicatorValue.Id)) {
                return;
            }
            
            let newServiceIndicator = this.getNewServiceIndicator(eachServiceIndicatorValue.Id, eachServiceIndicatorValue.portalDescription, false);
            newServiceIndicator.timestampHtmlKey = timeStamp++;

            stickyServiceIndicators.push(newServiceIndicator);
        });

        this._stickyServiceIndicators = stickyServiceIndicators;
        return stickyServiceIndicators;
    }

    getInitialSearchResults(nonStickyConstituentServiceIndicators) {
        let serviceIndicatorList = [...nonStickyConstituentServiceIndicators];
        
        if (this._lightningElement.displayMode === 'view') {
            return serviceIndicatorList;
        }

        let constituentServiceIndicatorsValueSet = new Set(nonStickyConstituentServiceIndicators.map(eachServiceIndicator => eachServiceIndicator.serviceIndicatorValue));
        let timeStamp = Date.now();
        this.recordMap.serviceIndicatorValues.forEach(eachServiceIndicatorValue => {
            if (eachServiceIndicatorValue.isSticky || constituentServiceIndicatorsValueSet.has(eachServiceIndicatorValue.Id)) {
                return;
            }

            let newServiceIndicator = this.getNewServiceIndicator(eachServiceIndicatorValue.Id, eachServiceIndicatorValue.portalDescription, false);
            newServiceIndicator.timestampHtmlKey = timeStamp++;

            serviceIndicatorList.push(newServiceIndicator);
        });

        this._searchResults = serviceIndicatorList;
        return serviceIndicatorList;
    }

    setComponentViewAttributes(response, subSection) {
        this._recordMap[subSection.sectionId] = response?.recordListWithStagedChanges;
        this.setConfiguration(response);
    }

    setComponentEditAttributes(response, subSection) {
        if (!response) {
            return;
        }

        this.setRecordsForEdit(response, subSection.sectionId);
        this.setConfiguration(response);
    }

    setRecordsForEdit(response, sectionId) {
        // make a copy so the map can be edited
        let recordListClone = [];
        let timestamp = Date.now();
        for (let eachRecord of response.recordListWithStagedChanges) {
            recordListClone.push({
                                    ...eachRecord,
                                    timestampHtmlKey: ++timestamp,  // key name is unlikely to collide with fields, distinct values needed for HTML iteration
                                    isDelete: false,                // backend requires isDelete to be true or false
                                });
        }

        this._recordMap[sectionId] = recordListClone;
    }

    setConfiguration(response) {
        let configuration = JSON.parse(response?.configString || '{}');

        this._sectionConfiguration = {...this._sectionConfiguration, ...configuration?.sectionConfigurationMap};
        this._lightningElement.componentAttributes.sectionConfiguration = this.sectionConfiguration;
    }

    getNewServiceIndicator(serviceIndicatorValueId, portalDescription, isActiveValue) {
        return {
            Id: null,
            portalDescription: portalDescription,
            serviceIndicatorValue: serviceIndicatorValueId,
            isActive: isActiveValue,
            isDelete: false
        };
    }

    handleChange(value, fieldId, recordIndex, sectionId) {        
        if (sectionId == 'stickyServiceIndicators') {
            this._stickyServiceIndicators[recordIndex][fieldId] = value;
            this._lightningElement.componentAttributes.stickyServiceIndicators = this._stickyServiceIndicators;

            // modify maps to keep track of data
            let stickyServiceIndicatorValueId = this._stickyServiceIndicators[recordIndex].serviceIndicatorValue;
            this._modifiedServiceIndicatorsMap[stickyServiceIndicatorValueId] = this._stickyServiceIndicators[recordIndex];
            delete this._originalAvailableServiceIndicatorsMap[stickyServiceIndicatorValueId];
            return;
        }

        // need to calculate index for pagination
        recordIndex = (this._lightningElement._currentPage - 1) * this._lightningElement._itemsPerPage + recordIndex;

        this._searchResults[recordIndex][fieldId] = value;
        this._lightningElement.componentAttributes.searchResults = [...this._searchResults];

        // modify maps to keep track of data
        let serviceIndicatorValueId = this._searchResults[recordIndex].serviceIndicatorValue;
        this._modifiedServiceIndicatorsMap[serviceIndicatorValueId] = this._searchResults[recordIndex];
        this._constituentsNonStickyServiceIndicatorsMap[serviceIndicatorValueId] = this._searchResults[recordIndex];

        // Need to delete from constituent map so when we reset it does not show extra values
        if (!this._constituentsNonStickyServiceIndicatorsMap[serviceIndicatorValueId].Id && !value) {
            delete this._constituentsNonStickyServiceIndicatorsMap[serviceIndicatorValueId];
            this._originalAvailableServiceIndicatorsMap[serviceIndicatorValueId] = this._searchResults[recordIndex];
        } else {
            delete this._originalAvailableServiceIndicatorsMap[serviceIndicatorValueId];
        }
    }

    handleSearchInput(event) {
        this._searchInput = event.currentTarget.value;
        this._lightningElement.componentAttributes.searchInput = this._searchInput;
    }

    handleSearchForServiceIndicators() {
        this._lightningElement._isShowSpinner = true;
        if (this._searchInput?.length < 2) {
            this._lightningElement.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: 'Please enter more than one character when searching for contact preferences.',
                variant: 'error',
                mode: 'sticky'
            }));

            this._lightningElement._isShowSpinner = false;
            return;
        }

        let params = {
            searchText: this._searchInput,
            pageName: this.pageName,
            mainSectionName: this.mainSectionName,
            subSectionName: 'Service Indicator Values',
            sectionId: 'serviceIndicatorValues'
        }

        callApexFunction(this._lightningElement, searchServiceIndicators, params, (response) => {
            this._searchResults = this.getFilteredSearchResultList(response);
            this._lightningElement._currentPage = 1;
            this._lightningElement.componentAttributes.searchResults = this._searchResults;
        }, () => {}).finally(() => {
            this._lightningElement._isShowSpinner = false;
        });
    }

    handleReset(event) {
        this._lightningElement._isShowSpinner = true;
        let unsortedOriginalAvailableServiceIndicatorsMap = [...Object.values(this._originalAvailableServiceIndicatorsMap)];
        unsortedOriginalAvailableServiceIndicatorsMap.sort((a, b) => a.portalDescription.localeCompare(b.portalDescription));

        let resultList = [...Object.values(this._constituentsNonStickyServiceIndicatorsMap), ...unsortedOriginalAvailableServiceIndicatorsMap];
        let timeStamp = Date.now();
        resultList.forEach(eachResult => {
            eachResult.timestampHtmlKey = timeStamp++;
        });

        this._searchInput = '';
        this._searchResults = resultList;
        this._lightningElement.componentAttributes.searchResults = this._searchResults;
        this._lightningElement.componentAttributes.searchInput = this._searchInput;
        this._lightningElement._currentPage = 1;
        this._lightningElement._isShowSpinner = false;
    }

    handlePageChange(searchResultsToDisplay, pageNumber) {
        this._lightningElement._currentPage = pageNumber;
        this._lightningElement.componentAttributes.searchResultsToDisplay = searchResultsToDisplay;
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

            const invalidFieldLabel = eachField.label;
            if (invalidFieldLabel) {
                invalidFieldList.push(invalidFieldLabel);
            }
        }

        return invalidFieldList;
    }

    getUpdatedRecordsMap() {
        let returnMap = {};
        returnMap[this._lightningElement.sectionId] = this.getFilteredServiceIndicatorList();
        return returnMap;
    }

    getFilteredSearchResultList(searchResults) {
        let resultList = this.getFilteredConstituentNonStickyServiceIndicatorsFromSearchResults(searchResults);

        if (!searchResults) {
            return resultList;
        }

        let constituentsNonStickyServiceIndicatorIdSet = new Set(resultList.map(eachServiceIndicator => eachServiceIndicator.serviceIndicatorValue));

        searchResults.forEach(eachSearchResult => {
            if (eachSearchResult.isSticky || constituentsNonStickyServiceIndicatorIdSet.has(eachSearchResult.Id)) {
                return;
            }

            let newServiceIndicator = this.getNewServiceIndicator(eachSearchResult.Id, eachSearchResult.portalDescription, false);
            resultList.push(newServiceIndicator);
        });

        let timeStamp = Date.now();
        resultList.forEach(eachServiceIndicator => {
            eachServiceIndicator.timestampHtmlKey = timeStamp++;
        });

        return resultList;
    }

    getFilteredConstituentNonStickyServiceIndicatorsFromSearchResults(searchResults) {
        let returnList = [];

        if (!searchResults) {
            return returnList;
        }

        let searchResultIdSet = new Set(searchResults.map(eachSearchResult => eachSearchResult.Id));

        returnList = Object.values(this._constituentsNonStickyServiceIndicatorsMap).filter(eachServiceIndicator => {
            return searchResultIdSet.has(eachServiceIndicator.serviceIndicatorValue);
        });

        let timeStamp = Date.now();
        returnList.forEach(eachServiceIndicator => {
            eachServiceIndicator.timestampHtmlKey = timeStamp++;
        });

        return returnList;
    }

    getFilteredServiceIndicatorList() {
        let returnList = [];
        if (Object.keys(this._modifiedServiceIndicatorsMap).length === 0) {
            return returnList;
        }

        Object.values(this._modifiedServiceIndicatorsMap).forEach(eachServiceIndicator => {
            if (eachServiceIndicator.isActive === false && !eachServiceIndicator.Id) {
                return;
            }

            returnList.push(eachServiceIndicator);
        });

        return returnList;
    }
}