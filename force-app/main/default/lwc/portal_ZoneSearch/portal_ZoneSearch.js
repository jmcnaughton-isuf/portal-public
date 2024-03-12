import { api, track, LightningElement, wire } from 'lwc';
import initZoneSearch from '@salesforce/apex/PORTAL_LWC_ZoneSearchController.SERVER_initZoneSearch';
import getZoneRecords from '@salesforce/apex/PORTAL_LWC_ZoneSearchController.SERVER_getZoneRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Portal_MyMembershipSearch extends LightningElement {
    @api recordTypes;
    @api leadershipLabel;
    @api center;
    @api zoomLevel;
    @api markerTitle;
    @api hideMarkerList;
    @api hideMap;
    @api hideCityAndState;
    @api hideZipCode;
    @api hideRadius;
    @api hideCountries;
    @api hideNameSearch;
    @track zoneData = [];
    @api itemsPerPage;
    @track currentPageNumber = 1;
    countriesList = [];
    hideSearch = false;
    frontEndDataMap = {};
    searchActive = false;

    // search criteria
    @api radius;
    nameSearch = '';
    city = '';
    state = '';
    zipcode = '';
    selectedCountry = '';

    // default value for radius. Set inside init()
    defaultRadius = '';

    lastZoneSearchParams = {};
    get initializeZoneSearchParams() {
        let locationObject = {city: this.city, state: this.state, postalCode: this.zipcode, country: this.selectedCountry, distance: this.radius};
        let params = {nameSearchInput: this.nameSearch, location: locationObject, recordTypeDeveloperNamesCommaSeperated: this.recordTypes, offset: 0};

        this.lastZoneSearchParams = params;

        return params;
    }

    connectedCallback() {
        this.init();
    }

    init = () => {
        if (this.hideCityAndState && this.hideZipCode && this.hideRadius && this.hideCountries && this.hideNameSearch) {
            this.hideSearch = true;
        }

        this.defaultRadius = this.radius;

        this.searchActive = true;
        initZoneSearch({params : this.initializeZoneSearchParams})
        .then(response => {
            this.frontEndDataMap = response.frontEndDataMap;
            this.zoneData = [...response.records];
            this.hasMoreRecords = response.hasMoreRecords;
            
            this.zoneData.forEach(zoneRecord => {
                this.formatTableData(zoneRecord);
            })
            
            this.countriesList = this.countriesList.concat(response.countries);
        })
        .catch(error => {
            this.showNotification('Error', error.body.message, 'error');
        })
        .finally(() => {
            this.searchActive = false;
        })
    }

    getMoreZoneRecords = (event) => {
        if (this.hasMoreRecords) {
            this.queryForZoneRecords({params : {...this.lastZoneSearchParams, offset: event.detail.offset}}, event.detail.pageNumber + 1);
        }
    }

    search = (event) => {
        if(!this.isValidRadius() || !this.isValidGeolocationSearchInput()) {
            return;
        }

        this.zoneData = [];
        this.queryForZoneRecords({params : this.initializeZoneSearchParams}, 1);
    }

    queryForZoneRecords(params, newPageNumber) { 
        this.searchActive = true;
        getZoneRecords(params)
        .then(response => {
            this.zoneData = [...this.zoneData, ...response.formattedZonesList];
            this.hasMoreRecords = response.hasMoreRecords;

            this.zoneData.forEach(zoneRecord => {
                this.formatTableData(zoneRecord);
            });

            this.currentPageNumber = newPageNumber;
        })
        .catch(error => {
            this.showNotification('Error', error.body.message, 'error');
        })
        .finally(() => {
            this.searchActive = false;
        });
    }

    formatTableData(record) {
        if (!this.frontEndDataMap || Object.keys(this.frontEndDataMap).length <= 0) {
            return;
        }

        // making the html elements for table module, Zone Homepage and Club column
        record.homePageHTML = '<a href="zone-home-page?zname=' + encodeURIComponent(record.Name) + '" target="_blank">' + record.Name + '</a>';

        // making the html elements for Club Leadership column
        record.leadershipHTML = '<a href="zone-leadership?zname=' + encodeURIComponent(record.Name) + '" target="_blank">' + this.leadershipLabel + '</a>';

        // making the html elements for Name column
        let titleString = '';
        let nameString = '';
        let email = '';
        let phone = '';

        if (this.frontEndDataMap.contactTitle?.display && record.contactTitle) {
            titleString = record.contactTitle;
        }

        if (this.frontEndDataMap.contactName?.display && record.contactName) {
            nameString = ' ' + record.contactName;
        }
        
        if (this.frontEndDataMap.contactEmail?.display && record.contactEmail) {
            email = record.contactEmail;
        } 

        if (this.frontEndDataMap.contactPhone?.display && record.contactPhone) {
            phone = record.contactPhone;
        }

        record.primaryContactHTML = '<p>' + titleString + nameString + '</p>\n<p>\n<a href>' + email + '</a>\n</p><p>' + phone + '</p>';

        // making the html elements for the Media column
        record.socialMediaHTML = '<div class="social-media-links">\n<div class="container">\n'
        record.socialMedia?.forEach(eachSocialMedia => {
            if (eachSocialMedia.logoLink && eachSocialMedia.logoURL) {
                record.socialMediaHTML += '<a href="' + eachSocialMedia.logoLink + '" key="' + eachSocialMedia.logoLink + '"target="_blank"><img style="width: 100%; max-width: 24px;" src="' + eachSocialMedia.logoURL + '"></img></a>';
            }
        })
        record.socialMediaHTML += '</div>\n</div>';
    }

    handlePicklistChange = (event) => {
        this.selectedCountry = event.target.value;
    }

    inputOnChange = (event) => {
        let inputName = event.target.name;
        let value = event.target.value;

        if (!value) {
            value = null;
        }

        if (inputName == 'city') {
            this.city = value;
        }
        else if (inputName == 'state') {
            this.state = value;
        }
        else if (inputName == 'zipCode') {
            this.zipcode = value;
        }
        else if (inputName == 'radius') {
            this.radius = value;
        }
        else if (inputName == 'nameSearch') {
            this.nameSearch = value;
        }
    }

    resetSearch = (event) => {
        this.nameSearch = '';
        this.city = '';
        this.state = '';
        this.zipcode = '';
        this.selectedCountry = '';
        this.radius = this.defaultRadius;
    }

    isValidRadius() {
        // Check if radius exists & is within acceptable bounds
        if (this.radius && (this.radius < 1 || this.radius > 99999)) {
            this.showNotification('Invalid Radius.',
                                  'Enter a positive value up to 5 digits long; or leave blank to use text search.',
                                  'error');
            return false;
        }

        return true;
    }

    isValidGeolocationSearchInput() {
        // If radius is populated, don't do a geolocation search with only a state and/or country. Should have a city and/or postal code.
        if (this.radius != null && !this.city && !this.zipcode && (this.selectedCountry || this.state)) {
            this.showNotification('Invalid Geolocation Input.',
                                  'Please include a city and/or postal code when using geolocation search; or leave radius blank to use text search.',
                                  'error');
            return false;
        }

        return true;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'sticky'
        });

        this.dispatchEvent(evt);
    }
}