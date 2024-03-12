import { LightningElement, api, track } from 'lwc';
export default class Portal_DirectoryProfileDegree extends LightningElement {
    @api informationMap;

    @track degreeFieldMappingList = [{fieldId: 'schoolDegreeDegree', fieldName: 'ucinn_ascendv2__Degree__c', showFieldName: 'ucinn_portal_Is_Show_Degree__c'},
                                     {fieldId: 'schoolDegreeAcademicOrg', fieldName: 'ucinn_ascendv2__School_1_Formula__c', showFieldName: ''},
                                     {fieldId: 'schoolDegreeYear', fieldName: 'ucinn_ascendv2__Conferred_Degree_Year__c', showFieldName: 'ucinn_portal_Is_Show_Degree_Year__c'},
                                     {fieldId: 'schoolDegreeMajor', fieldName: 'ucinn_ascendv2__Major_Formula__c', showFieldName: 'ucinn_portal_Is_Show_Major__c'},
                                     {fieldId: 'schoolDegreeMinor', fieldName: 'ucinn_ascendv2__Minor_Formula__c', showFieldName: 'ucinn_portal_Is_Show_Minor__c'}];

    @track nonSchoolDegreeFieldMappingList = [{fieldId: 'nonSchoolDegreeInstitution', fieldName: 'degreeInstitution', showFieldName: 'ucinn_portal_Is_Show_Institution__c'},
                                              {fieldId: 'nonSchoolDegreeDegree', fieldName: 'ucinn_ascendv2__Degree__c', showFieldName: 'ucinn_portal_Is_Show_Degree__c'},
                                              {fieldId: 'nonSchoolDegreeYear', fieldName: 'ucinn_ascendv2__Conferred_Degree_Year__c', showFieldName: 'ucinn_portal_Is_Show_Degree_Year__c'},
                                              {fieldId: 'nonSchoolDegreeMajor', fieldName: 'ucinn_ascendv2__Non_School_Major__c', showFieldName: 'ucinn_portal_Is_Show_Major__c'}];

    get degreesToDisplay() {
        if (!this.informationMap) {
            return [];
        }


        return this.parseRecords(this.informationMap.records.Degrees.School_Degree_Information, this.degreeFieldMappingList);
    }

    get nonSchoolDegreesToDisplay() {
        if (!this.informationMap) {
            return [];
        }

        let resultList = [];
        for (let eachRecord of this.informationMap.records.Degrees.Non_School_Degree_Information) {
            let newRecord = Object.assign({}, eachRecord);
            newRecord.degreeInstitution = eachRecord.ucinn_ascendv2__Degree_Institution__r.Name;

            resultList.push(newRecord);
        }

        return this.parseRecords(resultList, this.nonSchoolDegreeFieldMappingList);
    }

    get degreeColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        for (let eachMapping of this.degreeFieldMappingList) {
            if (this.informationMap.frontEndData[eachMapping.fieldId].display) {
                resultList.push({label: this.informationMap.frontEndData[eachMapping.fieldId].label, fieldId: eachMapping.fieldName, fieldType: 'text'});
            }
        }

        return resultList;
   }

    get nonSchoolDegreeColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        for (let eachMapping of this.nonSchoolDegreeFieldMappingList) {
            if (this.informationMap.frontEndData[eachMapping.fieldId].display) {
                resultList.push({label: this.informationMap.frontEndData[eachMapping.fieldId].label, fieldId: eachMapping.fieldName, fieldType: 'text'});
            }
        }

        return resultList;
   }

    get isShowSchoolDegrees() {
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Degrees
                && this.informationMap.records.Degrees.School_Degree_Information
                && this.informationMap.records.Degrees.School_Degree_Information.length) {
            return true;
        }
        return false;
    }

    get isShowNonSchoolDegrees() {
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Degrees
                && this.informationMap.records.Degrees.Non_School_Degree_Information
                && this.informationMap.records.Degrees.Non_School_Degree_Information.length) {
            return true;
        }
        return false;
    }

    get isShowSection() {
        return this.isShowSchoolDegrees || this.isShowNonSchoolDegrees;
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