import {LightningElement, api, wire, track} from 'lwc';
import SERVER_getConstituentInformation from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getConstituentInformation'
import getInternationalAutocompleteConfigurationMap from '@salesforce/apex/PORTAL_LWC_AddressServiceHubController.SERVER_getInternationalAutocompleteConfigurationMap';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import constituentTemplate from './portal_OnlineGivingBillingDetailsOR.html';
import organizationTemplate from './portal_OnlineGivingBillingDetailsOROrganization.html';
import isguest from '@salesforce/user/isGuest';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import SERVER_getConstituentDetails from '@salesforce/apex/PORTAL_OnlineGivingCustomExtension.SERVER_getDonorIdConstituentInformation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import REVIEW_OBJECT from '@salesforce/schema/ucinn_ascendv2__Review_Transaction_v2__c';
import STATE_FIELD from '@salesforce/schema/ucinn_ascendv2__Review_Transaction_v2__c.Picklist_State__c';
import COUNTRY_FIELD from '@salesforce/schema/ucinn_ascendv2__Review_Transaction_v2__c.Picklist_Country__c';
export default class Portal_OnlineGivingBillingDetailsOR extends LightningElement {

    @api componentLabel;
    @api informationMap;
    @api pageName;
    @api pageSectionName;
    @api textColor;
    @api organizationInformationLabel;
    @api organizationalContactInformationLabel;
    @api hasAddressAutocomplete;
    @wire(MessageContext) messageContext;
    @track phoneNumberFormat ='';
    _subscription = null;
    _informationMap;
    _callbackDone = false;
    _page = 'giving';
    _picklists = {};
    _emailConfirmation = '';
    _emailConfirmationConstituent = '';
    _emailConfirmationOrganization = '';
    _matchingCompanyIntegration = '';
    _givingAsOrg = false;
    _autocompleteFieldNameMap = {'streetLine1': 'addressLine1', 'streetLine2': 'addressLine2', 'city': 'addressCity', 
                                'state': 'addressState', 'postalCode': 'addressPostalCode', 'country': 'addressCountry'};
    _autocompleteOrganizationFieldNameMap = {'streetLine1': 'organizationAddressLine1', 'streetLine2': 'organizationAddressLine2', 'city': 'organizationCity', 
                                    'state': 'organizationState', 'postalCode': 'organizationPostalCode', 'country': 'organizationCountry'};
    _hasInternationalAutocomplete = false;
    _countriesList = [];
    _addressCountryCode = '';
    _isCityInAutocomplete = true;
    _isPostalCodeInAutocomplete = true;
    _isStateInAutocomplete = true;
    _organizationCountryCode = '';
    _isCityInOrganizationAutocomplete = true;
    _isStateInOrganizationAutocomplete = true;
    _isPostalCodeInOrganizationAutocomplete = true;
    emailFormat = /^[\w\d.!#$%&'*+/=?^_`{|}~-]+@[\w\d-]+(?:\.[\w\d-]+)*$/;
    _isGuestUser = isguest;
    _keyword = '';
    _showModal = false;
    @track _showSpinner = false;
    @track contactCountryInput = true;
    _searchDonorList = [];
    _selectedDonorMap;
    @track countryList;
    @track usStateList;
    get countryOptions() {  
        this.countryList =  this.countryPicklist.data.values;
        
        return this.countryList;      

    }
    get MainStates() {
        this.usStateList = [];
        const defaultOpt = {label:'Select an Option',value:null};
        this.usStateList = [...this.usStateList,defaultOpt];
        this.usStateList = [...this.usStateList,...this.statePicklist.data.values];
        return this.usStateList;        
    }

    connectedCallback() {
        this.subscribeToMessageChannel();

        const urlParams = new URLSearchParams(window.location.search);
        let donorIdParam = urlParams?.get('donorId');
        let passCodeParam = urlParams?.get('passcode');

        const params = {'pageName': this.pageSectionName, 'donorId': donorIdParam, 'passcode': passCodeParam};
        Promise.all([callApexFunction(this, SERVER_getConstituentInformation, params, this.handleConstituentInformation, () => {})])
                    
        // Promise.all([callApexFunction(this, SERVER_getConstituentInformation, params, this.handleConstituentInformation, () => {}),
        //     this.hasAddressAutocomplete ? callApexFunction(this, getInternationalAutocompleteConfigurationMap, {}, this.handleInternationalAutocompleteConfiguration, () => {}) : () => {}])
        .finally(() => {this._callbackDone = true;});
        
    }

    handleConstituentInformation = (response) => {
        this.informationMap = JSON.parse(JSON.stringify(response));
        this._informationMap = Object.assign({}, this.informationMap);
        this.setRecordValueWithField('organizationCountry', 'US');
        this.checkValidity();
        publish(this.messageContext, onlineGivingChannel, {detail: this._informationMap, type: "billingDetails"});
    }
    handleInternationalAutocompleteConfiguration = (response) => {
        if (response.hasInternationalAutocomplete) {
            this._countriesList = Object.entries(response.countryCodeMap).map(([label, value]) => {return {'label': label, 'value': value}});

            let defaultCountryLabel = response.defaultCountry;
            this._addressCountryCode = response.countryCodeMap[defaultCountryLabel];
            this._organizationCountryCode = this._addressCountryCode;
            this.setRecordValueWithField('addressCountry', defaultCountryLabel);
            this.setRecordValueWithField('organizationCountry', defaultCountryLabel);

            this._hasInternationalAutocomplete = response.hasInternationalAutocomplete;
        }
    }

    @wire(getObjectInfo, { objectApiName: REVIEW_OBJECT })
    reviewMetadata;
    @wire(getPicklistValues,
        {
            recordTypeId: '$reviewMetadata.data.defaultRecordTypeId',
            fieldApiName: COUNTRY_FIELD
        }
    )
    countryPicklist;

    @wire(getPicklistValues,
        {
            recordTypeId: '$reviewMetadata.data.defaultRecordTypeId',
            fieldApiName:  STATE_FIELD
        }
    )
    statePicklist;

    renderedCallback() {
        if (this.isShowComponent) {
            this.checkValidity();
        }
    }

    disconnectedCallback() {
        unsubscribe(this._subscription);
        this._subscription = null;
    }

    subscribeToMessageChannel() {
        if (!this._subscription) {
            this._subscription = subscribe(
                this.messageContext,
                onlineGivingChannel,
                (message) => this.handleMessage(message),
            );
        }
    }

    handleMessage(message) {
        if (message.type == 'data-change') {
            if (this._page != message.detail['page']) {
                this._page = message.detail['page'];
            }
            this._matchingCompanyIntegration = message.detail['matchingCompanyIntegration'];
        }
        if (message.type == 'display-field-errors') {
            this.displayFieldErrors();
        }
        if (message.type == 'donor-change') {
            this._givingAsOrg = message.detail;
            if (this._givingAsOrg) {
                this._emailConfirmation = this._emailConfirmationOrganization;
            } else {
                this._emailConfirmation = this._emailConfirmationConstituent;
            }
        }
        if (message.type == 'beginValidation') {
            let valid =  this.checkValidity();

            publish(this.messageContext, onlineGivingChannel, {detail: valid, type: "billingDetailsCheckValidityResults"});
        }
    }

    render() {
        if (this._givingAsOrg) {
            return organizationTemplate;
        } else if (!this._givingAsOrg) {
            return constituentTemplate;
        }

        return constituentTemplate;
    }

    setKeyword(event) {
        this._keyword = event.currentTarget.value;

        this.template.querySelector('[data-name="keyword"]').setCustomValidity('');
        this.template.querySelector('[data-name="keyword"]').reportValidity();
    }

    handleDonorSearchClicked(event){
        this._showModal = true;
    }

    searchDonors(event) {
        if(!this._keyword || this._keyword.trim().length < 2) {
            if (this.template.querySelector('[data-name="keyword"]')) {
                this.template.querySelector('[data-name="keyword"]').setCustomValidity('keyword must be at least 2 characters long');
                this.template.querySelector('[data-name="keyword"]').reportValidity();
            }
            return;
        }
        const donorSearchParams = {'params':{"pageName": this.pageSectionName, "offset": 0, "keyword":this._keyword}};
        this._showSpinner = true;
        SERVER_getConstituentDetails(donorSearchParams).then(res => {
            this._searchDonorList = [];
            this._selectedDonorMap = JSON.parse(JSON.stringify(res));
            this.informationMap = this._selectedDonorMap;
            this._informationMap = Object.assign({}, this.informationMap);
            for (let record of this._informationMap['contactInformation']) {
                let conId = record['Id'];
                let fName = record['Name'];
                let dId = record['ucinn_ascendv2__Donor_ID__c'];
                this._searchDonorList.push({'Name': fName , 'Id' : conId, 'donorId': dId});
            }
        }).catch(error => {
            console.log(error);
            let errorMap = JSON.parse(error.body.message);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);

        }).finally(() => {
            this._callbackDone = true;
            this._showSpinner = false;
        })
    }

