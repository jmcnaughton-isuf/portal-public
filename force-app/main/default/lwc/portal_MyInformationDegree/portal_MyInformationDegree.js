import { LightningElement, api, track } from 'lwc';
import viewTemplate from './portal_MyInformationDegreeView.html';
import editTemplate from './portal_MyInformationDegreeEdit.html';
import getAcademicOrgName from '@salesforce/apex/PORTAL_MyInformationController.SERVER_getAcademicOrgName';

export default class Portal_MyInformationDegree extends LightningElement {
    @api informationMap;
    @api displayView;
    @api deleteIcon;
    @track _informationMap;
    @track idToSelfReportDegreeMap = {};
    @track _interimDegrees = [];
    @track _interimSchoolDegrees = [];
    _openModal;
    _modalUpdateType;
    _modalRecord;
    _modalRecordTypeName;
    _modalSObjectName;
    _modalSection;
    _modalIndex;
    _degreeIndex = 0;
    _schoolDegreeIndex = 0;
    _modalMasterDegreeId = '';
    _recordToUpdateId = '';
    _recordKey = 0;  // resetting this value will rerender array

    @api
    checkInputValidity() {
        let inputs = this.template.querySelectorAll('c-portal_-My-Information-Edit-Field');
        let validity = true;

        if (inputs) {
            for (const input of inputs) {
                if (input.checkValidity() === false) {
                    if (validity === true) {
                        input.reportValidity();
                        validity = false;
                    }
                }
            }
        }

        return validity;
    }

