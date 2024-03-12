import { LightningElement, api, wire, track } from 'lwc';
import basePath from '@salesforce/community/basePath';
import SERVER_getListingConfigurations from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getListingConfigurations';
import SERVER_getFrontEndDataMap from '@salesforce/apex/PORTAL_LWC_ListingController.SERVER_getFrontEndDataMap';
import SERVER_searchListings from '@salesforce/apex/PORTAL_LWC_ListingSearchController.SERVER_searchListings';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import newsCarousel from './portal_ListingNewsCarousel.html';

export default class Portal_Listing extends LightningElement {
    @api pageName = "";
    @api mainSectionName = "";
    @api subSectionName = "";
    @api design = "";
    @api titleText = "";
    @api showMoreURL ="";
    @api showMoreLabel = "";

    @api get listingList() {
        return this._listingList;
    }

    @track frontEndDataMap = {};

    set listingList(value) {
        if (value) {
            this._listingList = this.parseListingData(value);
            this._carouselOffset = 0;

            if (!this._listingList || this._listingList.length <= 0) {
                return;
            }

            for (let eachListing of this._listingList) {
                if (!eachListing || Object.keys(eachListing).length === 0) {
                    continue;
                }

                if (eachListing.thumbnailImage) {
                    eachListing.thumbnailImageUrl = this.parseRichTextForImageUrl(eachListing.thumbnailImage);
                }
                if (eachListing.headerImage) {
                    eachListing.headerImageUrl = this.parseRichTextForImageUrl(eachListing.headerImage);
                }
            }
        }
    }

    breakpoints = {
        large: {
            size: 1024,
            columns: 4
        },
        medium: {
            size: 960,
            columns: 3
        },
        small: {
            size: 667,
            columns: 1
        }
    };

    @track _listingList = [];
    @track _carouselOffset = 0;
    @track _itemsPerRow = 4;
    @track _pageList = [];
    @track _noResultsText = '';
    @track _sizing = 3;
    @track _showSpinner = true;
    _isCarouselPageChanged = false;

    get getListingParams() {
        return {pageName: this.pageName, mainSectionName: this.mainSectionName, subSectionName: this.subSectionName};
    }

    get isBeginningOfCarousel() {
        return (this._carouselOffset < this._itemsPerRow);
    }

    get isEndOfCarousel() {
        return (this._carouselOffset + this._itemsPerRow >= this.listingList.length);
    }

    get isShowMore() {
        return this.showMoreURL && this.showMoreLabel;
    }

    get listingListToDisplay() {
        let listingListToDisplay = [];

        if (!this._listingList) {
            return listingListToDisplay;
        }


        for (let listingIndex = 0; listingIndex < this._listingList.length; listingIndex++) {
            this._listingList[listingIndex].class = 'carousel-item';

            if (listingIndex == this._carouselOffset) {
                this._listingList[listingIndex].class = 'carousel-item active';
            }
        }

        return this._listingList;
    }

    get pageListToDisplay() {
        let pageListToDisplay = [];

        if (!this._listingList || this._listingList.length <= 0) {
            return pageListToDisplay;
        }

        let numberOfPages = Math.ceil(this._listingList.length/this._itemsPerRow);
        for (let eachPage = 0; eachPage < numberOfPages; eachPage++) {

            // If carousel offset is on current page
            if (eachPage == Math.floor(this._carouselOffset / this._itemsPerRow)) {
                pageListToDisplay.push({'isActivePage': true, 'id': eachPage});
            } else {
                pageListToDisplay.push({'isActivePage': false, 'id': eachPage});
            }
        }

        return pageListToDisplay;
    }

    get hasNoResults() {

        if (!this._listingList || this._listingList.length === 0) {
            return true;
        }

        return false;
    }

    get showComponent() {
        if (this._listingList && this._listingList.length > 0 && Object.keys(this.frontEndDataMap).length !== 0) {
            return true;
        }

        return false;
    }

    @wire(SERVER_getListingConfigurations, {params: '$getListingParams'})
    setListingConfigurations({error, data}) {
        if (error) {
            console.log(error);
        }

        if (!data) {
            return;
        }

        if (data.itemsPerRow) {
            this._itemsPerRow = parseInt(data.itemsPerRow, 10);
        }

        this._sizing = Math.floor(12 / this._itemsPerRow);

        this._noResultsText = data.noResultsText;

        this.searchListings();
    }

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