    handleSelectDonorClicked(event) {
        if(this._selectedDonorMap){
            this.informationMap = this._selectedDonorMap;
            this._informationMap = Object.assign({}, this.informationMap);
            let id = event.target.dataset.targetId;
            this.checkValidity();
            publish(this.messageContext, onlineGivingChannel, {detail: this._informationMap, type: "billingDetails"});
            publish(this.messageContext, onlineGivingChannel, {detail: id, type: "contactId"});
        }
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        }, 1000);
        this._showModal = false;
    }

    closeModal(event) {
        this._showModal = false;
    }

    get isShowComponent() {
        return this._page == this.pageName;
    }

    get headerStyle() {
        return "font-weight: bold;" + 'color: ' + this.textColor + ';';
    }

    get addressAutocompleteFlexGrid() {
        return this._hasInternationalAutocomplete ? 'flex-grid-3' : 'flex-grid';
    }

    get addressAutocompleteStyle() {
        return 'padding-right: 0;' + (this._hasInternationalAutocomplete ? ' flex: 1 1 66.7% !important; max-width: 100%;' : '');
    }
    
    get addressRegionFlexGrid() {
        return this._hasInternationalAutocomplete ? 'flex-grid-4' : 'flex-grid-3';
    }

    get firstName() {
        return this.getNullCheckedRecordValue("firstName");
    }

    get middleName() {
        return this.getNullCheckedRecordValue("middleName");
    }

    get lastName() {
        return this.getNullCheckedRecordValue("lastName");
    }
    
    get suffix() {
        return this.getNullCheckedRecordValue("suffix");
    }

    get emailType() {
        return this.getNullCheckedRecordValue("emailType");
    }

    get phoneNumber() {
        return this.getNullCheckedRecordValue("phoneNumber");
    }

    get phoneType() {
        return this.getNullCheckedRecordValue("phoneType");
    }

    get addressCountry() {
        return this.getNullCheckedRecordValue("addressCountry");
    }

    get addressCity() {
        return this.getNullCheckedRecordValue("addressCity");
    }

    get addressLine1() {
        return this.getNullCheckedRecordValue("addressLine1");
    }

    get addressLine2() {
        return this.getNullCheckedRecordValue("addressLine2");
    }

    get addressState() {
        return this.getNullCheckedRecordValue("addressState");
    }

    get addressPostalCode() {
        return this.getNullCheckedRecordValue("addressPostalCode");
    }

    get addressType() {
        return this.getNullCheckedRecordValue("addressType");
    }

    get organizationName() {
        return this.getNullCheckedRecordValue("organizationName");
    }

    get organizationEmailType() {
        return this.getNullCheckedRecordValue("organizationEmailType");
    }

    get organizationPhoneNumber() {
        return this.getNullCheckedRecordValue("organizationPhoneNumber");
    }

    get organizationPhoneType() {
        return this.getNullCheckedRecordValue("organizationPhoneType");
    }

    get organizationAddressLine1() {
        return this.getNullCheckedRecordValue("organizationAddressLine1");
    }

    get organizationAddressLine2() {
        return this.getNullCheckedRecordValue("organizationAddressLine2");
    }

    get organizationCity() {
        return this.getNullCheckedRecordValue("organizationCity");
    }

    get organizationState() {
        return this.getNullCheckedRecordValue("organizationState");
    }

    get organizationPostalCode() {
        return this.getNullCheckedRecordValue("organizationPostalCode");
    }

    get organizationCountry() {
        return this.getNullCheckedRecordValue("organizationCountry");
    }

    get organizationAddressType() {
        return this.getNullCheckedRecordValue("organizationAddressType");
    }

    get organizationalContactFirstName() {
        return this.getNullCheckedRecordValue("organizationalContactFirstName");
    }

    get organizationalContactMiddleName() {
        return this.getNullCheckedRecordValue("organizationalContactMiddleName");
    }

    get organizationalContactLastName() {
        return this.getNullCheckedRecordValue("organizationalContactLastName");
    }

    get organizationalContactTitle() {
        return this.getNullCheckedRecordValue("organizationalContactTitle");
    }

    get organizationalContactPhone() {
        return this.getNullCheckedRecordValue("organizationalContactPhone");
    }

    get organizationalContactPhoneType() {
        return this.getNullCheckedRecordValue("organizationalContactPhoneType");
    }

    get organizationalContactEmail() {
        return this.getNullCheckedRecordValue("organizationalContactEmail");
    }

    get organizationalContactEmailType() {
        return this.getNullCheckedRecordValue("organizationalContactEmailType");
    }

    get emailAddress() {
        if (this._givingAsOrg) {
            return this.getNullCheckedRecordValue('organizationEmail');
        }

        return this.getNullCheckedRecordValue('emailAddress');
    }

    get emailTypePicklist() {
        let resultList = [...this.informationMap.picklists.emailType]
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }

    get phoneTypePicklist() {
       // let resultList = [...this.informationMap.picklists.phoneType];
        //console.log('result list:: ',resultList);
        let resultList = [{'label':'Home - Cell', 'value':'Home - Cell'},{'label':'Home - Landline', 'value':'Home - Landline'},{'label':'Business - Cell', 'value':'Business - Cell'},{'label':'Business - Landline', 'value':'Business - Landline'}];
        //resultList.unshift({label: 'Select an Option', value: ''});
        return resultList;
    }

    get addressTypePicklist() {
        let resultList = [...this.informationMap.picklists.addressType];
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }

    get organizationEmailTypePicklist() {
        let resultList = [...this.informationMap.picklists.organizationEmailType]
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }

    get organizationPhoneTypePicklist() {
        let resultList = [...this.informationMap.picklists.organizationPhoneType];
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }

    get organizationAddressTypePicklist() {
        let resultList = [...this.informationMap.picklists.organizationAddressType];
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }

    get organizationalContactEmailTypePicklist() {
        let resultList = [...this.informationMap.picklists.organizationalContactEmailType]
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }

    get organizationalContactPhoneTypePicklist() {
        let resultList = [...this.informationMap.picklists.organizationalContactPhoneType];
        resultList.unshift({label: 'Select an Option', value: ''});

        return resultList;
    }
    get addressCityRequired() {
        return this.informationMap.frontEndData.addressCity.isRequired && this._isCityInAutocomplete;
    }

    get addressPostalCodeRequired() {
        return this.informationMap.frontEndData.addressPostalCode.isRequired && this._isPostalCodeInAutocomplete;
    }

    get addressStateRequired() {
        return this.informationMap.frontEndData.addressState.isRequired && this._isStateInAutocomplete;
    }

    get organizationCityRequired() {
        return this.informationMap.frontEndData.organizationCity.isRequired && this._isCityInOrganizationAutocomplete;
    }

    get organizationPostalCodeRequired() {
        return this.informationMap.frontEndData.organizationPostalCode.isRequired && this._isPostalCodeInOrganizationAutocomplete;
    }

    get organizationStateRequired() {
        return this.informationMap.frontEndData.organizationState.isRequired && this._isStateInOrganizationAutocomplete;
    }



    get phoneExt() {
        return this.getNullCheckedRecordValue('phoneExt');
    }

    getNullCheckedRecordValue(field) {
        let recordValue = this.getRecordValue(field);

        if (!recordValue) {
            return '';
        }

        return recordValue;
    }

    getRecordValue(field)  {
        let mainSection = this.informationMap.frontEndData[field].mainSection;
        let subSection = this.informationMap.frontEndData[field].subSection;
        let fieldName = this.informationMap.frontEndData[field].fieldName;
        let filterValue = this.informationMap.frontEndData[field].filterValue;
        let filterField = this.informationMap.frontEndData[field].filterField;
        let isPicklist = this.informationMap.frontEndData[field].isPicklist;
        if (!subSection) {
            subSection = 'records';
        }

        try {
            if (!isPicklist) {
                if (filterValue) {
                    for (let record of this._informationMap['records'][mainSection][subSection]) {
                        if (record[filterField] == filterValue) {
                            if (fieldName.includes('.')) {
                                let fields = fieldName.split('.');
                                return record[fields[0]][fields[1]]
                            }
                            return record[fieldName];
                        }
                    }
                } else {
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0] && this._informationMap['records'][mainSection][subSection][0][fields[0]]) {
                            return this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]
                        }
                        return "";
                    }
                    if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0]) {
                        return this._informationMap['records'][mainSection][subSection][0][fieldName];
                    }   
                    return "";
                }
            } else {
                for (let picklistValue of this.informationMap.picklists[field]) {
                   
        
                    if (filterValue) {
                        for (let record of this._informationMap['records'][mainSection][subSection]) {
                            if (record[filterField] == filterValue) {
                                if (fieldName.includes('.')) {
                                    let fields = fieldName.split('.');
                                    if (picklistValue.value == record[fields[0]][fields[1]]) {
                                        return picklistValue.label;
                                    }
                                }
                                if (picklistValue.value == record[fieldName]) {
                                    return picklistValue.label;
                                }
                            }
                        }
                    } else {
                        if (fieldName.includes('.')) {
                            let fields = fieldName.split('.');
                            if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0] && this._informationMap['records'][mainSection][subSection][0][fields[0]] && picklistValue.value ==  this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]) {
                                return picklistValue.label;
                            }
                        }
                        if (this._informationMap && this._informationMap['records'] && this._informationMap['records'][mainSection] && this._informationMap['records'][mainSection][subSection] && this._informationMap['records'][mainSection][subSection][0] && picklistValue.value == this._informationMap['records'][mainSection][subSection][0][fieldName]) {
                            return picklistValue.label;
                        }
                    }
                    
                }
           }
        } catch (e) {
        }
        return "";
    }

    setEmailValue(event) {
        if (event.currentTarget.getAttribute('name') == 'emailConfirm') {
            if (this._givingAsOrg) {
                this._emailConfirmationOrganization = event.currentTarget.value;
                this._emailConfirmation = this._emailConfirmationOrganization;
            } else {
                this._emailConfirmationConstituent = event.currentTarget.value;
                this._emailConfirmation = this._emailConfirmationConstituent;
            }
            this.checkEmailConfirmation();
        } else {
            this.setRecordValueWithField(event.currentTarget.getAttribute('name'), event.currentTarget.value);
        }
    }

    clearValidity(event) {
        event.target.setCustomValidity('');
    }

    checkEmailConfirmation() {
        let email = this.emailAddress;

        if (this._emailConfirmation || email) {
            if (this._emailConfirmation != email) {
                if (this.template.querySelector('[name="emailConfirm"]')) {
                    //this.template.querySelector('[name="emailConfirm"]').setCustomValidity('Emails do not match');
                }
            } else {
                if (this.template.querySelector('[name="emailConfirm"]')) {
                    //this.template.querySelector('[name="emailConfirm"]').setCustomValidity('');
                    //this.template.querySelector('[name="emailConfirm"]').reportValidity();
                }
            }
        } else if (!email && !this._emailConfirmation){
            if (this.template.querySelector('[name="emailConfirm"]')) {
                //this.template.querySelector('[name="emailConfirm"]').setCustomValidity('');
            }
        }
    }

    handleCountrySelection = (event) => {
        let select = event.currentTarget;
        let countryCode = select.value;
        let label = select.options[select.selectedIndex].text;

        if (this._givingAsOrg) {
            this._organizationCountryCode = countryCode;
            this._isCityInOrganizationAutocomplete = true;
            this._isStateInOrganizationAutocomplete = true;
            this._isPostalCodeInOrganizationAutocomplete = true;
        }
        else {
            this._addressCountryCode = countryCode;
            this._isCityInAutocomplete = true;
            this._isStateInAutocomplete = true;
            this._isPostalCodeInAutocomplete = true;
        }
        this.setRecordValueWithField(select.getAttribute('name'), label);
    }
    
    handleAddressSelection = (selectedAddress) => {
        let fieldMap = this._givingAsOrg ? this._autocompleteOrganizationFieldNameMap : this._autocompleteFieldNameMap;
        for (let [addressWrapperField, value] of Object.entries(selectedAddress)) {
            let billingFormField = fieldMap[addressWrapperField];
            if (billingFormField) {
                this.setRecordValueWithField(billingFormField, value);

                if (this._givingAsOrg) {
                    if (addressWrapperField === 'state') {
                        this._isStateInOrganizationAutocomplete = value !== '';
                    }
                    else if (addressWrapperField === 'postalCode') {
                        this._isPostalCodeInOrganizationAutocomplete = value !== '';
                    }
                    else if (addressWrapperField === 'city') {
                        this._isCityInOrganizationAutocomplete = value !== '';
                    }
                }
                else {
                    if (addressWrapperField === 'state') {
                        this._isStateInAutocomplete = value !== '';
                    }
                    else if (addressWrapperField === 'postalCode') {
                        this._isPostalCodeInAutocomplete = value !== '';
                    }
                    else if (addressWrapperField === 'city') {
                        this._isCityInAutocomplete = value !== '';
                    }
                }
            }
        }
    }

    setRecordValue = (event) => {
        this.setRecordValueWithField(event.currentTarget.getAttribute('name'), event.currentTarget.value);

        if (event.currentTarget.checkValidity() === false) {
            event.currentTarget.reportValidity();
        }
    }

    setRecordValueWithField = (field, fieldValue) => {
        let mainSection = this.informationMap.frontEndData[field].mainSection;
        let subSection = this.informationMap.frontEndData[field].subSection;
        let filterValue = this.informationMap.frontEndData[field].filterValue;
        let filterField = this.informationMap.frontEndData[field].filterField;
        let fieldName = this.informationMap.frontEndData[field].fieldName;
        if (!subSection) {
            subSection = 'records';
        }
        if((field == 'addressCountry' || field == 'organizationCountry') && fieldValue != 'US'){
            this.contactCountryInput = false;
        } else if (field == 'addressCountry' && fieldValue == 'US') {
            this.contactCountryInput = true;
        }
        if(fieldName == 'ucinn_ascendv2__Phone_Number__c') {
            let formatPhoneNumber = fieldValue.replaceAll("-", "").trim();
            //formatPhoneNumber = formatPhoneNumber.replaceAll("\\D+", "");
            //if(!fieldValue || isNaN(fieldValue)) return 'input must be a number was sent ${fieldValue}';

            //if(typeof(formatPhoneNumber) !== 'string') formatPhoneNumber = formatPhoneNumber.toString();
            if(formatPhoneNumber.length === 10){
                formatPhoneNumber =  formatPhoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
            } else if(formatPhoneNumber.length === 6) {
                formatPhoneNumber =  formatPhoneNumber.replace(/(\d{3})(\d{3})/, "$1-$2");
            } else if(formatPhoneNumber.length === 3) {
                formatPhoneNumber =  formatPhoneNumber.replace(/(\d{3})/, "$1-");
            }else {
                formatPhoneNumber =  formatPhoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
            }
            this.phoneNumberFormat = formatPhoneNumber;
        }
        if (!this._informationMap['records'][mainSection]) {
            this._informationMap['records'][mainSection] = {};
            this._informationMap['records'][mainSection][subSection] = [];
        } 

        if (!this._informationMap['records'][mainSection][subSection]) {
            this._informationMap['records'][mainSection][subSection] = [];
        }

        try {
            if (filterValue) {
                let hasRecord = false;
                for (let record of this._informationMap['records'][mainSection][subSection]) {
                    if (record[filterField] == filterValue) {
                        hasRecord = true;
                        if (fieldName.includes('.')) {
                            let fields = fieldName.split('.');
                            record[fields[0]][fields[1]] = fieldValue;
                        } else {
                            record[fieldName] = fieldValue;
                        }
                        
                    }
                } 
                if (!hasRecord) {
                    let record = {Id: null};
                    record[filterField] = filterValue;
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        record[fields[0]][fields[1]] = fieldValue;
                    } else {
                        record[fieldName] = fieldValue;
                    }
                    this._informationMap['records'][mainSection][subSection] = [...this._informationMap['records'][mainSection][subSection], record];

                }
            } else {
                if (this._informationMap['records'][mainSection][subSection].length <= 0) {
                    let record = {Id: null};
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        if (record[fields[0]]) {
                            record[fields[0]][fields[1]] = fieldValue;
                        } else {
                            record[fields[0]] = {};
                            record[fields[0]][fields[1]] = fieldValue;
                        }
                    } else {
                        record[fieldName] = fieldValue;
                    }
                    this._informationMap['records'][mainSection][subSection] = [...this._informationMap['records'][mainSection][subSection], record];
                } else {
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        if (!this._informationMap['records'][mainSection][subSection][0][fields[0]]) {
                            this._informationMap['records'][mainSection][subSection][0][fields[0]] = {};
                        }

                        this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]] = fieldValue;
                    } else {
                        this._informationMap['records'][mainSection][subSection][0][fieldName] = fieldValue;
                    }
                    this._informationMap['records'][mainSection][subSection][0] = {...this._informationMap['records'][mainSection][subSection][0]}
                    this._informationMap = JSON.parse(JSON.stringify(this._informationMap));

                }
                
            }
            publish(this.messageContext, onlineGivingChannel, {detail: this._informationMap, type:"billingDetails"});
            this.checkValidity();
        } catch (e) {
        }
        return "";
    }

    displayFieldErrors() {
        if (!this.checkEmailConfirmation()) {
            return;
        }

        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                if (elements[index].checkValidity() === false) {
                    elements[index].reportValidity();
                    return;
                }
            }
        }
    }

    checkValidity() {
        //this.checkEmailConfirmation();

        let valid = true;
        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                valid = valid && elements[index].checkValidity();
            }
        }
        valid = valid;// && (this._emailConfirmation == this.emailAddress);

        let isEmailRequired = this._givingAsOrg ? this.informationMap.frontEndData.organizationEmail.isRequired : this.informationMap.frontEndData.emailAddress.isRequired;

        valid = valid;// && (this._emailConfirmation == this.emailAddress);
        if (isEmailRequired && !this.emailAddress) {
            valid = false;
        }

        valid = valid;// && (this._emailConfirmation == this.emailAddress);

        publish(this.messageContext, onlineGivingChannel, {detail: valid, type:"billingValidity"});

        return valid;
    }
}