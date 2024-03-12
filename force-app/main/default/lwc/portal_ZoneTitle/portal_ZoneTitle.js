import { LightningElement } from 'lwc';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import getZoneTitle from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_getZoneTitle';

export default class Portal_ZoneTitle extends LightningElement {
    zoneTitle = '';

    connectedCallback() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        const urlParmsObject = Object.fromEntries(urlParams);

        callApexFunction(this, getZoneTitle, urlParmsObject, (result) => {
            this.zoneTitle = result;
        }, () => {
        });
    }
}