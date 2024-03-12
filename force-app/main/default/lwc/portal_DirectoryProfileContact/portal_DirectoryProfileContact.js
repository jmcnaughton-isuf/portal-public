import { LightningElement, api } from 'lwc';
export default class Portal_DirectoryProfileContact extends LightningElement {
    @api informationMap;

    _emailValues = [{"label":"Home", "value":"Home"}, {"label":"Business", "value":"Business"}, {"label": "Other", "value":"Other"}];
    _phoneValues = [{"label":"Home", "value":"Home"}, {"label":"Business", "value":"Business"}, {"label": "Mobile", "value":"Mobile"}];
    _addressValues = [{"label":"Home", "value":"Home"}, {"label":"Business", "value":"Business"}];

    get firstName() {
        let firstName = this.getRecordValue("firstName");

        if (!firstName) {
            return '-';
        }

        return firstName
    }

    get middleName() {
        let middleName = this.getRecordValue("middleName");

        if (!middleName) {
            return '-';
        }
        return middleName;
    }

    get lastName() {
        return this.getRecordValue("lastName");
    }

    get title() {
        let prefix = this.getRecordValue("prefix");

        if (!prefix) {
            return '-';
        }

        return prefix;
    }

    get suffix() {
        let suffix = this.getRecordValue("suffix");

        if (!suffix) {
            return '-';
        }

        return suffix;
    }

    get businessTitle() {
        let businessTitle = this.getRecordValue("businessTitle");

        if (!businessTitle) {
            return '-';
        }

        return businessTitle;
    }

    get maidenFirstName() {
        let maidenLastName = this.getRecordValue("maidenFirstName");

        if (!maidenLastName) {
            return '-';
        }

        return maidenLastName;
    }

    get maidenMiddleName() {
        let maidenMiddleName = this.getRecordValue("maidenMiddleName");

        if (!maidenMiddleName) {
            return '-';
        }

        return maidenMiddleName;
    }

    get maidenLastName() {
        let maidenLastName = this.getRecordValue("maidenLastName");

        if (!maidenLastName) {
            return '-';
        }

        return maidenLastName;
    }

    get directoryFirstName() {
        let directoryFirstName = this.getRecordValue("directoryFirstName");

        if (!directoryFirstName) {
            return '-';
        }

        return directoryFirstName;
    }

    get directoryLastName() {
        let directoryLastName = this.getRecordValue("directoryLastName");

        if (!directoryLastName) {
            return '-';
        }

        return directoryLastName;
    }

    get nicknameFirstName() {
        let nicknameFirstName = this.getRecordValue("nicknameFirstName");

        if (!nicknameFirstName) {
            return '-';
        }

        return nicknameFirstName;
    }

    get nicknameLastName() {
        let nicknameLastName = this.getRecordValue("nicknameLastName");

        if (!nicknameLastName) {
            return '-';
        }

        return nicknameLastName;
    }

    get gender() {
        let gender = this.getRecordValue("gender");

        if (!gender) {
            return '-';
        }

        return gender;
    }

    get pronoun() {
        let pronoun = this.getRecordValue("pronoun");

        if (!pronoun) {
            return '-';
        }

        return pronoun;
    }

    get birthdate() {
        if (this.informationMap?.frontEndData?.birthdate?.displayStagingRecordInRealTime && this._interim?.ucinn_ascendv2__Birthdate__c) {
            return this._interim.ucinn_ascendv2__Birthdate__c;
        } else if (this.informationMap?.records?.Personal_Information?.Additional_Details?.length > 0) {
            let day = this.informationMap.records.Personal_Information.Additional_Details[0].ucinn_ascendv2__Birth_Day__c;
            let month = this.informationMap.records.Personal_Information.Additional_Details[0].ucinn_ascendv2__Birth_Month__c;
            let year = this.informationMap.records.Personal_Information.Additional_Details[0].ucinn_ascendv2__Birth_Year__c;

            if (day && month && year) {
                return year + '-' + month + '-' + day;
            }
        }
        return '-';
    }

