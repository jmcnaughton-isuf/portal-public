import { LightningElement, api, track } from 'lwc';
import {getAbsoluteCommunitySiteUrl, formatRelativeUrlWithRootPath, formatRelativeUrlWithSitePath} from 'c/portal_util_Urls';

export default class Portal_Footer extends LightningElement {
    @api backgroundColor;
    @api buttonLink;
    @api buttonLabel;
    @api copyrightText = '© Copyright UC Innovation';
    @api navigationLinks = '[{\"label\": \"My Information\", \"link\": \"my-information\"}, {\"label\": \"Give\", \"link\": \"give\"}, {\"label\": \"Giving History\", \"link\": \"giving-history\"}, {\"label\": \"My Membership\", \"link\": \"memberships\"}, {\"label\": \"Job Board\", \"link\": \"job-board\"}]';
    @api logoUrl = '/resource/Portal_FooterLogo';
    @api socialMediaLinks = '[{\"platform\": \"Facebook\", \"link\": \"https://www.facebook.com/\"}, {\"platform\": \"LinkedIn\", \"link\": \"https://www.linkedIn.com/\"}, {\"platform\": \"Instagram\", \"link\": \"https://www.instagram.com/\"}, {\"platform\": \"Twitter\", \"link\": \"https://www.twitter.com/\"}]';

    @track _navigationLinks = [];
    @track _socialMediaLinks = [];

    get footerStyling() {
        return 'background-color: ' + this.backgroundColor;
    }

    get communityLogoUrl() {
        return formatRelativeUrlWithRootPath(this.logoUrl);
    }

    get homeUrl() {
        return getAbsoluteCommunitySiteUrl();
    }

    get socialMediaImageLinkMap() {
        let imageLinkMap = {facebook : formatRelativeUrlWithRootPath('/resource/Portal_FacebookIcon'),
                            linkedIn : formatRelativeUrlWithRootPath('/resource/PORTAL_LinkedInIcon'),
                            twitter : formatRelativeUrlWithRootPath('/resource/PORTAL_TwitterIcon'),
                            instagram : formatRelativeUrlWithRootPath('/resource/PORTAL_InstagramIcon'),}

        return imageLinkMap;
    }

    get facebookLink() {
        if (!this._socialMediaLinks) {
            return '';
        }

        for (const link of this._socialMediaLinks) {
            if (link.platform === 'Facebook') {
                return link.link;
            }
        }

        return '';
    }

    get linkedInLink() {
        if (!this._socialMediaLinks) {
            return '';
        }

        for (const link of this._socialMediaLinks) {
            if (link.platform === 'LinkedIn') {
                return link.link;
            }
        }

        return '';
    }

    get twitterLink() {
        if (!this._socialMediaLinks) {
            return '';
        }

        for (const link of this._socialMediaLinks) {
            if (link.platform === 'Twitter') {
                return link.link;
            }
        }

        return '';
    }

    get instagramLink() {
        if (!this._socialMediaLinks) {
            return '';
        }

        for (const link of this._socialMediaLinks) {
            if (link.platform === 'Instagram') {
                return link.link;
            }
        }

        return '';
    }

    connectedCallback() {
        this._socialMediaLinks = JSON.parse(this.socialMediaLinks);
        this._navigationLinks = JSON.parse(this.navigationLinks);

        for (let eachNavLink of this._navigationLinks) {
            if (eachNavLink.link.startsWith('/s/')) {
                continue;
            }

            eachNavLink.link = formatRelativeUrlWithSitePath(eachNavLink.link);
        }
    }
}