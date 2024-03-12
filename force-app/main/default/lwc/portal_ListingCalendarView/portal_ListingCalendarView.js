import { LightningElement, api, track } from 'lwc';

const URL_PARAM_ZONE_NAME = 'zname';

export default class Portal_ListingCalendarView extends LightningElement {
    @api pageName;
    @api mainSectionName;
    @api subSectionName;
    @api noResultsMobileMessage = "There are no events this month.";
    @api design; // DEPRECATED

    @track _allCalendarListings;
    @track _listingList;
    @track frontEndDataMap = null;

    handleListingChange = (listingList) => {
        this._listingList = listingList;
        
        // only set _allCalendarListings when the initial portal_Listing load query occurs
        if (this._allCalendarListings === undefined) {
            this._allCalendarListings = listingList?.length > 0 ? [...listingList] : [];
        }
    }

    handleFrontEndDataMap = (frontEndDataMap) => {
        this.frontEndDataMap = frontEndDataMap;
    }
}