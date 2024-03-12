import { LightningElement, api, track } from 'lwc'
import isGuestUser from '@salesforce/user/isGuest';

import SERVER_getContentModuleMetadata  from '@salesforce/apex/PORTAL_LWC_StaticContentController.SERVER_getContentModuleMetadata';

export default class Portal_HtmlEditor extends LightningElement {
    @api pageName;
    @api moduleName;
    @api urlParamKey;
    @api displayTo;

    @track _contentModuleMetadata;

    get isLoggedInUser() {
        if (isGuestUser) {
            return false;
        }

        return true;
    }

    get isShowContent() {
        if (this.displayTo === 'All Users') {
            return true;
        } else if (this.displayTo === 'Authenticated Users') {
            return !isGuestUser;
        } else if (this.displayTo === 'Unauthenticated Users') {
            return isGuestUser;
        } else {
            return true;
        }
    }

    connectedCallback() {
        let subPageName;
        let pageUrl = new URL(window.location.href).pathname;

        if (this.urlParamKey) {
            const urlParams = new URLSearchParams(window.location.search);
            subPageName = urlParams.get(this.urlParamKey);
        }


        SERVER_getContentModuleMetadata({params: {pageName: this.pageName,
                                                  moduleName: this.moduleName,
                                                  subPageName: subPageName,
                                                  pageUrl: pageUrl}}).then(result => {
            this._contentModuleMetadata = result;
        }).catch(error => {
            console.log(error);
        })
    }
}