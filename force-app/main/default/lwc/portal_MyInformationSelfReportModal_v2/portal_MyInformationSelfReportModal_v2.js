import { LightningElement, api, track } from 'lwc';
import singleFieldTemplate from './portal_MyInformationSelfReportSingleFieldModal_v2.html';
import schoolDegreeTemplate from './portal_MyInformationSelfReportSchoolDegreeModal_v2.html';
import nonSchoolDegreeTemplate from './portal_MyInformationSelfReportNonSchoolDegreeModal_v2.html';
import emailTemplate from './portal_MyInformationSelfReportEmailModal_v2.html';
import phoneTemplate from './portal_MyInformationSelfReportPhoneModal_v2.html';
import addressTemplate from './portal_MyInformationSelfReportAddressModal_v2.html';
import employmentTemplate from './portal_MyInformationSelfReportEmploymentModal_v2.html';
import socialMediaTemplate from './portal_MyInformationSelfReportSocialMediaModal_v2.html';

import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationSelfReportModalHelper_v2';
export * from './portal_MyInformationSelfReportModalHelper_v2';

export default class Portal_MyInformationSelfReportModal_v2 extends LightningElement {
    @api modalType;         // specifies HTML template
    @api configuration;     // either field or section configuration map
    @api fieldId;           // only needed for single field design
    @api selfReportRecord;
    @api saveParams;        // contains info needed only for the save callout
    @api helperRichText;
    @api handleClose = () => {};

    @track _isShowSpinner = false;

    componentLogic = undefined;
    isDeletedValue = '%isDeleted%';

    connectedCallback() {
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this).build();
    }

    render() {
        switch (this.modalType) {
            case 'field':
                return singleFieldTemplate;
            case 'schoolDegrees':
                return schoolDegreeTemplate;
            case 'nonSchoolDegrees':
                return nonSchoolDegreeTemplate; 
            case 'emails':
                return emailTemplate;
            case 'phones':
                return phoneTemplate;
            case 'addresses':
                return addressTemplate;
            case 'employment':
                return employmentTemplate;
            case 'socialMedia':
                return socialMediaTemplate;
            default:
                return singleFieldTemplate;
        }
    }

    get fieldValue() {
        return this.componentLogic.fieldValue;
    }

    handleChange = (value, fieldId) => {
        this.componentLogic.handleChange(value, fieldId);
    }

    handleLookupSelection = (option, fieldId, recordIndex, sectionId, lookupFieldId) => {
        this.componentLogic.handleLookupSelection(option, fieldId, recordIndex, sectionId, lookupFieldId);
    }

    updateToggleValue = (event) => {
        this.componentLogic.updateToggleValue(event);
    }

    handleCancel = (event) => {
        this.componentLogic.handleCancel(event);
    }

    handleSave = (event) => {
        this.componentLogic.handleSave(event);
    }
}