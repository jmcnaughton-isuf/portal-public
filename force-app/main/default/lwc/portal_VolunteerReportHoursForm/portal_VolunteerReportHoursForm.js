import { LightningElement, wire, api, track } from 'lwc';
import initializeReportHoursForm  from '@salesforce/apex/PORTAL_LWC_VolunteerReportHoursForm.SERVER_initializeReportHoursForm';
import reportVolunteerHours from '@salesforce/apex/PORTAL_LWC_VolunteerReportHoursForm.SERVER_reportVolunteerHours';
import { getFormInfo, checkFormValidity, reportFormValidity } from 'c/portal_util_FormFunctions';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_VolunteerReportHoursForm extends LightningElement {
    @api pageName = 'Volunteer Information';
    @api mainSectionName = 'Volunteer Report Form';
    @api recordId;
    @api closeModal = () => {};
    @api refreshParent = () => {};

    @track _frontEndDataMap;
    @track _fieldList = [];
    @track _valueChangeMap = {};
    @track _showSpinner = false;
    @track _formData = {};
    @track _headingInfo;

    connectedCallback() {
        this._showSpinner = true;

        callApexFunction(this, initializeReportHoursForm, {pageName: this.pageName, mainSectionName: this.mainSectionName, recordId: this.recordId},
        (data) => {
            this._formData = data.formData;
            this._headingInfo = data.headingInfo;
            this._headingInfo.startDateTime = Date.parse(this._headingInfo.startDateTime);
            this._headingInfo.endDateTime = Date.parse(this._headingInfo.endDateTime);
            this._formData.heading = '';

            if (!this._formData.formRowList[0].formFieldList[0].value) {
                this._formData = null;
            }

            this._showSpinner = false;
        }, (e) => {this._showSpinner = false;});
    }

    handleSubmit = () => {
        if (!checkFormValidity(this)) {
            reportFormValidity(this);
            return;
        }

        let formInfo = getFormInfo(this);
        
        this._showSpinner = true;
        callApexFunction(this, reportVolunteerHours, {pageName: this.pageName, mainSectionName: this.mainSectionName, formData: formInfo},
        () => {
            this._showSpinner = false;
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'You have successfully reported your hours.',
                variant:"success",
                mode:"sticky"
            });
            this._isShowSpinner = false;
            this.dispatchEvent(event);

            this.refreshParent();
            this.closeModal();
            this._showSpinner = false;
        }, () => {
            this._showSpinner = false;
        });
    }
}