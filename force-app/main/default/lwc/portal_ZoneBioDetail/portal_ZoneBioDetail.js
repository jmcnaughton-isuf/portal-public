import { api, LightningElement, track } from 'lwc';
import getZoneBioDetail from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_getZoneBioDetailInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { callApexFunction } from 'c/portal_util_ApexCallout';
import {formatRelativeUrlWithRootPath} from 'c/portal_util_Urls';

export default class Portal_ZoneBioDetail extends LightningElement {

    permissionMap = {};
    initFinished = false;
    _homePageURL = '';
    _zoneName = '';
    @api defaultPictureURL = '../resource/Portal_ZoneMemberDefaultProfilePicture';
    @api hideDegreeString;

    @track bioDetail = {};

    connectedCallback() {
        // get url params
        const url = new URL(window.location.href);
        let zoneMemId = url.searchParams.get("zmid");
        this.init(zoneMemId);
    }

    init(zoneMemId) {
        let params = {zoneMembershipId : zoneMemId};
        callApexFunction(this, getZoneBioDetail, params, (result) => {
            if (result) {
                this.permissionMap = result.permissionMap;

                let record = Object.assign({}, result.records);

                if (record.zoneMembershipPictureRecord) {
                    record.pictureURL =  formatRelativeUrlWithRootPath('/sfc/servlet.shepherd/version/download/' + record.zoneMembershipPictureRecord);
                } else {
                    record.pictureURL = this.defaultPictureURL;
                }
                        
                // processing name to actually display
                record.fullName = '';
                if (this.permissionMap.firstName.display && record.firstName) {
                    record.fullName += record.firstName;
                }
                if (this.permissionMap.lastName.display && record.lastName) {
                    record.fullName += record.fullName ? ' ' : '';
                    record.fullName += record.lastName;
                }

                this._zoneName = record.zoneName;
                this._homePageURL = "zone-home-page?zname=" + encodeURIComponent(this._zoneName);
                this.bioDetail = record;
                this.initFinished = true;
            }
        }, () => {
        });
    }
    
    goBackToHomePage() {
        window.location.href = this._homePageURL;
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