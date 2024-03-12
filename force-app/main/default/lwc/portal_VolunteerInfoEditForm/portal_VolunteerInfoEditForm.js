import { LightningElement, wire, api, track } from 'lwc';
import initializeVolunteerEditForm from '@salesforce/apex/PORTAL_LWC_VolunteerEditForm.SERVER_initializeVolunteerEditForm';
import updateVolunteerInformation from '@salesforce/apex/PORTAL_LWC_VolunteerEditForm.SERVER_updateVolunteerInformation';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { getFormById } from 'c/portal_util_FormFunctions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_VolunteerInfoEditForm extends LightningElement {
    @api pageName = 'Volunteer Information';
    @api mainSectionName = 'Volunteer Edit Form';
    @api closeModal = () => {};
    @api refreshPage = () => {};

    @track _showSpinner;
    @track _showAddList = false;

    @track _contactFormData = {};
    @track _isVolunteer = false;
    _contactId = '';

    @track _skillFormData = {};
    @track _skillList = [];         // verbose list of skills, copied from the form data
    @track _skillsPicklist = [];    // concise list of {value, label}, all skills to choose from, effectively const
    @track _selectedSkills = [];    // concise list of {value, label}, skills currently selected
    @track _formFieldSkill = {};    // data structure tied to picklist/lookup fields, has picklist of unselected skills
    @track _userSelection = null;   // element of skillsPicklist, represents user's selection
    _isSkillUpdated = false;

    get formFieldSkills() {
        return {...this._formFieldSkill};
    }
    
    get listAvailableSkills() {
        const selectedValues = this._selectedSkills.map(skill => skill.value);
        return this._skillsPicklist.filter(skill => !selectedValues.includes(skill.value));
    }

    get isLookup() {
        return this._formFieldSkill.fieldType === 'lookup';
    }

    // associate non-human readable id string with human readable label
    // returns {"label": label, "value": idString}
    skillFromId(idString) {
        for (let eachSkill of this._skillsPicklist) {
            if (eachSkill.value === idString) {
                return eachSkill;
            }
        }
    }
    
    connectedCallback() {
        this._showSpinner = true;
        callApexFunction(this, initializeVolunteerEditForm, {pageName: this.pageName, mainSectionName: this.mainSectionName},
        (data) => {
            this._skillFormData = getFormById(data, 'skillList');
            this._skillFormData.isMultipleRecordForm = true;
            this.initializeSkills(this._skillFormData);

            this._contactFormData = getFormById(data, 'volunteerEditForm');
            for (let eachFormField of this._contactFormData.formRowList[0].formFieldList) {
                if (eachFormField.fieldId === 'contactId') {
                    this._contactId = eachFormField.value;
                }
                else if (eachFormField.fieldId === 'isVolunteer') {
                    this._isVolunteer = eachFormField.value;
                }
            }

            for (let eachFormField of this._skillFormData.formRowList[0].formFieldList) {
                if (eachFormField.fieldId === 'skillName') {
                    this._formFieldSkill = {...eachFormField, 'value': null, 'picklistValues': this.listAvailableSkills};
                    break;
                }
            }

            this._showSpinner = false;
        }, (e) => {this._showSpinner = false;});
    }

    // set picklist of Volunteer Skills, set selectedSkills, set skillList
    initializeSkills(skillListFormData) {
        let formFieldList = skillListFormData.formRowList[0].formFieldList;
        // every skill record has a copy of a Volunteer Skills list, just grab the first
        for (let eachFormField of formFieldList) {
            if (eachFormField.fieldId === 'skillName') {
                this._skillsPicklist = eachFormField.picklistValues.map(skill => {return {...skill, 'key': skill.value};});
            }
        }

        // each skill record represents a Constituent Skill, grab each skill label/value pair
        for (let eachFormRow of skillListFormData.formRowList) {
            let formFieldList = eachFormRow.formFieldList;
            for (let eachFormField of formFieldList) {
                // if 0 constituent skills initially, eachFormField.value is absent
                if (eachFormField.fieldId === 'skillName' && eachFormField.value) {
                    let skill = typeof(eachFormField.value) === 'string' ? this.skillFromId(eachFormField.value) : eachFormField.value;
                    this._selectedSkills.push(skill);
                    this._skillList.push(eachFormRow);
                }
            }
        }
    } 

    handleSubmit() {
        let formInfo = {};
        formInfo[this._contactFormData.formId] = this.contactFormSubmitData;
        formInfo[this._skillFormData.formId] = this.skillsSubmitData;

        this._showSpinner = true;
        callApexFunction(this, updateVolunteerInformation, {pageName: this.pageName, mainSectionName: this.mainSectionName, formData: formInfo},
        () => {
            this._showSpinner = false;
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'You have successfully updated your volunteer information.',
                variant:"success",
                mode:"sticky"
            });
            this._isShowSpinner = false;
            this.dispatchEvent(event);

            this.refreshPage();
            this.closeModal();
            this._showSpinner = false;
        }, () => {
            this._showSpinner = false;
        });
    }

    // get contact data from form element
    get contactFormSubmitData() {    
        let contactFields = {'formData': {}};
        for (let eachField of this.template.querySelectorAll('c-portal_-form-field[data-contact]')) {
            let fieldInfo = eachField.getFieldInfo();  
            if (!fieldInfo) {
                continue;
            }
            contactFields.formData[fieldInfo.fieldId] = fieldInfo.value;
        }

        return [contactFields];
    }

    // get skill form data from _skillList, form element not guaranteed to exist
    get skillsSubmitData() {
        let allSkillFields = [];
        for (let eachSkill of this._skillList) {
            let skillFields = {'formData': {}};
            for (let eachField of eachSkill.formFieldList) {
                if (eachField.fieldId === 'contactId') {
                    skillFields.formData[eachField.fieldId] = this._contactId;
                }
                else {
                    skillFields.formData[eachField.fieldId] = eachField.value?.value || eachField.value;
                }
            }
            if (eachSkill.isDeleted) {
                skillFields.isDeleted = true;
            }

            allSkillFields.push(skillFields);
        }

        return allSkillFields;
    }

    // flag to show Add picklist, disabled button
    handleAddList = (event) => {
        this._showAddList = true;
        event.currentTarget.classList.add('disabled-button');
    }

    handleRemoveAddList = (event) => {
        let addSkillButton = this.template.querySelector('.disabled-button');
        addSkillButton.classList.remove('disabled-button');
        this._showAddList = false;
        this._formFieldSkill.value = null;
    }

    validateAddSkill() {
        let choice = this._userSelection;
        if (!choice?.value) {
            const toast = new ShowToastEvent({
                title: 'No choice made',
                message: 'Please select an option',
                variant:"warning"
            });
            this.dispatchEvent(toast);
            return false;
        }

        if (this._selectedSkills.map(skill => skill.value).includes(choice.value)) {
            const toast = new ShowToastEvent({
                title: 'Skill already added',
                message: 'Please select a different option',
                variant:"warning"
            });
            this.dispatchEvent(toast);
            this._formFieldSkill.value = null;
            return false;
        }
        return true;
    }

    handleAddSkill() {
        if (!this.validateAddSkill()) {
            return;
        }

        let choice = this._userSelection;
        // reuse existing record object if previously deleted
        let recycle = false;
        for (let i = 0; i < this._skillList.length && !recycle; ++i) {
            for (const eachFormField of this._skillList[i].formFieldList) {
                if (eachFormField.fieldId === 'skillName') {
                    if ((eachFormField.value?.value || eachFormField.value) === choice.value) {
                        delete this._skillList[i].isDeleted;
                        let skill = typeof(eachFormField.value) === 'string' ? this.skillFromId(eachFormField.value) : eachFormField.value;
                        this._selectedSkills.push(skill);
                        recycle = true;
                    }
                    break;
                }
            }
        }

        // base newRecord off a copy of some other one
        if (!recycle) {
            let newRecord = [];
            for (let eachFormField of this._skillFormData.formRowList[0].formFieldList) {
                let newFormField = Object.assign({}, eachFormField);
                newFormField.value = null;
                if (newFormField.fieldId === 'skillName') {
                    newFormField.value = choice;
                    this._selectedSkills.push(newFormField.value);
                }
                newRecord.push(newFormField);
            }

            this._skillList.push({formFieldList: newRecord});
        }

        // sync _skillList with pill buttons by keeping deleteds at end of _skillList
        this.rerenderSkillList();

        // reset selection
        this._formFieldSkill.value = null;
    }

    // form field calls this function in 2 relevant cases: user input on lookup/picklist and changing _formFieldSkill in code
    handleSkillChange = (fieldId, value) => {
        if (fieldId === 'skillName') {
            // case where formFieldSkill is set to null in code  
            if (value === null) {
                return;
            }

            // picklist selection case
            if (!this.isLookup) {
                this._userSelection = this.skillFromId(value);
            }
            // lookup selection case
            else {
                // first callback
                if (!this._isSkillUpdated) {
                    this._isSkillUpdated = true;
                    this._formFieldSkill.value = value; // assignment causes second callback 
                }
                // second callback 
                //      at the end of handleAddSkill(), _formFieldSkill.value is set to null to clear text
                //      this only works if _formFieldSkill.value is updated (to the user input) in the first callback 
                //      and then handleAddSkill is called in the second callback
                else {
                    this._isSkillUpdated = false;
                    this._userSelection = value;
                    this.handleAddSkill();
                }
            }
        }
    }

    handleDeleteSkill(event) {
        let recordIndex = event.currentTarget.dataset.index;
        
        this._skillList[recordIndex].isDeleted = true;

        // update selectedSkills
        let toDelete = undefined;
        for (const eachFormField of this._skillList[recordIndex].formFieldList) {
            if (eachFormField.fieldId === 'skillName') {
                toDelete = eachFormField.value?.value || eachFormField.value;
                break;
            }
        }
        this._selectedSkills = this._selectedSkills.filter(skill => skill.value !== toDelete);

        // move deleteds to end
        this.rerenderSkillList();
    }

    // move deleted skills to the end of skillList, adds timestamp to use as a key
    rerenderSkillList = () => {
        let reorderedSkillList = []
        let deletedSkillList = [];
        for (let skillIndex = 0; skillIndex < this._skillList.length; skillIndex++) {
            let eachSkill = this._skillList[skillIndex];

            if (eachSkill.isDeleted) {
                deletedSkillList.push(eachSkill);
            } else {
                reorderedSkillList.push(eachSkill);
            }
        }

        reorderedSkillList.push(...deletedSkillList);

        this._skillList = reorderedSkillList;

        for (let eachSkill of this._skillList) {
            eachSkill.identifier = Date.now();
        }

        this._formFieldSkill.picklistValues = this.listAvailableSkills;
    }
}