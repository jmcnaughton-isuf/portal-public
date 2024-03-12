import { LightningElement, api, track, wire } from 'lwc';
import SERVER_getCreateJobPostingFrontEndData from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getCreateJobPostingFrontEndData';
import SERVER_getPicklists from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getPicklists';
import SERVER_submitJobPosting from '@salesforce/apex/PORTAL_JobBoardController.SERVER_submitJobPosting';
import SERVER_getContactInfo from '@salesforce/apex/PORTAL_JobBoardController.SERVER_getContactInfo';
import getIsRecaptchaEnabled from '@salesforce/apex/PORTAL_LWC_RecaptchaController.SERVER_getIsRecaptchaEnabled';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { submitForm } from 'c/portal_Recaptcha';

export default class Portal_CreateJobPosting extends LightningElement {

    _job = {};
    _isShowComponent = false;
    @api frontEndData;
    @api picklists;
    @api job;
    @api contact;
    @api degreeList;
    @api contentPageName;
    @api contentModuleName;
    @api pageName = 'Job Posting';
    @api mainSectionName = 'Job';

    _isRecaptchaEnabled = false;
    _agreementClause = 'I agree to the terms of service.';
    _messageOnInvalidInput = 'Please fill out this field.';
    _messageOnInvalidEmail = 'Please enter a valid email address (Example: \'email@example.com\').';
    _agree = false;
    _isShowSpinner = false;
    _isValidDescription = true;
    _isValidDesiredMajors = true;
    _isValidDesiredSkills = true;
    _isValidQualifications = true;  

    @wire(getIsRecaptchaEnabled, {params: {'classFunctionName': 'PORTAL_JobBoardControllerBase.submitJobPosting'}})
    setRecaptchaEnabled({error, data}) {
        if (error) {
            console.log(error);
        }

        this._isRecaptchaEnabled = data;
    }

    @api handleClose = (saved) => {
        
    };
    
    @api handleUpdateModalSpinner = () => {}

    @track _isSubmittingJobPost = false;
    
    connectedCallback() {
        if (this.job) {
            this._job = JSON.parse(JSON.stringify(this.job));
        }
        const params = {params:{}};
        const dataParams = {params:{contentModuleName:this.contentModuleName, contentPageName:this.contentPageName, pageName: this.pageName, mainSectionName: this.mainSectionName}};
        SERVER_getCreateJobPostingFrontEndData(dataParams).then(res => {
            this.frontEndData = res['frontEndData'];
            if (res['agreement']) {
                this._agreementClause = res['agreement']['clause'];
            }
            SERVER_getPicklists(params).then(res => {
                this.picklists = res;
                SERVER_getContactInfo(params).then(res => {
                    if (res && res.Degrees && res.Degrees.records) {
                        this.degreeList = res.Degrees.records;
                    }
                    if (res && res.Personal_Information && res.Personal_Information.records && res.Personal_Information.records.length > 0) {
                        this.contact = res.Personal_Information.records[0];
                        if (Object.keys(this.job).length === 0) {
                            this._job['Job_Poster_Name__c'] = this.contact.Name;
                            this._job['Job_Poster_Phone__c'] = this.contact.Phone;
                            this._job['Job_Poster_Email__c'] = this.contact.Email;
                            this._job['Job_Poster_School_Degree__c'] = this.getDegreeString();
                        }
                    }
                    this._isShowComponent = true;
                }).catch(error => {
                    console.log(error);
                })
            }).catch(error => {
                console.log(error);
            });
        }).catch(error => {
            console.log(error);
        });

    }

    get hasAgree() {
        if (this.contentModuleName) {
            return true;
        } else {
            return false;
        }
    }

    get isAgree() {
        return this._agree;
    }

    get companyName() {
        return this.getRecordValue('companyName');
    }

    get isExternal() {
        return this.getRecordValue('isExternal');
    }

    get externalLink() {
        return this.getRecordValue('externalLink');
    }

    get isShowExternalLink() {
        return this.frontEndData.externalLink.display && this.getRecordValue('isExternal');
    }

