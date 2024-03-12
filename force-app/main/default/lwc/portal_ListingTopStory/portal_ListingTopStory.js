import { LightningElement, api, wire, track } from 'lwc';
import basePath from '@salesforce/community/basePath';
import searchListings from '@salesforce/apex/PORTAL_LWC_ListingSearchController.SERVER_searchListings';
import SERVER_getFrontEndDataMap from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap';
import textOverThumbnail from './portal_TextOverThumbnail.html';

export default class Portal_Listing extends LightningElement {
    @api pageName = "";
    @api mainSectionName = "";
    @api subSectionName = "";
    @api design = "";

    @api handleListingChange = () => {}
    @track _listingList = [];
    @track _shownListing;
    @track frontEndDataMap = {};

    @wire(SERVER_getFrontEndDataMap, {params: '$getListingParams'})
    setFrontEndDataMap({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        this.frontEndDataMap = data;
    }

    set listingList(value) {
        if (value) {
            this._listingList = this.parseListingData(value);
            this._shownListing = this._listingList[0];

            if (!this._shownListing || Object.keys(this._shownListing).length === 0) {
                return;
            }

            if (this._shownListing.thumbnailImage) {
                this._shownListing.thumbnailImageUrl = this.parseRichTextForImageUrl(this._shownListing.thumbnailImage);
            }
            if (this._shownListing.headerImage) {
                this._shownListing.headerImageUrl = this.parseRichTextForImageUrl(this._shownListing.headerImage);
            }
        }
    }

    get getListingParams() {
        return {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};
    }

    get showComponent() {
        if (this._shownListing && Object.keys(this.frontEndDataMap).length !== 0) {
            if (this.showThumbnailImage || this.showHeaderImage) {
                return true;
            }
        }

        return false;
    }

    get showThumbnailImage() {
        return this._shownListing.thumbnailImage && this.frontEndDataMap.thumbnailImage.display;
    }

    get showHeaderImage() {
        return this._shownListing.headerImage && this.frontEndDataMap.headerImage.display;
    }

    connectedCallback() {
        searchListings({params: {pageName: this.pageName,
                                mainSectionName: this.mainSectionName,
                                subSectionName: this.subSectionName}})
        .then(result => {
            this.listingList = result;
            this.handleListingChange(this._listingList);

            return this._listingList;
        }).catch(error => {
            console.log(error);
        })
    }

    render() {
        if (this.design === 'Text Over Thumbnail') {
            return textOverThumbnail;
        }

        return textOverThumbnail
    }

    parseListingData(data) {
        if (!data) {
            return data;
        }

        let resultList = [];

        data.forEach(listing => {
            let newListing = Object.assign({}, listing);

            if (newListing.listingDetailUrl) {
                newListing.listingUrl = newListing.listingDetailUrl;
            } else {
                newListing.listingUrl = basePath + '/listing-detail?listingName=' + encodeURIComponent(newListing.name) + '&recordId=' + newListing.Id;
            }

            resultList.push(newListing);
        })

        return resultList;
    }

    parseRichTextForImageUrl(richText) {
        if (richText?.includes("<img")) {
            // to get src from img tag inside of lightning-formatted-rich-text
            let urlStartIndex = richText.indexOf("\"") + 1;
            let urlEndIndex = richText.indexOf("\"", urlStartIndex);
            return richText.substring(urlStartIndex, urlEndIndex).replaceAll('amp;', '');
        }
    }
}