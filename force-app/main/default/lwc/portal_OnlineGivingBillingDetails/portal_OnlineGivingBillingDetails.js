import { LightningElement, api, wire } from 'lwc';
import SERVER_getConstituentInformation from '@salesforce/apex/PORTAL_OnlineGivingController.SERVER_getConstituentInformation';
import getInternationalAutocompleteConfigurationMap from '@salesforce/apex/PORTAL_LWC_AddressServiceHubController.SERVER_getInternationalAutocompleteConfigurationMap';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { publish, MessageContext, subscribe, APPLICATION_SCOPE, unsubscribe } from 'lightning/messageService';
import onlineGivingChannel from '@salesforce/messageChannel/onlineGivingChannel__c';
import constituentTemplate from './portal_OnlineGivingBillingDetails.html';
import organizationTemplate from './portal_OnlineGivingBillingDetailsOrganization.html';
export default class Portal_OnlineGivingBillingDetails extends LightningElement {

    @api componentLabel;
    @api informationMap;
    @api pageName;
    @api pageSectionName;
    @api textColor;
    @api organizationInformationLabel;
    @api organizationalContactInformationLabel;
    @api hasAddressAutocomplete;
    @wire(MessageContext) messageContext;
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

    connectedCallback() {
        this.subscribeToMessageChannel();

        const urlParams = new URLSearchParams(window.location.search);
        let donorIdParam = urlParams?.get('donorId');
        let passCodeParam = urlParams?.get('passcode');

        const params = {'pageName': this.pageSectionName, 'donorId': donorIdParam, 'passcode': passCodeParam};
        Promise.all([callApexFunction(this, SERVER_getConstituentInformation, params, this.handleConstituentInformation, () => {}),
                    this.hasAddressAutocomplete ? callApexFunction(this, getInternationalAutocompleteConfigurationMap, {}, this.handleInternationalAutocompleteConfiguration, () => {}) : () => {}])
        .finally(() => {this._callbackDone = true;});
    }

    handleConstituentInformation = (response) => {
        this.informationMap = JSON.parse(JSON.stringify(response));
        this._informationMap = Object.assign({}, this.informationMap);
        this.checkValidity();
        publish(this.messageContext, onlineGivingChannel, {detail: this._informationMap, type: "billingDetails"});
        publish(this.messageContext, onlineGivingChannel, {detail: this.hasAddressAutocomplete, type: "setHasAddressAutocomplete"});
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
            publish(this.messageContext, onlineGivingChannel, {detail: this.checkValidity(), type: "billingDetailsCheckValidityResults"});
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

    get isShowComponent() {
        return this._page == this.pageName;
    }

    get headerStyle() {
        return "font-weight: bold;" + 'color: ' + this.textColor + '; margin-bottom: .8em;';
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
        let resultList = [...this.informationMap.picklists.phoneType];
        resultList.unshift({label: 'Select an Option', value: ''});

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
        let emailConfirmField = this.template.querySelector('[name="emailConfirm"]');

        if (this._emailConfirmation && this._emailConfirmation != this.emailAddress) {
            if (emailConfirmField) {
                emailConfirmField.setCustomValidity('The emails do not match.');
                emailConfirmField.reportValidity();
            }
            return false;
        } else {
            if (emailConfirmField) {
                emailConfirmField.setCustomValidity('');
            }
            return true;
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
        // Method called here so custom validity can be unset if element is now valid.
        if (!this.checkEmailConfirmation()){
            return false;
        }

        let valid = true;
        if (this.template.querySelectorAll('input') && this.template.querySelectorAll('input').length > 0) {
            let elements = this.template.querySelectorAll('input');
            for (let index = 0; index < elements.length; index++) {
                valid = valid && elements[index].checkValidity();
            }
        }

        let isEmailRequired = this._givingAsOrg ? this.informationMap.frontEndData.organizationEmail.isRequired : this.informationMap.frontEndData.emailAddress.isRequired;

        if (isEmailRequired && !this.emailAddress) {
            valid = false;
        }

        valid = valid && (this._emailConfirmation == this.emailAddress);

        if (valid && this._matchingCompanyIntegration === 'Double The Donation') {
            let dtdBillingInformation = {
                'firstName': this.firstName,
                'lastName': this.lastName,
                'phoneNumber': this.phoneNumber,
                'emailAddress': this.emailAddress,
                'addressLine1': this.addressLine1,
                'addressLine2': this.addressLine2,
                'addressCity': this.addressCity,
                'addressState': this.addressState,
                'addressPostalCode': this.addressPostalCode,
                'addressCountry': this.addressCountry
            };
            publish(this.messageContext, onlineGivingChannel, {detail: dtdBillingInformation, type:"dtdBillingInformation"});
        }

        return valid;
    }
}