    get expirationDate() {
        return this.getRecordValue('expirationDate');
    }

    get addressLine1() {
        return this.getRecordValue('addressLine1');
    }

    get addressLine2() {
        return this.getRecordValue('addressLine2');
    }

    get addressLine3() {
        return this.getRecordValue('addressLine3');
    }

    get city() {
        return this.getRecordValue('city');
    }

    get state() {
        return this.getRecordValue('state');
    }

    get country() {
        return this.getRecordValue('country');
    }

    get postalCode() {
        return this.getRecordValue('postalCode');
    }

    get multipleLocations() {
        return this.getRecordValue('multipleLocations');
    }

    get isRemote() {
        return this.getRecordValue('isRemote');
    }

    get positionType() {
        return this.getRecordValue('positionType');
    }

    get jobName() {
        return this.getRecordValue('jobName');
    }

    get description() {
        return this.getRecordValue('description');
    }

    get qualification() {
        return this.getRecordValue('qualification');
    }

    get coverLetter() {
        return this.getRecordValue('coverLetter');
    }

    get unofficialTranscript() {
        return this.getRecordValue('unofficialTranscript');
    }

    get workAuthorization() {
        return this.getRecordValue('workAuthorization');
    }

    get salary() {
        return this.getRecordValue('salary');
    }

    get hoursPerWeek() {
        return this.getRecordValue('hoursPerWeek');
    }

    get classDegreeLevel() {
        return this.getRecordValue('classDegreeLevel');
    }

    get desiredSkills() {
        return this.getRecordValue('desiredSkills');
    }

    get desiredMajors() {
        return this.getRecordValue('desiredMajors');
    }

    get hasContactInfo() {
        return this.getRecordValue('hasContactInfo');
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

    get jobPosterPhone() {
        return this.getRecordValue('jobPosterPhone');
    }

    get jobPosterEmail() {
        return this.getRecordValue('jobPosterEmail');
    }

    get jobPosterSchoolDegree() {
        return this.getRecordValue('jobPosterSchoolDegree');
    }

    get currentDate() {
        let today = new Date();
        today.setDate(today.getDate());
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0');
        let yyyy = today.getFullYear();
        today = yyyy + "-" + mm + "-" + dd;
        return today;
    }

    get isDisableSubmit() {
        return (this._job.Status__c == 'Pending Edit') || this._isSubmittingJobPost;
    }

    get submitButtonClasses() {
        if (!this.isDisableSubmit) {
            return 'button primary';
        }

        return 'button primary disabled';
    }

    getRecordValue(fieldId) {
        let fieldName = this.frontEndData[fieldId].fieldName;
        let fieldType = this.frontEndData[fieldId].fieldType;
        let isPicklist = this.frontEndData[fieldId].isPicklist;
        if (isPicklist) {
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
                return this._job[fieldName];
            }
            if (fieldType == 'checkbox') {
                return false;
            }
            return '';
        }

    }

    getDegreeString() {
        let degreeString = '';
        if (this.degreeList) {
            this.degreeList.forEach(degree => {
                if (degree.ucinn_ascendv2__Degree__c && degree.ucinn_ascendv2__Conferred_Degree_Year__c) {
                    if (degreeString) {
                        degreeString = degreeString + ';' + degree.ucinn_ascendv2__Degree__c + ",'" +degree.ucinn_ascendv2__Conferred_Degree_Year__c.slice(-2);
                    } else {
                        degreeString =  degree.ucinn_ascendv2__Degree__c + ",'" +degree.ucinn_ascendv2__Conferred_Degree_Year__c.slice(-2);
                    }
                }
            })
        }

        return degreeString;
    }

    setRecordValue = (event) => {
        let fieldId = event.currentTarget.name;
        let fieldName = this.frontEndData[fieldId].fieldName;
        if (this.frontEndData[fieldId].fieldType == 'checkbox') {
            this._job[fieldName] = event.currentTarget.checked;
            this._job = {...this._job};
        } else {
            this._job[fieldName] = event.currentTarget.value;
            this._job = {...this._job};
        }
        event.currentTarget.setCustomValidity("");
    }

