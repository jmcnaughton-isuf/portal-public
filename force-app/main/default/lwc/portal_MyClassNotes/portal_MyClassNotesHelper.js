import { callApexFunction } from 'c/portal_util_ApexCallout';
import getMySubmittedContent from '@salesforce/apex/PORTAL_LWC_SubmittedContentController.SERVER_getMySubmittedContent';
import getFrontEndDataMap from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap';
import getListingConfigurations from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingConfigurations';

export class ComponentLogicBuilder {
    result;

    constructor() {
        this.result = new ComponentLogic();
    }

    buildLightningElement(lightningElement) {
        this.result._lightningElement = lightningElement;
        return this;
    }

    buildPageName(pageName) {
        this.result._pageName = pageName;
        return this;
    }

    buildMainSectionName(mainSectionName) {
        this.result._mainSectionName = mainSectionName;
        return this;
    }

    build() {        
        return this.result;
    }
}

export class ComponentLogic {
    _lightningElement;
    _pageName = '';
    _mainSectionName = '';

    _recordList = [];
    _sectionConfiguration = {};
    _columnMappings = [];
    _columnList = ['submissionCategory', 'status', 'createdDate', 'classNoteContent'];
    _noResultsText = '';
    _itemsPerPage = 10;

    get recordList() {
        return this._recordList;
    }

    get sectionConfiguration() {
        return this._sectionConfiguration;
    }

    get columnMappings() {
        return this._columnMappings;
    }

    get noResultsText() {
        return this._noResultsText;
    }

    get itemsPerPage() {
        return this._itemsPerPage;
    }

    set recordList(recordList) {
        this._recordList = recordList;
        this._lightningElement.componentAttributes.recordList = recordList;
    }
    
    set sectionConfiguration(sectionConfiguration) {
        this._sectionConfiguration = sectionConfiguration;
        this._lightningElement.componentAttributes.sectionConfiguration = sectionConfiguration;
    }

    set columnMappings(columnMappings) {
        this._columnMappings = columnMappings;
        this._lightningElement.componentAttributes.columnMappings = columnMappings;
    }

    set noResultsText(noResultsText) {
        this._noResultsText = noResultsText;
        this._lightningElement.componentAttributes.noResultsText = noResultsText;
    }

    set itemsPerPage(itemsPerPage) {
        this._itemsPerPage = itemsPerPage;
        this._lightningElement.componentAttributes.itemsPerPage = itemsPerPage;
    }

    getComponentData() {
        let params = {
            pageName: this._pageName,
            mainSectionName: this._mainSectionName
        }

        this._lightningElement._isShowSpinner = true;

        Promise.all([
            callApexFunction(this._lightningElement, getFrontEndDataMap, params, (response) => {
                this.setComponentSectionConfiguration(response);
            }, () => {}),
            callApexFunction(this._lightningElement, getMySubmittedContent, params, (response) => {
                this.setComponentRecordList(response);
            }, () => {}),
            callApexFunction(this._lightningElement, getListingConfigurations, params, (response) => {
                this.noResultsText = response.noResultsText;
                this.itemsPerPage = response.itemsPerPage;
            }, () => {})
        ]).finally(() => {
            this._lightningElement._isShowSpinner = false;
        });
    }

    setComponentSectionConfiguration(response) {
        if (!response) {
            return;
        }

        this.sectionConfiguration = {...response};
        this.columnMappings = this.getColumnMappings();
    }

    getColumnMappings() {
        let resultList = [];
        if (!this.sectionConfiguration) {
            return resultList;
        }

        for (let eachFieldId of this._columnList) {
            if (this.sectionConfiguration[eachFieldId] && this.sectionConfiguration[eachFieldId].display) {
                const fieldConfiguration = this.sectionConfiguration[eachFieldId];
                resultList.push({
                    label: fieldConfiguration.label,
                    fieldId: fieldConfiguration.fieldId,
                    fieldType: fieldConfiguration.fieldType == 'textarea' || fieldConfiguration.fieldType == 'picklist' ? 'text' : fieldConfiguration.fieldType
                });
            }
        }

        return resultList;
    }

    setComponentRecordList(response) {
        if (!response) {
            return;
        }

        let recordListClone = [];
        for (let eachClassNotesRecord of response) {
            recordListClone.push({
                ...eachClassNotesRecord,
                classNoteContent: this.truncateClassNoteContent(eachClassNotesRecord?.classNoteContent),
                submissionCategory: eachClassNotesRecord.submissionCategory ? eachClassNotesRecord.submissionCategory.replaceAll(';', ', ') : ''
                // classNotesLink: this.getClassNotesLink(eachClassNotesRecord.Id)
            });
        }

        this.recordList = recordListClone;
    }

    // getClassNotesLink(classNotesRecordId) {
    //     TODO;
    // }

    truncateClassNoteContent(noteContent) {
        if (!noteContent) {
            return '';
        }

        // Remove HTML tags using RegExp
        const cleanNoteContent = noteContent.replace(/<\/?[^>]+>/g, '');

        // Return the first 5 words (truncated to less than 40 chars) + an ellipsis
        return cleanNoteContent.split(' ').slice(0, 5).join(' ').slice(0, 40) + '...';
    }
}