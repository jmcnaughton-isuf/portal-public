import { LightningElement, api, track } from 'lwc';
export default class Portal_DirectoryProfileSocialMedia extends LightningElement {
    @api informationMap;

    @track socialMediaFieldMapping = [{fieldId: 'socialMediaPlatform', fieldName: 'ucinn_ascendv2__Platform__c', showFieldName: '', fieldType: 'text'},
                                      {fieldId: 'socialMediaUrl', fieldName: 'ucinn_ascendv2__URL__c', showFieldName: '', fieldType: 'text'}];

    get socialMediaToDisplay() {
        if (!this.informationMap) {
            return [];
        }

        return this.parseRecords(this.informationMap.records.Social_Media.records, this.socialMediaFieldMapping);
    }

    get socialMediaColumnMapping() {
        let resultList = [];

        if (!this.informationMap) {
            return [];
        }

        for (let eachMapping of this.socialMediaFieldMapping) {
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
        if (this.informationMap && this.informationMap.records && this.informationMap.records.Social_Media
                && this.informationMap.records.Social_Media.records && this.informationMap.records.Social_Media.records.length) {
            return true;
        }

        return false;
    }
}