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
            callApexFunction(this._lightningElement, getEditInfo, params, (response) => {
                this.setComponentEditAttributes(response);
            }, () => {}).finally(() => {
                this._lightningElement._isShowSpinner = false;
            });
        }
    }
    
    setComponentViewAttributes(response) {
        this.recordList = response?.recordListWithStagedChanges;
        this.sectionConfiguration = JSON.parse(response?.configString)?.sectionConfigurationMap?.[this._lightningElement.sectionId];
    }

    setComponentEditAttributes(response) {
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

        // make a copy so the map can be edited
        let recordListClone = [];
        let timestamp = Date.now();
        for (let eachRecord of response?.recordListWithStagedChanges) {
            recordListClone.push({
                                    ...eachRecord,
                                    timestampHtmlKey: ++timestamp,  // key name is unlikely to collide with fields, distinct values needed for HTML iteration
                                    isDelete: false,                // backend requires isDelete to be true or false
                                    hasSelfReportChange: selfReportOriginalIdSet.has(eachRecord.Id)
                                });
        }

        this.recordList = recordListClone;

        let configuration = JSON.parse(response?.configString || '{}');
        this.sectionConfiguration = configuration?.sectionConfigurationMap?.[this._lightningElement.sectionId];
        this.selfReportSectionConfiguration = configuration?.selfReportSectionConfigurationMap?.[this._lightningElement.sectionId];

        this._lightningElement._requestUpdateRichText = configuration?.requestUpdateRichText;
    }	

    get newSocialMedia() {
        return {
            Id: null,
            socialMediaPlatform: "",
            socialMediaUrl: "",
            isDisplayOnPortal: true,
            socialMediaShowOnDirectory: false,
            status: "Active",
            timestampHtmlKey: Date.now(),
            isDelete: false
        };
    }

    handleAddSocialMedia() {
        this._recordList.push(this.newSocialMedia);
        this._lightningElement.componentAttributes.recordList = [...this._recordList];
    }

    handleDeleteSocialMedia(recordIndex) {
        let record = this._recordList[recordIndex];
        if (record.Id) {
            record.isDelete = true;
            record.timestampHtmlKey = Date.now();
        } else {
            this._recordList.splice(recordIndex, 1);
        }

        this._lightningElement.componentAttributes.recordList = [...this._recordList];
    }

    handleChange(value, fieldId, recordIndex) {
        this._recordList[recordIndex][fieldId] = value;
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
}