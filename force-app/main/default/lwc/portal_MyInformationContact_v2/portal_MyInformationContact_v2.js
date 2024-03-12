import { LightningElement, api, track } from 'lwc';

export default class Portal_MyInformationContact_v2 extends LightningElement {
    @track _isDisplay = false;
    @track _displayMode = 'view';

    @api 
    get isDisplay() {
        return this._isDisplay
    }

    set isDisplay(isDisplay) {
        this._isDisplay = isDisplay;
    }

    @api
    get displayMode() {
        return this._displayMode;
    }

    set displayMode(displayMode) {
        this._displayMode = displayMode;
    }

    get isViewDisplay() {
        return this.displayMode === 'view';
    }

    @api
    checkAndReportInputValidity() {
        let childComponentList = [
            this.template.querySelector('c-portal_-My-Information-Personal-Info_v2'),
            this.template.querySelector('c-portal_-My-Information-Email_v2'),
            this.template.querySelector('c-portal_-My-Information-Phone_v2'),
            this.template.querySelector('c-portal_-My-Information-Address_v2')
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
            this.template.querySelector('c-portal_-My-Information-Personal-Info_v2'),
            this.template.querySelector('c-portal_-My-Information-Email_v2'),
            this.template.querySelector('c-portal_-My-Information-Phone_v2'),
            this.template.querySelector('c-portal_-My-Information-Address_v2')
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
            this.template.querySelector('c-portal_-My-Information-Personal-Info_v2'),
            this.template.querySelector('c-portal_-My-Information-Email_v2'),
            this.template.querySelector('c-portal_-My-Information-Phone_v2'),
            this.template.querySelector('c-portal_-My-Information-Address_v2')
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