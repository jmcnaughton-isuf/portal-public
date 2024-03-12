import { LightningElement, track } from 'lwc';

export default class Portal_ZoneHomeLink extends LightningElement {
    @track zoneName = '';
    homePageURL = '';

    connectedCallback() {
        const url = new URL(window.location.href);
        this.zoneName = url.searchParams.get("zname");
        this.homePageURL = "zone-home-page?zname=" + encodeURIComponent(this.zoneName);
    }

    goBackToHomePage() {
        window.location.href = this.homePageURL;
    }
}