    searchListings(params) {
        SERVER_searchListings({params: {pageName: this.pageName,
                                     mainSectionName: this.mainSectionName,
                                     subSectionName: this.subSectionName,
                                     additionalParams: params}})
        .then(result => {
            this.listingList = result;
        }).catch(error => {
            let errorMap = JSON.parse(error.body.message);
            console.log(errorMap.error);
            const event = new ShowToastEvent({
                title: 'Error!',
                message: errorMap.message,
                variant:"error",
                mode:"sticky"
            });
            this.dispatchEvent(event);

        }).finally(() => {
            this._showSpinner = false;
        })
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

            //strip html tags to get plaintext on header content
            newListing.headerContent = newListing.headerContent.replace(/<[^>]*>?/gm, '');

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

    isCarouselEnd() {
        // if (this.showMoreURL) {
        //     //for a carousel with a show more link we go 1 past the total number of records so that we can show the button
        //     return (this._carouselOffset + this._itemsPerRow > this.listingList.length);
        // } else {
        //     return (this._carouselOffset + this._itemsPerRow >= this.listingList.length);
        // }
        return (this._carouselOffset + this._itemsPerRow >= this.listingList.length);
    }

    handleResize = () => {
        // Adjust listing card size & listings per page to be according to viewport width
        this.setCarouselItemWidth();

        // If page is changed then a resize occurs, prevent listings in view from shifting
        this.handleCarouselMovementTransition(0);
    }

    connectedCallback() {
        window.addEventListener('resize', this.handleResize);
    }

    render() {
        if (this.design === 'News Carousel') {
            return newsCarousel;
        }

        return newsCarousel;
    }

    renderedCallback() {
        // Ensure correct listing card width on page load
        this.setCarouselItemWidth();

        // Shift carousel when user changes the page
        if (this._isCarouselPageChanged) {
            this.handleCarouselMovementTransition(0.3);
            this._isCarouselPageChanged = false;
        }
    }

    setCarouselItemWidth() {
        let viewport = this.template.querySelector("div.viewport");
        if (!viewport) {
            return;
        }

        let viewportWidth = viewport.getBoundingClientRect().width;
        let columnsPerPage = this.getColumnsPerPage(viewportWidth);
        let listingCardWidth = viewportWidth / columnsPerPage;

        if (this._itemsPerRow != columnsPerPage) {
            this._itemsPerRow = columnsPerPage;
            this._carouselOffset = this.getNewCarouselOffset();
        }

        let carouselItemList = this.template.querySelectorAll("a:not(.view-all-news)");
        for (let eachCarouselItem of carouselItemList) {
            eachCarouselItem.style.setProperty('width', listingCardWidth + 'px');
        }
    }

    getColumnsPerPage(viewportWidth) {
        if (viewportWidth > this.breakpoints.medium.size) return this.breakpoints.large.columns;
        if (viewportWidth <= this.breakpoints.medium.size && viewportWidth > this.breakpoints.small.size) return this.breakpoints.medium.columns;
        if (viewportWidth <= this.breakpoints.small.size) return this.breakpoints.small.columns;
    }

    getNewCarouselOffset() {
        let numOfListingsAwayFromPageStart = this._carouselOffset % this._itemsPerRow;
        let newCarouselOffset = this._carouselOffset - numOfListingsAwayFromPageStart;

        return newCarouselOffset;
    }

    handleCarouselMovementTransition(transitionTime) {
        let multiColumnCarousel = this.template.querySelector('.multi-column-carousel');

        if (!multiColumnCarousel) {
            return;
        }

        let pageContainer = multiColumnCarousel.querySelector('.page-container');

        let leftTransition = -( multiColumnCarousel.querySelector('.carousel-item.active').getBoundingClientRect().left -
                                multiColumnCarousel.querySelector('.carousel-item').getBoundingClientRect().left  ) + 'px';

        if (!transitionTime || transitionTime < 0) {
            transitionTime = 0;
        }

        pageContainer.style.setProperty('left', leftTransition);
        pageContainer.style.setProperty('transition', transitionTime + 's');
    }

    handlePreviousClick() {
        if (this._carouselOffset > 0) {
            this._carouselOffset = this._carouselOffset - this._itemsPerRow;
            this._isCarouselPageChanged = true;
        }
    }

    handleNextClick() {
        if (!this.isCarouselEnd()) {
            this._carouselOffset = this._carouselOffset + this._itemsPerRow;
            this._isCarouselPageChanged = true;
        }
    }

    handlePageChange = (event) => {
        // event.target.dataset.index represents page number we're switching to
        this._carouselOffset = this._itemsPerRow * event.target.dataset.index;
        this._isCarouselPageChanged = true;
    }
}