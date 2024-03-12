import { api, LightningElement } from 'lwc';
import getFeaturedZoneMemberships from '@salesforce/apex/PORTAL_LWC_ZoneController.SERVER_getZoneBoardMembers';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {formatRelativeUrlWithRootPath} from 'c/portal_util_Urls';

export default class Portal_FeaturedZoneMemberships extends LightningElement {
    sectionTitle = 'test title';
    @api boardMemberOrder;
    @api defaultPictureURL = "../resource/Portal_ZoneMemberDefaultProfilePicture";
    @api hidePictures;
    @api hideDegreeString;
    @api hideViewMoreButton;

    title = '';
    featuredZoneMemberList = [];
    permissionMap = {};
    zoneLeadershipLink = '';
    initFinished = false;

    connectedCallback() {
        const url = new URL(window.location.href);
        let zoneName = url.searchParams.get("zname");
        this.init(zoneName);
    }

    init(zoneName) {
        getFeaturedZoneMemberships({params: {zoneName : zoneName, orderBy: this.boardMemberOrder, pageName: 'Zone Home Page', mainSectionName : 'Featured Zone Members'}})
        .then(result => {
            if (result) {
                this.permissionMap = result.permissionMap;

                if (!result.records || result.records.length <= 0) {
                    result.records = [];
                }

                result.records.forEach(record => {
                    if (record.zoneMembershipPictureRecord) {
                        record.pictureURL =  formatRelativeUrlWithRootPath('/sfc/servlet.shepherd/version/download/') + record.zoneMembershipPictureRecord;
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

                    record.zoneBioDetailURL = 'zone-bio-detail?zmid=' + record.zoneMembershipId + '&zname=' + encodeURIComponent(result.zoneName);
                })

                this.featuredZoneMemberList = result.records;

                this.zoneLeadershipLink = 'zone-leadership?zname=' + encodeURIComponent(result.zoneName);

                this.initFinished = true;
            }
        })
        .catch(error => {
            console.log(error);
        });
    }

    get showFeaturedMembership() {
        return this.featuredZoneMemberList.length > 0 && this.permissionMap.featuredZoneMembers.display;
    }

    get showViewMoreButton() {
        return !this.hideViewMoreButton && this.zoneLeadershipLink;
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