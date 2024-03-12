import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import basePath from '@salesforce/community/basePath';
import SERVER_getJobListing from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getJobListing';
export default class Portal_JobListingDetail extends LightningElement {

    @api recordId;
    @api informationMap;
    @api isShowInModal = false;

    _job;
    _callbackDone = false;
    _isShowModal = false;
    _isUserOwned = false;
    _applied = false;
    _isShowSpinner = true;

    connectedCallback() {
        const params = {params : {recordId : this.recordId}};
        SERVER_getJobListing(params).then(res => {
            this.informationMap = res;
            this._applied = res['applied'];
            this._isUserOwned = res['userOwned'];
            if (this.informationMap && this.informationMap['records'] && this.informationMap['records']['Job'] && this.informationMap['records']['Job']['records']) {
                this._job = this.informationMap['records']['Job']['records'][0];
                this._isShowSpinner = false;
                this._callbackDone = true;
            }
        }).catch(error => {
            console.log(error);
        })
    }

    getRecordValue(fieldId) {
        if (!this.informationMap || !this.informationMap.frontEndData || !this.informationMap.frontEndData[fieldId] || !this._job) {
            return "";
        }

        let fieldName = this.informationMap.frontEndData[fieldId].fieldName;
        let fieldType = this.informationMap.frontEndData[fieldId].fieldType;
        let isPicklist = this.informationMap.frontEndData[fieldId].isPicklist;

        if (isPicklist) {
            if (this._job[fieldName]) {
                let picklistSplit = this._job[fieldName].split(';').join('; ');
                return picklistSplit;
            }
            if (!this.picklists || !this.picklists[fieldId]) {
                return '';
            }
            for (let picklistValue of this.picklists[fieldId]) {
                if (picklistValue.value == this._job[fieldName]) {
                    return picklistValue.label;
                }
            }
            return '';
        } else {
            if (this._job[fieldName]) {
                if (fieldType == "checkbox") {
                    if (this._job[fieldName] == true) {
                        return 'Yes';
                    } else
                    {
                        return 'No'
                    }
                }
                return this._job[fieldName];
            }
            if (fieldType == 'checkbox') {
                return 'No';
            }
            return '';
        }
    }

    handleShowModal(event) {
        this._isShowModal = true;
    }

    handleCloseModal = (submit) => {
        this._isShowModal = false;

        if (submit == true) {
            const event = new ShowToastEvent({
                title: 'Submit',
                variant: 'success',
                mode: 'sticky',
                message:
                    'You have successfully submitted your job application.',
            });
            this.dispatchEvent(event);
            this._applied = true;
            this.informationMap.applied = true;
        }
    }

    handleViewApplication() {
        // if job board's flexipage/json tabset id changed, change here too
        window.location.href = basePath + '/job-board?viewJobApplications=true';
    }

    get jobName() {
        return this.getRecordValue('jobName');
    }

    get companyName() {
        return this.getRecordValue('companyName');
    }

    get isShowAddress() {
        if (this.informationMap && this.informationMap.frontEndData) {
            let showAddress = false;
            if (this.informationMap.frontEndData.addressLine1) {
                showAddress = showAddress || this.informationMap.frontEndData.addressLine1.display;
            }
            if (this.informationMap.frontEndData.addressLine2) {
                showAddress = showAddress || this.informationMap.frontEndData.addressLine2.display;
            }
            if (this.informationMap.frontEndData.addressLine3) {
                showAddress = showAddress || this.informationMap.frontEndData.addressLine3.display;
            }
            if (this.informationMap.frontEndData.city) {
                showAddress = showAddress || this.informationMap.frontEndData.city.display;
            }
            if (this.informationMap.frontEndData.state) {
                showAddress = showAddress || this.informationMap.frontEndData.state.display;
            }
            if (this.informationMap.frontEndData.country) {
                showAddress = showAddress || this.informationMap.frontEndData.country.display;
            }
            if (this.informationMap.frontEndData.postalCode) {
                showAddress = showAddress || this.informationMap.frontEndData.postalCode.display;
            }
            return showAddress;
        } else {
            return false;
        }
    }

    get city() {
        return this.informationMap.frontEndData.city.display ? this.getRecordValue('city') : '';
    }

    get state() {
        return this.informationMap.frontEndData.state.display ? this.getRecordValue('state') : '';
    }

    get postalCode() {
        return this.informationMap.frontEndData.postalCode.display ? this.getRecordValue('postalCode') : '';
    }

    get country() {
        return this.informationMap.frontEndData.country.display ? this.getRecordValue('country') : '';
    }

    get jobPosterName() {
        return this.getRecordValue('jobPosterName');
    }

    get jobPosterCompany() {
        return this.getRecordValue('jobPosterCompany');
    }

    get jobPosterJobTitle() {
        return this.getRecordValue('jobPosterJobTitle');
    }

    get jobPosterEmail() {
        return this.getRecordValue('jobPosterEmail');
    }

    get jobPosterPhone() {
        return this.getRecordValue('jobPosterPhone');
    }

    get jobPosterDegree() {
        return this.getRecordValue('jobPosterDegree');
    }

    get hasContactInfo() {
        let returnValue = this.getRecordValue('hasContactInfo');
        if (returnValue == 'Yes') {
            return true;
        } else {
            return false;
        }
        //return this.getRecordValue('hasContactInfo');
    }

    get formattedStreet() {
        let streetLinePrefix = '';
        let street = this.informationMap.frontEndData.addressLine1.display ? this.getRecordValue('addressLine1') : '';
        let streetLine2 = this.informationMap.frontEndData.addressLine2.display ? this.getRecordValue('addressLine2') : '';
        let streetLine3 = this.informationMap.frontEndData.addressLine3.display ? this.getRecordValue('addressLine3') : '';

        if (street) {
            streetLinePrefix = ' ';
        }
        if (streetLine2) {
            street = street + streetLinePrefix + streetLine2;
            streetLinePrefix = ' ';
        }
        if (streetLine3) {
            street = street + streetLinePrefix + streetLine3;
        }

        return street;
    }

    get description() {
        return this.getRecordValue('description');
    }

    get qualification() {
        return this.getRecordValue('qualification');
    }

    get desiredSkills() {
        return this.getRecordValue('desiredSkills');
    }

    get desiredMajors() {
        return this.getRecordValue('desiredMajors');
    }

    get classDegreeLevel() {
        return this.getRecordValue('classDegreeLevel');
    }

    get positionType() {
        return this.getRecordValue('positionType');
    }

    get salary() {
        return this.getRecordValue('salary');
    }

    get workAuthorization() {
        return this.getRecordValue('workAuthorization');
    }

    get unofficialTranscript() {
        return this.getRecordValue('unofficialTranscript');
    }

    get isRemote() {
        return this.getRecordValue('isRemote');
    }

    get coverLetter() {
        return this.getRecordValue('coverLetter');
    }

    get multipleLocations() {
        return this.getRecordValue('multipleLocations');
    }

    get hoursPerWeek() {
        return this.getRecordValue('hoursPerWeek');
    }

    get isExternalSite() {
        return this.getRecordValue('isExternalSite') === 'Yes';
    }

    get externalLink() {
        return this.getRecordValue('externalLink');
    }
}