    checkInputValidity() {
        let inputs = this.template.querySelectorAll('input');
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

        if (this._job['Job_Poster_Email__c'] && this._job['Has_Contact_Information__c']) {
            validity = this.hasValidEmailInput() && validity;
        }

        return this.hasValidRichTextInput() && validity;
    }

    hasValidEmailInput() {
        let validity = true;

        let email = this.template.querySelector('[name="jobPosterEmail"]');
        let emailVal = email.value;

        // Email validation regex, this would accept any string that follows the rules of:
        // Must have non-empty name and domain strings separated by a single '@' character (cannot have more than 1 '@')
        // Domain string must also have two non-empty strings separated by a '.', such as name@domain.part
        const validEmailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailVal.match(validEmailRegex)) {
            email.setCustomValidity(this._messageOnInvalidEmail);
            validity = false;
        } else {
            email.setCustomValidity("");
        }

        email.reportValidity();
        return validity;
    }

    hasValidRichTextInput() {
        let validity = true;

        if (this.frontEndData.description.display && this.frontEndData.description.isRequired) {
            this._isValidDescription = this.description ? true : false;
            if (validity == true && !this._isValidDescription) {
                validity = this._isValidDescription;
            }
        }
        if (this.frontEndData.desiredMajors.display && this.frontEndData.desiredMajors.isRequired) {
            this._isValidDesiredMajors = this.desiredMajors ? true : false;
            if (validity == true && !this._isValidDesiredMajors) {
                validity = this._isValidDesiredMajors;
            }
        }
        if (this.frontEndData.desiredSkills.display && this.frontEndData.desiredSkills.isRequired) {
            this._isValidDesiredSkills = this.desiredSkills ? true : false;
            if (validity == true && !this._isValidDesiredSkills) {
                validity = this._isValidDesiredSkills;
            }
        }
        if (this.frontEndData.qualification.display && this.frontEndData.qualification.isRequired) {
            this._isValidQualifications = this.qualification ? true : false;
            if (validity == true && !this._isValidQualifications) {
                validity = this._isValidQualifications;
            }
        }

        return validity;
    }


    handleSubmit(event) {
        let isValidInput = this.checkInputValidity();
        if (!isValidInput) {
            return;
        }

        this.handleUpdateModalSpinner(true);

        this._isSubmittingJobPost = true;
      
        if (!this._job['Has_Contact_Information__c']) {
            this._job['Job_Poster_Name__c'] = '';
            this._job['Job_Poster_Phone__c'] = '';
            this._job['Job_Poster_Email__c'] = '';
            this._job['Job_Poster_School_Degree__c'] = '';
            this._job['Job_Poster_Job_Title__c'] = '';
            this._job['Job_Poster_Company__c'] = '';
        }

        // deleting the date field altogether 
        // when there's no value since apex
        // cannot deserialize empty value for date
        if (!this._job['Expiration_Date__c']) {
            delete this._job['Expiration_Date__c'];
        }

        if (this.contentModuleName && !this._agree) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Please fill out all fields.',
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);

            this._isSubmittingJobPost = false;
            this.handleUpdateModalSpinner(false);

        } else {
            submitForm(this, this.submissionLogic, (error) => {
                console.log(error);
                this._isSubmittingJobPost = false;  
                this.handleUpdateModalSpinner(false);
            });
        }
    }

    submissionLogic = (recaptchaToken, errorRecaptchaCallback) => {
        const params = {jobRecord: this._job, recaptchaToken: recaptchaToken};

        callApexFunction(this, SERVER_submitJobPosting, params, () => {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Job posted successfully!',
                variant:"success",
                mode:"sticky"
            });

            this.dispatchEvent(event);

            this.handleUpdateModalSpinner(false);
            this.handleClose(true);

            window.location.reload();
        }, (error) => {
            console.log(error);
            this._isSubmittingJobPost = false;  
            this.handleUpdateModalSpinner(false);
            errorRecaptchaCallback();
        });
    }

    handleCancel(event) {
        this.handleClose(false);
    }
}