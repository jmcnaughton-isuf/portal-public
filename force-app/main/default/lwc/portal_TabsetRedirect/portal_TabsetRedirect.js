import { LightningElement, api } from 'lwc';

export default class Portal_TabsetRedirect extends LightningElement {
    
    @api urlParam;
    @api tabsetId;
    @api tabKey;

    connectedCallback() {
        // listen for a given url param to redirect to desired tab
        const urlParams = new URLSearchParams(window.location.search);
        let isRedirectToTab = urlParams.get(this.urlParam);

        if (isRedirectToTab === 'true') {
            let pathToTab = `?tabset-${this.tabsetId}=${this.tabKey}`;
            window.history.replaceState(null, null, pathToTab);
        }
    }
}