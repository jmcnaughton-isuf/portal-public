import { LightningElement, api } from 'lwc';

export default class Portal_MyInformationContactPreferences_v2 extends LightningElement {
    @api displayMode = 'view';
    @api isDisplay = false;

    @api
    checkAndReportInputValidity() {
        let childComponentList = [
                this.template.querySelector('c-portal_-My-Information-Privacy-Settings_v2'),
                this.template.querySelector('c-portal_-My-Information-Service-Indicators_v2')
            ];
            
        for (let eachComponent of childComponentList) {
            if (!eachComponent || eachComponent.checkAndReportInputValidity()) {
                continue;
            }
            
            return false;
        }
        
        return true;
    }

    @api
    getInvalidFieldList() {
        let childComponentList = [
            this.template.querySelector('c-portal_-My-Information-Privacy-Settings_v2'),
            this.template.querySelector('c-portal_-My-Information-Service-Indicators_v2')
        ];

        let invalidFieldList = [];
        for (let eachComponent of childComponentList) {
            if (!eachComponent) {
                continue;
            }
            
            invalidFieldList.push(...eachComponent.getInvalidFieldList());
        }
        return invalidFieldList;
    }

    @api
    getUpdatedRecordsMap() {
        let childComponentList = [
                this.template.querySelector('c-portal_-My-Information-Privacy-Settings_v2'),
                this.template.querySelector('c-portal_-My-Information-Service-Indicators_v2')
            ];

        let sectionIdToUpdatedRecordsMap = {};

        for (let eachComponent of childComponentList) {
            if (!eachComponent) {
                continue;
            }

            sectionIdToUpdatedRecordsMap = Object.assign(sectionIdToUpdatedRecordsMap, eachComponent.getUpdatedRecordsMap());
        }

        return sectionIdToUpdatedRecordsMap;
    }
}