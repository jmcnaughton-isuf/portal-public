import { callApexFunction } from 'c/portal_util_ApexCallout';
import getViewInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getViewInfo';
import getEditInfo from '@salesforce/apex/PORTAL_LWC_MyInformationV2Controller.SERVER_getEditInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
    
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
    // actual self report record
    _selfReportRecordMap = {};
    // map of fieldId to boolean indicating whether the self report record changed the field
    _selfReportChangeMap = {};

    // top level keys are sectionIds that have last name validity logic
    // each element in the list is constraint record for that section 
    //      any constraint field that is non-blank in the actual record makes the whole record non-blank, a true field is required for a non-blank record
    _sectionConstraints = {
        name: [
            {firstName: false, middleName: false, lastName: true, prefix: false, suffix: false, businessTitle: false}
        ],
        maidenName: [
            {maidenFirstName: false, maidenMiddleName: false, maidenLastName: true},
        ],
        nickname: [
            {nicknameFirstName: false, nicknameLastName: true}
        ],
        directoryName: [
            {directoryFirstName: false, directoryLastName: true}
        ]
    };

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

    get selfReportChangeMap() {
        return this._selfReportChangeMap;
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
                mainSectionName: subSection.mainSectionName ? subSection.mainSectionName : this.mainSectionName,
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
        this._recordMap[subSection.sectionId] = this.getInitialRecordListIfEmpty(response?.recordListWithStagedChanges, subSection.sectionId);
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
        this._selfReportRecordMap[sectionId] = response.selfReportRecordList;
        this._lightningElement.componentAttributes.selfReportRecordMap = this.selfReportRecordMap;
    }

    setRecordsForEdit(response, sectionId) {
        // make a copy so the map can be edited
        let recordListClone = [];
        let selfReportChangeList = [];
        const recordListWithStagedChanges = this.getInitialRecordListIfEmpty(response.recordListWithStagedChanges, sectionId);

        for (let eachRecord of recordListWithStagedChanges) {
            let recordClone = {};
            let selfReportChanges = {};
            let selfReportRecord = this.selfReportRecordMap[sectionId]?.[0] || {};

            for (let eachFieldId of Object.keys(eachRecord).concat(Object.keys(selfReportRecord))) {
                recordClone[eachFieldId] = eachRecord[eachFieldId];
                selfReportChanges[eachFieldId] = this.isFieldChanged(eachRecord, selfReportRecord, eachFieldId);
            }

            // backend requires isDelete to be true or false
            recordClone.isDelete = false;

            recordListClone.push(recordClone);
            selfReportChangeList.push(selfReportChanges);
        }

        this._recordMap[sectionId] = recordListClone;
        this._selfReportChangeMap[sectionId] = selfReportChangeList;

        // remove directorySetting fields that get modified in Privacy Settings
        if (sectionId === 'directorySetting' && this._recordMap.directorySetting?.[0]) {
            delete this._recordMap.directorySetting[0].receivingMessages;
            delete this._recordMap.directorySetting[0].studentCanSee;
        }

        // birthdate/birthMonth/birthYear from an interim is in the wrong format
        if (sectionId === 'additionalDetails' && this._recordMap.additionalDetails?.[0].birthdate?.includes('-')) {
            this.handleBirthdateChange(this._recordMap.additionalDetails[0].birthdate, undefined, 0, sectionId);
        }

        this._lightningElement.componentAttributes.recordMap = this.recordMap;
        this._lightningElement.componentAttributes.selfReportChangeMap = this.selfReportChangeMap;
    }

    getInitialRecordListIfEmpty(recordListWithStagedChanges, sectionId) {
        // handleChange handles the case of an empty directory setting list 
        if (sectionId === 'directorySetting') {
            return recordListWithStagedChanges;
        }

        if (sectionId === 'maidenName') {
            return recordListWithStagedChanges?.length > 0 ? recordListWithStagedChanges : [{maidenType: 'Maiden'}];
        }

        if (sectionId === 'nickname') {
            return recordListWithStagedChanges?.length > 0 ? recordListWithStagedChanges : [{nicknameType: 'Nickname'}];
        }

        if (sectionId === 'directoryName') {
            return recordListWithStagedChanges?.length > 0 ? recordListWithStagedChanges : [{directoryType: 'Directory'}];
        }

        return recordListWithStagedChanges?.length > 0 ? recordListWithStagedChanges : [{}];
    } 

    setConfiguration(response) {
        let configuration = JSON.parse(response?.configString || '{}');

        this._lightningElement._requestUpdateRichText = configuration?.requestUpdateRichText;
        this._sectionConfiguration = {...this._sectionConfiguration, ...configuration?.sectionConfigurationMap};
        this._selfReportSectionConfiguration = {...this._selfReportSectionConfiguration, ...configuration?.selfReportSectionConfigurationMap};

        this._lightningElement.componentAttributes.sectionConfiguration = this.sectionConfiguration;
    }

    get newDirectorySetting() {
        return {
            isShowMaidenName: false,
            isShowNickname: false,
            isShowGender: false,
            isShowPronouns: false,
            Id: null,
            isDelete: false
        };
    }

    get isShowMaidenNameToggleValue() {
        return this.getDirectorySettingValue('isShowMaidenName');
    }

    get isShowNicknameToggleValue() {
        return this.getDirectorySettingValue('isShowNickname');
    }

    get isShowGenderToggleValue() {
        return this.getDirectorySettingValue('isShowGender');
    }

    get isShowPronounsToggleValue() {
        return this.getDirectorySettingValue('isShowPronouns');
    }

    getDirectorySettingValue(fieldId) {
        if (!this._recordMap.directorySetting || this._recordMap.directorySetting.length === 0) {
            return false;
        }

        return this._recordMap.directorySetting[0][fieldId];
    }

    handleChange(value, fieldId, recordIndex, sectionId) {
        if (fieldId === 'birthdate') {
            this.handleBirthdateChange(value, fieldId, recordIndex, sectionId);
            return;
        }

        if (fieldId.includes('directorySetting')) {
            if (!this._recordMap.directorySetting || this._recordMap.directorySetting.length === 0) {
                this._recordMap.directorySetting = [this.newDirectorySetting];   
            }

            sectionId = 'directorySetting';
            fieldId = fieldId.split('.')[1];
        }

        this._recordMap[sectionId][recordIndex][fieldId] = value;
    }

    handleToggleChange(event) {
        this.handleChange(event.currentTarget.checked, event.currentTarget.dataset.fieldId, 0, 'directorySetting');
    }

    handleBirthdateChange(value, fieldId, recordIndex, sectionId) {
        if (!value) {
            this._recordMap[sectionId][recordIndex].birthdate = undefined;
            this._recordMap[sectionId][recordIndex].birthMonth = undefined;
            this._recordMap[sectionId][recordIndex].birthYear = undefined;
            return;
        } 

        let dateList = value.split('-');
        this._recordMap[sectionId][recordIndex].birthdate = dateList[2];
        this._recordMap[sectionId][recordIndex].birthMonth = dateList[1];
        this._recordMap[sectionId][recordIndex].birthYear = dateList[0];
    }

    getBirthdate(recordMap) {
        let date = recordMap?.birthdate;

        // if birthdate comes from interim, it will be YYYY-MM-DD 
        // if birthdate comes from contact, it will be in 3 separate fields
        if (date?.includes('-')) {
            return date;
        }

        let month = recordMap?.birthMonth;
        let year = recordMap?.birthYear;

        if (year && month && date) {
            return year + '-' + month + '-' + date;
        }

        return '';
    }

    isFieldChanged(originalRecord, selfReportRecord, fieldId) {
        if (fieldId !== 'birthdate') {
            return originalRecord?.[fieldId] !== selfReportRecord?.[fieldId] && selfReportRecord?.[fieldId];
        }

        // birthdate gets special treatment bc its value is spread across 3 fields (but not always) and bc of the isBirthdateDeleted field
        return selfReportRecord?.isBirthdateDeleted || (this.getBirthdate(originalRecord) !== this.getBirthdate(selfReportRecord) && this.getBirthdate(selfReportRecord));
    }

    handleSelfReport(event) {
        let fieldId = event.currentTarget.dataset.fieldId;
        let sectionId = event.currentTarget.dataset.sectionId;
        let subSectionName = undefined;
        for (let subSection of this.subSectionNames) {
            if (subSection.sectionId === sectionId) {
                subSectionName = subSection.sectionName; 
                break;
            }
        }

        this._lightningElement._selfReportFieldId = fieldId;
        this._lightningElement._selfReportConfiguration = this.selfReportSectionConfiguration[sectionId].fieldConfigurationMap[fieldId];

        this._lightningElement._selfReportSaveParams = {
            pageName: this.selfReportPageName,
            mainSectionName: this.mainSectionName,
            subSectionName: subSectionName,
            sectionId: sectionId
        };
        
        let originalRecordIndex = 0;
        this._lightningElement._selfReportOriginalRecordIndex = originalRecordIndex;

        let currentSelfReportRecord = this.selfReportRecordMap[sectionId]?.[0];
        let originalRecord = this.recordMap[sectionId]?.[originalRecordIndex];

        // if the current self report record is missing a value, use the original record value; birthdate is special as always
        this._lightningElement._selfReportRecord = {...originalRecord, Id: undefined, ...currentSelfReportRecord};
        this._lightningElement._selfReportRecord.birthdate = currentSelfReportRecord?.isBirthdateDeleted ? '' : (this.getBirthdate(currentSelfReportRecord) || this.getBirthdate(originalRecord));

        this._lightningElement._isDisplaySelfReportModal = true; 
    }

    handleSelfReportClose(newSelfReportRecord) {
        this.setNewSelfReportRecord(newSelfReportRecord);

        this._lightningElement._selfReportFieldId = undefined;
        this._lightningElement._selfReportConfiguration = undefined;
        this._lightningElement._selfReportSaveParams = undefined;
        this._lightningElement._selfReportRecord = undefined;
        this._lightningElement._selfReportOriginalRecordIndex = undefined;

        this._lightningElement._isDisplaySelfReportModal = false; 
    }

    setNewSelfReportRecord(newSelfReportRecord) {
        if (!newSelfReportRecord) {
            return;
        }

        let fieldId = this._lightningElement._selfReportFieldId;
        let sectionId = this._lightningElement._selfReportSaveParams.sectionId;

        let originalRecordIndex = this._lightningElement._selfReportOriginalRecordIndex;
        let originalRecord = this.recordMap[sectionId][originalRecordIndex];
        this._lightningElement.componentAttributes.selfReportChangeMap[sectionId][originalRecordIndex][fieldId] = this.isFieldChanged(originalRecord, newSelfReportRecord, fieldId);

        let previousSelfReportRecord = this.selfReportRecordMap[sectionId]?.[0];
        this.selfReportRecordMap[sectionId] = [{...previousSelfReportRecord, ...newSelfReportRecord}];
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

        // if a name record has a blank last name, then whole record needs to be blank
        let missingFields = '';
        for (let [eachSectionId, eachConstraintList] of Object.entries(this._sectionConstraints)) {
            if (!this._recordMap[eachSectionId]) {
                continue;
            }

            for (let eachRecord of this._recordMap[eachSectionId]) {
                let status = this.getConstraintStatus(eachRecord, eachConstraintList, eachSectionId);
                if (status.startsWith('invalid')) {
                    missingFields += (missingFields ? ', ' : '') + status.replace('invalid ', '');
                }
            }
        }

        if (!missingFields) {
            return true;
        }

        this._lightningElement.dispatchEvent(new ShowToastEvent({
            title: 'Error.',
            message: 'Please fill in the following values: ' + missingFields + '.',
            variant: 'error',
            mode: 'sticky'
        }));
        return false;
    }

    // returns 'blank', 'valid', or 'invalid <field, names, list>' for a single record
    getConstraintStatus(record, constraintList, sectionId) {
        let isAllBlank = true;
        let missingFieldList = [];
        for (let eachConstraint of constraintList) {
            let isValid = true;
            let isBlank = true;
            let missingFieldLabel = '';

            for (let [eachField, isRequired] of Object.entries(eachConstraint)) {
                isBlank &&= !record[eachField];
                isValid &&= (!isRequired || record[eachField]);
                if (isRequired && !record[eachField]) {
                    missingFieldLabel = this.sectionConfiguration[sectionId].fieldConfigurationMap[eachField].label;
                }
            }

            if (!isBlank && !isValid) {
                missingFieldList.push(missingFieldLabel);
            }

            isAllBlank &&= isBlank;
        }

        if (missingFieldList.length > 0) {
            return 'invalid ' + missingFieldList.join(', ');
        }

        return isAllBlank ? 'blank' : 'valid';
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

        for (let [eachSectionId, eachConstraintList] of Object.entries(this._sectionConstraints)) {
            if (!this._recordMap[eachSectionId]) {
                continue;
            }

            for (let eachRecord of this._recordMap[eachSectionId]) {
                let status = this.getConstraintStatus(eachRecord, eachConstraintList, eachSectionId);
                if (status.startsWith('invalid')) {
                    invalidFieldList.push(...status.replace('invalid ', '').split(', '));
                }
            }
        }

        return invalidFieldList;
    }

    getUpdatedRecordsMap() {
        let recordMapClone = {...this._recordMap};
        for (let [eachSectionId, eachConstraintList] of Object.entries(this._sectionConstraints)) {
            if (!this._recordMap[eachSectionId]) {
                continue;
            }

            let sectionValidRecordList = [];
            for (let eachRecord of this._recordMap[eachSectionId]) {
                if (this.getConstraintStatus(eachRecord, eachConstraintList, eachSectionId) === 'valid') {
                    sectionValidRecordList.push(eachRecord);
                }
            }
            recordMapClone[eachSectionId] = sectionValidRecordList;
        }

        return recordMapClone;
    }
}