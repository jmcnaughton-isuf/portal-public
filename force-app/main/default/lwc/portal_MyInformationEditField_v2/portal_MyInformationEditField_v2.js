import { LightningElement, api } from 'lwc';
import { ComponentLogic, ComponentLogicBuilder } from './portal_MyInformationEditFieldHelper_v2';
export * from './portal_MyInformationEditFieldHelper_v2';

export default class Portal_MyInformationEditField_v2 extends LightningElement {
    @api label;
    @api value;
    @api fieldId;
    @api index;
    @api sectionId;
    @api inputType;
    @api isDisabled;
    @api isRequired;
    @api handleChangeCallback = () => {};

    // toggle parameters
    @api hasToggle;
    @api toggleValue;
    @api toggleField;

    // self report parameters
    @api hasSelfReportLink;
    @api hasPreviousSelfReport;
    @api handleSelfReport = () => {};

    // picklist specific parameters
    @api picklistValues;
    @api isNullOptionDisabled;

    // lookup specific parameters
    @api isLookup;
    @api lookupValue;
    @api lookupFieldId;
    @api customMetadataApiName;
    @api customMetadataDeveloperName;
    @api handleLookupSelectionCallback = () => {};
    _isHideLookupOptions = true;

    componentLogic = undefined;

    @api
    checkAndReportValidity() {
        return this.componentLogic.checkAndReportValidity();
    }

    connectedCallback() {
        this.componentLogic = new ComponentLogicBuilder().buildLightningElement(this).build();
    }

    renderedCallback() {
        let toggle = this.template.querySelector('.labelled-toggle-switch');
        let selfReport = this.template.querySelector('.edit-entry-list');

        if (toggle && selfReport) {
            toggle.classList.add('layered');
            selfReport.classList.add('layered');
        }
    }

    get isDate() {
        return this.inputType === 'date';
    }

    get isCheckbox() {
        return this.inputType === 'checkbox';
    }

    get isPicklist() {
        return this.inputType === 'picklist';
    }

    get isNullOptionEnabled() {
        return (!this.isNullOptionDisabled || this.isNullOptionDisabled === 'false')
    }

    get displaySettingList() {
        return this.componentLogic.displaySettingList();
    }

    handleChange = (event) => {
        this.componentLogic.handleChange(event);
    }

    updateToggleValue = (event) => {
        this.componentLogic.updateToggleValue(event);
    }

    // option is the selected lookup option of form {value: string, label: string}
    handleLookupSelection = (option) => {
        this.componentLogic.handleLookupSelection(option);
    }

    // lookup's <input> oninput handler
    handleLookupInput = (value) => {
        this.componentLogic.handleLookupInput(value);
    }
}