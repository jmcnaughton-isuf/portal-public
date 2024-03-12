import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getCookie } from 'c/portal_util_Cookie';
import getListingConfigurations from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingConfigurations';
import getListingPicklists from '@salesforce/apex/PORTAL_LWC_ListingSearchController.SERVER_getPicklists';
import eventLocationSearchTemplate from './portal_ListingEventLocationSearch.html';
import newsSearchTemplate from './portal_ListingNewsSearch.html';
import zoneEventsSearchTemplate from './portal_ListingZoneEventsSearch.html';

const URL_PARAM_KEYWORD = 'keyword';
const URL_PARAM_CATEGORY = 'category';
const URL_PARAM_CITY = 'city';
const URL_PARAM_STATE = 'state';
const URL_PARAM_ZIPCODE = 'zipcode';
const URL_PARAM_RADIUS = 'radius';
const URL_PARAM_FEATURED = 'featured';
const URL_PARAM_MOST_VIEWED = 'mostViewed';
const URL_PARAM_RECOMMENDED = 'recommended';
const URL_PARAM_FORMAT = 'format';
const URL_PARAM_ARTICLE_LENGTH = 'articleLength';
const URL_PARAM_TOPIC = 'topic';
const URL_PARAM_ZONE_NAME = 'zname';

export default class Portal_ListingSearch extends LightningElement {
    @api pageName = "";
    @api mainSectionName = "";
    @api subSectionName = "";
    @api searchSectionTitle = "Search News & Learning";
    @api listingSectionTitle = "";

    @track _searchSectionTitle = "";
    @track _listSectionTitle = "";

    _hasUrlParam = false;

    @api design = "";
    @api searchDesign = "";

    @track _isShowSpinner = true;

    @track _listingList = [];
    @track _listingPicklists;
    @track _listingCategories;
    @track _keyword = '';
    @track _category = '';
    @track _city = '';
    @track _state = '';
    @track _country = '';
    @track _zipCode = '';
    @track _radius = 100;
    @track _articleLength = '';
    @track _format = '';
    @track _topic = '';
    @track _isShowOnlineEventsOnly = false;
    @track _onlineEventsOnlyHelpText = '';
    @track _isShowFeaturedOnly = false;
    @track _zoneName = '';
    _cookieId = getCookie('PORTAL_EVENT_SHOPPING_CART_ID');

    @track _hasRendered = false;

    get getListingParams() {
        return {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};
    }

    @wire(getListingConfigurations, {params: '$getListingParams'})
    setListingConfigurations({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        if (data.onlineEventsOnlyHelpText) {
            this._onlineEventsOnlyHelpText = data.onlineEventsOnlyHelpText;
        }
    }

    @wire(getListingPicklists)
    setListingPicklists({error, data}) {
        if (error) {
            console.log(error);
        }

        if (data) {

            let listingPicklists = {};

            for(const eachKey of Object.keys(data)) {
                let label = 'All';

                if (eachKey === 'Country__c') {
                    label = 'Select a Country';
                }
                let picklist = [...data[eachKey]];
                picklist.unshift({'label': label, value: ''});
                listingPicklists[eachKey] = picklist;
            };

            this._listingPicklists = listingPicklists;
        }

        this._isShowSpinner = false;
    }

    handleKeywordInput = (event) => {
        this._keyword = event.target.value;
    }

    handleCategoryChange = (event) => {
        this._category = event.target.value;
    }

    handleCountryChange = (event) => {
        this._country = event.target.value;
    }

    handleArticleLengthChange = (event) => {
        this._articleLength = event.target.value;
    }

    handleTopicChange = (event) => {
        this._topic = event.target.value;
    }

    handleFormatChange = (event) => {
        this._format = event.target.value;
    }

    handleLocationInput = (event) => {
        this[event.target.name] = event.target.value;
    }

    handleRadiusInput = (event) => {
        this._radius = event.target.value;
    }

    handleOnlineEventChange = (event) => {
        this._isShowOnlineEventsOnly = event.target.checked;
    }

    handleSearch() {        
        let location = {city: this._city, state: this._state, country: this._country, postalCode: this._zipCode, distance: this._radius};

        if (this._isShowOnlineEventsOnly) {
            location = null;
        }

        if (this._keyword && this._keyword.length == 1) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Search terms must be more than 1 character long. Please clear your current keyword search or add more characters.',
                variant:"error",
                mode:"sticky"
            });

