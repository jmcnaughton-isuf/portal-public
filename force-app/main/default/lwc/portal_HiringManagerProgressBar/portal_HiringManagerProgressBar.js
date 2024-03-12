import { api, LightningElement, track, wire } from 'lwc';

export default class Portal_HiringManagerProgressBar extends LightningElement {
    @api pageLabels = '["Information", "Company"]';
    @api pageValues = '["information", "company"]'

    @track _pageLabels = [];
    @track _pageValues = [];
    @track _currentPage;

    @api set currentPageIndex(value) {
        this._currentPage = this._pageValues[value-1];
    }

    get currentPageIndex() {
        return 0;
    }

    get steps() {
        let resultList = [];

        for (let pageIndex = 0; pageIndex < this._pageLabels.length; pageIndex++) {
            let step = {label: this._pageLabels[pageIndex], value: this._pageValues[pageIndex], key: Date.now()};

            resultList.push(step);
        }

        return resultList;
    }

    connectedCallback() {
        this._pageLabels = JSON.parse(this.pageLabels);
        this._pageValues = JSON.parse(this.pageValues);
        this._currentPage = this._pageValues[0];
    }
}