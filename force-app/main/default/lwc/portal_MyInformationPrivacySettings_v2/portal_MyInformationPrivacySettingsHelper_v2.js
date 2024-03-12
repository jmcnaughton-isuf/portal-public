import { callApexFunction } from 'c/portal_util_ApexCallout';
import getViewInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo';
import getEditInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo';

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

    buildSubSectionNames(subSectionName) {
        this.result._subSectionNames = subSectionName;
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
            this._lightningElement._isShowSpinner = false;
        });
    }

    getCalloutPromiseList() {
        let calloutPromiseList = [];

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

    setComponentViewAttributes(response, subSection) {
        let recordListClone = [];
        let timestamp = Date.now();
        for (let eachRecord of response?.recordListWithStagedChanges) {
            recordListClone.push({
                                    ...eachRecord,
                                    timestampHtmlKey: ++timestamp  // key name is unlikely to collide with fields, distinct values needed for HTML iteration
                                });
        }
        this._recordMap[subSection.sectionId] = recordListClone;

        this._sectionConfiguration = {...this._sectionConfiguration, ...JSON.parse(response?.configString)?.sectionConfigurationMap};
        this._lightningElement.componentAttributes.recordMap = this.recordMap;
        this._lightningElement.componentAttributes.sectionConfiguration = this.sectionConfiguration;
    }

    setComponentEditAttributes(response, subSection) {
        if (!response) {
            return;
        }

        // make a copy so the map can be edited
        let recordListClone = [];
        let timestamp = Date.now();
        for (let eachRecord of response.recordListWithStagedChanges) {
            recordListClone.push({
                                    ...eachRecord,
                                    timestampHtmlKey: ++timestamp,  // key name is unlikely to collide with fields, distinct values needed for HTML iteration
                                    isDelete: false                 // backend requires isDelete to be true or false
                                });
        }
        this._recordMap[subSection.sectionId] = recordListClone;

        // remove directorySetting fields that get modified in Contact Personal Info
        if (subSection.sectionId === 'directorySetting' && this._recordMap.directorySetting?.[0]) {
            delete this._recordMap.directorySetting[0].isShowMaidenName;
            delete this._recordMap.directorySetting[0].isShowNickname;
            delete this._recordMap.directorySetting[0].isShowGender;
            delete this._recordMap.directorySetting[0].isShowPronouns;
        }

        this._sectionConfiguration = {...this._sectionConfiguration, ...JSON.parse(response.configString)?.sectionConfigurationMap};
        this._lightningElement.componentAttributes.recordMap = this.recordMap;
        this._lightningElement.componentAttributes.sectionConfiguration = this.sectionConfiguration;
    }

    get newDirectorySetting() {
        return {
            receivingMessages: true,
            studentCanSee: true,
            timestampHtmlKey: Date.now(),
            isDelete: false
        };
    }

    get directorySetting() {
        if (!this._sectionConfiguration.directorySetting) {
            return [];
        }

        if (!this._recordMap.directorySetting || this._recordMap.directorySetting.length === 0) {
            return [this.newDirectorySetting];
        }

        return this._recordMap.directorySetting;
    }

    handleChange(value, fieldId, recordIndex, sectionId) {
        if (sectionId === 'directorySetting' && (!this._recordMap.directorySetting || this._recordMap.directorySetting.length === 0)) {
            this._recordMap.directorySetting = [this.newDirectorySetting];   
        }

        this._recordMap[sectionId][recordIndex][fieldId] = (fieldId === 'isDirectoryOptOut') ? !value : value;
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

            const invalidFieldLabel = eachField.label || this.sectionConfiguration[eachField.sectionId]?.fieldConfigurationMap?.[eachField.fieldId]?.label;
            if (invalidFieldLabel) {
                invalidFieldList.push(invalidFieldLabel);
            }
        }

        return invalidFieldList;
    }

    getUpdatedRecordsMap() {
        return this._recordMap;
    }
}