    connectedCallback() {
        if (this.informationMap) {
            this._informationMap = Object.assign({}, JSON.parse(JSON.stringify(this.informationMap)));
            if (this.informationMap.interimRecords && this.informationMap.interimRecords.nonSchoolDegrees && this.informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees) {
                this._interimDegrees = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees))];
            }

            if (this.informationMap.interimRecords && this.informationMap.interimRecords.schoolDegrees && this.informationMap.interimRecords.schoolDegrees.schoolDegrees) {
                this._interimSchoolDegrees = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.schoolDegrees.schoolDegrees))];
            }
        }

        if (this.informationMap.selfReports && this.informationMap.selfReports.schoolDegreesSelfReport && this.informationMap.selfReports.schoolDegreesSelfReport.schoolDegreesSelfReport
            && this.informationMap.selfReports.schoolDegreesSelfReport.schoolDegreesSelfReport.length > 0 && this._informationMap.records.Degrees.School_Degree_Information.length > 0) {

            for (let record of this._informationMap.records.Degrees.School_Degree_Information) {
                for (let report of this.informationMap.selfReports.schoolDegreesSelfReport.schoolDegreesSelfReport) {
                    if (record.Id == report.masterDegree) {
                        record.hasMaster = true;
                        break;
                    }
                }
                record.key = this._recordKey++;
            }

            for (let record of this._interimSchoolDegrees) {
                for (let report of this.informationMap.selfReports.schoolDegreesSelfReport.schoolDegreesSelfReport) {
                    if (record.Id == report.masterDegree) {
                        record.hasMaster = true;
                        break;
                    }
                }
                record.key = this._recordKey++;
            }

            if (this._informationMap && this._informationMap.records && this._informationMap.records.Degrees && this._informationMap.records.Degrees.Non_School_Degree_Information) {
                for (let record of this._informationMap.records.Degrees.Non_School_Degree_Information) {
                    record['index'] = 'degree' + this._degreeIndex;
                    this._degreeIndex++;
                }
            }

            if (this._informationMap && this._informationMap.records && this._informationMap.records.Degrees && this._informationMap.records.Degrees.School_Degree_Information) {
                for (let record of this._informationMap.records.Degrees.School_Degree_Information) {
                    record['index'] = 'degree' + this._schoolDegreeIndex;
                    this._schoolDegreeIndex++;
                }
            }
        }

        if (this.informationMap.selfReports && this.informationMap.selfReports.nonSchoolDegreesSelfReport && this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport
            && this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport.length > 0 && this._informationMap.records.Degrees.Non_School_Degree_Information.length > 0) {

            for (let record of this._informationMap.records.Degrees.Non_School_Degree_Information) {
                for (let report of this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport) {
                    if (record.Id == report.masterDegree) {
                        record.hasMaster = true;
                        break;
                    }
                }
            }
        }

        if (this.informationMap.selfReports && this.informationMap.selfReports.nonSchoolDegreesSelfReport && this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport
            && this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport.length > 0 && this._informationMap.records.Degrees.Non_School_Degree_Information.length > 0) {

            for (let record of this._informationMap.records.Degrees.Non_School_Degree_Information) {
                for (let report of this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport) {
                    if (record.Id == report.masterDegree) {
                        record.hasMaster = true;
                        break;
                    }
                }
            }
        }
    }

    render() {
        return this.displayView ? viewTemplate : editTemplate;
    }

    editInformation(){
        window.location.replace(window.location.href.split(/[?#]/)[0] + '?mode=edit&tab=degree');
    }

    addDegree(event) {
        try {
            this._informationMap.records.Degrees.Non_School_Degree_Information = [...this._informationMap.records.Degrees.Non_School_Degree_Information,
                {nonSchoolDegreeInstitution: "", nonSchoolDegreeMajor: "",
                nonSchoolDegreeDegree : "", nonSchoolDegreeYear: "", Id:null, isShowOnDirectory : false,
                status: "Active",
                isShowMajor: false, isShowInstitution: false, isShowDegree: false, isShowYear: false, index:'degree'+this._degreeIndex}];
            this._degreeIndex++;
            this.addToChangeSet('Non_School_Degree_Information');
        } catch (e) {
            console.log(e);
        }
    }

    addSchoolDegree(event) {
        try {
            this._informationMap.records.Degrees.School_Degree_Information = [...this._informationMap.records.Degrees.School_Degree_Information,
                {schoolDegreeDegree : "", schoolDegreeYear: "", Id:null, isShowOnDirectory : false,
                status: "Active", postCode: null,
                minorCode: null,
                isShowMajor: false, isShowDegree: false, isShowYear: false, index:'degree'+this._schoolDegreeIndex}];
            this._schoolDegreeIndex++;
            this.addToChangeSet('School_Degree_Information');
        } catch (e) {
            console.log(e);
        }
    }

    getDisplaySettingList(fieldId) {
        let displaySettingList = [];
        let displaySetting = {};
        displaySetting['customMetadataDeveloperName']  = this.informationMap.frontEndData[fieldId].customMetadataDeveloperName;
        displaySettingList.push(displaySetting);
        return displaySettingList;
    }

    get majorDisplaySettingList() {
        return this.getDisplaySettingList('schoolDegreeMajor');
    }

    get academicOrgDisplaySettingList() {
        return this.getDisplaySettingList('schoolDegreeAcademicOrg');
    }

    get minorDisplaySettingList() {
        return this.getDisplaySettingList('schoolDegreeMinor');
    }

    get nonSchoolDegreeInstitutionDisplaySettingList() {
        return this.getDisplaySettingList('nonSchoolDegreeInstitution');
    }

    deleteDegree(event) {
        let type = event.currentTarget.getAttribute('data-type');
        let index = event.currentTarget.getAttribute('data-index');
        if (type == "interim") {
            this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees.splice(index, 1);
            this._interimDegrees = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees))]
        } else if (type == "interimSchoolDegree") {
            this._informationMap.interimRecords.schoolDegrees.schoolDegrees.splice(index, 1);
            this._interimSchoolDegrees = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.schoolDegrees.schoolDegrees))]
        } else if (type == 'schoolDegree') {
            this._informationMap.records.Degrees.School_Degree_Information.splice(index, 1);
            this.addToChangeSet('School_Degree_Information');
        } else {
            this._informationMap.records.Degrees.Non_School_Degree_Information.splice(index, 1);
            this.addToChangeSet('Non_School_Degree_Information');
        }

    }

    @api
    getEditInformation() {
        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            try {
                this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                    let fieldChanges = element.getEditInformation();

                    if (fieldChanges.fieldName) {
                        if (fieldChanges.fieldType == 'Non_School_Degree_Information') {
                            if (fieldChanges.fieldName.includes('.')) {
                                let fields = fieldChanges.fieldName.split('.');
                                this._informationMap.records.Degrees.Non_School_Degree_Information[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                            } else {
                                this._informationMap.records.Degrees.Non_School_Degree_Information[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                            }
                        } else if (fieldChanges.fieldType == 'School_Degree_Information') {
                            if (fieldChanges.fieldName.includes('.')) {
                                let fields = fieldChanges.fieldName.split('.');
                                this._informationMap.records.Degrees.School_Degree_Information[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                            } else if (!fieldChanges.lookupField) {
                                this._informationMap.records.Degrees.School_Degree_Information[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                            }
                        } else if (fieldChanges.fieldType == "interimDegree") {
                            this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                        } else if (fieldChanges.fieldType == 'interimSchoolDegree') {
                            this._informationMap.interimRecords.schoolDegrees.schoolDegrees[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                        }
                    }

                    if (fieldChanges.toggleField) {
                        if (fieldChanges.fieldType == "interimDegree") {
                            this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        } else if (fieldChanges.fieldType == 'interimSchoolDegree') {
                            this._informationMap.interimRecords.schoolDegrees.schoolDegrees[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        } else {
                            this._informationMap.records.Degrees[fieldChanges.fieldType][fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        }
                    }

                    if (fieldChanges.lookupField) {
                        if (fieldChanges.fieldType == "interimDegree") {
                            this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees[fieldChanges.index][fieldChanges.lookupField] = fieldChanges.lookupValue;
                        } else if (fieldChanges.fieldType == 'interimSchoolDegree') {
                            this._informationMap.interimRecords.schoolDegrees.schoolDegrees[fieldChanges.index][fieldChanges.lookupField] = fieldChanges.lookupValue;
                        } else if (fieldChanges.fieldType == "Non_School_Degree_Information") {
                            this._informationMap.records.Degrees.Non_School_Degree_Information[fieldChanges.index][fieldChanges.lookupField] = fieldChanges.lookupValue;
                        } else if (fieldChanges.fieldType == "School_Degree_Information") {
                            this._informationMap.records.Degrees.School_Degree_Information[fieldChanges.index][fieldChanges.lookupField] = fieldChanges.lookupValue;
                        }
                    }

                    if (fieldChanges.changeSetValue) {
                        this.addToChangeSet(fieldChanges.changeSetValue);
                    }
                })
            } catch (e) {
                console.log(e);
            }
        }
        for (let record of this._informationMap.records.Degrees.School_Degree_Information) {
            delete record.hasMaster;
        }

        if (this._informationMap && this._informationMap.records && this._informationMap.records.Degrees && this._informationMap.records.Degrees.Non_School_Degree_Information) {
            for (let record of this._informationMap.records.Degrees.Non_School_Degree_Information) {
                delete record.index;
            }
        }

        if (this._informationMap && this._informationMap.records && this._informationMap.records.Degrees && this._informationMap.records.Degrees.School_Degree_Information) {
            for (let record of this._informationMap.records.Degrees.School_Degree_Information) {
                delete record.index;
            }
        }
        return this._informationMap;
    }

    updateDirectorySetting(event) {
        let section = event.target.getAttribute('data-changesetvalue');
        let index = event.target.getAttribute('data-index');
        let type = event.target.getAttribute('data-type');
        if (type == "interim") {
            this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees[index].isShowOnDirectory = event.target.checked;
        } else {
            this._informationMap.records.Degrees[section][index].isShowOnDirectory = event.target.checked;
            this.addToChangeSet(section);
        }
    }

    addToChangeSet(changeSetValue) {
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add(changeSetValue);
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = [changeSetValue];
        }
    }

    reportUpdate(event) {
        let index = event.target.getAttribute('data-index');
        this._modalUpdateType = event.target.getAttribute('data-type');
        let section = event.target.getAttribute('data-section');
        this._modalSection = section;
        this._modalIndex = index;
        this._modalRecordTypeName = event.target.getAttribute('data-recordtype');
        this._modalSObjectName = event.target.getAttribute('data-sobjectname');

        if (section == 'interimSchoolDegree') {
            this._modalRecord = this._interimSchoolDegrees[index];
        } else {
            this._modalRecord = this._informationMap.records.Degrees[section][index];
        }

        this._openModal = true;
        this._modalMasterDegreeId = this._modalRecord.Id;

        event.preventDefault();
    }

    pendingClick(event) {
        let index = event.target.getAttribute('data-index');
        this._modalUpdateType = event.target.getAttribute('data-type');
        let section = event.target.getAttribute('data-section');
        this._modalSection = section;
        this._modalIndex = index;
        this._modalRecordTypeName = event.target.getAttribute('data-recordtype');
        this._modalSObjectName = event.target.getAttribute('data-sobjectname');
        this._openModal = true;

        let record = {};

        if (section == 'interimSchoolDegree') {
            record = this._interimSchoolDegrees[index];  // record of clicked element
        } else {
            record = this._informationMap.records.Degrees[section][index];  // record of clicked element
        }

        this._modalMasterDegreeId = record.Id;

        if (this._modalUpdateType == 'schoolDegree' && Object.keys(this.idToSelfReportDegreeMap).length > 0) {
            this._modalRecord = this.idToSelfReportDegreeMap[this._modalMasterDegreeId];
            this._recordToUpdateId = this._modalRecord.Id;
        } else if (this._modalUpdateType == 'schoolDegree') {
            for (let eachSelfReport of this.informationMap.selfReports.schoolDegreesSelfReport.schoolDegreesSelfReport) {
                if (record.Id == eachSelfReport.masterDegree) {
                    this._modalRecord = eachSelfReport;
                    this._recordToUpdateId = eachSelfReport.Id;
                    break;
                }
            }
        } else if (this._modalUpdateType == 'nonSchoolDegree' && Object.keys(this.idToSelfReportDegreeMap).length > 0) {
            this._modalRecord = this.idToSelfReportDegreeMap[this._modalMasterDegreeId];
            this._recordToUpdateId = this._modalRecord.Id;
        } else if (this._modalUpdateType == 'nonSchoolDegree') {
            for (let eachSelfReport of this.informationMap.selfReports.nonSchoolDegreesSelfReport.nonSchoolDegreesSelfReport) {
                if (record.Id == eachSelfReport.masterDegree) {
                    this._modalRecord = eachSelfReport;
                    this._recordToUpdateId = eachSelfReport.Id;
                    break;
                }
            }
        }

        event.preventDefault();
    }

    handleCloseModal = (saved, recordList) => {
        if (saved) {
            if (this._modalSection == 'interimSchoolDegree') {
                this._interimSchoolDegrees[this._modalIndex]['hasMaster'] = true;
                this._interimSchoolDegrees = [...JSON.parse(JSON.stringify(this._interimSchoolDegrees))];

            } else {
                this._informationMap.records.Degrees[this._modalSection][this._modalIndex]['hasMaster'] = true;
                this._informationMap.records.Degrees[this._modalSection] = JSON.parse(JSON.stringify(this._informationMap.records.Degrees[this._modalSection]));
            }


            recordList.forEach(record => {
                if (record.masterDegree == this._modalMasterDegreeId) {
                    this.idToSelfReportDegreeMap[record.masterDegree] = record;
                    return;
                }
            })
        }
        this._openModal = false;
    }

    handleToggleUpdate = (value, fieldName, index, fieldType) => {
        if (fieldType == 'interimDegree') {
            this._interimDegrees[index][fieldName] = value;
        } else if (fieldType == 'interimSchoolDegree') {
            this._interimSchoolDegrees[index][fieldName] = value;
        } else {
            this._informationMap.records.Degrees[fieldType][index][fieldName] = value;
        }
    }

    handleLookupAdditionalInformation = (option, fieldName, index, fieldType) => {
        let objectNameParam = '';
        if (fieldName == 'postCode' && option && option.value) {
            objectNameParam = 'postCode';
        } else if (fieldName == 'minorCode' && option && option.value) {
            let isSchoolDegreeMajorNotBlank = this._informationMap.records.Degrees.School_Degree_Information && this._informationMap.records.Degrees.School_Degree_Information[index] && this._informationMap.records.Degrees.School_Degree_Information[index].schoolDegreeMajor;
            let isInterimMajorNotBlank = this._interimSchoolDegrees && this._interimSchoolDegrees[index] && this._interimSchoolDegrees[index].schoolDegreeMajor;

            if ((fieldType == 'School_Degree_Information' && isSchoolDegreeMajorNotBlank) || (fieldType == 'interimSchoolDegree' && isInterimMajorNotBlank)) {
                return;
            } else {
                objectNameParam = 'minorCode';
            }
        }

        getAcademicOrgName({params: {objectName: objectNameParam, Id: option.value}})
        .then(result => {
            if (!result) {
                return;
            }

            let schoolName = result;

            if (fieldType == 'School_Degree_Information') {
                this._informationMap.records.Degrees.School_Degree_Information[index].schoolDegreeAcademicOrg = schoolName;
                this._informationMap.records.Degrees.School_Degree_Information[index].key = this._recordKey++;

            } else if (fieldType == 'interimSchoolDegree') {
                this._interimSchoolDegrees[index].schoolDegreeAcademicOrg = schoolName;
                this._interimSchoolDegrees[index].key = this._recordKey++;
            }
        })
    }

    renderedCallback() {
        this.equalHeight(true);
    }

    equalHeight = (resize) => {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = [];
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        if(resize === true){
            for(let i = 0; i < elements.length; i++){
                elements[i].style.height = 'auto';
            }
            for(let i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
            for(let i = 0; i < expandedElements.length; i++){
                expandedElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < elements.length; i++){
            var elementHeight = elements[i].clientHeight;
            allHeights.push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < expandedElements.length; i++){
            var elementHeight = expandedElements[i].clientHeight;
            allRowHeights.push(elementHeight);
        }

        for(let i = 0; i < elements.length; i++){
            elements[i].style.height = Math.max.apply( Math, allHeights) + 'px';
            if(resize === false){
                elements[i].className = elements[i].className + " show";
            }
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
            if(resize === false){
                headerElements[i].className = headerElements[i].className + " show";
            }
        }

        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = Math.max.apply( Math, allRowHeights) + 'px';
            if(resize === false){
                expandedElements[i].className = expandedElements[i].className + " show";
            }
        }
    }
}