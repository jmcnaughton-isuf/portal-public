import { callApexFunction } from 'c/portal_util_ApexCallout';
import getFilesForDownload from '@salesforce/apex/PORTAL_LWC_FileDownloadController.SERVER_getFilesForDownload';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildComponentName(componentName) {
        this.result._componentName = componentName;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement = undefined;
    
    _componentName = '';
    _isShowSpinner = true;
    _isShowTable = false;
    _records = undefined;

    setComponentAttribute(field, value) {
        this['_' + field] = value;
        this._lightningElement[field] = value;
    }

    getComponentData() {
        this.setComponentAttribute('isShowTable', false);
        this.setComponentAttribute('isShowSpinner', true);

        callApexFunction(this._lightningElement, getFilesForDownload, {componentName: this._componentName}, (response) => {
            this.handleResponse(response);
        }, (error) => {
            this.setComponentAttribute('isShowSpinner', false);
        });
    }

    handleResponse(response) {
        this.setComponentAttribute('records', this.processRecords(response?.records));

        if (this._records?.length) {
            this.setComponentAttribute('isShowTable', true);
        }

        this.setComponentAttribute('isShowSpinner', false);
    }

    processRecords(recordsList) {
        if (!recordsList) {
            return [];
        }

        let processedRecords = [];
        for (const eachRecord of recordsList) {
            for (const [eachTitle, eachUrl] of Object.entries(eachRecord)) {
                processedRecords.push({
                    key: eachUrl,
                    fileName: eachTitle,
                    download: 'Download',
                    hrefMap: {download: eachUrl}
                });
            }
        }

        return processedRecords;
    }

    get columnMappings() {
        return [
            {
                label: 'File Name',
                fieldId: 'fileName',
                fieldType: 'text'
            }, 
            {
                label: 'Download',
                fieldId: 'download',
                fieldType: 'url'
            }
        ];
    }
}