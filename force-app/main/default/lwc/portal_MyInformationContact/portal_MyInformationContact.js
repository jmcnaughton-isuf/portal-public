import { LightningElement, api, track } from 'lwc';
import viewTemplate from './portal_MyInformationContactView.html';
import editTemplate from './portal_MyInformationContactEdit.html';
export default class Portal_MyInformationContact extends LightningElement {
    @api informationMap;
    @api displayView;
    @api deleteIcon;
    @track _informationMap;

    _modalField;
    _modalUpdateType;
    _modalFieldType;
    _modalFieldValue;
    _modalSObjectName;
    _modalFieldName;
    _birthdateReported = false;

    _spousalInterim;
    @track _cachedSpouseInfo = {};

    _emailIndex = 0;
    _phoneIndex  = 0;
    _addressIndex = 0;
    _emailValues;
    _phoneValues;
    _addressValues;
    _isAddEmailDisplay = true;
    _isAddPhoneDisplay = true;
    _isAddAddressDisplay = true;
    @track _interimEmail = [];
    @track _interimPhones = [];
    @track _interimAddresses = [];
    @track _selfReportBirthDate = {};
    @track _interim;
    @track _openModal = false;

    @api
    checkInputValidity() {
        let inputs = this.template.querySelectorAll('c-portal_-My-Information-Edit-Field');
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

    @api
    resetPicklistValues() {
        if (!this.displayView) {
            this._emailIndex = 0;
            this._phoneIndex  = 0;
            this._addressIndex = 0;
            this.setupContactInformation();
        }
    }

    connectedCallback() {
        if (this.informationMap) {
            this._informationMap = Object.assign({}, JSON.parse(JSON.stringify(this.informationMap)));
            this._emailValues = this._informationMap.picklists.emailType;
            this._phoneValues = this._informationMap.picklists.phoneType;
            this._addressValues = this._informationMap.picklists.addressType;
            if (this.informationMap.interimRecords && this.informationMap.interimRecords.interims && this.informationMap.interimRecords.interims.interims) {
                this._interim = Object.assign({}, this.informationMap.interimRecords.interims.interims[0]);
            }
            if (this.informationMap.interimRecords && this.informationMap.interimRecords.spousalInterim && this.informationMap.interimRecords.spousalInterim.spousalInterim) {
                this._spousalInterim = Object.assign({}, this.informationMap.interimRecords.spousalInterim.spousalInterim[0]);
            }
            if (this.informationMap && this.informationMap.interimRecords && this.informationMap.interimRecords.emails && this.informationMap.interimRecords.emails.emails) {
                this._interimEmail = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.emails.emails))];
            }
            if (this.informationMap && this.informationMap.interimRecords && this.informationMap.interimRecords.phones && this.informationMap.interimRecords.phones.phones) {
                this._interimPhones = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.phones.phones))];
            }
            if (this.informationMap && this.informationMap.interimRecords && this.informationMap.interimRecords.addresses && this.informationMap.interimRecords.addresses.addresses) {
                this._interimAddresses = [...JSON.parse(JSON.stringify(this.informationMap.interimRecords.addresses.addresses))];
            }
            if (!this.displayView) {
                this.setupContactInformation();
            } else if (this.displayView) {
                this.formatNonInterimPhoneRecords();
                this.formatInterimPhoneRecords();
            }

            this._cachedSpouseInfo.maritalStatus = this.maritalStatus;
            this._cachedSpouseInfo.spouseFirstName = this.spouseFirstName;
            this._cachedSpouseInfo.spouseLastName = this.spouseLastName;
        }
    }

    render() {
        return this.displayView ? viewTemplate : editTemplate;
    }

    get firstName() {
        return this.getRecordValue("firstName");
    }

    get middleName() {
        return this.getRecordValue("middleName");
    }

    get lastName() {
        return this.getRecordValue("lastName");
    }

    get title() {
        return this.getRecordValue("prefix");
    }

    get suffix() {
        return this.getRecordValue("suffix");
    }

    get businessTitle() {
        return this.getRecordValue("businessTitle");
    }


    get maidenFirstName() {
        return this.getRecordValue("maidenFirstName");
    }

    get maidenMiddleName() {
        return this.getRecordValue("maidenMiddleName");
    }

    get maidenLastName() {
        return this.getRecordValue("maidenLastName");
    }

    get directoryFirstName() {
        return this.getRecordValue("directoryFirstName");
    }

    get directoryLastName() {
        return this.getRecordValue("directoryLastName");
    }

    get nicknameFirstName() {
        return this.getRecordValue("nicknameFirstName");
    }

    get nicknameLastName() {
        return this.getRecordValue("nicknameLastName");
    }

    get gender() {
        return this.getRecordValue("gender");
    }

    get pronoun() {
        return this.getRecordValue("pronoun");
    }

    get birthdate() {
        if (this._selfReportBirthDate.isBirthdateDeleted) {
            return '';
        } else if (Object.keys(this._selfReportBirthDate).length > 0) {
            return this._selfReportBirthDate.birthdate;
        } else if (this.informationMap.frontEndData.birthdate.displayStagingRecordInRealTime && this._interim && this._interim.birthdate) {
            return this._interim.birthdate;
        } else if (this.informationMap && this.informationMap.records
            && this.informationMap.records.Personal_Information && this.informationMap.records.Personal_Information.Additional_Details
            && this.informationMap.records.Personal_Information.Additional_Details.length > 0) {
            try {
                let day = this.informationMap.records.Personal_Information.Additional_Details[0].birthdate;
                let month = this.informationMap.records.Personal_Information.Additional_Details[0].birthMonth;
                let year = this.informationMap.records.Personal_Information.Additional_Details[0].birthYear;
                if (year && day && month) {
                    return year + '-' + month + '-' + day;
                } else {
                    return '';
                }
            } catch (e) {
                return "";
            }
        } else {
            return "";
        }
    }

    get pendingBirthdate() {
        if (this._selfReportBirthDate.isBirthdateDeleted) {
            return '';
        } else if (Object.keys(this._selfReportBirthDate).length > 0) {
            if (this._selfReportBirthDate.isBirthdateDeleted) {
                return '';
            } else if (!this._selfReportBirthDate.birthdate){
                return '';
            } else {
                return this._selfReportBirthDate.birthdate;
            }

        } else if (this.informationMap && this.informationMap.selfReports && this.informationMap.selfReports.interims
                    && this.informationMap.selfReports.interims.interims
                    && this.informationMap.selfReports.interims.interims[0]
                    && this.informationMap.selfReports.interims.interims[0].birthdate) {
                return this.informationMap.selfReports.interims.interims[0].birthdate;
        }
    }

    get maritalStatus() {
        return this.getRecordValue("maritalStatus");
    }

    get spouseFirstName() {
        return this.getRecordValue("spouseFirstName");
    }

    get spouseLastName() {
        return this.getRecordValue("spouseLastName");
    }

    get formerNameToggle() {
        if (this._informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
            return this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowMaidenName;
        } else {
            return false;
        }
    }

    get reportBirthdate() {
        return this._informationMap.frontEndData.birthdate.reportUpdateLink
            && !(this.informationMap.selfReports
                && this.informationMap.selfReports.interims && this.informationMap.selfReports.interims.interims.length > 0
                && (this.informationMap.selfReports.interims.interims[0].birthdate
                    || this.informationMap.selfReports.interims.interims[0].isBirthdateDeleted))
            && !(this._birthdateReported);
    }

    setFormerNameToggle  = (event) => {
        if (this._informationMap.records.Privacy_Settings.Directory_Setting.length <= 0) {
            this._informationMap.records.Privacy_Settings.Directory_Setting.push({
                isShowMaidenName: event.currentTarget.checked,
                isShowNickname: false,
                isShowGender: false,
                isShowPronouns: false,
                Id: null
            });
        } else {
            this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowMaidenName =  event.currentTarget.checked;
        }
        this.addToChangeSet('Directory_Setting');
    }

    get alsoKnownAsToggle() {
        if (this._informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
            return this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowNickname;
        } else {
            return false;
        }
    }

    setAlsoKnownAsToggle = (event) => {
        if (this._informationMap.records.Privacy_Settings.Directory_Setting.length <= 0) {
            this._informationMap.records.Privacy_Settings.Directory_Setting.push({
                isShowMaidenName: false,
                isShowNickname: event.currentTarget.checked,
                isShowGender: false,
                isShowPronouns: false
            });
        } else {
            this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowNickname =  event.currentTarget.checked;
        }
        this.addToChangeSet('Directory_Setting');
    }

    get genderToggle() {
        if (this._informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
            return this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowGender;
        } else {
            return false;
        }
    }

    get pronounToggle() {
        if (this._informationMap.records.Privacy_Settings.Directory_Setting.length > 0) {
            return this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowPronouns;
        } else {
            return false;
        }
    }

    get areStreetsVisible() {
        if (this.informationMap && this.informationMap.frontEndData && this.informationMap.frontEndData.addressLine1 &&
            this.informationMap.frontEndData.addressLine2 && this.informationMap.frontEndData.addressLine3 ) {
                return this.informationMap.frontEndData.addressLine1.display || this.informationMap.frontEndData.addressLine2.display
                || this.informationMap.frontEndData.addressLine3.display;
        }
        return false;
    }

    editInformation = (event) => {
        window.location.replace(window.location.href.split(/[?#]/)[0] + '?mode=edit');
    }

    addEmails = (event) => {
        let defaultEmailTypeValue = "";

        // if not multiple emails, then get next value in picklist values to default to when they click add
        if (!this._informationMap.multipleEmails) {
            let emailValuesToHideInPicklist = this.findEmailValuesToHideInPicklist();
            let newEmailTypeList = this._emailValues.filter(picklistObject => {
                return !emailValuesToHideInPicklist.has(picklistObject.value);
            });

            if (newEmailTypeList && newEmailTypeList.length > 0) {
                defaultEmailTypeValue = newEmailTypeList[0].value
            }
        }

        this._informationMap.records.Emails.records = [...this._informationMap.records.Emails.records, {emailAddress:"",
                                                        emailType: defaultEmailTypeValue,
                                                        emailIsPreferred: false,
                                                        picklistValues: this._emailValues,
                                                        Id: null, status : "Current", isDisplayOnPortal : true, index: 'email' + this._emailIndex}];
        this._emailIndex++;

        if (!this._informationMap.multipleEmails) {
            this.createPicklistsForEmails(this._emailValues)
        }

        this.addToChangeSet('Emails');
    }

    addPhones = (event) => {
        let defaultPhoneTypeValue = "";

        // if not multiple emails, then get next value in picklist values to default to when they click add
        if (!this._informationMap.multiplePhones) {
            let phoneValuesToHideInPicklist = this.findPhoneValuesToHideInPicklist();
            let newPhoneTypeList = this._phoneValues.filter(picklistObject => {
                return !phoneValuesToHideInPicklist.has(picklistObject.value);
            });

            if (newPhoneTypeList && newPhoneTypeList.length > 0) {
                defaultPhoneTypeValue = newPhoneTypeList[0].value
            }
        }

        this._informationMap.records.Phones.records = [...this._informationMap.records.Phones.records, {phoneNumber:"",
                                                        phoneType: defaultPhoneTypeValue, picklistValues: this._phoneValues,
                                                        phoneIsPreferred: false, Id:null, status : "Current", isDisplayOnPortal : true, index: 'phone' + this._phoneIndex}];
        this._phoneIndex++;

        if (!this._informationMap.multiplePhones) {
            this.createPicklistsForPhones(this._phoneValues)
        }
        
        this.addToChangeSet('Phones');
    }

    addAddresses = (event) => {
        let defaultAddressTypeValue = "";

        // if not multiple emails, then get next value in picklist values to default to when they click add
        if (!this._informationMap.multipleAddresses) {
            let addressValuesToHideInPicklist = this.findAddressValuesToHideInPicklist();
            let newAddressTypeList = this._addressValues.filter(picklistObject => {
                return !addressValuesToHideInPicklist.has(picklistObject.value);
            });

            if (newAddressTypeList && newAddressTypeList.length > 0) {
                defaultAddressTypeValue = newAddressTypeList[0].value
            }
        }
        
        this._informationMap.records.Addresses.records = [...this._informationMap.records.Addresses.records,
                                                                {addressType: defaultAddressTypeValue, Id:null, addressIsPreferred: false, addressLine1 : "", addressLine2 :"",
                                                            addressLine3 : "", addressCity : "", addressState : "",
                                                            addressCountry : "",addressPostalCode : "", status : "Current", isDisplayOnPortal : true, addressShowOnDirectory: false,
                                                            picklistValues: this._addressValues, isShowAddressLines: false, isShowCountry: false, isShowCity: false, isShowState: false, isShowPostalCode: false, index: 'address' + this._addressIndex}];
        this._addressIndex++;

        if (!this._informationMap.multipleAddresses) {
            this.createPicklistsForAddresses(this._addressValues);
        }

        this.addToChangeSet('Addresses');
    }

    deleteEmail(event) {
        let type = event.currentTarget.getAttribute('data-type');
        let index = event.currentTarget.getAttribute('data-index');

        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                let fieldChanges = element.getEditInformation();
                if (fieldChanges.fieldType == 'email') {
                    this._informationMap.records.Emails.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                } else if (fieldChanges.fieldType == 'interimEmail') {
                    this._informationMap.interimRecords.emails.emails[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                }
            })
        }

        if (type == "interim") {
            this._informationMap.interimRecords.emails.emails.splice(index, 1);
            this._informationMap.interimRecords.emails.emails = [...this._informationMap.interimRecords.emails.emails];
            this._interimEmail = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.emails.emails))];
        } else {
            this._informationMap.records.Emails.records.splice(index, 1);
            this._informationMap.records.Emails.records = [...this._informationMap.records.Emails.records];
        }

        if (!this._informationMap.multipleEmails) {
            this.createPicklistsForEmails(this._emailValues);
        }

        this.addToChangeSet('Emails');
    }

    deletePhone(event){
        let type = event.currentTarget.getAttribute('data-type');
        let index = event.currentTarget.getAttribute('data-index');

        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                let fieldChanges = element.getEditInformation();
                if (fieldChanges.changeSetValue) {
                    this.addToChangeSet(fieldChanges.changeSetValue);
                }
                if (fieldChanges.fieldType == 'phone') {
                    this._informationMap.records.Phones.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                } else if (fieldChanges.fieldType == 'interimPhone') {
                    this._informationMap.interimRecords.phones.phones[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                }
            })
        }

        if (type == "interim") {
            this._informationMap.interimRecords.phones.phones.splice(index, 1);
            this._informationMap.interimRecords.phones.phones = [...this._informationMap.interimRecords.phones.phones];
            this._interimPhones = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.phones.phones))];
        } else {
            this._informationMap.records.Phones.records.splice(index, 1);
            this._informationMap.records.Phones.records = [...this._informationMap.records.Phones.records];
        }

        if (!this._informationMap.multiplePhones) {
            this.createPicklistsForPhones(this._phoneValues)
        }

        this.addToChangeSet('Phones');
    }

    deleteAddress(event) {
        let type = event.currentTarget.getAttribute('data-type');
        let index = event.currentTarget.getAttribute('data-index');

        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                let fieldChanges = element.getEditInformation();
                if (fieldChanges.changeSetValue) {
                    this.addToChangeSet(fieldChanges.changeSetValue);
                }
                if (fieldChanges.fieldType == 'address') {
                    if (fieldChanges.toggleField) {
                        this._informationMap.records.Addresses.records[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                    }
                    if (fieldChanges.fieldName.includes('.')) {
                        let fields = fieldChanges.fieldName.split('.');
                        this._informationMap.records.Addresses.records[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                    } else {
                        this._informationMap.records.Addresses.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                    }                    
                } else if (fieldChanges.fieldType == 'interimAddress') {
                    if (fieldChanges.toggleField) {
                        this._informationMap.interimRecords.addresses.addresses[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                    }
                    if (fieldChanges.fieldName.includes('.')) {
                        let fields = fieldChanges.fieldName.split('.');
                        this._informationMap.interimRecords.addresses.addresses[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                    } else {
                        this._informationMap.interimRecords.addresses.addresses[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                    }
                }
            })
        }

        if (type == "interim") {
            this._informationMap.interimRecords.addresses.addresses.splice(index, 1);
            this._informationMap.interimRecords.addresses.addresses = [...this._informationMap.interimRecords.addresses.addresses];
            this._interimAddresses = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.addresses.addresses))];
        } else {
            this._informationMap.records.Addresses.records.splice(index, 1);
        }

        if (!this._informationMap.multipleAddresses) {
            this.createPicklistsForAddresses(this._addressValues);
        }

        this.addToChangeSet('Addresses');
    }

    setAddressStreetToggle = (event) => {
        let type = event.currentTarget.dataset.type;
        let index = event.currentTarget.dataset.index;

        if (type == "interim") {
            this._informationMap.interimRecords.addresses.addresses[index].isShowAddressLines = event.currentTarget.checked;
            this._informationMap.interimRecords.addresses.addresses = [...this._informationMap.interimRecords.addresses.addresses];
            this._interimAddresses = [...JSON.parse(JSON.stringify(this._informationMap.interimRecords.addresses.addresses))];
        } else {
            this._informationMap.records.Addresses.records[index].isShowAddressLines = event.currentTarget.checked;
        }

        this.addToChangeSet('Addresses');
    }

    @api
    getEditInformation() {
        if (this.template.querySelectorAll('c-portal_-My-Information-Edit-Field') && this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').length > 0) {
            this.template.querySelectorAll('c-portal_-My-Information-Edit-Field').forEach(element => {
                let fieldChanges = element.getEditInformation();
                if (fieldChanges.changeSetValue) {
                    this.addToChangeSet(fieldChanges.changeSetValue);
                }
                if (fieldChanges.fieldType == 'email') {
                    this._informationMap.records.Emails.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                } else if (fieldChanges.fieldType == 'interimEmail') {
                    this._informationMap.interimRecords.emails.emails[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                } else if (fieldChanges.fieldType == 'phone') {
                    this._informationMap.records.Phones.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                } else if (fieldChanges.fieldType == 'interimPhone') {
                    this._informationMap.interimRecords.phones.phones[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                } else if (fieldChanges.fieldType == 'address') {
                    if (fieldChanges.toggleField) {
                        this._informationMap.records.Addresses.records[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                    }
                    if (fieldChanges.fieldName.includes('.')) {
                        let fields = fieldChanges.fieldName.split('.');
                        this._informationMap.records.Addresses.records[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                    } else {
                        this._informationMap.records.Addresses.records[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'interimAddress') {
                    if (fieldChanges.toggleField) {
                        this._informationMap.interimRecords.addresses.addresses[fieldChanges.index][fieldChanges.toggleField] = fieldChanges.toggleValue;
                    }
                    if (fieldChanges.fieldName.includes('.')) {
                        let fields = fieldChanges.fieldName.split('.');
                        this._informationMap.interimRecords.addresses.addresses[fieldChanges.index][fields[0]][fields[1]] = fieldChanges.value;
                    } else {
                        this._informationMap.interimRecords.addresses.addresses[fieldChanges.index][fieldChanges.fieldName] = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'firstName') {
                    if (this._interim && this._interim.firstName) {
                        this._informationMap.interimRecords.interims.interims[0].firstName = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Name[0].firstName = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'middleName') {
                    if (this._interim && this._interim.middleName) {
                        this._informationMap.interimRecords.interims.interims[0].middleName = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Name[0].middleName = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'lastName') {
                    if (this._interim && this._interim.lastName) {
                        this._informationMap.interimRecords.interims.interims[0].lastName = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Name[0].lastName = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'title') {
                    if (this._interim && this._interim.prefix) {
                        this._informationMap.interimRecords.interims.interims[0].prefix = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Name[0].prefix = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'suffix') {
                    if (this._interim && this._interim.suffix) {
                        this._informationMap.interimRecords.interims.interims[0].suffix = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Name[0].suffix = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'businessTitle')  {
                    if (this._interim && this._interim.businessTitle) {
                        this._informationMap.interimRecords.interims.interims[0].businessTitle = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Name[0].businessTitle = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'maidenFirstName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].maidenFirstName = fieldChanges.value;
                    } else if (!this._interim){
                        let hasMaidenName = false;
                        let maidenFirstName = fieldChanges.value;

                        this._informationMap.records.Personal_Information.Also_Known_As.forEach( record => {
                            if (record.maidenType == 'Maiden') {
                                hasMaidenName = true;
                                record.maidenFirstName = maidenFirstName;
                            }

                        });
                        if (!hasMaidenName) {
                            this._informationMap.records.Personal_Information.Also_Known_As.push({
                                Id: null,
                                maidenFirstName : maidenFirstName,
                                maidenType : "Maiden"
                            });
                        }

                    }

                } else if (fieldChanges.fieldType == 'maidenMiddleName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].maidenMiddleName = fieldChanges.value;
                    } else if (!this._interim){
                        let hasMaidenName = false;
                        let maidenMiddleName = fieldChanges.value;

                        this._informationMap.records.Personal_Information.Also_Known_As.forEach( record => {
                            if (record.maidenType == 'Maiden') {
                                hasMaidenName = true;
                                record.maidenMiddleName = maidenMiddleName;
                            }

                        });

                        if (!hasMaidenName) {
                            this._informationMap.records.Personal_Information.Also_Known_As.push({
                                Id: null,
                                maidenMiddleName : maidenMiddleName,
                                maidenType : "Maiden"
                            });
                        }

                    }

                } else if (fieldChanges.fieldType == 'maidenLastName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].maidenLastName = fieldChanges.value;
                    } else if (!this._interim) {
                        let hasMaidenName = false;
                        let maidenLastName = fieldChanges.value;

                        this._informationMap.records.Personal_Information.Also_Known_As.forEach( record => {
                            if (record.maidenType == 'Maiden') {
                                hasMaidenName = true;
                                record.maidenLastName = maidenLastName;
                            }

                        });
                        if (!hasMaidenName) {
                            this._informationMap.records.Personal_Information.Also_Known_As.push({
                                Id: null,
                                maidenLastName : maidenLastName,
                                maidenType : "Maiden"
                            });
                        }

                    }

                } else if (fieldChanges.fieldType == 'nicknameFirstName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].nicknameFirstName = fieldChanges.value;
                    } else if (!this._interim) {
                        let hasNickname = false;
                        let nicknameFirstName = fieldChanges.value;

                        this._informationMap.records.Personal_Information.Also_Known_As.forEach( record => {
                            if (record.nicknameType == 'Nickname') {
                                hasNickname = true;
                                record.nicknameFirstName = nicknameFirstName;
                            }

                        });

                        if (!hasNickname) {
                            this._informationMap.records.Personal_Information.Also_Known_As.push({
                                Id: null,
                                nicknameFirstName : nicknameFirstName,
                                nicknameType : "Nickname"
                            });
                        }

                    }

                } else if (fieldChanges.fieldType == 'nicknameLastName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].nicknameLastName = fieldChanges.value;
                    } else if (!this._interim) {
                        let hasNickname = false;
                        let nicknameLastName = fieldChanges.value;

                        this._informationMap.records.Personal_Information.Also_Known_As.forEach( record => {
                            if (record.nicknameType == 'Nickname') {
                                hasNickname = true;
                                record.nicknameLastName = nicknameLastName;
                            }

                        });
                        if (!hasNickname) {
                            this._informationMap.records.Personal_Information.Also_Known_As.push({
                                Id: null,
                                nicknameLastName : nicknameLastName,
                                nicknameType : "Nickname"
                            });
                        }

                    }
                } else if (fieldChanges.fieldType == 'directoryFirstName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].directoryFirstName = fieldChanges.value;
                    } else if (!this._interim) {
                        let directoryFirstName = fieldChanges.value;

                        if (this._informationMap.records.Personal_Information.Directory_Display_Name.length  > 0) {
                            this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryFirstName = directoryFirstName;
                        } else {
                            this._informationMap.records.Personal_Information.Directory_Display_Name.push({
                                directoryFirstName : directoryFirstName,
                                Id: null,
                                directoryType: "Directory"
                            });
                        }
                    }
                } else if (fieldChanges.fieldType == 'directoryLastName') {
                    if (this._interim) {
                        this._informationMap.interimRecords.interims.interims[0].directoryLastName = fieldChanges.value;
                    } else if (!this._interim) {
                        let directoryLastName = fieldChanges.value;

                        if (this._informationMap.records.Personal_Information.Directory_Display_Name.length  > 0) {
                            this._informationMap.records.Personal_Information.Directory_Display_Name[0].directoryLastName = directoryLastName;
                        } else {


                            this._informationMap.records.Personal_Information.Directory_Display_Name.push({
                                directoryLastName : directoryLastName,
                                Id: null,
                                directoryType: "Directory"
                            });
                        }
                    }
                } else if (fieldChanges.fieldType == 'gender') {
                    if (this._informationMap.records.Privacy_Settings.Directory_Setting.length == 0) {
                        this._informationMap.records.Privacy_Settings.Directory_Setting.push({
                            isShowMaidenName: false,
                            isShowNickname: false,
                            isShowGender: fieldChanges.toggleValue,
                            isShowPronouns: false,
                            Id: null
                        });
                    } else {
                        this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowGender = fieldChanges.toggleValue;
                    }
                    this.addToChangeSet('Directory_Setting');

                    if (this._interim && this._interim.gender) {
                        this._informationMap.interimRecords.interims.interims[0].gender = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Additional_Details[0].gender = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'pronoun') {
                    if (this._informationMap.records.Privacy_Settings.Directory_Setting.length == 0) {
                        this._informationMap.records.Privacy_Settings.Directory_Setting.push({
                            isShowMaidenName: false,
                            isShowNickname: false,
                            isShowGender: false,
                            isShowPronouns: fieldChanges.toggleValue,
                            Id:null
                        });
                    } else {
                        this._informationMap.records.Privacy_Settings.Directory_Setting[0].isShowPronouns = fieldChanges.toggleValue;
                    }
                    this.addToChangeSet('Directory_Setting');
                    if (this._interim && this._interim.pronoun) {
                        this._informationMap.interimRecords.interims.interims[0].pronoun = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Additional_Details[0].pronoun = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'birthdate') {
                    if (this._interim && this._interim.birthdate) {
                        this._informationMap.interimRecords.interims.interims[0].birthdate = fieldChanges.value;
                    } else {
                        let dateValue = new Date(fieldChanges.value);
                        dateValue.setDate(dateValue.getDate() + 1);
                        let day = dateValue.getDate();
                        let month = dateValue.getMonth();
                        let year = dateValue.getFullYear();
                        if (day > 0) {
                            if (day < 10) {
                                this._informationMap.records.Personal_Information.Additional_Details[0].birthdate = '0' + day;
                            } else {
                                this._informationMap.records.Personal_Information.Additional_Details[0].birthdate = day;
                            }
                        }
                        if (month + 1 < 10) {
                            this._informationMap.records.Personal_Information.Additional_Details[0].birthMonth = '0' + (month + 1);
                        } else  {
                            this._informationMap.records.Personal_Information.Additional_Details[0].birthMonth = month + 1;
                        }
                        if (year > 0) {
                            this._informationMap.records.Personal_Information.Additional_Details[0].birthYear = year;
                        }
                    }
                } else if (fieldChanges.fieldType == 'maritalStatus') {
                    if (this._interim && this._interim.maritalStatus) {
                        this._informationMap.interimRecords.interims.interims[0].maritalStatus = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Additional_Details[0].maritalStatus = fieldChanges.value;
                    }
                } else if (fieldChanges.fieldType == 'spouseFirstName') {
                    if (this._spousalInterim) {
                        this._informationMap.interimRecords.spousalInterim.spousalInterim[0].spouseFirstName = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Additional_Details[0].spouseFirstName = fieldChanges.value;
                    }

                } else if (fieldChanges.fieldType == 'spouseLastName') {
                    if (this._spousalInterim) {
                        this._informationMap.interimRecords.spousalInterim.spousalInterim[0].spouseLastName = fieldChanges.value;
                    } else {
                        this._informationMap.records.Personal_Information.Additional_Details[0].spouseLastName = fieldChanges.value;
                    }

                }
            })

        }

        if (!this.informationMap.multipleAddresses) {
            let updatedAddresses = []
            for (let record of this._informationMap.records.Addresses.records) {
                if (record.addressLine1 || record.addressLine2
                    || record.addressLine3 || record.addressCity
                || record.addressPostalCode || record.addressState ||record.addressCountry) {
                    updatedAddresses.push(Object.assign({}, record));
                }
            }
            this._informationMap.records.Addresses.records = updatedAddresses;
        }

        if (!this.informationMap.multiplePhones) {
            let updatedPhones = []
            for (let record of this._informationMap.records.Phones.records) {
                if (record.phoneNumber) {
                    updatedPhones.push(Object.assign({}, record));
                }
            }
            this._informationMap.records.Phones.records = updatedPhones;
        }

        if (!this.informationMap.multipleEmails) {
            let updatedEmails = []
            for (let record of this._informationMap.records.Emails.records) {
                if (record.emailAddress) {
                    updatedEmails.push(Object.assign({}, record));
                }
            }
            this._informationMap.records.Emails.records = updatedEmails;
        }

        return this._informationMap;
    }

    getRecordValue (field)  {
        let mainSection = this.informationMap.frontEndData[field].mainSection;
        let subSection = this.informationMap.frontEndData[field].subSection;
        let fieldName = this.informationMap.frontEndData[field].fieldId;
        let filterValue = this.informationMap.frontEndData[field].filterValue;
        let filterField = this.informationMap.frontEndData[field].filterField;
        let isPicklist = this.informationMap.frontEndData[field].isPicklist;
        let stagingRecordFieldName = this.informationMap.frontEndData[field].fieldId;
        if (!subSection) {
            subSection = 'records';
        }

        try {
            if (!isPicklist) {
                if (stagingRecordFieldName == 'spouseFirstName' || stagingRecordFieldName == 'spouseLastName') {
                    // TODO: need to change when making wraper for interim
                    if (this._spousalInterim && this._spousalInterim[stagingRecordFieldName]) {
                        if (this._spousalInterim[stagingRecordFieldName] == '%isDeleted%') {
                            return '';
                        }
                        return this._spousalInterim[stagingRecordFieldName];
                    }
                } else {
                    if (this._interim && this._interim[stagingRecordFieldName]) {
                        if (this._interim[stagingRecordFieldName] == '%isDeleted%') {
                            return '';
                        }
                        return this._interim[stagingRecordFieldName];
                    }

                }

                if (filterValue) {
                    for (let record of this.informationMap['records'][mainSection][subSection]) {
                        if (record.nicknameType == filterValue || record.maidenType == filterValue || record.directoryType == filterValue) {
                            // if (fieldName.includes('.')) {
                            //     let fields = fieldName.split('.');
                            //     return record[fields[0]][fields[1]]
                            // }
                            return record[fieldName];
                        }
                    }
                } else {
                    // if (fieldName.includes('.')) {
                    //     let fields = fieldName.split('.');
                    //     return this.informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]
                    // }
                    return this.informationMap['records'][mainSection][subSection][0][fieldName];
                }


            } else {
                for (let picklistValue of this.informationMap.picklists[field]) {
                    if (this._interim  && this._interim[stagingRecordFieldName]) {
                        if (picklistValue.value == this._interim[stagingRecordFieldName]) {
                            return picklistValue.label;
                        }
                    } else if (this._spousalInterim && field == 'maritalStatus' && this._spousalInterim[stagingRecordFieldName]) {
                        if (this._spousalInterim[stagingRecordFieldName] == '%isDeleted%') {
                                return '';
                        } else if (picklistValue.value == this._spousalInterim[stagingRecordFieldName]) {
                            return picklistValue.label;
                        }
                    } else {

                        if (filterValue) {
                            for (let record of this.informationMap['records'][mainSection][subSection]) {
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
                                if (picklistValue.value ==  this.informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]) {
                                    return picklistValue.label;
                                }
                            }
                            if (picklistValue.value == this.informationMap['records'][mainSection][subSection][0][fieldName]) {
                                return picklistValue.label;
                            }
                        }
                    }

                }
           }
        } catch (e) {
            console.log(e);
        }
        return "";
    }

    updateDirectorySetting(event) {
        let section = event.target.getAttribute('data-changesetvalue');
        let index = event.target.getAttribute('data-index');
        let type = event.target.getAttribute('data-type');
        if (type == "interimEmail") {
            this._informationMap.interimRecords[section][section][index].emailShowOnDirectory = event.target.checked;
        } else if (type == "interimPhone") {
            this._informationMap.interimRecords[section][section][index].phoneShowOnDirectory = event.target.checked;
        } else if (type == "interimAddress") {
            this._informationMap.interimRecords[section][section][index].addressShowOnDirectory = event.target.checked;
        } else {
            this._informationMap.records[section].records[index].addressShowOnDirectory  = event.target.checked;
            this.addToChangeSet(section);
        }
    }

    addToChangeSet(changeSetValue) {
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add(changeSetValue);
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = [changeSetValue];
        }
    }

    get isSpouseFirstNameRequired() {
        return this.informationMap.frontEndData.spouseFirstName.isRequired || this._cachedSpouseInfo.maritalStatus === 'Married';
    }

    get isSpouseLastNameRequired() {
        return this.informationMap.frontEndData.spouseLastName.isRequired || this._cachedSpouseInfo.maritalStatus === 'Married';
    }

    get isSpouseFirstNameDisabled() {
        return this.informationMap.frontEndData.spouseFirstName.disable || this._cachedSpouseInfo.maritalStatus === 'Single';
    }

    get isSpouseLastNameDisabled() {
        return this.informationMap.frontEndData.spouseLastName.disable || this._cachedSpouseInfo.maritalStatus === 'Single';
    }

    get emailDisabled() {
        return this.informationMap.frontEndData.emailType.disable
    }

    get phoneDisabled() {
        return this.informationMap.frontEndData.phoneType.disable
    }

    get addressDisabled() {
        return this.informationMap.frontEndData.addressType.disable
    }

    get isAddEmailDisplay() {
        return this._isAddEmailDisplay;
    }

    set isAddEmailDisplay(picklistValues) {
        // if all picklist values to hide are equal to original picklist values in length, then hide.
        if (picklistValues && picklistValues.length == this._emailValues.length) {
            this._isAddEmailDisplay = false;
        } else {
            let totalEmailRecordCount = 0;

            if (this._informationMap.records.Emails.records) {
                totalEmailRecordCount += this._informationMap.records.Emails.records.length;
            }

            if (this._interimEmail) {
                totalEmailRecordCount += this._interimEmail.length;
            }

            // if total records is greater than 0, and also greater than or equal to amount of picklist values, then hide the add button
            if (totalEmailRecordCount > 0 && totalEmailRecordCount >= this._emailValues.length) {
                this._isAddEmailDisplay = false;

            } else {
                this._isAddEmailDisplay = true;
            }
        }
    }

    get isAddPhoneDisplay() {
        return this._isAddPhoneDisplay;
    }

    set isAddPhoneDisplay(picklistValues) {
        // if all picklist values to hide are equal to original picklist values in length, then hide.
        if (picklistValues && picklistValues.length == this._phoneValues.length) {
            this._isAddPhoneDisplay = false;
        } else {
            let totalPhoneRecordCount = 0;

            if (this._informationMap.records.Phones.records) {
                totalPhoneRecordCount += this._informationMap.records.Phones.records.length;
            }

            if (this._interimPhones) {
                totalPhoneRecordCount += this._interimPhones.length;
            }

            // if total records is greater than 0, and also greater than or equal to amount of picklist values, then hide the add button
            if (totalPhoneRecordCount > 0 && totalPhoneRecordCount >= this._phoneValues.length) {
                this._isAddPhoneDisplay = false;

            } else {
                this._isAddPhoneDisplay = true;
            }
        }
    }

    get isAddAddressDisplay() {
        return this._isAddAddressDisplay;
    }

    set isAddAddressDisplay(picklistValues) {
        // if all picklist values to hide are equal to original picklist values in length, then hide.
        if (picklistValues && picklistValues.length == this._addressValues.length) {
            this._isAddAddressDisplay = false;
        } else {
            let totalAddressRecordCount = 0;

            if (this._informationMap.records.Addresses.records) {
                totalAddressRecordCount += this._informationMap.records.Addresses.records.length;
            }

            if (this._interimAddresses) {
                totalAddressRecordCount += this._interimAddresses.length;
            }

            // if total records is greater than 0, and also greater than or equal to amount of picklist values, then hide the add button
            if (totalAddressRecordCount > 0 && totalAddressRecordCount >= this._addressValues.length) {
                this._isAddAddressDisplay = false;

            } else {
                this._isAddAddressDisplay = true;
            }
        }
    }

    addToChangeSet = (changeSetValue) => {
        if (this._informationMap['Change_Set']) {
            let changeSet = new Set (this._informationMap['Change_Set']);
            changeSet.add(changeSetValue);
            this._informationMap['Change_Set'] = Array.from(changeSet);

        } else {
            this._informationMap['Change_Set'] = [changeSetValue];
        }
    }

    setRecordValue(field, fieldName, fieldValue) {

        let mainSection = this.informationMap.frontEndData[field].mainSection;
        let subSection = this.informationMap.frontEndData[field].subSection;
        let filterValue = this.informationMap.frontEndData[field].filterValue;
        let filterField = this.informationMap.frontEndData[field].filterField;
        let stagingRecordFieldName = this.informationMap.frontEndData[field].stagingRecordFieldName;
        if (!subSection) {
            subSection = 'records';
        }

        try {
            if (this._interim && this._interim[stagingRecordFieldName]) {
                this._interim[stagingRecordFieldName] = fieldValue;
            }
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
                if (this._informationMap['records'][mainSection][subSection].length < 0) {
                    let record = {Id: null};
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        record[fields[0]][fields[1]] = fieldValue;
                    } else {
                        record[fieldName] = fieldValue;
                    }
                    this._informationMap['records'][mainSection][subSection] = [...this._informationMap['records'][mainSection][subSection], record];
                } else {
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');
                        this._informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]] = fieldValue;
                    } else {
                        this._informationMap['records'][mainSection][subSection][0][fieldName] = fieldValue;
                    }

                }

            }
        } catch (e) {
            console.log(e);
        }
        return "";
    }

    reportUpdate(event) {
        this._modalUpdateType = event.target.getAttribute('data-type');
        this._modalField = event.target.getAttribute('data-field');
        this._modalFieldType = event.target.getAttribute('data-fieldtype');
        this._modalFieldValue = event.target.getAttribute('data-fieldvalue');
        this._modalSObjectName = event.target.getAttribute('data-sobjectname');
        this._modalFieldName = event.target.getAttribute('data-fieldname');
        this._openModal = true;
        event.preventDefault();
    }

    handleCloseModal = (saved, recordList) => {
        if (saved) {
            if (this._modalFieldName == 'birthdate') {
                this._birthdateReported = true;
                this._selfReportBirthDate = recordList[0];
            }
        }
        this._openModal = false;
    }

    // clear the values in MyInformationEditField, not in this.informationMap
    clearSpouseNames() {
        let spouseFirstNameField = this.template.querySelector('[data-field-type="spouseFirstName"]');
        if (spouseFirstNameField) {
            spouseFirstNameField.setValue('');
        }

        let spouseLastNameField = this.template.querySelector('[data-field-type="spouseLastName"]');
        if (spouseLastNameField) {
            spouseLastNameField.setValue('');
        }
    }

    // restore the values in MyInformationEditField, not in this.informationMap
    restoreSpouseNames() {
        let spouseFirstNameField = this.template.querySelector('[data-field-type="spouseFirstName"]');
        if (spouseFirstNameField) {
            spouseFirstNameField.setValue(this._cachedSpouseInfo.spouseFirstName);
        }

        let spouseLastNameField = this.template.querySelector('[data-field-type="spouseLastName"]');
        if (spouseLastNameField) {
            spouseLastNameField.setValue(this._cachedSpouseInfo.spouseLastName);
        }
    }

    resetSpouseNameValidity() {
        let spouseFirstNameField = this.template.querySelector('[data-field-type="spouseFirstName"]');
        if (spouseFirstNameField) {
            spouseFirstNameField.reportValidity();
        }

        let spouseLastNameField = this.template.querySelector('[data-field-type="spouseLastName"]');
        if (spouseLastNameField) {
            spouseLastNameField.reportValidity();
        }

    }

    handleChange = (value, index, fieldType, inputType) => {
        if (fieldType === 'maritalStatus') {
            if (this._cachedSpouseInfo.maritalStatus !== 'Single' && value === 'Single') {
                this.clearSpouseNames();
            } else if (this._cachedSpouseInfo.maritalStatus === 'Single' && value !== 'Single') {
                this.restoreSpouseNames();
            }

            this._cachedSpouseInfo[fieldType] = value;

            // need to wait for the input field's required state to update before resetting validity
            setTimeout(() => {
                this.resetSpouseNameValidity();
            });

            return;
        }

        if (fieldType === 'spouseFirstName' || fieldType === 'spouseLastName') {
            this._cachedSpouseInfo[fieldType] = value;
            return;
        }

        if (fieldType == 'email' || fieldType == 'interimEmail') {
            if (value == true && inputType == 'checkbox') {
                let emailFields = this.template.querySelectorAll('[data-target="emailPreferred"]');
                let interimEmailFields = this.template.querySelectorAll('[data-target="interimEmailPreferred"]');

                let emailIndex = 0;
                for(let i = 0; i <  this._informationMap.records.Emails.records.length; i++) {
                    if (!this._informationMap.records.Emails.records[i].isHide && (i != index || fieldType == 'interimEmail')) {
                        if (emailFields && emailFields.length > emailIndex) {
                            emailFields[emailIndex].setValue(false);
                            emailIndex++;
                        }
                        this._informationMap.records.Emails.records[i].emailIsPreferred = false;
                    } else if (i == index && fieldType == 'email'){
                        emailIndex++;
                    }
                }

                let interimEmailIndex = 0;
                for(let i = 0; i <  this._informationMap.interimRecords.emails.emails.length; i++) {
                    if (!this._informationMap.interimRecords.emails.emails[i].isHide && (i != index || fieldType == 'email')) {
                        if (interimEmailFields && interimEmailFields.length > interimEmailIndex) {
                            interimEmailFields[interimEmailIndex].setValue(false);
                            interimEmailIndex++;
                        }
                        this._informationMap.interimRecords.emails.emails[i].emailIsPreferred = false;
                    } else if (i == index && fieldType == 'interimEmail'){
                        interimEmailIndex++;
                    }
                }
            } else if (inputType == 'picklist' && !this.informationMap.multipleEmails) {
                if (fieldType == 'email') {
                    this._informationMap.records.Emails.records[index].emailType = value;
                } else if (fieldType == 'interimEmail') {
                    this._interimEmail[index].emailType = value;
                }

                this.createPicklistsForEmails(this._emailValues);
            }
        } else if (fieldType == 'phone' || fieldType == 'interimPhone') {
            if (value == true && inputType == 'checkbox') {
                let phoneFields = this.template.querySelectorAll('[data-target="phonePreferred"]');
                let interimPhoneFields = this.template.querySelectorAll('[data-target="interimPhonePreferred"]');

                let phoneIndex = 0;
                for(let i = 0; i <  this._informationMap.records.Phones.records.length; i++) {
                    if (!this._informationMap.records.Phones.records[i].isHide && (i != index || fieldType == 'interimPhone')) {
                        if (phoneFields && phoneFields.length > phoneIndex) {
                            phoneFields[phoneIndex].setValue(false);
                            phoneIndex++;
                        }
                        this._informationMap.records.Phones.records[i].phoneIsPreferred = false;
                    } else if (i == index && fieldType == 'phone') {
                        phoneIndex++;
                    }
                }

                let interimPhoneIndex = 0;
                for(let i = 0; i <  this._informationMap.interimRecords.phones.phones.length; i++) {
                    if (!this._informationMap.interimRecords.phones.phones[i].isHide && (i != index || fieldType == 'phone')) {
                        if (interimPhoneFields && interimPhoneFields.length > interimPhoneIndex) {
                            interimPhoneFields[interimPhoneIndex].setValue(false);
                            interimPhoneIndex ++;
                        }
                        this._informationMap.interimRecords.phones.phones[i].phoneIsPreferred = false;
                    } else if (i == index && fieldType == 'interimPhone') {
                        interimPhoneIndex++;
                    }
                }
            } else if (inputType == 'picklist' && !this.informationMap.multiplePhones) {
                if (fieldType == 'phone') {
                    this._informationMap.records.Phones.records[index].phoneType = value;
                } else if (fieldType == 'interimPhone') {
                    this._interimPhones[index].phoneType = value;
                }

                this.createPicklistsForPhones(this._phoneValues);
            }

        } else if (fieldType == 'address' || fieldType == 'interimAddress') {
            if (value == true && inputType == 'checkbox') {
                let addressFields = this.template.querySelectorAll('[data-target="addressPreferred"]');
                let interimAddressPreferred = this.template.querySelectorAll('[data-target="interimAddressPreferred"]');

                let addressFieldIndex = 0;
                for(let i = 0; i <  this._informationMap.records.Addresses.records.length; i++) {
                    if (!this._informationMap.records.Addresses.records[i].isHide && (i != index || fieldType == 'interimAddress')) {
                        if (addressFields && addressFields.length > addressFieldIndex) {
                            addressFields[addressFieldIndex].setValue(false);
                            addressFieldIndex++;
                        }
                        this._informationMap.records.Addresses.records[i].addressIsPreferred = false;
                    } else if (i == index && fieldType == 'address') {
                        addressFieldIndex++;
                    }
                }

                let interimAddressIndex = 0;
                for(let i = 0; i <  this._informationMap.interimRecords.addresses.addresses.length; i++) {
                    if (!this._informationMap.interimRecords.addresses.addresses[i].isHide && (i != index || fieldType == 'address')) {
                        if (interimAddressPreferred && interimAddressPreferred.length > interimAddressIndex) {
                            interimAddressPreferred[interimAddressIndex].setValue(false);
                            interimAddressIndex++;
                        }
                        this._informationMap.interimRecords.addresses.addresses[i].addressIsPreferred = false;
                    } else if (i == index && fieldType == 'interimAddress') {
                        interimAddressIndex++;
                    }
                }
            } else if (inputType == 'picklist' && !this.informationMap.multipleAddresses) {
                if (fieldType == 'address') {
                    this._informationMap.records.Addresses.records[index].addressType = value;
                } else if (fieldType == 'interimAddress') {
                    this._interimAddresses[index].addressType = value;
                }

                this.createPicklistsForAddresses(this._addressValues);
            }
        }
    }

    setupContactInformation() {
        if (this.informationMap && this.informationMap.picklists && this.informationMap.picklists.addressType) {
            let newAddressValues = [...this._addressValues];
            this.createPicklistsForAddresses(newAddressValues);
        }
        if (this.informationMap && this.informationMap.picklists && this.informationMap.picklists.phoneType) {
            let newPhoneValues = [...this._phoneValues];
            this.createPicklistsForPhones(newPhoneValues);
        }
        if (this.informationMap && this.informationMap.picklists && this.informationMap.picklists.emailType) {
            let allEmailValues = [...this._emailValues];
            this.createPicklistsForEmails(allEmailValues);
        }
        for (let record of this._informationMap.records.Emails.records) {
            record['index'] = 'email' + this._emailIndex;
            this._emailIndex++;
        }
        for (let record of this._informationMap.records.Phones.records) {
            record['index'] = 'phone' + this._phoneIndex;
            this._phoneIndex++;
        }
        for (let record of this._informationMap.records.Addresses.records) {
            record['index'] = 'address' + this._addressIndex;
            this._addressIndex++;
        }
    }

    formatNonInterimPhoneRecords() {
        if (!this._informationMap || !this._informationMap.records || !this._informationMap.records.Phones || !this._informationMap.records.Phones.records) {
            return;
        }

        for (let record of this._informationMap.records.Phones.records) {
            this.formatPhoneRecord(record);
        }
    }

    formatInterimPhoneRecords() {
        if (!this._interimPhones) {
            return;
        }

        for (let record of this._interimPhones) {
            this.formatPhoneRecord(record);
        }
    }

    formatPhoneRecord(phoneRecord) {
        if (!phoneRecord.phoneNumber) {
            return;
        }

        let phoneNumber = phoneRecord.phoneNumber.replace(/[^0-9]/g,'');
        if (!phoneNumber || phoneNumber.length != 10) {
            return;
        }

        let formattedPhoneNumber = this.formatTenDigitPhoneNumber(phoneNumber);
        if (formattedPhoneNumber) {
            phoneRecord.phoneNumber = formattedPhoneNumber;
        }
    }

    formatTenDigitPhoneNumber(phoneNumber) {
        if (!phoneNumber) {
            return '';
        }

        let firstDigitGroup = phoneNumber.substring(0, 3);
        let secondDigitGroup = phoneNumber.substring(3, 6);
        let thirdDigitGroup = phoneNumber.substring(6);
        let formattedTenDigitPhoneNumber = '(' + firstDigitGroup + ') ' + secondDigitGroup + '-' + thirdDigitGroup
        
        return formattedTenDigitPhoneNumber;
    }

    formatContactInformation() {
        if (!this.informationMap.multipleAddresses) {
            let updatedAddresses = []
            for (let record of this._informationMap.records.Addresses.records) {
                if (record.addressLine1 || record.addressLine2
                    || record.addressLine3 || record.addressCity
                || record.addressPostalCode || record.addressState ||record.addressCountry) {
                    updatedAddresses.push(Object.assign({}, record));
                }
            }
            this._informationMap.records.Addresses.records = updatedAddresses;
        }

        if (!this.informationMap.multiplePhones) {
            let updatedPhones = []
            for (let record of this._informationMap.records.Phones.records) {
                if (record.phoneNumber) {
                    updatedPhones.push(Object.assign({}, record));
                }
            }
            this._informationMap.records.Phones.records = updatedPhones;
        }

        if (!this.informationMap.multipleEmails) {
            let updatedEmails = []
            for (let record of this._informationMap.records.Emails.records) {
                if (record.emailAddress) {
                    updatedEmails.push(Object.assign({}, record));
                }
            }
            this._informationMap.records.Emails.records = updatedEmails;
        }
        for (let record of this._informationMap.records.Emails.records) {
            delete record.index;
        }
        for (let record of this._informationMap.records.Phones.records) {
            delete record.index;
        }
        for (let record of this._informationMap.records.Addresses.records) {
            delete record.index;
        }
    }

    renderedCallback() {
        this.equalHeight(true);
        this.equalHeightAddress(true);
    }

    equalHeight = (resize) => {
        let headerElements = this.template.querySelectorAll('.headerEqualHeight');
        let elements = this.template.querySelectorAll(".equalHeight")
        let expandedElements = this.template.querySelectorAll(".element-row");
        let allHeights = [];
        let allHeaderHeights = [];
        let allRowHeights = [];

        if (!headerElements || !elements) {
            return;
        }

        if (resize === true){
            for(let i = 0; i < elements.length; i++){
                elements[i].style.height = 'auto';
            }
            for(let i = 0; i < headerElements.length; i++){
                headerElements[i].style.height = 'auto';
            }
            for(let i = 0; i < expandedElements.length; i++){
                expandedElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < elements.length; i++){
            var elementHeight = elements[i].clientHeight;
            allHeights.push(elementHeight);
        }

        for(let i = 0; i < headerElements.length; i++){
            var elementHeight = headerElements[i].clientHeight;
            allHeaderHeights.push(elementHeight);
        }

        for(let i = 0; i < expandedElements.length; i++){
            var elementHeight = expandedElements[i].clientHeight;
            allRowHeights.push(elementHeight);
        }

        for(let i = 0; i < elements.length; i++){
            elements[i].style.height = Math.max.apply( Math, allHeights) + 'px';
            if(resize === false){
                elements[i].className = elements[i].className + " show";
            }
        }

        for(let i = 0; i < headerElements.length; i++){
            headerElements[i].style.height = Math.max.apply( Math, allHeaderHeights) + 'px';
            if(resize === false){
                headerElements[i].className = headerElements[i].className + " show";
            }
        }

        for(let i = 0; i < expandedElements.length; i++){
            expandedElements[i].style.height = Math.max.apply( Math, allRowHeights) + 'px';
            if(resize === false){
                expandedElements[i].className = expandedElements[i].className + " show";
            }
        }
    }

    equalHeightAddress = (resize) => {
        let addressElements = this.template.querySelectorAll(".equalHeightAddress")
        let allHeights = [];

        if(resize === true){
            for(let i = 0; i < addressElements.length; i++){
                addressElements[i].style.height = 'auto';
            }
        }

        for(let i = 0; i < addressElements.length; i++){
            var elementHeight = addressElements[i].clientHeight;
            allHeights.push(elementHeight);
        }

        for(let i = 0; i < addressElements.length; i++){
            addressElements[i].style.height = Math.max.apply( Math, allHeights) + 'px';
            if(resize === false){
                addressElements[i].className = addressElements[i].className + " show";
            }
        }
    }

    handleEmailTypePicklistChange(modifiedPicklist) {
        this.isAddEmailDisplay = modifiedPicklist;
    }

    handlePhoneTypePicklistChange(modifiedPicklist) {
        this.isAddPhoneDisplay = modifiedPicklist;
    }

    handleAddressTypePicklistChange(modifiedPicklist) {
        this.isAddAddressDisplay = modifiedPicklist;
    }

    findEmailValuesToHideInPicklist() {
        let emailValuesToHideInPicklist = new Set();

        if (this._informationMap && this._informationMap.records && this._informationMap.records.Emails && this._informationMap.records.Emails.records) {
            this._informationMap.records.Emails.records.forEach(record => {
                if (record.emailType) {
                    emailValuesToHideInPicklist.add(record.emailType);
                }
            })
        }

        if (this._interimEmail) {
            this._interimEmail.forEach(record => {
                if (record.emailType) {
                    emailValuesToHideInPicklist.add(record.emailType);
                }
            })
        }
        return emailValuesToHideInPicklist;
    }

    findPhoneValuesToHideInPicklist() {
        let phoneValuesToHideInPicklist = new Set();

        if (this._informationMap && this._informationMap.records && this._informationMap.records.Phones && this._informationMap.records.Phones.records) {
            this._informationMap.records.Phones.records.forEach(record => {
                if (record.phoneType) {
                    phoneValuesToHideInPicklist.add(record.phoneType);
                }
            })
        }

        if (this._interimPhones) {
            this._interimPhones.forEach(record => {
                if (record.phoneType) {
                    phoneValuesToHideInPicklist.add(record.phoneType);
                }
            })
        }

        return phoneValuesToHideInPicklist;
    }

    findAddressValuesToHideInPicklist() {
        let addressValuesToHideInPicklist = new Set();

        if (this._informationMap && this._informationMap.records && this._informationMap.records.Addresses && this._informationMap.records.Addresses.records) {
            this._informationMap.records.Addresses.records.forEach(record => {
                if (record.addressType) {
                    addressValuesToHideInPicklist.add(record.addressType);
                }
            })
        }

        if (this._interimAddresses) {
            this._interimAddresses.forEach(record => {
                if (record.addressType) {
                    addressValuesToHideInPicklist.add(record.addressType);
                }
            })
        }

        return addressValuesToHideInPicklist;
    }

    createPicklistsForEmails(allEmailValues) {
        let emailValuesToHideInPicklist = this.findEmailValuesToHideInPicklist();
        if (this._informationMap && this._informationMap.records && this._informationMap.records.Emails && this._informationMap.records.Emails.records) {
                let newEmailRecords = [...this._informationMap.records.Emails.records];

                if (this.informationMap.multipleEmails) {
                    newEmailRecords.forEach(record => {
                        record.picklistValues = this._emailValues;
                    });
                } else {
                    newEmailRecords.forEach(record => {
                        record.picklistValues = allEmailValues.filter(picklistValue => {
                            return (!emailValuesToHideInPicklist.has(picklistValue.value) || picklistValue.value == record.emailType)
                        });
                    })
                }

                this._informationMap.records.Emails.records = newEmailRecords;
            }

        if (this._interimEmail) {
            let newInterimEmailRecords = [...this._interimEmail];

            if (this.informationMap.multipleEmails) {
                newInterimEmailRecords.forEach(record => {
                    record.picklistValues = this._emailValues;
                });
            } else {
                newInterimEmailRecords.forEach(record => {
                    record.picklistValues = allEmailValues.filter(picklistValue => {
                        return (!emailValuesToHideInPicklist.has(picklistValue.value) || picklistValue.value == record.emailType)
                    });
                });
            }

            this._interimEmail = newInterimEmailRecords;
        }

        this.handleEmailTypePicklistChange(Array.from(emailValuesToHideInPicklist))
    }

    createPicklistsForPhones(allPhoneValues) {
        let phoneValuesToHideInPicklist = this.findPhoneValuesToHideInPicklist();
        if (this._informationMap && this._informationMap.records && this._informationMap.records.Phones && this._informationMap.records.Phones.records) {
            let newPhoneRecords = [...this._informationMap.records.Phones.records];

            if (this.informationMap.multiplePhones) {
                newPhoneRecords.forEach(record => {
                    record.picklistValues = this._phoneValues;
                });
            } else {
                newPhoneRecords.forEach(record => {
                    record.picklistValues = allPhoneValues.filter(picklistValue => {
                        return (!phoneValuesToHideInPicklist.has(picklistValue.value) || picklistValue.value == record.phoneType)
                    });
                });
            }

            this._informationMap.records.Phones.records = newPhoneRecords;
        }

        if (this._interimPhones) {
            let newInterimPhoneRecords = [...this._interimPhones];

            if (this.informationMap.multiplePhones) {
                newInterimPhoneRecords.forEach(record => {
                    record.picklistValues = this._phoneValues;
                });
            } else {
                newInterimPhoneRecords.forEach(record => {
                    record.picklistValues = allPhoneValues.filter(picklistValue => {
                        return (!phoneValuesToHideInPicklist.has(picklistValue.value) || picklistValue.value == record.phoneType)
                    });
                });
            }

            this._interimPhones = newInterimPhoneRecords;
        }

        this.handlePhoneTypePicklistChange(Array.from(phoneValuesToHideInPicklist))
    }

    createPicklistsForAddresses(allAddressValues) {
        let addressValuesToHideInPicklist = this.findAddressValuesToHideInPicklist();
        if (this._informationMap && this._informationMap.records && this._informationMap.records.Addresses && this._informationMap.records.Addresses.records) {
            let newAddressRecords = [...this._informationMap.records.Addresses.records];

            if (this.informationMap.multipleAddresses) {
                newAddressRecords.forEach(record => {
                    record.picklistValues = this._addressValues;
                });
            } else {
                newAddressRecords.forEach(record => {
                    record.picklistValues = allAddressValues.filter(picklistValue => {
                        return (!addressValuesToHideInPicklist.has(picklistValue.value) || picklistValue.value == record.addressType)
                    });
                });
            }

            this._informationMap.records.Addresses.records = newAddressRecords;
        }

        if (this._interimAddresses) {
            let newInterimAddressRecords = [...this._interimAddresses];

            if (this.informationMap.multipleAddresses) {
                newInterimAddressRecords.forEach(record => {
                    record.picklistValues = this._addressValues;
                });
            } else {
                newInterimAddressRecords.forEach(record => {
                    record.picklistValues = allAddressValues.filter(picklistValue => {
                        return (!addressValuesToHideInPicklist.has(picklistValue.value) || picklistValue.value == record.addressType)
                    });
                });
            }

            this._interimAddresses = newInterimAddressRecords;
        }

        this.handleAddressTypePicklistChange(Array.from(addressValuesToHideInPicklist))
    }
}