    get maritalStatus() {
        let maritalStatus = this.getRecordValue("maritalStatus");

        if (!maritalStatus) {
            return '-';
        }

        return maritalStatus;
    }

    get spouseFirstName() {
        let spouseFirstName = this.getRecordValue("spouseFirstName");

        if (!spouseFirstName) {
            return '-';
        }

        return spouseFirstName;
    }

    get spouseLastName() {
        let spouseLastName = this.getRecordValue("spouseLastName");

        if (!spouseLastName) {
            return '-';
        }

        return spouseLastName;
    }

    get isShowEmails() {
        if (this.informationMap.records && this.informationMap.records.Emails
                    && this.informationMap.records.Emails.records && this.informationMap.records.Emails.records.length) {
            return true;
        }

        return false;
    }

    get isDisplayMaidenName() {
        return this.informationMap?.records?.Privacy_Settings?.Directory_Setting?.[0]?.Is_Show_Maiden_Name__c;
    }

    get isDisplayNickname() {
        return this.informationMap?.records?.Privacy_Settings?.Directory_Setting?.[0]?.Is_Show_Nickname__c;
    }

    get isDisplayAlsoKnownAsHeader() {
        return this.isDisplayMaidenName || this.isDisplayNickname;
    }

    get isDisplayGender() {
        return this.informationMap?.records?.Privacy_Settings?.Directory_Setting?.[0]?.Is_Show_Gender__c;
    }

    get isDisplayPronouns() {
        return this.informationMap?.records?.Privacy_Settings?.Directory_Setting?.[0]?.Is_Show_Pronouns__c;
    }

     get isShowPhones() {
        if (this.informationMap.records && this.informationMap.records.Phones
                    && this.informationMap.records.Phones.records && this.informationMap.records.Phones.records.length) {
            return true;
        }

        return false;
    }

    get isShowAddresses() {
        if (this.informationMap.records && this.informationMap.records.Addresses
                    && this.informationMap.records.Addresses.records && this.informationMap.records.Addresses.records.length) {
            return true;
        }

        return false;
    }

    get areStreetsVisible() {
        if (this.informationMap && this.informationMap.frontEndData && this.informationMap.frontEndData.addressLine1 &&
            this.informationMap.frontEndData.addressLine2 && this.informationMap.frontEndData.addressLine3 ) {
                return this.informationMap.frontEndData.addressLine1.display || this.informationMap.frontEndData.addressLine2.display
                || this.informationMap.frontEndData.addressLine3.display;
        }
        return false;
    }

