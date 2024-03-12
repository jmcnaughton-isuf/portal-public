import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createVolunteerFieldList } from 'c/portal_util_Volunteer';
import initializeVolunteerSignUp from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerSignUp';
import getShiftVolunteersByRegisteringConstituent from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_initializeVolunteerModifyModal';
import volunteerShiftSignUp from '@salesforce/apex/PORTAL_LWC_VolunteerController.SERVER_volunteerShiftSignUp';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { getRelativeUrl } from 'c/portal_util_Urls';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_VolunteerSignUp extends LightningElement {
    @api pageName = 'Volunteers';
    @api mainSectionName = 'Volunteer Sign Up';
    @api modifySectionName = 'Volunteer Modify';

    @api volunteerShift;
    @api signUpType;
    @api isShowBackButton;
    @api handleCloseSignUpModal = () => {};

    _contactFrontEndDataMap = {};
    @track _signUpFieldList = [];
    _isRecaptchaEnabled = false;

    _volunteerFrontEndDataMap = {};
    _existingVolunteers;

    _isShowSpinner = false;

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_VolunteerControllerBase.volunteerShiftSignUp'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    get startDateTime() {
        return Date.parse(this.volunteerShift.volunteerJobShiftStartDateTime);
    }

    get endDateTime() {
        return Date.parse(this.volunteerShift.volunteerJobShiftEndDateTime);
    }
    connectedCallback() {
        this._isShowSpinner = true;

        getShiftVolunteersByRegisteringConstituent({params: {pageName: this.pageName, mainSectionName: this.modifySectionName, volunteerShiftId: this.volunteerShift.volunteerShiftId}})
        .then(response => {
            if (!response) {
                return;
            }

            let existingVolunteers = [];
            this._volunteerFrontEndDataMap = response.frontEndDataMap;
            for (let eachVolunteer of response.records) {
                let volunteerFields = createVolunteerFieldList(eachVolunteer, this._volunteerFrontEndDataMap);
                let volunteer = volunteerFields.reduce((accumulator, field) => {
                    if (field.display) {
                        accumulator[field.label] = field.value;
                    }
                    return accumulator;
                }, {});
                existingVolunteers.push(volunteer);
            }

            this._existingVolunteers = existingVolunteers;
        }).catch(this.initializationError);

        initializeVolunteerSignUp({params: {pageName: this.pageName, mainSectionName: this.mainSectionName, volunteerShiftId: this.volunteerShift.volunteerShiftId}})
        .then(response => {
            if (!response) {
                return;
            }

            this._contactFrontEndDataMap = response.frontEndDataMap;
            this._userContact = response.contact;
            
            for (const sectionId in this._contactFrontEndDataMap) {
                if (sectionId != null && !this._contactFrontEndDataMap[sectionId].mainSection) {
                    let dataMap = Object.assign({}, this._contactFrontEndDataMap[sectionId]);

                    for (const fieldId in dataMap.fieldMap) {
                        if (fieldId != null) {
                            let fieldMap = Object.assign({}, dataMap.fieldMap[fieldId]);
                            fieldMap.id = fieldId;

                            // prepopulate fields if information is available
                            if (this._userContact && this._userContact[fieldId] && this.signUpType != 'guest') {
                                fieldMap.value = this._userContact[fieldId];
                            } else {
                                fieldMap.value = '';
                            }

                            this._signUpFieldList.push(fieldMap);
                        }
                    }
                }
            }

            this._signUpFieldList.sort((a, b) => (a.orderNumber - b.orderNumber));
            this._isShowSpinner = false;
        }).catch(this.initializationError);
    }

    initializationError = (error) => {
        let errorMap = JSON.parse(error.body.message);
        const event = new ShowToastEvent({
            title: 'Error!',
            message: errorMap.message,
            variant:"error",
            mode:"sticky"
        });
        this.dispatchEvent(event);
    }

    get _isShowRegistrationFields() {
        return (this._signUpFieldList);
    }

    handleValueChange = (fieldId, value) => {
        this._signUpFieldList.forEach(fieldMap => {
            if (fieldMap.id === fieldId && fieldMap.value !== value) {
                fieldMap.value = value;
            }
        });
    }

    handleCloseModal(action) {
        this._signUpFieldList = [];
        this.handleCloseSignUpModal(action);
    }

    async handleVolunteerShiftSignUp() {
        if (this.areInputFieldsValid() != true) {
            return;
        }
        
        // convert list of objects to single object for backend; format matches this._userContact
        let volunteerLabelToValue = this._signUpFieldList.reduce((obj, item) => (obj[item.label] = item.value , obj), {});
        if (await this.userAlreadySignedUp(volunteerLabelToValue)) {
            this._isShowSpinner = false;
            return;
        }

        submitForm(this, this.submissionLogic, (error) => {
            console.log(error);
            this._isShowSpinner = false;
        });
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        let volunteerIdToValue = this._signUpFieldList.reduce((obj, item) => (obj[item.id] = item.value , obj), {});

        this._isShowSpinner = true;
        const params = {pageName: this.pageName, 
                        mainSectionName: this.mainSectionName, 
                        volunteerShiftId: this.volunteerShift.volunteerShiftId, 
                        volunteerBioInfoMap: volunteerIdToValue, 
                        signUpType: this.signUpType, 
                        interimSourceUrl: getRelativeUrl(),
                        recaptchaToken: recaptchaToken}

        callApexFunction(this, volunteerShiftSignUp, params, (result) => {
            // if success, then refresh previous screen so Sign Up button goes away
            this.handleCloseModal('refreshList');
            this._isShowSpinner = false;
            const event = new ShowToastEvent({
                title: 'Sign Up Success!',
                message: 'You have successfully signed up for a shift.',
                variant:"success",
                mode:"sticky"
            });
            this.dispatchEvent(event);
        }, (error) => {
            console.log(error);
            this._isShowSpinner = false;
            this.handleCloseModal('showCalendarShifts');
            errorRecaptchaCallback();
        });
    }

    handleBackButtonClick() {
        this.handleCloseModal('showCalendarShifts');
    }

    areInputFieldsValid() {
        let inputs = this.template.querySelectorAll('c-portal_-section-edit-field');
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

    // does there exist 1 volunteer where every field (first, last, email) matches the user argument?
    userInExistingVolunteers(user) {
        // it's theoretically possible for _existingVolunteers to be undefined at this point
        // due to the Apex callout being really slow
        while (!this._existingVolunteers) {
            this._isShowSpinner = true;
            return () => new Promise(resolve => setTimeout(resolve, 1000));
        }

        return this._existingVolunteers.some(
            (eachVolunteer) => {
                if (Object.keys(eachVolunteer).length == 0) {
                    return false;
                }

                return Object.keys(eachVolunteer).every(
                    (eachKey) => {
                        return eachVolunteer[eachKey].trim().toLowerCase() === user[eachKey].trim().toLowerCase();
                    }
                );
            }
        );
    }
    
    async userAlreadySignedUp(submitContact) { 
        let matchingVolunteer = this.userInExistingVolunteers(submitContact);      
        while (typeof(matchingVolunteer) !== 'boolean') {
            await matchingVolunteer();
            matchingVolunteer = this.userInExistingVolunteers(submitContact);
        }

        if (matchingVolunteer) {
            const event = new ShowToastEvent({
                title: 'Sign Up Failure!',
                message: 'This person is already signed up for a shift.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            return true;;
        }

        return false;
    }
}