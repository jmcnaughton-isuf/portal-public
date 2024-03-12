import { LightningElement, api } from 'lwc';
import fieldTemplate from './portal_MyInformationUpdateModalField.html';
import schoolDegreeTemplate from './portal_MyInformationUpdateModalSchoolDegree.html';
import nonSchoolDegreeTemplate from './portal_MyInformationUpdateModalNonSchoolDegree.html';
import employmentTemplate from './portal_MyInformationUpdateModalEmployment.html';
import socialMediaTemplate from './portal_MyInformationUpdateModalSocialMedia.html';
import SERVER_reportUpdate from '@salesforce/apex/PORTAL_MyInformationController.SERVER_reportUpdate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRelativeUrl } from 'c/portal_util_Urls';

export default class Portal_MyInformationUpdateModal extends LightningElement {

    @api informationMap;
    @api field;
    @api updateType;
    @api fieldValue;
    @api fieldType;
    @api record;
    @api sobjectName;
    @api recordTypeName;
    @api fieldName;
    @api masterDegreeId;
    @api recordToUpdateId;  // need this field since just having the Id in the record doesnt update it
    @api handleClose = (saved) => {};
    _interimRecord = {};
    _label = "";
    _saving = false;
    _isShowSpinner = false;
    _record = {};
    _earliestDate = new Date('1700-01-01');
    _latestDate = new Date('4000-12-31');

    connectedCallback() {
        this._isShowSpinner = true;
        if (this.field) {
            this._label = this.informationMap.frontEndData[this.field].label;
        }

        this._isShowSpinner = false;
        this._record = Object.assign({}, this.record);
    }

    render() {
        if (this.updateType == 'fieldUpdate') {
            return fieldTemplate;
        } else if (this.updateType == 'schoolDegree') {
            return schoolDegreeTemplate;
        } else if (this.updateType == 'nonSchoolDegree') {
            return nonSchoolDegreeTemplate;
        } else if (this.updateType == 'employment') {
            return employmentTemplate;
        } else {
            return socialMediaTemplate;
        }
    }

    updateDirectorySetting(event) {
        this._interimRecord['isShowOnDirectory'] = event.target.checked;
    }


    getDisplaySettingList(fieldId) {
        let displaySettingList = [];
        let displaySetting = {};
        displaySetting['customMetadataDeveloperName']  = this.informationMap.frontEndData[fieldId].customMetadataDeveloperName;
        displaySettingList.push(displaySetting);
        return displaySettingList;
    }

    get helperRichText() {
        return this.informationMap?.requestUpdateRichText;
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

    get degreeInstitutionDisplaySettingList() {
        return this.getDisplaySettingList('nonSchoolDegreeInstitution');
    }

    get employerInstitutionDisplaySettingList() {
        return this.getDisplaySettingList('employer');
    }

    handleCancel(event) {
        this.handleClose(false);
    }

    handleSave(event) {
        if (this._saving == true) {
            return;
        }
        this._isShowSpinner = true;
        this._saving = true;
        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            try {
                this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                    let fieldChanges = element.getEditInformation();
                    if (fieldChanges.lookupField) {
                        this._interimRecord[fieldChanges.lookupField] = fieldChanges.lookupValue;
                    } else if (this.updateType == 'fieldUpdate') {
                        if (!fieldChanges.value && this.fieldValue) {
                            this._interimRecord.isBirthdateDeleted = true;
                        } else if (fieldChanges.value) {
                            this._interimRecord.isBirthdateDeleted = false;
                        }

                        if (this._interimRecord.isBirthdateDeleted == true) {
                            this._interimRecord[fieldChanges.fieldName] = null; // set it to null and not empty during deletion because backend cannot accept empty date.
                        } else {
                            this._interimRecord[fieldChanges.fieldName] = fieldChanges.value;
                        }
                    } else {
                        if (fieldChanges.fieldName.includes('.')) {
                            let fields = fieldChanges.fieldName.split('.');
                            this._interimRecord[fields[0]][fields[1]] = fieldChanges.value;
                        } else {
                            this._interimRecord[fieldChanges.fieldName] = fieldChanges.value;
                        }
                    }
                    if (fieldChanges.toggleField) {
                        this._interimRecord[fieldChanges.toggleField] = fieldChanges.toggleValue;
                    }
                });
            } catch (e) {
                console.log(e);
            }
        }

        if (!this.validateInformation()) {
            this._isShowSpinner = false;
            this._saving = false;
            return;
        }
        const params = {record : this._interimRecord, sObjectName: this.sobjectName,
                        recordType: this.recordTypeName, masterDegreeId: this.masterDegreeId,
                        recordToUpdateId: this.recordToUpdateId, createCase: true, interimSourceUrl: getRelativeUrl()};
        SERVER_reportUpdate({params: params}).then(res => {
            let recordList = JSON.parse(JSON.stringify(res))
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Your changes have been saved.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this._saving = false;
            this._isShowSpinner = false;
            this.handleClose(true, recordList);
        }).catch(error => {
            this._isShowSpinner = false;
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        });

    }

    handleSchoolLookupChange = (value, index, fieldType) => {
        this._record[index] = value;

    }

    validateInformation() {
        let errorMessage = '';

        if (this.sobjectName == 'schoolDegreesSelfReport' || this.sobjectName == 'nonSchoolDegreesSelfReport') {
            if (this.recordTypeName == 'School_Degree_Information' && this._interimRecord && !this._interimRecord.postCode && this._record.postCode) {
                errorMessage = 'Please choose a major from the drop down list';
            } else if (this.recordTypeName == 'School_Degree_Information' && this._interimRecord && !this._interimRecord.minorCode && this._record.minorCode) {
                errorMessage = 'Please choose a minor from the drop down list';
            } else if (this.recordTypeName == 'Non_School_Degree_Information' && this._interimRecord && !this._interimRecord.degreeInstitution) {
                errorMessage = 'Please choose a ' + this.informationMap.frontEndData.nonSchoolDegreeInstitution.label + ' from the drop down list';
            }
        } else if (this.field == 'birthdate') {
            let inputField = this.template.querySelector('[data-target="singlefield"]');
            if (inputField) {
                if (!inputField.checkValidity()) {
                    errorMessage = 'Please enter in a valid date';
                } else {
                    let enteredDate = new Date(inputField.getValue());
                    if (enteredDate < this._earliestDate || enteredDate > this._latestDate) {
                        errorMessage = 'Please enter in a valid date';
                    }
                }
            }
        }

        if (errorMessage) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMessage,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            return false;
        } else {
            return true;
        }
    }
}