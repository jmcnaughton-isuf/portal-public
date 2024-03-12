import { LightningElement, api, track } from 'lwc';
import viewTemplate from './portal_MyInformationEmploymentView.html';
import editTemplate from './portal_MyInformationEmploymentEdit.html';

export default class Portal_MyInformationEmployment extends LightningElement {
    @api informationMap;
    @api displayView;
    @api deleteIcon;
    @track _informationMap;
    _openModal;
    _modalUpdateType;
    _modalRecord;
    _modalRecordTypeName;
    _modalSObjectName;
    _interimEmployment = [];
    _employmentIndex = 0;

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
            if (this.informationMap && this.informationMap.interimRecords && this.informationMap.interimRecords.employment && this.informationMap.interimRecords.employment.employment) {
                this._interimEmployment = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.employment.employment))];
            }
            if (this._informationMap && this._informationMap.records && this._informationMap.records.Employment && this._informationMap.records.Employment.records) {
                for (let record of this._informationMap.records.Employment.records) {
                    record['index'] = 'employment' + this._employmentIndex;
                    this._employmentIndex++;
                }
            }
        }
    }

    render(){
        return this.displayView ? viewTemplate : editTemplate;
    }

    editInformation(){
        window.location.replace(window.location.href.split(/[?#]/)[0] + '?mode=edit&tab=employment');
    }

    addEmployment (event) {
        this._informationMap.records.Employment.records = [...this._informationMap.records.Employment.records,
            {employer: "", jobTitle: "", isShowJobTitle: false, status: "Current",
            employmentShowOnDirectory: false, isShowEmployer:false, employeeRole: "Employee",
            employmentStartDate : null, employmentEndDate: null, Id:null, index: 'employment' + this._employmentIndex}];
            this._employmentIndex++;
            this.addToChangeSet('Employment');
    }

    deleteEmployment(event) {
        let type = event.currentTarget.getAttribute('data-type');
        let index = event.currentTarget.getAttribute('data-index');
        if (type == "interim") {
            this._informationMap.interimRecords.employment.employment.splice(index, 1);
            this._interimEmployment = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.employment.employment))];
        } else {
            this._informationMap.records.Employment.records.splice(index, 1);
        }
        this.addToChangeSet('Employment');
    }

    @api
    getEditInformation() {
        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            try {
                this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                    let fieldChanges = element.getEditInformation();
                    if (fieldChanges.fieldType == "interimEmployment") {
                        this._informationMap.interimRecords.employment.employment[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                    } else {
                        if (fieldChanges.fieldName.includes('.')) {
                            let fields = fieldChanges.fieldName.split('.');
                            this._informationMap.records.Employment.records[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                        } else {
                            this._informationMap.records.Employment.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                        }

                    }
                    if (fieldChanges.toggleField) {
                        if (fieldChanges.fieldType == "interimEmployment") {
                            this._informationMap.interimRecords.employment.employment[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        } else {
                            this._informationMap.records.Employment.records[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                        }
                    }
                    if (fieldChanges.lookupField) {
                        if (fieldChanges.fieldType == "interimEmployment") {
                            this._informationMap.interimRecords.employment.employment[fieldChanges.index][fieldChanges.lookupField] = fieldChanges.lookupValue;
                        } else {
                            this._informationMap.records.Employment.records[fieldChanges.index][fieldChanges.lookupField] = fieldChanges.lookupValue;
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
        if (this._informationMap && this._informationMap.records && this._informationMap.records.Employment && this._informationMap.records.Employment.records) {
            for (let record of this._informationMap.records.Employment.records) {
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
            this._informationMap.interimRecords.employment.employment[index].employmentShowOnDirectory = event.target.checked;
        } else {
            this._informationMap.records.Employment.records[index].employmentShowOnDirectory = event.target.checked;
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

    get employmentDisplaySettingList() {
        let displaySettingList = [];
        let displaySetting = {};
        displaySetting['customMetadataDeveloperName'] = this.informationMap.frontEndData['employer'].customMetadataDeveloperName;
        displaySettingList.push(displaySetting);
        return displaySettingList;
    }

    reportUpdate(event) {
        let index= event.target.getAttribute('data-index');
        this._modalUpdateType = event.target.getAttribute('data-type');
        this._modalRecordTypeName = event.target.getAttribute('data-recordtype');
        this._modalSObjectName = event.target.getAttribute('data-sobjectname');
        this._modalRecord = this._informationMap.records.Employment.records[index];
        this._openModal = true;
        event.preventDefault();
    }

    handleCloseModal = (saved) => {
        this._openModal = false;
    }

    handleToggleUpdate = (value, fieldName, index, fieldType) => {
        if (fieldType == "interimEmployment") {
            this._informationMap.interimRecords.employment.employment[index][fieldName] = value;
        } else {
            this._informationMap.records.Employment.records[index][fieldName] = value;
        }
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