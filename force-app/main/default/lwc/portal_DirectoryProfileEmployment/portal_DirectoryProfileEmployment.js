import { LightningElement, api, track } from 'lwc';

export default class Portal_DirectoryProfileEmployment extends LightningElement {
    @api informationMap;

    @track employmentFieldMapping = [{fieldId: 'employer', fieldName: 'employer', showFieldName: 'ucinn_portal_Is_Show_Employer__c', fieldType: 'text'},
                                     {fieldId: 'jobTitle', fieldName: 'ucinn_ascendv2__Job_Title__c', showFieldName: 'ucinn_portal_Is_Show_Job_Title__c', fieldType: 'text'},
                                     {fieldId: 'employmentStartDate', fieldName: 'ucinn_ascendv2__Start_Date__c', showFieldName: '', fieldType: 'date'},
                                     {fieldId: 'employmentEndDate', fieldName: 'ucinn_ascendv2__End_Date__c', showFieldName: '', fieldType: 'date'}];

    get employmentsToDisplay() {
        if (!this.informationMap) {
            return [];
        }

        let resultList = [];
        for (let eachRecord of this.informationMap.records.Employment.records) {
            let newRecord = Object.assign({}, eachRecord);
            newRecord.employer = eachRecord.ucinn_ascendv2__Account__r.Name;

            resultList.push(newRecord);
        }

        return this.parseRecords(resultList, this.employmentFieldMapping);
    }

    get employmentColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        for (let eachMapping of this.employmentFieldMapping) {
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

    get isShowSection() {
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Employment
                && this.informationMap.records.Employment.records && this.informationMap.records.Employment.records.length) {
            return true;
        }

        return false;
    }
}