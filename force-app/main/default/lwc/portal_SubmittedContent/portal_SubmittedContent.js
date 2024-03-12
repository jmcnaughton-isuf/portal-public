import { LightningElement, api, track, wire } from 'lwc';
import getMySubmittedContent from '@salesforce/apex/PORTAL_LWC_SubmittedContentController.SERVER_getMySubmittedContent';
import SERVER_getListingConfigurations from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingConfigurations';
import SERVER_getFrontEndDataMap from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap';

export default class Portal_SubmittedContent extends LightningElement {
    @api pageName = 'Submitted Content';
    @api mainSectionName = 'Submitted Content';
    @api subSectionName = '';
    @api recordType = 'Event';
    @api portalZone = 'All';
    
    @track _listingList = undefined;
    @track _itemsPerPage = 10;
    @track _noResultsText = '';
    @track _frontEndDataMap = undefined;
    @track _columnMappings = [];
    columnFieldIdList = ['name', 'caseStatus', 'eventStartDateTime', 'locationVenue', 'portalZone', 'editLink', 'viewLink', 'cloneLink'];

    @track _isShowSpinner = false;
    @track _isFirstLoad = true;
    
    @wire(SERVER_getListingConfigurations, {params: '$getListingParams'})
    setListingConfigurations({error, data}) {
        if (error) {
            console.log(error);
        }
        
        if (!data) {
            return;
        }
        
        if (data.itemsPerPage) {
            this._itemsPerPage = parseInt(data.itemsPerPage, 10);
        }
        
        if (data.noResultsText) {
            this._noResultsText = data.noResultsText;
        }
    }
    
    @wire(SERVER_getFrontEndDataMap, {params: '$getListingParams'})
    setFrontEndDataMap({error, data}) {
        if (error) {
            console.log(error);
        }
        
        if (!data) {
            return;
        }
        
        this._frontEndDataMap = data;
        this.columnMappings = this.getColumnMappings();
        
        this.getListings();
    }

    getColumnMappings() {
        let returnList = [];
        if (!this._frontEndDataMap) {
            return returnList;
        }
        
        for (let eachFieldId of this.columnFieldIdList) {
            if (this._frontEndDataMap[eachFieldId] && this._frontEndDataMap[eachFieldId].display) {
                const fieldConfiguration = this._frontEndDataMap[eachFieldId];
                returnList.push({
                    label: fieldConfiguration.label,
                    fieldId: fieldConfiguration.fieldId,
                    fieldType: this.getColumnFieldType(fieldConfiguration)
                })
            }
        }

        return returnList;
    }

    getColumnFieldType(fieldConfiguration) {
        if (fieldConfiguration.fieldType == 'textarea' || fieldConfiguration.fieldType == 'picklist') {
            return 'text';
        }

        if (fieldConfiguration.fieldId == 'locationVenue') {
            return 'html';
        }

        return fieldConfiguration.fieldType;
    }

    getListings() {
        this._isShowSpinner = true;

        getMySubmittedContent({params: {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName}})
        .then(result => {
            const resultList = [];
            if (result) {
                result.forEach(eachListing => {
                    const clonedListing = this.processListingRecord(eachListing);

                    resultList.push(clonedListing);
                });
            }

            this._listingList = resultList;
        }).catch(e => {
            console.log(e);
        }).finally(() => {
            this._isShowSpinner = false;
            this._isFirstLoad = false;
        });
    }

    processListingRecord(listingRecord) {
        let returnRecord = {...listingRecord};
        returnRecord.hrefMap = {};

        if (listingRecord.portalZone) {
            returnRecord.portalZone = listingRecord.portalZone.replaceAll(';', ', ');
        }

        if (listingRecord.locationVenue) {
            returnRecord.locationVenue = this.getHtmlFormattedLocation(listingRecord);
        }

        this.setRecordHrefMap(returnRecord);

        return returnRecord;
    }

    getHtmlFormattedLocation(listingRecord) {
        let returnHtml = '';
        if (!listingRecord.locationVenue && !listingRecord.city && !listingRecord.state) {
            return returnHtml;
        }

        if (listingRecord.locationVenue) {
            returnHtml += listingRecord.locationVenue;

            if (listingRecord.city || listingRecord.state) {
                returnHtml += '<br>';
            }
        }

        if (listingRecord.city) {
            returnHtml += listingRecord.city;
        }

        if (listingRecord.state) {
            if (listingRecord.city) {
                returnHtml += ', '
            }

            returnHtml += listingRecord.state;
        }

        return returnHtml;
    }

    setRecordHrefMap(returnRecord) {
        if (returnRecord.caseStatus !== 'Approved')  {
            returnRecord.editLink = 'Edit';
            returnRecord.hrefMap.editLink = './event-submission?recordId=' + returnRecord.id;
        } else {
            returnRecord.viewLink = 'View';
            returnRecord.hrefMap.viewLink = './listing-detail?listingName=' + returnRecord.name + '&recordId=' + returnRecord.id;
        }

        returnRecord.cloneLink = 'Clone';
        returnRecord.hrefMap.cloneLink = './event-submission?recordId=' + returnRecord.id + '&isClone=true';
    }
    
    get getListingParams() {
        return {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};
    }
    
    get hasNoResult() {
        return !this._isFirstLoad && (!this._listingList || this._listingList.length === 0);
    }
}