    getRecordValue (field)  {
        let mainSection = this.informationMap.frontEndData[field].mainSection;
        let subSection = this.informationMap.frontEndData[field].subSection;
        let fieldName = this.informationMap.frontEndData[field].fieldName;
        let filterValue = this.informationMap.frontEndData[field].filterValue;
        let filterField = this.informationMap.frontEndData[field].filterField;
        let isPicklist = this.informationMap.frontEndData[field].isPicklist;
        let stagingRecordFieldName = this.informationMap.frontEndData[field].stagingRecordFieldName;

        if (!subSection) {
            subSection = 'records';
        }

        try {
            if (!isPicklist) {
                if (stagingRecordFieldName == 'ucinn_ascendv2__Significant_Other_First_Name__c' || stagingRecordFieldName == 'ucinn_ascendv2__Significant_Other_Last_Name__c') {
                    if (this._spousalInterim && this._spousalInterim[stagingRecordFieldName]) {
                        if (this._spousalInterim[stagingRecordFieldName] == 'isDeleted') {
                            return '';
                        }
                        return this._spousalInterim[stagingRecordFieldName];
                    }
                } else {
                    if (this._interim && this._interim[stagingRecordFieldName]) {
                        if (this._interim[stagingRecordFieldName] == 'isDeleted') {
                            return '';
                        }
                        return this._interim[stagingRecordFieldName];
                    }

                }

                if (filterValue) {
                    for (let record of this.informationMap['records'][mainSection][subSection]) {
                        if (record[filterField] == filterValue) {
                            if (fieldName.includes('.')) {
                                let fields = fieldName.split('.');
                                return record[fields[0]][fields[1]]
                            }
                            return record[fieldName];
                        }
                    }
                } else {
                    if (!this.informationMap?.records?.[mainSection]?.[subSection]
                        || this.informationMap?.records?.[mainSection]?.[subSection]?.length <= 0) {
                        return '';
                    }
                    if (fieldName.includes('.')) {
                        let fields = fieldName.split('.');

                        if (!this.informationMap?.records?.[mainSection][subSection][0][fields[0]]) {
                            return '';
                        }
                        
                        return this.informationMap['records'][mainSection][subSection][0][fields[0]][fields[1]]
                    }
                    return this.informationMap['records'][mainSection][subSection][0][fieldName];
                }


            } else {
                for (let picklistValue of this.informationMap.picklists[field]) {
                    if (this._interim  && this._interim[stagingRecordFieldName]) {
                        if (picklistValue.value == this._interim[stagingRecordFieldName]) {
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

    /* Table Logic */


    emailFieldMapping = [{fieldId: 'emailAddress', fieldName: 'ucinn_ascendv2__Email_Address__c', showFieldName: '', fieldType: 'text'},
                         {fieldId: 'emailType', fieldName: 'ucinn_ascendv2__Type__c', showFieldName: '', fieldType: 'text'},
                         {fieldId: 'emailIsPreferred', fieldName: 'ucinn_ascendv2__Is_Preferred__c', showFieldName: '', fieldType: 'text'}];

    phoneFieldMapping = [{fieldId: 'phoneNumber', fieldName: 'ucinn_ascendv2__Phone_Number__c', showFieldName: '', fieldType: 'text'},
                         {fieldId: 'phoneType', fieldName: 'ucinn_ascendv2__Type__c', showFieldName: '', fieldType: 'text'},
                         {fieldId: 'phoneIsPreferred', fieldName: 'ucinn_ascendv2__Is_Preferred__c', showFieldName: '', fieldType: 'text'}];

    addressFieldMapping = [{fieldId: 'addressCity', fieldName: 'city', showFieldName: 'ucinn_portal_Is_Show_City__c', fieldType: 'text'},
                           {fieldId: 'addressState', fieldName: 'state', showFieldName: 'ucinn_portal_Is_Show_State__c', fieldType: 'text'},
                           {fieldId: 'addressPostalCode', fieldName: 'postalCode', showFieldName: 'ucinn_portal_Is_Show_Postal_Code__c', fieldType: 'text'},
                           {fieldId: 'addressCountry', fieldName: 'country', showFieldName: 'ucinn_portal_Is_Show_Country__c', fieldType: 'text'},
                           {fieldId: 'addressType', fieldName: 'ucinn_ascendv2__Type__c', showFieldName: '', fieldType: 'text'},
                           {fieldId: 'addressIsPreferred', fieldName: 'ucinn_ascendv2__Is_Preferred__c', showFieldName: '', fieldType: 'text'}];


    get emailsToDisplay() {
        if (!this.informationMap) {
            return [];
        }

        let resultList = [];
        for (let eachRecord of this.informationMap.records.Emails.records) {
            let newRecord = Object.assign({}, eachRecord);
            let isPreferred = 'Yes';

            if (!eachRecord.ucinn_ascendv2__Is_Preferred__c) {
                isPreferred = 'No';
            }

            newRecord.ucinn_ascendv2__Is_Preferred__c = isPreferred;

            resultList.push(newRecord);
        }

        return this.parseRecords(resultList, this.emailFieldMapping);
    }

    get phonesToDisplay() {
        if (!this.informationMap) {
            return [];
        }

        let resultList = [];
        for (let eachRecord of this.informationMap.records.Phones.records) {
            let newRecord = Object.assign({}, eachRecord);
            let isPreferred = 'Yes';

            if (!eachRecord.ucinn_ascendv2__Is_Preferred__c) {
                isPreferred = 'No';
            }

            newRecord.ucinn_ascendv2__Is_Preferred__c = isPreferred;

            resultList.push(newRecord);
        }

        return this.parseRecords(resultList, this.phoneFieldMapping);
    }

    get addressesToDisplay() {
        if (!this.informationMap) {
            return [];
        }

        let resultList = [];
        for (let eachRecord of this.informationMap.records.Addresses.records) {
            let newRecord = Object.assign({}, eachRecord);
            let isPreferred = 'Yes';

            if (!eachRecord.ucinn_ascendv2__Is_Preferred__c) {
                isPreferred = 'No';
            }

            newRecord.street = '';
            if (eachRecord.ucinn_portal_Is_Show_Address_Lines__c) {
                if (this.informationMap.frontEndData.addressLine1.display && newRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c) {
                    newRecord.street = newRecord.street + newRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_1__c;
                }

                if (this.informationMap.frontEndData.addressLine2.display && newRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_2__c) {
                    newRecord.street = newRecord.street + '<br/>' + newRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_2__c;
                }

                if (this.informationMap.frontEndData.addressLine3.display && newRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_3__c) {
                    newRecord.street = newRecord.street + '<br/>' + newRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Address_Line_3__c;
                }
            }

            newRecord.ucinn_ascendv2__Is_Preferred__c = isPreferred;
            newRecord.city = eachRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__City__c;
            newRecord.state = eachRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__State__c;
            newRecord.postalCode = eachRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Postal_Code__c;
            newRecord.country = eachRecord.ucinn_ascendv2__Address__r.ucinn_ascendv2__Country__c;

            resultList.push(newRecord);
        }

        return this.parseRecords(resultList, this.addressFieldMapping);
    }

    // get employmentsToDisplay() {
    //     if (!this.informationMap) {
    //         return [];
    //     }

    //     let resultList = [];
    //     for (let eachRecord of this.informationMap.records.Employment.) {
    //         let newRecord = Object.assign({}, eachRecord);
    //         newRecord.employer = eachRecord.ucinn_ascendv2__Account__r.Name;

    //         resultList.push(newRecord);
    //     }

    //     return this.parseRecords(resultList, this.employmentFieldMapping);
    // }

    get emailColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        for (let eachMapping of this.emailFieldMapping) {
            if (this.informationMap.frontEndData[eachMapping.fieldId].display) {
                resultList.push({label: this.informationMap.frontEndData[eachMapping.fieldId].label, fieldId: eachMapping.fieldName, fieldType: eachMapping.fieldType});
            }
        }

        return resultList;
   }

    get phoneColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        for (let eachMapping of this.phoneFieldMapping) {
            if (this.informationMap.frontEndData[eachMapping.fieldId].display) {
                resultList.push({label: this.informationMap.frontEndData[eachMapping.fieldId].label, fieldId: eachMapping.fieldName, fieldType: eachMapping.fieldType});
            }
        }

        return resultList;
   }

    get addressColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        if (this.areStreetsVisible) {
            resultList.push({label: 'Street', fieldId: 'street', fieldType: 'html'})
        }

        for (let eachMapping of this.addressFieldMapping) {
            if (this.informationMap.frontEndData[eachMapping.fieldId].display) {
                resultList.push({label: this.informationMap.frontEndData[eachMapping.fieldId].label, fieldId: eachMapping.fieldName, fieldType: eachMapping.fieldType});
            }
        }

        return resultList;
   }

    parseRecords(recordList, fieldMappingList) {
        let resultList = [];

        for (let eachRecord of recordList) {
            let newRecord = Object.assign({}, eachRecord);
            for (let eachFieldMapping of fieldMappingList) {
                if (!eachFieldMapping.showFieldName || newRecord[eachFieldMapping.showFieldName]) {
                    continue;
                }

                newRecord[eachFieldMapping.fieldName] = '';
            }

            resultList.push(newRecord);
        }

        return resultList
    }
}