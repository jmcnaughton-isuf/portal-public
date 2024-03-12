import { LightningElement, api, track } from 'lwc';
import SERVER_getConstituentInformation from '@salesforce/apex/PORTAL_MyInformationController.SERVER_getConstituentInformation'
import SERVER_saveInformation from '@salesforce/apex/PORTAL_MyInformationController.SERVER_saveInformation';
import DELETE_ICON from '@salesforce/resourceUrl/Portal_Delete_Icon';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRelativeUrl } from 'c/portal_util_Urls';

export default class Portal_MyInformationWrapper extends LightningElement {
    @api displayMode;
    @api informationMap;
    displayView;
    _callbackDone = false;
    @track _informationMap;
    @track _progressTabList = [];
    tab = "contact";
    _showSpinner = true;
    _deleteIcon = DELETE_ICON;
    dataMap;

    connectedCallback() {
        SERVER_getConstituentInformation().then(res => {
            let data = res;
            let originalIdSet = new Set();
            if (data?.interimRecords && data?.frontEndInactiveRecordFieldMap) {
                // go through page section settings to determine two things
                // 1: First is to find all the original record ids so we can hide the original records on the front end
                // 2: Find out which interim records meet the requirements of the inactive record field map and make sure those are hidden
                for (const eachFrontEndSectionId in data.frontEndInactiveRecordFieldMap) {
                    let inactiveRecordFieldMap = data.frontEndInactiveRecordFieldMap[eachFrontEndSectionId];
                    let eachInterimObjectMap = data.interimRecords[eachFrontEndSectionId];

                    for (const eachFrontEndInterimId in eachInterimObjectMap) {
                        let interimRecordList = eachInterimObjectMap[eachFrontEndInterimId];
                        for (const eachInterimRecordIndex in interimRecordList) {
                            let interimRecord = interimRecordList[eachInterimRecordIndex]
                            if (interimRecord.originalRecord) {
                                originalIdSet.add(interimRecord.originalRecord);
                            }

                            let isInactiveRecord = true;

                            for (const inactiveFrontEndFieldId in inactiveRecordFieldMap) {
                                if ((inactiveRecordFieldMap[inactiveFrontEndFieldId] || interimRecord[inactiveFrontEndFieldId])
                                        && (inactiveRecordFieldMap[inactiveFrontEndFieldId] != interimRecord[inactiveFrontEndFieldId])) {
                                    isInactiveRecord = false;
                                    break;
                                }
                            }

                            if (isInactiveRecord) {
                                interimRecord.isHide = true;
                            }
                        }
                    }
                }
            }

            if (originalIdSet.size > 0 && data.records) {
                for (const sectionId in data.records) {
                    if (sectionId == null) {
                        continue;
                    }

                    if (!data.records[sectionId] || (!data.records[sectionId].records && sectionId != 'Degrees')) {
                        continue;
                    }

                    if (sectionId != 'Degrees') {
                        data.records[sectionId].records.forEach(record => {
                            if (originalIdSet.has(record.Id)) {
                                record.isHide = true;
                            }
                        });
                    } else {
                        for (const eachDegreeInformation in data.records[sectionId]) {
                            if (!eachDegreeInformation) {
                                continue;
                            }

                            data.records[sectionId][eachDegreeInformation].forEach(degreeRecord => {
                                if (originalIdSet.has(degreeRecord.Id)) {
                                    degreeRecord.isHide = true;
                                }
                            })
                        }
                    }
                }
            }

            this.informationMap = JSON.parse(JSON.stringify(data));
            this._informationMap = Object.assign({}, this.informationMap);
            this.displayView = this.displayMode == 'view';
            var vars = {};

            var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
                vars[key] = value;
            });

            if (vars.mode) {
                this.displayView = vars.mode == 'view';
            }
            if (vars.tab && vars.mode == 'edit') {
                this.setCurrentTab(vars.tab);
            }

            this.createProgressTabList();
            this._callbackDone = true;
            this._showSpinner = false;
            if (vars && vars.message) {
                if (vars.message == 'success') {
                    const event = new ShowToastEvent({
                        title: 'Success!',
                        message: 'Your changes have been saved.',
                        variant:"success",
                        mode:"sticky"
                    });
                    this.dispatchEvent(event);
                } else if (vars.message == 'error') {
                    let errorMessage = vars.error;
                    if (errorMessage) {
                        errorMessage = errorMessage.replaceAll('+', ' ');
                        const event = new ShowToastEvent({
                            title: 'Error!',
                            message: errorMessage,
                            variant:"error",
                            mode:"sticky"
                        });
                        this.dispatchEvent(event);
                    }
                }

            }
        }).catch(error => {
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

    renderedCallback() {
        if (!this.displayView) {
            this.setTabToDisplay();
        }
    }

    save(event) {
        if (this.template.querySelector('[data-target="contact"]')) {
            let validity = this.template.querySelector('[data-target="contact"]').checkInputValidity();
            if (!validity) {
                this.showValidityToast();
                return;
            }

            let contactInfo = this.template.querySelector('[data-target="contact"]').getEditInformation();
            if (contactInfo.Change_Set) {
                if (this._informationMap['Change_Set']) {
                    let changeSet = new Set ([...this._informationMap['Change_Set'], ...contactInfo.Change_Set]);
                    this._informationMap['Change_Set'] = Array.from(changeSet);
                } else {
                    this._informationMap['Change_Set'] = contactInfo.Change_Set;
                }
            }
            this._informationMap.records.Emails.records = [...contactInfo.records.Emails.records];
            this._informationMap.records.Addresses.records = contactInfo.records.Addresses.records;
            this._informationMap.records.Phones.records = contactInfo.records.Phones.records;
            this._informationMap.records.Personal_Information.Name = contactInfo.records.Personal_Information.Name;
            this._informationMap.records.Personal_Information.Also_Known_As = contactInfo.records.Personal_Information.Also_Known_As;
            this._informationMap.records.Personal_Information.Directory_Display_Name = contactInfo.records.Personal_Information.Directory_Display_Name;
            this._informationMap.records.Personal_Information.Additional_Details = contactInfo.records.Personal_Information.Additional_Details;
            if (this._informationMap.records.Privacy_Settings.Directory_Setting.length == 0) {
                this._informationMap.records.Privacy_Settings.Directory_Setting = contactInfo.records.Privacy_Settings.Directory_Setting;
            } else {
                this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowGender = contactInfo.records.Privacy_Settings.Directory_Setting[0].isShowGender;
                this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowPronouns = contactInfo.records.Privacy_Settings.Directory_Setting[0].isShowPronouns;
                this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowMaidenName = contactInfo.records.Privacy_Settings.Directory_Setting[0].isShowMaidenName;
                this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowNickname = contactInfo.records.Privacy_Settings.Directory_Setting[0].isShowNickname;
            }

            if (this._informationMap.interimRecords && this._informationMap.interimRecords.interims && this._informationMap.interimRecords.interims.interims) {
                this._informationMap.interimRecords.interims.interims = contactInfo.interimRecords.interims.interims;
            }
            if (this._informationMap.interimRecords && this._informationMap.interimRecords.spousalInterim && this._informationMap.interimRecords.spousalInterim.spousalInterim) {
                this._informationMap.interimRecords.spousalInterim.spousalInterim = contactInfo.interimRecords.spousalInterim.spousalInterim;
            }
            if (this._informationMap.interimRecords && this._informationMap.interimRecords.emails && this._informationMap.interimRecords.emails.emails) {
                this._informationMap.interimRecords.emails.emails = contactInfo.interimRecords.emails.emails;
            }
            if (this._informationMap.interimRecords && this._informationMap.interimRecords.phones && this._informationMap.interimRecords.phones.phones) {
                this._informationMap.interimRecords.phones.phones = contactInfo.interimRecords.phones.phones;
            }
            if (this._informationMap.interimRecords && this._informationMap.interimRecords.addresses && this._informationMap.interimRecords.addresses.addresses) {
                this._informationMap.interimRecords.addresses.addresses = contactInfo.interimRecords.addresses.addresses;
            }
        }

        if (this.template.querySelector('[data-target="degree"]')) {
            let validity = this.template.querySelector('[data-target="degree"]').checkInputValidity();
            if (!validity) {
                this.showValidityToast();
                return;
            }

            let degreeInfo = this.template.querySelector('[data-target="degree"]').getEditInformation();
            if (degreeInfo.Change_Set) {
                if (this._informationMap['Change_Set']) {
                    let changeSet = new Set ([...this._informationMap['Change_Set'], ...degreeInfo.Change_Set]);
                    this._informationMap['Change_Set'] = Array.from(changeSet);

                } else {
                    this._informationMap['Change_Set'] = degreeInfo.Change_Set;
                }
            }
            this._informationMap.records.Degrees.Non_School_Degree_Information = degreeInfo.records.Degrees.Non_School_Degree_Information;
            this._informationMap.records.Degrees.School_Degree_Information = degreeInfo.records.Degrees.School_Degree_Information;

            if (this._informationMap.interimRecords && this._informationMap.interimRecords.nonSchoolDegrees && this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees) {
                this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees = degreeInfo.interimRecords.nonSchoolDegrees.nonSchoolDegrees;
            }

            if (this._informationMap.interimRecords && this._informationMap.interimRecords.schoolDegrees && this._informationMap.interimRecords.schoolDegrees.schoolDegrees) {
                this._informationMap.interimRecords.schoolDegrees.schoolDegrees = degreeInfo.interimRecords.schoolDegrees.schoolDegrees;
            }

        }

        if (this.template.querySelector('[data-target="employment"]')) {
            let validity = this.template.querySelector('[data-target="employment"]').checkInputValidity();
            if (!validity) {
                this.showValidityToast();
                return;
            }

            let employmentInfo = this.template.querySelector('[data-target="employment"]').getEditInformation();
            if (employmentInfo.Change_Set) {
                if (this._informationMap['Change_Set']) {
                    let changeSet = new Set ([...this._informationMap['Change_Set'], ...employmentInfo.Change_Set]);
                    this._informationMap['Change_Set'] = Array.from(changeSet);

                } else {
                    this._informationMap['Change_Set'] = employmentInfo.Change_Set;
                }
            }
            this._informationMap.records.Employment.records = employmentInfo.records.Employment.records;
            if (this._informationMap.interimRecords && this._informationMap.interimRecords.employment && this._informationMap.interimRecords.employment.employment) {
                this._informationMap.interimRecords.employment.employment = employmentInfo.interimRecords.employment.employment;
            }

        }

        if (this.template.querySelector('[data-target="socialmedia"]')) {
            let validity = this.template.querySelector('[data-target="socialmedia"]').checkInputValidity();
            if (!validity) {
                this.showValidityToast();
                return;
            }

            let socialMediaInfo = this.template.querySelector('[data-target="socialmedia"]').getEditInformation();
            if (socialMediaInfo.Change_Set) {
                if (this._informationMap['Change_Set']) {
                    let changeSet = new Set ([...this._informationMap['Change_Set'], ...socialMediaInfo.Change_Set]);
                    this._informationMap['Change_Set'] = Array.from(changeSet);

                } else {
                    this._informationMap['Change_Set'] = socialMediaInfo.Change_Set;
                }
            }
            this._informationMap.records.Social_Media.records = socialMediaInfo.records.Social_Media.records;
            if (this._informationMap.interimRecords && this._informationMap.interimRecords.socialMedia  && this._informationMap.interimRecords.socialMedia .socialMedia) {
                this._informationMap.interimRecords.socialMedia.socialMedia = socialMediaInfo.interimRecords.socialMedia.socialMedia;
            }
        }

        if (this.template.querySelector('[data-target="privacy"]')) {
            let privacyInfo = this.template.querySelector('[data-target="privacy"]').getEditInformation();
            if (privacyInfo.Change_Set) {
                if (this._informationMap['Change_Set']) {
                    let changeSet = new Set ([...this._informationMap['Change_Set'], ...privacyInfo.Change_Set]);
                    this._informationMap['Change_Set'] = Array.from(changeSet);

                } else {
                    this._informationMap['Change_Set'] = privacyInfo.Change_Set;
                }
            }
            this._informationMap.records.Privacy_Settings.Directory_Opt_Out = privacyInfo.records.Privacy_Settings.Directory_Opt_Out;
            if (!this._informationMap.records.Privacy_Settings.Directory_Setting || this._informationMap.records.Privacy_Settings.Directory_Setting.length == 0) {
                this._informationMap.records.Privacy_Settings.Directory_Setting = privacyInfo.records.Privacy_Settings.Directory_Setting;
            } else if (privacyInfo && privacyInfo.records && privacyInfo.records.Privacy_Settings && privacyInfo.records.Privacy_Settings.Directory_Setting && privacyInfo.records.Privacy_Settings.Directory_Setting.length > 0) {
                this._informationMap.records.Privacy_Settings.Directory_Setting[0].studentCanSee = privacyInfo.records.Privacy_Settings.Directory_Setting[0].studentCanSee;
                this._informationMap.records.Privacy_Settings.Directory_Setting[0].receivingMessages = privacyInfo.records.Privacy_Settings.Directory_Setting[0].receivingMessages;
            }
        }

        if (!this.validateInformation()) {
            return;
        }

        this.removePicklistValuesFromRecords();
        this.removeExtraValuesFromAlsoKnownAsRecords();
        this._informationMap.interimSourceUrl = getRelativeUrl();

        const params = {information : this._informationMap};
        this._showSpinner = true;
        SERVER_saveInformation(params).then(res => {
            if (res) {
                window.location.replace(window.location.href.split(/[?#]/)[0] + "?message=error&error=" + res);
            } else {
                window.location.replace(window.location.href.split(/[?#]/)[0] + "?message=success");
            }

        }).catch(error => {
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);
            this.template.querySelector('[data-target="contact"]').resetPicklistValues();
            this._showSpinner = false;
        });
    }

    validateInformation() {
        let errorMessage = '';
        if (this._informationMap && this._informationMap.records) {
            if (this._informationMap.records.Personal_Information) {
                if (this._informationMap.records.Personal_Information.Name && this._informationMap.records.Personal_Information.Name.length > 0) {
                    let trimmedLastName = !this._informationMap.records.Personal_Information.Name[0].lastName || this._informationMap.records.Personal_Information.Name[0].lastName.trim();
                    if (!this._informationMap.records.Personal_Information.Name[0].lastName || !trimmedLastName) {
                        errorMessage = 'Please make sure all names have an associated last name.';
                    }
                }
                if (this._informationMap.records.Personal_Information.Additional_Details && this._informationMap.records.Personal_Information.Additional_Details.length > 0) {
                    let contact = this._informationMap.records.Personal_Information.Additional_Details[0];
                    if (contact.ucinn_ascendv2__Preferred_Spouse__r) {
                        let spouseFirstName = contact.spouseFirstName;
                        let spouseLastName = contact.spouseLastName;
                        let trimmedSpouseFirstName = !spouseFirstName || contact.spouseFirstName.trim();
                        let trimmedSpouseLastName = !spouseLastName || contact.spouseLastName.trim();

                        if ((spouseFirstName && !spouseLastName) || (!spouseFirstName && spouseLastName)
                            || (spouseFirstName && !trimmedSpouseLastName) || (!trimmedSpouseFirstName && spouseLastName) || (!trimmedSpouseFirstName && !trimmedSpouseLastName)) {
                            if (!errorMessage.includes('Please fill out all spouse information.')) {
                                errorMessage = errorMessage + 'Please fill out all spouse information.';
                            }
                        }
                    }
                }

                if (this._informationMap.records.Personal_Information.Also_Known_As && this._informationMap.records.Personal_Information.Also_Known_As.length > 0) {
                    for (let name of this._informationMap.records.Personal_Information.Also_Known_As) {
                        if (name.maidenType == 'Maiden') {
                            let trimmedAkaLastName = !name.maidenLastName || name.maidenLastName.trim();

                            if ((name.maidenFirstName || name.maidenMiddleName) && !name.maidenLastName) {
                                if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                                    errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                                }
                            } else if ((name.maidenFirstName || name.maidenMiddleName) && !trimmedAkaLastName) {
                                if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                                    errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                                }
                            }
                        } else if (name.nicknameType == 'Nickname'){
                            let trimmedAkaLastName = !name.nicknameLastName || name.nicknameLastName.trim();

                            if (name.nicknameFirstName && !name.nicknameLastName) {
                                if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                                    errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                                }
                            } else if (name.nicknameFirstName && !trimmedAkaLastName) {
                                if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                                    errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                                }
                            }
                        }
                    }
                }

                if (this._informationMap.records.Personal_Information.Directory_Display_Name && this._informationMap.records.Personal_Information.Directory_Display_Name.length > 0) {
                    let directoryLastName = !this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryLastName || this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryLastName.trim();
                    if (this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryFirstName && !this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryLastName) {
                        if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                            errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                        }
                    } else if (this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryFirstName && !directoryLastName) {
                        if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                            errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                        }
                    }
                }

                if (this._informationMap.records.Employment.records && this._informationMap.records.Employment.records.length > 0) {
                    for (let employment of this._informationMap.records.Employment.records) {
                        if (employment.employmentStartDate && employment.employmentEndDate) {
                            let startDate = employment.employmentStartDate;
                            let endDate = employment.employmentEndDate;

                            if (endDate < startDate && !errorMessage.includes('Please ensure employment end date is not before start date.')) {
                                errorMessage = errorMessage + 'Please ensure employment end date is not before start date.';
                            }
                        }
                    }
                }

            }
        }

        if (this._informationMap && this._informationMap.interimRecords) {
            if (this._informationMap.interimRecords.spousalInterim && this._informationMap.interimRecords.spousalInterim.spousalInterim && this._informationMap.interimRecords.spousalInterim.spousalInterim.length > 0) {
                let spousalInterim = this._informationMap.interimRecords.spousalInterim.spousalInterim[0];
                let spouseFirstName = spousalInterim.spouseFirstName;

                let spouseLastName = spousalInterim.spouseLastName;

                let trimmedSpouseFirstName = !spouseFirstName || spouseFirstName.trim();

                let trimmedSpouseLastName = !spouseLastName || spouseLastName.trim();

                if ((spouseFirstName && !spouseLastName) || (!spouseFirstName && spouseLastName)
                    || (spouseFirstName && !trimmedSpouseLastName) || (!trimmedSpouseFirstName && spouseLastName) || (!trimmedSpouseFirstName && !trimmedSpouseLastName)) {
                    if (!errorMessage.includes('Please fill out all spouse information.')) {
                        errorMessage = errorMessage + 'Please fill out all spouse information.';
                    }
                }

            }

            if (this._informationMap.interimRecords.interims && this._informationMap.interimRecords.interims.interimRecords
                && this._informationMap.interimRecords.interims.interimRecords.length > 0) {
                let interim = this._informationMap.interimRecords.interims.interimRecords[0];
                let trimmedInterimLastName = !interim.lastName || interim.lastName.trim();
                let trimmedInterimMaidenLastName = !interim.maidenLastName || interim.maidenLastName.trim();
                let trimmedDirectoryLastName = !interim.directoryLastName || interim.directoryLastName.trim();
                let trimmedNicknameLastName = !interim.nicknameLastName || interim.nicknameLastName.trim();

                if ((interim.firstName || interim.middleName) && !interim.lastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                } else if ((interim.firstName || interim.middleName) && !trimmedInterimLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                }

                if ((interim.maidenFirstName || interim.maidenMiddleName) && !interim.maidenLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                } else if ((interim.maidenFirstName || interim.maidenMiddleName) && !trimmedInterimMaidenLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                }

                if (interim.directoryFirstName && !interim.directoryLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                } else if (interim.directoryFirstName && !trimmedDirectoryLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                }

                if (interim.nicknameFirstName && !interim.nicknameLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                } else if (interim.nicknameFirstName && !trimmedNicknameLastName) {
                    if (!errorMessage.includes('Please make sure all names have an associated last name.')) {
                        errorMessage = errorMessage + 'Please make sure all names have an associated last name.';
                    }
                }
            }

            if (this._informationMap.interimRecords.nonSchoolDegrees && this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees
                && this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees.length > 0) {
                for (let degree of this._informationMap.interimRecords.nonSchoolDegrees.nonSchoolDegrees) {
                    if (!degree.nonSchoolDegreeInstitutionId) {
                        if (!errorMessage.includes('Please choose a ' + this.informationMap.frontEndData.nonSchoolDegreeInstitution.label + ' from the drop down list.')) {
                            errorMessage = errorMessage + 'Please choose a ' + this.informationMap.frontEndData.nonSchoolDegreeInstitution.label + ' from the drop down list.';
                        }
                    }
                }
            }

            if (this._informationMap.interimRecords.employment && this._informationMap.interimRecords.employment.employment
                && this._informationMap.interimRecords.employment.employment.length > 0) {
                for (let employment of this._informationMap.interimRecords.employment.employment) {
                    if (!employment.employerId) {
                        if (!errorMessage.includes('Please choose employers from the drop down list.')) {
                            errorMessage = errorMessage + 'Please choose employers from the drop down list.';
                        }
                    }

                    if (employment.employmentStartDate && employment.employmentEndDate) {
                        let startDate = employment.employmentStartDate;
                        let endDate = employment.employmentEndDate;

                        if (endDate < startDate && !errorMessage.includes('Please ensure employment end date is not before start date.')) {
                            errorMessage = errorMessage + 'Please ensure employment end date is not before start date.';
                        }

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

    get _displayPrivacySection() {
        return (this.informationMap.frontEndData.directoryOptOut.display || this.informationMap.frontEndData.directorySetting.display);
    }

    get _displayDegreeSection() {
        return (this.informationMap.frontEndData.schoolDegrees.display || this.informationMap.frontEndData.nonSchoolDegrees.display);
    }

    showValidityToast() {
        const event = new ShowToastEvent({
            title: 'Error.',
            message: 'Please fill out all required fields.',
            variant:"error",
            mode:"sticky"
        });
        this.dispatchEvent(event);
        return;
    }

    get _displaySocialMediaTab() {
        return this.informationMap.frontEndData.socialMedia.display;
    }

    get _displayEmploymentTab() {
        return this.informationMap.frontEndData.employment.display;
    }

    get _displayPrivacyTab() {
        return (this.informationMap.frontEndData.directoryOptOut.display || this.informationMap.frontEndData.directorySetting.display);
    }

    get _displayDegreeTab() {
        return (this.informationMap.frontEndData.schoolDegrees.display || this.informationMap.frontEndData.nonSchoolDegrees.display);
    }

    get _displayContactTab() {
        return (this.informationMap.frontEndData.name.display
                || this.informationMap.frontEndData.alsoKnownAs.display
                || this.informationMap.frontEndData.additionalDetails.display
                || this.informationMap.frontEndData.emails.display
                || this.informationMap.frontEndData.phones.display
                || this.informationMap.frontEndData.addresses.display)
    }

    get _displaySocialMediaSection() {
        return (this.informationMap.frontEndData.socialMedia.display && this.tab == 'socialmedia');
    }

    get _displayEmploymentSection() {
        return (this.informationMap.frontEndData.employment.display && this.tab == 'employment');
    }

    get _displayPrivacySection() {
        return (this.informationMap.frontEndData.directoryOptOut.display || this.informationMap.frontEndData.directorySetting.display) && this.tab == 'privacy';
    }

    get _displayDegreeSection() {
        return (this.informationMap.frontEndData.schoolDegrees.display || this.informationMap.frontEndData.nonSchoolDegrees.display) && this.tab == 'degree';
    }

    get _displayContactSection() {
        return ((this.informationMap.frontEndData.name.display
                || this.informationMap.frontEndData.alsoKnownAs.display
                || this.informationMap.frontEndData.additionalDetails.display
                || this.informationMap.frontEndData.emails.display
                || this.informationMap.frontEndData.phones.display
                || this.informationMap.frontEndData.addresses.display)
                    && this.tab == 'contact'
                );
    }

    get pathClass() {
        return 'progress-step-custom slds-path__item slds-is-incomplete';
    }

    setTab = (event) => {
        this.tab = event.target.value;
        if (event.target.value) {
            this.tab = event.target.value;
        } else if (event.currentTarget.getAttribute('data-value')) {
            this.tab = event.currentTarget.getAttribute('data-value');
        }

        this.createProgressTabList();

        if (!this.displayView) {
            this.setTabToDisplay();
        }
    }

    // we want to hide and show the sections and not make them disappear or the information will not save
    setTabToDisplay = () =>{
        if (this.template.querySelectorAll('[data-element="editsection"]')) {
            let editSections = this.template.querySelectorAll('[data-element="editsection"]');
            editSections.forEach(section => {
                section.classList.add('slds-hide');
            });

            let activeSection = this.template.querySelector('[data-section="' + this.tab + '"]');
            if (activeSection) {
                activeSection.classList.remove('slds-hide');
            }
        }
    }

    setCurrentTab(tabName) {
        if (tabName == 'contact' && !this._displayContactTab
            || tabName == 'employment' && !this._displayEmploymentTab
            || tabName == 'degree' && !this._displayDegreeTab
            || tabName == 'socialmedia' && !this._displaySocialMediaTab
            || tabName == 'privacy' && !this._displayPrivacyTab) {
                return;
        }

        this.tab = tabName;
    }

    createProgressTabList() {
        let progressTabList = [];

        if (this._displayContactTab) {
            let tabClass = this.pathClass;

            if (this.tab == 'contact') {
                tabClass = tabClass + ' slds-is-active';
            }
            progressTabList.push({label: "Contact Information", class: tabClass, value:"contact", key: Date.now()});
        }

        if (this._displayEmploymentTab) {
            let tabClass = this.pathClass;

            if (this.tab == 'employment') {
                tabClass = tabClass + ' slds-is-active';
            }
            progressTabList.push({label: "Employment Information", class: tabClass, value:"employment", key: Date.now()});
        }

        if (this._displayDegreeTab) {
            let tabClass = this.pathClass;

            if (this.tab == 'degree') {
                tabClass = tabClass + ' slds-is-active';
            }
            progressTabList.push({label: "Degree Information", class: tabClass, value:"degree", key: Date.now()});
        }

        if (this._displaySocialMediaTab) {
            let tabClass = this.pathClass;

            if (this.tab == 'socialmedia') {
                tabClass = tabClass + ' slds-is-active';
            }
            progressTabList.push({label: "Social Media Information", class: tabClass, value:"socialmedia", key: Date.now()});
        }

        if (this._displayPrivacyTab) {
            let tabClass = this.pathClass;

            if (this.tab == 'privacy') {
                tabClass = tabClass + ' slds-is-active';
            }
            progressTabList.push({label: "Privacy Settings", class: tabClass, value:"privacy"});
        }

        this._progressTabList = progressTabList;
    }

    removePicklistValuesFromRecords() {
        this._informationMap.records.Emails.records.forEach(record => {
                delete record.picklistValues;
        });

        this._informationMap.records.Addresses.records.forEach(record => {
                delete record.picklistValues;
        });

        this._informationMap.records.Phones.records.forEach(record => {
                delete record.picklistValues;
        });

        if (this._informationMap.interimRecords && this._informationMap.interimRecords.emails && this._informationMap.interimRecords.emails.emails) {
            this._informationMap.interimRecords.emails.emails.forEach(record => {
                delete record.picklistValues;
            });
        }
        if (this._informationMap.interimRecords && this._informationMap.interimRecords.phones && this._informationMap.interimRecords.phones.phones) {
            this._informationMap.interimRecords.phones.phones.forEach(record => {
                delete record.picklistValues;
            });
        }
        if (this._informationMap.interimRecords && this._informationMap.interimRecords.addresses && this._informationMap.interimRecords.addresses.addresses) {
            this._informationMap.interimRecords.addresses.addresses.forEach(record => {
                delete record.picklistValues;
            });
        }
    }

    /**
     * With new front end refactor, when we pull the AKA records, the nickname/maiden records will contain the correct info but 
     * also include extraneous information. This can be fixed but will prob require a much bigger refactor. 
     * 
     * With the extra information, it will override the actual changes since these fields all share the same staging field api name
     * so we need to remove the extra information. Directory is unaffected here since it belongs in a separate CMT setting that doesnt get 
     * included in the same list of records as nickname & maiden names. 
     * 
     * For example, a nickname record shouldnt contain info about directory, or maiden names, and vice versa.
     */
    removeExtraValuesFromAlsoKnownAsRecords() {
        if (!this._informationMap?.records?.Personal_Information.Also_Known_As) {
            return;
        }

        this._informationMap.records.Personal_Information.Also_Known_As.forEach(record => {
            if (record.maidenType == 'Maiden') {
                Object.keys(record).forEach(fieldName => {
                    if (fieldName.toLowerCase().includes('directory') || fieldName.toLowerCase().includes('nickname')) {
                        delete record[fieldName];
                    }
                })
            } else if (record.maidenType == 'Nickname') {
                Object.keys(record).forEach(fieldName => {
                    if (fieldName.toLowerCase().includes('directory') || fieldName.toLowerCase().includes('maiden')) {
                        delete record[fieldName];
                    }
                })
            }

            delete record.firstName;
            delete record.middleName;
            delete record.lastName;
            delete record.type
        })

    }
}