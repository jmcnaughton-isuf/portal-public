import { LightningElement, api, track } from 'lwc';

export default class Portal_ListingSearch extends LightningElement {
    @api pageName = "";
    @api mainSectionName = "";
    @api subSectionName = "";

    @api design = "";

    @track _isShowOnlineEvents;

    handleOnlineEventChange = (event) => {
        this._isShowOnlineEvents = event.target.checked;
        let params = {pageName: this.pageName,
                        mainSectionName: this.mainSectionName,
                        subSectionName: this.subSectionName,
                        additionalParams: {
                            isShowOnlineEvents: this._isShowOnlineEvents
                        }
                      };
        this.template.querySelector('c-portal_-listing').searchListings(params);
    }
}