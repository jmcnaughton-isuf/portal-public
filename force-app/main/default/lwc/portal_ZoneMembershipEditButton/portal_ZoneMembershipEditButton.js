import { LightningElement, api } from 'lwc';
import { getAbsoluteCommunitySiteUrl } from 'c/portal_util_Urls';

export default class Portal_ZoneMembershipEditButton extends LightningElement {
    @api redirectButtonURL = '';
    @api redirectButtonText = 'Edit Clubs and Groups Memberships';

    get redirectURL() {
        if (this.redirectButtonURL) {
            return this.redirectButtonURL;
        }

        return getAbsoluteCommunitySiteUrl() + '/edit-zone-memberships';
    }
}