            this.dispatchEvent(event);
            return;
        }

        let params = {pageName: this.pageName,
                        mainSectionName: this.mainSectionName,
                        subSectionName: this.subSectionName,
                        keyword: this._keyword,
                        category: this._category,
                        location: location,
                        isShowOnlineEventsOnly: this._isShowOnlineEventsOnly,
                        additionalParams: {
                            isShowFeaturedOnly: this._isShowFeaturedOnly,
                            articleLength: this._articleLength,
                            format: this._format,
                            topic: this._topic,
                            zoneName: this._zoneName
                        },
                        cookieId: this._cookieId};
        
        this.template.querySelector('c-portal_-listing').searchListings(params);
    }


    renderedCallback() {
        //using renderedcallback so that we ensure the child component is already loaded for this
        //we only want to run this once so we wrap in a boolean
        if (!this._hasRendered) {

            this._hasRendered = true;

            let urlParams = new URLSearchParams(window.location.search);
            this._keyword = urlParams.get(URL_PARAM_KEYWORD);
            this._category = urlParams.get(URL_PARAM_CATEGORY);
            this._city = urlParams.get(URL_PARAM_CITY);
            this._state = urlParams.get(URL_PARAM_STATE);
            this._zipCode = urlParams.get(URL_PARAM_ZIPCODE);
            this._radius = urlParams.get(URL_PARAM_RADIUS);
            this._format = urlParams.get(URL_PARAM_FORMAT);
            this._articleLength = urlParams.get(URL_PARAM_ARTICLE_LENGTH);
            this._topic = urlParams.get(URL_PARAM_TOPIC);
            this._zoneName = urlParams.get(URL_PARAM_ZONE_NAME);

            let featuredString = urlParams.get(URL_PARAM_FEATURED);
            if (featuredString != null && featuredString.toLowerCase() == 'true') {
                this.mainSectionName = "Featured News Show All";
                this._hasUrlParam = true;
            }

            let isMostViewedString = urlParams.get(URL_PARAM_MOST_VIEWED);
            if (isMostViewedString != null && isMostViewedString.toLowerCase() == 'true') {
                this.mainSectionName = "Most Viewed News Show All";
                this._hasUrlParam = true;
            } 
            
            let isRecommendedString = urlParams.get(URL_PARAM_RECOMMENDED);
            if (isRecommendedString != null && isRecommendedString.toLowerCase() == 'true'){
                this.mainSectionName = "Recommended News Show All";
                this._hasUrlParam = true;
            }

            this.handleSearch();
        }
    }

    setSectionTitles = (searchSectionTitleCMT, listingSectionTitleCMT) => {
        if (this._hasUrlParam){
            this._searchSectionTitle = searchSectionTitleCMT ? searchSectionTitleCMT : this.searchSectionTitle;
            this._listingSectionTitle = listingSectionTitleCMT ? listingSectionTitleCMT : this.listingSectionTitle;    
        
        } else {
            this._searchSectionTitle = this.searchSectionTitle;
            this._listingSectionTitle = this.listingSectionTitle;
        }
    }

    handleClear() {
        this._keyword = '';
        this._category = '';
        this._articleLength = '';
        this._topic = '';
        this._format = '';
        this._city = '';
        this._state = '';
        this._zipCode = '';
        this._radius = '';
        this._country = '';
        this._isShowOnlineEventsOnly = false;

        this.resetPicklists();
    }

    resetPicklists() {
        let newPicklists = {};

        for (const eachKey of Object.keys(this._listingPicklists)) {
            let newList = [];
            for (let eachValue of this._listingPicklists[eachKey]) {
                let newValue = Object.assign({}, eachValue);
                newValue.key = Date.now();
                newList.push(newValue);
            }
            newPicklists[eachKey] = newList;
        };

        this._listingPicklists = newPicklists;
    }

    render() {
        if (this.searchDesign === 'Event Location Search') {
            return eventLocationSearchTemplate;
        } else if (this.searchDesign === 'News Search') {
            return newsSearchTemplate;
        } else if (this.searchDesign === 'Zone Events Search') {
            return zoneEventsSearchTemplate;
        }

        return newsSearchTemplate;
    }
}