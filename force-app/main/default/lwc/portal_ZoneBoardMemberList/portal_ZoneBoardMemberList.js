import { api, LightningElement } from 'lwc';
import getBoardMembers from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_getZoneBoardMembers';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {formatRelativeUrlWithRootPath} from 'c/portal_util_Urls';

export default class Portal_ZoneBoardMemberList extends LightningElement {
    @api boardMemberOrder;
    @api defaultPictureURL = '../resource/Portal_ZoneMemberDefaultProfilePicture';
    @api hidePictures;
    @api hideDegreeString;

    boardMembers = [];
    permissionMap = {};
    initFinished = false;
    zoneName = '';

    get isDisplayZoneLeadership() {
        return this.permissionMap?.zoneLeadership?.display;
    }

    connectedCallback() {
        const url = new URL(window.location.href);
        this.zoneName = url.searchParams.get("zname");
        this.init(this.zoneName);
    }

    init(zoneName) {
        if (!zoneName) {
            this.initFinished = true;
            return;
        }

        getBoardMembers({params: {zoneName : zoneName, orderBy: this.boardMemberOrder, pageName: 'Zone Leadership', mainSectionName : 'Zone Leadership'}})
        .then(result => {
            this.permissionMap = result.permissionMap;
            
            let records = Object.assign([], result.records);
            records.forEach(record => {
                if (record.zoneMembershipPictureRecord) {
                    record.pictureURL =  formatRelativeUrlWithRootPath('/sfc/servlet.shepherd/version/download/' + record.zoneMembershipPictureRecord);
                } else {
                    record.pictureURL = formatRelativeUrlWithRootPath(this.defaultPictureURL);
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

                record.zoneBioDetailURL = 'zone-bio-detail?zmid=' + record.zoneMembershipId + '&zname=' + encodeURIComponent(this.zoneName);
            });

            this.boardMembers = records;
        })
        .catch(error => {
            console.log(error);
        }).finally(() => {
            this.initFinished = true;
        });
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