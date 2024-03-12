import { LightningElement, api, track } from 'lwc';

export default class Portal_MyInformationContact_v2OR extends LightningElement {
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
            this.template.querySelector('c-portal_-My-Information-Address_v2-O-R')
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
    getUpdatedRecordsMap() {
        let childComponentList = [
            this.template.querySelector('c-portal_-My-Information-Personal-Info_v2'),
            this.template.querySelector('c-portal_-My-Information-Email_v2'),
            this.template.querySelector('c-portal_-My-Information-Phone_v2'),
            this.template.querySelector('c-portal_-My-Information-Address_v2-O-R')
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