import { LightningElement, api, track } from 'lwc';

import SERVER_getZoneBanner  from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_getZoneBanner';

export default class Portal_ZoneBanner extends LightningElement {
    @api pageName;
    @api moduleName;
    @api urlParamKey;

    @track _contentModuleMetadata;

    _zoneName = '';

    get isLoggedInUser() {
        if (isGuestUser) {
            return false;
        }

        return true;
    }

    connectedCallback() {
        let subPageName;

        if (this.urlParamKey) {
            const urlParams = new URLSearchParams(window.location.search);
            subPageName = urlParams.get(this.urlParamKey);
            this._zoneName = subPageName;
        }

        SERVER_getZoneBanner({params: {pageName: this.pageName,
                                       moduleName: this.moduleName,
                                       subPageName: subPageName}}).then(result => {
            let mergeFieldReplacedResult = {htmlText: result.htmlText.replaceAll("{_zoneName}", this._zoneName ? this._zoneName : "")};
            this._contentModuleMetadata = mergeFieldReplacedResult;
        }).catch(error => {
            console.log(error);
        })
    }

}