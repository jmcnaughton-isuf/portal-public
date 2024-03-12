import { api, LightningElement } from 'lwc';
import getContentModule from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_getContentToDisplay';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Portal_ZoneRelatedLinks extends LightningElement {
    @api contentPage;
    @api contentModule;
    @api jsonRelatedLinksKey;
    @api jsonTitleKey;
    @api urlParamKey;

    title = '';
    relatedLinksList = [];

    connectedCallback() {
        let zoneName = null;

        const url = new URL(window.location.href);
        zoneName = url.searchParams.get(this.urlParamKey);
        let params = {contentPage : this.contentPage, contentModule : this.contentModule, subPageName : zoneName};

        callApexFunction(this, getContentModule, params, (result) => {
            if (result) {
                if (result[this.jsonTitleKey]) {
                    this.title = result[this.jsonTitleKey];
                }

                if (result[this.jsonRelatedLinksKey]) {
                    this.relatedLinksList = result[this.jsonRelatedLinksKey];
                }
            }
        }, () => {
        });

        // getContentModule({'paramMap' : {'contentPage' : this.contentPage, 'contentModule' : this.contentModule, 'subPageName' : zoneName}})
        // .then( result => {
        //     if (result) {
        //         if (result[this.jsonTitleKey]) {
        //             this.title = result[this.jsonTitleKey];
        //         }

        //         if (result[this.jsonRelatedLinksKey]) {
        //             this.relatedLinksList = result[this.jsonRelatedLinksKey];
        //         }
        //     }
        // })
        // .catch( error => {
        //     this.showNotification('Error', error.body.message, 'error');
        // });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evt);
    }
}