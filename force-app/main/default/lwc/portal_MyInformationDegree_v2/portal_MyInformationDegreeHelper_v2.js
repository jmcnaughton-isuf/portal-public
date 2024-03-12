import getViewInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo';
import getEditInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo';
// FUTURE TODO decide whether/how to make a v2 getAcademicOrg
import getAcademicOrgName from '@salesforce/apex/PORTAL_MyInformationController.SERVER_getAcademicOrgName';
import { callApexFunction } from 'c/portal_util_ApexCallout';

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
    _subSectionNames = [];
    _selfReportPageName = '';

    _recordMap = {};
    _sectionConfiguration = {};
    _selfReportSectionConfiguration = {};
    _selfReportRecordMap = {};

    get pageName() {
        return this._pageName;
    }

    get mainSectionName() {
        return this._mainSectionName;
    }

    get subSectionNames() {
        return this._subSectionNames;
    }

    get selfReportPageName() {
        return this._selfReportPageName;
    }

    get recordMap() {
        return this._recordMap;
    }

    get selfReportRecordMap() {
        return this._selfReportRecordMap;
    }

    get sectionConfiguration() {
        return this._sectionConfiguration;
    }

    get selfReportSectionConfiguration() {
        return this._selfReportSectionConfiguration;
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
                params.selfReportPageName = this.selfReportPageName;
                calloutPromiseList.push(callApexFunction(this._lightningElement, getEditInfo, params, (response) => {
                    this.setComponentEditAttributes(response, subSection);
                }, () => {}));
            }
        }

        return calloutPromiseList;
    }	

    setComponentViewAttributes(response, subSection) {
        this._recordMap[subSection.sectionId] = response?.recordListWithStagedChanges;
        this._lightningElement.componentAttributes.recordMap = this.recordMap;
        this.setConfiguration(response);
    }

    setComponentEditAttributes(response, subSection) {
        if (!response) {
            return;
        }

        // self report records needs to be set before the rest of the records 
        this.setSelfReportRecords(response, subSection.sectionId);
        this.setRecordsForEdit(response, subSection.sectionId);
        this.setConfiguration(response);
    }

    setSelfReportRecords(response, sectionId) {
        this._selfReportRecordMap[sectionId] = [];
        // copy list so self update callback can replace records in the list
        if (response?.selfReportRecordList) {
            this._selfReportRecordMap[sectionId] = [...response.selfReportRecordList];
        }
    }

    setRecordsForEdit(response, sectionId) {
        // make a copy so the map can be edited
        let recordListClone = [];
        let timestamp = Date.now();

        // find set of record IDs that have been changed before
        let selfReportOriginalIdSet = new Set();
        for (let eachSelfReportRecord of this._selfReportRecordMap[sectionId]) {
            selfReportOriginalIdSet.add(eachSelfReportRecord.masterDegree);
        }
        
        for (let eachRecord of response.recordListWithStagedChanges) {
            recordListClone.push({
                                    ...eachRecord,
                                    timestampHtmlKey: ++timestamp,  // key name is unlikely to collide with fields, distinct values needed for HTML iteration
                                    isDelete: false,                // backend requires isDelete to be true or false
                                    hasSelfReportChange: selfReportOriginalIdSet.has(eachRecord.Id)
                                });
        }

        this._recordMap[sectionId] = recordListClone;
        this._lightningElement.componentAttributes.recordMap = this.recordMap;
    }

    setConfiguration(response) {
        let configuration = JSON.parse(response?.configString || '{}');

        this._lightningElement._requestUpdateRichText = configuration?.requestUpdateRichText;
        this._sectionConfiguration = {...this._sectionConfiguration, ...configuration?.sectionConfigurationMap};
        this._selfReportSectionConfiguration = {...this._selfReportSectionConfiguration, ...configuration?.selfReportSectionConfigurationMap};

        this._lightningElement.componentAttributes.sectionConfiguration = this.sectionConfiguration;
    }

    get newSchoolDegree() {
        return {
            schoolDegreeDegree: "",
            schoolDegreeYear: "",
            Id: null,
            isShowOnDirectory: false,
            status: "Active",
            postCode: null,
            minorCode: null,
            isShowMajor: false,
            isShowDegree: false,
            isShowYear: false,
            timestampHtmlKey: Date.now(),
            isDelete: false
        };
    }

    get newNonSchoolDegree() {
        return {
            nonSchoolDegreeInstitution: "", 
            nonSchoolDegreeMajor: "",
            nonSchoolDegreeDegree : "", 
            nonSchoolDegreeYear: "", 
            Id: null, 
            isShowOnDirectory: false,
            status: "Active",
            isShowMajor: false, 
            isShowInstitution: false, 
            isShowDegree: false, 
            isShowYear: false, 
            timestampHtmlKey: Date.now(),
            isDelete: false
        };
    }

    handleAddDegree(sectionId) {
        let newDegree = sectionId === 'schoolDegrees' ? this.newSchoolDegree : this.newNonSchoolDegree;
        this._recordMap[sectionId].push(newDegree);
        this._lightningElement.componentAttributes.recordMap = {...this._recordMap};
    }

    handleDeleteDegree(sectionId, recordIndex) {
        let record = this._recordMap[sectionId][recordIndex];
        if (record.Id) {
            record.isDelete = true;
            record.timestampHtmlKey = Date.now();
        } else {
            this._recordMap[sectionId].splice(recordIndex, 1);
        }

        this._lightningElement.componentAttributes.recordMap = {...this._recordMap};
    }

    handleChange(value, fieldId, recordIndex, sectionId) {
        this._recordMap[sectionId][recordIndex][fieldId] = value;
    }

    handleLookupSelection(option, fieldId, recordIndex, sectionId, lookupFieldId) {
        this._recordMap[sectionId][recordIndex][lookupFieldId] = option.value;

        let objectName = undefined;
        if (fieldId === 'schoolDegreeMajor') {
            objectName = 'postCode';
        } else if (fieldId === 'schoolDegreeMinor') {
            objectName = 'minorCode';
        }

        // do a lookup + autofill for academic org (if not already populated) after major or minor is selected
        if (sectionId !== 'schoolDegrees' || !objectName || this._recordMap[sectionId][recordIndex].schoolDegreeAcademicOrg) {
            return;
        }

        callApexFunction(this._lightningElement, getAcademicOrgName, {objectName: objectName, Id: option.value}, (schoolName) => {
            if (!schoolName) {
                return;
            }

            this.handleChange(schoolName,'schoolDegreeAcademicOrg', recordIndex, sectionId);
            this._recordMap[sectionId][recordIndex].timestampHtmlKey = Date.now();
            this._lightningElement.componentAttributes.recordMap = {...this._recordMap};
        }, () => {});
    }

    handleSelfReport(event) {
        let sectionId = event.currentTarget.dataset.sectionId;
        let recordIndex = event.currentTarget.dataset.index;

        let subSectionName = undefined;
        for (let subSection of this.subSectionNames) {
            if (subSection.sectionId === sectionId) {
                subSectionName = subSection.sectionName; 
                break;
            }
        }

        let originalRecord = this.recordMap[sectionId][recordIndex];
        let currentSelfReportRecord = undefined;

        this._lightningElement._selfReportOriginalRecordIndex = recordIndex;
        let selfReportRecordIndex = 0;
        for (let eachSelfReportRecord of this.selfReportRecordMap[sectionId]) {
            if (eachSelfReportRecord.masterDegree === originalRecord.Id) {
                currentSelfReportRecord = eachSelfReportRecord;
                this._lightningElement._selfReportRecordIndex = selfReportRecordIndex;
                break;
            }
            ++selfReportRecordIndex;
        }

        this._lightningElement._selfReportRecord = currentSelfReportRecord || {...originalRecord, Id: undefined};
        this._lightningElement._selfReportModalType = sectionId;
        
        // the two Degree Page Section Settings are the only ones where the frontend section IDs differ from the non-self report frontend section IDs
        // this is kept in v2 for v1 backwards compatibility
        this._lightningElement._selfReportConfiguration = this.selfReportSectionConfiguration[sectionId + 'SelfReport'].fieldConfigurationMap;

        this._lightningElement._selfReportSaveParams = {
            originalRecordId: originalRecord.Id,
            pageName: this.selfReportPageName,
            mainSectionName: this.mainSectionName,
            subSectionName: subSectionName,
            sectionId: sectionId + 'SelfReport'
        };

        this._lightningElement._isDisplaySelfReportModal = true; 
    }

    handleSelfReportClose(newSelfReportRecord) {
        this.setNewSelfReportRecord(newSelfReportRecord);

        this._lightningElement._selfReportModalType = undefined;
        this._lightningElement._selfReportRecord = undefined;
        this._lightningElement._selfReportConfiguration = undefined;
        this._lightningElement._selfReportSaveParams = undefined;
        this._lightningElement._selfReportOriginalRecordIndex = undefined;
        this._lightningElement._selfReportRecordIndex = undefined;

        this._lightningElement._isDisplaySelfReportModal = false; 
    }

    setNewSelfReportRecord(newSelfReportRecord) {
        if (!newSelfReportRecord) {
            return;
        }

        let sectionId = this._lightningElement._selfReportSaveParams.sectionId.replace('SelfReport', '');

        this._lightningElement.componentAttributes.recordMap[sectionId][this._lightningElement._selfReportOriginalRecordIndex].hasSelfReportChange = true

        let selfReportIndex = this._lightningElement._selfReportRecordIndex;
        if (selfReportIndex === undefined) {
            this.selfReportRecordMap[sectionId].push(newSelfReportRecord);
            return;
        }

        this.selfReportRecordMap[sectionId][selfReportIndex] = newSelfReportRecord;
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